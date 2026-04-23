comment on table dirkspzm32.pzm_vertragsarten is
    'Liste der Vertragsarten';

comment on column dirkspzm32.pzm_vertragsarten.va_bemerkung is
    'Bemerkung zur Vertragsart';

comment on column dirkspzm32.pzm_vertragsarten.va_bis_monat_ende_sim is
    'Diese Arbeiter werden im vorraus abgerechnet und der Restmonat wird simuliert';

comment on column dirkspzm32.pzm_vertragsarten.va_bis_std_auszahlen is
    'Bis zu dieser Grenze weden die Stunden ausgezahlt ohne Überstundenprozente';

comment on column dirkspzm32.pzm_vertragsarten.va_bis_std_auszahlen_zeiteinheit is
    'DD = Tag, WW = Woche, MM = Monat - Bis zu diser Einheit weden die Anzahl Stunden in va_bis_std_auszahlen ausgezahlt. z.B. 40 Stunden je Woche'
    ;

comment on column dirkspzm32.pzm_vertragsarten.va_id is
    'Vertragsart-ID (Primary-Key)';

comment on column dirkspzm32.pzm_vertragsarten.va_loa_stunden_abrechnung is
    'T Bedeutet, dass die Stunden in einer LOÁ übertragen werden müssen';

comment on column dirkspzm32.pzm_vertragsarten.va_name is
    'Name der Vertragsart';

comment on column dirkspzm32.pzm_vertragsarten.va_reset_monats_ende is
    'Reset am Monatsende ja = 1, nein = 0 im zusammenhang mit LZ_RESET_MONATS_ENDE zu betrachten';


-- sqlcl_snapshot {"hash":"dad40d887895601c40d368f0afb60549f08d5d08","type":"COMMENT","name":"pzm_vertragsarten","schemaName":"dirkspzm32","sxml":""}