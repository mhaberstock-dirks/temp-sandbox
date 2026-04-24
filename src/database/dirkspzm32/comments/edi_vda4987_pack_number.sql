comment on table dirkspzm32.edi_vda4987_pack_number is
    'VDA4987 Packaging Item Number / Verpackungsartikelnummer';

comment on column dirkspzm32.edi_vda4987_pack_number.cod_no is
    '1=true, 0=false, Trigger Segment, COD+NO''';

comment on column dirkspzm32.edi_vda4987_pack_number.document_id is
    'Unique Identifier of VDA4987 document; Master (FK)';

comment on column dirkspzm32.edi_vda4987_pack_number.object_identifier1 is
    'Object identifier (an22); e.g. 1JUN123456789000000955; Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.object_identifier2 is
    'Object identifier (an22); e.g. 1JUN123456789000000955; Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.object_identifier3 is
    'Object identifier (an22); e.g. 1JUN123456789000000955; Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.object_identifier4 is
    'Object identifier (an22); e.g. 1JUN123456789000000955; Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.object_identifier5 is
    'Object identifier (an22); e.g. 1JUN123456789000000955; Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.package_number1 is
    'Package number specified by supplier (an9); Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.package_number2 is
    'Package number specified by supplier (an9); Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.package_number3 is
    'Package number specified by supplier (an9); Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.package_number4 is
    'Package number specified by supplier (an9); Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.package_number5 is
    'Package number specified by supplier (an9); Label ID of the packaging (packaging item number) / Label-ID der Verpackung (Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack_number.pack_item_id is
    'Unique Identifier of Packaging Item; Part of Primary Key (FK)';

comment on column dirkspzm32.edi_vda4987_pack_number.pos is
    'Position number; Part of Primary Key (n..4)';


-- sqlcl_snapshot {"hash":"218a7314d8e829605402dbf067276439e6e36b8e","type":"COMMENT","name":"edi_vda4987_pack_number","schemaName":"dirkspzm32","sxml":""}