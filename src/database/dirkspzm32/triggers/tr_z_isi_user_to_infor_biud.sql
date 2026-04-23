create or replace editionable trigger dirkspzm32.tr_z_isi_user_to_infor_biud before
    insert or update on dirkspzm32.isi_user
    for each row
begin
    begin
        if inserting then
            if
                :new.transponder is not null
                and :new.pers_nr is not null
            then
                insert into z_pzm_stammdaten_to_infor (
                    tabelle,
                    pk_felder,
                    pk_value,
                    action_date,
                    status,
                    action_type
                ) values ( 'PZM_PERSONAL',
                           'pers_nr',
                           :new.pers_nr,
                           sysdate,
                           'N',
                           'I' );

            end if;

        else
            if
                nvl(:new.transponder,
                    '0') != nvl(:old.transponder,
                                '0')
                and :old.pers_nr is not null
            then
                insert into z_pzm_stammdaten_to_infor (
                    tabelle,
                    pk_felder,
                    pk_value,
                    action_date,
                    status,
                    action_type
                ) values ( 'PZM_PERSONAL',
                           'pers_nr',
                           :new.pers_nr,
                           sysdate,
                           'N',
                           'U' );

            end if;
        end if;

    exception
        when others then
            null;
    end;
end;
/

alter trigger dirkspzm32.tr_z_isi_user_to_infor_biud enable;


-- sqlcl_snapshot {"hash":"358f668e82f83a99e6e6aa1eb325b8746194a759","type":"TRIGGER","name":"TR_Z_ISI_USER_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}