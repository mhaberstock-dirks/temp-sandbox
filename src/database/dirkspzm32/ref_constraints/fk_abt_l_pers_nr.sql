alter table dirkspzm32.pzm_abt_leitung
    add constraint fk_abt_l_pers_nr
        foreign key ( abt_l_pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
                on delete cascade
        disable;


-- sqlcl_snapshot {"hash":"54f38566356a94ae3264ec2d6f96304cc2dea922","type":"REF_CONSTRAINT","name":"FK_ABT_L_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}