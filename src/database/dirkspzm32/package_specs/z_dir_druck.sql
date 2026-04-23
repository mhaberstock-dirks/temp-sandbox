create or replace package dirkspzm32.z_dir_druck is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  24.06.2004 16:37:26
  __________________________________________________
  Description
  Standard Print Routine nicht Kundenspezifisch
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
    function vda_etikett (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_id        in lvs_lte.lte_id%type,
        in_waren_typ in lvs_lte.waren_typ%type
    ) return varchar2;

    function ccg_etikett (
        in_lte_id    in lvs_lte.lte_id%type,
        in_waren_typ in lvs_lte.waren_typ%type
    ) return varchar2;

    function std_etikett (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_id                  in lvs_lte.lte_id%type,
        in_waren_typ           in lvs_lte.waren_typ%type,
        in_format_spez_barcode in isi_adressen.lte_etiketten_spez_barcode%type
    ) return varchar2;

    procedure c_test_etikett (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_drucker  in pe_drucker_cfg.drucker_name%type
    );

    function format_artikel (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_str      in varchar2
    ) return varchar2;

end z_dir_druck;
/


-- sqlcl_snapshot {"hash":"614bed5b7bd00845a81e313e4c5d8e81caa6f016","type":"PACKAGE_SPEC","name":"Z_DIR_DRUCK","schemaName":"DIRKSPZM32","sxml":""}