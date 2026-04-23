comment on table dirkspzm32.pzm_lohnarten is
    'Lohnarten für die Übertragung an die Lohnbuchhaltug';

comment on column dirkspzm32.pzm_lohnarten.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_lohnarten.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_lohnarten.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_lohnarten.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_lohnarten.lz_alternativ_loa_id is
    'Alternative Lohnart für diese';

comment on column dirkspzm32.pzm_lohnarten.lz_bemerkungen is
    'Bemerkungen';

comment on column dirkspzm32.pzm_lohnarten.lz_einheit is
    'DD = Tag, HH24 = Stunden';

comment on column dirkspzm32.pzm_lohnarten.lz_feiertag is
    'Ist die Lohnart an einem Ferertag gekoppelt SF = Sonderfeiertag';

comment on column dirkspzm32.pzm_lohnarten.lz_gueltig_ab is
    'Lohnart Gültig ab';

comment on column dirkspzm32.pzm_lohnarten.lz_gueltig_bis is
    'Lohnart Gültig bis';

comment on column dirkspzm32.pzm_lohnarten.lz_id is
    'ID Der Lohnart. Diese ID ist die referenz in der Lohnbuchhaltung';

comment on column dirkspzm32.pzm_lohnarten.lz_is_erp_loa is
    'T = diese LOA in das ERP übertragen, F = keine Übertragung ins ERP';

comment on column dirkspzm32.pzm_lohnarten.lz_konto_bus is
    'Buchungsschlüssel für die Verbuchung in einem Stundenkonto';

comment on column dirkspzm32.pzm_lohnarten.lz_konto_name_kurz is
    'Ist die Lohnart für die Verbuchung in einem Stundenkonto. Z.B. Flexistunden';

comment on column dirkspzm32.pzm_lohnarten.lz_link_loa_id is
    'ggf. verknüpfte Lohnart (z.B. eine in Tagen geführte LOA verknüpft mit einer Std. LOA)';

comment on column dirkspzm32.pzm_lohnarten.lz_lohnart is
    'Bezeichnung / Beschreibung der Lohnart';

comment on column dirkspzm32.pzm_lohnarten.lz_lohnart_grp is
    'Zur Verknüpfung von Lohnarten';

comment on column dirkspzm32.pzm_lohnarten.lz_operator is
    'Operatur zum Regelwerk Bsp.: Nachtzuschlag 25 % bis max. 10 Stunden <= 10 oder !N = diese LOA darf nicht mit Überstunden verrechnet werden, also Überstunden abziehen, wenn vorhanden'
    ;

comment on column dirkspzm32.pzm_lohnarten.lz_reset_monats_ende is
    'Reset am Monatsende ja = 1, nein = 0 in im zusammenhang mit VA_RESET_MONATS_ENDE zu betrachten';

comment on column dirkspzm32.pzm_lohnarten.lz_stunden is
    'Stunden für LZ_OPERATOR';

comment on column dirkspzm32.pzm_lohnarten.lz_typ is
    'ARB_STD = normale Arbeitsstunden, UEB_STD = Überstunden, ZU_STD = Zuschläge, ABW = Abwesenheitsart';

comment on column dirkspzm32.pzm_lohnarten.lz_uhrz_bis is
    'Lohnart Gültig bis zu dieser Ujrzeit (Datumsteil wird ignoriert)';

comment on column dirkspzm32.pzm_lohnarten.lz_uhrz_von is
    'Lohnart Gültig ab dieser Ujrzeit (Datumsteil wird ignoriert)';

comment on column dirkspzm32.pzm_lohnarten.lz_wochentag is
    'Ist die Lohnart an einem bestimmten Wochentag gekoppelt z.B. Samstag oder Sonntag';


-- sqlcl_snapshot {"hash":"010da8f7a6467b15f0b58a9237f31527e0476c58","type":"COMMENT","name":"pzm_lohnarten","schemaName":"dirkspzm32","sxml":""}