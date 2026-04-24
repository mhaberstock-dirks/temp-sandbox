create or replace package dirkspzm32.z_oetker_druck is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  01.09.2009 12:30:00
  __________________________________________________
  Description
  Project Oetker Print Routinen
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
    function ccg_etikett (
        in_lte_id    in lvs_lte.lte_id%type,
        in_waren_typ in lvs_lte.waren_typ%type
    ) return varchar2;

    function format_artikel (
        in_str in varchar2
    ) return varchar2;

end;
/


-- sqlcl_snapshot {"hash":"14197555f8468252d404ca5b0b648ddde54b3632","type":"PACKAGE_SPEC","name":"Z_OETKER_DRUCK","schemaName":"DIRKSPZM32","sxml":""}