create or replace editionable trigger dirkspzm32.tr_pzm_abwesenheitsmeldungen_powerbi_bud before
    update or delete on dirkspzm32.pzm_abwesenheitsmeldungen
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

alter trigger dirkspzm32.tr_pzm_abwesenheitsmeldungen_powerbi_bud enable;


-- sqlcl_snapshot {"hash":"6abbf85ec35ddd02585ab75fe1c637f15d1ce4b8","type":"TRIGGER","name":"TR_PZM_ABWESENHEITSMELDUNGEN_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}