create or replace 
procedure DIRKSPZM32.mb_crt_lgr_fuer_res is
  -- Local variables here
  v_res isi_resource%rowtype;
  CURSOR c_res is
    select *
      from isi_resource r
     where r.typ = 'MS';
begin
  OPEN c_res;
  LOOP
    FETCH c_res into v_res;
    EXIT when c_res%NOTFOUND;
    begin
      insert into lvs_lgr
        values(v_res.sid,
               v_res.firma_nr,
               v_res.res_ext_name,
               v_res.res_ext_name,
               1, -- to_number(t.lgr_l) lgr_ort,
               1,
               1,
               v_res.res_name,
               2,
               1,
               to_number(
               lpad(1, 4, '0') || lpad(1, 4, '0') || lpad(v_res.res_name, 4, '0')
                                     || lpad(2, 4, '0') || lpad(1, 4, '0')), -- lgr_dim_platz,
               1, -- lgr_dim_fifo_nr,
               'BKL1', -- lgr_typ, --t.lgr_ltyp,
               'WE', -- lgr_verwendung,
               'A', -- lgr_res_strat,
               --t.lgr_masseinheit,
               999999, -- lgr_vol_hoehe,
               999999, -- lgr_vol_breite,
               999999, -- lgr_vol_tiefe,
               999999, -- lgr_frei_hoehe,
               999999, -- lgr_frei_breite,
               999999, -- lgr_frei_tiefe,
               999999, -- lgr_max_te,
               0, -- lgr_akt_te,
               0, -- lgr_dispo_einl_te,
               0, -- lgr_dispo_ausl_te,
               999999, -- lgr_max_kg,
               0, -- lgr_akt_kg,
               0, -- lgr_dispo_einl_kg,
               0, -- lgr_dispo_ausl_kg,
               sysdate, -- lgr_dat_erstellt,
               0, -- lgr_usr_id_erstellt,
               NULL, -- lgr_dat_erst_belegt,
               null, -- lgr_dat_l_inventur,
               null, -- res_ls_login_name, -- ?? Keine statische reservierung für User
               NULL, -- res_artikel_id, -- !! lookup isi_artikel
               null, -- res_string,
               'F', -- gesperrt, -- !! decode
               null, -- gesp_grund,
               1, -- abc,
               null, -- gruppe,
               0, -- wert_klasse,
               0, -- gefahren_klasse,
               1, -- hrl_lag_max_pal_a,
               1, -- hrl_lag_max_pal_i,
               null, -- lte_namen,
               null, -- lte_namen_cfg,
               null, -- lgr_platz_gruppe_gegenueber,
               '20', -- lgr_temp,
               'FW;HW;RW;', -- waren_typen_cfg,
               'F', -- res_art_statisch, --!! decode
               999999, -- lgr_einl_te_verfueg,
               'F', -- res_res_string_statisch,
               0, -- lgr_order_res_te, -- !!
               0, -- lgr_gruppe_id,
               null, -- aktivierung_prio,
               'T', -- uml_erlaubt,
               null, -- anz_uml,
               null, -- lgr_verwendung_proj,
               0, -- lgr_dispo_einl_frei_hoehe,
               null, -- akt_inventur_id,
               null, -- letzte_inventur_id,
               null,
               null,
               null, -- lgr_platz_eti_pfeil_richt,
               'F', -- flaechen_stellplatz,
               null, -- wa_menge_ueberlief,
               null, -- LGR_EINL_TE_VERFUEG_GRUPPE
               null, -- wa_typ
               null,  -- POS_X
               null, -- POS_Y
               null, -- LGR_MIN_LTE_HOEHE	N	NUMBER	Y			Minimale Hoehe der LTE in diesem Lagerplatz in mm
               null, -- LGR_MIN_LTE_BREITE	N	NUMBER	Y			Minimale Breite der LTE in diesem Lagerplatz in mm
               null, -- LGR_MIN_LTE_TIEFE	N	NUMBER	Y			Minimale Tiefe der LTE in diesem Lagerplatz in mm
               null, -- OWNER_ADDRESS_ID	N	NUMBER	Y			ID in der ISI_ADRESSEN für KONSI. Ist der Wert != NULL dann ist die Adresse dieser ID Eigentümer der Ware
               null, -- LGR_KG_GRUPPE	N	VARCHAR2(30)	Y			Gruppe für Prozentsatz in KG die eingelagert werden dürfen (Wird beim Anlegen mit DIM_GANG, Regal und Platz gefüllt)
               'LTE', -- TRANSPORT_EINHEIT	N	VARCHAR2(10)	N	'LTE'		Transportierte Ware 'LTE' = Alle LTE_CFG, 'LHM' = Alle LHM_CFG, 'LTE_LTE' = LTE_CFG vom Transporttyp LTE oder 'LTE_LHM' = LTE_CFG vom Transporttyp LHM
               sysdate, -- CHANGE_DATE	N	DATE	N	sysdate		Datum letzte Änderung
               -1,      -- CHANGE_LOGIN_ID	N	NUMBER	Y			Login ID letzte Änderung (Wird z.Zt. nicht gefüllt)
               NULL);   -- EINL_ORT_DEFAULT_LISTE	N	VARCHAR2(100)	Y			Liste der Einlagerorte, die als default auf diesem Platz genommen werden. Bsp.: 001;101;201 = In dieser Reihenfloge sollen die Platzsuche erfolgen. Also erst in 1 dann in 101 und dann in 
               

    exception
      when others then NULL;
    end;
    begin
      insert into lvs_lgr
        values(v_res.sid,
               v_res.firma_nr,
               '1.' || v_res.res_name,
               '1.' || v_res.res_name,
               1, -- to_number(t.lgr_l) lgr_ort,
               1,
               1,
               v_res.res_name,
               1,
               1,
               to_number(
               lpad(1, 4, '0') || lpad(1, 4, '0') || lpad(v_res.res_name, 4, '0')
                                     || lpad(1, 4, '0') || lpad(1, 4, '0')), -- lgr_dim_platz,
               1, -- lgr_dim_fifo_nr,
               'BKL1', -- lgr_typ, --t.lgr_ltyp,
               'WA', -- lgr_verwendung,
               'A', -- lgr_res_strat,
               --t.lgr_masseinheit,
               999999, -- lgr_vol_hoehe,
               999999, -- lgr_vol_breite,
               999999, -- lgr_vol_tiefe,
               999999, -- lgr_frei_hoehe,
               999999, -- lgr_frei_breite,
               999999, -- lgr_frei_tiefe,
               999999, -- lgr_max_te,
               0, -- lgr_akt_te,
               0, -- lgr_dispo_einl_te,
               0, -- lgr_dispo_ausl_te,
               999999, -- lgr_max_kg,
               0, -- lgr_akt_kg,
               0, -- lgr_dispo_einl_kg,
               0, -- lgr_dispo_ausl_kg,
               sysdate, -- lgr_dat_erstellt,
               0, -- lgr_usr_id_erstellt,
               NULL, -- lgr_dat_erst_belegt,
               null, -- lgr_dat_l_inventur,
               null, -- res_ls_login_name, -- ?? Keine statische reservierung für User
               NULL, -- res_artikel_id, -- !! lookup isi_artikel
               null, -- res_string,
               'F', -- gesperrt, -- !! decode
               null, -- gesp_grund,
               1, -- abc,
               null, -- gruppe,
               0, -- wert_klasse,
               0, -- gefahren_klasse,
               1, -- hrl_lag_max_pal_a,
               1, -- hrl_lag_max_pal_i,
               null, -- lte_namen,
               null, -- lte_namen_cfg,
               null, -- lgr_platz_gruppe_gegenueber,
               '20', -- lgr_temp,
               'FW;HW;RW;', -- waren_typen_cfg,
               'F', -- res_art_statisch, --!! decode
               999999, -- lgr_einl_te_verfueg,
               'F', -- res_res_string_statisch,
               0, -- lgr_order_res_te, -- !!
               0, -- lgr_gruppe_id,
               null, -- aktivirung_prio,
               'T', -- uml_erlaubt,
               null, -- anz_uml,
               null, -- lgr_verwendung_proj,
               0, -- lgr_dispo_einl_frei_hoehe,
               null, -- akt_inventur_id,
               null, -- letzte_inventur_id,
               null,
               null,
               null, -- lgr_platz_eti_pfeil_richt,
               'F', -- flaechen_stellplatz,
               null, -- wa_menge_ueberlief,
               null, -- LGR_EINL_TE_VERFUEG_GRUPPE);
               null, -- wa_typ
               null,  -- POS_X
               null, -- POS_Y
               null, -- LGR_MIN_LTE_HOEHE	N	NUMBER	Y			Minimale Hoehe der LTE in diesem Lagerplatz in mm
               null, -- LGR_MIN_LTE_BREITE	N	NUMBER	Y			Minimale Breite der LTE in diesem Lagerplatz in mm
               null, -- LGR_MIN_LTE_TIEFE	N	NUMBER	Y			Minimale Tiefe der LTE in diesem Lagerplatz in mm
               null, -- OWNER_ADDRESS_ID	N	NUMBER	Y			ID in der ISI_ADRESSEN für KONSI. Ist der Wert != NULL dann ist die Adresse dieser ID Eigentümer der Ware
               null, -- LGR_KG_GRUPPE	N	VARCHAR2(30)	Y			Gruppe für Prozentsatz in KG die eingelagert werden dürfen (Wird beim Anlegen mit DIM_GANG, Regal und Platz gefüllt)
               'LTE', -- TRANSPORT_EINHEIT	N	VARCHAR2(10)	N	'LTE'		Transportierte Ware 'LTE' = Alle LTE_CFG, 'LHM' = Alle LHM_CFG, 'LTE_LTE' = LTE_CFG vom Transporttyp LTE oder 'LTE_LHM' = LTE_CFG vom Transporttyp LHM
               sysdate, -- CHANGE_DATE	N	DATE	N	sysdate		Datum letzte Änderung
               -1,      -- CHANGE_LOGIN_ID	N	NUMBER	Y			Login ID letzte Änderung (Wird z.Zt. nicht gefüllt)
               NULL);   -- EINL_ORT_DEFAULT_LISTE	N	VARCHAR2(100)	Y			Liste der Einlagerorte, die als default auf diesem Platz genommen werden. Bsp.: 001;101;201 = In dieser Reihenfloge sollen die Platzsuche erfolgen. Also erst in 1 dann in 101 und dann in 


               
    exception
      when others then NULL;
    end;
    update isi_resource r
        set r.lager_roh = '1.' || v_res.res_name,
            r.lager_fertig = v_res.res_ext_name
      where r.res_id = v_res.res_id;
  end LOOP;

  CLOSE c_res;
end;
/



-- sqlcl_snapshot {"hash":"aacb73f124d3a86dd661d63ba1292eb2737fb5d9","type":"PROCEDURE","name":"MB_CRT_LGR_FUER_RES","schemaName":"DIRKSPZM32","sxml":""}