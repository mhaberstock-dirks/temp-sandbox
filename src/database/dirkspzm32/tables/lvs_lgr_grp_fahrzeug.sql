create table dirkspzm32.lvs_lgr_grp_fahrzeug (
    sid           varchar2(2 char) not null enable,
    firma_nr      number(2, 0) not null enable,
    res_id        number(*, 0) not null enable,
    lgr_gruppe_id number(*, 0) not null enable,
    lgr_ort       number(5, 0) not null enable
);

create unique index dirkspzm32.ix_lvs_lgr_grp_fahrzeug on
    dirkspzm32.lvs_lgr_grp_fahrzeug (
        res_id,
        lgr_ort,
        lgr_gruppe_id
    );

alter table dirkspzm32.lvs_lgr_grp_fahrzeug
    add constraint ix_lvs_lgr_grp_id
        unique ( lgr_gruppe_id,
                 lgr_ort,
                 res_id )
            using index dirkspzm32.ix_lvs_lgr_grp_fahrzeug enable;

alter table dirkspzm32.lvs_lgr_grp_fahrzeug
    add constraint pk_lvs_lgr_grp_fahrzeug
        primary key ( lgr_ort,
                      lgr_gruppe_id,
                      res_id,
                      firma_nr,
                      sid )
            using index enable;


-- sqlcl_snapshot {"hash":"bff101932c778d4ac7cb61dbb52e02c2f687f66d","type":"TABLE","name":"LVS_LGR_GRP_FAHRZEUG","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>LVS_LGR_GRP_FAHRZEUG</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>2</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_GRUPPE_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>5</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_LVS_LGR_GRP_FAHRZEUG</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>LGR_ORT</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>LGR_GRUPPE_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>RES_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>IX_LVS_LGR_GRP_ID</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>LGR_GRUPPE_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>LGR_ORT</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>RES_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}