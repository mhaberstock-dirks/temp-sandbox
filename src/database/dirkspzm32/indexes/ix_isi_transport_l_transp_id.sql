create index dirkspzm32.ix_isi_transport_l_transp_id on
    dirkspzm32.isi_transport_log (
        transp_id
    );


-- sqlcl_snapshot {"hash":"5e813705605cce4a6f14a7498f508ba3ec4ff2c7","type":"INDEX","name":"IX_ISI_TRANSPORT_L_TRANSP_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_L_TRANSP_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TRANSP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}