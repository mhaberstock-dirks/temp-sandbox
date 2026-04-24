create index dirkspzm32.ix_aps_order_mat_rel_typ_auftr on
    dirkspzm32.aps_order_materialrelation (
        materialrelation_type,
        auftrag_nr,
        pos_nr,
        upos_nr,
        aps_plan_status
    );


-- sqlcl_snapshot {"hash":"0af666f7fe9fa489190b746f3602ad99fa62857f","type":"INDEX","name":"IX_APS_ORDER_MAT_REL_TYP_AUFTR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_MAT_REL_TYP_AUFTR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_MATERIALRELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MATERIALRELATION_TYPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AUFTRAG_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPOS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}