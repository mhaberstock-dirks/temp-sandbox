create index dirkspzm32.ix_isi_transport_grp_grp on
    dirkspzm32.isi_transport_grp (
        lte_grp_id
    );


-- sqlcl_snapshot {"hash":"5f7853da0c314ec2bf2b2554c2c76ee2e3a2c1b5","type":"INDEX","name":"IX_ISI_TRANSPORT_GRP_GRP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_GRP_GRP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_GRP</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_GRP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}