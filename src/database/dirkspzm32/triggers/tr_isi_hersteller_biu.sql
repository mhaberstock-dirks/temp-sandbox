create or replace editionable trigger dirkspzm32.tr_isi_hersteller_biu before
    insert or update on dirkspzm32.isi_hersteller
    for each row
declare
  -- local variables here
 begin
    if :new.erstell_datum is null then
        :new.erstell_datum := sysdate;
    end if;

    if updating then
        :new.bearb_datum := sysdate;
    end if;
end;
/

alter trigger dirkspzm32.tr_isi_hersteller_biu enable;


-- sqlcl_snapshot {"hash":"dd48f94722afd594eb66dfe2ecad06f1fafbc069","type":"TRIGGER","name":"TR_ISI_HERSTELLER_BIU","schemaName":"DIRKSPZM32","sxml":""}