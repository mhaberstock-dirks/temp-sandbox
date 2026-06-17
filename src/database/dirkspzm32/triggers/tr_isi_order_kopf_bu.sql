
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_KOPF_BU" 
  before update on DIRKSPZM32.isi_order_kopf
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------

begin
  NULL; -- Dieser Trigger kann geloescht werden. (Please delete)
end TR_ISI_ORDER_KOPF_BU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_KOPF_BU" ENABLE;


-- sqlcl_snapshot {"hash":"e9d6446cfe66302709bcbd7e3d19e83ecf18b401","type":"TRIGGER","name":"TR_ISI_ORDER_KOPF_BU","schemaName":"DIRKSPZM32","sxml":""}