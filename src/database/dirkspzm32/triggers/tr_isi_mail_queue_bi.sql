
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_MAIL_QUEUE_BI" 
  before insert on DIRKSPZM32."ISI_MAIL_QUEUE"
  for each row
declare
begin
  if :new.mail_id is NULL then
    select seq_isi_mail_queue_id.nextval into :new.mail_id from dual;
  end if;
end TR_ISI_mail_QUEUE_BI;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_MAIL_QUEUE_BI" ENABLE;


-- sqlcl_snapshot {"hash":"830827b2ddee6d3b4991f6ac4c7e83449295f922","type":"TRIGGER","name":"TR_ISI_MAIL_QUEUE_BI","schemaName":"DIRKSPZM32","sxml":""}