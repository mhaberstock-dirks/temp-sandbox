create or replace package body dirkspzm32.pzm_kontoverwaltung is
  /* Neue Kontoverwaltung umsetzung Feb 2006 (-WK-) */

  /* Kontoinformationen */

  /***********************************************************************************************
   * is_konto_vorhanden prüft anhand der Kriterien Personalnummer, Kontonamenskürzel ('UK', 'FK', 'ZK'),
   * ob ein Konto vorhanden ist und gibt ggf. die entspr. Kontonummer zurück
   */
    function is_konto_vorhanden (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_pers_nr   in pzm_personal.pers_nr%type,
        in_name_kurz in pzm_konten.name_kurz%type,
        in_typ       in pzm_konten.typ%type,
        out_konto    out pzm_konten%rowtype
    ) return boolean is

    --v_pzm_konten pzm_konten%rowtype;

        cursor c_pzm_konten is
        select
            t.*
        from
            pzm_konten t
        where
                t.sid = in_sid
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

        return ( v_found );
    end;

  /***********************************************************************************************
   * get_akt_saldo gibt den aktuellen Kontostand des angegebenen Kontos zurück
   */
    function get_akt_saldo (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_pers_nr  in pzm_personal.pers_nr%type,
        in_konto_nr in pzm_konten.konto_nr%type
    ) return number is

        v_saldo pzm_konten.saldo%type;
        cursor c_pzm_konten is
        select
            t.saldo
        from
            pzm_konten t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.pers_nr = in_pers_nr
            and t.konto_nr = in_konto_nr;

        v_found boolean;
    begin
        open c_pzm_konten;
        fetch c_pzm_konten into v_saldo;
        v_found := c_pzm_konten%found;
        close c_pzm_konten;
        if not v_found then
            raise_application_error(-20000,
                                    'Konto '
                                    || to_char(in_konto_nr)
                                    || ' konnte nicht gefunden werden.');
        end if;

        return ( v_saldo );
    end;

  /* normale Kontobuchungen */

  /***********************************************************************************************
   * zugang_buchen trägt in der tabelle pzm_konten_bh einen Buchungssatz mit dem entspr.
   * Buchungsschlüssel ein. Anhand das Buchungsschlüssels wird der Kontostand in der Tabelle pzm_konten
   * automatisch verändert.
   * Die Prozedur zugang_buchen erhöht den Kontostand um den Betrag "in_wert".
   */
    procedure zugang_buchen (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_konto_nr      in pzm_konten.konto_nr%type,
        in_pers_nr       in pzm_personal.pers_nr%type,
        in_kst           in pzm_konten_bh.kst_id%type,
        in_wert          in pzm_konten_bh.wert%type,
        in_info          in pzm_konten_bh.info%type,
        in_typ           in pzm_konten_bh.typ%type,
        in_abt_id        in pzm_konten_bh.abt_id%type,
        out_konten_bh_id out pzm_konten_bh.konten_bh_id%type
    ) is

        v_pzm_konten pzm_konten%rowtype;
        cursor c_pzm_konten is
        select
            t.*
        from
            pzm_konten t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.pers_nr = in_pers_nr
            and t.konto_nr = in_konto_nr;

        v_found      boolean;
    begin
        open c_pzm_konten;
        fetch c_pzm_konten into v_pzm_konten;
        v_found := c_pzm_konten%found;
        close c_pzm_konten;
        if not v_found then
            raise_application_error(-20000,
                                    'Konto '
                                    || to_char(in_konto_nr)
                                    || ' konnte nicht gefunden werden.');
        end if;

        insert into pzm_konten_bh values ( in_sid,
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
                                           null,
                                           null,
                                           null ) returning konten_bh_id into out_konten_bh_id;

    end;

  /***********************************************************************************************
   * abgang_buchen trägt in der tabelle pzm_konten_bh einen Buchungssatz mit dem entspr.
   * Buchungsschlüssel ein. Anhand das Buchungsschlüssels wird der Kontostand in der Tabelle pzm_konten
   * automatisch verändert.
   * Die Prozedur abgang_buchen reduziert den Kontostand um den Betrag "in_wert".
   */
    procedure abgang_buchen (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_konto_nr      in pzm_konten.konto_nr%type,
        in_pers_nr       in pzm_personal.pers_nr%type,
        in_kst           in pzm_konten_bh.kst_id%type,
        in_wert          in pzm_konten_bh.wert%type,
        in_info          in pzm_konten_bh.info%type,
        in_typ           in pzm_konten_bh.typ%type,
        in_abt_id        in pzm_konten_bh.abt_id%type,
        out_konten_bh_id out pzm_konten_bh.konten_bh_id%type
    ) is

        v_pzm_konten pzm_konten%rowtype;
        cursor c_pzm_konten is
        select
            t.*
        from
            pzm_konten t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.pers_nr = in_pers_nr
            and t.konto_nr = in_konto_nr;

        v_found      boolean;
    begin
        open c_pzm_konten;
        fetch c_pzm_konten into v_pzm_konten;
        v_found := c_pzm_konten%found;
        close c_pzm_konten;
        if not v_found then
            raise_application_error(-20000,
                                    'Konto '
                                    || to_char(in_konto_nr)
                                    || ' konnte nicht gefunden werden.');
        end if;

        insert into pzm_konten_bh values ( in_sid,
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
                                           null,
                                           null,
                                           null ) returning konten_bh_id into out_konten_bh_id;

    end;

  /***********************************************************************************************
   * buchung_stornieren macht eine getätigte Buchung ungültig, damit wird eine Stornobuchung eingefügt,
   * die den Kontostand anpasst. Zusätzlich wird der Typ der stornierten Buchung auf 'S' gesetzt, sodass
   * sie nicht zwangsläufig bei den aktiven Buchungen aufgelistet werden muss.
   */
    procedure buchung_storinieren (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_konto_nr     in pzm_konten.konto_nr%type,
        in_pers_nr      in pzm_personal.pers_nr%type,
        in_konten_bh_id in pzm_konten_bh.konten_bh_id%type,
        in_wert         in pzm_konten_bh.wert%type
    ) is

        v_pzm_konten    pzm_konten%rowtype;
        v_pzm_konten_bh pzm_konten_bh%rowtype;
        v_storno_bus    pzm_konten_bh.bus%type;
        cursor c_pzm_konten is
        select
            t.*
        from
            pzm_konten t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.pers_nr = in_pers_nr
            and t.konto_nr = in_konto_nr;

        cursor c_pzm_konten_bh is
        select
            t.*
        from
            pzm_konten_bh t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.konten_bh_id = in_konten_bh_id;

        v_found         boolean;
    begin
        open c_pzm_konten;
        fetch c_pzm_konten into v_pzm_konten;
        v_found := c_pzm_konten%found;
        close c_pzm_konten;
        if not v_found then
            raise_application_error(-20000,
                                    'Konto '
                                    || to_char(in_konto_nr)
                                    || ' konnte nicht gefunden werden.');
        end if;

        open c_pzm_konten_bh;
        fetch c_pzm_konten_bh into v_pzm_konten_bh;
        v_found := c_pzm_konten_bh%found;
        close c_pzm_konten_bh;
        if not v_found then
            raise_application_error(-20000,
                                    'Buchung '
                                    || to_char(in_konten_bh_id)
                                    || ' konnte nicht gefunden werden.');
        end if;

        if v_pzm_konten_bh.wert != in_wert then
            raise_application_error(-20000,
                                    'Der Stornowert '
                                    || to_char(in_wert)
                                    || ' stimmt nicht mit dem Buchungswert überein.');
        end if;

    /* hier evtl. weitere Plausibilitäten prüfen */

        v_storno_bus := v_pzm_konten_bh.bus + 2; -- Bus 1 (Zugang) + 2 = 3 (Zugang storno) / Bus 2 (Abgang) + 2 = 4 (Abgang storno)
        insert into pzm_konten_bh values ( in_sid,
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
                                           null,
                                           null,
                                           null );

        update pzm_konten_bh t
        set
            t.typ = 'S' -- buchung auf "Storniert" setzen
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.konten_bh_id = in_konten_bh_id;

    end;

  /***********************************************************************************************
   * get_buchung_saldo gibt den Kontostand zum Zeitpunkt der angegeben Buchung aus. Die Funktion
   * kann z.B. in einem SELECT über alle Buchungen verwendet werden um die Veränderung des Kontostandes
   * anzuzeigen.
   */
    function get_buchung_saldo (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_konto_nr     in pzm_konten.konto_nr%type,
        in_pers_nr      in pzm_personal.pers_nr%type,
        in_konten_bh_id in pzm_konten_bh.konten_bh_id%type
    ) return number is

        v_saldo      pzm_konten.saldo%type;
        v_summe_diff number;

    -- alle Zugänge müssen abgebucht werden, und alle Abgänge müssen aufaddiert werden
        cursor c_summe_diff is
        select
            nvl(
                sum(to_number(decode(t.bus, 1, t.wert * -1, t.wert))),
                0
            ) summe
        from
            pzm_konten_bh t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.konto_nr = in_konto_nr
            and t.typ in ( 'B', 'G', 'K' )
            and t.zk_start > (
                select
                    t1.zk_start
                from
                    pzm_konten_bh t1
                where
                        t1.sid = in_sid
                    and t1.firma_nr = in_firma_nr
                    and t1.konten_bh_id = in_konten_bh_id
            );

    begin
        v_saldo := get_akt_saldo(in_sid, in_firma_nr, in_pers_nr, in_konto_nr);
        open c_summe_diff;
        fetch c_summe_diff into v_summe_diff;
        if c_summe_diff%found then
            v_saldo := v_saldo + v_summe_diff;
        end if;
        close c_summe_diff;
        return ( v_saldo );
    end;

  /* Zeitkonto spezifische Kontobuchungen */
  /***********************************************************************************************
   * Eine mit COMMIT abgeschlossene "zk_zugang_buchen"
   */
    procedure c_zk_zugang_buchen (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_konto_nr      in pzm_konten.konto_nr%type,
        in_pers_nr       in pzm_personal.pers_nr%type,
        in_kst_id        in pzm_konten_bh.kst_id%type,
        in_wert          in pzm_konten_bh.wert%type,
        in_info          in pzm_konten_bh.info%type,
        in_zk_start      in pzm_konten_bh.zk_start%type,
        in_zk_aa_id      in pzm_konten_bh.zk_aa_id%type,
        in_abt_id        in pzm_konten_bh.abt_id%type,
        out_konten_bh_id out pzm_konten_bh.konten_bh_id%type
    ) is
    begin
        zk_zugang_buchen(in_sid, in_firma_nr, in_konto_nr, in_pers_nr, in_kst_id,
                         in_wert, in_info, in_zk_start, in_zk_aa_id, in_abt_id,
                         out_konten_bh_id);

        commit;
    end;

  /***********************************************************************************************
   * Eine mit COMMIT abgeschlossene "zk_abgang_buchen"
   */
    procedure c_zk_abgang_buchen (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_konto_nr      in pzm_konten.konto_nr%type,
        in_pers_nr       in pzm_personal.pers_nr%type,
        in_kst_id        in pzm_konten_bh.kst_id%type,
        in_wert          in pzm_konten_bh.wert%type,
        in_info          in pzm_konten_bh.info%type,
        in_zk_start      in pzm_konten_bh.zk_start%type,
        in_zk_aa_id      in pzm_konten_bh.zk_aa_id%type,
        in_abt_id        in pzm_konten_bh.abt_id%type,
        out_konten_bh_id out pzm_konten_bh.konten_bh_id%type
    ) is
    begin
        zk_abgang_buchen(in_sid, in_firma_nr, in_konto_nr, in_pers_nr, in_kst_id,
                         in_wert, in_info, in_zk_start, in_zk_aa_id, in_abt_id,
                         out_konten_bh_id);

        commit;
    end;

  /***********************************************************************************************
   * zk_zugang_buchen funktioniert wie zugang_buchen, nur das zusätzlich zeitkontotypische Daten,
   * abgespeichert werden.
   */
    procedure zk_zugang_buchen (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_konto_nr      in pzm_konten.konto_nr%type,
        in_pers_nr       in pzm_personal.pers_nr%type,
        in_kst_id        in pzm_konten_bh.kst_id%type,
        in_wert          in pzm_konten_bh.wert%type,
        in_info          in pzm_konten_bh.info%type,
        in_zk_start      in pzm_konten_bh.zk_start%type,
        in_zk_aa_id      in pzm_konten_bh.zk_aa_id%type,
        in_abt_id        in pzm_konten_bh.abt_id%type,
        out_konten_bh_id out pzm_konten_bh.konten_bh_id%type
    ) is
        v_kst_id pzm_konten_bh.kst_id%type;
        v_abt_id pzm_konten_bh.abt_id%type;
    begin
        v_kst_id := in_kst_id;
        if v_kst_id is null then
            v_kst_id := get_pers_kst_id(in_pers_nr);
        end if;
        v_abt_id := in_abt_id;
        if v_abt_id is null then
            v_abt_id := get_pers_abt_id(in_pers_nr);
        end if;
        zugang_buchen(in_sid, in_firma_nr, in_konto_nr, in_pers_nr, v_kst_id,
                      in_wert, in_info, 'B', v_abt_id, out_konten_bh_id);

        update pzm_konten_bh t
        set
            t.zk_start = in_zk_start,
            t.zk_aa_id = in_zk_aa_id
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.konten_bh_id = out_konten_bh_id;

    end;

  /***********************************************************************************************
   * zk_abgang_buchen funktioniert wie abgang_buchen, nur das zusätzlich zeitkontotypische Daten,
   * abgespeichert werden.
   */
    procedure zk_abgang_buchen (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_konto_nr      in pzm_konten.konto_nr%type,
        in_pers_nr       in pzm_personal.pers_nr%type,
        in_kst_id        in pzm_konten_bh.kst_id%type,
        in_wert          in pzm_konten_bh.wert%type,
        in_info          in pzm_konten_bh.info%type,
        in_zk_start      in pzm_konten_bh.zk_start%type,
        in_zk_aa_id      in pzm_konten_bh.zk_aa_id%type,
        in_abt_id        in pzm_konten_bh.abt_id%type,
        out_konten_bh_id out pzm_konten_bh.konten_bh_id%type
    ) is
        v_kst_id pzm_konten_bh.kst_id%type;
        v_abt_id pzm_konten_bh.abt_id%type;
    begin
        v_kst_id := in_kst_id;
        if v_kst_id is null then
            v_kst_id := get_pers_kst_id(in_pers_nr);
        end if;
        v_abt_id := in_abt_id;
        if v_abt_id is null then
            v_abt_id := get_pers_abt_id(in_pers_nr);
        end if;
        abgang_buchen(in_sid, in_firma_nr, in_konto_nr, in_pers_nr, v_kst_id,
                      in_wert, in_info, 'B', v_abt_id, out_konten_bh_id);

        update pzm_konten_bh t
        set
            t.zk_start = in_zk_start,
            t.zk_aa_id = in_zk_aa_id
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.konten_bh_id = out_konten_bh_id;

    end;

  /***********************************************************************************************
   * zk_get_akt_saldo gibt den aktuellen Kontostand des Kontos anhand der Personalnummer und des
   * Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wurd null zurückgegeben.
   * Die Funktion reisst keine Exception.
   */
    function zk_get_akt_saldo (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_pers_nr   in pzm_personal.pers_nr%type,
        in_name_kurz in pzm_konten.name_kurz%type
    ) return number is
        v_saldo pzm_konten.saldo%type;
        v_konto pzm_konten%rowtype;
    begin
        v_saldo := null;
        if is_konto_vorhanden(in_sid, in_firma_nr, in_pers_nr, in_name_kurz, 'ZK',
                              v_konto) then
            v_saldo := get_akt_saldo(in_sid, in_firma_nr, in_pers_nr, v_konto.konto_nr);
        end if;

        return ( v_saldo );
    end;

  /***********************************************************************************************
   * zk_get_akt_monat_saldo gibt den Kontostand zu einem Monatsende des Kontos anhand der Personalnummer
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wurd null zurückgegeben.
   * Die Funktion reisst keine Exception.
   */
    function zk_get_date_saldo (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_pers_nr   in pzm_personal.pers_nr%type,
        in_name_kurz in pzm_konten.name_kurz%type,
        in_date      in date
    ) return number is

        v_saldo      pzm_konten.saldo%type;
        v_konto      pzm_konten%rowtype;
        v_summe_diff number;

    -- alle Zugänge müssen abgebucht werden, und alle Abgänge müssen aufaddiert werden
        cursor c_summe_diff is
        select
            nvl(
                sum(to_number(decode(t.bus, 1, t.wert * -1, t.wert))),
                0
            ) summe
        from
            pzm_konten_bh t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.konto_nr = v_konto.konto_nr
            and t.typ in ( 'B', 'G', 'K' )
            and trunc(t.zk_start) > in_date;

    begin
        v_saldo := null;
        if is_konto_vorhanden(in_sid, in_firma_nr, in_pers_nr, in_name_kurz, 'ZK',
                              v_konto) then
            v_saldo := get_akt_saldo(in_sid, in_firma_nr, in_pers_nr, v_konto.konto_nr);
        end if;

        open c_summe_diff;
        fetch c_summe_diff into v_summe_diff;
        if c_summe_diff%found then
            v_saldo := v_saldo + v_summe_diff;
        end if;
        close c_summe_diff;
        return ( v_saldo );
    end;

  /***********************************************************************************************
   * zk_get_akt_monat_saldo gibt den Kontostand zu einem Monatsende des Kontos anhand der Personalnummer
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wurd null zurückgegeben.
   * Die Funktion reisst keine Exception.
   */
    function zk_get_monat_saldo (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_pers_nr   in pzm_personal.pers_nr%type,
        in_name_kurz in pzm_konten.name_kurz%type,
        in_monat     in number,
        in_jahr      in number
    ) return number is

        v_saldo      pzm_konten.saldo%type;
        v_konto      pzm_konten%rowtype;
        v_summe_diff number;

    -- alle Zugänge müssen abgebucht werden, und alle Abgänge müssen aufaddiert werden
        cursor c_summe_diff is
        select
            nvl(
                sum(to_number(decode(t.bus, 1, t.wert * -1, t.wert))),
                0
            ) summe
        from
            pzm_konten_bh t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.konto_nr = v_konto.konto_nr
            and t.typ in ( 'B', 'G', 'K' )
            and trunc(t.zk_start) > last_day(to_date('01.'
                                                     || lpad(
                to_char(in_monat),
                2,
                '0'
            )
                                                     || '.'
                                                     || to_char(in_jahr),
         'dd.mm.yyyy'));

    begin
        v_saldo := null;
        if is_konto_vorhanden(in_sid, in_firma_nr, in_pers_nr, in_name_kurz, 'ZK',
                              v_konto) then
            v_saldo := get_akt_saldo(in_sid, in_firma_nr, in_pers_nr, v_konto.konto_nr);
        end if;

        open c_summe_diff;
        fetch c_summe_diff into v_summe_diff;
        if c_summe_diff%found then
            v_saldo := v_saldo + v_summe_diff;
        end if;
        close c_summe_diff;
        return ( v_saldo );
    end;
  /***********************************************************************************************
   * zk_get_akt_monat_saldo_bus gibt den Kontostand zu einem Monatsende des Kontos anhand der Personalnummer und des Buchungsschlüssels
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wurd null zurückgegeben.
   * Die Funktion reisst keine Exception.
   */
    function zk_get_monat_zug_abg (
        in_pers_nr   in pzm_personal.pers_nr%type,
        in_name_kurz in pzm_konten.name_kurz%type,
        in_monat     in number,
        in_jahr      in number
    ) return number is

        v_saldo      pzm_konten.saldo%type;
        v_konto      pzm_konten%rowtype;
        v_summe_diff number;

    -- alle Zugänge müssen abgebucht werden, und alle Abgänge müssen aufaddiert werden
        cursor c_summe_diff is
        select
            nvl(
                sum(to_number(decode(t.bus, 1, t.wert * -1, t.wert))),
                0
            ) summe
        from
            pzm_konten_bh t,
            pzm_lohnarten l
        where
                t.konto_nr = v_konto.konto_nr
            and t.typ in ( 'B', 'G', 'K' )
            and trunc(t.zk_start) >= to_date('01.'
                                             || lpad(
                to_char(in_monat),
                2,
                '0'
            )
                                             || '.'
                                             || to_char(in_jahr),
        'dd.mm.yyyy')
            and trunc(t.zk_start) <= last_day(to_date('01.'
                                                      || lpad(
                to_char(in_monat),
                2,
                '0'
            )
                                                      || '.'
                                                      || to_char(in_jahr),
         'dd.mm.yyyy'));

    begin
        v_saldo := null;
        open c_summe_diff;
        fetch c_summe_diff into v_summe_diff;
        if c_summe_diff%found then
            v_saldo := v_summe_diff;
        end if;
        close c_summe_diff;
        return ( v_saldo );
    end;

  /***********************************************************************************************
   * zk_get_jahresanspruch gibt den Jahresanspruch des Kontos anhand der Personalnummer
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wird 0 zurückgegeben.
   * DKr P70899-47
   */
    function zk_get_jahresanspruch (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_pers_nr   in pzm_personal.pers_nr%type,
        in_name_kurz in pzm_konten.name_kurz%type,
        in_jahr      in number
    ) return number is

        v_saldo      pzm_konten.saldo%type;
        v_konto      pzm_konten%rowtype;
        v_summe_diff number;
        cursor c_summe_diff is
        select
            sum(to_number(decode(t.bus, 2, t.wert * -1, t.wert))) summe
        from
            pzm_konten_bh t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.konto_nr = v_konto.konto_nr
            and t.typ in ( 'B', 'G', 'K' )
            and lower(t.info) like '%anspruch%'
            and trunc(t.zk_start) between to_date('01.01.' || to_char(in_jahr),
        'dd.mm.yyyy') and to_date('31.12.' || to_char(in_jahr),
        'dd.mm.yyyy');

    begin
        v_saldo := 0;
        if is_konto_vorhanden(in_sid, in_firma_nr, in_pers_nr, in_name_kurz, 'ZK',
                              v_konto) then
      -- hole die Differenz zwischen dem 01.01. und dem 31.12. des gewünschten Jahres
            open c_summe_diff;
            fetch c_summe_diff into v_summe_diff;
            if v_summe_diff is not null then
                v_saldo := v_saldo + v_summe_diff;
            end if;
            close c_summe_diff;
        end if;

        return ( v_saldo );
    end;

  /***********************************************************************************************
   * zk_serien_gutschrift verbucht einen Wert als Gutschrift über alle vorhandenen Konten
   */
    procedure zk_serien_gutschrift (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_name_kurz in pzm_konten.name_kurz%type,
        in_wert      in pzm_konten_bh.wert%type,
        in_info      in pzm_konten_bh.info%type,
        in_zk_start  in pzm_konten_bh.zk_start%type,
        in_zk_aa_id  in pzm_konten_bh.zk_aa_id%type
    ) is

        v_pzm_konten       pzm_konten%rowtype;
        v_freistd_pro_jahr number;
        cursor c_pzm_konten is
        select
            t.*
        from
            pzm_konten t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and upper(t.name_kurz) = upper(in_name_kurz) -- case insensitive
            and t.typ = 'ZK';

        v_konten_bh_id     pzm_konten_bh.konten_bh_id%type;
    begin
        open c_pzm_konten;
        loop
            fetch c_pzm_konten into v_pzm_konten;
            exit when c_pzm_konten%notfound;
            v_freistd_pro_jahr := to_number ( pzm_p_base.get_allg_parameter_mandant(v_pzm_konten.pers_nr, 'FREISTD_PRO_JAHR') );
            if nvl(v_freistd_pro_jahr, 0) != 0 then
                zugang_buchen(v_pzm_konten.sid,
                              v_pzm_konten.firma_nr,
                              v_pzm_konten.konto_nr,
                              v_pzm_konten.pers_nr,
                              get_pers_kst_id(v_pzm_konten.pers_nr),
                              v_freistd_pro_jahr,
                              in_info,
                              'G',
                              get_pers_abt_id(v_pzm_konten.pers_nr),
                              v_konten_bh_id);

                update pzm_konten_bh t
                set
                    t.zk_start = in_zk_start,
                    t.zk_aa_id = in_zk_aa_id
                where
                        t.sid = in_sid
                    and t.firma_nr = in_firma_nr
                    and t.konten_bh_id = v_konten_bh_id;

            end if;

        end loop;

        close c_pzm_konten;
    end;

  /***********************************************************************************************
   * zk_serien_gutschrift verbucht den Urlaubsanspruch als Gutschrift über alle Mitarbeiter
   */
    procedure personal_urlaubs_gutschrift (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_info     in pzm_konten_bh.info%type,
        in_zk_start in pzm_konten_bh.zk_start%type,
        in_zk_aa_id in pzm_konten_bh.zk_aa_id%type
    ) is

        v_pzm_personal     pzm_personal%rowtype;
        cursor c_pzm_personal is
        select
            t.*
        from
            pzm_personal t
        where
                nvl(
                    trunc(t.pers_eintrittsdatum, 'year'),
                    trunc(sysdate, 'year')
                ) <= trunc(sysdate, 'year')
            and nvl(
                trunc(t.pers_austrittdatum, 'year'),
                trunc(sysdate, 'year')
            ) >= trunc(sysdate, 'year');

        v_pzm_konto        pzm_konten%rowtype;
        v_konten_bh_id     pzm_konten_bh.konten_bh_id%type;
        v_lohnarten        pzm_lohnarten%rowtype;
        v_sm_durch_std_tag number;
        cursor c_abwes_art is
        select
            t.*
        from
            pzm_lohnarten         t,
            pzm_abwesenheitsarten t1
        where
                t.lz_id = t1.lz_id
            and t1.aa_id = v_pzm_personal.pers_urlaub_anspr_aa_id;

    begin
        open c_pzm_personal;
        loop
            fetch c_pzm_personal into v_pzm_personal;
            exit when c_pzm_personal%notfound;
            if
                v_pzm_personal.pers_urlaub_anspr_wert is not null
                and v_pzm_personal.pers_urlaub_anspr_aa_id is not null
            then
                open c_abwes_art;
                fetch c_abwes_art into v_lohnarten;
                close c_abwes_art;
                if is_konto_vorhanden(in_sid, in_firma_nr, v_pzm_personal.pers_nr, v_lohnarten.lz_konto_name_kurz, 'ZK',
                                      v_pzm_konto) then
                    if v_lohnarten.lz_einheit = 'HH24' then
            -- Urlaubskonto in Stunden, also mit Duchschnittsstunden je Tag multiplizieren
                        v_sm_durch_std_tag := pzm_utils.pzm_get_sm_durch_std_tag(v_pzm_personal.pers_sm_name);
                    else
                        v_sm_durch_std_tag := 1; -- Urlaubskonto in Tagen - Also 1 zu 1
                    end if;

                    zugang_buchen(in_sid, in_firma_nr, v_pzm_konto.konto_nr, v_pzm_personal.pers_nr, v_pzm_personal.pers_kst_id,
                                  v_pzm_personal.pers_urlaub_anspr_wert * v_sm_durch_std_tag, in_info, 'G', v_pzm_personal.pers_abt_id
                                  , v_konten_bh_id);

                    update pzm_konten_bh t
                    set
                        t.zk_start = in_zk_start,
                        t.zk_aa_id = in_zk_aa_id
                    where
                            t.sid = in_sid
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
    procedure c_personal_jahres_gutschriften (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_zk_start in pzm_konten_bh.zk_start%type
    ) is
    begin
        personal_urlaubs_gutschrift(in_sid, in_firma_nr, 'Anspruch Jahresurlaub', in_zk_start, null);
        zk_serien_gutschrift(in_sid, in_firma_nr, 'FK', null, 'Anspruch Freistunden',
                             in_zk_start, null);
        commit;
    end;

end;
/


-- sqlcl_snapshot {"hash":"7ed2bec93d463d98a99b7420f7155521c945b66c","type":"PACKAGE_BODY","name":"PZM_KONTOVERWALTUNG","schemaName":"DIRKSPZM32","sxml":""}