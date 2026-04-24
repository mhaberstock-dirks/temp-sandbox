create or replace editionable trigger dirkspzm32.tr_pzm_abwesenheits_antr_powerbi_bud before
    update or delete on dirkspzm32.pzm_abwesenheits_antr
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

alter trigger dirkspzm32.tr_pzm_abwesenheits_antr_powerbi_bud enable;


-- sqlcl_snapshot {"hash":"d556cec54a2932ebfe18a5ab715a097d68b8475e","type":"TRIGGER","name":"TR_PZM_ABWESENHEITS_ANTR_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}