create or replace editionable trigger dirkspzm32.tr_mfr_transp_log_bi before
    insert on dirkspzm32.mfr_transp_log
    for each row
declare
  -- local variables here
 begin
    :new.log_date := sysdate;
end tr_meldung_daten_biu;
/

alter trigger dirkspzm32.tr_mfr_transp_log_bi enable;


-- sqlcl_snapshot {"hash":"be7870c21f3b82c7ef92dbd990711bcb04118722","type":"TRIGGER","name":"TR_MFR_TRANSP_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}