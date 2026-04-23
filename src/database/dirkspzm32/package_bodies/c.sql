create or replace package body dirkspzm32.c is

    function get_isi_product_release return varchar2 is
    begin
        return ( v_isi_product_release );
    end;

    function decode_function_fehler (
        return_value in integer
    ) return varchar2 is
    begin
        if return_value = transport_fehlt then
            return ( c.transport_txt_fehlt );
        end if;
        if return_value = lte_fehlt then
            return ( c.lte_txt_fehlt );
        end if;
        if return_value = lgr_fehlt then
            return ( c.lgr_txt_fehlt );
        end if;
        if return_value = lgr_lte_fehlt then
            return ( c.lgr_lte_txt_fehlt );
        end if;
        if return_value = lgr_q_fehlt then
            return ( c.lgr_q_txt_fehlt );
        end if;
        if return_value = lgr_z_fehlt then
            return ( c.lgr_z_txt_fehlt );
        end if;
        if return_value = lgr_transp_begonnen then
            return ( c.lgr_transp_txt_begonnen );
        end if;
        if return_value = lgr_res_fehlt then
            return ( c.lgr_res_txt_fehlt );
        end if;
        if return_value = lgr_reihenfolge_falsch then
            return ( c.lgr_reihenf_txt_falsch );
        end if;
        if return_value = lgr_voll then
            return ( c.lgr_txt_voll );
        end if;
        if return_value = lgr_dispo_voll then
            return ( c.lgr_dispo_txt_voll );
        end if;
        if return_value = lgr_res_string then
            return ( c.lgr_res_txt_string );
        end if;
        if return_value = lgr_ziel_typ_falsch then
            return ( c.lgr_ziel_typ_txt_falsch );
        end if;
        return ( '?' );
    end decode_function_fehler;

    function decode_lte_voll (
        return_value in varchar2
    ) return varchar2 is
    begin
        if return_value = lte_voll_v then
            return ( c.lte_voll_txt_v );
        end if;
        if return_value = lte_voll_a then
            return ( c.lte_voll_txt_a );
        end if;
        if return_value is null then
            return ( c.lte_voll_txt_v );
        end if;
        return ( '?' );
    end decode_lte_voll;

    function r_lort_laenge return number is
    begin
        return ( lort_laenge );
    end r_lort_laenge;

    function r_lgr_platz_res_string return number is
    begin
        return ( lgr_platz_res_string );
    end r_lgr_platz_res_string;

    function r_lgr_platz_leer return number is
    begin
        return ( lgr_platz_leer );
    end r_lgr_platz_leer;

    function r_lgr_platz_misch_kanal return number is
    begin
        return ( lgr_platz_misch_kanal );
    end r_lgr_platz_misch_kanal;

    function r_lgr_platz_misch_pal return number is
    begin
        return ( lgr_platz_misch_pal );
    end r_lgr_platz_misch_pal;

    function r_lgr_platz_falsch return number is
    begin
        return ( lgr_platz_falsch );
    end r_lgr_platz_falsch;

    function r_sat1 return varchar2 is
    begin
        return ( sat1 );
    end r_sat1;

    function r_sat_epl1 return varchar2 is
    begin
        return ( sat_epl1 );
    end r_sat_epl1;

    function r_epl1 return varchar2 is
    begin
        return ( epl1 );
    end r_epl1;

    function r_sat_epl2 return varchar2 is
    begin
        return ( sat_epl2 );
    end r_sat_epl2;

    function r_kanal1 return varchar2 is
    begin
        return ( kanal1 );
    end r_kanal1;

    function r_kanal_bkl1 return varchar2 is
    begin
        return ( kanal_bkl1 );
    end r_kanal_bkl1;

    function r_bkl1 return varchar2 is
    begin
        return ( bkl1 );
    end r_bkl1;

    function r_reg_fach1 return varchar2 is
    begin
        return ( reg_fach1 );
    end r_reg_fach1;

    function r_seg1 return varchar2 is
    begin
        return ( seg1 );
    end r_seg1;

    function r_seg_duedo1 return varchar2 is
    begin
        return ( seg_duedo1 );
    end r_seg_duedo1;

    function r_pp_epl1 return varchar2 is
    begin
        return ( pp_epl1 );
    end r_pp_epl1;

    function r_durchl1 return varchar2 is
    begin
        return ( durchl1 );
    end r_durchl1;

    function r_stap_flae1 return varchar2 is
    begin
        return ( stap_flae1 );
    end r_stap_flae1;

    function r_stap_flae2 return varchar2 is
    begin
        return ( stap_flae2 );
    end r_stap_flae2;

    function r_c_false return varchar2 is
    begin
        return ( c_false );
    end r_c_false;

    function r_c_true return varchar2 is
    begin
        return ( c_true );
    end r_c_true;

    function decode_true_false (
        return_value in varchar2
    ) return varchar2 is
    begin
        if return_value = c_false then
            return ( c.c_txt_false );
        end if;
        if return_value = c_true then
            return ( c.c_txt_true );
        end if;
    end decode_true_false;

    function r_lte_voll_v return varchar2 is
    begin
        return ( lte_voll_v );
    end r_lte_voll_v;

    function r_lte_voll_a return varchar2 is
    begin
        return ( lte_voll_a );
    end r_lte_voll_a;

    function r_c_anbruch_ausnahme return varchar2 is
    begin
        return ( c_anbruch_ausnahme );
    end r_c_anbruch_ausnahme;

    function r_c_anbruch_vorzug return varchar2 is
    begin
        return ( c_anbruch_vorzug );
    end r_c_anbruch_vorzug;

    function r_c_anbruch_ignore return varchar2 is
    begin
        return ( c_anbruch_ignore );
    end r_c_anbruch_ignore;

    function r_c_volle_behaelter return varchar2 is
    begin
        return ( c_volle_behaelter );
    end r_c_volle_behaelter;

    function r_lgr_gesperrt_f return varchar2 is
    begin
        return ( lgr_gesperrt_f );
    end r_lgr_gesperrt_f;

    function r_lgr_abstand_faktor return integer is
    begin
        return ( lgr_abstand_faktor );
    end r_lgr_abstand_faktor;

    function r_lgr_platz_r_faktor return integer is
    begin
        return ( lgr_platz_r_faktor );
    end r_lgr_platz_r_faktor;

    function r_mhd_ms_min_tage return integer is
    begin
        return ( mhd_ms_min_tage );
    end r_mhd_ms_min_tage;

    function r_mhd_rw_min_tage return integer is
    begin
        return ( mhd_rw_min_tage );
    end r_mhd_rw_min_tage;

    function r_mhd_hw_min_tage return integer is
    begin
        return ( mhd_hw_min_tage );
    end r_mhd_hw_min_tage;

    function r_mhd_fw_min_tage return integer is
    begin
        return ( mhd_fw_min_tage );
    end r_mhd_fw_min_tage;

    function r_lam_bh_bus_inv return integer is
    begin
        return ( lam_bh_bus_inv );
    end r_lam_bh_bus_inv;

    function r_lam_bh_bus_zug return integer is
    begin
        return ( lam_bh_bus_zug );
    end r_lam_bh_bus_zug;

    function r_lam_bh_bus_abg return integer is
    begin
        return ( lam_bh_bus_abg );
    end r_lam_bh_bus_abg;

    function r_lam_bh_bus_uml return integer is
    begin
        return ( lam_bh_bus_uml );
    end r_lam_bh_bus_uml;

    function r_lam_bh_bus_sp return integer is
    begin
        return ( lam_bh_bus_sp );
    end r_lam_bh_bus_sp;

    function r_lam_bh_bus_up return integer is
    begin
        return ( lam_bh_bus_up );
    end r_lam_bh_bus_up;

    function r_lam_bh_bus_q return integer is
    begin
        return ( lam_bh_bus_q );
    end r_lam_bh_bus_q;

    function r_lam_bh_bus_zug_komm return integer is
    begin
        return ( lam_bh_bus_zug_komm );
    end r_lam_bh_bus_zug_komm;

    function r_lam_bh_bus_abg_komm return integer is
    begin
        return ( lam_bh_bus_abg_komm );
    end r_lam_bh_bus_abg_komm;

    function r_lam_bh_bus_gezae_inv return integer is
    begin
        return ( lam_bh_bus_ivz );
    end r_lam_bh_bus_gezae_inv;

    function r_lam_bh_bus_zug_konsi return integer is
    begin
        return ( lam_bh_bus_zug_konsi );
    end r_lam_bh_bus_zug_konsi;

    function r_lam_bh_bus_abg_konsi return integer is
    begin
        return ( lam_bh_bus_abg_konsi );
    end r_lam_bh_bus_abg_konsi;

    function r_lam_bh_bus_uml_konsi return integer is
    begin
        return ( lam_bh_bus_wke_konsi );
    end r_lam_bh_bus_uml_konsi;

    function r_lgr_typ_we return varchar2 is
    begin
        return ( lgr_typ_we );
    end r_lgr_typ_we;

    function r_lgr_typ_wa return varchar2 is
    begin
        return ( lgr_typ_wa );
    end r_lgr_typ_wa;

    function r_lgr_typ_lager return varchar2 is
    begin
        return ( lgr_typ_lager );
    end r_lgr_typ_lager;

    function r_lgr_typ_puffer return varchar2 is
    begin
        return ( lgr_typ_puffer );
    end r_lgr_typ_puffer;

    function r_lgr_typ_wep return varchar2 is
    begin
        return ( lgr_typ_wep );
    end r_lgr_typ_wep;

    function r_lgr_typ_lagerp return varchar2 is
    begin
        return ( lgr_typ_lagerp );
    end r_lgr_typ_lagerp;

    function r_lte_ff_stat return varchar2 is
    begin
        return ( lte_ff_stat );
    end r_lte_ff_stat;

    function r_lte_pf_stat return varchar2 is
    begin
        return ( lte_pf_stat );
    end r_lte_pf_stat;

    function r_lte_kf_stat return varchar2 is
    begin
        return ( lte_kf_stat );
    end r_lte_kf_stat;

    function r_lte_bs_stat return varchar2 is
    begin
        return ( lte_bs_stat );
    end r_lte_bs_stat;

    function r_lte_bf_stat return varchar2 is
    begin
        return ( lte_bf_stat );
    end r_lte_bf_stat;

    function r_lte_ed_stat return varchar2 is
    begin
        return ( lte_ed_stat );
    end r_lte_ed_stat;

    function r_lte_et_stat return varchar2 is
    begin
        return ( lte_et_stat );
    end r_lte_et_stat;

    function r_lte_lf_stat return varchar2 is
    begin
        return ( lte_lf_stat );
    end r_lte_lf_stat;

    function r_lte_ad_stat return varchar2 is
    begin
        return ( lte_ad_stat );
    end r_lte_ad_stat;

    function r_lte_af_stat return varchar2 is
    begin
        return ( lte_af_stat );
    end r_lte_af_stat;

    function r_lte_ag_stat return varchar2 is
    begin
        return ( lte_ag_stat );
    end r_lte_ag_stat;

    function r_lte_ud_stat return varchar2 is
    begin
        return ( lte_ud_stat );
    end r_lte_ud_stat;

    function r_lte_ut_stat return varchar2 is
    begin
        return ( lte_ut_stat );
    end r_lte_ut_stat;

    function r_lab_stat_q return varchar2 is
    begin
        return ( lab_stat_q );
    end r_lab_stat_q;

    function r_lab_stat_u return varchar2 is
    begin
        return ( lab_stat_u );
    end r_lab_stat_u;

    function r_lab_stat_b return varchar2 is
    begin
        return ( lab_stat_b );
    end r_lab_stat_b;

    function r_lab_stat_g return varchar2 is
    begin
        return ( lab_stat_g );
    end r_lab_stat_g;

    function r_lab_stat_f return varchar2 is
    begin
        return ( lab_stat_f );
    end r_lab_stat_f;

    function r_lgr_transp_std_prio_ms return varchar2 is
    begin
        return ( lgr_transp_std_prio_ms );
    end r_lgr_transp_std_prio_ms;

    function r_lgr_transp_std_prio_wa return varchar2 is
    begin
        return ( lgr_transp_std_prio_wa );
    end r_lgr_transp_std_prio_wa;

    function r_lgr_transp_std_prio_we return varchar2 is
    begin
        return ( lgr_transp_std_prio_we );
    end r_lgr_transp_std_prio_we;

    function r_lgr_transp_std_prio_ul return varchar2 is
    begin
        return ( lgr_transp_std_prio_ul );
    end r_lgr_transp_std_prio_ul;

    function r_lgr_transp_std_prio_ff return varchar2 is
    begin
        return ( lgr_transp_std_prio_ff );
    end r_lgr_transp_std_prio_ff;

    function r_max_anz_liefs_tage return number is
    begin
        return ( max_anz_liefs_tage );
    end r_max_anz_liefs_tage;

    function r_fmid_quelle_existiert_nicht return integer is
    begin
        return ( fmid_quelle_existiert_nicht );
    end r_fmid_quelle_existiert_nicht;

    function r_fmid_ziel_existiert_nicht return integer is
    begin
        return ( fmid_ziel_existiert_nicht );
    end r_fmid_ziel_existiert_nicht;

    function r_fmid_lte_id_null return integer is
    begin
        return ( fmid_lte_id_null );
    end r_fmid_lte_id_null;

    function r_fmid_lte_id_schon_vorhanden return integer is
    begin
        return ( fmid_lte_id_schon_vorhanden );
    end r_fmid_lte_id_schon_vorhanden;

    function r_fmid_quellkanal_leer return integer is
    begin
        return ( fmid_quellkanal_leer );
    end r_fmid_quellkanal_leer;

    function r_fmid_quelle_nicht_belegt return integer is
    begin
        return ( fmid_quelle_nicht_belegt );
    end r_fmid_quelle_nicht_belegt;

    function r_fmid_ziel_voll return integer is
    begin
        return ( fmid_ziel_voll );
    end r_fmid_ziel_voll;

    function r_fmid_artikelnummer_fehlt return integer is
    begin
        return ( fmid_artikelnummer_fehlt );
    end r_fmid_artikelnummer_fehlt;

    function r_fmid_palettetyp_fehlt return integer is
    begin
        return ( fmid_palettetyp_fehlt );
    end r_fmid_palettetyp_fehlt;

    function r_fmid_lagerplatz_gesperrt return integer is
    begin
        return ( fmid_lagerplatz_gesperrt );
    end r_fmid_lagerplatz_gesperrt;

    function r_fmid_platz_kein_we return integer is
    begin
        return ( fmid_platz_kein_we );
    end r_fmid_platz_kein_we;

    function r_fmid_lte_id_fehlt return integer is
    begin
        return ( fmid_lte_id_fehlt );
    end r_fmid_lte_id_fehlt;

    function r_fmid_lager_platz_fehlt return integer is
    begin
        return ( fmid_lager_platz_fehlt );
    end r_fmid_lager_platz_fehlt;

    function r_fmid_falscher_lte_status return integer is
    begin
        return ( fmid_falscher_lte_status );
    end r_fmid_falscher_lte_status;

    function r_fmid_platz_nicht_io return integer is
    begin
        return ( fmid_platz_nicht_io );
    end r_fmid_platz_nicht_io;

    function r_fmid_lte_hat_transport return integer is
    begin
        return ( fmid_lte_hat_transport );
    end r_fmid_lte_hat_transport;

    function r_fmid_lte_falscher_platz return integer is
    begin
        return ( fmid_lte_falscher_platz );
    end r_fmid_lte_falscher_platz;

    function r_fmid_weg_von_nach_falsch return integer is
    begin
        return ( fmid_weg_von_nach_falsch );
    end r_fmid_weg_von_nach_falsch;

    function r_fmid_falscher_lte_type return integer is
    begin
        return ( fmid_falscher_lte_type );
    end r_fmid_falscher_lte_type;

    function r_fmid_falsche_temperatur return integer is
    begin
        return ( fmid_falsche_temperatur );
    end r_fmid_falsche_temperatur;

    function r_fmid_falsche_wertklasse return integer is
    begin
        return ( fmid_falsche_wertklasse );
    end r_fmid_falsche_wertklasse;

    function r_fmid_falsche_gefahrenklasse return integer is
    begin
        return ( fmid_falsche_gefahrenklasse );
    end r_fmid_falsche_gefahrenklasse;

    function r_fmid_lte_ist_zu_schwer return integer is
    begin
        return ( fmid_lte_ist_zu_schwer );
    end r_fmid_lte_ist_zu_schwer;

    function r_fmid_lte_zu_gross return integer is
    begin
        return ( fmid_lte_zu_gross );
    end r_fmid_lte_zu_gross;

    function r_fmid_lgr_type_unbekannt return integer is
    begin
        return ( fmid_lgr_type_unbekannt );
    end r_fmid_lgr_type_unbekannt;

    function r_fmid_keine_lagerorte return integer is
    begin
        return ( fmid_keine_lagerorte );
    end r_fmid_keine_lagerorte;

    function r_fmid_kein_platz_fuer_lte return integer is
    begin
        return ( fmid_kein_platz_fuer_lte );
    end r_fmid_kein_platz_fuer_lte;

    function r_fmid_falscher_bearbmodul return integer is
    begin
        return ( fmid_falscher_bearbmodul );
    end r_fmid_falscher_bearbmodul;

    function r_fmid_falsche_buchungsart return integer is
    begin
        return ( fmid_falsche_buchungsart );
    end r_fmid_falsche_buchungsart;

    function r_fmid_zuggang_buchen return integer is
    begin
        return ( fmid_zuggang_buchen );
    end r_fmid_zuggang_buchen;

    function r_fmid_alle_fahrz_ausgelastet return integer is
    begin
        return ( fmid_alle_fahrz_ausgelastet );
    end r_fmid_alle_fahrz_ausgelastet;

    function r_fmid_kein_fahrz_bereit_orte return integer is
    begin
        return ( fmid_kein_fahrz_bereit_orte );
    end r_fmid_kein_fahrz_bereit_orte;

    function sql_count (
        in_nr     in integer,
        in_gleich in varchar2,
        in_ts     in timestamp
    ) return integer is
    begin
        if v_ts is null
           or v_ts != in_ts then
            v_ts := in_ts;
            v_nr := in_nr;
            v_gleich := nvl(in_gleich, c.leer);
        else
            if
                v_ts = in_ts
                and v_gleich != nvl(in_gleich, c.leer)
            then
                v_gleich := nvl(in_gleich, c.leer);
                v_nr := v_nr + 1;
            end if;
        end if;

        return ( v_nr );
    end sql_count;

    function decode_lgr_sperre (
        gesperrt in lvs_lgr.gesperrt%type
    ) return varchar2 is
    begin
        if gesperrt = c.lgr_gesperrt_f then
            return ( c.lgr_gesperrt_txt_f );
        end if;
        if gesperrt = c.lgr_gesperrt_g then
            return ( c.lgr_gesperrt_txt_g );
        end if;
        return ( gesperrt );
    end;

    function decode_lgr_sperre_farbe (
        gesperrt in lvs_lgr.gesperrt%type
    ) return varchar2 is
    begin
        if gesperrt = c.lgr_gesperrt_f then
            return ( c.lgr_gesperrt_txt_f || c.lgr_gesperrt_col_f );
        end if;

        if gesperrt = c.lgr_gesperrt_g then
            return ( c.lgr_gesperrt_txt_g || c.lgr_gesperrt_col_g );
        end if;

        return ( gesperrt );
    end;

    function decode_labor_status (
        labor_status in lvs_lam.labor_status%type
    ) return varchar2 is
    begin
        if labor_status = c.lab_stat_q then
            return ( c.lab_stat_txt_q );
        end if;
        if labor_status = c.lab_stat_u then
            return ( c.lab_stat_txt_u );
        end if;
        if labor_status = c.lab_stat_b then
            return ( c.lab_stat_txt_b );
        end if;
        if labor_status = c.lab_stat_g then
            return ( c.lab_stat_txt_g );
        end if;
        if labor_status = c.lab_stat_f then
            return ( c.lab_stat_txt_f );
        end if;
        return ( labor_status );
    end;

    function decode_labor_status_farbe (
        labor_status in lvs_lam.labor_status%type
    ) return varchar2 is
    begin
        if labor_status = c.lab_stat_q then
            return ( c.lab_stat_txt_q || c.lab_stat_col_q );
        end if;

        if labor_status = c.lab_stat_u then
            return ( c.lab_stat_txt_u || c.lab_stat_col_u );
        end if;

        if labor_status = c.lab_stat_b then
            return ( c.lab_stat_txt_b || c.lab_stat_col_b );
        end if;

        if labor_status = c.lab_stat_g then
            return ( c.lab_stat_txt_g || c.lab_stat_col_g );
        end if;

        if labor_status = c.lab_stat_f then
            return ( c.lab_stat_txt_f || c.lab_stat_col_f );
        end if;

        return ( labor_status );
    end;

end c;
/


-- sqlcl_snapshot {"hash":"b7b876ffd3f5b149ccd6ba5a9b74a01bf7aa7d9c","type":"PACKAGE_BODY","name":"C","schemaName":"DIRKSPZM32","sxml":""}