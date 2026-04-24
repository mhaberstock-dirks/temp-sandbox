create table dirkspzm32.isi_res_kosten (
    sid                  varchar2(2 char) not null enable,
    firma_nr             number(6, 0) not null enable,
    res_id               number(*, 0) not null enable,
    created_date         date not null enable,
    created_login_id     number(*, 0) default - 1,
    last_change_date     date,
    last_change_login_id number(*, 0),
    fertigen             number(*, 5) default 100,
    ruesten              number(*, 5) default 150,
    stillstand           number(*, 5) default 50,
    gilt_ab              date default to_date('01.01.2012', 'dd.mm.yyyy') not null enable
);

alter table dirkspzm32.isi_res_kosten
    add constraint pk_isi_res_kosten
        primary key ( res_id,
                      gilt_ab,
                      firma_nr,
                      sid )
            using index enable;


-- sqlcl_snapshot {"hash":"2bfd0068cf480dab1addb47818ad0e3000e6763d","type":"TABLE","name":"ISI_RES_KOSTEN","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_RES_KOSTEN</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>-1</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CHANGE_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CHANGE_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FERTIGEN</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <DEFAULT>100</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RUESTEN</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <DEFAULT>150</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STILLSTAND</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <DEFAULT>50</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GILT_AB</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>to_date('01.01.2012', 'dd.mm.yyyy')</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_ISI_RES_KOSTEN</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>RES_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>GILT_AB</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}