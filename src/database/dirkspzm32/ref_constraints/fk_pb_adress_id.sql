alter table dirkspzm32.pzm_produktionsbereiche
    add constraint fk_pb_adress_id
        foreign key ( pb_adress_id )
            references dirkspzm32.isi_adressen ( adress_id )
        disable;


-- sqlcl_snapshot {"hash":"7e8b10783dc1e163c6346e965a9f675815797baf","type":"REF_CONSTRAINT","name":"FK_PB_ADRESS_ID","schemaName":"DIRKSPZM32","sxml":""}