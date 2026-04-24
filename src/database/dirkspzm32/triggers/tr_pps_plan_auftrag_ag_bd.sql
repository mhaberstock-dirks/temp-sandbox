create or replace editionable trigger dirkspzm32.tr_pps_plan_auftrag_ag_bd before
    delete on dirkspzm32.pps_plan_auftrag_ag
    for each row
declare begin
    delete pps_plan_auftrag_ag_stl t
    where
            t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.plan_auf_ag_id = :old.plan_auf_ag_id;

    delete pps_plan_auftrag_ag_res t
    where
            t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.plan_auf_ag_id = :old.plan_auf_ag_id;

    delete pps_plan_auftrag_ag_fhm t
    where
            t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.plan_auf_ag_id = :old.plan_auf_ag_id;

end tr_pps_plan_auftrag_bd;
/

alter trigger dirkspzm32.tr_pps_plan_auftrag_ag_bd enable;


-- sqlcl_snapshot {"hash":"83bc3a53cbe6bd2be2d0342a3c427bd70858531d","type":"TRIGGER","name":"TR_PPS_PLAN_AUFTRAG_AG_BD","schemaName":"DIRKSPZM32","sxml":""}