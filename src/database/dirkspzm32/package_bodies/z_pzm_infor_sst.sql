create or replace 
PACKAGE BODY z_pzm_infor_sst
IS
  PROCEDURE ins_pzm_stammdaten_to_infor (i_tabelle IN z_pzm_stammdaten_to_infor.tabelle%TYPE
                                       , i_pk_felder IN z_pzm_stammdaten_to_infor.pk_felder%TYPE
                                       , i_value IN z_pzm_stammdaten_to_infor.pk_value%TYPE
                                       , i_action_type IN z_pzm_stammdaten_to_infor.action_type%TYPE)
  IS
  BEGIN
    -- ggf. Validierung der Input-Felder: Nur Insert, Update, Delete zulässig
    IF i_action_type NOT IN ('I', 'U', 'D')
    THEN
      raise_application_error (err_unknown_action_type
                             , 'Unzulässiger Action_Type-Parameter :''' || i_action_type || '''; zuslässige Werte I, U oder D');
    END IF;

    IF UPPER (trim(i_tabelle)) NOT MEMBER OF c_supported_tables
    THEN
      raise_application_error (err_unsupported_table, 'Tabelle ''' || i_tabelle || ''' nicht für INFOR vorgesehen');
    END IF;

    -- Schnittstellensatz anlegen
    INSERT INTO z_pzm_stammdaten_to_infor (tabelle
                                         , pk_felder
                                         , pk_value
                                         , action_date
                                         , status
                                         , action_type)
         VALUES (i_tabelle
               , i_pk_felder
               , i_value
               , SYSDATE
               , 'N'
               , i_action_type);
  END ins_pzm_stammdaten_to_infor;
END z_pzm_infor_sst;
/



-- sqlcl_snapshot {"hash":"896481fc36442c66fc8ec580c5ae06ddc4a40508","type":"PACKAGE_BODY","name":"Z_PZM_INFOR_SST","schemaName":"DIRKSPZM32","sxml":""}