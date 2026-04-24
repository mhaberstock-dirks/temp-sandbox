create index dirkspzm32.ix_pps_plan_auftrag_ix3 on
    dirkspzm32.pps_plan_auftrag (
        artikel_id,
        zeichnung_index,
        zeichnung
    );


-- sqlcl_snapshot {"hash":"d892f0922af41ff281915cb53a70b9ff88e9bace","type":"INDEX","name":"IX_PPS_PLAN_AUFTRAG_IX3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_PLAN_AUFTRAG_IX3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_PLAN_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZEICHNUNG_INDEX</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZEICHNUNG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}