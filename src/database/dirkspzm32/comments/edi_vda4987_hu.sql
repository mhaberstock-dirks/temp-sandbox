comment on table DIRKSPZM32.EDI_VDA4987_HU is 'VDA4987 Handling Unit / Handhabungseinheit';
comment on column DIRKSPZM32.EDI_VDA4987_HU."DOCUMENT_ID" is 'Unique Identifier of VDA4987 document; Master (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_HU."GROSS_WEIGHT_IN_KG" is 'Gross weight in kg (n..7); Gross weight / Bruttogewicht';
comment on column DIRKSPZM32.EDI_VDA4987_HU."HUG_ID" is 'Unique Identifier of Handling Unit Group; Parent (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_HU."HU_ID" is 'Unique Identifier of Handling Unit; Primary Key';
comment on column DIRKSPZM32.EDI_VDA4987_HU."IDENT_CODE_QUALIFIER" is 'XP=Module name (an..3); Name of the JIS container / module name / Name des Modulbehälters (Modulname)';
comment on column DIRKSPZM32.EDI_VDA4987_HU."LABEL_ID" is 'Label ID of handling unit (an9); Packaging item number of the loading unit / Packstücknummer der Ladeeinheit';
comment on column DIRKSPZM32.EDI_VDA4987_HU."LHM_NUMBER" is 'LHM number (an..12); OT DDP: LHM number (VDA: Packaging item number of the loading unit.) / OT-Strecke: LHM-Nummer (VDA: Packstücknummer der Ladeeinheit.)';
comment on column DIRKSPZM32.EDI_VDA4987_HU."MARKING_TYPE_CODE" is 'Marking type codes: 5J Unique license plate number mixed load; 6J Unique license plate number assigned to a master load; 3J Unique license plate number - JIS handling unit with trays; 4J Unique license plate number - JIS handling unit with 1..n JIS packages; Label type of the loading unit / Labeltyp der Ladeeinheit';
comment on column DIRKSPZM32.EDI_VDA4987_HU."MODULE_NAME" is 'Name of the module (JIS container) (an..35); Name of the JIS container / module name / Name des Modulbehälters (Modulname)';
comment on column DIRKSPZM32.EDI_VDA4987_HU."NET_WEIGHT_IN_KG" is 'Net weight in kg (n..7); Net weight / Nettogewicht';
comment on column DIRKSPZM32.EDI_VDA4987_HU."OBJECT_ID" is 'Object identifier (an22); Packaging item number of the loading unit / Packstücknummer der Ladeeinheit';
comment on column DIRKSPZM32.EDI_VDA4987_HU."PARTS_QTY_PER_HU" is 'Parts quantity per loading unit in pieces (n..35); Quantity of parts in homogeneous handling units / Teile-Menge der sortenreinen Ladeeinheit';
comment on column DIRKSPZM32.EDI_VDA4987_HU."POS" is 'Position number; Unique Index (n..4)';
comment on column DIRKSPZM32.EDI_VDA4987_HU."SHIPPING_MARKS_DESC" is 'Shipping marks description / Versandmarkierungen (an..35); Label type of the loading unit / Labeltyp der Ladeeinheit';
comment on column DIRKSPZM32.EDI_VDA4987_HU."TARE_WEIGHT_IN_KG" is 'Tare weight in kg (n..7); Tare weight / Taragewicht';



-- sqlcl_snapshot {"hash":"1efd0f897d14e19a6dafc1310d4be8fe6f9a6e35","type":"COMMENT","name":"edi_vda4987_hu","schemaName":"dirkspzm32","sxml":""}