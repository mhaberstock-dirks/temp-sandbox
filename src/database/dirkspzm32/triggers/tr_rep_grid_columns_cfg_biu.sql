
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_REP_GRID_COLUMNS_CFG_BIU" 
  before insert or update on DIRKSPZM32.rep_grid_columns_cfg
  for each row
declare
  -- local variables here
begin
  if inserting
  or updating
  then
    if :new.field_name = 'SID'
    or :new.field_name = 'FIRMA_NR'
    then
      :new.def_val_sys_var := :new.field_name;
    end if;
  end if;

end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_REP_GRID_COLUMNS_CFG_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"a1adcd097b8f7a8fce4b8d0cd53293113c230392","type":"TRIGGER","name":"TR_REP_GRID_COLUMNS_CFG_BIU","schemaName":"DIRKSPZM32","sxml":""}