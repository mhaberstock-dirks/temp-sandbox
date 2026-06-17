
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_PD_LAM_STL_DATEN_BIU" 
  before insert or update on DIRKSPZM32.bde_pd_lam_stl_daten
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    if :new.pd_lam_stl_daten_id is null
    then
      select seq_lam_stl_daten_id.nextval into :new.pd_lam_stl_daten_id from dual;
    end if;
  end if;
end tr_bde_pd_lam_stl_daten_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_PD_LAM_STL_DATEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"2c55a0c8b5845bac03c21718bdf8f5766913d3be","type":"TRIGGER","name":"TR_BDE_PD_LAM_STL_DATEN_BIU","schemaName":"DIRKSPZM32","sxml":""}