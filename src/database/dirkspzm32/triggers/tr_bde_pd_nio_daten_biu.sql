
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_BDE_PD_NIO_DATEN_BIU" 
  before insert or update on bde_pd_nio_daten
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
ALTER TRIGGER "TR_BDE_PD_NIO_DATEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"5e0b85700ca6d88872f6585aae57589f45fceb99","type":"TRIGGER","name":"TR_BDE_PD_NIO_DATEN_BIU","schemaName":"DIRKSPZM32","sxml":""}