
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_ARTIKEL_LGR_INFO_BUID" 
  before insert or update or delete on DIRKSPZM32.lvs_artikel_lgr_info
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    if :new.lvs_art_lgr_info_id is null
    then
      select seq_lvs_artikel_lgr_info.nextval into :new.lvs_art_lgr_info_id from dual;
    end if;
  end if;
end tr_lvs_artikel_lgr_info_buid;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_ARTIKEL_LGR_INFO_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"a96d7556b04dac707e321fd3de0782d702267fb4","type":"TRIGGER","name":"TR_LVS_ARTIKEL_LGR_INFO_BUID","schemaName":"DIRKSPZM32","sxml":""}