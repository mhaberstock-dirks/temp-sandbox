create or replace package dirkspzm32.bde_p_base is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  05.02.2008
  __________________________________________________
  Description
  Basisfunktionen für schnellen Zugriff auf bde Datensätze
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR   Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-WK-)   Minor Release 3.5
  05.02.2008   3.4.4.1     (-WK-)   Package erstellt
  11.11.2009   3.4.13.1    (-BW-)   Anzeige Freie Plätze anstatt bel. Plätze.
  22.10.2009   3.4.12.1    (-BW-)   Visu Erzeugt
  *            3.4.1.1     (-HJG-)  Einbau BDE-Datenerfassung Manuell
  *            3.3.4.1     (-HJG-)  Einbau neuer Fuktionen c_insert_bde_pd_schrott
  *                                 > Aenerung des Rueckgabewerts beim zaehlen der Prod-Tage
  *                                 > und der Schichten
  *                                 - V3.3.4.0: > Einbau der Versionierung
  */

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;

    function get_fa_kopf (
        in_sid          in bde_fa_kopf.sid%type,
        in_firma_nr     in bde_fa_kopf.firma_nr%type,
        in_fa_nr        in bde_fa_kopf.fa_nr%type,
        out_bde_fa_kopf out bde_fa_kopf%rowtype
    ) return boolean;

    function get_fa_ag (
        in_sid        in bde_fa_auftrag.sid%type,
        in_firma_nr   in bde_fa_auftrag.firma_nr%type,
        in_fa_nr      in bde_fa_auftrag.leitzahl%type,
        in_fa_ag      in bde_fa_auftrag.fa_ag%type,
        in_fa_upos    in bde_fa_auftrag.fa_upos%type,
        out_bde_fa_ag out bde_fa_auftrag%rowtype
    ) return boolean;

    function get_fa_by_auf_id (
        in_sid        in bde_fa_auftrag.sid%type,
        in_firma_nr   in bde_fa_auftrag.firma_nr%type,
        in_auf_id     in bde_fa_auftrag.auf_id%type,
        out_bde_fa_ag out bde_fa_auftrag%rowtype
    ) return boolean;

    function get_pd_kopf (
        in_sid            in bde_pd_kopf.sid%type,
        in_firma_nr       in bde_pd_kopf.firma_nr%type,
        in_res_id         in bde_pd_kopf.res_id%type,
        in_pd_kopf_beginn in bde_pd_kopf.pd_kopf_beginn%type,
        out_bde_pd_kopf   out bde_pd_kopf%rowtype
    ) return boolean;

    function get_pd_pers_zeit_kst (
        in_sid                   in bde_pd_pers_zeit_kst.sid%type,
        in_firma_nr              in bde_pd_pers_zeit_kst.firma_nr%type,
        in_res_id                in bde_pd_pers_zeit_kst.res_id%type,
        in_pres_nr               in bde_pd_pers_zeit_kst.pers_nr%type,
        in_pd_pres_beginn        in bde_pd_pers_zeit_kst.pd_pers_beginn%type,
        out_bde_pd_pers_zeit_kst out bde_pd_pers_zeit_kst%rowtype
    ) return boolean;

    procedure c_set_fa_ag_mg (
        in_sid               in bde_fa_auftrag.sid%type,
        in_firma_nr          in bde_fa_auftrag.firma_nr%type,
        in_fa_nr             in bde_fa_auftrag.leitzahl%type,
        in_fa_ag             in bde_fa_auftrag.fa_ag%type,
        in_fa_upos           in bde_fa_auftrag.fa_upos%type,
        in_pd_ende           in bde_pd_prod.prod_ende%type,
        in_ag_ist_mg         in bde_fa_auftrag.ag_ist_mg%type,
        in_ag_ist_mg_b       in bde_fa_auftrag.ag_ist_mg_b%type,
        in_ag_ist_mg_schrott in bde_fa_auftrag.ag_ist_mg_schrott%type,
        in_ag_ist_mg_ruesten in bde_fa_auftrag.ag_ist_mg_ruesten%type,
        in_ruest_zeit_ist    in bde_fa_auftrag.ruest_zeit_ist%type,
        in_prod_zeit_ist     in bde_fa_auftrag.prod_zeit_ist%type,
        in_stoer_zeit_ist    in bde_fa_auftrag.stoer_zeit_ist%type
    );

    function get_bde_pd_prozess_data (
        in_sid                     in bde_pd_prozess_data.sid%type,
        in_firma_nr                in bde_pd_prozess_data.firma_nr%type,
        in_vorg_id                 in bde_pd_prozess_data.vorg_id%type,
        in_res_prozess_data_res_id in bde_pd_prozess_data.res_prozess_data_res_id%type,
        in_res_prozess_data_date   in bde_pd_prozess_data.res_prozess_data_date%type,
        in_res_prozess_data_nr     in bde_pd_prozess_data.res_prozess_data_nr%type,
        out_bde_pd_prozess_data    out bde_pd_prozess_data%rowtype
    ) return boolean;

    procedure c_bde_pd_set_aktiv_ag (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_leitzahl    in bde_fa_auftrag.leitzahl%type,
        in_fa_ag       in bde_fa_auftrag.fa_ag%type,
        in_fa_upos     in bde_fa_auftrag.fa_upos%type,
        in_res_id      in isi_resource.res_id%type,
        in_akt_term    in isi_arbeitsplatz.ip_name%type,
        in_ls_login_id in isi_user.login_id%type
    );

    procedure c_bde_pd_set_deaktiv_ag (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_res_id      in isi_resource.res_id%type,
        in_akt_term    in isi_arbeitsplatz.ip_name%type,
        in_ls_login_id in isi_user.login_id%type
    );

    procedure c_bde_pd_set_reset_ag (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_leitzahl    in bde_fa_auftrag.leitzahl%type,
        in_fa_ag       in bde_fa_auftrag.fa_ag%type,
        in_fa_upos     in bde_fa_auftrag.fa_upos%type,
        in_res_id      in isi_resource.res_id%type,
        in_akt_term    in isi_arbeitsplatz.ip_name%type,
        in_ls_login_id in isi_user.login_id%type
    );

    function bde_pd_check_aktiv_ag (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_leitzahl in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_fa_upos  in bde_fa_auftrag.fa_upos%type
    ) return varchar;

    function get_pd_prod_by_lam_id (
        in_sid          in bde_pd_prod.sid%type,
        in_firma_nr     in bde_pd_prod.firma_nr%type,
        in_lam_id       in bde_pd_prod.lam_id%type,
        out_bde_pd_prod out bde_pd_prod%rowtype
    ) return boolean;

    function get_leitzahl_by_lte_id (
        in_sid      in lvs_lte.sid%type,
        in_firma_nr in lvs_lte.firma_nr%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) return number;

end bde_p_base;
/


-- sqlcl_snapshot {"hash":"3eacc37d55104f737d21bd3fdf63c153e9ada853","type":"PACKAGE_SPEC","name":"BDE_P_BASE","schemaName":"DIRKSPZM32","sxml":""}