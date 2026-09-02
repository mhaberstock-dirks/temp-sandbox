create or replace 
package LVS_PROD is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  16.08.2004 12:20:18
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

  Function STR_MB_FORMAT(in_str_a      in varchar2,
                         in_trenner    in char,
                         in_formatchar in char,
                         in_laenge     in number)
                         return varchar2;

  Function STR_MB_IX(in_str_a    in varchar2,
                     in_laenge   in number,
                     in_position in number)
                     return varchar2;

  Function STR_MB_COUNT(in_str_a in varchar2,
                        in_laenge in number)
                        return number;

  Function STR_MB_GET_PARAM(in_str_a in varchar2,
                            in_start_char in char)
                            return varchar2;

  Function STR_MB_LOG_UND(in_str_a  in varchar2,
                        in_str_b  in varchar2,
                        in_laenge in number) return varchar2;

  procedure LIEFERANT_LINIE_ERZEUGEN(in_sid in isi_sid.sid%TYPE,
                                     in_firma_nr in isi_firma.firma_nr%TYPE,
                                     in_linie_name in lvs_prod_linie.linie_name%TYPE,
                                     in_adress_id in isi_adressen.adress_id%TYPE);

end LVS_PROD;
/



-- sqlcl_snapshot {"hash":"cab95fe52de21deff33a23dc3e2eaff1425aaa7a","type":"PACKAGE_SPEC","name":"LVS_PROD","schemaName":"DIRKSPZM32","sxml":""}