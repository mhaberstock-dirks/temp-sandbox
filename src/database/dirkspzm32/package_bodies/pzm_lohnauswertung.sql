create or replace 
package body DIRKSPZM32.PZM_LOHNAUSWERTUNG is

  type t_kst_std_rec is record
       (
         kst_id                    pzm_ze_tagessatz.ts_day_kst_id%type,
         kst_std                   number,
         kst_proz                  number
       );

  type t_kst_std_tab is table of t_kst_std_rec
      index by binary_integer;
  v_lz_korr_WE_F boolean;

function check_gueltig_liste (
    in_schluessel in varchar2,
    in_regeln     in pzm_gueltig_regel_ct
) return number is
/*
 * Generische Allow-/Blocklist-Prüfung.
 * Gibt 1 (gültig) oder 0 (ungültig) zurück:
 *
 *   Keine Einträge                             ¿ 1  (gilt für alle)
 *   Eintrag: schluessel = X, gueltig = 1       ¿ 1  (Allowlist-Treffer)
 *   Eintrag: schluessel = X, gueltig = 0       ¿ 0  (Blocklist-Treffer)
 *   Keine Übereinstimmung, gueltig=1 existiert ¿ 0  (Allowlist-Modus, nicht enthalten)
 *   Keine Übereinstimmung, nur gueltig=0       ¿ 1  (Blocklist-Modus, nicht gesperrt)
 */
    v_result number;
begin
    if in_regeln is null or in_regeln.count = 0 then
        return 1;
    end if;

    select
        case
            when exists (select 1 from table(in_regeln) r where r.schluessel = in_schluessel and r.gueltig = 1) then 1
            when exists (select 1 from table(in_regeln) r where r.schluessel = in_schluessel and r.gueltig = 0) then 0
            when exists (select 1 from table(in_regeln) r where r.gueltig = 1)                                  then 0
            else 1
        end
    into v_result
    from dual;

    return v_result;
end check_gueltig_liste;

  --------------------------------------------------------------------------
  -- Die Funktion prüt, ob die LOA für diesen Mitarbeiter gültigt ist (Tarif, Sichtart und Kostenstelle)
  -------------------------------------------------------------------------- 
  function GET_PERS_LOA_IS_GUELTIG (in_pers_nr     in pzm_personal.pers_nr%type,
                                                      in_lz_id       in pzm_lohnarten.lz_id%type,
                                                      in_sa_kurzname in pzm_schichtarten.sa_kurzname%type
                                                     ) return number is

/*
 * Prüft ob eine Lohnart (lz_id) für Person, Schichtart und Kostenstelle gültig ist.
 * Gibt 1 (gültig) oder 0 (ungültig) zurück — verwendbar direkt in SQL-WHERE-Klauseln.
 *
 * Entspricht get_pers_loa_is_gueltig, jedoch mit NUMBER statt BOOLEAN als Rückgabetyp.
 * Die Allow-/Blocklist-Logik ist in check_gueltig_liste zentralisiert.
 */

    v_tarif_name  pzm_tarifmodelle.tarif_name%type;
    v_kst_id      pzm_personal.pers_kst_id%type;
    v_regeln      pzm_gueltig_regel_ct;

begin
    select tarif_name into v_tarif_name
    from pzm_personal
    where pers_nr = in_pers_nr;

    v_kst_id := get_pers_kst_id(in_pers_nr);

    -- 1. Tarifmodell
    select pzm_gueltig_regel_t(tarif_name, lz_gueltig)
    bulk collect into v_regeln
    from pzm_lz_tarifmodelle
    where lz_id = in_lz_id;

    if check_gueltig_liste(v_tarif_name, v_regeln) = 0 then
        return 0;
    end if;

    if in_sa_kurzname is not null then

        -- 2. Schichtart
        select pzm_gueltig_regel_t(lzsa_sa_kurzname, lzsa_gueltig)
        bulk collect into v_regeln
        from pzm_lz_sa
        where lzsa_lz_id = in_lz_id;

        if check_gueltig_liste(in_sa_kurzname, v_regeln) = 0 then
            return 0;
        end if;

        -- 3. Kostenstelle
        select pzm_gueltig_regel_t(to_char(lzkst_abt_kst), lzkst_gueltig)
        bulk collect into v_regeln
        from pzm_lz_kst
        where lzkst_lz_id = in_lz_id;

        if check_gueltig_liste(to_char(v_kst_id), v_regeln) = 0 then
            return 0;
        end if;

    end if;

    return 1;
  end GET_PERS_LOA_IS_GUELTIG;

  function get_alternativ_loa(
    in_loa_id in pzm_lohnarten.lz_id%type
  ) return pzm_lohnarten.lz_lohnart%type is
    v_result pzm_lohnarten.lz_lohnart%type;

    cursor c_alternativ_loa is
      select l.lz_lohnart
        from pzm_lohnarten l
       where l.lz_id = in_loa_id
         and l.lz_operator is NULL;
  begin
    if in_loa_id is null then
      return null;
    end if;

    -- use cursor to avoid 'NOT FOUND' exception
    -- (because exceptions in oracle are expensive!)
    open c_alternativ_loa;
    fetch c_alternativ_loa into v_result;
    close c_alternativ_loa;

    return v_result;
  exception
    when others then
      return null;
  end;

  /**************************************************************************************************
  * ueb_std_auszahlung_pruefen
  * Anhand der in den Personalstammdaten eingetragenen Einstellungen
  * Überstundenauszahlung prüfen und durchführen
  **************************************************************************************************/
  function ueb_std_auszahlung_pruefen_r32(in_pers_nr      in number,
                                          in_monatsende   in date,
                                          in_loa          in pzm_lohnarten.lz_lohnart%type
                                          ) return boolean is
                                     
    v_loa_stunden                    number;
    cursor c_lohnauswertungen is
      select sum(t.zeaw_lz_loa_std)
        from pzm_ze_loa_ausw t
       where zeaw_pers_nr = in_pers_nr
         and zeaw_datum = in_monatsende
         and zeaw_lz_lohnart = in_loa;
  begin
    OPEN c_lohnauswertungen;
    FETCH c_lohnauswertungen into v_loa_stunden;
    CLOSE c_lohnauswertungen;
    
    if nvl(v_loa_stunden, 0) > 0
    then 
      return false;
    else
      return true;
    end if;
  end;

  /**************************************************************************************************
  *
  * UEB_STD_AUSZAHLEN
  * ab R5
  *  
  **************************************************************************************************/
  procedure c_ueb_std_auszahlen(in_pers_nr in number,
                                in_monat   in integer,
                                in_jahr    in integer,
                                in_stunden in number) is
  begin
    ueb_std_auszahlen(in_pers_nr,
                      in_monat,
                      in_jahr,
                      in_stunden);
    commit;
    
  end;
  
  procedure ueb_std_auszahlen(in_pers_nr in number,
                              in_monat   in integer,
                              in_jahr    in integer,
                              in_stunden in number) is

    v_error_code number;
    v_error_text varchar2(255);
    v_found      boolean;


    v_moantsende   date;

    v_lohnart    pzm_lohnarten%rowtype;
    v_personal   pzm_personal%rowtype;

    --v_konten_bh_id        pzm_konten_bh.konten_bh_id%type;
    v_konto               pzm_konten%rowtype;

    cursor c_lohnarten IS
      select x.*
        from pzm_lohnarten x
       where x.lz_operator = 'UESTD'
         and x.lz_typ = 'UEB_STD';
    cursor c_pzm_konten is
      select t.*
        from pzm_konten t,
             pzm_lohnarten lz
       where t.sid = '01'
         and t.firma_nr = 1
         and t.pers_nr = in_pers_nr
         and t.name_kurz = lz.lz_konto_name_kurz
         and lz.lz_id = v_lohnart.lz_id;
  begin
    v_error_code   := null;
    
    if not pzm_p_base.get_personal(in_pers_nr, v_personal)
    then
      v_error_code := 1;
      v_error_text := 'Fehler <' || in_pers_nr || '> ist nicht vorhanden.';
      raise_application_error(-20000 - v_error_code,
                              v_error_text,
                              true);
      
    end if;

        
    open c_lohnarten;
    fetch c_lohnarten into v_lohnart;
    v_found := c_lohnarten%found;
    close c_lohnarten;

    v_moantsende   := last_day(to_date('01.' || to_char(in_monat) || '.' ||
                                       to_char(in_jahr),
                                       'dd.mm.yyyy'));

    if v_found
    and ueb_std_auszahlung_pruefen_r32(in_pers_nr,
                                       v_moantsende,
                                       v_lohnart.lz_lohnart)
    then
      begin
        open c_pzm_konten;
        fetch c_pzm_konten into v_konto;
        v_found := c_pzm_konten%found;
        close c_pzm_konten;
        if v_found
        then
          set_loa_std(in_pers_nr,
                      v_moantsende,
                      v_lohnart.lz_lohnart,
                      in_stunden,
                      NULL,
                      false,
                      v_lohnart.lz_id,
                      get_pers_kst_id(in_pers_nr));
        end if;
      exception
        when others then
          v_error_code := 2;
          v_error_text := 'Fehler beim Auszahlen der Überstunden.';
          raise_application_error(-20000 - v_error_code,
                                  v_error_text,
                                  true);
      end;
    else
      v_error_text := 'Fehler beim Auszahlen der Überstunden.';
      if not v_found
      then
        v_error_code := 3;
        v_error_text := v_error_text || ' LOA für Überstunden fehlt.';
      else
        v_error_code := 4;
        v_error_text := v_error_text || ' Überstunden sind bereits in der Auszahlung. Bitte erst die Auszahlung stonieren.';
      end if;
    end if;

    if v_error_code is not null then
      raise_application_error(-20000 - v_error_code, v_error_text, true);
    end if;
  end;
  
  
  /**************************************************************************************************
  *
  * UEB_STD_AUSZAHLEN_STORNO
  * ab R5
  * 
  **************************************************************************************************/
  procedure c_ueb_std_auszahlen_storno(in_pers_nr in number,
                                       in_monat   in integer,
                                       in_jahr    in integer) is
  begin
    ueb_std_auszahlen_storno(in_pers_nr,
                             in_monat,
                             in_jahr);
    commit;
    
  end;
  
  procedure ueb_std_auszahlen_storno(in_pers_nr in number,
                                     in_monat   in integer,
                                     in_jahr    in integer) is

    v_error_code number;
    v_error_text varchar2(255);
    v_found      boolean;


    v_moantsende   date;

    v_lohnart    pzm_lohnarten%rowtype;
    v_personal   pzm_personal%rowtype;

    --v_konten_bh_id        pzm_konten_bh.konten_bh_id%type;
    v_konto               pzm_konten%rowtype;

    cursor c_lohnarten IS
      select x.*
        from pzm_lohnarten x
       where x.lz_operator = 'UESTD'
         and x.lz_typ = 'UEB_STD';
    cursor c_pzm_konten is
      select t.*
        from pzm_konten t,
             pzm_lohnarten lz
       where t.sid = '01'
         and t.firma_nr = 1
         and t.pers_nr = in_pers_nr
         and t.name_kurz = lz.lz_konto_name_kurz
         and lz.lz_id = v_lohnart.lz_id;
  begin
    v_error_code   := null;
    
    if not pzm_p_base.get_personal(in_pers_nr, v_personal)
    then
      v_error_code := 1;
      v_error_text := 'Fehler <' || in_pers_nr || '> ist nicht vorhanden.';
      raise_application_error(-20000 - v_error_code,
                              v_error_text,
                              true);
      
    end if;

        
    open c_lohnarten;
    fetch c_lohnarten into v_lohnart;
    v_found := c_lohnarten%found;
    close c_lohnarten;

    v_moantsende   := last_day(to_date('01.' || to_char(in_monat) || '.' ||
                                       to_char(in_jahr),
                                       'dd.mm.yyyy'));

    if v_found
    then
      if not ueb_std_auszahlung_pruefen_r32(in_pers_nr,
                                        v_moantsende,
                                        v_lohnart.lz_lohnart)
      then
        begin
          open c_pzm_konten;
          fetch c_pzm_konten into v_konto;
          v_found := c_pzm_konten%found;
          close c_pzm_konten;
          if v_found
          then
            set_loa_std(in_pers_nr,
                        v_moantsende,
                        v_lohnart.lz_lohnart,
                        0,
                        null,
                        true,
                        v_lohnart.lz_id,
                        get_pers_kst_id(in_pers_nr));
          end if;
        exception
          when others then
            v_error_code := 2;
            v_error_text := 'Fehler beim Stornieren der Überstunden.';
            raise_application_error(-20000 - v_error_code,
                                    v_error_text,
                                    true);
        end;
      else
        v_error_code := 3;
        v_error_text := v_error_text || 'Fehler beim Stornieren der Überstunden. Es sind keine Überstunden in der Auszahlung.';
      end if;
    else
      v_error_code := 4;
      v_error_text := 'Fehler beim Stornieren der Überstunden. LOA für Überstunden fehlt.';
    end if;

    if v_error_code is not null then
      raise_application_error(-20000 - v_error_code, v_error_text, true);
    end if;
  end;

  procedure set_lz_id_loa_std(in_pers_nr      in number,
                              in_datum        in date,
                              in_lz_id        in pzm_lohnarten.lz_id%type,
                              in_loa_std      in number,
                              in_aa_id        in number,
                              in_std_ersetzen in boolean,
                              in_kst_id       in pzm_ze_loa_ausw.zeaw_kst_id%type) is
    v_lohnarten pzm_lohnarten%rowtype;

    cursor c_lohnarten is
      select t.* from pzm_lohnarten t where t.lz_id = in_lz_id;

    v_found boolean;
  begin
    open c_lohnarten;
    fetch c_lohnarten
      into v_lohnarten;
    v_found := c_lohnarten%found;
    close c_lohnarten;

    if v_found then
      set_loa_std(in_pers_nr,
                  in_datum,
                  v_lohnarten.lz_lohnart,
                  in_loa_std,
                  in_aa_id,
                  in_std_ersetzen,
                  v_lohnarten.lz_id,
                  in_kst_id);
    end if;
  end;

  procedure set_loa_std_grp(in_pers_nr      in pzm_ze_loa_ausw.zeaw_pers_nr%type,
                            in_datum        in pzm_ze_loa_ausw.zeaw_datum%type,
                            in_lohnart      in pzm_ze_loa_ausw.zeaw_lz_lohnart%type,
                            in_loa_std      in pzm_ze_loa_ausw.zeaw_lz_loa_std%type,
                            in_aa_id        in pzm_ze_loa_ausw.aa_id%type,
                            in_loa_grp      in pzm_ze_loa_ausw.zeaw_lz_loa_grp%type,
                            in_loa_id       in pzm_ze_loa_ausw.zeaw_lz_id%type,
                            in_std_ersetzen in boolean,
                            in_kst_id       in pzm_ze_loa_ausw.zeaw_kst_id%type) is
  begin
    set_loa_std(in_pers_nr,
                in_datum,
                in_lohnart,
                in_loa_std,
                in_aa_id,
                in_std_ersetzen,
                in_loa_id,
                in_kst_id);
    -- LOA Gruppe nachziehen
    update pzm_ze_loa_ausw t
       set t.zeaw_lz_loa_grp = in_loa_grp
     where zeaw_pers_nr = in_pers_nr
       and zeaw_datum = in_datum
       and zeaw_lz_lohnart = in_lohnart;
  end;

  procedure set_loa_std(in_pers_nr      in number,
                        in_datum        in date,
                        in_lohnart      in pzm_ze_loa_ausw.zeaw_lz_lohnart%type,
                        in_loa_std      in number,
                        in_aa_id        in number,
                        in_std_ersetzen in boolean,
                        in_loa_id       in pzm_ze_loa_ausw.zeaw_lz_id%type,
                        in_kst_id       in pzm_ze_loa_ausw.zeaw_kst_id%type,
                        in_passiv_loa   in pzm_ze_loa_ausw.passiv_loa%type default 'F') is

    v_loa_std number;
    v_lohnart pzm_lohnarten%rowtype;

    cursor c_ZELoaAusw is
      select zeaw_lz_loa_std
        from pzm_ze_loa_ausw
       where zeaw_pers_nr = in_pers_nr
         and zeaw_datum = in_datum
         and zeaw_lz_lohnart = in_lohnart
         and zeaw_lz_id = v_lohnart.lz_id;

  begin
    if not pzm_p_base.get_lohnart(in_loa_id, v_lohnart) 
    then
      if not pzm_p_base.get_lohnart_by_loa(in_lohnart, in_aa_id, v_lohnart)
      then 
        return; -- here we should raise an exception. no time to implement that now.
      end if;
    end if;

    if (in_loa_std = 0 and in_std_ersetzen) or in_loa_std is NULL then
      if in_aa_id is not null then
        update pzm_ze_loa_ausw
           set aa_id = null
         where zeaw_pers_nr = in_pers_nr
           and zeaw_datum = in_datum
           and zeaw_lz_lohnart = in_lohnart
           and zeaw_lz_id = v_lohnart.lz_id
           and zeaw_korr_datum is null;
      end if;

      delete pzm_ze_loa_ausw
       where zeaw_pers_nr = in_pers_nr
         and zeaw_datum = in_datum
         and zeaw_lz_lohnart = in_lohnart
         and zeaw_lz_id = v_lohnart.lz_id
         and zeaw_korr_datum is null;
      return;
    end if;

    open c_ZELoaAusw;

    fetch c_ZELoaAusw
      into v_loa_std;

    if c_ZELoaAusw%found then
      if in_std_ersetzen then
        v_loa_std := in_loa_std;
      else
        v_loa_std := v_loa_std + in_loa_std;
      end if;
      v_loa_std := round(v_loa_std, 3);

      if v_loa_std > 0 then
        update pzm_ze_loa_ausw
           set zeaw_lz_loa_std = v_loa_std
         where zeaw_pers_nr = in_pers_nr
           and zeaw_datum = in_datum
           and zeaw_lz_lohnart = in_lohnart
           and zeaw_lz_id = v_lohnart.lz_id
           and zeaw_korr_datum is null;
      else
        -- v_loa_std <= 0
        if in_aa_id is not null then
          update pzm_ze_loa_ausw
             set aa_id = null
           where zeaw_pers_nr = in_pers_nr
             and zeaw_datum = in_datum
             and zeaw_lz_lohnart = in_lohnart
             and zeaw_lz_id = v_lohnart.lz_id
             and zeaw_korr_datum is null;
        end if;

        delete pzm_ze_loa_ausw
         where zeaw_pers_nr = in_pers_nr
           and zeaw_datum = in_datum
           and zeaw_lz_lohnart = in_lohnart
           and zeaw_lz_id = v_lohnart.lz_id
           and zeaw_korr_datum is null;
      end if;
    else
      if in_loa_std > 0 then
        insert into pzm_ze_loa_ausw
          (zeaw_pers_nr,
           zeaw_datum,
           zeaw_lz_lohnart,
           zeaw_lz_loa_std,
           aa_id,
           passiv_loa,
           zeaw_lz_id,
           zeaw_pb_id,
           zeaw_kst_id)
        values
          (in_pers_nr,
           in_datum,
           in_lohnart,
           round(in_loa_std, 3),
           in_aa_id,
           in_passiv_loa,
           v_lohnart.lz_id,
           get_pers_pb_id(in_pers_nr),
           nvl(in_kst_id, get_pers_kst_id(in_pers_nr)));
      end if;
    end if;

    close c_ZELoaAusw;
  end;

  function berechne_loa_std(p_arb_von     in date,
                            p_arb_bis     in date,
                            p_lz_von      in date,
                            p_lz_bis      in date,
                            p_lz_op       in varchar2,
                            p_lz_ueb_std  in number,
                            p_arb_std     in number,
                            p_ueb_std     in number,
                            p_lz_wo_tag   in varchar2,
                            p_lz_feiertag in varchar2,
                            p_sa_kurzname in varchar2,
                            p_schicht_tag in date,
                            p_pers_nr     in number,
                            p_loa_std     in number default NULL) return number is
    v_LoaVon date;
    --v_LoaBis date;
    v_LoaStd       number;
    v_diff_std_ns  number;
    v_LoaUebStd    number;
    v_UebStdBeginn date;
    v_LoaStdDiff   number;
    v_ueb_std      number;
    --s5 varchar2(255);
    v_SonderFeiertag varchar2(10);
    v_Wochentag      number;
    v_Ueberspringen  boolean;
    v_ist_feiertag   boolean;

    v_pause_std number;

    v_max_loa_std number;

  begin
    v_LoaStd        := 0;
    v_Ueberspringen := false;

    v_max_loa_std := ((p_lz_bis - p_lz_von) * 24);

    -- Wochentag prüfen
    if p_lz_wo_tag is not null then
      -- diese lohnart gilt nur bei bestimmten Wochentagen
      v_Wochentag := isi_utils.Iso_WeekDay(p_arb_von);
      if  to_number(p_lz_wo_tag) <> v_Wochentag
      and to_number(p_lz_wo_tag) <> v_Wochentag + 1
      then
        v_Ueberspringen := true;
      end if;
    end if;
    
    v_ist_feiertag := ist_feiertag(p_pers_nr, 
                                   get_pers_pb_id(p_pers_nr), 
                                   get_pers_abt_id(p_pers_nr), 
                                   get_pers_kst_id(p_pers_nr), 
                                   p_lz_von, 
                                   v_SonderFeiertag) = 1;
    
    -- Feiertag prüfen
    if v_ist_feiertag
    then
      if p_lz_op != 'KUGF'
      and p_lz_op not in ('<=', '<', '>=', '>', '!N')
      then
        v_Ueberspringen := true;
      end if;
    else
      if p_lz_op = 'KUGF'
      then
        v_Ueberspringen := true;
      end if;
    end if;


    if p_lz_feiertag is not null 
    then
      if v_ist_feiertag 
      then
      -- diese lohnart gilt nur bei Feiertagen
        -- wenn das o.g. Datum ein Feiertag ist
        if (upper(nvl(v_SonderFeiertag, 'xx')) <> 'SF') and
           upper(p_lz_feiertag) = 'SF' then
          -- Wir haben einen normalen Feiertag!! Diese LOA ist aber ein Sonder-Feiertag
          v_Ueberspringen := true;
        end if;
        if (upper(v_SonderFeiertag) = 'SF') and
           upper(p_lz_feiertag) <> 'SF' then
          -- Wir haben einen Sonder-Feiertag!! Diese LOA ist aber ein normaler Feiertag
          v_Ueberspringen := true;
        end if;
      else
        -- Das o.g. Datum ist KEIN Feiertag, aber diese LOA ist nur für Feiertage bestimmt
        if upper(p_lz_feiertag) = 'F' or upper(p_lz_feiertag) = 'SF' then
          v_Ueberspringen := true;
        end if;
      end if;
    end if;

    if not v_Ueberspringen 
    then
      
      if p_lz_op in ('<=', '<', '>=', '>', '!N')
      or p_lz_op is NULL 
      or p_lz_ueb_std is null 
      then
        --      v_LoaStd := (p_arb_bis - p_arb_von) * 24;
        --v_LoaVon := p_arb_von;
        --v_LoaBis := p_arb_bis;
        --v_LoaStd  := ((p_lz_von - p_arb_von) * 24);
        --v_LoaStd  :=  ((p_lz_bis - p_lz_von) / 4) * 24;
        v_LoaStd  := p_arb_std;
        v_ueb_std := p_ueb_std;

        -- Differenz ist genau ein Tag (Ganztageseintrag)
        -- Muss immer so rechnen
        --if p_lz_von + 1 != p_lz_bis then
          if p_lz_von > p_arb_von then
            -- da p_arb_von die pause impliziert, muss sie berücksichtigt werden, wenn sie ausserhalb der loa zeiten ist
            begin
              v_diff_std_ns := nvl(pzm_p_base.get_allg_parameter_mandant(get_pers_pb_id(p_pers_nr), 'STD_IN_NACHZULAGE_OHNE_PAUSE') / 24, (p_lz_bis - p_lz_von) / 4);
            exception
              when others then 
                v_diff_std_ns := nvl((p_lz_bis - p_lz_von) / 4, 0);
            end;
            if p_lz_von + 1 != p_lz_bis -- Kein ganztageseintrag
            and trunc(p_lz_von) < trunc(p_lz_bis) -- Nachtschicht
            and p_arb_von < p_lz_von -  
                           ((p_lz_bis - p_lz_von) / 4)
            and p_arb_bis < p_lz_von + (1/1440) + v_diff_std_ns
            then
              v_LoaVon := p_arb_bis;          
            else
              v_LoaVon := p_lz_von;          -- Die Pause der ganzen Schincht rechenen
            end if;
              
            v_pause_std := get_pers_pause_std(p_pers_nr,
                                              p_schicht_tag,
                                              p_sa_kurzname,
                                              p_arb_von,
                                              v_LoaVon); --,
            --round((p_arb_bis - p_arb_von) * 24, 3), 0);
            v_LoaStd := (v_LoaStd + v_pause_std) -
                        ((p_lz_von - p_arb_von) * 24);
            if v_LoaStd > (p_arb_bis - p_lz_von) * 24 -- ggf. wegen der Pause zu viel
            then
              v_LoaStd := round((p_arb_bis - p_lz_von) * 24, 2);-- jetzt reine Zeit
            end if;
          end if;

          v_LoaStdDiff := round(((p_arb_bis - p_lz_bis) * 24), 6);
          if p_lz_bis < p_arb_bis
          then
            --v_LoaBis := p_lz_bis;
            -- da p_arb_bis die pause impliziert, muss sie berücksichtigt werden, wenn sie ausserhalb der loa zeiten ist
            v_pause_std := get_pers_pause_std(p_pers_nr,
                                              p_schicht_tag,
                                              p_sa_kurzname,
                                              p_arb_von,
                                              p_arb_bis) -
                           get_pers_pause_std(p_pers_nr,
                                              p_schicht_tag,
                                              p_sa_kurzname,
                                              p_lz_bis,
                                              p_arb_bis); --,
            --round((p_arb_bis - p_arb_von) * 24, 3), 0);
            if trunc(p_lz_von) < trunc(p_lz_bis)
            and p_lz_bis < p_arb_von +  
                           ((p_lz_bis - p_lz_von) / 2)
            then
              v_LoaStd := nvl(round((p_lz_bis - p_arb_von) * 24, 3), 0); -- Die Differenz von Arbeisbegin bis LOA-Ende
            else
              if  v_pause_std > 0
              and p_lz_von < p_arb_von
              then
                v_LoaStd := (v_LoaStd + v_pause_std) - v_LoaStdDiff; -- Wenn Pause dann so rechnen
              elsif v_LoaStdDiff > 0
              and v_pause_std = 0
              then
                if  p_lz_von < p_arb_von    -- Arbeitszeit rechnen
                and p_lz_bis > p_arb_bis 
                then
                  v_LoaStd  := ((p_arb_bis - p_arb_von) * 24);
                elsif p_lz_von < p_arb_von -- Von Begin Arbeitszeit bis LZ-Ende
                and   p_lz_bis < p_arb_bis 
                then
                  v_LoaStd  := ((p_lz_bis - p_arb_von) * 24);
                elsif p_lz_von > p_arb_von -- Von Begin lz bis Arbeitszeit-Ende
                and   p_lz_bis < p_arb_bis 
                then
                  v_LoaStd  := ((p_arb_bis - p_lz_von) * 24);
                elsif p_lz_von > p_arb_von -- Von Begin lz bis lz-Ende
                and   p_lz_bis > p_arb_bis 
                then
                  v_LoaStd  := ((p_lz_bis - p_lz_von) * 24);
                end if;
              elsif v_LoaStdDiff > 0
              and   v_pause_std > 0
              then
                v_LoaStd := (v_LoaStd + v_pause_std) - v_LoaStdDiff; -- Wenn Pause dann so rechnen
              else
                v_LoaStd  := ((p_lz_bis - p_lz_von) * 24) - v_pause_std;
              end if;
            end if;
            v_ueb_std := v_ueb_std - v_LoaStdDiff;
            if v_ueb_std < 0 then
              -- der negative teil ist in der arbeitszeit
              v_ueb_std := 0;
            end if;
          end if;
        --end if;
        
        if p_loa_std is NULL
        then
          if p_lz_op = '<=' then
            if v_LoaStd > p_lz_ueb_std then
              v_LoaStd := p_lz_ueb_std;
            end if;
          elsif p_lz_op = '<' then
            if v_LoaStd >= p_lz_ueb_std then
              v_LoaStd := p_lz_ueb_std - 15 / 60; -- 1/4 Stunde abziehen
            end if;
          elsif p_lz_op = '>' 
            and v_lz_korr_WE_F = false
          then
            if v_LoaStd >= p_lz_ueb_std then
              v_LoaStd := v_LoaStd - p_lz_ueb_std; -- nur das berechnen, was über die grenze hinaus geht
            else
              v_LoaStd := 0;
            end if;
          elsif p_lz_op = '>='
            and v_lz_korr_WE_F = false
          then
            if v_LoaStd < p_lz_ueb_std then -- Alles wenn Groesse dieser Angabe
              v_LoaStd := 0;
            end if;
          end if;
        else
          v_LoaStd := v_LoaStd + v_pause_std;
        end if;

        if p_lz_op = '!N' then
          -- !N = diese LOA darf nicht mit Überstunden verrechnet werden, also Überstunden abziehen, wenn vorhanden
          if p_ueb_std is not null then
            v_LoaStd := v_LoaStd - v_ueb_std;
          end if;
        end if;
      elsif p_lz_op in ('KUGF', 'KUG')
      then
        v_LoaStd := p_arb_std;
        -- Überstunden berücksichtigen
      elsif (p_lz_op is not null) and (p_lz_ueb_std > 0) 
             and (p_ueb_std > 0) 
            then
        v_UebStdBeginn := (p_arb_bis - p_ueb_std / 24);

        v_LoaUebStd := p_ueb_std;
        -- Differenz ist genau ein Tag (Ganztageseintrag)
        if p_lz_von + 1 != p_lz_bis then
          if p_lz_von > v_UebStdBeginn then
            v_LoaUebStd := v_LoaUebStd - ((p_lz_von - v_UebStdBeginn) * 24);
          end if;

          if p_lz_bis < p_arb_bis then
            v_LoaUebStd := v_LoaUebStd - ((p_arb_bis - p_lz_bis) * 24);
          end if;
        end if;

        if p_lz_op = '<=' then
          if v_LoaUebStd > p_lz_ueb_std then
            v_LoaUebStd := p_lz_ueb_std;
          end if;
        elsif p_lz_op = '<' then
          if v_LoaUebStd >= p_lz_ueb_std then
            v_LoaUebStd := p_lz_ueb_std - 15 / 60; -- 1/4 Stunde abziehen
          end if;
        elsif p_lz_op = '>=' then
          if v_LoaUebStd >= p_lz_ueb_std then
            v_LoaUebStd := v_LoaUebStd - p_lz_ueb_std; -- nur das berechnen, was über die grenze hinaus geht
          else
            v_LoaUebStd := 0;
          end if;
        elsif p_lz_op = '>' then
          if v_LoaUebStd > p_lz_ueb_std then
            v_LoaUebStd := v_LoaUebStd - p_lz_ueb_std; -- nur das berechnen, was über die grenze hinaus geht
          else
            v_LoaUebStd := 0;
          end if;
        end if;
        v_LoaStd := v_LoaUebStd;
      end if;
    end if;

    if v_LoaStd > v_max_loa_std then
      -- es können nicht mehr stunden sein, als geleistet wurde
      v_LoaStd := v_max_loa_std;
    end if;

    return(round(v_LoaStd, 3));
  end berechne_loa_std;

  procedure c_berechne_schichtzulagen(in_pers_nr     in number,
                                      in_schicht_tag in date,
                                      in_von         in date,
                                      in_bis         in date,
                                      in_sa_kurzname in varchar2,
                                      in_kst         in number) is
    v_Loa       varchar2(50);
    v_AltLoa    varchar2(50);
    v_lz_von    date;
    v_lz_bis    date;
    v_ns_von    date;
    v_ns_bis    date;
    v_Von       date;
    v_Bis       date;
    v_p_Von     date;
    v_p_Bis     date;
    v_in_Bis    date;
    v_Op        varchar2(10);
    v_Std       number;
    v_d_start   date;
    v_d_ende    date;
    v_std_d_g   number;
    v_std_minus number;
    v_f_Std     number;
    v_sa_Std    number;
    v_so_Std    number;
    --v_pause_std number;
    v_Feiertag  varchar2(20);
    v_x_Wochentag    number;
    v_Wochentag      number;
    v_a_Wochentag    number;
    v_n_Wochentag    number;
    v_tarif_name       pzm_tarifmodelle.tarif_name%type;
    v_pzm_lz_tarif     pzm_lz_tarifmodelle%rowtype;
    v_abwesenheiten    pzm_abwesenheitsarten%rowtype;
    v_SonderFeiertag   varchar2(10);
    v_lohnart         pzm_lohnarten%rowtype;
    v_Schichtmodell   pzm_schicht_modelle%rowtype;
    v_nachtschicht    boolean;
    
    v_pb_id number;
    v_abt_id number;
    v_kst_id number;

    v_LZLoa varchar2(50);
    --v_LZLoaStd   number;
    v_lzid number;

    v_loaGrp    varchar2(50);
    v_LoaStdGrp number;

    -- ******************** Cursor deklarationen **********************
    cursor c_lohnartenAll is -- 1 = Bedingungsstufe (Alle Bedingungen müssen erfüllt sein)
      select lz_lohnart,
             pzm_lohnauswertung.get_alternativ_loa(lz_alternativ_loa_id),
             -- ALT: DECODE(trunc(p_von) + 1, trunc(p_bis),
             -- wenn der schichtag am Vortag beginnt
             decode(in_schicht_tag + 1,
                    trunc(in_bis),
                    (case
                      when fraction_of_day(lz_uhrz_von) < fraction_of_day(in_von) and
                           lz_uhrz_von < lz_uhrz_bis and lz_operator is not NULL then
                       lz_uhrz_von + 1
                      else
                       lz_uhrz_von
                    end),
                    lz_uhrz_von) lz_uhrz_von,
             lz_uhrz_bis,
             lz_operator,
             TRUNC(lz_stunden, 0),
             lz_feiertag,
             lz_wochentag,
             lz_id,
             lz_lohnart_grp
        from pzm_lohnarten
       where nvl(lz_gueltig_ab, trunc(sysdate)) <= trunc(sysdate)
         and nvl(lz_gueltig_bis, trunc(sysdate)) >= trunc(sysdate)
       order by decode (nvl(pzm_p_base.get_allg_parameter_mandant(v_pb_id, 'LOA_HOERERE_LOA_MINUS'), 'T'),
                          'T', lz_id,
                           0),                                                -- Reihenfolge LOA beachten
                lz_uhrz_von, lz_lohnart;
    --------------------
    cursor c_lztarif is
      select * from pzm_lz_tarifmodelle t
       where t.lz_id = v_lzid;
    --------------------
    cursor c_lzsa is
      select * from pzm_lz_sa where lzsa_lz_id = v_lzid;
    --------------------
    cursor c_lzkst is
      select * from pzm_lz_kst where lzkst_lz_id = v_lzid;
    --------------------
    cursor c_ZELoaAuswGrp is
      select nvl(sum(zeaw_lz_loa_std), 0)
        from pzm_ze_loa_ausw
       where zeaw_pers_nr = in_pers_nr
         and zeaw_datum = trunc(in_schicht_tag)
         and (zeaw_lz_loa_grp like
             '%' || nvl(v_LoaGrp, '$KeineGruppe$') || '%' or
             v_LoaGrp like
             '%' || nvl(zeaw_lz_loa_grp, '$KeineGruppe$') || '%');
    --------------------
    cursor c_ISI_PZM_ZE_Tagessatz is
      select *
        from PZM_ZE_Tagessatz
       where ts_pers_nr = in_pers_nr
         and ts_datum = in_schicht_tag;
    --------------------
    CURSOR c_get_ze_eintrag is
      select sum(z.ze_std),
             min(z.ze_calc_ist_start), 
             max(z.ze_calc_ist_ende)
        from pzm_zeiterfassung z
       where z.ze_pers_nr = in_pers_nr
         and z.ze_schicht_tag = in_schicht_tag
         and z.ze_calc_ist_start >= in_von
         and z.ze_calc_ist_ende <= in_bis
         and z.ze_status = 5 
         and nvl(z.ze_work_location, 52) in (52, 53, 99);

    CURSOR c_get_ze_eintrag_anw is   -- Neue Zeiten wegen Diestgang
      select sum(z.ze_std),
             min(z.ze_calc_ist_start), 
             max(z.ze_calc_ist_ende)
        from pzm_zeiterfassung z
       where z.ze_pers_nr = in_pers_nr
         and z.ze_schicht_tag = in_schicht_tag
         and z.ze_calc_ist_start >= in_von
         and z.ze_calc_ist_ende <= in_bis
         and z.ze_status in (2, 7)
         and nvl(z.ze_work_location, 52) not in (52, 53, 99);

    --------------------
    cursor c_abwesenheitsarten is
      select t.aa_id from pzm_abwesenheitsarten t where t.lz_id = v_lzid;
    --------------------

    cursor c_lohnarten_pers is 
      select la.lz_lohnart,
             pzm_lohnauswertung.get_alternativ_loa(la.lz_alternativ_loa_id),
             -- ALT: DECODE(trunc(p_von) + 1, trunc(p_bis),
             -- wenn der schichtag am Vortag beginnt
             decode(in_schicht_tag + 1,
                    trunc(in_bis),
                    (case
                      when fraction_of_day(la.lz_uhrz_von) < fraction_of_day(in_von) and
                           la.lz_uhrz_von < la.lz_uhrz_bis and la.lz_operator is not NULL then
                       la.lz_uhrz_von + 1
                      else
                       la.lz_uhrz_von
                    end),
                    la.lz_uhrz_von) lz_uhrz_von,
             la.lz_uhrz_bis,
             la.lz_operator,
             TRUNC(la.lz_stunden, 0),
             la.lz_feiertag,
             la.lz_wochentag,
             la.lz_id,
             la.lz_lohnart_grp,
             la.lz_typ,
             la.lz_einheit
        from pzm_lohnarten la
       where nvl(lz_gueltig_ab, trunc(sysdate)) <= trunc(sysdate)
         and nvl(lz_gueltig_bis, trunc(sysdate)) >= trunc(sysdate)
         and la.lz_id in (select plz.lz_id
                            from pzm_pers_lohn_zulagen plz
                           where plz.pers_nr = in_pers_nr
                             and nvl(plz.gueltig_datum_von, in_schicht_tag) <= in_schicht_tag
                             and nvl(plz.gueltig_datum_bis, in_schicht_tag) >= in_schicht_tag
                            group by plz.lz_id);

    v_aa_id                pzm_abwesenheitsarten.aa_id%type;
    v_LoaStd               number;
    v_lz_typ               pzm_lohnarten.lz_typ%type;
    v_lz_einheit           pzm_lohnarten.lz_einheit%type;
    --v_LoaUebStd number;
    v_Found                boolean;
    --v_isi_pzm_lz_tarif     pzm_lz_tarifmodelle%rowtype;
    v_isi_pzm_lz_kst       pzm_lz_kst%rowtype;
    v_isi_pzm_lz_sa        pzm_lz_sa%rowtype;
    v_ISI_PZM_ZE_Tagessatz PZM_ZE_Tagessatz%rowtype;
    v_gueltig              boolean;
    v_gueltigX             boolean;
    v_arbstd               number;
    v_arbstd_pers          number;
    v_ueb_std              number;
    v_flex_std             number;
    v_korr_std             number;
    
    --v_FeiertagKette boolean;        -- Feiertag ist kein Ganztageseintrag und muß evtl. zwei mal durchlaufen
    v_ketten_zaehler integer;
    v_loa_ketten     integer;

    v_korr_std_loa pzm_lohnarten.lz_lohnart%type;
    v_ueb_std_loa  pzm_lohnarten.lz_lohnart%type;
    v_flex_std_loa pzm_lohnarten.lz_lohnart%type;

    v_pers_nr number;
    cursor c_pers is
      select t.pers_nr,
             t.pers_pb_id,
             t.pers_abt_id,
             t.pers_kst_id,
             t.tarif_name
        from pzm_personal t
       where t.pers_nr = in_pers_nr;
    

  begin
    open c_pers;
    fetch c_pers into v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_tarif_name;
    close c_pers;
    
    if v_kst_id is NULL
    then
      v_kst_id := get_pers_kst_id(v_pers_nr);
    end if;
    if v_pb_id is NULL
    then
      v_pb_id := get_pers_pb_id(v_pers_nr);
    end if;
    if v_tarif_name is NULL
    then
      v_tarif_name := get_pers_tarif_name(v_pers_nr);
    end if;


    v_Found := false;
    v_p_bis := in_bis;
    v_in_Bis := NULL;

    v_ueb_std_loa  := pzm_p_base.get_allg_parameter_mandant(v_pb_id, 'UEB_STD_ZUGANG_LOA');
    v_flex_std_loa := pzm_p_base.get_allg_parameter_mandant(v_pb_id, 'FLEX_STD_ZUGANG_LOA');
    v_korr_std_loa := pzm_p_base.get_allg_parameter_mandant(v_pb_id, 'KORR_STD_ZUGANG_LOA');

    v_korr_std := 0;

    -- Erst mal prüfen, ob Überstunden bezahlt werden sollen
    open c_ISI_PZM_ZE_Tagessatz;
    fetch c_ISI_PZM_ZE_Tagessatz
      into v_ISI_PZM_ZE_Tagessatz;
    close c_ISI_PZM_ZE_Tagessatz;

    v_flex_std := nvl(v_ISI_PZM_ZE_Tagessatz.ts_day_flex_std, 0);
    v_ueb_std  := nvl(v_ISI_PZM_ZE_Tagessatz.ts_day_ueb_std, 0);

    v_arbstd := nvl(v_ISI_PZM_ZE_Tagessatz.ts_day_arb_std, 0) + v_flex_std +
                v_ueb_std;

    if v_ISI_PZM_ZE_Tagessatz.ts_ueb_ok_datum is null or
       v_ISI_PZM_ZE_Tagessatz.ts_ueb_storno_datum is not null then
      -- Überstunden wieder abziehen
      v_p_bis   := in_bis - v_ueb_std / 24;
      v_arbstd  := v_arbstd - v_ueb_std;
      v_ueb_std := 0;
    end if;

    -- Rundungsfehler korrigieren (auf ganze Minuten runden)
    v_arbstd := round(v_arbstd * 60) / 60;
    v_arbstd_pers := v_arbstd;

    if nvl(v_isi_pzm_ze_tagessatz.ts_day_korr_std, 0) > 0 and
       v_isi_pzm_ze_tagessatz.ts_abschluss is not null then
      v_korr_std := v_isi_pzm_ze_tagessatz.ts_day_korr_std;
    end if;

    delete pzm_ze_loa_ausw t
     where t.zeaw_pers_nr = in_pers_nr
       and t.zeaw_datum = in_schicht_tag
       and t.zeaw_korr_datum is null
       and t.aa_id is null
       and t.zeaw_lz_lohnart not in
           (v_ueb_std_loa, v_flex_std_loa, v_korr_std_loa);
    
    v_a_Wochentag := isi_utils.Iso_WeekDay(in_schicht_tag);
    if v_arbstd > 0
    and v_a_Wochentag not in (6, 7)
    and ist_feiertag(in_pers_nr, 
                    get_pers_pb_id(in_pers_nr), 
                    get_pers_abt_id(in_pers_nr), 
                    get_pers_kst_id(in_pers_nr), 
                    in_schicht_tag, 
                    v_SonderFeiertag) = 1
    then
      if pzm_p_base.get_lohnart(pzm_utils.get_feiertag_lz_id, v_lohnart)
      then
        if pzm_p_base.get_schicht_modell(in_pers_nr, v_Schichtmodell)
        then
          if v_SonderFeiertag = 'H'
          then
            v_LoaStd := pzm_utils.pzm_get_sm_durch_std_tag(v_Schichtmodell.sm_name) / 2;
          else
            v_LoaStd := pzm_utils.pzm_get_sm_durch_std_tag(v_Schichtmodell.sm_name);
          end if;
          pzm_lohnauswertung.set_loa_std(in_pers_nr,
                                         in_schicht_tag,
                                         v_lohnart.lz_lohnart,
                                         v_LoaStd,
                                         pzm_utils.get_feiertag_aa_id,
                                         true,
                                         v_lohnart.lz_id,
                                         get_pers_kst_id(in_pers_nr)
                                         );
        end if;
      end if;
    end if;
      

    -- ************ Gehe durch alle lohnarten pruefe dann ueber Cursor (c_lzsa und c_lzkst) auf Gueltigkeit  ************
    -- lohnarten sind gueltig, wenn diese LOA keiner Schicht und Abteilung zugeordnet sind oder
    -- die LOA genau diese Schicht oder Abteilung zugeordnet ist und der Eintrag auf gueltig steht.
    -- Die LOA ist dann ungültig, wenn sie genau dieser Schicht oder Abteilung zugeortnet ist und der Eintrag
    -- auf Ungueltig steht.

    --
    -- Achtung wenn für eine LOA in den Schichten nur eine gefunden wird, die gültig ist, dann kann die LOA nur dann
    -- gültig sein, wenn für genau diese Schicht oder Abteilung ein Eintrag (GUELTIG) gefunden wird.
    --
    v_f_Std     := 0; -- Init
    v_sa_Std    := 0;
    v_so_Std    := 0;
    v_std_minus := 0;
    v_ns_von := NULL;  -- nachschichtzeiten - Ggf. SA-Stunden kürzen, dafür merken
    v_ns_bis := NULL;

    open c_lohnartenAll;
    loop
      <<fetch_loa>> -- label fuer GOTO (continue)
      fetch c_lohnartenAll
        into v_Loa,
             v_AltLoa,
             v_lz_von,
             v_lz_bis,
             v_Op,
             v_Std,
             v_Feiertag,
             v_x_Wochentag,
             v_lzid,
             v_loagrp;
      exit when c_lohnartenAll%notfound;
      v_Wochentag := to_number(v_x_Wochentag);
      v_arbstd := v_arbstd_pers;
      
      -- keine Sonderbehandlung für Korrektur-/Bonusstunden, aber auch nicht verarbeiten
      if v_Loa in (v_ueb_std_loa, v_flex_std_loa, v_korr_std_loa) then
        goto fetch_loa; -- nach Sonderbehandlung mit der nächsten LOA weitermachen
      end if;

      open c_abwesenheitsarten;
      fetch c_abwesenheitsarten
        into v_aa_id;
      v_found := c_abwesenheitsarten%found;
      close c_abwesenheitsarten;
      if v_found then
        goto fetch_loa; -- mit der nächsten LOA weitermachen
      end if;

      v_Von := v_lz_von;
      v_Bis := v_lz_bis;

      -- Jede gefundene Lohnart ist erst mal ungueltig !!!!
      v_gueltig := false;

      v_loa_ketten     := 0;
      v_ketten_zaehler := 0;

      if v_loa = '410'
      then
        v_Loa := v_loa;
      end if;
      if v_loa = '513'
      then
        v_Loa := v_loa;
      end if;
      if v_loa = '932'
      or v_loa = '931'
      or v_loa = '926'
      or v_loa = '925'
      then
        v_Loa := v_loa;
      end if;
      if v_loa = '516'
      then
        v_Loa := v_loa;
      end if;
      if v_loa = '517'
      then
        v_Loa := v_loa;
      end if;
      if v_lzid = '209'
      then
        v_Loa := v_loa;
      end if;
      loop
        -- Wann LOA beginnt und Endet (Schicht beruecksichtigen)
        v_von := in_schicht_tag + fraction_of_day(v_lz_von);
        v_bis := in_schicht_tag + fraction_of_day(v_lz_bis);

        if v_ketten_zaehler > 0 then
          v_von := v_von + v_ketten_zaehler;
          v_bis := v_bis + v_ketten_zaehler;
        end if;
        
        if trunc(in_von) < trunc(in_bis)
        then
          v_nachtschicht := true;
        else
          v_nachtschicht := false;
        end if;

        if v_von >= v_bis then
          v_bis := trunc(v_bis) + 1 + FRACTION_OF_DAY(v_bis);
          if v_von > in_von      -- z.B. in 01.01.2025 05:45 v_von 02.01.2025 22:00
          and v_von > in_bis     -- z.B. in in 01.01.2025 05:45 v_bis 03.01.2025 06:00
          and v_Bis - 1 > in_von -- Vor Nachtschichtende gekommen
          then
            v_bis := v_bis - 1;  -- Schichtdatum um einen Tag zurück.
            v_von := v_von - 1;
          end if;
        else
          if (v_von < in_von) and
             (trunc(in_schicht_tag) + 1 = trunc(v_p_bis)) and
             not (v_bis between in_von and v_p_bis) then
            v_von := v_von + 1;
            v_bis := v_bis + 1;
          end if;
        end if;
        v_gueltigX := true;
        
        v_n_Wochentag := isi_utils.Iso_WeekDay(in_schicht_tag+1);
        if v_n_Wochentag > 7 -- Aktuellet Tag ist Sonntag
        then
          v_n_Wochentag := 1;  -- dann ist der nächste Tag Montag
        end if;
        if v_a_Wochentag in (6,7)
        then
          if v_Feiertag is NULL
          and v_Wochentag != v_a_Wochentag
          then
            if not v_nachtschicht
            then
              v_gueltigX := false;
            end if;
          end if;
        end if;

        if v_feiertag = 'F' or v_feiertag = 'SF' or v_Wochentag is not NULL
        then
          if  ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, in_schicht_tag, v_SonderFeiertag) = 1
          and ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, in_schicht_tag + 1, v_SonderFeiertag) = 1 
          then
             -- Aktueller Tag und der nächste Tag passt auch (Kann nur Feiertag sein)
            v_bis := v_bis + 1;
          elsif ((ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, in_schicht_tag + 1, v_SonderFeiertag) = 1
                  and v_feiertag = 'F' or v_feiertag = 'SF')
                )
             or v_Wochentag = v_n_Wochentag
          then
            -- Aktueller Tag passt nicht, aber der nächste
            v_von := trunc(v_von) + 1;
            v_bis := trunc(v_bis) + 1;
          elsif (ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_von, v_SonderFeiertag) = 1 
               or v_Wochentag = isi_utils.Iso_WeekDay(in_schicht_tag))
              and v_bis > trunc(v_von) + 1 
          then
            -- Aktueller Tag passt und nächster Tag nicht
            v_bis := trunc(v_von) + 1;
          end if;
        end if;
        
        if v_gueltigX = true
        then
          if  v_Op in ('KUG', 'KUGF')   -- Kurzarbeitergeld  
          then
            if pzm_p_base.get_abwesenheitsart(v_ISI_PZM_ZE_Tagessatz.Ts_Aa_Id, v_abwesenheiten)
            and v_abwesenheiten.aa_kurzname = 'KUG'
            then
              v_gueltig := true;
            end if;
          elsif (in_von between v_von and v_bis) 
          or    (v_p_bis between v_von and v_bis) 
          or    (v_von between in_von and v_p_bis) 
          or    (v_bis between in_von and v_p_bis) 
          then
            OPEN c_get_ze_eintrag;
            FETCH c_get_ze_eintrag into v_std_d_g, v_d_start, v_d_ende;
            CLOSE c_get_ze_eintrag;
            if v_std_d_g > 0
            then 
              v_arbstd := v_arbstd - v_std_d_g + v_ISI_PZM_ZE_Tagessatz.Ts_Day_Pause_Std;
              -- Dies muss noch einmal geprüft werden
              OPEN c_get_ze_eintrag_anw;
              FETCH c_get_ze_eintrag_anw into v_std_d_g, v_d_start, v_d_ende;
              CLOSE c_get_ze_eintrag_anw;
              if v_d_start is not NULL
              and v_d_ende is not NULL
              then
                v_p_von := v_d_start;
                v_p_bis := v_d_ende;
              end if;
              
            end if;
            if v_arbstd > 0
            then
              v_gueltig := true;
            end if;
          end if;
        end if;

        -- Jede gefundene Lohnart ist gueltig, wenn der tarif passt
        v_gueltigX := true;

        if v_gueltig = true then
          open c_lztarif;

          loop
            fetch c_lztarif
              into v_pzm_lz_tarif;
            -- Wenn kein Eintrag vorhanden, dann gilt diese Lohnart fuer all Schichten
            exit when c_lztarif%notfound;

            -- Eintrag vorhanden, dann erst mal ungültig
            if c_lztarif%rowcount = 1 
            and v_pzm_lz_tarif.lz_gueltig = 1 then
              v_gueltig := false;
            end if;

            -- Ein Eintrag mit gültig gefunden, dann nur noch Gültig wenn Eintrag genau für diese Schicht
            if v_pzm_lz_tarif.lz_gueltig = 1 then
              v_gueltigX := false;
              v_gueltig  := false;
            end if;

            -- Wenn der Passende Tarif gefunden wurde und fuer diesen Tarif des Status
            -- GUELTIG gesetzt ist, dann ist diese Lohnart immer noch gültig.
            if v_tarif_name =  v_pzm_lz_tarif.tarif_name and
               v_pzm_lz_tarif.lz_gueltig = 1 then
              v_gueltig := true;
              exit;
            end if;

            -- Wenn der Passende Tarif gefunden wurde und fuer diesen Tarif des Status
            -- UNGUELTIG gesetzt ist, dann ist diese Lohnart ungültig.
            if v_tarif_name =  v_pzm_lz_tarif.tarif_name and
               v_pzm_lz_tarif.lz_gueltig = 0 then
              v_gueltig := false;
              exit;
            end if;

            -- Ein Entrag mit UNGUELTIG fuer einen anderen Tarif gefunden,
            -- dann erst mal wieder auf gueltig stellen
            if v_tarif_name = v_pzm_lz_tarif.tarif_name and
               v_pzm_lz_tarif.lz_gueltig = 0 then
              v_gueltig := v_gueltigX;
            end if;
          end loop;

          close c_lztarif;
          
        end if;
        
        -- Jede gefundene Lohnart ist gueltig, wenn LoaZeit in der Schichtzeit !!!!
        v_gueltigX := true;

        if v_gueltig = true then
          open c_lzsa;

          loop
            fetch c_lzsa
              into v_isi_pzm_lz_sa;
            -- Wenn kein Eintrag vorhanden, dann gilt diese Lohnart fuer all Schichten
            exit when c_lzsa%notfound;

            -- Eintrag vorhanden, dann erst mal ungültig
            if c_lzsa%rowcount = 1 
            and v_isi_pzm_lz_sa.lzsa_gueltig = 1 
            then
              v_gueltig := false;
            end if;

            -- Ein Eintrag mit gültig gefunden, dann nur noch Gültig wenn Eintrag genau für diese Schicht
            if v_isi_pzm_lz_sa.lzsa_gueltig = 1 then
              v_gueltigX := false;
              v_gueltig  := false;
            end if;

            -- Wenn die Passende Schicht gefunden wurde und fuer diesen Eintrag des Status
            -- GUELTIG gesetzt ist, dann ist diese Lohnart immer noch gültig.
            if v_isi_pzm_lz_sa.lzsa_sa_kurzname = in_sa_kurzname and
               v_isi_pzm_lz_sa.lzsa_gueltig = 1 then
              v_gueltig := true;
              exit;
            end if;

            -- Wenn die Passende Schicht gefunden wurde und fuer diesen Eintrag des Status
            -- UNGUELTIG gesetzt ist, dann ist diese Lohnart ungültig.
            if v_isi_pzm_lz_sa.lzsa_sa_kurzname = in_sa_kurzname and
               v_isi_pzm_lz_sa.lzsa_gueltig = 0 then
              v_gueltig := false;
              exit;
            end if;

            -- Ein Entrag mit UNGUELTIG fuer eine andere Schicht gefunden,
            -- dann erst mal wieder auf gueltig stellen
            if v_isi_pzm_lz_sa.lzsa_sa_kurzname != in_sa_kurzname and
               v_isi_pzm_lz_sa.lzsa_gueltig = 0 then
              v_gueltig := v_gueltigX;
            end if;
          end loop;

          close c_lzsa;

          -- Lohnart ist gueltig fuer diese KST!!
          v_gueltigX := true;
          if v_gueltig = true then
            open c_lzkst;

            loop
              fetch c_lzkst
                into v_isi_pzm_lz_kst;

              -- Wenn kein Eintrag vorhanden, dann gilt diese Lohnart fuer all Abteilungen
              exit when c_lzkst%notfound;

              -- Eintrag vorhanden, dann erst mal ungültig
              if c_lzkst%rowcount = 1 
              AND v_isi_pzm_lz_kst.lzkst_gueltig = 1 then
                v_gueltig := false;
              end if;

              -- Ein Eintrag mit gültig gefunden, dann nur noch Gültig wenn Eintrag genau für diese Abteilung
              if v_isi_pzm_lz_kst.lzkst_gueltig = 1 then
                v_gueltigX := false;
                v_gueltig  := false;
              end if;

              -- Wenn die Passende Abteilung gefunden wurde und fuer diesen Eintrag des Status
              -- GUELTIG gesetzt ist, dann ist diese Lohnart immer noch gültig.
              if v_isi_pzm_lz_kst.lzkst_abt_kst = in_kst and
                 v_isi_pzm_lz_kst.lzkst_gueltig = 1 then
                v_gueltig := true;
                exit;
              end if;

              -- Wenn die Passende Abteilung gefunden wurde und fuer diesen Eintrag des Status
              -- UNGUELTIG gesetzt ist, dann ist diese Lohnart ungültig.
              if v_isi_pzm_lz_kst.lzkst_abt_kst = in_kst and
                 v_isi_pzm_lz_kst.lzkst_gueltig = 0 then
                v_gueltig := false;
                exit;
              end if;

              -- Ein Entrag mit UNGUELTIG fuer eine andere Abteilung gefunden,
              -- dann erst mal wieder auf gueltig? stellen
              if v_isi_pzm_lz_kst.lzkst_abt_kst != in_kst and
                 v_isi_pzm_lz_kst.lzkst_gueltig = 0 then
                v_gueltig := v_gueltigX;
              end if;
            end loop;

            close c_lzkst;
          end if;

          -- Lohnart ist immer noch gueltig fuer diese Abteilung!!
          if v_gueltig = true then
            v_LZLoa := v_Loa;
            v_lz_korr_WE_F := false;

            open c_ZELoaAuswGrp;
            fetch c_ZELoaAuswGrp
              into v_LoaStdGrp;
            close c_ZELoaAuswGrp;

            if v_std is not null and v_Op like ('<%') then
              if v_std > v_LoaStdGrp then
                v_std := v_std - v_LoaStdGrp;
              else
                v_std := 0;
              end if;
            end if;

            if v_Op in ('KUG', 'KUGF')
            then 
              v_arbstd := v_isi_pzm_ze_tagessatz.ts_day_abw_std; -- Bei Kurzarbeit die Zeit wie Arbeitszeit bewerten
              v_von := v_isi_pzm_ze_tagessatz.ts_datum;
            end if;
            v_p_Von := in_von;
            v_p_Bis := nvl(v_in_bis, v_p_Bis);
            
            if v_d_ende is not NULL
            and v_d_start is not NULL
            then
              /*
              if v_p_Bis > v_d_start
              and v_p_Bis <= v_d_ende
              then
                v_in_bis := v_p_Bis;
                v_p_Bis := v_d_start;
              end if;
              
              if v_p_Von < v_d_ende    -- Wenn die Diestreise zum Beginn der Schicht ist
              and v_p_Von = v_d_start  -- Dann ist diese nicht vor der Dienstreise Schichtbeginn = Diensreisebeginn
              then
                v_p_Von := v_d_ende;
              end if;
              */
              -- Hier sind jetzt die Anewesenheitszeit von bin MAX
              v_p_von := v_d_start;
              v_p_bis := v_d_ende;
            end if;
            
            v_LoaStd := berechne_loa_std(v_p_Von,
                                         v_p_bis,
                                         v_Von,
                                         v_Bis,
                                         v_Op,
                                         v_Std,
                                         v_arbstd,
                                         v_ueb_std,
                                         v_Wochentag,
                                         v_Feiertag,
                                         v_ISI_PZM_ZE_Tagessatz.ts_sa_kurzname,
                                         in_schicht_tag,
                                         in_pers_nr);
            v_arbstd := v_arbstd_pers;
            v_lz_korr_WE_F := true;
            if nvl(v_LoaStd, 0) > 0 
            then
              if nvl(pzm_p_base.get_allg_parameter_mandant(v_pb_id, 'LOA_HOERERE_LOA_MINUS'), 'T') = 'T'
              and ((v_f_Std + v_sa_Std + v_so_Std > 0 and (v_ns_bis is NULL or v_Wochentag != 6)) 
               or  (v_a_Wochentag in (5, 6) and v_sa_Std = 0 and v_ns_bis is not NULL and v_Wochentag = 6))
              then
                if  (ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, in_schicht_tag, v_SonderFeiertag) = 1
                and  ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, in_schicht_tag + 1, v_SonderFeiertag) = 1)
                 or (v_a_Wochentag = 7 -- Aktueller Tag ist Sonntag  
                and  ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, in_schicht_tag + 1, v_SonderFeiertag) = 1)
                 or v_a_Wochentag = 6 -- Aktueller Tag ist Samstag
                then
                  if v_a_Wochentag = 6 -- Aktueller Tag ist Samstag
                  and v_Wochentag = 6  -- LOA ist für Samstag
                  and v_ns_von is not NULL
                  and v_ns_bis is not NULL
                  then
                    if v_ns_bis > in_von -- Nachtschicht ist am Anfang der Schicht, dann Samstag nach Ende der Nachtscicht
                    and v_ns_von < in_von
                    then
                      v_LoaStd := v_LoaStd - round(((v_ns_bis - in_von) * 24), 3);
                    else
                      v_LoaStd := berechne_loa_std(in_von,
                                                    v_p_bis,
                                                    v_Von,
                                                    v_ns_von,  -- Nur bis die Nachtschicht beginnt
                                                    v_Op,
                                                    v_Std,
                                                    v_arbstd,
                                                    v_ueb_std,
                                                    v_n_Wochentag,
                                                    v_SonderFeiertag,
                                                    v_ISI_PZM_ZE_Tagessatz.ts_sa_kurzname,
                                                    in_schicht_tag,
                                                    in_pers_nr);
                    end if;
                  else
                    if v_lz_von > v_lz_bis -- Nachtschicht am Samstag
                    then
                      v_LoaStd := v_LoaStd - v_so_Std;
                      if v_so_Std = 0
                      then
                        v_LoaStd := v_LoaStd - v_f_Std;   -- -AG- 05.05.2026 Bei Feiertag muss auch abgezogen werden
                      end if;
                    else
                      -- Aktueller Tag und der nächste Tag passt auch (Kann nur Feiertag sein) oder Sa/So uns Sa > andere Zulage
                      v_LoaStd := 0;
                    end if;
                  end if;
                elsif ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, in_schicht_tag + 1, v_SonderFeiertag) = 1
                   or v_n_Wochentag = 6 -- Nächster tag ist Samstag
                then
                  -- Aktueller Tag passt nicht, aber der nächste
                  if v_n_Wochentag = 6 -- Naechster Tag ist Samstag
                  and v_Wochentag = 6  -- LOA ist für Samstag
                  and v_ns_von is not NULL
                  and v_ns_bis is not NULL
                  then
                    v_LoaStd :=    berechne_loa_std(in_von,
                                                    v_p_bis,
                                                    v_ns_bis,  -- Erst nach der Nachtschicht NS > Samstag
                                                    v_Bis,
                                                    v_Op,
                                                    v_Std,
                                                    v_arbstd,
                                                    v_ueb_std,
                                                    v_n_Wochentag,
                                                    v_SonderFeiertag,
                                                    v_ISI_PZM_ZE_Tagessatz.ts_sa_kurzname,
                                                    in_schicht_tag,
                                                    in_pers_nr);
                  else
                    if v_p_bis < in_schicht_tag + 1
                    then
                      v_LoaStd := 0;
                    else
                      if nvl(v_n_Wochentag, 1) != 6
                      then
                        v_std_minus := berechne_loa_std(in_von,
                                                      v_p_bis,
                                                      in_schicht_tag + 1,
                                                      v_Bis,
                                                      v_Op,
                                                      v_Std,
                                                      v_arbstd,
                                                      v_ueb_std,
                                                      v_n_Wochentag,
                                                      v_SonderFeiertag,
                                                      v_ISI_PZM_ZE_Tagessatz.ts_sa_kurzname,
                                                      in_schicht_tag,
                                                      in_pers_nr,
                                                      v_LoaStd);
                        v_LoaStd := v_LoaStd - v_std_minus;
                      else
                        v_LoaStd := berechne_loa_std (in_von,
                                                      v_p_bis,
                                                      in_schicht_tag + 1,
                                                      v_Bis,
                                                      v_Op,
                                                      v_Std,
                                                      v_arbstd,
                                                      v_ueb_std,
                                                      v_n_Wochentag,
                                                      v_SonderFeiertag,
                                                      v_ISI_PZM_ZE_Tagessatz.ts_sa_kurzname,
                                                      in_schicht_tag,
                                                      in_pers_nr);
                      end if;
                    end if;
                  end if;
                elsif (ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_von, v_SonderFeiertag) = 1) 
                   or v_a_Wochentag = 7 -- Aktueller Tag ist Sonntag
                then
                  -- Aktueller Tag passt und nächster Tag nicht
                  /*
                  v_std_minus := berechne_loa_std(in_von,
                                                  v_p_bis,
                                                  v_Von,
                                                  in_schicht_tag + 1,
                                                  v_Op,
                                                  v_Std,
                                                  v_arbstd,
                                                  v_ueb_std,
                                                  v_a_Wochentag,
                                                  v_SonderFeiertag,
                                                  v_ISI_PZM_ZE_Tagessatz.ts_sa_kurzname,
                                                  in_schicht_tag,
                                                  in_pers_nr);
                  v_pause_std := get_pers_pause_std(in_pers_nr,
                                  in_schicht_tag,
                                  v_ISI_PZM_ZE_Tagessatz.ts_sa_kurzname,
                                  in_von,
                                  v_p_bis); --,
                    v_LoaStd := v_LoaStd - v_std_minus - v_pause_std;
                  */
                  v_LoaStd := berechne_loa_std (in_von,
                                                v_p_bis,
                                                in_schicht_tag + 1,
                                                v_Bis,
                                                v_Op,
                                                v_Std,
                                                v_arbstd,
                                                v_ueb_std,
                                                v_a_Wochentag,
                                                v_SonderFeiertag,
                                                v_ISI_PZM_ZE_Tagessatz.ts_sa_kurzname,
                                                in_schicht_tag,
                                                in_pers_nr);
                end if;
              end if;

            end if;
            v_lz_korr_WE_F := false;

            if nvl(v_LoaStd, 0) > 0 
            then 
              -- -AG- 2026.06.01 - Fehler bei der Nachschicht an Feiertagen
              if nvl(v_f_Std, 0) < v_arbstd -- Nachtschicht muss bei Feiertagen noch einmal gesondert betrachtet werden, 
                                            -- wegen der Sonderregeln in der nachtscicht
              or v_lz_von < v_lz_bis        -- keine Nachtschicht, dann passt es immer
              or v_Op in ('KUG', 'KUGF')    -- oder Kurzarbeitergeld, KUG immer buchen
              then
                set_loa_std_grp(in_pers_nr,
                                in_schicht_tag,
                                v_LZLoa,
                                v_LoaStd,
                                null,
                                v_loagrp,
                                v_lzid,
                                false,
                                v_ISI_PZM_ZE_Tagessatz.Ts_Day_Kst_Id);
              end if;

              if v_Feiertag is not NULL -- SF oder F
              then
                v_f_Std := v_LoaStd; 
              elsif v_Wochentag = 6
              then
                v_sa_Std := v_LoaStd; 
                if v_sa_Std =  v_f_Std
                then
                  v_sa_Std := 0;
                elsif v_sa_Std + v_f_Std > v_arbstd + v_ueb_std
                then
                  v_sa_Std := v_arbstd + v_ueb_std - v_f_Std;
                end if;
              elsif v_Wochentag = 7
              then
                v_so_Std := v_LoaStd; 
                if v_so_Std =  v_f_Std
                then
                  v_sa_Std := 0;
                elsif v_so_Std + v_f_Std > v_arbstd + v_ueb_std
                then
                  v_so_Std := v_arbstd + v_ueb_std - v_f_Std;
                end if;
              end if; 
              if fraction_of_day(v_lz_von) > fraction_of_day(v_lz_bis)
              then -- Nachtschicht Zeiten merken ggf. für SA-Stunden
                v_ns_von := v_von;                
                v_ns_bis := v_bis;                
              end if;
            end if;

            commit;
          end if;
        end if;

        v_ketten_zaehler := v_ketten_zaehler + 1;
        exit when v_ketten_zaehler > v_loa_ketten;
      end loop;
    end loop;

    close c_lohnartenAll;

    commit;

    select nvl(sum(t.ze_std), 0) into v_korr_std    -- Abwesenheiten mit LOA für Arbeitsstunden
     from pzm_zeiterfassung t,
          pzm_abwesenheitsarten aa,
          pzm_lohnarten l
    where 1=1
      and t.ze_aa_status = aa.aa_id
      and aa.lz_id = l.lz_id
      and l.lz_operator = 'ARBSTD'
      and t.ze_pers_nr = in_pers_nr
      and t.ze_schicht_tag = in_schicht_tag;
    v_arbstd := v_arbstd - nvl(v_korr_std, 0);
    
    -- Und jetzt die Zulagen die über die Personalnummer zugeordnet werden sollen
    open c_lohnarten_pers;

    loop
      fetch c_lohnarten_pers
        into v_LZLoa,
             v_AltLoa,
             v_lz_von,
             v_lz_bis,
             v_Op,
             v_Std,
             v_Feiertag,
             v_Wochentag,
             v_lzid,
             v_loagrp,
             v_lz_typ,
             v_lz_einheit;
      exit when c_lohnarten_pers%notfound;
      
      v_LoaStd := 0;   -- Erst mal keine LOA-Stunden

      if v_lz_typ = 'ZU_STD'
      then
        if v_lz_einheit = 'HH24'
        then 
           v_LoaStd := v_arbstd;
        elsif v_lz_einheit = 'DD'
        then
          v_LoaStd := 1;
        end if;
      elsif v_lz_typ = 'ARB_STD'
      then
        if v_lz_einheit = 'HH24'
        then 
           v_LoaStd := v_arbstd;
        elsif v_lz_einheit = 'DD'
        then
          v_LoaStd := 1;
        end if;
      elsif v_lz_typ = 'UEB_STD'
      and v_ueb_std > 0
      then
        if v_lz_einheit = 'HH24'
        then 
           v_LoaStd := v_ueb_std;
        elsif v_lz_einheit = 'DD'
        then
          v_LoaStd := 1;
        end if;
      end if;
        
      if v_feiertag = 'F' or v_feiertag = 'SF' 
      then
        if ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_von, v_SonderFeiertag) != 1 
        or v_feiertag != v_SonderFeiertag
        then
          -- Aktueller Tag ist kein Feiertag
          v_LoaStd     := 0;
        end if;
      end if;

      if v_LoaStd > 0
      then
        set_loa_std_grp(in_pers_nr,
                        in_schicht_tag,
                        v_LZLoa,
                        v_LoaStd,
                        null,
                        v_loagrp,
                        v_lzid,
                        false,
                        v_ISI_PZM_ZE_Tagessatz.Ts_Day_Kst_Id);
      end if;
    end LOOP;
    close c_lohnarten_pers;
    
    commit;

  end c_berechne_schichtzulagen;

  /**************************************************************************************************
  * c_reset_Monatsende
  * zum Monatsende werden die Daten automatisch auf null gesetzt
  *
  * Die Bedingung ist das die Lohnart Reset =1 und die Mitarbeiter mit der Vertragsart Reset =1 besitzen.
  * Die Überstunden werden den automatisch ausgezahlt und negativ Stunden auf 0 gesetzt.
  *
  * 20180619 MWe automatisches Reset wenn Lohnart und Vertragsart passen (Reset =1) Ticket: P70074-30
  **************************************************************************************************/
  procedure c_reset_Monatsende(p_pers_nr  in number,
                               p_datum    in date,
                               p_res_info out varchar2) is

    v_pers_nr                  PZM_PERSONAL%rowtype;
    v_zk_monat_saldo           number;

    -- Prüft ob bei der Pers_nr ein Reset am Monatsende erlaubt ist.
    cursor c_Perosnal is
      select pd.*
        from PZM_PERSONAL pd, PZM_VERTRAGSARTEN pv
       where pv.va_reset_monats_ende = 1
         and pv.va_id = pd.pers_vertragsart
         and pd.pers_nr = p_pers_nr;

  begin
    p_res_info := 'Es hat keine Verarbeitung stattgefunden.';

    -- Wenn der letzte Tag des Monats gleich ist dann starte die Berechnung.
    -- last_day gibt den Letzten Tag des Monats wieder.
    if (last_day(p_datum) != p_datum) then
      p_res_info := 'Es hat keine Verarbeitung stattgefunden, da noch nicht Ende des Monats.';
      return;
    end if;

    open c_Perosnal;
    p_res_info := 'Es hat keine Verarbeitung stattgefunden, bei der Person darf kein Reset ausgeführt werden.';

    loop
      fetch c_Perosnal
        into v_pers_nr;
      exit when c_Perosnal%notfound;
      p_res_info := 'Start der Verarbeitung. (Überstunden automatisch Auszahlen)';

      -- Überstunden automatisch Auszahlen für den Monat
      v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                   p_pers_nr,
                                                                   'ZK',
                                                                   p_datum), 0);
      if v_zk_monat_saldo > 0
      then
        c_ueb_std_auszahlen(p_pers_nr,
                            to_number(to_char(p_datum, 'mm')),
                            to_number(to_char(p_datum, 'yyyy')),
                            v_zk_monat_saldo);

        p_res_info := 'Alle Daten Verarbeitet.';
      end if;
    end loop;

    close c_Perosnal;
  end;

  procedure c_save_13_w_schnitt (in_pers_nr       in pzm_personal.pers_nr%type,
                                in_monat_jahr    in date
                                ) is
    v_anz_arb_tage                number;
    v_arb_stunden                 number;
    v_zk_stunden                  number;
    v_datum_von                   date;
    v_datum_bis                   date;
    --v_13_w_schnitt                number;
    
  begin
    v_datum_von := in_monat_jahr;
    v_datum_bis := last_day(in_monat_jahr);
    v_anz_arb_tage := pzm_utils.get_pers_arb_std_tage(in_pers_nr,
                                                      NULL,
                                                      v_datum_von,
                                                      v_datum_bis);

    select sum(loa_h.loa_value) into v_arb_stunden
      from pzm_lohnarten loa,
           pzm_ze_loa_exp_host loa_h
     where ((loa.lz_typ = 'ARB_STD' and loa.lz_operator = 'ARBSTD')
         or (loa.lz_typ = 'UEB_STD' and nvl(loa.lz_operator, 'UESTD') = 'UESTD' and loa_h.loa_value > 0)
           )
       and loa_h.pers_nr = in_pers_nr
       and loa_h.lohnart = loa.lz_lohnart
       and loa_h.datum > v_datum_von
       and loa_h.datum <= v_datum_bis + 1;

    select sum(t.ts_day_abw_std)  into v_zk_stunden
      from pzm_ze_tagessatz t
     where t.ts_pers_nr = in_pers_nr
       and t.ts_datum >= v_datum_von
       and t.ts_datum <= v_datum_bis
       and (t.ts_day_arb_std = 0
       and exists (select la.lz_konto_name_kurz
                     from pzm_abwesenheitsarten aa,
                          pzm_lohnarten la
                   where aa.aa_id = t.ts_aa_id
                     and la.lz_id = aa.lz_id
                     and la.lz_konto_name_kurz = 'ZK')
           );
           
    if nvl(pzm_p_base.get_allg_parameter_mandant(get_pers_pb_id(in_pers_nr), 'LOA_13WS_MIT_ZEITKONTO_STD'), 'T') = 'F'
    then
      v_zk_stunden := 0;                              -- Nicht mitrechnen
    end if;
    
    v_arb_stunden := nvl(v_arb_stunden, 0) + nvl(v_zk_stunden, 0);
    
    delete pzm_ze_loa_13w_schnitt t
     where t.pers_nr = in_pers_nr
       and t.datum = trunc(v_datum_bis);
    insert into pzm_ze_loa_13w_schnitt
      (pers_nr, datum, arb_std, arb_tage)
    values
      (in_pers_nr, trunc(v_datum_bis), v_arb_stunden, v_anz_arb_tage);
    commit;
  end;

  function c_loa_13_w_schnitt (in_pers_nr       in pzm_personal.pers_nr%type,
                               in_monat_jahr    in date
                               ) return number is
    v_anz_arb_tage                number;
    v_arb_stunden                 number;
    --v_zk_stunden                  number;
    v_datum_von                   date;
    v_datum_bis                   date;
    v_13_w_schnitt                number;
    
  begin
    v_datum_bis := in_monat_jahr;
    v_datum_von := trunc(trunc(trunc(v_datum_bis - 1, 'MONTH') - 1, 'MONTH') - 1, 'MONTH');

    select sum(t.arb_std), sum(t.arb_tage) into v_arb_stunden, v_anz_arb_tage
      from pzm_ze_loa_13W_schnitt t
     where t.pers_nr = in_pers_nr
       and t.datum > v_datum_von
       and t.datum < v_datum_bis;

    v_13_w_schnitt := 0;
    if v_anz_arb_tage > 0 
    and v_arb_stunden > 0
    then
      v_13_w_schnitt := v_arb_stunden / v_anz_arb_tage;
    end if;
    return (v_13_w_schnitt);
  end;
  
  
  function c_loa_an_host (in_pers_nr       in pzm_personal.pers_nr%type,
                          in_monat         in number,
                          in_jahr          in number,
                          in_reset         in varchar2 default 'F' -- Immer neu ausrechnen
                         ) return varchar2 is
  begin
    return(c_loa_an_host_r32(in_pers_nr,
                             in_monat,
                             in_jahr,
                             NULL,
                             'LODAS',
                             nvl(in_reset, 'F')));
  end;
  
  procedure insert_pzm_ze_loa_exp_host(in_loa_kumuliert   in pzm_ze_loa_exp_host%rowtype, 
                                       in_kst_tab         in t_kst_std_tab,
                                       in_kst_idx_max     in integer) is

  v_kst_idx                            integer;
  v_loa_kumuliert                      pzm_ze_loa_exp_host%rowtype;

  begin
    v_kst_idx := 1;
    v_loa_kumuliert := in_loa_kumuliert;

    LOOP
      EXIT when v_kst_idx > in_kst_idx_max;
      v_loa_kumuliert.loa_value := round(in_loa_kumuliert.loa_value * in_kst_tab(v_kst_idx).kst_proz, 3);
      v_loa_kumuliert.kst_id := in_kst_tab(v_kst_idx).kst_id;
      if v_loa_kumuliert.loa_value != 0
      then
        insert into pzm_ze_loa_exp_host values v_loa_kumuliert;
      end if;
      v_kst_idx := v_kst_idx + 1;
    end LOOP;
  end;
  
  procedure insert_pzm_ze_loa_exp_ext_gutsch(in_loa_kumuliert   in pzm_ze_loa_exp_host%rowtype, 
                                             in_datum           in pzm_ze_loa_exp_ext_gutsch.datum%type,
                                             in_pers_vname      in pzm_personal.pers_vname%type,
                                             in_pers_nname      in pzm_personal.pers_nname%type,
                                             in_pb_abteilung    in pzm_ze_loa_exp_ext_gutsch.pb_abteilung_id%type) is

    v_start_zeit                             varchar2(5);
    v_ende_zeit                              varchar2(5);
    v_pause_zeit                             number;
    v_st_zeiten                              varchar2(50);
    
    CURSOR c_ts_zeit is
      select to_char(min(t.ze_calc_ist_start), 'hh24:mi') start_zeit,
             to_char(max(t.ze_calc_ist_ende), 'hh24:mi') ende_zeit,
             min(ts.ts_day_pause_std)
        from pzm_zeiterfassung t,
             pzm_ze_tagessatz ts
       where t.ze_pers_nr = in_loa_kumuliert.pers_nr
         and t.ze_schicht_tag = in_loa_kumuliert.datum
         and t.ze_aa_status is NULL
         and ts.ts_datum = t.ze_schicht_tag
         and ts.ts_pers_nr = t.ze_pers_nr
        group by t.ze_pers_nr;
  begin
    OPEN c_ts_zeit;
    FETCH c_ts_zeit into v_start_zeit, v_ende_zeit, v_pause_zeit;
    CLOSE c_ts_zeit;
    v_start_zeit := nvl(v_start_zeit, '00:00');
    v_ende_zeit := nvl(v_ende_zeit, '00:00');
    select substr(stradd_distinct(to_char(t.ze_ist_start, 'hh24:mi') || '_' || to_char(t.ze_ist_ende, 'hh24:mi')) || ',', 1, 50) into v_st_zeiten
      from pzm_zeiterfassung t
     where t.ze_schicht_tag = in_loa_kumuliert.datum
       and t.ze_pers_nr = in_loa_kumuliert.pers_nr
       and (t.ze_ist_start is not NULL or t.ze_ist_ende is not NULL);
    v_st_zeiten := substr(v_st_zeiten, 1, length(v_st_zeiten) -1);
    insert into pzm_ze_loa_exp_ext_gutsch
       (datum, 
        pb_id, 
        pb_abteilung_id, 
        pers_nr, lohnart, 
        loa_value, 
        pers_vname, 
        pers_nname,
        status, 
        konto_nr_korr, 
        konto_val_korr, 
        konten_bh_id_korr,
        ts_start_zeit,
        ts_ende_zeit,
        ze_stempelzeiten,
        ts_pause_zeit)
     values
       (
        in_datum, 
        in_loa_kumuliert.pb_id, 
        in_pb_abteilung, 
        in_loa_kumuliert.pers_nr, 
        in_loa_kumuliert.lohnart, 
        in_loa_kumuliert.loa_value, 
        in_pers_vname, 
        in_pers_nname,
        'N',
        in_loa_kumuliert.konto_nr_korr,
        in_loa_kumuliert.konto_val_korr,
        in_loa_kumuliert.konten_bh_id_korr,
        v_start_zeit, 
        v_ende_zeit,
        v_st_zeiten,
        v_pause_zeit);
  end;

  procedure insert_pzm_bereitschaft(in_loa_kumuliert   in pzm_ze_loa_exp_host%rowtype, 
                                    in_von_datum          in date,
                                    in_bis_datum          in date,
                                    in_kst_tab            in t_kst_std_tab,
                                    in_kst_idx_max        in integer) is
  
  v_kst_idx                            integer;
  v_loa_kumuliert                      pzm_ze_loa_exp_host%rowtype;

  CURSOR c_get_bereitschaft_zeiten is
    select l.lz_lohnart,
           erg.loa_id,
           sum(erg.loa_value) loa_value,
           erg.loa_unit
      from pzm_lohnarten l,
           (select t.pers_nr,
                   dlist.datum,
                   case when ist_feiertag_osf(t.pers_nr, v_loa_kumuliert.pb_id, get_pers_abt_id(t.pers_nr), v_loa_kumuliert.kst_id, dlist.datum) = 1
                        then
                             c.loa_id_fe
                        when isi_utils.Iso_WeekDay(dlist.datum) = 6
                        then
                             c.loa_id_sa
                        when isi_utils.Iso_WeekDay(dlist.datum) = 7
                        then
                             c.loa_id_so
                        else
                             c.loa_id
                        end loa_id,
                   case when ist_feiertag_osf(t.pers_nr, v_loa_kumuliert.pb_id, get_pers_abt_id(t.pers_nr), v_loa_kumuliert.kst_id, dlist.datum) = 1
                        then
                             c.value_fe
                        when isi_utils.Iso_WeekDay(dlist.datum) = 6
                        then
                             c.value_sa
                        when isi_utils.Iso_WeekDay(dlist.datum) = 7
                        then
                             c.value_so
                        else
                             c.value
                        end loa_value,
                   c.loa_einheit loa_unit
              from 
                   (select trunc(in_von_datum)+level-1 as DATUM from dual
                     where trunc(in_von_datum)+level-1 <= trunc(in_bis_datum)
                    connect by level <= trunc(in_bis_datum)-trunc(in_von_datum)+1) dlist,
                   pzm_personal p,
                   PZM_BEREITSCHAFT_PLAN t,
                   PZM_BEREITSCHAFT_CFG c
             where t.bereitschaft_cfg = c.bereitschaft_cfg
               and p.pers_nr = t.pers_nr
               and t.pers_nr = v_loa_kumuliert.pers_nr
               and dlist.datum >= t.bereitschaft_von
               and dlist.datum <= t.bereitschaft_bis
           ) erg
     where l.lz_id = erg.loa_id
     group by l.lz_lohnart,
              erg.loa_id,
              erg.loa_unit;
    v_get_bereitschaft_zeiten c_get_bereitschaft_zeiten%rowtype;
  
  begin
    v_loa_kumuliert := in_loa_kumuliert;
    OPEN c_get_bereitschaft_zeiten;
    LOOP
      FETCH c_get_bereitschaft_zeiten into v_get_bereitschaft_zeiten;
      EXIT when c_get_bereitschaft_zeiten%NOTFOUND;
      if in_kst_idx_max = 0
      then
        v_kst_idx := 0;
      else
        v_kst_idx := 1;
      end if;

      LOOP
        EXIT when v_kst_idx > in_kst_idx_max;
        if in_kst_idx_max > 0
        then
          v_loa_kumuliert.loa_value := round(v_get_bereitschaft_zeiten.loa_value * in_kst_tab(v_kst_idx).kst_proz, 3);
          v_loa_kumuliert.kst_id := nvl(in_kst_tab(v_kst_idx).kst_id, get_pers_kst_id(v_loa_kumuliert.pers_nr));
          v_loa_kumuliert.pb_id := nvl(v_loa_kumuliert.pb_id, get_pers_pb_id(v_loa_kumuliert.pers_nr));
        else
          v_loa_kumuliert.loa_value := round(v_get_bereitschaft_zeiten.loa_value, 3);
          v_loa_kumuliert.kst_id := get_pers_kst_id(v_loa_kumuliert.pers_nr);
          v_loa_kumuliert.pb_id := get_pers_pb_id(v_loa_kumuliert.pers_nr);
        end if;
        v_loa_kumuliert.loa_unit := v_get_bereitschaft_zeiten.loa_unit;
        v_loa_kumuliert.lohnart := v_get_bereitschaft_zeiten.lz_lohnart;
        v_loa_kumuliert.lz_id := v_get_bereitschaft_zeiten.loa_id;
        if v_loa_kumuliert.loa_value != 0
        then
          insert into pzm_ze_loa_exp_host values v_loa_kumuliert;
        end if;
        v_kst_idx := v_kst_idx + 1;
      end LOOP;
    end LOOP;
    CLOSE c_get_bereitschaft_zeiten;
  end;

function c_loa_an_host_r32 (in_pers_nr       in pzm_personal.pers_nr%type,
                              in_monat         in number,
                              in_jahr          in number,
                              in_ende_datum    in date,
                              in_schnittstelle in pzm_produktionsbereiche.pb_schnittstelle%type,
                              in_reset         in varchar2 default 'F' -- Immer neu ausrechnen
                             ) return varchar2 is

    v_result varchar2(500);
    v_res_info varchar2(500);     -- ergebnis von update_pers_ze_tag
    v_datum date;                 -- Aktuelles Datum für die Simulationsdaten
    v_von_datum date;
    v_bis_datum date;
    v_bis_datum_kst date;
    v_start_datum date;
    v_ende_datum date;
    v_start_datum_ueb_p date;
    v_ende_datum_ueb_p date;
    v_folgemonat_datum date;
    
    v_zk_monat_saldo_kug_done     boolean;
    v_zk_monat_saldo_true         boolean;
    v_zk_monat_saldo              number;      -- Zeitkonto hatt Überstunden + oder - 
    v_zk_monat_saldo_old          number;      -- Zeitkonto hatt Überstunden + oder - 
    v_zk_monat_loa                number;      -- ZK Daten im LOA
    v_zk_monat_diff               number;      -- Überstunden + oder - geleistet
    v_zk_monat_diff_ges           number;      -- Über alle Kostenstellen
    v_zk_monat_diff_kug           number;      -- Überstunden korrktur kug
    v_zk_monat_diff_kug_vmonat    number;      -- Überstunden korrktur kug
    v_anz_arb_tage                number;
    v_anz_arb_stunden             number;
    --v_aus_arb_tage                number;
    v_aus_arb_stunden             number;
    v_pers_max_frei_stunden       number;
    --v_ab_ueb_stunden              number;
    v_soll_std                    number;
    v_f_stunden_loa               number;
    v_f_stunden_loa_diff          number;
    v_ueb_stunden                 number;
    v_ueb_stunden_loa             number;
    v_ueb_stunden_loa2            number;
    v_ueb_stunden_13w             number;
    v_ueb_stunden_13w_korr        number;
    v_arb_stunden                 number;
    v_F_U_K_stunden               number;
    v_arb_plus_F_U_K_stunden      number;
    v_feiertags_std               number;
    v_zk_fuer_sundenlohn_std      number;
    v_kappung_flex_std            number;
    v_ueb_std                     number;
    v_ueb_std_proz                number;
    v_loa_std                     number;
    v_rb_stunden                  number;
    orignal_loa_value             number;
    v_korr_std_korrekt            Boolean;
    v_korr_std                    number;
    v_korr_std_abz                number;
    v_13_w_schnitt                number;
    v_13_w_schnitt_value          number;
    v_day_schnitt                 number;
    v_stat_value                  number;
    v_stat_value_arb_std          number;
    v_loa_kumuliert_loa_value     number;
    
    v_zk_13_w_schnitt_ueb         number;
    v_zk_13_w_schnitt_feiertag    number;
    v_zk_13_w_schnitt_krank       number;
    v_zk_13_w_schnitt_kugk        number;
    v_zk_13_w_schnitt_urlaub      number;
    v_zk_sonder_urlaub            number;
    v_zk_soll_stunden             number;

    v_uer_std_aus_K_U_F           number;
    v_uer_std_aus_K_U_F_S         number;
    v_uer_std_aus_K_U_F_13W       number;
    

    v_konten_bh_id                pzm_konten_bh.konten_bh_id%type;
    v_pzm_loa_komto               pzm_lohnarten%rowtype;
    v_pzm_lonhnart                pzm_lohnarten%rowtype;
    v_pers_tarif_name             pzm_personal.tarif_name%type;
    v_tarifmodell                 pzm_tarifmodelle%rowtype;
    v_schicht_modelle             pzm_schicht_modelle%rowtype;
    v_personal                    pzm_personal%rowtype;
    v_produktionsbereich          pzm_produktionsbereiche%rowtype;
    v_uk_konto                    pzm_konten%rowtype;
    v_kst_id                      pzm_personal.pers_kst_id%type;
    v_kst_id_zk                   pzm_personal.pers_kst_id%type;
    v_kst_std                     number;
    v_lohnart                     pzm_lohnarten%rowtype;
    
    v_zk_loa                      pzm_lohnarten.lz_lohnart%type;
    v_kug_loa                     pzm_lohnarten.lz_lohnart%type;
    v_kug_loa_id                  pzm_lohnarten.lz_id%type;
    v_kug_loa_value               number;
    v_kugk_loa                    pzm_lohnarten.lz_lohnart%type;
    v_kugk_loa_id                 pzm_lohnarten.lz_id%type;
    v_kugk_loa_value              number;
    v_urlaub_std_value            number;
    v_urlaub_tag_value            number;
    v_unbezahlt_std_value         number;
    v_unbezahlt_tag_value         number;
    v_operator                    varchar2(50);
    
    v_SABeginn                 date;
    v_SAEnde                   date;
    v_SAStdProTag              number;
    v_DaySAKurzname            pzm_zeiterfassung.ze_sa_kurzname%type;
    v_ze_id                    pzm_zeiterfassung.ze_id%type; 

    v_loa_kumuliert pzm_ze_loa_exp_host%rowtype;
--    v_loa_kumuliert_ext_gutsch pzm_ze_loa_exp_ext_gutsch%rowtype;


  cursor c_pzm_konten_uk is
    select t.*
      from pzm_konten t,
           pzm_lohnarten lz
     where t.sid = '01'
       and t.firma_nr = 1
       and t.pers_nr = in_pers_nr
       and t.name_kurz = nvl(lz.lz_konto_name_kurz, v_loa_kumuliert.ret_code)
       and lz.lz_id = nvl(v_loa_kumuliert.lz_id, lz.lz_id);

  --cursor c_pzm_konten_by_nr is
  --  select t.*
  --    from pzm_konten t
  --   where t.sid = '01'
  --     and t.firma_nr = 1
  --     and t.konto_nr = v_loa_kumuliert.konto_nr_korr;
       
  cursor c_loa_kumuliert_stat is
      select round(sum(t.zeaw_lz_loa_std), 3) strat_std,
             count(t.zeaw_lz_loa_std) strat_tage
        from pzm_ze_loa_ausw t,
             pzm_lohnarten lz,
             pzm_abwesenheitsarten aa
       where t.zeaw_pers_nr = in_pers_nr
         and t.zeaw_datum >= v_von_datum
         and t.zeaw_datum < v_bis_datum + 1
         and nvl(lz.lz_gueltig_ab, v_von_datum) >= v_von_datum
         and nvl(lz.lz_gueltig_bis, v_bis_datum) <= v_bis_datum
         -- AG 20200527 LOAs, die nicht übertragen werden sollen, nicht übertragen
         and lz.lz_lohnart = t.zeaw_lz_lohnart
         and lz.lz_id = t.zeaw_lz_id
         and (   (lz.lz_link_loa_id is NULL and not exists (select lz.lz_id from pzm_lohnarten lx where lx.lz_link_loa_id = lz.lz_id)) -- ggf. mit Konto aber ohne Gegenloa (Dann muss über das Konto gerechnet werden
              or  lz.lz_konto_name_kurz is NULL) -- Oder alle Einträge ohne Konto
         and aa.aa_id(+) = t.aa_id
         and v_operator like '%;' || lz.lz_operator || ';%' 
       group by
             t.zeaw_pb_id,
             t.zeaw_pers_nr,
             t.zeaw_lz_lohnart,
             --t.aa_id,
             t.zeaw_lz_id,
             lz.lz_lohnart_grp,
             nvl(t.zeaw_kst_id, get_pers_kst_id(in_pers_nr)),
             nvl(lz.lz_einheit, nvl(aa.aa_einheit, 'HH24'));
             
    cursor c_loa_kumuliert_13W is
      select *
      from (select t.zeaw_pb_id,
                   t.zeaw_pers_nr pers_nr,
                   case when in_schnittstelle = 'EXT_KW_MM'
                         then v_bis_datum
                         else add_months(trunc(min(t.zeaw_datum), 'Month'), 1) 
                         end datum,
                   t.zeaw_lz_lohnart lohnart,
                   decode(nvl(lz.lz_einheit, nvl(aa.aa_einheit, 'HH24')), 
                     'DD', count(t.zeaw_lz_loa_std),
                     round(sum(t.zeaw_lz_loa_std), 3)) loa_value, -- -WK- 13.01.2010 2 Stellig runden
                   decode(nvl(lz.lz_einheit, nvl(aa.aa_einheit, 'HH24')), 
                     'DD', 'TAG', 
                     'STD') loa_unit,
                   lz.lz_lohnart_grp loa_grp, -- t.zeaw_lz_loa_grp
                   min(t.aa_id) aa_id,
                   'N' status,
                   null ret_code,
                   null err_text,
                   0 cycle,
                   t.zeaw_lz_id,
                   nvl(v_kst_id_zk, get_pers_kst_id(in_pers_nr)) zeaw_kst_id,
                   null KONTO_NR_KORR,
                   null KONTO_VAL_KORR,
                   null KONTEN_BH_ID_KORR,
                   sysdate CREATED_DATE,
                   null CREATED_LOGIN_ID,
                   null CREATED_USER,
                   null LAST_CHANGE_DATE,
                   null LAST_CHANGE_LOGIN_ID,
                   null LAST_CHANGE_USER
              from pzm_ze_loa_ausw t,
                   pzm_lohnarten lz,
                   pzm_abwesenheitsarten aa
             where t.zeaw_pers_nr = in_pers_nr
               and t.zeaw_datum >= v_start_datum
               and t.zeaw_datum < v_ende_datum + 1
               and nvl(lz.lz_gueltig_ab, v_start_datum) >= v_start_datum
               and nvl(lz.lz_gueltig_bis, v_ende_datum) <= v_ende_datum
               -- AG 20200527 LOAs, die nicht übertragen werden sollen, nicht übertragen
               and nvl(lz.lz_is_erp_loa, 'T') != 'F'
               and lz.lz_lohnart = t.zeaw_lz_lohnart
               and lz.lz_id = t.zeaw_lz_id
               and (lz.lz_operator in ('KUGK', 'K', 'U', 'F', 'SF', 'SU') 
                    or ((      lz.lz_feiertag in ('F', 'SF')
                            or lz.lz_wochentag = 7
                            or lz.lz_wochentag = 6)
                        and lz.lz_operator is NULL
                       )
                   )
               and aa.aa_id(+) = t.aa_id
             group by
                   t.zeaw_pb_id,
                   t.zeaw_pers_nr,
                   t.zeaw_lz_lohnart,
                   t.zeaw_lz_id,
                   lz.lz_lohnart_grp,
                   nvl(lz.lz_einheit, nvl(aa.aa_einheit, 'HH24')));

    cursor c_loa_kumuliert is
      select *
      from (select t.zeaw_pb_id,
                   t.zeaw_pers_nr pers_nr,
                   case when in_schnittstelle = 'EXT_KW_MM'
                         then v_bis_datum
                         else add_months(trunc(min(t.zeaw_datum), 'Month'), 1) 
                         end datum,
                   t.zeaw_lz_lohnart lohnart,
                   decode(nvl(lz.lz_einheit, nvl(aa.aa_einheit, 'HH24')), 
                     'DD', count(t.zeaw_lz_loa_std),
                     round(sum(t.zeaw_lz_loa_std), 3)) loa_value, -- -WK- 13.01.2010 2 Stellig runden
                   decode(nvl(lz.lz_einheit, nvl(aa.aa_einheit, 'HH24')), 
                     'DD', 'TAG', 
                     'STD') loa_unit,
                   lz.lz_lohnart_grp loa_grp, -- t.zeaw_lz_loa_grp
                   min(t.aa_id) aa_id,
                   'N' status,
                   null ret_code,
                   null err_text,
                   0 cycle,
                   t.zeaw_lz_id,
                   case when in_schnittstelle != 'EXT_KW_MM' and v_tarifmodell.tarif_fest_std != 'T' and v_kst_id is not NULL
                        then v_kst_id
                        else get_pers_kst_id(in_pers_nr)
                        end zeaw_kst_id,      --nvl(t.zeaw_kst_id, get_pers_kst_id(in_pers_nr)) zeaw_kst_id,
                   null KONTO_NR_KORR,
                   null KONTO_VAL_KORR,
                   null KONTEN_BH_ID_KORR,
                   sysdate CREATED_DATE,
                   null CREATED_LOGIN_ID,
                   null CREATED_USER,
                   null LAST_CHANGE_DATE,
                   null LAST_CHANGE_LOGIN_ID,
                   null LAST_CHANGE_USER
              from pzm_ze_loa_ausw t,
                   pzm_lohnarten lz,
                   pzm_abwesenheitsarten aa
             where t.zeaw_pers_nr = in_pers_nr
               and t.zeaw_datum >= v_von_datum
               and (t.zeaw_datum < v_bis_datum + 1
                  or (    t.zeaw_datum < v_ende_datum
                      and v_start_datum = v_von_datum
                      and lz.lz_operator in ('KUGF', 'KUGK', 'KUG')
                      and in_schnittstelle = 'EXT_KW_MM'
                     )
                    )
               and nvl(lz.lz_gueltig_ab, v_von_datum) >= v_von_datum
               and nvl(lz.lz_gueltig_bis, v_bis_datum) <= v_bis_datum
               -- AG 20200527 LOAs, die nicht übertragen werden sollen, nicht übertragen
               and nvl(lz.lz_is_erp_loa, 'T') != 'F'
               and lz.lz_lohnart = t.zeaw_lz_lohnart
               and lz.lz_id = t.zeaw_lz_id
               and (   (lz.lz_link_loa_id is NULL and not exists (select lz.lz_id from pzm_lohnarten lx where lx.lz_link_loa_id = lz.lz_id)) -- ggf. mit Konto aber ohne Gegenloa (Dann muss über das Konto gerechnet werden
                    or  lz.lz_konto_name_kurz is NULL) -- Oder alle Einträge ohne Konto
               and aa.aa_id(+) = t.aa_id
               and (   (nvl(t.zeaw_kst_id, get_pers_kst_id(in_pers_nr)) = v_kst_id 
                        and (nvl(lz.lz_operator, 'XXX') not in ('KUGF', 'KUGK', 'KUG'))
                       )
                    or v_kst_id is NULL 
                    or (v_kst_id  = v_kst_id_zk and (nvl(lz.lz_operator, 'XXX') in ('KUGF', 'KUGK', 'KUG'))
                       )
                    or in_schnittstelle = 'EXT_KW_MM'
                    or v_tarifmodell.tarif_fest_std = 'T' 
                   )
             group by
                   t.zeaw_pb_id,
                   t.zeaw_pers_nr,
                   t.zeaw_lz_lohnart,
                   --t.aa_id,
                   t.zeaw_lz_id,
                   lz.lz_lohnart_grp,
                   --nvl(t.zeaw_kst_id, get_pers_kst_id(in_pers_nr)),
                   nvl(lz.lz_einheit, nvl(aa.aa_einheit, 'HH24'))
          union
            select k_loa.zeaw_pb_id,
                   k_loa.pers_nr,
                   k_loa.datum,
                   (select x.lz_lohnart from pzm_lohnarten x where k_loa.lohnart like '%;' || x.lz_lohnart || ';%' and x.lz_konto_bus = k_loa.bus) lohnart,
                   k_loa.loa_value,
                   k_loa.loa_unit,
                   k_loa.loa_grp,
                   k_loa.aa_id,
                   'N' status,
                   k_loa.lz_konto_name_kurz ret_code, -- Im retkod das Konto mitgeben
                   null err_text,
                   0 cycle,
                   (select x.lz_id from pzm_lohnarten x where k_loa.lohnart like '%;' || x.lz_lohnart || ';%' and x.lz_konto_bus = k_loa.bus) lz_id,
                   k_loa.zeaw_kst_id,
                   null KONTO_NR_KORR,
                   null KONTO_VAL_KORR,
                   null KONTEN_BH_ID_KORR,
                   sysdate CREATED_DATE,
                   null CREATED_LOGIN_ID,
                   null CREATED_USER,
                   null LAST_CHANGE_DATE,
                   null LAST_CHANGE_LOGIN_ID,
                   null LAST_CHANGE_USER
              from (select k_erg.zeaw_pb_id,
                           k_erg.pers_nr,
                           k_erg.datum,
                           ';' || stradd_distinct(k_erg.lohnart) || ';' lohnart,
                           case when sum(decode(k_erg.lz_konto_bus, 1, k_erg.loa_value, k_erg.loa_value * -1)) > 0
                                then 1
                                else 2
                                end bus,
                           sum(decode(k_erg.lz_konto_bus, 1, k_erg.loa_value, k_erg.loa_value * -1)) loa_value,
                           k_erg.loa_unit,
                           k_erg.loa_grp,
                           min(k_erg.aa_id) aa_id,
                           k_erg.lz_konto_name_kurz,
                           k_erg.zeaw_kst_id
                    from (select t.zeaw_pb_id,
                                 t.zeaw_pers_nr pers_nr,
                                 case when in_schnittstelle = 'EXT_KW_MM'
                                       then v_bis_datum
                                       else add_months(trunc(min(t.zeaw_datum), 'Month'), 1) 
                                       end datum,
                                 lz.lz_lohnart lohnart,
                                 decode(nvl(aa.aa_einheit, nvl(lz.lz_einheit, 'HH24')),
                                   'DD', count(t.zeaw_lz_loa_std),
                                   round(sum(t.zeaw_lz_loa_std), 3)) loa_value, -- -WK- 13.01.2010 2 Stellig runden
                                 decode(nvl(aa.aa_einheit, nvl(lz.lz_einheit, 'HH24')), 
                                   'DD', 'TAG', 
                                   'STD') loa_unit,
                                 lz.lz_konto_bus,
                                 lz.lz_lohnart_grp loa_grp,
                                 min(t.aa_id) aa_id,
                                 lz.lz_konto_name_kurz,
                                 nvl(v_kst_id_zk, get_pers_kst_id(in_pers_nr)) zeaw_kst_id
                            from pzm_ze_loa_ausw t,
                                 pzm_lohnarten lz,
                                 pzm_abwesenheitsarten aa
                           where 1=1
                             and t.zeaw_pers_nr = in_pers_nr
                             and t.zeaw_datum >= v_von_datum
                             and t.zeaw_datum < v_bis_datum + 1
                             and nvl(lz.lz_gueltig_ab, v_von_datum) >= v_von_datum
                             and nvl(lz.lz_gueltig_bis, v_bis_datum) <= v_bis_datum
                             -- AG 20200527 LOAs, die nicht übertragen werden sollen, nicht übertragen
                             and nvl(lz.lz_is_erp_loa, 'T') != 'F'
                             and lz.lz_id = t.zeaw_lz_id
                             and (  lz.lz_link_loa_id is NOT NULL 
                                  or exists (select lz.lz_id from pzm_lohnarten lx where lx.lz_link_loa_id = lz.lz_id)) -- mit Konto Gegenloa (Dann muss über das Konto gerechnet werden)
                             and aa.aa_id(+) = t.aa_id
                             and (v_kst_id = v_kst_id_zk)
                           group by
                                 t.zeaw_pb_id,
                                 t.zeaw_pers_nr,
                                 lz.lz_lohnart,
                                 lz.lz_konto_bus,
                                 lz.lz_lohnart_grp,
                                 lz.lz_konto_name_kurz,
                                 --nvl(t.zeaw_kst_id, get_pers_kst_id(in_pers_nr)),
                                nvl(aa.aa_einheit, nvl(lz.lz_einheit, 'HH24'))) k_erg
                    group by k_erg.zeaw_pb_id,
                           k_erg.pers_nr,
                           k_erg.datum,
                           k_erg.loa_unit,
                           k_erg.lz_konto_name_kurz,
                           k_erg.zeaw_kst_id,
                           k_erg.loa_grp) k_loa
          )
      order by decode(ret_code, 'ZK', 1, 0),
               zeaw_lz_id;

    cursor c_loa_zk is
      select decode(nvl(aa.aa_einheit, nvl(lz.lz_einheit, 'HH24')),
               'DD', count(t.zeaw_lz_loa_std),
               round(sum(t.zeaw_lz_loa_std), 3)) loa_value
        from pzm_ze_loa_ausw t,
             pzm_lohnarten lz,
             pzm_abwesenheitsarten aa
       where 1=1
         and t.zeaw_pers_nr = in_pers_nr
         and t.zeaw_datum >= v_von_datum
         and t.zeaw_datum < v_bis_datum_kst + 1
         and nvl(lz.lz_gueltig_ab, v_von_datum) >= v_von_datum
         and nvl(lz.lz_gueltig_bis, v_bis_datum_kst) <= v_bis_datum_kst
         -- AG 20200527 LOAs, die nicht übertragen werden sollen, nicht übertragen
         and nvl(lz.lz_is_erp_loa, 'T') != 'F'
         and lz.lz_id = t.zeaw_lz_id
         and lz.lz_konto_name_kurz = 'ZK'
         and (  lz.lz_link_loa_id is NOT NULL 
              or exists (select lz.lz_id from pzm_lohnarten lx where lx.lz_link_loa_id = lz.lz_id)) -- mit Konto Gegenloa (Dann muss über das Konto gerechnet werden)
         and aa.aa_id(+) = t.aa_id
         and (v_kst_id = v_kst_id_zk or in_schnittstelle = 'EXT_KW_MM' or v_tarifmodell.tarif_fest_std != 'T')
       group by
             t.zeaw_pb_id,
             t.zeaw_pers_nr,
             lz.lz_lohnart,
             lz.lz_konto_bus,
             lz.lz_lohnart_grp,
             lz.lz_konto_name_kurz,
             --nvl(t.zeaw_kst_id, get_pers_kst_id(in_pers_nr)),
             nvl(aa.aa_einheit, nvl(lz.lz_einheit, 'HH24'));
              
    cursor c_loa_kug is
      select decode(nvl(aa.aa_einheit, nvl(lz.lz_einheit, 'HH24')),
               'DD', count(t.zeaw_lz_loa_std),
               round(sum(t.zeaw_lz_loa_std), 3)) loa_value
        from pzm_ze_loa_ausw t,
             pzm_lohnarten lz,
             pzm_abwesenheitsarten aa
       where 1=1
         and t.zeaw_pers_nr = in_pers_nr
         and t.zeaw_datum >= v_von_datum
         and t.zeaw_datum < v_bis_datum + 1
         and nvl(lz.lz_gueltig_ab, v_von_datum) >= v_von_datum
         and nvl(lz.lz_gueltig_bis, v_bis_datum) <= v_bis_datum
         -- AG 20200527 LOAs, die nicht übertragen werden sollen, nicht übertragen
         and nvl(lz.lz_is_erp_loa, 'T') != 'F'
         and lz.lz_id = t.zeaw_lz_id
         and lz.lz_operator = 'KUGK'
         and (  lz.lz_link_loa_id is NOT NULL 
              or exists (select lz.lz_id from pzm_lohnarten lx where lx.lz_link_loa_id = lz.lz_id)) -- mit Konto Gegenloa (Dann muss über das Konto gerechnet werden)
         and aa.aa_id(+) = t.aa_id
         and (v_kst_id = v_kst_id_zk or in_schnittstelle = 'EXT_KW_MM' or v_tarifmodell.tarif_fest_std = 'T' )
       group by
             t.zeaw_pb_id,
             t.zeaw_pers_nr,
             lz.lz_lohnart,
             lz.lz_konto_bus,
             lz.lz_lohnart_grp,
             lz.lz_konto_name_kurz,
             --nvl(t.zeaw_kst_id, get_pers_kst_id(in_pers_nr)),
             nvl(aa.aa_einheit, nvl(lz.lz_einheit, 'HH24'));
              
    cursor c_loa_konto is
      select lz.*
        from pzm_lohnarten lz
       where lz.lz_konto_name_kurz is not NULL
         and nvl(lz.lz_gueltig_ab, v_von_datum) >= v_von_datum
         and nvl(lz.lz_gueltig_bis, v_bis_datum) <= v_bis_datum
         and lz.lz_is_erp_loa = 'T'
         and lz.lz_link_loa_id is not NULL;   -- lz_loa_id ist nicht null und gegen LOA ist vorhanden (Z.B. Stundenkonto

    cursor c_ze_tagessatz_kst_id is
      select nvl(t.ts_day_kst_id, get_pers_kst_id(in_pers_nr)) ts_day_kst_id,
             sum(t.ts_day_arb_std + t.ts_day_ueb_std + t.ts_day_flex_std) ts_std
        from PZM_ZE_Tagessatz t
       where t.ts_pers_nr = in_pers_nr
         and t.ts_datum >= v_von_datum
         and t.ts_datum <= v_bis_datum
       group by nvl(t.ts_day_kst_id, get_pers_kst_id(in_pers_nr));

    v_kst_tab t_kst_std_tab;

    v_kst_idx                           integer;
    v_kst_idx_loa                       integer;
    v_kst_idx_max                       integer;
    v_kst_sum_std                       number;

    CURSOR c_produktionsbereich IS
      SELECT *
        FROM pzm_produktionsbereiche pb
       WHERE pb.pb_id = get_pers_pb_id(in_pers_nr);

    CURSOR c_tarifmodel is
      select *
        from pzm_tarifmodelle t
       where t.tarif_name = v_pers_tarif_name;

    cursor c_check is
      select count(*)
        from pzm_ze_loa_exp_host t
       where t.pers_nr = in_pers_nr
         and t.datum = v_folgemonat_datum
         and t.status != 'N';

    cursor c_check_exp_ext_gutsch is
      select count(*)
        from pzm_ze_loa_exp_ext_gutsch t
       where t.pers_nr = in_pers_nr
         and t.datum >= v_start_datum
         and t.datum <= v_ende_datum
         and t.status != 'N';
    
    /*
    cursor c_ze_loa_exp_ext_gutsch is
      select * 
        from pzm_ze_loa_exp_ext_gutsch t
       where t.pers_nr = in_pers_nr
         and (t.datum = v_bis_datum or t.datum = v_ende_datum)
         and t.konto_val_korr > 0
         and t.konten_bh_id_korr is not NULL;
    
    cursor c_ze_loa_exp_host is           -- kontokorrekturen aus Monats LOA
      select * 
        from pzm_ze_loa_exp_host t
       where t.pers_nr = in_pers_nr
         and t.datum = v_folgemonat_datum
         and t.konto_val_korr != 0
         and t.konten_bh_id_korr is not NULL;
    */

    cursor c_vertragsart is
      select pv.*
        from pzm_personal p, pzm_vertragsarten pv
       where pv.va_id = p.pers_vertragsart
         and p.pers_nr = in_pers_nr;

    cursor c_loa_stat_cfg is
      select t.*
        from pzm_ze_loa_statistik_cfg t
       where t.lz_gueltig = 1;
    
    cursor c_pb_abteilung is
      select t.abt_pb_id
        from pzm_abteilungen t
       where t.abt_id = get_pers_abt_id(in_pers_nr);

    v_vertragsart          pzm_vertragsarten%rowtype;
    v_loa_stat_cfg         pzm_ze_loa_statistik_cfg%rowtype;
    
    v_pb_abteilung pzm_personal.pers_pb_id%type;

    v_loa_zk number;
    v_loa_kug number;
    v_check_anz number;
    v_pers_schnittst number;
    v_found boolean;
    v_found_ue boolean;
    v_found_kto boolean;
    v_ext_kw_mm_done boolean;
    v_loa_zk_done boolean;
    
  begin
    
    v_found_ue := false;
    v_result := '(E?)'; -- unKnown Error
    if in_schnittstelle = 'EXT_KW_MM' -- kalenderwoche und Monat
    then
      v_start_datum := trunc(in_ende_datum, 'iw');
      v_von_datum := v_start_datum;
      v_ende_datum := v_von_datum + 6;
      v_bis_datum := v_von_datum;

      OPEN c_check_exp_ext_gutsch;
      fetch c_check_exp_ext_gutsch into v_check_anz;
      v_found := c_check_exp_ext_gutsch%found;
      close c_check_exp_ext_gutsch;
      
      if v_found and v_check_anz > 0
      and nvl(in_reset, 'N') != 'T'
      then
        -- bereits erfolgt
        v_result := '(E101) DATEN_SCHON_UEBERTRAGEN';
        return(v_result);
      end if;
    else
      if in_jahr <= 99
      then
        v_von_datum := to_date('01.' || lpad(in_monat, 2, '0')  || '.' || lpad(in_jahr, 2, '0'), 'dd.mm.yy');
      else
        v_von_datum := to_date('01.' || lpad(in_monat, 2, '0') || '.' || lpad(in_jahr, 4, '0'), 'dd.mm.yyyy');
      end if;
      v_folgemonat_datum := add_months(v_von_datum, 1);
      v_bis_datum := last_day(v_von_datum);
      v_start_datum := v_von_datum;
      v_ende_datum := v_bis_datum;
      
      select nvl(t.pers_schnittstelle, 0) pd_schnittstelle
        into v_pers_schnittst
        from pzm_personal t
       where t.pers_nr = in_pers_nr;

      if v_pers_schnittst != 1
      then
        v_result := '(E101) PZM_PERSONAL.PERS_SCHNITTSTELLE=FALSE'; -- S = pers_nr nicht für Schnittstellenübergabe konfiguriert
        return(v_result);
      end if;

      open c_check;
      fetch c_check into v_check_anz;
      v_found := c_check%found;
      close c_check;
      
      if v_found and v_check_anz > 0
      then
        v_found_ue := true;
        -- bereits erfolgt und meken
      end if;

      if v_found and v_check_anz > 0
      and nvl(in_reset, 'N') != 'T'
      then
        -- bereits erfolgt
        v_result := '(E101) DATEN_SCHON_UEBERTRAGEN';
        return(v_result);
      end if;

    end if;

    OPEN c_pb_abteilung;
    FETCH c_pb_abteilung into v_pb_abteilung;
    CLOSE c_pb_abteilung;
    
    if not pzm_p_base.get_personal(in_pers_nr, v_personal)
    then
      v_personal.pers_kappung_me_ab_flx_std := NULL;
      v_result := '(E101) PZM_PERSONAL Tabelleeintrag fehlt'; -- S = pers_nr nicht für Schnittstellenübergabe konfiguriert
      return(v_result);
    else
      OPEN c_produktionsbereich;
      FETCH c_produktionsbereich INTO v_produktionsbereich;
      CLOSE c_produktionsbereich;
      
      if nvl(v_produktionsbereich.pb_schnittstelle, 'LODAS') != in_schnittstelle
      then
          v_result := '(E101) PZM_PERSONAL.PERS_SCHNITTSTELLE=FALSE ' || in_schnittstelle || ' != ' || nvl(v_produktionsbereich.pb_schnittstelle, 'LODAS'); -- S = pers_nr nicht für Schnittstellenübergabe konfiguriert
          return(v_result);
      end if;
    end if;
    
    v_pers_tarif_name := get_pers_tarif_name(in_pers_nr);
    v_tarifmodell := NULL;
    if v_pers_tarif_name is not NULL
    then
      OPEN c_tarifmodel;
      FETCH c_tarifmodel into v_tarifmodell;
      CLOSE c_tarifmodel;
    end if;
    
    OPEN c_vertragsart;
    FETCH c_vertragsart into v_vertragsart;
    if c_vertragsart%NOTFOUND
    then
      v_vertragsart := NULL;
    end if;  
    CLOSE c_vertragsart;
    if v_vertragsart.va_bis_monat_ende_sim = 'T'
    and trunc(sysdate) <= v_bis_datum
    then
      v_pzm_sim_on := true;
      v_datum := trunc(sysdate);
      
      v_datum := v_datum;
      if get_schicht_daten(in_pers_nr, v_datum, v_datum,
                                   v_DaySAKurzname, v_SABeginn, v_SAEnde, v_SAStdProTag) != 1
      then
        v_SAStdProTag := 8;
      end if;
      v_ze_id := PZM_P_ZEITERFASSUNG.find_offener_eintrag_id(in_pers_nr, v_datum);
      if v_ze_id > 0
      then
        delete pzm_ze_tagessatz t               -- Sicherheitshalber löschen versuchen. Wenn ZE offen ist eine tagessatz immer falsch
         where t.ts_pers_nr = in_pers_nr
           and t.ts_datum = v_datum;
        insert into pzm_ze_tagessatz            -- jetzt daten default eintragen
          (ts_pers_nr, 
           ts_datum, 
           ts_aa_id, 
           ts_day_kst_id, 
           ts_abwesenheit, 
           ts_day_abw_std, 
           ts_day_arb_std, 
           ts_day_ueb_std, 
           ts_day_korr_std, 
           ts_day_flex_std, 
           ts_day_anw_std, 
           ts_day_pause_std, 
           ts_day_arb_std_g_min, 
           ts_day_pause_bez_std, 
           ts_day_abt_id, 
           ts_day_pb_id
           )
           values
          ( in_pers_nr, 
            v_datum, 
            NULL, 
            get_pers_kst_id(in_pers_nr),
            NULL, 
            0, 
            v_SAStdProTag, 
            0, 
            0,
            0,
            0,
            0, 
            0, 
            0, 
            get_pers_abt_id(in_pers_nr), 
            get_pers_pb_id(in_pers_nr)
          );
      end if;
      v_datum := v_datum + 1;
        
      --schicht_daten
      -- Call the procedure
      LOOP
        -- Call the procedure
        update_pers_ze_tag(p_pers_nr => in_pers_nr,
                           p_datum => v_datum,
                           p_result => v_result,
                           p_res_info => v_res_info,
                           p_zaehler => 0);
        commit;
        v_datum := v_datum + 1;
        exit when v_datum > v_bis_datum;
      end loop;
      
      v_pzm_sim_on := false;
      v_result := NULL;
    end if;
    
    select t.konto_nr into v_loa_kumuliert.konto_nr_korr
      from pzm_konten t
     where t.sid = '01'
       and t.firma_nr = 1
       and t.pers_nr = in_pers_nr
       and t.name_kurz = 'ZK';

    begin
      if v_tarifmodell.tarif_fest_std = 'T'
      and v_tarifmodell.tarif_fest_std_je_periode is not NULL
      and v_vertragsart.va_loa_stunden_abrechnung = 'T'
      then
        delete pzm_konten_bh t
          where t.konto_nr = v_loa_kumuliert.konto_nr_korr
            and t.pers_nr = in_pers_nr
            and t.typ = 'B'                                         -- Kein korrekturbuchungen löschen
            and (t.zk_start >= v_start_datum and t.zk_start <= v_ende_datum);
      end if;
    exception
      when others then
        v_result := '(E199) Korrektur für Konto ' || to_char(v_loa_kumuliert.konto_nr_korr) || ' Nicht möglich.'; -- Konto nicht mehr da?
    end;

    if in_schnittstelle = 'EXT_KW_MM' -- kalenderwoche und Monat
    then
      begin
        delete pzm_konten_bh t
          where t.konto_nr = v_loa_kumuliert.konto_nr_korr
            and (  t.info = 'pers_LOA_ME_KORR Flexistunden Saldo'
                or t.info = 'pers_LOA_ME_KORR_TARIF Flexistunden Saldo'
                or t.info = 'pers_LOA_AUSZ_AUSTRITT Flexistunden Saldo')
            and t.pers_nr = in_pers_nr
            and (t.zk_start >= v_start_datum and t.zk_start <= v_ende_datum);
      exception
        when others then
          v_result := '(E199) Korrektur für Konto ' || to_char(v_loa_kumuliert.konto_nr_korr) || ' Nicht möglich.'; -- Konto nicht mehr da?
      end;

      delete pzm_ze_loa_exp_ext_gutsch t -- Falls etwas da was noch nicht übertragen ist, dann löschen
       where t.pers_nr = in_pers_nr
         and t.datum >=  v_start_datum
         and t.datum <=  v_ende_datum;
      
    else
      begin
        delete pzm_konten_bh t
          where t.konto_nr = v_loa_kumuliert.konto_nr_korr
            and (  t.info = 'pers_LOA_ME_KORR Flexistunden Saldo'
                or t.info = 'pers_LOA_ME_KORR_TARIF Flexistunden Saldo'
                or t.info = 'pers_LOA_AUSZ_AUSTRITT Flexistunden Saldo')
            and t.pers_nr = in_pers_nr
            and t.zk_start = v_bis_datum;
      exception
        when others then
          v_result := '(E199) Korrektur für Konto ' || to_char(v_loa_kumuliert.konto_nr_korr) || ' Nicht möglich.'; -- Konto nicht mehr da?
      end;
      
      if v_found_ue
      and nvl(v_vertragsart.va_bis_monat_ende_sim, 'F') != 'T'
      then
        v_found_ue := false;  
      end if;
      
      delete pzm_ze_loa_exp_host t -- Falls etwas da was noch nicht übertragen ist, dann löschen
       where t.pers_nr = in_pers_nr
         and t.datum =  v_folgemonat_datum;
      delete pzm_ze_loa_statistik_exp_host t -- Falls etwas da was noch nicht übertragen ist, dann löschen
       where t.pers_nr = in_pers_nr
         and t.datum =  v_folgemonat_datum;
    end if;
    commit;

    v_stat_value_arb_std := 0;       
    v_zk_monat_diff_kug := 0;
    v_zk_monat_diff_kug_vmonat := 0;
    v_kug_loa := NULL;
    v_kug_loa_value := 0;
    v_kugk_loa := NULL;
    v_kugk_loa_value := 0;
    v_zk_monat_diff := 0;
    
    v_anz_arb_tage := get_anz_arbeitstage_R32(in_pers_nr,
                                              v_von_datum,
                                              v_ende_datum);    -- p_ende_datum => :p_ende_datum,
    -- Sollstunden ermiteln
    if pzm_p_base.get_schicht_modell(in_pers_nr, v_schicht_modelle)
    then
      v_day_schnitt := pzm_utils.pzm_get_sm_durch_std_tag(v_schicht_modelle.sm_name);
      v_anz_arb_stunden := v_anz_arb_tage * v_day_schnitt;
    else
      v_anz_arb_stunden := v_anz_arb_tage * 8;
      v_day_schnitt :=  8;
      v_schicht_modelle.kappung_te_ab_flx_std := 10;
    end if;

    if v_tarifmodell.tarif_13w_schnitt = 'T'
    then
      v_13_w_schnitt := c_loa_13_w_schnitt(in_pers_nr, v_von_datum);
      v_13_w_schnitt_value := 0;
      if v_13_w_schnitt > nvl(v_personal.pers_kappung_te_ab_flx_std, v_schicht_modelle.kappung_te_ab_flx_std)
      then
        v_13_w_schnitt := nvl(v_personal.pers_kappung_te_ab_flx_std, v_schicht_modelle.kappung_te_ab_flx_std);
      end if;
    else
      v_13_w_schnitt := v_day_schnitt;
    end if;

    if v_13_w_schnitt < v_day_schnitt
    then
      v_13_w_schnitt := v_day_schnitt;
    end if;

    v_kst_sum_std := 0;
    v_kst_idx := 0;
    v_kst_id_zk := NULL;
    v_kst_idx_loa := 0;

    
    v_bis_datum_kst := v_bis_datum;
    v_bis_datum := v_ende_datum;

    OPEN c_ze_tagessatz_kst_id;
    LOOP
      FETCH c_ze_tagessatz_kst_id into v_kst_id, v_kst_std;
      EXIT when c_ze_tagessatz_kst_id%NOTFOUND;
      
      v_kst_idx := v_kst_idx + 1;
      v_kst_tab(v_kst_idx).kst_id := v_kst_id;
      v_kst_tab(v_kst_idx).kst_std := v_kst_std;
      v_kst_sum_std := v_kst_sum_std + v_kst_std;
    end LOOP;
    v_kst_idx_max := v_kst_idx;
    CLOSE c_ze_tagessatz_kst_id;

    v_bis_datum := v_bis_datum_kst;
    v_bis_datum_kst := v_ende_datum;

    --v_zk_loa := 0;
    v_kug_loa := 0;
      
    v_uer_std_aus_K_U_F := 0;
    --v_uer_std_aus_K_U_F_S := 0;
    v_uer_std_aus_K_U_F_13W := 0;
    v_f_stunden_loa := 0;
    ---v_ueb_stunden := 0;
    v_ueb_stunden_loa := 0;
    v_ueb_stunden_loa2 := 0;
    v_ueb_stunden_13w := 0;
    v_ueb_stunden_13w_korr := 0;
    v_zk_fuer_sundenlohn_std := 0;
    v_feiertags_std := 0;

    --v_zk_13_w_schnitt_ueb         := 0;
    v_zk_13_w_schnitt_feiertag    := 0;
    v_zk_monat_diff_ges           := 0;
    v_zk_13_w_schnitt_krank       := 0;
    v_zk_13_w_schnitt_kugk        := 0;
    --v_zk_13_w_schnitt_urlaub      := 0;
    v_zk_sonder_urlaub            := 0;
    v_F_U_K_stunden                 := 0;

    v_kst_std := 0;
    -- Prozente ausrechnen 
    v_kst_idx := 0;
    LOOP
      v_kst_idx := v_kst_idx + 1;
      if v_kst_sum_std > 0
      then
        v_kst_tab(v_kst_idx).kst_proz := v_kst_tab(v_kst_idx).kst_std / v_kst_sum_std;
        if v_kst_tab(v_kst_idx).kst_std > v_kst_std
        then
          v_kst_id := v_kst_tab(v_kst_idx).kst_id;
          v_kst_std :=  v_kst_tab(v_kst_idx).kst_std;
          v_kst_id_zk := v_kst_id;
        end if;
      else
        if v_kst_idx_max > 0
        then
          v_kst_id := v_kst_tab(v_kst_idx).kst_id;
          v_kst_std :=  v_kst_tab(v_kst_idx).kst_std;
          v_kst_tab(v_kst_idx).kst_proz := 1 / v_kst_idx_max;
          v_kst_id_zk := v_kst_id;
        else
          v_kst_id_zk := v_kst_id;
          v_kst_tab(v_kst_idx).kst_proz := 1;
        end if;
      end if;
      EXIT when v_kst_idx >= v_kst_idx_max;
    end LOOP;

    --if v_tarifmodell.tarif_13w_schnitt = 'T'
    --then
      OPEN c_loa_kumuliert_13W;
      LOOP
        FETCH c_loa_kumuliert_13W into v_loa_kumuliert;
        EXIT when c_loa_kumuliert_13W%NOTFOUND;
        if pzm_p_base.get_lohnart(v_loa_kumuliert.lz_id, v_lohnart)
        then
          if v_lohnart.lz_operator in ('F', 'SF')       -- Feiertag 13 W Schnitt
          then
            v_f_stunden_loa := v_loa_kumuliert.loa_value;
          end if;
          if (v_lohnart.lz_wochentag = 7)
          and v_lohnart.lz_operator is NULL
          then
            v_ueb_stunden_loa2 := v_ueb_stunden_loa2 - v_loa_kumuliert.loa_value; -- Sonntag abziehen
          end if;
          if nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'T'  -- Gehalt
          then
            if v_lohnart.lz_wochentag = 7 
            --or v_lohnart.lz_wochentag = 6
            and v_lohnart.lz_operator is NULL
            then
              if v_tarifmodell.tarif_13w_schnitt = 'T'
              then
                --v_uer_std_aus_K_U_F_13W := v_uer_std_aus_K_U_F_13W + round(v_loa_kumuliert.loa_value * (v_13_w_schnitt + v_loa_kumuliert.loa_value) / (v_day_schnitt + v_loa_kumuliert.loa_value), 3);
                v_ueb_stunden_13w := round(v_loa_kumuliert.loa_value * (v_uer_std_aus_K_U_F_13W + v_loa_kumuliert.loa_value) / (v_uer_std_aus_K_U_F + v_loa_kumuliert.loa_value), 3);
                --v_uer_std_aus_K_U_F_13W := v_uer_std_aus_K_U_F_13W + round(v_loa_kumuliert.loa_value * (v_uer_std_aus_K_U_F_13W + v_loa_kumuliert.loa_value) / (v_uer_std_aus_K_U_F + v_loa_kumuliert.loa_value), 3);
              end if;
            end if;
          end if;
            
          if nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'F'  -- Gehalt
          and ( v_lohnart.lz_operator in ('KUGK', 'K', 'U', 'SU', 'F', 'SF', 'SU')
             or (( v_lohnart.lz_feiertag in ('F', 'SF')
                or v_lohnart.lz_wochentag = 7
                or v_lohnart.lz_wochentag = 6)
                and v_lohnart.lz_operator is NULL
                )
              )
          then
            if v_lohnart.lz_operator not in ('F', 'SF')
            then
              v_ueb_stunden_loa2 := v_ueb_stunden_loa2 + v_loa_kumuliert.loa_value;
            end if;
            if in_schnittstelle != 'EXT_KW_MM'
            and v_tarifmodell.tarif_13w_schnitt = 'T'
            then
              v_uer_std_aus_K_U_F := v_uer_std_aus_K_U_F + v_loa_kumuliert.loa_value;
              v_loa_kumuliert.loa_value := round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
              v_uer_std_aus_K_U_F_13W := v_uer_std_aus_K_U_F_13W + v_loa_kumuliert.loa_value;
            end if;
          elsif v_lohnart.lz_feiertag is not NULL
          then
            v_ueb_stunden_loa2 := v_ueb_stunden_loa2 - v_loa_kumuliert.loa_value; -- Sonntag abziehen
          elsif v_lohnart.lz_operator in ('KUGK', 'K', 'U', 'F', 'SF', 'SU')           -- Urlaub, Krank oder Feiertag 13 W Schnitt
          then
            if v_lohnart.lz_operator not in ('F', 'SF')
            then
              v_ueb_stunden_loa2 := v_ueb_stunden_loa2 + v_loa_kumuliert.loa_value;
            end if;
            if in_schnittstelle != 'EXT_KW_MM'
            and v_tarifmodell.tarif_13w_schnitt = 'T'
            then
              v_13_w_schnitt_value := v_13_w_schnitt_value +round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
              v_uer_std_aus_K_U_F := v_uer_std_aus_K_U_F + v_loa_kumuliert.loa_value;
              v_uer_std_aus_K_U_F_S := v_loa_kumuliert.loa_value;
              if v_lohnart.lz_einheit = 'HH24'                 -- In Stunden geführt
              and v_13_w_schnitt != v_day_schnitt
              then
                v_loa_kumuliert.loa_value := round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
              end if;
              v_uer_std_aus_K_U_F_13W := v_uer_std_aus_K_U_F_13W + v_loa_kumuliert.loa_value;
            end if;
          end if;
        end if;
      end LOOP;
      CLOSE c_loa_kumuliert_13W;
    --end if;

    --v_ab_ueb_stunden := nvl(v_tarifmodell.tarif_ueb_std, v_anz_arb_stunden);
    v_ext_kw_mm_done := false;
    v_loa_zk_done := false;
    OPEN c_ze_tagessatz_kst_id;
    LOOP
      v_kst_idx_loa := v_kst_idx_loa + 1;

      if in_schnittstelle != 'EXT_KW_MM'
      and v_tarifmodell.tarif_fest_std != 'T' 
      then
        FETCH c_ze_tagessatz_kst_id into v_kst_id, v_kst_std;
        EXIT when c_ze_tagessatz_kst_id%NOTFOUND;
        if v_kst_idx_max = 0
        then
          v_kst_idx :=1;
          v_kst_idx_max :=1;
          v_kst_tab(v_kst_idx).kst_id := v_kst_id;
          v_kst_tab(v_kst_idx).kst_std := v_kst_std;
          v_kst_sum_std := v_kst_sum_std + v_kst_std;
        end if;
      else
        if v_ext_kw_mm_done
        then
          if v_bis_datum < v_ende_datum
          and v_tarifmodell.tarif_fest_std != 'T' 
          then
            v_bis_datum := v_bis_datum + 1;
            v_von_datum := v_von_datum + 1;
          else
            EXIT;
          end if;
        else
          FETCH c_ze_tagessatz_kst_id into v_kst_id, v_kst_std;
        end if;
      end if;
      v_ext_kw_mm_done := true;     -- in_schnittstelle = 'EXT_KW_MM' ohne Kostenstellenaufteilung
      
      v_zk_loa := 0;
      v_kug_loa := 0;
      v_kugk_loa := 0;
      
      v_ueb_stunden := 0;
      v_ueb_stunden_loa := 0;
      v_ueb_stunden_13w := 0;
      v_ueb_stunden_13w_korr := 0;
      v_zk_fuer_sundenlohn_std := 0;

      v_zk_13_w_schnitt_ueb         := 0;
      v_zk_13_w_schnitt_feiertag    := 0;
      v_zk_13_w_schnitt_krank       := 0;
      v_zk_13_w_schnitt_kugk        := 0;
      v_zk_13_w_schnitt_urlaub      := 0;
      v_zk_sonder_urlaub            := 0;
      v_F_U_K_stunden               := 0;
      v_zk_monat_saldo_true         := false;
      v_zk_monat_saldo_kug_done := false;


      v_zk_soll_stunden := get_pers_monat_soll_std(in_pers_nr, v_kst_id, v_von_datum);
      v_loa_kumuliert.pb_id := get_pers_pb_id(in_pers_nr);
      if in_schnittstelle = 'EXT_KW_MM' -- Bei Extern besser setzen
      then
        v_loa_kumuliert.pb_id := nvl(v_produktionsbereich.pb_bemerkungen, v_produktionsbereich.pb_id);
      end if;
      

      begin
        if in_schnittstelle != 'EXT_KW_MM'
        and v_tarifmodell.tarif_fest_std != 'T' 
        then 
          OPEN c_loa_zk;
          FETCH c_loa_zk into v_loa_zk;
          CLOSE c_loa_zk;

          OPEN c_loa_kug;
          FETCH c_loa_kug into v_loa_kug;
          CLOSE c_loa_kug;
        else
          v_loa_zk := 0;
          v_loa_kug :=0;
        end if;
        
        v_loa_zk := nvl(v_loa_zk, 0);
        v_loa_kug := nvl(v_loa_kug, 0);
        
        open c_loa_kumuliert;        -- lesen alle berechneten Lohnzulagen
        loop
          fetch c_loa_kumuliert into v_loa_kumuliert;
          exit when c_loa_kumuliert%notfound;
          
          if in_schnittstelle = 'EXT_KW_MM' -- Die gesamte Abhandlung Zeitkonto ist nicht für Externe Zeitarbeiter
          then
            v_loa_kumuliert.pb_id := nvl(v_produktionsbereich.pb_bemerkungen, v_produktionsbereich.pb_id);
          end if;
          
          if pzm_p_base.get_lohnart(v_loa_kumuliert.lz_id, v_lohnart)
          and v_tarifmodell.tarif_fest_std = 'T'  -- Tarifmodell hat feste Stunden für einen Zeitraum
          and v_tarifmodell.tarif_13w_schnitt ='F'
          then
            if ( v_lohnart.lz_operator in ('K', 'U', 'SU', 'F', 'SF', 'SU')
                )
            then
              v_F_U_K_stunden := v_F_U_K_stunden + v_loa_kumuliert.loa_value;
            end if;
          end if;
          
          if (in_schnittstelle != 'EXT_KW_MM'         -- Die gesamte Abhandlung Zeitkonto ist nicht für Externe Zeitarbeiter
            and v_tarifmodell.tarif_fest_std != 'T')  -- Tarifmodell hat feste Stunden für einen Zeitraum
          or v_loa_kumuliert.ret_code != 'ZK'
          then 
            if v_loa_zk = 0 -- Alles KUG und es kommt kein ZK mehr.
            and pzm_p_base.get_lohnart(v_loa_kumuliert.lz_id, v_lohnart)
            and v_lohnart.lz_operator = 'KUG'
            then
              v_kug_loa := v_loa_kumuliert.lohnart;
              v_kug_loa_id := v_loa_kumuliert.lz_id;
              v_kug_loa_value := v_loa_kumuliert.loa_value;
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_id = (select max(loax.lz_link_loa_id)
                                    from pzm_lohnarten loax
                                   where loax.lz_link_loa_id is not NULL
                                     and loax.lz_alternativ_loa_id is NULL
                                     and loax.lz_konto_name_kurz = 'ZK');
              v_loa_kumuliert.loa_value := 0;
              v_loa_kumuliert.ret_code := 'ZK';
            end if;

            if v_loa_zk = 0 -- Alles KUG und es kommt kein ZK mehr.
            and v_loa_kug = 0 -- Alles KUG und es kommt kein ZK mehr.
            and pzm_p_base.get_lohnart(v_loa_kumuliert.lz_id, v_lohnart)
            and v_lohnart.lz_operator = 'KUGK'
            then
              v_kugk_loa := v_loa_kumuliert.lohnart;
              v_kugk_loa_id := v_loa_kumuliert.lz_id;
              v_kugk_loa_value := v_loa_kumuliert.loa_value;
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_id = (select max(loax.lz_link_loa_id)
                                    from pzm_lohnarten loax
                                   where loax.lz_link_loa_id is not NULL
                                     and loax.lz_alternativ_loa_id is NULL
                                     and loax.lz_konto_name_kurz = 'ZK');
              v_loa_kumuliert.loa_value := 0;
              v_loa_kumuliert.ret_code := 'ZK';
            end if;
            if v_loa_zk = 0 -- Es kommt kein ZK mehr.
            and v_loa_kug = 0 -- und kein KUG mehr.
            and v_kugk_loa = 0
            and v_kst_id = v_kst_id_zk
            and v_ueb_stunden_13w = 0
            and nvl(v_uer_std_aus_K_U_F_13W - v_uer_std_aus_K_U_F, 0) > 0
            then
              v_ueb_stunden_13w := nvl(v_uer_std_aus_K_U_F_13W - v_uer_std_aus_K_U_F, 0);
            end if;
            
            if in_schnittstelle != 'EXT_KW_MM' -- Die gesamte Abhandlung Zeitkonto ist nicht für Externe Zeitarbeiter
            then
              if v_loa_kumuliert.ret_code = 'ZK'
              then
                
                v_loa_kumuliert.konto_val_korr := NULL;
                v_kappung_flex_std := get_pers_kappung_flex_std(in_pers_nr);
                v_ueb_std := 0;
                v_ueb_std_proz := 0;
                v_korr_std := 0;
                v_korr_std_abz := 0;
                v_korr_std_korrekt := false;
                
                v_zk_13_w_schnitt_ueb := v_loa_kumuliert.loa_value + v_uer_std_aus_K_U_F_13W - v_uer_std_aus_K_U_F;
                v_ueb_stunden_13w := nvl(v_uer_std_aus_K_U_F_13W - v_uer_std_aus_K_U_F, 0);
                v_loa_zk_done := true;
                -- Wert direkt zum Zeitpunkt Lesen
                v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,   
                                                                             in_pers_nr,
                                                                             'ZK',
                                                                             v_bis_datum), 0);
                if v_zk_monat_saldo < nvl(v_tarifmodell.tarif_fest_std_akz_minus, 0) * -1 -- Minus ist unterschritten
                and nvl(v_tarifmodell.tarif_fest_std_akz_minus, 0) > 0    -- Aber MAX Minus im Tarif gesetzt
                and v_loa_kumuliert.loa_value < 0
                then
                  v_loa_kumuliert.ret_code := 'ZK';
                  v_loa_kumuliert.kst_id := nvl(v_kst_id, get_pers_kst_id(in_pers_nr));
                  open c_pzm_konten_uk;               -- konto lesen
                  fetch c_pzm_konten_uk into v_uk_konto;
                  v_found_kto := c_pzm_konten_uk%found;
                  close c_pzm_konten_uk;
                  v_loa_kumuliert.ret_code := NULL;
                  v_konten_bh_id := NULL;
                  if v_uk_konto.konto_nr is not NULL
                  then
                    v_zk_monat_saldo := (v_zk_monat_saldo + nvl(v_tarifmodell.tarif_fest_std_akz_minus, 0)) * -1;
                    if v_zk_monat_saldo > v_loa_kumuliert.loa_value * -1
                    then
                      v_zk_monat_saldo := v_loa_kumuliert.loa_value * -1;
                      v_loa_kumuliert.loa_value := 0;
                    else
                      v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value + v_zk_monat_saldo;
                    end if;
                    pzm_kontoverwaltung.zugang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                      in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                      v_zk_monat_saldo,
                                                      'pers_LOA_ME_KORR_TARIF ' || v_uk_konto.name, 'B',
                                                      get_pers_abt_id(in_pers_nr),
                                                      v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                      
                    update pzm_konten_bh t
                       set t.zk_start = v_loa_kumuliert.datum - 1,
                           t.buch_datum = v_loa_kumuliert.datum - 1,
                           t.zk_aa_id = null
                     where t.sid = '01'
                       and t.firma_nr = 1
                       and t.konten_bh_id = v_konten_bh_id;
                    if nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'F'
                    then
                      v_ueb_std := v_zk_monat_saldo * -1;  -- Bei Gehalt über Überstunden - abziehen
                    end if;
                    -- Wert direkt zum Zeitpunkt Lesen
                    v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,   
                                                                                 in_pers_nr,
                                                                                 'ZK',
                                                                                 v_bis_datum), 0);
                  end if;
                end if;

                -- if v_loa_kumuliert.loa_value >= 0 -- -AG- 2026.03.21 Falsch, hier muss auch KUG geschaut werden
                if v_loa_kumuliert.loa_value + v_kug_loa_value + v_kugk_loa_value >= 0 -- KUG ist wie ZK zu betrachten
                and v_loa_kumuliert.loa_value + v_uer_std_aus_K_U_F_13W - v_uer_std_aus_K_U_F < v_kug_loa_value + v_kugk_loa_value -- im plus abewr wegen KUG im Minus
                then
                  
                  orignal_loa_value := v_loa_kumuliert.loa_value;

                  select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                    from pzm_lohnarten loa
                   where loa.lz_id = (select loax.lz_link_loa_id from pzm_lohnarten loax where loax.lz_id = v_loa_kumuliert.lz_id);
                  
                  v_zk_monat_saldo_old := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                                    in_pers_nr,
                                                                                    'ZK',
                                                                                    v_von_datum - 1), 0); -- Saldo Monatsbegin
                  v_zk_monat_diff_kug_vmonat := v_zk_monat_saldo - v_zk_monat_saldo_old;
                  if v_kug_loa_value > v_ueb_stunden_13w
                  then 
                    v_kug_loa_value := v_kug_loa_value - v_ueb_stunden_13w;
                  else
                    v_kugk_loa_value := v_kugk_loa_value + v_kug_loa_value - v_ueb_stunden_13w;
                    v_kug_loa_value := 0;
                  end if;
                  v_ueb_stunden_13w := 0;

                  if v_zk_monat_saldo < 0
                  or (v_zk_monat_saldo_old < 0 and v_kug_loa_value > 0)
                  then
                    if v_loa_kumuliert.loa_value > 0
                    then
                      v_zk_monat_saldo := v_loa_kumuliert.loa_value;
                      if v_kug_loa_value > v_zk_monat_saldo
                      then
                        v_kug_loa_value := v_kug_loa_value - v_zk_monat_saldo;
                      else
                        v_kugk_loa_value := v_kugk_loa_value + v_kug_loa_value - v_zk_monat_saldo;
                        v_kug_loa_value := 0;
                      end if;
                    else
                      v_zk_monat_saldo := 0;
                    end if;
                    v_loa_kumuliert.loa_value := 0;
                    v_zk_monat_saldo_kug_done := True;
                  else
                    v_zk_monat_saldo_kug_done := false;     
                    if v_zk_monat_saldo > v_kug_loa_value + v_kugk_loa_value
                    then
                      v_zk_monat_saldo := v_kug_loa_value + v_kugk_loa_value;
                      v_loa_kumuliert.loa_value := v_kug_loa_value + v_kugk_loa_value - v_loa_kumuliert.loa_value;
                      v_kug_loa_value := 0;
                      v_kugk_loa_value := 0;
                      v_uer_std_aus_K_U_F_13W := 0;
                      v_uer_std_aus_K_U_F := 0;
                    else
                      v_zk_monat_saldo_kug_done := True;
                      v_uer_std_aus_K_U_F_13W := 0;
                      v_uer_std_aus_K_U_F := 0;
                      v_loa_kumuliert.loa_value := v_zk_monat_saldo - v_loa_kumuliert.loa_value;
                      if v_kug_loa_value > v_zk_monat_saldo
                      then
                        v_kug_loa_value := v_kug_loa_value - v_zk_monat_saldo;
                      else
                        v_kugk_loa_value := v_kugk_loa_value + v_kug_loa_value - v_zk_monat_saldo;
                        v_kug_loa_value := 0;
                      end if;
                    end if;
                  end if;
                  v_loa_kumuliert.konto_val_korr := v_kugk_loa_value + v_kug_loa_value; -- Damit KUG gebucht wird
                  if v_zk_monat_saldo > 0 -- Konto ist hat Wert
                  then
                    open c_pzm_konten_uk;               -- konto lesen
                    fetch c_pzm_konten_uk into v_uk_konto;
                    v_found_kto := c_pzm_konten_uk%found;
                    close c_pzm_konten_uk;
                    pzm_kontoverwaltung.abgang_buchen('01', 1, v_uk_konto.konto_nr,
                                                      in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                      v_zk_monat_saldo,
                                                      'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                      get_pers_abt_id(in_pers_nr),
                                                      v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                    v_loa_kumuliert.konten_bh_id_korr := v_konten_bh_id;
                    update pzm_konten_bh t
                       set t.zk_start = v_loa_kumuliert.datum - 1,
                           t.buch_datum = v_loa_kumuliert.datum - 1,
                           t.zk_aa_id = null
                     where t.sid = '01'
                       and t.firma_nr = 1
                       and t.konten_bh_id = v_konten_bh_id;
                  end if;
                else
                  v_zk_monat_saldo_kug_done := False;
                  orignal_loa_value := v_loa_kumuliert.loa_value;
                  v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - (v_kug_loa_value + v_kugk_loa_value);
                  
                  if v_loa_kumuliert.loa_value + v_uer_std_aus_K_U_F_13W - v_uer_std_aus_K_U_F > 0 -- Nur 13 W Schnitt
                  then
                    if v_loa_kumuliert.loa_value <= 0 -- Nur wegen 13 W Schnitt Zugang
                    then -- Dann auf dei korrektte LOA wechseln wenn möglich
                      select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                        from pzm_lohnarten loa
                       where loa.lz_link_loa_id = v_loa_kumuliert.lz_id;
                    end if;
                    if v_kappung_flex_std > 0
                    then
                      select sum(t.ze_std) into v_rb_stunden    -- Ermitteln der Stunden Rufbereitschaft
                       from pzm_zeiterfassung t
                      where t.ze_status = 7
                        and t.ze_pers_nr = in_pers_nr
                        and t.ze_schicht_tag >= v_start_datum
                        and t.ze_schicht_tag <= v_ende_datum;
                        
                      if nvl(v_rb_stunden, 0) > 0                   -- RB Stunden dürfen nicht gekappt werden
                      then
                        if v_kappung_flex_std > 0
                        then
                          if v_loa_kumuliert.loa_value <= v_rb_stunden
                          then 
                            v_kappung_flex_std := 0;
                          elsif v_kappung_flex_std >= v_loa_kumuliert.loa_value - v_rb_stunden
                          then
                            v_kappung_flex_std := v_loa_kumuliert.loa_value - v_rb_stunden;
                          else 
                            v_kappung_flex_std := v_kappung_flex_std - v_rb_stunden;
                          end if;
                        end if;
                      end if;
                      v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                                    in_pers_nr,
                                                                                    'ZK',
                                                                                    v_von_datum - 1), 0);

                      if nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'LOA_KAPP_ZUGANG_SALDO_MINUS'), 'T') = 'F'
                      and v_zk_monat_saldo < 0
                      and v_kappung_flex_std > 0
                      then
                        if v_zk_monat_saldo + v_loa_kumuliert.loa_value <= 0
                        then
                          v_kappung_flex_std := 0;
                        else
                          if v_loa_kumuliert.loa_value - v_kappung_flex_std + v_zk_monat_saldo < 0
                          then
                            v_kappung_flex_std := v_zk_monat_saldo + v_loa_kumuliert.loa_value;
                            if v_kappung_flex_std < 0
                            then
                              v_kappung_flex_std := 0;
                            end if;
                          end if;
                        end if;
                      end if;
                      
                      if v_loa_kumuliert.loa_value + v_ueb_stunden_13w <= v_kappung_flex_std
                      then
                        v_ueb_stunden_13w := 0;
                        v_loa_kumuliert.konto_val_korr := v_loa_kumuliert.loa_value;
                        v_loa_kumuliert.loa_value := 0;
                      else
                        if v_loa_kumuliert.loa_value <= v_kappung_flex_std
                        then
                          v_loa_kumuliert.konto_val_korr := v_loa_kumuliert.loa_value;
                          v_loa_kumuliert.loa_value := 0;
                          v_ueb_stunden_13w := v_ueb_stunden_13w - v_kappung_flex_std + v_loa_kumuliert.konto_val_korr;
                          if v_ueb_stunden_13w < 0
                          then
                            v_ueb_stunden_13w := 0;
                          end if;
                        else
                          v_loa_kumuliert.konto_val_korr := v_kappung_flex_std;
                          v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_kappung_flex_std;
                        end if;
                      end if;
                      v_korr_std_abz := v_loa_kumuliert.konto_val_korr;
                    end if;
                    -- Wert direkt zum Zeitpunkt Lesen
                    v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                                 in_pers_nr,
                                                                                 'ZK',
                                                                                 v_bis_datum), 0)
                                                                                 + (v_kug_loa_value + v_kugk_loa_value);
                    v_pers_max_frei_stunden := v_personal.pers_max_freistd;
                    -- Überstunden bis Grenze auszahlen
                    if v_vertragsart.va_bis_std_auszahlen_zeiteinheit is not NULL -- Es gibt eine zeiteiheit für Stunden auszahlen
                    and v_vertragsart.va_bis_std_auszahlen > 0                    -- Und der wert ist auch gepflegt.
                    then --  v_vertragsart.va_bis_std_auszahlen_zeiteinheit anpassen, dass ausgezahlt wird
                      v_arb_stunden := pzm_utils.get_pers_arb_std(in_pers_nr,
                                                                  NULL,
                                                                  v_von_datum,
                                                                  v_bis_datum,   -- Ermittlung der gearbeiteten Stunden
                                                                  true, -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                                  true -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T'
                                                                  );  -- Krank und Urlaub kommen dazu?

                      if v_vertragsart.va_bis_std_auszahlen_zeiteinheit = 'MM'
                      then
                        v_aus_arb_stunden := v_vertragsart.va_bis_std_auszahlen; -- Ermittlung der Sollstunden
                      elsif v_vertragsart.va_bis_std_auszahlen_zeiteinheit = 'WW'
                      then
                        v_aus_arb_stunden := v_vertragsart.va_bis_std_auszahlen / 
                                             pzm_p_schicht_tag.get_anz_schicht_tage(in_pers_nr, v_start_datum, v_start_datum + 6) * 
                                             v_anz_arb_tage;
                      elsif v_vertragsart.va_bis_std_auszahlen_zeiteinheit = 'DD'
                      then
                        v_aus_arb_stunden := v_vertragsart.va_bis_std_auszahlen * v_anz_arb_tage; -- Ermittlung der Sollstunden
                      end if;
                      
                       
                      if v_aus_arb_stunden >= v_ueb_stunden_13w + v_arb_stunden
                      then
                        v_pers_max_frei_stunden := 0;                -- Alles auszahlen
                      elsif v_aus_arb_stunden >= v_arb_stunden
                        and v_pers_max_frei_stunden > (v_zk_monat_saldo + v_ueb_stunden_13w + v_arb_stunden) - v_aus_arb_stunden
                      then
                        v_pers_max_frei_stunden := (v_zk_monat_saldo + v_ueb_stunden_13w + v_arb_stunden) - v_aus_arb_stunden;
                      end if;
                    end if;
                    -- Prüfung max Flex-Stunden
                    if v_loa_kumuliert.loa_value + v_ueb_stunden_13w > 0 -- Ueberstunden
                    and v_zk_monat_saldo + v_ueb_stunden_13w > v_pers_max_frei_stunden -- Konto ist übervoll aus den Buchungen 
                    and v_loa_kumuliert.lohnart is not NULL
                    then
                      v_korr_std := v_zk_monat_saldo - v_pers_max_frei_stunden; -- Wieviel zu viel ist auf dem Konto
                      
                      if v_korr_std > 0
                      then
                        /* -- Dies wird jetzt korrekt im Tagessatz gebucht (LOA 503 ARBSTD)
                        -- Zus. Stunden Mehrarbeit, die ggf. mit in die Ueberstunden müssen
                        select nvl(sum(t.ze_std), 0) into v_ueb_std    -- Abwesenheiten mit LOA für Arbeitsstunden
                         from pzm_zeiterfassung t,
                              pzm_abwesenheitsarten aa,
                              pzm_lohnarten l
                        where 1=1
                          and t.ze_aa_status = aa.aa_id
                          and aa.lz_id = l.lz_id
                          and l.lz_operator = 'ARBSTD'
                          and t.ze_pers_nr = in_pers_nr
                          and t.ze_schicht_tag >= v_start_datum
                          and t.ze_schicht_tag <= v_ende_datum;
                        */
                        v_ueb_std := 0;
                        if v_zk_monat_saldo - v_loa_kumuliert.loa_value <= v_pers_max_frei_stunden
                        then
                          v_ueb_std := v_ueb_std + v_zk_monat_saldo + v_ueb_stunden_13w - v_pers_max_frei_stunden; -- Wieviel zu viel ist auf dem Konto
                          --v_ueb_std := v_ueb_std + v_zk_monat_saldo - v_pers_max_frei_stunden; -- Wieviel zu viel ist auf dem Konto
                        else
                          v_ueb_std := v_ueb_std + v_loa_kumuliert.loa_value + v_ueb_stunden_13w;
                        end if;
                        if v_korr_std >= v_loa_kumuliert.loa_value + (v_kug_loa_value + v_kugk_loa_value)  -- Mehr als im Monat geleistete eberstunden
                        then
                          v_korr_std := v_loa_kumuliert.loa_value + (v_kug_loa_value + v_kugk_loa_value);  -- Dann geleistetetn Stunden = Korregieren und Auszahlen
                          v_ueb_stunden_13w := v_loa_kumuliert.loa_value + v_ueb_stunden_13w;
                          v_loa_kumuliert.loa_value := 0;                             -- LOA-Value dann 0
                        else
                          v_korr_std_korrekt := true;
                          v_korr_std := v_korr_std;
                          v_ueb_stunden_13w := v_ueb_stunden_13w + v_korr_std;
                          v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - round(v_korr_std, 3); -- Sonst Differenz für die korrektur merken
                        end if;
                      else
                        if v_korr_std = 0
                        then
                          v_korr_std_korrekt := true;
                          if v_zk_monat_saldo = v_pers_max_frei_stunden -- Konto ist genau voll mit ZK-Buchungen
                          then
                            v_ueb_std := v_ueb_stunden_13w; -- 13W Schnitt ist Überstunde
                          else
                            v_ueb_std := v_loa_kumuliert.loa_value + v_ueb_stunden_13w;
                            v_loa_kumuliert.loa_value := 0;
                          end if;
                        else
                          if (v_korr_std) + v_ueb_stunden_13w - (v_kug_loa_value + v_kugk_loa_value) < 0
                          and (v_kug_loa_value + v_kugk_loa_value) > 0
                          then
                            -- Wert direkt zum Zeitpunkt Lesen
                            v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                                         in_pers_nr,
                                                                                         'ZK',
                                                                                         v_bis_datum), 0);
                            v_zk_monat_saldo_old := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                                              in_pers_nr,
                                                                                              'ZK',
                                                                                              v_von_datum - 1), 0); -- Saldo Monatsbegin
                            v_ueb_std := 0;
                            v_loa_kumuliert.loa_value := (v_ueb_stunden_13w + v_loa_kumuliert.loa_value);
                            v_ueb_stunden_13w := v_ueb_std;
                            v_korr_std := v_zk_monat_saldo - v_zk_monat_saldo_old + (v_loa_kumuliert.loa_value * -1);
                            v_korr_std_korrekt := true;
                          else
                            v_ueb_std := (v_korr_std) + v_ueb_stunden_13w - (v_kug_loa_value + v_kugk_loa_value);
                            v_loa_kumuliert.loa_value := (v_ueb_stunden_13w + v_loa_kumuliert.loa_value) - v_ueb_std; 
                            v_ueb_stunden_13w := v_ueb_std;
                          end if;
                        end if;
                      end if;
                    else
                      -- Wert direkt zum Zeitpunkt Lesen
                      v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                                   in_pers_nr,
                                                                                   'ZK',
                                                                                   v_bis_datum), 0);
                      v_zk_monat_saldo_old := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                                        in_pers_nr,
                                                                                        'ZK',
                                                                                        v_von_datum - 1), 0); -- Saldo Monatsbegin
                      if 1=1
                      -- and v_zk_monat_saldo - v_zk_monat_saldo_old - v_loa_kumuliert.loa_value != 0
                      and v_loa_kumuliert.loa_value != 0
                      then
                        v_korr_std_korrekt := true;
                        --v_korr_std := ((v_zk_monat_saldo - v_zk_monat_saldo_old) - v_ueb_stunden_13w) * -1;
                        --v_korr_std :=  + v_ueb_stunden_13w - (v_zk_monat_saldo - v_zk_monat_saldo_old) - v_loa_kumuliert.loa_value;
                        v_loa_kumuliert.loa_value := (v_ueb_stunden_13w + v_loa_kumuliert.loa_value);
                        v_korr_std := (orignal_loa_value - v_loa_kumuliert.loa_value);
                        v_korr_std_abz := 0; -- Dann diesen Wert ignorieren
                        if v_loa_kumuliert.loa_value > 0
                        then
                          v_ueb_stunden_13w := 0;
                        end if;
                      end if;  
                    end if;  
                    v_loa_kumuliert.konto_val_korr := v_korr_std + v_korr_std_abz;
                      
                    if v_loa_kumuliert.konto_val_korr < 0 -- Es muss etwas aufgebaut werden
                    or (v_loa_kumuliert.konto_val_korr = 0 -- Es ist eigndlich nichts zu korrigieren
                    and  (v_loa_kumuliert.loa_value >= 0 or (v_loa_kumuliert.loa_value < 0 and v_loa_kumuliert.loa_value + v_ueb_stunden_13w > 0))
                    and  v_ueb_stunden_13w > 0)
                    then
                      if v_loa_kumuliert.konto_val_korr < 0
                      then 
                        v_loa_kumuliert.konto_val_korr := v_loa_kumuliert.konto_val_korr * -1;
                        --v_ueb_stunden_13w := 0;
                      else
                        if v_loa_kumuliert.loa_value < 0
                        then
                          if v_loa_kumuliert.konto_val_korr = 0
                          then
                            v_loa_kumuliert.konto_val_korr := v_ueb_stunden_13w + v_loa_kumuliert.loa_value;  
                            --v_loa_kumuliert.konto_val_korr := v_ueb_stunden_13w;
                          else
                            v_loa_kumuliert.konto_val_korr := v_ueb_stunden_13w;
                          end if;
                          v_loa_kumuliert.loa_value := v_ueb_stunden_13w + v_loa_kumuliert.loa_value;
                          v_ueb_stunden_13w := 0;
                        else
                          if v_ueb_std != v_ueb_stunden_13w
                          then
                            if not v_korr_std_korrekt
                            then
                              v_loa_kumuliert.konto_val_korr := v_ueb_stunden_13w;
                              --v_loa_kumuliert.loa_value := v_loa_kumuliert.konto_val_korr * -1;
                              v_loa_kumuliert.loa_value := v_loa_kumuliert.konto_val_korr;
                            end if;
                            v_ueb_stunden_13w := 0;
                          end if;
                        end if;
                      end if;
                      if v_loa_kumuliert.konto_val_korr > 0
                      then
                        open c_pzm_konten_uk;               -- konto lesen
                        fetch c_pzm_konten_uk into v_uk_konto;
                        v_found_kto := c_pzm_konten_uk%found;
                        close c_pzm_konten_uk;
                        pzm_kontoverwaltung.zugang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                          in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                          v_loa_kumuliert.konto_val_korr,
                                                          'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                          get_pers_abt_id(in_pers_nr),
                                                          v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                        v_loa_kumuliert.konten_bh_id_korr := v_konten_bh_id;
                        update pzm_konten_bh t
                           set t.zk_start = v_loa_kumuliert.datum - 1,
                               t.buch_datum = v_loa_kumuliert.datum - 1,
                               t.zk_aa_id = null
                         where t.sid = '01'
                           and t.firma_nr = 1
                           and t.konten_bh_id = v_konten_bh_id;
                                                              
                        v_loa_kumuliert.konto_nr_korr := v_uk_konto.konto_nr;
                        v_loa_kumuliert.konto_val_korr := v_loa_kumuliert.konto_val_korr * -1;
                      end if;
                    end if;

                    if v_loa_kumuliert.konto_val_korr > 0 -- Es ist zu korrigieren
                    then
                      if v_loa_kumuliert.loa_value > 0
                      and not v_korr_std_korrekt
                      then
                        v_loa_kumuliert.konto_val_korr := v_loa_kumuliert.loa_value + v_ueb_stunden_13w;
                      end if;
                      open c_pzm_konten_uk;               -- konto lesen
                      fetch c_pzm_konten_uk into v_uk_konto;
                      v_found_kto := c_pzm_konten_uk%found;
                      close c_pzm_konten_uk;
                      pzm_kontoverwaltung.abgang_buchen('01', 1, v_uk_konto.konto_nr,
                                                        in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                        v_loa_kumuliert.konto_val_korr,
                                                        'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                        get_pers_abt_id(in_pers_nr),
                                                        v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                      v_loa_kumuliert.konten_bh_id_korr := v_konten_bh_id;
                      update pzm_konten_bh t
                         set t.zk_start = v_loa_kumuliert.datum - 1,
                             t.buch_datum = v_loa_kumuliert.datum - 1,
                             t.zk_aa_id = null
                       where t.sid = '01'
                         and t.firma_nr = 1
                         and t.konten_bh_id = v_konten_bh_id;
                      --if v_loa_kumuliert.loa_value != 0
                      --then
                      --  v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - round(v_loa_kumuliert.konto_val_korr, 3);
                      --end if;
                                                            
                      v_loa_kumuliert.konto_nr_korr := v_uk_konto.konto_nr;
                    else
                      v_loa_kumuliert.konto_val_korr := v_loa_kumuliert.konto_val_korr * -1;
                    end if;
                    /*
                    if v_loa_kumuliert.loa_value > 0
                    then
                      v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value + v_ueb_stunden_13w;
                      v_ueb_stunden_13w := 0;
                    end if;
                    */
                    v_zk_monat_diff := v_loa_kumuliert.loa_value; -- Hier wird sich v_zk_fuer_sundenlohn_std immer gemerkt - Ohne Differenz Überstunden
                    v_zk_monat_loa := 0;
                    if v_zk_monat_diff > 0
                    then
                      v_zk_fuer_sundenlohn_std := (v_loa_kumuliert.loa_value) * -1; -- Stundenaufbau vom Stundenlohn immer abziehen.
                    end if;

                    if nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'LOA_FLEX_ZUGANG_IN_MINUS'), 'T') = 'T'
                    then
                      v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value * -1;
                    end if;
                    
                    if  v_loa_kumuliert.loa_value != 0
                    and v_loa_kumuliert.lohnart is not NULL
                    and v_kst_id = v_kst_id_zk
                    then
                      v_zk_loa := v_loa_kumuliert.lohnart;
                      if nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'T'  -- Kein Gehalt?
                      then
                        if in_schnittstelle = 'EXT_KW_MM'
                        then
                          insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                           v_bis_datum,
                                                           v_personal.pers_vname, 
                                                           v_personal.pers_nname,
                                                           v_pb_abteilung);
                        else
                          if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                          then
                            v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                          end if;
                          insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
                        end if;
                        v_loa_kumuliert.konto_nr_korr := NULL;
                        v_loa_kumuliert.konto_val_korr := NULL;
                        v_loa_kumuliert.konto_val_korr := NULL;
                        v_loa_kumuliert.konten_bh_id_korr := NULL;
                      end if;
                      if pzm_p_base.get_lohnart_by_alternative_lz_id(v_loa_kumuliert.lz_id, v_lohnart)
                      and v_lohnart.lz_operator = 'ERP_ZUS_ZK'
                      then
                        v_loa_kumuliert.lz_id   := v_lohnart.lz_id;
                        v_loa_kumuliert.lohnart := v_lohnart.lz_lohnart;
                        if in_schnittstelle = 'EXT_KW_MM'
                        then
                          insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                           v_bis_datum,
                                                           v_personal.pers_vname, 
                                                           v_personal.pers_nname,
                                                           v_pb_abteilung);
                        else
                          if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                          then
                            v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                          end if;
                          insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
                        end if;
                        v_loa_kumuliert.konto_nr_korr := NULL;
                        v_loa_kumuliert.konto_val_korr := NULL;
                        v_loa_kumuliert.konto_val_korr := NULL;
                        v_loa_kumuliert.konten_bh_id_korr := NULL;
                      end if;
                    end if;
          -----------------------------------------------------          
                    if v_ueb_std > 0 
                    then
                      select min(loa.lz_lohnart), min(loa.lz_id) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                        from pzm_lohnarten loa,
                             pzm_pers_lohn_zulagen p_lz
                       where loa.lz_typ = 'UEB_STD'
                         and loa.lz_operator = 'UESTD'
                         and loa.lz_id = p_lz.lz_id(+)
                         and in_pers_nr = p_lz.pers_nr(+)
                         and v_von_datum - 1 <= nvl(p_lz.gueltig_datum_bis(+), v_von_datum - 1)
                         and v_von_datum - 1 >= nvl(p_lz.gueltig_datum_von(+), v_von_datum - 1);
                      v_ueb_stunden_loa := v_ueb_std;
                      v_ueb_stunden := v_ueb_std;
                      if v_loa_kumuliert.loa_value = 0
                      then
                        v_ueb_stunden_13w := v_ueb_std;
                      end if;
                      v_loa_kumuliert.loa_value := v_ueb_std;
                      if v_tarifmodell.tarif_ueb_proz_wie_ueb_auszahlung = 'T'
                      then
                        v_ueb_std_proz := v_ueb_std;
                      end if;
                      --v_ueb_stunden_13w := v_loa_kumuliert.loa_value;
                      -- -AG- lesen der gebuchten Ueberstunden
                      v_stat_value_arb_std := v_stat_value_arb_std + v_loa_kumuliert.loa_value;
                      v_loa_kumuliert.konto_nr_korr := NULL;
                      v_loa_kumuliert.konto_val_korr := NULL;
                      v_loa_kumuliert.konto_val_korr := NULL;
                      v_loa_kumuliert.konten_bh_id_korr := NULL;
                      if  v_loa_kumuliert.loa_value != 0
                      and v_loa_kumuliert.lohnart is not NULL
                      then
                        if in_schnittstelle = 'EXT_KW_MM'
                        then
                          insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                           v_bis_datum,
                                                           v_personal.pers_vname, 
                                                           v_personal.pers_nname,
                                                           v_pb_abteilung);
                        else
                          select sum(loa.loa_value) into v_ueb_std
                            from pzm_ze_loa_exp_host loa
                           where loa.pers_nr = in_pers_nr
                             and loa.lz_id = v_loa_kumuliert.lz_id
                             and loa.datum = v_loa_kumuliert.datum;
                          if v_ueb_std != 0
                          then
                            delete pzm_ze_loa_exp_host loa
                             where loa.pers_nr = in_pers_nr
                               and loa.lz_id = v_loa_kumuliert.lz_id
                               and loa.datum = v_loa_kumuliert.datum;
                            v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value + v_ueb_std;
                          end if;
                          if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                          then
                            v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                          end if;
                          insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
                        end if;
                      end if;
                    end if;
                    v_loa_kumuliert.konto_nr_korr := NULL;
                    v_loa_kumuliert.konto_val_korr := NULL;
                    v_loa_kumuliert.konten_bh_id_korr := NULL;
                    v_loa_kumuliert.loa_value := NULL;
                  else 
                    if v_ueb_stunden_13w > 0 -- 13W Schnitt wieder draufrechnen
                    then
                      open c_pzm_konten_uk;               -- konto lesen
                      fetch c_pzm_konten_uk into v_uk_konto;
                      v_found_kto := c_pzm_konten_uk%found;
                      close c_pzm_konten_uk;
                      v_loa_kumuliert.konto_val_korr := v_ueb_stunden_13w;
                      v_ueb_stunden_13w_korr := v_loa_kumuliert.konto_val_korr;
                      pzm_kontoverwaltung.zugang_buchen('01', 1, v_uk_konto.konto_nr,
                                                        in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                        v_ueb_stunden_13w,
                                                        'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                        get_pers_abt_id(in_pers_nr),
                                                        v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                      v_loa_kumuliert.konten_bh_id_korr := v_konten_bh_id;
                      update pzm_konten_bh t
                         set t.zk_start = v_loa_kumuliert.datum - 1,
                             t.buch_datum = v_loa_kumuliert.datum - 1,
                             t.zk_aa_id = null
                       where t.sid = '01'
                         and t.firma_nr = 1
                         and t.konten_bh_id = v_konten_bh_id;
                      v_loa_kumuliert.konto_nr_korr := v_uk_konto.konto_nr;
                    end if; 
                    v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value * -1;
                    v_zk_monat_loa := v_loa_kumuliert.loa_value;
                  end if;
                end if;
              else
                if pzm_p_base.get_lohnart(v_loa_kumuliert.lz_id, v_lohnart)
                then
                  orignal_loa_value := v_loa_kumuliert.loa_value;
                  if nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'F'  -- Gehalt
                  and ( v_lohnart.lz_operator in ('KUGK', 'K', 'U', 'SU', 'F', 'SF', 'SU')
                     or (( v_lohnart.lz_feiertag in ('F', 'SF')
                        or v_lohnart.lz_wochentag = 7
                        or v_lohnart.lz_wochentag = 6)
                        and v_lohnart.lz_operator is NULL
                        )
                      )
                  then
                    if v_lohnart.lz_operator in ('SU')                          -- Sonderurlaub
                    then
                        v_zk_sonder_urlaub := v_zk_sonder_urlaub + v_loa_kumuliert.loa_value + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                    elsif v_lohnart.lz_operator in ('K')               -- Krank 13 W Schnitt
                    then
                      v_zk_13_w_schnitt_krank := v_zk_13_w_schnitt_krank + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                    elsif v_lohnart.lz_operator in ('KUGK')            -- KUG Krank 13 W Schnitt
                    then
                      v_zk_13_w_schnitt_kugk  := v_zk_13_w_schnitt_kugk + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                    elsif v_lohnart.lz_operator in ('F', 'SF')       -- Feiertag 13 W Schnitt
                    then
                      v_zk_13_w_schnitt_feiertag := v_zk_13_w_schnitt_feiertag + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                      --v_f_stunden_loa := v_loa_kumuliert.loa_value;
                    elsif v_lohnart.lz_operator in ('U')             -- Urlaub 13 W Schnitt
                    then
                      v_zk_13_w_schnitt_urlaub := v_zk_13_w_schnitt_urlaub + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                    end if;

                    --v_ueb_stunden_loa2 := v_ueb_stunden_loa2 + v_loa_kumuliert.loa_value;
                    v_loa_kumuliert.loa_value := round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                    v_ueb_stunden_loa := v_ueb_stunden_loa + v_loa_kumuliert.loa_value;
                    if v_lohnart.lz_feiertag not in ('F', 'SF')       -- Feiertagszulage muss auch bei Gehalt ausgewiesen werden
                    or v_lohnart.lz_operator is not NULL              -- Feiertagszulage hat hier NULL
                    then
                      v_loa_kumuliert.loa_value := 0;
                    end if;
                    --if ( v_lohnart.lz_wochentag = 7)
                    --and v_lohnart.lz_operator is NULL
                    --then
                    --  v_ueb_stunden_loa2 := v_ueb_stunden_loa2 - orignal_loa_value; -- Sonntag wieder abziehen
                    --end if;
                  else
                    orignal_loa_value := v_loa_kumuliert.loa_value;
                    if v_lohnart.lz_operator in ('SU')                          -- Sonderurlaub
                    then
                        v_zk_sonder_urlaub := v_zk_sonder_urlaub + v_loa_kumuliert.loa_value + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                    end if;
                    if v_lohnart.lz_operator in ('KUGK', 'K', 'U', 'F', 'SF', 'SU')           -- Urlaub, Krank oder Feiertag 13 W Schnitt
                    then
                      v_ueb_stunden_loa := v_ueb_stunden_loa + v_loa_kumuliert.loa_value;
                      --v_ueb_stunden_loa2 := v_ueb_stunden_loa2 + v_loa_kumuliert.loa_value;
                      --v_13_w_schnitt_value := v_13_w_schnitt_value +round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                      if v_lohnart.lz_operator in ('K')               -- Krank 13 W Schnitt
                      then
                        v_zk_13_w_schnitt_krank := v_zk_13_w_schnitt_krank + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                      elsif v_lohnart.lz_operator in ('KUGK')            -- KUG Krank 13 W Schnitt
                      then
                        v_zk_13_w_schnitt_kugk  := v_zk_13_w_schnitt_kugk + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                      elsif v_lohnart.lz_operator in ('F', 'SF')       -- Feiertag 13 W Schnitt
                      then
                        v_zk_13_w_schnitt_feiertag := v_zk_13_w_schnitt_feiertag + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                        --v_f_stunden_loa := v_loa_kumuliert.loa_value;
                      elsif v_lohnart.lz_operator in ('U')             -- Urlaub 13 W Schnitt
                      then
                        v_zk_13_w_schnitt_urlaub := v_zk_13_w_schnitt_urlaub + round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                      end if;

                      if v_lohnart.lz_einheit = 'HH24'                 -- In Stunden geführt
                      and v_13_w_schnitt != v_day_schnitt
                      then
                        v_loa_kumuliert.loa_value := round(v_loa_kumuliert.loa_value * v_13_w_schnitt / v_day_schnitt, 3);
                      end if;
                    end if;
                    --if ( v_lohnart.lz_wochentag = 7)
                    --and v_lohnart.lz_operator is NULL
                    --then
                    --  v_ueb_stunden_loa2 := v_ueb_stunden_loa2 - orignal_loa_value; -- Sonntag wieder abziehen
                    --end if;
                  end if;
                end if;
                if v_lohnart.lz_operator = 'KUG'
                then
                  v_kug_loa := v_loa_kumuliert.lohnart;
                  v_kug_loa_id := v_loa_kumuliert.lz_id;
                  v_kug_loa_value := v_loa_kumuliert.loa_value;
                end if;
                if v_lohnart.lz_operator = 'KUGK'
                then
                  v_kugk_loa := v_loa_kumuliert.lohnart;
                  v_kugk_loa_id := v_loa_kumuliert.lz_id;
                  v_kugk_loa_value := v_loa_kumuliert.loa_value;
                end if;
              end if;
            end if;
          end if;

          if in_schnittstelle = 'EXT_KW_MM' -- Die gesamte Abhandlung Zeitkonto ist nicht für Externe Zeitarbeiter
          and v_loa_kumuliert.ret_code = 'ZK'
          then
            if v_loa_kumuliert.loa_value > 0
            then 
              v_ueb_stunden_loa := v_loa_kumuliert.loa_value + v_ueb_stunden_loa;
            end if;
            v_loa_kumuliert.loa_value := 0;
            v_loa_kumuliert.lohnart := NULL;
            v_loa_kumuliert.konto_val_korr := 0;
          end if;

          if (v_loa_kumuliert.konto_val_korr > 0
           or v_loa_kumuliert.loa_value != 0)
          and v_loa_kumuliert.kst_id is not NULL
          and (v_loa_kumuliert.lohnart != nvl(v_kug_loa, '000') or v_loa_zk = 0)
          and (v_loa_kumuliert.lohnart != nvl(v_kugk_loa, '000') or (v_loa_zk = 0 and v_loa_kug = 0))
          then
            if (v_zk_monat_saldo_kug_done = false or v_loa_kumuliert.loa_value != 0)
            or nvl(v_loa_kumuliert.ret_code, 'X') != 'ZK'
            then
              if v_loa_kumuliert.ret_code = 'ZK' -- 13 W Schnitt
              then
                v_zk_monat_saldo_true := true;
                if v_tarifmodell.tarif_fest_std != 'T'
                then
                  v_loa_kumuliert.loa_value :=  v_loa_kumuliert.loa_value - v_uer_std_aus_K_U_F_13W + v_uer_std_aus_K_U_F;
                  if v_kug_loa_value > 0
                  or v_kugk_loa_value > 0
                  then
                    if v_zk_monat_saldo_kug_done = True
                    then
                      v_zk_monat_saldo := 0;
                      v_loa_kumuliert.konto_val_korr := 0;
                    else
                      v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                                   in_pers_nr,
                                                                                   'ZK',
                                                                                   v_von_datum - 1), 0); -- + v_loa_kumuliert.loa_value - v_kug_loa_value;
                    end if;
                  end if;
                  if v_zk_monat_saldo_kug_done = false
                  then
                    if v_kug_loa_value > 0
                    then
                      v_loa_kumuliert.err_text := NULL;
                      if v_loa_kumuliert.loa_value = v_kug_loa_value
                      and v_zk_monat_saldo <= 0
                      then
                        v_loa_kumuliert.lohnart := v_kug_loa;
                        v_loa_kumuliert.lz_id := v_kug_loa_id;
                        v_loa_kumuliert.konto_val_korr := 0;
                        v_kug_loa_value := 0;
                      else
                        if v_zk_monat_saldo > 0
                        then
                          if v_zk_monat_saldo >= v_loa_kumuliert.loa_value
                          then
                            v_loa_kumuliert.konto_val_korr := v_kug_loa_value;
                            v_zk_monat_saldo := v_zk_monat_saldo - v_kug_loa_value;
                            v_kug_loa_value := 0;
                          else
                            if v_zk_monat_saldo >= v_loa_kumuliert.loa_value - v_kug_loa_value
                            then
                              v_loa_kumuliert.konto_val_korr := v_zk_monat_saldo - v_loa_kumuliert.loa_value + v_kug_loa_value;
                              v_zk_monat_saldo := v_zk_monat_saldo + v_loa_kumuliert.loa_value - v_kug_loa_value;
                              v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_kug_loa_value + v_loa_kumuliert.konto_val_korr;
                              v_kug_loa_value := v_kug_loa_value - v_loa_kumuliert.konto_val_korr;
                              v_zk_monat_saldo_kug_done := true;
                            else
                              v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_kug_loa_value;
                            end if;
                          end if;
                        elsif v_zk_monat_saldo < 0
                        then
                          if v_loa_kumuliert.loa_value > v_kug_loa_value
                          then
                            v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_kug_loa_value;
                          end if;
                        else
                          v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_kug_loa_value;
                        end if;
                      end if;

                      if v_loa_kumuliert.konto_val_korr != 0 -- Es ist zu korrigieren
                      then
                        open c_pzm_konten_uk;               -- konto lesen
                        fetch c_pzm_konten_uk into v_uk_konto;
                        v_found_kto := c_pzm_konten_uk%found;
                        close c_pzm_konten_uk;
                        if v_loa_kumuliert.konto_val_korr != 0
                        then
                          pzm_kontoverwaltung.abgang_buchen('01', 1, v_uk_konto.konto_nr,
                                                            in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                            v_loa_kumuliert.konto_val_korr,
                                                            'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                            get_pers_abt_id(in_pers_nr),
                                                            v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                        end if;
                        v_loa_kumuliert.konten_bh_id_korr := v_konten_bh_id;
                        update pzm_konten_bh t
                           set t.zk_start = v_loa_kumuliert.datum - 1,
                               t.buch_datum = v_loa_kumuliert.datum - 1,
                               t.zk_aa_id = null
                         where t.sid = '01'
                           and t.firma_nr = 1
                           and t.konten_bh_id = v_konten_bh_id;
                                                                  
                        v_loa_kumuliert.konto_nr_korr := v_uk_konto.konto_nr;
                        v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value + v_ueb_stunden_13w - v_ueb_stunden_13w_korr;
                        v_ueb_stunden_13w := 0;
                        v_ueb_stunden_13w_korr := 0;
                      end if;
                    end if;
                  
                    if v_kugk_loa_value > 0
                    then
                      if v_kug_loa_value = 0
                      then
                        v_loa_kumuliert.err_text := NULL;
                        if v_loa_kumuliert.loa_value = v_kugk_loa_value
                        and v_zk_monat_saldo <= 0
                        then
                          v_loa_kumuliert.lohnart := v_kugk_loa;
                          v_loa_kumuliert.lz_id := v_kugk_loa_id;
                          v_loa_kumuliert.konto_val_korr := 0;
                          v_kugk_loa_value := 0;
                        else
                          if v_zk_monat_saldo > 0
                          then
                            if v_zk_monat_saldo >= v_loa_kumuliert.loa_value
                            then
                              v_loa_kumuliert.konto_val_korr := v_kugk_loa_value;
                              v_kugk_loa_value := 0;
                            else
                              if v_zk_monat_saldo >= v_loa_kumuliert.loa_value - v_kugk_loa_value
                              then
                                v_loa_kumuliert.konto_val_korr := v_zk_monat_saldo - v_loa_kumuliert.loa_value + v_kugk_loa_value;
                                v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_kugk_loa_value + v_loa_kumuliert.konto_val_korr;
                                v_kugk_loa_value := v_kugk_loa_value - v_loa_kumuliert.konto_val_korr;
                              else
                                v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_kugk_loa_value;
                              end if;
                            end if;
                          elsif v_zk_monat_saldo < 0
                          then
                            if v_loa_kumuliert.loa_value > v_kugk_loa_value
                            then
                              v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_kugk_loa_value;
                            end if;
                          else
                            v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_kugk_loa_value;
                          end if;
                        end if;

                        if v_loa_kumuliert.konto_val_korr != 0 -- Es ist zu korrigieren
                        then
                          open c_pzm_konten_uk;               -- konto lesen
                          fetch c_pzm_konten_uk into v_uk_konto;
                          v_found_kto := c_pzm_konten_uk%found;
                          close c_pzm_konten_uk;
                          if v_loa_kumuliert.konto_val_korr != 0
                          then
                            pzm_kontoverwaltung.abgang_buchen('01', 1, v_uk_konto.konto_nr,
                                                              in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                              v_loa_kumuliert.konto_val_korr,
                                                              'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                              get_pers_abt_id(in_pers_nr),
                                                              v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                          end if;
                          v_loa_kumuliert.konten_bh_id_korr := v_konten_bh_id;
                          update pzm_konten_bh t
                             set t.zk_start = v_loa_kumuliert.datum - 1,
                                 t.buch_datum = v_loa_kumuliert.datum - 1,
                                 t.zk_aa_id = null
                           where t.sid = '01'
                             and t.firma_nr = 1
                             and t.konten_bh_id = v_konten_bh_id;
                                                                  
                          v_loa_kumuliert.konto_nr_korr := v_uk_konto.konto_nr;
                          v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value + v_ueb_stunden_13w;
                          v_ueb_stunden_13w := 0;
                        end if;
                      end if;
                    end if;
                    v_ueb_stunden_13w := 0; -- ???  
                  end if;
                end if;
              end if;
              --v_loa_kumuliert.ret_code := null;
              -- if nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'T'  -- Kein Gehalt? - Diese Abfrage war falsch
              if nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') != 'X'  -- Immer war
              then
                if v_tarifmodell.tarif_fest_std != 'T'
                or nvl(v_loa_kumuliert.ret_code, 'xx') != 'ZK'
                then
                  if in_schnittstelle = 'EXT_KW_MM'
                  then
                    insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                     v_bis_datum,
                                                     v_personal.pers_vname, 
                                                     v_personal.pers_nname,
                                                     v_pb_abteilung);
                  else
                    if v_loa_kumuliert.ret_code = 'ZK'
                    or v_tarifmodell.tarif_fest_std = 'T'
                    then 
                      if  v_tarifmodell.tarif_fest_std = 'T'
                      then
                        if v_tarifmodell.tarif_13w_schnitt = 'T'
                        and v_uer_std_aus_K_U_F > 0
                        then
                          if pzm_p_base.get_lohnart(v_loa_kumuliert.lz_id, v_lohnart)
                          and v_lohnart.lz_operator in ('KUGK', 'K', 'U', 'SU', 'F', 'SF', 'SU')
                          then
                            v_loa_kumuliert.loa_value := round(v_loa_kumuliert.loa_value * nvl(v_uer_std_aus_K_U_F_13W / v_uer_std_aus_K_U_F, 1), 3);
                          end if;
                        end if;
                        --v_ueb_stunden_13w := v_ueb_stunden_13w + v_loa_kumuliert.loa_value;
                      end if;
                    end if;
                    if (nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'T'  -- Kein Gehalt? - Hier ist Abfrage korrekt
                      or nvl(v_loa_kumuliert.ret_code, 'xx') != 'ZK')            -- -AG- 05.05.2026 oder kein ZK-Wert
                    and v_lohnart.lz_lohnart is not NULL
                    or (    v_lohnart.lz_uhrz_von is not NULL                        -- Bei diesen Lohnarten wird in der Stempelung entschieden
                        and v_lohnart.lz_uhrz_bis is not NULL)
                    then
                      if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                      then
                        v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                      end if;
                      insert into pzm_ze_loa_exp_host values v_loa_kumuliert; -- Schreiben der LOA - Stundenaufbauukonto
                      --insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
                    end if;
                  end if;
                end if;
                v_loa_kumuliert.konto_nr_korr := NULL;
                v_loa_kumuliert.konto_val_korr := NULL;
                v_loa_kumuliert.konten_bh_id_korr := NULL;
              end if;
              if  v_tarifmodell.tarif_fest_std != 'T' 
              and pzm_p_base.get_lohnart_by_alternative_lz_id(v_loa_kumuliert.lz_id, v_lohnart)
              and v_lohnart.lz_operator = 'ERP_ZUS_ZK'
              then
                v_loa_kumuliert.lz_id   := v_lohnart.lz_id;
                v_loa_kumuliert.lohnart := v_lohnart.lz_lohnart;
                if in_schnittstelle = 'EXT_KW_MM'
                then
                  insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                   v_bis_datum,
                                                   v_personal.pers_vname, 
                                                   v_personal.pers_nname,
                                                   v_pb_abteilung);
                else
                  if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                  then
                    v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                  end if;
                  if v_loa_kumuliert.ret_code = 'ZK'
                  then 
                    insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
                  else
                    insert into pzm_ze_loa_exp_host values v_loa_kumuliert; -- Schreiben der LOA - Stundenaufbauukonto
                  end if;
                end if;
                v_loa_kumuliert.konto_nr_korr := NULL;
                v_loa_kumuliert.konto_val_korr := NULL;
                v_loa_kumuliert.konten_bh_id_korr := NULL;
              end if;
              if v_ueb_std < 0 -- 25.03.2026 -AG- jestz kann es bei gehalt auch - Überstunden geben AKZ Minus überschritten
              then
                select min(loa.lz_lohnart), min(loa.lz_id) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                  from pzm_lohnarten loa,
                       pzm_pers_lohn_zulagen p_lz
                 where loa.lz_typ = 'UEB_STD'
                   and loa.lz_operator = 'UESTD'
                   and loa.lz_id = p_lz.lz_id(+)
                   and in_pers_nr = p_lz.pers_nr(+)
                   and v_von_datum - 1 <= nvl(p_lz.gueltig_datum_bis(+), v_von_datum - 1)
                   and v_von_datum - 1 >= nvl(p_lz.gueltig_datum_von(+), v_von_datum - 1);
                v_loa_kumuliert.loa_value := v_ueb_std;
                --v_ueb_stunden_13w := v_loa_kumuliert.loa_value;
                v_loa_kumuliert.konto_nr_korr := NULL;
                v_loa_kumuliert.konto_val_korr := NULL;
                v_loa_kumuliert.konto_val_korr := NULL;
                v_loa_kumuliert.konten_bh_id_korr := NULL;
                if  v_loa_kumuliert.loa_value != 0
                and v_loa_kumuliert.lohnart is not NULL
                then
                  if in_schnittstelle = 'EXT_KW_MM'
                  then
                    insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                     v_bis_datum,
                                                     v_personal.pers_vname, 
                                                     v_personal.pers_nname,
                                                     v_pb_abteilung);
                  else
                    if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                    then
                      v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                    end if;
                    insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
                  end if;
                  v_ueb_std := 0;
                end if;
              end if;
            end if;
            if v_kug_loa_value > 0
            then
              v_loa_kumuliert.lohnart := v_kug_loa;
              v_loa_kumuliert.lz_id := v_kug_loa_id;
              v_loa_kumuliert.konto_val_korr := 0;
              v_loa_kumuliert.loa_value := v_kug_loa_value;
              v_kug_loa_value := 0;
              if in_schnittstelle = 'EXT_KW_MM'
              then
                insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                 v_bis_datum,
                                                 v_personal.pers_vname, 
                                                 v_personal.pers_nname,
                                                 v_pb_abteilung);
              else
                if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                then
                  v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                end if;
                insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
              end if;
              v_loa_kumuliert.konto_nr_korr := NULL;
              v_loa_kumuliert.konto_val_korr := NULL;
              v_loa_kumuliert.konten_bh_id_korr := NULL;
            end if;
            if v_kugk_loa_value > 0
            then
              v_loa_kumuliert.lohnart := v_kugk_loa;
              v_loa_kumuliert.lz_id := v_kugk_loa_id;
              v_loa_kumuliert.konto_val_korr := 0;
              v_loa_kumuliert.loa_value := v_kugk_loa_value;
              v_kugk_loa_value := 0;
              if in_schnittstelle = 'EXT_KW_MM'
              then
                insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                 v_bis_datum,
                                                 v_personal.pers_vname, 
                                                 v_personal.pers_nname,
                                                 v_pb_abteilung);
              else
                if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                then
                  v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                end if;
                insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
              end if;
              v_loa_kumuliert.konto_nr_korr := NULL;
              v_loa_kumuliert.konto_val_korr := NULL;
              v_loa_kumuliert.konten_bh_id_korr := NULL;
            end if;
          end if;
          v_loa_kumuliert.konto_nr_korr := NULL;
          v_loa_kumuliert.konto_val_korr := NULL;
          v_lohnart.lz_operator := NULL;

        end loop;
        close c_loa_kumuliert;
      exception
       
        WHEN OTHERS THEN  -- handles all other errors
          if c_loa_kumuliert%isopen 
          then
            close c_loa_kumuliert;
          end if;
          v_result :=  '(E104) PL/SQL LOA_KUMULIERT' || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
          rollback;
          return(v_result);
          raise;
          -- ToDo: BWe  Info on v_result
      end;

      if not v_loa_zk_done
      and in_schnittstelle != 'EXT_KW_MM' -- Nicht für EXTERNE
      and v_ueb_stunden_13w >= 0 -- Nur 13 W Schnitt
      and v_kst_id = v_kst_id_zk
      and v_tarifmodell.tarif_fest_std != 'T'
      and v_tarifmodell.tarif_13w_schnitt = 'T'
      then
        v_pers_max_frei_stunden := v_personal.pers_max_freistd;
        if v_vertragsart.va_bis_std_auszahlen_zeiteinheit is not NULL -- Es gibt eine zeiteiheit für Stunden auszahlen
        and v_vertragsart.va_bis_std_auszahlen > 0                    -- Und der wert ist auch gepflegt.
        then --  v_vertragsart.va_bis_std_auszahlen_zeiteinheit anpassen, dass ausgezahlt wird
          v_arb_stunden := pzm_utils.get_pers_arb_std(in_pers_nr,
                                                      NULL,
                                                      v_von_datum,
                                                      v_bis_datum,   -- Ermittlung der gearbeiteten Stunden
                                                      true, -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                      true -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T'
                                                      );  -- Krank und Urlaub kommen dazu?

          if v_vertragsart.va_bis_std_auszahlen_zeiteinheit = 'MM'
          then
            v_aus_arb_stunden := v_vertragsart.va_bis_std_auszahlen; -- Ermittlung der Sollstunden
          elsif v_vertragsart.va_bis_std_auszahlen_zeiteinheit = 'WW'
          then
            v_aus_arb_stunden := v_vertragsart.va_bis_std_auszahlen / 
                                 pzm_p_schicht_tag.get_anz_schicht_tage(in_pers_nr, v_start_datum, v_start_datum + 6) * 
                                 v_anz_arb_tage;
          elsif v_vertragsart.va_bis_std_auszahlen_zeiteinheit = 'DD'
          then
            v_aus_arb_stunden := v_vertragsart.va_bis_std_auszahlen * v_anz_arb_tage; -- Ermittlung der Sollstunden
          end if;
                      
                       
          if v_aus_arb_stunden >= v_ueb_stunden_13w + v_arb_stunden
          then
            v_pers_max_frei_stunden := 0;                -- Alles auszahlen
          elsif v_aus_arb_stunden >= v_arb_stunden
            and v_pers_max_frei_stunden > (v_zk_monat_saldo + v_ueb_stunden_13w + v_arb_stunden) - v_aus_arb_stunden
          then
            v_pers_max_frei_stunden := (v_zk_monat_saldo + v_ueb_stunden_13w + v_arb_stunden) - v_aus_arb_stunden;
          end if;
        end if;
        v_loa_kumuliert.loa_value := v_ueb_stunden_13w;
        v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                     in_pers_nr,
                                                                     'ZK',
                                                                     v_von_datum - 1), 0);
        if v_zk_monat_saldo < v_pers_max_frei_stunden -- Konto hat noch Platz
        then
          v_korr_std_korrekt := true;
          if v_zk_monat_saldo + v_ueb_stunden_13w < v_personal.pers_max_freistd
          then
            v_korr_std := v_ueb_stunden_13w;
            v_loa_kumuliert.loa_value := v_ueb_stunden_13w;
            v_ueb_stunden_13w := 0;
          else
            v_korr_std := v_zk_monat_saldo + v_ueb_stunden_13w - v_personal.pers_max_freistd;
            v_korr_std := v_ueb_stunden_13w - v_korr_std;
            v_loa_kumuliert.loa_value := v_korr_std;
            v_ueb_stunden_13w := v_ueb_stunden_13w - v_korr_std;
          end if;
          v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value * -1;
          select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
            from pzm_lohnarten loa
           where loa.lz_link_loa_id is not NULL
             and loa.lz_alternativ_loa_id is NULL
             and loa.lz_konto_name_kurz = 'ZK';
             
          v_loa_kumuliert.ret_code := 'ZK';
          open c_pzm_konten_uk;               -- konto lesen
          fetch c_pzm_konten_uk into v_uk_konto;
          v_found_kto := c_pzm_konten_uk%found;
          close c_pzm_konten_uk;
          pzm_kontoverwaltung.zugang_Buchen('01', 1, v_uk_konto.konto_nr,
                                            in_pers_nr, get_pers_kst_id(in_pers_nr),
                                            v_korr_std,
                                            'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                            get_pers_abt_id(in_pers_nr),
                                            v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
          v_loa_kumuliert.konten_bh_id_korr := v_konten_bh_id;
          v_loa_kumuliert.datum := add_months(v_von_datum, 1);
          update pzm_konten_bh t
             set t.zk_start = v_loa_kumuliert.datum - 1,
                 t.buch_datum = v_loa_kumuliert.datum - 1,
                 t.zk_aa_id = null
           where t.sid = '01'
             and t.firma_nr = 1
             and t.konten_bh_id = v_konten_bh_id;
                                                            
          v_loa_kumuliert.konto_nr_korr := v_uk_konto.konto_nr;
          v_loa_kumuliert.konto_val_korr := v_loa_kumuliert.konto_val_korr * -1;
          if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
          then
            v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
          end if;
          insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
          if pzm_p_base.get_lohnart_by_alternative_lz_id(v_loa_kumuliert.lz_id, v_lohnart)
          and v_lohnart.lz_operator = 'ERP_ZUS_ZK'
          then
            v_loa_kumuliert.lz_id   := v_lohnart.lz_id;
            v_loa_kumuliert.lohnart := v_lohnart.lz_lohnart;
            if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
            then
              v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
            end if;
            insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
            end if;
        end if;

        if v_ueb_stunden_13w > 0
        then
          v_loa_kumuliert.loa_value := v_ueb_stunden_13w;
          -- v_ueb_stunden_13w := 0;
          select min(loa.lz_lohnart), min(loa.lz_id) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
            from pzm_lohnarten loa,
                 pzm_pers_lohn_zulagen p_lz
           where loa.lz_typ = 'UEB_STD'
             and loa.lz_operator = 'UESTD'
             and loa.lz_id = p_lz.lz_id(+)
             and in_pers_nr = p_lz.pers_nr(+)
             and v_von_datum - 1 <= nvl(p_lz.gueltig_datum_bis(+), v_von_datum - 1)
             and v_von_datum - 1 >= nvl(p_lz.gueltig_datum_von(+), v_von_datum - 1);
                                                                     
          v_loa_kumuliert.konto_nr_korr := NULL;
          v_loa_kumuliert.konto_val_korr := NULL;
          v_loa_kumuliert.konto_val_korr := NULL;
          v_loa_kumuliert.konten_bh_id_korr := NULL;
          if  v_loa_kumuliert.loa_value != 0
          and v_loa_kumuliert.lohnart is not NULL
          then
            if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
            then
              v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
            end if;
            insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
          end if;
        end if;
        --v_ueb_stunden_13w := 0;
      end if;

      v_loa_kumuliert.pers_nr := in_pers_nr;
      v_loa_kumuliert.datum := add_months(v_von_datum, 1);
      v_loa_kumuliert.loa_grp := null;
      v_loa_kumuliert.aa_id := null;
      v_loa_kumuliert.status := 'N';
      v_loa_kumuliert.ret_code := null;
      v_loa_kumuliert.cycle := null;

      if v_13_w_schnitt_value > 0
      and v_kst_id = v_kst_id_zk
      and v_tarifmodell.tarif_13w_schnitt = 'T'
      then
        v_loa_kumuliert.lohnart := NULL;
        select min(loa.lz_lohnart), min(loa.lz_id) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
          from pzm_lohnarten loa
         where loa.lz_typ = 'ARB_STD'
           and loa.lz_operator = 'SCHNITT13W';
        v_loa_kumuliert.loa_value := v_13_w_schnitt_value;

        if  v_loa_kumuliert.loa_value != 0
        and v_loa_kumuliert.lohnart is not NULL
        then
          if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
          then
            v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
          end if;
          insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
        end if;
      end if;
    
      v_loa_kumuliert.kst_id := nvl(v_kst_id, get_pers_kst_id(in_pers_nr));
      v_loa_kumuliert.pers_nr := in_pers_nr;
      if in_schnittstelle = 'EXT_KW_MM' -- kalenderwoche und Monat
      then
        v_loa_kumuliert.datum := v_bis_datum;
      else
        v_loa_kumuliert.datum := v_folgemonat_datum;
      end if;
      v_zk_monat_diff_ges := v_zk_monat_diff_ges + v_zk_monat_diff;

    -- Hier die Überstunden (Zuschlag)
      if  nvl(v_tarifmodell.tarif_ueb_loa, 'T') = 'T'
      and v_tarifmodell.tarif_fest_std != 'T' 
      and (v_zk_monat_diff_ges > 0 and v_kst_idx_max = v_kst_idx_loa) -- -AG- 06.04.2026 Wenn es mehrere Kostenstellen gibt
           or (v_zk_monat_diff > 0 
           or v_ueb_stunden_loa2 > 0 
           or v_ueb_stunden_loa > 0 
           or v_ueb_std_proz > 0 
           or in_schnittstelle = 'EXT_KW_MM')
      and (in_schnittstelle != 'EXT_KW_MM' or v_bis_datum = v_ende_datum) 
      and (v_kst_idx_max <= v_kst_idx_loa)
      then
        select sum(t.ze_std) into v_arb_stunden    -- Ermitteln der Stunden ohne Lohnzulage
         from pzm_zeiterfassung t
        where 1=1
          and t.ze_status = 5 
          and nvl(t.ze_work_location, 52) in (52, 53, 99)
          and t.ze_pers_nr = in_pers_nr
          and t.ze_schicht_tag >= v_start_datum
          and t.ze_schicht_tag <= v_ende_datum;
        v_ueb_stunden_loa2 := v_ueb_stunden_loa2 - nvl(v_arb_stunden, 0);  -- Stunden abziehen

        /* -- Dies wird jetzt korrekt im Tagessatz gebucht (LOA 503 ARBSTD)
        select sum(t.ze_std)  into v_arb_stunden    -- Abwesenheiten mit LOA für Arbeitsstunden
         from pzm_zeiterfassung t,
              pzm_abwesenheitsarten aa,
              pzm_lohnarten l
        where 1=1
          and t.ze_aa_status = aa.aa_id
          and aa.lz_id = l.lz_id
          and l.lz_operator = 'ARBSTD'
          and t.ze_pers_nr = in_pers_nr
          and t.ze_schicht_tag >= v_start_datum
          and t.ze_schicht_tag <= v_ende_datum;
        v_ueb_stunden_loa2 := v_ueb_stunden_loa2 + nvl(v_arb_stunden, 0);  -- Diese Arbeitsstunden dazuneh´men
        */
        
        v_arb_stunden := 0;
        
        v_loa_kumuliert.lohnart := NULL; -- Initial
        
        begin
          select loa.lz_lohnart, loa.lz_id into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
            from pzm_lohnarten loa
          where lz_id = (select min(lz_id) 
                           from pzm_lohnarten 
                          where lz_konto_name_kurz='ZK'
                            and lz_konto_bus is null
                            and lz_typ='UEB_STD'
                            and lz_operator='UESTDPROZ'
                            and GET_PERS_LOA_IS_GUELTIG(in_pers_nr, lz_id, null)=1);
        exception
          when others then v_loa_kumuliert.lohnart := NULL;
        end;

        if v_loa_kumuliert.lohnart is not NULL
        then
          if v_tarifmodell.tarif_ueb_proz_wie_ueb_auszahlung = 'T'
          then
            v_loa_kumuliert_loa_value := v_ueb_std_proz;
            v_ueb_std_proz := 0;
          else
            if nvl(v_tarifmodell.tarif_ueb_basis, 'XX') not in ('MM', 'WW', 'DD')     -- Alle gefundenen Überstunden buchen
            and get_pers_loa_is_gueltig(in_pers_nr, v_loa_kumuliert.lz_id, NULL) = 1  -- Auf Gültigkeit prüfen
            then
              v_arb_stunden := pzm_utils.get_pers_arb_std(in_pers_nr,
                                                          NULL,
                                                          v_start_datum,
                                                          v_bis_datum,   -- Ermittlung der gearbeiteten Stunden
                                                          false, -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                          false -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T'
                                                          );  -- Krank und Urlaub kommen dazu?
              v_anz_arb_stunden := get_pers_monat_soll_std(in_pers_nr, v_kst_id, v_von_datum); -- Ermittlung der Sollstunden
              v_arb_stunden := v_arb_stunden + v_ueb_stunden_loa2;
              v_loa_kumuliert.loa_value := nvl(v_arb_stunden - v_anz_arb_stunden, 0);
              if v_loa_kumuliert.loa_value < 0
              then
                v_loa_kumuliert.loa_value := 0;
              end if;
            elsif v_tarifmodell.tarif_ueb_basis in ('MM', 'WW', 'DD')
            then
              v_arb_stunden := pzm_utils.get_pers_arb_std(in_pers_nr,
                                                          NULL,
                                                          v_start_datum,
                                                          v_bis_datum,   -- Ermittlung der gearbeiteten Stunden
                                                          false, -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                          false -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T'
                                                          );  -- Krank und Urlaub kommen dazu?
              v_arb_stunden := v_arb_stunden + v_ueb_stunden_loa2;
              if nvl(v_tarifmodell.tarif_ueb_basis_ermittlung, 'MM') = 'MM' -- Monatsweise - Default
              or (v_tarifmodell.tarif_ueb_basis = 'MM' and v_tarifmodell.tarif_ueb_std > 0) -- In der Kombination kann nur so gerechnete werden
              then
                if v_tarifmodell.tarif_ueb_std > 0
                then
                  if v_tarifmodell.tarif_ueb_basis = 'MM'
                  then
                    v_tarifmodell.tarif_ueb_std := v_tarifmodell.tarif_ueb_std - v_f_stunden_loa;
                    if v_tarifmodell.tarif_ueb_std >= v_arb_stunden
                    then
                      v_loa_kumuliert.loa_value := 0;
                    else
                      v_loa_kumuliert.loa_value := v_arb_stunden - v_tarifmodell.tarif_ueb_std;
                    end if;
                  elsif v_tarifmodell.tarif_ueb_basis = 'WW'
                  then
                    v_anz_arb_stunden := round(v_tarifmodell.tarif_ueb_std / 
                                               pzm_p_schicht_tag.get_anz_schicht_tage(in_pers_nr, v_start_datum, v_start_datum + 6) * 
                                               v_anz_arb_tage, 3); -- Ermittlung der Sollstunden
                    -- v_loa_kumuliert.loa_value := nvl(v_arb_stunden - v_anz_arb_stunden - v_f_stunden_loa, 0);
                    -- -AG- 06.05.2026 Die Feiertage sind schon abgezogen 
                    v_loa_kumuliert.loa_value := nvl(v_arb_stunden - v_anz_arb_stunden, 0);
                  elsif v_tarifmodell.tarif_ueb_basis = 'DD'
                  then
                    v_anz_arb_stunden := v_tarifmodell.tarif_ueb_std * v_anz_arb_tage; -- Ermittlung der Sollstunden
                    -- Feiertag mit Ü-Tag-Stunden rechnen
                    if get_pers_schicht_d_std(in_pers_nr) > 0
                    then
                      v_f_stunden_loa_diff := v_f_stunden_loa - round(v_f_stunden_loa / get_pers_schicht_d_std(in_pers_nr) * v_tarifmodell.tarif_ueb_std, 3);
                      v_f_stunden_loa := round(v_f_stunden_loa / get_pers_schicht_d_std(in_pers_nr) * v_tarifmodell.tarif_ueb_std, 3);
                    else
                      v_f_stunden_loa_diff := 0; 
                    end if;
                    -- v_loa_kumuliert.loa_value := nvl(v_arb_stunden - v_anz_arb_stunden - v_f_stunden_loa, 0);
                    -- -AG- 06.05.2026 Die Feiertage sind schon abgezogen 
                    v_loa_kumuliert.loa_value := nvl(v_arb_stunden - v_anz_arb_stunden, 0) + v_f_stunden_loa_diff;
                  end if;  
                elsif nvl(v_tarifmodell.tarif_ueb_std, 0) = 0
                then
                  v_anz_arb_stunden := get_pers_monat_soll_std(in_pers_nr, NULL, v_von_datum); -- Ermittlung der Sollstunden aller Kostenstellen
                  v_loa_kumuliert.loa_value := nvl(v_arb_stunden - v_anz_arb_stunden, 0);
                end if;
                v_kappung_flex_std := get_pers_kappung_flex_std(in_pers_nr);
                v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - nvl(v_kappung_flex_std, 0);
                if v_loa_kumuliert.loa_value < 0
                then
                  v_loa_kumuliert.loa_value := 0;
                end if;
                v_loa_kumuliert_loa_value := v_loa_kumuliert.loa_value;
              elsif v_tarifmodell.tarif_ueb_basis_ermittlung = 'WW' -- Wochenweise
              then
                v_start_datum_ueb_p := trunc(v_start_datum, 'iw');
                v_ende_datum_ueb_p := v_start_datum_ueb_p + 6;
                if v_start_datum_ueb_p < v_start_datum
                then 
                  v_start_datum_ueb_p := v_start_datum;
                end if;
                v_loa_kumuliert_loa_value := 0;
                v_loa_kumuliert.loa_value := NULL;
                
                LOOP
                  EXIT when v_start_datum_ueb_p > v_ende_datum;
                  if v_ende_datum_ueb_p > v_ende_datum
                  then
                    v_ende_datum_ueb_p := v_ende_datum;
                  end if;
                  v_arb_stunden := pzm_utils.get_pers_arb_std(in_pers_nr,
                                                              NULL,
                                                              v_start_datum_ueb_p,
                                                              v_ende_datum_ueb_p,   -- Ermittlung der gearbeiteten Stunden
                                                              true, -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                              true -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T'
                                                              );  -- Krank und Urlaub kommen dazu?

                  v_anz_arb_tage := get_anz_arbeitstage_R32(in_pers_nr,
                                                            v_start_datum_ueb_p,
                                                            v_ende_datum_ueb_p);    -- p_ende_datum => :p_ende_datum,

                  if v_arb_stunden > 0
                  then
                    if v_tarifmodell.tarif_ueb_std > 0
                    then
                      v_soll_std := 0;
                      if v_tarifmodell.tarif_ueb_basis = 'WW'
                      and v_tarifmodell.tarif_ueb_basis_w_tage > 0
                      and v_anz_arb_tage > 0 
                      then
                        v_soll_std := v_tarifmodell.tarif_ueb_std / v_tarifmodell.tarif_ueb_basis_w_tage * v_anz_arb_tage;
                      elsif v_tarifmodell.tarif_ueb_basis = 'DD'
                      then
                        v_soll_std := v_tarifmodell.tarif_ueb_std * v_anz_arb_tage;
                      end if;  
                    elsif nvl(v_tarifmodell.tarif_ueb_std, 0) = 0
                    then
                      v_soll_std := v_day_schnitt * v_anz_arb_tage;
                    end if;
                  else
                    -- Sollstunden ermiteln
                    v_soll_std := v_anz_arb_tage * v_day_schnitt;
                  end if;
                  v_anz_arb_stunden := nvl(v_arb_stunden - v_soll_std, 0);
                  if v_anz_arb_stunden > 0
                  then
                    v_loa_kumuliert_loa_value := v_loa_kumuliert_loa_value + v_anz_arb_stunden;
                  end if;
                  if v_loa_kumuliert_loa_value < 0
                  then
                    v_loa_kumuliert_loa_value := 0;
                  end if;
                  v_start_datum_ueb_p := v_ende_datum_ueb_p + 1;
                  v_ende_datum_ueb_p := v_start_datum_ueb_p + 6;
                end LOOP;
              end if;
            end if;
          end if;
        end if;
        
        if  v_loa_kumuliert_loa_value != 0
        and v_loa_kumuliert.lohnart is not NULL
        and v_datum is NULL
        then
          v_korr_std := 0;
          if v_tarifmodell.tarif_ueb_zeitkonto_p_zk = 'T'
          and v_tarifmodell.tarif_ueb_zeitkonto_proz > 0
          -- and v_zk_monat_saldo_kug_done = false                -- Bei Kurzarbeit werden kene Ü-Std-% auf das Konto gebucht
          then
            v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                         in_pers_nr,
                                                                         'ZK',
                                                                         v_bis_datum), 0);
            if v_zk_monat_saldo < v_personal.pers_max_freistd -- Konto hat noch Platz
            then
              v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                           in_pers_nr,
                                                                           'ZK',
                                                                           v_von_datum - 1), 0);
              v_korr_std := v_loa_kumuliert_loa_value * v_tarifmodell.tarif_ueb_zeitkonto_proz / 100;
              --if v_zk_monat_saldo + v_loa_kumuliert.loa_value < v_personal.pers_max_freistd
              if v_zk_monat_saldo + v_korr_std > v_personal.pers_max_freistd
              then
 
 
                v_korr_std := v_zk_monat_saldo + v_korr_std - v_personal.pers_max_freistd;
                v_loa_kumuliert.loa_value := v_loa_kumuliert_loa_value -
                                              (v_korr_std / (v_tarifmodell.tarif_ueb_zeitkonto_proz / 100));
              else
                v_loa_kumuliert.loa_value := 0;
              end if;
              v_loa_kumuliert_loa_value := v_loa_kumuliert.loa_value - v_korr_std; 
              v_loa_kumuliert.ret_code := 'ZK';
              open c_pzm_konten_uk;               -- konto lesen
              fetch c_pzm_konten_uk into v_uk_konto;
              v_found_kto := c_pzm_konten_uk%found;
              close c_pzm_konten_uk;

              if v_zk_monat_saldo_kug_done = false                -- -AG- 23.03.2026 Bei Kurzarbeit werden kene Ü-Std-% auf das Konto gebucht
              then
                pzm_kontoverwaltung.zugang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                  in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                  v_korr_std,
                                                  'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                  get_pers_abt_id(in_pers_nr),
                                                  v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                v_loa_kumuliert.konten_bh_id_korr := v_konten_bh_id;
                v_loa_kumuliert.datum := add_months(v_von_datum, 1);
                update pzm_konten_bh t
                   set t.zk_start = v_loa_kumuliert.datum - 1,
                       t.buch_datum = v_loa_kumuliert.datum - 1,
                       t.zk_aa_id = null
                 where t.sid = '01'
                   and t.firma_nr = 1
                   and t.konten_bh_id = v_konten_bh_id;
              else                                          -- -AG- 23.03.2026 Bei Kurzarbeit werden Ü-Std-% vom KUG Stunden abgezogen
                if v_zk_monat_saldo < 0                     -- Wenn das ZK-Konto < 0 dann muss mit den Ueb-Std-% erst das ZK-Konto ausgeglichen werden
                then
                  -- außer KUG kein Minus, was vorher verrechnet werden muss
                  if v_zk_monat_diff_kug_vmonat < 0
                  then
                    if v_zk_monat_saldo * -1 >= v_korr_std   -- Der Minus ist so gross, dass alles auf das ZK-Konto geht
                    then
                      v_loa_kumuliert.konto_val_korr := v_korr_std;
                      v_korr_std := 0;
                    else                                          -- Sonst so viel, dass das ZK Konto auf 0 geht.
                      v_loa_kumuliert.konto_val_korr := v_zk_monat_saldo * -1;
                      v_korr_std := v_korr_std + v_zk_monat_saldo;
                    end if;
                    if v_loa_kumuliert.konto_val_korr > 0         -- ZK ist zu korrigieren
                    then
                      pzm_kontoverwaltung.zugang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                        in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                        v_loa_kumuliert.konto_val_korr,
                                                        'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                        get_pers_abt_id(in_pers_nr),
                                                        v_konten_bh_id); -- Korrekturbuchung auf Konto
                      v_loa_kumuliert.konten_bh_id_korr := v_konten_bh_id;
                      v_loa_kumuliert.datum := add_months(v_von_datum, 1);
                      update pzm_konten_bh t
                         set t.zk_start = v_loa_kumuliert.datum - 1,
                             t.buch_datum = v_loa_kumuliert.datum - 1,
                             t.zk_aa_id = null
                       where t.sid = '01'
                         and t.firma_nr = 1
                         and t.konten_bh_id = v_konten_bh_id;
                    end if;
                  end if;
                end if;
                if v_korr_std > 0 -- KUG Stunden müssen noch korrigiert werden
                then
                  select loa.loa_value into v_kug_loa_value
                    from pzm_ze_loa_exp_host loa
                   where loa.pers_nr = in_pers_nr
                     and loa.lz_id = v_kug_loa_id
                     and loa.datum = v_loa_kumuliert.datum;
                  if v_kug_loa_value <= v_korr_std
                  then
                    delete pzm_ze_loa_exp_host loa
                     where loa.pers_nr = in_pers_nr
                       and loa.lz_id = v_kug_loa_id
                       and loa.datum = v_loa_kumuliert.datum;
                  else
                    update pzm_ze_loa_exp_host loa
                       set loa.loa_value = loa.loa_value - v_korr_std
                     where loa.pers_nr = in_pers_nr
                       and loa.lz_id = v_kug_loa_id
                       and loa.datum = v_loa_kumuliert.datum;
                  end if;
                end if;
                v_korr_std := 0;
                v_loa_kumuliert_loa_value := 0;
                v_loa_kumuliert.loa_value := 0;
                v_loa_kumuliert.konto_val_korr := 0;
              end if;
            end if;
          end if;
          if v_korr_std = 0
          and v_loa_kumuliert.loa_value is NULL
          then
            v_loa_kumuliert.loa_value := v_loa_kumuliert_loa_value;
          end if;
          if ( v_loa_kumuliert.konto_val_korr > 0
          or   v_loa_kumuliert.loa_value != 0)
          and v_loa_kumuliert.lohnart is not NULL
          then
            if in_schnittstelle = 'EXT_KW_MM'
            then
              insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                               v_bis_datum,
                                               v_personal.pers_vname, 
                                               v_personal.pers_nname,
                                               v_pb_abteilung);
            else
              if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
              then
                v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
              end if;
              insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
            end if;
          end if;
          if v_loa_kumuliert.konto_val_korr > 0
          then
            select min(loa.lz_lohnart), min(loa.lz_id) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
              from pzm_lohnarten loa,
                   pzm_pers_lohn_zulagen p_lz
             where loa.lz_typ = 'UEB_STD'
               and loa.lz_operator = 'UESTD'
               and loa.lz_id = p_lz.lz_id(+)
               and in_pers_nr = p_lz.pers_nr(+)
               and v_von_datum - 1 <= nvl(p_lz.gueltig_datum_bis(+), v_von_datum - 1)
               and v_von_datum - 1 >= nvl(p_lz.gueltig_datum_von(+), v_von_datum - 1);
            v_loa_kumuliert.loa_value := v_loa_kumuliert.konto_val_korr;
            
            v_loa_kumuliert.konto_val_korr := NULL;
            v_loa_kumuliert.konto_val_korr := NULL;
            v_loa_kumuliert.konten_bh_id_korr := NULL;
            if  v_loa_kumuliert.loa_value != 0
            and v_loa_kumuliert.lohnart is not NULL
            then
              if in_schnittstelle = 'EXT_KW_MM'
              then
                insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                 v_bis_datum,
                                                 v_personal.pers_vname, 
                                                 v_personal.pers_nname,
                                                 v_pb_abteilung);
              else
                if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                then
                  v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                end if;
                insert into pzm_ze_loa_exp_host values v_loa_kumuliert; -- Schreiben der LOA - Stundenaufbauukonto
              end if;
            end if;
          end if;
          v_loa_kumuliert.konto_nr_korr := NULL;
          v_loa_kumuliert.konto_val_korr := NULL;
          if v_korr_std > 0
          then
            v_korr_std := v_korr_std * -1;

            select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
              from pzm_lohnarten loa
             where loa.lz_id = (select max(loax.lz_link_loa_id)
                                  from pzm_lohnarten loax
                                 where loax.lz_link_loa_id is not NULL
                                   and loax.lz_alternativ_loa_id is NULL
                                   and loax.lz_konto_name_kurz = 'ZK');
            select sum(t.loa_value) into v_loa_kumuliert.loa_value
              from pzm_ze_loa_exp_host t
             where t.pb_id = v_loa_kumuliert.pb_id
               and t.pers_nr = v_loa_kumuliert.pers_nr
               and t.datum = v_loa_kumuliert.datum
               and t.lohnart = v_loa_kumuliert.lohnart;
            delete pzm_ze_loa_exp_host t
             where t.pb_id = v_loa_kumuliert.pb_id
               and t.pers_nr = v_loa_kumuliert.pers_nr
               and t.datum = v_loa_kumuliert.datum
               and t.lohnart = v_loa_kumuliert.lohnart;
            
            if pzm_p_base.get_lohnart_by_alternative_lz_id(v_loa_kumuliert.lz_id, v_lohnart)
            and v_lohnart.lz_operator = 'ERP_ZUS_ZK'
            then
              if v_loa_kumuliert.loa_value is NULL
              then
                select sum(t.loa_value) into v_loa_kumuliert.loa_value
                  from pzm_ze_loa_exp_host t
                 where t.pb_id = v_loa_kumuliert.pb_id
                   and t.pers_nr = v_loa_kumuliert.pers_nr
                   and t.datum = v_loa_kumuliert.datum
                   and t.lohnart = v_lohnart.lz_lohnart;
              end if;
              delete pzm_ze_loa_exp_host t
               where t.pb_id = v_loa_kumuliert.pb_id
                 and t.pers_nr = v_loa_kumuliert.pers_nr
                 and t.datum = v_loa_kumuliert.datum
                 and t.lohnart = v_lohnart.lz_lohnart;
            end if;
            
            if v_loa_kumuliert.loa_value is NULL
            then
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_link_loa_id is not NULL
                 and loa.lz_alternativ_loa_id is NULL
                 and loa.lz_konto_name_kurz = 'ZK';
              select sum(t.loa_value) into v_loa_kumuliert.loa_value
                from pzm_ze_loa_exp_host t
               where t.pb_id = v_loa_kumuliert.pb_id
                 and t.pers_nr = v_loa_kumuliert.pers_nr
                 and t.datum = v_loa_kumuliert.datum
                 and t.lohnart = v_loa_kumuliert.lohnart;
              delete pzm_ze_loa_exp_host t
               where t.pb_id = v_loa_kumuliert.pb_id
                 and t.pers_nr = v_loa_kumuliert.pers_nr
                 and t.datum = v_loa_kumuliert.datum
                 and t.lohnart = v_loa_kumuliert.lohnart;
              if pzm_p_base.get_lohnart_by_alternative_lz_id(v_loa_kumuliert.lz_id, v_lohnart)
              and v_lohnart.lz_operator = 'ERP_ZUS_ZK'
              then
                if v_loa_kumuliert.loa_value is NULL
                then
                  select sum(t.loa_value) into v_loa_kumuliert.loa_value
                    from pzm_ze_loa_exp_host t
                   where t.pb_id = v_loa_kumuliert.pb_id
                     and t.pers_nr = v_loa_kumuliert.pers_nr
                     and t.datum = v_loa_kumuliert.datum
                     and t.lohnart = v_lohnart.lz_lohnart;
                end if;
                delete pzm_ze_loa_exp_host t
                 where t.pb_id = v_loa_kumuliert.pb_id
                   and t.pers_nr = v_loa_kumuliert.pers_nr
                   and t.datum = v_loa_kumuliert.datum
                   and t.lohnart = v_lohnart.lz_lohnart;
              end if;
            end if;
            
            v_loa_kumuliert.loa_value := nvl(v_loa_kumuliert.loa_value, 0) + v_korr_std;
            if v_loa_kumuliert.loa_value < 0
            then
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_link_loa_id is not NULL
                 and loa.lz_alternativ_loa_id is NULL
                 and loa.lz_konto_name_kurz = 'ZK';
            else
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_id = (select max(loax.lz_link_loa_id)
                                    from pzm_lohnarten loax
                                   where loax.lz_link_loa_id is not NULL
                                     and loax.lz_alternativ_loa_id is NULL
                                     and loax.lz_konto_name_kurz = 'ZK');
            end if;
            
            v_loa_kumuliert.konto_val_korr := NULL;
            v_loa_kumuliert.konten_bh_id_korr := NULL;
            if  v_loa_kumuliert.loa_value != 0
            and v_loa_kumuliert.lohnart is not NULL
            then
              if in_schnittstelle = 'EXT_KW_MM'
              then
                insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                 v_bis_datum,
                                                 v_personal.pers_vname, 
                                                 v_personal.pers_nname,
                                                 v_pb_abteilung);
              else
                if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                then
                  v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                end if;
                if nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'T'  -- Kein Gehalt? - Hier ist Abfrage korrekt
                  -- FIX AG 2026022
                then
                  insert into pzm_ze_loa_exp_host values v_loa_kumuliert; -- Schreiben der LOA - Stundenaufbauukonto
                end if;
              end if;
              if pzm_p_base.get_lohnart_by_alternative_lz_id(v_loa_kumuliert.lz_id, v_lohnart)
              and v_lohnart.lz_operator = 'ERP_ZUS_ZK'
              then
                v_loa_kumuliert.lz_id   := v_lohnart.lz_id;
                v_loa_kumuliert.lohnart := v_lohnart.lz_lohnart;
                if in_schnittstelle = 'EXT_KW_MM'
                then
                  insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                   v_bis_datum,
                                                   v_personal.pers_vname, 
                                                   v_personal.pers_nname,
                                                   v_pb_abteilung);
                else
                  if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                  then
                    v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                  end if;
                  insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
      
      -- Hier die Stunden
      select min(loa.lz_lohnart), min(loa.lz_id) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
        from pzm_lohnarten loa,
             pzm_pers_lohn_zulagen p_lz
       where loa.lz_konto_name_kurz is NULL            -- Arbeitsstunden haben kein Konto
         and loa.lz_konto_bus is NULL                  -- Keine Kontobuchung
         and loa.lz_typ = 'ARB_STD'
         and loa.lz_operator = 'ARBSTD'
         and loa.lz_id = p_lz.lz_id(+)
         and in_pers_nr = p_lz.pers_nr(+)
         and v_von_datum - 1 <= nvl(p_lz.gueltig_datum_bis(+), v_von_datum - 1)
         and v_von_datum - 1 >= nvl(p_lz.gueltig_datum_von(+), v_von_datum - 1);
          
      if v_loa_kumuliert.lohnart is not NULL
      or nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'F'
      then
        /* -- Dies wird jetzt korrekt im Tagessatz gebucht (LOA 503 ARBSTD)
        if v_zk_monat_diff <= 0 -- Wenn die korrekte Differenz noch nich gerechnet worden ist
        then                    -- dann ggf. Abwesebheit als Arbeiteszeit mit berücksuchiten und wieder abziehen
          select sum(t.ze_std)  into v_arb_stunden    -- Abwesenheiten mit LOA für Arbeitsstunden
           from pzm_zeiterfassung t,
                pzm_abwesenheitsarten aa,
                pzm_lohnarten l
          where 1=1
            and t.ze_aa_status = aa.aa_id
            and aa.lz_id = l.lz_id
            and l.lz_operator = 'ARBSTD'
            and t.ze_pers_nr = in_pers_nr
            and t.ze_schicht_tag >= v_start_datum
            and t.ze_schicht_tag <= v_ende_datum;
          v_ueb_stunden_13w := v_ueb_stunden_13w - nvl(v_arb_stunden, 0);  -- Diese Arbeitsstunden dazunehmen
        end if;
        --v_zk_monat_diff := v_zk_monat_diff + nvl(v_arb_stunden, 0);
        */

        if in_schnittstelle != 'EXT_KW_MM'
        --and v_tarifmodell.tarif_fest_std != 'T'  
        then
          v_arb_stunden := pzm_utils.get_pers_arb_std(in_pers_nr,
                                                      v_loa_kumuliert.kst_id,
                                                      v_von_datum,
                                                      v_bis_datum,   -- Ermittlung der gearbeiteten Stunden
                                                      nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                      nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T');  -- Krank und Urlaub kommen dazu?
        else
          if in_schnittstelle = 'EXT_KW_MM'  
          then
            v_arb_stunden := pzm_utils.get_pers_arb_std(in_pers_nr,
                                                        NULL,
                                                        v_von_datum,
                                                        v_bis_datum,   -- Ermittlung der gearbeiteten Stunden
                                                        false, -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                        false -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T'
                                                        );  -- Krank und Urlaub kommen dazu?
          else
            v_arb_stunden := pzm_utils.get_pers_arb_std(in_pers_nr,
                                                        NULL,
                                                        v_von_datum,
                                                        v_bis_datum,   -- Ermittlung der gearbeiteten Stunden
                                                        true, -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                        true -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T'
                                                        );  -- Krank und Urlaub kommen dazu?
          end if;
        end if;
        v_arb_stunden := v_arb_stunden + v_zk_monat_diff_kug;                  -- KUG-Differenz hier wieder draufrechenen
        if v_kst_id = v_kst_id_zk 
        then
          v_arb_stunden := v_arb_stunden - v_ueb_stunden_13w; -- 13 W Schnitt abziehen
          if v_tarifmodell.tarif_fest_std != 'T'
          then
            v_ueb_stunden_13w := 0;
          end if;
          if nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'UE_IN_STUNDENLOHN'), 'T') = 'T'
          and v_zk_monat_diff > 0
          then
            v_arb_stunden := v_arb_stunden + v_zk_monat_diff;
            v_zk_monat_diff := 0;
          end if;
        end if;
        if v_tarifmodell.tarif_fest_std != 'T'
        then
          if nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'F_IN_STUNDENLOHN'), 'F') = 'T'
          then
            v_feiertags_std := pzm_utils.get_pers_feiertags_std(in_pers_nr,
                                                                v_loa_kumuliert.kst_id,
                                                                v_von_datum,
                                                                v_bis_datum);  -- Ermittlung der Feiertags-Stunden
          else
            v_feiertags_std := 0;
          end if;
        end if;

        -- v_loa_kumuliert.loa_value := nvl(v_arb_stunden, 0) + nvl(v_feiertags_std, 0) + nvl(v_zk_fuer_sundenlohn_std, 0);  -- Arbeitsstunden + Urlaub + Krank + Feiertag = Stundlohn-Stunden
        v_loa_kumuliert.loa_value := nvl(v_arb_stunden, 0) + nvl(v_feiertags_std, 0) + nvl(v_zk_fuer_sundenlohn_std, 0);  -- Arbeitsstunden + Urlaub + Krank + Feiertag = Stundlohn-Stunden
        v_stat_value_arb_std := v_stat_value_arb_std + v_loa_kumuliert.loa_value;
      end if;
          
      if v_loa_kumuliert.loa_value > 0
      and v_loa_kumuliert.lohnart is not NULL
      or nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'F'
      or v_tarifmodell.tarif_fest_std != 'T'
      then
        v_loa_std := NULL;
        if in_schnittstelle = 'EXT_KW_MM'
        then
          select sum(t.loa_value) into v_loa_std
            from pzm_ze_loa_exp_ext_gutsch t
           where t.lohnart = v_loa_kumuliert.lohnart
             and t.pers_nr = in_pers_nr
             and t.datum = v_loa_kumuliert.datum;
          if v_loa_std is not NULL
          then
            delete pzm_ze_loa_exp_host t 
             where t.lohnart = v_loa_kumuliert.lohnart
               and t.pers_nr = in_pers_nr
               and t.datum = v_loa_kumuliert.datum;
          end if;
        else
          select sum(t.loa_value) into v_loa_std
            from pzm_ze_loa_exp_host t
           where t.lohnart = v_loa_kumuliert.lohnart
             and t.pers_nr = in_pers_nr
             and t.datum = v_loa_kumuliert.datum
             and t.kst_id = v_loa_kumuliert.kst_id;
          if v_loa_std is not NULL
          then
            delete pzm_ze_loa_exp_host t 
             where t.lohnart = v_loa_kumuliert.lohnart
               and t.pers_nr = in_pers_nr
               and t.datum = v_loa_kumuliert.datum
               and t.kst_id = v_loa_kumuliert.kst_id;
          end if;
        end if;
        
        if nvl(v_vertragsart.va_loa_stunden_abrechnung, 'T') = 'F'
        then
          if v_kst_id = v_kst_id_zk
          then
            select min(loa.lz_lohnart), min(loa.lz_id) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
              from pzm_lohnarten loa,
                   pzm_pers_lohn_zulagen p_lz
             where loa.lz_konto_name_kurz is NULL            -- Arbeitsstunden haben kein Konto
               and loa.lz_konto_bus is NULL                  -- Keine Kontobuchung
               and loa.lz_typ = 'GEHALT'
               and loa.lz_operator = 'GEHALT'
               and loa.lz_id = p_lz.lz_id(+)
               and in_pers_nr = p_lz.pers_nr(+)
               and v_von_datum - 1 <= nvl(p_lz.gueltig_datum_bis(+), v_von_datum - 1)
               and v_von_datum - 1 >= nvl(p_lz.gueltig_datum_von(+), v_von_datum - 1);
            v_operator := ';UNB;';
            OPEN c_loa_kumuliert_stat;
            FETCH c_loa_kumuliert_stat into v_unbezahlt_std_value, v_unbezahlt_tag_value;
            CLOSE c_loa_kumuliert_stat;
            v_loa_kumuliert.loa_value := 1;
            if v_unbezahlt_std_value > 0
            and v_zk_monat_saldo_true = false
            then
              v_loa_kumuliert.loa_value := round(v_loa_kumuliert.loa_value / (v_unbezahlt_std_value + v_arb_stunden + nvl(v_ueb_stunden_loa2, 0)) * (v_arb_stunden+ nvl(v_ueb_stunden_loa2, 0)), 3);
              if v_loa_kumuliert.loa_value = 0
              then
                insert into pzm_ze_loa_exp_host values v_loa_kumuliert;
              else
                v_loa_kumuliert.loa_value := 1;
              end if;
            end if;
            if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
            then
              v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
            end if;
            insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
            v_loa_kumuliert.loa_value := 0;
          end if;
          if v_tarifmodell.tarif_fest_std = 'T'  -- Hier ist Gehalt und feste Monatsstunden
          then
            if v_tarifmodell.tarif_13w_schnitt = 'T'
            then
              v_F_U_K_stunden := v_uer_std_aus_K_U_F;
              v_uer_std_aus_K_U_F := v_uer_std_aus_K_U_F_13W;
            else
              v_uer_std_aus_K_U_F := v_F_U_K_stunden;
            end if;
            -- Setzen der Werte
            v_loa_kumuliert.pers_nr := in_pers_nr;
            v_loa_kumuliert.datum := add_months(v_von_datum, 1);
            v_loa_kumuliert.loa_grp := null;
            v_loa_kumuliert.aa_id := null;
            v_loa_kumuliert.status := 'N';
            v_loa_kumuliert.ret_code := null;
            v_loa_kumuliert.cycle := null;
            
            -- Salden von Monatsanfang und Ende ermitteln
            v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                         in_pers_nr,
                                                                         'ZK',
                                                                         v_ende_datum), 0);
            v_zk_monat_saldo_old := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                              in_pers_nr,
                                                                              'ZK',
                                                                              v_von_datum - 1), 0); -- Saldo Monatsbegin
            v_arb_stunden := v_arb_stunden + ((v_zk_monat_saldo - v_zk_monat_saldo_old) * -1); -- Das muss als Arbeitsstunden dazugerechnet werden, um die Korrektur zu berechnen
            v_loa_kumuliert.loa_value := ((v_zk_monat_saldo - v_zk_monat_saldo_old) * -1);
            v_loa_kumuliert.kst_id := nvl(v_kst_id, get_pers_kst_id(in_pers_nr));
            v_loa_kumuliert.ret_code := NULL;
            v_konten_bh_id := NULL;
            v_arb_plus_F_U_K_stunden := round(v_arb_stunden, 2);

            if nvl(v_tarifmodell.tarif_fest_std_je_periode, 0) > nvl(v_arb_plus_F_U_K_stunden, 0) -- Zu wenig gearbeitet
            then
              v_zk_monat_saldo := nvl(v_tarifmodell.tarif_fest_std_je_periode, 0) - nvl(v_arb_plus_F_U_K_stunden, 0);
            elsif nvl(v_tarifmodell.tarif_fest_std_je_periode, 0) < nvl(v_arb_plus_F_U_K_stunden, 0)
            then
              v_zk_monat_saldo := (nvl(v_arb_plus_F_U_K_stunden, 0) - nvl(v_tarifmodell.tarif_fest_std_je_periode, 0));
              v_zk_monat_saldo := v_zk_monat_saldo * -1;
            else
              v_zk_monat_saldo := 0;
            end if;
            v_ueb_stunden_13w := 0;
            v_loa_kumuliert.loa_value := (v_loa_kumuliert.loa_value + v_zk_monat_saldo); -- Differenz noch dazu
            
            if v_zk_monat_saldo <= 0 -- Die korrekte LOA ermitteln
            then
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_link_loa_id is not NULL
                 and loa.lz_alternativ_loa_id is NULL
                 and loa.lz_konto_name_kurz = 'ZK';
              v_zk_monat_saldo := v_zk_monat_saldo * -1;
            else
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_id = (select max(loax.lz_link_loa_id)
                                    from pzm_lohnarten loax
                                   where loax.lz_link_loa_id is not NULL
                                     and loax.lz_alternativ_loa_id is NULL
                                     and loax.lz_konto_name_kurz = 'ZK');
            end if;

            if v_zk_monat_saldo != 0 -- Es gibt eine Korrektur, dann die LOA schreiben (Das übernimt auch die Buchung im Konto)
            then
              select max(t.ts_datum) into v_datum -- Dein letzen Zeiteintrag in den tagessätzen finden
                from pzm_ze_tagessatz t
               where t.ts_datum >= v_von_datum
                 and t.ts_datum <= v_bis_datum
                 and t.ts_pers_nr = v_loa_kumuliert.pers_nr;
              set_loa_std(v_loa_kumuliert.pers_nr,
                          nvl(v_datum, v_bis_datum),  -- Fals kein Zeiteintrag, dann auf den letzen tag des Monats
                          v_loa_kumuliert.lohnart,
                          v_zk_monat_saldo,
                          NULL,
                          false,
                          v_loa_kumuliert.lz_id,
                          v_loa_kumuliert.kst_id);
            end if;
            
            if v_loa_kumuliert.loa_value < 0 -- Jetzt die korrekte LOA für den Statistik-Satz finden (KONTO ZK - Altanative LOA)
            then
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_link_loa_id is not NULL
                 and loa.lz_alternativ_loa_id is NULL
                 and loa.lz_konto_name_kurz = 'ZK';
            else
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_id = (select max(loax.lz_link_loa_id)
                                    from pzm_lohnarten loax
                                   where loax.lz_link_loa_id is not NULL
                                     and loax.lz_alternativ_loa_id is NULL
                                     and loax.lz_konto_name_kurz = 'ZK');
            end if;
            if pzm_p_base.get_lohnart_by_alternative_lz_id(v_loa_kumuliert.lz_id, v_lohnart)
            and v_lohnart.lz_operator = 'ERP_ZUS_ZK'
            and v_loa_kumuliert.loa_value != 0
            then

              v_loa_kumuliert.lz_id   := v_lohnart.lz_id;
              v_loa_kumuliert.lohnart := v_lohnart.lz_lohnart;
              if in_schnittstelle = 'EXT_KW_MM'
              then
                insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                 v_bis_datum,
                                                 v_personal.pers_vname, 
                                                 v_personal.pers_nname,
                                                 v_pb_abteilung);
              else
                if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                then
                  v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                end if;
                insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
              end if;
            end if;


          end if;
        else
          if v_tarifmodell.tarif_fest_std != 'T'
          then
            if in_schnittstelle = 'EXT_KW_MM'
            then
              insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                               v_bis_datum,
                                               v_personal.pers_vname, 
                                               v_personal.pers_nname,
                                               v_pb_abteilung);
            else
              if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
              then
                v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
              end if;
              insert into pzm_ze_loa_exp_host values v_loa_kumuliert; -- Schreiben der LOA - Stundenaufbauukonto
            end if;
          else
            if v_tarifmodell.tarif_13w_schnitt = 'T'
            then
              v_F_U_K_stunden := v_uer_std_aus_K_U_F;
              v_uer_std_aus_K_U_F := v_uer_std_aus_K_U_F_13W;
            else
              v_uer_std_aus_K_U_F := v_F_U_K_stunden;
            end if;
            v_loa_kumuliert.loa_value := nvl(v_tarifmodell.tarif_fest_std_je_periode - nvl(v_uer_std_aus_K_U_F, 0), v_loa_kumuliert.loa_value);
            v_loa_kumuliert.pers_nr := in_pers_nr;
            v_loa_kumuliert.datum := add_months(v_von_datum, 1);
            v_loa_kumuliert.loa_grp := null;
            v_loa_kumuliert.aa_id := null;
            v_loa_kumuliert.status := 'N';
            v_loa_kumuliert.ret_code := null;
            v_loa_kumuliert.cycle := null;
            
            v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                         in_pers_nr,
                                                                         'ZK',
                                                                         v_ende_datum), 0);

            v_loa_kumuliert.ret_code := 'ZK';
            v_loa_kumuliert.kst_id := nvl(v_kst_id, get_pers_kst_id(in_pers_nr));
            open c_pzm_konten_uk;               -- konto lesen
            fetch c_pzm_konten_uk into v_uk_konto;
            v_found_kto := c_pzm_konten_uk%found;
            close c_pzm_konten_uk;
            v_loa_kumuliert.ret_code := NULL;
            v_konten_bh_id := NULL;
            v_arb_plus_F_U_K_stunden := round(v_arb_stunden + v_uer_std_aus_K_U_F - v_F_U_K_stunden + nvl(v_f_stunden_loa,0), 2);

            if nvl(v_tarifmodell.tarif_fest_std_je_periode, 0) > nvl(v_arb_plus_F_U_K_stunden, 0) -- Zu wenig gearbeitet
            then
              if v_zk_monat_saldo > nvl(v_tarifmodell.tarif_fest_std_akz_minus, 0) * -1
              then
                if v_zk_monat_saldo + nvl(v_tarifmodell.tarif_fest_std_akz_minus, 0) < nvl(v_tarifmodell.tarif_fest_std_je_periode, 0) - nvl(v_arb_plus_F_U_K_stunden, 0)
                then
                  v_zk_monat_saldo := v_zk_monat_saldo + nvl(v_tarifmodell.tarif_fest_std_akz_minus, 0);
                  v_loa_kumuliert.loa_value := nvl(v_arb_plus_F_U_K_stunden, 0) + v_zk_monat_saldo;
                else
                  v_zk_monat_saldo := (nvl(v_tarifmodell.tarif_fest_std_je_periode, 0) - (nvl(v_arb_plus_F_U_K_stunden, 0) + nvl(v_zk_fuer_sundenlohn_std, 0)));
                end if;
                pzm_kontoverwaltung.abgang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                  in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                  v_zk_monat_saldo,
                                                  'pers_LOA_ME_KORR_TARIF ' || v_uk_konto.name, 'B',
                                                  get_pers_abt_id(in_pers_nr),
                                                  v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value - v_zk_monat_saldo;
                v_zk_monat_saldo := v_zk_monat_saldo * -1;
              else
                v_zk_monat_saldo := 0;
                
                v_loa_kumuliert.loa_value :=  nvl(v_arb_stunden, 0) -  nvl(v_uer_std_aus_K_U_F, 0);
                if v_zk_monat_saldo > 0
                then
                  pzm_kontoverwaltung.zugang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                    in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                    v_zk_monat_saldo,
                                                    'pers_LOA_ME_KORR_TARIF ' || v_uk_konto.name, 'B',
                                                    get_pers_abt_id(in_pers_nr),
                                                    v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
                end if;
              end if;
            elsif nvl(v_tarifmodell.tarif_fest_std_je_periode, 0) < nvl(v_arb_plus_F_U_K_stunden, 0)
            then
              v_zk_monat_saldo := (nvl(v_arb_plus_F_U_K_stunden, 0) - nvl(v_tarifmodell.tarif_fest_std_je_periode, 0));
              pzm_kontoverwaltung.zugang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                v_zk_monat_saldo,
                                                'pers_LOA_ME_KORR_TARIF ' || v_uk_konto.name, 'B',
                                                get_pers_abt_id(in_pers_nr),
                                                v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
              
              v_loa_kumuliert.loa_value := v_loa_kumuliert.loa_value + v_zk_monat_saldo;
            end if;
            update pzm_konten_bh t
               set t.zk_start = v_loa_kumuliert.datum - 1,
                   t.buch_datum = v_loa_kumuliert.datum - 1,
                   t.zk_aa_id = null
             where t.sid = '01'
               and t.firma_nr = 1
               and t.konten_bh_id = v_konten_bh_id;
            v_ueb_stunden_13w := 0;
            if in_schnittstelle = 'EXT_KW_MM'
            then
              insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                               v_bis_datum,
                                               v_personal.pers_vname, 
                                               v_personal.pers_nname,
                                               v_pb_abteilung);
            else
              if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
              then
                v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
              end if;
              insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
            end if;
            
            if v_zk_monat_saldo > 0
            then
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_link_loa_id is not NULL
                 and loa.lz_alternativ_loa_id is NULL
                 and loa.lz_konto_name_kurz = 'ZK';
            else
              select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
                from pzm_lohnarten loa
               where loa.lz_id = (select max(loax.lz_link_loa_id)
                                    from pzm_lohnarten loax
                                   where loax.lz_link_loa_id is not NULL
                                     and loax.lz_alternativ_loa_id is NULL
                                     and loax.lz_konto_name_kurz = 'ZK');
              
            end if;

            if v_zk_monat_saldo != 0
            then
              v_loa_kumuliert.ret_code := 'ZK';
              v_loa_kumuliert.loa_value := v_zk_monat_saldo * -1;
              if in_schnittstelle = 'EXT_KW_MM'
              then
                insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                 v_bis_datum,
                                                 v_personal.pers_vname, 
                                                 v_personal.pers_nname,
                                                 v_pb_abteilung);
              else
                if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                then
                  v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                end if;
                insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
              end if;
              if pzm_p_base.get_lohnart_by_alternative_lz_id(v_loa_kumuliert.lz_id, v_lohnart)
              and v_lohnart.lz_operator = 'ERP_ZUS_ZK'
              then
                v_loa_kumuliert.lz_id   := v_lohnart.lz_id;
                v_loa_kumuliert.lohnart := v_lohnart.lz_lohnart;
                if in_schnittstelle = 'EXT_KW_MM'
                then
                  insert_pzm_ze_loa_exp_ext_gutsch(v_loa_kumuliert,
                                                   v_bis_datum,
                                                   v_personal.pers_vname, 
                                                   v_personal.pers_nname,
                                                   v_pb_abteilung);
                else
                  if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                  then
                    v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                  end if;
                  insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
      
      -- ZK Konto abarbeiten Ohne Überstunden
      v_loa_kumuliert.loa_value := 0;
      if in_schnittstelle != 'EXT_KW_MM'
      then      
        OPEN c_loa_konto;
        LOOP
          FETCH c_loa_konto into v_pzm_loa_komto;
          EXIT when c_loa_konto%NOTFOUND;
          v_loa_kumuliert.loa_value := pzm_kontoverwaltung.zk_get_monat_zug_abg(in_pers_nr, 
                                                                                v_pzm_loa_komto.lz_konto_name_kurz,
                                                                                in_monat, in_jahr);
          v_loa_kumuliert.lohnart := v_pzm_loa_komto.lz_lohnart;
          v_loa_kumuliert.loa_unit := v_pzm_loa_komto.lz_einheit;
          if pzm_p_base.get_lohnart_by_loa(v_pzm_loa_komto.lz_lohnart, v_loa_kumuliert.aa_id, v_pzm_lonhnart)
          then
            if v_loa_kumuliert.loa_value > 0
            and v_loa_kumuliert.lohnart is not NULL
            and v_pzm_lonhnart.lz_konto_name_kurz != 'ZK'             -- Zeitkonto Zeitkonten sind bereits abgearbeitet
            then
              if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
              then
                v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
              end if;
              insert into pzm_ze_loa_exp_host values v_loa_kumuliert; -- Schreiben der LOA - Stundenaufbauukonto
            end if;
          end if;
        end LOOP;
        CLOSE c_loa_konto;
      else
        if v_bis_datum = v_ende_datum
        then
          v_loa_kumuliert.datum := add_months(v_von_datum, 1);
          v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_akt_saldo('01', 1,
                                                                       in_pers_nr,
                                                                       'ZK'), 0);
          if v_zk_monat_saldo != 0
          then
            v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_date_saldo('01', 1,
                                                                         in_pers_nr,
                                                                         'ZK',
                                                                         v_ende_datum), 0);
            v_loa_kumuliert.ret_code := 'ZK';
            if v_zk_monat_saldo > 0
            then
              open c_pzm_konten_uk;               -- konto lesen
              fetch c_pzm_konten_uk into v_uk_konto;
              v_found_kto := c_pzm_konten_uk%found;
              close c_pzm_konten_uk;
              pzm_kontoverwaltung.abgang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                v_zk_monat_saldo,
                                                'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                get_pers_abt_id(in_pers_nr),
                                                v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
              update pzm_konten_bh t
                 set t.zk_start = v_loa_kumuliert.datum - 1,
                     t.buch_datum = v_loa_kumuliert.datum - 1,
                     t.zk_aa_id = null
               where t.sid = '01'
                 and t.firma_nr = 1
                 and t.konten_bh_id = v_konten_bh_id;
              
            elsif v_zk_monat_saldo < 0
            then
              open c_pzm_konten_uk;               -- konto lesen
              fetch c_pzm_konten_uk into v_uk_konto;
              v_found_kto := c_pzm_konten_uk%found;
              close c_pzm_konten_uk;
              pzm_kontoverwaltung.zugang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                v_zk_monat_saldo * -1,
                                                'pers_LOA_ME_KORR ' || v_uk_konto.name, 'B',
                                                get_pers_abt_id(in_pers_nr),
                                                v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
              update pzm_konten_bh t
                 set t.zk_start = v_loa_kumuliert.datum - 1,
                     t.buch_datum = v_loa_kumuliert.datum - 1,
                     t.zk_aa_id = null
               where t.sid = '01'
                 and t.firma_nr = 1
                 and t.konten_bh_id = v_konten_bh_id;
              
            end if;
          end if;
        end if;
      end if;
    end LOOP;
    CLOSE c_ze_tagessatz_kst_id;
    if in_schnittstelle != 'EXT_KW_MM'
    then
      -- Hier AKZ Auszahlen wenn Austrittsdatum erreicht
      if v_personal.pers_austrittdatum <= v_ende_datum
      and v_personal.pers_austrittdatum >= v_start_datum
      then
        v_zk_monat_saldo := nvl(pzm_kontoverwaltung.zk_get_akt_saldo('01', 1,
                                                                     in_pers_nr,
                                                                     'ZK'), 0);
        if v_zk_monat_saldo > 0
        then
          v_loa_kumuliert.pb_id := get_pers_pb_id(in_pers_nr);
          v_loa_kumuliert.pers_nr := in_pers_nr;
          v_loa_kumuliert.kst_id := get_pers_kst_id(in_pers_nr);
          v_loa_kumuliert.datum := add_months(v_von_datum, 1);
          v_loa_kumuliert.loa_grp := null;
          v_loa_kumuliert.aa_id := null;
          v_loa_kumuliert.status := 'N';
          v_loa_kumuliert.ret_code := null;
          v_loa_kumuliert.cycle := null;
          select min(loa.lz_lohnart), min(loa.lz_id) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
            from pzm_lohnarten loa,
                 pzm_pers_lohn_zulagen p_lz
           where loa.lz_konto_name_kurz is NULL            -- Arbeitsstunden haben kein Konto
             and loa.lz_konto_bus is NULL                  -- Keine Kontobuchung
             and loa.lz_typ = 'AUSZ_STD'
             and loa.lz_operator = 'AUSZ_AUSTR'
             and loa.lz_id = p_lz.lz_id(+)
             and in_pers_nr = p_lz.pers_nr(+)
             and v_von_datum - 1 <= nvl(p_lz.gueltig_datum_bis(+), v_von_datum - 1)
             and v_von_datum - 1 >= nvl(p_lz.gueltig_datum_von(+), v_von_datum - 1);
              
          if v_loa_kumuliert.lohnart is not NULL
          then
            v_loa_kumuliert.ret_code := 'ZK';
            open c_pzm_konten_uk;               -- konto lesen
            fetch c_pzm_konten_uk into v_uk_konto;
            v_found_kto := c_pzm_konten_uk%found;
            close c_pzm_konten_uk;
            if v_found_kto
            then
              pzm_kontoverwaltung.abgang_Buchen('01', 1, v_uk_konto.konto_nr,
                                                in_pers_nr, get_pers_kst_id(in_pers_nr),
                                                v_zk_monat_saldo,
                                                'pers_LOA_AUSZ_AUSTRITT ' || v_uk_konto.name, 
                                                'B',
                                                get_pers_abt_id(in_pers_nr),
                                                v_konten_bh_id); -- Korrekturbuchung auf Konto -> Diese Stunden werden ausgezahlt
              update pzm_konten_bh t
                 set t.zk_start = v_loa_kumuliert.datum - 1,
                     t.buch_datum = v_loa_kumuliert.datum - 1,
                     t.zk_aa_id = null
               where t.sid = '01'
                 and t.firma_nr = 1
                 and t.konten_bh_id = v_konten_bh_id;
              v_loa_kumuliert.loa_value := v_zk_monat_saldo;
              v_loa_kumuliert.loa_unit := 'STD';
            end if;
            if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
            then
              v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
            end if;
            insert into pzm_ze_loa_exp_host values v_loa_kumuliert; -- Schreiben der LOA - Stundenaufbauukonto
            select nvl(min(loa.lz_lohnart), v_loa_kumuliert.lohnart), nvl(min(loa.lz_id), v_loa_kumuliert.lz_id ) into v_loa_kumuliert.lohnart, v_loa_kumuliert.lz_id 
              from pzm_lohnarten loa
             where loa.lz_id = (select max(loax.lz_link_loa_id)
                                  from pzm_lohnarten loax
                                 where loax.lz_link_loa_id is not NULL
                                   and loax.lz_alternativ_loa_id is NULL
                                   and loax.lz_konto_name_kurz = 'ZK');
            if v_loa_kumuliert.lohnart is not NULL
            then
              v_loa_std := NULL;
              select sum(t.loa_value) into v_loa_std
                from pzm_ze_loa_exp_host t
               where t.lohnart = v_loa_kumuliert.lohnart
                 and t.pers_nr = in_pers_nr
                 and t.datum = v_loa_kumuliert.datum
                 and t.kst_id = v_loa_kumuliert.kst_id;
              /* Abgang nicht noch einmam buchen nur Statistik
              if v_loa_std is not NULL
              then
                update pzm_ze_loa_exp_host t
                   set t.loa_value = t.loa_value + v_loa_kumuliert.loa_value
                 where t.lohnart = v_loa_kumuliert.lohnart
                   and t.pers_nr = in_pers_nr
                   and t.datum = v_loa_kumuliert.datum
                   and t.kst_id = v_loa_kumuliert.kst_id;
              else
                if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                then
                  v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                end if;
                insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
              end if;
              */
              if pzm_p_base.get_lohnart_by_alternative_lz_id(v_loa_kumuliert.lz_id, v_lohnart)
              and v_lohnart.lz_operator = 'ERP_ZUS_ZK'
              then
                v_loa_kumuliert.lz_id   := v_lohnart.lz_id;
                v_loa_kumuliert.lohnart := v_lohnart.lz_lohnart;
                begin
                  if v_loa_std is not NULL
                  then
                    update pzm_ze_loa_exp_host t
                       set t.loa_value = t.loa_value + v_loa_kumuliert.loa_value
                     where t.lohnart = v_loa_kumuliert.lohnart
                       and t.pers_nr = in_pers_nr
                       and t.datum = v_loa_kumuliert.datum
                       and t.kst_id = v_loa_kumuliert.kst_id;
                  else
                    if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
                    then
                      v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
                    end if;
                    insert_pzm_ze_loa_exp_host(v_loa_kumuliert, v_kst_tab, v_kst_idx_max);
                  end if;
                exception
                  when others 
                    then 
                      update pzm_ze_loa_exp_host t
                         set t.loa_value = t.loa_value + v_loa_kumuliert.loa_value
                       where t.lohnart = v_loa_kumuliert.lohnart
                         and t.pers_nr = in_pers_nr
                         and t.datum = v_loa_kumuliert.datum
                         and t.kst_id = v_loa_kumuliert.kst_id;
                end;
              end if;
            end if;
          end if;
        end if;
      end if;
      if v_vertragsart.va_reset_monats_ende = 1
      then
        c_reset_Monatsende(in_pers_nr, v_loa_kumuliert.datum - 1, v_result);
      end if;
      
      v_loa_kumuliert.pers_nr := nvl(v_loa_kumuliert.pers_nr, in_pers_nr);
      v_loa_kumuliert.datum := add_months(v_von_datum, 1);
      if v_found_ue = true -- Daten bereits übertragen und es muss eine korrektur durchgeführt werden
      then
        v_loa_kumuliert.status := 'NK';  -- Neu korrigiert
      end if;
      insert_pzm_bereitschaft(v_loa_kumuliert, v_start_datum, v_ende_datum, v_kst_tab, v_kst_idx_max);

      -- Hier die Statistik
      v_urlaub_std_value := NULL;
      v_urlaub_tag_value := NULL;
      v_unbezahlt_std_value := NULL;
      v_unbezahlt_tag_value := NULL;
      
      OPEN c_loa_stat_cfg;
      LOOP
        FETCH c_loa_stat_cfg into v_loa_stat_cfg;
        EXIT when c_loa_stat_cfg%NOTFOUND;
        v_stat_value := 0;
        case when v_loa_stat_cfg.operator = 'ARBSTD'
             then
               if v_loa_stat_cfg.value_unit = 'HH24'
               then
                 /* 
                 v_stat_value := pzm_utils.get_pers_arb_std(in_pers_nr,
                                                            NULL, -- v_loa_kumuliert.kst_id,
                                                            v_von_datum,
                                                            v_bis_datum,   -- Ermittlung der gearbeiteten Stunden
                                                            false,  -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                            false); -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T');  -- Krank und Urlaub kommen dazu?
                 v_stat_value := round(v_stat_value * v_13_w_schnitt / v_day_schnitt, 3);
                 */
                 v_stat_value := v_stat_value_arb_std;
               else
                 v_stat_value := pzm_utils.get_pers_anw_tage(in_pers_nr,
                                                             NULL, -- v_loa_kumuliert.kst_id,
                                                             v_von_datum,
                                                             v_bis_datum);   -- Ermittlung der gearbeiteten Tage
               end if;
             when v_loa_stat_cfg.operator = 'K'
             then
               if v_loa_stat_cfg.value_unit = 'HH24'
               then 
                  v_stat_value := pzm_utils.get_pers_krank_std(in_pers_nr,
                                                               NULL, -- v_loa_kumuliert.kst_id,
                                                               v_von_datum,
                                                               v_bis_datum);   -- Ermittlung der krank Stunden
                 v_stat_value := round(v_stat_value * v_13_w_schnitt / v_day_schnitt, 3);
                 
               else
                 v_stat_value := pzm_utils.get_pers_krank_tage(in_pers_nr,
                                                               NULL, -- v_loa_kumuliert.kst_id,
                                                               v_von_datum,
                                                               v_bis_datum);   -- Ermittlung der gearbeiteten Tage
               end if;
             when v_loa_stat_cfg.operator = 'U' 
             then
               if v_urlaub_std_value is NULL
               then
                 v_operator := ';U;SU;';
                 OPEN c_loa_kumuliert_stat;
                 FETCH c_loa_kumuliert_stat into v_urlaub_std_value, v_urlaub_tag_value;
                 CLOSE c_loa_kumuliert_stat;
               end if;
               if v_loa_stat_cfg.value_unit = 'HH24'
               then 
                 v_stat_value := v_urlaub_std_value;
                 v_stat_value := round(v_stat_value * v_13_w_schnitt / v_day_schnitt, 3);
               else
                 if v_day_schnitt > 0
                 then
                   v_stat_value := round(v_urlaub_std_value / v_day_schnitt, 3); 
                 else
                   v_stat_value := v_urlaub_tag_value;
                 end if;
               end if;
             when v_loa_stat_cfg.operator =  'UNBEZAHLT'
             then
               if v_unbezahlt_std_value is NULL
               then
                 v_operator := ';UNB;';
                 OPEN c_loa_kumuliert_stat;
                 FETCH c_loa_kumuliert_stat into v_unbezahlt_std_value, v_unbezahlt_tag_value;
                 CLOSE c_loa_kumuliert_stat;
               end if;
               if v_loa_stat_cfg.value_unit = 'HH24'
               then 
                 v_stat_value := v_unbezahlt_std_value;
                 -- v_stat_value := round(v_stat_value * v_13_w_schnitt / v_day_schnitt, 3);
               else
                 v_stat_value := v_unbezahlt_tag_value;
               end if;
            else
              NULL;

        end case;
        if in_schnittstelle = 'LODAS' -- LODAS Schnittstelle bekommt auch die Statistik
        and v_stat_value > 0
        then
          insert into pzm_ze_loa_statistik_exp_host
            (pb_id, 
             pers_nr, 
             datum, 
             stat_value, 
             stat_unit, 
             status, 
             kst_id)
          values
            (v_loa_kumuliert.pb_id, 
             in_pers_nr, 
             v_folgemonat_datum, 
             v_stat_value, 
             v_loa_stat_cfg.stat_unit, 
             'N', 
             get_pers_kst_id(in_pers_nr));
        end if;
      end LOOP;
      CLOSE c_loa_stat_cfg;
    else
      c_pdl_equal_pay(in_pers_nr, v_ende_datum);
    end if;

    if v_vertragsart.va_bis_monat_ende_sim = 'T'
    and trunc(sysdate) <= v_bis_datum
    then
      v_datum := trunc(sysdate);
      delete pzm_zeiterfassung t
        where t.ze_pers_nr = in_pers_nr
          and t.ze_schicht_tag >= v_datum + 1
          and t.ze_schicht_tag <= v_bis_datum
          and t.ze_korr_pers_nr is NULL
          and t.ze_typ in ('S', 'A');
      update pzm_zeiterfassung t
         set t.ze_calc_ist_start = NULL,
             t.ze_calc_ist_ende = NULL,
             t.ze_std = 0
        where t.ze_pers_nr = in_pers_nr
          and t.ze_schicht_tag = v_datum
          and t.ze_calc_ist_ende > sysdate
          and t.ze_korr_pers_nr is NULL
          and t.ze_typ = 'L';
      delete pzm_ze_tagessatz t
        where t.ts_pers_nr = in_pers_nr
          and t.ts_datum >= v_datum
          and t.ts_datum  <= v_bis_datum
          and (t.ts_day_wert_ende is NULL or t.ts_datum > v_datum);
    end if;
    
    commit;

    if v_tarifmodell.tarif_13w_schnitt = 'T'
    then
      c_save_13_w_schnitt(in_pers_nr, v_von_datum);
    end if;
    v_result := c_azk_urlaub_monat_Abschluss(in_pers_nr, v_bis_datum);

    v_result := nvl(v_result, 'T');
    return(v_result);
  end;

  procedure insert_pzm_pdl_kst_equal_pay(in_loa_kumuliert   in pzm_ze_loa_exp_ext_gutsch%rowtype, 
                                         in_kst_tab         in t_kst_std_tab,
                                         in_kst_idx_max     in integer) is

    v_kst_idx                            integer;
    v_pdl_kst_equal_pay                  pzm_pdl_kst_equal_pay%rowtype;
  begin
    v_kst_idx := 1;
    v_pdl_kst_equal_pay.datum            := in_loa_kumuliert.datum;
    v_pdl_kst_equal_pay.pb_id            := in_loa_kumuliert.pb_id;
    v_pdl_kst_equal_pay.pb_abteilung_id  := in_loa_kumuliert.pb_abteilung_id;
    v_pdl_kst_equal_pay.pers_nr          := in_loa_kumuliert.pers_nr;
    v_pdl_kst_equal_pay.pers_vname       := in_loa_kumuliert.pers_vname;
    v_pdl_kst_equal_pay.pers_nname       := in_loa_kumuliert.pers_nname;
    v_pdl_kst_equal_pay.lohnart          := in_loa_kumuliert.lohnart;

    LOOP
      EXIT when v_kst_idx > in_kst_idx_max;
      v_pdl_kst_equal_pay.loa_value := round(in_loa_kumuliert.loa_value * in_kst_tab(v_kst_idx).kst_proz, 3);

      if v_pdl_kst_equal_pay.loa_value != 0
      then
        v_pdl_kst_equal_pay.kst_nr := in_kst_tab(v_kst_idx).kst_id;
        v_pdl_kst_equal_pay.kst_anteil := round(in_kst_tab(v_kst_idx).kst_proz, 3);
        insert into pzm_pdl_kst_equal_pay values v_pdl_kst_equal_pay;
      end if;
      v_kst_idx := v_kst_idx + 1;
    end LOOP;
  end;

  procedure c_pdl_equal_pay (in_pers_nr       pzm_personal.pers_nr%type,
                             in_datum         in date) is

    v_kst_tab t_kst_std_tab;
    v_kst_tab_emty t_kst_std_tab;

    v_kst_idx                           integer;
    v_kst_idx_max                       integer;
    v_kst_sum_std                       number;

    v_kst_id                      pzm_personal.pers_kst_id%type;
    v_kst_id_zk                   pzm_personal.pers_kst_id%type;
    v_kst_std                     number;

    v_von_datum date;
    v_bis_datum date;
    v_start_datum date;
    v_ende_datum date;
    
    v_pzm_ze_loa_exp_ext_gutsch  pzm_ze_loa_exp_ext_gutsch%rowtype;

    cursor c_ze_tagessatz_kst_id is
      select nvl(t.ts_day_kst_id, get_pers_kst_id(in_pers_nr)) ts_day_kst_id,
             sum(t.ts_day_arb_std + t.ts_day_ueb_std + t.ts_day_flex_std) ts_std
        from PZM_ZE_Tagessatz t
       where t.ts_pers_nr = in_pers_nr
         and t.ts_datum >= v_von_datum
         and t.ts_datum <= v_bis_datum
       group by nvl(t.ts_day_kst_id, get_pers_kst_id(in_pers_nr));
       
    cursor c_pzm_ze_loa_exp_ext_gutsch is
      select max(datum), 
             pb_id, 
             pb_abteilung_id, 
             pers_nr, 
             lohnart, 
             sum(loa_value), 
             pers_vname, 
             pers_nname, 
             max(konto_nr_korr), 
             sum(konto_val_korr), 
             max(konten_bh_id_korr), 
             max(status), 
             max(ret_code), 
             max(err_text), 
             max(created_date), 
             max(created_login_id), 
             max(created_user), 
             max(last_change_date), 
             max(last_change_login_id), 
             max(last_change_user), 
             max(ts_start_zeit), 
             max(ts_ende_zeit),
             NULL,
             sum(ts_pause_zeit) 
        from pzm_ze_loa_exp_ext_gutsch
       where pers_nr = in_pers_nr
         and datum >= v_von_datum
         and datum <= v_bis_datum
       group by  pb_id, 
                 pb_abteilung_id, 
                 pers_nr, 
                 lohnart, 
                 pers_vname, 
                 pers_nname;
  begin
    v_start_datum := trunc(in_datum, 'iw');
    v_von_datum := v_start_datum;
    v_ende_datum := v_von_datum + 6;
    --if to_char (v_start_datum, 'mm') != to_char(v_ende_datum, 'mm') -- Monatswechsel 
    --then
    --  v_bis_datum := last_day(v_von_datum);
    --else
    --  v_bis_datum := v_von_datum + 6;
    --end if;
    v_bis_datum := v_von_datum;

    -- Loeschen der Alt-Daten
    delete pzm_pdl_kst_equal_pay t -- Falls etwas da ist, dann löschen
     where t.pers_nr = in_pers_nr
       and t.datum >= v_start_datum
       and t.datum <=  v_ende_datum;

    LOOP
      v_kst_tab := v_kst_tab_emty; -- Tabelle leeren
      v_kst_idx := 0;
      v_kst_sum_std := 0;
      OPEN c_ze_tagessatz_kst_id; -- daten aus den tagessätzen holen
      LOOP                        -- Tabelle füllen
        FETCH c_ze_tagessatz_kst_id into v_kst_id, v_kst_std;
        EXIT when c_ze_tagessatz_kst_id%NOTFOUND;
          
        v_kst_idx := v_kst_idx + 1;
        v_kst_tab(v_kst_idx).kst_id := v_kst_id;
        v_kst_tab(v_kst_idx).kst_std := v_kst_std;
        v_kst_sum_std := v_kst_sum_std + v_kst_std;
      end LOOP;
      v_kst_idx_max := v_kst_idx;
      CLOSE c_ze_tagessatz_kst_id;

      -- Prozente ausrechnen 
      v_kst_idx := 0;
      LOOP
        v_kst_idx := v_kst_idx + 1;
        if v_kst_sum_std > 0
        then
          v_kst_tab(v_kst_idx).kst_proz := v_kst_tab(v_kst_idx).kst_std / v_kst_sum_std;
          if v_kst_tab(v_kst_idx).kst_std > v_kst_std
          then
            v_kst_id := v_kst_tab(v_kst_idx).kst_id;
            v_kst_std :=  v_kst_tab(v_kst_idx).kst_std;
            v_kst_id_zk := v_kst_id;
          end if;
        else
          if v_kst_idx_max > 0
          then
            v_kst_id := v_kst_tab(v_kst_idx).kst_id;
            v_kst_std :=  v_kst_tab(v_kst_idx).kst_std;
            v_kst_tab(v_kst_idx).kst_proz := 1 / v_kst_idx_max;
            v_kst_id_zk := v_kst_id;
          else
            v_kst_id_zk := v_kst_id;
            v_kst_tab(v_kst_idx).kst_proz := 1;
          end if;
        end if;
        EXIT when v_kst_idx >= v_kst_idx_max;
      end LOOP;
      
      OPEN c_pzm_ze_loa_exp_ext_gutsch; -- Öffnen der Gutschriften für diese pers_nr und Stichtag
      LOOP                              -- Druch alle Gutschriftseinträge
        FETCH c_pzm_ze_loa_exp_ext_gutsch into v_pzm_ze_loa_exp_ext_gutsch; -- lesen
        EXIT when c_pzm_ze_loa_exp_ext_gutsch%notfound;                     -- End wenn nichts mehr da
        v_pzm_ze_loa_exp_ext_gutsch.datum := v_bis_datum;                   -- Stichtagdatum eintragen
        insert_pzm_pdl_kst_equal_pay(v_pzm_ze_loa_exp_ext_gutsch,           -- daten in die Equal pay Tabelle schreiben
                                     v_kst_tab,
                                     v_kst_idx_max);
      end LOOP;
      
      CLOSE c_pzm_ze_loa_exp_ext_gutsch;
      
      if v_bis_datum < v_ende_datum
      then
        --v_bis_datum := v_ende_datum;
        --v_von_datum := trunc(v_ende_datum, 'month');
        v_von_datum := v_von_datum + 1;
        v_bis_datum := v_von_datum;
      else
        EXIT;
      end if;
    end LOOP;
    commit;
  end;    
    
  function c_azk_urlaub_monat_Abschluss (in_pers_nr       pzm_personal.pers_nr%type,
                                         in_datum         in date
                                        ) return varchar2 is
    CURSOR c_azk_ur_m_ab is
      select p.pers_pb_id,
             p.pers_nr,
             p.pers_nname,
             p.pers_vname,
             in_datum datum,
             round(p.pers_urlaub_anspr_wert, 3) Urlaubsanspruch_Tage_Jahr, -- Immer in Tagen erfasst
             round(p.pers_urlaub_anspr_wert*get_pers_schicht_d_std(p.pers_nr), 3) Urlaubsanspruch_Stunden_Jahr,
             case when k.buch_einheit = 'HH24'
                  then round(pzm_kontoverwaltung.zk_get_date_saldo('01', 1, p.pers_nr, k.name_kurz, trunc(in_datum)), 3) 
                  else round(pzm_kontoverwaltung.zk_get_date_saldo('01', 1, p.pers_nr, k.name_kurz, trunc(in_datum)), 3) * get_pers_schicht_d_std(p.pers_nr)
                  end  Resturlaub_Stunden,
             round(pzm_kontoverwaltung.zk_get_date_saldo('01', 1, p.pers_nr, zk.name_kurz, trunc(in_datum)), 3) Arbeitskonto_Saldo_Stunden, -- immer in Stunden
             p.pers_kst_id
        from pzm_personal p,
             pzm_abwesenheitsarten a,
             pzm_lohnarten l,
             Pzm_Konten k,
             Pzm_Konten zk
       where 1=1
         and p.pers_nr = in_pers_nr
         and p.pers_pb_id is not NULL
         and a.aa_id = p.pers_urlaub_anspr_aa_id
         and a.lz_id = l.lz_id
         and p.pers_nr = k.pers_nr
         and k.name_kurz = l.lz_konto_name_kurz -- in ('UK', 'UKS')
         and zk.pers_nr = p.pers_nr
         and zk.name_kurz = 'ZK';
    v_azk_ur_m_ab                               c_azk_ur_m_ab%rowtype;
  begin
    delete PZM_ZE_AZK_URLAUB t
      where t.pers_nr = in_pers_nr
        and t.datum = in_datum;
    OPEN c_azk_ur_m_ab;
    FETCH c_azk_ur_m_ab into v_azk_ur_m_ab;
    if c_azk_ur_m_ab%FOUND
    then
      insert into pzm_ze_azk_urlaub
        (pb_id, 
         pers_nr, 
         nname, 
         vname, 
         datum, 
         urlaubsanspruch_tage_jahr, 
         urlaubsanspruch_stunden_jahr, 
         resturlaub_stunden, 
         arbeitskonto_saldo_stunden, 
         pers_kst_id,
         status)
      values
        (v_azk_ur_m_ab.pers_pb_id, 
         v_azk_ur_m_ab.pers_nr, 
         v_azk_ur_m_ab.pers_nname, 
         v_azk_ur_m_ab.pers_vname, 
         v_azk_ur_m_ab.datum, 
         v_azk_ur_m_ab.urlaubsanspruch_tage_jahr, 
         v_azk_ur_m_ab.urlaubsanspruch_stunden_jahr, 
         v_azk_ur_m_ab.resturlaub_stunden, 
         v_azk_ur_m_ab.arbeitskonto_saldo_stunden, 
         v_azk_ur_m_ab.pers_kst_id,
         'N');
      commit;
    end if;
    rollback;
    CLOSE c_azk_ur_m_ab;
    return NULL;    
  end;    

  function c_loa_im_host_aktivieren (in_pers_nr       pzm_personal.pers_nr%type,
                                     in_monat         in number,
                                     in_jahr          in number
                                     ) return varchar2 is
     v_von_datum date;
     v_folgemonat_datum date;
  begin
    if in_jahr <= 99
    then
      v_von_datum := to_date('01.' || lpad(in_monat, 2, '0')  || '.' || lpad(in_jahr, 2, '0'), 'dd.mm.yy');
    else
      v_von_datum := to_date('01.' || lpad(in_monat, 2, '0') || '.' || lpad(in_jahr, 4, '0'), 'dd.mm.yyyy');
    end if;
    v_folgemonat_datum := add_months(v_von_datum, 1);
 
    update PZM_ZE_LOA_EXP_HOST t
    set t.status = 'U' 
    where t.pers_nr = in_pers_nr
          and t.datum = v_folgemonat_datum
          and t.status = 'N';
    update PZM_ZE_LOA_EXP_HOST t
    set t.status = 'UK' 
    where t.pers_nr = in_pers_nr
          and t.datum = v_folgemonat_datum
          and t.status = 'NK';
    commit;
    return ('T');
  end;

  

end;
/



-- sqlcl_snapshot {"hash":"59b76a1a6eadccebd145bbdcc9ff71e1934919e5","type":"PACKAGE_BODY","name":"PZM_LOHNAUSWERTUNG","schemaName":"DIRKSPZM32","sxml":""}