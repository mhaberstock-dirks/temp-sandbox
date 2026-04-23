alter table dirkspzm32.pzm_zeiterfassung
    add constraint fk_ze_status
        foreign key ( ze_status )
            references dirkspzm32.pzm_ze_statusinfo ( stat_id )
        disable;


-- sqlcl_snapshot {"hash":"b062e6dfacdf44d95be6b0489bdc05bec46d3cd0","type":"REF_CONSTRAINT","name":"FK_ZE_STATUS","schemaName":"DIRKSPZM32","sxml":""}