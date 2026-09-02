
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RES_FHM_BUID" 
  before insert or delete on ISI_RES_FHM
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
ALTER TRIGGER "TR_ISI_RES_FHM_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"4db03d12dafeeba815097a30d51efa6a8becadb2","type":"TRIGGER","name":"TR_ISI_RES_FHM_BUID","schemaName":"DIRKSPZM32","sxml":""}