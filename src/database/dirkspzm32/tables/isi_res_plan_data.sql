create table dirkspzm32.isi_res_plan_data (
    sid                       varchar2(2 char) not null enable,
    firma_nr                  number(6, 0) not null enable,
    res_id                    number(*, 0) not null enable,
    created_date              date not null enable,
    created_login_id          number(*, 0),
    last_change_date          date,
    last_change_login_id      number(*, 0),
    max_auslastung            number(*, 5) default 100 not null enable,
    prozess                   number(1, 0) default 0 not null enable,
    arbeitszeitmodellnr       varchar2(50 char),
    kap_typ                   number(6, 0) default 2 not null enable,
    belegungs_typ             number(1, 0) default 1,
    parallelbelegungs_typ     number(2, 0) default 0,
    max_belegung              number(*, 6) default 100,
    mehrschicht               number(1, 0) default 1,
    personalbedarf            number(*, 0) default 0,
    personalplanung           number(1, 0) default 0,
    ruest_typ                 number(1, 0) default 0,
    ruestzeit_statisch        number(*, 12) default 0,
    ruest_matrix_id           varchar2(20 char),
    ruestoptimierungs_typ     number(1, 0) default 0,
    stillstandskostenzeitraum number(*, 12) default 0,
    sm_name                   varchar2(100 char) default '24Std',
    max_transporte            number(*, 0) default 1 not null enable,
    fa_reichweite_zeit        number(*, 0) default 480,
    fa_reichweite_mg          number(*, 0)
);

alter table dirkspzm32.isi_res_plan_data
    add constraint chk_isi_res_plan_data_bel_typ
        check ( belegungs_typ in ( 1, 2 ) ) enable;

alter table dirkspzm32.isi_res_plan_data
    add constraint chk_isi_res_plan_data_kap_typ
        check ( kap_typ in ( 1, 2, 5, 6 ) ) enable;

alter table dirkspzm32.isi_res_plan_data
    add constraint chk_isi_res_plan_data_mehrsch
        check ( mehrschicht in ( 0, 1 ) ) enable;

alter table dirkspzm32.isi_res_plan_data
    add constraint chk_isi_res_plan_data_pers_p
        check ( personalplanung in ( 0, 1 ) ) enable;

alter table dirkspzm32.isi_res_plan_data
    add constraint chk_isi_res_plan_data_prozess
        check ( prozess in ( 0, 1 ) ) enable;

alter table dirkspzm32.isi_res_plan_data
    add constraint chk_isi_res_plan_data_p_b_typ
        check ( parallelbelegungs_typ in ( 0, 1, 2, 4, 16,
                                           32 ) ) enable;

alter table dirkspzm32.isi_res_plan_data
    add constraint chk_isi_res_plan_data_r_o_t
        check ( ruestoptimierungs_typ in ( 0, 1, 2 ) ) enable;

alter table dirkspzm32.isi_res_plan_data
    add constraint chk_isi_res_plan_data_r_typ
        check ( ruest_typ in ( 0, 2, 4 ) ) enable;

alter table dirkspzm32.isi_res_plan_data
    add constraint pk_isi_res_plan_data
        primary key ( res_id,
                      firma_nr,
                      sid )
            using index enable;


-- sqlcl_snapshot {"hash":"c541c32a986fcf616f05c54eedfb4d2069077de0","type":"TABLE","name":"ISI_RES_PLAN_DATA","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_RES_PLAN_DATA</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CHANGE_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CHANGE_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MAX_AUSLASTUNG</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <DEFAULT>100</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROZESS</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>1</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>0</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARBEITSZEITMODELLNR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KAP_TYP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>2</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BELEGUNGS_TYP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>1</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>1</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PARALLELBELEGUNGS_TYP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>2</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MAX_BELEGUNG</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>6</SCALE>\n            <DEFAULT>100</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MEHRSCHICHT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>1</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>1</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERSONALBEDARF</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERSONALPLANUNG</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>1</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RUEST_TYP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>1</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RUESTZEIT_STATISCH</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RUEST_MATRIX_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RUESTOPTIMIERUNGS_TYP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>1</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STILLSTANDSKOSTENZEITRAUM</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SM_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'24Std'</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MAX_TRANSPORTE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_REICHWEITE_ZEIT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>480</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_REICHWEITE_MG</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ISI_RES_PLAN_DATA_BEL_TYP</NAME>\n            <CONDITION>BELEGUNGS_TYP in (1, 2)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ISI_RES_PLAN_DATA_KAP_TYP</NAME>\n            <CONDITION>KAP_TYP in (1, 2, 5, 6)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ISI_RES_PLAN_DATA_MEHRSCH</NAME>\n            <CONDITION>MEHRSCHICHT in (0, 1)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ISI_RES_PLAN_DATA_P_B_TYP</NAME>\n            <CONDITION>PARALLELBELEGUNGS_TYP in (0, 1, 2, 4, 16, 32)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ISI_RES_PLAN_DATA_PERS_P</NAME>\n            <CONDITION>PERSONALPLANUNG in (0, 1)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ISI_RES_PLAN_DATA_PROZESS</NAME>\n            <CONDITION>PROZESS in (0, 1)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ISI_RES_PLAN_DATA_R_O_T</NAME>\n            <CONDITION>RUESTOPTIMIERUNGS_TYP in (0,1,2)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ISI_RES_PLAN_DATA_R_TYP</NAME>\n            <CONDITION>RUEST_TYP in (0, 2, 4)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_ISI_RES_PLAN_DATA</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>RES_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}