create or replace 
package DIRKSPZM32.bde_scanner is



  -- Author  : HJGOEDEKE
  -- Created : 07.04.2005 08:41:25
  -- Purpose : Funktionen zum Verbuchen von Barcodes aus dem Scann Server

v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
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
  v_prod_lhm_id                         lvs_lhm.lhm_id%type;
  v_prod_lte_id                         lvs_lte.lte_id%type;

function bde_c_scanner_Status (
  in_scanner_name IN  Varchar2,
  in_name         IN  Varchar2,
  in_Aufgabe      IN  Varchar2,
  out_msg         OUT Varchar2) Return boolean;

function bde_c_scanner_Status_name (
  in_scanner_name IN  Varchar2,
  in_name         IN  Varchar2,
  in_Aufgabe      IN  Varchar2,
  out_name        out varchar2,
  out_msg         OUT Varchar2) Return boolean;

function bde_c_scanner_buch (
  in_scanner_name IN  Varchar2,
  in_barcode      IN  Varchar2,
  out_msg         OUT Varchar2) Return Number;

function bde_c_scanner_buch_spez (
  in_scanner_name IN  Varchar2,
  in_barcode      IN  Varchar2,
  in_barcode_brutto in varchar2,  -- Incl Menge
  out_msg         OUT Varchar2) Return Number;

function bde_scanner_buch_spez(in_scanner_name    in varchar2,
                               in_barcode        in varchar2,
                               in_barcode_brutto in varchar2,  -- Incl Menge
                               out_msg          out varchar2
                               ) return number;
PROCEDURE bde_c_com_server_connected (
  in_sid               IN isi_scanner_funk_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_funk_cfg.firma_nr%TYPE,
  in_scanner_funk_name IN isi_scanner_funk_cfg.scanner_funk_name%TYPE);

PROCEDURE bde_c_com_server_disconnected (
  in_sid               IN isi_scanner_funk_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_funk_cfg.firma_nr%TYPE,
  in_scanner_funk_name IN isi_scanner_funk_cfg.scanner_funk_name%TYPE);

PROCEDURE bde_scanner_funk_cfg (
  in_sid                     IN  isi_scanner_funk_cfg.sid%TYPE,
  in_firma_nr                IN  isi_scanner_funk_cfg.firma_nr%TYPE,
  in_scanner_funk_name       IN  isi_scanner_funk_cfg.scanner_funk_name%TYPE,
  out_scanner_funk_prae      OUT isi_scanner_funk_cfg.scanner_funk_prae%TYPE,
  out_scanner_funk_post      OUT isi_scanner_funk_cfg.scanner_funk_post%TYPE,
  out_scanner_funk_delimiter OUT isi_scanner_funk_cfg.scanner_funk_delimiter%TYPE,
  out_ip_address             OUT isi_com_server.com_adress%TYPE,
  out_ip_port                OUT isi_com_server.com_port%TYPE);

PROCEDURE bde_scanner_funk_cfg_V34 (
  in_sid                     IN  isi_scanner_funk_cfg.sid%TYPE,
  in_firma_nr                IN  isi_scanner_funk_cfg.firma_nr%TYPE,
  in_scanner_funk_name       IN  isi_scanner_funk_cfg.scanner_funk_name%TYPE,
  out_scanner_funk_prae      OUT isi_scanner_funk_cfg.scanner_funk_prae%TYPE,
  out_scanner_funk_post      OUT isi_scanner_funk_cfg.scanner_funk_post%TYPE,
  out_scanner_funk_delimiter OUT isi_scanner_funk_cfg.scanner_funk_delimiter%TYPE,
  out_ip_address             OUT isi_com_server.com_adress%TYPE,
  out_ip_port                OUT isi_com_server.com_port%TYPE,
  out_enabled                out isi_scanner_funk_cfg.scanner_funk_enabled%type);

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
  in_scanner_funk_name IN isi_scanner_cfg.scanner_funk_name%TYPE);

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
  in_scanner_funk_name IN isi_scanner_cfg.scanner_funk_name%TYPE);

PROCEDURE bde_scanner_lock_scanner_cfg (
  in_sid               IN isi_scanner_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_cfg.firma_nr%TYPE,
  in_scanner_name      IN isi_scanner_cfg.scanner_name%TYPE);

PROCEDURE bde_c_scanner_del_scanner_cfg (
  in_sid               IN isi_scanner_cfg.sid%TYPE,
  in_firma_nr          IN isi_scanner_cfg.firma_nr%TYPE,
  in_scanner_name      IN isi_scanner_cfg.scanner_name%TYPE);

procedure bde_scanner_check_maschine(in_maschine_name          in isi_resource.res_ext_name%type);

procedure bde_c_scanner_fa_freigabe(in_login_transponder     in isi_user.transponder%type,
                                    in_maschine_name          in isi_resource.res_ext_name%type);

procedure bde_c_scanner_fa_p_anmelden (in_sid          in isi_sid.sid%type,
                                     in_firma_nr     in isi_firma.firma_nr%type,
                                     in_leitzahl     in bde_fa_auftrag.leitzahl%type,
                                     in_res_ext_name in isi_resource.res_ext_name%type,
                                     in_login_id     in isi_user.login_id%type);

procedure bde_c_scanner_fa_p_abmelden (in_sid          in isi_sid.sid%type,
                                     in_firma_nr     in isi_firma.firma_nr%type,
                                     in_res_ext_name in isi_resource.res_ext_name%type,
                                     in_login_id     in isi_user.login_id%type);

procedure bde_c_scanner_fa_r_anmelden (in_sid          in isi_sid.sid%type,
                                     in_firma_nr     in isi_firma.firma_nr%type,
                                     in_leitzahl     in bde_fa_auftrag.leitzahl%type,
                                     in_res_ext_name in isi_resource.res_ext_name%type,
                                     in_login_id     in isi_user.login_id%type);

procedure bde_c_scanner_fa_r_abmelden (in_sid          in isi_sid.sid%type,
                                     in_firma_nr     in isi_firma.firma_nr%type,
                                     in_res_ext_name in isi_resource.res_ext_name%type,
                                     in_login_id     in isi_user.login_id%type);

function bde_c_scanner_login(in_scanner_name in varchar2,
                              in_transponder  in varchar2,
                              out_msg         out varchar2
                              ) return number;

procedure bde_c_scanner_ms_status(in_sid           in isi_sid.sid%type,
                                  in_firma_nr      in isi_firma.firma_nr%type,
                                  in_maschine_name in isi_resource.res_ext_name%type,
                                  in_transponder   in isi_user.transponder%type,
                                  in_res_st_id     in isi_res_status_cfg.res_st_id%type);

procedure bde_c_sc_ms_Schicht_anmelden(in_sid           in isi_sid.sid%type,
                                       in_firma_nr      in isi_firma.firma_nr%type,
                                       in_maschine_name in isi_resource.res_ext_name%type,
                                       in_login_id      in isi_user.login_id%type);


procedure bde_c_sc_ms_Schicht_abmelden(in_sid           in isi_sid.sid%type,
                                       in_firma_nr      in isi_firma.firma_nr%type,
                                       in_maschine_name in isi_resource.res_ext_name%type,
                                       in_login_id      in isi_user.login_id%type);

function bde_sc_login_id(in_sid           in isi_sid.sid%type,
                         in_firma_nr      in isi_firma.firma_nr%type,
                         in_scanner_name in varchar2
                        ) return integer;

procedure bde_c_sc_barcode_buch(in_scanner_name in varchar2,
                                in_barcode      in varchar2,
                                out_msg         out varchar2
                                );

function bde_c_sc_prod_rest_mg(in_scanner_name in varchar2,
                                in_barcode1     in varchar2,
                                in_barcode2     in varchar2,
                                out_msg         out varchar2
                                ) return number;

function bde_c_sc_fa_prod_rest_mg(in_scanner_name in varchar2,
                                  in_barcode1     in varchar2,
                                  in_barcode2     in varchar2,
                                  in_barcode3     in varchar2,
                                  out_msg         out varchar2
                                  ) return number;

function bde_c_sc_fa_prod(in_scanner_name in varchar2,
                          in_barcode1     in varchar2,
                          in_barcode2     in varchar2,
                          out_msg         out varchar2
                         ) return number;

function bde_c_isi_scan_log_chk (in_scanner_name    in varchar2,
                                 in_barcode        in varchar2,
                                 out_msg          out varchar2
                                 ) return varchar2;

procedure bde_c_isi_scan_log(in_scanner_name  IN ISI_SCAN_LOG.Scanner_Name%TYPE,
                             in_scanner_read  IN ISI_SCAN_LOG.Scanner_Read%TYPE,
                             in_scanner_cmd   IN ISI_SCAN_LOG.Scanner_Cmd%TYPE,
                             in_error_txt     IN ISI_SCAN_LOG.Error_Txt%TYPE,
                             in_scan_ok       IN ISI_SCAN_LOG.Scan_Ok%TYPE);

procedure bde_isi_scan_log_id(in_scanner_name  in isi_scan_log.scanner_name%type,
                              in_scanner_read  in isi_scan_log.scanner_read%type,
                              in_lte_id        in isi_scan_log.lte_id%type,
                              in_lhm_id        in isi_scan_log.lhm_id%type,
                              in_scanner_cmd   in isi_scan_log.scanner_cmd%type,
                              in_error_txt     in isi_scan_log.error_txt%type,
                              in_scan_ok       in isi_scan_log.scan_ok%type);

procedure bde_c_sc_ean_create_lte_print (in_scanner_name      in      isi_scanner_cfg.scanner_name%type,
                                         in_barcode           in      isi_scanner_cfg.scanner_daten%type,
                                         in_login_id          in      isi_user.login_id%type,
                                         in_lgr_ort           in      lvs_lgr_ort.lgr_ort%type default NULL);

procedure bde_c_sc_ean_crt_lte_print_D30(in_scanner_name      in      isi_scanner_cfg.scanner_name%type,
                                         in_barcode           in      isi_scanner_cfg.scanner_daten%type,
                                         in_login_id          in      isi_user.login_id%type,
                                         in_linie             in      isi_resource.res_name%type,
                                         in_lgr_ort           in      lvs_lgr_ort.lgr_ort%type default NULL);
end bde_scanner;
/



-- sqlcl_snapshot {"hash":"037644765972e53c4ba4a74895b91105c3b3cd4b","type":"PACKAGE_SPEC","name":"BDE_SCANNER","schemaName":"DIRKSPZM32","sxml":""}