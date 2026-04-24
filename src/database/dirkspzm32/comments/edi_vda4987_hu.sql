comment on table dirkspzm32.edi_vda4987_hu is
    'VDA4987 Handling Unit / Handhabungseinheit';

comment on column dirkspzm32.edi_vda4987_hu.document_id is
    'Unique Identifier of VDA4987 document; Master (FK)';

comment on column dirkspzm32.edi_vda4987_hu.gross_weight_in_kg is
    'Gross weight in kg (n..7); Gross weight / Bruttogewicht';

comment on column dirkspzm32.edi_vda4987_hu.hug_id is
    'Unique Identifier of Handling Unit Group; Parent (FK)';

comment on column dirkspzm32.edi_vda4987_hu.hu_id is
    'Unique Identifier of Handling Unit; Primary Key';

comment on column dirkspzm32.edi_vda4987_hu.ident_code_qualifier is
    'XP=Module name (an..3); Name of the JIS container / module name / Name des Modulbehälters (Modulname)';

comment on column dirkspzm32.edi_vda4987_hu.label_id is
    'Label ID of handling unit (an9); Packaging item number of the loading unit / Packstücknummer der Ladeeinheit';

comment on column dirkspzm32.edi_vda4987_hu.lhm_number is
    'LHM number (an..12); OT DDP: LHM number (VDA: Packaging item number of the loading unit.) / OT-Strecke: LHM-Nummer (VDA: Packstücknummer der Ladeeinheit.)'
    ;

comment on column dirkspzm32.edi_vda4987_hu.marking_type_code is
    'Marking type codes: 5J Unique license plate number mixed load; 6J Unique license plate number assigned to a master load; 3J Unique license plate number - JIS handling unit with trays; 4J Unique license plate number - JIS handling unit with 1..n JIS packages; Label type of the loading unit / Labeltyp der Ladeeinheit'
    ;

comment on column dirkspzm32.edi_vda4987_hu.module_name is
    'Name of the module (JIS container) (an..35); Name of the JIS container / module name / Name des Modulbehälters (Modulname)';

comment on column dirkspzm32.edi_vda4987_hu.net_weight_in_kg is
    'Net weight in kg (n..7); Net weight / Nettogewicht';

comment on column dirkspzm32.edi_vda4987_hu.object_id is
    'Object identifier (an22); Packaging item number of the loading unit / Packstücknummer der Ladeeinheit';

comment on column dirkspzm32.edi_vda4987_hu.parts_qty_per_hu is
    'Parts quantity per loading unit in pieces (n..35); Quantity of parts in homogeneous handling units / Teile-Menge der sortenreinen Ladeeinheit'
    ;

comment on column dirkspzm32.edi_vda4987_hu.pos is
    'Position number; Unique Index (n..4)';

comment on column dirkspzm32.edi_vda4987_hu.shipping_marks_desc is
    'Shipping marks description / Versandmarkierungen (an..35); Label type of the loading unit / Labeltyp der Ladeeinheit';

comment on column dirkspzm32.edi_vda4987_hu.tare_weight_in_kg is
    'Tare weight in kg (n..7); Tare weight / Taragewicht';


-- sqlcl_snapshot {"hash":"78098fdc1234ab7c1687872fc9c9bc7e06a1599e","type":"COMMENT","name":"edi_vda4987_hu","schemaName":"dirkspzm32","sxml":""}