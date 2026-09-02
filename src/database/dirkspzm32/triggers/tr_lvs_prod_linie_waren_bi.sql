
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_LVS_PROD_LINIE_WAREN_BI" 
  before insert on lvs_prod_linie_waren
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
ALTER TRIGGER "TR_LVS_PROD_LINIE_WAREN_BI" ENABLE;


-- sqlcl_snapshot {"hash":"01f68f16684a260c94484604752ff70d51138ab7","type":"TRIGGER","name":"TR_LVS_PROD_LINIE_WAREN_BI","schemaName":"DIRKSPZM32","sxml":""}