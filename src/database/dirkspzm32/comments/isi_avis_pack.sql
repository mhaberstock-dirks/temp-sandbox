comment on table dirkspzm32.isi_avis_pack is
    'VDA4913, Wareneingangsdaten / Lieferschein AVIS (Wareneingangsankündigung), LFT an Daimler AG (PACK)';

comment on column dirkspzm32.isi_avis_pack.anz_packmittel is
    'N13, Anzahl Packmittel je Typ pro Lieferscheinposition';

comment on column dirkspzm32.isi_avis_pack.eigentum_kennung is
    'Eigentum-Kennung, D = Mehrweg-Leihverpackung von Kunden Rückgabepfl., K = Mehrwegverpackung Eigentum Kunde, L = Mehrwegverpackung Eigentum Lieferant, Rückgabepflichtig, z.B. K'
    ;

comment on column dirkspzm32.isi_avis_pack.einlager_datum is
    'Datum und uhrzeit der WE-Buchung';

comment on column dirkspzm32.isi_avis_pack.einlager_status is
    'N = Neu, ''F'' = WE-Gebucht';

comment on column dirkspzm32.isi_avis_pack.fuellmenge is
    'N10,3, Bei Liefereinheiten und vereinfachten Ladeeinheiten muss die Füllmenge angegeben werden. Die tatsächliche Füllmenge bezieht sich immer auf ein Packstück. Bei Hilfspackmitteln ist die Füllmenge = 0.'
    ;

comment on column dirkspzm32.isi_avis_pack.label_kennung is
    'Label-Kennung, G = Gemischtes Packstück (mit Unter-Packstücken und unterschiedlichen Sachnummern), M = Master-Label (mit Unter-Packstücken und gleichen Sachnummern), S = Single-Label (1 Packstück), , z.B. S'
    ;

comment on column dirkspzm32.isi_avis_pack.lhm_id is
    'Packstücknummern sind für folgende Labelkennungen immer zu übertragen: M (Master), G (Mischverpackungen) und S (Single). Für Packhilfsmittel (Deckel, leere Behälter, etc.) und für lose angelieferte Materialien mit dem Packmittel-Nr. Kunde 0000LOS ist keine Packstücknummer zu vergeben. Die Nummer darf sich innerhalb eines Kalenderjahres (Jan.-Dez.) nicht wiederholen.'
    ;

comment on column dirkspzm32.isi_avis_pack.lhm_name is
    'Nur gefüllt wenn Packmittel eine LHM';

comment on column dirkspzm32.isi_avis_pack.lieferanten_nr is
    'Lieferanten-Nummer, z,B, 12345678';

comment on column dirkspzm32.isi_avis_pack.lieferschein_nr is
    'N8, Lieferschein-Nummer';

comment on column dirkspzm32.isi_avis_pack.lieferschein_pos is
    'N3, Lieferschein-Position auf die sich das Packmittel bezieht';

comment on column dirkspzm32.isi_avis_pack.lte_id is
    'LTE-ID als Klammer oder bei S ohne LHM';

comment on column dirkspzm32.isi_avis_pack.lte_name is
    'Nur gefüllt wenn Packmittel eine LTE';

comment on column dirkspzm32.isi_avis_pack.packmittel_nr_lieferant is
    'Packmittel-Nummer-Lieferant';

comment on column dirkspzm32.isi_avis_pack.slb_nr is
    'N8, Sendungs-Ladungs-Bezugsnummer, z.B. 12345678';

comment on column dirkspzm32.isi_avis_pack.stapelfaktor is
    'N1, Stapelfaktor, 1 = einfach stapelbar, 2 = zweifach stapelbar, usw., z.B. 2';

comment on column dirkspzm32.isi_avis_pack.verpackung_abmessung is
    'N12, Verpackungs-Abmessung, 4 Stellen Länge, 4 Stellen Breite, 4 Stellen Höhe';

comment on column dirkspzm32.isi_avis_pack.verpackung_kennung is
    'Verpackung-Kennung, M = Mehrweg-Verpackung, E = Einweg-Verpackung,z.B. M';


-- sqlcl_snapshot {"hash":"fe8b2686609cddb410c2d0b54ef4a5e8fa5f4c61","type":"COMMENT","name":"isi_avis_pack","schemaName":"dirkspzm32","sxml":""}