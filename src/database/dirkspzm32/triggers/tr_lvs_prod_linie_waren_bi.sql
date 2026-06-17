
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_PROD_LINIE_WAREN_BI" 
  before insert on DIRKSPZM32.lvs_prod_linie_waren
  for each row
declare
  -- local variables here
begin
  if :new.waren_nr is null
  then
    select nvl(max(waren_nr), 0) + 1
      into :new.waren_nr
      from lvs_prod_linie_waren
     where sid = :new.sid
       and firma_nr = :new.firma_nr
       and linie_nr = :new.linie_nr;
  end if;
end tr_lvs_prod_linie_waren_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_PROD_LINIE_WAREN_BI" ENABLE;


-- sqlcl_snapshot {"hash":"e9893fdc65db1926463ae7e3544d77eaab8ade46","type":"TRIGGER","name":"TR_LVS_PROD_LINIE_WAREN_BI","schemaName":"DIRKSPZM32","sxml":""}