comment on table DIRKSPZM32.EDI_VDA4987_IPIG is 'VDA4987 Inner Packaging Item Group / Produktgruppe der innere Verpackungen';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."DOCUMENT_ID" is 'Unique Identifier of VDA4987 document; Master (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."GROSS_WEIGHT_IN_KG" is 'Gross weight in kg (n..7); Gross weight / Bruttogewicht';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."IPIG_ID" is 'Unique Identifier of Inner Packaging Item Group; Primary Key';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."MAXIMUM_STACKABILITY" is 'Quantity (n..3); Maximum stackability / Max. Stapelfaktor';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."NET_WEIGHT_IN_KG" is 'Net weight in kg (n..7); Net weight / Nettogewicht';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."PACKAGE_QTY" is 'Package quantity. (n..6); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."PACK_TYPE_DESC_CODE" is 'Package Type Description Code; Designation of the packaging, coded (packaging material code of the customer) (an..7); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."POS" is 'Position number; Unique Index (n..4)';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."QTY_PER_PACKAGING_UNIT" is 'Quantity (n..35); Quantity per packaging unit / Menge je Verpackungseinheit';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."TARE_WEIGHT_IN_KG" is 'Tare weight in kg (n..7); Tare weight / Taragewicht';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."TERMS_AND_COND_CODE" is 'Packaging Terms and Conditions Code (an..3): AAA One way packaging, supplier pays; AAB One way packaging, customer pays; AAC Customer''s returnable package item; AAD Supplier''s returnable package item; Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."TYPE_OF_PACKAGES" is 'Packaging material code of the supplier (an..35); Quantity, type and ownership identifier / Menge, Typ und Eigentumskennung';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."VOLUME_MEASUREMENT_UNIT" is 'LTR=Litre, DMQ=Cubic Decimetre, MTQ=Cubic Metre (an..8); Volume of the packaging material / Volumen des Packmittels';
comment on column DIRKSPZM32.EDI_VDA4987_IPIG."VOLUME_OF_PACK_MATERIAL" is 'Volume (n..9); Volume of the packaging material / Volumen des Packmittels';



-- sqlcl_snapshot {"hash":"0114f85365893feed027763540854c7608a160dd","type":"COMMENT","name":"edi_vda4987_ipig","schemaName":"dirkspzm32","sxml":""}