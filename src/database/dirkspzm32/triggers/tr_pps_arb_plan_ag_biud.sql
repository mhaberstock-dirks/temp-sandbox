create or replace editionable trigger dirkspzm32.tr_pps_arb_plan_ag_biud before
    insert or update or delete on dirkspzm32.pps_arb_plan_ag
    for each row
declare begin
    if deleting then
        delete pps_arb_plan_ag_stl t
        where
                t.arb_plan_id = :old.arb_plan_id
            and t.arb_plan_pos_id = :old.arb_plan_pos_id
            and t.ag_alternative = :old.ag_alternative;

    end if;
end tr_pps_arb_plan_ag_biud;
/

alter trigger dirkspzm32.tr_pps_arb_plan_ag_biud enable;


-- sqlcl_snapshot {"hash":"19a9db8935292795420a0c8453fe21f0528fa522","type":"TRIGGER","name":"TR_PPS_ARB_PLAN_AG_BIUD","schemaName":"DIRKSPZM32","sxml":""}