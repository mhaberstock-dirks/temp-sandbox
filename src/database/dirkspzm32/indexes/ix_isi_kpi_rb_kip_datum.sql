create index dirkspzm32.ix_isi_kpi_rb_kip_datum on
    dirkspzm32.isi_kpi_ring_buffer (
        kpi_name,
        wert_datum,
        kpi_sel_param
    );


-- sqlcl_snapshot {"hash":"93733b508173309204570012c0ff7c58c49bcdde","type":"INDEX","name":"IX_ISI_KPI_RB_KIP_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_KPI_RB_KIP_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KPI_RING_BUFFER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KPI_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>WERT_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KPI_SEL_PARAM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}