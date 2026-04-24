create or replace editionable trigger dirkspzm32.tr_isi_artikel_ctrl_bi before
    insert on dirkspzm32.isi_artikel_ctrl
    for each row
declare
  -- local variables here
 begin
    if :new.isi_artikel_ctrl_id is null then
        select
            seq_isi_artikel_ctrl.nextval
        into :new.isi_artikel_ctrl_id
        from
            dual;

    end if;
end tr_isi_artikel_ctrl_bi;
/

alter trigger dirkspzm32.tr_isi_artikel_ctrl_bi enable;


-- sqlcl_snapshot {"hash":"570e6b3d9fef1f663a595cfddf734073bf3c382d","type":"TRIGGER","name":"TR_ISI_ARTIKEL_CTRL_BI","schemaName":"DIRKSPZM32","sxml":""}