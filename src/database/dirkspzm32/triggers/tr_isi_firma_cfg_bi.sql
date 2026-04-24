create or replace editionable trigger dirkspzm32.tr_isi_firma_cfg_bi before
    insert on dirkspzm32.isi_firma_cfg
    for each row
declare
  -- local variables here
 begin
    if :new.firma_cfg_id is null then
        select
            seq_isi_firma_cfg_id.nextval
        into :new.firma_cfg_id
        from
            dual;

    end if;

    if :new.user_edit is null then
        :new.user_edit := 'F';
    end if;

end;
/

alter trigger dirkspzm32.tr_isi_firma_cfg_bi enable;


-- sqlcl_snapshot {"hash":"ed086fdd4c3bc5d0949e2e8ad99026c1eba5018b","type":"TRIGGER","name":"TR_ISI_FIRMA_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}