alter table dirkspzm32.pzm_abteilungen
    add constraint fk_abt_kst_id
        foreign key ( abt_kst_id )
            references dirkspzm32.isi_kostenstellen ( kst_nr )
        disable;


-- sqlcl_snapshot {"hash":"f5b1331a14ab037ca7b66c218f9e031e9d6c41ed","type":"REF_CONSTRAINT","name":"FK_ABT_KST_ID","schemaName":"DIRKSPZM32","sxml":""}