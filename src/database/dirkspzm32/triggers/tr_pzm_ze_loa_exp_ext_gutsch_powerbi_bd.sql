create or replace editionable trigger dirkspzm32.tr_pzm_ze_loa_exp_ext_gutsch_powerbi_bd before
    delete on dirkspzm32.pzm_ze_loa_exp_ext_gutsch
    for each row
begin
    begin  
  -- auslastungsquote
        insert into z_pzm_pbi_delete (
            tabelle,
            lnr,
            delete_date,
            pers_nr
        ) values ( 'buchungsdaten',
                   'PDL'
                   || :old.pers_nr
                   || :old.lohnart
                   || to_char(:old.datum,
                              'ddmmyyyy'),
                   sysdate,
                   :old.pers_nr );

        insert into z_pzm_pbi_delete (
            tabelle,
            lnr,
            delete_date,
            pers_nr
        ) values ( 'pdler',
                   'PDL'
                   || to_char(:old.pers_nr)
                   || to_char(:old.datum,
                              'ddmmyyyy')
                   || :old.lohnart,
                   sysdate,
                   :old.pers_nr );

    exception
        when others then
            null;
    end;
end;
/

alter trigger dirkspzm32.tr_pzm_ze_loa_exp_ext_gutsch_powerbi_bd enable;


-- sqlcl_snapshot {"hash":"856fd9ae46e7fae4583067d1b2f1bc6951753ad7","type":"TRIGGER","name":"TR_PZM_ZE_LOA_EXP_EXT_GUTSCH_POWERBI_BD","schemaName":"DIRKSPZM32","sxml":""}