comment on table dirkspzm32.isi_resource is
    'Stammdaten aller Ressourcen';

comment on column dirkspzm32.isi_resource.adress_id is
    'Zu welcher Adresse gehört diese Resource';

comment on column dirkspzm32.isi_resource.com_name is
    'Angeschlossen an ComServer';

comment on column dirkspzm32.isi_resource.drucker is
    'Drucker auf dem gedruckt werden soll';

comment on column dirkspzm32.isi_resource.fehler_schluessel is
    'Fehlerschlüssel der Resource für Gruppierung der Fehlerstati';

comment on column dirkspzm32.isi_resource.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_resource.gruppe is
    'Gehört zu eine Resource (Maschinengruppe, Maschine Werkzeug)';

comment on column dirkspzm32.isi_resource.kategorie is
    'Kategurie der Resource (Bei MS z.B. PRM = Produktionsmaschine, ROB = Roboter WA = Waage';

comment on column dirkspzm32.isi_resource.kategorie_typ is
    'waage Typ, evtl später für besondere Abhandlung';

comment on column dirkspzm32.isi_resource.lager_fertig is
    'Lagerplatz der Fertigware';

comment on column dirkspzm32.isi_resource.lager_roh is
    'Lagerplatz für die Rohstoffe';

comment on column dirkspzm32.isi_resource.linie_res_id is
    'Zu welcher Linie gehört diese Resource';

comment on column dirkspzm32.isi_resource.login_id_verantw is
    'wer ist für diese Resource verantwortlich';

comment on column dirkspzm32.isi_resource.max_kg is
    'Max Gewicht KG';

comment on column dirkspzm32.isi_resource.orts_kz is
    'Ortskennzeichen der Resource (sinnvoll für Maschinen, schnurgebundene Scanner, etc)';

comment on column dirkspzm32.isi_resource.parent_res_id is
    'Eingebaut in Resource';

comment on column dirkspzm32.isi_resource.parent_res_start is
    'Seit wann in Resource eingebaut';

comment on column dirkspzm32.isi_resource.pollmsek is
    'Poll ms für ComServer oder anderen Anschluss';

comment on column dirkspzm32.isi_resource.pos_info is
    'Kurze Umgebungs-, Positionsbeschr., wo eingebaut';

comment on column dirkspzm32.isi_resource.res_ext_name is
    'Externer Nane für Maschine etc';

comment on column dirkspzm32.isi_resource.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk';

comment on column dirkspzm32.isi_resource.res_kst is
    'Kostenstelle der Resource';

comment on column dirkspzm32.isi_resource.res_name is
    'Maschinennummer oder Werkzeugid';

comment on column dirkspzm32.isi_resource.res_params_cfg is
    'CSV Parameternamen für diese Ressource (Teach- und Konfigurationswerte werden in RES_LAM_PARAMS gespeichert)';

comment on column dirkspzm32.isi_resource.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_resource.text is
    'Beschreibender Text';

comment on column dirkspzm32.isi_resource.typ is
    '###R4 ENUM!!!###
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

comment on column dirkspzm32.isi_resource.variante is
    'Aktuelle Variante der Resource';

comment on column dirkspzm32.isi_resource.visuname is
    'Name in der Visu';


-- sqlcl_snapshot {"hash":"2c9e4da1cd38c827dabf2af125070254e507d672","type":"COMMENT","name":"isi_resource","schemaName":"dirkspzm32","sxml":""}