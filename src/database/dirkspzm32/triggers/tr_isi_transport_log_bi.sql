create or replace editionable trigger dirkspzm32.tr_isi_transport_log_bi before
    insert on dirkspzm32.isi_transport_log
    for each row
declare
  -- local variables here
 begin
    if :new.transp_log_id is null then
        select
            seq_transp_log_id.nextval
        into :new.transp_log_id
        from
            dual;

    end if;
end tr_isi_transport_log_bi;
/

alter trigger dirkspzm32.tr_isi_transport_log_bi enable;


-- sqlcl_snapshot {"hash":"739928539faaf91fe10f7fbd7128ddd653da0020","type":"TRIGGER","name":"TR_ISI_TRANSPORT_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}