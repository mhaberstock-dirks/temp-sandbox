create or replace editionable trigger dirkspzm32.tr_s_seaquist_send_bew_bd after
    delete on dirkspzm32.s_seaquist_send_bew
    for each row
declare begin
    if :old.status = 'L' then
        delete s_send_bew
        where
            s_send_bew.bew_id = :old.bew_id;

    end if;
end;
/

alter trigger dirkspzm32.tr_s_seaquist_send_bew_bd enable;


-- sqlcl_snapshot {"hash":"276b14f253aa537dc93fc9d6eca7d0bfbae4d336","type":"TRIGGER","name":"TR_S_SEAQUIST_SEND_BEW_BD","schemaName":"DIRKSPZM32","sxml":""}