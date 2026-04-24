create index dirkspzm32.ix_s_sqd_sap_send_bew_art_chg on
    dirkspzm32.s_sqd_sap_send_bew (
        artikel,
        charge,
        aktion
    );


-- sqlcl_snapshot {"hash":"3dc9907fbcbd3e320905076d28de6a2b34430c21","type":"INDEX","name":"IX_S_SQD_SAP_SEND_BEW_ART_CHG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_SQD_SAP_SEND_BEW_ART_CHG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SQD_SAP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHARGE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AKTION</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}