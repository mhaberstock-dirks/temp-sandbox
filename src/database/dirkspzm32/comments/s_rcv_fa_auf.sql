comment on table dirkspzm32.s_rcv_fa_auf is
    'Fertigungsauftraege uebergabe aus DIAF';

comment on column dirkspzm32.s_rcv_fa_auf.ab_artikel is
    'Eindeutiger Artikel ID des Auftragskopf';

comment on column dirkspzm32.s_rcv_fa_auf.ab_ist is
    'Istmenge im Auftragskopf';

comment on column dirkspzm32.s_rcv_fa_auf.ab_soll is
    'Sollmenge im Auftragskopf';

comment on column dirkspzm32.s_rcv_fa_auf.ab_status is
    'NULL = Noch nicht bearbeitet UE = Im ISIPlus übernommen L = Auftrag kann gelöscht werden F = Auftrag komplett Fertig TF = Teilfertig AR = Rüsten AP = Produktion'
    ;

comment on column dirkspzm32.s_rcv_fa_auf.ab_text1 is
    'Auftragskopf Text 1';

comment on column dirkspzm32.s_rcv_fa_auf.ab_text2 is
    'Auftragskopf Text 2';

comment on column dirkspzm32.s_rcv_fa_auf.ab_text3 is
    'Auftragskopf Text 3';

comment on column dirkspzm32.s_rcv_fa_auf.ag_artikel is
    'Artikel des Arbeitsgangs';

comment on column dirkspzm32.s_rcv_fa_auf.ag_art_breite is
    'Breite';

comment on column dirkspzm32.s_rcv_fa_auf.ag_art_dicke is
    'Dicke';

comment on column dirkspzm32.s_rcv_fa_auf.ag_art_durch is
    'Durchmesser';

comment on column dirkspzm32.s_rcv_fa_auf.ag_art_laenge is
    'Länge';

comment on column dirkspzm32.s_rcv_fa_auf.ag_bez1 is
    'Arbeitsgang Bezeichnung 1';

comment on column dirkspzm32.s_rcv_fa_auf.ag_bez2 is
    'Arbeitsgang Bezeichnung 2';

comment on column dirkspzm32.s_rcv_fa_auf.ag_freigabe_st is
    'Freigabestatus';

comment on column dirkspzm32.s_rcv_fa_auf.ag_id is
    'Areitsgang';

comment on column dirkspzm32.s_rcv_fa_auf.ag_ist_mg is
    'Istmenge im Arbeitsgang';

comment on column dirkspzm32.s_rcv_fa_auf.ag_ist_mg_b is
    'Menge B Qualität';

comment on column dirkspzm32.s_rcv_fa_auf.ag_ist_ruesten is
    'Menge beim Rüsten';

comment on column dirkspzm32.s_rcv_fa_auf.ag_ist_schrott is
    'Menge Schrott';

comment on column dirkspzm32.s_rcv_fa_auf.ag_los_mg is
    'Sollmenge in diesem AG die als Produktionsmenge zur Maschiene gesendet werden soll (Teilmenge für dieses Produktionslos)';

comment on column dirkspzm32.s_rcv_fa_auf.ag_opt_grp is
    'Rüstgruppe zur optimierung im APS';

comment on column dirkspzm32.s_rcv_fa_auf.ag_prod_frei is
    'T = Freigegeben für Produktion, F = Nur für Planung';

comment on column dirkspzm32.s_rcv_fa_auf.ag_soll_mg is
    'Sollmenge im Arbeitsgang';

comment on column dirkspzm32.s_rcv_fa_auf.ag_status is
    'NULL = Noch nicht bearbeitet UE = Im ISIPlus übernommen L = Auftrag kann gelöscht werden F = Auftrag komplett Fertig TF = Teilfertig AR = Rüsten AP = Produktion'
    ;

comment on column dirkspzm32.s_rcv_fa_auf.ag_text1 is
    'Arbeitsgang Text 1';

comment on column dirkspzm32.s_rcv_fa_auf.ag_text2 is
    'Arbeitsgang Text 2';

comment on column dirkspzm32.s_rcv_fa_auf.ag_text3 is
    'Arbeitsgang Text 3';

comment on column dirkspzm32.s_rcv_fa_auf.ag_ueberlappen is
    '"Anzahl die fertig sein müssen, um den
                  nächsten AG zu beginnen
nächsten AG zu beginnen"';

comment on column dirkspzm32.s_rcv_fa_auf.anz_mitarbeiter is
    'Anzahl der benötigten Mitarbeiter';

comment on column dirkspzm32.s_rcv_fa_auf.anz_rohstoffe is
    'Anzahl der benötigten Drähte';

comment on column dirkspzm32.s_rcv_fa_auf.auftrag is
    'Aufragsnummer (PLEIT)';

comment on column dirkspzm32.s_rcv_fa_auf.auf_id is
    'eindeutige Sequenz-Nummer';

comment on column dirkspzm32.s_rcv_fa_auf.ausgef_ende is
    'AUSGEFÜHRTES ENDE';

comment on column dirkspzm32.s_rcv_fa_auf.best_nr_kunde is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.s_rcv_fa_auf.charge is
    'Vorgabe CHARGE';

comment on column dirkspzm32.s_rcv_fa_auf.einsatz is
    'Einsatzgewicht';

comment on column dirkspzm32.s_rcv_fa_auf.ende_gepl is
    'Geplanter Ende Termin';

comment on column dirkspzm32.s_rcv_fa_auf.ende_ist is
    'Echter Ende Termin';

comment on column dirkspzm32.s_rcv_fa_auf.ext_arbeits_anweisung is
    'URL zur Arbeitsanweisung';

comment on column dirkspzm32.s_rcv_fa_auf.fa_ag is
    'Arbeitsgang zur Leitzahl aus DIAF';

comment on column dirkspzm32.s_rcv_fa_auf.fa_upos is
    'Unterposition für Gruppenarbeit';

comment on column dirkspzm32.s_rcv_fa_auf.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_rcv_fa_auf.freig_status is
    '"N" = Neuer Auftrag "A" = Kann angefangen werden "AR" Aktuell Rüsten"AP" Aktuell in Produktion, "TF" Teilfertigung gemeldet';

comment on column dirkspzm32.s_rcv_fa_auf.fremd_zeichnung is
    'Externe Zeichnung';

comment on column dirkspzm32.s_rcv_fa_auf.gewicht is
    'Gewicht';

comment on column dirkspzm32.s_rcv_fa_auf.kategorie is
    'Kategorie z.B. SAMPLE, Nachschreiber, ...';

comment on column dirkspzm32.s_rcv_fa_auf.kd_art_nr is
    'Kundenartikelnummer';

comment on column dirkspzm32.s_rcv_fa_auf.kenz_lhm_druck is
    '''T'' = Bei jedem Karton soll auch ein Etikett gedruckt werden';

comment on column dirkspzm32.s_rcv_fa_auf.kunden_ab is
    'AB Nummer des Kundenauftrags';

comment on column dirkspzm32.s_rcv_fa_auf.kunden_ab_pos is
    'AB Positionsnummer des Kundenauftrags';

comment on column dirkspzm32.s_rcv_fa_auf.kunden_ab_text is
    'Beschreibender Text zum  Kundenauftrags';

comment on column dirkspzm32.s_rcv_fa_auf.kunden_ab_upos is
    'AB Unterposition des Kundenauftrags';

comment on column dirkspzm32.s_rcv_fa_auf.kunden_nr is
    'Kundennummer aus Adressen';

comment on column dirkspzm32.s_rcv_fa_auf.kunden_nr_adr_liefer is
    'Lieferadresse (Kunden; Gruppenmerkmal ist die Kundenummer)';

comment on column dirkspzm32.s_rcv_fa_auf.lead_leitzahl is
    'Leitzahl des Vorgängerauftrags';

comment on column dirkspzm32.s_rcv_fa_auf.leitzahl is
    'Leitzahl aus DIAF (KLEIT)';

comment on column dirkspzm32.s_rcv_fa_auf.lhm_menge is
    'Menge in LHM';

comment on column dirkspzm32.s_rcv_fa_auf.lhm_name is
    'Hilfsmittelname (Kiste, Karton, etc.) Bsp.: K600';

comment on column dirkspzm32.s_rcv_fa_auf.lte_lhm_lagen is
    'Aus ISI_ARTIKEL oder Schnittstelle';

comment on column dirkspzm32.s_rcv_fa_auf.lte_lhm_pro_lage is
    'Aus ISI_ARTIKEL oder Schnittstelle';

comment on column dirkspzm32.s_rcv_fa_auf.lte_menge is
    'Menge in LTE';

comment on column dirkspzm32.s_rcv_fa_auf.lte_name is
    'Name der Transporteinheit / Palette Gitteboxstapel etc';

comment on column dirkspzm32.s_rcv_fa_auf.lueckenfueller is
    '"Lückenfüller ''F'' False (Nein) (Zwischenplanen) ''T'' = Ja

"';

comment on column dirkspzm32.s_rcv_fa_auf.maschine is
    'Eindeutiger Maschinen ID Z.B. M36';

comment on column dirkspzm32.s_rcv_fa_auf.max_tak_ausf_zeit is
    'Maximale Takt Ausfallzeit';

comment on column dirkspzm32.s_rcv_fa_auf.max_tak_zeit is
    'Maximale Takt Zeit';

comment on column dirkspzm32.s_rcv_fa_auf.min_tak_zeit is
    'Minimale Takt Zeit';

comment on column dirkspzm32.s_rcv_fa_auf.nutzen is
    'Nutzen';

comment on column dirkspzm32.s_rcv_fa_auf.primaer_leitzahl is
    'Leitzahl des Primärauftrag';

comment on column dirkspzm32.s_rcv_fa_auf.prioritaet is
    'Priorität des Fertigungsauftrags';

comment on column dirkspzm32.s_rcv_fa_auf.prod_params is
    'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';

comment on column dirkspzm32.s_rcv_fa_auf.prod_zeit_gepl is
    'Produktionzeit geplant';

comment on column dirkspzm32.s_rcv_fa_auf.prod_zeit_ist is
    'Produktionzeit ist';

comment on column dirkspzm32.s_rcv_fa_auf.rcv_ag_ist_mg is
    'Bereits gefertigte Menge in diesem AG die zum HOST gesendet wurde';

comment on column dirkspzm32.s_rcv_fa_auf.rcv_ag_ist_mg_b is
    'Angefalle Menge in B-Qualität für diesen AG die zum HOST gesendet wurde';

comment on column dirkspzm32.s_rcv_fa_auf.rcv_ag_ist_mg_ruesten is
    'Angefalle Menge beim Rüsten und Anfahren für diesen AG die zum HOST gesendet wurde';

comment on column dirkspzm32.s_rcv_fa_auf.rcv_ag_ist_mg_schrott is
    'Angefalle Schrottmenge für diesen AG die zum HOST gesendet wurde';

comment on column dirkspzm32.s_rcv_fa_auf.rcv_prod_zeit_ist is
    'Angefallene netto Produktionszeit in Minuten die zum HOST gesendet wurde';

comment on column dirkspzm32.s_rcv_fa_auf.rcv_ruest_zeit_ist is
    'Angefallene Rüstzeit in Minuten die zum HOST gesendet wurde';

comment on column dirkspzm32.s_rcv_fa_auf.rcv_stoer_zeit_ist is
    'Angefallene Ausfallzeiten in Minuten die zum HOST gesendet wurde';

comment on column dirkspzm32.s_rcv_fa_auf.res_name is
    'Maschinenbez.';

comment on column dirkspzm32.s_rcv_fa_auf.ruest_zeit_gepl is
    'Rüstzeit geplant';

comment on column dirkspzm32.s_rcv_fa_auf.ruest_zeit_ist is
    'Rüstzeit ist';

comment on column dirkspzm32.s_rcv_fa_auf.satzart is
    'MA = Materialanforderung VR = Verrichten';

comment on column dirkspzm32.s_rcv_fa_auf.schrott is
    'Schrottgewicht';

comment on column dirkspzm32.s_rcv_fa_auf.seq_nr is
    'Sequenz-Nummer, für das Zielprodukt auf der Fertigungslinie Montage - Ab DB31';

comment on column dirkspzm32.s_rcv_fa_auf.start_batch_by_order_start is
    'Dieser Batch wird gestartet, wenn der AG auf der Maschine angemeldet wird';

comment on column dirkspzm32.s_rcv_fa_auf.start_gepl is
    'Geplanter Start Termin';

comment on column dirkspzm32.s_rcv_fa_auf.start_ist is
    'Echter Start Termin';

comment on column dirkspzm32.s_rcv_fa_auf.stoer_zeit_gepl is
    'Unterbrechungszeit geplant';

comment on column dirkspzm32.s_rcv_fa_auf.stoer_zeit_ist is
    'Unterbrechungszeit ist';

comment on column dirkspzm32.s_rcv_fa_auf.term_best is
    'Bestätigter Termin in dd.mm.yyyy hh24:mi:ss';

comment on column dirkspzm32.s_rcv_fa_auf.term_wunsch is
    'Wunschtermin in dd.mm.yyyy hh24:mi:ss';

comment on column dirkspzm32.s_rcv_fa_auf.transp_zeit is
    'Transportzeit für die Lieferung zum Kunden in STD';

comment on column dirkspzm32.s_rcv_fa_auf.verbrauch is
    'Gewicht Verbraucht';

comment on column dirkspzm32.s_rcv_fa_auf.vorgangsqualifikation is
    'Qualifikation, die das Personal zur Bedienung des Vorgangs benötigt';

comment on column dirkspzm32.s_rcv_fa_auf.zeichnung is
    'Zeichnung';

comment on column dirkspzm32.s_rcv_fa_auf.zeichnungname is
    'Zeichnungsname (*.TIF)';

comment on column dirkspzm32.s_rcv_fa_auf.zeichnung_index is
    'Zeichnungsindex';

comment on column dirkspzm32.s_rcv_fa_auf.zeit_einheit is
    'Benötigte Zeit je Einheit';


-- sqlcl_snapshot {"hash":"17cc1c5fc7a5499feab0ed7c73787b8b41bbbe39","type":"COMMENT","name":"s_rcv_fa_auf","schemaName":"dirkspzm32","sxml":""}