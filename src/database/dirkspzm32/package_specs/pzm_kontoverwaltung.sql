create or replace package dirkspzm32.pzm_kontoverwaltung is

  -- Author  : wkroeker
  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  05.12.2003 11:31:21
  __________________________________________________
  Description
  Funktionen zur Verwaltung von PZM Konten
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

  -- Public function and procedure declarations

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
    ) return boolean;

  /***********************************************************************************************
   * get_akt_saldo gibt den aktuellen Kontostand des angegebenen Kontos zurück
   */
    function get_akt_saldo (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_pers_nr  in pzm_personal.pers_nr%type,
        in_konto_nr in pzm_konten.konto_nr%type
    ) return number;

  /***********************************************************************************************
   * zk_get_jahresanspruch gibt den Jahresanspruch des Kontos anhand der Personalnummer
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wird null zurückgegeben.
   */
    function zk_get_jahresanspruch (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_pers_nr   in pzm_personal.pers_nr%type,
        in_name_kurz in pzm_konten.name_kurz%type,
        in_jahr      in number
    ) return number;

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
    );

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
    );

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
    );

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
    ) return number;

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
    );

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
    );

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
    );

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
    );

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
    ) return number;

  /***********************************************************************************************
   * zk_get_date_saldo gibt den Kontostand zu einem Monatsende des Kontos anhand der Personalnummer
   * und des Kontonamenskürzels zurück. Wenn das Konto nicht vorhanden ist, wurd null zurückgegeben.
   * Die Funktion reisst keine Exception.
   */
    function zk_get_date_saldo (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_pers_nr   in pzm_personal.pers_nr%type,
        in_name_kurz in pzm_konten.name_kurz%type,
        in_date      in date
    ) return number;

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
    ) return number;

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
    ) return number;

  /***********************************************************************************************
   * zk_abwesenheit_buchen verbucht Abwesenheitsbegründungen (auch wenn diese geändert/korrigiert werden)
   */
  /*
  procedure zk_abwesenheit_buchen(in_sid in isi_sid.sid%type,
                                  in_firma_nr in isi_firma.firma_nr%type,
                                  in_pers_nr in pzm_personal.pers_nr%type,
                                  in_kst in pzm_konten_bh.kst%type,

                                  in_konto_nr in pzm_konten.konto_nr%type,
                                  in_zk_start in date,
                                  in_abw_std in number,
                                  in_aa_id in number,

                                  in_old_konto_nr in pzm_konten.konto_nr%type,
                                  in_old_zk_start in date,
                                  in_old_abw_std in number,
                                  in_old_aa_id in number,

                                  out_result out number,
                                  out_result_info out varchar2);
  */

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
    );

  /***********************************************************************************************
   * zk_serien_gutschrift verbucht den Urlaubsanspruch als Gutschrift über alle Mitarbeiter
   */
    procedure personal_urlaubs_gutschrift (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_info     in pzm_konten_bh.info%type,
        in_zk_start in pzm_konten_bh.zk_start%type,
        in_zk_aa_id in pzm_konten_bh.zk_aa_id%type
    );

  /***********************************************************************************************
   * c_personal_jahres_gutschriften führt alle relevanden Jahresgutschriften für PZM Konten durch.
   * Diese Prozedur ist besonders geeignet um aus einem Oracle-Job gestartet zu werden.
   */
    procedure c_personal_jahres_gutschriften (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_zk_start in pzm_konten_bh.zk_start%type
    );

end;
/


-- sqlcl_snapshot {"hash":"c18027b972e737b8b8f62187e06d8934eb9eeaf5","type":"PACKAGE_SPEC","name":"PZM_KONTOVERWALTUNG","schemaName":"DIRKSPZM32","sxml":""}