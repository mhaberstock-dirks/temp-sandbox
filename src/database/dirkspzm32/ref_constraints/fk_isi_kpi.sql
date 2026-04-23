alter table dirkspzm32.isi_kpi
    add constraint fk_isi_kpi
        foreign key ( kpi_name,
                      firma_nr,
                      sid )
            references dirkspzm32.isi_kpi_cfg ( kpi_name,
                                                firma_nr,
                                                sid )
        enable;


-- sqlcl_snapshot {"hash":"09e7ac0f717a38f4c09b10405723f19ef8b12fb8","type":"REF_CONSTRAINT","name":"FK_ISI_KPI","schemaName":"DIRKSPZM32","sxml":""}