
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_MFR_TRANSP_LOG_BI" 
  before insert on DIRKSPZM32.mfr_transp_log
  for each row
declare
  -- local variables here
begin
  :new.log_date := sysdate;
end tr_meldung_daten_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_MFR_TRANSP_LOG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"ef3fb7db2290e741e6de35e9b4fc850943dad7d0","type":"TRIGGER","name":"TR_MFR_TRANSP_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}