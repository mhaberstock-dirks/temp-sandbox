create or replace editionable trigger dirkspzm32.tr_lz_id_seq before
    insert on dirkspzm32.pzm_lohnarten
    for each row
declare
  -- local variables here
 begin
    if :new.lz_id is null then
        select
            seq_lz_id.nextval
        into :new.lz_id
        from
            dual;

    end if;
end tr_lz_id_seq;
/

alter trigger dirkspzm32.tr_lz_id_seq enable;


-- sqlcl_snapshot {"hash":"892d5ebfbd096ea4bda4ee68ab1045c913050b76","type":"TRIGGER","name":"TR_LZ_ID_SEQ","schemaName":"DIRKSPZM32","sxml":""}