alter table dirkspzm32.isi_komm_wege_zeit
    add constraint fk_isi_komm_wege_zeit_lagerort
        foreign key ( lgr_ort_quelle )
            references dirkspzm32.lvs_lgr_ort ( lgr_ort )
        enable;


-- sqlcl_snapshot {"hash":"a11eb4c149ade845c64e07839ffc527018984221","type":"REF_CONSTRAINT","name":"FK_ISI_KOMM_WEGE_ZEIT_LAGERORT","schemaName":"DIRKSPZM32","sxml":""}