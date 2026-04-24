create or replace editionable trigger dirkspzm32.tr_isi_arbeitsplatz_cfg_bi before
    insert on dirkspzm32.isi_arbeitsplatz_cfg
    for each row
declare
  -- local variables here
 begin
    if :new.app_cfg_id is null then
        select
            seq_isi_arbeitsplatz_cfg_id.nextval
        into :new.app_cfg_id
        from
            dual;

    end if;
end;
/

alter trigger dirkspzm32.tr_isi_arbeitsplatz_cfg_bi enable;


-- sqlcl_snapshot {"hash":"520bf4db276613f21379f3fe1103bdf6e7980a1c","type":"TRIGGER","name":"TR_ISI_ARBEITSPLATZ_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}