comment on table dirkspzm32.mde_res_akt is
    'Maschinentabelle und aktueller Zustand';

comment on column dirkspzm32.mde_res_akt.akt_aufgabe is
    'Akt. Aufgabe P=Produzieren R=Rüsten NULL=Kein Auftrag angemeldtet sonst P oder R Produktion oder Ruesten';

comment on column dirkspzm32.mde_res_akt.auftrag is
    'Aufragsnummer FA_NR+FA_AG+UPOS (Systemnummer) aktuell';

comment on column dirkspzm32.mde_res_akt.change_date is
    'Geändert Datum / Zeit Trigger';

comment on column dirkspzm32.mde_res_akt.create_date is
    'Erstellt Datum / Zeit Trigger';

comment on column dirkspzm32.mde_res_akt.fa_ag is
    'Arbeitsgang aktuell';

comment on column dirkspzm32.mde_res_akt.fa_upos is
    'Pos / Folge (Splitt) aktuell';

comment on column dirkspzm32.mde_res_akt.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.mde_res_akt.leitzahl is
    'Fertigungsauftrag aktuell';

comment on column dirkspzm32.mde_res_akt.lhm_id_akt is
    'Aktuelle Spule Produktion';

comment on column dirkspzm32.mde_res_akt.lhm_id_next is
    'Nächste Spule FK_spulen_lhm_id';

comment on column dirkspzm32.mde_res_akt.lhm_id_rw_akt is
    'Aktuelle Spule Leitermaterial';

comment on column dirkspzm32.mde_res_akt.lhm_id_rw_next is
    'Nächste Spule Leitermaterial';

comment on column dirkspzm32.mde_res_akt.mde_bstd_min is
    'Betriebsstunden in Min. gesamt';

comment on column dirkspzm32.mde_res_akt.mde_menge is
    'Menge in Meter aktueller FA';

comment on column dirkspzm32.mde_res_akt.mde_menge_t is
    'Menge in Meter (Tageszähler)';

comment on column dirkspzm32.mde_res_akt.mde_prod_min is
    'Produktionszeit in Min.';

comment on column dirkspzm32.mde_res_akt.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk';

comment on column dirkspzm32.mde_res_akt.res_name is
    'Maschinenname incl. Gang Bsp. F10_001';

comment on column dirkspzm32.mde_res_akt.res_status is
    '0 = Maschine läuft, -1 unbegründete Störung sonst Störungsnr';

comment on column dirkspzm32.mde_res_akt.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.mde_res_akt.status is
    'N = Neu
								I = ISI hat geändert
								M = MDE Manager hat geändert
								UE = Änderung ist übernommen';


-- sqlcl_snapshot {"hash":"13c5fdc5e48d282a6632505d93600f2b1b59b1dd","type":"COMMENT","name":"mde_res_akt","schemaName":"dirkspzm32","sxml":""}