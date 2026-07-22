create or replace 
PACKAGE BODY DIRKSPZM32.z_pzm_infor_sst
IS
  PROCEDURE ins_pzm_stammdaten_to_infor (i_tabelle IN z_pzm_stammdaten_to_infor.tabelle%TYPE
                                       , i_pk_felder IN z_pzm_stammdaten_to_infor.pk_felder%TYPE
                                       , i_value IN z_pzm_stammdaten_to_infor.pk_value%TYPE
                                       , i_action_type IN z_pzm_stammdaten_to_infor.action_type%TYPE)
  IS
  BEGIN
    -- ggf. Validierung der Input-Felder
    IF i_action_type NOT IN ('I', 'U', 'D')
    THEN
      raise_application_error (err_unknown_action_type
                             , 'Unzulässiger Action_Type-Parameter :''' || i_action_type || '''; zuslässige Werte I, U oder D');
    END IF;

    IF UPPER (i_tabelle) NOT IN ('PZM_SCHICHT_MODELLE', 'PZM_TARIFMODELLE')
    THEN
      raise_application_error (err_unsupported_table, 'Tabellendaten nicht für INFOR vorgesehen');
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



-- sqlcl_snapshot {"hash":"cbfb6052bb96ed48bdf2cf0804c752771236296f","type":"PACKAGE_BODY","name":"Z_PZM_INFOR_SST","schemaName":"DIRKSPZM32","sxml":""}