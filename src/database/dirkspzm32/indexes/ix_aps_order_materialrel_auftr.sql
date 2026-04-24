create index dirkspzm32.ix_aps_order_materialrel_auftr on
    dirkspzm32.aps_order_materialrelation (
        auftrag_nr,
        pos_nr,
        upos_nr,
        aps_plan_status
    );


-- sqlcl_snapshot {"hash":"acd494e7f987841c0c7914f7d2f755e22ff34e49","type":"INDEX","name":"IX_APS_ORDER_MATERIALREL_AUFTR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_MATERIALREL_AUFTR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_MATERIALRELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUFTRAG_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPOS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}