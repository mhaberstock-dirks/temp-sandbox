create or replace editionable trigger dirkspzm32.tr_isi_mail_queue_bi before
    insert on dirkspzm32.isi_mail_queue
    for each row
declare begin
    if :new.mail_id is null then
        select
            seq_isi_mail_queue_id.nextval
        into :new.mail_id
        from
            dual;

    end if;
end tr_isi_mail_queue_bi;
/

alter trigger dirkspzm32.tr_isi_mail_queue_bi enable;


-- sqlcl_snapshot {"hash":"a4e15b91d068ecfa84ef87c2b7455a4d093ed47f","type":"TRIGGER","name":"TR_ISI_MAIL_QUEUE_BI","schemaName":"DIRKSPZM32","sxml":""}