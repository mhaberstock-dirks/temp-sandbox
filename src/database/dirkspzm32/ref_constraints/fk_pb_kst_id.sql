alter table dirkspzm32.pzm_produktionsbereiche
    add constraint fk_pb_kst_id
        foreign key ( pb_kst_id )
            references dirkspzm32.isi_kostenstellen ( kst_nr )
        disable;


-- sqlcl_snapshot {"hash":"469098fd04a7eb2e5ed995fd85be2c4b434f1aa1","type":"REF_CONSTRAINT","name":"FK_PB_KST_ID","schemaName":"DIRKSPZM32","sxml":""}