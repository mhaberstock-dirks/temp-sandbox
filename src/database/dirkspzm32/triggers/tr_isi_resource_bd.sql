
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RESOURCE_BD" 
  before delete on DIRKSPZM32.isi_resource
  for each row
declare
  -- local variables here
begin
  delete from isi_resource_zust_akt
   where sid = :old.sid
     and res_id = :old.res_id;
  delete from isi_resource_var
   where sid = :old.sid
     and res_id = :old.res_id;

end tr_isi_resource_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RESOURCE_BD" ENABLE;


-- sqlcl_snapshot {"hash":"1209096dd219054eec5d08538afe61e3124094f6","type":"TRIGGER","name":"TR_ISI_RESOURCE_BD","schemaName":"DIRKSPZM32","sxml":""}