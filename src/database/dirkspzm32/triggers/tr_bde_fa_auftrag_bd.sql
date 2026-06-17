
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_FA_AUFTRAG_BD" 
  before delete on DIRKSPZM32.BDE_FA_AUFTRAG
  for each row
declare
  v_lte_id                      lvs_lte.lte_id%type;
  v_result                      number;

  CURSOR c_lam_lte_id is
    select l.lte_id
      from lvs_lam l
     where l.order_pos_auf_id = :old.auf_id
     group by l.lte_id;

begin
  delete bde_fa_auftrag_hist t
    where t.sid          = :old.SID
      and t.firma_nr     = :old.FIRMA_NR
      and t.leitzahl     = :old.LEITZAHL
      and t.fa_ag        = :old.FA_AG
      and t.fa_upos      = :old.FA_UPOS;

  delete bde_fa_auftrag_stl t
    where t.sid          = :old.SID
      and t.firma_nr     = :old.FIRMA_NR
      and t.leitzahl     = :old.LEITZAHL
      and t.fa_ag        = :old.FA_AG
      and t.fa_upos      = :old.FA_UPOS;

  delete bde_fa_auftrag_fhm t
    where t.sid          = :old.SID
      and t.firma_nr     = :old.FIRMA_NR
      and t.leitzahl     = :old.LEITZAHL
      and t.fa_ag        = :old.FA_AG
      and t.fa_upos      = :old.FA_UPOS;

  delete bde_fa_auftrag_rel t
    where t.sid          = :old.SID
      and t.firma_nr     = :old.FIRMA_NR
      and t.leitzahl     = :old.LEITZAHL
      and t.fa_ag        = :old.FA_AG
      and t.fa_upos      = :old.FA_UPOS;

  delete bde_fa_auftrag_res_liste t
    where t.sid          = :old.SID
      and t.firma_nr     = :old.FIRMA_NR
      and t.leitzahl     = :old.LEITZAHL
      and t.fa_ag        = :old.FA_AG
      and t.fa_upos      = :old.FA_UPOS;

  begin
    if :old.ma_reserviert = c.C_TRUE
    then
      OPEN c_lam_lte_id;
      LOOP
        FETCH c_lam_lte_id into v_lte_id;
        EXIT when c_lam_lte_id%notfound;
        v_result := lvs_ausl.lvs_lte_res_rueck(:old.sid,
                                               :old.firma_nr,
                                               :old.leitzahl,
                                               :old.auf_id,
                                               v_lte_id,
                                               :old.leitzahl,
                                               :old.auf_id,
                                               c.C_TRUE);

      end LOOP;
      CLOSE c_lam_lte_id;
    end if;
  exception
    when others then NULL;  -- Hier kann eigentlich nicht schlimmes passieren. Ein Fehler hier wuerde die reservierung um Rohstoff nicht zurücksetzten
  end;

  insert into bde_fa_auftrag_hist
    values (:old.SID,
            :old.FIRMA_NR,
            :old.ABNR,
            :old.LEITZAHL,
            :old.FA_AG,
            :old.FA_UPOS,
            :old.SATZART,
            :old.RES_ID,
            :old.ANZ_RES,
            :old.AB_ARTIKEL_ID,
            :old.AB_SOLL_MG,
            :old.AB_IST_MG,
            :old.AB_TEXT1,
            :old.AB_TEXT2,
            :old.AB_TEXT3,
            :old.AB_ENDE_STATUS,
            :old.AG_SOLL_MG,
            :old.AG_IST_MG,
            :old.AG_IST_MG_B,
            :old.AG_IST_MG_SCHROTT,
            :old.AG_IST_MG_RUESTEN,
            :old.RUEST_ZEIT_GEPL,
            :old.RUEST_ZEIT_IST,
            :old.PROD_ZEIT_GEPL,
            :old.PROD_ZEIT_IST,
            :old.STOER_ZEIT_GEPL,
            :old.STOER_ZEIT_IST,
            :old.ZEIT_EINHEIT,
            :old.TERMIN_START_GEPL,
            :old.TERMIN_ENDE_GEPL,
            :old.TERMIN_START_IST,
            :old.TERMIN_ENDE_IST,
            :old.FREIG_STATUS,
            :old.FREIG_WER,
            :old.FREIG_WANN,
            :old.STATUS_RES_ID,
            :old.STATUS_ID,
            :old.STATUS_BEGIN,
            :old.KUNDEN_NR,
            :old.AG_ARTIKEL_ID,
            :old.KD_ART_NR,
            :old.AG_BEZ1,
            :old.AG_BEZ2,
            :old.AG_TEXT1,
            :old.AG_TEXT2,
            :old.AG_TEXT3,
            :old.ZEICHNUNG,
            :old.SCHROTT_PROZ,
            :old.NUTZEN,
            :old.GEWICHT,
            :old.SCHROTT,
            :old.VERBRAUCH,
            :old.EINSATZ,
            :old.MAX_TAKT_AUSF_ZEIT,
            :old.MIN_TAKT_ZEIT,
            :old.MAX_TAKT_ZEIT,
            :old.STATUS_FREIGABE,
            :old.AG_ID,
            :old.CHARGE_ID,
            :old.KENZ_LETZT_AG,
            :old.ZEICHNUNG_INDEX,
            :old.LHM_NAME,
            :old.LHM_MENGE,
            :old.LTE_NAME,
            :old.LTE_MENGE,
            :old.BEST_NR_KUNDE,
            :old.KENZ_LHM_DRUCK,
            :old.MDE_IST_MG,
            :old.MDE_IST_MG_B,
            :old.MDE_IST_MG_SCHROTT,
            :old.MDE_IST_MG_RUESTEN,
            :old.MDE_MICRO_STOP,
            :old.MDE_IST_MG_T,
            :old.MDE_IST_MG_B_T,
            :old.MDE_IST_MG_SCHROTT_T,
            :old.MDE_IST_MG_RUESTEN_T,
            :old.MDE_MICRO_STOP_T,
            :old.LTE_LHM_LAGEN,
            :old.LTE_LHM_PRO_LAGE,
            :old.LTE_ANZ,
            :old.LTE_ANZ_IST,
            :old.LHM_ANZ,
            :old.LHM_ANZ_IST,
            :old.ABFUELL_ABSCHALT_GROB,
            :old.ABFUELL_ABSCHALT_MITTEL,
            :old.ABFUELL_ABSCHALT_FEIN,
            :old.ABFUELL_TOLERANZ_PLUS,
            :old.ABFUELL_TOLERANZ_MINUS,
            :old.ABFUELL_SILO,
            :old.ABFUELL_Soll,
            :old.PROD_PARAMS,
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
            NULL,                            -- MA_RES_CHARGE_ID  N NUMBER  Y     Wenn ID gefüllt, dann muss Chargenrein der Rohstoff verwendet werden
            NULL,                            -- MA_HERSTELLER_KUERZEL_LISTE N VARCHAR2(100) Y     Wenn Herstelle-Rein, dann ist hier der Hersteller als Liste hinterlegt Wert mit ;
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
end TR_BDE_FA_AUFTRAG_BD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_FA_AUFTRAG_BD" ENABLE;


-- sqlcl_snapshot {"hash":"5c55769c43064b6c730627c7fda3aba3cd050e7f","type":"TRIGGER","name":"TR_BDE_FA_AUFTRAG_BD","schemaName":"DIRKSPZM32","sxml":""}