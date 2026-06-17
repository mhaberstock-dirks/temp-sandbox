comment on column DIRKSPZM32.RS232_CLIENT_CFG."APP_EXENAME" is 'Name of Executable configuration belongs to';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."BAUDRATE" is 'BaudRate: 110, 300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 38400, 56000, 57600, 115200, 128000, 256000';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."COMPORT" is 'Name of ComPort, e.g. COM1';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."DATABITS" is 'DataBits: 5, 6, 7, 8';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."DEST_HOST" is 'TCP/IP Address or hostname of destination peer';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."DEST_MC" is 'Destination MessageCommand, default -1 (MSG_MC_NO_COMMAND)';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."DEST_MODE" is 'DestinationMode: local, client, server, oracle';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."DEST_MT" is 'Destination MessageType, default -1 (MSG_MT_NO_TYPE)';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."DEST_PFXCHAR" is 'decimal ASCII Code of Prefix Char if using PFX/SFX';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."DEST_PORT" is 'Port number of destination peer';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."DEST_PROTOCOL" is 'Protocol: RAW, ISI_MESSAGE, STX/ETX, CR/LF, 3964R, PFX/SFX';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."DEST_SFXCHAR" is 'decimal ASCII Code of Suffix Char if using PFX/SFX';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."ENABLED" is 'RS232 Client enabled T or disabled F';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."FIRMA_NR" is 'Company Number';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."FLOWCONTROL" is 'FlowControl: none, hardware, software';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."HOSTNAME" is 'Name of Host configuration belongs to';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."INSTANCE_ID" is 'Instance ID - reserved for future use';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."PARITY" is 'Parity: none, even, odd';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."RESPONSE_REQ" is 'Response required to source envelope T/F';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."SID" is 'System ID';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."SRC_PFXCHAR" is 'decimal ASCII Code of Prefix Char if using PFX/SFX';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."SRC_PROTOCOL" is 'Protocol: RAW, ISI_MESSAGE, STX/ETX, CR/LF, 3964R, PFX/SFX';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."SRC_SFXCHAR" is 'decimal ASCII Code of Suffix Char if using PFX/SFX';
comment on column DIRKSPZM32.RS232_CLIENT_CFG."STOPBITS" is 'StopBits: 1, 2';



-- sqlcl_snapshot {"hash":"d39946f120c86f4753b0fccb88063704c4cfc42b","type":"COMMENT","name":"rs232_client_cfg","schemaName":"dirkspzm32","sxml":""}