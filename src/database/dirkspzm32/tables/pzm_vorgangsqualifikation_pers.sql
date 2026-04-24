create table dirkspzm32.pzm_vorgangsqualifikation_pers (
    pers_nr                    number(*, 0) not null enable,
    pers_vorgangsqualifikation varchar2(50 char) not null enable,
    "PERS_VORG_ANZ_EINSÄTZE"   number(*, 2)
);

alter table dirkspzm32.pzm_vorgangsqualifikation_pers
    add constraint pk_pers_vorgangsqual primary key ( pers_nr,
                                                      pers_vorgangsqualifikation )
        using index enable;


-- sqlcl_snapshot {"hash":"29c46ce27812900ea55919745dfefe77cb5d6466","type":"TABLE","name":"PZM_VORGANGSQUALIFIKATION_PERS","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PZM_VORGANGSQUALIFIKATION_PERS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_VORGANGSQUALIFIKATION</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_VORG_ANZ_EINS\u00c4TZE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>2</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_PERS_VORGANGSQUAL</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>PERS_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>PERS_VORGANGSQUALIFIKATION</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}