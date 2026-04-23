create or replace force editionable view dirkspzm32.v_isi_tab_field_seq (
    "table_name_",
    "field_name_",
    "sequence_name_",
    "Kommentar_"
) as
    select
        'BDE_FA_AUFTRAG' as "table_name_",
        'Auf_ID'         as "field_name_",
        'SEQ_ISI_ORDER'  as "sequence_name_",
        ''               as "Kommentar_"
    from
        dual
    union
    select
        'bde_fa_auftrag_stl'                    as "table_name_",
        'fa_ag_stl_id'                          as "field_name_",
        'seq_fa_ag_stl_id'                      as "sequence_name_",
        'TR: TR_BDE_FA_AUFTRAG_STL_BI, Zeile:9' as "Kommentar_"
    from
        dual
    union
    select
        'bde_pd_lam_stl_daten'            as "table_name_",
        'pd_lam_stl_daten_id'             as "field_name_",
        'seq_lam_stl_daten_id'            as "sequence_name_",
        'TR: TR_BDE_PD_LAM_STL_DATEN_BIU' as "Kommentar_"
    from
        dual
    union
    select
        'bde_pd_nio_daten'            as "table_name_",
        'nio_daten_id'                as "field_name_",
        'seq_bde_pd_nio_daten'        as "sequence_name_",
        'TR: TR_BDE_PD_NIO_DATEN_BIU' as "Kommentar_"
    from
        dual
    union
    select
        'bde_pd_schicht_log'        as "table_name_",
        'schicht_log_id'            as "field_name_",
        'SEQ_BDE_PD_SCHICHT_LOG_ID' as "sequence_name_",
        ''                          as "Kommentar_"
    from
        dual
    union
    select
        'BDE_PD_PROD'                             as "table_name_",
        'VORG_ID'                                 as "field_name_",
        'SEQ_VORG_ID'                             as "sequence_name_",
        'SEQ-Generierung nicht von einem TRIGGER' as "Kommentar_"
    from
        dual
    union
    select
        'bde_pd_rueckverf_sel'       as "table_name_",
        'ABFR_ID'                    as "field_name_",
        'SEQ_BDE_PD_RUECKVERFOLGUNG' as "sequence_name_",
        ''                           as "Kommentar_"
    from
        dual
    union
    select
        'bde_pd_rueckverfolgung'     as "table_name_",
        'ABFR_ID'                    as "field_name_",
        'SEQ_BDE_PD_RUECKVERFOLGUNG' as "sequence_name_",
        ''                           as "Kommentar_"
    from
        dual
    union
    select
        'db_trace'          as "table_name_",
        'db_act_log_id'     as "field_name_",
        'seq_db_act_log_id' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'dw_lvs_bestand'           as "table_name_",
        'dw_stat_id'               as "field_name_",
        'SEQ_DW_LVS_BESTAND'       as "sequence_name_",
        'TR: TR_DW_LVS_BESTAND_BI' as "Kommentar_"
    from
        dual
    union
    select
        'ems_konten'            as "table_name_",
        'ems_konto_nr'          as "field_name_",
        'seq_ems_konto_nr'      as "sequence_name_",
        'TR: TR_EMS_KONTEN_BIU' as "Kommentar_"
    from
        dual
    union
    select
        'isi_adressen'    as "table_name_",
        'adress_id'       as "field_name_",
        'seq_adressen_id' as "sequence_name_",
        ''                as "Kommentar_"
    from
        dual
    union
    select
        'isi_arbeitsplatz'       as "table_name_",
        'arbeitsplatz_id'        as "field_name_",
        'seq_isi_arbeitsplaz_id' as "sequence_name_",
        ''                       as "Kommentar_"
    from
        dual
    union
    select
        'isi_arbeitsplatz_cfg'        as "table_name_",
        'app_cfg_id'                  as "field_name_",
        'seq_isi_arbeitsplatz_cfg_id' as "sequence_name_",
        ''                            as "Kommentar_"
    from
        dual
    union
    select
        'isi_artikel_ctrl'     as "table_name_",
        'isi_artikel_ctrl_id'  as "field_name_",
        'seq_isi_artikel_ctrl' as "sequence_name_",
        ''                     as "Kommentar_"
    from
        dual
    union
    select
        'isi_artikel_gruppe'    as "table_name_",
        'art_gruppe_id'         as "field_name_",
        'seq_artikel_gruppe_id' as "sequence_name_",
        ''                      as "Kommentar_"
    from
        dual
    union
    select
        'isi_contact'     as "table_name_",
        'contact_Id'      as "field_name_",
        'seq_isi_contact' as "sequence_name_",
        ''                as "Kommentar_"
    from
        dual
    union
    select
        'isi_event'    as "table_name_",
        'event_id'     as "field_name_",
        'seq_event_id' as "sequence_name_",
        ''             as "Kommentar_"
    from
        dual
    union
    select
        'isi_event_message_texte' as "table_name_",
        'event_msg_text_id'       as "field_name_",
        'seq_event_msg_text_id'   as "sequence_name_",
        ''                        as "Kommentar_"
    from
        dual
    union
    select
        'ISI_FIRMA_CFG'        as "table_name_",
        'firma_cfg_ID'         as "field_name_",
        'seq_isi_firma_cfg_ID' as "sequence_name_",
        ''                     as "Kommentar_"
    from
        dual
    union
    select
        'isi_komm_order' as "table_name_",
        'komm_id'        as "field_name_",
        'seq_komm_id'    as "sequence_name_",
        ''               as "Kommentar_"
    from
        dual
    union
    select
        'ISI_LAND'     as "table_name_",
        'land_id'      as "field_name_",
        'SEQ_ISI_LAND' as "sequence_name_",
        ''             as "Kommentar_"
    from
        dual
    union
    select
        'ISI_LAND_REGION'     as "table_name_",
        'region_id'           as "field_name_",
        'SEQ_ISI_LAND_REGION' as "sequence_name_",
        ''                    as "Kommentar_"
    from
        dual
    union
    select
        'ISI_LANGUAGE'             as "table_name_",
        'lang_id'                  as "field_name_",
        'SEQ_ISI_LANGUAGE_LANG_ID' as "sequence_name_",
        ''                         as "Kommentar_"
    from
        dual
    union
    select
        'ISI_MAIL_QUEUE'        as "table_name_",
        'mail_id'               as "field_name_",
        'seq_isi_mail_queue_id' as "sequence_name_",
        ''                      as "Kommentar_"
    from
        dual
    union
    select
        'isi_order_kopf'                                                    as "table_name_",
        'LI_NR'                                                             as "field_name_",
        'SEQ_TMS_ORDER_LI_NR'                                               as "sequence_name_",
        'PBdy: tms_p_loading, Zeile: 409, durch Insert wenn diese NULL ist' as "Kommentar_"
    from
        dual
    union
    select
        'isi_order_kopf'                                                                              as "table_name_",
        'vorgang_id'                                                                                  as "field_name_",
        'SEQ_ISI_ORDER_MA_LIEF'                                                                       as "sequence_name_",
        'TR_ISI_ORDER_KOPF_BIU. Die Vorgang_ID wird aus der SEQ: SEQ_ISI_ORDER_MA_LIEF ermittelt!!! ' as "Kommentar_"
    from
        dual
    union
    select
        'isi_order_pos' as "table_name_",
        'auf_id'        as "field_name_",
        'seq_isi_order' as "sequence_name_",
        ''              as "Kommentar_"
    from
        dual
    union
    select
        'isi_order_reord_h' as "table_name_",
        'reord_id'          as "field_name_",
        'seq_reord_id'      as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'isi_purch_kopf'     as "table_name_",
        'id'                 as "field_name_",
        'seq_isi_purch_kopf' as "sequence_name_",
        ''                   as "Kommentar_"
    from
        dual
    union
    select
        'isi_purch_pos'     as "table_name_",
        'id'                as "field_name_",
        'seq_isi_purch_pos' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'isi_res_leistung_cfg'     as "table_name_",
        'res_l_cfg_id'             as "field_name_",
        'SEQ_ISI_RES_LEISTUNG_CFG' as "sequence_name_",
        ''                         as "Kommentar_"
    from
        dual
    union
    select
        'isi_resource' as "table_name_",
        'res_id'       as "field_name_",
        'seq_res_id'   as "sequence_name_",
        ''             as "Kommentar_"
    from
        dual
    union
    select
        'ISI_RES_PRUEF_PLAN_DATA'     as "table_name_",
        'id'                          as "field_name_",
        'SEQ_ISI_RES_PRUEF_PLAN_DATA' as "sequence_name_",
        ''                            as "Kommentar_"
    from
        dual
    union
    select
        'ISI_RES_PRUEF_PLAN_DATA_CFG'  as "table_name_",
        'id'                           as "field_name_",
        'SEQ_ISI_RES_PRUEF_P_DATA_CFG' as "sequence_name_",
        ''                             as "Kommentar_"
    from
        dual
    union
    select
        'isi_res_schicht'        as "table_name_",
        'Schicht_ID'             as "field_name_",
        'seq_isi_res_schicht_id' as "sequence_name_",
        ''                       as "Kommentar_"
    from
        dual
    union
    select
        'isi_script_cfg'    as "table_name_",
        'script_id'         as "field_name_",
        'seq_script_cfg_id' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'isi_security_cfg'    as "table_name_",
        'SECURITY_CFG_ID'     as "field_name_",
        'seq_security_cfg_id' as "sequence_name_",
        ''                    as "Kommentar_"
    from
        dual
    union
    select
        'ISI_TRANSPORT'    as "table_name_",
        'TRANSP_ID'        as "field_name_",
        'seq_Transport_id' as "sequence_name_",
        ''                 as "Kommentar_"
    from
        dual
    union
    select
        'isi_transport_log' as "table_name_",
        'transp_log_id'     as "field_name_",
        'seq_transp_log_id' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'isi_user'     as "table_name_",
        'login_id'     as "field_name_",
        'seq_login_id' as "sequence_name_",
        ''             as "Kommentar_"
    from
        dual
    union
    select
        'isi_system_info'        as "table_name_",
        'last_license_ticket_id' as "field_name_",
        'seq_license_ticket_id'  as "sequence_name_",
        ''                       as "Kommentar_"
    from
        dual
    union
    select
        'isi_log'        as "table_name_",
        'log_id'         as "field_name_",
        'seq_isi_log_id' as "sequence_name_",
        ''               as "Kommentar_"
    from
        dual
    union
    select
        'isi_db_act_log'    as "table_name_",
        'db_act_log_id'     as "field_name_",
        'seq_db_act_log_id' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'isi_Res_schicht'        as "table_name_",
        'Parent_id'              as "field_name_",
        'seq_isi_res_schicht_id' as "sequence_name_",
        ''                       as "Kommentar_"
    from
        dual
    union
    select
        'ISI_DB_AKTIVITAET'     as "table_name_",
        'ID'                    as "field_name_",
        'SEQ_ISI_DB_AKTIVITAET' as "sequence_name_",
        ''                      as "Kommentar_"
    from
        dual
    union
    select
        'isi_scan_log'        as "table_name_",
        'isi_scan_log_id'     as "field_name_",
        'seq_isi_scan_log_id' as "sequence_name_",
        ''                    as "Kommentar_"
    from
        dual
    union
    select
        'LVS_ARTIKEL_LGR_INFO'     as "table_name_",
        'lvs_art_lgr_info_id'      as "field_name_",
        'seq_lvs_artikel_lgr_info' as "sequence_name_",
        ''                         as "Kommentar_"
    from
        dual
    union
    select
        'lvs_artikel_status'    as "table_name_",
        'artikel_status_id'     as "field_name_",
        'seq_artikel_status_id' as "sequence_name_",
        ''                      as "Kommentar_"
    from
        dual
    union
    select
        'lvs_check_log'        as "table_name_",
        'lvs_check_log_id'     as "field_name_",
        'seq_lvs_check_log_id' as "sequence_name_",
        ''                     as "Kommentar_"
    from
        dual
    union
    select
        'lvs_inventur_job_kopf' as "table_name_",
        'inventur_id'           as "field_name_",
        'SEQ_INVENTUR'          as "sequence_name_",
        ''                      as "Kommentar_"
    from
        dual
    union
    select
        'lvs_inventur_job_pos' as "table_name_",
        'inventur_pk_id'       as "field_name_",
        'seq_inventur_pos_id'  as "sequence_name_",
        ''                     as "Kommentar_"
    from
        dual
    union
    select
        'lvs_prod_linie'        as "table_name_",
        'linie_nr'              as "field_name_",
        'seq_lvs_prod_linie_nr' as "sequence_name_",
        ''                      as "Kommentar_"
    from
        dual
    union
    select
        'LVS_SERIE_ID_KOPF' as "table_name_",
        'serie_id'          as "field_name_",
        'seq_serie_id'      as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'LVS_SERIE_ID_POS'  as "table_name_",
        'serie_id_lfdn'     as "field_name_",
        'seq_serie_id_lfdn' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'LVS_CHARGE'                                        as "table_name_",
        'CHARGE_ID'                                         as "field_name_",
        'SEQ_CHARGE'                                        as "sequence_name_",
        'Aus den FKT: GET_CHARGE_ID und GET_CHARGE_NEXT_ID' as "Kommentar_"
    from
        dual
    union
    select
        'LVS_LAM' as "table_name_",
        'LAM_ID'  as "field_name_",
        'SEQ_LAM' as "sequence_name_",
        ''        as "Kommentar_"
    from
        dual
    union
    select
        'lvs_lam_bh'  as "table_name_",
        'VORG_ID'     as "field_name_",
        'SEQ_VORG_ID' as "sequence_name_",
        ''            as "Kommentar_"
    from
        dual
    union
    select
        'lvs_lam_bh' as "table_name_",
        'LAM_BH_ID'  as "field_name_",
        'seq_lam_bh' as "sequence_name_",
        ''           as "Kommentar_"
    from
        dual
    union
    select
        'meldung_daten' as "table_name_",
        'md_id'         as "field_name_",
        'seq_md_id'     as "sequence_name_",
        ''              as "Kommentar_"
    from
        dual
    union
    select
        'PE_JOBS'        as "table_name_",
        'job_nr'         as "field_name_",
        'PE_SEQ_PE_JOBS' as "sequence_name_",
        ''               as "Kommentar_"
    from
        dual
    union
    select
        'pzm_abteilungen' as "table_name_",
        'abt_id'          as "field_name_",
        'seq_abt_id'      as "sequence_name_",
        ''                as "Kommentar_"
    from
        dual
    union
    select
        'pzm_abwesenheitsarten' as "table_name_",
        'aa_id'                 as "field_name_",
        'seq_aa_id'             as "sequence_name_",
        ''                      as "Kommentar_"
    from
        dual
    union
    select
        'pzm_betriebsferien' as "table_name_",
        'bf_id'              as "field_name_",
        'seq_bf_id'          as "sequence_name_",
        ''                   as "Kommentar_"
    from
        dual
    union
    select
        'pzm_konten'       as "table_name_",
        'konto_nr'         as "field_name_",
        'seq_pzm_konto_nr' as "sequence_name_",
        ''                 as "Kommentar_"
    from
        dual
    union
    select
        'pzm_konten_bh'    as "table_name_",
        'konten_bh_id'     as "field_name_",
        'seq_konten_bh_id' as "sequence_name_",
        ''                 as "Kommentar_"
    from
        dual
    union
    select
        'pzm_krankmeldungen' as "table_name_",
        'km_id'              as "field_name_",
        'seq_km_id'          as "sequence_name_",
        ''                   as "Kommentar_"
    from
        dual
    union
    select
        'pzm_lohnzulagen' as "table_name_",
        'lz_id'           as "field_name_",
        'seq_lz_id'       as "sequence_name_",
        ''                as "Kommentar_"
    from
        dual
    union
    select
        'pzm_personal_gruppen' as "table_name_",
        'pg_nummer'            as "field_name_",
        'seq_pg_nummer'        as "sequence_name_",
        ''                     as "Kommentar_"
    from
        dual
    union
    select
        'pzm_produktionsbereiche' as "table_name_",
        'pb_id'                   as "field_name_",
        'seq_pb_id'               as "sequence_name_",
        ''                        as "Kommentar_"
    from
        dual
    union
    select
        'pzm_vertragsarten' as "table_name_",
        'va_id'             as "field_name_",
        'seq_va_id'         as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'pzm_zeiterfassung' as "table_name_",
        'ZE_ID'             as "field_name_",
        'seq_ze_id'         as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'rep_abfragen' as "table_name_",
        'rep_id'       as "field_name_",
        'seq_rep_id'   as "sequence_name_",
        ''             as "Kommentar_"
    from
        dual
    union
    select
        'rep_abfragen_hist' as "table_name_",
        'REP_HIST_ID'       as "field_name_",
        'seq_rep_hist_id'   as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'sec_groups'   as "table_name_",
        'group_id'     as "field_name_",
        'seq_group_id' as "sequence_name_",
        ''             as "Kommentar_"
    from
        dual
    union
    select
        'pps_plan_auftrag'            as "table_name_",
        'PLAN_AUF_ID'                 as "field_name_",
        'SEQ_BDE_FA_AUFTRAG_LEITZAHL' as "sequence_name_",
        ''                            as "Kommentar_"
    from
        dual
    union
    select
        'pps_plan_auftrag'            as "table_name_",
        'PLAN_AUF_ID_EXT'             as "field_name_",
        'SEQ_BDE_FA_AUFTRAG_LEITZAHL' as "sequence_name_",
        ''                            as "Kommentar_"
    from
        dual
    union
    select
        'pps_plan_auftrag_ag'     as "table_name_",
        'PLAN_AUF_AG_ID'          as "field_name_",
        'SEQ_PPS_PLAN_AUFTRAG_AG' as "sequence_name_",
        ''                        as "Kommentar_"
    from
        dual
    union
    select
        'pps_plan_auftrag_stl'        as "table_name_",
        'PLAN_AUF_ID'                 as "field_name_",
        'SEQ_BDE_FA_AUFTRAG_LEITZAHL' as "sequence_name_",
        ''                            as "Kommentar_"
    from
        dual
    union
-- hier knallt es da res_string eine Zusammensetzung ist
    select
        'S_ERP_RCV_AUFTR' as "table_name_",
        'auf_id'          as "field_name_",
        'SEQ_S_AUFTR'     as "sequence_name_",
        ''                as "Kommentar_"
    from
        dual
    union
    select
        'S_ERP_RCV_FA_AUF' as "table_name_",
        'auf_id'           as "field_name_",
        'SEQ_S_AUFTR'      as "sequence_name_",
        ''                 as "Kommentar_"
    from
        dual
    union
    select
        's_essex_send_bew'  as "table_name_",
        'send_id'           as "field_name_",
        'seq_s_send_bew_id' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        's_mfr_rcv_auftr' as "table_name_",
        'auf_id'          as "field_name_",
        'SEQ_S_AUFTR'     as "sequence_name_",
        ''                as "Kommentar_"
    from
        dual
    union
    select
        's_mfr_send_offline' as "table_name_",
        'offline_id'         as "field_name_",
        'seq_s_send_bew_id'  as "sequence_name_",
        ''                   as "Kommentar_"
    from
        dual
    union
    select
        's_rcv_auftr'                                            as "table_name_",
        'auf_id'                                                 as "field_name_",
        'SEQ_ISI_ORDER_AUF_ID'                                   as "sequence_name_",
        'MFR_PACKAGE, Zeile 1803. procedure C_TRANSP_DEPAL_LTE.' as "Kommentar_"
    from
        dual
    union
    select
        's_rcv_auftr'                                                                                                  as "table_name_"
        ,
        'VORGANG'                                                                                                      as "field_name_"
        ,
        'SEQ_TMS_ORDER_VORGANG_ID'                                                                                     as "sequence_name_"
        ,
        'MFR_PACKAGE, Zeile 1804. procedure C_TRANSP_DEPAL_LTE. Die Vorgang_ID wird durch die angegebene SEQ erstellt' as "Kommentar_"
    from
        dual
    union
    select
        's_rcv_fa_auf'         as "table_name_",
        'auf_id'               as "field_name_",
        'SEQ_ISI_ORDER_AUF_ID' as "sequence_name_",
        ''                     as "Kommentar_"
    from
        dual
    union
    select
        's_rcv_kunden_auftr_pos'     as "table_name_",
        'kunden_auftr_pos_id'        as "field_name_",
        'SEQ_S_RCV_kunden_auftr_pos' as "sequence_name_",
        ''                           as "Kommentar_"
    from
        dual
    union
    select
        's_send_bew'        as "table_name_",
        'bew_id'            as "field_name_",
        'seq_s_send_bew_id' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        's_sqd_sap_send_bew'                                                      as "table_name_",
        'TS'                                                                      as "field_name_",
        'seq_s_send_bew_id'                                                       as "sequence_name_",
        'PaBdy S_SCHNITTSTELLE, Proc.: SEND_HOST_BEW, Zeile 2368, (durch update)' as "Kommentar_"
    from
        dual
    union
    select
        'ts_job_items_log'       as "table_name_",
        'job_item_log_id'        as "field_name_",
        'seq_ts_job_item_log_id' as "sequence_name_",
        ''                       as "Kommentar_"
    from
        dual
    union
    select
        'ts_schedule_cfg'     as "table_name_",
        'schedule_cfg_id'     as "field_name_",
        'seq_schedule_cfg_id' as "sequence_name_",
        ''                    as "Kommentar_"
    from
        dual
    union
    select
        'z_bel_snd_message' as "table_name_",
        'uidnr'             as "field_name_",
        'seq_s_send_bew_id' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        'sec_section_info'   as "table_name_",
        'section_id'         as "field_name_",
        'seq_sec_section_id' as "sequence_name_",
        ''                   as "Kommentar_"
    from
        dual
    union
    select
        'sec_action_info'   as "table_name_",
        'ACTION_ID'         as "field_name_",
        'seq_sec_action_id' as "sequence_name_",
        ''                  as "Kommentar_"
    from
        dual
    union
    select
        's_eus_sap_send_bew'                                                                                    as "table_name_",
        'TS'                                                                                                    as "field_name_",
        'seq_s_send_bew_id'                                                                                     as "sequence_name_",
        'PaBdy S_SCHNITTSTELLE, Proc.: SEND_HOST_BEW, Zeile 1772. Auch im Trigger: TR_S_SQD_SAP_SEND_BEW_BIUD ' as "Kommentar_"
    from
        dual
    union
    select
        's_sas_sap_send_bew'                                                     as "table_name_",
        'SEND_ID'                                                                as "field_name_",
        'seq_sas_sap_job_id'                                                     as "sequence_name_",
        'PaBdy S_SCHNITTSTELLE, Proc.: SEND_HOST_BEW, Zeile 3315 (durch Insert)' as "Kommentar_"
    from
        dual;


-- sqlcl_snapshot {"hash":"ea3ec0f3e54636a0806b78cb598c41e3d494db67","type":"VIEW","name":"V_ISI_TAB_FIELD_SEQ","schemaName":"DIRKSPZM32","sxml":""}