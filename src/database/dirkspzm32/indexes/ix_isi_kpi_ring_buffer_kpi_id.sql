create index dirkspzm32.ix_isi_kpi_ring_buffer_kpi_id on
    dirkspzm32.isi_kpi_ring_buffer (
        isi_kpi_id
    );


-- sqlcl_snapshot {"hash":"039a933ac1d14e9b426d6ccfe9741deccb682b46","type":"INDEX","name":"IX_ISI_KPI_RING_BUFFER_KPI_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_KPI_RING_BUFFER_KPI_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KPI_RING_BUFFER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ISI_KPI_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}