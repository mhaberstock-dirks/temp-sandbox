create or replace package dirkspzm32.z_cerealia_druck is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  23.04.2004 14:53:34
  __________________________________________________
  Description
  Project Cerealia (Landmännen) Print Routinen
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

end;
/


-- sqlcl_snapshot {"hash":"0444a6bfb1faa74b63d1f7ddb64261d176fca88a","type":"PACKAGE_SPEC","name":"Z_CEREALIA_DRUCK","schemaName":"DIRKSPZM32","sxml":""}