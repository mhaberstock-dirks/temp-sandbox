
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_REP_GRID_COLUMNS_CFG_BIU" 
  before insert or update on rep_grid_columns_cfg
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
ALTER TRIGGER "TR_REP_GRID_COLUMNS_CFG_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"bfd0bfe6d24d98a90cbd0173118dda40c794b53c","type":"TRIGGER","name":"TR_REP_GRID_COLUMNS_CFG_BIU","schemaName":"DIRKSPZM32","sxml":""}