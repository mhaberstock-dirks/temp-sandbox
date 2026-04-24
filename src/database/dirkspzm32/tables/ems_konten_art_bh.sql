create table dirkspzm32.ems_konten_art_bh (
    sid                  varchar2(2 char) default '01' not null enable,
    firma_nr             number default 1 not null enable,
    ems_konten_art_bh_id number(*, 0) not null enable,
    ems_beleg_nr         varchar2(20 char) not null enable,
    ems_konto_nr         number(*, 5) not null enable,
    ems_art_name         varchar2(20 char) not null enable,
    erz_login_id         number(*, 0) not null enable,
    erz_datum            date not null enable,
    aend_login_id        number(*, 0),
    aend_datum           date,
    entl_menge_brutto    number(*, 3),
    entl_menge_defekt    number(*, 3),
    entl_menge_netto     number(*, 3),
    bel_menge_netto      number(*, 3),
    summe_menge          number(*, 3),
    info                 varchar2(500 char),
    saldo_vortrag        number(*, 5),
    saldo                number(*, 5)
);

alter table dirkspzm32.ems_konten_art_bh
    add constraint pk_ems_konten_art_bh primary key ( ems_konten_art_bh_id )
        using index enable;

alter table dirkspzm32.ems_konten_art_bh
    add constraint uk_ems_konten_art_bh
        unique ( ems_beleg_nr,
                 ems_konto_nr,
                 ems_art_name )
            using index enable;


-- sqlcl_snapshot {"hash":"3488b200d6cdc818996d09f972e40cf4aa9e88fb","type":"TABLE","name":"EMS_KONTEN_ART_BH","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>EMS_KONTEN_ART_BH</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'01'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>EMS_KONTEN_ART_BH_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>EMS_BELEG_NR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>EMS_KONTO_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>EMS_ART_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERZ_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERZ_DATUM</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AEND_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AEND_DATUM</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ENTL_MENGE_BRUTTO</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>3</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ENTL_MENGE_DEFEKT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>3</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ENTL_MENGE_NETTO</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>3</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEL_MENGE_NETTO</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>3</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SUMME_MENGE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>3</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INFO</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>500</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SALDO_VORTRAG</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SALDO</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_EMS_KONTEN_ART_BH</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>EMS_KONTEN_ART_BH_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>UK_EMS_KONTEN_ART_BH</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>EMS_BELEG_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>EMS_KONTO_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>EMS_ART_NAME</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}