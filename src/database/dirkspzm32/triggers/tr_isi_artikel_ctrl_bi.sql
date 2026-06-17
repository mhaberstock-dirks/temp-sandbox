
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ARTIKEL_CTRL_BI" 
  before insert on DIRKSPZM32.isi_artikel_ctrl
  for each row
declare
  -- local variables here
begin
  if :new.isi_artikel_ctrl_id is null
  then
    select seq_isi_artikel_ctrl.nextval into :new.isi_artikel_ctrl_id from dual;
  end if;
end tr_isi_artikel_ctrl_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ARTIKEL_CTRL_BI" ENABLE;


-- sqlcl_snapshot {"hash":"dd4a77b037d06419a268523938b9fc09e07079be","type":"TRIGGER","name":"TR_ISI_ARTIKEL_CTRL_BI","schemaName":"DIRKSPZM32","sxml":""}