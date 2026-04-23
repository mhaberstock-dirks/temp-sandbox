create or replace package dirkspzm32.s_schnittstelle is

  -- Author  : HJGOEDEKE
  -- Created : 25.07.2004 10:59:06
  -- Purpose :

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
    v_send_host_aktiv boolean;
    procedure write_host_bew (
        in_order_pos  in isi_order_pos%rowtype,
        in_lam        in lvs_lam%rowtype,
        in_lam_bh_id  in lvs_lam_bh.lam_bh_id%type,
        in_lam_bh_bus in lvs_lam_bh.bus%type,
        in_lam_bh_typ in lvs_lam_bh.vorg_typ%type,
        in_tabelle    in varchar2,
        in_status     in s_send_bew.status%type,
        in_quell_lgr  in lvs_lgr%rowtype,
        in_ziel_lgr   in lvs_lgr%rowtype,
        in_login_id   in isi_user.login_id%type,
        in_menge      in number default null
    );

    procedure write_host_bew_menge (
        in_order_pos  in isi_order_pos%rowtype,
        in_lam        in lvs_lam%rowtype,
        in_lam_bh_id  in lvs_lam_bh.lam_bh_id%type,
        in_lam_bh_bus in lvs_lam_bh.bus%type,
        in_lam_bh_typ in lvs_lam_bh.vorg_typ%type,
        in_tabelle    in varchar2,
        in_status     in s_send_bew.status%type,
        in_quell_lgr  in lvs_lgr.lgr_platz%type,
        in_ziel_lgr   in lvs_lgr.lgr_platz%type,
        in_login_id   in isi_user.login_id%type,
        in_menge      in number
    );

    procedure send_host_bew (
        io_bew in out s_send_bew%rowtype
    );

    procedure write_host_platz_lte_update (
        in_lte in lvs_lte%rowtype
    );

    procedure write_auftr_update (
        in_auf_id    in s_rcv_auftr.auf_id%type,
        in_status    in s_rcv_auftr.status%type,
        in_lvs_info  in s_rcv_auftr.lvs_info%type,
        in_ist_menge in s_rcv_auftr.ist_menge%type
    );

    function write_host_prod_bew (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_fa_auftrag in bde_fa_auftrag%rowtype,
        in_lam        in lvs_lam%rowtype,
        in_lam_bh_id  in lvs_lam_bh.lam_bh_id%type,
        in_lam_bh_bus in lvs_lam_bh.bus%type,
        in_lam_bh_typ in lvs_lam_bh.vorg_typ%type,
        in_tabelle    in varchar2,
        in_status     in s_send_bew.status%type
    ) return number;

    procedure write_host_prod_bew_menge (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_fa_auftrag in bde_fa_auftrag%rowtype,
        in_lam        in lvs_lam%rowtype,
        in_lam_bh_id  in lvs_lam_bh.lam_bh_id%type,
        in_lam_bh_bus in lvs_lam_bh.bus%type,
        in_lam_bh_typ in lvs_lam_bh.vorg_typ%type,
        in_tabelle    in varchar2,
        in_status     in s_send_bew.status%type,
        in_menge      in number,
        in_login_id   in number
    );

    function c_write_mfr_auftrag (
        in_firma     in s_mfr_rcv_auftr.firma_nr%type,
        in_auf_id    in s_mfr_rcv_auftr.auf_id%type,
        in_satzart   in s_mfr_rcv_auftr.satzart%type,
        in_funktion  in s_mfr_rcv_auftr.funktion%type,
        in_auftrag   in s_mfr_rcv_auftr.auftrag%type,
        in_lte_id    in s_mfr_rcv_auftr.lte_id%type,
        in_quelle    in s_mfr_rcv_auftr.quelle%type,
        in_ziel      in s_mfr_rcv_auftr.ziel%type,
        in_telegramm in s_mfr_rcv_auftr.telegramm%type
    ) return s_mfr_rcv_auftr.auf_id%type;

    function c_write_mfr_send_offline (
        in_firma     in s_mfr_send_offline.firma_nr%type,
        in_auf_id    in s_mfr_send_offline.auf_id%type,
        in_satzart   in s_mfr_send_offline.satzart%type,
        in_funktion  in s_mfr_send_offline.funktion%type,
        in_auftrag   in s_mfr_send_offline.auftrag%type,
        in_lte_id    in s_mfr_send_offline.lte_id%type,
        in_quelle    in s_mfr_send_offline.quelle%type,
        in_ziel      in s_mfr_send_offline.ziel%type,
        in_telegramm in s_mfr_send_offline.telegramm%type,
        in_gruppe    in s_mfr_send_offline.gruppe%type
    ) return s_mfr_send_offline.offline_id%type;

end;
/


-- sqlcl_snapshot {"hash":"35648e3cadf10e6a1f45c3f4097e59afdb50f2c5","type":"PACKAGE_SPEC","name":"S_SCHNITTSTELLE","schemaName":"DIRKSPZM32","sxml":""}