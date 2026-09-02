
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_Z_ISI_USER_TO_INFOR_BIUD" 
  BEFORE INSERT OR UPDATE
  ON isi_user
  FOR EACH ROW
  FOLLOWS tr_isi_user_bi
/******************************************************************************
   NAME:       tr_z_isi_user_to_infor_biud
   PURPOSE:    Übermittle PK des Stammdaten-Satzes an Schnittstellen-Handler
               Wenn Transponder für User gepflegt wird. 

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17.07.2026      mhaberstock       1. Changed this trigger

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     tr_z_isi_user_to_infor_biud
      Sysdate:         17.07.2026
      Date and Time:   17.07.2026, 12:45
      Username:        mhaberstock (set in TOAD Options, Proc Templates)
      Table Name:      ISI_USER (set in the "New PL/SQL Object" dialog)
******************************************************************************/  
BEGIN
  BEGIN
    z_pzm_infor_sst.ins_pzm_stammdaten_to_infor (
      i_tabelle       => 'PZM_PERSONAL'
    , i_pk_felder     => 'PERS_NR'
    , i_value         =>
        CASE
          WHEN INSERTING AND :new.transponder IS NOT NULL AND :new.pers_nr IS NOT NULL THEN :new.pers_nr
          WHEN UPDATING AND NVL (:new.transponder, '0') != NVL (:old.transponder, 0) AND :old.pers_nr IS NOT NULL THEN :old.pers_nr
        END
    , i_action_type   => CASE WHEN INSERTING THEN 'I' WHEN UPDATING THEN 'U' END);
  EXCEPTION
    WHEN OTHERS
    THEN
      pzm_p_log.log_exception (p_category   => pzm_p_log.cat_system
                             , p_module     => 'trigger tr_z_isi_user_to_infor_biud'
                             , p_context    => CASE WHEN INSERTING THEN 'On Insert' WHEN UPDATING THEN 'On Update' END
                             , p_pers_nr    => :new.pers_nr);
  END;
END;
/
ALTER TRIGGER "TR_Z_ISI_USER_TO_INFOR_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"47eff13187be96d398971a7de7d4098d91e645c3","type":"TRIGGER","name":"TR_Z_ISI_USER_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}