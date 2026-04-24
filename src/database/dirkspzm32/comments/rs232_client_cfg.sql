comment on column dirkspzm32.rs232_client_cfg.app_exename is
    'Name of Executable configuration belongs to';

comment on column dirkspzm32.rs232_client_cfg.baudrate is
    'BaudRate: 110, 300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 38400, 56000, 57600, 115200, 128000, 256000';

comment on column dirkspzm32.rs232_client_cfg.comport is
    'Name of ComPort, e.g. COM1';

comment on column dirkspzm32.rs232_client_cfg.databits is
    'DataBits: 5, 6, 7, 8';

comment on column dirkspzm32.rs232_client_cfg.dest_host is
    'TCP/IP Address or hostname of destination peer';

comment on column dirkspzm32.rs232_client_cfg.dest_mc is
    'Destination MessageCommand, default -1 (MSG_MC_NO_COMMAND)';

comment on column dirkspzm32.rs232_client_cfg.dest_mode is
    'DestinationMode: local, client, server, oracle';

comment on column dirkspzm32.rs232_client_cfg.dest_mt is
    'Destination MessageType, default -1 (MSG_MT_NO_TYPE)';

comment on column dirkspzm32.rs232_client_cfg.dest_pfxchar is
    'decimal ASCII Code of Prefix Char if using PFX/SFX';

comment on column dirkspzm32.rs232_client_cfg.dest_port is
    'Port number of destination peer';

comment on column dirkspzm32.rs232_client_cfg.dest_protocol is
    'Protocol: RAW, ISI_MESSAGE, STX/ETX, CR/LF, 3964R, PFX/SFX';

comment on column dirkspzm32.rs232_client_cfg.dest_sfxchar is
    'decimal ASCII Code of Suffix Char if using PFX/SFX';

comment on column dirkspzm32.rs232_client_cfg.enabled is
    'RS232 Client enabled T or disabled F';

comment on column dirkspzm32.rs232_client_cfg.firma_nr is
    'Company Number';

comment on column dirkspzm32.rs232_client_cfg.flowcontrol is
    'FlowControl: none, hardware, software';

comment on column dirkspzm32.rs232_client_cfg.hostname is
    'Name of Host configuration belongs to';

comment on column dirkspzm32.rs232_client_cfg.instance_id is
    'Instance ID - reserved for future use';

comment on column dirkspzm32.rs232_client_cfg.parity is
    'Parity: none, even, odd';

comment on column dirkspzm32.rs232_client_cfg.response_req is
    'Response required to source envelope T/F';

comment on column dirkspzm32.rs232_client_cfg.sid is
    'System ID';

comment on column dirkspzm32.rs232_client_cfg.src_pfxchar is
    'decimal ASCII Code of Prefix Char if using PFX/SFX';

comment on column dirkspzm32.rs232_client_cfg.src_protocol is
    'Protocol: RAW, ISI_MESSAGE, STX/ETX, CR/LF, 3964R, PFX/SFX';

comment on column dirkspzm32.rs232_client_cfg.src_sfxchar is
    'decimal ASCII Code of Suffix Char if using PFX/SFX';

comment on column dirkspzm32.rs232_client_cfg.stopbits is
    'StopBits: 1, 2';


-- sqlcl_snapshot {"hash":"6b2b86e226600620b432052104e91cf7b08b6e5e","type":"COMMENT","name":"rs232_client_cfg","schemaName":"dirkspzm32","sxml":""}