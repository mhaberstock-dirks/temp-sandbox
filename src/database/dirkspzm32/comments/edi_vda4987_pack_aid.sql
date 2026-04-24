comment on table dirkspzm32.edi_vda4987_pack_aid is
    'VDA4987 Packaging Aid / Hilfspackmittel';

comment on column dirkspzm32.edi_vda4987_pack_aid.document_id is
    'Unique Identifier of VDA4987 document; Master (FK)';

comment on column dirkspzm32.edi_vda4987_pack_aid.gross_weight_in_kg is
    'Gross weight in kg (n..7); Gross weight / Gewicht des Hilfspackmittels';

comment on column dirkspzm32.edi_vda4987_pack_aid.hug_id is
    'Unique Identifier of Handling Unit Group; (null if IPIG Element) (FK)';

comment on column dirkspzm32.edi_vda4987_pack_aid.ipig_id is
    'Unique Identifier of Inner Packaging Item Group; (null if HUG Element) (FK)';

comment on column dirkspzm32.edi_vda4987_pack_aid.package_qty is
    'Package quantity or Number of identical handling units belonging to this group. (n..8); Packaging aid / Hilfspackmittel';

comment on column dirkspzm32.edi_vda4987_pack_aid.pack_aid_id is
    'Unique Identifier of Packaging Aid; Primary Key';

comment on column dirkspzm32.edi_vda4987_pack_aid.pack_type_desc_code is
    'Package Type Description Code; Designation of the packaging, coded (packaging material code of the customer) (an..7); Packaging aid / Hilfspackmittel'
    ;

comment on column dirkspzm32.edi_vda4987_pack_aid.pos is
    'Position number; Unique Index (n..4)';

comment on column dirkspzm32.edi_vda4987_pack_aid.tare_weight_in_kg is
    'Tare weight in kg (n..7); Tare weight / Gewicht des Hilfspackmittels';

comment on column dirkspzm32.edi_vda4987_pack_aid.terms_and_cond_code is
    'Packaging Terms and Conditions Code (an..3): AAA One way packaging, supplier pays; AAB One way packaging, customer pays; AAC Customer''s returnable package item; AAD Supplier''s returnable package item; Packaging aid / Hilfspackmittel'
    ;

comment on column dirkspzm32.edi_vda4987_pack_aid.type_of_packages is
    'Packaging material code of the supplier (an..35); Packaging aid / Hilfspackmittel';


-- sqlcl_snapshot {"hash":"d6ea8e6358aac85948ad7d91291ba7ff56f3c7f3","type":"COMMENT","name":"edi_vda4987_pack_aid","schemaName":"dirkspzm32","sxml":""}