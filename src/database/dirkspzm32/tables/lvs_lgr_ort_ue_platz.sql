create table dirkspzm32.lvs_lgr_ort_ue_platz (
    sid            varchar2(2 char) not null enable,
    firma_nr       number(2, 0) not null enable,
    lgr_ort_quelle number(5, 0) not null enable,
    lgr_ort_ziel   number(5, 0) not null enable,
    lgr_platz      varchar2(30 char),
    lte_name       varchar2(22 char),
    lte_name_ziel  varchar2(22 char)
);

alter table dirkspzm32.lvs_lgr_ort_ue_platz
    add constraint pk_lvs_lgr_ort_ue_platz
        primary key ( lgr_ort_quelle,
                      lgr_ort_ziel,
                      firma_nr,
                      sid )
            using index enable;


-- sqlcl_snapshot {"hash":"18777360aa584549bed470af7bba820237be7ed5","type":"TABLE","name":"LVS_LGR_ORT_UE_PLATZ","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>LVS_LGR_ORT_UE_PLATZ</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>2</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_QUELLE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>5</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_ZIEL</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>5</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>30</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>22</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_NAME_ZIEL</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>22</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_LVS_LGR_ORT_UE_PLATZ</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>LGR_ORT_QUELLE</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>LGR_ORT_ZIEL</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}