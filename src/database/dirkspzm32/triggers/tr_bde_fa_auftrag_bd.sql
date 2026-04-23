create or replace editionable trigger dirkspzm32.tr_bde_fa_auftrag_bd before
    delete on dirkspzm32.bde_fa_auftrag
    for each row
declare
    v_lte_id lvs_lte.lte_id%type;
    v_result number;
    cursor c_lam_lte_id is
    select
        l.lte_id
    from
        lvs_lam l
    where
        l.order_pos_auf_id = :old.auf_id
    group by
        l.lte_id;

begin
    delete bde_fa_auftrag_hist t
    where
            t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.leitzahl = :old.leitzahl
        and t.fa_ag = :old.fa_ag
        and t.fa_upos = :old.fa_upos;

    delete bde_fa_auftrag_stl t
    where
            t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.leitzahl = :old.leitzahl
        and t.fa_ag = :old.fa_ag
        and t.fa_upos = :old.fa_upos;

    delete bde_fa_auftrag_fhm t
    where
            t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.leitzahl = :old.leitzahl
        and t.fa_ag = :old.fa_ag
        and t.fa_upos = :old.fa_upos;

    delete bde_fa_auftrag_rel t
    where
            t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.leitzahl = :old.leitzahl
        and t.fa_ag = :old.fa_ag
        and t.fa_upos = :old.fa_upos;

    delete bde_fa_auftrag_res_liste t
    where
            t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.leitzahl = :old.leitzahl
        and t.fa_ag = :old.fa_ag
        and t.fa_upos = :old.fa_upos;

    begin
        if :old.ma_reserviert = c.c_true then
            open c_lam_lte_id;
            loop
                fetch c_lam_lte_id into v_lte_id;
                exit when c_lam_lte_id%notfound;
                v_result := lvs_ausl.lvs_lte_res_rueck(:old.sid,
                                                       :old.firma_nr,
                                                       :old.leitzahl,
                                                       :old.auf_id,
                                                       v_lte_id,
                                                       :old.leitzahl,
                                                       :old.auf_id,
                                                       c.c_true);

            end loop;

            close c_lam_lte_id;
        end if;
    exception
        when others then
            null;  -- Hier kann eigentlich nicht schlimmes passieren. Ein Fehler hier wuerde die reservierung um Rohstoff nicht zurücksetzten
    end;

    insert into bde_fa_auftrag_hist values ( :old.sid,
                                             :old.firma_nr,
                                             :old.abnr,
                                             :old.leitzahl,
                                             :old.fa_ag,
                                             :old.fa_upos,
                                             :old.satzart,
                                             :old.res_id,
                                             :old.anz_res,
                                             :old.ab_artikel_id,
                                             :old.ab_soll_mg,
                                             :old.ab_ist_mg,
                                             :old.ab_text1,
                                             :old.ab_text2,
                                             :old.ab_text3,
                                             :old.ab_ende_status,
                                             :old.ag_soll_mg,
                                             :old.ag_ist_mg,
                                             :old.ag_ist_mg_b,
                                             :old.ag_ist_mg_schrott,
                                             :old.ag_ist_mg_ruesten,
                                             :old.ruest_zeit_gepl,
                                             :old.ruest_zeit_ist,
                                             :old.prod_zeit_gepl,
                                             :old.prod_zeit_ist,
                                             :old.stoer_zeit_gepl,
                                             :old.stoer_zeit_ist,
                                             :old.zeit_einheit,
                                             :old.termin_start_gepl,
                                             :old.termin_ende_gepl,
                                             :old.termin_start_ist,
                                             :old.termin_ende_ist,
                                             :old.freig_status,
                                             :old.freig_wer,
                                             :old.freig_wann,
                                             :old.status_res_id,
                                             :old.status_id,
                                             :old.status_begin,
                                             :old.kunden_nr,
                                             :old.ag_artikel_id,
                                             :old.kd_art_nr,
                                             :old.ag_bez1,
                                             :old.ag_bez2,
                                             :old.ag_text1,
                                             :old.ag_text2,
                                             :old.ag_text3,
                                             :old.zeichnung,
                                             :old.schrott_proz,
                                             :old.nutzen,
                                             :old.gewicht,
                                             :old.schrott,
                                             :old.verbrauch,
                                             :old.einsatz,
                                             :old.max_takt_ausf_zeit,
                                             :old.min_takt_zeit,
                                             :old.max_takt_zeit,
                                             :old.status_freigabe,
                                             :old.ag_id,
                                             :old.charge_id,
                                             :old.kenz_letzt_ag,
                                             :old.zeichnung_index,
                                             :old.lhm_name,
                                             :old.lhm_menge,
                                             :old.lte_name,
                                             :old.lte_menge,
                                             :old.best_nr_kunde,
                                             :old.kenz_lhm_druck,
                                             :old.mde_ist_mg,
                                             :old.mde_ist_mg_b,
                                             :old.mde_ist_mg_schrott,
                                             :old.mde_ist_mg_ruesten,
                                             :old.mde_micro_stop,
                                             :old.mde_ist_mg_t,
                                             :old.mde_ist_mg_b_t,
                                             :old.mde_ist_mg_schrott_t,
                                             :old.mde_ist_mg_ruesten_t,
                                             :old.mde_micro_stop_t,
                                             :old.lte_lhm_lagen,
                                             :old.lte_lhm_pro_lage,
                                             :old.lte_anz,
                                             :old.lte_anz_ist,
                                             :old.lhm_anz,
                                             :old.lhm_anz_ist,
                                             :old.abfuell_abschalt_grob,
                                             :old.abfuell_abschalt_mittel,
                                             :old.abfuell_abschalt_fein,
                                             :old.abfuell_toleranz_plus,
                                             :old.abfuell_toleranz_minus,
                                             :old.abfuell_silo,
                                             :old.abfuell_soll,
                                             :old.prod_params,
                                             :old.nio_res_id,
                                             :old.quitt_gruppe_ag,
                                             :old.prod_menge_p_einheit,
                                             :old.prod_menge_p_einheit_op,
                                             :old.kunden_nr_adr_liefer,
                                             :old.ag_los_mg,
                                             :old.rcv_ag_ist_mg,
                                             :old.rcv_ag_ist_mg_b,
                                             :old.rcv_ag_ist_mg_schrott,
                                             :old.rcv_ag_ist_mg_ruesten,
                                             :old.rcv_ruest_zeit_ist,
                                             :old.rcv_prod_zeit_ist,
                                             :old.rcv_stoer_zeit_ist,
                                             :old.ag_los_ist_mg,
                                             :old.packschema_kopf_id,
                                             :old.ag_art_laenge,                                                        -- AG_ART_LAENGE N NUMBER(12,3)  Y     Länge
                                             :old.ag_art_breite,                                                        -- AG_ART_BREITE N NUMBER(12,3)  Y     Breite
                                             :old.ag_art_dicke,                                                         -- AG_ART_DICKE  N NUMBER(12,3)  Y     Dicke
                                             :old.ag_art_durch,                                                         -- AG_ART_DURCH  N NUMBER(12,3)  Y     Durchmesser
                                             :old.kunden_ab,                                                            -- KUNDEN_AB N VARCHAR2(20)  Y     AB Nummer des Kundenauftrags
                                             :old.kunden_ab_pos,                                                        -- KUNDEN_AB_POS N VARCHAR2(20)  Y     AB Positionsnummer des Kundenauftrags
                                             :old.kunden_ab_upos,                                                       -- KUNDEN_AB_UPOS  N VARCHAR2(20)  Y     AB Unterposition des Kundenauftrags
                                             :old.term_wunsch,                                                          -- TERM_WUNSCH N DATE  Y     Wunschtermin in dd.mm.yyyy hh24:mi:ss
                                             :old.term_best,                                                            -- TERM_BEST N DATE  Y     Bestätigter Termin in dd.mm.yyyy hh24:mi:ss
                                             :old.transp_zeit,                                                          -- TRANSP_ZEIT N NUMBER(5) Y     Transportzeit für die Lieferung zum Kunden in STD
                                             :old.anz_rohstoffe,                                                        -- ANZ_ROHSTOFFE N NUMBER(3) Y     Anzahl der benötigten Drähte
                                             :old.ausgef_ende,                                                          -- AUSGEF_ENDE N VARCHAR2(1) Y     AUSGEFÜHRTES ENDE
                                             :old.ag_prod_frei,                                                         -- AG_PROD_FREI  N VARCHAR2(1) Y     T = Freigegeben für Produktion, F = Nur für Planung
                                             :old.ag_ueberlappen,                                                       -- AG_UEBERLAPPEN  N NUMBER(12,3)  Y     Anzahl die fertig sein müssen, um den  nächsten AG zu beginnen nächsten AG zu beginnen"""""
                                             :old.ag_opt_grp,                                                           -- AG_OPT_GRP  N VARCHAR2(50)  Y     Rüstgruppe zur optimierung im APS
                                             :old.prioritaet,
                                             :old.vorgangsqualifikation,
                                             :old.anz_mitarbeiter,
                                             :old.lueckenfueller,
                                             :old.termin_start_frueh,
                                             :old.start_batch_by_order_start,
                                             :old.ext_arbeits_anweisung,
                                             :old.job_sequenz,
                                             :old.kunden_ab_text,
                                             :old.ruest_zeit_erf,
                                             :old.prod_zeit_erf,
                                             :old.stoer_zeit_erf,
                                             :old.termin_start_erf,
                                             :old.termin_ende_erf,
                                             :old.kategorie,
                                             :old.auf_id,
                                             'F',                             -- MA_RESERVIERT N VARCHAR2(1) Y     Ist der Rohstoff (Materialanforderung) Reserviert T=Ist Reserviert, F=Ist nicht reserviert
                                             0,                               -- MA_RES_MENGE  N NUMBER  Y     Welche Menge  Rohstoff (Materialanforderung) ist Reserviert
                                             null,                            -- MA_RES_CHARGE_ID  N NUMBER  Y     Wenn ID gefüllt, dann muss Chargenrein der Rohstoff verwendet werden
                                             null,                            -- MA_HERSTELLER_KUERZEL_LISTE N VARCHAR2(100) Y     Wenn Herstelle-Rein, dann ist hier der Hersteller als Liste hinterlegt Wert mit ;
                                             0,                               -- MA_RES_MENGE_KOMM N NUMBER  Y     Welche Menge  Rohstoff wurde berreitgestellt / Kommissioniert
                                             :old.adress_id,
                                             :old.lohn_arbeit,
                                             :old.created_date,
                                             :old.created_login_id,
                                             :old.last_change_date,
                                             :old.last_change_login_id,
                                             :old.rcv_ruest_zeit_erf,         -- RCV_RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden übertragen
                                             :old.rcv_prod_zeit_erf,          -- RCV_PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden übertragen
                                             :old.seq_nr,                     -- SEQ_NR  N NUMBER  Y     N   Sequenz-Nummer, für das Zielprodukt auf der Fertigungslinie Montage - Ab DB31
                                             :old.lead_leitzahl,              -- LEAD_LEITZAHL N NUMBER  Y     N   Leitzahl des vorlaeferauftrag
                                             :old.primaer_leitzahl,
                                             :old.nr_pruefung,
                                             :old.fremd_zeichnung,            -- FREMD_ZEICHNUNG N VARCHAR2(30)  Y     N   Externe Zeichnung
                                             :old.zeichnungname               -- ZEICHNUNGNAME N VARCHAR2(255) Y     N   Zeichnungsname (*.TIF)
                                              );

end tr_bde_fa_auftrag_bd;
/

alter trigger dirkspzm32.tr_bde_fa_auftrag_bd enable;


-- sqlcl_snapshot {"hash":"19f1e623821afe5c1b30453e3a7bb9366ee9c380","type":"TRIGGER","name":"TR_BDE_FA_AUFTRAG_BD","schemaName":"DIRKSPZM32","sxml":""}