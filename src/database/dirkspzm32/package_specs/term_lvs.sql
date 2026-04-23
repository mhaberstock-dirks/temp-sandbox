create or replace package dirkspzm32.term_lvs is

  -- Author  : HJGOEDEKE
  -- Created : 12.02.2009 11:27:22
  -- Purpose :

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;
  /*
  *  Versionsverlauf
  *  Datum      | Version    | Info
  *  ---------------------------------------------------------------------------------
  *  12.02.2009 | 3.4.10.1   | (-WK-) Package erstellt
  */
end term_lvs;
/


-- sqlcl_snapshot {"hash":"d7d4a79b30c289130252889d51e4bcf9a11b3cd1","type":"PACKAGE_SPEC","name":"TERM_LVS","schemaName":"DIRKSPZM32","sxml":""}