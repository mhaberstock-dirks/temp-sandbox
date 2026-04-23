create or replace editionable trigger dirkspzm32.tr_z_pzm_produktionsbereiche_to_infor_biud before
    insert or update or delete on dirkspzm32.pzm_produktionsbereiche
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
            ) values ( 'PZM_PRODUKTIONSBEREICHE',
                       'pb_id',
                       :new.pb_id,
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
            ) values ( 'PZM_PRODUKTIONSBEREICHE',
                       'pb_id',
                       :old.pb_id,
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

alter trigger dirkspzm32.tr_z_pzm_produktionsbereiche_to_infor_biud enable;


-- sqlcl_snapshot {"hash":"248eb6770a9be70c1b62dfd5b70ccd5fd1456a44","type":"TRIGGER","name":"TR_Z_PZM_PRODUKTIONSBEREICHE_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}