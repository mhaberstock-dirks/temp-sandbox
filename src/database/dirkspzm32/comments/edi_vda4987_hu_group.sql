comment on table DIRKSPZM32.EDI_VDA4987_HU_GROUP is 'VDA4987 Handling Unit Group / Handhabungseinheit Gruppe';
comment on column DIRKSPZM32.EDI_VDA4987_HU_GROUP."DOCUMENT_ID" is 'Unique Identifier of VDA4987 document; Master (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_HU_GROUP."HUG_ID" is 'Unique Identifier of Handling Unit Group; Primary Key';
comment on column DIRKSPZM32.EDI_VDA4987_HU_GROUP."NUMBER_OF_PACK_MATERIALS" is 'Number Of Included Inner Packaging Materials Qty; Number of included inner packaging materials / Anzahl der enthaltenen inneren Packmittel';
comment on column DIRKSPZM32.EDI_VDA4987_HU_GROUP."PACKAGE_QTY" is 'Package quantity (n..3); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';
comment on column DIRKSPZM32.EDI_VDA4987_HU_GROUP."PACK_CODE_SUPPLIER" is 'Packaging Code of Supplier; Type of packages (an..35); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';
comment on column DIRKSPZM32.EDI_VDA4987_HU_GROUP."POS" is 'Position number; Unique Index (n..4)';
comment on column DIRKSPZM32.EDI_VDA4987_HU_GROUP."QTY_STACKING_FACTOR" is 'Quantity Stacking factor (n..3); Maximum stackability / Max. Stapelfaktor';
comment on column DIRKSPZM32.EDI_VDA4987_HU_GROUP."TERMS_COND_CODE" is 'Packaging terms and conditions codes: AAA One way packaging, supplier pays; AAB One way packaging, customer pays; AAC Customer''s returnable package item; AAD Supplier''s returnable package item; AAC Customer''s returnable package item; Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';
comment on column DIRKSPZM32.EDI_VDA4987_HU_GROUP."TYPE_DESC_CODE" is 'Type Description Code; Designation of packagin, e.g. 0001PAL(an..7); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';



-- sqlcl_snapshot {"hash":"a96e9878cc71ffcb958843eaa17ea8079bd0d608","type":"COMMENT","name":"edi_vda4987_hu_group","schemaName":"dirkspzm32","sxml":""}