create or replace editionable trigger dirkspzm32.tr_pps_stueckliste_biud before
    insert or update or delete on dirkspzm32.pps_stueckliste
    for each row
declare begin
    if deleting then
        delete pps_stueckliste_pos t
        where
            t.stueckliste_id = :old.stueckliste_id;

    end if;
end tr_pps_stueckliste_biud;
/

alter trigger dirkspzm32.tr_pps_stueckliste_biud enable;


-- sqlcl_snapshot {"hash":"4300d3e8b9846685b29571581ab2bd78862e937a","type":"TRIGGER","name":"TR_PPS_STUECKLISTE_BIUD","schemaName":"DIRKSPZM32","sxml":""}