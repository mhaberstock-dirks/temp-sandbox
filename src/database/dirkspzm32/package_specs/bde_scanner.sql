create or replace package dirkspzm32.bde_scanner is


  -- Author  : HJGOEDEKE
  -- Created : 07.04.2005 08:41:25
  -- Purpose : Funktionen zum Verbuchen von Barcodes aus dem Scann Server

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;
  /*
  *  Versionsverlauf
  *     Date         Ver.     Comment
  *     -----------  -------  ---------------------
  *     08.09.2008   3.4.8.1  (-AG-) Schreiben der Tabelle isi_scan_log und Umbuchung der Rohstoffe
  *                                  falls diese nicht auf dem Platz der Maschine stehen
  *                           (Achtung: Versionsstring für Delphi nicht geändert, da 100% Kompatibel)
  *     22.04.2008   3.4.4.1  (-AM-) Einbau Festscanner für Leerkartons an Produktions-Maschinen
  *                  3.3.4.3  Erweiterung Buchen Spezialbarcode mit Brutto und Netto barcode
  *                  3.3.4.2  Erweiterung Erstellen und Drucken einer LTE aus Scannerdaten
  *                  3.3.4.1  Erweiterung neue Funktionen Produktion mit FA-Nummer (Seaquist)
  *                  3.3.4.0  Einbau der Versionierung
  */

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
    v_prod_lhm_id lvs_lhm.lhm_id%type;
    v_prod_lte_id lvs_lte.lte_id%type;
    function bde_c_scanner_status (
        in_scanner_name in varchar2,
        in_name         in varchar2,
        in_aufgabe      in varchar2,
        out_msg         out varchar2
    ) return boolean;

    function bde_c_scanner_status_name (
        in_scanner_name in varchar2,
        in_name         in varchar2,
        in_aufgabe      in varchar2,
        out_name        out varchar2,
        out_msg         out varchar2
    ) return boolean;

    function bde_c_scanner_buch (
        in_scanner_name in varchar2,
        in_barcode      in varchar2,
        out_msg         out varchar2
    ) return number;

    function bde_c_scanner_buch_spez (
        in_scanner_name   in varchar2,
        in_barcode        in varchar2,
        in_barcode_brutto in varchar2,  -- Incl Menge
        out_msg           out varchar2
    ) return number;

    function bde_scanner_buch_spez (
        in_scanner_name   in varchar2,
        in_barcode        in varchar2,
        in_barcode_brutto in varchar2,  -- Incl Menge
        out_msg           out varchar2
    ) return number;

    procedure bde_c_com_server_connected (
        in_sid               in isi_scanner_funk_cfg.sid%type,
        in_firma_nr          in isi_scanner_funk_cfg.firma_nr%type,
        in_scanner_funk_name in isi_scanner_funk_cfg.scanner_funk_name%type
    );

    procedure bde_c_com_server_disconnected (
        in_sid               in isi_scanner_funk_cfg.sid%type,
        in_firma_nr          in isi_scanner_funk_cfg.firma_nr%type,
        in_scanner_funk_name in isi_scanner_funk_cfg.scanner_funk_name%type
    );

    procedure bde_scanner_funk_cfg (
        in_sid                     in isi_scanner_funk_cfg.sid%type,
        in_firma_nr                in isi_scanner_funk_cfg.firma_nr%type,
        in_scanner_funk_name       in isi_scanner_funk_cfg.scanner_funk_name%type,
        out_scanner_funk_prae      out isi_scanner_funk_cfg.scanner_funk_prae%type,
        out_scanner_funk_post      out isi_scanner_funk_cfg.scanner_funk_post%type,
        out_scanner_funk_delimiter out isi_scanner_funk_cfg.scanner_funk_delimiter%type,
        out_ip_address             out isi_com_server.com_adress%type,
        out_ip_port                out isi_com_server.com_port%type
    );

    procedure bde_scanner_funk_cfg_v34 (
        in_sid                     in isi_scanner_funk_cfg.sid%type,
        in_firma_nr                in isi_scanner_funk_cfg.firma_nr%type,
        in_scanner_funk_name       in isi_scanner_funk_cfg.scanner_funk_name%type,
        out_scanner_funk_prae      out isi_scanner_funk_cfg.scanner_funk_prae%type,
        out_scanner_funk_post      out isi_scanner_funk_cfg.scanner_funk_post%type,
        out_scanner_funk_delimiter out isi_scanner_funk_cfg.scanner_funk_delimiter%type,
        out_ip_address             out isi_com_server.com_adress%type,
        out_ip_port                out isi_com_server.com_port%type,
        out_enabled                out isi_scanner_funk_cfg.scanner_funk_enabled%type
    );

    procedure bde_c_scanner_ins_scanner_cfg (
        in_sid               in isi_scanner_cfg.sid%type,
        in_firma_nr          in isi_scanner_cfg.firma_nr%type,
        in_scanner_name      in isi_scanner_cfg.scanner_name%type,
        in_scanner_prae      in isi_scanner_cfg.scanner_prae%type,
        in_scanner_post      in isi_scanner_cfg.scanner_post%type,
        in_scanner_typ       in isi_scanner_cfg.scanner_typ%type,
        in_com_name          in isi_scanner_cfg.com_name%type,
        in_scanner_visuname  in isi_scanner_cfg.scanner_visuname%type,
        in_ls_login_id       in isi_scanner_cfg.ls_login_id%type,
        in_res_id            in isi_scanner_cfg.res_id%type,
        in_akt_aufgabe       in isi_scanner_cfg.akt_aufgabe%type,
        in_scanner_funk_name in isi_scanner_cfg.scanner_funk_name%type
    );

    procedure bde_c_scanner_upd_scanner_cfg (
        in_sid               in isi_scanner_cfg.sid%type,
        in_firma_nr          in isi_scanner_cfg.firma_nr%type,
        in_scanner_name      in isi_scanner_cfg.scanner_name%type,
        in_scanner_prae      in isi_scanner_cfg.scanner_prae%type,
        in_scanner_post      in isi_scanner_cfg.scanner_post%type,
        in_scanner_typ       in isi_scanner_cfg.scanner_typ%type,
        in_com_name          in isi_scanner_cfg.com_name%type,
        in_scanner_visuname  in isi_scanner_cfg.scanner_visuname%type,
        in_ls_login_id       in isi_scanner_cfg.ls_login_id%type,
        in_res_id            in isi_scanner_cfg.res_id%type,
        in_akt_aufgabe       in isi_scanner_cfg.akt_aufgabe%type,
        in_scanner_funk_name in isi_scanner_cfg.scanner_funk_name%type
    );

    procedure bde_scanner_lock_scanner_cfg (
        in_sid          in isi_scanner_cfg.sid%type,
        in_firma_nr     in isi_scanner_cfg.firma_nr%type,
        in_scanner_name in isi_scanner_cfg.scanner_name%type
    );

    procedure bde_c_scanner_del_scanner_cfg (
        in_sid          in isi_scanner_cfg.sid%type,
        in_firma_nr     in isi_scanner_cfg.firma_nr%type,
        in_scanner_name in isi_scanner_cfg.scanner_name%type
    );

    procedure bde_scanner_check_maschine (
        in_maschine_name in isi_resource.res_ext_name%type
    );

    procedure bde_c_scanner_fa_freigabe (
        in_login_transponder in isi_user.transponder%type,
        in_maschine_name     in isi_resource.res_ext_name%type
    );

    procedure bde_c_scanner_fa_p_anmelden (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_leitzahl     in bde_fa_auftrag.leitzahl%type,
        in_res_ext_name in isi_resource.res_ext_name%type,
        in_login_id     in isi_user.login_id%type
    );

    procedure bde_c_scanner_fa_p_abmelden (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_res_ext_name in isi_resource.res_ext_name%type,
        in_login_id     in isi_user.login_id%type
    );

    procedure bde_c_scanner_fa_r_anmelden (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_leitzahl     in bde_fa_auftrag.leitzahl%type,
        in_res_ext_name in isi_resource.res_ext_name%type,
        in_login_id     in isi_user.login_id%type
    );

    procedure bde_c_scanner_fa_r_abmelden (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_res_ext_name in isi_resource.res_ext_name%type,
        in_login_id     in isi_user.login_id%type
    );

    function bde_c_scanner_login (
        in_scanner_name in varchar2,
        in_transponder  in varchar2,
        out_msg         out varchar2
    ) return number;

    procedure bde_c_scanner_ms_status (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_maschine_name in isi_resource.res_ext_name%type,
        in_transponder   in isi_user.transponder%type,
        in_res_st_id     in isi_res_status_cfg.res_st_id%type
    );

    procedure bde_c_sc_ms_schicht_anmelden (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_maschine_name in isi_resource.res_ext_name%type,
        in_login_id      in isi_user.login_id%type
    );

    procedure bde_c_sc_ms_schicht_abmelden (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_maschine_name in isi_resource.res_ext_name%type,
        in_login_id      in isi_user.login_id%type
    );

    function bde_sc_login_id (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_scanner_name in varchar2
    ) return integer;

    procedure bde_c_sc_barcode_buch (
        in_scanner_name in varchar2,
        in_barcode      in varchar2,
        out_msg         out varchar2
    );

    function bde_c_sc_prod_rest_mg (
        in_scanner_name in varchar2,
        in_barcode1     in varchar2,
        in_barcode2     in varchar2,
        out_msg         out varchar2
    ) return number;

    function bde_c_sc_fa_prod_rest_mg (
        in_scanner_name in varchar2,
        in_barcode1     in varchar2,
        in_barcode2     in varchar2,
        in_barcode3     in varchar2,
        out_msg         out varchar2
    ) return number;

    function bde_c_sc_fa_prod (
        in_scanner_name in varchar2,
        in_barcode1     in varchar2,
        in_barcode2     in varchar2,
        out_msg         out varchar2
    ) return number;

    function bde_c_isi_scan_log_chk (
        in_scanner_name in varchar2,
        in_barcode      in varchar2,
        out_msg         out varchar2
    ) return varchar2;

    procedure bde_c_isi_scan_log (
        in_scanner_name in isi_scan_log.scanner_name%type,
        in_scanner_read in isi_scan_log.scanner_read%type,
        in_scanner_cmd  in isi_scan_log.scanner_cmd%type,
        in_error_txt    in isi_scan_log.error_txt%type,
        in_scan_ok      in isi_scan_log.scan_ok%type
    );

    procedure bde_isi_scan_log_id (
        in_scanner_name in isi_scan_log.scanner_name%type,
        in_scanner_read in isi_scan_log.scanner_read%type,
        in_lte_id       in isi_scan_log.lte_id%type,
        in_lhm_id       in isi_scan_log.lhm_id%type,
        in_scanner_cmd  in isi_scan_log.scanner_cmd%type,
        in_error_txt    in isi_scan_log.error_txt%type,
        in_scan_ok      in isi_scan_log.scan_ok%type
    );

    procedure bde_c_sc_ean_create_lte_print (
        in_scanner_name in isi_scanner_cfg.scanner_name%type,
        in_barcode      in isi_scanner_cfg.scanner_daten%type,
        in_login_id     in isi_user.login_id%type,
        in_lgr_ort      in lvs_lgr_ort.lgr_ort%type default null
    );

    procedure bde_c_sc_ean_crt_lte_print_d30 (
        in_scanner_name in isi_scanner_cfg.scanner_name%type,
        in_barcode      in isi_scanner_cfg.scanner_daten%type,
        in_login_id     in isi_user.login_id%type,
        in_linie        in isi_resource.res_name%type,
        in_lgr_ort      in lvs_lgr_ort.lgr_ort%type default null
    );

end bde_scanner;
/


-- sqlcl_snapshot {"hash":"8c67c1e32a5bfec6e1f11a1edef2d1177fcde405","type":"PACKAGE_SPEC","name":"BDE_SCANNER","schemaName":"DIRKSPZM32","sxml":""}