
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_Z_PZM_TARIFMOD_TO_INFOR_BIUD" 
  -- TR_Z_PZM_SCHICHT_MOD_TO_INFOR_BIUD
  BEFORE DELETE OR INSERT OR UPDATE
  ON dirkspzm32.pzm_tarifmodelle
  REFERENCING NEW AS new OLD AS old
  FOR EACH ROW
-- Kein FOLLOWS-Attribut nötig; PK wird nicht per Sequence erzeugt.

DECLARE
/******************************************************************************
   NAME:       TR_Z_PZM_TARIFMOD_TO_INFOR_BIUD
   PURPOSE:    Übermittle PK des Stammdaten-Satzes an Schnittstellen-Handler
               Validierung der

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17.07.2026      mhaberstock       1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     TR_Z_PZM_TARIFMOD_TO_INFOR_BIUD
      Sysdate:         17.07.2026
      Date and Time:   17.07.2026, 11:27:00
      Username:        mhaberstock (set in TOAD Options, Proc Templates)
      Table Name:      PZM_TARIF_MODELLE
******************************************************************************/
BEGIN
  z_pzm_infor_sst.ins_pzm_stammdaten_to_infor (
    i_tabelle       => 'PZM_TARIFMODELLE'
  , i_pk_felder     => 'TARIF_NAME'
  , i_value         => CASE WHEN INSERTING THEN :new.tarif_name ELSE :old.tarif_name END
  , i_action_type   => CASE WHEN INSERTING THEN 'I' WHEN UPDATING THEN 'U' WHEN DELETING THEN 'D' END);
END tr_z_pzm_tarifmod_to_infor_biud;
/
ALTER TRIGGER "DIRKSPZM32"."TR_Z_PZM_TARIFMOD_TO_INFOR_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"d3f8ee2f6c5f9c7dc7ce9bde39853b8ebd2ddfe4","type":"TRIGGER","name":"TR_Z_PZM_TARIFMOD_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}