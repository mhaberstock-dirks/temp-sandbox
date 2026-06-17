
  CREATE TABLE "DIRKSPZM32"."Z_PZM_PERS_NR_ALT_NEU" 
   (	"PERS_NR" NUMBER(*,0), 
	"PERS_NR_DATEV" NUMBER(*,0), 
	"PERS_NR_NEU" NUMBER(*,0)
   ) ;
ALTER TABLE "DIRKSPZM32"."Z_PZM_PERS_NR_ALT_NEU" ADD CONSTRAINT "U_Z_PZM_PERS_NR_ALT_NEU_PERS_NR" UNIQUE ("PERS_NR")
  USING INDEX  ENABLE;


-- sqlcl_snapshot {"hash":"e6e83ec64aeb0b4d8e310daa04188206a5505146","type":"TABLE","name":"Z_PZM_PERS_NR_ALT_NEU","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>Z_PZM_PERS_NR_ALT_NEU</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR_DATEV</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR_NEU</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>U_Z_PZM_PERS_NR_ALT_NEU_PERS_NR</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>PERS_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}