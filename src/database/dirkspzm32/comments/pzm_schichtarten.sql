comment on table dirkspzm32.pzm_schichtarten is
    'Schichtarten beschreibt den Tageszeitplan incl. der Pausen und an welchen Wochentagen diese Konfiguration gilt';

comment on column dirkspzm32.pzm_schichtarten.calc_basis is
    'FESTZ = feste Zeiten, GLEITZ = Gleitzeit (std_pro_tag is die Basis)';

comment on column dirkspzm32.pzm_schichtarten.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_schichtarten.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_schichtarten.flex_max_std_pro_tag is
    'Maximal flexible stunden pro tag (alles was mehr ist, wird als überstd gewertet)';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause1_arb_std is
    'Arbeitsstunden: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause1_dauer_min is
    'Pausendauer in Minuten: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause1_unbez is
    'T = Pausendauer für mehrstufige Pausenzeiten unbezahlt, F = bezahlt';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause2_arb_std is
    'Arbeitsstunden: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause2_dauer_min is
    'Pausendauer in Minuten: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause2_unbez is
    'T = Pausendauer für mehrstufige Pausenzeiten unbezahlt, F = bezahlt';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause3_arb_std is
    'Arbeitsstunden: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause3_dauer_min is
    'Pausendauer in Minuten: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause3_unbez is
    'T = Pausendauer für mehrstufige Pausenzeiten unbezahlt, F = bezahlt';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause_dauer_min is
    'Pausendauer in Minuten für die Regelarbeitszeit';

comment on column dirkspzm32.pzm_schichtarten.gleitz_pause_unbez is
    'T = Pausendauer für die Regelarbeitszeit unbezahlt, F = bezahlt';

comment on column dirkspzm32.pzm_schichtarten.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_schichtarten.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_schichtarten.sa_beginn is
    'Schichtbeginn';

comment on column dirkspzm32.pzm_schichtarten.sa_bemerkung is
    'Bemerkung zur Schichtart';

comment on column dirkspzm32.pzm_schichtarten.sa_bewertung_beginn is
    'Die Bewertung der Schichtart zum Anfang oder zum Ende der Schicht. 0 = Schichtanfang, 1 = Schichtende';

comment on column dirkspzm32.pzm_schichtarten.sa_ende is
    'Schichtende';

comment on column dirkspzm32.pzm_schichtarten.sa_ende_nachlauf_min is
    'Nachlaufzeit in der bei Ende der Schicht nicht Minutengenau sonder auf das Schichtende kalkuliert wird (Feierabendzeit)';

comment on column dirkspzm32.pzm_schichtarten.sa_kurzname is
    'Schichtart Kurzname (wird als Referenz in der Zeiterfassung verwendet) (Unique-Key)';

comment on column dirkspzm32.pzm_schichtarten.sa_name is
    'Name der Schichtart (Primary-Key)';

comment on column dirkspzm32.pzm_schichtarten.sa_pause1_beginn is
    'Erste Pause Anfang';

comment on column dirkspzm32.pzm_schichtarten.sa_pause1_dauer is
    'Erste Pause Dauer in Minuten';

comment on column dirkspzm32.pzm_schichtarten.sa_pause1_ende is
    'Erste Pause Ende';

comment on column dirkspzm32.pzm_schichtarten.sa_pause1_unbez is
    '0 = Nein, 1 = Ja';

comment on column dirkspzm32.pzm_schichtarten.sa_pause2_beginn is
    'Zweite Pause Anfang';

comment on column dirkspzm32.pzm_schichtarten.sa_pause2_dauer is
    'Zweite Pause Dauer in Minuten';

comment on column dirkspzm32.pzm_schichtarten.sa_pause2_ende is
    'Zweite Pause Ende';

comment on column dirkspzm32.pzm_schichtarten.sa_pause2_unbez is
    '0 = Nein, 1 = Ja';

comment on column dirkspzm32.pzm_schichtarten.sa_standard is
    'Standardschicht (wenn keine zutreffende Schicht gefunden wurde)';

comment on column dirkspzm32.pzm_schichtarten.sa_std_pro_tag is
    'Stunden pro Tag';

comment on column dirkspzm32.pzm_schichtarten.sa_wot_di is
    '0 = Nein, 1 = Ja';

comment on column dirkspzm32.pzm_schichtarten.sa_wot_do is
    '0 = Nein, 1 = Ja';

comment on column dirkspzm32.pzm_schichtarten.sa_wot_fr is
    '0 = Nein, 1 = Ja';

comment on column dirkspzm32.pzm_schichtarten.sa_wot_mi is
    '0 = Nein, 1 = Ja';

comment on column dirkspzm32.pzm_schichtarten.sa_wot_mo is
    '0 = Nein, 1 = Ja';

comment on column dirkspzm32.pzm_schichtarten.sa_wot_sa is
    '0 = Nein, 1 = Ja';

comment on column dirkspzm32.pzm_schichtarten.sa_wot_so is
    '0 = Nein, 1 = Ja';


-- sqlcl_snapshot {"hash":"dbd063d7c0f2e515f18a3b3100765b1849e869c5","type":"COMMENT","name":"pzm_schichtarten","schemaName":"dirkspzm32","sxml":""}