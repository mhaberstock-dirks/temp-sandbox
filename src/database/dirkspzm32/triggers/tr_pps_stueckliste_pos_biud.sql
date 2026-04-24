create or replace editionable trigger dirkspzm32.tr_pps_stueckliste_pos_biud before
    insert or update or delete on dirkspzm32.pps_stueckliste_pos
    for each row
declare begin
    if deleting then
        delete pps_arb_plan_ag_stl t
        where
            t.stueckliste_pos_id = :old.stueckliste_pos_id;

    end if;
end tr_pps_stueckliste_pos_biud;
/

alter trigger dirkspzm32.tr_pps_stueckliste_pos_biud enable;


-- sqlcl_snapshot {"hash":"ff7dec70a90f7fe2139bdec465963df771161f6a","type":"TRIGGER","name":"TR_PPS_STUECKLISTE_POS_BIUD","schemaName":"DIRKSPZM32","sxml":""}