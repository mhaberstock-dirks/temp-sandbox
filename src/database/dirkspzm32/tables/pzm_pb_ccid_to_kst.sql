
  CREATE TABLE "DIRKSPZM32"."PZM_PB_CCID_TO_KST" 
   (	"PB_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"PZM_CC_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"PZM_KST" NUMBER(6,0) NOT NULL ENABLE
   ) ;
ALTER TABLE "DIRKSPZM32"."PZM_PB_CCID_TO_KST" ADD CONSTRAINT "PZM_PB_CCID_TO_KST" PRIMARY KEY ("PB_ID", "PZM_CC_ID")
  USING INDEX  ENABLE;


-- sqlcl_snapshot {"hash":"33830123704147ad6d26b3845f1f4686c37f1271","type":"TABLE","name":"PZM_PB_CCID_TO_KST","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PZM_PB_CCID_TO_KST</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PB_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PZM_CC_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PZM_KST</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PZM_PB_CCID_TO_KST</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>PB_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>PZM_CC_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}