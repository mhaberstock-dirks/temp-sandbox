
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_LVS_LGR_AIUD" 
  after insert or update on LVS_LGR
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
ALTER TRIGGER "TR_LVS_LGR_AIUD" ENABLE;


-- sqlcl_snapshot {"hash":"337671bec68822225a950b78fda271c5ec69ed6a","type":"TRIGGER","name":"TR_LVS_LGR_AIUD","schemaName":"DIRKSPZM32","sxml":""}