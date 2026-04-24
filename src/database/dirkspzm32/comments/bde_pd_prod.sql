comment on table dirkspzm32.bde_pd_prod is
    'Referenzen Produktion und Rohware als Vorgänge';

comment on column dirkspzm32.bde_pd_prod.abfuell_abschalt_fein is
    'Absch. Fein';

comment on column dirkspzm32.bde_pd_prod.abfuell_abschalt_grob is
    'Absch. Grob';

comment on column dirkspzm32.bde_pd_prod.abfuell_abschalt_mittel is
    'Absch. Mittel';

comment on column dirkspzm32.bde_pd_prod.abfuell_brutto is
    'Istmenge für der Abfüllung Brutto';

comment on column dirkspzm32.bde_pd_prod.abfuell_ist is
    'Istmenge für der Abfüllung';

comment on column dirkspzm32.bde_pd_prod.abfuell_silo is
    'Silo für Abfüllung';

comment on column dirkspzm32.bde_pd_prod.abfuell_soll is
    'Sollmenge für die Abfüllung';

comment on column dirkspzm32.bde_pd_prod.abfuell_tara is
    'Istmenge für der Abfüllung TARA';

comment on column dirkspzm32.bde_pd_prod.abfuell_toleranz_minus is
    'Toleranz Minus';

comment on column dirkspzm32.bde_pd_prod.abfuell_toleranz_plus is
    'Toleranz Plus';

comment on column dirkspzm32.bde_pd_prod.abnr is
    'Auftragsbestätigungsnummer des Kundenauftragsbestätigung';

comment on column dirkspzm32.bde_pd_prod.artikel_id is
    'Artikel ID in ISI_ARTIKEL';

comment on column dirkspzm32.bde_pd_prod.fae_id is
    'Fertigungs Einheit ID (Fertigungs Einheit ID (Entspricht z.B. der LTE_ID, kann aber auch eine Transpoder-ID je Teil sein)';

comment on column dirkspzm32.bde_pd_prod.fae_id_position is
    'R = Rechts, L = Links, V = Vorne, H = Hinten, O = Oben, U = Unten';

comment on column dirkspzm32.bde_pd_prod.fa_ag is
    'Aktueller Arbeitsgang der Leitzahl';

comment on column dirkspzm32.bde_pd_prod.fa_upos is
    'Unterposition der Arbeitsgangs';

comment on column dirkspzm32.bde_pd_prod.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.bde_pd_prod.lam_id is
    'Lager Artikel Mengen ID auf die gebucht wurde (Bestands Key)';

comment on column dirkspzm32.bde_pd_prod.leitzahl is
    'Fertigungsauftrag Nr. (Leitzahl)';

comment on column dirkspzm32.bde_pd_prod.ls_login_id is
    'Login ID des Erfassers';

comment on column dirkspzm32.bde_pd_prod.menge_a is
    'Gutmenger 1. Wahl';

comment on column dirkspzm32.bde_pd_prod.menge_b is
    '2. Wahl Menge';

comment on column dirkspzm32.bde_pd_prod.pd_netto_zeit is
    'Netto Produktionszeit';

comment on column dirkspzm32.bde_pd_prod.pers_nr is
    'Personalnummer des Maschinenführeres';

comment on column dirkspzm32.bde_pd_prod.prod_beginn is
    'Zeitpunkt des Produktionsbeginn';

comment on column dirkspzm32.bde_pd_prod.prod_ende is
    'Zeitpunkt des Produktionsende';

comment on column dirkspzm32.bde_pd_prod.prod_params is
    'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';

comment on column dirkspzm32.bde_pd_prod.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk';

comment on column dirkspzm32.bde_pd_prod.schrott is
    'Schrottmenge';

comment on column dirkspzm32.bde_pd_prod.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.bde_pd_prod.vorg_id is
    'Vorgangsnummer (Eindeutig für jede Fertigmeldung oder Rohwarenzug. auf der Maschine)';

comment on column dirkspzm32.bde_pd_prod.vorg_typ is
    '"PP" Produktion, "PB" Bezug auf Rohware, "PM" Material, "PR" Wie "PP" jedoch Anfahren n. Rüsten "PA" und "PR" = Auftragsanmeldung Produktion und Rüsten "QF"=Qualitätsfreigabe "KM" = Kortrektur PA-Satz durch Mitarbeiter'
    ;


-- sqlcl_snapshot {"hash":"20556127dd8091c578c0e8cb567c242307b5bcd6","type":"COMMENT","name":"bde_pd_prod","schemaName":"dirkspzm32","sxml":""}