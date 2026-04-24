create or replace editionable trigger dirkspzm32.tr_pzm_ze_tagessatz_powerbi_bud before
    update or delete on dirkspzm32.pzm_ze_tagessatz
    for each row
begin
  -- auslastungsquote
    begin
        insert into z_pzm_pbi_delete (
            tabelle,
            lnr,
            delete_date,
            pers_nr
        ) values ( 'auslastungsquote',
                   to_char(:old.ts_pers_nr * 1000000000) + to_number(to_char(:old.ts_datum,
                                                                             'yyyymmdd')) * 10 + 0,
                   sysdate,
                   :old.ts_pers_nr );

    exception
        when others then
            null;
    end;

    begin
        insert into z_pzm_pbi_delete (
            tabelle,
            lnr,
            delete_date,
            pers_nr
        ) values ( 'auslastungsquote',
                   to_char(:old.ts_pers_nr * 1000000000) + to_number(to_char(:old.ts_datum,
                                                                             'yyyymmdd')) * 10 + 1,
                   sysdate,
                   :old.ts_pers_nr );

    exception
        when others then
            null;
    end;

    begin
    -- kostenstellensplit
        insert into z_pzm_pbi_delete (
            tabelle,
            lnr,
            delete_date,
            pers_nr
        ) values ( 'kostenstellensplit',
                   substr(:old.ts_pers_nr
                          || :old.ts_day_kst_id
                          || to_char(:old.ts_datum,
                                     'ddmmyyyy')
                          || 'Anwesende_Zeit',
                          1,
                          150),
                   sysdate,
                   :old.ts_pers_nr );

    exception
        when others then
            null;
    end;

    begin
        insert into z_pzm_pbi_delete (
            tabelle,
            lnr,
            delete_date,
            pers_nr
        ) values ( 'kostenstellensplit',
                   substr(:old.ts_pers_nr
                          || :old.ts_day_kst_id
                          || to_char(:old.ts_datum,
                                     'ddmmyyyy')
                          || :old.ts_aa_id,
                          1,
                          150),
                   sysdate,
                   :old.ts_pers_nr );

    exception
        when others then
            null;
    end;

end;
/

alter trigger dirkspzm32.tr_pzm_ze_tagessatz_powerbi_bud enable;


-- sqlcl_snapshot {"hash":"d6d447359a36afce7f5e36522e661ef79f063e0f","type":"TRIGGER","name":"TR_PZM_ZE_TAGESSATZ_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}