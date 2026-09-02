
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_BDE_PD_LAM_STL_DATEN_BIU" 
  before insert or update on bde_pd_lam_stl_daten
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
ALTER TRIGGER "TR_BDE_PD_LAM_STL_DATEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"08ccb3a42b900180235f0f27d3ae1d798e9b11c9","type":"TRIGGER","name":"TR_BDE_PD_LAM_STL_DATEN_BIU","schemaName":"DIRKSPZM32","sxml":""}