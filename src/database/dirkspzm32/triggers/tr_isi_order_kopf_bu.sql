
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_ORDER_KOPF_BU" 
  before update on isi_order_kopf
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------

begin
  NULL; -- Dieser Trigger kann geloescht werden. (Please delete)
end TR_ISI_ORDER_KOPF_BU;


/
ALTER TRIGGER "TR_ISI_ORDER_KOPF_BU" ENABLE;


-- sqlcl_snapshot {"hash":"7bf8771c8db57ce4623e2e14aefd796f1bb75ff9","type":"TRIGGER","name":"TR_ISI_ORDER_KOPF_BU","schemaName":"DIRKSPZM32","sxml":""}