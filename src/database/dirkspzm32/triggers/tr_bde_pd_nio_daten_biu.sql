
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_PD_NIO_DATEN_BIU" 
  before insert or update on DIRKSPZM32.bde_pd_nio_daten
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    if :new.nio_daten_id is null
    then
      select seq_bde_pd_nio_daten.nextval into :new.nio_daten_id from dual;
    end if;
  end if;
end tr_bde_pd_lam_nio_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_PD_NIO_DATEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"6db9d5d3a82987571c8c348ca50caeaa9ce9d3ee","type":"TRIGGER","name":"TR_BDE_PD_NIO_DATEN_BIU","schemaName":"DIRKSPZM32","sxml":""}