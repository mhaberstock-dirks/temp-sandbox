
  CREATE TABLE "DIRKSPZM32"."PZM_KST_PB" 
   (	"PZM_KST" NUMBER(6,0) NOT NULL ENABLE, 
	"PZM_KST_PB" NUMBER(*,0) NOT NULL ENABLE
   ) ;
ALTER TABLE "DIRKSPZM32"."PZM_KST_PB" ADD CONSTRAINT "PZM_KST_PB" PRIMARY KEY ("PZM_KST")
  USING INDEX  ENABLE;


-- sqlcl_snapshot {"hash":"4bc29ce24fcb52ff1ba0d5c52a58b0147ce684bd","type":"TABLE","name":"PZM_KST_PB","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PZM_KST_PB</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PZM_KST</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PZM_KST_PB</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PZM_KST_PB</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>PZM_KST</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}