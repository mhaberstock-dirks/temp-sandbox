create table dirkspzm32.s_erp_rcv_pack_vorschr_gew (
    sid                  varchar2(2 char) not null enable,
    firma_nr             number(3, 0) not null enable,
    artikel              varchar2(30 char) not null enable,
    kunden_nr            varchar2(10 char) not null enable,
    gew_nr               number(*, 5),
    lhm_art_1            varchar2(20 char),
    lhm_gew_nom          number(*, 6),
    lhm_gew_max          number(*, 6),
    lhm_gew_min          number(*, 6),
    lhm_gew_abw_pal      number(*, 5),
    created_date         date not null enable,
    created_login_id     number(*, 0),
    last_change_date     date,
    last_change_login_id number(*, 0)
);

alter table dirkspzm32.s_erp_rcv_pack_vorschr_gew
    add constraint pk_s_erp_rcv_pack_vor_gew
        primary key ( artikel,
                      kunden_nr,
                      firma_nr,
                      sid )
            using index enable;


-- sqlcl_snapshot {"hash":"6ea6ed8adc5471447bd56dd3ab70a9fdb0fafa44","type":"TABLE","name":"S_ERP_RCV_PACK_VORSCHR_GEW","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>S_ERP_RCV_PACK_VORSCHR_GEW</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>3</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>30</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KUNDEN_NR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GEW_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ART_1</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_GEW_NOM</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>6</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_GEW_MAX</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>6</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_GEW_MIN</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>6</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_GEW_ABW_PAL</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CHANGE_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CHANGE_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_S_ERP_RCV_PACK_VOR_GEW</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>ARTIKEL</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>KUNDEN_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}