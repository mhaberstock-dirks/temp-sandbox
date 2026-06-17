create or replace 
package body DIRKSPZM32.lvs_util is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  -------------------------------------------------------------------------
  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

  function get_artikel_menge_bis (in_artikel_id         in isi_artikel.artikel_id%type,
                                  in_fa_ag              in lvs_lam.fa_ag%type,
                                  in_akt_bestand        in lvs_lam.menge%type,
                                  in_bestand_dat_von    in date,
                                  in_bestand_dat_bis    in date,
                                  in_akt_date           in date
                                 ) return number is

  v_lam_o_lgr                    lvs_lam.menge%type;

  CURSOR c_verae_menge is
    select sum(decode(bh.bus,
             c.LAM_BH_BUS_UP, 0,
             c.R_LAM_BH_BUS_INV, bh.menge * -1,
             c.R_LAM_BH_BUS_ZUG, bh.menge * -1,
             c.R_LAM_BH_BUS_ZUG_KOMM, bh.menge * -1,
             bh.menge))
       from lvs_v_lam_bh bh
      where bh.artikel_id = in_artikel_id
        and bh.bus != c.R_LAM_BH_BUS_UML
        and bh.buch_datum > trunc(in_bestand_dat_bis) + 1
        --and bh.lgr_platz is not NULL -- -AG- Machmal hat der zugang keinen Lagerplatz (Bsp. MFR)
        and exists (select l.lam_id    -- -AG- 01.02.2010 Wenn die Ware im Lager angekommen ist, dann ist dieses Feld immer gefüllt
                      from lvs_v_lam l
                     where l.lam_id = bh.lam_id
                       and l.lam_text is not NULL)
        and bh.buch_datum <= in_akt_date
        and nvl(in_fa_ag, -1) =  (select nvl(l.fa_ag, -1) fa_ag
                                    from lvs_v_lam l
                                   where l.lam_id = bh.lam_id);

  CURSOR c_von_bis_menge is
    select sum(decode(bh.bus,
             c.R_LAM_BH_BUS_ZUG, bh.menge,
             c.R_LAM_BH_BUS_ZUG_KOMM, bh.menge,
             0)) Zug,
           sum(decode(bh.bus,
             c.R_LAM_BH_BUS_ABG, bh.menge,
             c.R_LAM_BH_BUS_ABG_KOMM, bh.menge,
             0)) Abg,
           sum(decode(bh.bus,
             c.R_LAM_BH_BUS_INV, bh.menge,
             c.R_LAM_BH_BUS_ZUG, 0,
             c.R_LAM_BH_BUS_ABG, 0,
             c.R_LAM_BH_BUS_ZUG_KOMM, 0,
             c.R_LAM_BH_BUS_ABG_KOMM, 0,
             c.LAM_BH_BUS_UP, 0,
             c.R_LAM_BH_BUS_SP,  bh.menge * -1,
             c.R_LAM_BH_BUS_Q,  bh.menge * -1,
             bh.menge)) Veraenderung
       from lvs_v_lam_bh bh
      where bh.artikel_id = in_artikel_id
        and bh.bus != c.R_LAM_BH_BUS_UML
        and bh.buch_datum <= trunc(in_bestand_dat_bis) + 1
        and bh.buch_datum > trunc(in_bestand_dat_von)
        --and bh.lgr_platz is not NULL -- -AG- Machmal hat der zugang keinen Lagerplatz (Bsp. MFR)
        and exists (select l.lam_id    -- -AG- 01.02.2010 Wenn die Ware im Lager angekommen ist, dann ist dieses Feld immer gefüllt
                      from lvs_v_lam l
                     where l.lam_id = bh.lam_id
                       and l.lam_text is not NULL)
        and nvl(in_fa_ag, -1) =  (select nvl(l.fa_ag, -1) fa_ag
                                    from lvs_v_lam l
                                   where l.lam_id = bh.lam_id);
/*/
  CURSOR c_verae_menge is
    select sum(decode(bh.bus,
             c.LAM_BH_BUS_UP, 0,
             c.R_LAM_BH_BUS_ABG, bh.menge * -1,
             c.R_LAM_BH_BUS_SP,  bh.menge * -1,
             c.R_LAM_BH_BUS_Q,  bh.menge * -1,
             bh.menge))
       from lvs_v_lam_bh_lam bh
      where bh.artikel_id = in_artikel_id
        and bh.bus != c.R_LAM_BH_BUS_UML
        and bh.buch_datum > trunc(in_bestand_dat_bis)
        and nvl(bh.lam_fa_ag, -1) = nvl(in_fa_ag, -1);

  CURSOR c_von_bis_menge is
    select sum(decode(bh.bus,
             c.R_LAM_BH_BUS_ZUG, bh.menge,
             0)) Zug,
           sum(decode(bh.bus,
             c.R_LAM_BH_BUS_ABG, bh.menge,
             0)) Abg,
           sum(decode(bh.bus,
             c.R_LAM_BH_BUS_INV, bh.menge,
             c.R_LAM_BH_BUS_ZUG, 0,
             c.R_LAM_BH_BUS_ABG, 0,
             c.LAM_BH_BUS_UP, 0,
             c.R_LAM_BH_BUS_SP,  bh.menge * -1,
             c.R_LAM_BH_BUS_Q,  bh.menge * -1,
             bh.menge)) Veraenderung
       from lvs_v_lam_bh_lam bh
      where bh.artikel_id = in_artikel_id
        and bh.bus != c.R_LAM_BH_BUS_UML
        and bh.buch_datum <= trunc(in_bestand_dat_bis)
        and bh.buch_datum > trunc(in_bestand_dat_von)
        and nvl(bh.lam_fa_ag, -1) = nvl(in_fa_ag, -1);
*/
  -- Hier werden Korrekturzahlen ermittelt fue dinge die nicht mehr in ISIPlusLagerbestand sind
  CURSOR c_lam_sum_o_lgr is
    select sum(l.menge)
      from lvs_v_lam l
     where l.lgr_platz is NULL
       and artikel_id = in_artikel_id
       and menge != 0
       and l.lte_id = (select lte_id
                         from lvs_v_lte lte
                        where lte.lte_id = l.lte_id
                          and lte.lte_letzte_buchung > trunc(in_bestand_dat_bis) + 1);
/*
       and l.lam_id = (select lam_id
                         from lvs_v_lam_bh bh
                        where bh.lam_id = l.lam_id
                          and bh.bus = c.LAM_BH_BUS_ZUG
                          and bh.buch_datum > trunc(in_bestand_dat_von)
                          and bh.lgr_platz is not NULL);
*/
  begin
    v_bestand_von := NULL;
    v_bestand_bis := NULL;
    v_zugang_von_bis := NULL;
    v_abgang_von_bis := NULL;
    v_sonst_von_bis := NULL;

    OPEN c_verae_menge;
    FETCH c_verae_menge into v_veraenderung_bis;
    CLOSE c_verae_menge;

    OPEN c_lam_sum_o_lgr;
    FETCH c_lam_sum_o_lgr into v_lam_o_lgr;
    CLOSE c_lam_sum_o_lgr;
    v_veraenderung_bis := nvl(v_veraenderung_bis, 0) + nvl(v_lam_o_lgr, 0);

    v_veraenderung_bis := nvl(v_veraenderung_bis, 0);
    v_bestand_bis := nvl(in_akt_bestand, 0) + nvl(v_veraenderung_bis, 0);

    if in_bestand_dat_von is not NULL
    then
      OPEN c_von_bis_menge;
      FETCH c_von_bis_menge into v_zugang_von_bis, v_abgang_von_bis, v_sonst_von_bis;
      CLOSE c_von_bis_menge;

      v_bestand_von := v_bestand_bis - v_zugang_von_bis + v_abgang_von_bis - v_sonst_von_bis;
    end if;
    v_bestand_von := nvl(v_bestand_von, v_bestand_bis);
    return(v_bestand_von);
  end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Gibt den in der Funktion get_artikel_menge_bis berechneteten Wert BIS_MENGE zurück
  ------------------------------------------------------------------------------------------------------------------------
  function get_veraendrung_bis  return number is
  begin
    return(v_veraenderung_bis);
  end;
  ------------------------------------------------------------------------------------------------------------------------
  -- Gibt den in der Funktion get_artikel_menge_von berechneteten Wert VON_MENGE zurück
  ------------------------------------------------------------------------------------------------------------------------
  function get_bestand_von  return number is
  begin
    return(v_bestand_von);
  end;
  ------------------------------------------------------------------------------------------------------------------------
  -- Gibt den in der Funktion get_artikel_menge_bis berechneteten Wert bis_MENGE zurück
  ------------------------------------------------------------------------------------------------------------------------
  function get_bestand_bis  return number is
  begin
    return(v_bestand_bis);
  end;
  ------------------------------------------------------------------------------------------------------------------------
  -- Gibt den in der Funktion get_artikel_menge_bis berechneteten Wert v_zugang_von_bis zurück
  ------------------------------------------------------------------------------------------------------------------------
  function get_zugang_von_bis  return number is
  begin
    return(v_zugang_von_bis);
  end;
  ------------------------------------------------------------------------------------------------------------------------
  -- Gibt den in der Funktion get_artikel_menge_bis berechneteten Wert v_abgang_von_bis zurück
  ------------------------------------------------------------------------------------------------------------------------
  function get_abgang_von_bis  return number is
  begin
    return(v_abgang_von_bis);
  end;
  ------------------------------------------------------------------------------------------------------------------------
  -- Gibt den in der Funktion get_artikel_menge_bis berechneteten Wert v_sonst_von_bis zurück
  ------------------------------------------------------------------------------------------------------------------------
  function get_sonst_von_bis  return number is
  begin
    return(v_sonst_von_bis);
  end;

  function get_lte_last_buch (in_sid           in lvs_lam_bh.sid%type,
                              in_firma_nr      in lvs_lam_bh.firma_nr%type,
                              in_lte_id        in lvs_lam_bh.lte_id%type,
                              in_bus           in lvs_lam_bh.bus%type)
                              return lvs_lam_bh.buch_datum%type is


  CURSOR c_v_lam_bh is
    select vbh.*
      from lvs_v_lam_bh vbh
     where vbh.sid = in_sid
       and vbh.firma_nr = in_firma_nr
       and vbh.lte_id = in_lte_id --'010000000072073'
       and vbh.bus = in_bus
    order by vbh.buch_datum;

  begin
    if  v_lam_bh.lte_id = in_lte_id
    and v_lam_bh.sid = in_sid
    and v_lam_bh.firma_nr = in_firma_nr
    and v_lam_bh.bus = in_bus
    then
      return (v_lam_bh.buch_datum);
    end if;

    OPEN c_v_lam_bh;
    FETCH c_v_lam_bh into   v_lam_bh;
    CLOSE c_v_lam_bh;

    return (v_lam_bh.buch_datum);
  end;

  function get_lte_last_lam_id(in_sid           in lvs_lam_bh.sid%type,
                               in_firma_nr      in lvs_lam_bh.firma_nr%type,
                               in_lte_id        in lvs_lam_bh.lte_id%type,
                               in_bus           in lvs_lam_bh.bus%type)
                               return lvs_lam.lam_id%type
           is
  CURSOR c_v_lam_bh is
    select vbh.*
      from lvs_v_lam_bh vbh
     where vbh.sid = in_sid
       and vbh.firma_nr = in_firma_nr
       and vbh.lte_id = in_lte_id --'010000000072073'
       and vbh.bus = in_bus
    order by vbh.buch_datum;

  begin
    if  v_lam_bh.lte_id = in_lte_id
    and v_lam_bh.sid = in_sid
    and v_lam_bh.firma_nr = in_firma_nr
    and v_lam_bh.bus = in_bus
    then
      return (v_lam_bh.lam_id);
    end if;

    OPEN c_v_lam_bh;
    FETCH c_v_lam_bh into   v_lam_bh;
    CLOSE c_v_lam_bh;

    return (v_lam_bh.lam_id);
  end;

  function get_lte_last_charge_id(in_sid           in lvs_lam_bh.sid%type,
                                  in_firma_nr      in lvs_lam_bh.firma_nr%type,
                                  in_lte_id        in lvs_lam_bh.lte_id%type,
                                  in_bus           in lvs_lam_bh.bus%type)
                                  return lvs_lam.charge_id%type
           is
  CURSOR c_v_lam_bh is
    select vbh.*
      from lvs_v_lam_bh vbh
     where vbh.sid = in_sid
       and vbh.firma_nr = in_firma_nr
       and vbh.lte_id = in_lte_id --'010000000072073'
       and vbh.bus = in_bus
    order by vbh.buch_datum;
  begin
    if  v_lam_bh.lte_id = in_lte_id
    and v_lam_bh.sid = in_sid
    and v_lam_bh.firma_nr = in_firma_nr
    and v_lam_bh.bus = in_bus
    then
      return (v_lam_bh.charge_id);
    end if;

    OPEN c_v_lam_bh;
    FETCH c_v_lam_bh into   v_lam_bh;
    CLOSE c_v_lam_bh;
    return (v_lam_bh.charge_id);
  end;

  function get_lvs_v_lam     (in_lam_id in lvs_lam.lam_id%type)
                              return lvs_lam%rowtype
                              is
   CURSOR c_v_lam is
     select *
       from lvs_v_lam
      where lam_id = in_lam_id;

   begin
     if in_lam_id = v_lam.lam_id
     then
       return (v_lam);
     end if;

     OPEN c_v_lam;
     FETCH c_v_lam into v_lam;
     CLOSE c_v_lam;
     return (v_lam);
   end;

  function get_v_lam_best_nr (in_lam_id in lvs_lam.lam_id%type)
                              return lvs_lam.best_nr%type
                              is
  begin
    if in_lam_id = v_lam.lam_id
    then
      return (v_lam.best_nr);
    end if;
    v_lam := get_lvs_v_lam(in_lam_id);

    return (v_lam.best_nr);
  end;

  function get_lam_kunde_by_lte_id (in_lte_id in lvs_lam.lte_id%type)
                              return lvs_lam.kunden_nr%type
                              is
    v_lam_kunde_nr            lvs_lam.kunden_nr%type;
    CURSOR c_lam_kunde is
      select decode(max(t.kunden_nr), min(t.kunden_nr), max(t.kunden_nr), null)
        from lvs_lam t
       where t.lte_id = in_lte_id;

  begin
    v_lam_kunde_nr := NULL;

    OPEN c_lam_kunde;
    FETCH c_lam_kunde into v_lam_kunde_nr;
    CLOSE c_lam_kunde;

    return (v_lam_kunde_nr);
  end;

  function get_lam_kunde_by_lhm_id (in_lhm_id in lvs_lam.lhm_id%type)
                              return lvs_lam.kunden_nr%type
                              is
    v_lam_kunde_nr            lvs_lam.kunden_nr%type;
    CURSOR c_lam_kunde is
      select decode(max(t.kunden_nr), min(t.kunden_nr), max(t.kunden_nr), null)
        from lvs_lam t
       where t.lhm_id = in_lhm_id;

  begin
    v_lam_kunde_nr := NULL;

    OPEN c_lam_kunde;
    FETCH c_lam_kunde into v_lam_kunde_nr;
    CLOSE c_lam_kunde;

    return (v_lam_kunde_nr);
  end;

  function get_artikel_last_buch (in_artikel_id         in isi_artikel.artikel_id%type
                                 ) return date is

  v_buch_dat                     date;
  v_buch_dat_hist                date;

  CURSOR c_lam_bh is
    select t.buch_datum
      from lvs_lam_bh t
     where t.artikel_id = in_artikel_id
       and t.lgr_platz is not NULL
     order by t.buch_datum desc;

  CURSOR c_lam_bh_hist is
    select t.buch_datum
      from lvs_lam_bh_hist t
     where t.artikel_id = in_artikel_id
       and t.lgr_platz is not NULL
     order by t.buch_datum desc;
  begin
    v_buch_dat := NULL;
    v_buch_dat_hist := NULL;

    OPEN c_lam_bh;
    FETCH c_lam_bh into v_buch_dat;
    CLOSE c_lam_bh;

    OPEN c_lam_bh_hist;
    FETCH c_lam_bh_hist into v_buch_dat;
    CLOSE c_lam_bh_hist;

    if v_buch_dat is not NULL
    and v_buch_dat_hist is not NULL
    then
      if v_buch_dat < v_buch_dat_hist
      then
        v_buch_dat := v_buch_dat_hist;
      end if;
    end if;
    return nvl(v_buch_dat, v_buch_dat_hist);
  end;

  function c_get_lte_aus_historie (in_lte_id         in lvs_lte.lte_id%type
                                   ) return number is


  v_lam_bh_hist                 lvs_lam_bh_hist%rowtype;
  v_anz_lhm                     number;

  CURSOR c_lam_bh_hist is
    select *
      from lvs_lam_bh_hist t
     where (t.lhm_id = in_lte_id
        or t.lte_id = in_lte_id)
       and t.bus = c.r_LAM_BH_BUS_ABG
       and t.buch_datum = (select max(l.buch_datum)
                             from lvs_lam_bh_hist l
                            where (l.lhm_id = in_lte_id
                               or l.lte_id = in_lte_id)
                              and l.bus = c.r_LAM_BH_BUS_ABG);


  begin
   v_anz_lhm := 0;
   OPEN c_lam_bh_hist;
   LOOP
     FETCH c_lam_bh_hist into v_lam_bh_hist;
     EXIT when c_lam_bh_hist%NOTFOUND;
     -- LTE
     insert into lvs_lte
       select *
         from lvs_lte_hist t
        where t.lte_id = v_lam_bh_hist.lte_id;
     delete lvs_lte_hist t
        where t.lte_id = v_lam_bh_hist.lte_id;

     -- Korrigierte LTE's rücklagerbar machen (Status muss AG sein)
     update lvs_lte t
        set t.lte_status = 'AG'
      where t.lte_id = v_lam_bh_hist.lte_id
        and t.lte_status = 'KF';

     -- LAM_BH
     -- LAM_BH vor der LAM importieren, damit keine doppelten Buchungen erfolgen (wird im Trigger abgefragt)
     -- Das versenden in die Schnittstelle abschalten
     s_schnittstelle.v_send_host_aktiv := False;
     insert into lvs_lam_bh
       select *
         from lvs_lam_bh_hist t
        where t.lam_id = v_lam_bh_hist.lam_id;
     s_schnittstelle.v_send_host_aktiv := True;

     --LAM
     insert into lvs_lam
       select *
         from lvs_lam_hist t
        where t.lam_id = v_lam_bh_hist.lam_id;

     delete lvs_lam_hist t
        where t.lam_id = v_lam_bh_hist.lam_id;

     delete lvs_lam_bh_hist t
        where t.lam_id = v_lam_bh_hist.lam_id;
     -- LHM
     insert into lvs_lhm
       select *
         from lvs_lhm_hist t
        where t.lhm_id = v_lam_bh_hist.lhm_id;

     delete lvs_lhm_hist t
        where t.lhm_id = v_lam_bh_hist.lhm_id;
     v_anz_lhm := v_anz_lhm + 1;
   end LOOP;
   CLOSE c_lam_bh_hist;
   commit;
   if v_anz_lhm = 0
   then
     RAISE_APPLICATION_ERROR(-20001, LC.ec(LC.O_TP1_KEINE_HIST_DATEN), true);
     -- RAISE_APPLICATION_ERROR(-20001, 'Keine Daten in der Histotie gefunden', true);
   end if;

   return (v_anz_lhm);

  end;
  -------------------------------------------------------------------------------------------------------
  function get_res_string(in_sid            in isi_firma.sid%TYPE,
                          in_firma_nr       in isi_firma.firma_nr%TYPE,
                          in_waren_typ      in lvs_lte.waren_typ%TYPE,
                          in_res_artikel_id in lvs_lte.res_artikel_id%TYPE,
                          in_fa_ag          in lvs_lam.fa_ag%TYPE,
                          in_charge_id      in lvs_lam.charge_id%TYPE,
                          in_serie_id       in lvs_lam.serie_id%TYPE,
                          in_leitzahl       in lvs_lam.leitzahl%TYPE,
                          in_kunden_nr      in lvs_lam.kunden_nr%TYPE,
                          in_lieferant_nr   in lvs_lam.lieferant_nr%TYPE,
                          in_bestellung     in lvs_lam.best_nr%TYPE,
                          in_lam_mhd        in lvs_lam.lam_mhd%TYPE,
                          in_artikel_tage   in isi_artikel.einlager_tage%TYPE,
                          in_labor_status   in lvs_lam.labor_status%TYPE,
                          in_lte_voll       in lvs_lte.lte_voll%TYPE,
                          in_out_res_mhd    in out date) return varchar2 is

    -------------------------------------------------------------------------------------------------------

    -- Bildet den Reservierungsstring für LTE
    -- Ersatz für LVS_RES_String -BW- 6.4.2004
    -------------------------------------------------------------------------------------------------------
  begin
    return ( get_res_string_v357 (in_sid,            -- in isi_firma.sid%TYPE,
                                  in_firma_nr,       -- in isi_firma.firma_nr%TYPE,
                                  in_waren_typ,      -- in lvs_lte.waren_typ%TYPE,
                                  in_res_artikel_id, -- in lvs_lte.res_artikel_id%TYPE,
                                  in_fa_ag,          -- in lvs_lam.fa_ag%TYPE,
                                  in_charge_id,      -- in lvs_lam.charge_id%TYPE,
                                  in_serie_id,       -- in lvs_lam.serie_id%TYPE,
                                  in_leitzahl,       -- in lvs_lam.leitzahl%TYPE,
                                  in_kunden_nr,      -- in lvs_lam.kunden_nr%TYPE,
                                  in_lieferant_nr,   -- in lvs_lam.lieferant_nr%TYPE,
                                  in_bestellung,     -- in lvs_lam.best_nr%TYPE,
                                  in_lam_mhd,        -- in lvs_lam.lam_mhd%TYPE,
                                  in_artikel_tage,   -- in isi_artikel.einlager_tage%TYPE,
                                  in_labor_status,   -- in lvs_lam.labor_status%TYPE,
                                  in_lte_voll,       -- in lvs_lte.lte_voll%TYPE,
                                  NULL,              -- in in_lam_owner_adr_id
                                  in_out_res_mhd));  -- in out date) return varchar2 is
    
  end;

  --------------------------------------------------------------------------------

  function get_res_string_v357 (in_sid               in isi_firma.sid%TYPE,
                                in_firma_nr          in isi_firma.firma_nr%TYPE,
                                in_waren_typ         in lvs_lte.waren_typ%TYPE,
                                in_res_artikel_id    in lvs_lte.res_artikel_id%TYPE,
                                in_fa_ag             in lvs_lam.fa_ag%TYPE,
                                in_charge_id         in lvs_lam.charge_id%TYPE,
                                in_serie_id          in lvs_lam.serie_id%TYPE,
                                in_leitzahl          in lvs_lam.leitzahl%TYPE,
                                in_kunden_nr         in lvs_lam.kunden_nr%TYPE,
                                in_lieferant_nr      in lvs_lam.lieferant_nr%TYPE,
                                in_bestellung        in lvs_lam.best_nr%TYPE,
                                in_lam_mhd           in lvs_lam.lam_mhd%TYPE,
                                in_artikel_tage      in isi_artikel.einlager_tage%TYPE,
                                in_labor_status      in lvs_lam.labor_status%TYPE,
                                in_lte_voll          in lvs_lte.lte_voll%TYPE,
                                in_lam_owner_adr_id  in lvs_lam.owner_address_id%type,
                                in_out_res_mhd       in out date) return varchar2 is
/*
  function get_res_string_v357 
  Hier wird der Resevierungsstring gebildet 
    Das bedeutet: Wenn die Menge > 0 dann wird von KONSI in den verfügbaren Bestand gebucht
                  Wenn die Menge < 0 dann wird von verfügbaren Bestand in den KONSI gebucht 
  Diese Funktion kann nur eine komplette LTE buchen 
  Ohne Commit
  Autor: AG
  ---- HISTORY ---
  18.11.2013 -AG- Erstellt für Erweiterung KONSI
  @param in_sid
  @param in_firma_nr
  @param in_waren_typ
  @param in_res_artikel_id
  @param in_fa_ag
  @param in_charge_id
  @param in_serie_id
  @param in_leitzahl
  @param in_kunden_nr
  @param in_lieferant_nr
  @param in_bestellung
  @param in_lam_mhd
  @param in_artikel_tage
  @param in_labor_status
  @param in_lte_voll
  @param in_lam_owner_adr_id
  @param in_out_res_mhd
*/

  begin
    return ( get_res_string_v359 (in_sid,              -- in isi_firma.sid%TYPE,
                                  in_firma_nr,         -- in isi_firma.firma_nr%TYPE,
                                  in_waren_typ,        -- in lvs_lte.waren_typ%TYPE,
                                  in_res_artikel_id,   -- in lvs_lte.res_artikel_id%TYPE,
                                  NULL,                -- in lvs_lam.hersteller_kuerzel_liste%TYPE,
                                  in_fa_ag,            -- in lvs_lam.fa_ag%TYPE,
                                  in_charge_id,        -- in lvs_lam.charge_id%TYPE,
                                  in_serie_id,         -- in lvs_lam.serie_id%TYPE,
                                  in_leitzahl,         -- in lvs_lam.leitzahl%TYPE,
                                  in_kunden_nr,        -- in lvs_lam.kunden_nr%TYPE,
                                  in_lieferant_nr,     -- in lvs_lam.lieferant_nr%TYPE,
                                  in_bestellung,       -- in lvs_lam.best_nr%TYPE,
                                  in_lam_mhd,          -- in lvs_lam.lam_mhd%TYPE,
                                  in_artikel_tage,     -- in isi_artikel.einlager_tage%TYPE,
                                  in_labor_status,     -- in lvs_lam.labor_status%TYPE,
                                  in_lte_voll,         -- in lvs_lte.lte_voll%TYPE,
                                  in_lam_owner_adr_id, -- in in_lam_owner_adr_id
                                  in_out_res_mhd));    -- in out date) return varchar2 is
    
  end;

  --------------------------------------------------------------------------------


  function get_res_string_v359(in_sid              IN isi_firma.sid%TYPE,
                               in_firma_nr         IN isi_firma.firma_nr%TYPE,
                               in_waren_typ        IN lvs_lte.waren_typ%TYPE,
                               in_res_artikel_id   IN lvs_lte.res_artikel_id%TYPE,
                               in_hersteller_list  in lvs_lam.hersteller_kuerzel_liste%TYPE,
                               in_fa_ag            IN lvs_lam.fa_ag%TYPE,
                               in_charge_id        IN lvs_lam.charge_id%TYPE,
                               in_serie_id         IN lvs_lam.serie_id%TYPE,
                               in_leitzahl         IN lvs_lam.leitzahl%TYPE,
                               in_kunden_nr        IN lvs_lam.kunden_nr%TYPE,
                               in_lieferant_nr     IN lvs_lam.lieferant_nr%TYPE,
                               in_bestellung       IN lvs_lam.best_nr%TYPE,
                               in_lam_mhd          IN lvs_lam.lam_mhd%TYPE,
                               in_artikel_tage     IN isi_artikel.einlager_tage%TYPE,
                               in_labor_status     in lvs_lam.labor_status%TYPE,
                               in_lte_voll         in lvs_lte.lte_voll%TYPE,
                               in_lam_owner_adr_id in lvs_lam.owner_address_id%type,
                               in_out_res_mhd    IN OUT DATE) RETURN VARCHAR2 is


/*
  function get_res_string_v359 
  Hier wird der Resevierungsstring gebildet 
    Das bedeutet: Wenn die Menge > 0 dann wird von KONSI in den verfügbaren Bestand gebucht
                  Wenn die Menge < 0 dann wird von verfügbaren Bestand in den KONSI gebucht 
  Diese Funktion kann nur eine komplette LTE buchen 
  Ohne Commit
  Autor: AG
  ---- HISTORY ---
  18.11.2013 -AG- Erstellt für Erweiterung KONSI
  @param in_sid
  @param in_firma_nr
  @param in_waren_typ
  @param in_res_artikel_id
  @param in_hersteller_list
  @param in_fa_ag
  @param in_charge_id
  @param in_serie_id
  @param in_leitzahl
  @param in_kunden_nr
  @param in_lieferant_nr
  @param in_bestellung
  @param in_lam_mhd
  @param in_artikel_tage
  @param in_labor_status
  @param in_lte_voll
  @param in_lam_owner_adr_id
  @param in_out_res_mhd
*/
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);
    v_charge   varchar2(255);
    v_lam_mhd  date;

    v_Result varchar2(50);

    v_firma   isi_firma%ROWTYPE; -- Firmenstamm
    v_artikel isi_artikel%rowtype;
    v_artikel_id isi_artikel.artikel_id%type;
    v_res_mhd_tage number;

    v_max_res_mhd date; -- Höchstes MHD für die paletten die bis hier gleich sind
    v_max_mhd_akt date;
    v_res_artikel_id   lvs_lte.res_artikel_id%TYPE;

    CURSOR c_artikel is
      select *
        from isi_artikel a
       where a.artikel_id = v_artikel_id;

    CURSOR c_firma is -- Lesen der Firma
      select *
        from isi_firma firma
       where firma.sid = in_sid
         and firma.firma_nr = in_firma_nr;

    -- BugFix -AG- 21.01.2010
    CURSOR c_max_mhd is
      select nvl(max(trunc(lte.res_mhd)), v_lam_mhd)
        from lvs_lte lte
       where lte.res_string like (v_result || '%')
         and lte.res_mhd <= v_lam_mhd
         and lte.res_mhd >= v_lam_mhd - v_res_mhd_tage;

    CURSOR c_charge is
      select nvl(chg.charge_bez, 'KeineCharge')
        from lvs_charge chg
       where chg.sid = in_sid
         and chg.charge_id = in_charge_id;
  begin
     
  
    -- AG 20180320 - KONIS nicht mit in_Lieferanten sondern mit ard_id 
    -- Über Firma_cfg kann der RES_STRING weiter aufgebaut werden

    v_result := NULL;

    if in_lam_owner_adr_id is not NULL
    then
      v_result := 'KONSI-' || in_lam_owner_adr_id;
      if isi_allg.c_get_firma_cfg_param(in_sid,                         -- in_sid                   in isi_firma_cfg.sid%type,
                                        in_firma_nr,                    -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                        'EINL_STRAT',                   -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        'RES_STRING',                   -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'LVS_RES_STR_KONSI_KOMPLETT', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'LVS',                          -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                          -- in_typ                   in isi_firma_cfg.typ%type,
                                        c.C_FALSE,                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_FALSE          -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
      then
        return(v_result);
      else
         v_result := v_result || '-';
      end if;
    end if;
    
    v_artikel := NULL;
    begin
      v_artikel_id := to_number(in_res_artikel_id);
      OPEN c_artikel;
      FETCH c_artikel into v_artikel;
      CLOSE c_artikel;
    exception
      when others
      then
        v_artikel_id := NULL;
    end;

    if in_out_res_mhd is NULL
    then
      v_lam_mhd := in_lam_mhd;
    else
      if nvl(in_lam_mhd, in_out_res_mhd) >= in_out_res_mhd
      then
        v_lam_mhd := in_out_res_mhd;
      else
        v_lam_mhd := in_lam_mhd;
      end if;
    end if;

    OPEN c_firma; -- Firmenstamm holen
    FETCH c_firma
      into v_firma; --
    CLOSE c_firma;

    if v_firma.res_string_anbruch is not NULL
    and in_lte_voll = c.LTE_VOLL_A
    and (v_firma.labor_status_anbruch like '%' || in_labor_status || ';%'
      or v_firma.labor_status_anbruch is NULL)
    then
      v_res_mhd_tage := 0;
      if v_artikel.res_mhd_tage is not NULL
      then
         v_max_mhd_akt := v_max_res_mhd + v_artikel.res_mhd_tage;
         v_res_mhd_tage := v_artikel.res_mhd_tage;
      else
        if in_waren_typ = c.FERTIGWARE and in_fa_ag is NULL then
           v_max_mhd_akt := v_max_res_mhd + v_firma.fw_res_mhd_tage;
           v_res_mhd_tage := v_firma.fw_res_mhd_tage;
        elsif in_waren_typ = c.ROHWARE then
           v_max_mhd_akt := v_max_res_mhd + v_firma.rw_res_mhd_tage;
           v_res_mhd_tage := v_firma.rw_res_mhd_tage;
        else
           v_max_mhd_akt := v_max_res_mhd + v_firma.hw_res_mhd_tage;
           v_res_mhd_tage := v_firma.hw_res_mhd_tage;
        end if;
      end if;

      OPEN c_max_mhd;
      FETCH c_max_mhd
        into v_max_res_mhd;
      CLOSE c_max_mhd;

      -- BugFix -AG- 21.01.2010
      -- BugFix -AG- Diese Bedingung wird nie erfüllt
      -- Richtig ist, wenn MAX MHD im Lager + MHD-Tage gleich < Berechnetes MHD
      -- und MHD der LAM < MAX MHD im Lager
      -- dann muss das RES_MHD von der LAM uebernommen werden
      -- (Neues MHD ist nicht im Bereich MAX-MHD und MAX-MHD + MHD-Tage-Gleich
      if trunc(v_max_mhd_akt) <= v_lam_mhd
      or v_lam_mhd < v_max_res_mhd
      then
        v_max_res_mhd := v_lam_mhd;
      end if;

      in_out_res_mhd := v_max_res_mhd;
      v_Result := v_firma.res_string_anbruch;
      return(v_Result);
    else
      if in_waren_typ = c.MISCHPAL or in_res_artikel_id = c.MISCHPAL then
        -- Bei Mischpaletten Reservierung Mischpal
        v_Result         := 'MischPal;';
        in_out_res_mhd := NULL;
        return(v_Result);
      end if;

      if in_waren_typ = c.MISCHKANAL or in_res_artikel_id = c.MISCHKANAL then
        -- Bei Mischpaletten Reservierung Mischpal
        v_Result         := 'MischKANAL;';
        in_out_res_mhd := NULL;
        return(v_Result);
      end if;

    end if;

    v_res_artikel_id := in_res_artikel_id;
    
    if in_hersteller_list is not NULL -- Wenn Artikel für RES_STRING relevant, dann auch die Herstellerliste
    then
      v_res_artikel_id := v_res_artikel_id || in_hersteller_list;
    end if;

    if in_waren_typ = c.FERTIGWARE and in_fa_ag is NULL then

      if nvl(v_artikel.res_artikel, v_firma.fw_res_artikel) = c.C_TRUE then
        v_Result := v_result || v_res_artikel_id || ';' || in_fa_ag || ';' || in_labor_status || ';'; -- Artikel_ID und Arbeitsgang in die Reservierung
      end if;

      if nvl(v_artikel.res_charge, v_firma.fw_res_charge) = c.C_TRUE then
        v_result := v_result || to_char(in_charge_id) || ';';
      end if;

      if nvl(v_artikel.res_charge, v_firma.fw_res_charge) = c.HILFS_CHARGE then
        -- Reservierung ueber Hauptcharge
        OPEN c_charge; -- Lesen der charge
        FETCH c_charge
          into v_charge;
        CLOSE c_charge;
        v_charge := substr(v_charge, 1, instr(v_charge, '-', 1, 1) - 1);
        v_result   := v_result || v_charge || ';';
      end if;

      if nvl(v_artikel.res_serie, v_firma.fw_res_serie) = c.C_TRUE then
        v_result := v_result || to_char(in_serie_id) || ';';
      end if;

      if nvl(v_artikel.res_fa_auftrag, v_firma.fw_res_fa_auftrag) = c.C_TRUE then
        v_result := v_result || to_char(in_leitzahl) || '/' ||
                  to_char(in_fa_ag) || ';';
      end if;

      if nvl(v_artikel.res_kunde, v_firma.fw_res_kunde) = c.C_TRUE then
        v_result := v_result || in_kunden_nr || ';';
      end if;

      v_res_mhd_tage := nvl(v_artikel.res_mhd_tage, v_firma.fw_res_mhd_tage);

      OPEN c_max_mhd;
      FETCH c_max_mhd
        into v_max_res_mhd;
      CLOSE c_max_mhd;

      -- BugFix -AG- 21.01.2010
      if nvl(trunc(v_max_res_mhd), v_lam_mhd) + v_res_mhd_tage <= v_lam_mhd -- Akt MHD ist Dahinter
      or v_lam_mhd < v_max_res_mhd                                         -- Akt MHD ist davor
      then
        v_max_res_mhd := v_lam_mhd;                                        -- Dann RES_MHD mit dem aktuellen Wert füllen
      end if;

      in_out_res_mhd := v_max_res_mhd;

      if nvl(v_artikel.res_mhd, v_firma.fw_res_mhd) = c.C_TRUE then
        v_result := v_result || to_char(v_max_res_mhd, 'dd.mm.yyyy') || ';';
      end if;
    elsif in_waren_typ = c.HALBWARE or in_fa_ag is not NULL then

      if nvl(v_artikel.res_artikel, v_firma.hw_res_artikel) = c.C_TRUE then
        v_result := v_result || v_res_artikel_id || ';' || in_fa_ag || ';' || in_labor_status || ';'; -- Artikel_ID und Arbeitsgang in die Reservierung
      end if;

      if nvl(v_artikel.res_charge, v_firma.hw_res_charge) = c.C_TRUE then
        v_result := v_result || to_char(in_charge_id) || ';';
      end if;

      if nvl(v_artikel.res_charge, v_firma.hw_res_charge) = c.HILFS_CHARGE then
        -- Reservierung uener Hauptcharge
        OPEN c_charge; -- Lesen der charge
        FETCH c_charge
          into v_charge;
        CLOSE c_charge;
        v_charge := substr(v_charge, 1, instr(v_charge, '-', 1, 1) - 1);
        v_result   := v_result || v_charge || ';';
      end if;

      if nvl(v_artikel.res_serie, v_firma.hw_res_serie) = c.C_TRUE then
        v_result := v_result || to_char(in_serie_id) || ';';
      end if;

      if nvl(v_artikel.res_fa_auftrag, v_firma.hw_res_fa_auftrag) = c.C_TRUE then
        v_result := v_result || to_char(in_leitzahl) || '/' ||
                  to_char(in_fa_ag) || ';';
      end if;

      if nvl(v_artikel.res_kunde, v_firma.hw_res_kunde) = c.C_TRUE then
        v_result := v_result || in_kunden_nr || ';';
      end if;

      v_res_mhd_tage := nvl(v_artikel.res_mhd_tage, v_firma.hw_res_mhd_tage);

      OPEN c_max_mhd;
      FETCH c_max_mhd
        into v_max_res_mhd;
      CLOSE c_max_mhd;

      -- BugFix -AG- Diese Bedingung wird nie erfüllt
      -- Richtig ist, wenn MAX MHD im Lager + MHD-Tage gleich < Berechnetes MHD
      -- und MHD der LAM < MAX MHD im Lager
      -- dann muss das RES_MHD von der LAM uebernommen werden
      -- (Neues MHD ist nicht im Bereich MAX-MHD und MAX-MHD + MHD-Tage-Gleich
      if nvl(trunc(v_max_res_mhd), v_lam_mhd) + v_res_mhd_tage <= v_lam_mhd -- Akt MHD ist Dahinter
      or v_lam_mhd < v_max_res_mhd                                         -- Akt MHD ist davor
      then
        v_max_res_mhd := v_lam_mhd;                                        -- Dann RES_MHD mit dem aktuellen Wert füllen
      end if;

      in_out_res_mhd := v_max_res_mhd;
      if nvl(v_artikel.res_mhd, v_firma.hw_res_mhd) = c.C_TRUE then
        v_result := v_result || to_char(v_max_res_mhd, 'dd.mm.yyyy') || ';';
      end if;

    elsif in_waren_typ = c.ROHWARE then
      if nvl(v_artikel.res_artikel, v_firma.rw_res_artikel) = c.C_TRUE then
        v_result := v_result || v_res_artikel_id || ';' || in_fa_ag || ';' || in_labor_status || ';'; -- Artikel_ID und Arbeitsgang in die Reservierung
      end if;

      if nvl(v_artikel.res_charge, v_firma.rw_res_charge) = c.C_TRUE then
        v_result := v_result || to_char(in_charge_id) || ';';
      end if;

      if nvl(v_artikel.res_serie, v_firma.rw_res_serie) = c.C_TRUE then
        v_result := v_result || to_char(in_serie_id) || ';';
      end if;

      if nvl(v_artikel.res_fa_auftrag, v_firma.rw_res_fa_auftrag) = c.C_TRUE then
        v_result := v_result || to_char(in_bestellung) || ';';
      end if;

      if nvl(v_artikel.res_kunde, v_firma.rw_res_lieferant) = c.C_TRUE then
        v_result := v_result || in_lieferant_nr || ';';
      end if;

      v_res_mhd_tage := nvl(v_artikel.res_mhd_tage, v_firma.rw_res_mhd_tage);

      OPEN c_max_mhd;
      FETCH c_max_mhd
        into v_max_res_mhd;
      CLOSE c_max_mhd;

      -- BugFix -AG- Diese Bedinungung wird nie erfüllt
      -- Richtig ist, wenn MAX MHD im Lager + MHD-Tage gleich < Berechnetes MHD
      -- und MHD der LAM < MAX MHD im Lager
      -- dann muss das RES_MHD von der LAM uebernommen werden
      -- (Neues MHD ist nicht im Bereich MAX-MHD und MAX-MHD + MHD-Tage-Gleich
      if nvl(trunc(v_max_res_mhd), v_lam_mhd) + v_res_mhd_tage <= v_lam_mhd -- Akt MHD ist dahinter
      or v_lam_mhd < v_max_res_mhd                                         -- Akt MHD ist davor
      then
        v_max_res_mhd := v_lam_mhd;                                        -- Dann RES_MHD mit dem aktuellen Wert füllen
      end if;

      in_out_res_mhd := v_max_res_mhd;
      if nvl(v_artikel.res_mhd, v_firma.rw_res_mhd) = c.C_TRUE then
        v_result := v_result || to_char(v_max_res_mhd, 'dd.mm.yyyy') || ';';
      end if;
    end if;

    return(v_result);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end;

  procedure c_set_lam_qs_status (in_sid           in lvs_lam.sid%type,
                                 in_firma_nr      in lvs_lam.firma_nr%type,
                                 in_lhm_id        in lvs_lam.lhm_id%type,
                                 in_qs_status     in lvs_lam.qs_status%type)
                                 is
    pragma autonomous_transaction;
  begin
    update lvs_lam l
       set l.qs_status = in_qs_status
     where l.sid = in_sid
       and l.firma_nr = in_firma_nr
       and l.lhm_id = in_lhm_id;
    commit;
  end;

  procedure c_set_lam_charge_u_prod_datum (in_sid           in lvs_lam.sid%type,
                                           in_firma_nr      in lvs_lam.firma_nr%type,
                                           in_lam_id        in lvs_lam.lam_id%type,
                                           in_charge_bez    in lvs_charge.charge_bez%type,
                                           in_prod_datum    in lvs_lam.prod_datum%type)
                                           is

    v_lam                                  lvs_lam%rowtype;
    v_art                                  isi_artikel%rowtype;
    
    v_charge_id                            lvs_charge.charge_id%type;
    v_charge_lieferant             lvs_charge.lieferanten_id%type;
  
  begin
    if lvs_p_base.get_lam(in_sid, in_firma_nr, in_lam_id, v_lam)
    then
      if isi_p_base.get_isi_artikel(in_sid, v_lam.artikel_id,v_art)
      then
        begin
          v_charge_lieferant := v_lam.lieferant_nr;
        exception
          when others then
            v_charge_lieferant := NULL;
        end;
         v_charge_id := get_charge_id(in_sid, in_firma_nr, v_charge_lieferant, in_charge_bez, v_lam.artikel_id);
         update lvs_lam t
            set t.prod_datum = in_prod_datum,
                t.lam_mhd = trunc(in_prod_datum + v_art.mhd_tage),
                t.lam_mhd_ausgabe = trunc(in_prod_datum + v_art.mhd_tage),
                t.charge_id = v_charge_id
          where t.lam_id = in_lam_id;
      end if;
    end if;    
  end;
  
end;
/



-- sqlcl_snapshot {"hash":"32c5f7223dac9f6b0edfbc157626c770f44a374a","type":"PACKAGE_BODY","name":"LVS_UTIL","schemaName":"DIRKSPZM32","sxml":""}