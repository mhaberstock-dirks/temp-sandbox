alter table dirkspzm32.isi_purch_pos
    add constraint fk_purch_pos_parent_pos
        foreign key ( kopf_id,
                      parent_pos )
            references dirkspzm32.isi_purch_pos ( kopf_id,
                                                  pos )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"0ac1d925b2132883bff7688a7b97f321f08dd9f7","type":"REF_CONSTRAINT","name":"FK_PURCH_POS_PARENT_POS","schemaName":"DIRKSPZM32","sxml":""}