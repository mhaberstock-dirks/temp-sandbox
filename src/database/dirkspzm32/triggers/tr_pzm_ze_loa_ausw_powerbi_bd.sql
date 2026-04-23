create or replace editionable trigger dirkspzm32.tr_pzm_ze_loa_ausw_powerbi_bd before
    delete on dirkspzm32.pzm_ze_loa_ausw
    for each row
declare
    v_is_reg number;
    cursor c_is_reg is
    select
        count(t.lnr)
    from
        z_pzm_pbi_delete t
    where
            t.tabelle = 'buchungsdaten'
        and t.lnr = 'LOA'
                    || :old.zeaw_lz_lohnart
                    || to_char(:old.zeaw_pers_nr)
                    || to_char(:old.zeaw_datum,
                               'ddmmyyyy')
        and t.delete_date = sysdate;

begin
    open c_is_reg;
    fetch c_is_reg into v_is_reg;
    close c_is_reg;
    if v_is_reg = 0 then
        begin
      -- auslastungsquote
            insert into z_pzm_pbi_delete (
                tabelle,
                lnr,
                delete_date,
                pers_nr
            ) values ( 'buchungsdaten',
                       'LOA'
                       || :old.zeaw_lz_lohnart
                       || to_char(:old.zeaw_pers_nr)
                       || to_char(:old.zeaw_datum,
                                  'ddmmyyyy'),
                       sysdate,
                       :old.zeaw_pers_nr );

        exception
            when others then
                null;
        end;
    end if;

end;
/

alter trigger dirkspzm32.tr_pzm_ze_loa_ausw_powerbi_bd enable;


-- sqlcl_snapshot {"hash":"3f8695fe8970aba819ac37aa4e307095137e3758","type":"TRIGGER","name":"TR_PZM_ZE_LOA_AUSW_POWERBI_BD","schemaName":"DIRKSPZM32","sxml":""}