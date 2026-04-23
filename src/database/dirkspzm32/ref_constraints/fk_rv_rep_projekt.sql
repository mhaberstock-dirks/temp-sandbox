alter table dirkspzm32.isi_rave_reports_cfg
    add constraint fk_rv_rep_projekt
        foreign key ( sid,
                      firma_nr,
                      kategorie,
                      rave_projekt )
            references dirkspzm32.isi_rave_projekte_cfg ( sid,
                                                          firma_nr,
                                                          kategorie,
                                                          rave_projekt )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"46b3ce3089ccddce3cabe8e5436dc6dfe7f76324","type":"REF_CONSTRAINT","name":"FK_RV_REP_PROJEKT","schemaName":"DIRKSPZM32","sxml":""}