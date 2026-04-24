create or replace editionable trigger dirkspzm32.tr_pzm_zeiterfassung_powerbi_bd before
    delete on dirkspzm32.pzm_zeiterfassung
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

alter trigger dirkspzm32.tr_pzm_zeiterfassung_powerbi_bd enable;


-- sqlcl_snapshot {"hash":"dcf4a6909e24598a36f8045d37f9dd4d79806a58","type":"TRIGGER","name":"TR_PZM_ZEITERFASSUNG_POWERBI_BD","schemaName":"DIRKSPZM32","sxml":""}