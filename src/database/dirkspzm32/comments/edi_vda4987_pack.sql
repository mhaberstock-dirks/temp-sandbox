comment on table dirkspzm32.edi_vda4987_pack is
    'VDA4987 Packaging Item / Verpackungsartikel';

comment on column dirkspzm32.edi_vda4987_pack.batch_number is
    'Batch number (an..35); Batch number / Chargennummer';

comment on column dirkspzm32.edi_vda4987_pack.code_qualifier1 is
    'Object Id Code Qualifiers:
XP Quality label ID for steel material
XQ Coil number
XR Cutting coil number
XS Total cutting sequence
XT Cutting sequence number

Additional information on steel deliveries / Zusatzangaben für Stahllieferungen';

comment on column dirkspzm32.edi_vda4987_pack.code_qualifier2 is
    '"Object Id Code Qualifiers:
XP Quality label ID for steel material
XQ Coil number
XR Cutting coil number
XS Total cutting sequence
XT Cutting sequence number

Additional information on steel deliveries / Zusatzangaben für Stahllieferungen"';

comment on column dirkspzm32.edi_vda4987_pack.code_qualifier3 is
    '"Object Id Code Qualifiers:
XP Quality label ID for steel material
XQ Coil number
XR Cutting coil number
XS Total cutting sequence
XT Cutting sequence number

Additional information on steel deliveries / Zusatzangaben für Stahllieferungen"';

comment on column dirkspzm32.edi_vda4987_pack.code_qualifier4 is
    '"Object Id Code Qualifiers:
XP Quality label ID for steel material
XQ Coil number
XR Cutting coil number
XS Total cutting sequence
XT Cutting sequence number

Additional information on steel deliveries / Zusatzangaben für Stahllieferungen"';

comment on column dirkspzm32.edi_vda4987_pack.code_qualifier5 is
    '"Object Id Code Qualifiers:
XP Quality label ID for steel material
XQ Coil number
XR Cutting coil number
XS Total cutting sequence
XT Cutting sequence number

Additional information on steel deliveries / Zusatzangaben für Stahllieferungen"';

comment on column dirkspzm32.edi_vda4987_pack.control_number is
    'Control number (n3); Control number of a JIT container / Kontrollnummer des JIS Behälters';

comment on column dirkspzm32.edi_vda4987_pack.document_id is
    'Unique Identifier of VDA4987 document; Master (FK)';

comment on column dirkspzm32.edi_vda4987_pack.expiration_date is
    'Expiration DateTime; Expiration date / Verfalldatum';

comment on column dirkspzm32.edi_vda4987_pack.ipig_id is
    'Unique Identifier of Inner Packaging Item Group; Parent (FK)';

comment on column dirkspzm32.edi_vda4987_pack.jis_module_id is
    'Name of the module (i.e. of the JIS package) (an..35); Name of the JIS container / module name / Name des Modulbehälters (Modulname)'
    ;

comment on column dirkspzm32.edi_vda4987_pack.lhm_number is
    'LHM number (an..12); OT DDP: LHM number (VDA: Packaging item number assigned by customer) / OT-Strecke: LHM-Nummer (VDA: Vom Kunden vorgegebene Packstücknummer)'
    ;

comment on column dirkspzm32.edi_vda4987_pack.manufacturing_date is
    'Manufacturing DateTime; Manufacturing date / Herstelldatum';

comment on column dirkspzm32.edi_vda4987_pack.marking_type_code is
    'Marking type codes: 1J Unique license plate number lowest package level; 3J Unique license plate number - JIS handling unit with trays; Package Identification / Packstückkennzeichnung'
    ;

comment on column dirkspzm32.edi_vda4987_pack.object_id1 is
    'Object Identifier (an..35); Additional information on steel deliveries / Zusatzangaben für Stahllieferungen';

comment on column dirkspzm32.edi_vda4987_pack.object_id2 is
    'Object Identifier (an..35); Additional information on steel deliveries / Zusatzangaben für Stahllieferungen';

comment on column dirkspzm32.edi_vda4987_pack.object_id3 is
    'Object Identifier (an..35); Additional information on steel deliveries / Zusatzangaben für Stahllieferungen';

comment on column dirkspzm32.edi_vda4987_pack.object_id4 is
    'Object Identifier (an..35); Additional information on steel deliveries / Zusatzangaben für Stahllieferungen';

comment on column dirkspzm32.edi_vda4987_pack.object_id5 is
    'Object Identifier (an..35); Additional information on steel deliveries / Zusatzangaben für Stahllieferungen';

comment on column dirkspzm32.edi_vda4987_pack.pack_item_id is
    'Unique Identifier of Packaging Item; Primary Key';

comment on column dirkspzm32.edi_vda4987_pack.pos is
    'Position number; Unique Index (n..4)';

comment on column dirkspzm32.edi_vda4987_pack.shipping_marks_desc is
    'Shipping marks description (an..35); Package Identification / Packstückkennzeichnung';

comment on column dirkspzm32.edi_vda4987_pack.tray_number is
    'Tray number (an..35); OT DDP: LHM number (VDA: Packaging item number assigned by customer) / OT-Strecke: LHM-Nummer (VDA: Vom Kunden vorgegebene Packstücknummer)'
    ;


-- sqlcl_snapshot {"hash":"9c184e2e4fbed3717a8fa28b6ed67ea9a7744594","type":"COMMENT","name":"edi_vda4987_pack","schemaName":"dirkspzm32","sxml":""}