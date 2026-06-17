comment on table DIRKSPZM32.DIS_CFG is 'ISIPlus Data Integration Service Configuration';
comment on column DIRKSPZM32.DIS_CFG."APP_EXENAME" is 'Name der Anwendung des bearbeitenden Servers';
comment on column DIRKSPZM32.DIS_CFG."CFG_PARAMS" is 'Konfigurations-Parameter für diesen Connector (Script-Übergabe)';
comment on column DIRKSPZM32.DIS_CFG."CONNECTOR_CAPTION" is 'Anzeige-Name des Connectors';
comment on column DIRKSPZM32.DIS_CFG."CONNECTOR_DESC" is 'Beschreibung des Connectors';
comment on column DIRKSPZM32.DIS_CFG."CONNECTOR_NAME" is 'Eindeutiger Name des Connectors; keine Leerzeichen, Umlaute oder sonstige ungültige Zeichen. Muss als Verzeichnisname geeignet sein!';
comment on column DIRKSPZM32.DIS_CFG."CONNECTOR_TYPE" is 'CON_IPS_FILE, CON_IPS_SAPRFC, CON_IPS_PCS';
comment on column DIRKSPZM32.DIS_CFG."DEST_ADDRESS" is 'Hostname oder TCP/IP Adresse des Kommunikationsziels als Übergabe-Parameter ins Script, z.B. TCP/IP Adresse des ComServers bei USAGE=SCANNER';
comment on column DIRKSPZM32.DIS_CFG."DEST_ADDRESS2" is 'Hostname oder TCP/IP Adresse des 2. Kommunikationsziels als Übergabe-Parameter ins Script, z.B. TCP/IP Adresse des ComServers bei USAGE=SCANNER';
comment on column DIRKSPZM32.DIS_CFG."DEST_ADDRESS3" is 'Hostname oder TCP/IP Adresse des 3. Kommunikationsziels als Übergabe-Parameter ins Script, z.B. TCP/IP Adresse des ComServers bei USAGE=SCANNER';
comment on column DIRKSPZM32.DIS_CFG."DEST_PORT" is 'Portnummer des Kommunikationsziels als Übergabe-Parameter ins Script, z.B. benutzter Port des ComServers bei USAGE=SCANNER';
comment on column DIRKSPZM32.DIS_CFG."DEST_PORT2" is 'Portnummer des 2. Kommunikationsziels als Übergabe-Parameter ins Script, z.B. benutzter Port des ComServers bei USAGE=SCANNER';
comment on column DIRKSPZM32.DIS_CFG."DEST_PORT3" is 'Portnummer des 3. Kommunikationsziels als Übergabe-Parameter ins Script, z.B. benutzter Port des ComServers bei USAGE=SCANNER';
comment on column DIRKSPZM32.DIS_CFG."ENABLED" is 'Konfigurationseintrag aktiv/inaktiv (T/F)';
comment on column DIRKSPZM32.DIS_CFG."EVENT_DRIVEN" is 'Ereignis-gesteuert (T/F), wenn T dann Event-Steuerung über ISIPlus Task Scheduler';
comment on column DIRKSPZM32.DIS_CFG."EVENT_TYPE" is 'Ereignis-Steuerung; ET_EDGE = Flanke (einmalig); ET_PERIOD = Zeitraum (mehrfach)';
comment on column DIRKSPZM32.DIS_CFG."FILE_INPUT_DIR" is 'Eingabeverzeichnis für Dateiverarbeitung aus Sicht des DIS, z.B. D:\INPUT\ oder UNC-Pfad z.B. \\10.1.2.42\wit\akf\sap_fls\';
comment on column DIRKSPZM32.DIS_CFG."FILE_INPUT_MASK" is 'Suchmaske im Eingabeverzeichnis für Dateiverarbeitung FindFirst, FindNext, z.B. ZACHSE*.xml';
comment on column DIRKSPZM32.DIS_CFG."FILE_OUTPUT_DIR" is 'Ausgabeverzeichnis für Dateiverarbeitung aus Sicht des DIS, z.B. D:\OUTPUT\ oder UNC-Pfad z.B. \\10.1.2.42\wit\akf\fls_sap\';
comment on column DIRKSPZM32.DIS_CFG."FIRMA_NR" is 'Firma Nr.';
comment on column DIRKSPZM32.DIS_CFG."HOSTNAME" is 'Hostname oder TCP/IP Adresse des bearbeitenden Servers';
comment on column DIRKSPZM32.DIS_CFG."HOST_CFG_NAME" is 'Name des Host Konfigurations-Eintrags bei Connector Type CON_IPS_SAPRFC, siehe S_HOST_CFG';
comment on column DIRKSPZM32.DIS_CFG."INSTANCE_ID" is 'Instanznummer des bearbeitenden Servers';
comment on column DIRKSPZM32.DIS_CFG."ISI_SCRIPT_DISPLAY_FUNC" is 'Funktionsname für die Darstellung der Visualisierung bei Connector Type CON_IPS_PCS';
comment on column DIRKSPZM32.DIS_CFG."ISI_SCRIPT_FILE_INPUT_FUNC" is 'Script Funktionsname bei Connector Type CON_IPS_FILE, z.B. ProcessInputFile, wird bei vorhandenem Input File aufgerufen';
comment on column DIRKSPZM32.DIS_CFG."ISI_SCRIPT_NAME" is 'Script Name, main() wird bei jedem Zyklus aufgerufen';
comment on column DIRKSPZM32.DIS_CFG."ISI_SCRIPT_PROCESS_FUNC" is 'Funktionsname für die Ausführung der Prozess-Daten bei Connector Type CON_IPS_PCS';
comment on column DIRKSPZM32.DIS_CFG."LOOP_INTERVAL_MS" is 'Loop-Intervall in Millisekunden, dient als Taktgeber für den Zyklus';
comment on column DIRKSPZM32.DIS_CFG."POLL_INTERVAL_MS" is 'Poll-Intervall in Millisekunden';
comment on column DIRKSPZM32.DIS_CFG."PROCESS_DATA" is 'Parameter-Namen und -Werte für die Visualisierungs-Anzeige bei Connector Type CON_IPS_PCS';
comment on column DIRKSPZM32.DIS_CFG."P_CONNECTOR_NAME" is 'Parent Connector Name, Name des Parent Connectors zur Abbildung von Connector-Hierarchien, z.B. bei USAGE=SCANNER der Konzentratorbetrieb über StarGates';
comment on column DIRKSPZM32.DIS_CFG."SERVICE_PORT" is 'Lokale Portnummer für Remote-Monitoring dieses Connectors als Übergabe-Parameter ins Script';
comment on column DIRKSPZM32.DIS_CFG."SID" is 'SID';
comment on column DIRKSPZM32.DIS_CFG."UPLINK_PORT" is 'Lokale Portnummer an der sich Childs an diesem Parent connectieren dürfen (Uplink-Connection) - als Übergabe-Parameter ins Script, z.B. bei USAGE=ACCESSPOINT, alle Scanner eines StarGates oder eine Anwendung wie z.B. der MFR Server';
comment on column DIRKSPZM32.DIS_CFG."USAGE" is 'Gebrauchsart, Klassifizierung nach Benutzung: UNKNOWN, IMPORT, EXPORT, HOST, PLC, ROBOT, ACCESSPOINT, SCANNER';



-- sqlcl_snapshot {"hash":"28ee1c3706ae8b04537ca26afa3ae8614fad4452","type":"COMMENT","name":"dis_cfg","schemaName":"dirkspzm32","sxml":""}