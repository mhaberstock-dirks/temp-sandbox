create or replace package dirkspzm32.lvs_prod is

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

    function str_mb_format (
        in_str_a      in varchar2,
        in_trenner    in char,
        in_formatchar in char,
        in_laenge     in number
    ) return varchar2;

    function str_mb_ix (
        in_str_a    in varchar2,
        in_laenge   in number,
        in_position in number
    ) return varchar2;

    function str_mb_count (
        in_str_a  in varchar2,
        in_laenge in number
    ) return number;

    function str_mb_get_param (
        in_str_a      in varchar2,
        in_start_char in char
    ) return varchar2;

    function str_mb_log_und (
        in_str_a  in varchar2,
        in_str_b  in varchar2,
        in_laenge in number
    ) return varchar2;

    procedure lieferant_linie_erzeugen (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_linie_name in lvs_prod_linie.linie_name%type,
        in_adress_id  in isi_adressen.adress_id%type
    );

end lvs_prod;
/


-- sqlcl_snapshot {"hash":"f2d9e63782441ab90df57beafe9b4fde1a812dea","type":"PACKAGE_SPEC","name":"LVS_PROD","schemaName":"DIRKSPZM32","sxml":""}