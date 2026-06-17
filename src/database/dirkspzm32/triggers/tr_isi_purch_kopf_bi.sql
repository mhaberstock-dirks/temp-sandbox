
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_PURCH_KOPF_BI" 
  before insert on DIRKSPZM32.isi_purch_kopf
  for each row
declare
  v_id        isi_purch_kopf.id%Type;
begin
  if inserting
  then
     if :new.id is null then
        select seq_isi_purch_kopf.nextval into v_id from dual;
        :new.id := v_id;
     end if;

     if :new.erz_datum is null
     then
       :new.erz_datum := sysdate;
       :new.aend_datum := sysdate;
     end if;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_PURCH_KOPF_BI" ENABLE;


-- sqlcl_snapshot {"hash":"c274e872f6c3e89069c1727c53d5e02864970115","type":"TRIGGER","name":"TR_ISI_PURCH_KOPF_BI","schemaName":"DIRKSPZM32","sxml":""}