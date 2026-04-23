
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_FA_AUF_BUID" 
  before insert or update  or delete on S_ERP_RCV_FA_AUF
  for each row
declare
  v_artikel                                    isi_artikel%rowtype;
  v_artikel_kunde                              isi_artikel_kunde%rowtype;
  v_fa_auf_fhm                                 s_erp_rcv_fa_auf_fhm%rowtype;

  v_erm_schrott                                s_ERP_rcv_fa_auf.schrott%type;
  v_fa                                         s_rcv_fa_auf%rowtype;
  v_fa_hist                                    bde_fa_auftrag_hist%rowtype;

  v_start_pos number;
  v_ende_pos  number;

  v_found                                      boolean;

  cursor c_fa is
    select *
      from s_rcv_fa_auf t
     where t.leitzahl = :new.leitzahl
       and t.fa_ag = :new.fa_ag
       and t.fa_upos = :new.fa_upos;

  cursor c_fa_hist is
    select *
      from bde_fa_auftrag_hist t
     where t.leitzahl = :new.leitzahl
       and t.fa_ag = :new.fa_ag
       and t.fa_upos = :new.fa_upos;

  cursor c_fa_auf_fhm is
    select *
      from s_erp_rcv_fa_auf_fhm t
     where t.leitzahl = :new.leitzahl
       and t.fa_ag = :new.fa_ag
       and t.fa_upos = :new.fa_upos
       and t.prod_fhm = :new.kunden_ab
       and t.firma_nr = :new.firma_nr;

begin


  if updating or inserting
  then
    if inserting
    and :new.auf_id is NULL
    then
      select SEQ_S_AUFTR.NEXTVAL into :new.auf_id from dual;
    end if;

    if :new.AG_SOLL_MG < 0
    then
     return;
  -- Schrott kommt als MA und damit immer vor den verrichten
      update s_rcv_fa_auf a
         set a.schrott = :new.ag_soll_mg * -1
       where a.firma_nr = :new.FIRMA_NR
         and a.leitzahl = :new.leitzahl
         and a.ag_artikel = :new.ag_artikel
         and a.satzart = 'MA';
      return;
    end if;

    v_artikel_kunde := NULL;
    v_erm_schrott := NULL;

    if :new.SATZART = 'MA'
    then
      v_start_pos := INSTR(:new.prod_param, 'LACK_GRP=', 1, 1);
      if v_start_pos > 0
      then
        return;
      end if;
    end if;

    if :new.SATZART = 'V'
    then
      if :new.KUNDEN_NR is not NULL
      then
        if isi_allg.get_artikel_by_artikel_nr(:new.AG_ARTIKEL, v_artikel)
        then
          if not isi_allg.get_kd_artikel_by_artikel_id('01', v_artikel.artikel_id, :new.KUNDEN_NR, v_artikel_kunde)
          then
             v_artikel_kunde := NULL;
          end if;
        end if;
      end if;
    end if;

    v_fa_hist := NULL;
    OPEN c_fa_hist;
    FETCH c_fa_hist into v_fa_hist;
    CLOSE c_fa_hist;

    OPEN c_fa;
    FETCH c_fa into v_fa;
    v_found := c_fa%FOUND;
    CLOSE c_fa;

    v_start_pos := 0;
    v_fa.prod_params := NULL;
    v_start_pos := INSTR(:new.prod_param, 'OPT_GRP=');
    if v_start_pos > 0
    then
      v_ende_pos := INSTR(:new.prod_param, ';', v_start_pos, 1);
      v_fa.prod_params := substr(:new.prod_param, v_start_pos, v_ende_pos - v_start_pos);
      v_fa.ag_opt_grp :=  substr(:new.prod_param, v_start_pos + 8, v_ende_pos - v_start_pos - 8);
    end if;
    v_start_pos := 0;
    v_start_pos := INSTR(:new.prod_param, 'Q_DAT');
    if v_start_pos > 0
    then  -- Ab hier nur die QDAT-Daten
      if v_fa.prod_params is NULL
      then
        v_fa.prod_params := substr(:new.prod_param, v_start_pos, 3999);
      else
        v_fa.prod_params := substr(v_fa.prod_params || substr(:new.prod_param, v_start_pos), 3999);
      end if;
    end if;

    if inserting
    or (updating
    and not v_found)
    then
      begin
        insert into s_rcv_fa_auf
             values (
                      :new.FIRMA_NR,
                      :new.auf_id,
                      :new.AUFTRAG,
                      :new.LEITZAHL,
                      :new.FA_AG,
                      :new.FA_UPOS,
                      :new.SATZART,
                      :new.MASCHINE,
                      :new.AB_ARTIKEL,
                      :new.AB_SOLL,
                      :new.AB_IST,
                      :new.AB_STATUS,
                      :new.AB_TEXT1,
                      :new.AB_TEXT2,
                      :new.AB_TEXT3,
                      :new.KUNDEN_NR,
                      --decode(:new.SATZART, 'MA', :new.AB_ARTIKEL, :new.AG_ARTIKEL),
                      :new.AG_ARTIKEL,
                      :new.AG_BEZ1,
                      :new.AG_BEZ2,
                      :new.AG_TEXT1,
                      :new.AG_TEXT2,
                      :new.AG_TEXT3,
                      :new.AG_FREIGABE_ST,
                      :new.AG_STATUS,
                      --decode(:new.SATZART, 'MA', :new.AB_SOLL, :new.AG_SOLL_MG),
                      :new.AG_SOLL_MG,
                      :new.AG_IST_MG,
                      :new.AG_IST_MG_B,
                      :new.AG_IST_SCHROTT,
                      :new.AG_IST_RUESTEN,
                      :new.RUEST_ZEIT_GEPL,
                      :new.RUEST_ZEIT_IST,
                      :new.PROD_ZEIT_GEPL,
                      :new.PROD_ZEIT_IST,
                      :new.NUTZEN,
                      :new.GEWICHT,
                      nvl(v_erm_schrott, :new.SCHROTT),
                      :new.VERBRAUCH,
                      :new.EINSATZ,
                      :new.STOER_ZEIT_GEPL,
                      :new.STOER_ZEIT_IST,
                      :new.ZEIT_EINHEIT,
                      :new.START_GEPL,
                      :new.START_IST,
                      :new.ENDE_GEPL,
                      :new.ENDE_IST,
                      :new.ZEICHNUNG,
                      :new.ZEICHNUNG_INDEX,
                      :new.FREMD_ZEICHNUNG,
                      :new.ZEICHNUNGNAME,
                      :new.MAX_TAK_AUSF_ZEIT,
                      :new.MAX_TAK_ZEIT,
                      :new.MIN_TAK_ZEIT,
                      :new.CHARGE,
                      :new.LHM_NAME,
                      :new.LHM_MENGE,
                      :new.LTE_NAME,
                      :new.LTE_MENGE,
                      :new.BEST_NR_KUNDE,
                      :new.KENZ_LHM_DRUCK,
                      NUll,
                      NULL,                -- RES_NAME  VARCHAR2(25)  Y     Maschinenbez.
                      NULL,                -- AG_ID NUMBER  Y     Areitsgang
                      NULL,                -- LTE_LHM_LAGEN NUMBER(2) Y     Aus ISI_ARTIKEL oder Schnittstelle
                      NULL,                -- LTE_LHM_PRO_LAGE  NUMBER(2) Y     Aus ISI_ARTIKEL oder Schnittstelle
                      v_artikel_kunde.kd_art_nr,                -- KD_ART_NR  VARCHAR2(30)  Y     Kundenartikelnummer
                      substr(v_fa.prod_params, 1, 4000),            -- PROD_PARAMS  VARCHAR2(4000)  Y     Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.
                      :new.ag_los_mg,                               -- AG_LOS_MG  NUMBER  Y     Sollmenge in diesem AG die als Produktionsmenge zur Maschiene gesendet werden soll (Teilmenge für dieses Produktionslos)
                      nvl(nvl(:new.rcv_ag_ist_mg, v_fa_hist.rcv_ag_ist_mg), 0),                 -- RCV_AG_IST_MG  NUMBER  Y     Bereits gefertigte Menge in diesem AG die zum HOST gesendet wurde
                      nvl(nvl(:new.rcv_ag_ist_mg_b, v_fa_hist.rcv_ag_ist_mg_b), 0),             -- RCV_AG_IST_MG_B  NUMBER  Y     Angefalle Menge in B-Qualität für diesen AG die zum HOST gesendet wurde
                      nvl(nvl(:new.rcv_ag_ist_mg_schrott, v_fa_hist.rcv_ag_ist_mg_schrott), 0), -- RCV_AG_IST_MG_SCHROTT  NUMBER  Y     Angefalle Schrottmenge für diesen AG die zum HOST gesendet wurde
                      nvl(nvl(:new.rcv_ag_ist_mg_ruesten, v_fa_hist.rcv_ag_ist_mg_ruesten), 0), -- RCV_AG_IST_MG_RUESTEN  NUMBER  Y     Angefalle Menge beim Rüsten und Anfahren für diesen AG die zum HOST gesendet wurde
                      nvl(nvl(:new.rcv_ruest_zeit_ist, v_fa_hist.rcv_ruest_zeit_ist), 0),       -- RCV_RUEST_ZEIT_IST NUMBER  Y     Angefallene Rüstzeit in Minuten die zum HOST gesendet wurde
                      nvl(nvl(:new.rcv_prod_zeit_ist, v_fa_hist.rcv_prod_zeit_ist), 0),         -- RCV_PROD_ZEIT_IST  NUMBER  Y     Angefallene netto Produktionszeit in Minuten die zum HOST gesendet wurde
                      nvl(nvl(:new.rcv_stoer_zeit_ist, v_fa_hist.rcv_stoer_zeit_ist), 0),       -- RCV_STOER_ZEIT_IST NUMBER  Y     Angefallene Ausfallzeiten in Minuten die zum HOST gesendet wurde
                      :new.ag_art_laenge,                                                       -- AG_ART_LAENGE  N NUMBER(12,3)  Y     Länge
                      :new.ag_art_breite,                                                       -- AG_ART_BREITE  N NUMBER(12,3)  Y     Breite
                      :new.ag_art_dicke,                                                        -- AG_ART_DICKE N NUMBER(12,3)  Y     Dicke
                      :new.ag_art_durch,                                                        -- AG_ART_DURCH N NUMBER(12,3)  Y     Durchmesser
                      :new.kunden_ab,                                                           -- KUNDEN_AB  N VARCHAR2(20)  Y     AB Nummer des Kundenauftrags
                      :new.kunden_ab_pos,                                                       -- KUNDEN_AB_POS  N VARCHAR2(20)  Y     AB Positionsnummer des Kundenauftrags
                      :new.kunden_ab_upos,                                                      -- KUNDEN_AB_UPOS N VARCHAR2(20)  Y     AB Unterposition des Kundenauftrags
                      :new.term_wunsch,                                                         -- TERM_WUNSCH  N DATE  Y     Wunschtermin in dd.mm.yyyy hh24:mi:ss
                      :new.term_best,                                                           -- TERM_BEST  N DATE  Y     Bestätigter Termin in dd.mm.yyyy hh24:mi:ss
                      :new.transp_zeit,                                                         -- TRANSP_ZEIT  N NUMBER(5) Y     Transportzeit für die Lieferung zum Kunden in STD
                      :new.anz_rohstoffe,                                                       -- ANZ_ROHSTOFFE  N NUMBER(3) Y     Anzahl der benötigten Drähte
                      :new.ausgef_ende,                                                         -- AUSGEF_ENDE  N VARCHAR2(1) Y     AUSGEFÜHRTES ENDE
                      decode(:new.ab_status,
                             'P', 'N',
                             nvl(:new.ag_prod_frei, 'Y')),                                      -- AG_PROD_FREI N VARCHAR2(1) Y     T = Freigegeben für Produktion, F = Nur für Planung
                      :new.ag_ueberlappen,                                                      -- AG_UEBERLAPPEN N NUMBER(12,3)  Y     """Anzahl die fertig sein müssen, um den nächsten AG zu beginnen nächsten AG zu beginnen"""
                      v_fa.ag_opt_grp,                                                          -- AG_OPT_GRP N VARCHAR2(50)  Y     Rüstgruppe zur optimierung im APS
                      :new.prioritaet,
                      :new.vorgangsqualifikation,
                      :new.anz_mitarbeiter,
                      nvl(:new.lueckenfueller, 'F'),
                      decode (:new.ab_status,
                              'C', 'F',       -- Closed Technisch abgeschlossen
                              'X', 'F',       -- Storniert
                              NULL),          -- FREIG_STATUS N VARCHAR2(3) Y 'N'   "N" = Neuer Auftrag "A" = Kann angefangen werden "AR" Aktuell Rüsten"AP" Aktuell in Produktion, "TF" Teilfertigung gemeldet
                      :new.start_batch_by_order_start,                                           -- Start this Batch
                      :new.ext_arbeits_anweisung,
                      :new.kunden_ab_text,
                      :new.kategorie,
                      :new.seq_nr,            -- SEQ_NR  N NUMBER  Y     N   Sequenz-Nummer, für das Zielprodukt auf der Fertigungslinie Montage - Ab DB31
                      :new.lead_leitzahl,     -- LEAD_LEITZAHL N NUMBER  Y     N   Leitzahl des Vorgängerauftrags
                      :new.primaer_leitzahl   -- PRIMAER_LEITZAHL  N NUMBER  Y     N   Leitzahl des Primärauftrag
                      )
         returning ag_status into :new.ag_status;
         return;
      exception
        when dup_val_on_index then NULL;
      end;
    elsif updating
    then
      :new.auf_id := :old.auf_id;
    end if;



     update s_rcv_fa_auf a
        set a.auftrag = :new.AUFTRAG,
            a.leitzahl = :new.LEITZAHL,
            a.fa_ag = :new.FA_AG,
            a.fa_upos = :new.FA_UPOS,
            a.satzart = :new.SATZART,
            a.maschine = :new.MASCHINE,
            a.ab_artikel = :new.AB_ARTIKEL,
            a.ab_soll = :new.AB_SOLL,
            a.ab_status = :new.AB_STATUS,
            a.ab_text1 = :new.AB_TEXT1,
            a.ab_text2 = :new.AB_TEXT2,
            a.ab_text3 = :new.AB_TEXT3,
            a.kunden_nr = :new.KUNDEN_NR,
            a.ag_artikel = :new.AG_ARTIKEL,
            a.ag_bez1 = :new.AG_BEZ1,
            a.ag_bez2 = :new.AG_BEZ2,
            a.ag_text1 = :new.AG_TEXT1,
            a.ag_text2 = :new.AG_TEXT2,
            a.ag_text3 = :new.AG_TEXT3,
            a.ag_freigabe_st = :new.AG_FREIGABE_ST,
            a.ag_status = :new.AG_STATUS,
            a.ag_soll_mg = :new.AG_SOLL_MG,
            a.ruest_zeit_gepl = :new.RUEST_ZEIT_GEPL,
            a.prod_zeit_gepl = :new.PROD_ZEIT_GEPL,
            a.stoer_zeit_gepl = :new.STOER_ZEIT_GEPL,
            a.zeit_einheit = :new.ZEIT_EINHEIT,
            a.prod_params = substr(v_fa.prod_params, 1, 4000),
            a.start_gepl = :new.START_GEPL,
            a.ende_gepl = :new.ENDE_GEPL,
            a.zeichnung = :new.ZEICHNUNG,
            a.zeichnung_index = :new.ZEICHNUNG_INDEX,
            a.fremd_zeichnung = :new.FREMD_ZEICHNUNG,
            a.zeichnungname = :new.ZEICHNUNGNAME,
            a.max_tak_ausf_zeit = :new.MAX_TAK_AUSF_ZEIT,
            a.max_tak_zeit = :new.MAX_TAK_ZEIT,
            a.min_tak_zeit = :new.MIN_TAK_ZEIT,
            a.charge = :new.CHARGE,
            a.lhm_name = :new.LHM_NAME,
            a.lte_name = :new.LTE_NAME,
            a.best_nr_kunde = :new.best_nr_kunde,
            a.kenz_lhm_druck = :new.kenz_lhm_druck,
            a.lhm_menge = :new.lhm_menge,
            a.schrott = nvl(v_erm_schrott, :new.SCHROTT),
            a.kd_art_nr = v_artikel_kunde.kd_art_nr,
            a.ag_los_mg = :new.ag_los_mg,                                                                -- AG_LOS_MG NUMBER  Y     Sollmenge in diesem AG die als Produktionsmenge zur Maschiene gesendet werden soll (Teilmenge für dieses Produktionslos)
            a.rcv_ag_ist_mg = nvl(:new.rcv_ag_ist_mg, v_fa_hist.rcv_ag_ist_mg),                          -- RCV_AG_IST_MG NUMBER  Y     Bereits gefertigte Menge in diesem AG die zum HOST gesendet wurde
            a.rcv_ag_ist_mg_b = nvl(:new.rcv_ag_ist_mg_b, v_fa_hist.rcv_ag_ist_mg_b),                    -- RCV_AG_IST_MG_B NUMBER  Y     Angefalle Menge in B-Qualität für diesen AG die zum HOST gesendet wurde
            a.rcv_ag_ist_mg_schrott = nvl(:new.rcv_ag_ist_mg_schrott, v_fa_hist.rcv_ag_ist_mg_schrott),  -- RCV_AG_IST_MG_SCHROTT NUMBER  Y     Angefalle Schrottmenge für diesen AG die zum HOST gesendet wurde
            a.rcv_ag_ist_mg_ruesten = nvl(:new.rcv_ag_ist_mg_ruesten, v_fa_hist.rcv_ag_ist_mg_ruesten),  -- RCV_AG_IST_MG_RUESTEN NUMBER  Y     Angefalle Menge beim Rüsten und Anfahren für diesen AG die zum HOST gesendet wurde
            a.rcv_ruest_zeit_ist = nvl(:new.rcv_ruest_zeit_ist, v_fa_hist.rcv_ruest_zeit_ist),           -- RCV_RUEST_ZEIT_IST  NUMBER  Y     Angefallene Rüstzeit in Minuten die zum HOST gesendet wurde
            a.rcv_prod_zeit_ist = nvl(:new.rcv_prod_zeit_ist, v_fa_hist.rcv_prod_zeit_ist),              -- RCV_PROD_ZEIT_IST NUMBER  Y     Angefallene netto Produktionszeit in Minuten die zum HOST gesendet wurde
            a.rcv_stoer_zeit_ist = nvl(:new.rcv_stoer_zeit_ist, v_fa_hist.rcv_stoer_zeit_ist),           -- RCV_STOER_ZEIT_IST  NUMBER  Y     Angefallene Ausfallzeiten in Minuten die zum HOST gesendet wurde
            a.ag_art_laenge = :new.ag_art_laenge,                                                        -- AG_ART_LAENGE N NUMBER(12,3)  Y     Länge
            a.ag_art_breite =:new.ag_art_breite,                                                         -- AG_ART_BREITE N NUMBER(12,3)  Y     Breite
            a.ag_art_dicke = :new.ag_art_dicke,                                                          -- AG_ART_DICKE  N NUMBER(12,3)  Y     Dicke
            a.ag_art_durch = :new.ag_art_durch,                                                          -- AG_ART_DURCH  N NUMBER(12,3)  Y     Durchmesser
            a.kunden_ab = :new.kunden_ab,                                                                -- KUNDEN_AB N VARCHAR2(20)  Y     AB Nummer des Kundenauftrags
            a.kunden_ab_pos = :new.kunden_ab_pos,                                                        -- KUNDEN_AB_POS N VARCHAR2(20)  Y     AB Positionsnummer des Kundenauftrags
            a.kunden_ab_upos = :new.kunden_ab_upos,                                                      -- KUNDEN_AB_UPOS  N VARCHAR2(20)  Y     AB Unterposition des Kundenauftrags
            a.term_wunsch = :new.term_wunsch,                                                            -- TERM_WUNSCH N DATE  Y     Wunschtermin in dd.mm.yyyy hh24:mi:ss
            a.term_best = :new.term_best,                                                                -- TERM_BEST N DATE  Y     Bestätigter Termin in dd.mm.yyyy hh24:mi:ss
            a.transp_zeit = :new.transp_zeit,                                                            -- TRANSP_ZEIT N NUMBER(5) Y     Transportzeit für die Lieferung zum Kunden in STD
            a.anz_rohstoffe = :new.anz_rohstoffe,                                                        -- ANZ_ROHSTOFFE N NUMBER(3) Y     Anzahl der benötigten Drähte
            a.ausgef_ende = :new.ausgef_ende,                                                            -- AUSGEF_ENDE N VARCHAR2(1) Y     AUSGEFÜHRTES ENDE
            a.ag_prod_frei = decode(:new.ab_status,
                                    'P', 'N',
                                    nvl(:new.ag_prod_frei, 'Y')),                                        -- AG_PROD_FREI  N VARCHAR2(1) Y     T = Freigegeben für Produktion, F = Nur für Planung
            a.ag_ueberlappen = :new.ag_ueberlappen,                                                      -- AG_UEBERLAPPEN  N NUMBER(12,3)  Y     Anzahl die fertig sein müssen, um den nächsten AG zu beginnen nächsten AG zu beginnen
            a.ag_opt_grp = v_fa.ag_opt_grp,                                                              -- AG_OPT_GRP  N VARCHAR2(50)  Y     Rüstgruppe zur optimierung im APS
            a.prioritaet = :new.prioritaet,
            a.anz_mitarbeiter = :new.anz_mitarbeiter,
            a.lueckenfueller = nvl(:new.lueckenfueller, a.lueckenfueller),
            a.freig_status =  decode (:new.ab_status,
                              'C', 'F',       -- Closed Technisch abgeschlossen
                              'X', 'F',       -- Storniert
                              NULL),          -- FREIG_STATUS N VARCHAR2(3) Y 'N'   "N" = Neuer Auftrag "A" = Kann angefangen werden "AR" Aktuell Rüsten"AP" Aktuell in Produktion, "TF" Teilfertigung gemeldet
            a.start_batch_by_order_start = :new.start_batch_by_order_start,
            a.ext_arbeits_anweisung = :new.ext_arbeits_anweisung,
            a.kunden_ab_text = :new.kunden_ab_text,
            a.seq_nr = :new.seq_nr,
            a.lead_leitzahl = :new.lead_leitzahl,
            a.primaer_leitzahl = :new.primaer_leitzahl
      where a.firma_nr = :new.FIRMA_NR
        and a.auf_id = :new.auf_id;
    if :new.satzart = 'V'
    then
      if :new.kunden_ab_wechsel_ruestzeit > 0
      and :new.kunden_ab is not NULL
      then
        OPEN c_fa_auf_fhm;
        FETCH c_fa_auf_fhm into v_fa_auf_fhm;
        v_found := c_fa_auf_fhm%FOUND;
        CLOSE c_fa_auf_fhm;
        if not v_found
        then
          insert into s_erp_rcv_fa_auf_fhm
          values
            (:new.firma_nr,
             :new.auf_id,
             :new.auftrag,
             :new.leitzahl,
             :new.fa_ag,
             :new.fa_upos,
             :new.kunden_ab,
             :new.kunden_ab_wechsel_ruestzeit,
             NULL);
        else
          update s_erp_rcv_fa_auf_fhm t
             set t.ruest_zeit = :new.kunden_ab_wechsel_ruestzeit
           where t.leitzahl = :new.leitzahl
             and t.fa_ag = :new.fa_ag
             and t.fa_upos = :new.fa_upos
             and t.prod_fhm = :new.kunden_ab
             and t.firma_nr = :new.firma_nr;
        end if;
      else
        delete s_erp_rcv_fa_auf_fhm t
         where t.leitzahl = :new.leitzahl
           and t.fa_ag = :new.fa_ag
           and t.fa_upos = :new.fa_upos
           and t.prod_fhm = :new.kunden_ab
           and t.firma_nr = :new.firma_nr;
      end if;
    end if;
  elsif deleting then
    delete s_rcv_fa_auf a
     where a.firma_nr = :old.FIRMA_NR
       and a.auf_id = :old.auf_id;
    delete s_erp_rcv_fa_auf_fhm t
     where t.leitzahl = :old.leitzahl
       and t.FA_AG    = :old.FA_AG;
    delete s_erp_rcv_fa_auf_res t
     where t.leitzahl = :old.leitzahl
       and t.fa_ag = :old.fa_ag
       and t.fa_upos = :old.fa_upos;
    delete s_erp_rcv_fa_auf_rel t
     where t.leitzahl = :old.leitzahl
       and t.fa_ag = :old.fa_ag
       and t.fa_upos = :old.fa_upos;
  end if;
end TR_S_ERP_RCV_FA_AUF_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_FA_AUF_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"5d4fcceb55fa82ede7a2a3f927eaf4f1c29c4b2d","type":"TRIGGER","name":"TR_S_ERP_RCV_FA_AUF_BUID","schemaName":"DIRKSPZM32","sxml":""}