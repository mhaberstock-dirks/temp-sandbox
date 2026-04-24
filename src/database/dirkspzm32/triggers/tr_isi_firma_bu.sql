create or replace editionable trigger dirkspzm32.tr_isi_firma_bu before
    update on dirkspzm32.isi_firma
    for each row
declare
  -- local variables here
 begin
    update isi_adressen a
    set
        a.sid = :new.sid,
        a.firma_nr = :new.firma_nr,
        a.adr_nr = :new.firma_nr
    where
        a.adress_id = :new.adress_id;

end tr_isi_firma_bu;
/

alter trigger dirkspzm32.tr_isi_firma_bu enable;


-- sqlcl_snapshot {"hash":"52edce7d6b13c437eb86e5e50be8afdd638ab4c3","type":"TRIGGER","name":"TR_ISI_FIRMA_BU","schemaName":"DIRKSPZM32","sxml":""}