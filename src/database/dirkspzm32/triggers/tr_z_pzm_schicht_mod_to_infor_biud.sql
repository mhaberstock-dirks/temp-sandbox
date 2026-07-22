
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_Z_PZM_SCHICHT_MOD_TO_INFOR_BIUD" 
  BEFORE DELETE OR INSERT OR UPDATE
  ON dirkspzm32.pzm_schicht_modelle
  REFERENCING NEW AS new OLD AS old
  FOR EACH ROW

DECLARE
/******************************************************************************
   NAME:       TR_Z_PZM_SCHICHT_MOD_TO_INFOR_BIUD
   PURPOSE:    Übermittle PK des Stammdaten-Satzes an Schnittstellen-Handler
               Validierung der

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17.07.2026      mhaberstock       1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     TR_Z_PZM_SCHICHT_MOD_TO_INFOR_BIUD
      Sysdate:         17.07.2026
      Date and Time:   17.07.2026, 09:19:28, and 17.07.2026 09:19:28
      Username:        mhaberstock (set in TOAD Options, Proc Templates)
      Table Name:      PZM_SCHICHT_MODELLE (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/
BEGIN
  z_pzm_infor_sst.ins_pzm_stammdaten_to_infor (
    i_tabelle       => 'PZM_SCHICHT_MODELLE'
  , i_pk_felder     => 'SM_NAME'
  , i_value         => CASE WHEN INSERTING THEN :new.sm_name ELSE :old.sm_name END
  , i_action_type   => CASE WHEN INSERTING THEN 'I' WHEN UPDATING THEN 'U' WHEN DELETING THEN 'D' END);
END tr_z_pzm_schicht_mod_to_infor_biud;
/
ALTER TRIGGER "DIRKSPZM32"."TR_Z_PZM_SCHICHT_MOD_TO_INFOR_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"c999da1caea05562e4b4f807ba851c92d676b08b","type":"TRIGGER","name":"TR_Z_PZM_SCHICHT_MOD_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}