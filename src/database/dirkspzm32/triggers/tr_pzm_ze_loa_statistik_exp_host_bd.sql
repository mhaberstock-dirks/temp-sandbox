
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BD" 
  before insert or update on DIRKSPZM32.PZM_ZE_LOA_STATISTIK_EXP_HOST
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
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BD" ENABLE;


-- sqlcl_snapshot {"hash":"3056218b00698ddd91907c42cd2b9ba2f4b19f4b","type":"TRIGGER","name":"TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BD","schemaName":"DIRKSPZM32","sxml":""}