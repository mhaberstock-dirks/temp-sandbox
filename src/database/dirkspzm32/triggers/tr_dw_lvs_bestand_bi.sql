
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_DW_LVS_BESTAND_BI" 
  before insert or update on DIRKSPZM32.dw_lvs_bestand
  for each row
declare
  -- local variables here
begin
  if INSERTING then
    if :new.dw_stat_id is NULL
    or :new.dw_stat_id = 0 then
      select SEQ_DW_LVS_BESTAND.nextval into :new.dw_stat_id from dual;
    end if;

    if :new.erfasst_am is NULL then
      select sysdate into :new.erfasst_am from dual;
    end if;
  end if;

end TR_Dw_LVS_BESTAND_BI;

/
ALTER TRIGGER "DIRKSPZM32"."TR_DW_LVS_BESTAND_BI" ENABLE;


-- sqlcl_snapshot {"hash":"68ff2571bf411f6f869156b469fd7bb761ef5064","type":"TRIGGER","name":"TR_DW_LVS_BESTAND_BI","schemaName":"DIRKSPZM32","sxml":""}