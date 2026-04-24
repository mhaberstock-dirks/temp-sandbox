create or replace package dirkspzm32.z_huf_druck is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  30.06.2006 10:02:45
  __________________________________________________
  Description
  Project Huf Print Routinen
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

   -- Public Funktions und Prozedur-Deklaration
    function vda_etikett (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_id         in lvs_lte.lte_id%type,
        in_waren_typ  in lvs_lte.waren_typ%type,
        in_artikel_id in lvs_lam.artikel_id%type
    ) return varchar2;

end;
/


-- sqlcl_snapshot {"hash":"60b22419a59e2c9bbfb6afd0d98b47a3bead4312","type":"PACKAGE_SPEC","name":"Z_HUF_DRUCK","schemaName":"DIRKSPZM32","sxml":""}