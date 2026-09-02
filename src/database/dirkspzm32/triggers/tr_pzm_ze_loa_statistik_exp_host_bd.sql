
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BD" 
  before insert or update on PZM_ZE_LOA_STATISTIK_EXP_HOST
  for each row
declare
  v_found                         boolean;

  v_vertragsart                   pzm_vertragsarten%rowtype;
  
  CURSOR c_vertragsart is
    select va.*
      from pzm_vertragsarten va,
           pzm_personal p
     where p.pers_nr = :old.pers_nr
       and p.pers_vertragsart = va.va_id;
begin

  OPEN c_vertragsart;
  FETCH c_vertragsart into v_vertragsart;
  v_found := c_vertragsart%FOUND;
  CLOSE c_vertragsart;
  
end;



/
ALTER TRIGGER "TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BD" ENABLE;


-- sqlcl_snapshot {"hash":"a6d44cd4c6e9babdc09ee739fa3008ab6a504bbc","type":"TRIGGER","name":"TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BD","schemaName":"DIRKSPZM32","sxml":""}