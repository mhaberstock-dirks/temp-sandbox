create or replace editionable trigger dirkspzm32.tr_bde_pd_schicht_log_bi before
    insert on dirkspzm32.bde_pd_schicht_log
    for each row
declare
  -- local variables here
 begin
    if :new.schicht_log_id is null then
        select
            seq_bde_pd_schicht_log_id.nextval
        into :new.schicht_log_id
        from
            dual;

    end if;
end tr_bde_pd_schicht_log_bi;
/

alter trigger dirkspzm32.tr_bde_pd_schicht_log_bi enable;


-- sqlcl_snapshot {"hash":"46701ae6edefd1500607cff5c8930e7a17439018","type":"TRIGGER","name":"TR_BDE_PD_SCHICHT_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}