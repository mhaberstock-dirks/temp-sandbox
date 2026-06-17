
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_MFR_SEND_OFFL_BIUD" 
  before insert or update or delete on DIRKSPZM32.s_mfr_send_offline
  for each row
declare
  -- local variables here
begin
  if inserting then
    select seq_s_send_bew_id.nextval into :new.offline_id from dual;
  elsif updating then
      NULL;

  elsif deleting then
      NULL;

  end if;


 if Deleting then
   begin
     insert into S_MFR_SEND_OFFLINE_HIST
          values (
                  :Old.FIRMA_NR,
                  :Old.OFFLINE_ID,
                  :Old.AUF_ID,
                  :Old.SATZART,
                  :Old.FUNKTION,
                  :Old.AUFTRAG,
                  :Old.LTE_ID,
                  :Old.GEN_DATUM,
                  :Old.QUELLE,
                  :Old.ZIEL,
                  :Old.TELEGRAMM,
                  :Old.GRUPPE);
   end;
 end if;

end TR_S_MFR_SEND_OFFL_BIUD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_MFR_SEND_OFFL_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"c755a31729147b44fba1ffeeb4a6c152e94ebddb","type":"TRIGGER","name":"TR_S_MFR_SEND_OFFL_BIUD","schemaName":"DIRKSPZM32","sxml":""}