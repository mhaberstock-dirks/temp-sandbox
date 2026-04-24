create index dirkspzm32.ix_isi_transport_grp_lte on
    dirkspzm32.isi_transport_grp (
        lte_id
    );


-- sqlcl_snapshot {"hash":"3c42f746d81a86bb12f4f769a57b3e5824d5c724","type":"INDEX","name":"IX_ISI_TRANSPORT_GRP_LTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_GRP_LTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_GRP</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}