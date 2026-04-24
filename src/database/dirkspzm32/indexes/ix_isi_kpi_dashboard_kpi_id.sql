create index dirkspzm32.ix_isi_kpi_dashboard_kpi_id on
    dirkspzm32.isi_kpi_dashboard (
        isi_kpi_id
    );


-- sqlcl_snapshot {"hash":"ee0f1692fec2574b2f7fad6920fe1de12b711379","type":"INDEX","name":"IX_ISI_KPI_DASHBOARD_KPI_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_KPI_DASHBOARD_KPI_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KPI_DASHBOARD</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ISI_KPI_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}