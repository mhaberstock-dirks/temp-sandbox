create or replace 
package body DIRKSPZM32.PZM_KONTOVERWALTUNG is
  /* Neue Kontoverwaltung umsetzung Feb 2006 (-WK-) */

  /* Kontoinformationen */

  /***********************************************************************************************
   * is_konto_vorhanden prüft anhand der Kriterien Personalnummer, Kontonamenskürzel ('UK', 'FK', 'ZK'),
   * ob ein Konto vorhanden ist und gibt ggf. die entspr. Kontonummer zurück
   */
  function is_konto_vorhanden(in_sid in isi_sid.sid%type,
                              in_firma_nr in isi_firma.firma_nr%type,
                              in_pers_nr in pzm_personal.pers_nr%type,
                              in_name_kurz in pzm_konten.name_kurz%type,
                              in_typ in pzm_konten.typ%type,
                              out_konto out pzm_konten%rowtype) return boolean is

    --v_pzm_konten pzm_konten%rowtype;

    cursor c_pzm_konten is
      select t.*
        from pzm_konten t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.pers_nr = in_pers_nr
         and upper(t.name_kurz) = upper(in_name_kurz) -- case insensitive
         and t.typ = in_typ;

    v_found boolean;
  begin
    open c_pzm_konten;

    fetch c_pzm_konten into out_konto;
    v_found := c_pzm_konten%found;

    close c_pzm_konten;

    --if v_found
    --then
    --  out_konto := v_pzm_konten;
    --end if;

    return (v_found);
  end;

  /***********************************************************************************************
   * get_akt_saldo gibt den aktuellen Kontostand des angegebenen Kontos zurück
   */
  function get_akt_saldo(in_sid in isi_sid.sid%type,
                         in_firma_nr in isi_firma.firma_nr%type,
                         in_pers_nr in pzm_personal.pers_nr%type,
                         in_konto_nr in pzm_konten.konto_nr%type) return number is

    v_saldo pzm_konten.saldo%type;

    cursor c_pzm_konten is
      select t.saldo
        from pzm_konten t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.pers_nr = in_pers_nr
         and t.konto_nr = in_konto_nr;
    v_found boolean;
  begin
    open c_pzm_konten;

    fetch c_pzm_konten into v_saldo;
    v_found := c_pzm_konten%found;

    close c_pzm_konten;

    if not v_found
    then
      raise_application_error(-20000, 'Konto ' || to_char(in_konto_nr) || ' konnte nicht gefunden werden.');
    end if;

    return (v_saldo);
  end;

  /* normale Kontobuchungen */

  /***********************************************************************************************
   * zugang_buchen trägt in der tabelle pzm_konten_bh einen Buchungssatz mit dem entspr.
   * Buchungsschlüssel ein. Anhand das Buchungsschlüssels wird der Kontostand in der Tabelle pzm_konten
   * automatisch verändert.
   * Die Prozedur zugang_buchen erhöht den Kontostand um den Betrag "in_wert".
   */
  procedure zugang_buchen(in_sid in isi_sid.sid%type,
                          in_firma_nr in isi_firma.firma_nr%type,
                          in_konto_nr in pzm_konten.konto_nr%type,
                          in_pers_nr in pzm_personal.pers_nr%type,
                          in_kst in pzm_konten_bh.kst_id%type,
                          in_wert in pzm_konten_bh.wert%type,
                          in_info in pzm_konten_bh.info%type,
                          in_typ in pzm_konten_bh.typ%type,
                          in_abt_id in pzm_konten_bh.abt_id%type,
                          out_konten_bh_id out pzm_konten_bh.konten_bh_id%type) is
    v_pzm_konten pzm_konten%rowtype;

    cursor c_pzm_konten is
      select t.*
        from pzm_konten t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.pers_nr = in_pers_nr
         and t.konto_nr = in_konto_nr;
    v_found boolean;
  begin
    open c_pzm_konten;

    fetch c_pzm_konten into v_pzm_konten;
    v_found := c_pzm_konten%found;

    close c_pzm_konten;

    if not v_found
    then
      raise_application_error(-20000, 'Konto ' || to_char(in_konto_nr) || ' konnte nicht gefunden werden.');
    end if;

    insert into pzm_konten_bh
    values (
      in_sid,
      in_firma_nr,
      in_konto_nr,
      in_pers_nr,
      in_kst,
      null, -- konten_bh_id
      sysdate, -- buch_datum
      1, -- bus (1 = zugang)
      in_wert,
      v_pzm_konten.buch_einheit,
      null, -- zk_start
      null, -- zk_aa_id
      in_info,
      in_typ, -- typ (B = Buchung)
      null, -- storno_konten_bh_id,
      in_abt_id,
      NULL,
      NULL,
      NULL 
      
    ) returning konten_bh_id into out_konten_bh_id;
  end;

  /***********************************************************************************************
   * abgang_buchen trägt in der tabelle pzm_konten_bh einen Buchungssatz mit dem entspr.
   * Buchungsschlüssel ein. Anhand das Buchungsschlüssels wird der Kontostand in der Tabelle pzm_konten
   * automatisch verändert.
   * Die Prozedur abgang_buchen reduziert den Kontostand um den Betrag "in_wert".
   */
  procedure abgang_buchen(in_sid in isi_sid.sid%type,
                          in_firma_nr in isi_firma.firma_nr%type,
                          in_konto_nr in pzm_konten.konto_nr%type,
                          in_pers_nr in pzm_personal.pers_nr%type,
                          in_kst in pzm_konten_bh.kst_id%type,
                          in_wert in pzm_konten_bh.wert%type,
                          in_info in pzm_konten_bh.info%type,
                          in_typ in pzm_konten_bh.typ%type,
                          in_abt_id in pzm_konten_bh.abt_id%type,
                          out_konten_bh_id out pzm_konten_bh.konten_bh_id%type) is
    v_pzm_konten pzm_konten%rowtype;

    cursor c_pzm_konten is
      select t.*
        from pzm_konten t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.pers_nr = in_pers_nr
         and t.konto_nr = in_konto_nr;
    v_found boolean;
  begin
    open c_pzm_konten;

    fetch c_pzm_konten into v_pzm_konten;
    v_found := c_pzm_konten%found;

    close c_pzm_konten;

    if not v_found
    then
      raise_application_error(-20000, 'Konto ' || to_char(in_konto_nr) || ' konnte nicht gefunden werden.');
    end if;

    insert into pzm_konten_bh
    values (
      in_sid,
      in_firma_nr,
      in_konto_nr,
      in_pers_nr,
      in_kst,
      null, -- konten_bh_id
      sysdate, -- buch_datum
      2, -- bus (1 = Abgang)
      in_wert,
      v_pzm_konten.buch_einheit,
      null, -- zk_start
      null, -- zk_aa_id
      in_info,
      in_typ, -- typ (B = Buchung)
      null, -- storno_konten_bh_id
      in_abt_id,
      NULL,
      NULL,
      NULL 
    ) returning konten_bh_id into out_konten_bh_id;
  end;

  /***********************************************************************************************
   * buchung_stornieren macht eine getätigte Buchung ungültig, damit wird eine Stornobuchung eingefügt,
   * die den Kontostand anpasst. Zusätzlich wird der Typ der stornierten Buchung auf 'S' gesetzt, sodass
   * sie nicht zwangsläufig bei den aktiven Buchungen aufgelistet werden muss.
   */
  procedure buchung_storinieren(in_sid in isi_sid.sid%type,
                                in_firma_nr in isi_firma.firma_nr%type,
                                in_konto_nr in pzm_konten.konto_nr%type,
                                in_pers_nr in pzm_personal.pers_nr%type,
                                in_konten_bh_id in pzm_konten_bh.konten_bh_id%type,
                                in_wert in pzm_konten_bh.wert%type) is
    v_pzm_konten pzm_konten%rowtype;
    v_pzm_konten_bh pzm_konten_bh%rowtype;

    v_storno_bus pzm_konten_bh.bus%type;

    cursor c_pzm_konten is
      select t.*
        from pzm_konten t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.pers_nr = in_pers_nr
         and t.konto_nr = in_konto_nr;

    cursor c_pzm_konten_bh is
      select t.*
        from pzm_konten_bh t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.konten_bh_id = in_konten_bh_id;

    v_found boolean;
  begin
    open c_pzm_konten;

    fetch c_pzm_konten into v_pzm_konten;
    v_found := c_pzm_konten%found;

    close c_pzm_konten;

    if not v_found
    then
      raise_application_error(-20000, 'Konto ' || to_char(in_konto_nr) || ' konnte nicht gefunden werden.');
    end if;

    open c_pzm_konten_bh;

    fetch c_pzm_konten_bh into v_pzm_konten_bh;
    v_found := c_pzm_konten_bh%found;

    close c_pzm_konten_bh;

    if not v_found
    then
      raise_application_error(-20000, 'Buchung ' || to_char(in_konten_bh_id) || ' konnte nicht gefunden werden.');
    end if;

    if v_pzm_konten_bh.wert != in_wert
    then
      raise_application_error(-20000, 'Der Stornowert ' || to_char(in_wert) || ' stimmt nicht mit dem Buchungswert überein.');
    end if;

    /* hier evtl. weitere Plausibilitäten prüfen */

    v_storno_bus := v_pzm_konten_bh.bus + 2; -- Bus 1 (Zugang) + 2 = 3 (Zugang storno) / Bus 2 (Abgang) + 2 = 4 (Abgang storno)

    insert into pzm_konten_bh
    values (
      in_sid,
      in_firma_nr,
      in_konto_nr,
      in_pers_nr,
      v_pzm_konten_bh.kst_id,
      null, -- konten_bh_id (aus sequence)
      sysdate, -- buch_datum
      v_storno_bus, -- bus (3 = storno Zugang, 4 = storno Abgang)
      in_wert,
      v_pzm_konten.buch_einheit,
      v_pzm_konten_bh.zk_start, -- zk_start
      v_pzm_konten_bh.zk_aa_id, -- zk_aa_id
      v_pzm_konten_bh.info,
      'S', -- typ (S = Stornobuchung)
      in_konten_bh_id, -- storno_konten_bh_id
      v_pzm_konten_bh.abt_id,
      NULL,
      NULL,
      NULL 
    );

    update pzm_konten_bh t
       set t.typ = 'S' -- buchung auf "Storniert" setzen
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.konten_bh_id = in_konten_bh_id;
  end;

  /***********************************************************************************************
   * get_buchung_saldo gibt den Kontostand zum Zeitpunkt der angegeben Buchung aus. Die Funktion
   * kann z.B. in einem SELECT über alle Buchungen verwendet werden um die Veränderung des Kontostandes
   * anzuzeigen.
   */
  function get_buchung_saldo(in_sid in isi_sid.sid%type,
                             in_firma_nr in isi_firma.firma_nr%type,
                             in_konto_nr in pzm_konten.konto_nr%type,
                             in_pers_nr in pzm_personal.pers_nr%type,
                             in_konten_bh_id in pzm_konten_bh.konten_bh_id%type) return number is
    v_saldo pzm_konten.saldo%type;
    v_summe_diff number;

    -- alle Zugänge müssen abgebucht werden, und alle Abgänge müssen aufaddiert werden
    cursor c_summe_diff is
      select nvl(sum(to_number(decode(t.bus, 1, t.wert * -1, t.wert))), 0) summe
        from pzm_konten_bh t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.konto_nr = in_konto_nr
         and t.typ in ('B', 'G', 'K')
         and t.zk_start > (select t1.zk_start
                             from pzm_konten_bh t1
                            where t1.sid = in_sid
                              and t1.firma_nr = in_firma_nr
                              and t1.konten_bh_id = in_konten_bh_id);
  begin
    v_saldo := get_akt_saldo(in_sid, in_firma_nr, in_pers_nr, in_konto_nr);

    open c_summe_diff;

    fetch c_summe_diff into v_summe_diff;
    if c_summe_diff%found
    then
      v_saldo := v_saldo + v_summe_diff;
    end if;

    close c_summe_diff;

    return (v_saldo);
  end;


  /* Zeitkonto spezifische Kontobuchungen */
  /***********************************************************************************************
   * Eine mit COMMIT abgeschlossene "zk_zugang_buchen"
   */
  procedure c_zk_zugang_buchen(in_sid in isi_sid.sid%type,
                               in_firma_nr in isi_firma.firma_nr%type,
                               in_konto_nr in pzm_konten.konto_nr%type,
                               in_pers_nr in pzm_personal.pers_nr%type,
                               in_kst_id in pzm_konten_bh.kst_id%type,
                               in_wert in pzm_konten_bh.wert%type,
                               in_info in pzm_konten_bh.info%type,
                               in_zk_start in pzm_konten_bh.zk_start%type,
                               in_zk_aa_id in pzm_konten_bh.zk_aa_id%type,
                               in_abt_id in pzm_konten_bh.abt_id%type,
                               out_konten_bh_id out pzm_konten_bh.konten_bh_id%type) is
  begin
    zk_zugang_buchen(in_sid, in_firma_nr, in_konto_nr, in_pers_nr, in_kst_id, in_wert, in_info,
                     in_zk_start, in_zk_aa_id, in_abt_id, out_konten_bh_id);

    commit;
  end;

  /***********************************************************************************************
   * Eine mit COMMIT abgeschlossene "zk_abgang_buchen"
   */
  procedure c_zk_abgang_buchen(in_sid in isi_sid.sid%type,
                               in_firma_nr in isi_firma.firma_nr%type,
                               in_konto_nr in pzm_konten.konto_nr%type,
                               in_pers_nr in pzm_personal.pers_nr%type,
                               in_kst_id in pzm_konten_bh.kst_id%type,
                               in_wert in pzm_konten_bh.wert%type,
                               in_info in pzm_konten_bh.info%type,
                               in_zk_start in pzm_konten_bh.zk_start%type,
                               in_zk_aa_id in pzm_konten_bh.zk_aa_id%type,
                               in_abt_id in pzm_konten_bh.abt_id%type,
                               out_konten_bh_id out pzm_konten_bh.konten_bh_id%type) is
  begin
    zk_abgang_buchen(in_sid, in_firma_nr, in_konto_nr, in_pers_nr, in_kst_id, in_wert, in_info,
                     in_zk_start, in_zk_aa_id, in_abt_id, out_konten_bh_id);

    commit;
  end;

  /***********************************************************************************************
   * zk_zugang_buchen funktioniert wie zugang_buchen, nur das zusätzlich zeitkontotypische Daten,
   * abgespeichert werden.
   */
  procedure zk_zugang_buchen(in_sid in isi_sid.sid%type,
                             in_firma_nr in isi_firma.firma_nr%type,
                             in_konto_nr in pzm_konten.konto_nr%type,
                             in_pers_nr in pzm_personal.pers_nr%type,
                             in_kst_id in pzm_konten_bh.kst_id%type,
                             in_wert in pzm_konten_bh.wert%type,
                             in_info in pzm_konten_bh.info%type,
                             in_zk_start in pzm_konten_bh.zk_start%type,
                             in_zk_aa_id in pzm_konten_bh.zk_aa_id%type,
                             in_abt_id in pzm_konten_bh.abt_id%type,
                             out_konten_bh_id out pzm_konten_bh.konten_bh_id%type) is
    v_kst_id pzm_konten_bh.kst_id%type;
    v_abt_id pzm_konten_bh.abt_id%type;
  begin
    v_kst_id := in_kst_id;
    if v_kst_id is null
    then
      v_kst_id := get_pers_kst_id(in_pers_nr);
    end if;

    v_abt_id := in_abt_id;
    if v_abt_id is null
    then
      v_abt_id := get_pers_abt_id(in_pers_nr);
    end if;

    zugang_buchen(in_sid, in_firma_nr, in_konto_nr, in_pers_nr, v_kst_id, in_wert, in_info, 'B', v_abt_id, out_konten_bh_id);

    update pzm_konten_bh t
       set t.zk_start = in_zk_start,
           t.zk_aa_id = in_zk_aa_id
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.konten_bh_id = out_konten_bh_id;
  end;

  /***********************************************************************************************
   * zk_abgang_buchen funktioniert wie abgang_buchen, nur das zusätzlich zeitkontotypische Daten,
   * abgespeichert werden.
   */
  procedure zk_abgang_buchen(in_sid in isi_sid.sid%type,
                             in_firma_nr in isi_firma.firma_nr%type,
                             in_konto_nr in pzm_konten.konto_nr%type,
                             in_pers_nr in pzm_personal.pers_nr%type,
                             in_kst_id in pzm_konten_bh.kst_id%type,
                             in_wert in pzm_konten_bh.wert%type,
                             in_info in pzm_konten_bh.info%type,
                             in_zk_start in pzm_konten_bh.zk_start%type,
                             in_zk_aa_id in pzm_konten_bh.zk_aa_id%type,
                             in_abt_id in pzm_konten_bh.abt_id%type,
                             out_konten_bh_id out pzm_konten_bh.konten_bh_id%type) is
    v_kst_id pzm_konten_bh.kst_id%type;
    v_abt_id pzm_konten_bh.abt_id%type;
  begin
    v_kst_id := in_kst_id;
    if v_kst_id is null
    then
      v_kst_id := get_pers_kst_id(in_pers_nr);
    end if;

    v_abt_id := in_abt_id;
    if v_abt_id is null
    then
      v_abt_id := get_pers_abt_id(in_pers_nr);
    end if;
    abgang_buchen(in_sid, in_firma_nr, in_konto_nr, in_pers_nr, v_kst_id, in_wert, in_info, 'B', v_abt_id, out_konten_bh_id);

    update pzm_konten_bh t
       set t.zk_start = in_zk_start,
           t.zk_aa_id = in_zk_aa_id
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.konten_bh_id = out_konten_bh_id;
  end;

  /***********************************************************************************************
   * zk_get_akt_saldo gibt den aktuellen Kontostand des Kontos anhand der Personalnummer und des
   * Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wurd null zurückgegeben.
   * Die Funktion reisst keine Exception.
   */
  function zk_get_akt_saldo(in_sid in isi_sid.sid%type,
                            in_firma_nr in isi_firma.firma_nr%type,
                            in_pers_nr in pzm_personal.pers_nr%type,
                            in_name_kurz in pzm_konten.name_kurz%type) return number is

    v_saldo pzm_konten.saldo%type;
    v_konto pzm_konten%rowtype;
  begin
    v_saldo := null;

    if is_konto_vorhanden(in_sid, in_firma_nr, in_pers_nr, in_name_kurz, 'ZK', v_konto)
    then
      v_saldo := get_akt_saldo(in_sid, in_firma_nr, in_pers_nr, v_konto.konto_nr);
    end if;

    return (v_saldo);
  end;

  /***********************************************************************************************
   * zk_get_akt_monat_saldo gibt den Kontostand zu einem Monatsende des Kontos anhand der Personalnummer
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wurd null zurückgegeben.
   * Die Funktion reisst keine Exception.
   */
  function zk_get_date_saldo(in_sid in isi_sid.sid%type,
                             in_firma_nr in isi_firma.firma_nr%type,
                             in_pers_nr in pzm_personal.pers_nr%type,
                             in_name_kurz in pzm_konten.name_kurz%type,
                             in_date in date) return number is
    v_saldo pzm_konten.saldo%type;
    v_konto pzm_konten%rowtype;

    v_summe_diff number;

    -- alle Zugänge müssen abgebucht werden, und alle Abgänge müssen aufaddiert werden
    cursor c_summe_diff is
      select nvl(sum(to_number(decode(t.bus, 1, t.wert * -1, t.wert))), 0) summe
        from pzm_konten_bh t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.konto_nr = v_konto.konto_nr
         and t.typ in ('B', 'G', 'K')
         and trunc(t.zk_start) > in_date;
  begin
    v_saldo := null;

    if is_konto_vorhanden(in_sid, in_firma_nr, in_pers_nr, in_name_kurz, 'ZK', v_konto)
    then
      v_saldo := get_akt_saldo(in_sid, in_firma_nr, in_pers_nr, v_konto.konto_nr);
    end if;

    open c_summe_diff;

    fetch c_summe_diff into v_summe_diff;
    if c_summe_diff%found
    then
      v_saldo := v_saldo + v_summe_diff;
    end if;

    close c_summe_diff;

    return (v_saldo);
  end;

  /***********************************************************************************************
   * zk_get_akt_monat_saldo gibt den Kontostand zu einem Monatsende des Kontos anhand der Personalnummer
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wurd null zurückgegeben.
   * Die Funktion reisst keine Exception.
   */
  function zk_get_monat_saldo(in_sid in isi_sid.sid%type,
                              in_firma_nr in isi_firma.firma_nr%type,
                              in_pers_nr in pzm_personal.pers_nr%type,
                              in_name_kurz in pzm_konten.name_kurz%type,
                              in_monat in number,
                              in_jahr in number) return number is
    v_saldo pzm_konten.saldo%type;
    v_konto pzm_konten%rowtype;

    v_summe_diff number;

    -- alle Zugänge müssen abgebucht werden, und alle Abgänge müssen aufaddiert werden
    cursor c_summe_diff is
      select nvl(sum(to_number(decode(t.bus, 1, t.wert * -1, t.wert))), 0) summe
        from pzm_konten_bh t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.konto_nr = v_konto.konto_nr
         and t.typ in ('B', 'G', 'K')
         and trunc(t.zk_start) > last_day(to_date('01.' ||
                                                  lpad(to_char(in_monat), 2, '0') || '.' ||
                                                  to_char(in_jahr),
                                                  'dd.mm.yyyy'
                                                 )
                                         );
  begin
    v_saldo := null;

    if is_konto_vorhanden(in_sid, in_firma_nr, in_pers_nr, in_name_kurz, 'ZK', v_konto)
    then
      v_saldo := get_akt_saldo(in_sid, in_firma_nr, in_pers_nr, v_konto.konto_nr);
    end if;

    open c_summe_diff;

    fetch c_summe_diff into v_summe_diff;
    if c_summe_diff%found
    then
      v_saldo := v_saldo + v_summe_diff;
    end if;

    close c_summe_diff;

    return (v_saldo);
  end;
  /***********************************************************************************************
   * zk_get_akt_monat_saldo_bus gibt den Kontostand zu einem Monatsende des Kontos anhand der Personalnummer und des Buchungsschlüssels
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wurd null zurückgegeben.
   * Die Funktion reisst keine Exception.
   */
  function zk_get_monat_zug_abg (in_pers_nr   in pzm_personal.pers_nr%type,
                                 in_name_kurz in pzm_konten.name_kurz%type,
                                 in_monat     in number,
                                 in_jahr      in number) return number is
    v_saldo pzm_konten.saldo%type;
    v_konto pzm_konten%rowtype;

    v_summe_diff number;

    -- alle Zugänge müssen abgebucht werden, und alle Abgänge müssen aufaddiert werden
    cursor c_summe_diff is
      select nvl(sum(to_number(decode(t.bus, 1, t.wert * -1, t.wert))), 0) summe
        from pzm_konten_bh t,
             pzm_lohnarten l
       where t.konto_nr = v_konto.konto_nr
         and t.typ in ('B', 'G', 'K')
         and trunc(t.zk_start) >= to_date('01.' ||
                                          lpad(to_char(in_monat), 2, '0') || '.' ||
                                          to_char(in_jahr),
                                          'dd.mm.yyyy'
                                         )
         and trunc(t.zk_start) <= last_day(to_date('01.' ||
                                                  lpad(to_char(in_monat), 2, '0') || '.' ||
                                                  to_char(in_jahr),
                                                  'dd.mm.yyyy'
                                                 )
                                         );
  begin
    v_saldo := null;

    open c_summe_diff;

    fetch c_summe_diff into v_summe_diff;
    if c_summe_diff%found
    then
      v_saldo := v_summe_diff;
    end if;

    close c_summe_diff;

    return (v_saldo);
  end;

  /***********************************************************************************************
   * zk_get_jahresanspruch gibt den Jahresanspruch des Kontos anhand der Personalnummer
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wird 0 zurückgegeben.
   * DKr P70899-47
   */
  function zk_get_jahresanspruch(in_sid in isi_sid.sid%type,
                                 in_firma_nr in isi_firma.firma_nr%type,
                                 in_pers_nr in pzm_personal.pers_nr%type,
                                 in_name_kurz in pzm_konten.name_kurz%type,
                                 in_jahr in number) return number is
    v_saldo         pzm_konten.saldo%type;
    v_konto         pzm_konten%rowtype;

    v_summe_diff number;

    cursor c_summe_diff is
      select sum(to_number(decode(t.bus, 2, t.wert * -1, t.wert))) summe
        from pzm_konten_bh t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.konto_nr = v_konto.konto_nr
         and t.typ in ('B', 'G', 'K')
         and lower(t.info) like '%anspruch%'
         and trunc(t.zk_start) between to_date('01.01.' || to_char(in_jahr), 'dd.mm.yyyy') and to_date('31.12.' || to_char(in_jahr), 'dd.mm.yyyy');
  begin
    v_saldo := 0;

    if is_konto_vorhanden(in_sid, in_firma_nr, in_pers_nr, in_name_kurz, 'ZK', v_konto)
    then
      -- hole die Differenz zwischen dem 01.01. und dem 31.12. des gewünschten Jahres
      open c_summe_diff;
      fetch c_summe_diff into v_summe_diff;

      if v_summe_diff is not null
      then
        v_saldo := v_saldo + v_summe_diff;
      end if;

      close c_summe_diff;

    end if;

    return (v_saldo);
  end;

  /***********************************************************************************************
   * zk_serien_gutschrift verbucht einen Wert als Gutschrift über alle vorhandenen Konten
   */
  procedure zk_serien_gutschrift(in_sid in isi_sid.sid%type,
                                 in_firma_nr in isi_firma.firma_nr%type,
                                 in_name_kurz in pzm_konten.name_kurz%type,
                                 in_wert in pzm_konten_bh.wert%type,
                                 in_info in pzm_konten_bh.info%type,
                                 in_zk_start in pzm_konten_bh.zk_start%type,
                                 in_zk_aa_id in pzm_konten_bh.zk_aa_id%type) is
    v_pzm_konten pzm_konten%rowtype;
    v_freistd_pro_jahr number;

    cursor c_pzm_konten is
      select t.*
        from pzm_konten t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and upper(t.name_kurz) = upper(in_name_kurz) -- case insensitive
         and t.typ = 'ZK';

    v_konten_bh_id pzm_konten_bh.konten_bh_id%type;
  begin
    open c_pzm_konten;

    loop
      fetch c_pzm_konten into v_pzm_konten;
      exit when c_pzm_konten%notfound;
      v_freistd_pro_jahr := to_number(pzm_p_base.get_allg_parameter_mandant(v_pzm_konten.pers_nr, 'FREISTD_PRO_JAHR'));

      if nvl(v_freistd_pro_jahr, 0) != 0
      then
        zugang_buchen(v_pzm_konten.sid, v_pzm_konten.firma_nr, v_pzm_konten.konto_nr,
                      v_pzm_konten.pers_nr, get_pers_kst_id(v_pzm_konten.pers_nr), v_freistd_pro_jahr, in_info,
                      'G', get_pers_abt_id(v_pzm_konten.pers_nr), v_konten_bh_id);

        update pzm_konten_bh t
           set t.zk_start = in_zk_start,
               t.zk_aa_id = in_zk_aa_id
         where t.sid = in_sid
           and t.firma_nr = in_firma_nr
           and t.konten_bh_id = v_konten_bh_id;
      end if;
    end loop;

    close c_pzm_konten;
  end;

  /***********************************************************************************************
   * zk_serien_gutschrift verbucht den Urlaubsanspruch als Gutschrift über alle Mitarbeiter
   */
  procedure personal_urlaubs_gutschrift(in_sid in isi_sid.sid%type,
                                        in_firma_nr in isi_firma.firma_nr%type,
                                        in_info in pzm_konten_bh.info%type,
                                        in_zk_start in pzm_konten_bh.zk_start%type,
                                        in_zk_aa_id in pzm_konten_bh.zk_aa_id%type) is
    v_pzm_personal pzm_personal%rowtype;
    cursor c_pzm_personal is
      select t.*
        from pzm_personal t
       where nvl(trunc(t.pers_eintrittsdatum, 'year'), trunc(sysdate, 'year')) <= trunc(sysdate, 'year')
         and nvl(trunc(t.pers_austrittdatum, 'year'), trunc(sysdate, 'year')) >= trunc(sysdate, 'year');

    v_pzm_konto pzm_konten%rowtype;
    v_konten_bh_id pzm_konten_bh.konten_bh_id%type;
    v_lohnarten pzm_lohnarten%rowtype;
    v_sm_durch_std_tag                       number;
    cursor c_abwes_art is
      select t.*
        from pzm_lohnarten t,
             pzm_abwesenheitsarten t1
       where t.lz_id = t1.lz_id
         and t1.aa_id = v_pzm_personal.pers_urlaub_anspr_aa_id;
  begin
    open c_pzm_personal;

    loop
      fetch c_pzm_personal into v_pzm_personal;
      exit when c_pzm_personal%notfound;

      if v_pzm_personal.pers_urlaub_anspr_wert is not null
        and v_pzm_personal.pers_urlaub_anspr_aa_id is not null
      then
        open c_abwes_art;
        fetch c_abwes_art into v_lohnarten;
        close c_abwes_art;
        
        if is_konto_vorhanden(in_sid, in_firma_nr, v_pzm_personal.pers_nr,
          v_lohnarten.lz_konto_name_kurz, 'ZK', v_pzm_konto)
        then
          if v_lohnarten.lz_einheit = 'HH24'
          then
            -- Urlaubskonto in Stunden, also mit Duchschnittsstunden je Tag multiplizieren
            v_sm_durch_std_tag := pzm_utils.pzm_get_sm_durch_std_tag(v_pzm_personal.pers_sm_name);
          else
            v_sm_durch_std_tag := 1; -- Urlaubskonto in Tagen - Also 1 zu 1
          end if;
          zugang_buchen(in_sid, in_firma_nr, v_pzm_konto.konto_nr,
                        v_pzm_personal.pers_nr, v_pzm_personal.pers_kst_id,
                        v_pzm_personal.pers_urlaub_anspr_wert * v_sm_durch_std_tag, in_info,
                        'G', v_pzm_personal.pers_abt_id, v_konten_bh_id);
          update pzm_konten_bh t
             set t.zk_start = in_zk_start,
                 t.zk_aa_id = in_zk_aa_id
           where t.sid = in_sid
             and t.firma_nr = in_firma_nr
             and t.konten_bh_id = v_konten_bh_id;
        end if;
      end if;
    end loop;

    close c_pzm_personal;
  end;

  /***********************************************************************************************
   * c_personal_jahres_gutschriften führt alle relevanden Jahresgutschriften für PZM Konten durch.
   * Diese Prozedur ist besonders geeignet um aus einem Oracle-Job gestartet zu werden.
   */
  procedure c_personal_jahres_gutschriften(in_sid in isi_sid.sid%type,
                                           in_firma_nr in isi_firma.firma_nr%type,
                                           in_zk_start in pzm_konten_bh.zk_start%type) is
  begin
    personal_urlaubs_gutschrift(in_sid, in_firma_nr, 'Anspruch Jahresurlaub',
                                in_zk_start, null);

    zk_serien_gutschrift(in_sid, in_firma_nr, 'FK', NULL, 'Anspruch Freistunden',
                           in_zk_start, null);
    commit;
  end;

  /***********************************************************************************************
   * zk_serien_Umbuchung verbucht einen Wert als alle vorhandenen Konten wenn Konten vorhanden
   */
  procedure zk_serien_umbuchen(in_pb_id in pzm_personal.pers_pb_id%type,
                               in_abt_id in pzm_personal.pers_abt_id%type,
                               in_wert in pzm_konten_bh.wert%type,
                               in_einheit in pzm_konten_cfg.buch_einheit%type,
                               in_info in pzm_konten_bh.info%type,
                               in_zk_start in pzm_konten_bh.zk_start%type,
                               in_zk_aa_id in pzm_konten_bh.zk_aa_id%type,
                               in_zk_v_name_kurz in pzm_konten.name_kurz%type,
                               in_zk_n_name_kurz in pzm_konten.name_kurz%type)
                               is
    v_pzm_konten                     pzm_konten%rowtype;
    v_pzm_gegen_konten               pzm_konten%rowtype;
    v_schichtmodell                  pzm_schicht_modelle%rowtype;
    v_personal                       pzm_personal%rowtype;
    v_schichtart                     pzm_schichtarten%rowtype;
    
    v_schichtmodell_day_d_std        number;

    v_def_sa_kurzname                pzm_schichtarten.sa_kurzname%type;
    v_SAFound                        boolean;
    v_DaySAKurzname                  pzm_schichtarten.sa_kurzname%type;
    v_SABeginn                       pzm_schichtarten.sa_beginn%type;
    v_SAEnde                         pzm_schichtarten.sa_ende%type;
    v_SAStdProTag                    number;
    v_schicht_datum                  date;
    
    v_gutschrift_saldo               number;
    v_found                          boolean;

    cursor c_pzm_konten is
      select t.*
        from pzm_konten t
       where upper(t.name_kurz) = upper(in_zk_n_name_kurz) -- case insensitive
         and t.typ = 'ZK'
       order by t.pers_nr;

    cursor c_pzm_gegen_konten is
      select t.*
        from pzm_konten t
       where t.pers_nr = v_pzm_konten.pers_nr
         and upper(t.name_kurz) = upper(in_zk_v_name_kurz) -- case insensitive
         and t.typ = 'ZK';

    v_konten_bh_id pzm_konten_bh.konten_bh_id%type;
  begin
    open c_pzm_konten;

    loop
      fetch c_pzm_konten into v_pzm_konten;
      exit when c_pzm_konten%notfound;
      v_schichtmodell.standard_aa_id := NULL;
      v_schicht_datum := trunc(nvl(in_zk_start, sysdate));
      
      if  pzm_p_base.get_personal(v_pzm_konten.pers_nr, v_personal)
      and trunc(nvl(v_personal.pers_austrittdatum, v_schicht_datum)) >= v_schicht_datum
      and trunc(v_personal.pers_eintrittsdatum) <= v_schicht_datum
      and v_personal.pers_pb_id = nvl(in_pb_id, v_personal.pers_pb_id)
      and v_personal.pers_abt_id = nvl(in_abt_id, v_personal.pers_abt_id)
      then
        v_def_sa_kurzname := pzm_utils.get_standard_schicht_by_pers_nr(v_personal.pers_nr);
        if pzm_p_base.get_schicht_modell(v_pzm_konten.pers_nr, v_schichtmodell)
        then
          v_schichtmodell_day_d_std :=  pzm_utils.pzm_get_sm_durch_std_tag(v_schichtmodell.sm_name);
        end if;
        v_DaySAKurzname := NULL;
        v_SABeginn      := NULL;
        v_SAEnde        := NULL;
        v_SAStdProTag   := NULL;
        
        v_SAFound := get_schicht_daten(v_personal.pers_nr, nvl(in_zk_start, sysdate), v_schicht_datum, 
                                       v_DaySAKurzname, v_SABeginn, v_SAEnde, v_SAStdProTag) = 1;
        if not pzm_p_base.get_schichtart_by_uix(v_DaySAKurzname, v_schichtart)
        then
          v_schichtart.sa_kurzname := v_def_sa_kurzname;
        end if;

        if in_wert is not NULL
        then
          v_gutschrift_saldo := in_wert;
          if  in_einheit = 'DD'
          and v_pzm_konten.buch_einheit = 'HH24'
          then
            v_gutschrift_saldo := 0;

            if nvl(v_schichtart.sa_kurzname, v_def_sa_kurzname) = v_def_sa_kurzname
            then
              v_gutschrift_saldo := v_schichtmodell_day_d_std * in_wert;
            else
              v_gutschrift_saldo := v_schichtart.sa_std_pro_tag * in_wert;
            end if;
          elsif  in_einheit = 'HH24'
          and v_pzm_konten.buch_einheit = 'DD'
          then
            v_gutschrift_saldo := 0;
            
            if nvl(v_schichtart.sa_kurzname, v_def_sa_kurzname) != v_def_sa_kurzname
            and nvl(v_schichtart.sa_std_pro_tag, 0) > 0
            then
              v_schichtmodell_day_d_std := v_schichtart.sa_std_pro_tag;
            end if;
            
            if nvl(v_schichtmodell_day_d_std, 0) > 0
            then
              v_gutschrift_saldo :=  in_wert / v_schichtmodell_day_d_std;
            end if;
          end if;
        else -- In diesem Fall kommen die Werte aus den allg. Parametern und muss zwingen immer in der Einheit des kontos erfasst werden
          -- Dann die Gutschrift aus den allg. Parametern ermitteln
          if in_zk_v_name_kurz is NULL
          then
            v_gutschrift_saldo := to_number(pzm_p_base.get_allg_parameter_mandant(get_pers_pb_id(v_pzm_konten.pers_nr), 'GUTSCHRIFT_' || in_zk_n_name_kurz));
          else
            v_gutschrift_saldo := pzm_utils.get_pers_arb_std (v_pzm_konten.pers_nr,
                                                                NULL,
                                                                v_schicht_datum,
                                                                v_schicht_datum,   -- Ermittlung der gearbeiteten Stunden
                                                                false, -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'K_IN_STUNDENLOHN'), 'F') = 'T',
                                                                false  -- nvl(pzm_p_base.get_allg_parameter_mandant(v_loa_kumuliert.pb_id, 'U_IN_STUNDENLOHN'), 'F') = 'T'
                                                                );  -- Krank und Urlaub kommen dazu?
            if v_gutschrift_saldo > 0                         -- Es ist an dem Tag gearbeitet worden, oder er war Krank - Dann Umbuchen
            then
              v_gutschrift_saldo := to_number(pzm_p_base.get_allg_parameter_mandant(get_pers_pb_id(v_pzm_konten.pers_nr), 'UMB_KONTO_' || in_zk_v_name_kurz || '_' || in_zk_n_name_kurz));
            end if;
          end if;
        end if;

        if nvl(v_gutschrift_saldo, 0) != 0
        then
          OPEN c_pzm_gegen_konten;
          FETCH c_pzm_gegen_konten into v_pzm_gegen_konten;
          v_found := c_pzm_gegen_konten%found;
          CLOSE c_pzm_gegen_konten;
          
          if v_found
          or in_zk_v_name_kurz is NULL
          then
            if v_pzm_gegen_konten.buch_einheit = v_pzm_konten.buch_einheit
            or in_zk_v_name_kurz is NULL
            then
              if  v_pzm_gegen_konten.saldo < v_gutschrift_saldo
              and in_zk_v_name_kurz is not NULL
              then
                if v_pzm_gegen_konten.min_saldo >= v_pzm_gegen_konten.saldo - v_gutschrift_saldo
                then
                  v_gutschrift_saldo := v_pzm_gegen_konten.saldo - v_pzm_gegen_konten.min_saldo;
                 end if;
              end if;
              if v_gutschrift_saldo > 0
              then
                if in_zk_v_name_kurz is not NULL
                then
                  zk_abgang_buchen(v_pzm_konten.sid, v_pzm_konten.firma_nr, v_pzm_gegen_konten.konto_nr,
                                   v_pzm_gegen_konten.pers_nr, get_pers_kst_id(v_pzm_gegen_konten.pers_nr), v_gutschrift_saldo, in_info,
                                   trunc(nvl(in_zk_start, sysdate)), nvl(in_zk_aa_id, v_schichtmodell.standard_aa_id), get_pers_abt_id(v_pzm_gegen_konten.pers_nr), v_konten_bh_id);
                end if;

                zk_zugang_buchen(v_pzm_konten.sid, v_pzm_konten.firma_nr, v_pzm_konten.konto_nr,
                                 v_pzm_konten.pers_nr, get_pers_kst_id(v_pzm_konten.pers_nr), v_gutschrift_saldo, in_info,
                                 trunc(nvl(in_zk_start, sysdate)), nvl(in_zk_aa_id, v_schichtmodell.standard_aa_id), get_pers_abt_id(v_pzm_gegen_konten.pers_nr), v_konten_bh_id);

              end if;
            else
              pzm_p_log.error('Bucheinheit von Konto NR. ' || v_pzm_konten.konto_nr || ' und Konto Nr. ' || v_pzm_gegen_konten.konto_nr || ' stimmen nicht überein.',
                              pzm_p_log.CAT_SYSTEM, 
                              'pzm_kontoverwaltung.zk_serien_umbuchen',
                              -20010);
              pzm_p_lc.raise_app_error(-20010, 'Bucheinheit von Konto NR. ' || v_pzm_konten.konto_nr || ' und Konto Nr. ' || v_pzm_gegen_konten.konto_nr || ' stimmen nicht überein.');
            end if;
          end if;
        end if;
      end if;
    end loop;

    close c_pzm_konten;
  end;

  /***********************************************************************************************
   * pzm_job_serien_umbuchung kann einfach zyclisch aufgerufen werden. in der Prozedure oder den 
   *                          Unterfunktionen wird geprüft, ob eine Serienbuchung noch durchgeführt 
   *                          werden muss
   */
  procedure pzm_job_serien_umbuchung is
    v_k_umb                   pzm_konten_umbuchen%rowtype;
    v_date                    date;
    v_Wochentag               integer;
    v_true                    boolean;
    
    v_buch_wert               pzm_konten_umbuchen.buch_wert%type;

    cursor c_k_umb is
      select * from pzm_konten_umbuchen t
       where t.typ_status in ('D', 'N')
         and t.aktiv = c.R_C_TRUE;

  begin
    
    open c_k_umb;
    loop
      fetch c_k_umb
        into v_k_umb;
      exit when c_k_umb%notfound;
      v_true := false;
      v_buch_wert := NULL;
      v_Wochentag := isi_utils.Iso_WeekDay(sysdate);
      
      case when v_Wochentag = 1 and v_k_umb.buch_wot_mo_wert is not NULL
                then v_buch_wert := v_k_umb.buch_wot_mo_wert;
           when v_Wochentag = 2 and v_k_umb.buch_wot_di_wert is not NULL
                then v_buch_wert := v_k_umb.buch_wot_di_wert;
           when v_Wochentag = 3 and v_k_umb.buch_wot_mi_wert is not NULL
                then v_buch_wert := v_k_umb.buch_wot_mi_wert;
           when v_Wochentag = 4 and v_k_umb.buch_wot_do_wert is not NULL
                then v_buch_wert := v_k_umb.buch_wot_do_wert;
           when v_Wochentag = 5 and v_k_umb.buch_wot_fr_wert is not NULL
                then v_buch_wert := v_k_umb.buch_wot_fr_wert;
           when v_Wochentag = 6 and v_k_umb.buch_wot_sa_wert is not NULL
                then v_buch_wert := v_k_umb.buch_wot_sa_wert;
           when v_Wochentag = 7 and v_k_umb.buch_wot_so_wert is not NULL
                then v_buch_wert := v_k_umb.buch_wot_so_wert;
           else v_buch_wert := NULL;
      end case;
      
      if v_buch_wert is NULL
      and v_k_umb.buch_wert > 0
      then
        v_buch_wert := v_k_umb.buch_wert;
      end if;
      if v_buch_wert is not NULL
      then
        if v_k_umb.typ_status = 'D'
        and fraction_of_day(v_k_umb.buch_datum) <= fraction_of_day(sysdate)
        and trunc(nvl(v_k_umb.last_event_date, sysdate-1)) < trunc(sysdate)
        then
          v_true := true;
          if v_buch_wert = 0
          then
            v_buch_wert := NULL;
          end if;
          if v_k_umb.von_konto_name_kurz is not NULL
          then -- Ist am Folgetag und muss für den Vortag gebucht werden
            v_k_umb.buch_datum := (trunc(sysdate) + fraction_of_day(v_k_umb.buch_datum)) -1; -- Immer erst am nächsten Tag buchen - Anwesenheit prüfen
          else
            v_k_umb.buch_datum := trunc(sysdate);
          end if;
        elsif v_k_umb.typ_status = 'N'
        and v_k_umb.buch_datum <= sysdate
        then
          v_true := true;
        end if;
      end if;
      
      if v_true
      then
        pzm_kontoverwaltung.zk_serien_umbuchen(in_pb_id => v_k_umb.pb_id,
                                               in_abt_id => v_k_umb.abt_id,
                                               in_wert => v_buch_wert,
                                               in_einheit => v_k_umb.buch_einheit,
                                               in_info => nvl(v_k_umb.info, v_k_umb.name),
                                               in_zk_start => v_k_umb.buch_datum,
                                               in_zk_aa_id => NULL,
                                               in_zk_v_name_kurz => v_k_umb.von_konto_name_kurz,
                                               in_zk_n_name_kurz => v_k_umb.nach_konto_name_kurz);
        if v_k_umb.typ_status = 'N'
        then
          v_k_umb.typ_status := 'F';
        end if;
        
        update pzm_konten_umbuchen t
           set t.typ_status = v_k_umb.typ_status,
               t.last_event_date = sysdate
         where t.name = v_k_umb.name;

      end if;      
      
    end loop;
    close c_k_umb;

  end pzm_job_serien_umbuchung;

end;
/



-- sqlcl_snapshot {"hash":"3740e6dc4ac70d0715d1c67f78e7677536f39b8e","type":"PACKAGE_BODY","name":"PZM_KONTOVERWALTUNG","schemaName":"DIRKSPZM32","sxml":""}