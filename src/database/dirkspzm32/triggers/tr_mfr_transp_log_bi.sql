
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_MFR_TRANSP_LOG_BI" 
  before insert on mfr_transp_log
  for each row
declare
  -- local variables here
begin
  :new.log_date := sysdate;
end tr_meldung_daten_biu;


/
ALTER TRIGGER "TR_MFR_TRANSP_LOG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"0a879dd8c0f5abea82d925be9895970f03efe7e5","type":"TRIGGER","name":"TR_MFR_TRANSP_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}