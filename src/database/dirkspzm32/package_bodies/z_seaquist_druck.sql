create or replace package body dirkspzm32.z_seaquist_druck is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

    type t_bezeichnung_liste is
        table of varchar2(255) index by pls_integer;

  -- Private constant declarations
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr                      number;
    v_err_text                    varchar2(255);

  --<ConstantName> constant <Datatype> := <Value>;

    c_layout_nr_vormontage        constant varchar2(20) := 'vormontage';
  -- -AG- Alt vor SAP
    c_basis_layout_versand        constant varchar2(20) := '7398_a.llf';
    c_basis_layout_vormontage     constant varchar2(20) := 'vormontage.llf';
  -- Neues Layout heisst jetzt
    c_basis_layout_versand_sap    constant varchar2(20) := 'spd_std.llf';
    c_basis_layout_versand_sap201 constant varchar2(20) := 'spd_f.llf';
    c_basis_layout_versand_sapbom constant varchar2(20) := 'spd_bom.llf';
    c_basis_layout_vormontage_sap constant varchar2(20) := 'spd_inerbox.llf';

    function vda_etikett_vers_krt (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_id       in lvs_lhm.lhm_id%type
    ) return varchar2 is

        v_print_daten               varchar2(4096);
        v_found                     boolean;
        v_sid                       isi_sid%rowtype;
        v_firma_nr                  lvs_lhm.firma_nr%type;
        v_leitzahl                  lvs_lam.leitzahl%type;
        v_adr_liefer                isi_adressen.adr_liefer%type;
        v_kunden_nr                 isi_adressen.adr_nr%type;
        v_layout_nr                 varchar2(255);  -- Nummer des LOGOPAK-Layouts ('vormontage', '0201', etc.)
                                                -- SubStr(ISI_ADRESSE.LHM_ETIKETTEN_LAYOUT), Zeichen für Vormontage ist ???
        v_basis_layout              varchar2(255);  -- Basislayout (Versand- und Vormontage-Layout)
        v_ident                     varchar2(255);  -- interne Artikelnr: ISI_ARTIKEL.ARTIKEL >>> kommt als S_SEAQUIST_RCV_FA_AUF.AB_ARTIKEL von MAPICS
        v_anzahl_pro_karton         varchar2(255);  -- LVS_LAM.MENGE                      >>> IST-Menge im Karton
        v_gesamt                    varchar2(255);  -- BDE_FA_AUFTRAG.AB_SOLL_MG          >>> SOLL-Menge des FA
        v_packdatum                 lvs_lam.prod_datum%type;  -- LVS_LAM.PROD_DATUM       >>> Paletten-Packdatum = heute
        v_packdatum_string          varchar2(255);
        v_packdatum_klein           varchar2(255);
        v_kartonnummer              varchar2(255);  -- LVS_LAM.LHM_LFD_NR                 >>> laufende KartonNr. pro FA
        v_karton_id                 varchar2(255);  -- LhmId                              >>> IST-Menge mit SOLL-Menge (BDE_FA.LHM_MENGE) vergleichen
        v_id                        varchar2(255);  -- LhmId                              >>> IST-Menge mit SOLL-Menge (BDE_FA.LHM_MENGE) vergleichen
                                                --                                    >>> mit führendem S: Volle Menge M: Anbruchmenge
        v_nummer                    varchar2(255);  -- = v_Artikelnummer                  >>> Kunden-Artikelnummer BDE_FA_AUFTRAG.KD_ART_NR
        v_nummer_rechts             varchar2(255);  -- = v_Nummer                         >>> BDE_FA_AUFTRAG.KD_ART_NR
        v_artikelnummer             varchar2(255);  -- BDE_FA_AUFTRAG.KD_ART_NR (nur 1004)>>> = BDE_FA_AUFTRAG.KD_ART_NR (muss noch über MAPICS kommen!)
        v_daten_code_id_170         varchar2(255);  -- = v_Artikelnummer, aber 18-stellig, mit 1 beginnend und mit 0-en auffüllen
                                                -- (muss noch über MAPICS kommen!)(nur 1002)
        v_kommission_lot            varchar2(255);  -- LVS_CHARGE.CHARGE_BEZ:              >>> ersten 10 Zeichen von CHARGE_BEZ
        v_cde_client_zeile_1        varchar2(255);  -- (nur 0201) neues Feld bde_fa_auftrag.AG_TEXT2
        v_cde_client_zeile_2        varchar2(255);  -- (nur 0201) neues Feld bde_fa_auftrag.AG_TEXT3
        v_reference_client          varchar2(255);  -- (nur 0201) von MAPICS: ISI_ARTIKEL_KUNDE.KD_ART_TEXT1 aus S_SEAQUIST_RCV_ART_KD.KD_ART_TEXT1
        v_nummer_unten              varchar2(255);  -- = v_Nummer (nur bei manchen Layouts)
        v_adressfeld_links_zeile_1  varchar2(255);  -- ISI_ADRESSEN.NAME_1 (Lieferanschrift)  >>> NAME1
        v_adressfeld_links_zeile_2  varchar2(255);  -- ISI_ADRESSEN.NAME_2 (Lieferanschrift)  >>> NAME2
        v_adressfeld_links_zeile_3  varchar2(255);  -- ISI_ADRESSEN.NAME_3 (Lieferanschrift)  >>> NAME3
        v_adressfeld_links_zeile_4  varchar2(255);  -- ISI_ADRESSEN.STRASSE(Lieferanschrift)  >>> STRASSE
        v_adressfeld_links_zeile_5  varchar2(255);  -- ISI_ADRESSEN...     (Lieferanschrift)  >>> Zeile 5 bleibt leer!
        v_adressfeld_links_zeile_6  varchar2(255);  -- ISI_ADRESSEN...     (Lieferanschrift)  >>> LAND_KURZ + PLZ + ORT
        v_adressfeld_rechts_zeile_1 varchar2(255);  -- <<< siehe Excel
        v_adressfeld_rechts_zeile_2 varchar2(255);  -- <<< siehe Excel
        v_adressfeld_rechts_zeile_3 varchar2(255);  -- <<< siehe Excel
        v_adressfeld_rechts_zeile_4 varchar2(255);  -- <<< siehe Excel
        v_adressfeld_rechts_zeile_5 varchar2(255);  -- <<< siehe Excel
        v_adressfeld_rechts_zeile_6 varchar2(255);  -- <<< siehe Excel
        v_barcode_id_100            varchar2(255);  -- >>> Ident-Nr(7) ChargeBez(10)+Packdatum(6:ddmmyy)+Stkzahl im Karton+'D' (nur 1102)
        v_barcode_id_110_fifo       varchar2(255);  -- v_Packdatum im Format YYYYMM (nur 1102)
        v_barcode_id_120_part       varchar2(255);  -- v_Nummer (nur 1102)
        v_barcode_id_130_qty        varchar2(255);  -- v_Anzahl_pro_Karton (nur 1102)
        v_barcode_id_140_lot        varchar2(255);  -- >>> QY + SubStr(v_Kommission_Lot,3,8), also hier nur 8 Zeichen lang (nur 1102)
        v_barcode_id_150_carton     varchar2(255);  -- v_Kartonnummer (nur 1102)
        v_barcode_id_pl_menden      varchar2(255);  -- Spezialbarcode für den Palletierer in Menden
        v_barcode_id_00_menden      varchar2(255);  -- Spezialbarcode für den Palletierer in Menden
        v_text_fifo                 varchar2(255);  -- 'FIFO:' (nur 1102)
        v_text_part                 varchar2(255);  -- 'PART ' (nur 1102)
        v_text_qty                  varchar2(255);  -- 'QTY:' (nur 1102)
        v_text_lot                  varchar2(255);  -- 'LOT TRACE #' (nur 1102)
        v_text_carton               varchar2(255);  -- 'CARTON #' (nur 1102)
        v_logo_1                    varchar2(255);  -- Leiter mit Titeltexten (Tabelle rechts)
        v_logo_2                    varchar2(255);  -- Adressfeldtabelle mit Titeltexten
        v_logo_3                    varchar2(255);  -- Rahmen Lot mit Titeltexten
        v_logo_4                    varchar2(255);  -- Rahmen unten mit Titeltexten
        v_logo_5                    varchar2(255);  -- Tabelle Produktteile mit Titeltexten
        v_logo_6                    varchar2(255);  -- France (nur 1102)
        v_bez_spez_zeile            varchar2(2000); -- aus BDE_FA_AUFTRAG.PROD_PARAMS(STK_LISTE_TXT), z.B. descr1@spez1@desc2@spez2@...
        v_bezeichnung_zeile         t_bezeichnung_liste;  -- siehe v_Bez_Spez_Zeile
        v_spezifikation_zeile       t_bezeichnung_liste;  -- siehe v_Bez_Spez_Zeile
        v_drucken                   varchar2(255);  -- 1: Etikett drucken, sonst ' '
    -- nur für Vormontage-Label:
        v_kunden_auftrag            varchar2(255);  -- Kundenauftragsnummer                >>> FA.AB_NR
        v_m_auftrag                 varchar2(255);  -- interne Auftragsnummer              >>> M+LEITZAHL
        v_maschine                  varchar2(255);  -- Maschinenname ISI_RESOURCE.RES_NAME >>> noch offen (H. Schütz)
        v_qs_status                 lvs_lam.qs_status%type;
        v_nve                       varchar2(20);   -- Fuer SSCC Nummer auf dem Etikett

        v_lhm_menge                 integer;        -- Menge pro Karton: BDE_FA_AUFTRAG.LHM_MENGE (für die Entscheidung STANDARD- oder RESTKARTON
        v_lte_lhm_lagen             integer;        -- Anzahl der lagen (Packhoehe)
        v_fa_soll                   integer;
        v_fa_ist                    integer;
        pos                         integer;
        c_count                     integer;
        i                           integer;
        v_code39                    varchar2(256);  -- -AG- Mögliche Zeichen CODE39 aus Firma_cfg

        cursor c_sid is
        select
            *
        from
            isi_sid t
        where
            t.sid = in_sid;
-- in:  v_sid, v_firma_nr, v_Karton_ID
-- out: v_Anzahl_pro_Karton, v_Ident, v_Kommission_Lot,
--      v_Artikelnummer, v_leitzahl, v_Packdatum, v_Kartonnummer, v_Maschine
        cursor c_lhm_lam_art_charge is
        select
            lam.menge,
            substr(art.artikel, 1, 8),
            substr(c.charge_bez, 1, 10),
            lam.kd_art_nr,
            lam.leitzahl,
            lam.prod_datum,
            nvl(lam.lhm_lfd_nr, 0),
            substr(res.res_ext_name, 1, 10),
            lam.qs_status
        from
            lvs_lhm      lhm,
            lvs_lam      lam,
            isi_artikel  art,
            lvs_charge   c,
            isi_resource res
        where
                lhm.sid = v_sid.sid
            and lhm.firma_nr = v_firma_nr
            and lam.lhm_id = lhm.lhm_id
            and lam.menge > 0
            and art.artikel_id (+) = lam.artikel_id
            and c.charge_id (+) = lam.charge_id
            and res.res_id (+) = lam.res_id
            and res.typ (+) = 'MS'
            and lhm.lhm_id = v_karton_id;

-- in:  v_sid, v_firma_nr, v_leitzahl
-- out: v_Gesamt, v_kunden_nr, v_adr_liefer, v_Nummer, v_Reference_Client , v_Cde_Client_Zeile_1/2,
--      v_Adressfeld_Rechts_Zeile_1, [v_Bezeichnung_Zeile, v_Kunden_Auftrag, v_Spezifikation_Zeile], v_Lhm_Menge
        cursor c_fa is
        select
            fa.ab_soll_mg,
            fa.kunden_nr,
            fa.kunden_nr_adr_liefer,
            fa.kd_art_nr,
            fa.ag_text1,
            fa.ag_text2,
            fa.ag_text3,
            fa.best_nr_kunde,
            fa.ab_text1,
            fa.abnr,
            isi_utils.get_csv_value(fa.prod_params, 'STK_LISTE_TXT'),
            fa.lhm_menge,
            fa.lte_lhm_lagen,
            fa.ag_soll_mg,
            fa.ag_ist_mg
        from
            bde_fa_auftrag fa
        where
                fa.sid = v_sid.sid
            and fa.firma_nr = v_firma_nr
            and fa.leitzahl = v_leitzahl
            and fa.satzart = 'V'             -- verrichten = produzieren
        group by
            fa.leitzahl,
            fa.ab_soll_mg,
            fa.kunden_nr,
            fa.kunden_nr_adr_liefer,
            fa.kd_art_nr,
            fa.ag_text1,
            fa.ag_text2,
            fa.ag_text3,
            fa.best_nr_kunde,
            fa.ab_text1,
            fa.abnr,
            isi_utils.get_csv_value(fa.prod_params, 'STK_LISTE_TXT'),
            fa.lhm_menge,
            fa.lte_lhm_lagen,
            fa.ag_soll_mg,
            fa.ag_ist_mg;

-- in:  v_sid, v_firma_nr, v_adr_liefer, v_kunden_nr
-- out: v_Adressfeld_Links_Zeile(1) - v_Adressfeld_Links_Zeile(6)

--   v_Adressfeld_Links_Zeile_1  varchar2(255);  -- ISI_ADRESSEN.NAME_1 (Lieferanschrift)  >>> NAME1
--   v_Adressfeld_Links_Zeile_2  varchar2(255);  -- ISI_ADRESSEN.NAME_2 (Lieferanschrift)  >>> NAME2
--   v_Adressfeld_Links_Zeile_3  varchar2(255);  -- ISI_ADRESSEN.NAME_3 (Lieferanschrift)  >>> NAME3
--   v_Adressfeld_Links_Zeile_4  varchar2(255);  -- ISI_ADRESSEN.STRASSE(Lieferanschrift)  >>> STRASSE
--   v_Adressfeld_Links_Zeile_5  varchar2(255);  -- ISI_ADRESSEN...     (Lieferanschrift)  >>> Zeile 5 bleibt leer!
--   v_Adressfeld_Links_Zeile_6  varchar2(255);  -- ISI_ADRESSEN...     (Lieferanschrift)  >>> LAND_KURZ + PLZ + ORT
        cursor c_lieferanschrift is
        select
            nvl(
                substr(adr.name_1, 1, 27),
                ''
            ),
            nvl(
                substr(adr.name_2, 1, 27),
                ''
            ),
            nvl(
                substr(adr.name_3, 1, 27),
                ''
            ),
            nvl(
                substr(adr.strasse, 1, 27),
                ''
            ),
            substr(nvl(adr.land_kurz, '')
                   || '-'
                   || nvl(adr.plz, '')
                   || ' '
                   || nvl(adr.ort, ''),
                   1,
                   27),
            nvl(
                substr(adr.lhm_etiketten_layout, 1, 4),
                '0000'
            ) --  ACHTUNG, noch default 0000 eintragen
        from
            isi_adressen   adr,
            bde_fa_auftrag fa
        where
                adr.sid = v_sid.sid
            and adr.firma_nr = v_firma_nr
         -- and fa.sid = v_sid
         -- and fa.firma_nr = v_firma_nr
            and fa.satzart = 'V'             -- verrichten = produzieren
            and fa.leitzahl = v_leitzahl
            and adr.adr_nr = to_char(fa.kunden_nr)
            and adr.adr_art = 'K'
            and adr.adr_liefer = fa.kunden_nr_adr_liefer;

-- ADR_LIEFER = 0 heißt Rechnungsadresse
-- ADR_LIEFER > 0 heißt Lieferadresse
-- ADR_ART = 'K'  heißt Kunde
    begin
        v_ident := null;
        v_anzahl_pro_karton := null;
        v_gesamt := null;
        v_packdatum := null;
        v_kartonnummer := null;
        v_karton_id := null;
        v_nummer := null;
        v_nummer_rechts := null;
        v_artikelnummer := null;
        v_daten_code_id_170 := null;
        v_kommission_lot := null;
        v_cde_client_zeile_1 := null;
        v_cde_client_zeile_2 := null;
        v_reference_client := null;
        v_nummer_unten := null;
        v_adressfeld_links_zeile_1 := null;
        v_adressfeld_links_zeile_2 := null;
        v_adressfeld_links_zeile_3 := null;
        v_adressfeld_links_zeile_4 := null;
        v_adressfeld_links_zeile_5 := null;
        v_adressfeld_links_zeile_6 := null;
        v_adressfeld_rechts_zeile_1 := null;
        v_adressfeld_rechts_zeile_2 := null;
        v_adressfeld_rechts_zeile_3 := null;
        v_adressfeld_rechts_zeile_4 := null;
        v_adressfeld_rechts_zeile_5 := null;
        v_adressfeld_rechts_zeile_6 := null;
        v_barcode_id_100 := null;
        v_barcode_id_110_fifo := null;
        v_barcode_id_120_part := null;
        v_barcode_id_130_qty := null;
        v_barcode_id_140_lot := null;
        v_barcode_id_150_carton := null;
        v_barcode_id_pl_menden := null;
        v_barcode_id_00_menden := null;
        v_text_fifo := null;
        v_text_part := null;
        v_text_qty := null;
        v_text_lot := null;
        v_text_carton := null;
        v_logo_1 := null;
        v_logo_2 := null;
        v_logo_3 := null;
        v_logo_4 := null;
        v_logo_5 := null;
        v_logo_6 := null;
        v_kunden_auftrag := null;
        v_maschine := null;
        v_bez_spez_zeile := null;
        for c_count in 1..20 loop
            v_bezeichnung_zeile(c_count) := null;
            v_spezifikation_zeile(c_count) := null;
        end loop;

        v_drucken := '1';  -- immer drucken!
        open c_sid;
        fetch c_sid into v_sid;
        close c_sid;
        v_firma_nr := in_firma_nr;
        v_karton_id := in_id;
        v_id := in_id;
        open c_lhm_lam_art_charge;
        fetch c_lhm_lam_art_charge into
            v_anzahl_pro_karton,                      -- lam.menge
            v_ident,                                  -- SubStr(art.artikel,1,8)
            v_kommission_lot,                         -- SubStr(c.charge_bez,1,10)
            v_artikelnummer,                          -- lam.kd_art_nr
            v_leitzahl,                               -- lam.leitzahl
            v_packdatum,                              -- lam.prod_datum
            v_kartonnummer,                           -- NVL(lam.lhm_lfd_nr, 0)
            v_maschine,                               -- SubStr(res.res_ext_name, 1,10)
            v_qs_status;                              -- Z oder ZM sind Zuordnungsfehler -> Leeres Etikett
        v_found := c_lhm_lam_art_charge%found;
        close c_lhm_lam_art_charge;
        if not v_found then
            v_err_text := ' Karton nicht gefunden: ' || v_karton_id;
            v_err_nr := 51;
            raise v_error;
        end if;

        if v_qs_status = 'ZM'
        or v_qs_status = 'Z' then
            v_id := null;
            v_karton_id := null;
            v_layout_nr := c_layout_nr_vormontage;
            v_bezeichnung_zeile(1) := 'GESPERRT (Zuordnung prüfen)';
            v_basis_layout := c_basis_layout_vormontage;
        else
      -- in:  v_sid, v_firma_nr, v_leitzahl
      -- out: v_Gesamt, v_kunden_nr, v_adr_liefer, v_Nummer, v_reference_client,
      --      v_Cde_Client_Zeile_1/2, v_Adressfeld_Rechts_Zeile_1 (Bestellnr Kund),
      --      v_Kunden_Auftrag, [v_Bezeichnung_Zeile, v_Spezifikation_Zeile], v_Lhm_Menge

            open c_fa;
            fetch c_fa into
                v_gesamt,                                      -- fa.ab_soll_mg
                v_kunden_nr,                                   -- fa.kunden_nr
                v_adr_liefer,                                  -- fa.kunden_nr_adr_liefer
                v_nummer,                                      -- fa.kd_art_nr
                v_reference_client,                            -- fa.ag_text1
                v_cde_client_zeile_1,                          -- fa.ag_text2
                v_cde_client_zeile_2,                          -- fa.ag_text3
                v_adressfeld_rechts_zeile_5,                   -- fa.best_nr_kunde
                v_adressfeld_rechts_zeile_6,                   -- fa.ab_text1
                v_kunden_auftrag,                              -- fa.abnr
                v_bez_spez_zeile,                              -- isi_utils.get_csv_value(fa.prod_params, 'STK_LISTE_TXT')
                v_lhm_menge,                                   -- fa.lhm_menge
                v_lte_lhm_lagen,                               -- fa.lte_lhm_lagen
                v_fa_soll,                                     -- fa.ag_soll_mg
                v_fa_ist;                                      -- fa.ag_ist_mg
            v_found := c_fa%found;
            close c_fa;
            if not v_found then
                v_err_text := ' FA nicht gefunden: ' || v_leitzahl;
                v_err_nr := 52;
                raise v_error;
            end if;

      -- Lieferanschrift:
      -- in:  v_sid, v_firma_nr, v_adr_liefer, v_kunden_nr
      -- out: v_Adressfeld_Links_Zeile(1) - v_Adressfeld_Links_Zeile(6), v_layout_nr

            open c_lieferanschrift;
            fetch c_lieferanschrift into
                v_adressfeld_links_zeile_1,
                v_adressfeld_links_zeile_2,
                v_adressfeld_links_zeile_3,
                v_adressfeld_links_zeile_4,
         -- _Adressfeld_Links_Zeile_5,   -- bleibt immer leer
                v_adressfeld_links_zeile_6,     -- LAND_KURZ + PLZ + ORT
                v_layout_nr;
            v_found := c_lieferanschrift%found;
            close c_lieferanschrift;
            if not v_found then
                v_err_text := ' Lieferadresse nicht gefunden: KundenNr='
                              || v_kunden_nr
                              || ' LieferantenNr='
                              || v_adr_liefer;
        -- v_err_nr := 53;
        -- raise v_error;
            end if;

      -- für interne Aufträge (Kunde ist Seaquist selbst) wird ein Vormontage-Label gedruckt:
            if v_kunden_nr = '1' then
                v_layout_nr := c_layout_nr_vormontage;
            end if;

      -- TEST TEST TEST:
      -- v_Layout_Nr := C_LAYOUT_NR_VORMONTAGE;
      -- .llf Dateien festlegen:
            if v_layout_nr = c_layout_nr_vormontage then
                if v_sid.sid_schnittstelle != 'SQD_SAP' then
                    v_basis_layout := c_basis_layout_vormontage;
                else
                    v_basis_layout := c_basis_layout_vormontage_sap;
                end if;
            else
                if v_sid.sid_schnittstelle != 'SQD_SAP' then
                    v_basis_layout := c_basis_layout_versand;
                else
                    v_kunden_auftrag := lpad(v_kunden_auftrag, 16, '0');
                    if trim(v_layout_nr) = '0201' -- sqdf
                     then
                        v_basis_layout := c_basis_layout_versand_sap201;
                    elsif trim(v_layout_nr) in ( '1001', '1101', '1201' ) -- sqdf
                     then
                        v_basis_layout := c_basis_layout_versand_sapbom;
                    else
                        v_basis_layout := c_basis_layout_versand_sap;
                    end if;

                end if;
            end if;

     -- Barcode_ID_100 = Ident-Nr(7) ChargeBez(10)+Packdatum(6:ddmmyy)+Stkzahl im Karton+'D'
            if v_sid.sid_schnittstelle != 'SQD_SAP' then
                v_barcode_id_100 := rpad(v_ident, 7, ' ');  -- interne Artikelnummer(8)
                v_barcode_id_100 := v_barcode_id_100
                                    || rpad(v_kommission_lot, 10, ' ');  -- ChargeBez(10)
                v_barcode_id_100 := v_barcode_id_100 || to_char(v_packdatum, 'DDMMYY');  -- Packdatum(6)
                v_barcode_id_100 := v_barcode_id_100
                                    || lpad(v_anzahl_pro_karton, 10, '0'); -- Stkzahl im Karton(10)
                v_barcode_id_100 := v_barcode_id_100 || 'D';
            else
                v_barcode_id_100 := '99' || '000000';                             -- Bezeichner unf FIX 000000
                v_barcode_id_100 := v_barcode_id_100 || '1121';                   -- Plaint für Dortmund ist 1121
                v_barcode_id_100 := v_barcode_id_100
                                    || '02'
                                    || lpad(
                    nvl(
                        substr(in_id,
                               length(in_id) - 7,
                               8),
                        '0'
                    ),
                    8,
                    '0'
                );  -- ID (Nur Nummer)
                v_barcode_id_100 := v_barcode_id_100
                                    || lpad(
                    nvl(v_kartonnummer, '0'),
                    4,
                    '0'
                );  -- Kartonnummer
                v_barcode_id_100 := v_barcode_id_100
                                    || lpad(v_ident, 10, '0');   -- interne Artikelnummer(10)
                v_barcode_id_100 := v_barcode_id_100
                                    || lpad(v_kommission_lot, 10, '0');  -- ChargeBez(10)
                v_barcode_id_100 := v_barcode_id_100
                                    || lpad(v_anzahl_pro_karton, 8, '0'); -- Stkzahl im Karton(10)
                if trim(v_layout_nr) = '0201' -- französisch
                 then
                    v_daten_code_id_170 := rpad(v_reference_client, 7, ' ');  -- interne alte Artikelnummer(8) (in kundenartukelnummer)
                    v_daten_code_id_170 := v_daten_code_id_170
                                           || rpad(v_kommission_lot, 10, ' ');  -- ChargeBez(10)
                    v_daten_code_id_170 := v_daten_code_id_170 || to_char(v_packdatum, 'DDMMYY');  -- Packdatum(6)
                    v_daten_code_id_170 := v_daten_code_id_170
                                           || lpad(v_anzahl_pro_karton, 10, '0'); -- Stkzahl im Karton(10)
                    v_daten_code_id_170 := v_daten_code_id_170 || 'D';
                end if;

                if length(in_id) = 15 then
                    v_nve := '740485532'
                             || substr(in_id, 8, 8);
                    v_nve := lvs_p_lte_lhm.lvs_lte_lhm_pruefziffer_mod10(v_nve);
                end if;

                v_karton_id := '00' || v_nve;
            end if;

            if v_sid.sid_schnittstelle != 'SQD_SAP' then
                v_m_auftrag := 'M' || v_leitzahl;
            else
                v_m_auftrag := lpad(v_leitzahl, 10, '0');
            end if;

            if v_anzahl_pro_karton < v_lhm_menge                 -- Restmengenkarton dann immer letzter Karton
            or v_fa_soll <= v_fa_ist + v_anzahl_pro_karton       -- Auftrag ist fertig
             then
                v_lte_lhm_lagen := 9;
            end if;

            v_barcode_id_pl_menden := 'PL'
                                      || rpad(v_maschine, 10, ' ')
                                      || rpad(v_kommission_lot, 10, ' ')
                                      || to_char(v_lte_lhm_lagen);

            v_barcode_id_00_menden := '00'
                                      || substr(v_nve, 9, 9)
                                      || v_m_auftrag
                                      || lpad(v_anzahl_pro_karton, 8, '0');

            v_adressfeld_rechts_zeile_1 := substr(v_cde_client_zeile_1, 1, 27);
            v_adressfeld_rechts_zeile_2 := substr(v_cde_client_zeile_2, 1, 27);
            v_adressfeld_rechts_zeile_3 := v_artikelnummer;
            v_adressfeld_rechts_zeile_4 := substr(v_reference_client, 1, 27);
      -- v_Adressfeld_Rechts_Zeile_5    := v_Adressfeld_Rechts_Zeile_1; -- Bestellnr Kunde
      -- v_Adressfeld_Rechts_Zeile_6    := '';  -- ist immer leer, bis auf 'Made in Germany' (im Layout enthalten)

      -- v_Bez_Spez_Zeile := 'aaa@bbb@ccc@ddddd@eee';  -- TEST
            c_count := 1;
            pos := 1;
            while
                c_count <= 20
                and pos > 0
            loop
                pos := instr(v_bez_spez_zeile, '@');
                if pos > 0 then
                    v_bezeichnung_zeile(c_count) := substr(v_bez_spez_zeile, 1, pos - 1);
                    v_bez_spez_zeile := substr(v_bez_spez_zeile,
                                               pos + 1,
                                               length(v_bez_spez_zeile));
                    v_bezeichnung_zeile(c_count) := substr(
                        v_bezeichnung_zeile(c_count),
                        1,
                        20
                    );  -- auf 20 Zeichen kürzen
                else
                    v_bezeichnung_zeile(c_count) := v_bez_spez_zeile;  -- Dies ist der Rest, wenn hinten kein @ steht
                end if;

                if pos > 0 then
                    begin
                        pos := instr(v_bez_spez_zeile, '@');
                        if pos > 0 then
                            v_spezifikation_zeile(c_count) := substr(v_bez_spez_zeile, 1, pos - 1);
                            v_bez_spez_zeile := substr(v_bez_spez_zeile,
                                                       pos + 1,
                                                       length(v_bez_spez_zeile));
                            v_spezifikation_zeile(c_count) := substr(
                                v_spezifikation_zeile(c_count),
                                1,
                                34
                            );  -- auf 30 Zeichen kürzen
                        else
                            v_spezifikation_zeile(c_count) := v_bez_spez_zeile;  -- Dies ist der Rest, wenn hinten kein @ steht
                        end if;

                    end;
                end if;

                c_count := c_count + 1;
            end loop;

     -- vom Layout abhängige Felder belegen:

            if v_sid.sid_schnittstelle != 'SQD_SAP' then
                v_adressfeld_rechts_zeile_6 := '';  -- ist immer leer, bis auf 'Made in Germany' (im Layout enthalten)

                case trim(v_layout_nr)
                    when '0201' -- französisch
                     then
                        v_adressfeld_rechts_zeile_1 := '';
                        v_adressfeld_rechts_zeile_2 := '';
                        v_adressfeld_rechts_zeile_3 := v_nummer; -- Kunden-Artikelnummer
                        v_adressfeld_rechts_zeile_4 := '';
            -- v_Adressfeld_Rechts_Zeile_5 := '';   -- hier: BestellNr Kunde
                        v_adressfeld_rechts_zeile_6 := '';
                        v_nummer_rechts := '';
                        v_artikelnummer := '';
                        v_daten_code_id_170 := '';
            -- v_Cde_Client_Zeile_1 aufteilen:
            -- v_Cde_Client_Zeile_1  -- wird nur hier gebraucht
            -- v_Cde_Client_Zeile_2  -- wird nur hier gebraucht

            -- v_Reference_Client   := 'RefClient';-- DUMMYY -- wird nur hier gebraucht
                        v_nummer_unten := '';
                        v_logo_1 := 'Ladder_1201';
                        v_logo_2 := 'adr_0201';
                        v_logo_3 := 'LOT_1201';
                        v_logo_4 := 'foot_0201';
                        v_logo_5 := 'table_1201';
                        v_logo_6 := 'FRANCE';  -- nur hier
                    when '1001' -- deutsch
                     then
                        v_nummer_rechts := '';
                        v_artikelnummer := '';
                        v_daten_code_id_170 := '';
                        v_cde_client_zeile_1 := '';
                        v_cde_client_zeile_2 := '';
                        v_reference_client := '';
                        v_nummer_unten := v_nummer;
                        v_adressfeld_rechts_zeile_5 := '';
                        v_logo_1 := 'Ladder_1001';
                        v_logo_2 := 'adr_1001';
                        v_logo_3 := 'LOT_1001';
                        v_logo_4 := 'foot_1001';
                        v_logo_5 := 'table_1001';
            --v_logo_6             := 'nologo';
                        v_logo_6 := '1'
                                    || lpad(v_nummer, 17, '0');
                    when '1002'  -- deutsch
                     then
                        v_nummer_rechts := '';
            -- 18-stellig, mit 1 beginnend und mit 0-en auffüllen:
                        v_daten_code_id_170 := '1'
                                               || lpad(v_artikelnummer, 17, '0'); -- wird nur hier gebraucht
                        v_artikelnummer := '';
                        v_cde_client_zeile_1 := '';
                        v_cde_client_zeile_2 := '';
                        v_reference_client := '';
                        v_nummer_unten := '';
                        v_adressfeld_rechts_zeile_5 := '';
                        v_logo_1 := 'Ladder_1001';
                        v_logo_2 := 'adr_1001';
                        v_logo_3 := 'LOT_1001';
                        v_logo_4 := 'foot_1001';
                        v_logo_5 := 'table_1001';
            --v_logo_6             := 'nologo';
                        v_logo_6 := '1'
                                    || lpad(v_nummer, 17, '0');
                    when '1003'  -- deutsch
                     then
                        v_nummer_rechts := '';
                        v_artikelnummer := '';
                        v_daten_code_id_170 := '';
                        v_cde_client_zeile_1 := '';
                        v_cde_client_zeile_2 := '';
                        v_reference_client := '';
                        v_nummer_unten := v_nummer;
                        v_adressfeld_rechts_zeile_5 := '';
                        v_logo_1 := 'Ladder_1001';
                        v_logo_2 := 'adr_1001';
                        v_logo_3 := 'LOT_1001';
                        v_logo_4 := 'foot_1001';
                        v_logo_5 := 'table_1001';
            --v_logo_6             := 'nologo';
                        v_logo_6 := '1'
                                    || lpad(v_nummer, 17, '0');
                    when '1004'  -- deutsch
                     then
                        v_adressfeld_rechts_zeile_1 := '';
                        v_adressfeld_rechts_zeile_2 := '';
                        v_adressfeld_rechts_zeile_3 := '';
                        v_adressfeld_rechts_zeile_4 := '';
                        v_adressfeld_rechts_zeile_5 := '';
                        v_adressfeld_rechts_zeile_6 := '';
                        v_nummer_rechts := '';
            -- v_Artikelnummer  -- v_Artikelummer wird nur hier gebraucht
                        v_daten_code_id_170 := '';
                        v_cde_client_zeile_1 := '';
                        v_cde_client_zeile_2 := '';
                        v_reference_client := '';
                        v_nummer_unten := v_nummer;
                        v_logo_1 := 'Ladder_1001';
                        v_logo_2 := 'adr_1001';
                        v_logo_3 := 'LOT_1001';
                        v_logo_4 := 'foot_1001';
                        v_logo_5 := 'table_1001';
            --v_logo_6             := 'nologo';
                        v_logo_6 := '1'
                                    || lpad(v_nummer, 17, '0');
                    when '1101' -- englisch
                     then
                        v_nummer_rechts := '';
                        v_artikelnummer := '';
                        v_daten_code_id_170 := '';
                        v_cde_client_zeile_1 := '';
                        v_cde_client_zeile_2 := '';
                        v_reference_client := '';
                        v_reference_client := '';
                        v_nummer_unten := v_nummer;
                        v_adressfeld_rechts_zeile_5 := '';
                        v_logo_1 := 'Ladder_1102';
                        v_logo_2 := 'adr_1101';
                        v_logo_3 := 'LOT_1101';
                        v_logo_4 := 'foot_1001';
                        v_logo_5 := 'table_1201';
            --v_logo_6             := 'nologo';
                        v_logo_6 := '1'
                                    || lpad(v_nummer, 17, '0');
                    when '1102' -- englisch + Made in Germany + Barcodes
                     then
                        v_nummer_rechts := '';
                        v_artikelnummer := '';
                        v_daten_code_id_170 := '';
                        v_cde_client_zeile_1 := '';
                        v_cde_client_zeile_2 := '';
                        v_reference_client := '';
                        v_nummer_unten := v_nummer;
                        v_adressfeld_rechts_zeile_5 := '';
                        v_logo_1 := 'Ladder_1102';
                        v_logo_2 := 'adr_1102';
                        v_logo_3 := 'LOT_1101';
                        v_logo_4 := 'nologo';
                        v_logo_5 := 'nologo';
            --v_logo_6             := 'nologo';
                        v_logo_6 := '1'
                                    || lpad(v_nummer, 17, '0');
                        v_barcode_id_110_fifo := to_char(v_packdatum, 'YYYYMM');
                        v_barcode_id_120_part := translate(v_nummer, '#', '-');
                        v_barcode_id_130_qty := v_anzahl_pro_karton;
            -- QY + SubStr(v_Kommission_Lot,3,8), also hier nur 8 Zeichen lang
            -- Aenderungswusch M.Schütz tel. 17.02.2010
            -- v_Barcode_ID_140_LOT        := 'QY' || SubStr(v_Kommission_Lot,3,8);
                        v_barcode_id_140_lot := substr(v_kommission_lot, 3, 8);
                        v_barcode_id_150_carton := v_kartonnummer;
                        v_text_fifo := 'FIFO:';
                        v_text_part := 'PART #';
                        v_text_qty := 'QTY:';
                        v_text_lot := 'LOT TRACE #';
                        v_text_carton := 'CARTON #';
                        for c_count in 1..20 loop
                            v_bezeichnung_zeile(c_count) := null;   -- nur hier nicht
                            v_spezifikation_zeile(c_count) := null; -- nur hier nicht
                        end loop;

                    when '1201' -- französisch

                     then
                        v_nummer_rechts := '';
                        v_artikelnummer := '';
                        v_daten_code_id_170 := '';
                        v_cde_client_zeile_1 := '';
                        v_cde_client_zeile_2 := '';
                        v_reference_client := '';
                        v_nummer_unten := v_nummer;
                        v_adressfeld_rechts_zeile_5 := '';
                        v_logo_1 := 'Ladder_1201';
                        v_logo_2 := 'adr_1201';
                        v_logo_3 := 'LOT_1201';
                        v_logo_4 := 'foot_1001';
                        v_logo_5 := 'table_1201';
                        v_logo_6 := 'nologo';
                    when c_layout_nr_vormontage -- Vormontage-Label
                     then
                        v_nummer_rechts := '';
                        v_artikelnummer := '';
                        v_daten_code_id_170 := '';
                        v_cde_client_zeile_1 := '';
                        v_cde_client_zeile_2 := '';
                        v_reference_client := '';
                        v_nummer_unten := '';
                        v_logo_1 := '';
                        v_logo_2 := '';
                        v_logo_3 := '';
                        v_logo_4 := '';
                        v_logo_5 := '';
                        v_logo_6 := '';
                        v_adressfeld_rechts_zeile_1 := '';
                        v_adressfeld_rechts_zeile_2 := '';
                        v_adressfeld_rechts_zeile_3 := '';
                        v_adressfeld_rechts_zeile_4 := '';
                        v_adressfeld_rechts_zeile_5 := '';
                        v_adressfeld_rechts_zeile_6 := '';
                        v_barcode_id_110_fifo := '';
                        v_barcode_id_120_part := '';
                        v_barcode_id_130_qty := '';
                        v_barcode_id_140_lot := '';
                        v_barcode_id_150_carton := '';
                        v_text_fifo := '';
                        v_text_part := '';
                        v_text_qty := '';
                        v_text_lot := '';
                        v_text_carton := '';
                        for c_count in 1..20 loop
                            v_bezeichnung_zeile(c_count) := null;
                            v_spezifikation_zeile(c_count) := null;
                        end loop;

                        if v_anzahl_pro_karton < v_lhm_menge then
                            v_bezeichnung_zeile(1) := 'RESTKARTON';
                        else
                            v_bezeichnung_zeile(1) := 'STANDARDKARTON';
                        end if;

                    else
                        v_err_text := ' Ungültige Layout-Nummer ' || v_layout_nr;
                        v_err_nr := 50;
                        raise v_error;
                end case;

            else
                if trim(v_layout_nr) = c_layout_nr_vormontage -- Vormontage-Label
                 then
                    v_nummer_rechts := '';
                    v_artikelnummer := '';
                    v_daten_code_id_170 := '';
                    v_cde_client_zeile_1 := '';
                    v_cde_client_zeile_2 := '';
                    v_reference_client := '';
                    v_nummer_unten := '';
                    v_logo_1 := '';
                    v_logo_2 := '';
                    v_logo_3 := '';
                    v_logo_4 := '';
                    v_logo_5 := '';
                    v_logo_6 := '';
                    v_adressfeld_rechts_zeile_1 := '';
                    v_adressfeld_rechts_zeile_2 := '';
                    v_adressfeld_rechts_zeile_3 := '';
                    v_adressfeld_rechts_zeile_4 := '';
                    v_adressfeld_rechts_zeile_5 := '';
          -- v_Adressfeld_Rechts_Zeile_6 := ''; -AG- 23.12.2010 Wird jetzt benötigt
                    v_barcode_id_110_fifo := '';
                    v_barcode_id_120_part := '';
                    v_barcode_id_130_qty := '';
                    v_barcode_id_140_lot := '';
                    v_barcode_id_150_carton := '';
                    v_text_fifo := '';
                    v_text_part := '';
                    v_text_qty := '';
                    v_text_lot := '';
                    v_text_carton := '';
                    for c_count in 1..20 loop
                        v_bezeichnung_zeile(c_count) := null;
                        v_spezifikation_zeile(c_count) := null;
                    end loop;

                    if v_anzahl_pro_karton < v_lhm_menge then
                        v_bezeichnung_zeile(1) := 'RESTKARTON';
                    else
                        v_bezeichnung_zeile(1) := 'STANDARDKARTON';
                    end if;

                else
                    v_barcode_id_110_fifo := to_char(v_packdatum, 'YYYYMM');
                    v_barcode_id_120_part := translate(v_nummer, '#', '-'); --v_Nummer;
                    v_barcode_id_130_qty := v_anzahl_pro_karton;
          -- QY + SubStr(v_Kommission_Lot,3,8), also hier nur 8 Zeichen lang
          -- Aenderungswusch M.Schütz tel. 17.02.2010
          -- v_Barcode_ID_140_LOT        := 'QY' || SubStr(v_Kommission_Lot,3,8);
                    v_barcode_id_140_lot := substr(v_kommission_lot, 3, 8);
                    v_barcode_id_150_carton := v_kartonnummer;
                    v_text_fifo := 'FIFO:';
                    v_text_part := 'PART #';
                    v_text_qty := 'QTY:';
                    v_text_lot := 'LOT TRACE #';
                    v_text_carton := 'CARTON #';
                    if trim(v_layout_nr) != '0201'   -- Frances
                     then
                        v_daten_code_id_170 := '';
                        v_cde_client_zeile_1 := '';
                        v_cde_client_zeile_2 := '';
                        v_reference_client := '';
                    end if;

                    if trim(v_layout_nr) not in ( '1002', '1003', '1004', '1102' )   -- BOM

                     then
                        v_barcode_id_110_fifo := '';
                        v_barcode_id_120_part := '';
                        v_barcode_id_130_qty := '';
                        v_barcode_id_140_lot := '';
                        v_barcode_id_150_carton := '';
                        v_text_fifo := '';
                        v_text_part := '';
                        v_text_qty := '';
                        v_text_lot := '';
                        v_text_carton := '';
                    end if;

                    v_nummer_rechts := '';
                    v_artikelnummer := '';
                    v_nummer_unten := v_nummer;
          -- -AG- Erweiterung PRJ 5315
                    if trim(v_layout_nr) not in ( '0201', -- sqdf
                     '1001', '1101', '1201' ) -- BOM
                     then -- CODE39 nur als Barcode im LABEL sqd_std
                        v_nummer_unten := upper(v_nummer);
                        v_code39 := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'CFG',                -- in_kategorie             in isi_firma_cfg.kategorie%type,
                         null,                -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                         'CODE39_VALUES',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                   'ALL',                -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                    'CFG',                -- in_typ                   in isi_firma_cfg.typ%type,
                                                                             -- Erlaubte Zeichen im COD39
                                                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.-*$/+%#',
                                                                              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                    'STRING');             -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                        if v_nummer_unten is not null then
                            i := 1;
                            loop
                                exit when i > length(v_nummer_unten);
                                if substr(v_nummer_unten, i, 1) = '#' -- Sonderbehandlung '#' für Seaquist
                                 then
                                    v_nummer_unten := substr(v_nummer_unten, 1, i - 1)
                                                      || '-'
                                                      || substr(v_nummer_unten, i + 1);

                                end if;

                                if instrc(v_code39,
                                          substr(v_nummer_unten, i, 1),
                                          1,
                                          1) = 0 then
                                    v_nummer_unten := substr(v_nummer_unten, 1, i - 1)
                                                      || 'Z'
                                                      || substr(v_nummer_unten, i + 1);
                                end if;

                                i := i + 1;
                            end loop;

                        end if;

                    end if;
          --v_Adressfeld_Rechts_Zeile_5 := '';
                    v_logo_1 := '';
                    v_logo_2 := '';
                    v_logo_3 := '';
                    v_logo_4 := '';
                    v_logo_5 := '';
          --v_logo_6             := 'nologo';
                    v_logo_6 := '1'
                                || lpad(v_nummer, 17, '0');
                end if;
            end if;

  /*
     -- if v_Layout_Nr = C_LAYOUT_NR_VORMONTAGE
     -- then
       v_print_daten :=

      'Layout_Nr='                    || v_Layout_Nr || CHR(13) || CHR(10) ||
      'Basis_Layout='                 || v_Basis_Layout || CHR(13) || CHR(10) ||
      'Ident='                        || v_Ident || CHR(13) || CHR(10) ||
      'Anzahl_pro_Karton='            || v_Anzahl_pro_Karton || CHR(13) || CHR(10) ||
      'Packdatum='                    || to_char(v_Packdatum, 'DD.MM.YYYY') || CHR(13) || CHR(10) ||
      'Kartonnummer='                 || v_Kartonnummer || CHR(13) || CHR(10) ||
      'Kommission_Lot='               || v_Kommission_Lot || CHR(13) || CHR(10) ||
      'Barcode_ID_100='               || v_Barcode_ID_100 || CHR(13) || CHR(10) ||
      'Fertigungsauftrag='            || v_Kunden_Auftrag || CHR(13) || CHR(10) ||
      'Karton_ID_Vormontage='         || v_Karton_ID_Vormontage|| CHR(13) || CHR(10) ||
      'M_Auftrag='                    || v_M_Auftrag || CHR(13) || CHR(10) ||
      'Maschine='                     || v_Maschine || CHR(13) || CHR(10) ||
      'Drucken='                      || v_Drucken|| CHR(13) || CHR(10);

     -- else
  */
            if v_sid.sid_schnittstelle != 'SQD_SAP' then
                v_packdatum_string := to_char(v_packdatum, 'DD.MM.YYYY');
                v_packdatum_klein := to_char(v_packdatum, 'DD.MM.YYYY');
            else
                v_packdatum_string := to_char(v_packdatum, 'YYYY-MM-DD HH24:mi');
                v_packdatum_klein := to_char(v_packdatum, 'YYYY-MM-DD');
            end if;

        end if;

        v_print_daten := 'Layout_Nr='
                         || v_layout_nr
                         || chr(13)
                         || chr(10)
                         || 'Basis_Layout='
                         || v_basis_layout
                         || chr(13)
                         || chr(10)
                         || 'Ident='
                         || v_ident
                         || chr(13)
                         || chr(10)
                         || 'Anzahl_pro_Karton='
                         || v_anzahl_pro_karton
                         || chr(13)
                         || chr(10)
                         || 'Gesamt='
                         || v_gesamt
                         || chr(13)
                         || chr(10)
                         || 'Packdatum='
                         || v_packdatum_klein
                         || chr(13)
                         || chr(10)
                         || 'Kartonnummer='
                         || v_kartonnummer
                         || chr(13)
                         || chr(10)
                         || 'Karton_ID='
                         || v_karton_id
                         || chr(13)
                         || chr(10)
                         || 'Nummer_rechts='
                         || v_nummer_rechts
                         || chr(13)
                         || chr(10)
                         || 'Artikelnummer='
                         || v_artikelnummer
                         || chr(13)
                         || chr(10)
                         || 'Daten_Code_Id_170='
                         || v_daten_code_id_170
                         || chr(13)
                         || chr(10)
                         || 'Kommission_Lot='
                         || v_kommission_lot
                         || chr(13)
                         || chr(10)
                         || 'Cde_Client_Zeile_1='
                         || v_cde_client_zeile_1
                         || chr(13)
                         || chr(10)
                         || 'Cde_Client_Zeile_2='
                         || v_cde_client_zeile_2
                         || chr(13)
                         || chr(10)
                         || 'Reference_Client='
                         || v_reference_client
                         || chr(13)
                         || chr(10)
                         || 'Packdatum_big='
                         || v_packdatum_string
                         || chr(13)
                         || chr(10)
                         || 'Nummer_unten='
                         || v_nummer_unten
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Links_Zeile_1='
                         || v_adressfeld_links_zeile_1
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Links_Zeile_2='
                         || v_adressfeld_links_zeile_2
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Links_Zeile_3='
                         || v_adressfeld_links_zeile_3
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Links_Zeile_4='
                         || v_adressfeld_links_zeile_4
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Links_Zeile_5='
                         || v_adressfeld_links_zeile_5
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Links_Zeile_6='
                         || v_adressfeld_links_zeile_6
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Rechts_Zeile_1='
                         || v_adressfeld_rechts_zeile_1
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Rechts_Zeile_2='
                         || v_adressfeld_rechts_zeile_2
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Rechts_Zeile_3='
                         || v_adressfeld_rechts_zeile_3
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Rechts_Zeile_4='
                         || v_adressfeld_rechts_zeile_4
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Rechts_Zeile_5='
                         || v_adressfeld_rechts_zeile_5
                         || chr(13)
                         || chr(10)
                         || 'Adressfeld_Rechts_Zeile_6='
                         || v_adressfeld_rechts_zeile_6
                         || chr(13)
                         || chr(10)
                         || 'Barcode_ID_100='
                         || v_barcode_id_100
                         || chr(13)
                         || chr(10)
                         || 'Barcode_ID_110_FIFO='
                         || v_barcode_id_110_fifo
                         || chr(13)
                         || chr(10)
                         || 'Barcode_ID_120_PART='
                         || v_barcode_id_120_part
                         || chr(13)
                         || chr(10)
                         || 'Barcode_ID_130_QTY='
                         || v_barcode_id_130_qty
                         || chr(13)
                         || chr(10)
                         || 'Barcode_ID_140_LOT='
                         || v_barcode_id_140_lot
                         || chr(13)
                         || chr(10)
                         || 'Barcode_ID_150_CARTON='
                         || v_barcode_id_150_carton
                         || chr(13)
                         || chr(10)
                         ||

    -- if v_Layout_Nr = C_LAYOUT_NR_VORMONTAGE  -- Felder 46 - 49 nur beim Vormontage-Layout
    -- then
                          'Fertigungsauftrag='
                         || v_kunden_auftrag
                         || chr(13)
                         || chr(10)
                         || 'Karton_ID_Vormontage='
                         || v_id
                         || chr(13)
                         || chr(10)
                         || 'M_Auftrag='
                         || '95'
                         || v_m_auftrag
                         || chr(13)
                         || chr(10)
                         || 'Maschine='
                         || v_maschine
                         || chr(13)
                         || chr(10)
                         ||
    -- end;
                          'Text_FIFO='
                         || v_text_fifo
                         || chr(13)
                         || chr(10)
                         || 'Text_PART='
                         || v_text_part
                         || chr(13)
                         || chr(10)
                         || 'Text_QTY='
                         || v_text_qty
                         || chr(13)
                         || chr(10)
                         || 'Text_LOT='
                         || v_text_lot
                         || chr(13)
                         || chr(10)
                         || 'Text_CARTON='
                         || v_text_carton
                         || chr(13)
                         || chr(10)
                         || 'Logo_1='
                         || v_logo_1
                         || chr(13)
                         || chr(10)
                         || 'Logo_2='
                         || v_logo_2
                         || chr(13)
                         || chr(10)
                         || 'Logo_3='
                         || v_logo_3
                         || chr(13)
                         || chr(10)
                         || 'Logo_4='
                         || v_logo_4
                         || chr(13)
                         || chr(10)
                         || 'Logo_5='
                         || v_logo_5
                         || chr(13)
                         || chr(10)
                         || 'Logo_6='
                         || v_logo_6
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_1='
                         || v_bezeichnung_zeile(1)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_1='
                         || v_spezifikation_zeile(1)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_2='
                         || v_bezeichnung_zeile(2)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_2='
                         || v_spezifikation_zeile(2)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_3='
                         || v_bezeichnung_zeile(3)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_3='
                         || v_spezifikation_zeile(3)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_4='
                         || v_bezeichnung_zeile(4)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_4='
                         || v_spezifikation_zeile(4)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_5='
                         || v_bezeichnung_zeile(5)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_5='
                         || v_spezifikation_zeile(5)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_6='
                         || v_bezeichnung_zeile(6)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_6='
                         || v_spezifikation_zeile(6)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_7='
                         || v_bezeichnung_zeile(7)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_7='
                         || v_spezifikation_zeile(7)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_8='
                         || v_bezeichnung_zeile(8)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_8='
                         || v_spezifikation_zeile(8)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_9='
                         || v_bezeichnung_zeile(9)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_9='
                         || v_spezifikation_zeile(9)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_10='
                         || v_bezeichnung_zeile(10)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_10='
                         || v_spezifikation_zeile(10)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_11='
                         || v_bezeichnung_zeile(11)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_11='
                         || v_spezifikation_zeile(11)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_12='
                         || v_bezeichnung_zeile(12)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_12='
                         || v_spezifikation_zeile(12)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_13='
                         || v_bezeichnung_zeile(13)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_13='
                         || v_spezifikation_zeile(13)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_14='
                         || v_bezeichnung_zeile(14)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_14='
                         || v_spezifikation_zeile(14)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_15='
                         || v_bezeichnung_zeile(15)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_15='
                         || v_spezifikation_zeile(15)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_16='
                         || v_bezeichnung_zeile(16)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_16='
                         || v_spezifikation_zeile(16)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_17='
                         || v_bezeichnung_zeile(17)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_17='
                         || v_spezifikation_zeile(17)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_18='
                         || v_bezeichnung_zeile(18)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_18='
                         || v_spezifikation_zeile(18)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_19='
                         || v_bezeichnung_zeile(19)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_19='
                         || v_spezifikation_zeile(19)
                         || chr(13)
                         || chr(10)
                         || 'Bezeichnung_Zeile_20='
                         || v_bezeichnung_zeile(20)
                         || chr(13)
                         || chr(10)
                         || 'Spezifikation_Zeile_20='
                         || v_spezifikation_zeile(20)
                         || chr(13)
                         || chr(10)
                         || 'Drucken='
                         || v_drucken
                         || chr(13)
                         || chr(10)
                         || 'Barcode_ID_PL_MENDEN='
                         || v_barcode_id_pl_menden
                         || chr(13)
                         || chr(10)
                         || 'Barcode_ID_00_MENDEN='
                         || v_barcode_id_00_menden
                         || chr(13)
                         || chr(10);

   -- end if; -- if v_Layout_Nr ...
        return ( v_print_daten );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end vda_etikett_vers_krt;

    function ccg_etikett_vers_lte (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_id       in lvs_lhm.lhm_id%type
    ) return varchar2 is

        v_print_daten         varchar2(4096);
        v_charge_bez          varchar2(10);
        v_artikel             isi_artikel.artikel%type;
        v_kunden_nr           isi_adressen.adr_nr%type;
        v_menge               lvs_lam.menge%type;
        v_prod_date           varchar2(10);
        v_prod_date_bc1       varchar2(10);
        v_prod_date_bc2       varchar2(10);
        v_name_1              varchar2(30);
        v_name_2              varchar2(30);
        v_strasse             varchar2(30);
        v_plz                 isi_adressen.plz%type;
        v_ort                 isi_adressen.ort%type;
        v_z_lgr_platz         lvs_lgr.lgr_platz%type;
        v_info_1              isi_adressen.info_1%type;
        v_kd_art_nr           bde_fa_auftrag.kd_art_nr%type;
        v_kd_art_text         bde_fa_auftrag.ag_text1%type;
        v_ccg_barcode1_string varchar2(100);  --BC1_TEXT
        v_ccg_barcode2_string varchar2(100);  --BC2_TEXT
        v_ccg_barcode3_string varchar2(100);  --BC3_TEXT

        v_ccg_barcode1        varchar2(100);  --BC1
        v_ccg_barcode2        varchar2(100);  --BC2
        v_ccg_barcode3        varchar2(100);  --BC2

        cursor c_get_eti_daten is
        select
            substr(c.charge_bez, 1, 10) charge_bez,
            art.artikel,
            fa.kunden_nr,
            sum(lam.menge)              menge,
            to_char(
                max(lam.prod_datum),
                'dd.mm.yyyy'
            )                           prod_datum,
            to_char(
                max(lam.prod_datum),
                'ddmmyy'
            )                           prod_datum_bc1,
            to_char(
                max(lam.prod_datum),
                'yymmdd'
            )                           prod_datum_bc2,
            substr(adr.name_1, 1, 30)   name_1,
            substr(adr.name_2, 1, 30)   name_2,
            substr(adr.strasse, 1, 30)  strasse,
            adr.plz,
            substr(adr.ort, 1, 30)      ort,
            z.lgr_platz,
            adr.info_1,
            fa.kd_art_nr,
            fa.ag_text1
        from
            lvs_lam            lam,
            lvs_charge         c,
            isi_artikel        art,
            isi_adressen       adr,
            bde_fa_auftrag     fa,
            sqd_land_trsp_ziel z,
            lvs_lgr            lgr
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and c.sid (+) = lam.sid
            and c.charge_id (+) = lam.charge_id
            and art.artikel_id (+) = lam.artikel_id
            and fa.sid (+) = lam.sid
            and fa.firma_nr (+) = in_firma_nr
            and fa.leitzahl (+) = lam.leitzahl
            and fa.satzart (+) = 'V'
            and adr.adr_nr (+) = to_char(fa.kunden_nr)
            and adr.adr_liefer (+) = fa.kunden_nr_adr_liefer
            and adr.land_kurz = z.land_kurz (+)
            and lgr.lgr_ort (+) = z.lgr_ort
            and lgr.lgr_platz (+) = z.lgr_platz
            and lam.lte_id = in_id
        group by
            c.charge_bez,
            art.artikel,
            fa.kunden_nr,
            lam.lte_id,
            fa.kd_art_nr,
            fa.ag_text1,
            adr.name_1,
            adr.name_2,
            adr.strasse,
            adr.plz,
            adr.ort,
            z.lgr_platz,
            adr.info_1;

    begin
        open c_get_eti_daten;
        fetch c_get_eti_daten into
            v_charge_bez,
            v_artikel,
            v_kunden_nr,
            v_menge,
            v_prod_date,
            v_prod_date_bc1,
            v_prod_date_bc2,
            v_name_1,
            v_name_2,
            v_strasse,
            v_plz,
            v_ort,
            v_z_lgr_platz,
            v_info_1,
            v_kd_art_nr,
            v_kd_art_text;

        close c_get_eti_daten;

    -- (93) Kundennummer
        v_ccg_barcode1 := '91'
                          || v_kd_art_nr
                          || chr(29)
                          ||                   -- Kunden Artikelnummer
                           '37'
                          || v_menge;                            -- Menge
        v_ccg_barcode1_string := '(91)'
                                 || v_kd_art_nr
                                 ||                              -- Kunden Artikelnummer
                                  '(37)'
                                 || v_menge;                          -- Menge
    -- (37) Menge (11) Prod. Datum (10) Charge
        v_ccg_barcode2 := '10'
                          || 'SEDO'
                          || v_charge_bez
                          || chr(29)
                          ||-- Charge
                           '90'
                          || 'E2';

        v_ccg_barcode2_string := '(10)'
                                 || 'SEDO'
                                 || v_charge_bez
                                 ||         -- Charge
                                  '(90)'
                                 || 'E2';                             --
    -- (00) CCG
        v_ccg_barcode3 := '00' || in_id;                              -- CCG NVE
        v_ccg_barcode3_string := '(00)' || in_id;                            -- CCG NVE

        v_print_daten := 'Charge='
                         || v_charge_bez
                         || chr(13)
                         || chr(10)
                         || 'Ident='
                         || v_artikel
                         || chr(13)
                         || chr(10)
                         || 'KundenNr='
                         || v_kunden_nr
                         || chr(13)
                         || chr(10)
                         || 'StkProPalette='
                         || to_char(v_menge)
                         || chr(13)
                         || chr(10)
                         || 'ProdDatum='
                         || v_prod_date
                         || chr(13)
                         || chr(10)
                         || 'PalettenNr='
                         || substr(in_id, 11, 7)
                         || chr(13)
                         || chr(10)
                         || -- Bei seaquist die lfd-nr aus der NVE
                          'Relation='
                         || v_info_1
                         || chr(13)
                         || chr(10)
                         || 'Liefer_Adr_1='
                         || v_name_1
                         || chr(13)
                         || chr(10)
                         || 'Liefer_Adr_2='
                         || v_name_2
                         || chr(13)
                         || chr(10)
                         || 'Liefer_Adr_3='
                         || v_plz
                         || ' '
                         || v_ort
                         || chr(13)
                         || chr(10)
                         || 'NVE='
                         || in_id
                         || chr(13)
                         || chr(10)
                         || 'KundenArtNr='
                         || v_kd_art_nr
                         || chr(13)
                         || chr(10)
                         || 'KundenArtText='
                         || v_kd_art_text
                         || chr(13)
                         || chr(10)
                         || 'CCG_BARCODE1='
                         || v_ccg_barcode1
                         || chr(13)
                         || chr(10)
                         || 'CCG_BARCODE1_STRING='
                         || v_ccg_barcode1_string
                         || chr(13)
                         || chr(10)
                         || 'CCG_BARCODE2='
                         || v_ccg_barcode2
                         || chr(13)
                         || chr(10)
                         || 'CCG_BARCODE2_STRING='
                         || v_ccg_barcode2_string
                         || chr(13)
                         || chr(10)
                         || 'CCG_BARCODE3='
                         || v_ccg_barcode3
                         || chr(13)
                         || chr(10)
                         || 'CCG_BARCODE3_STRING='
                         || v_ccg_barcode3_string
                         || chr(13)
                         || chr(10);

        return ( v_print_daten );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end ccg_etikett_vers_lte;

end;
/


-- sqlcl_snapshot {"hash":"a75f2fe7d8c73d769df05cc9fc4b43181544617d","type":"PACKAGE_BODY","name":"Z_SEAQUIST_DRUCK","schemaName":"DIRKSPZM32","sxml":""}