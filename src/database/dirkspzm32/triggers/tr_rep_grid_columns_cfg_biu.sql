create or replace editionable trigger dirkspzm32.tr_rep_grid_columns_cfg_biu before
    insert or update on dirkspzm32.rep_grid_columns_cfg
    for each row
declare
  -- local variables here
 begin
    if inserting
    or updating then
        if :new.field_name = 'SID'
        or :new.field_name = 'FIRMA_NR' then
            :new.def_val_sys_var := :new.field_name;
        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_rep_grid_columns_cfg_biu enable;


-- sqlcl_snapshot {"hash":"73c627edb1a21737e2f24902491947405dfeb80a","type":"TRIGGER","name":"TR_REP_GRID_COLUMNS_CFG_BIU","schemaName":"DIRKSPZM32","sxml":""}