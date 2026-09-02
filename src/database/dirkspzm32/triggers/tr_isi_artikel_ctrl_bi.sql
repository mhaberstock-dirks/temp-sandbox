
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_ARTIKEL_CTRL_BI" 
  before insert on isi_artikel_ctrl
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
ALTER TRIGGER "TR_ISI_ARTIKEL_CTRL_BI" ENABLE;


-- sqlcl_snapshot {"hash":"6a8ee74ab9c1382d90fcdb609cbc47bd1fb91612","type":"TRIGGER","name":"TR_ISI_ARTIKEL_CTRL_BI","schemaName":"DIRKSPZM32","sxml":""}