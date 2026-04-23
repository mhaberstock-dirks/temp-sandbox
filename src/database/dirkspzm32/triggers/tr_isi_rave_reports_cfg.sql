create or replace editionable trigger dirkspzm32.tr_isi_rave_reports_cfg before
    insert on dirkspzm32.isi_rave_reports_cfg
    for each row
declare
  -- local variables here
 begin
    if :new.sid is null then
        :new.sid := '01';
    end if;

    if :new.firma_nr is null then
        :new.firma_nr := 1;
    end if;

end tr_isi_rave_reports_cfg;
/

alter trigger dirkspzm32.tr_isi_rave_reports_cfg enable;


-- sqlcl_snapshot {"hash":"6f242d7ce86990d8b39b066ea96682f096ea32d4","type":"TRIGGER","name":"TR_ISI_RAVE_REPORTS_CFG","schemaName":"DIRKSPZM32","sxml":""}