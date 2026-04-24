create or replace editionable trigger dirkspzm32.tr_z_pzm_personal_to_infor_biud before
    insert or update or delete on dirkspzm32.pzm_personal
    for each row
declare
    v_action_type varchar2(1);
begin
    begin
        if inserting then
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

        else
            if updating then
                v_action_type := 'U';
            else
                v_action_type := 'D';
            end if;
            insert into z_pzm_stammdaten_to_infor (
                tabelle,
                pk_felder,
                pk_value,
                action_date,
                status,
                action_type
            ) values ( 'PZM_PERSONAL',
                       'pers_nr',
                       :old.pers_nr,
                       sysdate,
                       'N',
                       v_action_type );

        end if;

    exception
        when others then
            null;
    end;
end;
/

alter trigger dirkspzm32.tr_z_pzm_personal_to_infor_biud enable;


-- sqlcl_snapshot {"hash":"6f1e0250c0f980499950ad383b365eae4b29a057","type":"TRIGGER","name":"TR_Z_PZM_PERSONAL_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}