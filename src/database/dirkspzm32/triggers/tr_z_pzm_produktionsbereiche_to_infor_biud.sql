
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_Z_PZM_PRODUKTIONSBEREICHE_TO_INFOR_BIUD" 
  BEFORE INSERT OR UPDATE OR DELETE
  ON pzm_produktionsbereiche
  FOR EACH ROW
  /******************************************************************************
     NAME:       tr_z_pzm_produktionsbereiche_to_infor_biud
     PURPOSE:    Übermittle PK des Stammdaten-Satzes an Schnittstellen-Handler
                 

     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        17.07.2026      mhaberstock       1. Changed this trigger

     NOTES:

     Automatically available Auto Replace Keywords:
        Object Name:     tr_z_pzm_produktionsbereiche_to_infor_biud
        Sysdate:         17.07.2026
        Date and Time:   17.07.2026, 12:45
        Username:        mhaberstock (set in TOAD Options, Proc Templates)
        Table Name:      pzm_personal (set in the "New PL/SQL Object" dialog)
  ******************************************************************************/
BEGIN
  z_pzm_infor_sst.ins_pzm_stammdaten_to_infor (
    i_tabelle       => 'PZM_PRODUKTIONSBEREICHE'
  , i_pk_felder     => 'PB_ID'
  , i_value         => CASE WHEN INSERTING THEN :new.pb_id ELSE :old.pb_id END
  , i_action_type   => CASE WHEN INSERTING THEN 'I' WHEN UPDATING THEN 'U' WHEN DELETING THEN 'D' END);
  EXCEPTION
    WHEN OTHERS
    THEN
      pzm_p_log.log_exception (p_category   => pzm_p_log.cat_system
                             , p_module     => 'trigger tr_z_pzm_produktionsbereiche_to_infor_biud'
                             , p_context    => CASE WHEN INSERTING THEN 'On Insert' 
                                                    WHEN UPDATING THEN 'On Update' 
                                                    WHEN DELETING THEN 'On Delete' END);
END;
/
ALTER TRIGGER "TR_Z_PZM_PRODUKTIONSBEREICHE_TO_INFOR_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"88cf35f4e8b08ba7feb33bedd3e8bd783b468786","type":"TRIGGER","name":"TR_Z_PZM_PRODUKTIONSBEREICHE_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}