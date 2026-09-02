
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_PURCH_KOPF_BI" 
  before insert on isi_purch_kopf
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
ALTER TRIGGER "TR_ISI_PURCH_KOPF_BI" ENABLE;


-- sqlcl_snapshot {"hash":"443defa2fe6b978ee28ea1e7a2b0b86021d54016","type":"TRIGGER","name":"TR_ISI_PURCH_KOPF_BI","schemaName":"DIRKSPZM32","sxml":""}