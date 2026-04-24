comment on table dirkspzm32.edi_vda4987_ipig is
    'VDA4987 Inner Packaging Item Group / Produktgruppe der innere Verpackungen';

comment on column dirkspzm32.edi_vda4987_ipig.document_id is
    'Unique Identifier of VDA4987 document; Master (FK)';

comment on column dirkspzm32.edi_vda4987_ipig.gross_weight_in_kg is
    'Gross weight in kg (n..7); Gross weight / Bruttogewicht';

comment on column dirkspzm32.edi_vda4987_ipig.ipig_id is
    'Unique Identifier of Inner Packaging Item Group; Primary Key';

comment on column dirkspzm32.edi_vda4987_ipig.maximum_stackability is
    'Quantity (n..3); Maximum stackability / Max. Stapelfaktor';

comment on column dirkspzm32.edi_vda4987_ipig.net_weight_in_kg is
    'Net weight in kg (n..7); Net weight / Nettogewicht';

comment on column dirkspzm32.edi_vda4987_ipig.package_qty is
    'Package quantity. (n..6); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';

comment on column dirkspzm32.edi_vda4987_ipig.pack_type_desc_code is
    'Package Type Description Code; Designation of the packaging, coded (packaging material code of the customer) (an..7); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung'
    ;

comment on column dirkspzm32.edi_vda4987_ipig.pos is
    'Position number; Unique Index (n..4)';

comment on column dirkspzm32.edi_vda4987_ipig.qty_per_packaging_unit is
    'Quantity (n..35); Quantity per packaging unit / Menge je Verpackungseinheit';

comment on column dirkspzm32.edi_vda4987_ipig.tare_weight_in_kg is
    'Tare weight in kg (n..7); Tare weight / Taragewicht';

comment on column dirkspzm32.edi_vda4987_ipig.terms_and_cond_code is
    'Packaging Terms and Conditions Code (an..3): AAA One way packaging, supplier pays; AAB One way packaging, customer pays; AAC Customer''s returnable package item; AAD Supplier''s returnable package item; Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung'
    ;

comment on column dirkspzm32.edi_vda4987_ipig.type_of_packages is
    'Packaging material code of the supplier (an..35); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';

comment on column dirkspzm32.edi_vda4987_ipig.volume_measurement_unit is
    'LTR=Litre, DMQ=Cubic Decimetre, MTQ=Cubic Metre (an..8); Volume of the packaging material / Volumen des Packmittels';

comment on column dirkspzm32.edi_vda4987_ipig.volume_of_pack_material is
    'Volume (n..9); Volume of the packaging material / Volumen des Packmittels';


-- sqlcl_snapshot {"hash":"e696ec395263b6b285d805ae7d3b1f566acfb9a6","type":"COMMENT","name":"edi_vda4987_ipig","schemaName":"dirkspzm32","sxml":""}