create or replace editionable trigger dirkspzm32.tr_s_essex_send_bew before
    insert or update on dirkspzm32.s_essex_send_bew
    for each row
begin
    if inserting then
        select
            seq_s_send_bew_id.nextval
        into :new.send_id
        from
            dual;

        :new.send_status := 'N';
        :new.send_ts := sysdate;
        :new.firma_nr := 1;
        if :new.lhm_id is null then
            :new.lhm_id := '0';
        end if;

        if :new.lte_id is null then
            :new.lte_id := '0';
        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_s_essex_send_bew enable;


-- sqlcl_snapshot {"hash":"c5b2479febd9be8e3d9a5476f5827c8915749a2c","type":"TRIGGER","name":"TR_S_ESSEX_SEND_BEW","schemaName":"DIRKSPZM32","sxml":""}