
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_Z_PZM_ABTEILUNGEN_TO_INFOR_BIUD" 
  BEFORE INSERT OR UPDATE OR DELETE
  ON pzm_abteilungen
  FOR EACH ROW
  /******************************************************************************
     NAME:       tr_z_pzm_abteilungen_to_infor_biud
     PURPOSE:    Übermittle PK des Stammdaten-Satzes an Schnittstellen-Handler
                 

     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        17.07.2026      mhaberstock       1. Changed this trigger

     NOTES:

     Automatically available Auto Replace Keywords:
        Object Name:     tr_z_pzm_abteilungen_to_infor_biud
        Sysdate:         17.07.2026
        Date and Time:   17.07.2026, 12:45
        Username:        mhaberstock (set in TOAD Options, Proc Templates)
        Table Name:      pzm_personal (set in the "New PL/SQL Object" dialog)
  ******************************************************************************/

BEGIN
  z_pzm_infor_sst.ins_pzm_stammdaten_to_infor (
      i_tabelle       => 'PZM_ABTEILUNGEN'
    , i_pk_felder     => 'ABT_ID'
    , i_value         =>
        CASE
          WHEN INSERTING THEN :new.abt_id
          WHEN UPDATING OR DELETING THEN :old.abt_id
        END
    , i_action_type   => CASE WHEN INSERTING THEN 'I' WHEN UPDATING THEN 'U' WHEN DELETING THEN 'D' END);
  EXCEPTION
    WHEN OTHERS
    THEN
      pzm_p_log.log_exception (p_category   => pzm_p_log.cat_system
                             , p_module     => 'trigger tr_z_pzm_abteilungen_to_infor_biud'
                             , p_context    => CASE WHEN INSERTING THEN 'On Insert' 
                                                    WHEN UPDATING THEN 'On Update' 
                                                    WHEN DELETING THEN 'On Delete' END);
END;
/
ALTER TRIGGER "TR_Z_PZM_ABTEILUNGEN_TO_INFOR_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"f7b0b166d0c4ffe9f4ecb66240670fb70d420699","type":"TRIGGER","name":"TR_Z_PZM_ABTEILUNGEN_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}