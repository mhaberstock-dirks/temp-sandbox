
  CREATE TABLE "DIRKSPZM32"."PZM_ZE_TAGESSATZ" 
   (	"TS_PERS_NR" NUMBER(*,0) NOT NULL ENABLE, 
	"TS_DATUM" DATE NOT NULL ENABLE, 
	"TS_DAY_IST_START" DATE, 
	"TS_DAY_IST_ENDE" DATE, 
	"TS_DAY_WERT_START" DATE, 
	"TS_DAY_WERT_ENDE" DATE, 
	"TS_SA_KURZNAME" VARCHAR2(10 CHAR), 
	"TS_AA_ID" NUMBER(*,0), 
	"TS_DAY_KST_ID" NUMBER(*,0), 
	"TS_ABWESENHEIT" NUMBER(*,0), 
	"TS_DAY_ABW_STD" NUMBER(*,12), 
	"TS_DAY_ARB_STD" NUMBER(*,12), 
	"TS_DAY_UEB_STD" NUMBER(*,12), 
	"TS_DAY_KORR_STD" NUMBER(*,12), 
	"TS_UEB_OK_PERS_NR" NUMBER(*,0), 
	"TS_UEB_OK_DATUM" DATE, 
	"TS_UEB_STORNO_PERS_NR" NUMBER(*,0), 
	"TS_UEB_STORNO_DATUM" DATE, 
	"TS_ABSCHLUSS" NUMBER(*,0), 
	"TS_VERBUCHT_DATUM" DATE, 
	"TS_DAY_FLEX_STD" NUMBER(*,12), 
	"TS_DAY_ANW_STD" NUMBER(*,12), 
	"TS_DAY_PAUSE_STD" NUMBER(*,12), 
	"TS_DAY_ARB_STD_G_MIN" NUMBER(*,12), 
	"TS_DAY_PAUSE_BEZ_STD" NUMBER(*,12), 
	"TS_DAY_ABT_ID" NUMBER(*,0), 
	"TS_DAY_PB_ID" NUMBER(*,0), 
	"CREATED_DATE" DATE DEFAULT sysdate NOT NULL ENABLE, 
	"CREATED_LOGIN_ID" NUMBER(*,0) DEFAULT -1 NOT NULL ENABLE, 
	"LAST_CHANGE_DATE" DATE, 
	"LAST_CHANGE_LOGIN_ID" NUMBER(*,0)
   ) ;
ALTER TABLE "DIRKSPZM32"."PZM_ZE_TAGESSATZ" ADD CONSTRAINT "PK_PZM_ZE_TAGESSATZ" PRIMARY KEY ("TS_PERS_NR", "TS_DATUM")
  USING INDEX  ENABLE;


-- sqlcl_snapshot {"hash":"25140702431144c6d44a01660ea4762539d743bf","type":"TABLE","name":"PZM_ZE_TAGESSATZ","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PZM_ZE_TAGESSATZ</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TS_PERS_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DATUM</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_IST_START</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_IST_ENDE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_WERT_START</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_WERT_ENDE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_SA_KURZNAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_AA_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_KST_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_ABWESENHEIT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_ABW_STD</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_ARB_STD</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_UEB_STD</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_KORR_STD</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_UEB_OK_PERS_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_UEB_OK_DATUM</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_UEB_STORNO_PERS_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_UEB_STORNO_DATUM</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_ABSCHLUSS</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_VERBUCHT_DATUM</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_FLEX_STD</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_ANW_STD</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_PAUSE_STD</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_ARB_STD_G_MIN</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_PAUSE_BEZ_STD</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_ABT_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DAY_PB_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>sysdate</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>-1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CHANGE_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CHANGE_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_PZM_ZE_TAGESSATZ</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>TS_PERS_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>TS_DATUM</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}