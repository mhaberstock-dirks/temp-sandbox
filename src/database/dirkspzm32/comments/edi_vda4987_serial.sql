comment on table DIRKSPZM32.EDI_VDA4987_SERIAL is 'VDA4987 Serial Number / Seriennummer bzw. lfd. Nummer';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."ARTICLE_ID" is 'Unique Identifier of Article; (null if PACK_ITEM_ID Element is set) (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."DOCUMENT_ID" is 'Unique Identifier of VDA4987 document; Master (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."PACK_ITEM_ID" is 'Unique Identifier of Packaging Item; (null if ARTICLE_ID Element is set) (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."POS" is 'Position number; Part of Primary Key';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SERIAL_GROUP_ID" is 'Unique Identifier of Serial Number Group; virtual; Part of Primary Key';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN1A" is 'Serial number (an..35); Serial number / Seriennummer ';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN1B" is 'Only used, if the serial number is longer than 35 digits (an..35); Serial number / Seriennummer ';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN2A" is 'Serial number (an..35); Serial number / Seriennummer ';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN2B" is 'Only used, if the serial number is longer than 35 digits (an..35); Serial number / Seriennummer ';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN3A" is 'Serial number (an..35); Serial number / Seriennummer ';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN3B" is 'Only used, if the serial number is longer than 35 digits (an..35); Serial number / Seriennummer ';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN4A" is 'Serial number (an..35); Serial number / Seriennummer ';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN4B" is 'Only used, if the serial number is longer than 35 digits (an..35); Serial number / Seriennummer ';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN5A" is 'Serial number (an..35); Serial number / Seriennummer ';
comment on column DIRKSPZM32.EDI_VDA4987_SERIAL."SN5B" is 'Only used, if the serial number is longer than 35 digits (an..35); Serial number / Seriennummer ';



-- sqlcl_snapshot {"hash":"fbc8857961e22b2b24c623e27233e2ba7d635af0","type":"COMMENT","name":"edi_vda4987_serial","schemaName":"dirkspzm32","sxml":""}