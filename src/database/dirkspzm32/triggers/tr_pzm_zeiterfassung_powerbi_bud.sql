create or replace editionable trigger dirkspzm32.tr_pzm_zeiterfassung_powerbi_bud before
    update or delete on dirkspzm32.pzm_zeiterfassung
    for each row
begin
    begin
  -- auslastungsquote
        if
            updating
            and :new.last_change_date < sysdate
        then
            return;
        end if;
        insert into z_pzm_pbi_delete (
            tabelle,
            lnr,
            delete_date,
            pers_nr
        ) values ( 'buchungsdaten',
                   'ZE'
                   || to_char(:old.ze_pers_nr)
                   || to_char(:old.ze_calc_ist_start,
                              'ddmmyyyyhh24mi'),
                   sysdate,
                   :old.ze_pers_nr );

    exception
        when others then
            null;
    end;
end;
/

alter trigger dirkspzm32.tr_pzm_zeiterfassung_powerbi_bud enable;


-- sqlcl_snapshot {"hash":"2c7b1b5b4e39053959797d2e3aff57e4a9c8ec5c","type":"TRIGGER","name":"TR_PZM_ZEITERFASSUNG_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}