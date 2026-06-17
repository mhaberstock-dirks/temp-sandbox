create or replace 
package body DIRKSPZM32.z_seaquist_druck is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  TYPE t_bezeichnung_liste IS TABLE OF varchar2(255) INDEX BY PLS_INTEGER;

  -- Private constant declarations
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  --<ConstantName> constant <Datatype> := <Value>;

  C_LAYOUT_NR_VORMONTAGE    constant varchar2(20) := 'vormontage';
  -- -AG- Alt vor SAP
  C_BASIS_LAYOUT_VERSAND    constant varchar2(20) := '7398_a.llf';
  C_BASIS_LAYOUT_VORMONTAGE constant varchar2(20) := 'vormontage.llf';
  -- Neues Layout heisst jetzt
  C_BASIS_LAYOUT_VERSAND_SAP    constant varchar2(20) := 'spd_std.llf';
  C_BASIS_LAYOUT_VERSAND_SAP201 constant varchar2(20) := 'spd_f.llf';
  C_BASIS_LAYOUT_VERSAND_SAPBOM constant varchar2(20) := 'spd_bom.llf';
  C_BASIS_LAYOUT_VORMONTAGE_SAP constant varchar2(20) := 'spd_inerbox.llf';


  function vda_etikett_vers_krt(in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_id          in lvs_lhm.lhm_id%type)
                              return varchar2 is

    v_print_daten               varchar2(4096);
    v_found                     boolean;
    v_sid                       isi_sid%rowtype;
    v_firma_nr                  lvs_lhm.firma_nr%type;
    v_leitzahl                  lvs_lam.leitzahl%type;
    v_adr_liefer                isi_adressen.adr_liefer%type;
    v_kunden_nr                 isi_adressen.adr_nr%type;
    v_Layout_Nr                 varchar2(255);  -- Nummer des LOGOPAK-Layouts ('vormontage', '0201', etc.)
                                                -- SubStr(ISI_ADRESSE.LHM_ETIKETTEN_LAYOUT), Zeichen für Vormontage ist ???
    v_Basis_Layout              varchar2(255);  -- Basislayout (Versand- und Vormontage-Layout)
    v_Ident                     varchar2(255);  -- interne Artikelnr: ISI_ARTIKEL.ARTIKEL >>> kommt als S_SEAQUIST_RCV_FA_AUF.AB_ARTIKEL von MAPICS
    v_Anzahl_pro_Karton         varchar2(255);  -- LVS_LAM.MENGE                      >>> IST-Menge im Karton
    v_Gesamt                    varchar2(255);  -- BDE_FA_AUFTRAG.AB_SOLL_MG          >>> SOLL-Menge des FA
    v_Packdatum                 lvs_lam.prod_datum%type;  -- LVS_LAM.PROD_DATUM       >>> Paletten-Packdatum = heute
    v_Packdatum_string          varchar2(255);
    v_Packdatum_klein           varchar2(255);
    v_Kartonnummer              varchar2(255);  -- LVS_LAM.LHM_LFD_NR                 >>> laufende KartonNr. pro FA
    v_Karton_ID                 varchar2(255);  -- LhmId                              >>> IST-Menge mit SOLL-Menge (BDE_FA.LHM_MENGE) vergleichen
    v_ID                        varchar2(255);  -- LhmId                              >>> IST-Menge mit SOLL-Menge (BDE_FA.LHM_MENGE) vergleichen
                                                --                                    >>> mit führendem S: Volle Menge M: Anbruchmenge
    v_Nummer                    varchar2(255);  -- = v_Artikelnummer                  >>> Kunden-Artikelnummer BDE_FA_AUFTRAG.KD_ART_NR
    v_Nummer_rechts             varchar2(255);  -- = v_Nummer                         >>> BDE_FA_AUFTRAG.KD_ART_NR
    v_Artikelnummer             varchar2(255);  -- BDE_FA_AUFTRAG.KD_ART_NR (nur 1004)>>> = BDE_FA_AUFTRAG.KD_ART_NR (muss noch über MAPICS kommen!)
    v_Daten_Code_Id_170         varchar2(255);  -- = v_Artikelnummer, aber 18-stellig, mit 1 beginnend und mit 0-en auffüllen
                                                -- (muss noch über MAPICS kommen!)(nur 1002)
    v_Kommission_Lot            varchar2(255);  -- LVS_CHARGE.CHARGE_BEZ:              >>> ersten 10 Zeichen von CHARGE_BEZ
    v_Cde_Client_Zeile_1        varchar2(255);  -- (nur 0201) neues Feld bde_fa_auftrag.AG_TEXT2
    v_Cde_Client_Zeile_2        varchar2(255);  -- (nur 0201) neues Feld bde_fa_auftrag.AG_TEXT3
    v_Reference_Client          varchar2(255);  -- (nur 0201) von MAPICS: ISI_ARTIKEL_KUNDE.KD_ART_TEXT1 aus S_SEAQUIST_RCV_ART_KD.KD_ART_TEXT1
    v_Nummer_unten              varchar2(255);  -- = v_Nummer (nur bei manchen Layouts)
    v_Adressfeld_Links_Zeile_1  varchar2(255);  -- ISI_ADRESSEN.NAME_1 (Lieferanschrift)  >>> NAME1
    v_Adressfeld_Links_Zeile_2  varchar2(255);  -- ISI_ADRESSEN.NAME_2 (Lieferanschrift)  >>> NAME2
    v_Adressfeld_Links_Zeile_3  varchar2(255);  -- ISI_ADRESSEN.NAME_3 (Lieferanschrift)  >>> NAME3
    v_Adressfeld_Links_Zeile_4  varchar2(255);  -- ISI_ADRESSEN.STRASSE(Lieferanschrift)  >>> STRASSE
    v_Adressfeld_Links_Zeile_5  varchar2(255);  -- ISI_ADRESSEN...     (Lieferanschrift)  >>> Zeile 5 bleibt leer!
    v_Adressfeld_Links_Zeile_6  varchar2(255);  -- ISI_ADRESSEN...     (Lieferanschrift)  >>> LAND_KURZ + PLZ + ORT
    v_Adressfeld_Rechts_Zeile_1 varchar2(255);  -- <<< siehe Excel
    v_Adressfeld_Rechts_Zeile_2 varchar2(255);  -- <<< siehe Excel
    v_Adressfeld_Rechts_Zeile_3 varchar2(255);  -- <<< siehe Excel
    v_Adressfeld_Rechts_Zeile_4 varchar2(255);  -- <<< siehe Excel
    v_Adressfeld_Rechts_Zeile_5 varchar2(255);  -- <<< siehe Excel
    v_Adressfeld_Rechts_Zeile_6 varchar2(255);  -- <<< siehe Excel
    v_Barcode_ID_100            varchar2(255);  -- >>> Ident-Nr(7) ChargeBez(10)+Packdatum(6:ddmmyy)+Stkzahl im Karton+'D' (nur 1102)
    v_Barcode_ID_110_FIFO       varchar2(255);  -- v_Packdatum im Format YYYYMM (nur 1102)
    v_Barcode_ID_120_PART       varchar2(255);  -- v_Nummer (nur 1102)
    v_Barcode_ID_130_QTY        varchar2(255);  -- v_Anzahl_pro_Karton (nur 1102)
    v_Barcode_ID_140_LOT        varchar2(255);  -- >>> QY + SubStr(v_Kommission_Lot,3,8), also hier nur 8 Zeichen lang (nur 1102)
    v_Barcode_ID_150_CARTON     varchar2(255);  -- v_Kartonnummer (nur 1102)
    v_Barcode_ID_PL_MENDEN      varchar2(255);  -- Spezialbarcode für den Palletierer in Menden
    v_Barcode_ID_00_MENDEN      varchar2(255);  -- Spezialbarcode für den Palletierer in Menden
    v_Text_FIFO                 varchar2(255);  -- 'FIFO:' (nur 1102)
    v_Text_PART                 varchar2(255);  -- 'PART ' (nur 1102)
    v_Text_QTY                  varchar2(255);  -- 'QTY:' (nur 1102)
    v_Text_LOT                  varchar2(255);  -- 'LOT TRACE #' (nur 1102)
    v_Text_CARTON               varchar2(255);  -- 'CARTON #' (nur 1102)
    v_Logo_1                    varchar2(255);  -- Leiter mit Titeltexten (Tabelle rechts)
    v_Logo_2                    varchar2(255);  -- Adressfeldtabelle mit Titeltexten
    v_Logo_3                    varchar2(255);  -- Rahmen Lot mit Titeltexten
    v_Logo_4                    varchar2(255);  -- Rahmen unten mit Titeltexten
    v_Logo_5                    varchar2(255);  -- Tabelle Produktteile mit Titeltexten
    v_Logo_6                    varchar2(255);  -- France (nur 1102)
    v_Bez_Spez_Zeile            varchar2(2000); -- aus BDE_FA_AUFTRAG.PROD_PARAMS(STK_LISTE_TXT), z.B. descr1@spez1@desc2@spez2@...
    v_Bezeichnung_Zeile         t_bezeichnung_liste;  -- siehe v_Bez_Spez_Zeile
    v_Spezifikation_Zeile       t_bezeichnung_liste;  -- siehe v_Bez_Spez_Zeile
    v_Drucken                   varchar2(255);  -- 1: Etikett drucken, sonst ' '
    -- nur für Vormontage-Label:
    v_Kunden_Auftrag            varchar2(255);  -- Kundenauftragsnummer                >>> FA.AB_NR
    v_M_Auftrag                 varchar2(255);  -- interne Auftragsnummer              >>> M+LEITZAHL
    v_Maschine                  varchar2(255);  -- Maschinenname ISI_RESOURCE.RES_NAME >>> noch offen (H. Schütz)
    v_qs_status                 lvs_lam.qs_status%type;

    v_nve                       varchar2(20);   -- Fuer SSCC Nummer auf dem Etikett

    v_Lhm_Menge                 integer;        -- Menge pro Karton: BDE_FA_AUFTRAG.LHM_MENGE (für die Entscheidung STANDARD- oder RESTKARTON
    v_lte_lhm_lagen             integer;        -- Anzahl der lagen (Packhoehe)
    v_fa_soll                   integer;
    v_fa_ist                    integer;
    pos                         integer;
    c_count                     integer;
    i                           integer;
    v_code39                    varchar2(256);  -- -AG- Mögliche Zeichen CODE39 aus Firma_cfg

    CURSOR c_sid is
      select *
        from isi_sid t
       where t.sid = in_sid;
-- in:  v_sid, v_firma_nr, v_Karton_ID
-- out: v_Anzahl_pro_Karton, v_Ident, v_Kommission_Lot,
--      v_Artikelnummer, v_leitzahl, v_Packdatum, v_Kartonnummer, v_Maschine

    CURSOR c_lhm_lam_art_charge is
      select lam.menge, SubStr(art.artikel,1,8), SubStr(c.charge_bez,1,10),
             lam.kd_art_nr, lam.leitzahl, lam.prod_datum, NVL(lam.lhm_lfd_nr, 0), SubStr(res.res_ext_name, 1,10),
             lam.qs_status
        from lvs_lhm lhm, lvs_lam lam, isi_artikel art, lvs_charge c, isi_resource res
      where lhm.sid = v_sid.sid
        and lhm.firma_nr = v_firma_nr
        and lam.lhm_id = lhm.lhm_id
        and lam.menge > 0
        and art.artikel_id (+) = lam.artikel_id
        and c.charge_id (+) = lam.charge_id
        and res.res_id (+) = lam.res_id
        and res.typ (+) = 'MS'
        and lhm.lhm_id = v_Karton_ID;

-- in:  v_sid, v_firma_nr, v_leitzahl
-- out: v_Gesamt, v_kunden_nr, v_adr_liefer, v_Nummer, v_Reference_Client , v_Cde_Client_Zeile_1/2,
--      v_Adressfeld_Rechts_Zeile_1, [v_Bezeichnung_Zeile, v_Kunden_Auftrag, v_Spezifikation_Zeile], v_Lhm_Menge

    CURSOR c_fa is
      select fa.ab_soll_mg, fa.kunden_nr, fa.kunden_nr_adr_liefer, fa.kd_art_nr,
             fa.ag_text1, fa.ag_text2, fa.ag_text3, fa.best_nr_kunde, fa.ab_text1, fa.abnr,
             isi_utils.get_csv_value(fa.prod_params, 'STK_LISTE_TXT'), fa.lhm_menge, fa.lte_lhm_lagen,
             fa.ag_soll_mg, fa.ag_ist_mg
        from bde_fa_auftrag fa
      where fa.sid = v_sid.sid
        and fa.firma_nr = v_firma_nr
        and fa.leitzahl = v_leitzahl
        and fa.satzart = 'V'             -- verrichten = produzieren
     group by fa.leitzahl, fa.ab_soll_mg, fa.kunden_nr, fa.kunden_nr_adr_liefer, fa.kd_art_nr,
              fa.ag_text1, fa.ag_text2, fa.ag_text3, fa.best_nr_kunde, fa.ab_text1, fa.abnr,
             isi_utils.get_csv_value(fa.prod_params, 'STK_LISTE_TXT'), fa.lhm_menge, fa.lte_lhm_lagen,
             fa.ag_soll_mg, fa.ag_ist_mg;

-- in:  v_sid, v_firma_nr, v_adr_liefer, v_kunden_nr
-- out: v_Adressfeld_Links_Zeile(1) - v_Adressfeld_Links_Zeile(6)


--   v_Adressfeld_Links_Zeile_1  varchar2(255);  -- ISI_ADRESSEN.NAME_1 (Lieferanschrift)  >>> NAME1
--   v_Adressfeld_Links_Zeile_2  varchar2(255);  -- ISI_ADRESSEN.NAME_2 (Lieferanschrift)  >>> NAME2
--   v_Adressfeld_Links_Zeile_3  varchar2(255);  -- ISI_ADRESSEN.NAME_3 (Lieferanschrift)  >>> NAME3
--   v_Adressfeld_Links_Zeile_4  varchar2(255);  -- ISI_ADRESSEN.STRASSE(Lieferanschrift)  >>> STRASSE
--   v_Adressfeld_Links_Zeile_5  varchar2(255);  -- ISI_ADRESSEN...     (Lieferanschrift)  >>> Zeile 5 bleibt leer!
--   v_Adressfeld_Links_Zeile_6  varchar2(255);  -- ISI_ADRESSEN...     (Lieferanschrift)  >>> LAND_KURZ + PLZ + ORT

    CURSOR c_lieferanschrift is
      select
        NVL(SubStr(adr.name_1,1,27), ''),
        NVL(SubStr(adr.name_2,1,27), ''),
        NVL(SubStr(adr.name_3,1,27), ''),
        NVL(SubStr(adr.strasse,1,27),''),
        SubStr(NVL(adr.land_kurz, '') || '-' || NVL(adr.plz, '') || ' ' || NVL(adr.ort, ''),1,27),
        NVL(SubStr(adr.lhm_etiketten_layout,1,4), '0000') --  ACHTUNG, noch default 0000 eintragen
        from isi_adressen adr, bde_fa_auftrag fa
       where adr.sid = v_sid.sid
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
    v_Ident                     := NULL;
    v_Anzahl_pro_Karton         := NULL;
    v_Gesamt                    := NULL;
    v_Packdatum                 := NULL;
    v_Kartonnummer              := NULL;
    v_Karton_ID                 := NULL;
    v_Nummer                    := NULL;
    v_Nummer_rechts             := NULL;
    v_Artikelnummer             := NULL;
    v_Daten_Code_Id_170         := NULL;
    v_Kommission_Lot            := NULL;
    v_Cde_Client_Zeile_1        := NULL;
    v_Cde_Client_Zeile_2        := NULL;
    v_Reference_Client          := NULL;
    v_Nummer_unten              := NULL;
    v_Adressfeld_Links_Zeile_1  := NULL;
    v_Adressfeld_Links_Zeile_2  := NULL;
    v_Adressfeld_Links_Zeile_3  := NULL;
    v_Adressfeld_Links_Zeile_4  := NULL;
    v_Adressfeld_Links_Zeile_5  := NULL;
    v_Adressfeld_Links_Zeile_6  := NULL;
    v_Adressfeld_Rechts_Zeile_1 := NULL;
    v_Adressfeld_Rechts_Zeile_2 := NULL;
    v_Adressfeld_Rechts_Zeile_3 := NULL;
    v_Adressfeld_Rechts_Zeile_4 := NULL;
    v_Adressfeld_Rechts_Zeile_5 := NULL;
    v_Adressfeld_Rechts_Zeile_6 := NULL;
    v_Barcode_ID_100            := NULL;
    v_Barcode_ID_110_FIFO       := NULL;
    v_Barcode_ID_120_PART       := NULL;
    v_Barcode_ID_130_QTY        := NULL;
    v_Barcode_ID_140_LOT        := NULL;
    v_Barcode_ID_150_CARTON     := NULL;
    v_Barcode_ID_PL_MENDEN      := NULL;
    v_Barcode_ID_00_MENDEN      := NULL;
    v_Text_FIFO                 := NULL;
    v_Text_PART                 := NULL;
    v_Text_QTY                  := NULL;
    v_Text_LOT                  := NULL;
    v_Text_CARTON               := NULL;
    v_Logo_1                    := NULL;
    v_Logo_2                    := NULL;
    v_Logo_3                    := NULL;
    v_Logo_4                    := NULL;
    v_Logo_5                    := NULL;
    v_Logo_6                    := NULL;
    v_Kunden_Auftrag            := NULL;
    v_Maschine                  := NULL;
    v_Bez_Spez_Zeile            := NULL;

    FOR c_count in 1 .. 20
    LOOP
      v_Bezeichnung_Zeile(c_count) := NULL;
      v_Spezifikation_Zeile(c_count) := NULL;
    END LOOP;

    v_Drucken                   := '1';  -- immer drucken!

    OPEN c_sid;
    FETCH c_sid into v_sid;
    CLOSE c_sid;

    v_firma_nr                  := in_firma_nr;
    v_Karton_ID                 := in_id;
    v_ID                        := in_id;

    OPEN c_lhm_lam_art_charge;
    FETCH c_lhm_lam_art_charge into v_Anzahl_pro_Karton,                      -- lam.menge
                                    v_Ident,                                  -- SubStr(art.artikel,1,8)
                                    v_Kommission_Lot,                         -- SubStr(c.charge_bez,1,10)
                                    v_Artikelnummer,                          -- lam.kd_art_nr
                                    v_leitzahl,                               -- lam.leitzahl
                                    v_Packdatum,                              -- lam.prod_datum
                                    v_Kartonnummer,                           -- NVL(lam.lhm_lfd_nr, 0)
                                    v_Maschine,                               -- SubStr(res.res_ext_name, 1,10)
                                    v_qs_status;                              -- Z oder ZM sind Zuordnungsfehler -> Leeres Etikett

    v_found := c_lhm_lam_art_charge%FOUND;
    CLOSE c_lhm_lam_art_charge;

    if not v_found then
      v_err_text := ' Karton nicht gefunden: ' || v_Karton_ID;
      v_err_nr := 51;
      raise v_error;
    end if;

    if v_qs_status = 'ZM'
    or v_qs_status = 'Z'
    then
      v_id := NULL;
      v_Karton_ID := NULL;
      v_Layout_Nr := C_LAYOUT_NR_VORMONTAGE;
      v_Bezeichnung_Zeile(1) := 'GESPERRT (Zuordnung prüfen)';
      v_Basis_Layout := C_BASIS_LAYOUT_VORMONTAGE;

    else
      -- in:  v_sid, v_firma_nr, v_leitzahl
      -- out: v_Gesamt, v_kunden_nr, v_adr_liefer, v_Nummer, v_reference_client,
      --      v_Cde_Client_Zeile_1/2, v_Adressfeld_Rechts_Zeile_1 (Bestellnr Kund),
      --      v_Kunden_Auftrag, [v_Bezeichnung_Zeile, v_Spezifikation_Zeile], v_Lhm_Menge

      OPEN c_fa;
      FETCH c_fa into
          v_Gesamt,                                      -- fa.ab_soll_mg
          v_kunden_nr,                                   -- fa.kunden_nr
          v_adr_liefer,                                  -- fa.kunden_nr_adr_liefer
          v_Nummer,                                      -- fa.kd_art_nr
          v_reference_client,                            -- fa.ag_text1
          v_Cde_Client_Zeile_1,                          -- fa.ag_text2
          v_Cde_Client_Zeile_2,                          -- fa.ag_text3
          v_Adressfeld_Rechts_Zeile_5,                   -- fa.best_nr_kunde
          v_Adressfeld_Rechts_Zeile_6,                   -- fa.ab_text1
          v_Kunden_Auftrag,                              -- fa.abnr
          v_Bez_Spez_Zeile,                              -- isi_utils.get_csv_value(fa.prod_params, 'STK_LISTE_TXT')
          v_Lhm_Menge,                                   -- fa.lhm_menge
          v_lte_lhm_lagen,                               -- fa.lte_lhm_lagen
          v_fa_soll,                                     -- fa.ag_soll_mg
          v_fa_ist;                                      -- fa.ag_ist_mg


      v_found := c_fa%FOUND;
      CLOSE c_fa;

      if not v_found then
        v_err_text := ' FA nicht gefunden: ' || v_leitzahl;
        v_err_nr := 52;
        raise v_error;
      end if;

      -- Lieferanschrift:
      -- in:  v_sid, v_firma_nr, v_adr_liefer, v_kunden_nr
      -- out: v_Adressfeld_Links_Zeile(1) - v_Adressfeld_Links_Zeile(6), v_layout_nr


      OPEN c_lieferanschrift;
      FETCH c_lieferanschrift into
         v_Adressfeld_Links_Zeile_1,
         v_Adressfeld_Links_Zeile_2,
         v_Adressfeld_Links_Zeile_3,
         v_Adressfeld_Links_Zeile_4,
         -- _Adressfeld_Links_Zeile_5,   -- bleibt immer leer
         v_Adressfeld_Links_Zeile_6,     -- LAND_KURZ + PLZ + ORT
         v_Layout_Nr;

      v_found := c_lieferanschrift%FOUND;
      CLOSE c_lieferanschrift;
      if not v_found then
         v_err_text := ' Lieferadresse nicht gefunden: KundenNr=' || v_kunden_nr ||
                       ' LieferantenNr=' || v_adr_liefer;
        -- v_err_nr := 53;
        -- raise v_error;
      end if;


      -- für interne Aufträge (Kunde ist Seaquist selbst) wird ein Vormontage-Label gedruckt:
      if v_kunden_nr = '1' then
        v_Layout_Nr := C_LAYOUT_NR_VORMONTAGE;
      end if;

      -- TEST TEST TEST:
      -- v_Layout_Nr := C_LAYOUT_NR_VORMONTAGE;
      -- .llf Dateien festlegen:
      if v_Layout_Nr = C_LAYOUT_NR_VORMONTAGE then
        if v_sid.sid_schnittstelle != 'SQD_SAP'
        then
          v_Basis_Layout := C_BASIS_LAYOUT_VORMONTAGE;
        else
          v_Basis_Layout := C_BASIS_LAYOUT_VORMONTAGE_SAP;
        end if;
      else
        if v_sid.sid_schnittstelle != 'SQD_SAP'
        then
          v_Basis_Layout := C_BASIS_LAYOUT_VERSAND;
        else
          v_Kunden_Auftrag := lpad(v_Kunden_Auftrag, 16, '0');
          if trim(v_Layout_Nr) = '0201' -- sqdf
          then
            v_Basis_Layout := C_BASIS_LAYOUT_VERSAND_SAP201;
          elsif trim(v_Layout_Nr) in ('1001', '1101', '1201') -- sqdf
          then
            v_Basis_Layout := C_BASIS_LAYOUT_VERSAND_SAPBOM;
          else
            v_Basis_Layout := C_BASIS_LAYOUT_VERSAND_SAP;
          end if;
        end if;
      end if;

     -- Barcode_ID_100 = Ident-Nr(7) ChargeBez(10)+Packdatum(6:ddmmyy)+Stkzahl im Karton+'D'
      if v_sid.sid_schnittstelle != 'SQD_SAP'
      then
        v_Barcode_ID_100            := RPAD(v_Ident, 7, ' ');  -- interne Artikelnummer(8)
        v_Barcode_ID_100            := v_Barcode_ID_100 || RPAD(v_Kommission_Lot, 10, ' ');  -- ChargeBez(10)
        v_Barcode_ID_100            := v_Barcode_ID_100 || to_char(v_Packdatum, 'DDMMYY');  -- Packdatum(6)
        v_Barcode_ID_100            := v_Barcode_ID_100 || LPAD(v_Anzahl_pro_Karton, 10, '0'); -- Stkzahl im Karton(10)
        v_Barcode_ID_100            := v_Barcode_ID_100 || 'D';
      else
        v_Barcode_ID_100            := '99' || '000000';                             -- Bezeichner unf FIX 000000
        v_Barcode_ID_100            := v_Barcode_ID_100 || '1121';                   -- Plaint für Dortmund ist 1121
        v_Barcode_ID_100            := v_Barcode_ID_100 || '02' || LPAD(nvl(substr(in_id, length(in_id) - 7, 8), '0'), 8, '0');  -- ID (Nur Nummer)
        v_Barcode_ID_100            := v_Barcode_ID_100 || LPAD(nvl(v_Kartonnummer, '0'), 4, '0');  -- Kartonnummer
        v_Barcode_ID_100            := v_Barcode_ID_100 || LPAD(v_Ident, 10, '0');   -- interne Artikelnummer(10)
        v_Barcode_ID_100            := v_Barcode_ID_100 || LPAD(v_Kommission_Lot, 10, '0');  -- ChargeBez(10)
        v_Barcode_ID_100            := v_Barcode_ID_100 || LPAD(v_Anzahl_pro_Karton, 8, '0'); -- Stkzahl im Karton(10)

        if trim(v_Layout_Nr) =  '0201' -- französisch
        then
          v_Daten_Code_Id_170            := RPAD(v_Reference_Client, 7, ' ');  -- interne alte Artikelnummer(8) (in kundenartukelnummer)
          v_Daten_Code_Id_170            := v_Daten_Code_Id_170 || RPAD(v_Kommission_Lot, 10, ' ');  -- ChargeBez(10)
          v_Daten_Code_Id_170            := v_Daten_Code_Id_170 || to_char(v_Packdatum, 'DDMMYY');  -- Packdatum(6)
          v_Daten_Code_Id_170            := v_Daten_Code_Id_170 || LPAD(v_Anzahl_pro_Karton, 10, '0'); -- Stkzahl im Karton(10)
          v_Daten_Code_Id_170            := v_Daten_Code_Id_170 || 'D';
        end if;

        if length(in_id) = 15
        then
          v_nve := '740485532' || substr(in_id, 8, 8);
          v_nve := lvs_p_lte_lhm.lvs_lte_lhm_pruefziffer_mod10(v_nve);
        end if;
        v_Karton_ID := '00' || v_nve;
      end if;
      if v_sid.sid_schnittstelle != 'SQD_SAP'
      then
        v_M_Auftrag                    := 'M' || v_Leitzahl;
      else
        v_M_Auftrag                    := lpad(v_Leitzahl, 10, '0');
      end if;

      if v_Anzahl_pro_Karton < v_Lhm_Menge                 -- Restmengenkarton dann immer letzter Karton
      or v_fa_soll <= v_fa_ist + v_Anzahl_pro_Karton       -- Auftrag ist fertig
      then
        v_lte_lhm_lagen := 9;
      end if;

      v_Barcode_ID_PL_MENDEN      := 'PL' || rpad(v_Maschine, 10, ' ') || rpad(v_Kommission_Lot, 10, ' ') || to_char(v_lte_lhm_lagen);
      v_Barcode_ID_00_MENDEN      := '00' || substr(v_nve, 9, 9) || v_M_Auftrag || lpad(v_Anzahl_pro_Karton, 8, '0');

      v_Adressfeld_Rechts_Zeile_1    := SubStr(v_Cde_Client_Zeile_1, 1, 27);
      v_Adressfeld_Rechts_Zeile_2    := SubStr(v_Cde_Client_Zeile_2, 1, 27);
      v_Adressfeld_Rechts_Zeile_3    := v_Artikelnummer;
      v_Adressfeld_Rechts_Zeile_4    := SubStr(v_Reference_Client, 1, 27);
      -- v_Adressfeld_Rechts_Zeile_5    := v_Adressfeld_Rechts_Zeile_1; -- Bestellnr Kunde
      -- v_Adressfeld_Rechts_Zeile_6    := '';  -- ist immer leer, bis auf 'Made in Germany' (im Layout enthalten)

      -- v_Bez_Spez_Zeile := 'aaa@bbb@ccc@ddddd@eee';  -- TEST
      c_count := 1;
      pos     := 1;
      WHILE c_count <= 20 AND pos > 0
      LOOP
        pos := InStr(v_Bez_Spez_Zeile, '@');
        if pos > 0 then
          v_Bezeichnung_Zeile(c_count) := SubStr(v_Bez_Spez_Zeile, 1, pos-1);
          v_Bez_Spez_Zeile := SubStr(v_Bez_Spez_Zeile, pos+1, Length(v_Bez_Spez_Zeile));
          v_Bezeichnung_Zeile(c_count) := SubStr(v_Bezeichnung_Zeile(c_count), 1, 20);  -- auf 20 Zeichen kürzen
        else
          v_Bezeichnung_Zeile(c_count) := v_Bez_Spez_Zeile;  -- Dies ist der Rest, wenn hinten kein @ steht
        end if;

        if pos > 0 then
        begin
          pos := InStr(v_Bez_Spez_Zeile, '@');
          if pos > 0 then
            v_Spezifikation_Zeile(c_count) := SubStr(v_Bez_Spez_Zeile, 1, pos-1);
            v_Bez_Spez_Zeile := SubStr(v_Bez_Spez_Zeile, pos+1, Length(v_Bez_Spez_Zeile));
            v_Spezifikation_Zeile(c_count) := SubStr(v_Spezifikation_Zeile(c_count), 1, 34);  -- auf 30 Zeichen kürzen
          else
            v_Spezifikation_Zeile(c_count) := v_Bez_Spez_Zeile;  -- Dies ist der Rest, wenn hinten kein @ steht
          end if;
        end;
       end if;
       c_count := c_count + 1;
     END LOOP;


     -- vom Layout abhängige Felder belegen:

      if v_sid.sid_schnittstelle != 'SQD_SAP'
      then
        v_Adressfeld_Rechts_Zeile_6    := '';  -- ist immer leer, bis auf 'Made in Germany' (im Layout enthalten)

        CASE trim(v_Layout_Nr)

        WHEN '0201' -- französisch
          THEN
            v_Adressfeld_Rechts_Zeile_1 := '';
            v_Adressfeld_Rechts_Zeile_2 := '';
            v_Adressfeld_Rechts_Zeile_3 := v_Nummer; -- Kunden-Artikelnummer
            v_Adressfeld_Rechts_Zeile_4 := '';
            -- v_Adressfeld_Rechts_Zeile_5 := '';   -- hier: BestellNr Kunde
            v_Adressfeld_Rechts_Zeile_6 := '';

            v_Nummer_rechts      := '';
            v_Artikelnummer      := '';
            v_Daten_Code_Id_170  := '';
            -- v_Cde_Client_Zeile_1 aufteilen:
            -- v_Cde_Client_Zeile_1  -- wird nur hier gebraucht
            -- v_Cde_Client_Zeile_2  -- wird nur hier gebraucht

            -- v_Reference_Client   := 'RefClient';-- DUMMYY -- wird nur hier gebraucht
            v_Nummer_unten       := '';
            v_Logo_1             := 'Ladder_1201';
            v_Logo_2             := 'adr_0201';
            v_Logo_3             := 'LOT_1201';
            v_Logo_4             := 'foot_0201';
            v_Logo_5             := 'table_1201';
            v_logo_6             := 'FRANCE';  -- nur hier

        WHEN '1001' -- deutsch
          THEN
            v_Nummer_rechts      := '';
            v_Artikelnummer      := '';
            v_Daten_Code_Id_170  := '';
            v_Cde_Client_Zeile_1 := '';
            v_Cde_Client_Zeile_2 := '';
            v_Reference_Client   := '';
            v_Nummer_unten       := v_Nummer;
            v_Adressfeld_Rechts_Zeile_5 := '';
            v_Logo_1             := 'Ladder_1001';
            v_Logo_2             := 'adr_1001';
            v_Logo_3             := 'LOT_1001';
            v_Logo_4             := 'foot_1001';
            v_Logo_5             := 'table_1001';
            --v_logo_6             := 'nologo';
            v_logo_6             := '1' || lpad(v_Nummer, 17, '0');

        WHEN '1002'  -- deutsch
          THEN
            v_Nummer_rechts      := '';
            -- 18-stellig, mit 1 beginnend und mit 0-en auffüllen:
            v_Daten_Code_Id_170  := '1' || LPAD(v_Artikelnummer, 17, '0' ); -- wird nur hier gebraucht
            v_Artikelnummer      := '';
            v_Cde_Client_Zeile_1 := '';
            v_Cde_Client_Zeile_2 := '';
            v_Reference_Client   := '';
            v_Nummer_unten       := '';
            v_Adressfeld_Rechts_Zeile_5 := '';
            v_Logo_1             := 'Ladder_1001';
            v_Logo_2             := 'adr_1001';
            v_Logo_3             := 'LOT_1001';
            v_Logo_4             := 'foot_1001';
            v_Logo_5             := 'table_1001';
            --v_logo_6             := 'nologo';
            v_logo_6             := '1' || lpad(v_Nummer, 17, '0');

        WHEN '1003'  -- deutsch
          THEN
            v_Nummer_rechts      := '';
            v_Artikelnummer      := '';
            v_Daten_Code_Id_170  := '';
            v_Cde_Client_Zeile_1 := '';
            v_Cde_Client_Zeile_2 := '';
            v_Reference_Client   := '';
            v_Nummer_unten       := v_Nummer;
            v_Adressfeld_Rechts_Zeile_5 := '';
            v_Logo_1             := 'Ladder_1001';
            v_Logo_2             := 'adr_1001';
            v_Logo_3             := 'LOT_1001';
            v_Logo_4             := 'foot_1001';
            v_Logo_5             := 'table_1001';
            --v_logo_6             := 'nologo';
            v_logo_6             := '1' || lpad(v_Nummer, 17, '0');

        WHEN '1004'  -- deutsch
          THEN
            v_Adressfeld_Rechts_Zeile_1 := '';
            v_Adressfeld_Rechts_Zeile_2 := '';
            v_Adressfeld_Rechts_Zeile_3 := '';
            v_Adressfeld_Rechts_Zeile_4 := '';
            v_Adressfeld_Rechts_Zeile_5 := '';
            v_Adressfeld_Rechts_Zeile_6 := '';
            v_Nummer_rechts      := '';
            -- v_Artikelnummer  -- v_Artikelummer wird nur hier gebraucht
            v_Daten_Code_Id_170  := '';
            v_Cde_Client_Zeile_1 := '';
            v_Cde_Client_Zeile_2 := '';
            v_Reference_Client   := '';
            v_Nummer_unten       := v_Nummer;
            v_Logo_1             := 'Ladder_1001';
            v_Logo_2             := 'adr_1001';
            v_Logo_3             := 'LOT_1001';
            v_Logo_4             := 'foot_1001';
            v_Logo_5             := 'table_1001';
            --v_logo_6             := 'nologo';
            v_logo_6             := '1' || lpad(v_Nummer, 17, '0');

        WHEN '1101' -- englisch
          THEN
            v_Nummer_rechts      := '';
            v_Artikelnummer      := '';
            v_Daten_Code_Id_170  := '';
            v_Cde_Client_Zeile_1 := '';
            v_Cde_Client_Zeile_2 := '';
            v_Reference_Client   := '';
            v_Reference_Client   := '';
            v_Nummer_unten       := v_Nummer;
            v_Adressfeld_Rechts_Zeile_5 := '';
            v_Logo_1             := 'Ladder_1102';
            v_Logo_2             := 'adr_1101';
            v_Logo_3             := 'LOT_1101';
            v_Logo_4             := 'foot_1001';
            v_Logo_5             := 'table_1201';
            --v_logo_6             := 'nologo';
            v_logo_6             := '1' || lpad(v_Nummer, 17, '0');

        WHEN '1102' -- englisch + Made in Germany + Barcodes
          THEN
            v_Nummer_rechts      := '';
            v_Artikelnummer      := '';
            v_Daten_Code_Id_170  := '';
            v_Cde_Client_Zeile_1 := '';
            v_Cde_Client_Zeile_2 := '';
            v_Reference_Client   := '';
            v_Nummer_unten       := v_Nummer;
            v_Adressfeld_Rechts_Zeile_5 := '';
            v_Logo_1             := 'Ladder_1102';
            v_Logo_2             := 'adr_1102';
            v_Logo_3             := 'LOT_1101';
            v_logo_4             := 'nologo';
            v_logo_5             := 'nologo';
            --v_logo_6             := 'nologo';
            v_logo_6             := '1' || lpad(v_Nummer, 17, '0');
            v_Barcode_ID_110_FIFO       := to_char(v_Packdatum, 'YYYYMM');
            v_Barcode_ID_120_PART       := translate(v_Nummer, '#', '-');
            v_Barcode_ID_130_QTY        := v_Anzahl_pro_Karton;
            -- QY + SubStr(v_Kommission_Lot,3,8), also hier nur 8 Zeichen lang
            -- Aenderungswusch M.Schütz tel. 17.02.2010
            -- v_Barcode_ID_140_LOT        := 'QY' || SubStr(v_Kommission_Lot,3,8);
            v_Barcode_ID_140_LOT        := SubStr(v_Kommission_Lot,3,8);
            v_Barcode_ID_150_CARTON     := v_Kartonnummer;
            v_Text_FIFO                 := 'FIFO:';
            v_Text_PART                 := 'PART #';
            v_Text_QTY                  := 'QTY:';
            v_Text_LOT                  := 'LOT TRACE #';
            v_Text_CARTON               := 'CARTON #';
            FOR c_count in 1 .. 20
            LOOP
              v_Bezeichnung_Zeile(c_count) := NULL;   -- nur hier nicht
              v_Spezifikation_Zeile(c_count) := NULL; -- nur hier nicht
            END LOOP;

        WHEN '1201' -- französisch
          THEN
            v_Nummer_rechts      := '';
            v_Artikelnummer      := '';
            v_Daten_Code_Id_170  := '';
            v_Cde_Client_Zeile_1 := '';
            v_Cde_Client_Zeile_2 := '';
            v_Reference_Client   := '';
            v_Nummer_unten       := v_Nummer;
            v_Adressfeld_Rechts_Zeile_5 := '';
            v_Logo_1             := 'Ladder_1201';
            v_Logo_2             := 'adr_1201';
            v_Logo_3             := 'LOT_1201';
            v_Logo_4             := 'foot_1001';
            v_Logo_5             := 'table_1201';
            v_logo_6             := 'nologo';

        WHEN C_LAYOUT_NR_VORMONTAGE -- Vormontage-Label
          THEN
            v_Nummer_rechts      := '';
            v_Artikelnummer      := '';
            v_Daten_Code_Id_170  := '';
            v_Cde_Client_Zeile_1 := '';
            v_Cde_Client_Zeile_2 := '';
            v_Reference_Client   := '';
            v_Nummer_unten       := '';
            v_Logo_1             := '';
            v_Logo_2             := '';
            v_Logo_3             := '';
            v_Logo_4             := '';
            v_Logo_5             := '';
            v_logo_6             := '';
            v_Adressfeld_Rechts_Zeile_1 := '';
            v_Adressfeld_Rechts_Zeile_2 := '';
            v_Adressfeld_Rechts_Zeile_3 := '';
            v_Adressfeld_Rechts_Zeile_4 := '';
            v_Adressfeld_Rechts_Zeile_5 := '';
            v_Adressfeld_Rechts_Zeile_6 := '';
            v_Barcode_ID_110_FIFO       := '';
            v_Barcode_ID_120_PART       := '';
            v_Barcode_ID_130_QTY        := '';
            v_Barcode_ID_140_LOT        := '';
            v_Barcode_ID_150_CARTON     := '';
            v_Text_FIFO                 := '';
            v_Text_PART                 := '';
            v_Text_QTY                  := '';
            v_Text_LOT                  := '';
            v_Text_CARTON               := '';
            FOR c_count in 1 .. 20
            LOOP
              v_Bezeichnung_Zeile(c_count) := NULL;
              v_Spezifikation_Zeile(c_count) := NULL;
            END LOOP;

            if v_Anzahl_pro_Karton < v_Lhm_Menge then
              v_Bezeichnung_Zeile(1) := 'RESTKARTON';
            else
              v_Bezeichnung_Zeile(1) := 'STANDARDKARTON';
            end if;
          ELSE
          v_err_text := ' Ungültige Layout-Nummer ' || v_Layout_Nr;
          v_err_nr := 50;
          raise v_error;

        END CASE;
      else
        if trim(v_Layout_Nr) = C_LAYOUT_NR_VORMONTAGE -- Vormontage-Label
        then
          v_Nummer_rechts      := '';
          v_Artikelnummer      := '';
          v_Daten_Code_Id_170  := '';
          v_Cde_Client_Zeile_1 := '';
          v_Cde_Client_Zeile_2 := '';
          v_Reference_Client   := '';
          v_Nummer_unten       := '';
          v_Logo_1             := '';
          v_Logo_2             := '';
          v_Logo_3             := '';
          v_Logo_4             := '';
          v_Logo_5             := '';
          v_logo_6             := '';
          v_Adressfeld_Rechts_Zeile_1 := '';
          v_Adressfeld_Rechts_Zeile_2 := '';
          v_Adressfeld_Rechts_Zeile_3 := '';
          v_Adressfeld_Rechts_Zeile_4 := '';
          v_Adressfeld_Rechts_Zeile_5 := '';
          -- v_Adressfeld_Rechts_Zeile_6 := ''; -AG- 23.12.2010 Wird jetzt benötigt
          v_Barcode_ID_110_FIFO       := '';
          v_Barcode_ID_120_PART       := '';
          v_Barcode_ID_130_QTY        := '';
          v_Barcode_ID_140_LOT        := '';
          v_Barcode_ID_150_CARTON     := '';
          v_Text_FIFO                 := '';
          v_Text_PART                 := '';
          v_Text_QTY                  := '';
          v_Text_LOT                  := '';
          v_Text_CARTON               := '';
          FOR c_count in 1 .. 20
          LOOP
            v_Bezeichnung_Zeile(c_count) := NULL;
            v_Spezifikation_Zeile(c_count) := NULL;
          END LOOP;

          if v_Anzahl_pro_Karton < v_Lhm_Menge then
            v_Bezeichnung_Zeile(1) := 'RESTKARTON';
          else
            v_Bezeichnung_Zeile(1) := 'STANDARDKARTON';
          end if;
        else

          v_Barcode_ID_110_FIFO       := to_char(v_Packdatum, 'YYYYMM');
          v_Barcode_ID_120_PART       := translate(v_Nummer, '#', '-'); --v_Nummer;
          v_Barcode_ID_130_QTY        := v_Anzahl_pro_Karton;
          -- QY + SubStr(v_Kommission_Lot,3,8), also hier nur 8 Zeichen lang
          -- Aenderungswusch M.Schütz tel. 17.02.2010
          -- v_Barcode_ID_140_LOT        := 'QY' || SubStr(v_Kommission_Lot,3,8);
          v_Barcode_ID_140_LOT        := SubStr(v_Kommission_Lot,3,8);
          v_Barcode_ID_150_CARTON     := v_Kartonnummer;
          v_Text_FIFO                 := 'FIFO:';
          v_Text_PART                 := 'PART #';
          v_Text_QTY                  := 'QTY:';
          v_Text_LOT                  := 'LOT TRACE #';
          v_Text_CARTON               := 'CARTON #';

          if trim(v_Layout_Nr) != '0201'   -- Frances
          then
            v_Daten_Code_Id_170  := '';
            v_Cde_Client_Zeile_1 := '';
            v_Cde_Client_Zeile_2 := '';
            v_Reference_Client   := '';

          end if;

          if trim(v_Layout_Nr) not in ('1002', '1003', '1004', '1102')   -- BOM
          then
            v_Barcode_ID_110_FIFO       := '';
            v_Barcode_ID_120_PART       := '';
            v_Barcode_ID_130_QTY        := '';
            v_Barcode_ID_140_LOT        := '';
            v_Barcode_ID_150_CARTON     := '';
            v_Text_FIFO                 := '';
            v_Text_PART                 := '';
            v_Text_QTY                  := '';
            v_Text_LOT                  := '';
            v_Text_CARTON               := '';

          end if;

          v_Nummer_rechts      := '';
          v_Artikelnummer      := '';
          v_Nummer_unten       := v_Nummer;
          -- -AG- Erweiterung PRJ 5315
          if trim(v_Layout_Nr) not in ('0201', -- sqdf
                                       '1001', '1101', '1201') -- BOM
          then -- CODE39 nur als Barcode im LABEL sqd_std
            v_Nummer_unten       :=  upper(v_Nummer);
            v_code39 := isi_allg.c_get_firma_cfg_param(in_sid,
                                                       in_firma_nr,
                                                       'CFG',                -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                        NULL,                -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                       'CODE39_VALUES',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                       'ALL',                -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                       'CFG',                -- in_typ                   in isi_firma_cfg.typ%type,
                                                                             -- Erlaubte Zeichen im COD39
                                                       'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.-*$/+%#',
                                                                              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                       'STRING');             -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
            if v_Nummer_unten is not NULL
            then
              i := 1;
              LOOP
                EXIT WHEN i > length (v_Nummer_unten);
                if substr(v_Nummer_unten, i, 1) = '#' -- Sonderbehandlung '#' für Seaquist
                then
                  v_Nummer_unten := substr(v_Nummer_unten, 1, i-1) || '-' || substr(v_Nummer_unten, i +1);
                end if;
                if INSTRC(v_code39 , substr(v_Nummer_unten, i, 1), 1, 1) = 0
                then
                  v_Nummer_unten := substr(v_Nummer_unten, 1, i-1) || 'Z' || substr(v_Nummer_unten, i +1);
                end if;
                i := i + 1;
              end LOOP;
            end if;
          end if;
          --v_Adressfeld_Rechts_Zeile_5 := '';
          v_Logo_1             := '';
          v_Logo_2             := '';
          v_Logo_3             := '';
          v_Logo_4             := '';
          v_Logo_5             := '';
          --v_logo_6             := 'nologo';
          v_logo_6             := '1' || lpad(v_Nummer, 17, '0');
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
      if v_sid.sid_schnittstelle != 'SQD_SAP'
      then
        v_Packdatum_string := to_char(v_Packdatum, 'DD.MM.YYYY');
        v_Packdatum_klein := to_char(v_Packdatum, 'DD.MM.YYYY');
      else
        v_Packdatum_string := to_char(v_Packdatum, 'YYYY-MM-DD HH24:mi');
        v_Packdatum_klein := to_char(v_Packdatum, 'YYYY-MM-DD');
      end if;
    end if;

     v_print_daten :=

    'Layout_Nr='                    || v_Layout_Nr || CHR(13) || CHR(10) ||
    'Basis_Layout='                 || v_Basis_Layout || CHR(13) || CHR(10) ||
    'Ident='                        || v_Ident || CHR(13) || CHR(10) ||
    'Anzahl_pro_Karton='            || v_Anzahl_pro_Karton || CHR(13) || CHR(10) ||
    'Gesamt='                       || v_Gesamt || CHR(13) || CHR(10) ||
    'Packdatum='                    || v_Packdatum_klein || CHR(13) || CHR(10) ||
    'Kartonnummer='                 || v_Kartonnummer || CHR(13) || CHR(10) ||
    'Karton_ID='                    || v_Karton_ID|| CHR(13) || CHR(10) ||
    'Nummer_rechts='                || v_Nummer_rechts || CHR(13) || CHR(10) ||
    'Artikelnummer='                || v_Artikelnummer || CHR(13) || CHR(10) ||
    'Daten_Code_Id_170='            || v_Daten_Code_Id_170|| CHR(13) || CHR(10) ||
    'Kommission_Lot='               || v_Kommission_Lot || CHR(13) || CHR(10) ||
    'Cde_Client_Zeile_1='           || v_Cde_Client_Zeile_1 || CHR(13) || CHR(10) ||
    'Cde_Client_Zeile_2='           || v_Cde_Client_Zeile_2 || CHR(13) || CHR(10) ||
    'Reference_Client='             || v_Reference_Client || CHR(13) || CHR(10) ||
    'Packdatum_big='                || v_Packdatum_string || CHR(13) || CHR(10) ||
    'Nummer_unten='                 || v_Nummer_unten || CHR(13) || CHR(10) ||
    'Adressfeld_Links_Zeile_1='     || v_Adressfeld_Links_Zeile_1 || CHR(13) || CHR(10) ||
    'Adressfeld_Links_Zeile_2='     || v_Adressfeld_Links_Zeile_2 || CHR(13) || CHR(10) ||
    'Adressfeld_Links_Zeile_3='     || v_Adressfeld_Links_Zeile_3 || CHR(13) || CHR(10) ||
    'Adressfeld_Links_Zeile_4='     || v_Adressfeld_Links_Zeile_4 || CHR(13) || CHR(10) ||
    'Adressfeld_Links_Zeile_5='     || v_Adressfeld_Links_Zeile_5 || CHR(13) || CHR(10) ||
    'Adressfeld_Links_Zeile_6='     || v_Adressfeld_Links_Zeile_6 || CHR(13) || CHR(10) ||
    'Adressfeld_Rechts_Zeile_1='    || v_Adressfeld_Rechts_Zeile_1 || CHR(13) || CHR(10) ||
    'Adressfeld_Rechts_Zeile_2='    || v_Adressfeld_Rechts_Zeile_2 || CHR(13) || CHR(10) ||
    'Adressfeld_Rechts_Zeile_3='    || v_Adressfeld_Rechts_Zeile_3 || CHR(13) || CHR(10) ||
    'Adressfeld_Rechts_Zeile_4='    || v_Adressfeld_Rechts_Zeile_4 || CHR(13) || CHR(10) ||
    'Adressfeld_Rechts_Zeile_5='    || v_Adressfeld_Rechts_Zeile_5 || CHR(13) || CHR(10) ||
    'Adressfeld_Rechts_Zeile_6='    || v_Adressfeld_Rechts_Zeile_6 || CHR(13) || CHR(10) ||
    'Barcode_ID_100='               || v_Barcode_ID_100 || CHR(13) || CHR(10) ||
    'Barcode_ID_110_FIFO='          || v_Barcode_ID_110_FIFO || CHR(13) || CHR(10) ||
    'Barcode_ID_120_PART='          || v_Barcode_ID_120_PART || CHR(13) || CHR(10) ||
    'Barcode_ID_130_QTY='           || v_Barcode_ID_130_QTY || CHR(13) || CHR(10) ||
    'Barcode_ID_140_LOT='           || v_Barcode_ID_140_LOT || CHR(13) || CHR(10) ||
    'Barcode_ID_150_CARTON='        || v_Barcode_ID_150_CARTON || CHR(13) || CHR(10) ||

    -- if v_Layout_Nr = C_LAYOUT_NR_VORMONTAGE  -- Felder 46 - 49 nur beim Vormontage-Layout
    -- then
      'Fertigungsauftrag='            || v_Kunden_Auftrag || CHR(13) || CHR(10) ||
      'Karton_ID_Vormontage='         || v_id || CHR(13) || CHR(10) ||
      'M_Auftrag='                    || '95' || v_M_Auftrag || CHR(13) || CHR(10) ||
      'Maschine='                     || v_Maschine || CHR(13) || CHR(10) ||
    -- end;
    'Text_FIFO='                    || v_Text_FIFO || CHR(13) || CHR(10) ||
    'Text_PART='                    || v_Text_PART || CHR(13) || CHR(10) ||
    'Text_QTY='                     || v_Text_QTY || CHR(13) || CHR(10) ||
    'Text_LOT='                     || v_Text_LOT || CHR(13) || CHR(10) ||
    'Text_CARTON='                  || v_Text_CARTON || CHR(13) || CHR(10) ||
    'Logo_1='                       || v_Logo_1 || CHR(13) || CHR(10) ||
    'Logo_2='                       || v_Logo_2 || CHR(13) || CHR(10) ||
    'Logo_3='                       || v_Logo_3 || CHR(13) || CHR(10) ||
    'Logo_4='                       || v_Logo_4 || CHR(13) || CHR(10) ||
    'Logo_5='                       || v_Logo_5 || CHR(13) || CHR(10) ||
    'Logo_6='                       || v_Logo_6 || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_1='          || v_Bezeichnung_Zeile(1) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_1='        || v_Spezifikation_Zeile(1) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_2='          || v_Bezeichnung_Zeile(2) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_2='        || v_Spezifikation_Zeile(2) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_3='          || v_Bezeichnung_Zeile(3)|| CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_3='        || v_Spezifikation_Zeile(3) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_4='          || v_Bezeichnung_Zeile(4) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_4='        || v_Spezifikation_Zeile(4) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_5='          || v_Bezeichnung_Zeile(5) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_5='        || v_Spezifikation_Zeile(5) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_6='          || v_Bezeichnung_Zeile(6) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_6='        || v_Spezifikation_Zeile(6) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_7='          || v_Bezeichnung_Zeile(7) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_7='        || v_Spezifikation_Zeile(7) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_8='          || v_Bezeichnung_Zeile(8) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_8='        || v_Spezifikation_Zeile(8) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_9='          || v_Bezeichnung_Zeile(9) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_9='        || v_Spezifikation_Zeile(9) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_10='         || v_Bezeichnung_Zeile(10) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_10='       || v_Spezifikation_Zeile(10) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_11='         || v_Bezeichnung_Zeile(11) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_11='       || v_Spezifikation_Zeile(11) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_12='         || v_Bezeichnung_Zeile(12) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_12='       || v_Spezifikation_Zeile(12) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_13='         || v_Bezeichnung_Zeile(13) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_13='       || v_Spezifikation_Zeile(13) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_14='         || v_Bezeichnung_Zeile(14) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_14='       || v_Spezifikation_Zeile(14) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_15='         || v_Bezeichnung_Zeile(15) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_15='       || v_Spezifikation_Zeile(15) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_16='         || v_Bezeichnung_Zeile(16) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_16='       || v_Spezifikation_Zeile(16) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_17='         || v_Bezeichnung_Zeile(17) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_17='       || v_Spezifikation_Zeile(17) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_18='         || v_Bezeichnung_Zeile(18) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_18='       || v_Spezifikation_Zeile(18) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_19='         || v_Bezeichnung_Zeile(19) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_19='       || v_Spezifikation_Zeile(19) || CHR(13) || CHR(10) ||
    'Bezeichnung_Zeile_20='         || v_Bezeichnung_Zeile(20) || CHR(13) || CHR(10) ||
    'Spezifikation_Zeile_20='       || v_Spezifikation_Zeile(20) || CHR(13) || CHR(10) ||
    'Drucken='                      || v_Drucken|| CHR(13) || CHR(10) ||
    'Barcode_ID_PL_MENDEN='         || v_Barcode_ID_PL_MENDEN  || CHR(13) || CHR(10) ||
    'Barcode_ID_00_MENDEN='         || v_Barcode_ID_00_MENDEN  || CHR(13) || CHR(10);

   -- end if; -- if v_Layout_Nr ...

    return (v_print_daten);
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
    when v_error then
      RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text);
      raise;
    when others then
      if v_err_nr is not NULL then
         RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text, true);
      else
         raise;
      end if;
  end vda_etikett_vers_krt;

  function ccg_etikett_vers_lte(in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_id          in lvs_lhm.lhm_id%type)
                              return varchar2 is

    v_print_daten             varchar2(4096);

    v_charge_bez              varchar2(10);
    v_artikel                 isi_artikel.artikel%type;
    v_kunden_nr               isi_adressen.adr_nr%type;
    v_menge                   lvs_lam.menge%type;
    v_prod_date               varchar2(10);
    v_prod_date_bc1           varchar2(10);
    v_prod_date_bc2           varchar2(10);
    v_name_1                  varchar2(30);
    v_name_2                  varchar2(30);
    v_strasse                 varchar2(30);
    v_plz                     isi_adressen.plz%type;
    v_ort                     isi_adressen.ort%type;
    v_z_lgr_platz             lvs_lgr.lgr_platz%type;
    v_info_1                  isi_adressen.info_1%type;
    v_kd_art_nr               bde_fa_auftrag.kd_art_nr%type;
    v_kd_art_text             bde_fa_auftrag.ag_text1%type;

    v_ccg_barcode1_string       varchar2(100);  --BC1_TEXT
    v_ccg_barcode2_string       varchar2(100);  --BC2_TEXT
    v_ccg_barcode3_string       varchar2(100);  --BC3_TEXT

    v_ccg_barcode1              varchar2(100);  --BC1
    v_ccg_barcode2              varchar2(100);  --BC2
    v_ccg_barcode3              varchar2(100);  --BC2

  CURSOR c_get_eti_daten is
    select substr(c.charge_bez, 1, 10) charge_bez, art.artikel, fa.kunden_nr,
           sum(lam.menge) menge, to_char(max(lam.prod_datum), 'dd.mm.yyyy') prod_datum,
           to_char(max(lam.prod_datum), 'ddmmyy') prod_datum_bc1,
           to_char(max(lam.prod_datum), 'yymmdd') prod_datum_bc2,
           substr(adr.name_1, 1, 30) name_1, substr(adr.name_2, 1, 30) name_2,
           substr(adr.strasse, 1, 30) strasse, adr.plz, substr(adr.ort, 1, 30) ort, z.lgr_platz, adr.info_1,
           fa.kd_art_nr, fa.ag_text1
      from lvs_lam lam,
           lvs_charge c,
           isi_artikel art,
           isi_adressen adr,
           bde_fa_auftrag fa,
           sqd_land_trsp_ziel z,
           lvs_lgr lgr
     where lam.sid = in_sid
       and lam.firma_nr = in_firma_nr
       and c.sid(+) = lam.sid
       and c.charge_id(+)= lam.charge_id
       and art.artikel_id (+) = lam.artikel_id
       and fa.sid(+) = lam.sid
       and fa.firma_nr(+) = in_firma_nr
       and fa.leitzahl(+) = lam.leitzahl
       and fa.satzart(+) = 'V'
       and adr.adr_nr(+) = to_char(fa.kunden_nr)
       and adr.adr_liefer(+) = fa.kunden_nr_adr_liefer
       and adr.land_kurz = z.land_kurz(+)
       and lgr.lgr_ort(+) = z.lgr_ort
       and lgr.lgr_platz(+) = z.lgr_platz
       and lam.lte_id = in_id
     group by c.charge_bez, art.artikel, fa.kunden_nr,  lam.lte_id, fa.kd_art_nr, fa.ag_text1,
              adr.name_1, adr.name_2, adr.strasse, adr.plz, adr.ort, z.lgr_platz, adr.info_1;
  begin
    OPEN c_get_eti_daten;
    fetch c_get_eti_daten into v_charge_bez, v_artikel, v_kunden_nr, v_menge, v_prod_date,
                               v_prod_date_bc1, v_prod_date_bc2,
                               v_name_1, v_name_2 , v_strasse, v_plz, v_ort,  v_z_lgr_platz,
                               v_info_1, v_kd_art_nr, v_kd_art_text;
    CLOSE c_get_eti_daten;

    -- (93) Kundennummer
    v_ccg_barcode1            := '91' ||
                                 v_kd_art_nr || CHR(29) ||                   -- Kunden Artikelnummer
                                 '37' || v_menge;                            -- Menge
    v_ccg_barcode1_string     := '(91)' ||
                                 v_kd_art_nr ||                              -- Kunden Artikelnummer
                                 '(37)' || v_menge;                          -- Menge
    -- (37) Menge (11) Prod. Datum (10) Charge
    v_ccg_barcode2            := '10' || 'SEDO' || v_charge_bez || CHR(29) ||-- Charge
                                 '90' || 'E2';
    v_ccg_barcode2_string     := '(10)' || 'SEDO' || v_charge_bez ||         -- Charge
                                 '(90)' || 'E2';                             --
    -- (00) CCG
    v_ccg_barcode3            := '00' || in_id;                              -- CCG NVE
    v_ccg_barcode3_string     := '(00)' || in_id;                            -- CCG NVE

    v_print_daten :=
    'Charge='                       || v_charge_bez || CHR(13) || CHR(10) ||
    'Ident='                        || v_artikel || CHR(13) || CHR(10) ||
    'KundenNr='                     || v_kunden_nr || CHR(13) || CHR(10) ||
    'StkProPalette='                || to_char(v_menge) || CHR(13) || CHR(10) ||
    'ProdDatum='                    || v_prod_date || CHR(13) || CHR(10) ||
    'PalettenNr='                   || substr(in_id, 11, 7) || CHR(13) || CHR(10) || -- Bei seaquist die lfd-nr aus der NVE
    'Relation='                     || v_info_1 || CHR(13) || CHR(10) ||
    'Liefer_Adr_1='                 || v_name_1 || CHR(13) || CHR(10) ||
    'Liefer_Adr_2='                 || v_name_2 || CHR(13) || CHR(10) ||
    'Liefer_Adr_3='                 || v_plz || ' ' || v_ort || CHR(13) || CHR(10) ||
    'NVE='                          || in_id || CHR(13) || CHR(10) ||
    'KundenArtNr='                  || v_kd_art_nr || CHR(13) || CHR(10) ||
    'KundenArtText='                || v_kd_art_text || CHR(13) || CHR(10) ||
    'CCG_BARCODE1='                 || v_ccg_barcode1 || CHR(13) || CHR(10) ||
    'CCG_BARCODE1_STRING='          || v_ccg_barcode1_string || CHR(13) || CHR(10) ||
    'CCG_BARCODE2='                 || v_ccg_barcode2 || CHR(13) || CHR(10) ||
    'CCG_BARCODE2_STRING='          || v_ccg_barcode2_string || CHR(13) || CHR(10) ||
    'CCG_BARCODE3='                 || v_ccg_barcode3 || CHR(13) || CHR(10) ||
    'CCG_BARCODE3_STRING='          || v_ccg_barcode3_string || CHR(13) || CHR(10);

    return (v_print_daten);
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
    when v_error then
      RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text);
      raise;
    when others then
      if v_err_nr is not NULL then
         RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text, true);
      else
         raise;
      end if;
  end ccg_etikett_vers_lte;


end;
/



-- sqlcl_snapshot {"hash":"03098f81e1ed8b7b122ad95baa58de2702c09584","type":"PACKAGE_BODY","name":"Z_SEAQUIST_DRUCK","schemaName":"DIRKSPZM32","sxml":""}