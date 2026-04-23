create or replace editionable trigger dirkspzm32.tr_isi_rave_projekte_cfg before
    insert on dirkspzm32.isi_rave_projekte_cfg
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

end tr_isi_rave_projekte_cfg;
/

alter trigger dirkspzm32.tr_isi_rave_projekte_cfg enable;


-- sqlcl_snapshot {"hash":"b3f5645f42048c0560837f82fbe632d703ba82fb","type":"TRIGGER","name":"TR_ISI_RAVE_PROJEKTE_CFG","schemaName":"DIRKSPZM32","sxml":""}