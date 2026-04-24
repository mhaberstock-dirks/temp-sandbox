create index dirkspzm32.ix_lvs_inv_job_kopf_art_fa_ag on
    dirkspzm32.lvs_inventur_job_kopf (
        artikel_id,
        fa_ag,
        erstellt_datum
    );


-- sqlcl_snapshot {"hash":"5767fc1d37e82082e239670ddcb9c01e7691d300","type":"INDEX","name":"IX_LVS_INV_JOB_KOPF_ART_FA_AG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_INV_JOB_KOPF_ART_FA_AG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_INVENTUR_JOB_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERSTELLT_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}