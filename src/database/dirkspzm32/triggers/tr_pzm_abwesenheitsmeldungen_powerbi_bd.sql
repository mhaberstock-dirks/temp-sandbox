create or replace editionable trigger dirkspzm32.tr_pzm_abwesenheitsmeldungen_powerbi_bd before
    delete on dirkspzm32.pzm_abwesenheitsmeldungen
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
                   'ABW'
                   || :old.aa_id
                   || to_char(:old.pers_nr)
                   || to_char(:old.beginn,
                              'ddmmyyyy')
                   || :old.aa_id,
                   sysdate,
                   :old.pers_nr );

    exception
        when others then
            null;
    end;
end;
/

alter trigger dirkspzm32.tr_pzm_abwesenheitsmeldungen_powerbi_bd enable;


-- sqlcl_snapshot {"hash":"6501af121f5b0b32e99246d3aa6a9bb069c8b7e5","type":"TRIGGER","name":"TR_PZM_ABWESENHEITSMELDUNGEN_POWERBI_BD","schemaName":"DIRKSPZM32","sxml":""}