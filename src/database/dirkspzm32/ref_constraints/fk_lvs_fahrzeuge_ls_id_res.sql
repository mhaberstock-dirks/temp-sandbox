alter table dirkspzm32.lvs_fahrzeuge_ls_id
    add constraint fk_lvs_fahrzeuge_ls_id_res
        foreign key ( res_id )
            references dirkspzm32.lvs_fahrzeuge ( res_id )
        enable;


-- sqlcl_snapshot {"hash":"8115337ae66e13f494ee7c091eae0935943abfd5","type":"REF_CONSTRAINT","name":"FK_LVS_FAHRZEUGE_LS_ID_RES","schemaName":"DIRKSPZM32","sxml":""}