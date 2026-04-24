comment on table dirkspzm32.edi_vda4987_hu_group is
    'VDA4987 Handling Unit Group / Handhabungseinheit Gruppe';

comment on column dirkspzm32.edi_vda4987_hu_group.document_id is
    'Unique Identifier of VDA4987 document; Master (FK)';

comment on column dirkspzm32.edi_vda4987_hu_group.hug_id is
    'Unique Identifier of Handling Unit Group; Primary Key';

comment on column dirkspzm32.edi_vda4987_hu_group.number_of_pack_materials is
    'Number Of Included Inner Packaging Materials Qty; Number of included inner packaging materials / Anzahl der enthaltenen inneren Packmittel'
    ;

comment on column dirkspzm32.edi_vda4987_hu_group.package_qty is
    'Package quantity (n..3); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';

comment on column dirkspzm32.edi_vda4987_hu_group.pack_code_supplier is
    'Packaging Code of Supplier; Type of packages (an..35); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung'
    ;

comment on column dirkspzm32.edi_vda4987_hu_group.pos is
    'Position number; Unique Index (n..4)';

comment on column dirkspzm32.edi_vda4987_hu_group.qty_stacking_factor is
    'Quantity Stacking factor (n..3); Maximum stackability / Max. Stapelfaktor';

comment on column dirkspzm32.edi_vda4987_hu_group.terms_cond_code is
    'Packaging terms and conditions codes: AAA One way packaging, supplier pays; AAB One way packaging, customer pays; AAC Customer''s returnable package item; AAD Supplier''s returnable package item; AAC Customer''s returnable package item; Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung'
    ;

comment on column dirkspzm32.edi_vda4987_hu_group.type_desc_code is
    'Type Description Code; Designation of packagin, e.g. 0001PAL(an..7); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung'
    ;


-- sqlcl_snapshot {"hash":"2400612f9a02c585396a61f4fc7d4ec3f951b166","type":"COMMENT","name":"edi_vda4987_hu_group","schemaName":"dirkspzm32","sxml":""}