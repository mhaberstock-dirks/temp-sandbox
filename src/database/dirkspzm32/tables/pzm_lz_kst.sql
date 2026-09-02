
  CREATE TABLE "PZM_LZ_KST" 
   (	"LZKST_LZ_ID" NUMBER(6,0) NOT NULL ENABLE, 
	"LZKST_ABT_KST" NUMBER(6,0) NOT NULL ENABLE, 
	"LZKST_GUELTIG" NUMBER(1,0) DEFAULT 1 NOT NULL ENABLE
   ) ;
  CREATE UNIQUE INDEX "PZM_LZ_KST" ON "PZM_LZ_KST" ("LZKST_LZ_ID", "LZKST_ABT_KST") 
  ;
ALTER TABLE "PZM_LZ_KST" ADD CONSTRAINT "PZM_LZ_KST" PRIMARY KEY ("LZKST_LZ_ID", "LZKST_ABT_KST")
  USING INDEX "PZM_LZ_KST"  ENABLE;


-- sqlcl_snapshot {"hash":"3041734bcfe313e51a020420b01f58ff66b9a1d6","type":"TABLE","name":"PZM_LZ_KST","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PZM_LZ_KST</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LZKST_LZ_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LZKST_ABT_KST</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LZKST_GUELTIG</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>1</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PZM_LZ_KST</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>LZKST_LZ_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>LZKST_ABT_KST</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}