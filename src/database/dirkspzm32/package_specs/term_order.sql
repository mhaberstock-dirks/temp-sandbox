create or replace package dirkspzm32.term_order is

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
end term_order;
/


-- sqlcl_snapshot {"hash":"454059f3ab911883112f62014e69a12d541cd654","type":"PACKAGE_SPEC","name":"TERM_ORDER","schemaName":"DIRKSPZM32","sxml":""}