comment on table dirkspzm32.dis_cfg is
    'ISIPlus Data Integration Service Configuration';

comment on column dirkspzm32.dis_cfg.app_exename is
    'Name der Anwendung des bearbeitenden Servers';

comment on column dirkspzm32.dis_cfg.cfg_params is
    'Konfigurations-Parameter für diesen Connector (Script-Übergabe)';

comment on column dirkspzm32.dis_cfg.connector_caption is
    'Anzeige-Name des Connectors';

comment on column dirkspzm32.dis_cfg.connector_desc is
    'Beschreibung des Connectors';

comment on column dirkspzm32.dis_cfg.connector_name is
    'Eindeutiger Name des Connectors; keine Leerzeichen, Umlaute oder sonstige ungültige Zeichen. Muss als Verzeichnisname geeignet sein!'
    ;

comment on column dirkspzm32.dis_cfg.connector_type is
    'CON_IPS_FILE, CON_IPS_SAPRFC, CON_IPS_PCS';

comment on column dirkspzm32.dis_cfg.dest_address is
    'Hostname oder TCP/IP Adresse des Kommunikationsziels als Übergabe-Parameter ins Script, z.B. TCP/IP Adresse des ComServers bei USAGE=SCANNER'
    ;

comment on column dirkspzm32.dis_cfg.dest_address2 is
    'Hostname oder TCP/IP Adresse des 2. Kommunikationsziels als Übergabe-Parameter ins Script, z.B. TCP/IP Adresse des ComServers bei USAGE=SCANNER'
    ;

comment on column dirkspzm32.dis_cfg.dest_address3 is
    'Hostname oder TCP/IP Adresse des 3. Kommunikationsziels als Übergabe-Parameter ins Script, z.B. TCP/IP Adresse des ComServers bei USAGE=SCANNER'
    ;

comment on column dirkspzm32.dis_cfg.dest_port is
    'Portnummer des Kommunikationsziels als Übergabe-Parameter ins Script, z.B. benutzter Port des ComServers bei USAGE=SCANNER';

comment on column dirkspzm32.dis_cfg.dest_port2 is
    'Portnummer des 2. Kommunikationsziels als Übergabe-Parameter ins Script, z.B. benutzter Port des ComServers bei USAGE=SCANNER';

comment on column dirkspzm32.dis_cfg.dest_port3 is
    'Portnummer des 3. Kommunikationsziels als Übergabe-Parameter ins Script, z.B. benutzter Port des ComServers bei USAGE=SCANNER';

comment on column dirkspzm32.dis_cfg.enabled is
    'Konfigurationseintrag aktiv/inaktiv (T/F)';

comment on column dirkspzm32.dis_cfg.event_driven is
    'Ereignis-gesteuert (T/F), wenn T dann Event-Steuerung über ISIPlus Task Scheduler';

comment on column dirkspzm32.dis_cfg.event_type is
    'Ereignis-Steuerung; ET_EDGE = Flanke (einmalig); ET_PERIOD = Zeitraum (mehrfach)';

comment on column dirkspzm32.dis_cfg.file_input_dir is
    'Eingabeverzeichnis für Dateiverarbeitung aus Sicht des DIS, z.B. D:\INPUT\ oder UNC-Pfad z.B. \\10.1.2.42\wit\akf\sap_fls\';

comment on column dirkspzm32.dis_cfg.file_input_mask is
    'Suchmaske im Eingabeverzeichnis für Dateiverarbeitung FindFirst, FindNext, z.B. ZACHSE*.xml';

comment on column dirkspzm32.dis_cfg.file_output_dir is
    'Ausgabeverzeichnis für Dateiverarbeitung aus Sicht des DIS, z.B. D:\OUTPUT\ oder UNC-Pfad z.B. \\10.1.2.42\wit\akf\fls_sap\';

comment on column dirkspzm32.dis_cfg.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.dis_cfg.hostname is
    'Hostname oder TCP/IP Adresse des bearbeitenden Servers';

comment on column dirkspzm32.dis_cfg.host_cfg_name is
    'Name des Host Konfigurations-Eintrags bei Connector Type CON_IPS_SAPRFC, siehe S_HOST_CFG';

comment on column dirkspzm32.dis_cfg.instance_id is
    'Instanznummer des bearbeitenden Servers';

comment on column dirkspzm32.dis_cfg.isi_script_display_func is
    'Funktionsname für die Darstellung der Visualisierung bei Connector Type CON_IPS_PCS';

comment on column dirkspzm32.dis_cfg.isi_script_file_input_func is
    'Script Funktionsname bei Connector Type CON_IPS_FILE, z.B. ProcessInputFile, wird bei vorhandenem Input File aufgerufen';

comment on column dirkspzm32.dis_cfg.isi_script_name is
    'Script Name, main() wird bei jedem Zyklus aufgerufen';

comment on column dirkspzm32.dis_cfg.isi_script_process_func is
    'Funktionsname für die Ausführung der Prozess-Daten bei Connector Type CON_IPS_PCS';

comment on column dirkspzm32.dis_cfg.loop_interval_ms is
    'Loop-Intervall in Millisekunden, dient als Taktgeber für den Zyklus';

comment on column dirkspzm32.dis_cfg.poll_interval_ms is
    'Poll-Intervall in Millisekunden';

comment on column dirkspzm32.dis_cfg.process_data is
    'Parameter-Namen und -Werte für die Visualisierungs-Anzeige bei Connector Type CON_IPS_PCS';

comment on column dirkspzm32.dis_cfg.p_connector_name is
    'Parent Connector Name, Name des Parent Connectors zur Abbildung von Connector-Hierarchien, z.B. bei USAGE=SCANNER der Konzentratorbetrieb über StarGates'
    ;

comment on column dirkspzm32.dis_cfg.service_port is
    'Lokale Portnummer für Remote-Monitoring dieses Connectors als Übergabe-Parameter ins Script';

comment on column dirkspzm32.dis_cfg.sid is
    'SID';

comment on column dirkspzm32.dis_cfg.uplink_port is
    'Lokale Portnummer an der sich Childs an diesem Parent connectieren dürfen (Uplink-Connection) - als Übergabe-Parameter ins Script, z.B. bei USAGE=ACCESSPOINT, alle Scanner eines StarGates oder eine Anwendung wie z.B. der MFR Server'
    ;

comment on column dirkspzm32.dis_cfg.usage is
    'Gebrauchsart, Klassifizierung nach Benutzung: UNKNOWN, IMPORT, EXPORT, HOST, PLC, ROBOT, ACCESSPOINT, SCANNER';


-- sqlcl_snapshot {"hash":"19aa47b971ad39dfee5465b135fd17a604de2828","type":"COMMENT","name":"dis_cfg","schemaName":"dirkspzm32","sxml":""}