alter table dirkspzm32.isi_purch_pos
    add constraint fk_purch_pos_lief_pl_kal
        foreign key ( lief_plan_abr_kal_id )
            references dirkspzm32.isi_purch_lief_plan_abr_kal ( lief_plan_abr_kal_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"d02d625c5e33a8e16bb1fcf299570e9b653753e1","type":"REF_CONSTRAINT","name":"FK_PURCH_POS_LIEF_PL_KAL","schemaName":"DIRKSPZM32","sxml":""}