create or replace editionable trigger dirkspzm32.tr_pzm_ze_loa_exp_ext_gutsch_powerbi_bud before
    update or delete on dirkspzm32.pzm_ze_loa_exp_ext_gutsch
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

alter trigger dirkspzm32.tr_pzm_ze_loa_exp_ext_gutsch_powerbi_bud enable;


-- sqlcl_snapshot {"hash":"bb21a3dfcb3f075dd581386fc5e2035e928a42ed","type":"TRIGGER","name":"TR_PZM_ZE_LOA_EXP_EXT_GUTSCH_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}