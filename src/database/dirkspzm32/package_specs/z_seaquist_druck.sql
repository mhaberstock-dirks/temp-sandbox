create or replace package dirkspzm32.z_seaquist_druck is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  24.06.2004 16:37:26
  __________________________________________________
  Description
  Project Seaquist Print Routinen
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

------------------------------------------------------------------------------
-- (-AM-) 080815
-- Selektiert die Daten, die zum Drucken des Seaquist Karton-Versandlabels
-- und des Vormontagelabels benötigt werden und setzt die Zeichenkette zusammen,
-- die nach Abgleich mit der LOGPAK-Layout-Datei etiketten_seaquist_logopak_KrtVers.txt
-- (unter seaquist\x.x.x.x\rave_projects) direkt an den Drucker gesendet wird oder
-- der Print-Engine in der Tabelle PE_JOBS übergeben werden kann.
-- Result: Liste der zu druckenden Parameter, muss noch mit der Druck-Template-Datei zusammengeführt werden.
------------------------------------------------------------------------------

    function vda_etikett_vers_krt (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_id       in lvs_lhm.lhm_id%type
    ) return varchar2;

    function ccg_etikett_vers_lte (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_id       in lvs_lhm.lhm_id%type
    ) return varchar2;

end;
/


-- sqlcl_snapshot {"hash":"c5b913337c042aa2012fecc981143be8665cbd4c","type":"PACKAGE_SPEC","name":"Z_SEAQUIST_DRUCK","schemaName":"DIRKSPZM32","sxml":""}