create table dirkspzm32.isi_firma (
    sid                  varchar2(2 char) not null enable,
    firma_nr             number(2, 0) not null enable,
    bezeichnung          varchar2(50 char) not null enable,
    info                 varchar2(255 char),
    adress_id            number(*, 0),
    lte_barcode_type     varchar2(10 char) default 'STD',
    lte_barcode_laenge   number(2, 0) default 15,
    lte_barcode_kopf     varchar2(20 char),
    lte_barcode_basis    varchar2(30 char) default 'SEQ',
    lte_etikett_roh      varchar2(50 char),
    lte_etikett_tf       varchar2(50 char),
    lte_etikett_fw       varchar2(50 char),
    lhm_barcode_type     varchar2(10 char) default 'STD',
    lhm_barcode_laenge   number(2, 0) default 15,
    lhm_barcode_kopf     varchar2(20 char),
    lhm_barcode_basis    varchar2(30 char) default 'SEQ',
    lhm_etikett_roh      varchar2(50 char),
    lhm_etikett_tf       varchar2(50 char),
    lhm_etikett_fw       varchar2(50 char),
    fw_res_artikel       char(1 byte) default 'F' not null enable,
    fw_res_charge        char(1 byte) default 'F' not null enable,
    fw_res_serie         char(1 byte) default 'F' not null enable,
    fw_res_fa_auftrag    char(1 byte) default 'F' not null enable,
    fw_res_kunde         char(1 byte) default 'F' not null enable,
    fw_res_mhd           char(1 byte) default 'F' not null enable,
    fw_res_mhd_tage      number default 1 not null enable,
    hw_res_artikel       char(1 byte) default 'F' not null enable,
    hw_res_charge        char(1 byte) default 'F' not null enable,
    hw_res_serie         char(1 byte) default 'F' not null enable,
    hw_res_fa_auftrag    char(1 byte) default 'F' not null enable,
    hw_res_kunde         char(1 byte) default 'F' not null enable,
    hw_res_mhd           varchar2(1 char) default 'F' not null enable,
    hw_res_mhd_tage      number(*, 5) default 1 not null enable,
    rw_res_artikel       char(1 byte) default 'F' not null enable,
    rw_res_charge        char(1 byte) default 'F' not null enable,
    rw_res_serie         char(1 byte) default 'F' not null enable,
    rw_res_fa_auftrag    char(1 byte) default 'F' not null enable,
    rw_res_lieferant     varchar2(1 char) default 'F' not null enable,
    rw_res_mhd           char(1 byte) default 'F' not null enable,
    rw_res_mhd_tage      number(*, 5) default 1 not null enable,
    mhd_berechnung       varchar2(2 char) default 'TA',
    ext_etiketten_druck  varchar2(1 char),
    bde_prod_2w          varchar2(1 char) default 'T' not null enable,
    bde_prod_schrott     varchar2(1 char) default 'T' not null enable,
    bde_ruest_2w         varchar2(1 char) default 'T' not null enable,
    bde_ruest_schrott    varchar2(1 char) default 'T' not null enable,
    default_lang_id      number(*, 0) default 1 not null enable,
    sep_nve_kopf         varchar2(20 char),
    anz_etikett_je_lte   number(*, 0),
    res_string_anbruch   varchar2(80 char),
    lte_etikett_anbruch  varchar2(50 char),
    proz_anbruch         number(*, 6) default 100 not null enable,
    labor_status_anbruch varchar2(20 char)
);

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_bde_prod_2w
        check ( bde_prod_2w in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_bde_pr_schrott
        check ( bde_prod_schrott in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_bde_ruest_schr
        check ( bde_ruest_schrott in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_fw_res_artikel
        check ( fw_res_artikel in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_fw_res_charge
        check ( fw_res_charge in ( 'T', 'F', 'H' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_fw_res_fa_auft
        check ( fw_res_fa_auftrag in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_fw_res_kunde
        check ( fw_res_kunde in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_fw_res_mhd
        check ( fw_res_mhd in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_fw_res_serie
        check ( fw_res_serie in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_hw_res_artikel
        check ( hw_res_artikel in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_hw_res_charge
        check ( hw_res_charge in ( 'T', 'F', 'H' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_hw_res_fa_auft
        check ( hw_res_fa_auftrag in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_hw_res_kunde
        check ( hw_res_kunde in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_hw_res_mhd
        check ( hw_res_fa_auftrag in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_hw_res_serie
        check ( hw_res_serie in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_lhm_barc_basis
        check ( lhm_barcode_basis in ( 'SEQ', 'LTE', 'LHM' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_lhm_barc_type
        check ( lhm_barcode_type in ( 'STD', 'VDA', 'SPEZ', 'CCG' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_lte_barc_basis
        check ( lte_barcode_basis in ( 'SEQ', 'LTE', 'LHM' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_lte_barc_type
        check ( lte_barcode_type in ( 'STD', 'VDA', 'SPEZ', 'CCG' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_mhd_berech
        check ( mhd_berechnung in ( 'TA', 'MA', 'ME', 'WA', 'WE',
                                    'YA', 'YE' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_rw_res_artikel
        check ( rw_res_artikel in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_rw_res_charge
        check ( rw_res_charge in ( 'T', 'F', 'H' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_rw_res_fa_auft
        check ( rw_res_fa_auftrag in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_rw_res_mhd
        check ( rw_res_mhd in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint check_isi_firma_rw_res_serie
        check ( rw_res_serie in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_firma
    add constraint pk_firma primary key ( firma_nr )
        using index enable;


-- sqlcl_snapshot {"hash":"f6a66b73f900458b5604a1217575d2e8b011f747","type":"TABLE","name":"ISI_FIRMA","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_FIRMA</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>2</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEZEICHNUNG</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INFO</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ADRESS_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_BARCODE_TYPE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'STD'</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_BARCODE_LAENGE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>2</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>15</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_BARCODE_KOPF</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_BARCODE_BASIS</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>30</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'SEQ'</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ETIKETT_ROH</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ETIKETT_TF</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ETIKETT_FW</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_BARCODE_TYPE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'STD'</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_BARCODE_LAENGE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>2</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>15</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_BARCODE_KOPF</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_BARCODE_BASIS</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>30</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'SEQ'</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ETIKETT_ROH</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ETIKETT_TF</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ETIKETT_FW</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FW_RES_ARTIKEL</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FW_RES_CHARGE</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FW_RES_SERIE</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FW_RES_FA_AUFTRAG</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FW_RES_KUNDE</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FW_RES_MHD</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FW_RES_MHD_TAGE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HW_RES_ARTIKEL</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HW_RES_CHARGE</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HW_RES_SERIE</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HW_RES_FA_AUFTRAG</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HW_RES_KUNDE</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HW_RES_MHD</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HW_RES_MHD_TAGE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RW_RES_ARTIKEL</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RW_RES_CHARGE</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RW_RES_SERIE</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RW_RES_FA_AUFTRAG</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RW_RES_LIEFERANT</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RW_RES_MHD</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RW_RES_MHD_TAGE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MHD_BERECHNUNG</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'TA'</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>EXT_ETIKETTEN_DRUCK</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BDE_PROD_2W</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'T'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BDE_PROD_SCHROTT</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'T'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BDE_RUEST_2W</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'T'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BDE_RUEST_SCHROTT</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'T'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DEFAULT_LANG_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SEP_NVE_KOPF</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ANZ_ETIKETT_JE_LTE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_STRING_ANBRUCH</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>80</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ETIKETT_ANBRUCH</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROZ_ANBRUCH</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>6</SCALE>\n            <DEFAULT>100</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LABOR_STATUS_ANBRUCH</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_MHD_BERECH</NAME>\n            <CONDITION>MHD_BERECHNUNG in ('TA','MA','ME','WA', 'WE','YA','YE')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_RW_RES_ARTIKEL</NAME>\n            <CONDITION>RW_RES_ARTIKEL in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_RW_RES_CHARGE</NAME>\n            <CONDITION>RW_RES_CHARGE in ('T','F','H')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_RW_RES_FA_AUFT</NAME>\n            <CONDITION>RW_RES_FA_AUFTRAG in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_RW_RES_MHD</NAME>\n            <CONDITION>RW_RES_MHD in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_RW_RES_SERIE</NAME>\n            <CONDITION>RW_RES_SERIE in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_BDE_PROD_2W</NAME>\n            <CONDITION>BDE_PROD_2W in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_BDE_PR_SCHROTT</NAME>\n            <CONDITION>BDE_PROD_SCHROTT in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_BDE_RUEST_SCHR</NAME>\n            <CONDITION>BDE_RUEST_SCHROTT in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_FW_RES_ARTIKEL</NAME>\n            <CONDITION>FW_RES_ARTIKEL in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_FW_RES_CHARGE</NAME>\n            <CONDITION>FW_RES_CHARGE in ('T','F','H')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_FW_RES_FA_AUFT</NAME>\n            <CONDITION>FW_RES_FA_AUFTRAG in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_FW_RES_KUNDE</NAME>\n            <CONDITION>FW_RES_KUNDE in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_FW_RES_MHD</NAME>\n            <CONDITION>FW_RES_MHD in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_FW_RES_SERIE</NAME>\n            <CONDITION>FW_RES_SERIE in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_HW_RES_ARTIKEL</NAME>\n            <CONDITION>HW_RES_ARTIKEL in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_HW_RES_CHARGE</NAME>\n            <CONDITION>HW_RES_CHARGE in ('T','F', 'H')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_HW_RES_FA_AUFT</NAME>\n            <CONDITION>HW_RES_FA_AUFTRAG in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_HW_RES_KUNDE</NAME>\n            <CONDITION>HW_RES_KUNDE in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_HW_RES_MHD</NAME>\n            <CONDITION>HW_RES_FA_AUFTRAG in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_HW_RES_SERIE</NAME>\n            <CONDITION>HW_RES_SERIE in ('T','F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_LHM_BARC_BASIS</NAME>\n            <CONDITION>LHM_BARCODE_BASIS in ('SEQ', 'LTE', 'LHM')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_LHM_BARC_TYPE</NAME>\n            <CONDITION>LHM_BARCODE_TYPE in ('STD', 'VDA', 'SPEZ', 'CCG')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_LTE_BARC_BASIS</NAME>\n            <CONDITION>LTE_BARCODE_BASIS in ('SEQ', 'LTE', 'LHM')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHECK_ISI_FIRMA_LTE_BARC_TYPE</NAME>\n            <CONDITION>LTE_BARCODE_TYPE in ('STD', 'VDA', 'SPEZ', 'CCG')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_FIRMA</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}