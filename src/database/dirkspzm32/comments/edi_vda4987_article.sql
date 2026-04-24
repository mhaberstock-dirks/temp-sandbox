comment on table dirkspzm32.edi_vda4987_article is
    'VDA4987 Article / Artikel';

comment on column dirkspzm32.edi_vda4987_article.act_despatched_qty is
    'Actually despatched quantity (n..10); Part of the whole quantity of one handling unit / Teilmenge der Ladeeinheit';

comment on column dirkspzm32.edi_vda4987_article.act_despatched_qty_unit is
    'Measurement Unit Codes:
C62 one
PCE piece
SET set
MTR metre
CMT centimetre
MMT millimetre
MTK square metre
LEF leaf
MTQ cubic metre
LTR litre
 PR pair
 RO roll
TNE tonne(metric ton)
KGM kilogram
GRM gram
KMT kilometre

Part of the whole quantity of one handling unit / Teilmenge der Ladeeinheit';

comment on column dirkspzm32.edi_vda4987_article.article_desc is
    'Article Description (an..40); Product/service description / Produkt-/Leistungsbeschreibung';

comment on column dirkspzm32.edi_vda4987_article.article_id is
    'Unique Identifier of Article; Part of Primary Key';

comment on column dirkspzm32.edi_vda4987_article.article_number is
    'The original article number (an..22); Article number of the customer / Artikelnummer des Kunden';

comment on column dirkspzm32.edi_vda4987_article.delivery_note_date is
    'Delivery note date DateTime; Delivery note date / Lieferscheindatum';

comment on column dirkspzm32.edi_vda4987_article.delivery_note_number is
    'Delivery note number (n..8); Delivery note number and delivery note line item / Lieferscheinnummer und -position';

comment on column dirkspzm32.edi_vda4987_article.despatched_qty is
    'Despatched quantity (n..10); Despatched quantity / Liefermenge, Ist';

comment on column dirkspzm32.edi_vda4987_article.dg_desc_code is
    'Dangerous Goods Free text description code (an..17); Dangerous goods description / Gefahrgutbeschreibung in Textform';

comment on column dirkspzm32.edi_vda4987_article.dg_exc_desc_code is
    'Dangerous Goods Free text description code (an..17); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung';

comment on column dirkspzm32.edi_vda4987_article.dg_exc_ft1 is
    'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_exc_ft2 is
    'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_exc_ft3 is
    'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_exc_ft4 is
    'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_exc_ft5 is
    'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_exc_lang_code is
    'Language name code (an..3); Dangerous goods description / Gefahrgutbeschreibung in Textform';

comment on column dirkspzm32.edi_vda4987_article.dg_ft1 is
    'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_ft2 is
    'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_ft3 is
    'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_ft4 is
    'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_ft5 is
    'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform'
    ;

comment on column dirkspzm32.edi_vda4987_article.dg_lang_code is
    'Language name code (an..3); Dangerous goods description / Gefahrgutbeschreibung in Textform';

comment on column dirkspzm32.edi_vda4987_article.document_id is
    'Unique Identifier of VDA4987 document; Master (FK)';

comment on column dirkspzm32.edi_vda4987_article.duty_regime_type_code is
    'Duty regime type code: N=No, origin is not subject to preference; Y=Yes, origin is subject to preference; Country of origin, customs regime / Ursprungsland, Zollregime'
    ;

comment on column dirkspzm32.edi_vda4987_article.hazard_id_code is
    'Hazard identification code (an..7); Dangerous goods information / Gefahrgutinformationen';

comment on column dirkspzm32.edi_vda4987_article.internal_forward_address is
    'Location identifier (n..7); Internal forwarding address, e.g. warehouse / flow storage (e.g. JIT/JIS);  Weiterleitungsadresse intern, z.B. Lager / Durchlauflager (z.B. JIT/JIS)'
    ;

comment on column dirkspzm32.edi_vda4987_article.internal_place_of_use is
    'Location identifier (an..14); Internal place of use / Interne Verbrauchsstelle';

comment on column dirkspzm32.edi_vda4987_article.invoice_number is
    'Invoice Document Number (an..35); Invoice document identifier / Rechnungsnummer';

comment on column dirkspzm32.edi_vda4987_article.ipig_id is
    'Unique Identifier of Inner Packaging Item Group; Parent (FK)';

comment on column dirkspzm32.edi_vda4987_article.item_id1 is
    'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';

comment on column dirkspzm32.edi_vda4987_article.item_id2 is
    'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';

comment on column dirkspzm32.edi_vda4987_article.item_id3 is
    'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';

comment on column dirkspzm32.edi_vda4987_article.item_id4 is
    'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';

comment on column dirkspzm32.edi_vda4987_article.item_id5 is
    'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';

comment on column dirkspzm32.edi_vda4987_article.item_type_id_code1 is
    'Item Type Identification Codes:
DR Drawing revision number
AG Software revision number
BT Technical phase
SA Supplier''s article number
GB Buyer''s internal product group code
DR - Parts generation status(changes with the tool that was used to manufacture the part)
AG - Software status
BT - Hardware status
GB - module id

Additional product id / Zusätzliche Produktidentifikation';

comment on column dirkspzm32.edi_vda4987_article.item_type_id_code2 is
    '"Item Type Identification Codes:
DR Drawing revision number
AG Software revision number
BT Technical phase
SA Supplier''s article number
GB Buyer''s internal product group code
DR - Parts generation status(changes with the tool that was used to manufacture the part)
AG - Software status
BT - Hardware status
GB - module id

Additional product id / Zusätzliche Produktidentifikation"';

comment on column dirkspzm32.edi_vda4987_article.item_type_id_code3 is
    '"Item Type Identification Codes:
DR Drawing revision number
AG Software revision number
BT Technical phase
SA Supplier''s article number
GB Buyer''s internal product group code
DR - Parts generation status(changes with the tool that was used to manufacture the part)
AG - Software status
BT - Hardware status
GB - module id

Additional product id / Zusätzliche Produktidentifikation"';

comment on column dirkspzm32.edi_vda4987_article.item_type_id_code4 is
    '"Item Type Identification Codes:
DR Drawing revision number
AG Software revision number
BT Technical phase
SA Supplier''s article number
GB Buyer''s internal product group code
DR - Parts generation status(changes with the tool that was used to manufacture the part)
AG - Software status
BT - Hardware status
GB - module id

Additional product id / Zusätzliche Produktidentifikation"';

comment on column dirkspzm32.edi_vda4987_article.item_type_id_code5 is
    '"Item Type Identification Codes:
DR Drawing revision number
AG Software revision number
BT Technical phase
SA Supplier''s article number
GB Buyer''s internal product group code
DR - Parts generation status(changes with the tool that was used to manufacture the part)
AG - Software status
BT - Hardware status
GB - module id

Additional product id / Zusätzliche Produktidentifikation"';

comment on column dirkspzm32.edi_vda4987_article.line_no_cwh is
    'Document line identifier (an..6); Individual order number of central warehouse of supplier; Einzel-Bestellnummer des Zentraldepots beim Lieferanten'
    ;

comment on column dirkspzm32.edi_vda4987_article.line_no_cwh_wholesaler is
    'Document line identifier (an..6); Order number, as assigned by central warehouse to wholesaler order; Auftragsnummer, vergeben vom Zentraldepot für die Bestellung des Großhandels'
    ;

comment on column dirkspzm32.edi_vda4987_article.line_no_in_delivery_note is
    'Line number in the delivery note (n..3); Delivery note number and delivery note line item / Lieferscheinnummer und -position';

comment on column dirkspzm32.edi_vda4987_article.line_no_warehouse_call_off is
    'Document line identifier (an..6); Delivery instruction / schedule reference / Lieferplan / -abruf';

comment on column dirkspzm32.edi_vda4987_article.measurement_unit is
    'Measurement Unit Codes:
C62 one
PCE piece
SET set
MTR metre
CMT centimetre
MMT millimetre
MTK square metre
LEF leaf
MTQ cubic metre
LTR litre
 PR pair
 RO roll
TNE tonne(metric ton)
KGM kilogram
GRM gram
KMT kilometre

Despatched quantity / Liefermenge, Ist';

comment on column dirkspzm32.edi_vda4987_article.order_no_cwh is
    'Order number Reference identifier (an..70); Individual order number of central warehouse of supplier; Einzel-Bestellnummer des Zentraldepots beim Lieferanten'
    ;

comment on column dirkspzm32.edi_vda4987_article.order_no_cwh_wholesaler is
    'Order number Reference identifier (an..70); Order number, as assigned by central warehouse to wholesaler order; Auftragsnummer, vergeben vom Zentraldepot für die Bestellung des Großhandels'
    ;

comment on column dirkspzm32.edi_vda4987_article.order_no_wholesaler is
    'Order number Reference identifier (an..70); Order number of wholesaler (or of ultimate customer, if transmitted by wholesaler to central warehouse); Bestellnummer des Großhändlers (kann auch die des Endkunden sein, wenn der Großhändler das an das Zentraldepot überträgt)'
    ;

comment on column dirkspzm32.edi_vda4987_article.origin_country is
    'Country of origin identifier (a2); Country of origin, customs regime / Ursprungsland, Zollregime';

comment on column dirkspzm32.edi_vda4987_article.pos is
    'Position number; Part of Primary Key (n..4)';

comment on column dirkspzm32.edi_vda4987_article.purchase_order_number is
    'Purchase order number (an..12); Purchase order number / Abschluss-/Bestellnummer';

comment on column dirkspzm32.edi_vda4987_article.seller_address_desc is
    'Name and address description / Zeile für Name und Anschrift (an..35); Seller''s name and address / Name und Anschrift des Verkäufers'
    ;

comment on column dirkspzm32.edi_vda4987_article.seller_city is
    'City name / Ort (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_article.seller_country_id is
    'Country identifier / Ländername Code (an..3); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_article.seller_country_sub is
    'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Seller''s name and address / Name und Anschrift des Verkäufers'
    ;

comment on column dirkspzm32.edi_vda4987_article.seller_id is
    'Party identifier number / Beteiligter, Identifikation (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_article.seller_name1 is
    'Party name / Beteiligter (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_article.seller_name2 is
    'Party name / Beteiligter (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_article.seller_postal_code is
    'Postal identification code / Postleitzahl (an..17); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_article.seller_street1 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Seller''s name and address / Name und Anschrift des Verkäufers'
    ;

comment on column dirkspzm32.edi_vda4987_article.seller_street2 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Seller''s name and address / Name und Anschrift des Verkäufers'
    ;

comment on column dirkspzm32.edi_vda4987_article.supplier_duns_number is
    'DUNS number (n..9); Supplier''s DUNS-number / DUNS-Nummer des Lieferanten';

comment on column dirkspzm32.edi_vda4987_article.undg_danger_good_id is
    'United Nations Dangerous Goods (UNDG) identifier (n..4); Dangerous goods information / Gefahrgutinformationen';

comment on column dirkspzm32.edi_vda4987_article.unloading_point is
    'Location identifier (an..5); Unloading point / Abladestelle';

comment on column dirkspzm32.edi_vda4987_article.usage_code is
    'Usage Code: 11 Production, 12 Sparepart; 17 Initial sample; Product/service description / Produkt-/Leistungsbeschreibung';

comment on column dirkspzm32.edi_vda4987_article.warehouse_call_off_number is
    'Warehouse call-off number (an..15); Delivery instruction / schedule reference / Lieferplan / -abruf';


-- sqlcl_snapshot {"hash":"62df4474401f5f7065c975d40e8fe5e322e03d0e","type":"COMMENT","name":"edi_vda4987_article","schemaName":"dirkspzm32","sxml":""}