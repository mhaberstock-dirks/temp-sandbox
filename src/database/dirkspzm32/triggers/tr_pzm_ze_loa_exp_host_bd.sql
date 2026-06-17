
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_EXP_HOST_BD" 
  before delete on DIRKSPZM32.PZM_ZE_LOA_EXP_HOST
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
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_EXP_HOST_BD" ENABLE;


-- sqlcl_snapshot {"hash":"9f5f84dc080cd80a98abc19bc671105ca9919169","type":"TRIGGER","name":"TR_PZM_ZE_LOA_EXP_HOST_BD","schemaName":"DIRKSPZM32","sxml":""}