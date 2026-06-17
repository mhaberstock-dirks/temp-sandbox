comment on table DIRKSPZM32.ISI_RESOURCE is 'Stammdaten aller Ressourcen';
comment on column DIRKSPZM32.ISI_RESOURCE."ADRESS_ID" is 'Zu welcher Adresse gehört diese Resource';
comment on column DIRKSPZM32.ISI_RESOURCE."COM_NAME" is 'Angeschlossen an ComServer';
comment on column DIRKSPZM32.ISI_RESOURCE."DRUCKER" is 'Drucker auf dem gedruckt werden soll';
comment on column DIRKSPZM32.ISI_RESOURCE."FEHLER_SCHLUESSEL" is 'Fehlerschlüssel der Resource für Gruppierung der Fehlerstati';
comment on column DIRKSPZM32.ISI_RESOURCE."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_RESOURCE."GRUPPE" is 'Gehört zu eine Resource (Maschinengruppe, Maschine Werkzeug)';
comment on column DIRKSPZM32.ISI_RESOURCE."KATEGORIE" is 'Kategurie der Resource (Bei MS z.B. PRM = Produktionsmaschine, ROB = Roboter WA = Waage';
comment on column DIRKSPZM32.ISI_RESOURCE."KATEGORIE_TYP" is 'waage Typ, evtl später für besondere Abhandlung';
comment on column DIRKSPZM32.ISI_RESOURCE."LAGER_FERTIG" is 'Lagerplatz der Fertigware';
comment on column DIRKSPZM32.ISI_RESOURCE."LAGER_ROH" is 'Lagerplatz für die Rohstoffe';
comment on column DIRKSPZM32.ISI_RESOURCE."LINIE_RES_ID" is 'Zu welcher Linie gehört diese Resource';
comment on column DIRKSPZM32.ISI_RESOURCE."LOGIN_ID_VERANTW" is 'wer ist für diese Resource verantwortlich';
comment on column DIRKSPZM32.ISI_RESOURCE."MAX_KG" is 'Max Gewicht KG';
comment on column DIRKSPZM32.ISI_RESOURCE."ORTS_KZ" is 'Ortskennzeichen der Resource (sinnvoll für Maschinen, schnurgebundene Scanner, etc)';
comment on column DIRKSPZM32.ISI_RESOURCE."PARENT_RES_ID" is 'Eingebaut in Resource';
comment on column DIRKSPZM32.ISI_RESOURCE."PARENT_RES_START" is 'Seit wann in Resource eingebaut';
comment on column DIRKSPZM32.ISI_RESOURCE."POLLMSEK" is 'Poll ms für ComServer oder anderen Anschluss';
comment on column DIRKSPZM32.ISI_RESOURCE."POS_INFO" is 'Kurze Umgebungs-, Positionsbeschr., wo eingebaut';
comment on column DIRKSPZM32.ISI_RESOURCE."RES_EXT_NAME" is 'Externer Nane für Maschine etc';
comment on column DIRKSPZM32.ISI_RESOURCE."RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk';
comment on column DIRKSPZM32.ISI_RESOURCE."RES_KST" is 'Kostenstelle der Resource';
comment on column DIRKSPZM32.ISI_RESOURCE."RES_NAME" is 'Maschinennummer oder Werkzeugid';
comment on column DIRKSPZM32.ISI_RESOURCE."RES_PARAMS_CFG" is 'CSV Parameternamen für diese Ressource (Teach- und Konfigurationswerte werden in RES_LAM_PARAMS gespeichert)';
comment on column DIRKSPZM32.ISI_RESOURCE."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_RESOURCE."TEXT" is 'Beschreibender Text';
comment on column DIRKSPZM32.ISI_RESOURCE."TYP" is '###R4 ENUM!!!###
MHG=MaschHauptGruppe,
MG=MaschGruppe,
MS=Maschine,
MPG=MaschProdGruppe,
MPP=MaschProdPlatz,
WKZ=Werkzeug,
ST = Stapler,
LI = Linie,
RBG = Regalbediengerät,
IP = IdentifizierungsPlatz,
DR = Drucker,
FHM = Fertugungshilfsmittel,
KP = KommPlatz,
KPZ = KommZielPlatz,
KPQ = KommQuellPlatz,
VP = Verpackungsplatz,
MSMP = Maschine Meldepunkt für Prozessdaten
MA = Magazin
MAG = Magazin Gruppe
ZET = ZeitErfassungsTerminal';
comment on column DIRKSPZM32.ISI_RESOURCE."VARIANTE" is 'Aktuelle Variante der Resource';
comment on column DIRKSPZM32.ISI_RESOURCE."VISUNAME" is 'Name in der Visu';



-- sqlcl_snapshot {"hash":"d7f4a8f5360cfb65e3d27cc2a0a6702173decbc2","type":"COMMENT","name":"isi_resource","schemaName":"dirkspzm32","sxml":""}