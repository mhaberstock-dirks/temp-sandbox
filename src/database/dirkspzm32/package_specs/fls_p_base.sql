create or replace package dirkspzm32.fls_p_base is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  10.12.2007
  __________________________________________________
  Description
  Basisfunktionalitäten zur Buchung von FLS-Aktivitäten
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;
  /*
	*  Versionsverlauf
	*   - V3.4.4.1: > Package erstellt
  */
end fls_p_base;
/


-- sqlcl_snapshot {"hash":"251079981b3620b191f6438f473cc3bcac5b1d5b","type":"PACKAGE_SPEC","name":"FLS_P_BASE","schemaName":"DIRKSPZM32","sxml":""}