comment on table DIRKSPZM32.EDI_VDA4987_PACK_AID is 'VDA4987 Packaging Aid / Hilfspackmittel';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."DOCUMENT_ID" is 'Unique Identifier of VDA4987 document; Master (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."GROSS_WEIGHT_IN_KG" is 'Gross weight in kg (n..7); Gross weight / Gewicht des Hilfspackmittels';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."HUG_ID" is 'Unique Identifier of Handling Unit Group; (null if IPIG Element) (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."IPIG_ID" is 'Unique Identifier of Inner Packaging Item Group; (null if HUG Element) (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."PACKAGE_QTY" is 'Package quantity or Number of identical handling units belonging to this group. (n..8); Packaging aid / Hilfspackmittel';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."PACK_AID_ID" is 'Unique Identifier of Packaging Aid; Primary Key';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."PACK_TYPE_DESC_CODE" is 'Package Type Description Code; Designation of the packaging, coded (packaging material code of the customer) (an..7); Packaging aid / Hilfspackmittel';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."POS" is 'Position number; Unique Index (n..4)';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."TARE_WEIGHT_IN_KG" is 'Tare weight in kg (n..7); Tare weight / Gewicht des Hilfspackmittels';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."TERMS_AND_COND_CODE" is 'Packaging Terms and Conditions Code (an..3): AAA One way packaging, supplier pays; AAB One way packaging, customer pays; AAC Customer''s returnable package item; AAD Supplier''s returnable package item; Packaging aid / Hilfspackmittel';
comment on column DIRKSPZM32.EDI_VDA4987_PACK_AID."TYPE_OF_PACKAGES" is 'Packaging material code of the supplier (an..35); Packaging aid / Hilfspackmittel';



-- sqlcl_snapshot {"hash":"7dd4f72010b71e7246a5c75e057f796e61bf8a68","type":"COMMENT","name":"edi_vda4987_pack_aid","schemaName":"dirkspzm32","sxml":""}