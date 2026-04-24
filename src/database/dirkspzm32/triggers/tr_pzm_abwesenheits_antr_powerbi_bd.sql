create or replace editionable trigger dirkspzm32.tr_pzm_abwesenheits_antr_powerbi_bd before
    delete on dirkspzm32.pzm_abwesenheits_antr
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
                   'ABW-ANT'
                   || :old.au_abwes_art
                   || to_char(:old.au_pers_nr)
                   || to_char(:old.au_beginn,
                              'ddmmyyyy')
                   || :old.au_status,
                   sysdate,
                   :old.au_pers_nr );

    exception
        when others then
            null;
    end;
end;
/

alter trigger dirkspzm32.tr_pzm_abwesenheits_antr_powerbi_bd enable;


-- sqlcl_snapshot {"hash":"4ad883fd30c903a5f30dc272a5c81a64642d4a69","type":"TRIGGER","name":"TR_PZM_ABWESENHEITS_ANTR_POWERBI_BD","schemaName":"DIRKSPZM32","sxml":""}