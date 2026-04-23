create table dirkspzm32.isi_purch_lief_plan_abr_kal (
    lief_plan_abr_kal_id varchar2(32 char) default sys_guid() not null enable,
    lief_plan_abruf_id   varchar2(32 char) not null enable,
    lief_periode         varchar2(5 char) not null enable,
    lief_datum           date not null enable,
    lief_menge           number(*, 3) not null enable
);

alter table dirkspzm32.isi_purch_lief_plan_abr_kal
    add constraint chk_lief_plan_abr_kal_1
        check ( lief_periode in ( 'T', 'W', 'M' ) ) enable;

alter table dirkspzm32.isi_purch_lief_plan_abr_kal
    add constraint pk_lief_plan_abr_kal primary key ( lief_plan_abr_kal_id )
        using index enable;


-- sqlcl_snapshot {"hash":"382d7030e0f92a4e45dce6cf038cd3fd40769148","type":"TABLE","name":"ISI_PURCH_LIEF_PLAN_ABR_KAL","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_PURCH_LIEF_PLAN_ABR_KAL</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LIEF_PLAN_ABR_KAL_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>32</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>sys_guid()</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LIEF_PLAN_ABRUF_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>32</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LIEF_PERIODE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>5</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LIEF_DATUM</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LIEF_MENGE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>3</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_LIEF_PLAN_ABR_KAL_1</NAME>\n            <CONDITION>lief_periode in ('T', 'W', 'M')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_LIEF_PLAN_ABR_KAL</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>LIEF_PLAN_ABR_KAL_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}