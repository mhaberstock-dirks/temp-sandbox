create table dirkspzm32.aps_plan_status (
    sid              varchar2(2 char) default '01' not null enable,
    firma_nr         number(2, 0) default 1 not null enable,
    aps_status       varchar2(3 char),
    plan_status      varchar2(30 char),
    aps_mode         number(1, 0) default 1 not null enable,
    aps_interval_sec number(5, 0) default 600 not null enable,
    aps_command      varchar2(30 char),
    plan_ts_start    date default sysdate not null enable,
    plan_ts_end      date,
    info_debug       varchar2(4000 char),
    message_code     number(5, 0),
    message_text     varchar2(255 char),
    erz_datum        date default sysdate not null enable,
    erz_login_id     number(*, 0) default - 1 not null enable,
    aend_datum       date,
    aend_login_id    number(*, 0)
);

alter table dirkspzm32.aps_plan_status
    add constraint aps_command_chk
        check ( aps_command in ( 'StartAuto', 'StopAuto', 'Run', 'Abort', 'Reset' ) ) enable;

alter table dirkspzm32.aps_plan_status
    add constraint aps_status_chk
        check ( aps_status in ( 'PS', 'PE', 'PA', 'IMP', 'EXP',
                                'U', 'UE' ) ) enable;

alter table dirkspzm32.aps_plan_status
    add constraint pk_aps_plan_status primary key ( sid,
                                                    firma_nr )
        using index enable;

alter table dirkspzm32.aps_plan_status
    add constraint plan_status_chk
        check ( plan_status in ( 'Canceled', 'Created', 'Faulted', 'RanToCompletion', 'Running',
                                 'WaitingForActivation', 'WaitingForChildrenToComplete', 'WaitingToRun' ) ) enable;


-- sqlcl_snapshot {"hash":"866ead857eb4eb40049bd930e33ec5007145d83c","type":"TABLE","name":"APS_PLAN_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>APS_PLAN_STATUS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'01'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>2</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_STATUS</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>3</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PLAN_STATUS</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>30</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_MODE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>1</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_INTERVAL_SEC</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>5</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>600</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_COMMAND</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>30</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PLAN_TS_START</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>sysdate</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PLAN_TS_END</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INFO_DEBUG</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>4000</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MESSAGE_CODE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>5</PRECISION>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MESSAGE_TEXT</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERZ_DATUM</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>sysdate</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERZ_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>-1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AEND_DATUM</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AEND_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>APS_COMMAND_CHK</NAME>\n            <CONDITION>aps_command in ('StartAuto','StopAuto',\t'Run', \n'Abort', 'Reset')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>APS_STATUS_CHK</NAME>\n            <CONDITION>APS_STATUS in ('PS', 'PE', 'PA', 'IMP', 'EXP', 'U', 'UE')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>PLAN_STATUS_CHK</NAME>\n            <CONDITION>PLAN_STATUS in ('Canceled', 'Created', 'Faulted', 'RanToCompletion', 'Running', 'WaitingForActivation', 'WaitingForChildrenToComplete', 'WaitingToRun')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_APS_PLAN_STATUS</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}