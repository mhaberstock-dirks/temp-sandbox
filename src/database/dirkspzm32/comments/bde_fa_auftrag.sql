comment on table dirkspzm32.bde_fa_auftrag is
    'Alle Fertigungsaufträge mit den zugehörigen Arbeitsgängen (Artikelpositionen)';

comment on column dirkspzm32.bde_fa_auftrag.abfuell_abschalt_fein is
    'Absch. Fein';

comment on column dirkspzm32.bde_fa_auftrag.abfuell_abschalt_grob is
    'Absch. Grob';

comment on column dirkspzm32.bde_fa_auftrag.abfuell_abschalt_mittel is
    'Absch. Mittel';

comment on column dirkspzm32.bde_fa_auftrag.abfuell_silo is
    'Silo für Abfüllung';

comment on column dirkspzm32.bde_fa_auftrag.abfuell_soll is
    'Sollmenge für die Abfüllung';

comment on column dirkspzm32.bde_fa_auftrag.abfuell_toleranz_minus is
    'Toleranz Minus';

comment on column dirkspzm32.bde_fa_auftrag.abfuell_toleranz_plus is
    'Toleranz Plus';

comment on column dirkspzm32.bde_fa_auftrag.abnr is
    'Auftrag Bestätigungsnummer (PLEIT) oder Batch';

comment on column dirkspzm32.bde_fa_auftrag.ab_artikel_id is
    'Artikelnummer des Fertigartikels aus dem Kundenauftrag';

comment on column dirkspzm32.bde_fa_auftrag.ab_ende_status is
    'Ende Status (z.Zt. nicht in Verwendung)';

comment on column dirkspzm32.bde_fa_auftrag.ab_ist_mg is
    'Bereits gefertigte Menge im Kundenauftrag (Fertigartikel)';

comment on column dirkspzm32.bde_fa_auftrag.ab_soll_mg is
    'Sollmenge aus dem Kundenauftrag (Fertigartikel)';

comment on column dirkspzm32.bde_fa_auftrag.ab_text1 is
    'Zusatztext aud Kundenauftrag';

comment on column dirkspzm32.bde_fa_auftrag.ab_text2 is
    'Zusatztext aud Kundenauftrag';

comment on column dirkspzm32.bde_fa_auftrag.ab_text3 is
    'Zusatztext aud Kundenauftrag';

comment on column dirkspzm32.bde_fa_auftrag.adress_id is
    'Verlängerte Werkbank, Eigetümer der Rohstoffe und Fertigware';

comment on column dirkspzm32.bde_fa_auftrag.ag_artikel_id is
    'Artikel ID für den AG';

comment on column dirkspzm32.bde_fa_auftrag.ag_art_breite is
    'Breite';

comment on column dirkspzm32.bde_fa_auftrag.ag_art_dicke is
    'Dicke';

comment on column dirkspzm32.bde_fa_auftrag.ag_art_durch is
    'Durchmesser';

comment on column dirkspzm32.bde_fa_auftrag.ag_art_laenge is
    'Länge';

comment on column dirkspzm32.bde_fa_auftrag.ag_bez1 is
    'Arbeitsgang Bezeichnung';

comment on column dirkspzm32.bde_fa_auftrag.ag_bez2 is
    'Arbeitsgang Bezeichnung';

comment on column dirkspzm32.bde_fa_auftrag.ag_id is
    'Referenz zur auf_id im HOST';

comment on column dirkspzm32.bde_fa_auftrag.ag_ist_mg is
    'Bereits gefertigte Menge in diesem AG';

comment on column dirkspzm32.bde_fa_auftrag.ag_ist_mg_b is
    'Angefalle Menge in B-Qualität für diesen AG';

comment on column dirkspzm32.bde_fa_auftrag.ag_ist_mg_ruesten is
    'Angefalle Menge beim Rüsten und Anfahren für diesen AG';

comment on column dirkspzm32.bde_fa_auftrag.ag_ist_mg_schrott is
    'Angefalle Schrottmenge für diesen AG';

comment on column dirkspzm32.bde_fa_auftrag.ag_los_ist_mg is
    'Istmenge in diesem AG die als Produktionsmenge auf der Maschiene produziert wurde (Teilmenge für dieses Produktionslos)';

comment on column dirkspzm32.bde_fa_auftrag.ag_los_mg is
    'Sollmenge in diesem AG die als Produktionsmenge zur Maschiene gesendet werden soll (Teilmenge für dieses Produktionslos)';

comment on column dirkspzm32.bde_fa_auftrag.ag_opt_grp is
    'Rüstgruppe zur optimierung im APS';

comment on column dirkspzm32.bde_fa_auftrag.ag_prod_frei is
    'T = Freigegeben für Produktion, F = Nur für Planung';

comment on column dirkspzm32.bde_fa_auftrag.ag_soll_mg is
    'Sollmenge in diesem AG';

comment on column dirkspzm32.bde_fa_auftrag.ag_text1 is
    'Zusatztext für diesen Arbeitsgang';

comment on column dirkspzm32.bde_fa_auftrag.ag_text2 is
    'Zusatztext für diesen Arbeitsgang';

comment on column dirkspzm32.bde_fa_auftrag.ag_text3 is
    'Zusatztext für diesen Arbeitsgang';

comment on column dirkspzm32.bde_fa_auftrag.ag_ueberlappen is
    'Anzahl die fertig sein müssen, um den  nächsten AG zu beginnen nächsten AG zu beginnen';

comment on column dirkspzm32.bde_fa_auftrag.anz_mitarbeiter is
    'Anzahl der benötigten Mitarbeiter';

comment on column dirkspzm32.bde_fa_auftrag.anz_res is
    'Anzahl der Maschinen die an diesem AG arbeiten';

comment on column dirkspzm32.bde_fa_auftrag.anz_rohstoffe is
    'Anzahl der benötigten Drähte';

comment on column dirkspzm32.bde_fa_auftrag.auf_id is
    'eindeutige Sequenz-Nummer für Reservierungen und DISPO';

comment on column dirkspzm32.bde_fa_auftrag.ausgef_ende is
    'AUSGEFÜHRTES ENDE';

comment on column dirkspzm32.bde_fa_auftrag.best_nr_kunde is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.bde_fa_auftrag.charge_id is
    'ID der Charge';

comment on column dirkspzm32.bde_fa_auftrag.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.bde_fa_auftrag.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.bde_fa_auftrag.einsatz is
    'Gewicht Einsatz incl. Verschnitt und Schrott (Noch nicht gefüllt)';

comment on column dirkspzm32.bde_fa_auftrag.ext_arbeits_anweisung is
    'URL zur Arbeitsanweisung';

comment on column dirkspzm32.bde_fa_auftrag.fa_ag is
    'Arbeitsgang des Auftrags';

comment on column dirkspzm32.bde_fa_auftrag.fa_upos is
    'Unterposition des Arbeitsgangs';

comment on column dirkspzm32.bde_fa_auftrag.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.bde_fa_auftrag.freig_status is
    '"N" = Neuer Auftrag "A" = Kann angefangen werden "AR" Aktuell Rüsten"AP" Aktuell in Produktion, "TF" Teilfertigung gemeldet, "F" Fertig gemeldet'
    ;

comment on column dirkspzm32.bde_fa_auftrag.freig_wann is
    'Wann wurde Fertig gemeldet';

comment on column dirkspzm32.bde_fa_auftrag.freig_wer is
    'Wer hat Fertig gemeldet';

comment on column dirkspzm32.bde_fa_auftrag.fremd_zeichnung is
    'Externe Zeichnung';

comment on column dirkspzm32.bde_fa_auftrag.gewicht is
    'Gewicht der gefertigten Teile (Noch nicht gefüllt)';

comment on column dirkspzm32.bde_fa_auftrag.job_sequenz is
    'Job Sequenz als Abarbeitungsreihenfolge für selektierte Splitts';

comment on column dirkspzm32.bde_fa_auftrag.kategorie is
    'Kategorie z.B. SAMPLE, Nachschreiber, ...';

comment on column dirkspzm32.bde_fa_auftrag.kd_art_nr is
    'Kundenartikelnummer';

comment on column dirkspzm32.bde_fa_auftrag.kenz_letzt_ag is
    '1 Wenn letzter Prod. AG';

comment on column dirkspzm32.bde_fa_auftrag.kenz_lhm_druck is
    '''T'' = Bei jedem Karton soll auch ein Etikett gedruckt werden';

comment on column dirkspzm32.bde_fa_auftrag.kunden_ab is
    'AB Nummer des Kundenauftrags';

comment on column dirkspzm32.bde_fa_auftrag.kunden_ab_pos is
    'AB Positionsnummer des Kundenauftrags';

comment on column dirkspzm32.bde_fa_auftrag.kunden_ab_text is
    'Beschreibender Text zum  Kundenauftrags';

comment on column dirkspzm32.bde_fa_auftrag.kunden_ab_upos is
    'AB Unterposition des Kundenauftrags';

comment on column dirkspzm32.bde_fa_auftrag.kunden_nr is
    'Kundennummer für den Auftrag';

comment on column dirkspzm32.bde_fa_auftrag.kunden_nr_adr_liefer is
    'Lieferadresse (Kunden; Gruppenmerkmal ist die Kundenummer)';

comment on column dirkspzm32.bde_fa_auftrag.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.bde_fa_auftrag.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.bde_fa_auftrag.lead_leitzahl is
    'Leitzahl des Vorgängerauftrags';

comment on column dirkspzm32.bde_fa_auftrag.leitzahl is
    'Leitzahl des Fertigungsauftrags (KLEIT)';

comment on column dirkspzm32.bde_fa_auftrag.lhm_anz is
    'Sollmenge Anz. Gebinde';

comment on column dirkspzm32.bde_fa_auftrag.lhm_anz_ist is
    'Istmenge Anz. Gebinde';

comment on column dirkspzm32.bde_fa_auftrag.lhm_menge is
    'Menge (Stück) im LHM';

comment on column dirkspzm32.bde_fa_auftrag.lhm_name is
    'Art, Name des LHM''s Bsp.: K600 als Karton 600';

comment on column dirkspzm32.bde_fa_auftrag.lohn_arbeit is
    'Ist der Auftrag Lohnarbeit ''T''=True, ''F''=False  -> verlängerte Werkbank, soll bevorzugt KONSI-Bestände des Kunden verwenden '
    ;

comment on column dirkspzm32.bde_fa_auftrag.lte_anz is
    'Sollmenge Anz. LTE';

comment on column dirkspzm32.bde_fa_auftrag.lte_anz_ist is
    'Istmenge Anz. LTE';

comment on column dirkspzm32.bde_fa_auftrag.lte_lhm_lagen is
    'Aus ISI_ARTIKEL oder Schnittstelle';

comment on column dirkspzm32.bde_fa_auftrag.lte_lhm_pro_lage is
    'Aus ISI_ARTIKEL oder Schnittstelle';

comment on column dirkspzm32.bde_fa_auftrag.lte_menge is
    'Menge (Stück) im LTE';

comment on column dirkspzm32.bde_fa_auftrag.lte_name is
    'Art, Name der Transporteinheit z.B. EURO für EURO-PALETTE';

comment on column dirkspzm32.bde_fa_auftrag.lueckenfueller is
    '"Lückenfüller ''F'' False (Nein) (Zwischenplanen) ''T'' = Ja"';

comment on column dirkspzm32.bde_fa_auftrag.max_takt_ausf_zeit is
    'Eine Störung beginnt wenn x takte ausgefallen sind';

comment on column dirkspzm32.bde_fa_auftrag.max_takt_zeit is
    'Maximale taktzeit';

comment on column dirkspzm32.bde_fa_auftrag.ma_hersteller_kuerzel_liste is
    'Wenn Herstelle-Rein, dann ist hier der Hersteller als Liste hinterlegt Wert mit ;';

comment on column dirkspzm32.bde_fa_auftrag.ma_reserviert is
    'Ist der Rohstoff (Materialanforderung) Reserviert T=Ist Reserviert, F=Ist nicht reserviert';

comment on column dirkspzm32.bde_fa_auftrag.ma_res_charge_id is
    'Wenn ID gefüllt, dann muss Chargenrein der Rohstoff verwendet werden';

comment on column dirkspzm32.bde_fa_auftrag.ma_res_menge is
    'Welche Menge  Rohstoff (Materialanforderung) ist Reserviert';

comment on column dirkspzm32.bde_fa_auftrag.ma_res_menge_komm is
    'Welche Menge  Rohstoff wurde berreitgestellt / Kommissioniert';

comment on column dirkspzm32.bde_fa_auftrag.mde_ist_mg is
    'Bereits gefertigte Menge in diesem AG aus MDE';

comment on column dirkspzm32.bde_fa_auftrag.mde_ist_mg_b is
    'Angefalle Menge in B-Qualität für diesen AG aus MDE';

comment on column dirkspzm32.bde_fa_auftrag.mde_ist_mg_b_t is
    'Angefalle Menge in B-Qualität für diesen AG aus MDE Tag';

comment on column dirkspzm32.bde_fa_auftrag.mde_ist_mg_ruesten is
    'Angefalle Menge beim Rüsten und Anfahren für diesen AG aus MDE';

comment on column dirkspzm32.bde_fa_auftrag.mde_ist_mg_ruesten_t is
    'Angefalle Menge beim Rüsten und Anfahren für diesen AG aus MDE Tag';

comment on column dirkspzm32.bde_fa_auftrag.mde_ist_mg_schrott is
    'Angefalle Schrottmenge für diesen AG aus MDE';

comment on column dirkspzm32.bde_fa_auftrag.mde_ist_mg_schrott_t is
    'Angefalle Schrottmenge für diesen AG aus MDE Tag';

comment on column dirkspzm32.bde_fa_auftrag.mde_ist_mg_t is
    'Bereits gefertigte Menge in diesem AG aus MDE Tag';

comment on column dirkspzm32.bde_fa_auftrag.mde_micro_stop is
    'Angefallene Microstops aus MDE';

comment on column dirkspzm32.bde_fa_auftrag.mde_micro_stop_t is
    'Angefallene Microstops aus MDE Tag';

comment on column dirkspzm32.bde_fa_auftrag.min_takt_zeit is
    'Minimale Takzeit';

comment on column dirkspzm32.bde_fa_auftrag.nio_res_id is
    'Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden';

comment on column dirkspzm32.bde_fa_auftrag.nr_pruefung is
    'Nummer der Prüfung (Nicht der Stammsatz der die Prüfung beschreibt)';

comment on column dirkspzm32.bde_fa_auftrag.nutzen is
    'Nutzen in % (Noch nicht gefüllt)';

comment on column dirkspzm32.bde_fa_auftrag.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.bde_fa_auftrag.primaer_leitzahl is
    'Leitzahl des Primärauftrag';

comment on column dirkspzm32.bde_fa_auftrag.prioritaet is
    'Priorität des Fertigungsauftrags';

comment on column dirkspzm32.bde_fa_auftrag.prod_menge_p_einheit is
    'Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG';

comment on column dirkspzm32.bde_fa_auftrag.prod_menge_p_einheit_op is
    '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';

comment on column dirkspzm32.bde_fa_auftrag.prod_params is
    'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';

comment on column dirkspzm32.bde_fa_auftrag.prod_zeit_erf is
    'Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden';

comment on column dirkspzm32.bde_fa_auftrag.prod_zeit_gepl is
    'Geplante netto Produktionszeit in Minuten';

comment on column dirkspzm32.bde_fa_auftrag.prod_zeit_ist is
    'Angefallene netto Produktionszeit in Minuten';

comment on column dirkspzm32.bde_fa_auftrag.quitt_gruppe_ag is
    'Quittierungs-Gruppe der quittierenden Pos_Nr, sonst eigene Pos_Nr.';

comment on column dirkspzm32.bde_fa_auftrag.rcv_ag_ist_mg is
    'Bereits gefertigte Menge in diesem AG die zum HOST gesendet wurde';

comment on column dirkspzm32.bde_fa_auftrag.rcv_ag_ist_mg_b is
    'Angefalle Menge in B-Qualität für diesen AG die zum HOST gesendet wurde';

comment on column dirkspzm32.bde_fa_auftrag.rcv_ag_ist_mg_ruesten is
    'Angefalle Menge beim Rüsten und Anfahren für diesen AG die zum HOST gesendet wurde';

comment on column dirkspzm32.bde_fa_auftrag.rcv_ag_ist_mg_schrott is
    'Angefalle Schrottmenge für diesen AG die zum HOST gesendet wurde';

comment on column dirkspzm32.bde_fa_auftrag.rcv_prod_zeit_erf is
    'Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden übertragen';

comment on column dirkspzm32.bde_fa_auftrag.rcv_prod_zeit_ist is
    'Angefallene netto Produktionszeit in Minuten die zum HOST gesendet wurde';

comment on column dirkspzm32.bde_fa_auftrag.rcv_ruest_zeit_erf is
    'Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden übertragen';

comment on column dirkspzm32.bde_fa_auftrag.rcv_ruest_zeit_ist is
    'Angefallene Rüstzeit in Minuten die zum HOST gesendet wurde';

comment on column dirkspzm32.bde_fa_auftrag.rcv_stoer_zeit_ist is
    'Angefallene Ausfallzeiten in Minuten die zum HOST gesendet wurde';

comment on column dirkspzm32.bde_fa_auftrag.res_id is
    'Maschinen ID aus der Resourcentabelle falls eindeutig';

comment on column dirkspzm32.bde_fa_auftrag.ruest_zeit_erf is
    'Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden';

comment on column dirkspzm32.bde_fa_auftrag.ruest_zeit_gepl is
    'Geplante Rüstzeit in Minuten';

comment on column dirkspzm32.bde_fa_auftrag.ruest_zeit_ist is
    'Angefallene Rüstzeit in Minuten';

comment on column dirkspzm32.bde_fa_auftrag.satzart is
    '"V" Verrichten, "MA" = Materialanforderung, "VA" = Verrichten Auswäts, "VR" = Verrichten Rüsten';

comment on column dirkspzm32.bde_fa_auftrag.schrott is
    'Gewicht Schrott (Noch nicht gefüllt)';

comment on column dirkspzm32.bde_fa_auftrag.schrott_proz is
    'Ausschuss in Prozent';

comment on column dirkspzm32.bde_fa_auftrag.seq_nr is
    'Sequenz-Nummer, für das Zielprodukt auf der Fertigungslinie Montage - Ab DB31';

comment on column dirkspzm32.bde_fa_auftrag.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.bde_fa_auftrag.start_batch_by_order_start is
    'Dieser Batch wird gestartet, wenn der AG auf der Maschine angemeldet wird';

comment on column dirkspzm32.bde_fa_auftrag.status_begin is
    'Seit wann gilt dieser Status';

comment on column dirkspzm32.bde_fa_auftrag.status_freigabe is
    'Status der Freigabe NULL noch nicht begonnen, 100 Rüsten begonnen, 500 = Produktion begonnen , 900 = QS Freigabe erfolgt, 10000 Manuell kontrolliert'
    ;

comment on column dirkspzm32.bde_fa_auftrag.status_id is
    '000 = In Produktion, sonst Nummer der Störung';

comment on column dirkspzm32.bde_fa_auftrag.status_res_id is
    'Status der Resource (Wenn eindeutige ID)';

comment on column dirkspzm32.bde_fa_auftrag.stoer_zeit_erf is
    'Erfasste  Ausfallzeiten in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden';

comment on column dirkspzm32.bde_fa_auftrag.stoer_zeit_gepl is
    'Geplante, Berücksichtigte Stillstandszeit in Minuten';

comment on column dirkspzm32.bde_fa_auftrag.stoer_zeit_ist is
    'Angefallene Ausfallzeiten in Minuten';

comment on column dirkspzm32.bde_fa_auftrag.termin_ende_erf is
    'Erfasstes Produktionsende';

comment on column dirkspzm32.bde_fa_auftrag.termin_ende_gepl is
    'Geplantes Produktionsende';

comment on column dirkspzm32.bde_fa_auftrag.termin_ende_ist is
    'Echtes Produktionsende';

comment on column dirkspzm32.bde_fa_auftrag.termin_start_erf is
    'Erfasster Produktionsstart';

comment on column dirkspzm32.bde_fa_auftrag.termin_start_frueh is
    'Frühester Start Termin';

comment on column dirkspzm32.bde_fa_auftrag.termin_start_gepl is
    'Geplanter Produktionsbeginn';

comment on column dirkspzm32.bde_fa_auftrag.termin_start_ist is
    'Echter Produktionsstart';

comment on column dirkspzm32.bde_fa_auftrag.term_best is
    'Bestätigter Termin in dd.mm.yyyy hh24:mi:ss';

comment on column dirkspzm32.bde_fa_auftrag.term_wunsch is
    'Wunschtermin in dd.mm.yyyy hh24:mi:ss';

comment on column dirkspzm32.bde_fa_auftrag.transp_zeit is
    'Transportzeit für die Lieferung zum Kunden in STD';

comment on column dirkspzm32.bde_fa_auftrag.verbrauch is
    'Gewicht Verbrauch (Noch nicht gefüllt)';

comment on column dirkspzm32.bde_fa_auftrag.vorgangsqualifikation is
    'Qualifikation, die das Personal zur Bedienung des Vorgangs benötigt';

comment on column dirkspzm32.bde_fa_auftrag.zeichnung is
    'Externe Zeichnung';

comment on column dirkspzm32.bde_fa_auftrag.zeichnungname is
    'Zeichnungsname (*.TIF)';

comment on column dirkspzm32.bde_fa_auftrag.zeichnung_index is
    'ZeichnungIndex';

comment on column dirkspzm32.bde_fa_auftrag.zeit_einheit is
    'Benötigte Zeit je Einheit (Zykluszeit / (Stück je Zyklus) in Minuten';


-- sqlcl_snapshot {"hash":"fd774aaf22685506688d9e6afbbc858da9cf688c","type":"COMMENT","name":"bde_fa_auftrag","schemaName":"dirkspzm32","sxml":""}