comment on table DIRKSPZM32.EDI_VDA4987_ARTICLE is 'VDA4987 Article / Artikel';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ACT_DESPATCHED_QTY" is 'Actually despatched quantity (n..10); Part of the whole quantity of one handling unit / Teilmenge der Ladeeinheit';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ACT_DESPATCHED_QTY_UNIT" is 'Measurement Unit Codes:
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
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ARTICLE_DESC" is 'Article Description (an..40); Product/service description / Produkt-/Leistungsbeschreibung';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ARTICLE_ID" is 'Unique Identifier of Article; Part of Primary Key';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ARTICLE_NUMBER" is 'The original article number (an..22); Article number of the customer / Artikelnummer des Kunden';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DELIVERY_NOTE_DATE" is 'Delivery note date DateTime; Delivery note date / Lieferscheindatum';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DELIVERY_NOTE_NUMBER" is 'Delivery note number (n..8); Delivery note number and delivery note line item / Lieferscheinnummer und -position';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DESPATCHED_QTY" is 'Despatched quantity (n..10); Despatched quantity / Liefermenge, Ist';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_DESC_CODE" is 'Dangerous Goods Free text description code (an..17); Dangerous goods description / Gefahrgutbeschreibung in Textform';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_EXC_DESC_CODE" is 'Dangerous Goods Free text description code (an..17); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_EXC_FT1" is 'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_EXC_FT2" is 'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_EXC_FT3" is 'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_EXC_FT4" is 'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_EXC_FT5" is 'Free text - hazardous goods - exemption declaration (an..256); Dangerous goods declaration exception / Informationen zu Ausnahmeregelung';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_EXC_LANG_CODE" is 'Language name code (an..3); Dangerous goods description / Gefahrgutbeschreibung in Textform';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_FT1" is 'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_FT2" is 'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_FT3" is 'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_FT4" is 'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_FT5" is 'Dangerous Goods Free text - hazardous goods description (an..256); Dangerous goods description / Gefahrgutbeschreibung in Textform';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DG_LANG_CODE" is 'Language name code (an..3); Dangerous goods description / Gefahrgutbeschreibung in Textform';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DOCUMENT_ID" is 'Unique Identifier of VDA4987 document; Master (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."DUTY_REGIME_TYPE_CODE" is 'Duty regime type code: N=No, origin is not subject to preference; Y=Yes, origin is subject to preference; Country of origin, customs regime / Ursprungsland, Zollregime';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."HAZARD_ID_CODE" is 'Hazard identification code (an..7); Dangerous goods information / Gefahrgutinformationen';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."INTERNAL_FORWARD_ADDRESS" is 'Location identifier (n..7); Internal forwarding address, e.g. warehouse / flow storage (e.g. JIT/JIS);  Weiterleitungsadresse intern, z.B. Lager / Durchlauflager (z.B. JIT/JIS)';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."INTERNAL_PLACE_OF_USE" is 'Location identifier (an..14); Internal place of use / Interne Verbrauchsstelle';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."INVOICE_NUMBER" is 'Invoice Document Number (an..35); Invoice document identifier / Rechnungsnummer';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."IPIG_ID" is 'Unique Identifier of Inner Packaging Item Group; Parent (FK)';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_ID1" is 'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_ID2" is 'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_ID3" is 'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_ID4" is 'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_ID5" is 'ID number (an..35); Additional product id / Zusätzliche Produktidentifikation';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_TYPE_ID_CODE1" is 'Item Type Identification Codes:
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
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_TYPE_ID_CODE2" is '"Item Type Identification Codes:
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
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_TYPE_ID_CODE3" is '"Item Type Identification Codes:
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
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_TYPE_ID_CODE4" is '"Item Type Identification Codes:
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
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ITEM_TYPE_ID_CODE5" is '"Item Type Identification Codes:
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
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."LINE_NO_CWH" is 'Document line identifier (an..6); Individual order number of central warehouse of supplier; Einzel-Bestellnummer des Zentraldepots beim Lieferanten';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."LINE_NO_CWH_WHOLESALER" is 'Document line identifier (an..6); Order number, as assigned by central warehouse to wholesaler order; Auftragsnummer, vergeben vom Zentraldepot für die Bestellung des Großhandels';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."LINE_NO_IN_DELIVERY_NOTE" is 'Line number in the delivery note (n..3); Delivery note number and delivery note line item / Lieferscheinnummer und -position';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."LINE_NO_WAREHOUSE_CALL_OFF" is 'Document line identifier (an..6); Delivery instruction / schedule reference / Lieferplan / -abruf';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."MEASUREMENT_UNIT" is 'Measurement Unit Codes:
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
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ORDER_NO_CWH" is 'Order number Reference identifier (an..70); Individual order number of central warehouse of supplier; Einzel-Bestellnummer des Zentraldepots beim Lieferanten';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ORDER_NO_CWH_WHOLESALER" is 'Order number Reference identifier (an..70); Order number, as assigned by central warehouse to wholesaler order; Auftragsnummer, vergeben vom Zentraldepot für die Bestellung des Großhandels';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ORDER_NO_WHOLESALER" is 'Order number Reference identifier (an..70); Order number of wholesaler (or of ultimate customer, if transmitted by wholesaler to central warehouse); Bestellnummer des Großhändlers (kann auch die des Endkunden sein, wenn der Großhändler das an das Zentraldepot überträgt)';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."ORIGIN_COUNTRY" is 'Country of origin identifier (a2); Country of origin, customs regime / Ursprungsland, Zollregime';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."POS" is 'Position number; Part of Primary Key (n..4)';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."PURCHASE_ORDER_NUMBER" is 'Purchase order number (an..12); Purchase order number / Abschluss-/Bestellnummer';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_ADDRESS_DESC" is 'Name and address description / Zeile für Name und Anschrift (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_CITY" is 'City name / Ort (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_COUNTRY_ID" is 'Country identifier / Ländername Code (an..3); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_COUNTRY_SUB" is 'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_ID" is 'Party identifier number / Beteiligter, Identifikation (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_NAME1" is 'Party name / Beteiligter (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_NAME2" is 'Party name / Beteiligter (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_POSTAL_CODE" is 'Postal identification code / Postleitzahl (an..17); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_STREET1" is 'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SELLER_STREET2" is 'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."SUPPLIER_DUNS_NUMBER" is 'DUNS number (n..9); Supplier''s DUNS-number / DUNS-Nummer des Lieferanten';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."UNDG_DANGER_GOOD_ID" is 'United Nations Dangerous Goods (UNDG) identifier (n..4); Dangerous goods information / Gefahrgutinformationen';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."UNLOADING_POINT" is 'Location identifier (an..5); Unloading point / Abladestelle';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."USAGE_CODE" is 'Usage Code: 11 Production, 12 Sparepart; 17 Initial sample; Product/service description / Produkt-/Leistungsbeschreibung';
comment on column DIRKSPZM32.EDI_VDA4987_ARTICLE."WAREHOUSE_CALL_OFF_NUMBER" is 'Warehouse call-off number (an..15); Delivery instruction / schedule reference / Lieferplan / -abruf';



-- sqlcl_snapshot {"hash":"f358a7dd1a5054cb7290687bafd9b2b091b5ce8e","type":"COMMENT","name":"edi_vda4987_article","schemaName":"dirkspzm32","sxml":""}