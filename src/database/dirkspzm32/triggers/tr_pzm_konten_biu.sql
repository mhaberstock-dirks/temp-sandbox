create or replace editionable trigger dirkspzm32.tr_pzm_konten_biu before
    insert or update on dirkspzm32.pzm_konten
    for each row
begin
    if inserting then
        if :new.konto_nr is null then
            select
                seq_pzm_konto_nr.nextval
            into :new.konto_nr
            from
                dual;

        end if;

    elsif updating then
        if :new.min_saldo is not null then
            if :new.saldo < :new.min_saldo then
                pzm_p_log.log_data(
                    p_level      => pzm_p_log.level_warning,
                    p_message    => 'Der Saldo unterschreitet den Minimalwert des Kontos. Konto: ' || :new.name,
                    p_category   => pzm_p_log.cat_system,
                    p_module     => 'TR_PZM_KONTEN_BIU',
                    p_error_code => pzm_p_lc.pzm_error_buchung,
                    p_pers_nr    => :new.pers_nr
                );

            end if;
        end if;

        if :new.max_saldo is not null then
            if :new.saldo > :new.max_saldo then
                pzm_p_log.log_data(
                    p_level      => pzm_p_log.level_warning,
                    p_message    => 'Der Saldo ueberschreitet den Maximalwert des Kontos. Konto: ' || :new.name,
                    p_category   => pzm_p_log.cat_system,
                    p_module     => 'TR_PZM_KONTEN_BIU',
                    p_error_code => pzm_p_lc.pzm_error_buchung,
                    p_pers_nr    => :new.pers_nr
                );

            end if;

        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_konten_biu enable;


-- sqlcl_snapshot {"hash":"2e1ce5cd3ab3c5e5d13f3a356bc67f7faa5bfc13","type":"TRIGGER","name":"TR_PZM_KONTEN_BIU","schemaName":"DIRKSPZM32","sxml":""}