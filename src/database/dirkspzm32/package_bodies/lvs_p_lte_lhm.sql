create or replace 
package body DIRKSPZM32.lvs_p_lte_lhm is

  -- Private type declarations
  procedure lvs_lhm_abpacken(in_lhm        in lvs_lhm%rowtype,
                             in_user_ID    in isi_user.login_id%TYPE,
                             in_lte_status in lvs_lte.lte_status%type,
                             in_art        in isi_artikel%rowtype,
                             in_kunden_nr  in lvs_lam.kunden_nr%type);
  procedure lvs_lhm_aufpacken(in_lhm        in lvs_lhm%rowtype,
                              in_lte        in lvs_lte%rowtype,
                              in_dif_frei_h in lvs_lgr.lgr_frei_hoehe%type,
                              in_user_ID    in isi_user.login_id%TYPE,
                              in_lte_status in lvs_lte.lte_status%type);

  procedure lvs_lte_wieder_einl(in_lte_id     in lvs_lte.lte_id%type,
                                in_lgr_ort    in lvs_lgr_ort.lgr_ort%type,
                                in_user_ID    in isi_user.login_id%TYPE);

  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

  function lvs_lte_lhm_pruefcheck_mod10(in_barcode in varchar2)
    return boolean is
    -------------------------------------------------------------------------------------------------------
    -- Prueft die Prüfziffer aus String nach MOD 10
    -------------------------------------------------------------------------------------------------------
    Result boolean;
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    v_laenge        integer; -- Laenger des uebergebenen Barcodes
    v_multiplikator integer; -- Multiplikator 3 bzw 1
    v_summe         integer; -- Summe aller ziffer mit Multiplikator
    v_mod           integer; -- Rest aus Summe / 10

    v_pruefziffer integer;

  begin

    v_laenge        := length(in_barcode); -- Laenge ermitteln
    v_multiplikator := 3; -- Letzte ziffer immer mit 3 Multiplizieren
    v_summe         := 0; -- Noch keine ziffer ausgewertet

    v_pruefziffer := substr(in_barcode, v_laenge, 1);
    v_laenge      := v_laenge - 1; -- Auf letztes Zeichen

    while v_laenge > 0
    loop
      v_summe  := v_summe + to_number(substr(in_barcode, v_laenge, 1)) *
                  v_multiplikator;
      v_laenge := v_laenge - 1; -- naechstes Zeichen
      if v_multiplikator = 3
      then
        v_multiplikator := 1;
      else
        v_multiplikator := 3;
      end if;
    end loop;

    v_mod := v_summe mod 10; -- Rest aus Summe / 10 (MODUL10 Pruefziffer)
    if v_mod != 0
    then
      -- 0 ist immer 0
      v_mod := 10 - v_mod; -- Sonst differenz 10 - Rest aus Summe
    end if;

    if to_char(v_mod) != v_pruefziffer
    then
      -- Pruefziffer ist falsch
      v_err_nr   := 10;
      v_err_text := LC.ec_p2(LC.O_TP2_PRUEFZIFFER_ERR, v_pruefziffer, to_char(v_mod));
      raise v_error;
    end if;
    result := true; -- Berechnete Prüfziffer ist mit der uebergebenen gleich
    return(Result);

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
  end lvs_lte_lhm_pruefcheck_mod10;

  function lvs_lte_lhm_pruefziffer_mod10(in_barcode in varchar2)
    return varchar2 is
    -------------------------------------------------------------------------------------------------------
    -- Ermittel die Prüfziffer aus String nach MOD 10
    -------------------------------------------------------------------------------------------------------
    Result varchar2(20);

    v_laenge        integer; -- Laenger des uebergebenen Barcodes
    v_multiplikator integer; -- Multiplikator 3 bzw 1
    v_summe         integer; -- Summe aller ziffer mit Multiplikator
    v_mod           integer; -- Rest aus Summe / 10

  begin

    v_laenge        := length(in_barcode); -- Laenge ermitteln
    v_multiplikator := 3; -- Letzte ziffer immer mit 3 Multiplizieren
    v_summe         := 0; -- Noch keine ziffer ausgewertet

    while v_laenge > 0
    loop
      v_summe  := v_summe + to_number(substr(in_barcode, v_laenge, 1)) *
                  v_multiplikator;
      v_laenge := v_laenge - 1; -- Auf letztes Zeichen
      if v_multiplikator = 3
      then
        v_multiplikator := 1;
      else
        v_multiplikator := 3;
      end if;
    end loop;

    v_mod := v_summe mod 10; -- Rest aus Summe / 10 (MODUL10 Pruefziffer)
    if v_mod != 0
    then
      -- 0 ist immer 0
      v_mod := 10 - v_mod; -- Sonst differenz 10 - Rest aus Summe
    end if;

    result := in_barcode || to_char(v_mod); -- Barcode mit der berechneten Prüfziffer
    return(Result);

  end lvs_lte_lhm_pruefziffer_mod10;

  function lvs_lte_lhm_ref(in_sid      in isi_sid.sid%type,
                           in_firma_nr in isi_firma.firma_nr%type,
                           in_barcode  in lvs_lte.lte_id%type)
    return varchar2 is

    -------------------------------------------------------------------------------------------------------
    -- Funktion ermittelt für welche Tabelle der barcode passt. Return is 'LTE', 'LHM', 'NEU' oder NULL
    -------------------------------------------------------------------------------------------------------

    v_barcode lvs_lte.lte_id%type; -- Nimmt den Barcode des Cursor
    v_result  varchar2(3); -- Wozu gehört der Barcode ? LHM oder LTE

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error EXCEPTION; --
    v_err_nr   number;
    v_err_text varchar2(255);

    cursor c_lhm is -- Lesen des Lagerhilfsmittel
      select lhm.lhm_id
        from lvs_lhm lhm
       where lhm.sid = in_sid
         and lhm.firma_nr = in_firma_nr
         and lhm.lhm_id = in_barcode;

    cursor c_lte is -- Lesen der Transporteinheit für den Lagerplatz
      select lte.lte_id
        from lvs_lte lte
       where lte.sid = in_sid
         and lte.firma_nr = in_firma_nr
         and lte.lte_id = in_barcode;

  begin
    -- Lesen der Artikeldaten
    v_err_nr   := NULL;
    v_err_text := NULL;

    v_result := NULL; -- Initialisieren
    if in_barcode is not NULL
    then
      -- Ist der Barcode gefüllt??
      OPEN c_lhm; -- Erst mal prüfen ob der Barcode ein LHM ist
      FETCH c_lhm
        into v_barcode; -- Lesen
      if c_lhm%NOTFOUND
      then
        -- Barcode ist kein LHM
        OPEN c_lte; -- Jetzt prüfen ob der Barcode ein LTE ist (Transporteinheit)
        FETCH c_lte
          into v_barcode; -- Lesen
        if c_lte%NOTFOUND
        then
          -- Wenn nicht dann
          v_result := 'NEU'; -- Barcode ist noch nicht bekannt !!
        else
          v_result := 'LTE'; -- Barcode gehört zu einer Transporteinheit (Palette etc)
        end if;
        CLOSE c_lte;
      else
        v_result := 'LHM'; -- Dieser Barcode ist ein Lagerhilfsmittel (Karton etc.)
      end if;
      CLOSE c_lhm;
    end if;

    return(v_result); -- Gefundenes Ergebniss zurück
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
  end lvs_lte_lhm_ref;

  function lvs_lte_lhm_best(in_sid         in isi_sid.sid%type,
                            in_firma_nr    in isi_firma.firma_nr%type,
                            in_barcode     in lvs_lte.lte_id%type,
                            in_barcode_ref in varchar2) return number is
  begin
    return(lvs_p_lte_lhm.lvs_lte_lhm_best_R30(in_sid,              -- in isi_sid.sid%type,
                                              in_firma_nr,         -- in isi_firma.firma_nr%type,
                                              in_barcode,          -- in lvs_lte.lte_id%type,
                                              in_barcode_ref,
                                              c.C_TRUE));

  end;

  function lvs_lte_lhm_best_R30(in_sid              in isi_sid.sid%type,
                                in_firma_nr         in isi_firma.firma_nr%type,
                                in_barcode          in lvs_lte.lte_id%type,
                                in_barcode_ref      in varchar2,
                                in_ignor_lte_status in varchar2) return number is
    -------------------------------------------------------------------------------------------------------
    -- Funktion ermittelt ob es zu diesem Barcode einen Bestand gibt
    -------------------------------------------------------------------------------------------------------

    v_lam    lvs_lam%rowtype; -- Lagerbestand
    v_result number; -- Return > 0 ==> Zu diesem Barcode gibt es Bestand
    -- Return = 0 ==> Zu diesem Barcode gibt es keinen Bestand

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error EXCEPTION; --
    v_err_nr   number;
    v_err_text varchar2(255);

    v_lte              lvs_lte%rowtype;

    cursor c_lam_lte is -- Lesen des Lagerbestand
      select *
        from lvs_lam lam
       where lam.sid = in_sid
         and lam.firma_nr = in_firma_nr
         and lam.lte_id = in_barcode; -- Oder die Transporteinheit

    cursor c_lam_lhm is -- Lesen des Lagerbestand
      select *
        from lvs_lam lam
       where lam.sid = in_sid
         and lam.firma_nr = in_firma_nr
         and lam.lhm_id = in_barcode; -- Ueber das lagerhilfsmittel

  begin
    -- Lesen der Artikeldaten
    v_err_nr   := NULL;
    v_err_text := NULL;
    v_result   := 0; -- Erst mal kein Lagerbestand

    if in_barcode_ref = 'LTE'
    then
      if lvs_p_base.get_lte (in_barcode, v_lte)
      then
        -- -AG- 20190401 Bug, der Status muss fast immer ignoriert wereden, ausser bei den Scann-Prozessen
        if v_lte.lte_status in (c.LTE_KF_STAT, c.LTE_PF_STAT) -- Kein Lagerbestand mehr, dann 0
        and in_ignor_lte_status = c.C_FALSE
        then
          v_result := 0;
          return(v_result); -- Gefundenes Ergebniss zurück
        end if;
      else -- Palette nicht da, dann Menge 0
        v_result := 0;
        return(v_result); -- Gefundenes Ergebniss zurück
      end if;
      OPEN c_lam_lte; -- Prüfen ob es Lagerbestand für diesen Barcode gibt
      FETCH c_lam_lte
        into v_lam; -- Lesen
      if c_lam_lte%NOTFOUND
      then
        -- Keinen Lagerbestand
        v_result := 0; -- Kein Lagerbestand
      else
        v_result := nvl(v_lam.menge, 0); -- Wenn Lagerbestand vorhanden, dann aktuelle Menge zurück
        LOOP
          FETCH c_lam_lte
            into v_lam; -- Lesen
          EXIT when c_lam_lte%NOTFOUND; -- Keinen weiterer Lagerbestand (FERTIG)
          v_result := v_result + nvl(v_lam.menge, 0); -- Lagerbestand Addieren
        end LOOP;
      end if;
      CLOSE c_lam_lte;
    elsif in_barcode_ref = 'LHM'
    then
      OPEN c_lam_lhm; -- Prüfen ob es Lagerbestand für diesen Barcode gibt
      FETCH c_lam_lhm
        into v_lam; -- Lesen
      if c_lam_lhm%NOTFOUND
      then
        -- Keinen Lagerbestand
        v_result := 0; -- Kein Lagerbestand
      else
        v_result := nvl(v_lam.menge, 0); -- Wenn Lagerbestand vorhanden, dann aktuelle Menge zurück
        LOOP
          FETCH c_lam_lhm
            into v_lam; -- Lesen
          EXIT when c_lam_lhm%NOTFOUND; -- Keinen weiterer Lagerbestand (FERTIG)
          v_result := v_result + nvl(v_lam.menge, 0); -- Lagerbestand Addieren
        end LOOP;
      end if;
      CLOSE c_lam_lhm;
    end if;
    return(v_result); -- Gefundenes Ergebniss zurück
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
  end lvs_lte_lhm_best_r30;

  function lvs_lam_name_get(in_artikel_id in number,
                            in_kunden_nr  in bde_fa_auftrag.kunden_nr%type)
    return varchar2 is

    result varchar2(10); --isi_artikel.kd_verpackungstype%typ;

    v_art    isi_artikel%rowtype; -- Gelesene Artikeldaten
    v_kd_art isi_artikel_kunde%rowtype; -- Gelesene Artikelkundendaten

    cursor c_art is -- Lesen des Artikels !!!!
      select * from isi_artikel art where art.artikel_id = in_artikel_id;

    cursor c_kd_art is -- Lesen des KundenArtikels !!!!
      select *
        from isi_artikel_kunde kd_art
       where kd_art.artikel_id = in_artikel_id
         and kd_art.kunden_nr = in_kunden_nr;
  begin
    -- Erst mal kein Fehler
    Result := NULL; -- Noch nichts Gefunden da noch nichts gelesen

    OPEN c_kd_art;
    FETCH c_kd_art
      into v_kd_art; -- KundenArtikel lesen
    if c_kd_art%FOUND
    then
      -- KundenArtikel gefunden
      result := v_kd_art.lhm_name; -- In diesem Fall den LHM (Kunde)
    end if;
    CLOSE c_kd_art;

    if result is NULL
    then
      OPEN c_art;
      FETCH c_art
        into v_art; -- Artikel lesen
      if c_art%FOUND
      then
        -- Artikel gefunden
        result := v_art.lhm_name; -- In diesem Fall den LHM (Standard)
      end if;

      CLOSE c_art;
    end if;
    return(Result);
  end lvs_lam_name_get;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure erstellt eine LAM und bucht diese mit BUS7 (Gesperrt abgang) aus
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_c_lam_sper_neue_lte_mg(in_lte_id       in lvs_lhm.Lte_Id%TYPE,
                                       in_lhm_id       in lvs_lhm.Lhm_Id%TYPE,
                                       in_lam_id       in lvs_lam.Lam_Id%TYPE,
                                       in_lam_bh_id    in lvs_lam_bh.lam_bh_id%TYPE,
                                       in_user_ID      in isi_user.login_id%TYPE,
                                       in_lgr_ort      in lvs_lgr_ort.lgr_ort%type,
                                       in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                       in_menge        in number,
                                       in_drucker_name in varchar2) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    v_found boolean;
    v_menge number;

    v_lam_bh  lvs_lam_bh%rowtype;
    v_lgr_platz lvs_lgr.lgr_platz%type;

    v_sysdate date;

    cursor c_lam_bh is
      select *
        from lvs_lam_bh lam_bh
       where lam_bh.lam_bh_id = in_lam_bh_id;
  begin
    OPEN c_lam_bh;
    FETCH c_lam_bh
      into v_lam_bh;
    v_found := c_lam_bh%FOUND;
    CLOSE c_lam_bh;

    if not v_found
    then
      v_err_nr   := 10;
      v_err_text := LC.ec(LC.O_TXT_BUCH_ERR_VERBRAUCH);
      RAISE v_error;
    end if;

    if v_lam_bh.menge != in_menge
    then
      update lvs_lam_bh t
         set t.menge = in_menge
       where t.lam_bh_id = in_lam_bh_id;
       v_sysdate := sysdate;
       v_menge := bde_c_barcode_buch(v_lam_bh.sid,
                                     v_lam_bh.firma_nr,
                                     v_lam_bh.lhm_id,
                                     v_lam_bh.res_id,
                                     in_user_ID,
                                     NULL,
                                     NULL,
                                     NULL,
                                     'BESCHICKEN',
                                     NULL,
                                     NULL,
                                     v_lam_bh.leitzahl,
                                     v_lam_bh.fa_ag,
                                     v_lam_bh.fa_upos);
      if v_menge != v_lam_bh.menge - in_menge
      then
        update lvs_lam_bh t
           set t.menge = v_lam_bh.menge - in_menge
         where t.lam_id = v_lam_bh.lam_id
           and t.buch_datum >= v_sysdate
           and t.menge = v_menge;
      end if;
    end if;
    v_lgr_platz := null;

    lvs_c_lam_sperren_neue_lte(in_lte_id,          -- in lvs_lhm.Lte_Id%TYPE,
                               in_lhm_id,          -- in lvs_lhm.Lhm_Id%TYPE,
                               in_lam_id,          -- in lvs_lam.Lam_Id%TYPE,
                               in_lam_bh_id,       -- in lvs_lam_bh.lam_bh_id%TYPE,
                               in_user_ID,         -- in isi_user.login_id%TYPE,
                               in_lgr_ort,         -- in lvs_lgr_ort.lgr_ort%type,
                               v_lgr_platz,        -- in lvs_lgr.lgr_platz%type,
                               in_drucker_name);   -- in varchar2)

  end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure erstellt eine LAM und bucht diese mit BUS7 (Gesperrt abgang) aus
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_c_lam_sperren_neue_lte(in_lte_id       in lvs_lhm.Lte_Id%TYPE,
                                       in_lhm_id       in lvs_lhm.Lhm_Id%TYPE,
                                       in_lam_id       in lvs_lam.Lam_Id%TYPE,
                                       in_lam_bh_id    in lvs_lam_bh.lam_bh_id%TYPE,
                                       in_user_ID      in isi_user.login_id%TYPE,
                                       in_lgr_ort      in lvs_lgr_ort.lgr_ort%type,
                                       in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                       in_drucker_name in varchar2) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    -------------------------------------------------------------------------------------------------------
    v_lam_bh lvs_lam_bh%rowtype;
    v_lam    lvs_lam%rowtype;
    v_lte    lvs_lte%rowtype;
    v_lhm    lvs_lhm%rowtype;
    v_charge lvs_charge%rowtype;
    v_status lvs_lam.labor_status%type;
    v_platz  lvs_lam.lgr_platz%type;

    v_lte_id lvs_lte.lte_id%type;
    v_lhm_id lvs_lhm.lte_id%type;
    v_lam_id lvs_lam.lte_id%type;
    v_vorg_id lvs_lam_bh.vorg_id%type;

    v_pe_job_nr number;

    v_found boolean;

    cursor c_lam_bh is
      select *
        from lvs_lam_bh lam_bh
       where lam_bh.lam_bh_id = in_lam_bh_id;

    cursor c_lam is
      select * from lvs_lam lam where lam.lam_id = in_lam_id;

    cursor c_lte is
      select * from lvs_lte lte where lte.lte_id = in_lte_id;

    cursor c_lhm is
      select * from lvs_lhm lhm where lhm.lhm_id = in_lhm_id;

    CURSOR c_charge is
      select t.*
        from lvs_charge t
       where t.charge_id = v_lam.charge_id;
  begin

    OPEN c_lam_bh;
    FETCH c_lam_bh
      into v_lam_bh;
    v_found := c_lam_bh%FOUND;
    CLOSE c_lam_bh;

    if not v_found
    then
      v_err_nr   := 10;
      v_err_text := LC.ec(LC.O_TXT_BUCH_ERR_VERBRAUCH);
      RAISE v_error;
    end if;

    OPEN c_lam;
    FETCH c_lam
      into v_lam;
    v_found := c_lam%FOUND;
    CLOSE c_lam;

    if not v_found
    then
      v_err_nr   := 11;
      v_err_text := LC.ec(LC.O_TXT_LAGERBEST_N_LESBAR) || ' <' || to_char(in_lam_id) || '>';
      RAISE v_error;
    end if;

    OPEN c_lhm;
    FETCH c_lhm
      into v_lhm;
    CLOSE c_lhm;

    OPEN c_lte;
    FETCH c_lte
      into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found
    then
      v_err_nr   := 20;
      v_err_text := LC.ec_p1(LC.O_TP1_Q_LTE_ID_FEHLT, in_lte_id);
      RAISE v_error;
    end if;

    -- Erstmal die
    update lvs_lam_bh bh
       set bh.menge = 0
     where bh.lam_bh_id = in_lam_bh_id;

    OPEN c_charge;
    FETCH c_charge into v_charge;
    CLOSE c_charge;

    v_lte_id := NULL; -- INIT keine LTE_ID
    v_lte_id := lvs_p_lte.lvs_lte_insert_v358 (v_lam_bh.sid,
                                               v_lam_bh.firma_nr,
                                               v_lte.lte_name,
                                               v_lte_id,
                                               in_user_id,
                                               in_lgr_ort,
                                               in_lgr_platz,
                                               C.LTE_BF_STAT,
                                               null,
                                               'SD',
                                               v_charge.charge_id,
                                               v_charge.charge_bez,
                                               v_lam.artikel_id,
                                               v_lte.packschema_kopf_id,
                                               null,                    -- Auto Depal ist unbekannt
                                               null,                    -- wickelprogramm ist unbekannt,
                                               null);                   -- wickelprogramm_einl ist unbekannt

    lvs_p_lte.lvs_korr_te_einbuchen(v_lam_bh.sid,
                                    v_lam_bh.firma_nr,
                                    v_lte_id,
                                    NULL,
                                    v_lam_bh.sid,
                                    v_lam_bh.firma_nr,
                                    NULL,  -- in_lgr_ort, -- Wird nicht verwendet
                                    v_lam_bh.lgr_platz,
                                    -1,
                                    False);

    v_lhm_id := null;
    lvs_komm.lvs_komm_direct(v_lam_bh.sid,
                             v_lam_bh.firma_nr,
                             v_lam_bh.res_id,
                             in_user_id,
                             in_lte_id,
                             in_lam_id,
                             v_lam_bh.menge,
                             v_lte_id,
                             v_lam_id,
                             v_lhm_id);


    begin

      v_pe_job_nr := lvs_p_lte.lvs_lte_drucken(v_lte_id, -- in_lte_id       in lvs_lte.lte_id%type,
                                               NULL, -- in_kunden_nr    in isi_adressen.adr_nr%type,
                                               in_drucker_name); -- in_drucker_name in pe_drucker_cfg.drucker_name%type
    exception
      when others then
        isi_p_log.c_isi_system_meldung(v_lam_bh.sid,
                                       v_lam_bh.firma_nr,
                                       'lvs_lte_drucken', 'LVS', 'Log', null, null, null, null,
                                       null, 'Automatisches Buchen auf Drucker: (' || in_drucker_name || ') nicht möglich', '5');

    end;

    if c.C_TRUE =
          isi_allg.get_firma_cfg_param (v_lam_bh.sid,
                                        v_lam_bh.firma_nr,
                                        'LTE_SPERRE',
                                        null,
                                        'LVS_LTE_AUSBUCHEN',
                                        'LVS',
                                        'CFG',
                                        'T',
                                        'BOOLEAN')
    then
      v_status         := c.LAB_STAT_Q;
    else
      v_status         := c.LAB_STAT_G;
    end if;
    commit;
    lvs_c_lam_status(v_lam_id,
                     in_user_id,
                     v_vorg_id,
                     v_status,
                     c.LAB_STAT_TXT_G);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end lvs_c_lam_sperren_neue_lte;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure erstellt eine LAM und bucht diese mit BUS7 (Gesperrt abgang) aus
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_c_lam_status(in_lam_id       in lvs_lhm.Lte_Id%TYPE,
                             in_user_ID      in isi_user.login_id%TYPE,
                             in_out_vorg_id  in out lvs_lam_bh.vorg_id%TYPE,
                             in_labor_status in lvs_lam.labor_status%type,
                             in_labor_text   in lvs_lam.labor_text%type) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    -------------------------------------------------------------------------------------------------------
    v_lam lvs_lam%rowtype;
    v_lte lvs_lte%rowtype;
    v_lhm lvs_lhm%rowtype;

    --v_lte_id    lvs_lte.lte_id%type;
    --v_lhm_id    lvs_lhm.lte_id%type;
    v_lam_id    lvs_lam.lte_id%type;
    v_lam_bh_id lvs_lam_bh.lam_bh_id%type;

    v_found boolean;

    cursor c_lam is
      select * from lvs_lam lam where lam.lam_id = in_lam_id;

    cursor c_lte is
      select * from lvs_lte lte where lte.lte_id = v_lam.lte_id;

    cursor c_lhm is
      select * from lvs_lhm lhm where lhm.lhm_id = v_lam.lhm_id;
    pragma autonomous_transaction;
  begin

    OPEN c_lam;
    FETCH c_lam
      into v_lam;
    v_found := c_lam%FOUND;
    CLOSE c_lam;

    if not v_found
    then
      v_err_nr   := 10;
      v_err_text := LC.ec(LC.O_TXT_LAGERBEST_N_LESBAR) || ' <' || to_char(in_lam_id) || '>';
      RAISE v_error;
    end if;

    OPEN c_lhm;
    FETCH c_lhm
      into v_lhm;
    CLOSE c_lhm;

    OPEN c_lte;
    FETCH c_lte
      into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found
    then
      v_err_nr   := 20;
      v_err_text := LC.ec_p1(LC.O_TP1_Q_LTE_ID_FEHLT, v_lam.lte_id);
      RAISE v_error;
    end if;

    -- Erstmal den Text aktuallisieren
    update lvs_lam lam
       set lam.labor_text   = in_labor_text,
           lam.labor_status = in_labor_status
     where lam.lam_id = in_lam_id;

    if v_lam.labor_status != in_labor_status
       and v_lam.menge != 0
    then
      if v_lam.labor_status != 'F' -- Status F ==> Freigegeben
         and in_labor_status = 'F'
      then
        v_lam.menge  := v_lam.menge * -1;
        v_lam.lam_kg := v_lam.lam_kg * -1;
      elsif v_lam.labor_status = 'F' -- Status F ==> Freigegeben
            and in_labor_status != 'F'
      then
        v_lam.menge  := v_lam.menge;
        v_lam.lam_kg := v_lam.lam_kg;
      else
        v_lam.menge := 0;
      end if;

      if v_lam.menge != 0
      then
        v_err_nr   := 30;
        v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
        select seq_lam_bh.nextval into v_lam_bh_id from dual;
        v_err_nr   := NULL;
        v_err_text := NULL;
        if in_out_vorg_id is NULL
        then
          v_err_nr   := 40;
          v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
          select seq_vorg_id.nextval into in_out_vorg_id from dual;
          v_err_nr   := NULL;
          v_err_text := NULL;
        end if;
        v_err_nr   := 50;
        v_err_text := LC.ec_p2(LC.O_TP2_BUC_LAM_BH_ERR, v_lam_bh_id, v_lam_id);
        -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
        insert into lvs_lam_bh
        values
          (v_lam.sid,
           v_lam.firma_nr,
           in_out_vorg_id,
           c.LAM_BH_SPRERE,
           v_lam_bh_id,
           in_lam_id,
           v_lam.artikel_id,
           c.LAM_BH_BUS_SP,
           sysdate,
           in_user_ID,
           v_lam.lgr_platz,
           v_lam.lte_id,
           v_lam.lhm_id,
           v_lam.charge_id,
           v_lam.serie_id,
           null,
           v_lam.menge,
           v_lam.lam_kg,
           v_lam.lam_kg / v_lam.menge,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           sysdate,                     -- CREATED_DATE N DATE  Y     creation date+time of this dataset
           in_user_id,                  -- CREATED_LOGIN_ID N NUMBER  Y     login id of the user creating this dataset
           sysdate,                     -- LAST_CHANGE_DATE N DATE  Y     change date+time of this dataset
           in_user_id,                  -- LAST_CHANGE_LOGIN_ID N NUMBER  Y     login id of the user changing this dataset
           null,                        -- CHANGE_MENGE N NUMBER  Y     Menge die geändert wurde
           v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
           null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
        v_err_nr   := NULL;
        v_err_text := NULL;
      end if;
    end if;

    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end lvs_c_lam_status;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure erstellt eine LAM und bucht diese mit BUS7 (Gesperrt abgang) aus
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_c_lhm_sperre_abpack(in_sid          in isi_sid.sid%type,
                                    in_firma_nr     in isi_firma.firma_nr%type,
                                    in_lhm_id       in lvs_lhm.Lte_Id%TYPE,
                                    in_scanner_name in isi_scanner_cfg.scanner_name%TYPE,
                                    in_out_vorg_id  in out lvs_lam_bh.vorg_id%TYPE,
                                    in_labor_status in lvs_lam.labor_status%type,
                                    in_labor_text   in lvs_lam.labor_text%type) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    -------------------------------------------------------------------------------------------------------

    v_lam         lvs_lam%rowtype;
    v_lhm         lvs_lhm%rowtype;
    v_scanner_cfg isi_scanner_cfg%rowtype;
    v_art         isi_artikel%rowtype; -- Artikeldaten

    v_labor_status lvs_lam.labor_status%type;
    v_labor_text   lvs_lam.labor_text%type;

    CURSOR c_lam is
      select lam.* from lvs_lam lam where lam.lhm_id = in_lhm_id;

    CURSOR c_lhm is
      select lhm.* from lvs_lhm lhm where lhm.lhm_id = in_lhm_id;

    CURSOR c_scanner_cfg is
      select sc.*
        from isi_scanner_cfg sc
       where sc.sid = in_sid
         and sc.firma_nr = in_firma_nr
         and sc.scanner_name = in_scanner_name;

    CURSOR c_art is -- Lesen des Artikels
      select *
        from isi_artikel art
       where art.sid = v_lam.sid
         and art.artikel_id = v_lam.artikel_id;

  begin

    if in_labor_status is NULL
    then
      v_labor_status := 'G';
    else
      v_labor_status := in_labor_status;
    end if;

    if in_labor_text is NULL
    then
      v_labor_text := substr('SCANNER ' || in_scanner_name,0,30);    -- MWe 20190709 Ticket: P70762-20
    else
      v_labor_text := in_labor_text;
    end if;

    OPEN c_scanner_cfg;
    FETCH c_scanner_cfg
      into v_scanner_cfg;
    -- Aufruf kommt von einem SLS-Terminal, dann stheht die login ID im Vorgang-ID
    -- Vorgang-ID muss dann neu geholt werden (IsNULL)
    if c_scanner_cfg%NOTFOUND
    then
      v_scanner_cfg.ls_login_id := in_out_vorg_id;
      in_out_vorg_id := NULL;
    end if;
    CLOSE c_scanner_cfg;

    OPEN c_lam;
    LOOP
      FETCH c_lam into v_lam;
      EXIT when c_lam%NOTFOUND;
      v_art := NULL;
      OPEN c_art;
      FETCH c_art into v_art;
      CLOSE c_art;
      lvs_c_lam_status(v_lam.lam_id,
                       v_scanner_cfg.ls_login_id,
                       in_out_vorg_id,
                       v_labor_status,
                       v_labor_text);
    end LOOP;
    CLOSE c_lam;
    OPEN c_lhm;
    FETCH c_lhm
      into v_lhm;
    CLOSE c_lhm;
    lvs_lhm_abpacken(v_lhm, v_scanner_cfg.ls_login_id, 'B', v_art, v_lam.kunden_nr);
    -------------------------------------------------------------------------------------------------------
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
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
  end lvs_c_lhm_sperre_abpack;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure Legt eine LHM von einer oder keiner Palette auf eine andere
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_c_lhm_umpacken(in_sid      in isi_sid.sid%type,
                               in_firma_nr in isi_firma.firma_nr%type,
                               in_user_id  in isi_user.login_id%type,
                               in_res_id   in isi_resource.res_id%type,
                               in_lhm_id   in lvs_lhm.Lhm_Id%TYPE,
                               in_lte_id   in lvs_lte.lte_id%type) is
  begin
    lvs_lhm_umpacken(in_sid, in_firma_nr, in_user_id, in_res_id, in_lhm_id, in_lte_id);

    commit;
  end;

  function lvs_c_lhm_drucken_bde (in_lhm_id       in lvs_lam.lhm_id%type,
                                  in_drucker_name in pe_drucker_cfg.drucker_name%type)
                                  return integer is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;                 --
    v_err_nr    number;
    v_err_text  varchar2(255);

    v_kunde_nr  lvs_lam.kunden_nr%type;

    Result number;
  begin
    v_kunde_nr := lvs_util.get_lam_kunde_by_lhm_id(in_lhm_id);

    Result := lvs_p_lte.lvs_lte_drucken (in_lhm_id, v_kunde_nr, in_drucker_name);

    COMMIT;

    return(Result);
    -------------------------------------------------------------------------------------------------------
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end LVS_C_LHM_DRUCKEN_BDE;

  procedure lvs_lhm_umpacken(in_sid            in isi_sid.sid%type,
                             in_firma_nr       in isi_firma.firma_nr%type,
                             in_user_id        in isi_user.login_id%type,
                             in_res_id         in isi_resource.res_id%type,
                             in_lhm_id         in lvs_lhm.Lhm_Id%TYPE,
                             in_lte_id         in lvs_lte.lte_id%type) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    -------------------------------------------------------------------------------------------------------

    v_lhm lvs_lhm%rowtype;
    v_lam lvs_lam%rowtype;
    v_lte lvs_lte%rowtype; -- LagerTransporteinheit des Materials

    v_lte_cfg           lvs_lte_cfg%rowtype;-- Cfg Der LTE (Palette)
    v_firma             isi_firma%rowtype;
    v_packschema_kopf   lvs_packschema_kopf%rowtype;

    v_anz_lagen         number(3);         -- Anzahl der Lagen auf der LTE (Palette)
    v_lte_akt_lhm       number(3);         -- Aktuelle LHM's auf LTE

    v_art    isi_artikel%rowtype; -- Artikeldaten
    v_art_kd isi_artikel_kunde%rowtype;

    v_art_lte_hoehe_max    v_art.lte_hoehe_max%type;
    v_art_lte_breite_max   v_art.lte_breite_max%type;
    v_art_lte_tiefe_max    v_art.lte_tiefe_max%type;
    v_art_lhm_hoehe_lage   v_art.lhm_hoehe_lage%type;
    v_art_lte_lhm_menge    v_art.lte_lhm_menge%type;
    v_art_lte_lhm_pro_lage v_art.lte_lhm_pro_lage%type;
    v_art_lte_lhm_lagen    v_art.lte_lhm_lagen%type;
    v_lte_last_hoehe       lvs_lte.lte_vol_hoehe%type;
    v_lte_LHM_last_hoehe    lvs_lte.lte_vol_hoehe%type;
    v_dif_frei_hoehe       lvs_lte.lte_vol_hoehe%type;

    v_vorg_id   lvs_lam_bh.vorg_id%TYPE; -- Neu VORGang_ID aus Sequenz
    v_vorg_typ  lvs_lam_bh.vorg_typ%type; -- Typ des Vorgangs (UL, LZ ...)
    v_lam_bh_id lvs_lam_bh.lam_bh_id%type;
    v_lam_kg    number;
    v_lam_ges_menge    number;
    v_res_mhd   date; -- Datum gleiches MHD

    v_lgr_q         lvs_lgr%rowtype; -- Lagerplatz Quelle
    v_lgr_z         lvs_lgr%rowtype; -- Lagerplatz Ziel
    v_lgr_platz     lvs_lgr.lgr_platz%type; -- Lagerplatz für CURSOR
    v_art_lte_menge number;

    v_order_pos isi_order_pos%rowtype;
    v_found     boolean;
    v_lte_id    lvs_lte.lte_id%type;
    v_q_lte_id  lvs_lte.lte_id%type;
    v_lam_anz   number;                     -- Anzahl der LAMS auf der Palette

    cursor c_art is -- Lesen des Artikels
      select *
        from isi_artikel art
       where art.sid = v_lam.sid
         and art.artikel_id = v_lam.artikel_id;

    cursor c_art_kd is
      select *
        from isi_artikel_kunde ak
       where ak.sid = v_lam.sid
         and ak.artikel_id = v_lam.artikel_id
         and ak.kunden_nr = v_lam.kunden_nr;

    CURSOR c_lhm is
      select lhm.* from lvs_lhm lhm where lhm.lhm_id = in_lhm_id;

    CURSOR c_lam is
      select lam.* from lvs_lam lam where lam.lhm_id = in_lhm_id;

    cursor c_lte is -- Lesen der Transporteinheit
      select * from lvs_lte lte
       where lte.lte_id = v_lte_id;

    cursor c_lgr is
      select * from lvs_lgr lgr where lgr.lgr_platz = v_lgr_platz;

    CURSOR c_order_pos is
      select *
        from isi_order_pos pos
       where pos.vorgang_id = v_lte.order_vorgang_id
         and pos.artikel_id = v_lam.artikel_id
         and pos.soll_menge < pos.ist_menge;

    CURSOR c_firma is
      select *
        from isi_firma f
       where f.sid = in_sid
         and f.firma_nr = in_firma_nr;

    v_lte_cfg_found boolean;

  begin

    v_lte_LHM_last_hoehe := NULL;

    OPEN c_firma;
    FETCH c_firma into v_firma;
    CLOSE c_firma;

    OPEN c_lhm;
    FETCH c_lhm
      into v_lhm;
    v_found := c_lhm%FOUND;
    CLOSE c_lhm;

    if not v_found
    then
      v_err_nr   := 01;
      v_err_text := LC.ec_p1(LC.O_TP1_LHM_ID_FEHLT, nvl(in_lhm_id, 'NULL'));
      raise v_error;
    end if;

    if in_lte_id = v_lhm.lte_id -- ist bereits auf der Palette
    then
      return; -- Dann kein Fehler melden und nichts machen
    end if;

    /*----------------------------------------------------------------------------------------------------------------
    * Abpacken der Packstuecke (LHM)
    -----------------------------------------------------------------------------------------------------------------*/

    v_err_nr   := 10;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_vorg_id.nextval into v_vorg_id from dual;
    v_err_nr   := NULL;
    v_err_text := NULL;
    v_vorg_typ := c.LAM_BH_UMPACKEN;

    v_lgr_platz       := v_lhm.lgr_platz;
    v_lgr_q           := NULL;
    v_lgr_q.lgr_platz := NULL;

    if v_lgr_platz is NULL
    then
      v_err_nr   := 15;
      v_err_text := LC.ec_p1(LC.O_TP1_LHM_ID_N_IM_LAGER,  nvl(in_lhm_id, 'NULL'));
      raise v_error;
    end if;

    OPEN c_lgr;
    FETCH c_lgr
      into v_lgr_q;
    CLOSE c_lgr;
    v_lam_anz := 0;                                       -- 0 LAMs umgepackt

    OPEN c_lam;
    LOOP
      FETCH c_lam
        into v_lam;
      EXIT when c_lam%NOTFOUND;
      v_lam_anz := v_lam_anz + 1;                         -- Ein weiteres umgepackt
      v_err_nr   := 20;
      v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
      select seq_lam_bh.nextval into v_lam_bh_id from dual;
      v_err_nr   := NULL;
      v_err_text := NULL;
      begin
        v_lam_kg := v_lam.lam_kg / v_lam.menge;
      exception
        when others then
          v_lam_kg := 0;
      end;

      -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
      insert into lvs_lam_bh
      values
        (v_lam.sid,
         v_lam.firma_nr,
         v_vorg_id,
         v_vorg_typ,
         v_lam_bh_id,
         v_lam.lam_id,
         v_lam.artikel_id,
         C.LAM_BH_BUS_UP,
         sysdate,
         in_user_id,
         v_lam.lgr_platz,
         v_lam.lte_id,
         v_lam.lhm_id,
         v_lam.charge_id,
         v_lam.serie_id,
         null,
         v_lam.menge * -1,
         v_lam.lam_kg * -1,
         v_lam_kg,
         in_res_id,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         sysdate,                     -- CREATED_DATE N DATE  Y     creation date+time of this dataset
         in_user_id,                  -- CREATED_LOGIN_ID N NUMBER  Y     login id of the user creating this dataset
         sysdate,                     -- LAST_CHANGE_DATE N DATE  Y     change date+time of this dataset
         in_user_id,                  -- LAST_CHANGE_LOGIN_ID N NUMBER  Y     login id of the user changing this dataset
         null,                        -- CHANGE_MENGE N NUMBER  Y     Menge die geändert wurde
         v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
         null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

      -- -AG- 2015.08.10 Buchen in der KOMM_ORDER wenn Auftrag vorhanden
      update isi_komm_order t
         set t.komm_ist_menge = nvl(t.komm_ist_menge, 0) + v_lam.menge
       where t.auf_id = v_lam.order_pos_auf_id
         and t.lte_id = v_lam.lte_id
         and nvl(t.komm_ziel_lte_id, in_lte_id) = in_lte_id;

      OPEN c_art;
      FETCH c_art
        into v_art;
      CLOSE c_art;

      v_lte_id := v_lam.lte_id;
      v_q_lte_id := v_lam.lte_id;
      OPEN c_lte;
      FETCH c_lte into v_lte;
      CLOSE c_lte;
      if v_lam.order_pos_auf_id is not NULL
      and v_lte.order_vorgang_id is NULL
      and v_lte.lte_status = c.LTE_AF_STAT
      then
        update isi_order_pos pos
           set pos.ist_menge = pos.ist_menge + (nvl(v_lam.menge, 0) * -1),
               pos.brutto_kg = pos.brutto_kg + (nvl(v_lam.lam_kg, 0) * -1)
         where pos.auf_id = v_lam.order_pos_auf_id
           and pos.satzart in ('MA');
      end if;
      if v_lam.order_pos_auf_id is not NULL
      then
        if  isi_p_order_base.get_order_pos(in_sid, v_lam.order_pos_auf_id, v_order_pos)
        and v_order_pos.satzart in ('LNK', 'MAK')
        then
          update isi_order_pos pos
             set pos.ist_menge = pos.ist_menge + (nvl(v_lam.menge, 0)),
                 pos.brutto_kg = pos.brutto_kg + (nvl(v_lam.lam_kg, 0)),
                 pos.status = case when (pos.ist_menge + (nvl(v_lam.menge, 0)) >= pos.soll_menge)
                              then 'X'
                              else pos.status
                              end
           where pos.auf_id = v_lam.order_pos_auf_id
             and pos.satzart in ('LNK', 'MAK');
        end if;
      end if;
    end LOOP;
    CLOSE c_lam;


    if lvs_p_base.get_lte_cfg(v_lte.sid, v_lte.lte_name, v_lte_cfg)
    and v_lte_cfg.basis_lte_name = 'LHM'
    then
      v_lte_LHM_last_hoehe := v_lte.lte_vol_hoehe;       -- Höhe merken (LHM).
    end If;

    lvs_lhm_abpacken(v_lhm, in_user_ID, NULL, v_art, v_lam.kunden_nr);

    /*----------------------------------------------------------------------------------------------------------------
    * Aufpacken der Packstuecke (LHM) auf eine LTE
    -----------------------------------------------------------------------------------------------------------------*/
    v_lte_id := in_lte_id;
    OPEN c_lte;
    FETCH c_lte
      into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;
    -- Merken in init
    v_lte_last_hoehe := v_lte.lte_vol_hoehe;
    v_anz_lagen      := 0;

    if not v_found
    and v_lhm.lte_id is not NULL
    then
      v_err_nr   := 21;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
      raise v_error;
    end if;
    if v_lte.lgr_platz is NULL
    then
      v_err_nr   := 22;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_OHNE_LGR_PLATZ, in_lte_id);
      raise v_error;
    end if;

    v_lte_cfg := NULL;
    v_lte_cfg.basis_lte_name := NULL;
    v_lte_cfg_found := lvs_p_base.get_lte_cfg(v_lte.sid, v_lte.lte_name, v_lte_cfg);

    v_lgr_platz       := v_lte.lgr_platz;
    v_lgr_z           := NULL;
    v_lgr_z.lgr_platz := NULL;
    v_lgr_z := NULL;
    OPEN c_lgr;
    FETCH c_lgr
      into v_lgr_z;
    CLOSE c_lgr;

    OPEN c_lam;
    LOOP
      FETCH c_lam into v_lam;
      EXIT when c_lam%NOTFOUND;
      v_err_nr   := 25;
      v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
      select seq_lam_bh.nextval into v_lam_bh_id from dual;
      v_err_nr   := NULL;
      v_err_text := NULL;
      begin
        v_lam_kg := v_lam.lam_kg / v_lam.menge;
      exception
        when others then
          v_lam_kg := 0;
      end;
      OPEN c_art; --
      FETCH c_art
        into v_art; -- Hole dei Artikeldaten
      CLOSE c_art; --

      if nvl(v_lte.min_temp, -1000) < v_art.min_temp
      then
        v_lte.min_temp := v_art.min_temp; -- Artikel hat höhere MIN Temperatur
      end if;

      if nvl(v_lte.max_temp, 1000) > v_art.max_temp
      then
        v_lte.max_temp := v_art.max_temp; -- Artikel hat höhere MAX Temperatur
      end if;

      if v_art.lte_name = v_lte.lte_name -- Wenn der LTE-Typ gleich dem Default im Artikel entspricht
      then                               -- Dann gibt es evtl. Einen Ueberstand des Palettenmass (In Artikel xx_max definiert)
        if nvl(v_lte.lte_vol_hoehe, 0) < v_art.lte_hoehe_max
        then
          v_lte.lte_vol_hoehe := v_art.lte_hoehe_max; -- Artikel kann hoeher werden
        end if;

        if nvl(v_lte.lte_vol_breite, 0) < v_art.lte_breite_max
        then
          v_lte.lte_vol_breite := v_art.lte_breite_max; -- Artikel kann breiter werden
        end if;

        if nvl(v_lte.lte_vol_tiefe, 0) < v_art.lte_tiefe_max
        then
          v_lte.lte_vol_tiefe := v_art.lte_tiefe_max; -- Artikel kann tiefer werden
        end if;
      end if;

      if v_lte.res_artikel_id is NULL
      then
        v_lte.res_artikel_id := to_char(v_art.artikel_id);
      end if;

      if v_lte.res_artikel_id != to_char(v_art.artikel_id)
      then
        v_lte.res_artikel_id := 'MP';
        v_lte.lte_voll       := 'A';
      end if;

      if nvl(v_lte.waren_typ, c.LEERPAL) = c.LEERPAL
      then
        v_lte.waren_typ := v_art.waren_typ;
      end if;

      if v_lte.waren_typ != v_art.waren_typ
      and v_lte.waren_typ != c.MISCHKANAL
      and v_art.einlagerung = 'AR' then
        v_lte.waren_typ :='MP';
      end if;

      if v_art.einlagerung != 'AR'
      then
        v_lte.waren_typ := c.MISCHKANAL;
      end if;

      v_lte.lte_voll := 'A';

      if v_lte.packschema_kopf_id is not NULL
      and lvs_p_base.get_packschema_kopf(in_sid,
                                         in_firma_nr,
                                         v_lte.packschema_kopf_id,
                                         v_packschema_kopf)
      then

        v_lte.lte_vol_tiefe := v_lte_cfg.lte_vol_tiefe + v_packschema_kopf.y_ueberstand_max;
        v_lte.lte_vol_breite := v_lte_cfg.lte_vol_breite + v_packschema_kopf.x_ueberstand_max;

      end if;

      if v_lte.waren_typ != 'MP'
      then
        if v_lte.packschema_kopf_id is not NULL
        then
          begin
            v_anz_lagen     := round(((v_lte.lte_akt_lhm + 1) /
                                      lvs_komm.get_packschema_max_lage(in_sid,
                                                                       in_firma_nr,
                                                                       v_lte.packschema_kopf_id)
                                                                       + 0.49),
                                     0);
          exception
            when others then
               v_anz_lagen     := 1;
          end;
          v_lte.lte_vol_hoehe := v_lte_cfg.lte_vol_hoehe +
                                  v_anz_lagen * v_lhm.lhm_vol_hoehe;
        else
          if v_lte_cfg.basis_lte_name = 'LHM'  -- Die Ziel-LTE ist ein Behaelter (LHM)
          then
            v_anz_lagen := 1;                  -- Ohne Packschema 1 Lage
            if nvl(v_lhm.lhm_vol_hoehe, 0) = 0 -- Die Hoehe der LHM ist falsch oder nicht gesetzt
            then
              v_lhm.lhm_vol_hoehe := v_art.lhm_hoehe_lage;  -- Dann aus Artikel übernehmen
            end if;
            v_lte.lte_vol_hoehe := v_lte_cfg.lte_vol_hoehe +
                                    v_lhm.lhm_vol_hoehe;   -- Neue Hoehe rechnen entweder aus der Quelle oder dem Artikel
          end if;
        end if;
        if nvl(v_lte.lte_vol_hoehe, 0) = 0
        then
          v_lte.lte_vol_hoehe := v_lte_last_hoehe;
        end if;

        begin
          if v_anz_lagen = 0
          then
            if nvl(v_art.lhm_name, 'keine') != nvl(v_lhm.lhm_name, 'keine')
            and v_lhm.lhm_name is not NULL
            then
              if not v_lte_cfg_found
              then
                v_lte_cfg.lte_vol_hoehe := 0;
              end if;

              v_art_lte_hoehe_max    := v_lte.lte_vol_hoehe;
              v_art_lte_breite_max   := v_lte.lte_vol_breite;
              v_art_lte_tiefe_max    := v_lte.lte_vol_tiefe;
              v_art_lhm_hoehe_lage   := v_lhm.lhm_vol_hoehe;

              v_anz_lagen := round(((v_lte.lte_vol_hoehe - v_lte_cfg.lte_vol_hoehe) /  v_lhm.lhm_vol_hoehe) + 0.49, 0);
              v_art_lte_lhm_lagen    := v_anz_lagen;

              v_art_lte_lhm_pro_lage := round(((v_lte.lte_vol_breite * v_lte.lte_vol_tiefe) /
                                              (v_lhm.lhm_vol_breite * v_lhm.lhm_vol_tiefe)),
                                              0);
            else
              v_art_lte_hoehe_max    := v_art.lte_hoehe_max;
              v_art_lte_breite_max   := v_art.lte_breite_max;
              v_art_lte_tiefe_max    := v_art.lte_tiefe_max;
              v_art_lhm_hoehe_lage   := v_art.lhm_hoehe_lage;
              v_art_lte_lhm_menge    := v_art.lte_lhm_menge;
              v_art_lte_lhm_pro_lage := v_art.lte_lhm_pro_lage;
              v_art_lte_lhm_lagen    := v_art.lte_lhm_lagen;

              OPEN c_art_kd;
              FETCH c_art_kd
                into v_art_kd;
              v_found := c_art_kd%FOUND;
              CLOSE c_art_kd;
              if v_found
              then
                v_art_lte_hoehe_max    := nvl(v_art_kd.lte_hoehe_max,
                                              v_art_lte_hoehe_max);
                v_art_lte_breite_max   := nvl(v_art_kd.lte_breite_max,
                                              v_art_lte_breite_max);
                v_art_lte_tiefe_max    := nvl(v_art_kd.lte_tiefe_max,
                                              v_art_lte_tiefe_max);
                v_art_lhm_hoehe_lage   := nvl(v_art_kd.lhm_hoehe_lage,
                                              v_art_lhm_hoehe_lage);
                v_art_lte_lhm_menge    := nvl(v_art_kd.lte_lhm_menge,
                                              v_art_lte_lhm_menge);
                v_art_lte_lhm_pro_lage := nvl(v_art_kd.lte_lhm_pro_lage,
                                              v_art_lte_lhm_pro_lage);
                v_art_lte_lhm_lagen    := nvl(v_art_kd.lte_lhm_lagen,
                                              v_art_lte_lhm_lagen);
              end if;

              begin
                if v_art_lhm_hoehe_lage is NULL
                then
                  v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe /
                                          nvl(v_art_lte_lhm_lagen, 1);
                end if;
              exception
                when others then
                   v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe;
                   if v_art_lhm_hoehe_lage > nvl(v_lhm.lhm_vol_hoehe, 2000)
                   then
                     v_art_lhm_hoehe_lage := nvl(v_lhm.lhm_vol_hoehe, 2000);
                   end if;
              end;

              if nvl(v_art_lte_lhm_pro_lage, 0) = 0
              then
                begin
                  if nvl(v_art_lte_lhm_menge / v_art_lte_lhm_lagen, 0) != 0
                  then
                    v_art_lte_lhm_pro_lage := v_art_lte_lhm_menge / v_art_lte_lhm_lagen;
                  else
                    v_art_lte_lhm_pro_lage := 1;
                  end if;
                exception
                  when others
                    then v_art_lte_lhm_pro_lage := 1;
                end;
              end if;


            end if;
            if v_art.menge_basis = c.BASIS_LTE
            then
              v_art_lte_menge := 1;
              v_anz_lagen     := v_art_lte_lhm_lagen;
            elsif v_art.menge_basis = c.BASIS_LHM
            then
              v_art_lte_menge := v_art_lte_lhm_menge;
              v_lte_akt_lhm   := lvs_p_lte_lhm.lvs_lte_lhm_best(v_lam.sid,
                                                                v_lam.firma_nr,
                                                                v_lam.lte_id,
                                                                'LTE');
              v_anz_lagen     := round((v_lte_akt_lhm / v_art_lte_lhm_pro_lage + 0.49),
                                       0);
            else
              v_art_lte_menge := v_art_lte_menge;
              -- 08.10.2008 -AG- BugFix: Falsche berechnung der Hoehe, da Klammer fehlte
              v_anz_lagen     := round(((v_lte.lte_akt_lhm + 1) /
                                       v_art_lte_lhm_pro_lage) + 0.49,
                                       0);
            end if;
          end if;
        exception
          when others
            then v_art_lte_lhm_lagen := 1;
            v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe;
            if v_art_lhm_hoehe_lage > nvl(v_lhm.lhm_vol_hoehe, 2000)
            then
              v_art_lhm_hoehe_lage := nvl(v_lhm.lhm_vol_hoehe, 2000);
            end if;
        end;

        if lvs_p_lte_lhm.lvs_lte_lhm_best(v_lam.sid,
                                          v_lam.firma_nr,
                                          v_lam.lte_id,
                                          'LTE') >= (v_art_lte_menge * v_firma.proz_anbruch / 100)
           or v_art.waren_typ = c.ROHWARE
           or v_anz_lagen = 0
        then
          if nvl(v_art.lhm_name, 'keine') != nvl(v_lhm.lhm_name, 'keine')
          and v_lhm.lhm_name is not NULL
          and nvl(v_lte_cfg.lte_vol_hoehe_fest, c.c_false) = c.c_false
          and v_lte.packschema_kopf_id is NULL
          and v_anz_lagen > 0
          then
             v_lte.lte_vol_hoehe := v_lte_cfg.lte_vol_hoehe +
                                   v_anz_lagen * v_art_lhm_hoehe_lage;
          end if;
          v_lte.lte_voll := 'V';
        else
          if not v_lte_cfg_found
          then
            v_lte_cfg.lte_vol_hoehe := 0;
          end if;
          if nvl(v_lte_cfg.lte_vol_hoehe_fest, c.c_false) = c.c_false
          and v_lte.packschema_kopf_id is NULL
          and v_anz_lagen > 0
          then
            v_lte.lte_vol_hoehe := v_lte_cfg.lte_vol_hoehe +
                                   v_anz_lagen * v_art_lhm_hoehe_lage;
          end if;
          v_lte.lte_voll      := 'A';
        end if;
      end if;

      v_res_mhd := v_lte.res_mhd; -- MHD für Gruppe


      if v_lte.res_string_statisch is null
      then
        v_lte.res_string := lvs_util.get_res_string_v359(v_lam.sid,
                                                         v_lam.firma_nr,
                                                         v_lte.waren_typ,
                                                         v_lte.res_artikel_id,
                                                         v_lam.hersteller_kuerzel_liste,
                                                         v_lam.fa_ag,
                                                         v_lam.charge_id,
                                                         v_lam.serie_id,
                                                         v_lam.leitzahl,
                                                         v_lam.kunden_nr,
                                                         v_lam.lieferant_nr,
                                                         v_lam.best_nr,
                                                         v_lam.lam_mhd,
                                                         1,
                                                         v_lam.labor_status,
                                                         v_lte.lte_voll,
                                                         v_lam.owner_address_id,
                                                         v_res_mhd);
      else
        v_lte.res_string := v_lte.res_string_statisch;
      end if;

      v_lte.res_mhd := v_res_mhd; -- MHD für Gruppe

      if v_art.gefahren_klasse > nvl(v_lte.gefahren_klasse, -1)
      then
        v_lte.gefahren_klasse := v_art.gefahren_klasse;
      end if;
      if v_art.wert_klasse > nvl(v_lte.wert_klasse, -1)
      then
        v_lte.wert_klasse := v_art.wert_klasse;
      end if;

      -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
      insert into lvs_lam_bh
      values
        (v_lam.sid,
         v_lam.firma_nr,
         v_vorg_id,
         v_vorg_typ,
         v_lam_bh_id,
         v_lam.lam_id,
         v_lam.artikel_id,
         C.LAM_BH_BUS_UP,
         sysdate,
         in_user_id,
         v_lte.lgr_platz,
         in_lte_id,
         v_lam.lhm_id,
         v_lam.charge_id,
         v_lam.serie_id,
         null,
         v_lam.menge,
         v_lam.lam_kg,
         v_lam_kg,
         in_res_id,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         sysdate,                     -- CREATED_DATE N DATE  Y     creation date+time of this dataset
         in_user_id,                  -- CREATED_LOGIN_ID N NUMBER  Y     login id of the user creating this dataset
         sysdate,                     -- LAST_CHANGE_DATE N DATE  Y     change date+time of this dataset
         in_user_id,                  -- LAST_CHANGE_LOGIN_ID N NUMBER  Y     login id of the user changing this dataset
         null,                        -- CHANGE_MENGE N NUMBER  Y     Menge die geändert wurde
         v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
         null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

      -- -AG- Neue LTE-Nr. übergeben
      v_lam.lte_id := in_lte_id;
      s_schnittstelle.write_host_bew(NULL,
                                     v_lam,
                                     v_lam_bh_id,
                                     C.LAM_BH_BUS_UP,
                                     c.LAM_BH_UMLAG,
                                     NULL,
                                     'UE',
                                     v_lgr_q,
                                     v_lgr_z,
                                     in_user_id);
      OPEN c_order_pos;
      FETCH c_order_pos
        into v_order_pos;
      v_found := c_order_pos%FOUND;
      CLOSE c_order_pos;

      if v_found
      and v_lte.lte_status = c.LTE_AF_STAT
      then
        /* Dass ist Quatsch. Hier darfg nur gezielt ein UPDATE stattfinden
        update isi_order_pos pos
           set pos.ist_menge = pos.ist_menge + v_lam.menge,
               pos.brutto_kg = pos.brutto_kg + v_lam.lam_kg
         where pos.vorgang_id = v_lte.order_vorgang_id
           and pos.artikel_id = v_lam.artikel_id
           and pos.soll_menge < pos.ist_menge;
        */
        -- -AG- 2016.07.26 Korrekt umbuchen und
        update isi_order_pos pos
           set pos.ist_menge = pos.ist_menge + nvl(v_lam.menge, 0),
               pos.brutto_kg = pos.brutto_kg + nvl(v_lam.lam_kg, 0)
         where pos.auf_id = v_lam.order_pos_auf_id
           and pos.satzart in ('MA');
      else
        v_order_pos.auf_id := NULL;
      end if;

      -- ?? Warum vor dem Aufpacken die LTE ID zuweisen?
      update lvs_lam lam
         set lam.lte_id           = v_lte.lte_id
       where lam.lhm_id = v_lhm.lhm_id;

    end LOOP;
    CLOSE c_lam;

    -- -AG- !! 20.11.2006 Bugfix: LTE Hoehe war hier auch NULL
    v_lte.lte_vol_hoehe := nvl(v_lte.lte_vol_hoehe, v_lte_last_hoehe);

    -- -AG- Neue Hoehe rechnen nur wenn LHM-Name != NULL
    -- oder das Rechnen gewünscht ist
    if (v_lhm.lhm_name is NULL
      and c.C_FALSE =
          isi_allg.get_firma_cfg_param (in_sid,
                                        in_firma_nr,
                                        'LTE_CALC_HOEHE_UMPACKEN',
                                        null,
                                        'LHM_NULL',
                                        'LVS',
                                        'CFG',
                                        'T',
                                        'BOOLEAN'))
    or  c.C_TRUE =
        isi_allg.get_firma_cfg_param (in_sid,
                                      in_firma_nr,
                                      'LTE_CALC_HOEHE_UMPACKEN',
                                      null,
                                      'NIE',
                                      'LVS',
                                      'CFG',
                                      'F',
                                      'BOOLEAN')
    then
      v_lte.lte_vol_hoehe := nvl(v_lte_last_hoehe, 15);
    end if;

    if v_lte_cfg_found
    and v_lte_cfg.basis_lte_name = 'LHM'
    and v_lte_LHM_last_hoehe is not NULL
    then
      v_lte.lte_vol_hoehe := v_lte_LHM_last_hoehe;       -- Gemerkte Höhe (LHM) jetzt hier eintragen.
    end If;

    if v_lgr_z.lgr_typ = c.REG_FACH1
    or v_lgr_z.lgr_typ = c.STAP_FLAE1
    or v_lgr_z.lgr_typ = c.STAP_FLAE2
    then
      -- -WK- 31.10.2006 Bugfix: Freie hoehe auf lagerplatz war NULL
      v_dif_frei_hoehe := nvl(v_lte.lte_vol_hoehe, 0) - nvl(v_lte_last_hoehe, 0);
    else
      v_dif_frei_hoehe := 0;
    end if;

    lvs_lhm_aufpacken(v_lhm, v_lte, v_dif_frei_hoehe, in_user_ID, NULL);

    -- AG 20180124 Mitnahme der LTE-ID in der LHM-ID, wenn genau 1 LAM umgepackt wird
    -- und die FAE-ID mit der LTE-ID übereinstimmt
    -- und der Parameter LTE_LHM_UMPACKEN_CHG_LHM_ID auf True ist
    -- Eingebaut für HAG 3.5.11 - Rad miz LTE ID wird in ein gestell gepackt
    update lvs_lam t
       set t.res_menge = decode(t.order_pos_auf_id, NULL, NULL, nvl(t.res_menge, t.menge))
     where t.lam_id = v_lam.lam_id;

    if  v_lam_anz = 1
    and v_lam.fae_id = v_q_lte_id
    and v_lam.lhm_id != v_q_lte_id
    and c.C_TRUE =
        isi_allg.get_firma_cfg_param (in_sid,
                                      in_firma_nr,
                                      'FAE_ID',
                                      null,
                                      'LTE_LHM_UMPACKEN_CHG_LHM_ID',
                                      'LVS',
                                      'CFG',
                                      c.C_FALSE,
                                      'BOOLEAN')
    then
      begin
        update lvs_lam t
           set t.lhm_id = v_q_lte_id
         where t.lhm_id = v_lam.lhm_id
           and t.lam_id = v_lam.lam_id;
        update lvs_lhm t
           set t.lhm_id = v_q_lte_id
         where t.lhm_id = v_lam.lhm_id;
        update lvs_lam_bh t
           set t.lhm_id = v_q_lte_id
         where t.lhm_id = v_lam.lhm_id
           and t.lam_id = v_lam.lam_id
           and t.lte_id = in_lte_id;
      exception
        when others then         -- Stille Exception mit LOG
          isi_p_log.isi_system_meldung(v_lam.sid,
                                       v_lam.firma_nr,
                                       'lvs_p_lte_lhm.lvs_lhm_umpacken',
                                       'ORA-DB',
                                       'LTE_LHM_UMPACKEN_CHG_LHM_ID',
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       'Fehler bei FAE_ID' || v_q_lte_id,
                                       'ERR');
        end;
    end if;

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
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
  end lvs_lhm_umpacken;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure ist zum abpacken eines LHM's von einer Palette
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_lhm_abpacken(in_lhm        in lvs_lhm%rowtype,
                             in_user_ID    in isi_user.login_id%TYPE,
                             in_lte_status in lvs_lte.lte_status%type,
                             in_art        in isi_artikel%rowtype,
                             in_kunden_nr  in lvs_lam.kunden_nr%type) is
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    v_found    boolean;

    v_lte lvs_lte%rowtype; -- LagerTransporteinheit des Materials


    v_lte_cfg           lvs_lte_cfg%rowtype;-- Cfg Der LTE (Palette)

    v_anz_lagen         number(3);         -- Anzahl der Lagen auf der LTE (Palette)
    v_lte_akt_lhm       number(3);         -- Aktuelle LHM's auf LTE

    v_art_lte_menge number;

    v_art_kd isi_artikel_kunde%rowtype;

    v_art_lte_hoehe_max    isi_artikel.lte_hoehe_max%type;
    v_art_lte_breite_max   isi_artikel.lte_breite_max%type;
    v_art_lte_tiefe_max    isi_artikel.lte_tiefe_max%type;
    v_art_lhm_hoehe_lage   isi_artikel.lhm_hoehe_lage%type;
    v_art_lte_lhm_menge    isi_artikel.lte_lhm_menge%type;
    v_art_lte_lhm_pro_lage isi_artikel.lte_lhm_pro_lage%type;
    v_art_lte_lhm_lagen    isi_artikel.lte_lhm_lagen%type;

    v_lgr                  lvs_lgr%rowtype;
    v_lte_last_hoehe       lvs_lte.lte_vol_hoehe%type;
    v_dif_frei_hoehe       lvs_lgr.lgr_frei_hoehe%type;

    cursor c_art_kd is
      select *
        from isi_artikel_kunde ak
       where ak.sid = in_art.sid
         and ak.artikel_id = in_art.artikel_id
         and ak.kunden_nr = in_kunden_nr;

    cursor c_lte is -- Lesen der Transporteinheit
      select *
        from lvs_lte lte
       where lte.lte_id = in_lhm.lte_id;

    CURSOR c_lte_cfg is
      select *
        from lvs_lte_cfg ltec
       where ltec.sid = in_lhm.sid
         and ltec.firma_nr = in_lhm.firma_nr
         and ltec.lte_name = v_lte.lte_name;
    v_lte_cfg_found boolean;

    CURSOR c_lgr is
      select l.*
        from lvs_lgr l
       where l.lgr_platz = v_lte.lgr_platz;

  begin
    v_lgr := NULL;
    v_dif_frei_hoehe := 0; -- -WK- 31.10.2006 muss vorinitialisiert werden, wenn keine LTE gefunden wurde

    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%found;
    CLOSE c_lte;

    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    CLOSE c_lgr;

    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;
    v_lte_cfg_found := c_lte_cfg%found;
    CLOSE c_lte_cfg;

    if v_found
    then
      v_lte_last_hoehe := v_lte.lte_vol_hoehe;

      if v_lte.lte_akt_lhm = 1
      then
        v_lte.lte_status := 'LP';
        -- Leere Paletten haben auch keinen Reservierungsstring
        v_lte.res_string := NULL;
        v_lte.res_artikel_id := NULL;
        if v_lte_cfg_found
        then
          -- da die letzte LHM abgepackt werden soll, bleibt nur eine Leerpalette, also Hoehe aus CFG
          v_lte.lte_vol_hoehe := v_lte_cfg.lte_vol_hoehe;
        end if;
      end if;

      if v_lte.waren_typ != 'MP'
      then
        if v_lte.packschema_kopf_id is not NULL
        then
          begin
            v_anz_lagen     := round(((v_lte.lte_akt_lhm - 1) /
                                      lvs_komm.get_packschema_max_lage(in_lhm.sid,
                                                                       in_lhm.firma_nr,
                                                                       v_lte.packschema_kopf_id)

                                       + 0.49),
                                     0);
          exception
            when others then
               v_anz_lagen     := 1;
          end;
          v_lte.lte_vol_hoehe := v_lte_cfg.lte_vol_hoehe +
                                  v_anz_lagen * in_lhm.lhm_vol_hoehe;
        end if;
        if nvl(v_lte.lte_vol_hoehe, 0) = 0
        then
          v_lte.lte_vol_hoehe := v_lte_last_hoehe;
        end if;

        if nvl(in_art.lhm_name, 'keine') != nvl(in_lhm.lhm_name, 'keine')
        and in_lhm.lhm_name is not NULL
        then
          -- LHM Typ geändert
          if not v_lte_cfg_found
          then
            v_lte_cfg.lte_vol_hoehe := 0;
          end if;

          v_art_lte_hoehe_max    := v_lte.lte_vol_hoehe;
          v_art_lte_breite_max   := v_lte.lte_vol_breite;
          v_art_lte_tiefe_max    := v_lte.lte_vol_tiefe;
          v_art_lhm_hoehe_lage   := in_lhm.lhm_vol_hoehe;

          v_anz_lagen := round(((v_lte.lte_vol_hoehe - v_lte_cfg.lte_vol_hoehe) /  in_lhm.lhm_vol_hoehe) + 0.49, 0);
          v_art_lte_lhm_lagen    := v_anz_lagen;

          v_art_lte_lhm_pro_lage := round(((v_lte.lte_vol_breite * v_lte.lte_vol_tiefe) /
                                         (in_lhm.lhm_vol_breite * in_lhm.lhm_vol_tiefe)),
                                         0);

        else
          -- LHM Typ bleibt gleich oder kein LHM Typ gesetzt
          v_art_lte_hoehe_max    := in_art.lte_hoehe_max;
          v_art_lte_breite_max   := in_art.lte_breite_max;
          v_art_lte_tiefe_max    := in_art.lte_tiefe_max;
          v_art_lhm_hoehe_lage   := in_art.lhm_hoehe_lage;
          v_art_lte_lhm_menge    := in_art.lte_lhm_menge;
          v_art_lte_lhm_pro_lage := in_art.lte_lhm_pro_lage;
          v_art_lte_lhm_lagen    := in_art.lte_lhm_lagen;

          OPEN c_art_kd;
          FETCH c_art_kd
            into v_art_kd;
          v_found := c_art_kd%FOUND;
          CLOSE c_art_kd;
          if v_found
          then
            -- Volumenwerte vom Kunden überschreiben
            v_art_lte_hoehe_max    := nvl(v_art_kd.lte_hoehe_max,
                                          v_art_lte_hoehe_max);
            v_art_lte_breite_max   := nvl(v_art_kd.lte_breite_max,
                                          v_art_lte_breite_max);
            v_art_lte_tiefe_max    := nvl(v_art_kd.lte_tiefe_max,
                                          v_art_lte_tiefe_max);
            v_art_lhm_hoehe_lage   := nvl(v_art_kd.lhm_hoehe_lage,
                                          v_art_lhm_hoehe_lage);
            v_art_lte_lhm_menge    := nvl(v_art_kd.lte_lhm_menge,
                                          v_art_lte_lhm_menge);
            v_art_lte_lhm_pro_lage := nvl(v_art_kd.lte_lhm_pro_lage,
                                          v_art_lte_lhm_pro_lage);
            v_art_lte_lhm_lagen    := nvl(v_art_kd.lte_lhm_lagen,
                                          v_art_lte_lhm_lagen);
          end if;

          begin
            if v_art_lhm_hoehe_lage is NULL
            then
              v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe /
                                      nvl(v_art_lte_lhm_lagen, 1);
            end if;
          exception
            when others then
               v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe;
          end;

          if nvl(v_art_lte_lhm_lagen, 0) = 0
          then
            begin
              if nvl(v_art_lte_lhm_menge / v_art_lte_lhm_lagen, 0) != 0
              then
                v_art_lte_lhm_lagen := v_art_lte_lhm_menge / v_art_lte_lhm_lagen;
              else
                v_art_lte_lhm_lagen := 1;
              end if;
            exception
              when others
                then v_art_lte_lhm_lagen := 1;
            end;
          end if;
        end if;

        if in_art.menge_basis = c.BASIS_LTE
        then
          v_art_lte_menge := 1;
          v_anz_lagen     := v_art_lte_lhm_lagen;
        elsif in_art.menge_basis = c.BASIS_LHM
        then
          v_art_lte_menge := v_art_lte_lhm_menge;
          v_lte_akt_lhm   := lvs_p_lte_lhm.lvs_lte_lhm_best(in_lhm.sid,
                                                            in_lhm.firma_nr,
                                                            in_lhm.lte_id,
                                                            'LTE');
          begin
            v_anz_lagen     := round((v_lte_akt_lhm / v_art_lte_lhm_pro_lage + 0.49),
                                     0);
          exception
            when others then
               v_anz_lagen     := 0;
          end;
        else
          v_art_lte_menge := v_art_lte_menge;
          begin
            v_anz_lagen     := round(((v_lte.lte_akt_lhm - 1) /
                                     v_art_lte_lhm_pro_lage) + 0.49,
                                     0);
          exception
            when others then
               v_anz_lagen     := 0;
          end;
        end if;

        if lvs_p_lte_lhm.lvs_lte_lhm_best(in_lhm.sid,
                                          in_lhm.firma_nr,
                                          in_lhm.lte_id,
                                          'LTE') >= v_art_lte_menge
           or in_art.waren_typ = c.ROHWARE
        then
          if nvl(in_art.lhm_name, 'keine') != nvl(in_lhm.lhm_name, 'keine')
          and in_lhm.lhm_name is not NULL
          and nvl(v_lte_cfg.lte_vol_hoehe_fest, c.c_false) = c.c_false
          and v_lte.packschema_kopf_id is NULL
          then
             v_lte.lte_vol_hoehe := v_lte_cfg.lte_vol_hoehe +
                                    v_anz_lagen * v_art_lhm_hoehe_lage;
          end if;
          v_lte.lte_voll := 'V';
        else
          if not v_lte_cfg_found
          then
            v_lte_cfg.lte_vol_hoehe := 0;
          end if;

          if nvl(v_lte_cfg.lte_vol_hoehe_fest, c.c_false) = c.c_false
          and v_lte.packschema_kopf_id is NULL
          then
            v_lte.lte_vol_hoehe := v_lte_cfg.lte_vol_hoehe +
                                   v_anz_lagen * v_art_lhm_hoehe_lage;
          end if;
          v_lte.lte_voll      := 'A';
        end if;
      end if;

      -- -AG- Neue Hoehe rechnen nur wenn LHM-Name != NULL
      -- oder das Rechnen gewünscht ist
      if (in_lhm.lhm_name is NULL
        and c.C_FALSE =
            isi_allg.get_firma_cfg_param (in_lhm.sid,
                                          in_lhm.firma_nr,
                                          'LTE_CALC_HOEHE_UMPACKEN',
                                          null,
                                          'LHM_NULL',
                                          'LVS',
                                          'CFG',
                                          'T',
                                          'BOOLEAN'))
      or  c.C_TRUE =
          isi_allg.get_firma_cfg_param (in_lhm.sid,
                                        in_lhm.firma_nr,
                                        'LTE_CALC_HOEHE_UMPACKEN',
                                        null,
                                        'NIE',
                                        'LVS',
                                        'CFG',
                                        'F',
                                        'BOOLEAN')
      or v_lte_cfg.lte_vol_hoehe_fest = c.C_TRUE   -- Feste Höhe nicht neu berechnen
      or v_lte_cfg.basis_lte_name = 'LHM'          -- LHM werden in der Höhe nicht neu berechnet
      then
        v_lte.lte_vol_hoehe := nvl(v_lte_last_hoehe, 15);
      end if;

      update lvs_lte lte
         set lte.lte_akt_kg         = nvl(v_lte.lte_akt_kg, 1) -
                                      in_lhm.lhm_akt_kg,
             lte.lte_akt_lhm        = nvl(v_lte.lte_akt_lhm, 1) - 1,
             lte.lte_voll           = v_lte.lte_voll,
             lte.lte_vol_hoehe      = v_lte.lte_vol_hoehe,
             lte.lte_letzte_buchung = systimestamp,
             lte.lte_status         = nvl(in_lte_status, lte.lte_status),
             lte.res_string         = v_lte.res_string,
             lte.res_artikel_id     = v_lte.res_artikel_id
       where lte.lte_id = in_lhm.lte_id;

      v_dif_frei_hoehe := 0;
      if v_lgr.lgr_typ = c.REG_FACH1
      or v_lgr.lgr_typ = c.STAP_FLAE1
      or v_lgr.lgr_typ = c.STAP_FLAE2
      then
        v_dif_frei_hoehe := v_lte.lte_vol_hoehe - v_lte_last_hoehe;
      end if;
    end if;

    -- Lagerplatz informieren
    update lvs_lgr lgr
       set lgr.lgr_akt_kg = lgr.lgr_akt_kg - in_lhm.lhm_akt_kg,
           lgr.lgr_frei_hoehe = lgr.lgr_frei_hoehe - v_dif_frei_hoehe
     where lgr.lgr_platz = in_lhm.lgr_platz;

    -- Verknüpfung in der LHM zur LTE lösen, und in komm_quell_... merken
    update lvs_lhm lhm
       set lhm.lte_id = null,
           lhm.komm_quell_lte_id = in_lhm.lte_id,
           lhm.komm_quell_lgr_platz = in_lhm.lgr_platz
     where lhm.lhm_id = in_lhm.lhm_id;

    -- Verknüpfung in der LAM zur LTE lösen
    update lvs_lam lam
       set lam.lte_id           = null
           --lam.order_pos_auf_id = NULL, -- -WK- 28.09.2006 Rücksprache mit AG
     where lam.lhm_id = in_lhm.lhm_id;
  exception
    when others then
      rollback;
      if v_err_nr is not null
      then
        raise_application_error(-20000 - v_err_nr, v_err_text, true);
      else
        raise;
      end if;
  end lvs_lhm_abpacken;
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure ist zum abpacken eines LHM's auf eine Palette
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_lhm_aufpacken(in_lhm        in lvs_lhm%rowtype,
                              in_lte        in lvs_lte%rowtype,
                              in_dif_frei_h in lvs_lgr.lgr_frei_hoehe%type,
                              in_user_id    in isi_user.login_id%TYPE,
                              in_lte_status in lvs_lte.lte_status%type) is
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    v_lte_cfg lvs_lte_cfg%rowtype;
    v_lfdn    lvs_lam.packschema_lfdn%type;

  begin
    if not lvs_p_base.get_lte_cfg(in_lte.sid, in_lte.lte_name, v_lte_cfg)
    then
      v_lte_cfg.lte_vol_hoehe_fest := c.c_false;
    end if;

    update lvs_lte lte
       set lte.lte_akt_kg         = nvl(in_lte.lte_akt_kg, 0) +
                                    in_lhm.lhm_akt_kg,
           lte.lte_akt_lhm        = nvl(in_lte.lte_akt_lhm, 0) + 1,
           lte.min_temp           = in_lte.min_temp,
           lte.max_temp           = in_lte.max_temp,
           lte.lte_vol_breite     = in_lte.lte_vol_breite,
           lte.lte_vol_tiefe      = in_lte.lte_vol_tiefe,
           lte.res_artikel_id     = in_lte.res_artikel_id,
           lte.waren_typ          = in_lte.waren_typ,
           lte.res_mhd            = in_lte.res_mhd,
           lte.res_string         = in_lte.res_string,
           lte.lte_vol            = in_lte.lte_vol,
           lte.gefahren_klasse    = in_lte.gefahren_klasse,
           lte.wert_klasse        = in_lte.wert_klasse,
           lte.lte_voll           = in_lte.lte_voll,
           lte.lte_letzte_buchung = systimestamp,
           lte.lte_status         = nvl(in_lte_status, in_lte.lte_status)
     where lte.lte_id = in_lte.lte_id;

    -- -AG- Neue Hoehe rechnen nur wenn LHM-Name != NULL
    -- oder das Rechnen gewünscht ist
      if (in_lhm.lhm_name is not NULL
        or  c.C_TRUE =
            isi_allg.get_firma_cfg_param (in_lhm.sid,
                                          in_lhm.firma_nr,
                                          'LTE_CALC_HOEHE_UMPACKEN',
                                          null,
                                          'LHM_NULL',
                                          'LVS',
                                          'CFG',
                                          'T',
                                          'BOOLEAN'))
      and c.C_FALSE =
          isi_allg.get_firma_cfg_param (in_lhm.sid,
                                        in_lhm.firma_nr,
                                        'LTE_CALC_HOEHE_UMPACKEN',
                                        null,
                                        'NIE',
                                        'LVS',
                                        'CFG',
                                        'F',
                                        'BOOLEAN')
    then
      if v_lte_cfg.lte_vol_hoehe_fest = c.c_false
      then
        -- -WK- hoehe nur veändern, wenn vol_hoehe nicht fest
        update lvs_lte lte
           set lte.lte_vol_hoehe = in_lte.lte_vol_hoehe
         where lte.lte_id = in_lte.lte_id;
        update lvs_lgr lgr
           set lgr.lgr_frei_hoehe = lgr.lgr_frei_hoehe - nvl(in_dif_frei_h, 0)
         where lgr.lgr_platz = in_lte.lgr_platz;
      end if;
    end if;

    update lvs_lgr lgr
       set lgr.lgr_akt_kg = lgr.lgr_akt_kg + in_lhm.lhm_akt_kg
     where lgr.lgr_platz = in_lte.lgr_platz;

    update lvs_lhm lhm
       set lhm.lgr_platz = in_lte.lgr_platz,
           lhm.lte_id    = in_lte.lte_id
     where lhm.lhm_id = in_lhm.lhm_id;

    if in_lte.packschema_kopf_id is NULL
    then
      v_lfdn := 0;
    else
      v_lfdn := lvs_komm.get_packschema_lfdn (in_lte.sid, in_lte.firma_nr, in_lte.lte_id);
    end if;

    update lvs_lam lam
       set lam.lte_id    = in_lte.lte_id,
           lam.lgr_platz = in_lte.lgr_platz,
           lam.packschema_kopf_id = in_lte.packschema_kopf_id,
           lam.packschema_lfdn = v_lfdn
     where lam.lhm_id = in_lhm.lhm_id;

  exception
    when others then
      rollback;
      if v_err_nr is not null
      then
        raise_application_error(-20000 - v_err_nr, v_err_text, true);
      else
        raise;
      end if;
  end lvs_lhm_aufpacken;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure ist zum wiedereinlagern von LTE's (AG)
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_c_lte_wieder_einl(in_lte_id     in lvs_lte.lte_id%type,
                                in_lgr_ort    in lvs_lgr_ort.lgr_ort%type,
                                in_user_ID    in isi_user.login_id%TYPE) is

  begin
    lvs_lte_wieder_einl(in_lte_id,
                        in_lgr_ort,
                        in_user_ID);
    commit;
  end lvs_c_lte_wieder_einl;

--******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure ist zum wiedereinlagern von LTE's (AG)
  -- -AG- Achtung, diese Funktion geht nicht bei Umlaufbehältern, wenn Daten in der Historie
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_lte_wieder_einl(in_lte_id     in lvs_lte.lte_id%type,
                                in_lgr_ort    in lvs_lgr_ort.lgr_ort%type,
                                in_user_ID    in isi_user.login_id%TYPE) is
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    v_found    boolean;

    v_lam_bh_id                               lvs_lam_bh.lam_bh_id%TYPE; -- Neu LAM_BH_ID aus Sequenz
    v_vorg_id                                 lvs_lam_bh.vorg_id%type;
    v_lte                                     lvs_lte%rowtype;
    v_lhm                                     lvs_lhm%rowtype;
    v_lam_bh                                  lvs_lam_bh%rowtype;
    v_last_ag_dat                             date;
    v_last_lhm_id                             lvs_lhm.lhm_id%TYPE;

    CURSOR c_lte is
      select t.*
        from lvs_lte t
       where t.lte_id = in_lte_id;

    CURSOR c_lte_hist is
      select t.*
        from lvs_lte_hist t
       where t.lte_id = in_lte_id;

    CURSOR c_lam_bh_last_ag is
      select max(l.buch_datum)
        from lvs_lam_bh l
       where l.lte_id = in_lte_id
         and l.bus = c.LAM_BH_BUS_ABG;

    CURSOR c_lam_bh_last_ag_hist is
      select max(l.buch_datum)
        from lvs_lam_bh_hist l
       where l.lte_id = in_lte_id
         and l.bus = c.LAM_BH_BUS_ABG;

    CURSOR c_lam_bh is
      select *
        from lvs_lam_bh l
       where l.lte_id = in_lte_id
         and l.bus = c.LAM_BH_BUS_ABG
         and l.buch_datum = v_last_ag_dat;

    CURSOR c_lam_bh_hist is
      select *
        from lvs_lam_bh_hist l
       where l.lte_id = in_lte_id
         and l.bus = c.LAM_BH_BUS_ABG
         and l.buch_datum = v_last_ag_dat;

    CURSOR c_lhm is
     select *
       from lvs_lhm t
       where t.lhm_id = v_last_lhm_id;

    CURSOR c_lhm_hist is
     select *
       from lvs_lhm_hist t
      where t.lhm_id = v_last_lhm_id;

  begin

    OPEN c_lte;
    FETCH c_lte into v_lte;

    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found
    then
      OPEN c_lte_hist;
      FETCH c_lte_hist into v_lte;

      v_found := c_lte_hist%FOUND;
      CLOSE c_lte_hist;
      if not v_found
      then
        v_err_nr := 10;
        v_err_text := LC.ec_p1(LC.O_TP1_LTE_WIEDER_EINL_UNMOEGL, in_lte_id);
        raise v_error;
      end if;

      insert into lvs_lte
         select *
           from lvs_lte_hist
          where lte_id = in_lte_id;

      delete lvs_lte_hist t
        where t.lte_id = in_lte_id;

      update lvs_lte t
         set t.lgr_ort = in_lgr_ort,
             t.lte_status = 'PF',
             t.anz_uml = 0,
             t.order_auf_id = null,
             t.res_ziel_lgr_platz = null
       where t.lte_id = in_lte_id;

      v_last_ag_dat := NULL;
      OPEN c_lam_bh_last_ag_hist;
      FETCH c_lam_bh_last_ag_hist into v_last_ag_dat;
      CLOSE c_lam_bh_last_ag_hist;

      v_err_nr := 30;
      v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
      select seq_vorg_id.nextval into v_vorg_id from dual;
      v_err_nr := NULL;
      v_err_text := NULL;

      OPEN c_lam_bh_hist;
      LOOP
        FETCH c_lam_bh_hist into v_lam_bh;
        EXIT when c_lam_bh_hist%NOTFOUND;

        -- Materialdaten aus der history holen
        insert into lvs_lam
          select *
            from lvs_lam_hist t
           where t.lam_id = v_lam_bh.lam_id;
        delete lvs_lam_hist t
         where t.lam_id = v_lam_bh.lam_id;

        update lvs_lam t
           set t.lte_id = in_lte_id,
               t.lgr_platz = NULL,
               t.order_pos_auf_id = NULL,
               t.res_menge = NULL
         where t.lam_id = v_lam_bh.lam_id;

          -- -AG- Jetzt noch die LHM zurückholen und dann in der LAM tabelle eintragen
          -- BugFix -> Es muessen alle LHMs der Palette zurueckgeholt und mit UPDATE entsperechend eingetragen werden
          -- BugFix CMe -> Die LHM muss erst aus der Historie geholt werden da ansonsten die Buchungen lvs_lam_bh fehlschlagen,
          --               da die LHM nich in lvs_lhm gefunden werden konnten
          v_last_lhm_id := v_lam_bh.lhm_id;

          OPEN c_lhm;
          FETCH c_lhm into v_lhm;

          v_found := c_lhm%FOUND;
          CLOSE c_lhm;

          if not v_found then
           OPEN c_lhm_hist;
           FETCH c_lhm_hist into v_lhm;

           v_found := c_lhm_hist%FOUND;
           CLOSE c_lhm_hist;

           if not v_found
           then
              v_err_nr := 20;
              v_err_text := LC.ec_p1(LC.O_TP1_LHM_ID_FEHLT, v_last_lhm_id);
              raise v_error;
           end if;

           insert into lvs_lhm
                select *
                  from lvs_lhm_hist
                 where lhm_id = v_last_lhm_id;

           delete lvs_lhm_hist t
            where t.lhm_id = v_last_lhm_id;
         end if;

         update lvs_lhm t
            set t.lte_id = in_lte_id
          where t.lhm_id = v_lhm.lhm_id;

          update lvs_lam t
             set t.lhm_id = v_lhm.lhm_id
           where t.lam_id = v_lam_bh.lam_id;

        if v_lte.lte_akt_lhm = 0
        then
          v_err_nr := 20;
          v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
          select seq_lam_bh.nextval into v_lam_bh_id from dual;
          v_err_nr   := NULL;
          v_err_text := NULL;

          -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
          insert into lvs_lam_bh
               values (v_lam_bh.sid,
                       v_lam_bh.firma_nr,
                       v_vorg_id,
                       c.LAM_BH_ZUGAGNG,
                       v_lam_bh_id,
                       v_lam_bh.lam_id,
                       v_lam_bh.artikel_id,
                       c.LAM_BH_BUS_ZUG,
                       v_lam_bh.buch_datum,
                       v_lam_bh.ls_login_id,
                       v_lam_bh.lgr_platz,
                       v_lam_bh.lte_id,
                       v_lam_bh.lhm_id,
                       v_lam_bh.charge_id,
                       v_lam_bh.serie_id,
                       v_lam_bh.abnr,
                       v_lam_bh.menge,
                       v_lam_bh.lam_bh_kg,
                       v_lam_bh.lam_bh_kg_einheit,
                       v_lam_bh.res_id,
                       v_lam_bh.leitzahl,
                       v_lam_bh.fa_ag,
                       v_lam_bh.fa_upos,
                       v_lam_bh.abnr_extern,
                       v_lam_bh.vorgang_id,
                       v_lam_bh.li_nr,
                       v_lam_bh.li_pos_nr,
                       sysdate,                     -- CREATED_DATE N DATE  Y     creation date+time of this dataset
                       in_user_id,                  -- CREATED_LOGIN_ID N NUMBER  Y     login id of the user creating this dataset
                       sysdate,                     -- LAST_CHANGE_DATE N DATE  Y     change date+time of this dataset
                       in_user_id,                  -- LAST_CHANGE_LOGIN_ID N NUMBER  Y     login id of the user changing this dataset
                       null,                        -- CHANGE_MENGE N NUMBER  Y     Menge die geändert wurde
                       v_lam_bh.owner_address_id,   -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                       null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

        end if;
      end LOOP;
      CLOSE c_lam_bh_hist;
    else

      if v_lte.lte_status = 'PF'
      then
        update lvs_lte t
           set t.lgr_ort = in_lgr_ort,
               t.anz_uml = 0
         where t.lte_id = in_lte_id;
        return;
      end if;

      if (v_lte.lte_status != 'AG'
      and v_lte.lte_status != 'KF')
      then
        v_err_nr := 11;
        v_err_text := LC.ec_p2(LC.O_TP2_LTE_ERR_HAT_STATUS, in_lte_id, v_lte.lte_status);
        raise v_error;
      end if;

      v_last_ag_dat := NULL;
      OPEN c_lam_bh_last_ag;
      FETCH c_lam_bh_last_ag into v_last_ag_dat;
      CLOSE c_lam_bh_last_ag;

      lvs_p_lte.lvs_korr_te_ausbuchen(v_lte.sid,                           -- in_te_sid         IN lvs_lte.sid%TYPE,
                                      v_lte.firma_nr,                      -- in_te_firma_nr    IN lvs_lte.firma_nr%TYPE,
                                      in_lte_id,                           -- in_lte_id         IN LVS_LTE.LTE_ID%TYPE,
                                      NULL,                                -- in_lte_status     IN lvs_lte.lte_status%TYPE,
                                      v_lte.sid,                           -- in_lgr_sid        IN lvs_lgr.sid%TYPE,
                                      v_lte.firma_nr,                      -- in_lgr_firma_nr   IN lvs_lgr.firma_nr%TYPE,
                                      in_lgr_ort,                          -- in_lgr_ort        IN lvs_lgr.lgr_ort%TYPE,
                                      NULL,                                -- in_lgr_lagerplatz IN LVS_LTE.LGR_PLATZ%TYPE,
                                      in_user_ID                           -- in_ls_login_id    IN isi_user.login_id%TYPE
                                     );

      update lvs_lte t
         set t.lgr_ort = in_lgr_ort,
             t.lte_status = 'PF',
             t.anz_uml = 0,
             t.order_auf_id = null,
             t.res_ziel_lgr_platz = null
       where t.lte_id = in_lte_id;

      v_err_nr := 30;
      v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
      select seq_vorg_id.nextval into v_vorg_id from dual;
      v_err_nr := NULL;
      v_err_text := NULL;
      OPEN c_lam_bh;
      LOOP
        FETCH c_lam_bh into v_lam_bh;
        EXIT when c_lam_bh%NOTFOUND;

        update lvs_lam t
           set t.lte_id = in_lte_id,
               t.lgr_platz = NULL,
               t.order_pos_auf_id = NULL,
               t.res_menge = NULL
         where t.lam_id = v_lam_bh.lam_id;

        -- -AG- Jetzt noch die LHM zurückholen und dann in der LAM tabelle eintragen
        -- BugFix CMe -> Die LHM muss erst aus der Historie geholt werden da ansonsten die Buchungen lvs_lam_bh fehlschlagen,
        --               da die LHM nich in lvs_lhm gefunden werden konnten
        v_last_lhm_id := v_lam_bh.lhm_id;

        OPEN c_lhm;
        FETCH c_lhm into v_lhm;

        v_found := c_lhm%FOUND;
        CLOSE c_lhm;

        if not v_found then
           OPEN c_lhm_hist;
           FETCH c_lhm_hist into v_lhm;

           v_found := c_lhm_hist%FOUND;
           CLOSE c_lhm_hist;

           if not v_found
           then
              v_err_nr := 20;
              v_err_text := LC.ec_p1(LC.O_TP1_LHM_ID_FEHLT, v_last_lhm_id);
              raise v_error;
           end if;

           insert into lvs_lhm
                select *
                  from lvs_lhm_hist
                 where lhm_id = v_last_lhm_id;

           delete lvs_lhm_hist t
            where t.lhm_id = v_last_lhm_id;

        end if;

        update lvs_lhm t
           set t.lte_id = in_lte_id
         where t.lhm_id = v_lhm.lhm_id;

        update lvs_lam t
           set t.lhm_id = v_lhm.lhm_id
         where t.lam_id = v_lam_bh.lam_id;

        if v_lte.lte_akt_lhm = 0
        then
          v_err_nr := 20;
          v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
          select seq_lam_bh.nextval into v_lam_bh_id from dual;
          v_err_nr   := NULL;
          v_err_text := NULL;
          -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
          insert into lvs_lam_bh
               values (v_lam_bh.sid,
                       v_lam_bh.firma_nr,
                       v_vorg_id,
                       c.LAM_BH_ZUGAGNG,
                       v_lam_bh_id,
                       v_lam_bh.lam_id,
                       v_lam_bh.artikel_id,
                       c.LAM_BH_BUS_ZUG,
                       v_lam_bh.buch_datum,
                       v_lam_bh.ls_login_id,
                       v_lam_bh.lgr_platz,
                       v_lam_bh.lte_id,
                       v_lam_bh.lhm_id,
                       v_lam_bh.charge_id,
                       v_lam_bh.serie_id,
                       v_lam_bh.abnr,
                       v_lam_bh.menge,
                       v_lam_bh.lam_bh_kg,
                       v_lam_bh.lam_bh_kg_einheit,
                       v_lam_bh.res_id,
                       v_lam_bh.leitzahl,
                       v_lam_bh.fa_ag,
                       v_lam_bh.fa_upos,
                       v_lam_bh.abnr_extern,
                       v_lam_bh.vorgang_id,
                       v_lam_bh.li_nr,
                       v_lam_bh.li_pos_nr,
                       sysdate,                     -- CREATED_DATE N DATE  Y     creation date+time of this dataset
                       in_user_id,                  -- CREATED_LOGIN_ID N NUMBER  Y     login id of the user creating this dataset
                       sysdate,                     -- LAST_CHANGE_DATE N DATE  Y     change date+time of this dataset
                       in_user_id,                  -- LAST_CHANGE_LOGIN_ID N NUMBER  Y     login id of the user changing this dataset
                       null,                        -- CHANGE_MENGE N NUMBER  Y     Menge die geändert wurde
                       v_lam_bh.owner_address_id,   -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                       null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

        end if;
      end LOOP;
      CLOSE c_lam_bh;
    end if;

  exception
    when others then
      rollback;
      if v_err_nr is not NULL
      then
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        raise;
      end if;
  end lvs_lte_wieder_einl;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure setzt die Artikel_ID in allen Buchungen LAM LTE mit der gelieferten
  -- Artikel_id
  --
  -- Wenn die artikel_id gefüllt ist, ist diese führend, sonst wird mit der
  -- Artikelnummer der Artikel gesucht. Falls der Artikel nicht gefunden wird,
  -- wird eine exception gerissen.
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_c_lte_set_artikel(in_sid        in isi_sid.sid%type,
                                  in_firma_nr   in isi_firma.firma_nr%type,
                                  in_lhm_id     in lvs_lhm.lhm_id%type,
                                  in_lte_id     in lvs_lte.lte_id%type,
                                  in_artikel    in isi_artikel.artikel%type,
                                  in_artikel_id in isi_artikel.artikel_id%type,
                                  in_charge     in lvs_charge.charge_bez%type,
                                  in_Menge      in lvs_lam.menge%type,
                                  in_Kundennr   in lvs_lam.kunden_nr%type,
                                  in_user_ID    in isi_user.login_id%TYPE) is
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);
  begin
    lvs_lte_set_artikel(in_sid,               --in_sid        in isi_sid.sid%type,
                        in_firma_nr,          -- in_firma_nr   in isi_firma.firma_nr%type,
                        in_lhm_id,            -- in_lhm_id     in lvs_lhm.lhm_id%type,
                        in_lte_id,            -- in_lte_id     in lvs_lte.lte_id%type,
                        in_artikel,           -- in_artikel    in isi_artikel.artikel%type,
                        in_artikel_id,        -- in_artikel_id in isi_artikel.artikel_id%type,
                        in_charge,            -- in_charge     in lvs_charge.charge_bez%type,
                        in_Menge,             -- in_Menge      in lvs_lam.menge%type,
                        in_Kundennr,          -- in_Kundennr   in lvs_lam.kunden_nr%type,
                        in_user_ID);          -- in_user_ID    in isi_user.login_id%TYPE)
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end lvs_c_lte_set_artikel;
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure setzt die Artikel_ID in allen Buchungen LAM LTE mit der gelieferten
  -- Artikel_id
  --
  -- Wenn die artikel_id gefüllt ist, ist diese führend, sonst wird mit der
  -- Artikelnummer der Artikel gesucht. Falls der Artikel nicht gefunden wird,
  -- wird eine exception gerissen.
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_lte_set_artikel(in_sid        in isi_sid.sid%type,
                                in_firma_nr   in isi_firma.firma_nr%type,
                                in_lhm_id     in lvs_lhm.lhm_id%type,
                                in_lte_id     in lvs_lte.lte_id%type,
                                in_artikel    in isi_artikel.artikel%type,
                                in_artikel_id in isi_artikel.artikel_id%type,
                                in_charge     in lvs_charge.charge_bez%type,
                                in_Menge      in lvs_lam.menge%type,
                                in_Kundennr   in lvs_lam.kunden_nr%type,
                                in_user_ID    in isi_user.login_id%TYPE) is
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);
  --------------------------------------------------------------------------------
    v_lam                       lvs_lam%rowtype;             -- Palettendaten
    v_artikel                   isi_artikel%rowtype;         -- Artikeldaten
    v_charge_id                 lvs_charge.charge_id%type;   -- Charge ID

    v_found                     boolean;

  CURSOR c_artikel is
    select *
      from isi_artikel a
     where a.sid = in_sid
       and a.artikel = in_artikel;

  CURSOR c_artikel_id is
    select *
      from isi_artikel a
     where a.sid = in_sid
       and a.artikel_id = in_artikel_id;

  CURSOR c_lam is
    select *
      from lvs_lam l
     where l.sid = in_sid
       and l.lte_id = in_lte_id
       and l.lhm_id = nvl(in_lhm_id, l.lhm_id)
       FOR UPDATE of l.artikel_id,
                     l.charge_id,
                     l.kunden_nr;

  begin
    if in_artikel_id is NULL
    then
      v_artikel.artikel := in_artikel;
      OPEN c_artikel;
      fetch c_artikel into v_artikel;
      v_found := c_artikel%found;
      CLOSE c_artikel;
    else
      v_artikel.artikel := in_artikel_id;
      OPEN c_artikel_id;
      fetch c_artikel_id into v_artikel;
      v_found := c_artikel_id%found;
      CLOSE c_artikel_id;
    end if;

    if not v_found
    then
      v_err_nr   := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_ARTIKEL_FEHLT, v_artikel.artikel);
      raise v_error;
    end if;

    if in_Menge = 0 then
      v_err_nr   := 20;
      v_err_text := LC.ec_p2(LC.O_TP2_ARTIKEL_MENGE_LEER, v_artikel.artikel, in_lte_id);
      raise v_error;
    end if;

    if in_charge is not NULL
    then
      v_charge_id := get_charge_id(in_sid, in_firma_nr, NULL, in_charge, v_artikel.artikel_id);
    else
      v_charge_id := NULL;
    end if;

    OPEN c_lam;
    FETCH c_lam into v_lam;
    LOOP
      EXIT when c_lam%NOTFOUND;
      update lvs_lam l
         set l.artikel_id = v_artikel.artikel_id,
             l.charge_id = nvl(v_charge_id, l.charge_id),
             l.kunden_nr = nvl(in_Kundennr, l.kunden_nr)
       where current of c_lam;

      update lvs_lam_bh l
         set l.artikel_id = v_artikel.artikel_id,
             l.menge = nvl(in_Menge, l.menge),
             l.charge_id = nvl(v_charge_id, l.charge_id)
       where l.sid = v_lam.sid
         and l.firma_nr = v_lam.firma_nr
         and l.lam_id = v_lam.lam_id
         and l.menge >= 0;

      update lvs_lam_bh l
         set l.artikel_id = v_artikel.artikel_id,
             l.menge = nvl(in_Menge * -1, l.menge),
             l.charge_id = nvl(v_charge_id, l.charge_id)
       where l.sid = v_lam.sid
         and l.firma_nr = v_lam.firma_nr
         and l.lam_id = v_lam.lam_id
         and l.menge < 0;
      FETCH c_lam into v_lam;
    end LOOP;
    CLOSE c_lam;
    update lvs_lte l
       set l.res_artikel_id = v_artikel.artikel_id
     where l.sid = v_lam.sid
       and l.firma_nr = v_lam.firma_nr
       and l.lte_id = in_lte_id;

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
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
  end lvs_lte_set_artikel;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure Elemeniert eine LAM und bucht diese mit BUS7 (Gesperrt abgang) aus
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_c_lam_schrott(in_lte_id       in lvs_lhm.Lte_Id%TYPE,
                              in_lhm_id       in lvs_lhm.Lhm_Id%TYPE,
                              in_lam_id       in lvs_lam.Lam_Id%TYPE,
                              in_user_ID      in isi_user.login_id%TYPE
                             ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    -------------------------------------------------------------------------------------------------------
    v_lam              lvs_lam%rowtype;

    v_lam_bh_id        lvs_lam_bh.lam_bh_id%type;
    v_vorg_id          lvs_lam_bh.vorg_id%type;     -- Neu VORGang_ID aus Sequenz

    v_found boolean;

    cursor c_lam is
      select *
        from lvs_lam lam
       where lam.lam_id = in_lam_id;

  begin

    OPEN c_lam;
    FETCH c_lam
      into v_lam;
    v_found := c_lam%FOUND;
    CLOSE c_lam;

    if not v_found
    then
      v_err_nr   := 10;
      v_err_text := LC.ec(LC.O_TXT_LAGERBEST_N_LESBAR);
      RAISE v_error;
    end if;

    if not v_found
    then
      v_err_nr   := 20;
      v_err_text := LC.ec_P1(LC.O_TP1_Q_LTE_ID_FEHLT, in_lte_id);
      RAISE v_error;
    end if;

    v_err_nr := 20;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    -- Holen der neuen Nummern für diesen Vorgang
    select seq_vorg_id.nextval into v_vorg_id from dual;
    v_err_nr := 40;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_lam_bh.nextval into v_lam_bh_id from dual;
    v_err_nr := 50;
    v_err_text := LC.ec_p1(LC.O_TP1_BUCH_ERR, 'LAM_BH');

    -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
    insert into lvs_lam_bh
      values(v_lam.sid,                  -- SID               VARCHAR2(2) not null,
             v_lam.firma_nr,             -- FIRMA_NR          NUMBER(2) not null,
             v_vorg_id,                  -- VORG_ID           NUMBER not null,
             c.LAM_BH_ABGAGNG,           -- VORG_TYP          VARCHAR2(2) not null,
             v_lam_bh_id,                -- LAM_BH_ID         NUMBER not null,
             v_lam.lam_id,               -- LAM_ID            NUMBER not null,
             v_lam.artikel_id,           -- ARTIKEL_ID        NUMBER,
             c.LAM_BH_BUS_Q,             -- BUS               NUMBER,
             sysdate,                    -- BUCH_DATUM        DATE,
             in_user_ID,                 -- LS_LOGIN_ID       NUMBER,
             v_lam.lgr_platz,            -- LGR_PLATZ         VARCHAR2(30),
             v_lam.lte_id,               -- LTE_ID            VARCHAR2(19),
             v_lam.lhm_id,               -- LHM_ID            VARCHAR2(19),
             v_lam.charge_id,            -- CHARGE_ID         NUMBER,
             v_lam.serie_id,             -- SERIE_ID          NUMBER,
             NULL,                       -- ABNR              VARCHAR2(20),
             v_lam.menge,                -- MENGE             NUMBER,
             v_lam.lam_kg,               -- LAM_BH_KG         NUMBER,
             v_lam.lam_kg / decode(v_lam.menge, 0, 1, v_lam.menge),
                                         -- LAM_BH_KG_EINHEIT NUMBER,
             NULL,                       -- RES_ID            NUMBER,
             v_lam.leitzahl,             -- LEITZAHL          NUMBER,
             v_lam.fa_ag,                -- FA_AG             NUMBER,
             v_lam.fa_upos,              -- FA_UPOS           NUMBER,
             NULL,                       -- ABNR_EXTERN       NUMBER,
             NULL,                       -- VORGANG_ID        NUMBER
             NULL,
             NULL,
             sysdate,                     -- CREATED_DATE N DATE  Y     creation date+time of this dataset
             in_user_id,                  -- CREATED_LOGIN_ID N NUMBER  Y     login id of the user creating this dataset
             sysdate,                     -- LAST_CHANGE_DATE N DATE  Y     change date+time of this dataset
             in_user_id,                  -- LAST_CHANGE_LOGIN_ID N NUMBER  Y     login id of the user changing this dataset
             null,                        -- CHANGE_MENGE N NUMBER  Y     Menge die geändert wurde
             v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
             null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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

  -------------------------------------------------------------------------
  function lvs_mhd_berechne(in_Start_date in date,
                            in_mhd_tage   in isi_artikel.mhd_tage%TYPE,
                            in_berechnung in isi_artikel.mhd_berechnung%TYPE)
    return date is
    Result date;

    v_start_date date;
    v_mhd_tage   isi_artikel.mhd_tage%TYPE;
  begin
    v_mhd_tage   := nvl(in_mhd_tage, 0);
    v_start_date := nvl(in_start_date, sysdate);

    if in_berechnung = c.MHD_BERECHNEN_TAG or
       in_berechnung = c.MHD_BERECHNEN_TAG_ then
      result := trunc(v_Start_date + v_mhd_tage);
    elsif in_berechnung = c.MHD_BERECHNEN_WOCHE_A or
          in_berechnung = c.MHD_BERECHNEN_WOCHE_A_ then
      result := trunc(v_Start_date + v_mhd_tage, 'day');
    elsif in_berechnung = c.MHD_BERECHNEN_WOCHE_E or
          in_berechnung = c.MHD_BERECHNEN_WOCHE_E_ then
      result := trunc(v_Start_date + v_mhd_tage, 'day') + 6;
    elsif in_berechnung = c.MHD_BERECHNEN_MONAT_A or
          in_berechnung = c.MHD_BERECHNEN_MONAT_A_ then
      result := trunc(v_Start_date + v_mhd_tage, 'month');
    elsif in_berechnung = c.MHD_BERECHNEN_MONAT_E or
          in_berechnung = c.MHD_BERECHNEN_MONAT_E then
      result := trunc(last_day(v_Start_date + v_mhd_tage));  -- BW Tag Genau
    elsif in_berechnung = c.MHD_BERECHNEN_JAHR_A or
          in_berechnung = c.MHD_BERECHNEN_JAHR_A_ then
      result := trunc(v_Start_date + v_mhd_tage, 'syyy');
    elsif in_berechnung = c.MHD_BERECHNEN_JAHR_E or
          in_berechnung = c.MHD_BERECHNEN_JAHR_E_ then
      result := add_months(trunc(v_Start_date + v_mhd_tage, 'syyy') - 1, 12);
    else
      result := trunc(v_Start_date + v_mhd_tage);
    end if;

    return(Result);
  exception
    when others then return(NULL);
  end;

  --------------------------------------------------------------------------------
  -- function format_ean
  --
  -- 4027453230095 -> 40 27453 23009 5
  --------------------------------------------------------------------------------
  function format_ean(in_str in varchar2) return varchar2 is

  begin
    return(isi_utils.format_ean(in_str));
  end;

  --------------------------------------------------------------------------------
  -- function format_nve
  --
  -- 340274530000050083 -> 3 40 27453 000005008 3
  --------------------------------------------------------------------------------
  function format_nve(in_str in varchar2) return varchar2 is

  begin
    return(isi_utils.format_nve(in_str));
  end;
  --------------------------------------------------------------------------------
  -- procedure macht aus einer lam zwei
  -- 20180203 AG bubfix res_menge
  --------------------------------------------------------------------------------
  procedure lvs_sep_lam (in_sid                 in isi_sid.sid%type,
                         in_firma_nr            in isi_firma.firma_nr%type,
                         in_res_id              in isi_resource.res_id%type,
                         in_user_id             in isi_user.login_id%type,
                         in_lte_id              in lvs_lte.lte_id%type,
                         in_lam_id              in lvs_lam.lam_id%type,
                         in_lam_bh_id           in lvs_lam_bh.lam_bh_id%type,
                         in_sonst_id_lieferant  in lvs_lam.sonst_id_lieferant%type,
                         in_menge               in lvs_lam.menge%type) is

    ----------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    ----------------------------------------------------------------------------
    v_error    exception;
    v_err_nr   number;
    v_err_text varchar2(255);

    ----------------------------------------------------------------------------
    -- Lokale Variablen
    ----------------------------------------------------------------------------
    v_found             boolean;                           -- Dummy Var für gefunden im CURSOR
    v_lte               lvs_lte%rowtype;
    v_lam               lvs_lam%rowtype;
    v_lam_bh            lvs_lam_bh%rowtype;
    --v_ziel_lam          lvs_lam%rowtype;
    v_charge            lvs_charge%rowtype;
    v_art               isi_artikel%rowtype;

    v_lam_id            lvs_lam.lam_id%type;               -- Neu LAM_ID aus Sequenz
    v_lhm_id            lvs_lam.lhm_id%type;               -- Neu LHM_ID aus Sequenz
    v_vorg_id           lvs_lam_bh.vorg_id%type;           -- Neu VORGang_ID aus Sequenz
    v_lam_bh_id         lvs_lam_bh.lam_bh_id%type;         -- Neu LAM_BH_ID aus Sequenz
    v_lam_bh_anz        number;                            -- Anzahl der Abgangsbuchung für dieses Material
    v_lam_bh_kg         lvs_lam_bh.lam_bh_id%type;         -- Gewicht der Wahre
    v_lam_bh_kg_einheit lvs_lam_bh.lam_bh_kg_einheit%type; -- Gewicht der eine Wahre
    v_menge             lvs_lam_bh.menge%type;
    -- 20180203 AG bubfix res_menge
    v_res_menge_q       lvs_lam.res_menge%type;            -- Berechnete Reservierte Menge auf der Quelle
    v_res_menge_z       lvs_lam.res_menge%type;            -- Berechnete Reservierte Menge auf dem Ziel

    v_typ               varchar2(10);
    v_art_ctrl          isi_artikel_ctrl%rowtype;
    v_h_tag              isi_hersteller.tag%type;
    v_hersteller         isi_hersteller%rowtype;    -- Daten aus isi-Hersteller
    
    v_lhm_cfg           lvs_lhm_cfg%rowtype;
    v_lhm_vol           lvs_lhm.lhm_vol%type;
    v_org_lhm           lvs_lhm%rowtype;
    

    -- Lesen des Lagerbestands für quelle Transporteinheit
    CURSOR c_lte is
      select lte.*
        from lvs_lte lte
       where lte.sid      = in_sid
         and lte.firma_nr = in_firma_nr
         and lte.lte_id   = in_lte_id;

    -- Lesen des Lagerbestands für LAM
    CURSOR c_lam is
      select lam.*
        from lvs_lam lam
       where lam.sid      = in_sid
         and lam.firma_nr = in_firma_nr
         and lam.lam_id   = in_lam_id;

    -- Lesen alle Abgangsbuchungen eines LAM
    CURSOR c_lam_bh_anz is
      select count(*)
        from lvs_lam_bh bh
       where bh.sid      = in_sid
         and bh.firma_nr = in_firma_nr
         and bh.lam_id   = in_lam_id
         and bh.bus = c.LAM_BH_BUS_ABG;

    -- Lesen alle Abgangsbuchungen eines LAM
    CURSOR c_lam_bh is
      select bh.*
        from lvs_lam_bh bh
       where bh.sid      = in_sid
         and bh.firma_nr = in_firma_nr
         and bh.lam_id   = in_lam_id
         and bh.lam_bh_id = in_lam_bh_id;

    CURSOR c_charge is
      select t.*
        from lvs_charge t
       where t.charge_id = v_lam.charge_id;
    
    cursor c_lhm_cfg is
      select t.*
        from lvs_lhm_cfg t
       where t.sid = v_art.sid
         and t.lhm_name = v_art.lhm_name;
    
   cursor c_get_org_lhm is
      select lhm.* 
        from lvs_lhm lhm
       where 1=1
         and lhm.sid = v_lam.sid
         and lhm.firma_nr = v_lam.firma_nr
         and lhm.lhm_id =v_lam.lhm_id;
         

    -- Lesen die Lams auf die ZielPalette
    --CURSOR c_ziel_lam is
    --  select lam.*
    --    from lvs_lam lam
    --   where lam.sid      = in_sid
    --     and lam.firma_nr = in_firma_nr
    --     and lam.lte_id   = in_lte_id;

  begin

    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found then
      v_err_nr := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
      raise v_error;
    end if;

    if v_lte.lgr_platz is NULL
    then
      v_err_nr := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_LHM_ID_N_IM_LAGER, in_lte_id);
      raise v_error;
    end if;

    OPEN c_lam;
    FETCH c_lam into v_lam;
    v_found := c_lam%FOUND;
    CLOSE c_lam;
    if not v_found then
      v_err_nr := 30;
      v_err_text := LC.ec_p1(LC.O_TP1_LAM_FEHLT, in_lam_id);
      raise v_error;
    end if;

    OPEN c_lam_bh_anz;
    FETCH c_lam_bh_anz into v_lam_bh_anz;
    CLOSE c_lam_bh_anz;

    if v_lam_bh_anz = 1
    then
      update lvs_lam l
         set l.sonst_id_lieferant = in_sonst_id_lieferant
       where l.sid = v_lam.sid
         and l.firma_nr = v_lam.firma_nr
         and l.lam_id = in_lam_id;
      commit;
      return;
    end if;

    OPEN c_lam_bh;
    FETCH c_lam_bh into v_lam_bh;
    v_found := c_lam_bh%FOUND;
    CLOSE c_lam_bh;
    if not v_found then
      v_err_nr := 35;
      v_err_text := LC.ec_p1(LC.O_TP1_LAM_BH_FEHLT, in_lam_bh_id);
      raise v_error;
    end if;
    if in_menge is NULL
    then
      v_menge := v_lam_bh.menge;
    else
      v_menge := in_menge;
    end if;

    v_err_nr := 40;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_lam.nextval
      into v_lam_id
      from dual;
    v_err_nr   := NULL;
    v_err_text := NULL;

    OPEN c_charge;
    FETCH c_charge into v_charge;
    CLOSE c_charge;

    -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
    if not isi_p_base.get_isi_artikel(in_sid,
                                      v_lam.artikel_id,
                                      v_art)
    then
      v_art.artikel_fuer_kunde_etikett := NULL;
    end if;


    if isi_p_base.get_artikel_ctrl_typ(in_sid,
                                       v_lam.artikel_id,
                                       substr(v_lam.hersteller_kuerzel_liste, 1, length(v_lam.hersteller_kuerzel_liste) -1),
                                       v_art_ctrl)
    then
      v_typ := v_art_ctrl.prod_params;
    else
      v_typ := '0000000000';
    end if;

    if  v_lam.hersteller_kuerzel_liste is not NULL
    and v_lam.hersteller_kuerzel_liste != ';'
    and isi_p_base.get_hersteller(substr(v_lam.hersteller_kuerzel_liste, 1, length(v_lam.hersteller_kuerzel_liste) -1),
                                  v_hersteller)
    then
      v_h_tag := v_hersteller.tag;
    else
      v_h_tag := rpad('0', 20, '0');
    end if;
    v_lhm_id := lvs_p_lte.lvs_lte_lhm_next_id_v35 (v_lam.sid,
                                                   v_lam.firma_nr,
                                                   c.BASIS_LHM,
                                                   v_charge.charge_bez,
                                                   v_lam.artikel_id,
                                                   v_art.artikel_fuer_kunde_etikett,
                                                   v_typ,
                                                   v_h_tag);
    v_err_nr := NULL;
    
    --CMe 20220909 (W23910-279): Alte Variante geht davon, dass die original LHM immer vorhanden ist.
    --                           Fix: Jetzt wird geprüft ob die alte LHM noch gibt bzw. ob in lvs_lam
    --                           eine LHM ID vorhanden ist. Wenn ja wird werden von der LHM die Daten als Vorlage 
    --                           verwendet. Sonst werden die Daten aus der LHM CFG geladen und eingetragen    
    
    open c_get_org_lhm;
    fetch c_get_org_lhm into v_org_lhm;
    v_found := c_get_org_lhm%found;
    close c_get_org_lhm;
    
    if (v_found)
    then
      insert into lvs_lhm
             (sid,
              firma_nr,
              lhm_id,
              lte_id,
              lhm_name,
              lgr_platz,
              lhm_vol_hoehe,
              lhm_vol_breite,
              lhm_vol_tiefe,
              lhm_vol,
              lhm_akt_kg,
              lhm_letzte_buchung,
              lhm_eti_druck_status,
              komm_quell_lte_id,
              komm_quell_lgr_platz,
              komm_neu_lhm_name)
      values (v_lam.sid,
              v_lam.firma_nr,
              v_lhm_id,
              v_org_lhm.lte_id,
              v_org_lhm.lhm_name,
              v_org_lhm.lgr_platz,
              nvl(v_org_lhm.lhm_vol_hoehe, 0),
              nvl(v_org_lhm.lhm_vol_breite, 0),
              nvl(v_org_lhm.lhm_vol_tiefe, 0),
              nvl(v_org_lhm.lhm_vol, 0),
              nvl(v_org_lhm.lhm_akt_kg, 0),
              sysdate,
              null,
              in_lte_id,
              v_lte.lgr_platz,
              null);
    else
      open c_lhm_cfg;
      fetch c_lhm_cfg into v_lhm_cfg;
      close c_lhm_cfg;
        
      v_lhm_vol := nvl(v_lhm_cfg.lhm_vol_hoehe, 0) * nvl(v_lhm_cfg.lhm_vol_breite, 0) * nvl(v_lhm_cfg.lhm_vol_tiefe, 0) / 1000000000;
        
      insert into lvs_lhm
             (sid,
              firma_nr,
              lhm_id,
              lte_id,
              lhm_name,
              lgr_platz,
              lhm_vol_hoehe,
              lhm_vol_breite,
              lhm_vol_tiefe,
              lhm_vol,
              lhm_akt_kg,
              lhm_letzte_buchung,
              lhm_eti_druck_status,
              komm_quell_lte_id,
              komm_quell_lgr_platz,
              komm_neu_lhm_name)
      values (v_lam.sid,
              v_lam.firma_nr,
              v_lhm_id,
              in_lte_id,
              v_lhm_cfg.lhm_name,
              v_lte.lgr_platz,
              nvl(v_lhm_cfg.lhm_vol_hoehe, 0),
              nvl(v_lhm_cfg.lhm_vol_breite, 0),
              nvl(v_lhm_cfg.lhm_vol_tiefe, 0),
              v_lhm_vol,
              0,
              sysdate,
              null,
              in_lte_id,
              v_lte.lgr_platz,
              null);
    end if;

    -- Gewicht und Menge wird im Trigger LAM_BH gesetzt
    -- -AG- 06.09.2010 Erweiterung LFDN in der Charge
    insert into lvs_lam
         values (v_lam.sid,                 -- SID                 VARCHAR2(2) not null,
                 v_lam.firma_nr,            -- FIRMA_NR            NUMBER(2) not null,
                 v_lam_id,                  -- LAM_ID              NUMBER not null,
                 v_lam.artikel_id,          -- ARTIKEL_ID          NUMBER,
                 v_lte.lgr_platz,           -- LGR_PLATZ           VARCHAR2(30),
                 v_lte.lte_id,              -- LTE_ID              VARCHAR2(19),
                 v_lhm_id,                  -- LHM_ID              VARCHAR2(19),
                 v_lam.charge_id,           -- CHARGE_ID           NUMBER,
                 v_lam.serie_id,            -- SERIE_ID            NUMBER,
                 v_lam.leitzahl,            -- LEITZAHL            NUMBER,
                 v_lam.fa_ag,               -- FA_AG               NUMBER,
                 v_lam.fa_upos,             -- FA_UPOS             NUMBER,
                 v_lam.abnr,                -- ABNR                VARCHAR2(20),
                 v_lam.best_nr,             -- BEST_NR             VARCHAR2(20),
                 v_lam.best_pos,            -- BEST_POS            VARCHAR2(5),
                 v_lam.res_id,              -- RES_ID              NUMBER,
                 v_lam.prod_datum,          -- PROD_DATUM          DATE,
                 v_lam.zug_datum,           -- ZUG_DATUM           DATE,
                 v_lam.ls_login_id,         -- LS_LOGIN_ID         NUMBER,
                 0,                         -- MENGE               NUMBER,
                 0,                         -- LAM_KG              NUMBER,
                 v_lam.lam_text,            -- LAM_TEXT            VARCHAR2(20),
                 v_lam.labor_status,        -- LABOR_STATUS        CHAR(1),
                 v_lam.labor_text,          -- LABOR_TEXT          VARCHAR2(30),
                 v_lam.lam_mhd,             -- LAM_MHD             DATE,
                 v_lam.kunden_nr,           -- KUNDEN_NR           VARCHAR2(10),
                 v_lam.kd_art_nr,           -- KD_ART_NR           VARCHAR2(30),
                 v_lam.lieferant_nr,        -- LIEFERANT_NR        VARCHAR2(10),
                 v_lam.lam_mhd_ausgabe,     -- LAM_MHD_AUSGABE     DATE,
                 v_lam.menge_basis,         -- MENGE_BASIS         VARCHAR2(3) default 'LKE' not null,
                 v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                 v_lam.order_pos_auf_id,    -- ORDER_POS_AUF_ID    NUMBER
                 v_lam.zeichnung,
                 v_lam.zeichnung_index,
                 v_lam.li_nr_lief,
                 v_lam.lte_id_lieferant,
                 v_lam.sonst_id_lieferant,
                 v_lam.akt_inventur_id,
                 v_lam.letzte_inventur_id,
                 v_lam.letzte_inventur_datum,
                 v_lam.letzte_inventur_login_id,
                 v_lam.lam_p1,
                 v_lam.lam_p2,
                 v_lam.lam_p3,
                 v_lam.lam_p4,
                 v_lam.lam_p5,
                 v_lam.lam_p6,
                 v_lam.lam_p7,
                 v_lam.lam_p8,
                 v_lam.lam_p9,
                 v_lam.lam_p10,
                 NULL,                      -- Die v_lam.res_menge, muss am Anfang auf NULL sein
                 v_lam.res_ziel_lte_id,
                 v_lam.res_login_id,
                 v_lam.check_ware_transp_id,
                 v_lam.fae_id,
                 v_lam.fae_id_position,
                 v_lam.qs_status,
                 v_lam.waren_typ,
                 v_lam.lhm_lfd_nr,   -- (-AM-) 080907 zunächst nur, um das Modul übersetzbar zu machen,
                                     -- Es muss noch BDE_FA_AUFTRAG.LHM_ANZ_IST erhöht werden und dies als
                                     -- LHM_LFD_NR eingetragen werden
                 lvs_komm.get_packschema_kopf_id(in_sid, in_firma_nr, v_lte.lte_id),
                 lvs_komm.get_packschema_lfdn(in_sid, in_firma_nr, v_lte.lte_id),
                 v_lam.lhm_c_lfd_nr,
                 v_lam.owner_address_id,             -- Besitzer wird aus der LAM übernommen
                 v_lam.lam_sel1,                       -- LAM_SEL1  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.lam_sel2,                       -- LAM_SEL2  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.lam_sel3,                       -- LAM_SEL3  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.lam_sel4,                       -- LAM_SEL4  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.lam_sel5,                       -- LAM_SEL5  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.lam_sel6,                       -- LAM_SEL6  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.lam_sel7,                       -- LAM_SEL7  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.lam_sel8,                       -- LAM_SEL8  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.lam_sel9,                       -- LAM_SEL9  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.lam_sel10,                      -- LAM_SEL10 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam.hersteller_kuerzel_liste,
                 v_lam.nr_pruefung);

    v_err_nr := 50;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_vorg_id.nextval
      into v_vorg_id
      from dual;

    v_err_nr := 60;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_lam_bh.nextval
      into v_lam_bh_id
      from dual;

    v_err_nr   := NULL;
    v_err_text := NULL;
    v_lam_bh_kg         := nvl(v_lam_bh.lam_bh_kg, 0);
    v_lam_bh_kg_einheit := nvl(v_lam_bh.lam_bh_kg_einheit, 0);

    -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
    insert into lvs_lam_bh
         values (in_sid,              -- SID               VARCHAR2(2) not null,
                 in_firma_nr,         -- FIRMA_NR          NUMBER(2) not null,
                 v_vorg_id,           -- VORG_ID           NUMBER not null,
                 c.LAM_BH_ZUGAGNG,    -- VORG_TYP          VARCHAR2(2) not null,
                 v_lam_bh_id,         -- LAM_BH_ID         NUMBER not null,
                 v_lam_id,            -- LAM_ID            NUMBER not null,
                 v_lam.artikel_id,    -- ARTIKEL_ID        NUMBER,
                 c.LAM_BH_BUS_ZUG,    -- BUS               NUMBER,
                 sysdate,             -- BUCH_DATUM        DATE,
                 in_user_id,          -- LS_LOGIN_ID       NUMBER,
                 v_lte.lgr_platz,     -- LGR_PLATZ         VARCHAR2(30),
                 in_lte_id,           -- LTE_ID            VARCHAR2(19),
                 v_lhm_id,            -- LHM_ID            VARCHAR2(19),
                 v_lam.charge_id,     -- CHARGE_ID         NUMBER,
                 v_lam.serie_id,      -- SERIE_ID          NUMBER,
                 NULL,                -- ABNR              VARCHAR2(20),
                 nvl(v_menge, 0),     -- MENGE             NUMBER,
                 v_lam_bh_kg,         -- LAM_BH_KG         NUMBER,
                 v_lam_bh_kg_einheit, -- LAM_BH_KG_EINHEIT NUMBER,
                 in_res_id,           -- RES_ID            NUMBER
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 sysdate,                     -- CREATED_DATE N DATE  Y     creation date+time of this dataset
                 in_user_id,                  -- CREATED_LOGIN_ID N NUMBER  Y     login id of the user creating this dataset
                 sysdate,                     -- LAST_CHANGE_DATE N DATE  Y     change date+time of this dataset
                 in_user_id,                  -- LAST_CHANGE_LOGIN_ID N NUMBER  Y     login id of the user changing this dataset
                 null,                        -- CHANGE_MENGE N NUMBER  Y     Menge die geändert wurde
                 v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                 null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

    v_err_nr := 70;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_lam_bh.nextval
      into v_lam_bh_id
      from dual;

    v_err_nr   := NULL;
    v_err_text := NULL;
    -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
    insert into lvs_lam_bh
         values (in_sid,                 -- SID               VARCHAR2(2) not null,
                 in_firma_nr,            -- FIRMA_NR          NUMBER(2) not null,
                 v_vorg_id,              -- VORG_ID           NUMBER not null,
                 c.LAM_BH_ZUGAGNG,       -- VORG_TYP          VARCHAR2(2) not null,
                 v_lam_bh_id,            -- LAM_BH_ID         NUMBER not null,
                 v_lam_id,               -- LAM_ID            NUMBER not null,
                 v_lam.artikel_id,       -- ARTIKEL_ID        NUMBER,
                 c.LAM_BH_BUS_ZUG,       -- BUS               NUMBER,
                 sysdate,                -- BUCH_DATUM        DATE,
                 in_user_id,             -- LS_LOGIN_ID       NUMBER,
                 v_lte.lgr_platz,        -- LGR_PLATZ         VARCHAR2(30),
                 in_lte_id,              -- LTE_ID            VARCHAR2(19),
                 v_lhm_id,               -- LHM_ID            VARCHAR2(19),
                 v_lam.charge_id,        -- CHARGE_ID         NUMBER,
                 v_lam.serie_id,         -- SERIE_ID          NUMBER,
                 NULL,                   -- ABNR              VARCHAR2(20),
                 nvl(v_menge, 0) * -1,  -- MENGE             NUMBER,
                 v_lam_bh_kg * -1,       -- LAM_BH_KG         NUMBER,
                 v_lam_bh_kg_einheit,    -- LAM_BH_KG_EINHEIT NUMBER,
                 in_res_id,              -- RES_ID            NUMBER
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 sysdate,                     -- CREATED_DATE N DATE  Y     creation date+time of this dataset
                 in_user_id,                  -- CREATED_LOGIN_ID N NUMBER  Y     login id of the user creating this dataset
                 sysdate,                     -- LAST_CHANGE_DATE N DATE  Y     change date+time of this dataset
                 in_user_id,                  -- LAST_CHANGE_LOGIN_ID N NUMBER  Y     login id of the user changing this dataset
                 null,                        -- CHANGE_MENGE N NUMBER  Y     Menge die geändert wurde
                 v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                 null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer


    -- 20180203 AG bubfix res_menge
    if v_lam.order_pos_auf_id is not NULL
    then
      if v_menge >= v_lam.res_menge
      then
        v_res_menge_q := NULL;
        v_res_menge_z := v_lam.res_menge;
      else                                    -- dann ist v_menge < v_lam.res_menge (Reservierung verteilen
        v_res_menge_q := v_lam.res_menge - v_menge;
        v_res_menge_z := v_menge;
      end if;
    else
      v_res_menge_q := NULL;
      v_res_menge_z := NULL;
    end if;

    -- 20180203 AG bubfix res_menge
    update lvs_lam l
       set l.res_menge = v_res_menge_q,
           l.order_pos_auf_id = decode(v_res_menge_q, NULL, NULL, l.order_pos_auf_id),
           l.res_ziel_lte_id = decode(v_res_menge_q, NULL, NULL, l.res_ziel_lte_id),
           l.res_login_id = decode(v_res_menge_q, NULL, NULL, l.res_login_id)
     where l.sid = v_lam.sid
       and l.firma_nr = v_lam.firma_nr
       and l.lam_id = v_lam.lam_id;

    -- Update des neg. Zugangs (Zuordnung zur alten LAM)
    update lvs_lam_bh l
       set l.lam_id = v_lam_bh.lam_id,
           l.lhm_id = v_lam_bh.lhm_id
     where l.lam_bh_id = v_lam_bh_id;

    -- dafür den Aggang dem neuen LAM zuordnen
    update lvs_lam_bh l
       set l.lam_id = v_lam_id,
           l.lhm_id = v_lhm_id
     where l.lam_bh_id = in_lam_bh_id;

    update isi_resource_lam_akt r
       set r.lam_id = v_lam_id
     where r.lam_id = in_lam_id;

    update lvs_lam l
       set l.sonst_id_lieferant = in_sonst_id_lieferant,
           l.res_menge = v_res_menge_z,
           l.order_pos_auf_id = decode(v_res_menge_z, NULL, NULL, l.order_pos_auf_id),
           l.res_ziel_lte_id = decode(v_res_menge_z, NULL, NULL, l.res_ziel_lte_id),
           l.res_login_id = decode(v_res_menge_z, NULL, NULL, l.res_login_id)
     where l.sid = v_lam.sid
       and l.firma_nr = v_lam.firma_nr
       and l.lam_id = v_lam_id;

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end lvs_sep_lam;

  --------------------------------------------------------------------------------
  -- procedure macht aus einer lam zwei
  --------------------------------------------------------------------------------
  procedure lvs_c_sep_lam (in_sid                 in isi_sid.sid%type,
                           in_firma_nr            in isi_firma.firma_nr%type,
                           in_res_id              in isi_resource.res_id%type,
                           in_user_id             in isi_user.login_id%type,
                           in_lte_id              in lvs_lte.lte_id%type,
                           in_lam_id              in lvs_lam.lam_id%type,
                           in_lam_bh_id           in lvs_lam_bh.lam_bh_id%type,
                           in_sonst_id_lieferant  in lvs_lam.sonst_id_lieferant%type,
                           in_menge               in lvs_lam.menge%type) is

  begin
    lvs_sep_lam (in_sid,                  -- in_sid                 in isi_sid.sid%type,
                 in_firma_nr,             -- in_firma_nr            in isi_firma.firma_nr%type,
                 in_res_id,               -- in_res_id              in isi_resource.res_id%type,
                 in_user_id,              -- in_user_id             in isi_user.login_id%type,
                 in_lte_id,               -- in_lte_id              in lvs_lte.lte_id%type,
                 in_lam_id,               -- in_lam_id              in lvs_lam.lam_id%type,
                 in_lam_bh_id,            -- in_lam_bh_id           in lvs_lam_bh.lam_bh_id%type,
                 in_sonst_id_lieferant,   -- in_sonst_id_lieferant   in lvs_lam.sonst_id_lieferant%type,
                 in_menge);               -- in_menge               in lvs_lam.menge%type) is
    commit;
  end lvs_c_sep_lam;

  -----------------------------------------------------------------------------
  -- Teilt eine LTE mit einer LHM in n LHM's auf.
  -----------------------------------------------------------------------------
  procedure lvs_c_teile_lhm_auf_lte (in_lte_id           in lvs_lte.lte_id%type,
                                     in_lhm_menge        in lvs_lam.menge%type,
                                     in_lhm_name         in lvs_lhm_cfg.lhm_name%type,
                                     in_login_id         in isi_user.login_id%type,
                                     in_eti_druck_status in lvs_lhm.lhm_eti_druck_status%type
                                     ) is

    ----------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    ----------------------------------------------------------------------------
    v_error    exception;
    v_err_nr   number;
    v_err_text varchar2(255);

    ----------------------------------------------------------------------------
    -- Lokale Variablen
    ----------------------------------------------------------------------------

    v_found                                     boolean;

    v_lte                                       lvs_lte%rowtype;
    v_lhm                                       lvs_lhm%rowtype;
    v_lhm_cfg                                   lvs_lhm_cfg%rowtype;
    v_lam                                       lvs_lam%rowtype;

    v_neue_lam_id                               lvs_lam.lam_id%type;
    v_neue_lhm_id                               lvs_lhm.lhm_id%type;

  CURSOR c_lte is
    select *
      from lvs_lte t
     where t.lte_id = in_lte_id;

  CURSOR c_lhm is
    select *
      from lvs_lhm t
     where t.lte_id = in_lte_id;

  CURSOR c_lhm_cfg is
    select *
      from lvs_lhm_cfg t
     where t.lhm_name = in_lhm_name;

  CURSOR c_lam is
     select *
       from lvs_lam t
      where t.lte_id = in_lte_id;

  begin
    -- Palettendaten lesen
    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found
    then
      v_err_nr := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
      raise v_error;
    end if;

    if v_lte.lte_akt_lhm != 1
    then
      v_err_nr := 20;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_HAT_MEHR_EINE_LHM, in_lte_id);
      raise v_error;
    end if;

    -- LHM Lesen
    OPEN c_lhm;
    FETCH c_lhm into v_lhm;
    CLOSE c_lhm;

    if not v_found
    then
      v_err_nr := 25;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_IST_LEER, in_lte_id);
      raise v_error;
    end if;

    -- LHM CFG lesen
    OPEN c_lhm_cfg;
    FETCH c_lhm_cfg into v_lhm_cfg;
    CLOSE c_lhm_cfg;

    if not v_found
    then
      v_err_nr := 30;
      v_err_text := LC.ec_P1(LC.O_TP1_LHM_CFG_FEHLT, in_lhm_name);
      raise v_error;
    end if;

    -- LAM Lesen
    open c_lam;
    fetch c_lam into v_lam;

    if v_lam.order_pos_auf_id is not null
    then
      v_err_nr := 35;
      v_err_text := LC.ec(LC.O_TXT_LTE_HAT_RES_AUFT_ERR);
      raise v_error;
    end if;

    loop
      exit when c_lam%notfound or v_lam.menge <= in_lhm_menge;
      -- auf der aktuellen LTE solange LHM's kommissionieren bis die Restmenge in eine LHM passt
      lvs_komm.lvs_komm_direct(v_lam.sid,                    -- in_sid           in isi_sid.sid%type,
                               v_lam.firma_nr,               -- in_firma_nr      in isi_firma.firma_nr%type,
                               NULL,                         -- in_res_id        in isi_resource.res_id%type,
                               in_login_id,                  -- in_user_id       in isi_user.login_id%type,
                               in_lte_id,                    -- in_quelle_lte_id in lvs_lte.lte_id%type,
                               v_lam.lam_id,                 -- in_lam_id        in lvs_lam.lam_id%type,
                               in_lhm_menge,                 -- in_menge         in lvs_lam.menge%type,
                               c.LTE_KOMM_GLEICH_LTE,        -- in_ziel_lte_id   in lvs_lte.lte_id%type,
                               v_neue_lam_id,                --  out_neu_lam_id   out lvs_lam.lam_id%type,
                               v_neue_lhm_id);               -- out_neu_lhm_id   out lvs_lhm.lhm_id%type) is

      -- Menge berets bearbeitet, also aus der Quelle abziehen
      v_lam.menge := v_lam.menge - in_lhm_menge;

      -- Neues LHM jetzt auf den LHM_NAMEN setzen
      update lvs_lhm t
         set t.lhm_name = v_lhm_cfg.lhm_name,
             t.lhm_vol_hoehe = v_lhm_cfg.lhm_vol_hoehe,
             t.lhm_vol_breite = v_lhm_cfg.lhm_vol_breite,
             t.lhm_vol_tiefe = v_lhm_cfg.lhm_vol_tiefe
       where t.lhm_id = v_neue_lhm_id;

      if in_eti_druck_status = 'SD'
      then
        update lvs_lhm t
           set t.lhm_eti_druck_status = c.ETI_STATUS_SOLL_DRUCKEN
         where t.lhm_id = v_neue_lhm_id;
      end if;

    end loop;
    close c_lam;

    update lvs_lhm t
       set t.lhm_name = v_lhm_cfg.lhm_name,
           t.lhm_vol_hoehe = v_lhm_cfg.lhm_vol_hoehe,
           t.lhm_vol_breite = v_lhm_cfg.lhm_vol_breite,
           t.lhm_vol_tiefe = v_lhm_cfg.lhm_vol_tiefe
     where t.lhm_id = v_lam.lhm_id;

    if (v_lam.menge < in_lhm_menge and in_eti_druck_status = 'RM')
       or in_eti_druck_status = 'SD'
    then
      -- Etikett nur bei Restmenge drucken
      update lvs_lhm t
         set t.lhm_eti_druck_status = decode (t.lhm_eti_druck_status,
                                              c.ETI_STATUS_GEDRUCKT, c.ETI_STATUS_NEU_DRUCKEN,
                                              c.ETI_STATUS_SOLL_DRUCKEN)
       where t.lhm_id = v_lam.lhm_id;
    end if;

    update lvs_lte t
       set t.lte_eti_druck_status = decode (t.lte_eti_druck_status,
                                            c.ETI_STATUS_GEDRUCKT, c.ETI_STATUS_NEU_DRUCKEN,
                                            c.ETI_STATUS_SOLL_DRUCKEN),
           t.lte_name = decode(t.lte_name, c.KeineLTE, c.VirtualLTE, t.lte_name), -- WK 20110606: Bugfix SC3951
           t.res_login_id = in_login_id
     where t.lte_id = in_lte_id;
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_lam%isopen
      then
        CLOSE c_lam;
      end if;
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_lam%isopen
      then
        CLOSE c_lam;
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
  end lvs_c_teile_lhm_auf_lte;

  procedure split_spez_barcode(in_barcode              in  lvs_lam.lhm_id%type,
                               in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                               out_artikel             out varchar2,
                               out_charge              out varchar2,
                               out_prod_datum_str      out varchar2,
                               out_prod_datum_struktur out varchar2,
                               out_menge_str           out varchar2,
                               out_ean                 out varchar2,
                               out_lfd_nr_str          out varchar2,
                               out_linie_str           out varchar2)
                               is

    v_start_pos number;
    v_add_length number;

  begin
    v_add_length := 0;
    out_artikel := '';
    out_charge := '';
    out_prod_datum_str := '';
    out_menge_str := '';
    out_ean := '';

    v_start_pos := 1;
    -- Barcode kann jetzt auch die Linie oder Dummydaten haben

    -- !!! Achtung Änderungen hier auch in Modul BDE_SCANNER.spez_barcode_gen ändern redundante Routine
    -- !!!                              in Modul LVS_P_LTE_LHM.spez_barcode_gen
    -- !!!                              in Modul ISI_UTILS.spez_barcode_gen

    while (v_start_pos <= length(in_parameter_wert) + v_add_length) loop
      if    substr(in_parameter_wert, v_start_pos - v_add_length, 1) = '?' then NULL; -- Hier ist nicht fie ISIPlus zu tun
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 1) = 'A' then -- -AG- Artikel ist ein String und hat keine Leerzeichen
                                                                           if substr(in_barcode, v_start_pos, 1) != ' '
                                                                           then
                                                                             out_artikel := out_artikel || substr(in_barcode, v_start_pos, 1);
                                                                           end if;
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 1) = 'C' then out_charge  := out_charge  || substr(in_barcode, v_start_pos, 1);
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 6) = 'PDMMYY' then out_prod_datum_str := substr(in_barcode, v_start_pos, 6);
                                                                      out_prod_datum_struktur := 'DDMMYY';
                                                                      v_start_pos := v_start_pos + 5;
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 5) = 'EAN06'  then out_ean := substr(in_barcode, v_start_pos, 6);
                                                                      v_add_length := v_add_length + 1;
                                                                      v_start_pos := v_start_pos + 5;
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 5) = 'EAN13'  then out_ean := substr(in_barcode, v_start_pos, 13);
                                                                      v_add_length := v_add_length + 8;
                                                                      v_start_pos := v_start_pos + 12;
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 5) = 'EAN14'  then out_ean := substr(in_barcode, v_start_pos, 14);
                                                                      v_add_length := v_add_length + 9;
                                                                      v_start_pos := v_start_pos + 13;
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 1) = 'P' then out_lfd_nr_str  := out_lfd_nr_str  || substr(in_barcode, v_start_pos, 1);
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 1) = '_' then out_lfd_nr_str  := out_lfd_nr_str  || substr(in_barcode, v_start_pos, 1);
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 1) = 'M' then out_menge_str  := out_menge_str  || substr(in_barcode, v_start_pos, 1);
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 1) = 'm' then out_menge_str  := out_menge_str  || ',' || substr(in_barcode, v_start_pos, 1);
      elsif substr(in_parameter_wert, v_start_pos - v_add_length, 1) = 'L' then out_linie_str  := out_linie_str  || substr(in_barcode, v_start_pos, 1);
      end if;
      v_start_pos := v_start_pos + 1;
    end loop;
  end split_spez_barcode;

  procedure spez_barcode_result(in_sid      in isi_sid.sid%type,
                                in_firma_nr in isi_firma.firma_nr%type,
                                in_barcode              in  lvs_lam.lhm_id%type,
                                in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                                out_artikel             out isi_artikel%rowtype,
                                out_charge              out varchar2,
                                out_prod_datum          out date,
                                out_menge               out number,
                                out_ean                 out varchar2,
                                out_lfd_nr_str          out varchar2,
                                out_linie_str           out varchar2) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error       EXCEPTION;
    v_err_nr      number;
    v_err_text    varchar2(255);

    v_artikel                     isi_artikel%rowtype;
    v_menge_str                   varchar2(20);

    v_prod_datum_str              varchar2(30);
    v_prod_datum_struktur         varchar2(30);
    v_sysdate                     date;

    v_parameter                   isi_firma_cfg.parameter_wert%type;

    v_found                       boolean;

    CURSOR c_artikel is
      select *
        from isi_artikel a
       where a.artikel_kurz = out_artikel.artikel;
  begin
    split_spez_barcode(in_barcode,                       -- in_barcode              in  lvs_lam.lhm_id%type,
                       in_parameter_wert,                -- in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                       out_artikel.artikel,              -- out_artikel             out varchar2,
                       out_charge,                       -- out_charge              out varchar2,
                       v_prod_datum_str,                 -- out_prod_datum_str      out varchar2,
                       v_prod_datum_struktur,            -- out_prod_datum_struktur out varchar2,
                       v_menge_str,                      -- out_menge_str           out varchar2,
                       out_ean,                          -- out_ean                 out varchar2
                       out_lfd_nr_str,                   -- out_lfd_nr_str          out varchar2
                       out_linie_str);                   -- out_linie_str           out varchar2

    -- Sollen führende 0 aus dem Artikel gelöscht werden
    if isi_allg.c_get_firma_cfg_param(in_sid,
                                      in_firma_nr,
                                      'CFG',                                     -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                      'ARTIKEL_DEL_L_ZERO',                      -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                      'SPEZ_BARCODE',                            -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'CFG',                                     -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                      'CFG',                                     -- in_typ                   in isi_firma_cfg.typ%type,
                                      c.C_FALSE,                                 -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                      'BOOLEAN') = c.C_TRUE                      -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    then
      LOOP
        exit when (substr(out_artikel.artikel, 1, 1) != '0'
               or length(out_artikel.artikel) = 0);

        out_artikel.artikel := substr(out_artikel.artikel, 2);
      end LOOP;
    end if;

    if length(out_artikel.artikel) = 0
    then
      v_err_nr := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_ARTIKEL_FEHLT, 'BARCODE');
      -- v_err_text := 'Artikel NR Fehlt';
      raise v_error;
    end if;

    -- -AG- Neue Funktionalitaet Barcode kann auf neuene oder alten Barcode referenzzieren
    -- -AG- funktion nutzen und Artikeldaten lesen
    if not isi_p_base.get_isi_artikel_by_nr(out_artikel.artikel, v_artikel)
    then
      -- Gab es einen alten barcode mit anderer Struktur für die alte Artikelnummer
      v_parameter :=
        isi_allg.c_get_firma_cfg_param(in_sid,
                                        in_firma_nr,
                                        'CFG',                                     -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                                      -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'SPEZ_BARCODE_OLD',                        -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'CFG',                                     -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                                     -- in_typ                   in isi_firma_cfg.typ%type,
                                        'N.A.',                                    -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'STRING');                                 -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
      if v_parameter != 'N.A.'
      then
        split_spez_barcode(in_barcode,                       -- in_barcode              in  lvs_lam.lhm_id%type,
                           v_parameter,                      -- in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                           out_artikel.artikel,              -- out_artikel             out varchar2,
                           out_charge,                       -- out_charge              out varchar2,
                           v_prod_datum_str,                 -- out_prod_datum_str      out varchar2,
                           v_prod_datum_struktur,            -- out_prod_datum_struktur out varchar2,
                           v_menge_str,                      -- out_menge_str           out varchar2,
                           out_ean,                          -- out_ean                 out varchar2
                           out_lfd_nr_str,                   -- out_lfd_nr_str          out varchar2
                           out_linie_str);                   -- out_linie_str           out varchar2
      end if;

      if isi_allg.c_get_firma_cfg_param(in_sid,
                                        in_firma_nr,
                                        'CFG',                                     -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        'ARTIKEL_DEL_L_ZERO',                      -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'SPEZ_BARCODE',                            -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'CFG',                                     -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                                     -- in_typ                   in isi_firma_cfg.typ%type,
                                        c.C_FALSE,                                    -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_TRUE                       -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
      then
        LOOP
          exit when (substr(out_artikel.artikel, 1, 1) != '0'
                 or length(out_artikel.artikel) = 0);

          out_artikel.artikel := substr(out_artikel.artikel, 2);
        end LOOP;
      end if;

      if length(out_artikel.artikel) = 0
      then
        v_err_nr := 10;
        v_err_text := LC.ec_p1(LC.O_TP1_ARTIKEL_FEHLT, 'BARCODE');
        -- v_err_text := 'Artikel NR Fehlt';
        raise v_error;
      end if;


      -- -AG- Im Barcode kann auch ein alte Artikelnummer sein (artikel_kurz)
      OPEN c_artikel;
      FETCH c_artikel into out_artikel;
      v_found := c_artikel%FOUND;
      CLOSE c_artikel;
    else
      out_artikel := v_artikel;
      v_found := TRUE;
    end if;

    if not v_found
    then
      v_err_nr := 80;
      v_err_text :=  LC.ec_p1(LC.O_TP1_ARTIKEL_FEHLT, out_artikel.artikel);
      -- v_err_text := 'Artikelnr: ' || out_artikel.artikel || ' fehlt';
      raise v_error;
    end if;

    -- -AG- Falls die Charge im Barcode mit Fuellzeichen aufgefüllt sind, dann jetzt für die Cahrgebez rausnehmen
    --      Aber nur bis zur minimalen Laenge
    while length(out_charge) > isi_allg.c_get_firma_cfg_param(in_sid,
                                                              in_firma_nr,
                                                              'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                              NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                              'CHARGE_MIN_LENGTH',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                              'CFG',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                              'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                              '1',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                              'INTEGER')            -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
      -- -AG- Ist das erste zeichen das Fuellzeichen?
      and substr(out_charge, 1, 1) = isi_allg.c_get_firma_cfg_param(in_sid,
                                                                    in_firma_nr,
                                                                    'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                                    NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                                    'CHARGE_AUT_FIL_CHAR', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                    'CFG',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                    'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                                    NULL,                  -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                    'STRING')              -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,

    loop
      out_charge := substr(out_charge, 2);
    end loop;
    if length(out_charge) = 0
    then
      v_err_nr := 20;
      v_err_text :=  LC.ec_p1(LC.O_TP1_CHARGE_ZU_KURZ, '0 - BARCODE');
      --  v_err_text := 'Charge NR Fehlt';
      raise v_error;
    end if;

    if length(v_menge_str) = 0
    then
      v_err_nr := 30;
      v_err_text :=  LC.ec(LC.O_TXT_MENGE_FEHLT);
      -- v_err_text := 'Menge Fehlt';
      raise v_error;
    end if;
    if length(v_prod_datum_str) = 0
    then
      v_err_nr := 40;
      v_err_text :=  LC.ec(LC.O_TXT_PROD_DATUM_FEHLT);
      -- v_err_text := 'Prod. Datum Fehlt';
      raise v_error;
    end if;

    v_err_nr := 50;
    v_err_text :=  LC.ec(LC.O_TXT_MENGE_FEHLER);
    -- v_err_text := 'Fehler in der Menge';
    if v_menge_str != ',' -- Keine Menge
    then
      out_menge := to_number(v_menge_str);
    end if;

    v_err_nr := 60;
    v_err_text :=  LC.ec(LC.O_TXT_DATUM_FEHLER);
    -- v_err_text := 'Fehler im Datum';
    out_prod_datum := to_date(v_prod_datum_str, v_prod_datum_struktur);

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end spez_barcode_result;

  function insert_lhm_aus_barcode(in_sid             in isi_sid.sid%type,
                                  in_firma_nr        in isi_firma.firma_nr%type,
                                  in_barcode         in lvs_lam.lhm_id%type,
                                  in_parameter_wert  in isi_firma_cfg.parameter_wert%type,
                                  in_login_id        in isi_user.login_id%type,
                                  in_out_menge       in out number,
                                  in_lte_barcode     in lvs_lam.lte_id%type)
                                  return varchar2 is

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error       exception;
    v_err_nr      number;
    v_err_text    varchar2(255);

    v_lam                         lvs_lam%rowtype;

    v_artikel                     isi_artikel%rowtype;
    v_charge                      lvs_charge.charge_bez%type;
    v_ean                         varchar2(20);
    v_lfd_nr_str                  varchar2(20);
    v_linie_str                   varchar2(20);

    v_menge                       lvs_lam.menge%type;
    v_prod_datum                  date;

    v_sysdate                     date;

    v_found                       boolean;
    v_lte_barcode                 lvs_lte.lte_id%type;

    CURSOR c_lte_lhm is
      select l.*
        from lvs_lam l
       where l.lte_id = v_lte_barcode;

  begin

    spez_barcode_result(in_sid,
                        in_firma_nr,
                        in_barcode,              -- in  lvs_lam.lhm_id%type,
                        in_parameter_wert ,      -- in  isi_firma_cfg.parameter_wert%type,
                        v_artikel,               -- out_artikel
                        v_charge,                -- out varchar2,
                        v_prod_datum,            -- out date,
                        v_menge,                 -- out number,
                        v_ean,                   -- out varchar2
                        v_lfd_nr_str,            -- out varchar2
                        v_linie_str);            -- out varchar2

    -- -AG- Wenn übergebene Barcode OK
    begin
      v_lte_barcode := in_lte_barcode;
    exception
      when others then
        v_lte_barcode := NULL;
    end;
    -- -AG- Wenn noch Keine LTE_ID dann Gen wie früher
    if v_lte_barcode is NULL
    then
      v_lte_barcode := v_artikel.artikel || v_charge || nvl(v_lfd_nr_str, '');
    end if;

    v_sysdate := sysdate;
    lvs_p_lte.lvs_c_lte_artikel_erzeugen (in_sid,                             -- in_sid                 in isi_sid.sid%type,
                                          in_firma_nr,                        -- in_firma_nr            in isi_firma.firma_nr%type,
                                          v_lte_barcode,                      -- in_lte_id              in lvs_lte.lte_id%type,
                                          v_artikel.artikel,                  -- in_artikel             in isi_artikel.artikel%type,
                                          v_artikel.menge_basis,              -- in_menge_basis         in lvs_lam.menge_basis%type,
                                          v_artikel.mengeneinheit_basis,      -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                          v_charge,                           -- in_charge              in lvs_charge.charge_bez%type,
                                          nvl(in_out_menge, v_menge),         -- in_menge               in lvs_lam.menge%type,
                                          v_artikel.lte_hoehe_max,            -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                          v_artikel.lte_breite_max,           -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                          v_artikel.lte_tiefe_max,            -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                          v_artikel.lte_name,                 -- in_lte_name            in lvs_lte.lte_name%type,
                                          v_artikel.lte_gewicht_kg,           -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                          v_prod_datum,                       -- in_prod_datum          in lvs_lam.prod_datum%type,
                                          v_sysdate,                          -- in_zug_datum           in lvs_lam.zug_datum%type,
                                          v_prod_datum + v_artikel.mhd_tage,  -- in_mhd                 in lvs_lam.lam_mhd%type,
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

    in_out_menge := v_menge;
    return (v_lam.lhm_id);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  
  /*
  __________________________________________________
  Author    : CMe
  Created   : 08.08.2022
  __________________________________________________
  Description
  Die PRozedur fasst alle LAM's auf einer LTE zusammen, die noch keine reservierung haben.
  
  Ticket: P71141-237
  __________________________________________________
  TODO
  none.
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  08.08.2022   DB31_1      (-CMe-)  Neue Logik erstellt
  11.08.2022   DB31_3      (-CMe-)  MHD berücksichtigen falls gewünscht
  06.04.2023   DB31_4      (-CMe-)  Laborstatus berücksichtigen (W23910-343)
  */
  procedure unite_lams_without_reservation (in_sid          in lvs_lam_bh.sid%type,
                                            in_firma_nr     in lvs_lam_bh.firma_nr%type,
                                            in_lte_id       in lvs_lte.lte_id%type,
                                            in_user_id      in isi_user.login_id%type,
                                            in_consider_mhd in varchar2,
                                            in_min_mhd      in date) is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error                    exception;
  v_err_nr                   number;
  v_err_text                 varchar2(255);
  
  v_target_lam_id            lvs_lam.lam_id%type;
  v_target_lam_art_id        lvs_lam.artikel_id%type;
  v_target_lam_prod_list     lvs_lam.hersteller_kuerzel_liste%type;
  v_target_lam_owner_id      lvs_lam.owner_address_id%type;
  v_target_lam               lvs_lam%rowtype;
  
  v_source_lam               lvs_lam%rowtype;
  v_source_lam_bh_kg         lvs_lam_bh.lam_bh_id%type;         -- Gewicht der Wahre
  v_source_lam_bh_kg_einheit lvs_lam_bh.lam_bh_kg_einheit%type; -- Gewicht der eine Wahre
  
  v_lam_bh_id                lvs_lam_bh.lam_bh_id%type; -- Neu LAM_BH_ID aus Sequenz
  v_vorg_id                  lvs_lam_bh.vorg_id%type;   -- Neu VORGang_ID aus Sequenz
  v_found                    boolean;
  
  --CMe 20220811 MHD und Konsi berücksichtigen
  --CMe 20230405 Laborstatus berücksichtigen
  cursor c_get_target_lam is
    select max(lam.lam_id),
           lam.artikel_id,
           lam.hersteller_kuerzel_liste,
           lam.owner_address_id
      from lvs_lam lam
     where 1=1
       and lam.sid = in_sid
       and lam.firma_nr = in_firma_nr
       and lam.lte_id = in_lte_id
       and lam.order_pos_auf_id is null
       and (in_consider_mhd = 'T' and lam.lam_mhd >= in_min_mhd)
       and lam.labor_status = 'F'
     group by lam.artikel_id,
              lam.hersteller_kuerzel_liste,
              lam.owner_address_id;
  
  cursor c_get_target_lam_comp is
    select lam.*
      from lvs_lam lam
     where 1=1
       and lam.sid = in_sid
       and lam.firma_nr = in_firma_nr
       and lam.lam_id = v_target_lam_id;
  
  --CMe 20220811 MHD und Konsi berücksichtigen
  --CMe 20230405 Laborstatus berücksichtigen
  cursor c_get_source_lams is
    select lam.*
      from lvs_lam lam
     where 1=1
       and lam.sid = in_sid
       and lam.firma_nr = in_firma_nr
       and lam.order_pos_auf_id is null
       and lam.artikel_id = v_target_lam_art_id
       and lam.hersteller_kuerzel_liste = v_target_lam_prod_list
       and lam.owner_address_id = v_target_lam_owner_id
       and lam.lam_id != v_target_lam_id
       and lam.lte_id = in_lte_id
       and (in_consider_mhd = 'T' and lam.lam_mhd >= in_min_mhd)
       and lam.labor_status = 'F'
      order by lam.lam_id asc;
      
  begin
    open c_get_target_lam;
    loop
      fetch c_get_target_lam into v_target_lam_id,
                                  v_target_lam_art_id,
                                  v_target_lam_prod_list,
                                  v_target_lam_owner_id;
      
      exit when c_get_target_lam%notfound;
      
      open c_get_target_lam_comp;
      fetch c_get_target_lam_comp into v_target_lam;
      close c_get_target_lam_comp;
      
      open c_get_source_lams;
      loop
        fetch c_get_source_lams into v_source_lam;
        exit when c_get_source_lams%notfound;
        
        if (nvl(v_source_lam.menge, 0) <> 0) 
        then
          v_source_lam_bh_kg         := (nvl(v_source_lam.lam_kg, 0) *
                                         nvl(v_source_lam.res_menge, 0)) /
                                        nvl(v_source_lam.menge, 0);
          v_source_lam_bh_kg_einheit := nvl(v_source_lam.lam_kg, 0) / nvl(v_source_lam.menge, 0);
        else
          v_source_lam_bh_kg         := 0;
          v_source_lam_bh_kg_einheit := 0;
        end if;
        
        select seq_vorg_id.nextval into v_vorg_id from dual;
        select seq_lam_bh.nextval into v_lam_bh_id from dual;
        
        insert into lvs_lam_bh
               (sid,
                firma_nr,
                vorg_id,
                vorg_typ,
                lam_bh_id,
                lam_id,
                artikel_id,
                bus,
                buch_datum,
                ls_login_id,
                lgr_platz,
                lte_id,
                lhm_id,
                charge_id,
                serie_id,
                abnr,
                menge,
                lam_bh_kg,
                lam_bh_kg_einheit,
                res_id,
                leitzahl,
                fa_ag,
                fa_upos,
                abnr_extern,
                vorgang_id,
                li_nr,
                li_pos_nr,
                created_date,
                created_login_id,
                last_change_date,
                last_change_login_id,
                change_menge,
                owner_address_id,
                owner_address_id_new)
        values (v_source_lam.sid,
                v_source_lam.firma_nr,
                v_vorg_id,
                c.LAM_BH_ABGAGNG,
                v_lam_bh_id,
                v_source_lam.lam_id,
                v_source_lam.artikel_id,
                c.LAM_BH_BUS_ABG_KOMM,
                sysdate,
                in_user_id,
                v_source_lam.lgr_platz,
                v_source_lam.lte_id,
                v_source_lam.lhm_id,
                v_source_lam.charge_id,
                v_source_lam.serie_id,
                NULL,
                nvl(v_source_lam.menge, 0),
                v_source_lam_bh_kg,
                v_source_lam_bh_kg_einheit,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                sysdate,
                in_user_id,
                sysdate,
                in_user_id, 
                null,
                v_source_lam.owner_address_id,
                null);
      
        select seq_lam_bh.nextval into v_lam_bh_id from dual;
      
        insert into lvs_lam_bh
               (sid,
                firma_nr,
                vorg_id,
                vorg_typ,
                lam_bh_id,
                lam_id,
                artikel_id,
                bus,
                buch_datum,
                ls_login_id,
                lgr_platz,
                lte_id,
                lhm_id,
                charge_id,
                serie_id,
                abnr,
                menge,
                lam_bh_kg,
                lam_bh_kg_einheit,
                res_id,
                leitzahl,
                fa_ag,
                fa_upos,
                abnr_extern,
                vorgang_id,
                li_nr,
                li_pos_nr,
                created_date,
                created_login_id,
                last_change_date,
                last_change_login_id,
                change_menge,
                owner_address_id,
                owner_address_id_new)
        values (v_target_lam.sid,
                v_target_lam.firma_nr,
                v_vorg_id,
                c.LAM_BH_ZUGAGNG,
                v_lam_bh_id,
                v_target_lam.lam_id,
                v_source_lam.artikel_id,
                c.LAM_BH_BUS_ZUG_KOMM,
                sysdate,
                in_user_id,
                v_source_lam.lgr_platz,
                v_source_lam.lte_id,
                v_target_lam.lhm_id,
                v_source_lam.charge_id,
                v_source_lam.serie_id,
                null,
                nvl(v_source_lam.menge, 0),
                v_source_lam_bh_kg,
                v_source_lam_bh_kg_einheit,
                NULL,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                sysdate,
                in_user_id,
                sysdate,
                in_user_id,
                null,
                v_source_lam.owner_address_id,
                null);
      end loop;
      close c_get_source_lams;
    end loop;
    close c_get_target_lam;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if (c_get_target_lam%isopen) then
        close c_get_target_lam;
      end if;
      
      if (c_get_source_lams%isopen) then
        close c_get_source_lams;
      end if;
      
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      
      if (c_get_target_lam%isopen) then
        close c_get_target_lam;
      end if;
      
      if (c_get_source_lams%isopen) then
        close c_get_source_lams;
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
  end unite_lams_without_reservation;

/*
  __________________________________________________
  Author    : CMe
  Created   : 25.04.2022
  __________________________________________________
  Description
  Die Prozedur prüft, ob es auf einer Palette bereits eine Reservierung für eine order gibt.
  
  Wenn das der Fall ist, wird die reservierte Menge der neu Reservierte LAM auf die bereits vorhandene
  LAM umgeschrieben und die Menge, sowie das Gewicht entsprechend reserviert.
  
  Ticket: P71141-171
  __________________________________________________
  TODO
  none.
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  25.04.2022   DB31_1      (-CMe-)  Neue Logik erstellt
  08.08.2022   DB31_2      (-CMe-)  Anpassung fuer Ticket P71141-237, Umzug von pps_p_bde nach lvs_p_lte_lhm
  11.08.2022   DB31_3      (-CMe-)  MHD berücksichtigen falls gewünscht
  06.04.2023   DB31_4      (-CMe-)  Laborstatus berücksichtigen (W23910-343)
  */
  procedure add_amount_to_reservation (in_sid          in lvs_lam_bh.sid%type,
                                       in_firma_nr     in lvs_lam_bh.firma_nr%type,
                                       in_lte_id       in lvs_lte.lte_id%type,
                                       in_auf_id       in lvs_lam.order_pos_auf_id%type,
                                       in_user_id      in isi_user.login_id%type,
                                       in_consider_mhd in varchar2,
                                       in_min_mhd      in date) is
  
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error               exception;
  v_err_nr              number;
  v_err_text            varchar2(255);
  
  v_found               boolean;
  
  v_lam_bh_id           lvs_lam_bh.lam_bh_id%type;        -- Neu LAM_BH_ID aus Sequenz
  v_vorg_id             lvs_lam_bh.vorg_id%type;          -- Neu VORGang_ID aus Sequenz

  v_s_lam_bh_kg         lvs_lam_bh.lam_bh_id%type;         -- Gewicht der Wahre
  v_s_lam_bh_kg_einheit lvs_lam_bh.lam_bh_kg_einheit%type; -- Gewicht der eine Wahre
    
  v_t_lam               lvs_lam%rowtype;
  v_t_lam_id            lvs_lam.lam_id%type;
  
  v_s_lam               lvs_lam%rowtype;
  
  --CMe 20220811 MHD berücksichtigen
  --CMe 20230405 Laborstatus berücksichtigen
  cursor c_get_t_lam_id is
    select max(lam.lam_id)
      from lvs_lam lam
     where 1=1
       and lam.sid = in_sid 
       and lam.firma_nr = in_firma_nr
       and lam.order_pos_auf_id = in_auf_id
       and lam.lte_id = in_lte_id
       and (in_consider_mhd = 'T' and lam.lam_mhd >= in_min_mhd)
       and lam.labor_status = 'F';
  
  cursor c_get_t_lam_compl is
    select lam.*
      from lvs_lam lam
     where 1=1
       and lam.sid = in_sid 
       and lam.firma_nr = in_firma_nr
       and lam.lam_id = v_t_lam_id;
  
  --CMe 20220811 MHD berücksichtigen
  --CMe 20230405 Laborstatus berücksichtigen
  cursor c_get_s_lams_compl is
    select lam.*
      from lvs_lam lam
     where 1=1
       and lam.sid = in_sid 
       and lam.firma_nr = in_firma_nr
       and lam.order_pos_auf_id = in_auf_id
       and lam.lte_id = in_lte_id
       and lam.lam_id != v_t_lam_id
       and (in_consider_mhd = 'T' and lam.lam_mhd >= in_min_mhd)
       and lam.labor_status = 'F'
     order by lam.lam_id asc;
     
  begin
    open c_get_t_lam_id;
    fetch c_get_t_lam_id into v_t_lam_id;
    v_found := c_get_t_lam_id%found;
    close c_get_t_lam_id;
    
    if (v_found)
    then
      open c_get_t_lam_compl;
      fetch c_get_t_lam_compl into v_t_lam;
      close c_get_t_lam_compl;
      
      open c_get_s_lams_compl;
      loop
        fetch c_get_s_lams_compl into v_s_lam;
        exit when c_get_s_lams_compl%notfound;
        
      if (nvl(v_s_lam.menge, 0) <> 0) 
      then
        v_s_lam_bh_kg         := (nvl(v_s_lam.lam_kg, 0) *
                                  nvl(v_s_lam.menge, 0)) /
                                 nvl(v_s_lam.menge, 0);
        v_s_lam_bh_kg_einheit := nvl(v_s_lam.lam_kg, 0) / nvl(v_s_lam.menge, 0);
      else
        v_s_lam_bh_kg         := 0;
        v_s_lam_bh_kg_einheit := 0;
      end if;
      
      select seq_vorg_id.nextval into v_vorg_id from dual;
      select seq_lam_bh.nextval into v_lam_bh_id from dual;
      
      insert into lvs_lam_bh
             (sid,
              firma_nr,
              vorg_id,
              vorg_typ,
              lam_bh_id,
              lam_id,
              artikel_id,
              bus,
              buch_datum,
              ls_login_id,
              lgr_platz,
              lte_id,
              lhm_id,
              charge_id,
              serie_id,
              abnr,
              menge,
              lam_bh_kg,
              lam_bh_kg_einheit,
              res_id,
              leitzahl,
              fa_ag,
              fa_upos,
              abnr_extern,
              vorgang_id,
              li_nr,
              li_pos_nr,
              created_date,
              created_login_id,
              last_change_date,
              last_change_login_id,
              change_menge,
              owner_address_id,
              owner_address_id_new)
      values (v_s_lam.sid,
              v_s_lam.firma_nr,
              v_vorg_id,
              c.LAM_BH_ABGAGNG,
              v_lam_bh_id,
              v_s_lam.lam_id,
              v_s_lam.artikel_id,
              c.LAM_BH_BUS_ABG_KOMM,
              sysdate,
              in_user_id,
              v_s_lam.lgr_platz,
              v_s_lam.lte_id,
              v_s_lam.lhm_id,
              v_s_lam.charge_id,
              v_s_lam.serie_id,
              NULL,
              nvl(v_s_lam.menge, 0),
              v_s_lam_bh_kg,
              v_s_lam_bh_kg_einheit,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              sysdate,
              in_user_id,
              sysdate,
              in_user_id, 
              null,
              v_s_lam.owner_address_id,
              null);
      
      select seq_lam_bh.nextval into v_lam_bh_id from dual;
      
      insert into lvs_lam_bh
             (sid,
              firma_nr,
              vorg_id,
              vorg_typ,
              lam_bh_id,
              lam_id,
              artikel_id,
              bus,
              buch_datum,
              ls_login_id,
              lgr_platz,
              lte_id,
              lhm_id,
              charge_id,
              serie_id,
              abnr,
              menge,
              lam_bh_kg,
              lam_bh_kg_einheit,
              res_id,
              leitzahl,
              fa_ag,
              fa_upos,
              abnr_extern,
              vorgang_id,
              li_nr,
              li_pos_nr,
              created_date,
              created_login_id,
              last_change_date,
              last_change_login_id,
              change_menge,
              owner_address_id,
              owner_address_id_new)
      values (v_s_lam.sid,
              v_s_lam.firma_nr,
              v_vorg_id,
              c.LAM_BH_ZUGAGNG,
              v_lam_bh_id,
              v_t_lam.lam_id,
              v_s_lam.artikel_id,
              c.LAM_BH_BUS_ZUG_KOMM,
              sysdate,
              in_user_id,
              v_s_lam.lgr_platz,
              v_s_lam.lte_id,
              v_t_lam.lhm_id,
              v_s_lam.charge_id,
              v_s_lam.serie_id,
              null,
              nvl(v_s_lam.menge, 0),
              v_s_lam_bh_kg,
              v_s_lam_bh_kg_einheit,
              NULL,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              sysdate,
              in_user_id,
              sysdate,
              in_user_id,
              null,
              v_s_lam.owner_address_id,
              null);
      
      update lvs_lam lam
         set lam.order_pos_auf_id = null,
             lam.res_menge = 0,
             lam.res_login_id = null,
             lam.res_id = null,
             lam.res_ziel_lte_id = null
       where 1=1
         and lam.sid = v_s_lam.sid
         and lam.firma_nr = v_s_lam.firma_nr
         and lam.lam_id = v_s_lam.lam_id;
         
      end loop;
      close c_get_s_lams_compl;
      
      update lvs_lam lam
         set lam.res_menge = lam.menge
       where 1=1
         and lam.sid = v_t_lam.sid
         and lam.firma_nr = v_t_lam.firma_nr
         and lam.lam_id = v_t_lam.lam_id;
    end if;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then
      if (c_get_s_lams_compl%isopen) then
        close c_get_s_lams_compl;
      end if;
      
      v_err_text := v_err_text || CHR(13) || CHR(10) ||
                    DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if (c_get_s_lams_compl%isopen) then
        close c_get_s_lams_compl;
      end if;
      
      if v_err_nr is not NULL then
        v_err_text := v_err_text || CHR(13) || CHR(10) ||
                      DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%' then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) ||
                        DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end add_amount_to_reservation;
  
end lvs_p_lte_lhm;
/



-- sqlcl_snapshot {"hash":"70ffbf6c8629fd61e5e83ec0557a281affd28316","type":"PACKAGE_BODY","name":"LVS_P_LTE_LHM","schemaName":"DIRKSPZM32","sxml":""}