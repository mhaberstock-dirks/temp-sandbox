create or replace 
package z_cerealia_druck is

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
  function ccg_etikett(in_lte_id      in lvs_lte.lte_id%type,
                       in_waren_typ   in lvs_lte.waren_typ%type)
                                      return varchar2;

end;
/



-- sqlcl_snapshot {"hash":"3de652384c7dcce6b9a0e1489361c15991f8d4bc","type":"PACKAGE_SPEC","name":"Z_CEREALIA_DRUCK","schemaName":"DIRKSPZM32","sxml":""}