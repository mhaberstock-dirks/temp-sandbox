create table dirkspzm32.pzm_vorgangsqualifikation_pers_bedarf (
    vorgangsqualifikation varchar2(50 char) not null enable,
    schicht_nr            number(*, 0) not null enable,
    sm_name               varchar2(100 char),
    schicht_von           date,
    schicht_bis           date,
    pers_bedarf_mo        number(*, 2),
    pers_bedarf_di        number(*, 2),
    pers_bedarf_mi        number(*, 2),
    pers_bedarf_do        number(*, 2),
    pers_bedarf_fr        number(*, 2),
    pers_bedarf_sa        number(*, 2),
    pers_bedarf_so        number(*, 2)
);

alter table dirkspzm32.pzm_vorgangsqualifikation_pers_bedarf
    add constraint pk_pzm_vorgangsqualifikation_pers_bedarf primary key ( vorgangsqualifikation,
                                                                          schicht_nr )
        using index enable;


-- sqlcl_snapshot {"hash":"70af8a796d955c0277fa57fb2f8d8725c22f42f2","type":"TABLE","name":"PZM_VORGANGSQUALIFIKATION_PERS_BEDARF","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PZM_VORGANGSQUALIFIKATION_PERS_BEDARF</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANGSQUALIFIKATION</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SCHICHT_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SM_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SCHICHT_VON</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SCHICHT_BIS</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_BEDARF_MO</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>2</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_BEDARF_DI</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>2</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_BEDARF_MI</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>2</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_BEDARF_DO</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>2</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_BEDARF_FR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>2</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_BEDARF_SA</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>2</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_BEDARF_SO</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>2</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_PZM_VORGANGSQUALIFIKATION_PERS_BEDARF</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>VORGANGSQUALIFIKATION</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SCHICHT_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}