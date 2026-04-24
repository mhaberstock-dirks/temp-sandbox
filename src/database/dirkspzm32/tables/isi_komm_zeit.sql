create table dirkspzm32.isi_komm_zeit (
    sid                     varchar2(2 char) default '01' not null enable,
    firma_nr                number(6, 0) default 1 not null enable,
    bearb_res_id            number(*, 0) not null enable,
    quell_transport_einheit varchar2(10 char) not null enable,
    ziel_transport_einheit  varchar2(10 char) not null enable,
    komm_zeit_sec           number(*, 12) not null enable
);

alter table dirkspzm32.isi_komm_zeit
    add constraint check_isi_komm_zeit_qtyp
        check ( quell_transport_einheit in ( 'LTE', 'LHM', 'LTE_LHM', 'LTE_LTE' ) ) enable;

alter table dirkspzm32.isi_komm_zeit
    add constraint check_isi_komm_zeit_ztyp
        check ( ziel_transport_einheit in ( 'LTE', 'LHM', 'LTE_LHM', 'LTE_LTE' ) ) enable;

alter table dirkspzm32.isi_komm_zeit
    add constraint pk_komm_zeit
        primary key ( bearb_res_id,
                      quell_transport_einheit,
                      ziel_transport_einheit,
                      firma_nr,
                      sid )
            using index enable;


-- sqlcl_snapshot {"hash":"c323a50685334346fd3e0dc590891f6f585e0336","type":"TABLE","name":"ISI_KOMM_ZEIT","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_KOMM_ZEIT</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'01'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEARB_RES_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>QUELL_TRANSPORT_EINHEIT</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZIEL_TRANSPORT_EINHEIT</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_ZEIT_SEC</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_KOMM_ZEIT_QTYP</NAME>\n            <CONDITION>QUELL_TRANSPORT_EINHEIT in ('LTE', 'LHM', 'LTE_LHM', 'LTE_LTE')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_KOMM_ZEIT_ZTYP</NAME>\n            <CONDITION>ZIEL_TRANSPORT_EINHEIT in ('LTE', 'LHM', 'LTE_LHM', 'LTE_LTE')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_KOMM_ZEIT</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>BEARB_RES_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>QUELL_TRANSPORT_EINHEIT</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>ZIEL_TRANSPORT_EINHEIT</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}