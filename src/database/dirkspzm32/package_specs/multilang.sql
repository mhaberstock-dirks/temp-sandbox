create or replace package dirkspzm32.multilang is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  15.12.2004 00:19:01
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

    function get_lang_name (
        in_lang_id in isi_language.lang_id%type
    ) return isi_language.lang_name%type;

    function get_lang_id (
        in_lang_name in isi_language.lang_name%type
    ) return isi_language.lang_id%type;

    function get_default_firma_lang_name (
        in_firma_nr in isi_firma.firma_nr%type
    ) return isi_language.lang_name%type;

    procedure get_module_lang_data (
        in_module_id           in sec_module_info.mod_id%type,
        out_module_caption     out sec_module_info.caption%type,
        out_module_description out sec_module_info.description%type
    );

    procedure get_section_lang_data (
        in_section_id           in sec_section_info.section_id%type,
        out_section_caption     out sec_section_info.caption%type,
        out_section_description out sec_section_info.description%type
    );

    procedure get_lang_info (
        in_lang_name  in isi_language.lang_name%type,
        out_lang_info out isi_language%rowtype
    );

    function get_all_lang_names_cs return varchar2;

    function get_firma_lang_names_cs (
        in_firma_nr in isi_firma.firma_nr%type
    ) return varchar2;

    function get_arbeitsplatz_lang_names_cs (
        ip_adresse in isi_arbeitsplatz.ip_adresse%type
    ) return varchar2;

end multilang;
/


-- sqlcl_snapshot {"hash":"2dd63e31fe2c80e042e5b5e32b2d163c9bf7bec0","type":"PACKAGE_SPEC","name":"MULTILANG","schemaName":"DIRKSPZM32","sxml":""}