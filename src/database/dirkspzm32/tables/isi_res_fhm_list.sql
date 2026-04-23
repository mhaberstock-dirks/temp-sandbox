create table dirkspzm32.isi_res_fhm_list (
    fhm             varchar2(25 char) not null enable,
    res_id          number(*, 0) not null enable,
    datum_von       date not null enable,
    datum_bis       date not null enable,
    prioritaet      number(*, 5) default 0 not null enable,
    ruestzeitfaktor number(*, 5) default 100 not null enable
);

alter table dirkspzm32.isi_res_fhm_list
    add constraint ix_isi_res_fhm_list
        unique ( res_id,
                 fhm,
                 datum_von )
            using index (
                create unique index dirkspzm32.pk_isi_res_fhm_list on
                    dirkspzm32.isi_res_fhm_list (
                        fhm,
                        res_id,
                        datum_von
                    )
            ) enable;

alter table dirkspzm32.isi_res_fhm_list
    add constraint pk_isi_res_fhm_list
        primary key ( fhm,
                      res_id,
                      datum_von )
            using index enable;


-- sqlcl_snapshot {"hash":"02b71c994e602bb58e096139461329b48753b833","type":"TABLE","name":"ISI_RES_FHM_LIST","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_RES_FHM_LIST</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FHM</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>25</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM_VON</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM_BIS</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PRIORITAET</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <DEFAULT>0</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RUESTZEITFAKTOR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <DEFAULT>100</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_ISI_RES_FHM_LIST</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>FHM</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>RES_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>DATUM_VON</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>IX_ISI_RES_FHM_LIST</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>RES_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FHM</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>DATUM_VON</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX>\n               <INDEX version=\"1.0\">\n                  <UNIQUE></UNIQUE>\n                  <SCHEMA>DIRKSPZM32</SCHEMA>\n                  <NAME>PK_ISI_RES_FHM_LIST</NAME>\n                  <TABLE_INDEX>\n                     <ON_TABLE>\n                        <SCHEMA>DIRKSPZM32</SCHEMA>\n                        <NAME>ISI_RES_FHM_LIST</NAME>\n                     </ON_TABLE>\n                     <COL_LIST>\n                        <COL_LIST_ITEM>\n                           <NAME>FHM</NAME>\n                        </COL_LIST_ITEM>\n                        <COL_LIST_ITEM>\n                           <NAME>RES_ID</NAME>\n                        </COL_LIST_ITEM>\n                        <COL_LIST_ITEM>\n                           <NAME>DATUM_VON</NAME>\n                        </COL_LIST_ITEM>\n                     </COL_LIST>\n                  </TABLE_INDEX>\n               </INDEX>\n            </USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}