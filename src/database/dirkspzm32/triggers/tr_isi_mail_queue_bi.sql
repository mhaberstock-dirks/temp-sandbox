
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_MAIL_QUEUE_BI" 
  before insert on "ISI_MAIL_QUEUE"
  for each row
declare
begin
  if :new.mail_id is NULL then
    select seq_isi_mail_queue_id.nextval into :new.mail_id from dual;
  end if;
end TR_ISI_mail_QUEUE_BI;


/
ALTER TRIGGER "TR_ISI_MAIL_QUEUE_BI" ENABLE;


-- sqlcl_snapshot {"hash":"39a5c3167162521030c3c4e145f1863df22ae06f","type":"TRIGGER","name":"TR_ISI_MAIL_QUEUE_BI","schemaName":"DIRKSPZM32","sxml":""}