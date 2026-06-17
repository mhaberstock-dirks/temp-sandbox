create or replace 
package DIRKSPZM32.isi_utils is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  03.02.2006 15:08:06
  __________________________________________________
  Description
  Allgemeine Funktionen wie MBUtils.pas
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
	06.01.2009   3.4.10      (-BW-)   Zentrale FORMAT_XX
	21.04.2008   x.x.x.x     (-BW-)   SecondsBetweenD()
	03.02.2006   x.x.x.x     (-WK-)   Erstellt
  */


  -- Public Funktions und Prozedur-Deklaration
  function max_number(in_a in number, in_b in number) return number;

  function md5_encrypt(in_clear_value in varchar2) return varchar2;

  function time_delta(in_from_date in date,
                      in_to_date in date,
                      in_format in varchar2,
                      in_use_feiertage in varchar2,
                      in_use_weekend in varchar2,
                      in_day_start_limit in number,
                      in_day_end_limit in number) return number;

  function byte_unit_to_byte(in_value in number,
                             in_unit_name in varchar2) return number;

  function substr_to_eol(in_str in varchar2, in_pos in number) return varchar2;

  procedure spez_barcode_gen(in_artikel              in  isi_artikel.artikel%type,
                             in_charge               in  lvs_charge.charge_bez%type,
                             in_menge                in  lvs_lam.menge%type,
                             in_p_datum              in  lvs_lam.prod_datum%type,
                             in_ean                  in  varchar2,
                             in_typ                  in  varchar2,
                             in_hersteller_tag       in  varchar2,
                             in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                             out_barcode             out varchar2);

  procedure spez_barcode_lfdn(in_sid                  in  isi_firma.sid%type,
                              in_firma_nr             in  isi_firma.firma_nr%type,
                              in_barcode              in  varchar2,
                              in_barcode_ref          in  varchar2,
                              out_lfdn                out number);

  function get_csv_items_count(in_csv_string in varchar2) return number;

  function get_csv_value(in_csv_string in  varchar2,
                         in_csv_item   in  varchar2
                        ) return varchar2;

  function get_csv_item(in_csv_string in varchar2,
                        in_item_ix in number,
                        out_item_substring out varchar2
                       ) return boolean;

  function index_of_csv_item(in_csv_string in varchar2,
                             in_csv_item in varchar2
                            ) return number;

  function is_param_list_comlete(in_csv_params_values in varchar2,
                                 in_csv_params_cfg in varchar2,
                                 in_check_values in varchar2
                                ) return varchar2;

  function SecondsBetweenD(in_from_date in date,
                             in_to_date in date
                                ) return number;

  function human_to_steuerzeichen (
      in_str IN VARCHAR2) RETURN VARCHAR2;

  function Format_EAN (
    in_str IN VARCHAR2) RETURN VARCHAR2;

  function Format_NVE (
    in_str IN VARCHAR2) RETURN VARCHAR2;

  function Modulo43_CheckDigit(in_text IN varchar2) return VARCHAR2;
  
  function Iso_WeekDay(in_date IN date) RETURN number;
  

end isi_utils;
/



-- sqlcl_snapshot {"hash":"f9c22bc2a6c7eae26dddefc6955d9e0656c7033c","type":"PACKAGE_SPEC","name":"ISI_UTILS","schemaName":"DIRKSPZM32","sxml":""}