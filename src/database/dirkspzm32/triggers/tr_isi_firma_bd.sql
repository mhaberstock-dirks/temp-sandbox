create or replace editionable trigger dirkspzm32.tr_isi_firma_bd before
    delete on dirkspzm32.isi_firma
    for each row
declare
  -- local variables here
 begin
    delete isi_adressen
    where
        adress_id = :old.adress_id;

end tr_isi_firma_bd;
/

alter trigger dirkspzm32.tr_isi_firma_bd enable;


-- sqlcl_snapshot {"hash":"8f490bb3a24fa4b8b18286da95e5960adb883846","type":"TRIGGER","name":"TR_ISI_FIRMA_BD","schemaName":"DIRKSPZM32","sxml":""}