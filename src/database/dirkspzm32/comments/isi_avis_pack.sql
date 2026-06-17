comment on table DIRKSPZM32.ISI_AVIS_PACK is 'VDA4913, Wareneingangsdaten / Lieferschein AVIS (Wareneingangsankündigung), LFT an Daimler AG (PACK)';
comment on column DIRKSPZM32.ISI_AVIS_PACK."ANZ_PACKMITTEL" is 'N13, Anzahl Packmittel je Typ pro Lieferscheinposition';
comment on column DIRKSPZM32.ISI_AVIS_PACK."EIGENTUM_KENNUNG" is 'Eigentum-Kennung, D = Mehrweg-Leihverpackung von Kunden Rückgabepfl., K = Mehrwegverpackung Eigentum Kunde, L = Mehrwegverpackung Eigentum Lieferant, Rückgabepflichtig, z.B. K';
comment on column DIRKSPZM32.ISI_AVIS_PACK."EINLAGER_DATUM" is 'Datum und uhrzeit der WE-Buchung';
comment on column DIRKSPZM32.ISI_AVIS_PACK."EINLAGER_STATUS" is 'N = Neu, ''F'' = WE-Gebucht';
comment on column DIRKSPZM32.ISI_AVIS_PACK."FUELLMENGE" is 'N10,3, Bei Liefereinheiten und vereinfachten Ladeeinheiten muss die Füllmenge angegeben werden. Die tatsächliche Füllmenge bezieht sich immer auf ein Packstück. Bei Hilfspackmitteln ist die Füllmenge = 0.';
comment on column DIRKSPZM32.ISI_AVIS_PACK."LABEL_KENNUNG" is 'Label-Kennung, G = Gemischtes Packstück (mit Unter-Packstücken und unterschiedlichen Sachnummern), M = Master-Label (mit Unter-Packstücken und gleichen Sachnummern), S = Single-Label (1 Packstück), , z.B. S';
comment on column DIRKSPZM32.ISI_AVIS_PACK."LHM_ID" is 'Packstücknummern sind für folgende Labelkennungen immer zu übertragen: M (Master), G (Mischverpackungen) und S (Single). Für Packhilfsmittel (Deckel, leere Behälter, etc.) und für lose angelieferte Materialien mit dem Packmittel-Nr. Kunde 0000LOS ist keine Packstücknummer zu vergeben. Die Nummer darf sich innerhalb eines Kalenderjahres (Jan.-Dez.) nicht wiederholen.';
comment on column DIRKSPZM32.ISI_AVIS_PACK."LHM_NAME" is 'Nur gefüllt wenn Packmittel eine LHM';
comment on column DIRKSPZM32.ISI_AVIS_PACK."LIEFERANTEN_NR" is 'Lieferanten-Nummer, z,B, 12345678';
comment on column DIRKSPZM32.ISI_AVIS_PACK."LIEFERSCHEIN_NR" is 'N8, Lieferschein-Nummer';
comment on column DIRKSPZM32.ISI_AVIS_PACK."LIEFERSCHEIN_POS" is 'N3, Lieferschein-Position auf die sich das Packmittel bezieht';
comment on column DIRKSPZM32.ISI_AVIS_PACK."LTE_ID" is 'LTE-ID als Klammer oder bei S ohne LHM';
comment on column DIRKSPZM32.ISI_AVIS_PACK."LTE_NAME" is 'Nur gefüllt wenn Packmittel eine LTE';
comment on column DIRKSPZM32.ISI_AVIS_PACK."PACKMITTEL_NR_LIEFERANT" is 'Packmittel-Nummer-Lieferant';
comment on column DIRKSPZM32.ISI_AVIS_PACK."SLB_NR" is 'N8, Sendungs-Ladungs-Bezugsnummer, z.B. 12345678';
comment on column DIRKSPZM32.ISI_AVIS_PACK."STAPELFAKTOR" is 'N1, Stapelfaktor, 1 = einfach stapelbar, 2 = zweifach stapelbar, usw., z.B. 2';
comment on column DIRKSPZM32.ISI_AVIS_PACK."VERPACKUNG_ABMESSUNG" is 'N12, Verpackungs-Abmessung, 4 Stellen Länge, 4 Stellen Breite, 4 Stellen Höhe';
comment on column DIRKSPZM32.ISI_AVIS_PACK."VERPACKUNG_KENNUNG" is 'Verpackung-Kennung, M = Mehrweg-Verpackung, E = Einweg-Verpackung,z.B. M';



-- sqlcl_snapshot {"hash":"c7f8ebdd259e6ce0aad5bf03843c821b63d34939","type":"COMMENT","name":"isi_avis_pack","schemaName":"dirkspzm32","sxml":""}