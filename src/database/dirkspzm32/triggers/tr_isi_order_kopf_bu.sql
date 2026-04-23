create or replace editionable trigger dirkspzm32.tr_isi_order_kopf_bu before
    update on dirkspzm32.isi_order_kopf
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
 begin
    null; -- Dieser Trigger kann geloescht werden. (Please delete)
end tr_isi_order_kopf_bu;
/

alter trigger dirkspzm32.tr_isi_order_kopf_bu enable;


-- sqlcl_snapshot {"hash":"3f956058ec887d856a03ef3899b2d3dcf23a225f","type":"TRIGGER","name":"TR_ISI_ORDER_KOPF_BU","schemaName":"DIRKSPZM32","sxml":""}