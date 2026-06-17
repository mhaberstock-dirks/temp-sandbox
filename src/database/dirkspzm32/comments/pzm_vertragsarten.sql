comment on table DIRKSPZM32.PZM_VERTRAGSARTEN is 'Liste der Vertragsarten';
comment on column DIRKSPZM32.PZM_VERTRAGSARTEN."VA_BEMERKUNG" is 'Bemerkung zur Vertragsart';
comment on column DIRKSPZM32.PZM_VERTRAGSARTEN."VA_BIS_MONAT_ENDE_SIM" is 'Diese Arbeiter werden im vorraus abgerechnet und der Restmonat wird simuliert';
comment on column DIRKSPZM32.PZM_VERTRAGSARTEN."VA_BIS_STD_AUSZAHLEN" is 'Bis zu dieser Grenze weden die Stunden ausgezahlt ohne Überstundenprozente';
comment on column DIRKSPZM32.PZM_VERTRAGSARTEN."VA_BIS_STD_AUSZAHLEN_ZEITEINHEIT" is 'DD = Tag, WW = Woche, MM = Monat - Bis zu diser Einheit weden die Anzahl Stunden in va_bis_std_auszahlen ausgezahlt. z.B. 40 Stunden je Woche';
comment on column DIRKSPZM32.PZM_VERTRAGSARTEN."VA_ID" is 'Vertragsart-ID (Primary-Key)';
comment on column DIRKSPZM32.PZM_VERTRAGSARTEN."VA_LOA_STUNDEN_ABRECHNUNG" is 'T Bedeutet, dass die Stunden in einer LOÁ übertragen werden müssen';
comment on column DIRKSPZM32.PZM_VERTRAGSARTEN."VA_NAME" is 'Name der Vertragsart';
comment on column DIRKSPZM32.PZM_VERTRAGSARTEN."VA_RESET_MONATS_ENDE" is 'Reset am Monatsende ja = 1, nein = 0 im zusammenhang mit LZ_RESET_MONATS_ENDE zu betrachten';



-- sqlcl_snapshot {"hash":"bc1f798a120c0376d738d7bf9a977693d5991f23","type":"COMMENT","name":"pzm_vertragsarten","schemaName":"dirkspzm32","sxml":""}