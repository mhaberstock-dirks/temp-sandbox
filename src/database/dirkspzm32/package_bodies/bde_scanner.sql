create or replace 
package body DIRKSPZM32.bde_scanner IS


procedure bde_sc_barcode_fa_id_menge(in_barcode       in varchar2,
                                     out_leitzahl    out bde_fa_auftrag.leitzahl%type,
                                     out_fa_ag       out bde_fa_auftrag.fa_ag%type,
                                     out_menge       out lvs_lam.menge%type,
                                     out_lhm_id      out string
                                    );

procedure bde_sc_pd_prod_insert(in_sid         in isi_sid.sid%type,
                                in_vorg_typ    in bde_pd_prod.vorg_typ%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_barcode     in lvs_lhm.lhm_id%type,
                                in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                                in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                                in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                in_res_id      in isi_resource.res_id%type,
                                in_pers_nr     in isi_user.pers_nr%type,
                                in_menge_a     in bde_pd_prod.menge_a%type,
                                in_menge_b     in bde_pd_prod.menge_b%type,
                                in_schrott     in bde_pd_prod.schrott%type,
                                in_ls_login_id in isi_user.login_id%type,
                                in_fae_id      in bde_pd_prod.fae_id%type);

procedure bde_sc_pd_spez_prod(in_sid         in isi_sid.sid%type,
                              in_vorg_typ    in bde_pd_prod.vorg_typ%type,
                              in_firma_nr    in isi_firma.firma_nr%type,
                              in_barcode     in lvs_lte.lte_id%type,
                              in_artikel_id  in isi_artikel.artikel_id%type,
                              in_res_id      in isi_resource.res_id%type,
                              in_pers_nr     in isi_user.pers_nr%type,
                              in_menge       in bde_pd_prod.menge_a%type,
                              in_charge      in lvs_charge.charge_bez%type,
                              in_ls_login_id in isi_user.login_id%type,
                              in_fae_id      in bde_pd_prod.fae_id%type,
                              in_out_lhm_id  in out lvs_lam.lhm_id%type);

function get_version return varchar2 is
begin
  return(v_version_str);
end get_version;


function bde_c_scanner_Status(in_scanner_name in varchar2,
                              in_name         in varchar2,
                              in_Aufgabe      in Varchar2,
                              out_msg         out varchar2
                              ) return boolean is
  v_result boolean;
  v_name   varchar2(100);
begin

  v_result := bde_c_scanner_Status_name (in_scanner_name,             -- in_scanner_name in varchar2,
                                         in_name,                     -- in_name         in varchar2,
                                         in_Aufgabe,                  -- in_Aufgabe      in Varchar2,
                                         v_name,                      -- out_name        out varchar2,
                                         out_msg);                    -- out_msg         out varchar2
  return (v_result);

end bde_c_scanner_status;



function bde_c_scanner_Status_name(in_scanner_name in varchar2,
                                   in_name         in varchar2,
                                   in_Aufgabe      in Varchar2,
                                   out_name        out varchar2,
                                   out_msg         out varchar2
                                   ) return boolean is
  -------------------------------------------------------------------------------------------------------
  -- Funktion aender Status fuer einen Scanner
  -- in Aufgabe ist: A          --> User Anmeldung
  --                 E          --> User Abmelden (Scanner wieder frei)
  --                 PRODUKTION --> Scanner steht auf Produktion der Maschiene in_name ZUGANG
  --                 BESCHICKEN --> Scanner steht auf Beschicken der Maschiene in_name ABGANG
  -------------------------------------------------------------------------------------------------------

  Result boolean;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);


  -------------------------------------------------------------------------------------------------------
  -- Variablen
  -------------------------------------------------------------------------------------------------------


  v_ls_login_id isi_scanner_cfg.ls_login_id%type;    -- Login ID aus dem Terminal
  v_nname       isi_user.nachname%type;              -- Nachname für Return
  v_vname       isi_user.vorname%type;               -- Vorname
  v_login_name  isi_user.username%type;
  v_aufgabe     varchar2(20);                        -- ZUGANG oder ABGANG
  v_scanner     isi_scanner_cfg%rowtype;

  v_res_id      isi_scanner_cfg.res_id%type;         -- Res_id der Maschien
  v_res_name    isi_resource.res_name%type;          -- Name der Maschien
  v_msg         varchar2(80);

  v_found       boolean;


  -------------------------------------------------------------------------------------------------------
  -- Cursor
  -------------------------------------------------------------------------------------------------------

  CURSOR c_name is
    select isi_user.nachname,
           isi_user.vorname,
           isi_term_res.ls_login_id,
           isi_user.username
      from isi_arbeitsplatz,
           isi_term_res,
           isi_user
     where lower(isi_arbeitsplatz.ip_name) = lower(in_name)
       and isi_arbeitsplatz.ip_adresse = isi_term_res.ip_adresse
       and isi_term_res.aktiv = 1
       and isi_term_res.ls_login_id = isi_user.login_id(+);

  CURSOR c_term_res is
    select min(isi_user.nachname) nachname,
           min(isi_user.vorname) vorname,
           min(isi_term_res.ls_login_id) ls_login_id,
           min(isi_user.username) username
      from isi_term_res,
           isi_user
     where lower(isi_term_res.ip_adresse) = lower(in_name)
       and isi_term_res.ls_login_id is not NULL
       and isi_term_res.ls_login_id = isi_user.login_id(+);

  CURSOR c_res is
    select res.res_id, res.res_name
      from isi_resource res
     where res.res_ext_name = in_name;

  CURSOR c_scanner is
    select *
      from isi_scanner_cfg s
     where s.scanner_name = in_scanner_name;
begin

  OPEN c_scanner;
  FETCH c_scanner into v_scanner;
  CLOSE c_scanner;

  if v_scanner.scanner_typ = 'BDE_FEST'
  or v_scanner.scanner_typ = 'SICK_RET'
  then
    out_msg := NULL;
    Result := true;                                      -- alles OK
    return(Result);

  end if;

  v_res_name := NULL;
  if in_aufgabe = 'A' then
    OPEN c_term_res;
    FETCH c_term_res into v_nname, v_vname, v_ls_login_id, v_login_name; -- Daten lesen
    v_found := c_term_res%FOUND and v_ls_login_id is not NULL;           -- Keine Daten für dieses Terminal vorhanden
    CLOSE c_term_res;

    if not v_found
    then
      OPEN c_name;
      FETCH c_name into v_nname, v_vname, v_ls_login_id, v_login_name; -- Daten lesen
      v_found := c_name%FOUND and v_ls_login_id is not NULL;           -- Keine Daten für dieses Terminal vorhanden
      CLOSE c_name;
    end if;

    if not v_found then
       v_err_nr := 10;
       v_err_text := 'Keine Daten für Terminal ' || in_name || ' vorhanden';
       raise v_error;
    end if;

    if v_ls_login_id is NULL then
       v_err_nr := 20;
       v_err_text := 'Keine Scannerzuweisung am Terminal ' || in_name;
       raise v_error;
    end if;

    update isi_scanner_cfg sc
      set sc.ls_login_id = v_ls_login_id,
          sc.res_id = NULL,
          sc.akt_aufgabe = NULL
    where sc.scanner_name = in_scanner_name;
    if v_ls_login_id != 0 then
      if v_nname is NULL then
        v_msg := v_login_name;                  -- Wenn kein Name dann Loginname
      else
        v_msg := v_nname || ', ' || v_vname;    -- Nane aus PZM
      end if;

    else
      v_msg := 'Superuser :-)';                 -- Superuser ist angemeldet
    end if;
    v_msg := NULL;

  elsif in_aufgabe = 'E' then
    update isi_scanner_cfg sc
      set sc.ls_login_id = NULL,
          sc.res_id = NULL,
          sc.akt_aufgabe = NULL,
          sc.scanner_daten = NULL
    where sc.scanner_name = in_scanner_name;
    v_msg := NULL;

  elsif in_aufgabe = 'TP' then
    v_aufgabe := 'TRANSPORT';
    update isi_scanner_cfg sc
      set sc.akt_aufgabe = v_aufgabe,
          sc.scanner_daten = NULL
    where sc.scanner_name = in_scanner_name;
    v_msg := v_aufgabe;

  elsif in_aufgabe = 'LHMS' then
    v_aufgabe := 'LHM Sperren';
    update isi_scanner_cfg sc
      set sc.akt_aufgabe = v_aufgabe,
          sc.scanner_daten = NULL
    where sc.scanner_name = in_scanner_name;
    v_msg := v_aufgabe;

  else
    if in_aufgabe = 'P'
    or in_aufgabe = 'LK' then
       v_aufgabe := 'PRODUKTION';
    elsif in_aufgabe = 'PR' then
       v_aufgabe := 'PROD.R.MG.';
    elsif in_aufgabe = 'PA' then
       v_aufgabe := 'PROD+FA';
    elsif in_aufgabe = 'PAR' then
       v_aufgabe := 'P+F.R.MG.';
    else
       v_aufgabe := 'BESCHICKEN';
    end if;

    OPEN c_res;
    FETCH c_res into v_res_id, v_res_name;
    v_found := c_res%FOUND;                              -- Maschine mit diesen Namen gefunden
    CLOSE c_res;

    if not v_found then
       v_err_nr := 30;
       v_err_text := 'Maschine ' || in_name || ' nicht vorhanden';
       raise v_error;
    end if;

    update isi_scanner_cfg sc
      set sc.res_id = v_res_id,
          sc.akt_aufgabe = v_aufgabe,
          sc.scanner_daten = NULL
    where sc.scanner_name = in_scanner_name;
    v_msg := in_name || ', ' || v_aufgabe;
  end if;

  commit;

  out_name := v_res_name;
  out_msg := v_msg;
  Result := true;                                      -- alles OK
  return(Result);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_scanner_status_name;

function bde_c_scanner_buch(in_scanner_name in varchar2,
                            in_barcode      in varchar2,
                            out_msg         out varchar2
                            ) return number is
begin
  return(bde_c_scanner_buch_spez(in_scanner_name,
                                 in_barcode,
                                 NULL,
                                 out_msg));

end;

function bde_c_scanner_buch_spez(in_scanner_name    in varchar2,
                                  in_barcode        in varchar2,
                                  in_barcode_brutto in varchar2,  -- Incl Menge
                                  out_msg          out varchar2
                                  ) return number is
begin
  return(bde_scanner_buch_spez(in_scanner_name,
                               in_barcode,
                               in_barcode_brutto,
                               out_msg));

end;

function bde_scanner_buch_spez(in_scanner_name    in varchar2,
                               in_barcode        in varchar2,
                               in_barcode_brutto in varchar2,  -- Incl Menge
                               out_msg          out varchar2
                               ) return number is
  -------------------------------------------------------------------------------------------------------
  -- Funktion Bucht den Barcode fuer einen Scanner
  -------------------------------------------------------------------------------------------------------

  v_menge       lvs_lam.menge%type;              -- Menge aus Funktion (Menge der für Barcode)

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Variablen
  -------------------------------------------------------------------------------------------------------

  v_res         isi_resource%rowtype;
  v_res_akt     isi_resource_zust_akt%rowtype;
  v_firma       isi_firma%rowtype;
  v_firma_cfg   isi_firma_cfg%rowtype;

  v_scanner     isi_scanner_cfg%rowtype;
  v_lte         lvs_lte%rowtype;
  -- -AG- Zus. Felder fuer das Umbuchgen auf den rohplatz der Maschine und fuer das
  -- Schreiben in die tabelle ISI_SCAN_LOG
  v_lhm         lvs_lhm%rowtype;
  v_artikel     isi_artikel%rowtype;
  v_fa_auftrag  bde_fa_auftrag%rowtype;
  v_charge      lvs_charge%rowtype;
  v_lam         lvs_lam%rowtype;

  v_ean         isi_artikel.ean%type;
  v_lfd_nr_str                  varchar2(20);
  v_linie_str                   varchar2(20);

  v_leitzahl    bde_fa_auftrag.leitzahl%type;
  v_fa_ag       bde_fa_auftrag.fa_ag%type;
  v_fa_upos     bde_fa_auftrag.fa_upos%type;
  v_vorgang_id  number;
  v_spez_bc     varchar2(100);
  v_barcode     varchar2(200);
  v_barcode_ref varchar2(20);

  v_charge_bez  lvs_charge.charge_bez%type;
  v_lte_name    lvs_lte.lte_name%type;
  v_prod_datum                  date;
  v_prod_datum_struktur         varchar2(30);

  v_lgr_ort     lvs_lgr_ort%rowtype;
  v_lgr         lvs_lgr%rowtype;
  v_lgr_roh     lvs_lgr%rowtype;
  v_anz         number;

  v_found       boolean;
  v_msg         varchar2(80);
  v_lam_id      lvs_lam.lam_id%type;
  v_lhm_id      lvs_lhm.lhm_id%type;
  v_lte_id      lvs_lte.lte_id%type;

  v_lam_mengen  number;
  v_lam_anz     number;

  -------------------------------------------------------------------------------------------------------
  -- Cursor
  -------------------------------------------------------------------------------------------------------

  CURSOR c_lte is
    select *
      from lvs_lte t
     where t.lte_id = v_barcode;

  CURSOR c_scanner is
    select *
      from isi_scanner_cfg sc
     where sc.scanner_name = in_scanner_name;

  CURSOR c_res is
    select *
      from isi_resource
     where isi_resource.res_id = v_scanner.res_id;

  CURSOR c_res_akt is
    select *
      from isi_resource_zust_akt t
     where t.res_id = v_res.res_id;

  CURSOR c_firma is
    select *
      from isi_firma f
     where f.sid = v_scanner.sid
       and f.firma_nr = v_scanner.firma_nr;

  CURSOR c_firma_cfg is
    select *
      from isi_firma_cfg f
     where f.sid = v_scanner.sid
       and f.firma_nr = v_scanner.firma_nr
       and f.kategorie = 'CFG'
       and f.parameter_name = v_spez_bc;

  CURSOR c_fa_auftrag is
    select t.*
      from bde_fa_auftrag t
     where t.leitzahl = v_res_akt.leitzahl
       and t.fa_ag = v_res_akt.fa_ag
       and t.fa_upos = v_res_akt.fa_upos;

  CURSOR c_charge_bez is
    select t.*
      from lvs_charge t
     where t.charge_bez = v_charge_bez
       and t.artikel_id = v_artikel.artikel_id;

  CURSOR c_charge_id is
    select t.*
      from lvs_charge t
     where t.charge_id = v_fa_auftrag.charge_id;

  CURSOR c_lam_mengen is
    select sum(nvl(l.menge, 0)), count(l.lam_id)
      from lvs_lam l
     where l.lte_id = v_barcode;

  CURSOR c_lams is
    select *
      from lvs_lam l
     where l.lte_id = v_barcode
     order by l.lhm_id desc;

begin
  v_menge := NULL;
  v_prod_lte_id := NULL;
  v_prod_lhm_id := NULL;

  -- Lesen der Scannerdaten
  OPEN c_scanner;
  FETCH c_scanner into v_scanner; -- Scannerdaten holen
  v_found := c_scanner%FOUND;                              -- Daten gefunden
  CLOSE c_scanner;
  -- Scannerdaten nicht vorhanden !!!
  if not v_found then
     v_err_nr := 10;
     v_err_text := 'Scanner ' || in_scanner_name || ' fehlt in der Konfiguration';
     raise v_error;
  end if;

  if  v_scanner.ls_login_id is null
  and v_scanner.scanner_typ != 'BDE_FEST'
  and v_scanner.scanner_typ != 'SICK_RET'
  and v_scanner.scanner_typ != 'BDE_HAND' then
     v_err_nr := 20;
     v_err_text := 'Scanner ist keiner Person zugewiesen';
     raise v_error;
  end if;

  if v_scanner.akt_aufgabe = 'PRODUKTION'
  or v_scanner.akt_aufgabe = 'LK'
  or v_scanner.akt_aufgabe = 'BESCHICKEN'
  or v_scanner.akt_aufgabe = 'SPEZ_WE_PRODUKTION'
  then
    if v_scanner.res_id is null then
       v_err_nr := 30;
       v_err_text := 'Scanner ist mit keiner Maschine verbunden';
       raise v_error;
    end if;

    -- Lesen der Maschinenstammdaten
    OPEN c_res;
    FETCH c_res into v_res;                  -- Maschiendaten holen
    v_found := c_res%FOUND;                  -- Daten gefunden
    CLOSE c_res;

    if not v_found then
       v_err_nr := 40;
       v_err_text := 'Maschinendaten für res_id ' || v_scanner.res_id || ' fehlen !!!';
       raise v_error;
    end if;

    OPEN c_firma;
    FETCH c_firma into v_firma;
    CLOSE c_firma;

    if nvl(v_scanner.barcode_typ, 'ID') = 'ID'
    then
      v_spez_bc := 'SPEZ_BARCODE_' || v_scanner.akt_aufgabe;
    else
      v_spez_bc := upper(v_scanner.barcode_typ) || '_' || upper(v_scanner.barcode_bez);
    end if;

    v_firma_cfg := NULL;
    OPEN c_firma_cfg;
    FETCH c_firma_cfg into v_firma_cfg;
    CLOSE c_firma_cfg;

    v_barcode := in_barcode;
    -- Es gibt Barcodes mit Endekenneung und ohne Endekenneung
    -- Hierdurch kann eine Differenz von einem Zeichen im Barcode sein
    if length(v_barcode) = length(v_firma_cfg.parameter_wert) -1
    and substr(v_firma_cfg.parameter_wert, length(v_firma_cfg.parameter_wert), 1) = 'E'
    then
      v_barcode := v_barcode || '0';
    end if;

    if length(v_barcode) != length(v_firma_cfg.parameter_wert)
    then
      v_spez_bc := 'SPEZ_BARCODE_' || to_char(length(v_barcode));

      v_firma_cfg := NULL;
      OPEN c_firma_cfg;
      FETCH c_firma_cfg into v_firma_cfg;
      CLOSE c_firma_cfg;
    end if;

    if nvl(v_firma_cfg.parameter_wert, 'keiner') != 'keiner'
    and (length(v_barcode) = length(v_firma_cfg.parameter_wert)
      or v_spez_bc like 'SPEZ_ID_%')
    then
      v_barcode_ref := lvs_p_lte_lhm.lvs_lte_lhm_ref(v_scanner.sid,                                     -- in_sid             in isi_sid.sid%type,
                                                     v_scanner.firma_nr,                                -- in_firma_nr        in isi_firma.firma_nr%type,
                                                     v_barcode);                                        -- in_barcode         in lvs_lam.lhm_id%type,
      if v_scanner.akt_aufgabe = 'BESCHICKEN'
      and v_barcode_ref != c.BASIS_LHM
      -- -AG- BugFix LTE Erstellen nur möglich wenn der barcode keinen Referenz zu einem karton hat
      then
        if v_spez_bc like 'SPEZ_BARCODE_%'
        then
          v_menge := NULL;

          v_barcode := lvs_p_lte_lhm.insert_lhm_aus_barcode(v_scanner.sid,                                     -- in_sid             in isi_sid.sid%type,
                                                            v_scanner.firma_nr,                                -- in_firma_nr        in isi_firma.firma_nr%type,
                                                            v_barcode,                                 -- in_barcode         in lvs_lam.lhm_id%type,
                                                            v_firma_cfg.parameter_wert,                -- in_parameter_wert  in isi_firma_cfg.parameter_wert%type,
                                                            v_scanner.ls_login_id,                            -- in_login_id        in isi_user.login_id%type)
                                                            v_menge,
                                                            in_barcode);
          -- -AG- 25.06.2009 in dieser Variante muss hier der Lagerplatz eingetragen werden, damit dem Host
          -- dieser übermittelt werden kann (Keine Buchung)
          -- Der lagerplatz der Resource wird in der Lam eintragen, da dieser für die
          -- Verbuchung in der Schnittstelle für die Angabes der Host-Lagerorts benötigt
          -- wird.
          update lvs_lam t
             set t.lgr_platz = v_res.lager_roh
           where t.lhm_id = v_barcode;
          v_lhm_id := v_barcode;
          commit;
        elsif v_scanner.barcode_typ = 'SPEZ_ID'
        then
          -- -AG- Beim BESCHICKEN soll auch nur gebucht werden, was gescannt ist
          -- wenn diese Bedingungen erfüllt sind
          -- !!!!Achtung: Hier werden die daten einfach gelöscht, damit keine Buchungen erfolgen
          -- Falls die Menge korrigiert wird, ändern sich auch die Produktionsdaten, was hier auch
          -- nicht gewünscht ist (Anpassung für Umsetzung SASOL)
          if isi_allg.get_firma_cfg_param(v_res.sid,
                                          v_res.firma_nr,
                                          'SCANN',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                          NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                          'LTE_BARCODE_MG_BUCH',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                          'SCEngine',               -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                          'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                          'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                          'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
          and lvs_p_base.get_lte(in_barcode, v_lte)
          and v_spez_bc like 'SPEZ_ID_%'  -- Nur wenn der barcode vom Typ Spez_ID
          and in_barcode_brutto is not NULL -- Und der Bruttobarcode gefüllt ist
          then
            -- Mengen Lesen
            OPEN c_lam_mengen;
            FETCH c_lam_mengen into v_lam_mengen, v_lam_anz;
            CLOSE c_lam_mengen;

            -- Barcode auswerten
            lvs_p_lte_lhm.spez_barcode_result(v_firma_cfg.sid,             -- in in_sid
                                              v_firma_cfg.firma_nr,        -- in in_firma_nr
                                              in_barcode_brutto,           -- in  lvs_lam.lhm_id%type,
                                              v_firma_cfg.parameter_wert,  -- in  isi_firma_cfg.parameter_wert%type,
                                              v_artikel,                   -- out_artikel
                                              v_charge_bez,                -- out varchar2,
                                              v_prod_datum,                -- out date,
                                              v_menge,                     -- out number,
                                              v_ean,                   -- out varchar2
                                              v_lfd_nr_str,            -- out varchar2
                                              v_linie_str);            -- out varchar2

            -- Menge stimmt nicht
            if v_lam_mengen != v_menge
            then
              delete lvs_lhm t
               where t.lte_id = in_barcode;
              delete lvs_lam t
               where t.lte_id = in_barcode;
              delete lvs_lte t
               where t.lte_id = in_barcode;
            end if;
          end if;
          if not lvs_p_base.get_lte(in_barcode, v_lte)
          then
            if in_barcode_brutto is not NULL
            then
              v_barcode := lvs_p_lte_lhm.insert_lhm_aus_barcode(v_scanner.sid,                                     -- in_sid             in isi_sid.sid%type,
                                                                v_scanner.firma_nr,                                -- in_firma_nr        in isi_firma.firma_nr%type,
                                                                in_barcode_brutto,                                 -- in_barcode         in lvs_lam.lhm_id%type,
                                                                v_firma_cfg.parameter_wert,                        -- in_parameter_wert  in isi_firma_cfg.parameter_wert%type,
                                                                v_scanner.ls_login_id,                             -- in_login_id        in isi_user.login_id%type)
                                                                v_menge,
                                                                in_barcode);
              -- Der lagerplatz der Resource wird in der Lam eintragen, da dieser für die
              -- Verbuchung in der Schnittstelle für die Angabes der Host-Lagerorts benötigt
              -- wird.
              update lvs_lam t
                 set t.lgr_platz = v_res.lager_roh
               where t.lhm_id = v_barcode;
              v_lhm_id := v_barcode;
              commit;
            end if;
          end if;
        end if;
        if lvs_p_base.get_lte(in_barcode, v_lte)
        then
          if v_lte.lgr_platz != v_res.lager_roh
          then
            if  lvs_p_base.get_lgr_platz(v_res.lager_roh, v_lgr_roh)
            then
              if  lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr)
              then
                if v_lgr.lgr_ort != v_lgr_roh.lgr_ort
                or v_lgr.lgr_verwendung != c.WA
                then
                  lvs_transport.lvs_lte_transport(v_lte.lte_id, v_lte.lgr_platz, v_res.lager_roh, v_scanner.ls_login_id);
                end if;
              end if;
            end if;
          end if;
        end if;
      -- -AG- Umbuchen wenn auf falschem Platz
      elsif v_scanner.akt_aufgabe = 'BESCHICKEN'
      and v_barcode_ref = c.BASIS_LHM
      then
        if lvs_p_base.get_lhm(in_barcode, v_lhm)
        then
          if lvs_p_base.get_lte(v_lhm.lte_id, v_lte)
          then
            if v_lte.lgr_platz != v_res.lager_roh
            then
              if  lvs_p_base.get_lgr_platz(v_res.lager_roh, v_lgr_roh)
              then
                if  lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr)
                then
                  if v_lgr.lgr_ort != v_lgr_roh.lgr_ort
                  or v_lgr.lgr_verwendung != c.WA
                  then
                    lvs_transport.lvs_lte_transport(v_lte.lte_id, v_lte.lgr_platz, v_res.lager_roh, v_scanner.ls_login_id);
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      elsif (v_scanner.akt_aufgabe = 'PRODUKTION'
          or v_scanner.akt_aufgabe = 'LK'
          or v_scanner.akt_aufgabe = 'SPEZ_WE_PRODUKTION')
      then
        OPEN c_lte;
        FETCH c_lte into v_lte;
        v_found := c_lte%FOUND;
        CLOSE c_lte;

        if v_found
        then
          if v_lte.lgr_platz is NULL
          then
            -- Der Scanner bringt mit dem Barcode die Menge und
            -- diese soll dann in den Buchungen geaendert werden
            if isi_allg.get_firma_cfg_param(v_res.sid,
                                            v_res.firma_nr,
                                            'SCANN',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                            NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                            'LTE_BARCODE_MG_BUCH',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                            'SCEngine',               -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                            'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                            'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                            'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
            and v_spez_bc like 'SPEZ_ID_%'  -- Nur wenn der barcode vom Typ Spez_ID
            and in_barcode_brutto is not NULL -- Und der Bruttobarcode gefüllt ist
            then
              -- Mengen Lesen
              OPEN c_lam_mengen;
              FETCH c_lam_mengen into v_lam_mengen, v_lam_anz;
              CLOSE c_lam_mengen;

              -- Barcode auswerten
              lvs_p_lte_lhm.spez_barcode_result(v_firma_cfg.sid,             -- in in_sid
                                                v_firma_cfg.firma_nr,        -- in in_firma_nr
                                                in_barcode_brutto,           -- in  lvs_lam.lhm_id%type,
                                                v_firma_cfg.parameter_wert,  -- in  isi_firma_cfg.parameter_wert%type,
                                                v_artikel,                   -- out_artikel
                                                v_charge_bez,                -- out varchar2,
                                                v_prod_datum,                -- out date,
                                                v_menge,                     -- out number,
                                                v_ean,                   -- out varchar2
                                                v_lfd_nr_str,            -- out varchar2
                                                v_linie_str);            -- out varchar2
              -- Menge stimmt nicht
              if v_lam_mengen != v_menge
              then
                -- Dann entsprechend LAMs lesen und korrigieren
                OPEN c_lams;
                FETCH c_lams into v_lam;

                LOOP
                  EXIT when v_lam_mengen - v_menge = 0
                         or c_lams%NOTFOUND;

                  if v_lam.menge < v_lam_mengen - v_menge
                  and v_lam_mengen > v_menge
                  then
                    update lvs_lam_bh bh
                       set bh.menge = 0
                     where bh.lam_id = v_lam.lam_id
                       and bh.bus = c.LAM_BH_BUS_ZUG;
                    v_lam_mengen := v_lam_mengen - v_lam.menge;
                  else
                    update lvs_lam_bh bh
                       set bh.menge = bh.menge - (v_lam_mengen - v_menge)
                     where bh.lam_id = v_lam.lam_id
                       and bh.bus = c.LAM_BH_BUS_ZUG;
                    v_lam_mengen := v_menge;

                  end if;
                  FETCH c_lams into v_lam;
                end LOOP;
                CLOSE c_lams;
              end if;
            end if;

            lvs_p_lte.lvs_korr_te_einbuchen(v_scanner.sid,                                     -- in_sid             in isi_sid.sid%type,
                                            v_scanner.firma_nr,                                -- in_firma_nr        in isi_firma.firma_nr%type,
                                            v_barcode,                                 -- in_barcode         in lvs_lam.lhm_id%type,
                                            v_lte.lte_status,
                                            v_res.sid,
                                            v_res.firma_nr,
                                            NULL,
                                            v_res.lager_fertig,
                                            v_scanner.ls_login_id,
                                            true);
            v_msg := 'Platz <' || v_res.lager_fertig || '> gebucht';
            out_msg := v_msg;
            bde_isi_scan_log_id(v_scanner.scanner_name,
                                nvl(in_barcode_brutto, in_barcode),
                                v_lte.lte_id,
                                NULL,
                                v_scanner.akt_aufgabe,
                                NULL,
                                c.C_TRUE);
            commit;
            return(0);
          else
            v_msg := 'Palette bereits gebucht';
            out_msg := v_msg;
            rollback;
            bde_isi_scan_log_id(v_scanner.scanner_name,
                                nvl(in_barcode_brutto, in_barcode),
                                v_lte.lte_id,
                                NULL,
                                v_scanner.akt_aufgabe,
                                v_msg,
                                c.C_FALSE);
            commit;
            return(-1);
          end if;
        else
          if v_spez_bc like 'SPEZ_ID_%'
          then
            -- Auftrag lesen
            OPEN c_res_akt;
            FETCH c_res_akt into v_res_akt;
            v_found := c_res_akt%found;
            CLOSE c_res_akt;

            if not v_found
            then
              v_err_nr := 41;
              v_err_text := 'Fehler: Maschine aktuelle zustand ' || v_res.res_ext_name || ' fehlt';
              raise v_error;
            end if;
            -- Infos aus dem Barcode holen

            if in_barcode_brutto is not NULL
            then
              begin
                if v_spez_bc like 'SPEZ_ID_ORGANIK'
                then
                  v_err_nr := 42;
                  v_err_text := 'Fehler: Organik ';
                  raise v_error;
                end if;
                lvs_p_lte_lhm.spez_barcode_result(v_firma_cfg.sid,             -- in in_sid
                                                  v_firma_cfg.firma_nr,        -- in in_firma_nr
                                                  in_barcode_brutto,           -- in  lvs_lam.lhm_id%type,
                                                  v_firma_cfg.parameter_wert,  -- in  isi_firma_cfg.parameter_wert%type,
                                                  v_artikel,                   -- out_artikel
                                                  v_charge_bez,                -- out varchar2,
                                                  v_prod_datum,                -- out date,
                                                  v_menge,                     -- out number,
                                                  v_ean,                   -- out varchar2
                                                  v_lfd_nr_str,            -- out varchar2
                                                  v_linie_str);            -- out varchar2
              exception
                when others
                then
                  if  lvs_p_base.get_lgr_platz(v_res.lager_fertig,
                                              v_lgr)
                  and lvs_p_base.get_lgr_ort(v_scanner.sid,
                                             v_scanner.firma_nr,
                                             v_lgr.lgr_ort,
                                             v_lgr_ort)
                  and v_scanner.akt_aufgabe = 'SPEZ_WE_PRODUKTION'
                  and v_spez_bc like 'SPEZ_ID_ORGANIK'
                  then
                    select count(*) into v_anz
                      from s_send_bew t
                     where t.lte_nr = in_barcode_brutto;
                    if v_anz > 0
                    then
                      v_err_nr := 42;
                      v_err_text := 'Fehler: Barcode ' || in_barcode || ' bereits gebucht.';
                      raise v_error;
                    end if;

                    lvs_p_lte_lhm.split_spez_barcode(in_barcode_brutto,           -- in  lvs_lam.lhm_id%type,
                                                     v_firma_cfg.parameter_wert,  -- in  isi_firma_cfg.parameter_wert%type,
                                                     v_artikel.artikel,           -- out_artikel
                                                     v_charge_bez,                -- out varchar2,
                                                     v_prod_datum,                -- out date,
                                                     v_prod_datum_struktur,       -- out_prod_datum_struktur out varchar2,
                                                     v_menge,                     -- out number,
                                                     v_ean,                       -- out varchar2
                                                     v_lfd_nr_str,            -- out varchar2
                                                     v_linie_str);            -- out varchar2
                    -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
                    insert into s_send_bew send
                       values (
                          NULL,                       -- BEW_ID          NUMBER,
                          v_scanner.firma_nr,         -- FIRMA_NR        NUMBER(3),
                          'ISI',                      -- HERKUNFT        VARCHAR2(3),
                          NULL,                       -- TABELLE         VARCHAR2(5),
                          NULL,                       -- AUF_ID          NUMBER,
                          'UE',                       -- STATUS          VARCHAR2(3),
                          'WEI',                      -- AKTION          VARCHAR2(3),
                          NULL,                       -- MA_STATUS       VARCHAR2(1),
                          NULL,                       -- MA_S_GRUND      NUMBER(3),
                          NULL,                       -- MA_ID           VARCHAR2(10),
                          in_barcode_brutto,          -- LTE_NR          VARCHAR2(20),
                          NULL,                       -- LHM_NR          VARCHAR2(20),
                          v_lgr_ort.host_lgr_ort,     -- LAGERORT        VARCHAR2(10),
                          NULL,                       -- ZLAGERORT       VARCHAR2(10),
                          1,                          -- MENGE           NUMBER(12,3),
                          NULL,                       -- MENGE_B         NUMBER(12,3),
                          NULL,                       -- SCHROTT         NUMBER(12,3),
                          NULL,                       -- R_MENGE         NUMBER(12,3),
                          NULL,                       -- R_MENGE_B       NUMBER(12,3),
                          NULL,                       -- R_SCHROTT       NUMBER(12,3),
                          NULL,                       -- STOERZEIT_IST   NUMBER,
                          NULL,                       -- RUESTZEIT_IST   NUMBER,
                          NULL,                       -- PRODZEIT_IST    NUMBER,
                          NULL,                       -- EXT_LIEF_NR     VARCHAR2(15),
                          NULL,                       -- EXT_LIEF_POS    VARCHAR2(5),
                          v_charge_bez,               -- CHARGE          VARCHAR2(20),
                          NULL,                       -- SERIE           VARCHAR2(20),
                          NULL,                       -- ARBEITSPLATZ_ID VARCHAR2(20),
                          NULL,                       -- IST_BESTAND     NUMBER,
                          v_artikel.artikel,          -- ARTIKEL         VARCHAR2(20),
                          sysdate,                    -- B_DATUM         DATE,
                          NULL,                       -- LAM_ID          NUMBER,
                          NULL,                       -- LAM_BH_ID       NUMBER,
                          c.LAM_BH_ZUGAGNG,           -- LAM_BH_TYP      VARCHAR2(2)
                          NULL,                       -- LEITZAHL        NUMBER,
                          NULL,                       -- FA_AG           NUMBER,
                          NULL,                       -- FA_UPOS         NUMBER
                          NULL,                       -- LAM_AG          NUMBER
                          NULL,                       -- BRUTTO_KG
                          NULL,                       -- TEXT            VARCHAR2(40),
                          NULL,                       -- ERR_NR          NUMBER
                          NULL,                       -- USER_NAME       VARCHAR2(100)
                          v_res_akt.res_id,           -- RES_ID          NUMBER
                          NULL,                       -- SEND_ID         NUMBER
                          NULL,                       -- MA_LAST_S_GRUND NUMBER
                          NULL,                       -- PERS_NR          NUMBER
                          NULL,                      -- SPER_GRUND      VARCHAR2(30)
                          v_lgr.lgr_platz,           -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
                          NULL,                      -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
                          NULL,                      -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
                          NULL,                      -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                      -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                      -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                      -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                      -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                      -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                      -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                      -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                      -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                     -- LAM_SEL10  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                          NULL,                     -- LTE_NAME N VARCHAR2(15)  Y     Art, Name der Transporteinheit
                          NULL,                     -- ORDER_POS_AUF_ID N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                          NULL,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                          NULL);                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden

                    out_msg := 'Z_P_WE -> HOST OK';
                    bde_isi_scan_log_id(v_scanner.scanner_name,
                                        in_barcode_brutto,
                                        in_barcode_brutto,
                                        NULL,
                                        v_scanner.akt_aufgabe,
                                        NULL,
                                        c.C_TRUE);

                    commit;
                    return (1);
                  else
                    raise;
                  end if;

              end;
            else
              lvs_p_lte_lhm.spez_barcode_result(v_firma_cfg.sid,             -- in in_sid
                                                v_firma_cfg.firma_nr,        -- in in_firma_nr
                                                in_barcode,                  -- in  lvs_lam.lhm_id%type,
                                                v_firma_cfg.parameter_wert,  -- in  isi_firma_cfg.parameter_wert%type,
                                                v_artikel,                   -- out_artikel
                                                v_charge_bez,                -- out varchar2,
                                                v_prod_datum,                -- out date,
                                                v_menge,                     -- out number,
                                                v_ean,                   -- out varchar2
                                                v_lfd_nr_str,            -- out varchar2
                                                v_linie_str);            -- out varchar2
            end if;
            OPEN c_fa_auftrag;
            FETCH c_fa_auftrag into v_fa_auftrag;
            v_found := c_fa_auftrag%FOUND;
            CLOSE c_fa_auftrag;

            -- Wenn die Cahrge nicht da ist, dann ist sie immer !=
            -- Dann stimmt der FA auch nicht (FA legt die Charge immer an)
            if not lvs_p_base.get_charge_bez(v_scanner.sid, v_charge_bez, v_artikel.artikel_id, v_charge)
            then
              v_found := FALSE;
            end if;

            if not v_found
            or v_fa_auftrag.ag_artikel_id != v_artikel.artikel_id
            or v_fa_auftrag.charge_id != v_charge.charge_id
            then
              if  v_scanner.akt_aufgabe = 'SPEZ_WE_PRODUKTION'
              and v_spez_bc like 'SPEZ_ID_%'
              then
                bde_sc_pd_spez_prod(v_scanner.sid,                   -- in_sid         in isi_sid.sid%type,
                                    'PP',                                -- in_vorg_typ    in bde_pd_prod.vorg_typ%type,
                                     v_scanner.firma_nr,                 -- in_firma_nr    in isi_firma.firma_nr%type,
                                     v_barcode,                          -- in_barcode     in lvs_lhm.lhm_id%type,
                                     v_artikel.artikel_id,               -- in_artikel_ia  in isi_artikel.artikel_id%type,
                                     v_scanner.res_id,                   -- in_res_id      in isi_resource.res_id%type,
                                     v_res_akt.pers_nr,                  -- in_pers_nr     in isi_user.pers_nr%type,
                                     nvl(v_menge,
                                         v_artikel.lhm_menge),           -- in_menge_a     in bde_pd_prod.menge_a%type,
                                     v_charge_bez,                       -- in_charge      in lvs_charge.charge_bez%type,
                                     v_scanner.ls_login_id,              -- in_ls_login_id in isi_user.login_id%type) is
                                     substr(in_barcode_brutto, 1, 20),   -- in_fae_id
                                     v_lhm_id);                          -- in_out_lhm_id
                v_msg := 'Z_P_WE ' || to_char(v_menge) || ' OK';
                out_msg := v_msg;
                bde_isi_scan_log_id(v_scanner.scanner_name,
                                    nvl(in_barcode_brutto, in_barcode),
                                    v_barcode,
                                    nvl(v_prod_lhm_id, v_lhm_id),
                                    v_scanner.akt_aufgabe,
                                    NULL,
                                    c.C_TRUE);
                commit;
                return(nvl(v_menge, v_artikel.lhm_menge));
              else
                v_err_nr := 42;
                v_err_text := 'Fehler: FA-Auftrag ' || to_char(v_leitzahl) || ' fehlt in Maschine ' || v_res.res_ext_name;
                raise v_error;
              end if;
            end if;


            -- In jedem Fall eine neue Palette anlegen

            v_lte_name := nvl(v_fa_auftrag.lte_name, v_artikel.lte_name);

            if v_lte_name is NULL
            then
              v_err_nr := 43;
              v_err_text := 'Fehler: FA-Auftrag ' || to_char(v_leitzahl) || ' für in Maschine ' || v_res.res_ext_name || ' hat keinen LTE_Type';
              raise v_error;
            end if;

            OPEN c_charge_bez;
            FETCH c_charge_bez into v_charge;
            v_found := c_charge_bez%FOUND;
            CLOSE c_charge_bez;

            if not v_found
            then
              v_charge.charge_id := get_charge_id(v_fa_auftrag.sid,     -- p_sid               in isi_sid.sid%type,
                                                  v_fa_auftrag.firma_nr,
                                                  NULL,                 -- p_lieferanten_id    in number,
                                                  v_charge_bez,         -- p_charge            in lvs_charge.charge_bez%type,
                                                  v_artikel.artikel_id);-- p_artikel_id        in isi_artikel.artikel_id%type)
            end if;

            v_barcode := lvs_p_lte.lvs_lte_insert_v358 (v_res.sid,                -- SID der Maschine
                                                        v_res.firma_nr,           -- Firma der Maschine
                                                        v_lte_name,               -- Palettemtype Bsp. 'EURO'
                                                        v_barcode,                -- ID der Transporteinheit
                                                        v_scanner.ls_login_id,    -- Login ID aktuelle User
                                                        NULL,                     -- Kein Lager
                                                        v_res.lager_fertig,       -- Fertigwarenlager der Maschine
                                                        'BF',                     -- Status ist auf befüllen gesetzt
                                                        null,
                                                        null,
                                                        v_charge.charge_id,       -- Charge ID
                                                        v_charge_bez,         -- p_charge            in lvs_charge.charge_bez%type,
                                                        v_artikel.artikel_id, -- p_artikel_id        in isi_artikel.artikel_id%type)
                                                        nvl(v_fa_auftrag.packschema_kopf_id, v_artikel.packschema_kopf_id),
                                                        null,                    -- Auto Depal ist unbekannt
                                                        null,                    -- wickelprogramm ist unbekannt,
                                                        null);                   -- wickelprogramm_einl ist unbekannt

            update isi_resource_zust_akt
               set lte_id = v_barcode                   -- Ergebnis im aktuelle Maschienenzustan SPEICHERN
             where sid = v_res.sid and
                   res_id = v_res.res_id;

            if nvl(v_fa_auftrag.charge_id, -1) != v_charge.charge_id
            then
              v_fa_auftrag.charge_id := v_charge.charge_id;
              update bde_fa_auftrag t
                 set t.charge_id = v_fa_auftrag.charge_id
               where t.leitzahl = v_res_akt.leitzahl
                 and t.fa_ag = v_res_akt.fa_ag
                 and t.fa_upos = v_res_akt.fa_upos;
            end if;

            if isi_allg.get_firma_cfg_param(v_res.sid,
                                            v_res.firma_nr,
                                            'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                            NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                            'ET_LTE_ID_ON_ID_LHM',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                            'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                            'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                            'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                            'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
            then
              v_barcode := NULL;
            else
              v_barcode := in_barcode;
            end if;

            v_barcode := bde_c_barcode_buch(v_res.sid,                -- SID der Maschine
                                            v_res.firma_nr,           -- Firma der Maschine
                                            v_barcode,                -- in_barcode => :barcode,
                                            v_res.res_id,             -- in_res_id => :res_id,
                                            v_scanner.ls_login_id,    -- in_ls_login_id => :login_id,
                                            v_menge,                  -- in_menge_a => :menge_a,
                                            NULL,                     -- in_menge_b => :menge_b,
                                            NULL,                     -- in_schrott => :schrott,
                                            'ZUGANG',                 -- in_aufgabe => 'ZUGANG',
                                            in_barcode_brutto,        -- in_fa_id
                                            NULL,                     -- in_fa_id_position
                                            v_leitzahl,               -- out_leitzahl => :leitzahl,
                                            v_fa_ag,                  -- out_fa_ag => :fa_ag,
                                            v_fa_upos);               -- out_fa_upos => :fa_upos);
            if v_prod_datum is not NULL
            then
              update lvs_lam l
                 set l.prod_datum = v_prod_datum
               where l.lhm_id = v_barcode;
            end if;
            if v_scanner.akt_aufgabe = 'PRODUKTION'
            or v_scanner.akt_aufgabe = 'LK'
            then
              v_msg := 'PROD ' || to_char(v_menge) || ' OK';
            else
              v_msg := 'Z_P_WE ' || to_char(v_menge) || ' OK';
            end if;
            out_msg := v_msg;
            bde_isi_scan_log_id(v_scanner.scanner_name,
                                nvl(in_barcode_brutto, in_barcode),
                                v_prod_lte_id,
                                v_prod_lhm_id,
                                v_scanner.akt_aufgabe,
                                NULL,
                                c.C_TRUE);
            commit;
            return(v_menge);
          end if;
        end if;

      end if;
    else
      v_barcode := in_barcode;
    end if;
    if  length(v_barcode) != nvl(v_firma.lhm_barcode_laenge, length(v_barcode))
    and length(v_barcode) != nvl(v_firma.lte_barcode_laenge, length(v_barcode))
    then
       v_err_nr := 45;
       v_err_text := 'Barcodelänge falsch! Gelesene Länge:' || to_char(length(v_barcode)) || ' Soll: ' ||
       to_char(nvl(v_firma.lhm_barcode_laenge, length(v_barcode))) || ' oder ' ||
       to_char(nvl(v_firma.lte_barcode_laenge, length(v_barcode)));
       raise v_error;
    end if;


    OPEN c_res_akt;
    FETCH c_res_akt into v_res_akt;
    v_found := c_res_akt%found;
    CLOSE c_res_akt;

    if v_scanner.akt_aufgabe = 'BESCHICKEN' -- Beschicken und der Lagerplatz stimmt nicht
    then
      v_barcode_ref := lvs_p_lte_lhm.lvs_lte_lhm_ref(v_scanner.sid,                                     -- in_sid             in isi_sid.sid%type,
                                                     v_scanner.firma_nr,                                -- in_firma_nr        in isi_firma.firma_nr%type,
                                                     v_barcode);                                        -- in_barcode         in lvs_lam.lhm_id%type,
      if v_barcode_ref = c.BASIS_LHM
      then
        if lvs_p_base.get_lhm(in_barcode, v_lhm)
        then
          if lvs_p_base.get_lte(v_lhm.lte_id, v_lte)
          then
            if v_lte.lgr_platz != v_res.lager_roh
            then
              if  lvs_p_base.get_lgr_platz(v_res.lager_roh, v_lgr_roh)
              then
                if  lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr)
                then
                  if v_lgr.lgr_ort != v_lgr_roh.lgr_ort
                  then
                    lvs_transport.lvs_lte_transport(v_lte.lte_id, v_lte.lgr_platz, v_res.lager_roh, v_scanner.ls_login_id);
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
      if v_barcode_ref = c.BASIS_LTE
      then
        if lvs_p_base.get_lte(in_barcode, v_lte)
        then
          if v_lte.lgr_platz != v_res.lager_roh
          then
            if  lvs_p_base.get_lgr_platz(v_res.lager_roh, v_lgr_roh)
            then
              if  lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr)
              then
                if v_lgr.lgr_ort != v_lgr_roh.lgr_ort
                then
                  lvs_transport.lvs_lte_transport(v_lte.lte_id, v_lte.lgr_platz, v_res.lager_roh, v_scanner.ls_login_id);
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;

    if  v_spez_bc like 'SPEZ_ID_%'
    and v_res_akt.leitzahl is NULL
    and v_scanner.akt_aufgabe = 'BESCHICKEN'
    then
       v_barcode := in_barcode;
       v_lte_id :=  in_barcode;
       -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
       v_lam_id := lvs_ausl.lvs_lam_abgang (v_scanner.sid,                       -- in_sid         in isi_sid.sid%type,
                                            v_scanner.firma_nr,                  -- in_firma_nr    in isi_firma.firma_nr%type,
                                            v_artikel.artikel_id,                -- in_out_artikel_id  in out isi_artikel.artikel_id%type,
                                            v_barcode,                           -- in_lte_id      in lvs_lte.lte_id%type,
                                            NULL,                                -- in_lhm_id      in lvs_lhm.lhm_id%type,
                                            NULL,                                -- in_abnr        in bde_fa_auftrag.abnr%type,
                                            v_scanner.res_id,                    -- in_res_id      in isi_resource.res_id%type,
                                            sysdate,                             -- in_abg_datum   in date,
                                            v_scanner.ls_login_id,               -- in_ls_login_id in isi_user.login_id%type,
                                            null,                                -- in_vorgag_id   in lvs_lam_bh.vorg_id%type,
                                            null,                                -- in_bew_id      in s_send_bew.bew_id%type,
                                            null,                                -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                                            null,                                -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                                            null,                                -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                            null,                                -- in_abnr_extern in bde_fa_auftrag.abnr%type,
                                            c.LAM_BH_BUS_ABG,                    -- in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                            null,                                -- in_tour        in isi_order_pos.vorgang_id%type
                                            null,
                                            null);
      v_msg := v_scanner.akt_aufgabe || ' ' || to_char(v_menge) || ' OK';
    else
      v_menge := bde_c_barcode_buch (v_scanner.sid,
                                     v_scanner.firma_nr,
                                     v_barcode,
                                     v_scanner.res_id,
                                     v_scanner.ls_login_id,
                                     v_menge,
                                     NULL,
                                     NULL, v_scanner.akt_aufgabe,
                                     in_barcode_brutto,        -- in_fa_id
                                     NULL,                     -- in_fa_id_position
                                     v_leitzahl,
                                     v_fa_ag,
                                     v_fa_upos);
      v_msg := v_scanner.akt_aufgabe || ' ' || to_char(v_menge) || ' OK';
    end if;

  elsif v_scanner.akt_aufgabe = 'PROD+FA'
     or v_scanner.akt_aufgabe = 'PROD.R.MG.'
     or v_scanner.akt_aufgabe = 'P+F.R.MG.'
  then
    v_msg := '';
  elsif v_scanner.akt_aufgabe = 'TRANSPORT'
  then
    v_barcode := v_scanner.scanner_daten;
    if v_barcode is NULL
    then
      if lvs_p_lte_lhm.lvs_lte_lhm_ref(v_scanner.sid,
                                       v_scanner.firma_nr,
                                       in_barcode) = 'LTE'
      then
        update isi_scanner_cfg sc
           set sc.scanner_daten = in_barcode
         where sc.scanner_name = in_scanner_name;
      else
        v_err_nr := 50;
        v_err_text := 'Nur LTE''s können transportiert  werden.Bitte LTE scannen.';
        raise v_error;
      end if;
    else
      lvs_p_lte.LVS_LTE_TRANSPORT(v_barcode, NULL, in_barcode, v_scanner.ls_login_id);
      update isi_scanner_cfg sc
         set sc.scanner_daten = NULL
       where sc.scanner_name = in_scanner_name;
    end if;
    v_msg := v_scanner.akt_aufgabe || ' OK';

  elsif v_scanner.akt_aufgabe = 'LHM Sperren'
  then
    v_vorgang_id := NULL;
    if lvs_p_lte_lhm.lvs_lte_lhm_ref(v_scanner.sid,
                                     v_scanner.firma_nr,
                                     in_barcode) = 'LHM'
    then
      lvs_p_lte_lhm.lvs_c_lhm_sperre_abpack (v_scanner.sid,            -- in_sid                  in isi_sid.sid%type,
                                             v_scanner.firma_nr,       -- in_firma_nr             in isi_firma.firma_nr%type,
                                             in_barcode,       -- in_lhm_id               in lvs_lhm.Lte_Id%TYPE,
                                             in_scanner_name,  -- in_scanner_name         in isi_scanner_cfg.scanner_name%TYPE,
                                             v_vorgang_id,     -- in_out_vorg_id          in out lvs_lam_bh.vorg_id%TYPE,
                                             NULL,             -- in_labor_status         in lvs_lam.labor_status%type,
                                             NULL);            -- in_labor_text           in lvs_lam.labor_text%type
    else
      v_err_nr := 50;
      v_err_text := 'Nur LHM''s können gesperrt werden Bitte nur LHM''s scannen.';
      raise v_error;
    end if;

    v_msg := v_scanner.akt_aufgabe || ' OK';
  else
    v_msg := NULL;
    v_err_nr := 50;
    v_err_text := 'Aufgabe ' || nvl(v_scanner.akt_aufgabe, '<NULL>') || ' nicht möglich';
    raise v_error;
  end if;
  out_msg := v_msg;
  bde_isi_scan_log_id(v_scanner.scanner_name,
                    nvl(in_barcode_brutto, in_barcode),
                    nvl(v_prod_lte_id, v_lte_id),
                    nvl(v_prod_lhm_id, v_lhm_id),
                    v_scanner.akt_aufgabe,
                    NULL,
                    c.C_TRUE);
  commit;
  return(v_menge);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    bde_isi_scan_log_id(v_scanner.scanner_name,
                        nvl(in_barcode_brutto, in_barcode),
                        nvl(v_prod_lte_id, v_lte_id),
                        nvl(v_prod_lhm_id, v_lhm_id),
                        v_scanner.akt_aufgabe,
                        v_err_text,
                        c.C_FALSE);
    commit;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      if v_err_nr != 10
      then
        bde_isi_scan_log_id(v_scanner.scanner_name,
                            nvl(in_barcode_brutto, in_barcode),
                            nvl(v_prod_lte_id, v_lte_id),
                            nvl(v_prod_lhm_id, v_lhm_id),
                            v_scanner.akt_aufgabe,
                            v_err_text,
                            c.C_FALSE);
        commit;
      else
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      end if;
    else
      bde_isi_scan_log_id(v_scanner.scanner_name,
                          nvl(in_barcode_brutto, in_barcode),
                          nvl(v_prod_lte_id, v_lte_id),
                          nvl(v_prod_lhm_id, v_lhm_id),
                          v_scanner.akt_aufgabe,
                          NULL,
                          c.C_FALSE);
      commit;
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_scanner_buch_spez;

--------------------------------------------------------------------------------
-- procedure bde_c_com_server_connected
--
-- com_connected -> 'T'
--------------------------------------------------------------------------------
PROCEDURE bde_c_com_server_connected (
  in_sid               IN isi_scanner_funk_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_funk_cfg.firma_nr%TYPE,
  in_scanner_funk_name IN isi_scanner_funk_cfg.scanner_funk_name%TYPE) IS

  v_com_name isi_com_server.com_name%TYPE;

BEGIN

  SELECT cs.com_name INTO v_com_name
   FROM
   isi_scanner_funk_cfg fc,
   isi_com_server       cs
   WHERE
   fc.sid               = cs.sid AND
   fc.firma_nr          = cs.firma_nr AND
   fc.com_name          = cs.com_name AND
   fc.sid               = in_sid AND
   fc.firma_nr          = in_firma_nr AND
   fc.scanner_funk_name = in_scanner_funk_name;

  UPDATE
   isi_com_server cs
   SET
   cs.com_connected   = 'T',
   cs.com_geraet_name = in_scanner_funk_name,
   cs.com_geraet_typ  = 'SCANNER'
   WHERE
   cs.sid      = in_sid AND
   cs.firma_nr = in_firma_nr AND
   cs.com_name = v_com_name;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
END bde_c_com_server_connected;

--------------------------------------------------------------------------------
-- procedure bde_c_com_server_disconnected
--
-- com_connected -> 'F'
--------------------------------------------------------------------------------
PROCEDURE bde_c_com_server_disconnected (
  in_sid               IN isi_scanner_funk_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_funk_cfg.firma_nr%TYPE,
  in_scanner_funk_name IN isi_scanner_funk_cfg.scanner_funk_name%TYPE) IS

  v_com_name isi_com_server.com_name%TYPE;

BEGIN

  SELECT cs.com_name INTO v_com_name
   FROM
   isi_scanner_funk_cfg fc,
   isi_com_server       cs
   WHERE
   fc.sid               = cs.sid AND
   fc.firma_nr          = cs.firma_nr AND
   fc.com_name          = cs.com_name AND
   fc.sid               = in_sid AND
   fc.firma_nr          = in_firma_nr AND
   fc.scanner_funk_name = in_scanner_funk_name;

  UPDATE
   isi_com_server cs
   SET
   cs.com_connected   = 'F',
   cs.com_geraet_name = NULL,
   cs.com_geraet_typ  = NULL
   WHERE
   cs.sid      = in_sid AND
   cs.firma_nr = in_firma_nr AND
   cs.com_name = v_com_name;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
END bde_c_com_server_disconnected;

--------------------------------------------------------------------------------
-- procedure bde_scanner_funk_cfg
--
-- get Scanner parameters
--------------------------------------------------------------------------------

PROCEDURE bde_scanner_funk_cfg (
  in_sid                     IN  isi_scanner_funk_cfg.sid%TYPE,
  in_firma_nr                IN  isi_scanner_funk_cfg.firma_nr%TYPE,
  in_scanner_funk_name       IN  isi_scanner_funk_cfg.scanner_funk_name%TYPE,
  out_scanner_funk_prae      OUT isi_scanner_funk_cfg.scanner_funk_prae%TYPE,
  out_scanner_funk_post      OUT isi_scanner_funk_cfg.scanner_funk_post%TYPE,
  out_scanner_funk_delimiter OUT isi_scanner_funk_cfg.scanner_funk_delimiter%TYPE,
  out_ip_address             OUT isi_com_server.com_adress%TYPE,
  out_ip_port                OUT isi_com_server.com_port%TYPE) IS

  v_enabled isi_scanner_funk_cfg.scanner_funk_enabled%type;
begin
------------------------------------------------------------------------------------------
-- Nachbildung der alten Version für < 3.4.4
------------------------------------------------------------------------------------------

  bde_scanner_funk_cfg_V34 (in_sid,                    -- IN  isi_scanner_funk_cfg.sid%TYPE,
                            in_firma_nr,               -- IN  isi_scanner_funk_cfg.firma_nr%TYPE,
                            in_scanner_funk_name,      -- IN  isi_scanner_funk_cfg.scanner_funk_name%TYPE,
                            out_scanner_funk_prae,     -- OUT isi_scanner_funk_cfg.scanner_funk_prae%TYPE,
                            out_scanner_funk_post,     -- OUT isi_scanner_funk_cfg.scanner_funk_post%TYPE,
                            out_scanner_funk_delimiter,-- OUT isi_scanner_funk_cfg.scanner_funk_delimiter%TYPE,
                            out_ip_address,            -- OUT isi_com_server.com_adress%TYPE,
                            out_ip_port,               -- OUT isi_com_server.com_port%TYPE,
                            v_enabled);                -- out isi_scanner_funk_cfg.scanner_funk_enabled%type)
end bde_scanner_funk_cfg;

PROCEDURE bde_scanner_funk_cfg_V34 (
  in_sid                     IN  isi_scanner_funk_cfg.sid%TYPE,
  in_firma_nr                IN  isi_scanner_funk_cfg.firma_nr%TYPE,
  in_scanner_funk_name       IN  isi_scanner_funk_cfg.scanner_funk_name%TYPE,
  out_scanner_funk_prae      OUT isi_scanner_funk_cfg.scanner_funk_prae%TYPE,
  out_scanner_funk_post      OUT isi_scanner_funk_cfg.scanner_funk_post%TYPE,
  out_scanner_funk_delimiter OUT isi_scanner_funk_cfg.scanner_funk_delimiter%TYPE,
  out_ip_address             OUT isi_com_server.com_adress%TYPE,
  out_ip_port                OUT isi_com_server.com_port%TYPE,
  out_enabled                out isi_scanner_funk_cfg.scanner_funk_enabled%type) IS
BEGIN
  SELECT
    bde_util.human_to_steuerzeichen(fc.scanner_funk_prae),
    bde_util.human_to_steuerzeichen(fc.scanner_funk_post),
    bde_util.human_to_steuerzeichen(fc.scanner_funk_delimiter),
    cs.com_adress,
    cs.com_port,
    nvl(fc.scanner_funk_enabled, 'T')
  INTO
    out_scanner_funk_prae,
    out_scanner_funk_post,
    out_scanner_funk_delimiter,
    out_ip_address,
    out_ip_port,
    out_enabled
  FROM
    isi_scanner_funk_cfg fc,
    isi_com_server       cs
  WHERE
    fc.sid               = cs.sid AND
    fc.firma_nr          = cs.firma_nr AND
    fc.com_name          = cs.com_name AND
    fc.sid               = in_sid AND
    fc.firma_nr          = in_firma_nr AND
    fc.scanner_funk_name = in_scanner_funk_name;
EXCEPTION
  WHEN OTHERS THEN
    out_scanner_funk_prae      := null;
    out_scanner_funk_post      := null;
    out_scanner_funk_delimiter := null;
    out_ip_address             := null;
    out_ip_port                := null;
END bde_scanner_funk_cfg_V34;

--------------------------------------------------------------------------------
-- procedure bde_c_scanner_ins_scanner_cfg
--
-- insert new record in isi_scanner_cfg table
--------------------------------------------------------------------------------
PROCEDURE bde_c_scanner_ins_scanner_cfg (
  in_sid               IN isi_scanner_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_cfg.firma_nr%TYPE,
  in_scanner_name      IN isi_scanner_cfg.scanner_name%TYPE,
  in_scanner_prae      IN isi_scanner_cfg.scanner_prae%TYPE,
  in_scanner_post      IN isi_scanner_cfg.scanner_post%TYPE,
  in_scanner_typ       IN isi_scanner_cfg.scanner_typ%TYPE,
  in_com_name          IN isi_scanner_cfg.com_name%TYPE,
  in_scanner_visuname  IN isi_scanner_cfg.scanner_visuname%TYPE,
  in_ls_login_id       IN isi_scanner_cfg.ls_login_id%TYPE,
  in_res_id            IN isi_scanner_cfg.res_id%TYPE,
  in_akt_aufgabe       IN isi_scanner_cfg.akt_aufgabe%TYPE,
  in_scanner_funk_name IN isi_scanner_cfg.scanner_funk_name%TYPE) IS
BEGIN
  INSERT INTO isi_scanner_cfg sc
  (
   sc.sid,
   sc.firma_nr,
   sc.scanner_name,
   sc.scanner_prae,
   sc.scanner_post,
   sc.scanner_typ,
   sc.com_name,
   sc.scanner_visuname,
   sc.ls_login_id,
   sc.res_id,
   sc.akt_aufgabe,
   sc.scanner_funk_name
  )
  VALUES
  (
   in_sid,
   in_firma_nr,
   in_scanner_name,
   in_scanner_prae,
   in_scanner_post,
   in_scanner_typ,
   in_com_name,
   in_scanner_visuname,
   in_ls_login_id,
   in_res_id,
   in_akt_aufgabe,
   in_scanner_funk_name
  );

  COMMIT;
END bde_c_scanner_ins_scanner_cfg;

--------------------------------------------------------------------------------
-- procedure bde_c_scanner_upd_scanner_cfg
--
-- update record in isi_scanner_cfg table
--------------------------------------------------------------------------------
PROCEDURE bde_c_scanner_upd_scanner_cfg (
  in_sid               IN isi_scanner_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_cfg.firma_nr%TYPE,
  in_scanner_name      IN isi_scanner_cfg.scanner_name%TYPE,
  in_scanner_prae      IN isi_scanner_cfg.scanner_prae%TYPE,
  in_scanner_post      IN isi_scanner_cfg.scanner_post%TYPE,
  in_scanner_typ       IN isi_scanner_cfg.scanner_typ%TYPE,
  in_com_name          IN isi_scanner_cfg.com_name%TYPE,
  in_scanner_visuname  IN isi_scanner_cfg.scanner_visuname%TYPE,
  in_ls_login_id       IN isi_scanner_cfg.ls_login_id%TYPE,
  in_res_id            IN isi_scanner_cfg.res_id%TYPE,
  in_akt_aufgabe       IN isi_scanner_cfg.akt_aufgabe%TYPE,
  in_scanner_funk_name IN isi_scanner_cfg.scanner_funk_name%TYPE) IS
BEGIN
  UPDATE isi_scanner_cfg sc SET
   sc.scanner_prae      = in_scanner_prae,
   sc.scanner_post      = in_scanner_post,
   sc.scanner_typ       = in_scanner_typ,
   sc.com_name          = in_com_name,
   sc.scanner_visuname  = in_scanner_visuname,
   sc.ls_login_id       = in_ls_login_id,
   sc.res_id            = in_res_id,
   sc.akt_aufgabe       = in_akt_aufgabe,
   sc.scanner_funk_name = in_scanner_funk_name
   WHERE
   sc.sid          = in_sid AND
   sc.firma_nr     = in_firma_nr AND
   sc.scanner_name = in_scanner_name;

  COMMIT;
END bde_c_scanner_upd_scanner_cfg;

--------------------------------------------------------------------------------
-- procedure bde_scanner_lock_scanner_cfg
--
-- lock record in isi_scanner_cfg table
--------------------------------------------------------------------------------
PROCEDURE bde_scanner_lock_scanner_cfg (
  in_sid               IN isi_scanner_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_cfg.firma_nr%TYPE,
  in_scanner_name      IN isi_scanner_cfg.scanner_name%TYPE) IS

  dummy varchar2(1);
BEGIN
  SELECT 'x' INTO dummy
   FROM isi_scanner_cfg sc
   WHERE
   sc.sid          = in_sid AND
   sc.firma_nr     = in_firma_nr AND
   sc.scanner_name = in_scanner_name
   FOR UPDATE NOWAIT;
EXCEPTION
  WHEN TIMEOUT_ON_RESOURCE THEN
    RAISE_APPLICATION_ERROR (-20000, 'This Terminal is locked by another user');
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR (-20000, 'This Terminal has been deleted by another user');
END bde_scanner_lock_scanner_cfg;

--------------------------------------------------------------------------------
-- procedure bde_c_scanner_del_scanner_cfg
--
-- delete record in isi_scanner_cfg table
--------------------------------------------------------------------------------
PROCEDURE bde_c_scanner_del_scanner_cfg (
  in_sid               IN isi_scanner_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_cfg.firma_nr%TYPE,
  in_scanner_name      IN isi_scanner_cfg.scanner_name%TYPE) IS
BEGIN
  DELETE FROM isi_scanner_cfg sc
   WHERE
   sc.sid          = in_sid AND
   sc.firma_nr     = in_firma_nr AND
   sc.scanner_name = in_scanner_name;

  COMMIT;
END bde_c_scanner_del_scanner_cfg;

procedure scanner_spez_barcode(in_barcode              in  lvs_lam.lhm_id%type,
                               in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                               out_artikel             out varchar2,
                               out_charge              out varchar2,
                               out_prod_datum_str      out varchar2,
                               out_prod_datum_struktur out varchar2,
                               out_menge_str           out varchar2,
                               out_ean                 out varchar2)
                               is

  v_start_pos number;

begin
  out_artikel := '';
  out_charge := '';
  out_prod_datum_str := '';
  out_menge_str := '';
  out_ean := '';

  v_start_pos := 1;
  -- !!! Achtung Änderungen hier auch in Modul BDE_SCANNER.spez_barcode_gen ändern redundante Routine
  -- !!!                              in Modul LVS_P_LTE_LHM.spez_barcode_gen
  -- !!!                              in Modul ISI_UTILS.spez_barcode_gen

  while (v_start_pos < length(in_parameter_wert)) loop
    if    substr(in_parameter_wert, v_start_pos, 1) = 'A' then out_artikel := out_artikel || substr(in_barcode, v_start_pos, 1);
    elsif substr(in_parameter_wert, v_start_pos, 1) = 'C' then out_charge  := out_charge  || substr(in_barcode, v_start_pos, 1);
    elsif substr(in_parameter_wert, v_start_pos, 6) = 'PDMMYY' then out_prod_datum_str := substr(in_barcode, v_start_pos, 6);
                                                                    out_prod_datum_struktur := 'DDMMYY';
                                                                    v_start_pos := v_start_pos + 5;
    elsif substr(in_parameter_wert, v_start_pos, 5) = 'EAN06'  then out_ean := substr(in_barcode, v_start_pos, 6);
                                                                    v_start_pos := v_start_pos + 5;
    elsif substr(in_parameter_wert, v_start_pos, 5) = 'EAN13'  then out_ean := substr(in_barcode, v_start_pos, 13);
                                                                    v_start_pos := v_start_pos + 12;
    elsif substr(in_parameter_wert, v_start_pos, 5) = 'EAN14'  then out_ean := substr(in_barcode, v_start_pos, 14);
                                                                    v_start_pos := v_start_pos + 13;
    elsif substr(in_parameter_wert, v_start_pos, 1) = 'M' then out_menge_str  := out_menge_str  || substr(in_barcode, v_start_pos, 1);
    end if;
    v_start_pos := v_start_pos + 1;
  end loop;
end scanner_spez_barcode;


function insert_lhm_aus_barcode(in_sid             in isi_sid.sid%type,
                                in_firma_nr        in isi_firma.firma_nr%type,
                                in_barcode         in lvs_lam.lhm_id%type,
                                in_parameter_wert  in isi_firma_cfg.parameter_wert%type,
                                in_login_id        in isi_user.login_id%type)
                                return varchar2 is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_lam                         lvs_lam%rowtype;

  v_artikel                     isi_artikel%rowtype;
  v_charge                      lvs_charge.charge_bez%type;
  v_menge_str                   varchar2(20);
  v_ean                         varchar2(20);

  v_menge                       lvs_lam.menge%type;
  v_prod_datum                  date;

  v_prod_datum_str              varchar2(30);
  v_prod_datum_struktur         varchar2(30);
  v_sysdate                     date;

  v_found                       boolean;
--  v_start_pos number;

  CURSOR c_artikel is
    select a.*
      from isi_artikel a
     where a.sid = in_sid
       and a.artikel = v_artikel.artikel;

  CURSOR c_lte_lhm is
    select l.*
      from lvs_lam l
     where l.lte_id = v_artikel.artikel || v_charge;

BEGIN
  scanner_spez_barcode(in_barcode,                       -- in_barcode              in  lvs_lam.lhm_id%type,
                       in_parameter_wert,                -- in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                       v_artikel.artikel,                -- out_artikel             out varchar2,
                       v_charge,                         -- out_charge              out varchar2,
                       v_prod_datum_str,                 -- out_prod_datum_str      out varchar2,
                       v_prod_datum_struktur,            -- out_prod_datum_struktur out varchar2,
                       v_menge_str,                      -- out_menge_str           out varchar2,
                       v_ean);                           -- out_ean                 out varchar2)

  if length(v_artikel.artikel) = 0
  then
    v_err_nr := 10;
    v_err_text := 'Artikel NR Fehlt';
    raise v_error;
  end if;
  if length(v_charge) = 0
  then
    v_err_nr := 20;
    v_err_text := 'Charge NR Fehlt';
    raise v_error;
  end if;
  if length(v_menge_str) = 0
  then
    v_err_nr := 30;
    v_err_text := 'Menge Fehlt';
    raise v_error;
  end if;
  if length(v_prod_datum_str) = 0
  then
    v_err_nr := 40;
    v_err_text := 'Prod. Datum Fehlt';
    raise v_error;
  end if;

  v_err_nr := 50;
  v_err_text := 'Fehler in der Menge';
  v_menge := to_number(v_menge_str);

  v_err_nr := 60;
  v_err_text := 'Fehler im Datum';
  v_prod_datum := to_date(v_prod_datum_str, v_prod_datum_struktur);

  OPEN c_artikel;
  FETCH c_artikel into v_artikel;
  v_found := c_artikel%FOUND;
  CLOSE c_artikel;

  if not v_found
  then
    v_err_nr := 80;
    v_err_text := 'Artikelnr: ' || v_artikel.artikel || ' fehlt';
  end if;

  v_sysdate := sysdate;
  -- -AG- BugFix:  20.08.2009 Fehler beim Berechnen des MHD Datums
  lvs_p_lte.lvs_c_lte_artikel_erzeugen (in_sid,                             -- in_sid                 in isi_sid.sid%type,
                                        in_firma_nr,                        -- in_firma_nr            in isi_firma.firma_nr%type,
                                        v_artikel.artikel || v_charge,      -- in_lte_id              in lvs_lte.lte_id%type,
                                        v_artikel.artikel,                  -- in_artikel             in isi_artikel.artikel%type,
                                        v_artikel.menge_basis,              -- in_menge_basis         in lvs_lam.menge_basis%type,
                                        v_artikel.mengeneinheit_basis,      -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                        v_charge,                           -- in_charge              in lvs_charge.charge_bez%type,
                                        v_menge,                            -- in_menge               in lvs_lam.menge%type,
                                        v_artikel.lte_hoehe_max,            -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                        v_artikel.lte_breite_max,           -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                        v_artikel.lte_tiefe_max,            -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                        v_artikel.lte_name,                 -- in_lte_name            in lvs_lte.lte_name%type,
                                        v_artikel.lte_gewicht_kg,           -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                        v_prod_datum,                       -- in_prod_datum          in lvs_lam.prod_datum%type,
                                        v_sysdate,                          -- in_zug_datum           in lvs_lam.zug_datum%type,
                                        NULL,                               -- in_mhd                 in lvs_lam.lam_mhd%type,
                                        NULL,                               -- in_sep_nve             in lvs_lte.nve_nr%type,
                                        NULL,                               -- in_prod_nr             in lvs_lam.leitzahl%type,
                                        NULL,                               -- in_fa_ag               in lvs_lam.fa_ag%type,
                                        NULL,                               -- in_fa_upos             in lvs_lam.fa_upos%type,
                                        'F',                                -- in_wa_status           in lvs_lam.labor_status%type,
                                        NULL,                               -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                        in_login_id);                       -- in_login_id            in isi_user.login_id%type);
  OPEN c_lte_lhm;
  FETCH c_lte_lhm into v_lam;
  CLOSE c_lte_lhm;

  return (v_lam.lhm_id);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end insert_lhm_aus_barcode;

procedure bde_scanner_check_maschine(in_maschine_name          in isi_resource.res_ext_name%type)
                                     is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_resource                  isi_resource%rowtype;
  v_found                     boolean;

  CURSOR c_resource is
    select *
      from isi_resource t
     where t.res_ext_name = in_maschine_name;
begin
  OPEN c_resource;
  FETCH c_resource into v_resource;
  v_found := c_resource%FOUND;
  CLOSE c_resource;

  if not v_found
  then
    v_err_nr := 10;
    v_err_text := 'Maschine fehlt ' || in_maschine_name;
    raise v_error;
  end if;
  NULL;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_scanner_check_maschine;

procedure bde_c_scanner_fa_freigabe(in_login_transponder     in isi_user.transponder%type,
                                    in_maschine_name          in isi_resource.res_ext_name%type)
                                     is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_ls_login_id isi_user.login_id%type;    -- Login ID aus Transponderkey
  v_pers_nr     isi_user.pers_nr%type;     -- Pers_nr aus Transponderkey

  v_res_zus_akt isi_resource_zust_akt%rowtype;
  v_vorg_id     bde_pd_prod.vorg_id%type;          --  Vorgangs ID aus SEQ_VOR

  CURSOR c_resource_zust_akt is
    select r_a.*
      from isi_resource res,
           isi_resource_zust_akt r_a
     where res.res_ext_name = in_maschine_name
       and r_a.res_id = res.res_id;

  CURSOR c_login_daten is
    select isi_user.login_id,
           isi_user.pers_nr
      from isi_user
     where isi_user.transponder = in_login_transponder;


begin
  OPEN c_resource_zust_akt;
  FETCH c_resource_zust_akt into v_res_zus_akt;
  CLOSE c_resource_zust_akt;

  UPDATE bde_fa_auftrag fa
     set fa.status_freigabe = decode(fa.freig_status,
                                     'N', NULL,
                                     NULL, NULL,
                                     900)
   where fa.sid           = v_res_zus_akt.sid
     and fa.firma_nr      = v_res_zus_akt.firma_nr
     and fa.leitzahl      = v_res_zus_akt.leitzahl
     and fa.fa_ag         = v_res_zus_akt.fa_ag
     and fa.fa_upos       = v_res_zus_akt.fa_upos;
  OPEN c_login_daten;
  FETCH c_login_daten into v_ls_login_id, v_pers_nr;
  CLOSE c_login_daten;

  v_err_nr := 10;
  v_err_text := 'Fehler beim holer der SEQ Vorgang ID für QS Freigabe.';
  select seq_vorg_id.nextval into v_vorg_id from dual;
  v_err_nr := 20;
  v_err_text := 'Fehler beim Eintragen der QS Freigabe.';
  insert into bde_pd_prod p
         values(v_res_zus_akt.sid,                -- SID           VARCHAR2(2) not null,
                v_vorg_id,                        -- VORG_ID       NUMBER not null,
                'QF',                             -- VORG_TYP      VARCHAR2(2) not null,
                v_res_zus_akt.firma_nr,           -- FIRMA_NR      NUMBER(2) not null,
                v_res_zus_akt.leitzahl,           -- LEITZAHL      NUMBER not null,
                v_res_zus_akt.fa_ag,              -- FA_AG         NUMBER not null,
                v_res_zus_akt.fa_upos,            -- FA_UPOS       NUMBER,
                NULL,                             -- ABNR          VARCHAR2(20),
                v_res_zus_akt.res_id,             -- RES_ID        NUMBER not null,
                sysdate,                          -- PROD_BEGINN   DATE not null,
                sysdate,                          -- PROD_ENDE     DATE,
                v_pers_nr,                        -- PERS_NR       NUMBER,
                NULL,                             -- LAM_ID        NUMBER,
                NULL,                             -- ARTIKEL_ID    NUMBER,
                NULL,                             -- MENGE_A       NUMBER,
                NULL,                             -- MENGE_B       NUMBER,
                NULL,                             -- SCHROTT       NUMBER,
                v_ls_login_id,                    -- LS_LOGIN_ID   NUMBER,
                NULL,                             -- PD_NETTO_ZEIT NUMBER
                v_res_zus_akt.abfuell_abschalt_grob,
                v_res_zus_akt.abfuell_abschalt_mittel,
                v_res_zus_akt.abfuell_abschalt_fein,
                v_res_zus_akt.abfuell_toleranz_plus,
                v_res_zus_akt.abfuell_toleranz_minus,
                v_res_zus_akt.abfuell_silo,
                v_res_zus_akt.abfuell_soll,
                v_res_zus_akt.abfuell_ist,
                v_res_zus_akt.prod_params,
                NULL,
                NULL,
                NULL,
                NULL);
  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_scanner_fa_freigabe;

procedure bde_c_scanner_fa_p_anmelden (in_sid          in isi_sid.sid%type,
                                     in_firma_nr     in isi_firma.firma_nr%type,
                                     in_leitzahl     in bde_fa_auftrag.leitzahl%type,
                                     in_res_ext_name in isi_resource.res_ext_name%type,
                                     in_login_id     in isi_user.login_id%type) is


  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_fa_auftrag                     bde_fa_auftrag%rowtype;
  v_found                     boolean;
  v_res_ms                    isi_resource%rowtype;
  v_res_mpg                   isi_resource%rowtype;

  CURSOR c_fa_auftrag is
    select *
      from bde_fa_auftrag a
     where a.sid = in_sid
       and a.firma_nr = in_firma_nr
       and a.leitzahl = in_leitzahl
       and a.satzart = 'V'
       and (a.res_id = v_res_ms.res_id
         or a.res_id = v_res_mpg.res_id);

  CURSOR c_isi_res is
    select *
      from isi_resource r
     where r.res_ext_name = in_res_ext_name
       and r.typ = 'MS';

  CURSOR c_isi_res_grp is
    select *
      from isi_resource r
     where r.gruppe = v_res_ms.gruppe
       and r.typ = 'MPG';

begin
   OPEN c_isi_res;
   FETCH c_isi_res into v_res_ms;
   v_found := c_isi_res%found;
   CLOSE c_isi_res;
   if not v_found
   then
     v_err_nr := 05;
     v_err_text := 'Fehler: Maschine ' || in_res_ext_name || ' fehlt';
     raise v_error;
   end if;

   v_res_mpg := NULL;
   OPEN c_isi_res_grp;
   FETCH c_isi_res_grp into v_res_mpg;
   CLOSE c_isi_res_grp;

   OPEN c_fa_auftrag;
   FETCH c_fa_auftrag into v_fa_auftrag;
   v_found := c_fa_auftrag%FOUND;
   CLOSE c_fa_auftrag;

   if not v_found
   then
     v_err_nr := 10;
     v_err_text := 'Fehler: FA-Auftrag ' || to_char(in_leitzahl) || ' fehlt in Maschine ' || in_res_ext_name;
     raise v_error;
   end if;

   bde_pd_prod_p_ag_b(in_sid,                  -- in_sid         in isi_sid.sid%type,
                      in_firma_nr,             -- in_firma_nr    in isi_firma.firma_nr%type,
                      v_fa_auftrag.leitzahl,   -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                      v_fa_auftrag.fa_ag,      -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                      v_fa_auftrag.fa_upos,    -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                      v_res_ms.res_id,         -- in_res_id      in isi_resource.res_id%type,
                      NULL,                    -- in_akt_term    in isi_arbeitsplatz.ip_name%type,
                      in_login_id);            -- in_ls_login_id in isi_user.login_id%type) is
  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_scanner_fa_p_anmelden;

procedure bde_c_scanner_fa_p_abmelden (in_sid          in isi_sid.sid%type,
                                     in_firma_nr     in isi_firma.firma_nr%type,
                                     in_res_ext_name in isi_resource.res_ext_name%type,
                                     in_login_id     in isi_user.login_id%type) is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_fa_auftrag                     bde_fa_auftrag%rowtype;
  v_zustand_aktuell                isi_resource_zust_akt%rowtype;
  v_found                     boolean;

  CURSOR c_fa_auftrag is
    select *
      from bde_fa_auftrag a
     where a.sid = in_sid
       and a.firma_nr = in_firma_nr
       and a.leitzahl = v_zustand_aktuell.leitzahl
       and a.satzart = 'V';

  CURSOR c_zust_akt is
    select *
      from isi_resource_zust_akt t
     where t.sid = in_sid
       and t.res_id = (select res_id
                         from isi_resource r
                        where r.res_ext_name = in_res_ext_name);
begin

  OPEN c_zust_akt;
  FETCH c_zust_akt into v_zustand_aktuell;
  v_found := c_zust_akt%FOUND;
  CLOSE c_zust_akt;

  if not v_found
  then
    v_err_nr := 10;
    v_err_text := 'Fehler: Zustandseintrag für ' || in_res_ext_name || ' fehlt';
    raise v_error;
  end if;

  OPEN c_fa_auftrag;
  FETCH c_fa_auftrag into v_fa_auftrag;
  v_found := c_fa_auftrag%FOUND;
  CLOSE c_fa_auftrag;

  if not v_found
  then
    v_err_nr := 20;
    v_err_text := 'Fehler: FA-Auftrag ' || to_char(v_zustand_aktuell.leitzahl) || ' fehlt in Maschine ' || in_res_ext_name;
    raise v_error;
  end if;

  bde_pd_prod_p_ag_e(in_sid,                  -- in_sid         in isi_sid.sid%type,
                     in_firma_nr,             -- in_firma_nr    in isi_firma.firma_nr%type,
                     v_fa_auftrag.leitzahl,   -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                     v_fa_auftrag.fa_ag,      -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                     v_fa_auftrag.fa_upos,    -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                     v_zustand_aktuell.res_id,-- in_res_id      in isi_resource.res_id%type,
                     sysdate,                 -- in_sysdate     date,
                     0,                       -- in_menge_a     in bde_pd_prod.menge_a%type,
                     0,                       -- in_menge_b     in bde_pd_prod.menge_b%type,
                     0,                       -- in_schrott     in bde_pd_prod.schrott%type,
                     in_login_id);            -- in_ls_login_id in isi_user.login_id%type) is
  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt, als lam_id wird 0 zurückgegeben.
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_scanner_fa_p_abmelden;

procedure bde_c_scanner_fa_r_anmelden (in_sid          in isi_sid.sid%type,
                                     in_firma_nr     in isi_firma.firma_nr%type,
                                     in_leitzahl     in bde_fa_auftrag.leitzahl%type,
                                     in_res_ext_name in isi_resource.res_ext_name%type,
                                     in_login_id     in isi_user.login_id%type) is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_fa_auftrag                     bde_fa_auftrag%rowtype;
  v_found                     boolean;
  v_res_ms                    isi_resource%rowtype;
  v_res_mpg                   isi_resource%rowtype;

  CURSOR c_fa_auftrag is
    select *
      from bde_fa_auftrag a
     where a.sid = in_sid
       and a.firma_nr = in_firma_nr
       and a.leitzahl = in_leitzahl
       and (a.satzart = 'V'
        or a.satzart = 'VR')
       and (a.res_id = v_res_ms.res_id
         or a.res_id = v_res_mpg.res_id)
   order by a.satzart desc;

  CURSOR c_isi_res is
    select *
      from isi_resource r
     where r.res_ext_name = in_res_ext_name
       and r.typ = 'MS';

  CURSOR c_isi_res_grp is
    select *
      from isi_resource r
     where r.gruppe = v_res_ms.gruppe
       and r.typ = 'MPG';

begin
   OPEN c_isi_res;
   FETCH c_isi_res into v_res_ms;
   v_found := c_isi_res%found;
   CLOSE c_isi_res;
   if not v_found
   then
     v_err_nr := 05;
     v_err_text := 'Fehler: Maschine ' || in_res_ext_name || ' fehlt';
     raise v_error;
   end if;

   v_res_mpg := NULL;
   OPEN c_isi_res_grp;
   FETCH c_isi_res_grp into v_res_mpg;
   CLOSE c_isi_res_grp;

   OPEN c_fa_auftrag;
   FETCH c_fa_auftrag into v_fa_auftrag;
   v_found := c_fa_auftrag%FOUND;
   CLOSE c_fa_auftrag;

   if not v_found
   then
     v_err_nr := 10;
     v_err_text := 'Fehler: FA-Auftrag ' || to_char(in_leitzahl) || ' fehlt in Maschine ' || in_res_ext_name;
     raise v_error;
   end if;

   bde_pd_prod_r_ag_b(in_sid,                  -- in_sid         in isi_sid.sid%type,
                      in_firma_nr,             -- in_firma_nr    in isi_firma.firma_nr%type,
                      in_leitzahl,             -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                      v_fa_auftrag.fa_ag,      -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                      v_fa_auftrag.fa_upos,    -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                      v_res_ms.res_id,         -- in_res_id      in isi_resource.res_id%type,
                      in_login_id);            -- in_ls_login_id in isi_user.login_id%type) is
  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_scanner_fa_r_anmelden;

procedure bde_c_scanner_fa_r_abmelden (in_sid          in isi_sid.sid%type,
                                     in_firma_nr     in isi_firma.firma_nr%type,
                                     in_res_ext_name in isi_resource.res_ext_name%type,
                                     in_login_id     in isi_user.login_id%type) is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_zustand_aktuell                isi_resource_zust_akt%rowtype;
  v_found                     boolean;

  CURSOR c_fa_auftrag is
    select *
      from bde_fa_auftrag a
     where a.sid = in_sid
       and a.firma_nr = in_firma_nr
       and a.leitzahl = v_zustand_aktuell.leitzahl
       and a.satzart = 'V';

  CURSOR c_zust_akt is
    select *
      from isi_resource_zust_akt t
     where t.sid = in_sid
       and t.res_id = (select res_id
                         from isi_resource r
                        where r.res_ext_name = in_res_ext_name);
begin

  OPEN c_zust_akt;
  FETCH c_zust_akt into v_zustand_aktuell;
  v_found := c_zust_akt%FOUND;
  CLOSE c_zust_akt;

  if not v_found
  then
    v_err_nr := 20;
    v_err_text := 'Fehler: FA-Auftrag ' || to_char(v_zustand_aktuell.leitzahl) || ' fehlt in Maschine ' || in_res_ext_name;
    raise v_error;
  end if;

  bde_pd_prod_r_ag_e(in_sid,                       -- in_sid         in isi_sid.sid%type,
                     in_firma_nr,                  -- in_firma_nr    in isi_firma.firma_nr%type,
                     v_zustand_aktuell.leitzahl,   -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                     v_zustand_aktuell.fa_ag,      -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                     v_zustand_aktuell.fa_upos,    -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                     v_zustand_aktuell.res_id,     -- in_res_id      in isi_resource.res_id%type,
                     sysdate,                      -- in_sysdate     date,
                     0,                            -- in_menge_a     in bde_pd_prod.menge_a%type,
                     0,                            -- in_menge_b     in bde_pd_prod.menge_b%type,
                     0,                            -- in_schrott     in bde_pd_prod.schrott%type,
                     in_login_id);                 -- in_ls_login_id in isi_user.login_id%type) is
  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_scanner_fa_r_abmelden;

function bde_c_scanner_login(in_scanner_name in varchar2,
                              in_transponder  in varchar2,
                              out_msg         out varchar2
                              ) return number is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_nname       isi_user.nachname%type;              -- Nachname für Return
  v_vname       isi_user.vorname%type;               -- Vorname
  v_login_name  isi_user.username%type;
  v_ls_login_id isi_scanner_cfg.ls_login_id%type;    -- Login ID aus dem Terminal

  v_msg         varchar2(80);

  v_found       boolean;


  -------------------------------------------------------------------------------------------------------
  -- Cursor
  -------------------------------------------------------------------------------------------------------

  CURSOR c_name is
    select isi_user.nachname,
           isi_user.vorname,
           isi_user.login_id,
           isi_user.username
      from isi_user
     where isi_user.transponder = in_transponder;
begin
  OPEN c_name;
  FETCH c_name into v_nname, v_vname, v_ls_login_id, v_login_name; -- Daten lesen
  v_found := c_name%FOUND;                                         -- Keine Daten für dieses Terminal vorhanden
  CLOSE c_name;

  if not v_found then
     v_err_nr := 10;
     v_err_text := 'Fehler Login';
     raise v_error;
  end if;

  update isi_scanner_cfg sc
     set sc.ls_login_id = v_ls_login_id,
         sc.res_id = NULL,
         sc.akt_aufgabe = NULL
   where sc.scanner_name = in_scanner_name;
  if v_ls_login_id != 0 then
    if v_nname is NULL then
      v_msg := v_login_name;                  -- Wenn kein Name dann Loginname
    else
      v_msg := v_nname || ', ' || v_vname;    -- Nane aus PZM
    end if;

  else
    v_msg := 'Superuser :-)';                 -- Superuser ist angemeldet
  end if;

  commit;
  out_msg := v_msg;
  return (v_ls_login_id);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_scanner_login;

procedure bde_c_scanner_ms_status(in_sid           in isi_sid.sid%type,
                                  in_firma_nr      in isi_firma.firma_nr%type,
                                  in_maschine_name in isi_resource.res_ext_name%type,
                                  in_transponder   in isi_user.transponder%type,
                                  in_res_st_id     in isi_res_status_cfg.res_st_id%type) is


  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_nname       isi_user.nachname%type;              -- Nachname für Return
  v_vname       isi_user.vorname%type;               -- Vorname
  v_login_name  isi_user.username%type;
  v_ls_login_id isi_scanner_cfg.ls_login_id%type;    -- Login ID aus dem Terminal

  v_resource    isi_resource%rowtype;

  v_found       boolean;

  CURSOR c_name is
    select isi_user.nachname,
           isi_user.vorname,
           isi_user.login_id,
           isi_user.username
      from isi_user
     where isi_user.transponder = in_transponder;

  CURSOR c_res is
    select *
      from isi_resource res
     where res.res_ext_name = in_maschine_name;

begin
  OPEN c_name;
  FETCH c_name into v_nname, v_vname, v_ls_login_id, v_login_name; -- Daten lesen
  v_found := c_name%FOUND;                                         -- Keine Daten für dieses Terminal vorhanden
  CLOSE c_name;

  if not v_found then
     v_err_nr := 10;
     v_err_text := 'Kartennr. fehlt';
     raise v_error;
  end if;

  OPEN c_res;
  FETCH c_res into v_resource;
  v_found := c_res%FOUND;
  CLOSE c_res;

  if not v_found then
     v_err_nr := 20;
     v_err_text := 'Maschine fehlt ';
     raise v_error;
  end if;

  res_status.res_status_beg(in_sid,                       -- in_sid           in isi_sid.sid%type,
                            in_firma_nr,                  -- in_firma_nr      in isi_firma.firma_nr%type,
                            v_resource.res_id,            -- in_res_id        in isi_resource.res_id%type,
                            v_ls_login_id,                -- in_ls_login_id   in isi_user.login_id%type,
                            in_res_st_id,                 -- in_res_st_id     in isi_res_status_cfg.res_st_id%type,
                            v_resource.typ,               -- in_res_typ       in isi_res_status_cfg.res_typ%type,
                            in_res_st_id,                 -- in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
                            v_resource.fehler_schluessel, -- in_fehler_res_id in isi_res_status.fehler_res_id%type,
                            sysdate);                     -- in_sysdate       in date default null) is

  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_scanner_ms_status;

procedure bde_c_sc_ms_Schicht_anmelden(in_sid           in isi_sid.sid%type,
                                       in_firma_nr      in isi_firma.firma_nr%type,
                                       in_maschine_name in isi_resource.res_ext_name%type,
                                       in_login_id      in isi_user.login_id%type) is


  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_nname       isi_user.nachname%type;              -- Nachname für Return
  v_vname       isi_user.vorname%type;               -- Vorname
  v_login_name  isi_user.username%type;
  v_ls_login_id isi_scanner_cfg.ls_login_id%type;    -- Login ID aus dem Terminal
  v_pers_nr     isi_user.pers_nr%type;
  v_pd_k        bde_pd_kopf%rowtype;                     -- Schichtkopfdaten

  v_resource    isi_resource%rowtype;

  v_found       boolean;

  CURSOR c_name is
    select isi_user.nachname,
           isi_user.vorname,
           isi_user.login_id,
           isi_user.username,
           isi_user.pers_nr
      from isi_user
     where isi_user.sid = in_sid
       and isi_user.login_id = in_login_id;

  CURSOR c_res is
    select *
      from isi_resource res
     where res.res_ext_name = in_maschine_name;

  CURSOR c_pd_k is
    SELECT *
      FROM bde_pd_kopf pd_k
      WHERE pd_k.sid = in_sid and
            pd_k.firma_nr = in_firma_nr and
            pd_k.res_id = v_resource.res_id and
            pd_k.pd_kopf_ende is NULL;

begin
  OPEN c_name;
  FETCH c_name into v_nname, v_vname, v_ls_login_id, v_login_name, v_pers_nr; -- Daten lesen
  v_found := c_name%FOUND;                                                    -- Keine Daten für dieses Terminal vorhanden
  CLOSE c_name;

  if not v_found then
     v_err_nr := 10;
     v_err_text := 'Kartennr. fehlt';
     raise v_error;
  end if;

  OPEN c_res;
  FETCH c_res into v_resource;
  v_found := c_res%FOUND;
  CLOSE c_res;

  if not v_found then
     v_err_nr := 20;
     v_err_text := 'Maschine fehlt ';
     raise v_error;
  end if;

  OPEN c_pd_k;              -- Lesen des Eintrags
  FETCH c_pd_k into v_pd_k;
  v_found := c_pd_k%FOUND;  -- Merken ob einer gefunden wo auch die Pers_nr OK ist
  CLOSE c_pd_k;

  if v_found
  then
    if v_pd_k.pers_nr = v_pers_nr
    then
      return;
    else
      bde_pd_kopf_schicht_e(in_sid,               -- in_sid         in isi_sid.sid%type,
                            in_firma_nr,          -- in_firma_nr    in isi_firma.firma_nr%type,
                            v_resource.res_id,    -- in_res_id      in isi_resource.res_id%type,
                            v_pers_nr,            -- in_pers_nr     in isi_user.pers_nr%type,
                            v_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type)
    end if;
  end if;

  bde_pd_kopf_schicht_b(in_sid,                   -- in_sid         in isi_sid.sid%type,
                        in_firma_nr,              -- in_firma_nr    in isi_firma.firma_nr%type,
                        v_resource.res_id,        -- in_res_id      in isi_resource.res_id%type,
                        v_pers_nr,                -- in_pers_nr     in isi_user.pers_nr%type,
                        v_ls_login_id);           -- in_ls_login_id in isi_user.login_id%type)

  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_sc_ms_Schicht_anmelden;

procedure bde_c_sc_ms_Schicht_abmelden(in_sid           in isi_sid.sid%type,
                                       in_firma_nr      in isi_firma.firma_nr%type,
                                       in_maschine_name in isi_resource.res_ext_name%type,
                                       in_login_id      in isi_user.login_id%type) is


  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_nname       isi_user.nachname%type;              -- Nachname für Return
  v_vname       isi_user.vorname%type;               -- Vorname
  v_login_name  isi_user.username%type;
  v_ls_login_id isi_scanner_cfg.ls_login_id%type;    -- Login ID aus dem Terminal
  v_pers_nr     isi_user.pers_nr%type;

  v_resource    isi_resource%rowtype;

  v_found       boolean;

  CURSOR c_name is
    select isi_user.nachname,
           isi_user.vorname,
           isi_user.login_id,
           isi_user.username,
           isi_user.pers_nr
      from isi_user
     where isi_user.login_id = in_login_id;

  CURSOR c_res is
    select *
      from isi_resource res
     where res.res_ext_name = in_maschine_name;

begin
  OPEN c_name;
  FETCH c_name into v_nname, v_vname, v_ls_login_id, v_login_name, v_pers_nr; -- Daten lesen
  v_found := c_name%FOUND;                                                    -- Keine Daten für dieses Terminal vorhanden
  CLOSE c_name;

  if not v_found then
     v_err_nr := 10;
     v_err_text := 'Kartennr. fehlt';
     raise v_error;
  end if;

  OPEN c_res;
  FETCH c_res into v_resource;
  v_found := c_res%FOUND;
  CLOSE c_res;

  if not v_found then
     v_err_nr := 20;
     v_err_text := 'Maschine fehlt ';
     raise v_error;
  end if;

  bde_pd_kopf_schicht_e(in_sid,               -- in_sid         in isi_sid.sid%type,
                        in_firma_nr,          -- in_firma_nr    in isi_firma.firma_nr%type,
                        v_resource.res_id,    -- in_res_id      in isi_resource.res_id%type,
                        v_pers_nr,            -- in_pers_nr     in isi_user.pers_nr%type,
                        v_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type)
  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_sc_ms_Schicht_abmelden;

function bde_sc_login_id(in_sid           in isi_sid.sid%type,
                         in_firma_nr      in isi_firma.firma_nr%type,
                         in_scanner_name in varchar2
                        ) return integer is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_ls_login_id isi_scanner_cfg.ls_login_id%type;    -- Login ID aus dem Terminal

  CURSOR c_scanner is
    select sc.ls_login_id
      from isi_scanner_cfg sc
     where sc.sid = in_sid
       and sc.firma_nr = in_firma_nr
       and sc.scanner_name = in_scanner_name;
begin
  OPEN c_scanner;
  FETCH c_scanner into v_ls_login_id;
  CLOSE c_scanner;
  return (v_ls_login_id);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_sc_login_id;

procedure bde_c_sc_barcode_buch(in_scanner_name in varchar2,
                                in_barcode      in varchar2,
                                out_msg         out varchar2
                                ) is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Variablen
  -------------------------------------------------------------------------------------------------------

  v_scanner_daten isi_scanner_cfg%rowtype;


  v_found        boolean;
  v_msg          varchar2(80);
  v_lhm_id       varchar2(100);
  v_leitzahl     number;
  v_fa_ag        number;
  v_fa_upos      number;
  v_menge        lvs_lam.menge%type;
  v_menge_ist   lvs_lam.menge%type;              -- Menge aus Funktion (Menge der für Barcode)

  v_lam_lhm_id   lvs_lam.lhm_id%type;
  v_lhm_l_ziffer varchar2(1);

  v_fa_auftrag   bde_fa_auftrag%rowtype;
  v_artikel      isi_artikel%rowtype;
  v_res_zus_akt  isi_resource_zust_akt%rowtype;
  v_lte          lvs_lte%rowtype;

  v_res_id       isi_resource.res_id%type;
  v_ins_lte_r    varchar2(100);
  v_prn_job_nr   number;
  -------------------------------------------------------------------------------------------------------
  -- Cursor
  -------------------------------------------------------------------------------------------------------

  CURSOR c_scanner is
    select sc.*
      from isi_scanner_cfg sc
     where sc.scanner_name = in_scanner_name;

  CURSOR c_fa_auftrag is
    select t.*
      from bde_fa_auftrag t
     where t.leitzahl = v_leitzahl
       and t.fa_ag    = v_fa_ag
       and t.fa_upos  = v_fa_upos;

  CURSOR c_artikel is
    select *
      from isi_artikel a
     where a.sid = v_fa_auftrag.sid
       and a.artikel_id = v_fa_auftrag.ag_artikel_id;

  CURSOR c_lam is
    select l.lhm_id
      from lvs_lam l
     where l.lhm_id = v_lhm_id;

  CURSOR c_resource_zust_akt is
    select r_a.*
      from isi_resource res,
           isi_resource_zust_akt r_a
     where r_a.res_id = v_res_id;

  CURSOR c_lte is
    select *
      from lvs_lte t
     where t.lte_id = v_res_zus_akt.lte_id;
begin
  -- Lesen der Scannerdaten
  OPEN c_scanner;
  FETCH c_scanner into v_scanner_daten; -- Scannerdaten holen
  v_found := c_scanner%FOUND;                              -- Daten gefunden
  CLOSE c_scanner;

  v_fa_upos := 0;

  -- Scannerdaten nicht vorhanden !!!
  if not v_found then
     v_err_nr := 10;
     v_err_text := 'Scanner ' || in_scanner_name || ' fehlt in der Konfiguration';
     raise v_error;
  end if;

  -- In dieser Variante, die nur zwei Barcodes hat, steuert die letzte Ziffer den Palettenwechsel.
  -- Ist die letzte Ziffer im ID-Barcode eien 0, dann wird ein Palettenwechsel gegucht.
  if  v_scanner_daten.barcode_typ = 'SPEZ_ID'
  then
     v_menge := bde_c_scanner_buch(in_scanner_name, -- in varchar2,
                                   in_barcode,      -- in varchar2,
                                   v_msg);          -- out varchar2);

  elsif v_scanner_daten.barcode_typ = 'BDE_FA_ID'
  then
    bde_sc_barcode_fa_id_menge(in_barcode,             -- in_barcode       in varchar2,
                               v_leitzahl,             -- out_leitzahl    out bde_fa_auftrag.leitzahl,
                               v_fa_ag,                -- out_fa_ag       out bde_fa_auftrag.fa_ag,
                               v_menge,                -- out_menge       out lvs_lam.menge%type,
                               v_lhm_id);              -- out_lhm_id      out string

    OPEN c_lam;
    FETCH c_lam into v_lam_lhm_id;
    v_found := c_lam%FOUND;
    CLOSE c_lam;

    if v_found
    then
      v_err_nr := 15;
      v_err_text := 'Fehler: Gebinde ' || v_lam_lhm_id || ' bereits im Bestand';
      raise v_error;
    end if;
    OPEN c_fa_auftrag;
    FETCH c_fa_auftrag into v_fa_auftrag;
    v_found := c_fa_auftrag%FOUND;
    CLOSE c_fa_auftrag;



    if not v_found
    then
      v_msg := 'FA-Auftrag: ' || to_char(v_leitzahl) || '/' ||
                                 to_char(v_fa_ag)    || '-' ||
                                 to_char(v_fa_upos)  || ' nicht vorhanden.';
    else
      v_res_id := nvl(v_scanner_daten.res_id, v_fa_auftrag.res_id);
      OPEN c_resource_zust_akt;
      FETCH c_resource_zust_akt into v_res_zus_akt;
      CLOSE c_resource_zust_akt;
      v_artikel := NULL;
      OPEN c_artikel;
      FETCH c_artikel into v_artikel;
      CLOSE c_artikel;

      v_lhm_l_ziffer := substr(v_lhm_id, length(v_lhm_id), 1);
      if v_res_zus_akt.lte_id is NULL
      or v_lhm_l_ziffer = '0'
      then
        if v_res_zus_akt.lte_id is not NULL
        then
          OPEN c_lte;
          FETCH c_lte into v_lte;
          CLOSE c_lte;
          update lvs_lte lte
             set lte.lte_status = 'BF'
           where lte.sid = v_res_zus_akt.sid
             and lte.lte_id = v_res_zus_akt.lte_id;
          update isi_resource_zust_akt res
             set res.lte_id = NULL               -- In aktueller Maschienenzustan SPEICHERN
           where res.sid = v_res_zus_akt.sid
             and res.res_id = v_res_zus_akt.res_id
             and res.lte_id = v_res_zus_akt.lte_id;
        end if;
        if v_scanner_daten.drucker is not NULL
        and v_res_zus_akt.lte_id is not NULL
        then
          v_prn_job_nr := lvs_p_lte.lvs_lte_drucken(v_res_zus_akt.lte_id, v_fa_auftrag.kunden_nr, v_scanner_daten.drucker);
          if nvl(v_prn_job_nr, 0) <= 0
          then
            v_msg := 'Fehler beim Druck von LTE: ' || v_lte.lte_id;
          end if;
        end if;
        v_ins_lte_r := bde_pd_lte_insert(v_fa_auftrag.sid,
                                         v_res_id,
                                         0,
                                         nvl(v_fa_auftrag.lte_name, nvl(v_lte.lte_name, 'Euro')));
        if v_ins_lte_r is NULL
        then
          v_msg := 'Fehler beim anlegen eine neuen LTE';
        end if;
      end if;

      v_menge_ist := lvs_p_lte_lhm.lvs_lte_lhm_best(v_fa_auftrag.sid, v_fa_auftrag.firma_nr, v_lhm_id, 'LHM');

      if  v_menge_ist > 0
      then
        v_err_nr := 12;
        v_err_text := 'Barcode ist bereits vergeben. Buchung mit diesem Barcode nicht möglich!';
        raise v_error;
      end if;

      -- Aktuellen Produktionszustand holen
      bde_sc_pd_prod_insert(v_fa_auftrag.sid,                   -- in_sid         in isi_sid.sid%type,
                            'PP',                               -- in_vorg_typ    in bde_pd_prod.vorg_typ%type,
                             v_fa_auftrag.firma_nr,              -- in_firma_nr    in isi_firma.firma_nr%type,
                             v_lhm_id,                           -- in_barcode     in lvs_lhm.lhm_id%type,
                             v_fa_auftrag.leitzahl,              -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                             v_fa_auftrag.fa_ag,                 -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                             v_fa_auftrag.fa_upos,               -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                             v_res_id,                           -- in_res_id      in isi_resource.res_id%type,
                             0,                                  -- in_pers_nr     in isi_user.pers_nr%type,
                             nvl(v_menge,
                             nvl(v_fa_auftrag.lhm_menge,
                                 v_artikel.lhm_menge)),          -- in_menge_a     in bde_pd_prod.menge_a%type,
                             0,                                  -- in_menge_b     in bde_pd_prod.menge_b%type,
                             0,                                  -- in_schrott     in bde_pd_prod.schrott%type,
                             0,                                  -- in_ls_login_id in isi_user.login_id%type) is
                             substr(in_barcode, 1, 20));         -- in_fae_id
    end if;
  else
    v_msg := 'Barcodetyp: ' || v_scanner_daten.barcode_typ || ' nicht implementiert.';
  end if;

  out_msg := v_msg;
  commit;

exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_sc_barcode_buch;


procedure bde_sc_barcode_fa_id_menge(in_barcode       in varchar2,
                                     out_leitzahl    out bde_fa_auftrag.leitzahl%type,
                                     out_fa_ag       out bde_fa_auftrag.fa_ag%type,
                                     out_menge       out lvs_lam.menge%type,
                                     out_lhm_id      out string
                                    ) is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_pos         integer;
  v_pos2        integer;

  begin

    v_pos  := INSTR(in_barcode, '@', 1, 1);
    v_pos2 := INSTR(in_barcode, '@', 1, 2);
    if nvl(v_pos2, 0) = 0
    then
      v_pos2 := length(in_barcode) + 1;
    end if;

    out_leitzahl := to_number(substr(in_barcode, 4, v_pos - 7));
    out_fa_ag := to_number(substr(in_barcode, v_pos - 3, 3));
    out_lhm_id := substr(in_barcode, v_pos + 2, v_pos2 - v_pos - 2);
    out_menge := substr(in_barcode, v_pos2 + 2, length(in_barcode) - v_pos2 - 1);

exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_sc_barcode_fa_id_menge;

procedure bde_sc_pd_prod_insert(in_sid         in isi_sid.sid%type,
                                in_vorg_typ    in bde_pd_prod.vorg_typ%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_barcode     in lvs_lhm.lhm_id%type,
                                in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                                in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                                in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                in_res_id      in isi_resource.res_id%type,
                                in_pers_nr     in isi_user.pers_nr%type,
                                in_menge_a     in bde_pd_prod.menge_a%type,
                                in_menge_b     in bde_pd_prod.menge_b%type,
                                in_schrott     in bde_pd_prod.schrott%type,
                                in_ls_login_id in isi_user.login_id%type,
                                in_fae_id      in bde_pd_prod.fae_id%type) is
  --------------------------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------------

  v_vorg_id     bde_pd_prod.vorg_id%type;          --  Vorgangs ID aus SEQ_VOR
  v_fa_akt      bde_fa_auftrag%rowtype;            --  Lesen FA mit Leitzahl Aktuell
  v_fa_leit     bde_fa_auftrag%rowtype;            --  Lesen FA mit Leitzahl für Rohstoffe
  v_res_zus     isi_resource_zust_akt%rowtype;     --  Aktueller Zustands dieser Maschine
  v_res_fa_bis  date;                              --  Zeitpunkt der letzten Produktion bzw Beg. des AG
  v_res_pp_zeit number;                            --  Wie lange hat das gedauert
  v_lam_id      lvs_lam.lam_id%type;               --  Lager Artikel Material aus Zugang
  v_lhm_id      lvs_lhm.lhm_id%type;               --  Lager Hilfsmittel ID
  v_lte_id      lvs_lte.lte_id%type;               --  Lager Transporteinheit ID

  v_fa_upos     bde_fa_auftrag.fa_upos%type;       --  Unterposition des AG bei Gruppenarbeit
  v_fa_ag       bde_fa_auftrag.fa_ag%type;         --  Arbeitsgang für Lagerbuchung
  v_fa_leitzahl bde_fa_auftrag.leitzahl%type;      --  Leitzahl für Lagerbuchung
  v_menge_a     bde_pd_prod.menge_a%type;          --  Menge der A-Qualität
  v_found       boolean;
  v_artikel_id  bde_fa_auftrag.ag_artikel_id%type; -- Zum Holen und Übergeben der Artikel ID
  v_charge_id   bde_fa_auftrag.charge_id%type;     -- Aktuelle Charge
  v_artikel     isi_artikel%rowtype;               --  Artikelstammdaten

  v_last_lte_id lvs_lte.lte_id%type;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(2550);

  v_bew_id    s_send_bew.bew_id%type;

  -- Holen des Auftrags genau für diese Leitzahl an dieser Maschine
  CURSOR c_bde_fa_auftrag IS
  SELECT *
    FROM bde_fa_auftrag fa_a
    WHERE fa_a.sid = in_sid and
          fa_a.firma_nr = in_firma_nr and
          fa_a.leitzahl = in_leitzahl and
          fa_a.fa_ag    = in_fa_ag    and
          nvl(fa_a.fa_upos, 0)  = nvl(in_fa_upos, 0);

  -- Holen aller AG's Rohstoffe für diese Leitzahl an dieser Maschine
  CURSOR c_leit_fa_auftrag IS
  SELECT *
    FROM bde_fa_auftrag fa_leit
    WHERE fa_leit.sid = in_sid AND
          fa_leit.firma_nr = in_firma_nr and
          fa_leit.leitzahl = in_leitzahl and
          fa_leit.fa_ag    < in_fa_ag
    order by fa_leit.fa_ag desc;

  -- Holen des aktuellen Zustands dieser Maschine
  CURSOR c_bde_res_zus IS
  SELECT *
    FROM isi_resource_zust_akt zust_akt
    WHERE zust_akt.sid = in_sid AND
          zust_akt.res_id = in_res_id;

  -- Prüfen ob der Barcode ein LHM ist
  CURSOR c_lhm IS
  SELECT lhm_id, lte_id   -- Versuche lhm_tabelle mit diesem Barcode zu lesen
    FROM lvs_lhm
    WHERE lhm_id = in_barcode;

  -- Prüfen ob der Barcode ein LTE ist
  CURSOR c_lte IS
  SELECT lte_id   -- Versuche lhm_tabelle mit diesem Barcode zu lesen
    FROM lvs_lte
    WHERE lte_id = in_barcode;

  CURSOR c_lam_bh_last_lte_id is
    select l.lte_id
      from lvs_lam_bh l
     where l.leitzahl = in_leitzahl
       and l.res_id = in_res_id
       and l.bus = c.LAM_BH_BUS_ZUG
     order by l.lam_bh_id desc;

  -- Lesen des Artikelstamms
  CURSOR c_artikel IS
  SELECT *
    FROM isi_artikel a
    WHERE a.sid = in_sid and
          a.artikel_id = v_artikel_id;

begin
  -----------------------------------------------------------------------------------------------------------------
  -- Prüfen ob der Barcode ein LTE oder LHM ist
  -----------------------------------------------------------------------------------------------------------------
  v_lhm_id := NULL;            -- Barcode erst mal prüfen, ob dieser ein LHM oder LTE ist
  v_lte_id := NULL;            -- Dafür erst mal auf NULL
  v_err_nr := NULL;
  v_err_text := NULL;
  v_menge_a := in_menge_a;     -- Übergebene Menge merken !!


  OPEN c_lhm;
  FETCH c_lhm into v_lhm_id, v_lte_id;   -- Versuche lhm_tabelle mit diesem Barcode zu lesen
  v_found := c_lhm%FOUND;
  CLOSE c_lhm;

  if not v_found then
    OPEN c_lte;
    FETCH c_lte into v_lte_id;   -- Versuche lte_tabelle mit diesem Barcode zu lesen
    v_found := c_lte%FOUND;
    CLOSE c_lte;
    if v_found and
       in_vorg_typ = 'PP' then          -- Es darf kein LHM mit der Nummer eines LTE geben !!
      v_err_nr := 10;
      v_err_text := 'Barcode: ' || in_barcode || ' ist eine Transporteinheit und kann nicht als Ladehilfsmittel verwendet werden.';
      raise v_error;
    end if;
    if not v_found then
      v_lhm_id := in_barcode;         -- Wenn nicht vorhanden dann den uebergebenen Barcode verwenden
      if in_vorg_typ = 'PM' then      -- Barcode muss ein LHM oder LTE sein !!!
        v_err_nr := 15;
        v_err_text := 'Barcode: ' || in_barcode || ' ist keiner Transporteinheit und keinem Ladehilfsmittel zugeordnet.';
        raise v_error;
      end if;
    end if;
  end if;


  -- Erst mal kein Fehler
  v_err_nr := NULL;
  v_err_text := NULL;

  --------------------------------------------------------------------------------------------------------------------
  -- Holen der Auftragsdaten fuer ABNR und Artikel ID
  --------------------------------------------------------------------------------------------------------------------
  OPEN c_bde_fa_auftrag;
  FETCH c_bde_fa_auftrag INTO v_fa_akt;
  v_found := c_bde_fa_auftrag%FOUND;
  CLOSE c_bde_fa_auftrag;

  -- Wenn nicht gefunden dann setze Fehlertext !!
  if not v_found then
      v_err_nr := 20;
      v_err_text := 'FA Auftrag für NR: ' || in_leitzahl || '/' || in_fa_ag || '/' || in_fa_upos || ' falsch';
      raise v_error;
  end if;

  ---------------------------------------------------------------------------------------------------------------------
  -- Zeitpunkt ende dieser Produktion merken
  ---------------------------------------------------------------------------------------------------------------------
  OPEN c_bde_res_zus;
  FETCH c_bde_res_zus INTO v_res_zus;
  -- Wenn nicht gefunden dann setze Fehlertext !!
  v_found := c_bde_res_zus%FOUND;
  CLOSE c_bde_res_zus;

  if not v_found then
      v_err_nr := 30;
      v_err_text := 'Zustand der Maschine ID: ' || in_res_id || ' nicht vorhanden';
      raise v_error;
  else
    begin
      if v_res_zus.leitzahl = in_leitzahl and
         v_res_zus.fa_ag = in_fa_ag and
         nvl(v_res_zus.fa_upos, 0) = nvl(in_fa_upos, 0) then
         bde_pd_prod_insert(in_sid,                                -- in_sid         in isi_sid.sid%type,
                            in_vorg_typ,                           -- in_vorg_typ    in bde_pd_prod.vorg_typ%type,
                            in_firma_nr,                        -- in_firma_nr    in isi_firma.firma_nr%type,
                            in_barcode,                         -- in_barcode     in lvs_lhm.lhm_id%type,
                            in_leitzahl,                        -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                            in_fa_ag,                           -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                            in_fa_upos,                         -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                            in_res_id,                          -- in_res_id      in isi_resource.res_id%type,
                            in_pers_nr,                         -- in_pers_nr     in isi_user.pers_nr%type,
                            in_menge_a,                         -- in_menge_a     in bde_pd_prod.menge_a%type,
                            in_menge_b,                         -- in_menge_b     in bde_pd_prod.menge_b%type,
                            in_schrott,                         -- in_schrott     in bde_pd_prod.schrott%type,
                            in_ls_login_id,                     -- in_ls_login_id in isi_user.login_id%type) is
                            NULL,                               -- in_fae_id          in bde_pd_prod.fae_id%type,
                            NULL,                               -- in_fae_id_position in bde_pd_prod.fae_id_position%type)
                            NULL);                              -- in_lam_id          in lvs_lam.lam_id%type

        return;
      end if;
    exception
      when others then
        v_err_nr := 35;
        v_err_text := 'Barcode nicht zu Buchen: ' || in_barcode || ' Problem beim Buchen über den Fertigungsschritt.';
    end;
  end if;
  if v_fa_akt.kenz_letzt_ag = 1 then
     v_fa_leitzahl := v_fa_akt.leitzahl;
     v_fa_ag       := NULL;  -- Fertigwahre ohne AG im Lagerbestand
     v_fa_upos     := NULL;
  else
     v_fa_leitzahl := v_fa_akt.leitzahl;
     v_fa_ag       := v_fa_akt.fa_ag;  -- Zwischenprodukt mit AG und Leitzahl
     v_fa_upos     := v_fa_akt.fa_upos;
  end if;

  v_charge_id := v_fa_akt.charge_id;   -- Aktuelle Caharge nerken

  -- Folgende Typen sind immer die führenden Einträge in der Tabelle
  if in_vorg_typ = 'PP'    -- Produktion
  then
    select seq_vorg_id.nextval into v_vorg_id from dual;
  else
    v_err_nr := 40;
    v_err_text := 'Barcode nicht zu Buchen: ' || in_barcode || ' Nach abmeldung des FA an der Maschine ist nur nocht die Produktionsfertigmeldung möglich (PP).';
    raise v_error;
  end if;

  v_res_pp_zeit := 0;

  if in_vorg_typ = 'PP' then -- Produktion
    v_artikel_id := v_fa_akt.ag_artikel_id;        -- Artikel ID übergeben
    v_bew_id := s_schnittstelle.write_host_prod_bew(v_fa_akt.sid, v_fa_akt.firma_nr,
                                                    v_fa_akt, NULL, NULL,
                                                    c.lam_bh_bus_zug, c.lam_bh_zugagng,
                                                    'S_FA', NULL);
    if v_menge_a is NULL
    then
      if v_fa_akt.lhm_menge > 0 then
        v_menge_a := v_fa_akt.lhm_menge;
      else
        v_menge_a := NULL;
      end if;
    end if;


    v_last_lte_id := NULL;
    if v_fa_leitzahl = v_res_zus.leitzahl
    or v_res_zus.lte_id is NULL
    then
      OPEN c_lam_bh_last_lte_id;
      FETCH c_lam_bh_last_lte_id into v_last_lte_id;
      CLOSE c_lam_bh_last_lte_id;
    end if;

    v_artikel := NULL;
    OPEN c_artikel;
    FETCH c_artikel into v_artikel;
    CLOSE c_artikel;
    v_lam_id := lvs_einl.lvs_lam_zugang(in_sid, in_firma_nr, v_artikel_id, nvl(v_last_lte_id, v_res_zus.lte_id),
                               v_lhm_id, v_charge_id, NULL, v_fa_leitzahl, v_fa_ag, v_fa_upos,
                               v_fa_akt.abnr, NULL, NULL, in_res_id, nvl(v_res_fa_bis, sysdate), nvl(v_res_fa_bis, sysdate),
                               in_ls_login_id, v_menge_a, v_fa_leit.lhm_name, v_fa_akt.kunden_nr,
                               v_fa_akt.kd_art_nr, null, v_fa_akt.zeichnung, v_fa_akt.zeichnung_index,
                               v_bew_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                               NULL,     --   v_artikel.artikel_p1,
                               NULL,     --   v_artikel.artikel_p2,
                               NULL,     --   v_artikel.artikel_p3,
                               NULL,     --   v_artikel.artikel_p4,
                               NULL,     --   v_artikel.artikel_p5,
                               NULL,     --   v_artikel.artikel_p6,
                               NULL,     --   v_artikel.artikel_p7,
                               NULL,     --   v_artikel.artikel_p8,
                               NULL,     --   v_artikel.artikel_p9,
                               NULL,     --   v_artikel.artikel_p10
                               'SD',     --   in_lhm_eti_druck_status in lvs_lhm.lhm_eti_druck_status%type,
                               NULL,     --   in_lam_text             in lvs_lam.lam_text%type,
                               NULL,     --   in_labor_text           in lvs_lam.labor_text%type)
                               in_fae_id,
                               NULL,
                               NULL,
                               '1',      -- menge_a = 1. Wahl -> QS-Status = 1
                               v_fa_akt.lhm_anz_ist + 1); -- lam.lhm_lfd_nr aus FA-Auftrag

    bde_pd_prod_p_pa_u(in_sid, in_firma_nr, in_leitzahl, in_fa_ag, in_fa_upos, in_res_id, v_menge_a,
                               v_res_fa_bis, v_res_pp_zeit, v_res_zus.abfuell_ist);
  end if;

  -----------------------------------------------------------------
  -- Hier wird die Buchung in die Produktionstabelle eingetragen --
  -----------------------------------------------------------------
  v_err_nr := 70;
  v_err_text := 'Fehler beim Eintragen der Produktionsmeldung FA Auftrag: ' || in_leitzahl || '/' || in_fa_ag || '/' || in_fa_upos;
  insert into bde_pd_prod
    values(in_sid,
           v_vorg_id,
           in_vorg_typ,
           in_firma_nr,
           in_leitzahl,
           in_fa_ag,
           in_fa_upos,
           v_fa_akt.abnr,
           in_res_id,
           sysdate,
           sysdate,
           in_pers_nr,
           v_lam_id,
           v_artikel_id,
           v_menge_a,
           in_menge_b,
           in_schrott,
           in_ls_login_id,
           v_res_pp_zeit,
           v_res_zus.abfuell_abschalt_grob,
           v_res_zus.abfuell_abschalt_mittel,
           v_res_zus.abfuell_abschalt_fein,
           v_res_zus.abfuell_toleranz_plus,
           v_res_zus.abfuell_toleranz_minus,
           v_res_zus.abfuell_silo,
           v_res_zus.abfuell_soll,
           v_res_zus.abfuell_ist,
           v_res_zus.prod_params,
           in_fae_id,
           NULL,
           NULL,
           NULL);
  v_err_nr := NULL;
  v_err_text := NULL;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    if c_leit_fa_auftrag%ISOPEN then
      CLOSE c_leit_fa_auftrag;
    end if;
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    if c_leit_fa_auftrag%ISOPEN then
      CLOSE c_leit_fa_auftrag;
    end if;
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_sc_pd_prod_insert;

function bde_c_sc_prod_rest_mg(in_scanner_name in varchar2,
                                in_barcode1     in varchar2,
                                in_barcode2     in varchar2,
                                out_msg         out varchar2
                                ) return number is
  -------------------------------------------------------------------------------------------------------
  -- Funktion Bucht den Barcode fuer einen Scanner
  -------------------------------------------------------------------------------------------------------

  v_menge       lvs_lam.menge%type;              -- Menge aus Funktion (Menge der für Barcode)

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Variablen
  -------------------------------------------------------------------------------------------------------

  v_artikel                     isi_artikel%rowtype;
  v_charge                      lvs_charge.charge_bez%type;
  v_menge_str                   varchar2(20);
  v_ean                         varchar2(20);
  v_lfd_nr_str                  varchar2(20);
  v_linie_str                   varchar2(20);

  v_prod_datum_str              varchar2(30);
  v_prod_datum_struktur         varchar2(30);

  v_firma       isi_firma%rowtype;
  v_firma_cfg   isi_firma_cfg%rowtype;

  v_ls_login_id isi_scanner_cfg.ls_login_id%type;
  v_res_id      isi_scanner_cfg.res_id%type;
  v_aufgabe     isi_scanner_cfg.akt_aufgabe%type;
  v_sid         isi_resource.sid%type;
  v_firma_nr    isi_resource.firma_nr%type;
  v_leitzahl    bde_fa_auftrag.leitzahl%type;
  v_fa_ag       bde_fa_auftrag.fa_ag%type;
  v_fa_upos     bde_fa_auftrag.fa_upos%type;
  v_spez_bc     varchar2(100);
  v_barcode1    varchar2(100);
  v_barcode2    varchar2(100);

  v_found       boolean;
  v_msg         varchar2(80);

  -------------------------------------------------------------------------------------------------------
  -- Cursor
  -------------------------------------------------------------------------------------------------------

  CURSOR c_scanner is
    select sc.ls_login_id,
           sc.res_id,
           sc.akt_aufgabe,
           sc.scanner_daten,
           sc.sid,
           sc.firma_nr
      from isi_scanner_cfg sc
     where sc.scanner_name = in_scanner_name;

  CURSOR c_res is
    select isi_resource.sid,
           isi_resource.firma_nr
      from isi_resource
     where isi_resource.res_id = v_res_id;

  CURSOR c_firma is
    select *
      from isi_firma f
     where f.sid = v_sid
       and f.firma_nr = v_firma_nr;

  CURSOR c_firma_cfg is
    select *
      from isi_firma_cfg f
     where f.sid = v_sid
       and f.firma_nr = v_firma_nr
       and f.kategorie = 'CFG'
       and f.parameter_name = v_spez_bc;

begin
  -- Lesen der Scannerdaten
  OPEN c_scanner;
  FETCH c_scanner into v_ls_login_id, v_res_id, v_aufgabe, v_barcode1, v_sid, v_firma_nr; -- Scannerdaten holen
  v_found := c_scanner%FOUND;                              -- Daten gefunden
  CLOSE c_scanner;
  v_barcode1 := in_barcode1;

  -- Scannerdaten nicht vorhanden !!!
  if not v_found then
     v_err_nr := 10;
     v_err_text := 'Scanner ' || in_scanner_name || ' fehlt in der Konfiguration';
     raise v_error;
  end if;

  if v_ls_login_id is null then
     v_err_nr := 20;
     v_err_text := 'Scanner ist zu keiner Person zugewiesen';
     raise v_error;
  end if;

  if v_res_id is null then
     v_err_nr := 30;
     v_err_text := 'Scanner mit keine Maschien verbunden';
     raise v_error;
  end if;

  -- Lesen der Maschinenstammdaten
  OPEN c_res;
  FETCH c_res into v_sid, v_firma_nr;                  -- Maschiendaten holen
  v_found := c_res%FOUND;                              -- Daten gefunden
  CLOSE c_res;

  if not v_found then
     v_err_nr := 40;
     v_err_text := 'Maschiennendaten für res_id ' || v_res_id || ' fehlen !!!';
     raise v_error;
  end if;

  OPEN c_firma;
  FETCH c_firma into v_firma;
  CLOSE c_firma;

  v_spez_bc := 'SPEZ_BARCODE_' || v_aufgabe;

  v_firma_cfg := NULL;
  OPEN c_firma_cfg;
  FETCH c_firma_cfg into v_firma_cfg;
  CLOSE c_firma_cfg;

  v_barcode2 := in_barcode2;
  -- Es gibt Barcodes mit Endekenneung und ohne Endekenneung
  -- Hierdurch kann eine Differenz von einem Zeichen im Barcode sein
  if length(v_barcode2) = length(v_firma_cfg.parameter_wert) -1
  and substr(v_firma_cfg.parameter_wert, length(v_firma_cfg.parameter_wert), 1) = 'E'
  then
    v_barcode2 := v_barcode2 || '0';
  else
    v_barcode2 := in_barcode2;
  end if;

  if length( v_barcode2) = length(v_firma_cfg.parameter_wert)
  then
    lvs_p_lte_lhm.split_spez_barcode(in_barcode2,                      -- in_barcode              in  lvs_lam.lhm_id%type,
                                     v_firma_cfg.parameter_wert,       -- in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                                     v_artikel.artikel,                -- out_artikel             out varchar2,
                                     v_charge,                         -- out_charge              out varchar2,
                                     v_prod_datum_str,                 -- out_prod_datum_str      out varchar2,
                                     v_prod_datum_struktur,            -- out_prod_datum_struktur out varchar2,
                                     v_menge_str,                      -- out_menge_str           out varchar2,
                                     v_ean,                            -- out_ean                 out varchar2)
                                     v_lfd_nr_str,            -- out varchar2
                                     v_linie_str);            -- out varchar2
  else
    if v_firma.lhm_barcode_type = c.LTE_BARCODE_VDA
    and substr(v_barcode2, 1, 1) = 'Q'
    then
      v_menge_str := substr(in_barcode2, 2, length(in_barcode2) - 1) ;
    elsif v_firma.lhm_barcode_type = c.LTE_BARCODE_CCG
    or v_firma.lhm_barcode_type = c.LTE_BARCODE_NVE
    then
      v_menge_str := substr(in_barcode2, 3, length(in_barcode2) - 2) ;
    end if;
  end if;

  v_menge := to_number(v_menge_str);
  if  length(v_barcode1) != nvl(v_firma.lhm_barcode_laenge, length(v_barcode1))
  and length(v_barcode1) != nvl(v_firma.lte_barcode_laenge, length(v_barcode1))
  then
     v_err_nr := 45;
     v_err_text := 'Barcodelänge falsch! Gelesene Länge:' || to_char(length(v_barcode1)) || ' Soll: ' ||
     to_char(nvl(v_firma.lhm_barcode_laenge, length(v_barcode1))) || ' oder ' ||
     to_char(nvl(v_firma.lte_barcode_laenge, length(v_barcode1)));
     raise v_error;
  end if;

  v_menge := bde_c_barcode_buch (v_sid, v_firma_nr, v_barcode1, v_res_id, v_ls_login_id, v_menge, NULL, NULL, v_aufgabe,
                                 v_barcode1,        -- in_fa_id
                                 NULL,              -- in_fa_id_position
                                 v_leitzahl, v_fa_ag, v_fa_upos);

  v_msg := v_aufgabe || ' ' || to_char(v_menge) || ' OK';
  out_msg := v_msg;
  commit;
  return (v_menge);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_sc_prod_rest_mg;

function bde_c_sc_fa_prod_rest_mg(in_scanner_name in varchar2,
                                  in_barcode1     in varchar2,
                                  in_barcode2     in varchar2,
                                  in_barcode3     in varchar2,
                                  out_msg         out varchar2
                                  ) return number is
  -------------------------------------------------------------------------------------------------------
  -- Funktion Bucht den Barcode fuer einen Scanner
  -------------------------------------------------------------------------------------------------------

  v_menge       lvs_lam.menge%type;              -- Menge aus Funktion (Menge der für Barcode)

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Variablen
  -------------------------------------------------------------------------------------------------------

  v_artikel                     isi_artikel%rowtype;
  v_charge                      lvs_charge.charge_bez%type;
  v_menge_str                   varchar2(20);
  v_menge_ist                   lvs_lam.menge%type;              -- Menge aus Funktion (Menge der für Barcode)
  v_ean                         varchar2(20);


  v_prod_datum_str              varchar2(30);
  v_prod_datum_struktur         varchar2(30);

  v_firma       isi_firma%rowtype;
  v_firma_cfg   isi_firma_cfg%rowtype;

  v_ls_login_id isi_scanner_cfg.ls_login_id%type;
  v_res_id      isi_scanner_cfg.res_id%type;
  v_aufgabe     isi_scanner_cfg.akt_aufgabe%type;
  v_sid         isi_resource.sid%type;
  v_firma_nr    isi_resource.firma_nr%type;
  v_leitzahl    bde_fa_auftrag.leitzahl%type;
  v_fa_ag       bde_fa_auftrag.fa_ag%type;
  v_fa_upos     bde_fa_auftrag.fa_upos%type;
  v_spez_bc     varchar2(100);
  v_barcode1    varchar2(100);
  v_barcode2    varchar2(100);
  v_barcode3    varchar2(100);

  v_lfd_nr_str                  varchar2(20);
  v_linie_str                   varchar2(20);
  v_found       boolean;
  v_msg         varchar2(80);

  -------------------------------------------------------------------------------------------------------
  -- Cursor
  -------------------------------------------------------------------------------------------------------

  CURSOR c_scanner is
    select sc.ls_login_id,
           sc.res_id,
           sc.akt_aufgabe,
           sc.scanner_daten,
           sc.sid,
           sc.firma_nr
      from isi_scanner_cfg sc
     where sc.scanner_name = in_scanner_name;

  CURSOR c_res is
    select isi_resource.sid,
           isi_resource.firma_nr
      from isi_resource
     where isi_resource.res_id = v_res_id;

  CURSOR c_firma is
    select *
      from isi_firma f
     where f.sid = v_sid
       and f.firma_nr = v_firma_nr;

  CURSOR c_firma_cfg is
    select *
      from isi_firma_cfg f
     where f.sid = v_sid
       and f.firma_nr = v_firma_nr
       and f.kategorie = 'CFG'
       and f.parameter_name = v_spez_bc;

  CURSOR c_res_zus_akt is
    select isi_resource_zust_akt.leitzahl
      from isi_resource_zust_akt
     where isi_resource_zust_akt.res_id = v_res_id;

  CURSOR c_bde_pd_prod_last is
    select p.fa_ag, p.fa_upos
      from bde_pd_prod p
     where p.leitzahl = v_barcode3
       and p.res_id = v_res_id
       and p.vorg_typ = 'PP'
     order by p.prod_beginn desc;

begin
  v_barcode3 := in_barcode3;
  -- Lesen der Scannerdaten
  OPEN c_scanner;
  FETCH c_scanner into v_ls_login_id, v_res_id, v_aufgabe, v_barcode1, v_sid, v_firma_nr; -- Scannerdaten holen
  v_found := c_scanner%FOUND;                              -- Daten gefunden
  CLOSE c_scanner;
  v_barcode1 := in_barcode1;

  -- Scannerdaten nicht vorhanden !!!
  if not v_found then
     v_err_nr := 10;
     v_err_text := 'Scanner ' || in_scanner_name || ' fehlt in der Konfiguration';
     raise v_error;
  end if;

  if v_ls_login_id is null then
     v_err_nr := 20;
     v_err_text := 'Scanner ist zu keiner Person zugewiesen';
     raise v_error;
  end if;

  if v_res_id is null then
     v_err_nr := 30;
     v_err_text := 'Scanner mit keine Maschien verbunden';
     raise v_error;
  end if;

  -- Lesen der Maschinenstammdaten
  OPEN c_res;
  FETCH c_res into v_sid, v_firma_nr;                  -- Maschiendaten holen
  v_found := c_res%FOUND;                              -- Daten gefunden
  CLOSE c_res;

  if not v_found then
     v_err_nr := 40;
     v_err_text := 'Maschiennendaten für res_id ' || v_res_id || ' fehlen !!!';
     raise v_error;
  end if;

  OPEN c_firma;
  FETCH c_firma into v_firma;
  CLOSE c_firma;

  v_spez_bc := 'SPEZ_BARCODE_' || v_aufgabe;

  v_firma_cfg := NULL;
  OPEN c_firma_cfg;
  FETCH c_firma_cfg into v_firma_cfg;
  CLOSE c_firma_cfg;

  v_barcode2 := in_barcode2;
  -- Es gibt Barcodes mit Endekenneung und ohne Endekenneung
  -- Hierdurch kann eine Differenz von einem Zeichen im Barcode sein
  if length(v_barcode2) = length(v_firma_cfg.parameter_wert) -1
  and substr(v_firma_cfg.parameter_wert, length(v_firma_cfg.parameter_wert), 1) = 'E'
  then
    v_barcode2 := v_barcode2 || '0';
  else
    v_barcode2 := in_barcode2;
  end if;

  if length( v_barcode2) = length(v_firma_cfg.parameter_wert)
  then
    lvs_p_lte_lhm.split_spez_barcode(in_barcode2,                      -- in_barcode              in  lvs_lam.lhm_id%type,
                                     v_firma_cfg.parameter_wert,       -- in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                                     v_artikel.artikel,                -- out_artikel             out varchar2,
                                     v_charge,                         -- out_charge              out varchar2,
                                     v_prod_datum_str,                 -- out_prod_datum_str      out varchar2,
                                     v_prod_datum_struktur,            -- out_prod_datum_struktur out varchar2,
                                     v_menge_str,                      -- out_menge_str           out varchar2,
                                     v_ean,                            -- out_ean                 out varchar2)
                                     v_lfd_nr_str,            -- out varchar2
                                     v_linie_str);            -- out varchar2
  else
    if v_firma.lhm_barcode_type = c.LTE_BARCODE_VDA
    then
      if substr(v_barcode2, 1, 1) = 'Q'
      then
        v_menge_str := substr(in_barcode2, 2, length(in_barcode2) - 1) ;
      else
         v_err_nr := 45;
         v_err_text := 'Barcodefehler oder Reihenfolge falsch';
         raise v_error;
      end if;
    elsif (v_firma.lhm_barcode_type = c.LTE_BARCODE_CCG
     or v_firma.lhm_barcode_type = c.LTE_BARCODE_NVE)
    and substr(v_barcode2, 1, 2) = '37'
    then
      v_menge_str := substr(in_barcode2, 3, length(in_barcode2) - 2) ;
    else
      begin
        v_menge_str := to_char(to_number(in_barcode2)); -- Prüfung auf Nummer
      exception
        when others then
         v_err_nr := 46;
         v_err_text := 'Barcodefehler oder Reihenfolge falsch';
         raise v_error;
      end;
    end if;
  end if;

  v_menge := to_number(v_menge_str);
  if  length(v_barcode1) != nvl(v_firma.lhm_barcode_laenge, length(v_barcode1))
  and length(v_barcode1) != nvl(v_firma.lte_barcode_laenge, length(v_barcode1))
  then
     v_err_nr := 45;
     v_err_text := 'Barcodelänge falsch! Gelesene Länge:' || to_char(length(v_barcode1)) || ' Soll: ' ||
     to_char(nvl(v_firma.lhm_barcode_laenge, length(v_barcode1))) || ' oder ' ||
     to_char(nvl(v_firma.lte_barcode_laenge, length(v_barcode1)));
     raise v_error;
  end if;

  OPEN c_res_zus_akt;
  FETCH c_res_zus_akt into v_leitzahl;
  CLOSE c_res_zus_akt;

  if in_barcode3 not like ('%' || v_leitzahl || '%')
  then
    v_fa_ag := NULL;
    v_fa_upos := NULL;
    v_menge_ist := lvs_p_lte_lhm.lvs_lte_lhm_best(v_sid, v_firma_nr, in_barcode1, 'LHM');
    if  v_menge_ist > 0
    then
      v_err_nr := 12;
      v_err_text := 'Barcode ist bereits vergeben. Buchung mit diesem Barcode nicht möglich!';
      raise v_error;
    end if;

    if in_barcode3 like '20S%'
    then
      v_barcode3 := substr(in_barcode3, 4, length(in_barcode3) - 6);
    end if;

    OPEN c_bde_pd_prod_last;
    FETCH c_bde_pd_prod_last into v_fa_ag, v_fa_upos;
    CLOSE c_bde_pd_prod_last;

    bde_sc_pd_prod_insert(v_sid,                               -- in_sid         in isi_sid.sid%type,
                          'PP',                                -- in_vorg_typ    in bde_pd_prod.vorg_typ%type,
                           v_firma_nr,                         -- in_firma_nr    in isi_firma.firma_nr%type,
                           v_barcode1,                         -- in_barcode     in lvs_lhm.lhm_id%type,
                           v_barcode3,                         -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                           v_fa_ag,                            -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                           v_fa_upos,                          -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                           v_res_id,                           -- in_res_id      in isi_resource.res_id%type,
                           0,                                  -- in_pers_nr     in isi_user.pers_nr%type,
                           v_menge,                            -- in_menge_a     in bde_pd_prod.menge_a%type,
                           0,                                  -- in_menge_b     in bde_pd_prod.menge_b%type,
                           0,                                  -- in_schrott     in bde_pd_prod.schrott%type,
                           0,                                  -- in_ls_login_id in isi_user.login_id%type) is
                           v_barcode1);
  else
    v_menge := bde_c_barcode_buch (v_sid, v_firma_nr, v_barcode1, v_res_id, v_ls_login_id, v_menge, NULL, NULL, v_aufgabe,
                                   v_barcode1,        -- in_fa_id
                                   NULL,              -- in_fa_id_position
                                   v_leitzahl, v_fa_ag, v_fa_upos);
  end if;

  v_msg := v_aufgabe || ' ' || to_char(v_menge) || ' OK';
  out_msg := v_msg;
  commit;
  return (v_menge);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_sc_fa_prod_rest_mg;

function bde_c_sc_fa_prod(in_scanner_name in varchar2,
                          in_barcode1     in varchar2,
                          in_barcode2     in varchar2,
                          out_msg         out varchar2
                         ) return number is
  -------------------------------------------------------------------------------------------------------
  -- Funktion Bucht den Barcode fuer einen Scanner
  -------------------------------------------------------------------------------------------------------

  v_menge       lvs_lam.menge%type;              -- Menge aus Funktion (Menge der für Barcode)

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Variablen
  -------------------------------------------------------------------------------------------------------

  v_ls_login_id isi_scanner_cfg.ls_login_id%type;
  v_res_id      isi_scanner_cfg.res_id%type;
  v_aufgabe     isi_scanner_cfg.akt_aufgabe%type;
  v_sid         isi_resource.sid%type;
  v_firma_nr    isi_resource.firma_nr%type;
  v_leitzahl    bde_fa_auftrag.leitzahl%type;
  v_fa_ag       bde_fa_auftrag.fa_ag%type;
  v_fa_upos     bde_fa_auftrag.fa_upos%type;
  v_barcode1    varchar2(100);
  v_firma       isi_firma%rowtype;

  v_found       boolean;
  v_msg         varchar2(80);

  -------------------------------------------------------------------------------------------------------
  -- Cursor
  -------------------------------------------------------------------------------------------------------

  CURSOR c_scanner is
    select sc.ls_login_id,
           sc.res_id,
           sc.akt_aufgabe,
           sc.scanner_daten,
           sc.sid,
           sc.firma_nr
      from isi_scanner_cfg sc
     where sc.scanner_name = in_scanner_name;

  CURSOR c_res is
    select isi_resource.sid,
           isi_resource.firma_nr
      from isi_resource
     where isi_resource.res_id = v_res_id;

  CURSOR c_res_zus_akt is
    select isi_resource_zust_akt.leitzahl
      from isi_resource_zust_akt
     where isi_resource_zust_akt.res_id = v_res_id;

  CURSOR c_firma is
    select *
      from isi_firma f
     where f.sid = v_sid
       and f.firma_nr = v_firma_nr;

begin
  -- Lesen der Scannerdaten
  OPEN c_scanner;
  FETCH c_scanner into v_ls_login_id, v_res_id, v_aufgabe, v_barcode1, v_sid, v_firma_nr; -- Scannerdaten holen
  v_found := c_scanner%FOUND;                              -- Daten gefunden
  CLOSE c_scanner;
  v_barcode1 := in_barcode1;

  -- Scannerdaten nicht vorhanden !!!
  if not v_found then
     v_err_nr := 10;
     v_err_text := 'Scanner ' || in_scanner_name || ' fehlt in der Konfiguration';
     raise v_error;
  end if;

  if v_ls_login_id is null then
     v_err_nr := 20;
     v_err_text := 'Scanner ist zu keiner Person zugewiesen';
     raise v_error;
  end if;

  if v_res_id is null then
     v_err_nr := 30;
     v_err_text := 'Scanner mit keine Maschien verbunden';
     raise v_error;
  end if;

  OPEN c_firma;
  FETCH c_firma into v_firma;
  CLOSE c_firma;

  -- Lesen der Maschinenstammdaten
  OPEN c_res;
  FETCH c_res into v_sid, v_firma_nr;                  -- Maschiendaten holen
  v_found := c_res%FOUND;                              -- Daten gefunden
  CLOSE c_res;

  if not v_found then
     v_err_nr := 40;
     v_err_text := 'Maschiennendaten für res_id ' || v_res_id || ' fehlen !!!';
     raise v_error;
  end if;

  v_menge := NULL;

  if  length(v_barcode1) != nvl(v_firma.lhm_barcode_laenge, length(v_barcode1))
  and length(v_barcode1) != nvl(v_firma.lte_barcode_laenge, length(v_barcode1))
  then
     v_err_nr := 45;
     v_err_text := 'Barcodelänge falsch! Gelesene Länge:' || to_char(length(v_barcode1)) || ' Soll: ' ||
     to_char(nvl(v_firma.lhm_barcode_laenge, length(v_barcode1))) || ' oder ' ||
     to_char(nvl(v_firma.lte_barcode_laenge, length(v_barcode1)));
     raise v_error;
  end if;

  OPEN c_res_zus_akt;
  FETCH c_res_zus_akt into v_leitzahl;
  CLOSE c_res_zus_akt;

  if in_barcode2 not like ('%' || v_leitzahl || '%')
  then
     v_err_nr := 50;
     v_err_text := 'Falscher Auftrag! Angemeldet ist ' || v_leitzahl;
     raise v_error;
  end if;

  v_menge := bde_c_barcode_buch (v_sid, v_firma_nr, v_barcode1, v_res_id, v_ls_login_id, v_menge, NULL, NULL, v_aufgabe,
                                 v_barcode1,        -- in_fa_id
                                 NULL,              -- in_fa_id_position
                                 v_leitzahl, v_fa_ag, v_fa_upos);

  v_msg := v_aufgabe || ' ' || to_char(v_menge) || ' OK';
  out_msg := v_msg;
  commit;
  return (v_menge);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
   when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_c_sc_fa_prod;



function bde_c_isi_scan_log_chk (in_scanner_name    in varchar2,
                                 in_barcode        in varchar2,
                                 out_msg          out varchar2
                                 ) return varchar2 is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- variablen
  -------------------------------------------------------------------------------------------------------
  v_isi_scanner_cfg isi_scanner_cfg%rowtype;
  v_res_zus         isi_resource_zust_akt%rowtype;
  v_lhm_id          isi_scan_log.lhm_id%type;

  v_found           boolean;

  -------------------------------------------------------------------------------------------------------
  -- cursor
  -------------------------------------------------------------------------------------------------------

  cursor c_scanner is
    select *
      from isi_scanner_cfg sc
     where sc.scanner_name = in_scanner_name;

   cursor c_bde_res_zus is
      select *
        from isi_resource_zust_akt zust_akt
        where zust_akt.sid = v_isi_scanner_cfg.sid and
              zust_akt.res_id =  v_isi_scanner_cfg.res_id;

  -- ISI_SCAN_LOG nach aktueller lhm_id durchsuchen:
  CURSOR c_scan_log is
    select lhm_id
      from isi_scan_log sl
      where sl.lhm_id = in_barcode
      and   sl.scan_ok = 'J';


begin
  -- lesen der scannerdaten
  open c_scanner;
  fetch c_scanner into v_isi_scanner_cfg; -- scannerdaten holen
  close c_scanner;

  -- lesen des aktuellen zustands der maschine
  open c_bde_res_zus;
  fetch c_bde_res_zus into v_res_zus;
  close c_bde_res_zus;

  --  (-AM-) 080528
  --  Dieser Zweig ist nur für den Seaquist-Testbetrieb für LK-Scanner relevant:
  --  VON HIER ...
  if v_isi_scanner_cfg.akt_aufgabe = 'LK'
  then
    -- Holen des aktuellen Zustands der Maschine
    OPEN c_bde_res_zus;
    FETCH c_bde_res_zus INTO v_res_zus;
    v_found := c_bde_res_zus%FOUND;
    CLOSE c_bde_res_zus;

    -- Wenn nicht gefunden, dann setze Fehlertext !!
    if not v_found then
      v_err_nr := 10;
      v_err_text := 'Zustand der Maschine ID: ' || v_isi_scanner_cfg.res_id || ' nicht vorhanden.';
      raise v_error;
    end if;

     -- Prüfen, ob Auftrag angemeldet ist: isi_resource_zust_akt -> Leitzahl

    if v_res_zus.leitzahl is NULL then
      v_err_nr := 11;
      v_err_text := 'Auf dieser Maschine ist kein Auftrag angemeldet. Buchungen nicht möglich.';
      raise v_error;
    end if;

    -- Prüfen ob Karton schon in Tabelle

    OPEN c_scan_log;
    FETCH c_scan_log INTO v_lhm_id;
    v_found := c_scan_log%FOUND; -- doppelten Karton gefunden
    CLOSE c_scan_log;

    if v_found then
      v_err_nr := 112;
      v_err_text := 'Kartonnummer wird schon verwendet: ' || in_barcode;
      raise v_error;
    end if;
    out_msg := 'OK';
  end if;

  return (c.C_TRUE);
--  ... BIS HIER
exception
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;
--------------------------------------------------------------------------------
-- (-AM-) 080529
-- Neuer Eintrag in Tabelle ISI_SCAN_LOG
-- ISI_SCAN_LOG wird ausschließlich für die IBS der Leerkarton-Scanner bei Seaquist
-- benötigt, da in dieser Phase durch die Scannung noch keine Buchungen ausgelöst werden.
--------------------------------------------------------------------------------
procedure bde_c_isi_scan_log(in_scanner_name  in isi_scan_log.scanner_name%type,
                             in_scanner_read  in isi_scan_log.scanner_read%type,
                             in_scanner_cmd   in isi_scan_log.scanner_cmd%type,
                             in_error_txt     in isi_scan_log.error_txt%type,
                             in_scan_ok       in isi_scan_log.scan_ok%type) is
v_lhm_id    lvs_lhm.lhm_id%type;
begin

  begin
    if in_scan_ok = 'J' AND substr(in_scanner_read, 1,1) = 'S' then
      v_lhm_id := substr(in_scanner_read, 2, 15);  -- führendes s ausblenden
    end if;
    bde_isi_scan_log_id(in_scanner_name, -- isi_scan_log.scanner_name%type,
                        in_scanner_read, -- isi_scan_log.scanner_read%type,
                        NULL,            -- isi_scan_log.lte_id%type,
                        v_lhm_id,        -- isi_scan_log.lhm_id%type,
                        in_scanner_cmd,  -- isi_scan_log.scanner_cmd%type,
                        in_error_txt,    -- isi_scan_log.error_txt%type,
                        in_scan_ok);     -- isi_scan_log.scan_ok%type) is
    commit;

  exception
    when others then  -- alle exceptions unterdrücken
     null;
  end;  -- exception
end;
----------------------------------------------------------------------------------
-- -AG- Schreiben des ScannLogs
-- Schreibe Log für Scannung
-- Ohne Commit
----------------------------------------------------------------------------------
procedure bde_isi_scan_log_id(in_scanner_name  in isi_scan_log.scanner_name%type,
                              in_scanner_read  in isi_scan_log.scanner_read%type,
                              in_lte_id        in isi_scan_log.lte_id%type,
                              in_lhm_id        in isi_scan_log.lhm_id%type,
                              in_scanner_cmd   in isi_scan_log.scanner_cmd%type,
                              in_error_txt     in isi_scan_log.error_txt%type,
                              in_scan_ok       in isi_scan_log.scan_ok%type) is

  -------------------------------------------------------------------------------------------------------
  -- variablen
  -------------------------------------------------------------------------------------------------------
  v_isi_scanner_cfg isi_scanner_cfg%rowtype;
  v_res_zus         isi_resource_zust_akt%rowtype;
  v_isi_scan_log_id isi_scan_log.isi_scan_log_id%type;
  v_res_id          isi_scan_log.res_id%type;
  v_sid             isi_scan_log.sid%type;
  v_lhm_id          isi_scan_log.lhm_id%type;

  -------------------------------------------------------------------------------------------------------
  -- cursor
  -------------------------------------------------------------------------------------------------------

  cursor c_scanner is
    select *
      from isi_scanner_cfg sc
     where sc.scanner_name = in_scanner_name;

   cursor c_bde_res_zus is
      select *
        from isi_resource_zust_akt zust_akt
        where zust_akt.sid = v_sid and
              zust_akt.res_id = v_res_id;

begin
  select seq_isi_scan_log_id.nextval into v_isi_scan_log_id from dual;

  -- lesen der scannerdaten
  open c_scanner;
  fetch c_scanner into v_isi_scanner_cfg; -- scannerdaten holen
  close c_scanner;

  v_res_id := v_isi_scanner_cfg.res_id;
  v_sid    := v_isi_scanner_cfg.sid;

  -- lesen des aktuellen zustands der maschine
  open c_bde_res_zus;
  fetch c_bde_res_zus into v_res_zus;
  close c_bde_res_zus;

  insert into isi_scan_log
  values (v_sid,
          v_isi_scan_log_id,
          systimestamp,
          v_isi_scanner_cfg.scanner_name,
          in_scanner_read,
          in_scanner_cmd,
          v_res_id,
          v_res_zus.status_id,
          v_res_zus.akt_aufgabe,
          v_res_zus.leitzahl,
          v_res_zus.pers_nr,
          nvl(in_lte_id, v_res_zus.lte_id),
          in_lhm_id,
          in_scan_ok,
          in_error_txt);

end bde_isi_scan_log_id;

procedure bde_c_sc_ean_create_lte_print (in_scanner_name      in      isi_scanner_cfg.scanner_name%type,
                                         in_barcode           in      isi_scanner_cfg.scanner_daten%type,
                                         in_login_id          in      isi_user.login_id%type,
                                         in_lgr_ort           in      lvs_lgr_ort.lgr_ort%type default NULL)
                                         is
begin
  bde_scanner.bde_c_sc_ean_crt_lte_print_d30(in_scanner_name,
                                             in_barcode,
                                             in_login_id,
                                             NULL,
                                             in_lgr_ort);
end;

procedure bde_c_sc_ean_crt_lte_print_D30(in_scanner_name      in      isi_scanner_cfg.scanner_name%type,
                                         in_barcode           in      isi_scanner_cfg.scanner_daten%type,
                                         in_login_id          in      isi_user.login_id%type,
                                         in_linie             in      isi_resource.res_name%type,
                                         in_lgr_ort           in      lvs_lgr_ort.lgr_ort%type default NULL)
                                         is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error       EXCEPTION;
  v_err_nr      number;
  v_err_text    varchar2(2550);

  v_artikel                          isi_artikel%rowtype;
  v_artikel_2                        isi_artikel%rowtype;
  v_charge                           lvs_charge.charge_bez%type;
  v_menge_str                        varchar2(20);
  v_ean                              varchar2(20);
  v_lfd_nr_str                       varchar2(20);
  v_linie_str                        varchar2(20);
  v_linie_int                        number;
  v_parameter_wert                   varchar2(40);
  v_charge_id                        lvs_charge.charge_id%type;
  v_lgr_ort                      lvs_lgr_ort%rowtype;

  v_prod_datum_str                   varchar2(30);
  v_prod_datum_struktur              varchar2(30);

  v_barcode_config                   isi_scanner_cfg.scanner_daten%type;
  v_scanner_cfg                      isi_scanner_cfg%rowtype;
  v_firma                            isi_firma%rowtype;
  v_linien_waren                     lvs_prod_linie_waren%rowtype;
  v_linien_waren_2                   lvs_prod_linie_waren%rowtype;

  v_lte_id                           lvs_lte.lte_id%type;

  v_found                            boolean;
  v_found_2                          boolean;

  dru_result                         number;
  v_lgr_ort_ort                      lvs_lgr_ort.lgr_ort%type;
  v_typ                              varchar2(10);

  CURSOR c_linie_waren is
    select *
      from lvs_prod_linie_waren t
     where t.artikel_id = v_artikel.artikel_id
       and t.linie_nr = nvl(v_linie_int, t.linie_nr);

  CURSOR c_linie_waren_linie is
    select lw.*
      from lvs_prod_linie_waren lw,
           isi_resource r,
           lvs_prod_linie l
     where r.res_name = v_linie_str
       and l.res_id = r.res_id
       and l.linie_nr = lw.linie_nr;

  CURSOR c_art is
    select *
      from isi_artikel a
     where a.lhm_ean like ('%' || v_ean)
        or a.ean like ('%' || v_ean);

  CURSOR c_art_linie is
    select a.*
      from isi_artikel a,
           isi_resource r,
           lvs_prod_linie l,
           lvs_prod_linie_waren lw
     where (a.lhm_ean like ('%' || v_ean)
            or a.ean like ('%' || v_ean))
       and r.res_name = v_linie_str
       and l.res_id = r.res_id
       and l.linie_nr = lw.linie_nr
       and lw.artikel_id = a.artikel_id;

  CURSOR c_sacnner is
    select *
      from isi_scanner_cfg t
     where t.scanner_name = in_scanner_name;
begin
  OPEN c_sacnner;
  FETCH c_sacnner into v_scanner_cfg;
  v_found := c_sacnner%FOUND;
  CLOSE c_sacnner;

  if v_scanner_cfg.drucker is NULL
  then
     v_err_nr := 5;
     v_err_text := 'Für Scanner ' || in_scanner_name || ' ist kein Drucker eingetragen';
     raise v_error;
  end if;

  if not isi_p_base.get_isi_firma(v_scanner_cfg.sid,        -- in_sid                   in  isi_sid.sid%type,
                                  v_scanner_cfg.firma_nr,   -- in_firma_nr              in  isi_firma.firma_nr%type,
                                  v_firma)                  -- out_firma                out isi_firma%rowtype)
  then
    v_err_nr := 6;
    v_err_text := 'Für Scanner ' || in_scanner_name ||
                  ' mit SID/Firma_nr ' || nvl(v_scanner_cfg.sid, '<NULL>') ||
                  ' / ' || nvl(to_char(v_scanner_cfg.firma_nr), '<NULL>') ||
                  ' fehlt der Firmenstammsatz';
    raise v_error;
  end if;

  v_parameter_wert := isi_allg.c_get_firma_cfg_param (v_scanner_cfg.sid,                    -- in_sid                   in isi_firma_cfg.sid%type,
                                                      v_scanner_cfg.firma_nr,               -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                                      'CFG',                                -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                      v_scanner_cfg.scanner_name,           -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                      'SPEZ_BARCODE_SCANNER',               -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                      v_scanner_cfg.appli_modul,            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                      'CFG',                                -- in_typ                   in isi_firma_cfg.typ%type,
                                                      'EAN13',                              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                      'STRING');                            -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type
  if v_parameter_wert is NULL
  then
     v_err_nr := 10;
     v_err_text := 'Für Scanner ' || in_scanner_name || ' fehlen die Barcodekonfiguration (EAN13) in der ISI_FIRMA_CFG';
     raise v_error;
  end if;

  -- Barcode kann jetzt auch die Linie enthalten
  lvs_p_lte_lhm.split_spez_barcode(in_barcode,                       -- in_barcode              in  lvs_lam.lhm_id%type,
                                   v_parameter_wert,                 -- in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                                   v_artikel.artikel,                -- out_artikel             out varchar2,
                                   v_charge,                         -- out_charge              out varchar2,
                                   v_prod_datum_str,                 -- out_prod_datum_str      out varchar2,
                                   v_prod_datum_struktur,            -- out_prod_datum_struktur out varchar2,
                                   v_menge_str,                      -- out_menge_str           out varchar2,
                                   v_ean,                            -- out_ean                 out varchar2)
                                   v_lfd_nr_str,                     -- out_lfd_nr_str          out varchar2
                                   v_linie_str);                     -- out_linie_str           out varchar2

  v_linie_int := NULL;

  if  v_linie_str != '??'
  and v_linie_str != ''
  then
    begin
      v_linie_int := to_number(v_linie_str);
    exception
      when others then NULL;
    end;
  end if;

  if length(v_ean) = 0
  then
     v_err_nr := 20;
     v_err_text := 'Für Scanner ' || in_scanner_name || ' fehlen die Barcodebeschreibung für den EAN-Code';
     raise v_error;
  end if;

  -- EAN mit führender NULL
  if substr(v_ean, 1, 1) = '0'
  then
    v_ean := substr(v_ean, 2);
  end if;

  v_found := False;
  if in_linie is not NULL
  then
    v_linie_str := in_linie;
  end if;
  if v_linie_str is not NULL
  then
    OPEN c_art_linie;
    FETCH c_art_linie into v_artikel;
    v_found := c_art_linie%FOUND;
    CLOSE c_art_linie;
    v_found_2 := false;
  end if;
  if not v_found
  then
    OPEN c_art;
    FETCH c_art into v_artikel;
    v_found := c_art%FOUND;
    FETCH c_art into v_artikel_2;
    v_found_2 := c_art%FOUND;
    CLOSE c_art;
  end if;
  if not v_found
  then
     v_err_nr := 30;
     v_err_text := 'Artikel für EAN ' || nvl(in_barcode, '<NULL>') || ' fehlt.';
     raise v_error;
  elsif v_found_2
  then
     v_err_nr := 31;
     v_err_text := 'Artikel für EAN ' || nvl(in_barcode, '<NULL>') || ' nicht eindeutig.';
     raise v_error;
  end if;

  if isi_allg.c_get_firma_cfg_param(v_scanner_cfg.sid,                    -- in_sid                   in isi_firma_cfg.sid%type,
                                    v_scanner_cfg.firma_nr,               -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                    'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                    NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                    'AUTO_CRT_LTE_ARTIKEL',-- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                    'CFG',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                    'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                    c.C_FALSE,             -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                    'BOOLEAN') = c.C_TRUE  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
  then
    v_parameter_wert := isi_allg.c_get_firma_cfg_param (v_scanner_cfg.sid,                    -- in_sid                   in isi_firma_cfg.sid%type,
                                                        v_scanner_cfg.firma_nr,               -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                                        'CFG',                                -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                        NULL,                                 -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                        'CHARGE_FORMAT',                      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                        'CFG',                                -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                        'CFG',                                -- in_typ                   in isi_firma_cfg.typ%type,
                                                        'fehlt',                              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                        'STRING');                            -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type
    if v_parameter_wert != 'DATEJULIANISCH'
    then
       v_err_nr := 35;
       v_err_text := 'Keine gültige Beschreibung für die Bildung der Charge.';
       raise v_error;
    end if;
    v_charge := to_char(sysdate, 'YYDDD');
    v_lte_id := null;                                    -- INIT keine LTE_ID

    v_lgr_ort_ort := nvl(in_lgr_ort, v_artikel.lgr_ort_vorgabe);
    if not lvs_p_base.get_lgr_ort(v_scanner_cfg.sid,                    -- in_sid                   in isi_firma_cfg.sid%type,
                                  v_scanner_cfg.firma_nr,
                                  v_lgr_ort_ort,
                                  v_lgr_ort)
    then
      v_err_nr   := 36;
      v_err_text := LC.ec(LC.O_TXT_LGR_ORT_N_ERFASST);
       raise v_error;
    end if;

    -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
    -- -AG- Hier ist der Typ nicht bekannt
    v_lte_id := lvs_p_lte.lvs_lte_lhm_next_id_v35 (v_scanner_cfg.sid,                    -- in_sid                   in isi_firma_cfg.sid%type,
                                                   v_scanner_cfg.firma_nr,               -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                                   C.BASIS_LTE,
                                                   v_charge,
                                                   v_artikel.artikel_id,
                                                   v_artikel.artikel_fuer_kunde_etikett,
                                                   '0000000000',
                                                   '000');

    -- -AG- BugFix:  20.08.2009 Fehler beim Berechnen des MHD Datums
    lvs_p_lte.lvs_lte_artikel_erzeugen(v_scanner_cfg.sid,                    -- in_sid                   in isi_firma_cfg.sid%type,
                                       v_scanner_cfg.firma_nr,               -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                       v_lte_id,                             -- in_lte_id
                                       v_artikel.artikel,                    -- in_artikel             in isi_artikel.artikel%type,
                                       v_artikel.menge_basis,                -- in_menge_basis         in lvs_lam.menge_basis%type,
                                       v_artikel.mengeneinheit_basis,        -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                       v_charge,                             -- in_charge              in lvs_charge.charge_bez%type,
                                       NULL,                                 -- in_menge               in lvs_lam.menge%type,
                                       NULL,                                 -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                       NULL,                                 -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                       NULL,                                 -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                       NULL,                                 -- in_lte_name            in lvs_lte.lte_name%type,
                                       NULL,                                 -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                       trunc(sysdate),                       -- in_prod_datum          in lvs_lam.prod_datum%type,
                                       sysdate,                              -- in_zug_datum           in lvs_lam.zug_datum%type,
                                       v_artikel.mhd_festes_datum,           -- in_mhd                 in lvs_lam.lam_mhd%type,
                                       NULL,                                 -- in_sep_nve             in lvs_lte.nve_nr%type,
                                       NULL,                                 -- in_prod_nr             in lvs_lam.leitzahl%type,
                                       NULL,                                 -- in_fa_ag               in lvs_lam.fa_ag%type,
                                       NULL,                                 -- in_fa_upos             in lvs_lam.fa_upos%type,
                                       v_artikel.labor_vorgabe_status,       -- in_wa_status           in lvs_lam.labor_status%type,
                                       NULL,                                 -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                       -1,                                   -- in_login_id            in isi_user.login_id%type)
                                       NULL);                                -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
    update lvs_lte t
       set t.lgr_ort = v_lgr_ort_ort
     where t.lte_id = v_lte_id;
  else
    if v_linie_str is NULL
    then
      OPEN c_linie_waren;
      FETCH c_linie_waren into v_linien_waren;
      v_found := c_linie_waren%FOUND;
      FETCH c_linie_waren into v_linien_waren_2;
      v_found_2 := c_linie_waren%FOUND;
      CLOSE c_linie_waren;
    else
      OPEN c_linie_waren_linie;
      FETCH c_linie_waren_linie into v_linien_waren;
      v_found := c_linie_waren_linie%FOUND;
      FETCH c_linie_waren_linie into v_linien_waren_2;
      v_found_2 := c_linie_waren_linie%FOUND;
      CLOSE c_linie_waren_linie;
    end if;

    if not v_found
    then
       v_err_nr := 40;
       v_err_text := 'Keine Liniendaten für EAN ' || nvl(in_barcode, '<NULL>') ||
                     ', Artikel ' || nvl(v_artikel.artikel, '<NULL>') ||
                     ' angelegt.';
       raise v_error;
    elsif v_found_2
    then
       v_err_nr := 41;
       v_err_text := 'Liniendaten für EAN ' || nvl(in_barcode, '<NULL>') ||
                     ', Artikel ' || nvl(v_artikel.artikel, '<NULL>') ||
                     ' nicht eindeutig.';
       raise v_error;
    end if;

    v_lte_id := lvs_p_lte.LVS_LTE_ERZEUGEN (v_linien_waren.sid,
                                            v_linien_waren.firma_nr,
                                            v_linien_waren.linie_nr,
                                            NULL,
                                            in_login_id,
                                            v_scanner_cfg.drucker,
                                            NULL);
  end if;
  dru_result := lvs_p_lte.lvs_lte_drucken (v_lte_id, NULL, v_scanner_cfg.drucker);
  commit;

exception
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

procedure bde_sc_pd_spez_prod(in_sid         in isi_sid.sid%type,
                              in_vorg_typ    in bde_pd_prod.vorg_typ%type,
                              in_firma_nr    in isi_firma.firma_nr%type,
                              in_barcode     in lvs_lte.lte_id%type,
                              in_artikel_id  in isi_artikel.artikel_id%type,
                              in_res_id      in isi_resource.res_id%type,
                              in_pers_nr     in isi_user.pers_nr%type,
                              in_menge       in bde_pd_prod.menge_a%type,
                              in_charge      in lvs_charge.charge_bez%type,
                              in_ls_login_id in isi_user.login_id%type,
                              in_fae_id      in bde_pd_prod.fae_id%type,
                              in_out_lhm_id  in out lvs_lam.lhm_id%type) is

  --------------------------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------------
  v_vorg_id     bde_pd_prod.vorg_id%type;          --  Vorgangs ID aus SEQ_VOR
  v_res_zus     isi_resource_zust_akt%rowtype;     --  Aktueller Zustands dieser Maschine
  v_lam_id      lvs_lam.lam_id%type;               --  Lager Artikel Material aus Zugang
  v_lhm_id      lvs_lhm.lhm_id%type;               --  Lager Hilfsmittel ID

  v_menge       bde_pd_prod.menge_a%type;          --  Menge der A-Qualität
  v_found       boolean;
  v_artikel_id  bde_fa_auftrag.ag_artikel_id%type; -- Zum Holen und Übergeben der Artikel ID
  v_charge_id   bde_fa_auftrag.charge_id%type;     -- Aktuelle Charge
  v_artikel     isi_artikel%rowtype;               --  Artikelstammdaten

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(2550);

  v_lte       lvs_lte%rowtype;
  v_res       isi_resource%rowtype;
  v_fa_auft   bde_fa_auftrag%rowtype;

  v_bew_id    s_send_bew.bew_id%type;
  v_charge    lvs_charge%rowtype;
  v_barcode   lvs_lte.lte_id%type;

  -- Holen des aktuellen Zustands dieser Maschine
  CURSOR c_bde_res_zus IS
  SELECT *
    FROM isi_resource_zust_akt zust_akt
    WHERE zust_akt.sid = in_sid AND
          zust_akt.res_id = in_res_id;

  CURSOR c_artikel IS
  SELECT *
    FROM isi_artikel a
    WHERE a.sid = in_sid and
          a.artikel_id = in_artikel_id;

begin
  v_charge_id := get_charge_id(in_sid,
                               in_firma_nr,
                               NULL,
                               in_charge,
                               in_artikel_id);

  if not lvs_p_base.get_charge(v_charge_id, v_charge)
  then
    v_err_nr := 10;
    v_err_text := 'Barcode nicht zu Buchen: ' || in_barcode || ' Fehler in der Ermittlung der Charge ' || nvl(in_charge, '!!Fehlt!!') || '.';
    raise v_error;
  end if;

  if not isi_p_base.get_resource(in_sid, in_res_id, v_res)
  then
    v_err_nr := 40;
    v_err_text := 'Barcode nicht zu Buchen: ' || in_barcode || ' Resource mit res_id: ' || nvl(to_char(in_res_id), '!!NULL!!') || ' fehlt.';
    raise v_error;
  end if;

  -- Folgende Typen sind immer die führenden Einträge in der Tabelle
  if in_vorg_typ = 'PP'    -- Produktion
  then
    select seq_vorg_id.nextval into v_vorg_id from dual;
  else
    v_err_nr := 40;
    v_err_text := 'Barcode nicht zu Buchen: ' || in_barcode || ' Ohne FA an der Maschine ist nur noch die Produktionsfertigmeldung möglich (PP).';
    raise v_error;
  end if;

  if in_vorg_typ = 'PP' then -- Produktion
    if in_menge is NULL
    then
      v_menge := v_artikel.lhm_menge;
    else
      v_menge := in_menge;
    end if;

    if not bde_p_base.get_fa_ag(in_sid,                -- in_sid        in  bde_fa_auftrag.sid%type,
                                in_firma_nr,           -- in_firma_nr   in  bde_fa_auftrag.firma_nr%type,
                                v_res_zus.leitzahl,    -- in_fa_nr      in  bde_fa_auftrag.leitzahl%type,
                                v_res_zus.fa_ag,       -- in_fa_ag      in  bde_fa_auftrag.fa_ag%type,
                                v_res_zus.fa_upos,     -- in_fa_upos    in  bde_fa_auftrag.fa_upos%type,
                                v_fa_auft)          -- out_bde_fa_ag out bde_fa_auftrag%rowtype) return boolean is
    then
      v_fa_auft := NULL;
    end if;


    v_artikel := NULL;
    OPEN c_artikel;
    FETCH c_artikel into v_artikel;
    CLOSE c_artikel;
    v_artikel_id := v_artikel.artikel_id;        -- Artikel ID übergeben

    if not lvs_p_base.get_lte(in_barcode, v_lte)
    then
      v_barcode := lvs_p_lte.lvs_lte_insert_v358 (in_sid,                   -- SID der Maschine
                                                  in_firma_nr,              -- Firma der Maschine
                                                  v_artikel.lte_name,       -- Palettemtype Bsp. 'EURO'
                                                  in_barcode,               -- ID der Transporteinheit
                                                  in_ls_login_id,           -- Login ID aktuelle User
                                                  NULL,                     -- Kein Lager
                                                  v_res.lager_fertig,       -- Fertigwarenlager der Maschine
                                                  'BF',                     -- Status ist auf befüllen gesetzt
                                                  null,
                                                  null,
                                                  v_charge.charge_id,       -- Charge ID
                                                  v_charge.charge_bez,      -- p_charge            in lvs_charge.charge_bez%type,
                                                  v_artikel.artikel_id,     -- p_artikel_id        in isi_artikel.artikel_id%type)
                                                  nvl(v_fa_auft.packschema_kopf_id, v_artikel.packschema_kopf_id),
                                                  null,                    -- Auto Depal ist unbekannt
                                                  null,                    -- wickelprogramm ist unbekannt,
                                                  null);                   -- wickelprogramm_einl ist unbekannt
    end if;

    v_lhm_id := NULL;
    v_lam_id := lvs_einl.lvs_lam_zugang(in_sid, in_firma_nr, v_artikel_id, in_barcode,
                               v_lhm_id, v_charge_id, NULL, null, null, null,
                               null, NULL, NULL, in_res_id, sysdate, sysdate,
                               in_ls_login_id, v_menge, v_artikel.lhm_name, null,
                               null, null, v_artikel.zeichnung, v_artikel.zeichnung_index,
                               null, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                               NULL,     --   v_artikel.artikel_p1,
                               NULL,     --   v_artikel.artikel_p2,
                               NULL,     --   v_artikel.artikel_p3,
                               NULL,     --   v_artikel.artikel_p4,
                               NULL,     --   v_artikel.artikel_p5,
                               NULL,     --   v_artikel.artikel_p6,
                               NULL,     --   v_artikel.artikel_p7,
                               NULL,     --   v_artikel.artikel_p8,
                               NULL,     --   v_artikel.artikel_p9,
                               NULL,     --   v_artikel.artikel_p10
                               'SD',     --   in_lhm_eti_druck_status in lvs_lhm.lhm_eti_druck_status%type,
                               NULL,     --   in_lam_text             in lvs_lam.lam_text%type,
                               NULL,     --   in_labor_text           in lvs_lam.labor_text%type)
                               in_fae_id,
                               NULL,
                               NULL,
                               '1',   -- v_menge_a = A-Ware = 1. Wahl
                               0);     -- lam.lhm_lfd_nr aus FA-Auftrag

    in_out_lhm_id := v_lhm_id;
    select seq_vorg_id.nextval into v_vorg_id from dual;
    -----------------------------------------------------------------
    -- Hier wird die Buchung in die Produktionstabelle eingetragen --
    -----------------------------------------------------------------
    v_err_nr := 70;
    v_err_text := 'Fehler beim Eintragen der Produktionsmeldung FA Auftrag: 0';
    insert into bde_pd_prod
      values(in_sid,
             v_vorg_id,
             in_vorg_typ,
             in_firma_nr,
             0,
             0,
             0,
             NULL,
             in_res_id,
             sysdate,
             sysdate,
             in_pers_nr,
             v_lam_id,
             v_artikel.artikel_id,
             v_menge,
             0,
             0,
             in_ls_login_id,
             0,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             in_fae_id,
             NULL,
             NULL,
             NULL);
  end if;
end;

END bde_scanner;
/



-- sqlcl_snapshot {"hash":"7a8dbce99dbaf5ba159f7a45af0407315caaa920","type":"PACKAGE_BODY","name":"BDE_SCANNER","schemaName":"DIRKSPZM32","sxml":""}