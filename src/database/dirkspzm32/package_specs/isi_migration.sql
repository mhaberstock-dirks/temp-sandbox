create or replace package dirkspzm32.isi_migration is

  /*
  __________________________________________________
  Author
  BWELLING (-BW-)  25.03.2010 13:00:00
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  02.04.2004   3.5.0.0     (-BW-)   Package erstellt
  */

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;

    function c_migration_to_3_5_1 return varchar2;

end isi_migration;
/


-- sqlcl_snapshot {"hash":"8326b06550d1a07730977ec0618ba455ef0b3f80","type":"PACKAGE_SPEC","name":"ISI_MIGRATION","schemaName":"DIRKSPZM32","sxml":""}