
  CREATE UNIQUE INDEX "UIX_LVS_INVENTUR_JOB_POS" ON "LVS_INVENTUR_JOB_POS" ("INVENTUR_ID", "LGR_PLATZ", "LAM_ID") 
  ;


-- sqlcl_snapshot {"hash":"148acbe73e8fd35ab3f8e18f71c9026364ed923b","type":"INDEX","name":"UIX_LVS_INVENTUR_JOB_POS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UIX_LVS_INVENTUR_JOB_POS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_INVENTUR_JOB_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>INVENTUR_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}