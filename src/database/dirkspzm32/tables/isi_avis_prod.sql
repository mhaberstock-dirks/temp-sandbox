create table dirkspzm32.isi_avis_prod (
    lieferschein_nr  varchar2(8 char) not null enable,
    lieferschein_pos number(*, 5) not null enable,
    prod_nr          varchar2(10 char) not null enable,
    lieferanten_nr   varchar2(9 char) not null enable,
    slb_nr           varchar2(8 char) not null enable
);

alter table dirkspzm32.isi_avis_prod
    add constraint pk_isi_avis_prod
        primary key ( lieferanten_nr,
                      slb_nr,
                      lieferschein_nr,
                      lieferschein_pos,
                      prod_nr )
            using index enable;


-- sqlcl_snapshot {"hash":"002b6d5458386e14e2e6fe52d08a310d7ae1f8aa","type":"TABLE","name":"ISI_AVIS_PROD","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_AVIS_PROD</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LIEFERSCHEIN_NR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>8</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LIEFERSCHEIN_POS</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROD_NR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LIEFERANTEN_NR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>9</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SLB_NR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>8</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_ISI_AVIS_PROD</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>LIEFERANTEN_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SLB_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>LIEFERSCHEIN_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>LIEFERSCHEIN_POS</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>PROD_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}