alter table dirkspzm32.pps_prioritaetskurve
    add constraint "FK_PPS_PRIORITÄTEN"
        foreign key ( prio_id )
            references dirkspzm32.pps_prioritaeten ( prio_id )
        enable;


-- sqlcl_snapshot {"hash":"7d51e1d43e72f6573381444838081e291e0ec31d","type":"REF_CONSTRAINT","name":"FK_PPS_PRIORITÄTEN","schemaName":"DIRKSPZM32","sxml":""}