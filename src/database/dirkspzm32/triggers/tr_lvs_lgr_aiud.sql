
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_LGR_AIUD" 
  after insert or update on DIRKSPZM32.LVS_LGR
  for each row
declare
begin
--  if INSERTING then
--    dbms_alert.SIGNAL('LVS_LGR_INSERT', to_char(:new.lgr_Platz));
--  elsif UPDATING then
--    dbms_alert.SIGNAL('LVS_LGR_UPDATE', to_char(:new.lgr_Platz));
--  end if;
NULL;
end Tr_lvs_lgr_AIUD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_LGR_AIUD" ENABLE;


-- sqlcl_snapshot {"hash":"0b4c7940a329e3c1bd7eae208f93f5fe84596fdd","type":"TRIGGER","name":"TR_LVS_LGR_AIUD","schemaName":"DIRKSPZM32","sxml":""}