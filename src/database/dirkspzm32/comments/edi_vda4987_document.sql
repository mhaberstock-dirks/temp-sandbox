comment on table dirkspzm32.edi_vda4987_document is
    'VDA4987 Main Table / Haupttabelle';

comment on column dirkspzm32.edi_vda4987_document.buyer_address_desc is
    'Name and address description / Zeile für Name und Anschrift (an..35); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.buyer_city is
    'City name / Ort (an..35); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift';

comment on column dirkspzm32.edi_vda4987_document.buyer_country_id is
    'Country identifier / Ländername Code (an..3); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift';

comment on column dirkspzm32.edi_vda4987_document.buyer_country_sub is
    'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.buyer_id is
    'Party identifier number / Beteiligter, Identifikation (an..35); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift';

comment on column dirkspzm32.edi_vda4987_document.buyer_name1 is
    'Party name / Beteiligter (an..35); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift';

comment on column dirkspzm32.edi_vda4987_document.buyer_name2 is
    'Party name / Beteiligter (an..35); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift';

comment on column dirkspzm32.edi_vda4987_document.buyer_postal_code is
    'Postal identification code / Postleitzahl (an..17); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift';

comment on column dirkspzm32.edi_vda4987_document.buyer_street1 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.buyer_street2 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Buyer''s name and address / Käufer (Kunde) ID, Name, Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.carrier_add_party_id is
    'Reference identifier / Referenz, Identifikation (n..9); Carrier reference / Frachtführer Referenzangaben';

comment on column dirkspzm32.edi_vda4987_document.carrier_id is
    'Carrier identifier / Frachtführer, Nummer (an..17); Transport information / Transportinformationen';

comment on column dirkspzm32.edi_vda4987_document.carrier_to_address_desc is
    'Name and address description / Zeile für Name und Anschrift (an..35); Carrier name and address / Frachtführer - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.carrier_to_city is
    'City name / Ort (an..35); Carrier name and address / Frachtführer - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.carrier_to_country_id is
    'Country identifier / Ländername Code (an..3); Carrier name and address / Frachtführer - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.carrier_to_country_sub is
    'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Carrier name and address / Frachtführer - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.carrier_to_id is
    'Party identifier number / Beteiligter, Identifikation (an..35); Carrier name and address / Frachtführer - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.carrier_to_name1 is
    'Party name / Beteiligter (an..35); Carrier name and address / Frachtführer - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.carrier_to_name2 is
    'Party name / Beteiligter (an..35); Carrier name and address / Frachtführer - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.carrier_to_postal_code is
    'Postal identification code / Postleitzahl (an..17); Carrier name and address / Frachtführer - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.carrier_to_street1 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Carrier name and address / Frachtführer - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.carrier_to_street2 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Carrier name and address / Frachtführer - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.code_list_resp_agency_code is
    'Code list responsible agency code / Verantwortliche Stelle für die Codepflege, Code (an..3); Transport information / Transportinformationen'
    ;

comment on column dirkspzm32.edi_vda4987_document.consignment_gross_weight is
    'Gross weight (mass) excluding transport equipment (carrier equipment). The weight is to be rounded up to full kilogramms / Bruttogewicht - Gewicht (Masse) ausschließlich Transportausrüstung (carriers equipment). Das Gewicht ist auf volle Kilogramm aufzurunden. (n..7)'
    ;

comment on column dirkspzm32.edi_vda4987_document.consignment_net_weight is
    'Weight (mass) of the products. The weight is to be rounded up to full kilogramms. / Gewicht (Masse) der Erzeugnisse. Das Gewicht ist auf volle Kilogramm aufzurunden. (n..7)'
    ;

comment on column dirkspzm32.edi_vda4987_document.consignment_number is
    'Unique reference for a shipment. A shipment is to be understood as the entirety of the material that has been loaded into the same means of transport by one shipping point to one recipient. A repetition within one calendar year is not permitted. / Eindeutige Referenznummer, die einer Sendung / Tour / Abfahrt eines Transportmittels zugeordnet ist. Entspricht der Sendungs-Ladungs-Bezugsnummer der VDA Empfehlung 4913. (an..8)'
    ;

comment on column dirkspzm32.edi_vda4987_document.consignment_tara_weight is
    'Tara weight of consignment in kg, Weight (mass) of the packing materials / Taragewicht der Sendung in kg, Gewicht (Masse) der Packmittel (n..12)'
    ;

comment on column dirkspzm32.edi_vda4987_document.consignment_volume is
    'Consignment volume (Total cube) / Volumen der Sendung';

comment on column dirkspzm32.edi_vda4987_document.consignment_volume_unit is
    'Measurement Units: DMQ cubic decimetre; LTR litre; MTQ cubic metre';

comment on column dirkspzm32.edi_vda4987_document.creation_date is
    'Date of creation';

comment on column dirkspzm32.edi_vda4987_document.customer_shipment_auth_id is
    'Customer shipment authorisation identifier / Kunden-Sendungsfreigabenummer (an..17); Transport information / Transportinformationen'
    ;

comment on column dirkspzm32.edi_vda4987_document.customer_to_address_desc is
    'Name and address description / Zeile für Name und Anschrift (an..35); Ultimate customer''s name and address / Name und Anschrift des Endkunden'
    ;

comment on column dirkspzm32.edi_vda4987_document.customer_to_city is
    'City name / Ort (an..35); Ultimate customer''s name and address / Name und Anschrift des Endkunden';

comment on column dirkspzm32.edi_vda4987_document.customer_to_country_id is
    'Country identifier / Ländername Code (an..3); Ultimate customer''s name and address / Name und Anschrift des Endkunden';

comment on column dirkspzm32.edi_vda4987_document.customer_to_country_sub is
    'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Ultimate customer''s name and address / Name und Anschrift des Endkunden'
    ;

comment on column dirkspzm32.edi_vda4987_document.customer_to_id is
    'Party identifier number / Beteiligter, Identifikation (an..35); Ultimate customer''s name and address / Name und Anschrift des Endkunden'
    ;

comment on column dirkspzm32.edi_vda4987_document.customer_to_name1 is
    'Party name / Beteiligter (an..35); Ultimate customer''s name and address / Name und Anschrift des Endkunden';

comment on column dirkspzm32.edi_vda4987_document.customer_to_name2 is
    'Party name / Beteiligter (an..35); Ultimate customer''s name and address / Name und Anschrift des Endkunden';

comment on column dirkspzm32.edi_vda4987_document.customer_to_postal_code is
    'Postal identification code / Postleitzahl (an..17); Ultimate customer''s name and address / Name und Anschrift des Endkunden';

comment on column dirkspzm32.edi_vda4987_document.customer_to_street1 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Ultimate customer''s name and address / Name und Anschrift des Endkunden'
    ;

comment on column dirkspzm32.edi_vda4987_document.customer_to_street2 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Ultimate customer''s name and address / Name und Anschrift des Endkunden'
    ;

comment on column dirkspzm32.edi_vda4987_document.customs_currency is
    'EUR, Code specifying a currency in ISO 4217 three alpha code / Währungscode, verwende ISO 4217 3 alpha Code (an..3)';

comment on column dirkspzm32.edi_vda4987_document.customs_value is
    'Customs value of the shipment / Zollwert der Sendung (n..35)';

comment on column dirkspzm32.edi_vda4987_document.delivery_is_not_inv_relevant is
    '0/1; 1(true) = Delivery is not invoice relevant / Lieferung ist nicht Rechnungs-relevant';

comment on column dirkspzm32.edi_vda4987_document.despatch_advice_date is
    'Creation DateTime of DESADV; Despatch advice date / Datum der DESADV Nachricht';

comment on column dirkspzm32.edi_vda4987_document.despatch_advice_number is
    'Unique identifier of DESADV assigned by the supplier. No duplicates within one year. Lieferavis Nummer; Beginning of message / Beginn der Nachricht'
    ;

comment on column dirkspzm32.edi_vda4987_document.despatch_date is
    'Despatch date / Tatsächliches Versanddatum';

comment on column dirkspzm32.edi_vda4987_document.destination_sys is
    'Destination System';

comment on column dirkspzm32.edi_vda4987_document.direction is
    'Direction; I=Inbound; O=Outbound';

comment on column dirkspzm32.edi_vda4987_document.discharge_loc_id is
    'Location identifier / Ortsangabe, Nummer (an..3); Place of discharge  / Anlieferstelle';

comment on column dirkspzm32.edi_vda4987_document.discharge_loc_name is
    'Location name / Ortsangabe (an..256); Place of discharge  / Anlieferstelle';

comment on column dirkspzm32.edi_vda4987_document.document_id is
    'Unique Identifier of VDA4987 document; Primary Key';

comment on column dirkspzm32.edi_vda4987_document.equipment_id is
    'ID of used equipment (an..12); Equipment / means of transport (trailer / swap body) / Frachtträger / Transportmittel (Anhänger / Wechselbrücke)'
    ;

comment on column dirkspzm32.edi_vda4987_document.equipment_type is
    'Equipment type code qualifier: CN = Container; RR = Rail car; SW = Swap body; TE = Trailer / CN = Container; RR = Eisenbahnwaggon; SW = Wechselbehälter/Wechselbrücke; TE = Anhänger (an..3); Equipment / means of transport (trailer / swap body) / Frachtträger / Transportmittel (Anhänger / Wechselbrücke)'
    ;

comment on column dirkspzm32.edi_vda4987_document.estimated_arrival_date is
    'Estimated arrival date / geschätztes Ankunftsdatum';

comment on column dirkspzm32.edi_vda4987_document.excess_transp_resp_code is
    'Excess transportation responsibility code / Besonderer Transport, Verantwortlichkeit, Code (an..3); Transport information / Transportinformationen'
    ;

comment on column dirkspzm32.edi_vda4987_document.export_date is
    'Date of export';

comment on column dirkspzm32.edi_vda4987_document.filename is
    'Filename of corresponding VDA4987 document';

comment on column dirkspzm32.edi_vda4987_document.forward_add_party_id is
    'Reference identifier / Referenz, Identifikation (n..9); Freight forwarder reference / Spediteur Referenzangaben';

comment on column dirkspzm32.edi_vda4987_document.forward_to_address_desc is
    'Name and address description / Zeile für Name und Anschrift (an..35); Freight forwarder name and address / Spediteur - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.forward_to_city is
    'City name / Ort (an..35); Freight forwarder name and address / Spediteur - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.forward_to_country_id is
    'Country identifier / Ländername Code (an..3); Freight forwarder name and address / Spediteur - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.forward_to_country_sub is
    'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Freight forwarder name and address / Spediteur - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.forward_to_id is
    'Party identifier number / Beteiligter, Identifikation (an..35); Freight forwarder name and address / Spediteur - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.forward_to_name1 is
    'Party name / Beteiligter (an..35); Freight forwarder name and address / Spediteur - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.forward_to_name2 is
    'Party name / Beteiligter (an..35); Freight forwarder name and address / Spediteur - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.forward_to_postal_code is
    'Postal identification code / Postleitzahl (an..17); Freight forwarder name and address / Spediteur - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.forward_to_street1 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Freight forwarder name and address / Spediteur - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.forward_to_street2 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Freight forwarder name and address / Spediteur - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.import_date is
    'Date of import';

comment on column dirkspzm32.edi_vda4987_document.incoterms_loc_id is
    'Location identifier / Ortsangabe, Nummer (an..35); Location specification for INCOTERMS / Ortsangabe für INCOTERMS';

comment on column dirkspzm32.edi_vda4987_document.incoterms_loc_name is
    'Location name / Ortsangabe (an..256); Location specification for INCOTERMS / Ortsangabe für INCOTERMS';

comment on column dirkspzm32.edi_vda4987_document.interchange_control_reference is
    'Unique ID of an interchange; Interchange header / Nutzdaten-Kopfsegment';

comment on column dirkspzm32.edi_vda4987_document.loading_loc_id is
    'Location identifier / Ortsangabe, Nummer (an..17); Shipping location (Place of loading) / Beladestelle';

comment on column dirkspzm32.edi_vda4987_document.loading_loc_name is
    'Location name / Ortsangabe (an..256); Shipping location (Place of loading) / Beladestelle';

comment on column dirkspzm32.edi_vda4987_document.message_reference_number is
    'Message reference number in the interchange; Message header / Nachrichten-Kopfsegment';

comment on column dirkspzm32.edi_vda4987_document.message_timestamp is
    'DateTime of preparation; Interchange header / Nutzdaten-Kopfsegment';

comment on column dirkspzm32.edi_vda4987_document.message_type is
    'Type of message';

comment on column dirkspzm32.edi_vda4987_document.modify_date is
    'Date of last modification';

comment on column dirkspzm32.edi_vda4987_document.number_of_loading_units is
    'Number of loading units of the shipment / Anzahl der Ladeeinheiten der Sendung (n..4)';

comment on column dirkspzm32.edi_vda4987_document.number_of_messages is
    'Number of messages in the interchange (n..6); Interchange trailer / Nutzdaten-Endesegment';

comment on column dirkspzm32.edi_vda4987_document.number_of_segments is
    'Number of segments in the message (n..6); Message trailer / Nachrichten-Endesegment';

comment on column dirkspzm32.edi_vda4987_document.pref_auth_desc_code is
    'Free text description code / (an..17); Preference authorisation / Präferenzberechtigung';

comment on column dirkspzm32.edi_vda4987_document.pref_auth_lang_code is
    'Code specifying the language name. Use ISO 639-1988 / Sprache, codiert; verwende ISO 639-1988 (an..3); Preference authorisation / Präferenzberechtigung'
    ;

comment on column dirkspzm32.edi_vda4987_document.pref_auth_text1 is
    'Text of the declaration of preference in accordance with the legal regulations. / Text der Präferenzerklärung entsprechend der gesetzlichen Vorgaben. (an..256); Preference authorisation / Präferenzberechtigung'
    ;

comment on column dirkspzm32.edi_vda4987_document.pref_auth_text2 is
    'Text of the declaration of preference in accordance with the legal regulations. / Text der Präferenzerklärung entsprechend der gesetzlichen Vorgaben. (an..256); Preference authorisation / Präferenzberechtigung'
    ;

comment on column dirkspzm32.edi_vda4987_document.pref_auth_text3 is
    'Text of the declaration of preference in accordance with the legal regulations. / Text der Präferenzerklärung entsprechend der gesetzlichen Vorgaben. (an..256); Preference authorisation / Präferenzberechtigung'
    ;

comment on column dirkspzm32.edi_vda4987_document.pref_auth_text4 is
    'Text of the declaration of preference in accordance with the legal regulations. / Text der Präferenzerklärung entsprechend der gesetzlichen Vorgaben. (an..256); Preference authorisation / Präferenzberechtigung'
    ;

comment on column dirkspzm32.edi_vda4987_document.pref_auth_text5 is
    'Text of the declaration of preference in accordance with the legal regulations. / Text der Präferenzerklärung entsprechend der gesetzlichen Vorgaben. (an..256); Preference authorisation / Präferenzberechtigung'
    ;

comment on column dirkspzm32.edi_vda4987_document.receiver_id is
    'Odette ID of the receiver/recipient; Interchange header / Nutzdaten-Kopfsegment';

comment on column dirkspzm32.edi_vda4987_document.recipient_reference is
    'Recipient''s reference/password; Interchange header / Nutzdaten-Kopfsegment';

comment on column dirkspzm32.edi_vda4987_document.requested_delivery_date is
    'Requested delivery date / Soll-Wareneingangstermin';

comment on column dirkspzm32.edi_vda4987_document.requested_shipping_date is
    'Shipping DateTime as requested by buyer. The date is based on the duration of transport as determined by the buyer. Das vom Käufer erwünschte Versanddatum; Requested shipment date / geforderter Versand-Abholtermin'
    ;

comment on column dirkspzm32.edi_vda4987_document.reverse_routing_address is
    'Address for reverse routing; Interchange header / Nutzdaten-Kopfsegment';

comment on column dirkspzm32.edi_vda4987_document.seal_number is
    'Seal number / Plombennummer (an..35)';

comment on column dirkspzm32.edi_vda4987_document.seller_additional_party_id is
    'Reference identifier / Referenz, Identifikation (an..70); Seller (Supplier) Reference / Verkäufer (Lieferant) Referenzangaben';

comment on column dirkspzm32.edi_vda4987_document.seller_address_desc is
    'Name and address description / Zeile für Name und Anschrift (an..35); Seller''s name and address / Name und Anschrift des Verkäufers'
    ;

comment on column dirkspzm32.edi_vda4987_document.seller_city is
    'City name / Ort (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_document.seller_country_id is
    'Country identifier / Ländername Code (an..3); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_document.seller_country_sub is
    'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Seller''s name and address / Name und Anschrift des Verkäufers'
    ;

comment on column dirkspzm32.edi_vda4987_document.seller_id is
    'Party identifier number / Beteiligter, Identifikation (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_document.seller_name1 is
    'Party name / Beteiligter (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_document.seller_name2 is
    'Party name / Beteiligter (an..35); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_document.seller_postal_code is
    'Postal identification code / Postleitzahl (an..17); Seller''s name and address / Name und Anschrift des Verkäufers';

comment on column dirkspzm32.edi_vda4987_document.seller_street1 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Seller''s name and address / Name und Anschrift des Verkäufers'
    ;

comment on column dirkspzm32.edi_vda4987_document.seller_street2 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Seller''s name and address / Name und Anschrift des Verkäufers'
    ;

comment on column dirkspzm32.edi_vda4987_document.sender_additional_party_id is
    'Reference identifier / Referenz, Identifikation (n..9); Message Sender name and address / Sender der Nachricht - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.sender_addr_id is
    'Party identifier number / Beteiligter, Identifikation (an..10); Message Sender name and address / Sender der Nachricht - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.sender_city is
    'City name / Ort (an..35); Message Sender name and address / Sender der Nachricht - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.sender_country_id is
    'Country identifier / Ländername Code (an..3); Message Sender name and address / Sender der Nachricht - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.sender_country_sub is
    'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Message Sender name and address / Sender der Nachricht - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.sender_id is
    'Odette ID of the sender; Interchange header / Nutzdaten-Kopfsegment';

comment on column dirkspzm32.edi_vda4987_document.sender_name1 is
    'Party name / Beteiligter (an..35); Message Sender name and address / Sender der Nachricht - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.sender_name2 is
    'Party name / Beteiligter (an..35); Message Sender name and address / Sender der Nachricht - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.sender_postal_code is
    'Postal identification code / Postleitzahl (an..17); Message Sender name and address / Sender der Nachricht - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.sender_street1 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Message Sender name and address / Sender der Nachricht - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.sender_street2 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Message Sender name and address / Sender der Nachricht - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_from_address_desc is
    'Name and address description / Zeile für Name und Anschrift (an..35); Ship from''s name and address / Warenversender - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_from_add_party_id is
    'Reference identifier / Referenz, Identifikation (n..9); Ship from Reference / Warenversender Referenzangaben';

comment on column dirkspzm32.edi_vda4987_document.ship_from_city is
    'City name / Ort (an..35); Ship from''s name and address / Warenversender - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_from_country_id is
    'Country identifier / Ländername Code (an..3); Ship from''s name and address / Warenversender - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_from_country_sub is
    'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Ship from''s name and address / Warenversender - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_from_id is
    'Party identifier number / Beteiligter, Identifikation (an..35); Ship from''s name and address / Warenversender - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_from_name1 is
    'Party name / Beteiligter (an..35); Ship from''s name and address / Warenversender - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_from_name2 is
    'Party name / Beteiligter (an..35); Ship from''s name and address / Warenversender - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_from_postal_code is
    'Postal identification code / Postleitzahl (an..17); Ship from''s name and address / Warenversender - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_from_street1 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Ship from''s name and address / Warenversender - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_from_street2 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Ship from''s name and address / Warenversender - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_to_address_desc is
    'Name and address description / Zeile für Name und Anschrift (an..35); Ship to''s name and address / Warenempfänger - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_to_city is
    'City name / Ort (an..35); Ship to''s name and address / Warenempfänger - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_to_country_id is
    'Country identifier / Ländername Code (an..3); Ship to''s name and address / Warenempfänger - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_to_country_sub is
    'Country subdivision identifier / Land-Untereinheit, z.B. NDS (an..9); Ship to''s name and address / Warenempfänger - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_to_id is
    'Party identifier number / Beteiligter, Identifikation (an..35); Ship to''s name and address / Warenempfänger - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_to_name1 is
    'Party name / Beteiligter (an..35); Ship to''s name and address / Warenempfänger - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_to_name2 is
    'Party name / Beteiligter (an..35); Ship to''s name and address / Warenempfänger - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_to_name3 is
    'Party name / Beteiligter (an..35); Ship to''s name and address / Warenempfänger - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_to_name4 is
    'Party name / Beteiligter (an..35); Ship to''s name and address / Warenempfänger - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_to_postal_code is
    'Postal identification code / Postleitzahl (an..17); Ship to''s name and address / Warenempfänger - Name und Anschrift';

comment on column dirkspzm32.edi_vda4987_document.ship_to_street1 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Ship to''s name and address / Warenempfänger - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.ship_to_street2 is
    'Street and number or post office box identifier / Straße und Hausnummer oder Postfach (an..35); Ship to''s name and address / Warenempfänger - Name und Anschrift'
    ;

comment on column dirkspzm32.edi_vda4987_document.supplier_customs_clearance is
    '0/1; 1(true) = different from the standard delivery conditions, the supplier clears customs and then invoices the customer / abweichend von den Standardlieferbedingungen führt der Lieferant die Verzollung durch und stellt sie anschließend dem Kunden in Rechnung'
    ;

comment on column dirkspzm32.edi_vda4987_document.terms_of_delivery is
    'Delivery or transport terms description code / Liefer- oder Transportbedingungen, Code (an..3)';

comment on column dirkspzm32.edi_vda4987_document.test_indicator is
    'Test Indicator, default 0 = false, 1 = true = Test Transmission; Interchange header / Nutzdaten-Kopfsegment';

comment on column dirkspzm32.edi_vda4987_document.transfer_code is
    'Returncode of record processing';

comment on column dirkspzm32.edi_vda4987_document.transfer_status is
    'TransferStatus of record, N=New, ...';

comment on column dirkspzm32.edi_vda4987_document.transfer_text is
    'Returntext of record processing';

comment on column dirkspzm32.edi_vda4987_document.transport_id is
    'Transport chain reference / Transportkettenreferenz (an..35)';

comment on column dirkspzm32.edi_vda4987_document.transport_means_desc_code is
    'Transport means description code / Art des Transportmittels, Code (an..8); Transport information / Transportinformationen';

comment on column dirkspzm32.edi_vda4987_document.transport_mode_code is
    'Transport Mode Codes: 10 Maritime transport; 20 Rail transport; 30 Road transport (default); 40 Air transport; 50 Mail; 60 Multimodal transport; (an..3); Transport information / Transportinformationen'
    ;

comment on column dirkspzm32.edi_vda4987_document.transport_order_number is
    'Transport order number / Transportauftragsnummer (an..35)';

comment on column dirkspzm32.edi_vda4987_document.transp_means_ident_name_id is
    'Transport means identification name identifier / Transportmittel, Identifikation (an..25); Transport information / Transportinformationen'
    ;

comment on column dirkspzm32.edi_vda4987_document.transp_means_nation_code is
    'Transport means nationality code / Nationalität des Transportmittels, Code (a2); Transport information / Transportinformationen'
    ;

comment on column dirkspzm32.edi_vda4987_document.vat_reg_number is
    'Unique identifier assigned to a business partner for the purpose of VAT handling by tax authorities. / Eindeutiger Identifier, der einem Geschäftspartner zum Zwecke der umsatzsteuerlichen Behandlung von der Steuerbehörde zugewiesen wurde.(an..17); VAT registration number / Umsatzsteuer ID'
    ;


-- sqlcl_snapshot {"hash":"58f1f92a78092355cbc0dcac75a4832a69b970af","type":"COMMENT","name":"edi_vda4987_document","schemaName":"dirkspzm32","sxml":""}