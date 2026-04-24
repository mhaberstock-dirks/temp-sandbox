create or replace editionable trigger dirkspzm32.tr_s_seaquist_send_bew_bu after
    update on dirkspzm32.s_seaquist_send_bew
    for each row
declare begin
    if :new.status = 'L' then
        delete s_send_bew
        where
            s_send_bew.bew_id = :new.bew_id;

    end if;
end;
/

alter trigger dirkspzm32.tr_s_seaquist_send_bew_bu enable;


-- sqlcl_snapshot {"hash":"8a8461b21ae2af418158b67c90b39772a35d01ea","type":"TRIGGER","name":"TR_S_SEAQUIST_SEND_BEW_BU","schemaName":"DIRKSPZM32","sxml":""}