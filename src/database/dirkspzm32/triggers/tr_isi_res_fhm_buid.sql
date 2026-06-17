
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RES_FHM_BUID" 
  before insert or delete on DIRKSPZM32.ISI_RES_FHM
  for each row
declare

  v_found                 boolean;
begin
  if inserting
  then
    NULL;
  else -- delete
    delete isi_res_fhm_list t
     where t.fhm = :old.fhm;
  end if;
  
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RES_FHM_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"ca9f92f89aa33bb7792b3770d7db9381531a4e09","type":"TRIGGER","name":"TR_ISI_RES_FHM_BUID","schemaName":"DIRKSPZM32","sxml":""}