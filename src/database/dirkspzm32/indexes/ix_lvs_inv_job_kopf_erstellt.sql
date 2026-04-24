create index dirkspzm32.ix_lvs_inv_job_kopf_erstellt on
    dirkspzm32.lvs_inventur_job_kopf (
        erstellt_datum
    );


-- sqlcl_snapshot {"hash":"a64e50847d8a177e9ddacf5ca94b12b327c26141","type":"INDEX","name":"IX_LVS_INV_JOB_KOPF_ERSTELLT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_INV_JOB_KOPF_ERSTELLT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_INVENTUR_JOB_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERSTELLT_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}