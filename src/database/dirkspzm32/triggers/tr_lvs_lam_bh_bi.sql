create or replace editionable trigger dirkspzm32.tr_lvs_lam_bh_bi before
    insert on dirkspzm32.lvs_lam_bh
    for each row
declare
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr               number;
    v_err_text             varchar2(255);

  -- Buchungsschlüssel sind
  -- 1  Inventur
  -- 2  Zugang
  --    Alle Daten Lagerplatz, LTE und LHM werden mit Gewicht usw belastet
  -- 3  Abgang
  --    Alle Daten Lagerplatz, LTE und LHM werden mit Gewicht usw entlastet
  --    Ist die LTE dann leer, verliert diese den Lagerplatz.
  --    Der Lagerplatz wird dann um das Gewicht der LTE entlastet
  -- 4  Umlagerung
  --    Bei der Umlagerung wird der Lagerplatz und die LTE nicht gebucht
  --    Es werden nur die Lagerplatze in der LAM und LHM angepasst
  -- 5  Warenbestand sperren
  --    Warenbestand wird gesperrt (Laborstatus != 'F'
  -- 6  Pick und Put Umpacken
  -- 7  Quarantäne mit abbuchung (Danach ist der Bestand nicht mehr verfügbar)
  --12  Lagerzugang KommDirekt
  --    Zugang jedoch als eigener Schlüssel, da nur der Bestand aus eienr LHM genommen
  --    wurde und in eine andere gesteckt worden ist. (Keine Bestandsveränderung)
  --13  Lagerabgang KommDirekt
  --    Abgang jedoch als eigener Schlüssel, da nur der Bestand aus eienr LHM genommen
  --    wurde und in eine andere gesteckt worden ist. (Keine Bestandsveränderung)
  --14  gezählte Inventur (wie Inventur, nur keine spontane Korrektur)
  --22  Lagerzugang KONSI-LAGER (KWE aus ISI-Order BK)
  --23  Lagerabgang KONSI-LAGER (KWA aus ISI-Order LK)
  --24  Warenentnahme KONSI-LAGER (WKE aus KONSI wird freier Bestand)

  -- local variables here

    v_lam_akt              lvs_lam%rowtype;    -- Lagerbestand der aktuellen Buchung
    v_lgr                  lvs_lgr%rowtype;    -- Lagerplatz des Materials
    v_lhm                  lvs_lhm%rowtype;    -- Lagerhilfsmittel des Materials
    v_lte                  lvs_lte%rowtype;    -- LagerTransporteinheit des Materials
    v_send_bew             s_send_bew%rowtype; -- Schnittstelle zu HOST für Bewegungen
    v_send_bew_status      s_send_bew.status%type; -- Staus UE oder NULL
    v_send_bew_tabelle     s_send_bew.tabelle%type;
    v_ziel_ort             lvs_lgr_ort%rowtype;       -- Lagerort Ziel
    v_order_pos            isi_order_pos%rowtype;
    v_fa_auftrag           bde_fa_auftrag%rowtype;
    v_user                 isi_user%rowtype;          -- Lesen der Personalnummer

  --v_lgr_lte_anz      number;             -- Anzahl der LTE's auf dem Lagerplatz
  --v_lam_kg           number;             -- Gewicht der Ware
    v_buch_kg              number;             -- Gewicht der Buchung
  --v_lhm_kg           number;             -- Gewicht der LHM incl. der Ware
  --v_lte_kg           number;             -- Gewicht der LHM incl. der Ware
    v_count                number;             -- Anzahl LHM's auf der LTE
    v_max_temp             number;             -- Maximaltemperatur für LTE
    v_min_temp             number;             -- Maximaltemperatur für LTE
    v_max_breite           number;             -- Maximaltemperatur für LTE
    v_max_tiefe            number;             -- Maximaltemperatur für LTE
    v_max_hoehe            number;             -- Maximaltemperatur für LTE
    v_max_wert_k           number;             -- Maximaltemperatur für LTE
    v_max_gefahren_k       number;             -- Maximaltemperatur für LTE
    v_oder_res_te          number;             -- Orederes im lAGERPLATZ eintragen (ABGANG)
    v_art_lte_menge        number;
    v_lgr_platz            lvs_lgr.lgr_platz%type;
    v_res_mhd              date;               -- Datum gleiches MHD

    v_found                boolean;            -- Daten in CURSOR gefunden
    v_sid                  isi_sid%rowtype;
    v_lte_cfg              lvs_lte_cfg%rowtype;-- Cfg Der LTE (Palette)
    v_anz_lagen            number(3);         -- Anzahl der Lagen auf der LTE (Palette)
    v_lte_akt_lhm          number(3);         -- Aktuelle LHM's auf LTE

    v_art                  isi_artikel%rowtype;-- Artikeldaten
    v_art_kd               isi_artikel_kunde%rowtype;
    v_firma                isi_firma%rowtype;
    v_art_lte_hoehe_max    v_art.lte_hoehe_max%type;
    v_art_lte_breite_max   v_art.lte_breite_max%type;
    v_art_lte_tiefe_max    v_art.lte_tiefe_max%type;
    v_art_lhm_hoehe_lage   v_art.lhm_hoehe_lage%type;
    v_art_lte_lhm_menge    v_art.lte_lhm_menge%type;
    v_art_lte_lhm_pro_lage v_art.lte_lhm_pro_lage%type;
    v_art_lte_lhm_lagen    v_art.lte_lhm_lagen%type;
    v_lte_vol_hoehe        number;
    v_barcode_id           number;                -- ID aus dem barcode generiert

    cursor c_lte_cfg is
    select
        *
    from
        lvs_lte_cfg ltec
    where
            ltec.sid = :new.sid
        and ltec.firma_nr = :new.firma_nr
        and ltec.lte_name = v_lte.lte_name;

    cursor c_sid is
    select
        *
    from
        isi_sid s
    where
        s.sid_my_sid = 1;

    cursor c_lam_akt is                    -- Cursor für den Lagerbestand der aktuellen Buchung
    select
        *
    from
        lvs_lam lam_akt
    where
            lam_akt.sid = :new.sid
        and lam_akt.firma_nr = :new.firma_nr
        and lam_akt.lam_id = :new.lam_id;

    cursor c_lam_lte is                    -- Anzahl und MIN, MAX Temperatur der LHM's auf dieser Transporteinheit
    select
        count(lam_lte.lam_id),
        min(art.min_temp),
        max(art.max_temp),
        max(art.lte_breite_max),
        max(art.lte_tiefe_max),
        max(art.lte_hoehe_max),
        min(art.wert_klasse),
        min(art.gefahren_klasse)
    from
        lvs_lam     lam_lte,
        isi_artikel art
    where
            lam_lte.sid = :new.sid
        and lam_lte.lte_id = :new.lte_id
        and lam_lte.menge > 0
        and art.sid = :new.sid
        and art.artikel_id = lam_lte.artikel_id;

    cursor c_lgr is                        -- Lesen des Lagerplatz
    select
        *
    from
        lvs_lgr lgr
    where
        lgr.lgr_platz = :new.lgr_platz;

    cursor c_lte is                        -- Lesen der Transporteinheit
    select
        *
    from
        lvs_lte lte
    where
        lte.lte_id = :new.lte_id;

    cursor c_lhm is                        -- Lesen des Lagerhilfsmittel
    select
        *
    from
        lvs_lhm lhm
    where
        lhm.lhm_id = :new.lhm_id;

    cursor c_art is                        -- Lesen des Artikels
    select
        *
    from
        isi_artikel art
    where
            art.sid = :new.sid
        and art.artikel_id = :new.artikel_id;

    cursor c_art_kd is
    select
        *
    from
        isi_artikel_kunde ak
    where
            ak.sid = :new.sid
        and ak.artikel_id = :new.artikel_id
        and ak.kunden_nr = v_lam_akt.kunden_nr;

    cursor c_send_bew is                    -- Suche eintrag in der Schnittstelle
    select
        *
    from
        s_send_bew bew
    where
            bew.lam_id = v_lam_akt.lam_id
        and bew.lam_bh_typ = :new.vorg_typ
        and bew.lhm_nr = v_lam_akt.lhm_id
        and bew.status is null
        and bew.lam_bh_id is null;

    cursor c_lgr_ort is                             -- Lesen des Lagerplatz
    select
        *
    from
        lvs_lgr_ort ort
    where
            ort.lgr_ort = v_lgr.lgr_ort
        and ort.firma_nr = v_lgr.firma_nr
        and ort.sid = v_lgr.sid;

    cursor c_order_pos is                           -- Lesen der Order-Pos bei Bestellung
    select
        *
    from
        isi_order_pos pos
    where
            pos.sid = :new.sid
        and pos.vorgang_typ = decode(:new.bus,
                                     c.lam_bh_bus_zug_konsi,
                                     'KWE',  -- BUS = WE-Konsi-Lager dann ist in der ISI-Order Typ BK und Vorg_typ 'WEK'
                                     'WEE')
        and pos.vorgang_id = v_lam_akt.best_nr
        and pos.vorgang_pos = v_lam_akt.best_pos;

    cursor c_bde_fa_auftrag is
    select
        *
    from
        bde_fa_auftrag fa
    where
            fa.sid = v_lam_akt.sid
        and fa.firma_nr = v_lam_akt.firma_nr
        and fa.leitzahl = v_lam_akt.leitzahl
     --and fa.res_id = v_lam_akt.res_id;
        and fa.fa_ag = decode(v_lam_akt.fa_ag, null, fa.fa_ag, v_lam_akt.fa_ag)
        and nvl(fa.kenz_letzt_ag, 0) = decode(v_lam_akt.fa_ag, null, 1, 0);

    cursor c_firma is
    select
        *
    from
        isi_firma f
    where
            f.sid = :new.sid
        and f.firma_nr = :new.firma_nr;

begin
    v_art := null;
    v_lgr := null;
    v_ziel_ort := null;
    v_order_pos := null;
    open c_firma;
    fetch c_firma into v_firma;
    close c_firma;
  ---------------------------------------------------------------------------------------------------------------
  -- Vor dem Schreiben der Abgangsbuchung muss geprüft sein, dass die Mengen in der Buchung <= des Lagerbestands
  -- ist, sonst würde hier ein negativer Lagerbestand entstehen
  ---------------------------------------------------------------------------------------------------------------
    open c_lam_akt;                    -- Lagerbestandsdaten für aktuelle Buchung holen
    fetch c_lam_akt into v_lam_akt;    --
    v_found := c_lam_akt%found;
    close c_lam_akt;                   -- Aktueller Lagerbestand im Zugriff
  --v_lam_kg := v_lam_akt.lam_kg;      -- Gewicht merken

    if not v_found -- Wenn keine lam vorhanden ist, dann werden historische Daten zurueckgeholt,

     then           -- dabei duerfen keine Buchungen durchgefuert werden.
        return;      -- Also raus hier
    end if;
    open c_lte;                    --
    fetch c_lte into v_lte;        -- Hole die Transporteinheit
    close c_lte;                   --
  --v_lte_kg := v_lte.lte_akt_kg;  -- Gewicht merken

    open c_lhm;                    --
    fetch c_lhm into v_lhm;        -- Hole das Lagerhilfsmittel
    close c_lhm;                   --
  -- v_lhm_kg := v_lhm.      -- Gewicht merken

    open c_art;                    --
    fetch c_art into v_art;        -- Hole dei Artikeldaten
    close c_art;                   --

    open c_lgr;                    --
    fetch c_lgr into v_lgr;        -- Lesen den Eintrag des Lagerplatz
    close c_lgr;                   --

    if
        :new.bus != 1               -- Keine Inventurbuchung
        and :new.bus != 14              -- Keine gezaelte Inventurbuchung -AG- 20190227 BugFix
        and :new.bus != 22              -- KONSI hat keinen Einfluss auf INVENTUR
        and :new.bus != 23              -- KONSI hat keinen Einfluss auf INVENTUR
                                  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                  -- Achtung: BUS 24 ist eine Bestandsveränderung
                                  -- im KONSI und auch im eingenen Lagerbestand.
                                  -- Daher muss Inventur beachtet werden
                                  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    then
        if v_art.akt_inventur_id is not null then
            v_err_text := 'Fehler: Buchung nicht möglich. '
                          || 'Artikel '
                          || v_art.artikel
                          || ' '
                          || v_art.bezeichnung1
                          || ' ist in Inventur.';

            v_err_nr := c.fmid_inventur_artikel;
            raise v_error;
        end if;

        if v_lgr.akt_inventur_id is not null then
            v_err_text := 'Fehler: Buchung nicht möglich. '
                          || 'Lagerplatz '
                          || v_lgr.lgr_platz
                          || ' ist in Inventur.';
            v_err_nr := c.fmid_inventur_platz;
            raise v_error;
        end if;

        open c_lgr_ort;
        fetch c_lgr_ort into v_ziel_ort;
        close c_lgr_ort;
        if v_ziel_ort.akt_inventur_id is not null then
            v_err_text := 'Fehler: Buchung nicht möglich. '
                          || 'Lagerort '
                          || v_ziel_ort.lgr_ort
                          || ' '
                          || v_ziel_ort.lgr_ort_text
                          || ' ist in Inventur.';

            v_err_nr := c.fmid_inventur_ort;
            raise v_error;
        end if;

        if v_lam_akt.akt_inventur_id is not null then
            v_err_text := 'Fehler: Buchung nicht möglich. '
                          || 'Lagerbestand für LHM '
                          || v_lam_akt.lhm_id
                          || ' ist in Inventur.';
            v_err_nr := c.fmid_inventur;
            raise v_error;
        end if;

    end if;

    if
        :new.lgr_platz is not null
        and :new.bus != 22              -- KONSI hat keinen Einfluss
        and :new.bus != 23              -- KONSI hat keinen Einfluss
    then
        begin
            lvs_p_base.set_artikel_letzte_buchung(v_lam_akt.sid,
                                                  v_lam_akt.firma_nr,
                                                  v_lam_akt.artikel_id,
                                                  v_lam_akt.leitzahl,
                                                  v_lam_akt.fa_ag,
                                                  :new.buch_datum);

        exception
            when others then
                null;  -- Wenn kein Upodate dann egal
        end;
    end if;

  -- Lesen der User-Daten zum übermitteln der Personalnummer zu Hostsystemen
    if not isi_allg.get_user_by_login_id(:new.sid,
                                         :new.ls_login_id,
                                         v_user) then
        v_user.pers_nr := null;
    end if;

    if :new.bus = 1         -- Inventur
    or :new.bus = 14        -- gezählte Inventur
     then
  --
        v_lgr_platz := :new.lgr_platz;

    -- AG 22.06.2017 Wenn keine Menge auf der LAM, dann fehlt derLagerplatz un die LTE-ID
    --  ggf. ist auch dei LTE bereits ausgebucht.
        if
            v_lam_akt.menge = 0
            and :new.menge > 0
        then
            if v_lte.lgr_platz is null then
       -- wenn letzte LAM per Inventur von LTE genommen, dann (leere) LTE ausbuchen
                lvs_p_lte.lvs_korr_te_einbuchen(v_lte.sid,          -- in_te_sid         in lvs_lte.sid%TYPE,
                                                v_lte.firma_nr,     -- in_te_firma_nr    in lvs_lte.firma_nr%TYPE,
                                                v_lte.lte_id,       -- in_lte_id         in LVS_LTE.LTE_ID%TYPE,
                                                v_lte.lte_status,   -- in_lte_status     in lvs_lte.lte_status%TYPE,
                                                v_lte.sid,          -- in_lgr_sid        in lvs_lgr.sid%TYPE,
                                                v_lte.firma_nr,     -- in_lgr_firma_nr   in lvs_lgr.firma_nr%TYPE,
                                                v_lte.lgr_ort,      -- in_lgr_ort        in lvs_lgr.lgr_ort%TYPE,
                                                v_lgr_platz,        -- in_lgr_lagerplatz in LVS_LTE.LGR_PLATZ%TYPE,
                                                :new.ls_login_id);  -- in_ls_login_id    in isi_user.login_id%TYPE)
            end if;

            v_lam_akt.lgr_platz := v_lgr_platz;
            v_lam_akt.lte_id := :new.lte_id;
        end if;

        if
            v_lgr_platz is not null
            and v_lam_akt.lgr_platz is not null -- Mengenänderung Inventur
        then
            v_lam_akt.menge := v_lam_akt.menge + :new.menge;
            v_lam_akt.lam_kg := v_lam_akt.lam_kg + nvl(:new.lam_bh_kg,
                                                       0);      -- Gewicht addieren im Material
            update lvs_lte
            set
                lte_akt_kg = lte_akt_kg + nvl(:new.lam_bh_kg,
                                              0), -- WK 2015-10-01: wie bei LAM nur Delta (Änderung) buchen
                lte_letzte_buchung = :new.buch_datum
            where
                lte_id = :new.lte_id;

            update lvs_lgr
            set
                lgr_akt_kg = v_lgr.lgr_akt_kg + nvl(:new.lam_bh_kg,
                                                    0) -- WK 2015-10-01: wie bei LAM nur Delta (Änderung) buchen
            where
                lgr_platz = :new.lgr_platz;

        end if;

        if v_lam_akt.menge = 0 then
            v_lam_akt.lte_id := null;            -- -AG- 05.08.2016 Bug Fix, bei Menge 0 muss die LAM von der LTE getrennt werden.
            v_lgr_platz := null;
            if v_lte.lte_akt_lhm > 0 then -- -WK- Bugfix lte_akt_lhm < 0
                v_lte.lte_akt_lhm := v_lte.lte_akt_lhm - 1;
                update lvs_lte lte
                set
                    lte.lte_akt_lhm = v_lte.lte_akt_lhm
                where
                    lte_id = :new.lte_id;

            end if;

        else -- -AG- BugFix damit die Kartonzähler nach Inverur OK
            if v_lam_akt.menge = :new.menge then
                v_lte.lte_akt_lhm := v_lte.lte_akt_lhm + 1;
                update lvs_lte lte
                set
                    lte.lte_akt_lhm = v_lte.lte_akt_lhm
                where
                    lte_id = :new.lte_id;

            end if;
        end if;

    -- -AG- Bug Fix bei gezählter Inventur
        update lvs_lam lam
        set
            lam.lte_id = decode(:new.bus,
                                14,
                                v_lam_akt.lte_id,
                                lam.lte_id),  -- -AG- 05.08.2016 Bug Fix, bei Menge 0 muss die LAM von der LTE getrennt werden.
            lam.lgr_platz = v_lgr_platz,
            lam.menge = decode(:new.bus,
                               14,
                               v_lam_akt.menge,
                               lam.menge),
            lam.lam_kg = decode(:new.bus,
                                14,
                                v_lam_akt.lam_kg,
                                lam.lam_kg),
           -- WK 2015-10-01: bei gezählter Inventur kann mindestens das Datum und der User
           -- auf der LAM schon mal gesetzt werden (für Korrekturbuchungen ohne Inventur-Job)
            lam.letzte_inventur_datum = decode(:new.bus,
                                               14,
                                               sysdate,
                                               lam.letzte_inventur_datum),
            lam.letzte_inventur_login_id = decode(:new.bus,
                                                  14,
                                                  :new.ls_login_id,
                                                  lam.letzte_inventur_login_id)
        where
                lam.sid = :new.sid
            and lam.lam_id = :new.lam_id;

        update lvs_lhm lhm
        set
            lhm.lgr_platz = v_lgr_platz
        where
            lhm.lhm_id = :new.lhm_id;

        if v_lam_akt.menge = 0 then
            if v_lte.lte_akt_lhm = 0 then
        -- wenn letzte LAM per Inventur von LTE genommen, dann (leere) LTE ausbuchen
                lvs_p_lte.lvs_korr_te_ausbuchen(v_lte.sid,          -- in_te_sid         in lvs_lte.sid%TYPE,
                                                v_lte.firma_nr,     -- in_te_firma_nr    in lvs_lte.firma_nr%TYPE,
                                                v_lte.lte_id,       -- in_lte_id         in LVS_LTE.LTE_ID%TYPE,
                                                v_lte.lte_status,   -- in_lte_status     in lvs_lte.lte_status%TYPE,
                                                v_lte.sid,          -- in_lgr_sid        in lvs_lgr.sid%TYPE,
                                                v_lte.firma_nr,     -- in_lgr_firma_nr   in lvs_lgr.firma_nr%TYPE,
                                                v_lte.lgr_ort,      -- in_lgr_ort        in lvs_lgr.lgr_ort%TYPE,
                                                v_lte.lgr_platz,    -- in_lgr_lagerplatz in LVS_LTE.LGR_PLATZ%TYPE,
                                                :new.ls_login_id);  -- in_ls_login_id    in isi_user.login_id%TYPE)
            end if;
        end if;

    -- -CMe 03.01.2019 Fix- Wenn beim Abnehemen von Waren eine LTE leer wird und die Menge korrigiert wird
    -- muss der rest_string und die res_artikel_id wieder auf einen korrekten Wert gesetzt werden
        if
            :new.menge > 0
            and v_lte.res_string = v_lte.lte_name
        then
            if v_lte.res_artikel_id is null then
                v_lte.res_artikel_id := to_char(v_art.artikel_id);
            end if;

            if v_lte.res_artikel_id != to_char(v_art.artikel_id) then
                v_lte.res_artikel_id := 'MP';
                v_lte.lte_voll := 'A';
            end if;

            if v_lte.res_string_statisch is null then
                v_lte.res_string := lvs_util.get_res_string_v359(:new.sid,
                                                                 :new.firma_nr,
                                                                 v_lte.waren_typ,
                                                                 v_lte.res_artikel_id,
                                                                 v_lam_akt.hersteller_kuerzel_liste,
                                                                 v_lam_akt.fa_ag,
                                                                 v_lam_akt.charge_id,
                                                                 v_lam_akt.serie_id,
                                                                 v_lam_akt.leitzahl,
                                                                 v_lam_akt.kunden_nr,
                                                                 v_lam_akt.lieferant_nr,
                                                                 v_lam_akt.best_nr,
                                                                 v_lam_akt.lam_mhd,
                                                                 1,
                                                                 v_lam_akt.labor_status,
                                                                 v_lte.lte_voll,
                                                                 v_lam_akt.owner_address_id,
                                                                 v_res_mhd);
            else
                v_lte.res_string := v_lte.res_string_statisch;
            end if;

            update lvs_lte lte
            set
                lte.res_string = v_lte.res_string,
                lte.res_artikel_id = v_lte.res_artikel_id
            where
                lte.lte_id = v_lte.lte_id;

        end if;

        if v_lam_akt.lte_id is null then
            v_lam_akt.lte_id := v_lte.lte_id; -- AG 20170309 Damit die LTE-ID in der Schnittstelle geschrieben wird
        end if;

        s_schnittstelle.write_host_bew(null,
                                       v_lam_akt,
                                       :new.lam_bh_id,
                                       :new.bus,
                                       :new.vorg_typ,
                                       null,
                                       'UE',
                                       v_lgr,
                                       null,
                                       :new.ls_login_id,
                                       :new.menge);
---------------------------------------------------------------------------------------------------------------------------------
  -- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang
    elsif :new.bus = 2                     -- Zugang
    or :new.bus = 12                    -- Zugang KommDirekt
    or :new.bus = 22                    -- Zugang Konsi
     then
        v_buch_kg := nvl(:new.lam_bh_kg,
                         0);                                -- Gewicht Netto übergeben
        if
            nvl(v_lam_akt.menge, 0) = 0
            and :new.menge > 0
        then                                      -- Erste Befüllung dann
            v_buch_kg := nvl(v_buch_kg, 0) + nvl(v_lhm.lhm_akt_kg, 0);               -- Verpackung noch Dazurechnen für LTE
            v_lte.lte_akt_lhm := nvl(v_lte.lte_akt_lhm, 0) + 1;              -- Einen LHM mehr auf der Palette
        end if;

        v_lam_akt.menge := v_lam_akt.menge + :new.menge;
        v_lam_akt.lam_kg := v_lam_akt.lam_kg + :new.lam_bh_kg;      -- Gewicht addieren im Material
        v_lhm.lhm_akt_kg := v_lhm.lhm_akt_kg + :new.lam_bh_kg;      -- Gewicht addieren im LHM (Karton)

        open c_send_bew;
        fetch c_send_bew into v_send_bew;
        v_found := c_send_bew%found;
        close c_send_bew;

    -- Wenn hier ein Eintrag ist, kommt dieser aus dem BDE (Produktion)
        if v_found                                              -- Eintrag ist bereits in der Schnittstelle
         then
            open c_lgr_ort;                                        -- Dann soll dieser auch mit Menge
            fetch c_lgr_ort into v_ziel_ort;                       -- Uebertragen werden
            close c_lgr_ort;                                       -- Kann nur sein, wenn Material auf Lagerplatz

            if :new.lgr_platz is null then
                v_send_bew_status := null;
            else
                v_send_bew_status := 'UE';
            end if;

            update s_send_bew bew
            set
                bew.status = v_send_bew_status,
                bew.lagerort = v_ziel_ort.host_lgr_ort,
                bew.lte_nr = v_lam_akt.lte_id,
                bew.menge = :new.menge,
                bew.lam_bh_id = :new.lam_bh_id,
                bew.pers_nr = v_user.pers_nr,
                bew.aktion = decode(:new.bus,
                                    22,
                                    'KWE',
                                    bew.aktion),  -- Bei Konsi muss WEK in der Schnittstelle gebucht werden
                bew.lagerplatz = v_lgr.lgr_platz,
                bew.lte_name = v_lte.lte_name
            where
                    bew.lam_id = v_lam_akt.lam_id
                and bew.lam_bh_typ = :new.vorg_typ
                and bew.lhm_nr = v_lam_akt.lhm_id
                and bew.status is null
                and bew.lam_bh_id is null;

        else
            open c_order_pos;
            fetch c_order_pos into v_order_pos;
            v_found := c_order_pos%found;
            close c_order_pos;
            if v_found then
                open c_sid;
                fetch c_sid into v_sid;
                close c_sid;
                if v_sid.sid_schnittstelle is null then
                    update isi_order_pos pos
                    set
                        pos.ist_menge = pos.ist_menge + decode(pos.menge_basis,
                                                               c.basis_lte,
                                                               1,
                                                               :new.menge)
                    where
                            pos.sid = :new.sid
                        and pos.vorgang_typ = decode(:new.bus,
                                                     c.lam_bh_bus_zug_konsi,
                                                     'KWE',  -- BUS = WE-Konsi-Lager dann ist in der ISI-Order Typ BK und Vorg_typ 'WEK'
                                                     'WEE')                          -- Wareneingang Intern (Eigener Bestand
                        and pos.vorgang_id = v_lam_akt.best_nr
                        and pos.vorgang_pos = v_lam_akt.best_pos;

                end if;

                v_send_bew_status := null;                    -- erst Uebertragen wenn gescannt
                v_send_bew_tabelle := 'S_AUF';
            else
                v_order_pos := null;
                v_send_bew_tabelle := null;
                if :new.lgr_platz is null then
                    v_send_bew_status := null;
                else
                    v_send_bew_status := 'UE';
                end if;

            end if;

            s_schnittstelle.write_host_bew(v_order_pos,
                                           v_lam_akt,
                                           :new.lam_bh_id,
                                           :new.bus,
                                           :new.vorg_typ,
                                           v_send_bew_tabelle,
                                           v_send_bew_status,
                                           v_lgr,
                                           null,
                                           :new.ls_login_id);

        end if;

        if
            v_lam_akt.labor_status != c.lab_stat_f -- Gesperrte Ware muss auf dem HOST in die Spreeware gebucht werden
            and :new.bus = 22                         -- Zugang Konsi
        then
            s_schnittstelle.write_host_bew(null,
                                           v_lam_akt,
                                           null,
                                           5,
                                           c.lam_bh_bus_sp,
                                           null,
                                           'UE',
                                           v_lgr,
                                           null,
                                           :new.ls_login_id,
                                           :new.menge);
        end if;

        update lvs_lam
        set
            menge = v_lam_akt.menge,
            lam_kg = v_lam_akt.lam_kg
        where
                sid = :new.sid
            and firma_nr = :new.firma_nr
            and lam_id = :new.lam_id;

        update lvs_lhm
        set
            lhm_akt_kg = v_lam_akt.lam_kg,
            lhm_letzte_buchung = :new.buch_datum
        where
            lhm_id = :new.lhm_id;

        v_lte.lte_akt_kg := nvl(v_lte.lte_akt_kg, 0) + nvl(v_buch_kg, 0);      -- Gewicht der Ware und evtl. incl. Verpackung

        if v_lte.min_temp < v_art.min_temp then
            v_lte.min_temp := v_art.min_temp;                            -- Artikel hat höhere MIN Temperatur
        end if;

        if v_lte.max_temp > v_art.max_temp then
            v_lte.max_temp := v_art.max_temp;                            -- Artikel hat höhere MAX Temperatur
        end if;

        v_art_lte_hoehe_max := v_art.lte_hoehe_max;
        v_art_lte_breite_max := v_art.lte_breite_max;
        v_art_lte_tiefe_max := v_art.lte_tiefe_max;
        v_art_lhm_hoehe_lage := v_art.lhm_hoehe_lage;
        v_art_lte_lhm_menge := v_art.lte_lhm_menge;
        v_art_lte_lhm_pro_lage := v_art.lte_lhm_pro_lage;
        v_art_lte_lhm_lagen := v_art.lte_lhm_lagen;
        v_art_lte_menge := v_art.lte_menge;
        open c_art_kd;
        fetch c_art_kd into v_art_kd;
        v_found := c_art_kd%found;
        close c_art_kd;
        if v_found then
            v_art_lte_hoehe_max := nvl(v_art_kd.lte_hoehe_max, v_art_lte_hoehe_max);
            v_art_lte_breite_max := nvl(v_art_kd.lte_breite_max, v_art_lte_breite_max);
            v_art_lte_tiefe_max := nvl(v_art_kd.lte_tiefe_max, v_art_lte_tiefe_max);
            v_art_lhm_hoehe_lage := nvl(v_art_kd.lhm_hoehe_lage, v_art_lhm_hoehe_lage);
            v_art_lte_lhm_menge := nvl(v_art_kd.lte_lhm_menge, v_art_lte_lhm_menge);
            v_art_lte_lhm_pro_lage := nvl(v_art_kd.lte_lhm_pro_lage, v_art_lte_lhm_pro_lage);
            v_art_lte_lhm_lagen := nvl(v_art_kd.lte_lhm_lagen, v_art_lte_lhm_lagen);
            v_art_lte_menge := nvl(v_art_kd.lte_menge, v_art.lte_menge);
        end if;

        if
            v_lte_cfg.lte_vol_hoehe_fest != c.c_true
            and v_lte.lte_vol_hoehe < v_art_lte_hoehe_max
        then
            v_lte.lte_vol_hoehe := v_art_lte_hoehe_max;                   -- Artikel kann höher werden
        end if;

        if v_lte.lte_vol_breite < v_art_lte_breite_max then
            v_lte.lte_vol_breite := v_art_lte_breite_max;                 -- Artikel kann höher werden
        end if;
        if v_lte.lte_vol_tiefe < v_art_lte_tiefe_max then
            v_lte.lte_vol_tiefe := v_art_lte_tiefe_max;                   -- Artikel kann höher werden
        end if;
        if v_lte.res_artikel_id is null then
            v_lte.res_artikel_id := to_char(v_art.artikel_id);
        end if;

        if v_lte.res_artikel_id != to_char(v_art.artikel_id) then
            v_lte.res_artikel_id := 'MP';
            v_lte.lte_voll := 'A';
        end if;

        if v_lte.waren_typ = 'LP' then
            v_lte.waren_typ := v_art.waren_typ;
        end if;

        if
            v_lte.waren_typ != v_art.waren_typ
            and v_lte.waren_typ != c.mischkanal
            and v_art.einlagerung = 'AR'
        then
            v_lte.waren_typ := 'MP';
        end if;

        if v_art.einlagerung != 'AR' then
            v_lte.waren_typ := c.mischkanal;
        end if;

        if v_lte.lte_akt_lhm = 1 then
            v_res_mhd := v_lam_akt.lam_mhd;
        else
            v_res_mhd := v_lte.res_mhd;        -- MHD für Gruppe
        end if;

        v_lte.res_mhd := v_res_mhd;        -- MHD für Gruppe
        v_lte.lte_voll := 'A';
        if v_lte.waren_typ != 'MP' then
            begin
                if v_art_lhm_hoehe_lage is null then
                    v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe / nvl(v_art_lte_lhm_lagen, 1);
                end if;
            exception
                when others then
                    v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe;
            end;

            begin
                if nvl(v_art_lte_lhm_pro_lage, 0) = 0 then
                    begin
                        if nvl(v_art_lte_lhm_menge / v_art_lte_lhm_lagen, 0) != 0 then
                            v_art_lte_lhm_pro_lage := v_art_lte_lhm_menge / v_art_lte_lhm_lagen;
                        else
                            v_art_lte_lhm_pro_lage := 1;
                        end if;

                    exception
                        when others then
                            v_art_lte_lhm_lagen := 1;
                    end;
                end if;

                if v_art_lhm_hoehe_lage is null then
                    v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe / nvl(v_art_lte_lhm_lagen, 1);
                end if;

                if v_lam_akt.menge_basis = c.basis_lte then
                    v_art_lte_menge := 1;
                    v_anz_lagen := v_art_lte_lhm_lagen;
                elsif v_lam_akt.menge_basis = c.basis_lhm then
                    v_art_lte_menge := v_art_lte_lhm_menge;
                    v_lte_akt_lhm := lvs_p_lte_lhm.lvs_lte_lhm_best(:new.sid,
                                                                    :new.firma_nr,
                                                                    :new.lte_id,
                                                                    'LTE');

                    v_anz_lagen := round((v_lte_akt_lhm / v_art_lte_lhm_pro_lage + 0.49), 0);
                else
                    v_art_lte_menge := v_art_lte_menge;
                    v_anz_lagen := round((v_lte.lte_akt_lhm / v_art_lte_lhm_pro_lage) + 0.49, 0);

                end if;

            exception
                when others then
                    v_art_lte_lhm_lagen := 1;
                    v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe;
            end;

            open c_lte_cfg;
            fetch c_lte_cfg into v_lte_cfg;
            v_found := c_lte_cfg%found;
            close c_lte_cfg;
            if not v_found then
                v_lte_cfg.lte_vol_hoehe := 0;
            end if;
            if lvs_p_lte_lhm.lvs_lte_lhm_best(:new.sid,
                                              :new.firma_nr,
                                              :new.lte_id,
                                              'LTE') >= v_art_lte_menge * v_firma.proz_anbruch / 100
            or v_art.waren_typ = c.rohware then
                v_lte.lte_voll := 'V';
            else
                if v_lte_cfg.lte_vol_hoehe_fest != c.c_true then
                    v_lte_vol_hoehe := nvl(v_lte_cfg.lte_vol_hoehe + v_anz_lagen * v_art_lhm_hoehe_lage, v_lte.lte_vol_hoehe);
                    if v_lte_vol_hoehe > 99999                 -- Maxwert für LTE in der Tabelle
                     then
                        v_err_text := 'Fehler: Lte wird zu hoch. Bitte Einheit wechseln.';
                        v_err_nr := 20;
                        raise v_error;
                    end if;

                    v_lte.lte_vol_hoehe := v_lte_vol_hoehe;
                end if;

                v_lte.lte_voll := 'A';
            end if;

        end if;

        if v_lte.res_string_statisch is null then
            v_lte.res_string := lvs_util.get_res_string_v359(:new.sid,
                                                             :new.firma_nr,
                                                             v_lte.waren_typ,
                                                             v_lte.res_artikel_id,
                                                             v_lam_akt.hersteller_kuerzel_liste,
                                                             v_lam_akt.fa_ag,
                                                             v_lam_akt.charge_id,
                                                             v_lam_akt.serie_id,
                                                             v_lam_akt.leitzahl,
                                                             v_lam_akt.kunden_nr,
                                                             v_lam_akt.lieferant_nr,
                                                             v_lam_akt.best_nr,
                                                             v_lam_akt.lam_mhd,
                                                             1,
                                                             v_lam_akt.labor_status,
                                                             v_lte.lte_voll,
                                                             v_lam_akt.owner_address_id,
                                                             v_res_mhd);

            v_lte.res_mhd := v_res_mhd;        -- LTE_MHD aus ResString übernehmen
        else
            v_lte.res_string := v_lte.res_string_statisch;
        end if;

        v_lte.lte_vol := v_lte.lte_vol_tiefe * v_lte.lte_vol_breite * v_lte.lte_vol_hoehe / 1000000000;                   -- Artikel kann höher werden

        if v_art.gefahren_klasse > v_lte.gefahren_klasse then
            v_lte.gefahren_klasse := v_art.gefahren_klasse;
        end if;

        if v_art.wert_klasse > v_lte.wert_klasse then
            v_lte.wert_klasse := v_art.wert_klasse;
        end if;

        if v_art.abc > v_lte.abc then
            v_lte.abc := v_art.abc;
        end if;
    -- -ISIDEF-
    -- Mischpaletten sind immer ABC = 'A'
    -- weil diese evtl. kommissioniert sind und daher bald ausgelagert werden sollen
        if v_lte.waren_typ = 'MP' then
            v_lte.abc := 1;
        end if;
        update lvs_lte
        set
            lte_akt_kg = nvl(v_lte.lte_akt_kg, 0),
            lte_akt_lhm = nvl(v_lte.lte_akt_lhm, 0),
            lte_letzte_buchung = :new.buch_datum,
            res_artikel_id = v_lte.res_artikel_id,
            waren_typ = v_lte.waren_typ,
            res_string = v_lte.res_string,
            res_mhd = v_lte.res_mhd,
            lte_vol_hoehe = v_lte.lte_vol_hoehe,
            lte_voll = v_lte.lte_voll,
            wert_klasse = nvl(v_lte.wert_klasse, 0),
            gefahren_klasse = nvl(v_lte.gefahren_klasse, 0),
            abc = v_lte.abc,
            anz_uml = 0
        where
            lte_id = :new.lte_id;

        v_lgr.lgr_akt_kg := nvl(v_lgr.lgr_akt_kg, 0) + nvl(v_buch_kg, 0); -- Das Gewicht zubuchen auf den Lagerplatz

        update lvs_lgr
        set
            lgr_akt_te = v_lgr.lgr_akt_te,
            lgr_akt_kg = v_lgr.lgr_akt_kg
        where
            lgr_platz = :new.lgr_platz;

        v_barcode_id := null;                     -- INIT
    -- Spezialbarcode evtl mit lfdn für charge 'CCC'
        if v_firma.lhm_barcode_type = c.lte_barcode_spez then
            isi_utils.spez_barcode_lfdn(:new.sid,
                                        :new.firma_nr,
                                        :new.lhm_id,
                                        c.basis_lhm,
                                        v_barcode_id);
        end if;

        if
            :new.bus = 2
            and :new.lgr_platz is not null
        then
            lvs_p_base.set_artikel_letztes_einl_datum(v_lam_akt.sid,
                                                      v_lam_akt.firma_nr,
                                                      v_lam_akt.artikel_id,
                                                      v_lam_akt.leitzahl,
                                                      v_lam_akt.fa_ag,
                                                      :new.buch_datum);
        end if;

---------------------------------------------------------------------------------------------------------------------------------
  -- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang
    elsif :new.bus = 3                   -- Abgang
    or :new.bus = 13                  -- Abgang KommDirekt
    or :new.bus = 23                  -- Abgang KONSI
    or :new.bus = 7                   -- Quarantäne
     then
        v_lam_akt.res_id := :new.res_id;                            -- Beim Abgang die RES_ID des Verbrauches eintragen für die Schnittstelle
        if :new.bus = 7                   -- Quarantäne / Schrott
         then
            open c_bde_fa_auftrag;
            fetch c_bde_fa_auftrag into v_fa_auftrag;
            close c_bde_fa_auftrag;
      -- Wenn diese Ware aus der Produktion kommt, müssen die Mengen angepasst werden (Schrott und B)
            if v_lam_akt.labor_status = c.lab_stat_f then
                update bde_fa_auftrag fa
                set
                    fa.ag_ist_mg = fa.ag_ist_mg - :new.menge,
                    fa.ag_ist_mg_schrott = fa.ag_ist_mg_schrott + :new.menge
                where
                        fa.sid = v_fa_auftrag.sid
                    and fa.firma_nr = v_fa_auftrag.firma_nr
                    and fa.leitzahl = v_fa_auftrag.leitzahl
                    and fa.fa_ag = v_fa_auftrag.fa_ag
                    and fa.fa_upos = v_fa_auftrag.fa_upos;

                update bde_pd_prod pa
                set
                    pa.menge_a = nvl(pa.menge_a, 0) - :new.menge,
                    pa.schrott = nvl(pa.schrott, 0) + :new.menge
                where
                        pa.sid = v_fa_auftrag.sid
                    and pa.vorg_typ = 'PA'
                    and pa.firma_nr = v_fa_auftrag.firma_nr
                    and pa.leitzahl = v_fa_auftrag.leitzahl
                    and pa.fa_ag = v_fa_auftrag.fa_ag
                    and nvl(pa.fa_upos, 0) = nvl(v_fa_auftrag.fa_upos, 0)
                    and pa.res_id = v_lam_akt.res_id
                    and pa.prod_beginn <= v_lam_akt.prod_datum
                    and ( ( pa.prod_ende is null )
                          or ( pa.prod_ende >= v_lam_akt.prod_datum ) );

                update bde_pd_prod pp
                set
                    pp.menge_a = nvl(pp.menge_a, 0) - :new.menge,
                    pp.schrott = nvl(pp.schrott, 0) + :new.menge
                where
                        pp.sid = v_fa_auftrag.sid
                    and pp.vorg_typ = 'PP'
                    and pp.firma_nr = v_fa_auftrag.firma_nr
                    and pp.leitzahl = v_fa_auftrag.leitzahl
                    and pp.fa_ag = v_fa_auftrag.fa_ag
                    and nvl(pp.fa_upos, 0) = nvl(v_fa_auftrag.fa_upos, 0)
                    and pp.res_id = v_lam_akt.res_id
                    and pp.lam_id = v_lam_akt.lam_id;

            else
                update bde_pd_prod pa
                set
                    pa.menge_b = nvl(pa.menge_b, 0) - :new.menge,
                    pa.schrott = nvl(pa.schrott, 0) + :new.menge
                where
                        pa.sid = v_fa_auftrag.sid
                    and pa.vorg_typ = 'PA'
                    and pa.firma_nr = v_fa_auftrag.firma_nr
                    and pa.leitzahl = v_fa_auftrag.leitzahl
                    and pa.fa_ag = v_fa_auftrag.fa_ag
                    and nvl(pa.fa_upos, 0) = nvl(v_fa_auftrag.fa_upos, 0)
                    and pa.res_id = v_lam_akt.res_id
                    and pa.prod_beginn <= v_lam_akt.prod_datum
                    and ( ( pa.prod_ende is null )
                          or ( pa.prod_ende >= v_lam_akt.prod_datum ) );

                update bde_pd_prod pp
                set
                    pp.menge_b = nvl(pp.menge_b, 0) - :new.menge,
                    pp.schrott = nvl(pp.schrott, 0) + :new.menge
                where
                        pp.sid = v_fa_auftrag.sid
                    and pp.vorg_typ = 'PP'
                    and pp.firma_nr = v_fa_auftrag.firma_nr
                    and pp.leitzahl = v_fa_auftrag.leitzahl
                    and pp.fa_ag = v_fa_auftrag.fa_ag
                    and nvl(pp.fa_upos, 0) = nvl(v_fa_auftrag.fa_upos, 0)
                    and pp.res_id = v_lam_akt.res_id
                    and pp.lam_id = v_lam_akt.lam_id;

                update bde_fa_auftrag fa
                set
                    fa.ag_ist_mg_b = fa.ag_ist_mg_b - :new.menge,
                    fa.ag_ist_mg_schrott = fa.ag_ist_mg_schrott + :new.menge
                where
                        fa.sid = v_fa_auftrag.sid
                    and fa.firma_nr = v_fa_auftrag.firma_nr
                    and fa.leitzahl = v_fa_auftrag.leitzahl
                    and fa.fa_ag = v_fa_auftrag.fa_ag
                    and fa.fa_upos = v_fa_auftrag.fa_upos;

            end if;

        end if;

        if
            v_lam_akt.labor_status != c.lab_stat_f -- Gesperrte Ware muss auf dem HOST erst aus der Spreeware um dann abgebucht zu werden
            and :new.bus != 23                        -- Abgang KONSI
        then
            s_schnittstelle.write_host_bew(null,
                                           v_lam_akt,
                                           null,
                                           5,
                                           c.lam_bh_bus_sp,
                                           null,
                                           'UE',
                                           v_lgr,
                                           null,
                                           :new.ls_login_id,
                                           :new.menge * -1);
        end if;

        open c_send_bew;
        fetch c_send_bew into v_send_bew;
        v_found := c_send_bew%found;
        close c_send_bew;
        if v_found then
            open c_lgr_ort;
            fetch c_lgr_ort into v_ziel_ort;
            close c_lgr_ort;
            update s_send_bew bew
            set
                bew.status = 'UE',
                bew.lte_nr = v_lam_akt.lte_id,
                bew.lam_bh_id = :new.lam_bh_id,
                bew.menge = :new.menge,
             -- Eintragen der Res_ID in der Schnittstelle
                bew.res_id = :new.res_id,
                bew.lagerort = v_ziel_ort.host_lgr_ort,
                bew.lagerplatz = v_lgr.lgr_platz,
                bew.pers_nr = v_user.pers_nr
            where
                    bew.lam_id = v_lam_akt.lam_id
                and bew.lam_bh_typ = :new.vorg_typ
                and bew.lhm_nr = v_lam_akt.lhm_id
                and bew.status is null
                and bew.lam_bh_id is null;

        else
            s_schnittstelle.write_host_bew(null,
                                           v_lam_akt,
                                           :new.lam_bh_id,
                                           :new.bus,
                                           :new.vorg_typ,
                                           null,
                                           'UE',
                                           v_lgr,
                                           null,
                                           :new.ls_login_id,
                                           :new.menge);
        end if;

        v_buch_kg := :new.lam_bh_kg;                                -- Gewicht Netto übergeben
        v_lam_akt.menge := v_lam_akt.menge - :new.menge;
        v_lam_akt.lam_kg := v_lam_akt.lam_kg - :new.lam_bh_kg;      -- Gewicht abrechnen
        v_lhm.lhm_akt_kg := v_lhm.lhm_akt_kg - :new.lam_bh_kg;      -- Gewicht abrechnen
        if v_lam_akt.menge = 0 then
            v_lam_akt.lgr_platz := null;
            v_lam_akt.lte_id := null;
            v_lam_akt.lhm_id := null;
            v_lhm.lte_id := null;
            v_lhm.lgr_platz := null;
            v_buch_kg := v_buch_kg + nvl(v_lhm.lhm_akt_kg, 0);               -- Verpackung noch Dazurechnen
            v_lte.lte_akt_lhm := v_lte.lte_akt_lhm - 1;              -- Einen LHM weiniger auf der Palette
            v_lam_akt.lam_kg := 0;
        end if;

        update lvs_lam
        set
            menge = v_lam_akt.menge,
            lam_kg = v_lam_akt.lam_kg,
            lgr_platz = v_lam_akt.lgr_platz,
            lte_id = v_lam_akt.lte_id,
            lhm_id = v_lam_akt.lhm_id
        where
                sid = :new.sid
            and firma_nr = :new.firma_nr
            and lam_id = :new.lam_id;

        update lvs_lhm
        set
            lhm_akt_kg = v_lam_akt.lam_kg,
            lte_id = v_lhm.lte_id,
            lhm_letzte_buchung = :new.buch_datum,
            lgr_platz = v_lhm.lgr_platz
        where
            lhm_id = :new.lhm_id;

        v_oder_res_te := 0;
        if v_lte.lte_akt_lhm = 0 then                    -- Palette ist leer
            v_lte.lgr_platz := null;                 -- Pallet leer, wird die Palette von diesem Lagerplatz genommen!!!
            v_lte.min_temp := -300;                 -- Min und Max Temperatur
            v_lte.max_temp := + 300;                 -- auf default wenn leer
            v_lte.res_string := null;
            v_lte.res_mhd := null;                 -- MHD für Gruppe
            v_lte.res_artikel_id := null;
            v_lte.wert_klasse := 0;
            v_lte.gefahren_klasse := 0;
            v_lte.waren_typ := c.leerpal;
            if v_lte.order_vorgang_id is not null then
                v_oder_res_te := -1;
        -- v_lte.order_vorgang_id := NULL; -- -WK- 20090311: Bezug zur Order nicht entfernen. Wichtig für die Anzeige bei der Verladung.
            end if;
        else
            open c_lam_lte;                                -- Holen Anzahl LHM's Min- und Maxtemperatur fue LTE
            fetch c_lam_lte into
                v_count,
                v_min_temp,
                v_max_temp,
                v_max_breite,
                v_max_tiefe,
                v_max_hoehe,
                v_max_wert_k,
                v_max_gefahren_k;

            close c_lam_lte;
            v_lte.min_temp := v_min_temp;                 -- Min und Max Temperatur
            v_lte.max_temp := v_max_temp;                 -- aus ermittelten Werten

            if
                v_lte_cfg.lte_vol_hoehe_fest != c.c_true
                and v_max_hoehe > 0
            then
                v_lte.lte_vol_hoehe := nvl(v_max_hoehe, v_lte.lte_vol_hoehe);
            end if;

            if v_max_breite > 0 then
                v_lte.lte_vol_breite := nvl(v_max_breite, v_lte.lte_vol_breite);
            end if;

            if v_max_tiefe > 0 then
                v_lte.lte_vol_tiefe := nvl(v_max_tiefe, v_lte.lte_vol_tiefe);
            end if;

            v_lte.wert_klasse := nvl(v_max_wert_k, v_lte.wert_klasse);
            v_lte.gefahren_klasse := nvl(v_max_gefahren_k, v_lte.gefahren_klasse);
        end if;

        if v_lte.waren_typ != 'MP' then
            v_art_lte_hoehe_max := v_art.lte_hoehe_max;
            v_art_lte_breite_max := v_art.lte_breite_max;
            v_art_lte_tiefe_max := v_art.lte_tiefe_max;
            v_art_lhm_hoehe_lage := v_art.lhm_hoehe_lage;
            v_art_lte_lhm_menge := v_art.lte_lhm_menge;
            v_art_lte_lhm_pro_lage := v_art.lte_lhm_pro_lage;
            v_art_lte_lhm_lagen := v_art.lte_lhm_lagen;
            open c_art_kd;
            fetch c_art_kd into v_art_kd;
            v_found := c_art_kd%found;
            close c_art_kd;
            if v_found then
                v_art_lte_hoehe_max := nvl(v_art_kd.lte_hoehe_max, v_art_lte_hoehe_max);
                v_art_lte_breite_max := nvl(v_art_kd.lte_breite_max, v_art_lte_breite_max);
                v_art_lte_tiefe_max := nvl(v_art_kd.lte_tiefe_max, v_art_lte_tiefe_max);
                v_art_lhm_hoehe_lage := nvl(v_art_kd.lhm_hoehe_lage, v_art_lhm_hoehe_lage);
                v_art_lte_lhm_menge := nvl(v_art_kd.lte_lhm_menge, v_art_lte_lhm_menge);
                v_art_lte_lhm_pro_lage := nvl(v_art_kd.lte_lhm_pro_lage, v_art_lte_lhm_pro_lage);
                v_art_lte_lhm_lagen := nvl(v_art_kd.lte_lhm_lagen, v_art_lte_lhm_lagen);
            end if;

            begin
                if v_art_lhm_hoehe_lage is null then
                    v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe / nvl(v_art_lte_lhm_lagen, 1);
                end if;

                if v_art.menge_basis = c.basis_lte then
                    v_art_lte_menge := 1;
                    v_anz_lagen := v_art_lte_lhm_lagen;
                elsif v_art.menge_basis = c.basis_lhm then
                    v_art_lte_menge := v_art_lte_lhm_menge;
                    v_lte_akt_lhm := lvs_p_lte_lhm.lvs_lte_lhm_best(:new.sid,
                                                                    :new.firma_nr,
                                                                    :new.lte_id,
                                                                    'LTE');

                    v_anz_lagen := round((v_lte_akt_lhm / v_art_lte_lhm_pro_lage + 0.49), 0);
                else
                    v_art_lte_menge := v_art_lte_menge;
                    v_anz_lagen := round((v_lte.lte_akt_lhm / v_art_lte_lhm_pro_lage) + 0.49, 0);

                end if;

            exception
                when others then
                    v_art_lte_lhm_lagen := 1;
                    v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe;
            end;

            open c_lte_cfg;
            fetch c_lte_cfg into v_lte_cfg;
            v_found := c_lte_cfg%found;
            close c_lte_cfg;
            if not v_found then
                v_lte_cfg.lte_vol_hoehe := 0;
            end if;
            if lvs_p_lte_lhm.lvs_lte_lhm_best(:new.sid,
                                              :new.firma_nr,
                                              :new.lte_id,
                                              'LTE') >= v_art_lte_menge * v_firma.proz_anbruch / 100
            or v_art.waren_typ = c.rohware then
                v_lte.lte_voll := 'V';
            else
                if v_lte_cfg.lte_vol_hoehe_fest != c.c_true then
                    v_lte.lte_vol_hoehe := nvl(v_lte_cfg.lte_vol_hoehe + v_anz_lagen * v_art_lhm_hoehe_lage, v_lte.lte_vol_hoehe);
                end if;

                v_lte.lte_voll := 'A';
            end if;

        end if;

        v_lte.lte_akt_kg := v_lte.lte_akt_kg - nvl(v_buch_kg, 0);      -- Gewicht der Ware und evtl. Verpackung abrechnen
    
    --CMe 20210108 Das Gewicht darf niemals negativ werden
        if ( v_lte.lte_akt_kg < 0 ) then
            v_lte.lte_akt_kg := 0;
        end if;

        v_lte.lte_vol := v_lte.lte_vol_tiefe * v_lte.lte_vol_breite * v_lte.lte_vol_hoehe / 1000000000;                   -- Artikel kann höher werden

        update lvs_lte
        set
            lte_akt_kg = v_lte.lte_akt_kg,
            lte_akt_lhm = v_lte.lte_akt_lhm,
            lte_letzte_buchung = :new.buch_datum,
            -- Bei Teilentnahme (normaerweise immer aus einem Behaelter) kein Groessenkorrekturen (VOL in LTE)
            lte_vol_hoehe = decode(:new.bus,
                                   13,
                                   lte_vol_hoehe,
                                   v_lte.lte_vol_hoehe),
            lte_vol_breite = decode(:new.bus,
                                    13,
                                    lte_vol_breite,
                                    v_lte.lte_vol_breite),
            lte_vol_tiefe = decode(:new.bus,
                                   13,
                                   lte_vol_tiefe,
                                   v_lte.lte_vol_tiefe),
            lte_vol = decode(:new.bus,
                             13,
                             lte_vol,
                             v_lte.lte_vol),
            wert_klasse = nvl(v_lte.wert_klasse, 0),
            gefahren_klasse = nvl(v_lte.gefahren_klasse, 0),
            res_artikel_id = v_lte.res_artikel_id,
            waren_typ = v_lte.waren_typ,
            res_string = v_lte.res_string,
            res_mhd = v_lte.res_mhd,
            order_vorgang_id = v_lte.order_vorgang_id,
            anz_uml = 0
        where
            lte_id = :new.lte_id;

        if v_lte.lte_akt_lhm = 0 then                -- Palette ist leer
            v_lgr.lgr_akt_te := v_lgr.lgr_akt_te - 1;  -- Eine Transporteinheit weniger
            v_buch_kg := v_buch_kg + v_lte.lte_akt_kg; -- Pallet leer, dann Gewicht auf dem Lagerplatz reduzieren
        end if;

        v_lgr.lgr_akt_kg := v_lgr.lgr_akt_kg - nvl(v_buch_kg, 0); -- Das Gewicht immer reduzieren
        update lvs_lgr
        set
            lgr_akt_te = v_lgr.lgr_akt_te,
            lgr_akt_kg = v_lgr.lgr_akt_kg,
            lgr_order_res_te = lgr_order_res_te + v_oder_res_te
        where
            lgr_platz = :new.lgr_platz;

        if :new.bus = 3 then
            lvs_p_base.set_artikel_letztes_ausl_datum(v_lam_akt.sid,
                                                      v_lam_akt.firma_nr,
                                                      v_lam_akt.artikel_id,
                                                      v_lam_akt.leitzahl,
                                                      v_lam_akt.fa_ag,
                                                      :new.buch_datum);
        end if;
---------------------------------------------------------------------------------------------------------------------------------
  -- Umlagerung -- Umlagerung -- Umlagerung -- Umlagerung -- Umlagerung -- Umlagerung -- Umlagerung -- Umlagerung -- Umlagerung
    elsif :new.bus = 4 then                   -- Umlagerung
        if
            :new.vorg_typ = c.lam_bh_zugagng
            and :new.lgr_platz is not null
            and v_lam_akt.lgr_platz is null
        then
            lvs_p_base.set_artikel_letztes_einl_datum(v_lam_akt.sid,
                                                      v_lam_akt.firma_nr,
                                                      v_lam_akt.artikel_id,
                                                      v_lam_akt.leitzahl,
                                                      v_lam_akt.fa_ag,
                                                      :new.buch_datum);

            if nvl(v_lam_akt.owner_address_id, 0) != v_lgr.owner_address_id -- Vergleich mit NULL ist immer FALSE. Daher ist es möglich,
                                                                      -- KONSI-WARE auch auf normalen Plätzen einzulagern

             then
                v_err_text := 'Fehler: Der Lagerplatz ist für KONSI reserviert. '
                              || 'LTE '
                              || v_lam_akt.lte_id;
                if nvl(v_lam_akt.owner_address_id, 0) = 0 then
                    v_err_text := v_err_text || ' ist kein KONSI-Bestand.';
                else
                    v_err_text := v_err_text || ' entspricht nicht dem eingetragenen Lieferanten.';
                end if;

                v_err_nr := 28;
                raise v_error;
            end if;

        end if;

        if ( nvl(v_lam_akt.owner_address_id, 0) != 0 )                  -- KONSI-Ware darf nicht auf einen WA gefahren werden

         then
            if isi_allg.c_get_firma_cfg_param(:new.sid,
                                              :new.firma_nr,
                                              'LVS',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                              null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                              'LVS_AUSL_KONSI_ERLAUBT',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                              'LVS',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                              'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                              'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                              'BOOLEAN') = c.c_false  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                               then
                if
                    ( isi_p_order_base.get_order_pos(:new.sid,
                                                     v_lam_akt.order_pos_auf_id,
                                                     v_order_pos)
                    or v_lam_akt.order_pos_auf_id is null )
                    and v_lgr.lgr_verwendung = c.wa
                    and nvl(v_order_pos.vorgang_typ, 'XX') != 'KWA'                         -- wenn es keine KWA, Rücklieferung Lieferant ist
                    and nvl(v_order_pos.satzart, 'XX') != 'LK'
                then
                    v_err_text := 'Fehler: Die LTE '
                                  || v_lam_akt.lte_id
                                  || ' ist KONSI-Bestand und darf nicht ausgelagert werden.';
                    v_err_nr := 29;
                    raise v_error;
                end if;

            end if;

        end if;

        if :new.menge >= 0 then
            update lvs_lam
            set
                lgr_platz = :new.lgr_platz
            where
                    sid = :new.sid
                and firma_nr = :new.firma_nr
                and lam_id = :new.lam_id;

            update lvs_lhm
            set
                lgr_platz = :new.lgr_platz,
                lhm_letzte_buchung = :new.buch_datum
            where
                lhm_id = :new.lhm_id;

        end if;
    -- AG 25.07.2016 Umlagerungen jetzt im Transport-Trigger zählen je LTE
  ---------------------------------------------------------------------------------------------------------------------------------
  -- Sperren ohne Abgang -- Sperren ohne Abgang -- Sperren ohne Abgang -- Sperren ohne Abgang -- Sperren ohne Abgang -- Sperren ohne Abgang
    elsif :new.bus = 5 then                  -- Sperren ohne Abgang
        open c_bde_fa_auftrag;
        fetch c_bde_fa_auftrag into v_fa_auftrag;
        close c_bde_fa_auftrag;
        update bde_pd_prod pa
        set
            pa.menge_a = nvl(pa.menge_a, 0) - :new.menge,
            pa.menge_b = nvl(pa.menge_b, 0) + :new.menge
        where
                pa.sid = v_lam_akt.sid
            and pa.vorg_typ = 'PA'
            and pa.firma_nr = v_fa_auftrag.firma_nr
            and pa.leitzahl = v_fa_auftrag.leitzahl
            and pa.fa_ag = v_fa_auftrag.fa_ag
            and nvl(pa.fa_upos, 0) = nvl(v_fa_auftrag.fa_upos, 0)
            and pa.res_id = v_lam_akt.res_id
            and pa.prod_beginn <= v_lam_akt.prod_datum
            and ( ( pa.prod_ende is null )
                  or ( pa.prod_ende >= v_lam_akt.prod_datum ) );

        update bde_pd_prod pp
        set
            pp.menge_a = nvl(pp.menge_a, 0) - :new.menge,
            pp.menge_b = nvl(pp.menge_b, 0) + :new.menge
        where
                pp.sid = v_fa_auftrag.sid
            and pp.vorg_typ = 'PP'
            and pp.firma_nr = v_fa_auftrag.firma_nr
            and pp.leitzahl = v_fa_auftrag.leitzahl
            and pp.fa_ag = v_fa_auftrag.fa_ag
            and nvl(pp.fa_upos, 0) = nvl(v_fa_auftrag.fa_upos, 0)
            and pp.res_id = v_lam_akt.res_id
            and pp.lam_id = v_lam_akt.lam_id;

        update bde_fa_auftrag fa
        set
            fa.ag_ist_mg = fa.ag_ist_mg - :new.menge,
            fa.ag_ist_mg_b = fa.ag_ist_mg_b + :new.menge
        where
                fa.sid = v_fa_auftrag.sid
            and fa.firma_nr = v_fa_auftrag.firma_nr
            and fa.leitzahl = v_fa_auftrag.leitzahl
            and fa.fa_ag = v_fa_auftrag.fa_ag
            and fa.fa_upos = v_fa_auftrag.fa_upos;

        s_schnittstelle.write_host_bew(null,
                                       v_lam_akt,
                                       :new.lam_bh_id,
                                       :new.bus,
                                       :new.vorg_typ,
                                       null,
                                       'UE',
                                       v_lgr,
                                       null,
                                       :new.ls_login_id,
                                       :new.menge);
---------------------------------------------------------------------------------------------------------------------------------
  -- Umpacken -- Umpacken -- Umpacken -- Umpacken -- Umpacken -- Umpacken -- Umpacken -- Umpacken -- Umpacken -- Umpacken -- Umpacken
    elsif :new.bus = 6 then                   -- Umpacken
        update lvs_lam
        set
            lgr_platz = :new.lgr_platz
        where
                sid = :new.sid
            and firma_nr = :new.firma_nr
            and lam_id = :new.lam_id;

        update lvs_lhm
        set
            lgr_platz = :new.lgr_platz,
            lhm_letzte_buchung = :new.buch_datum
        where
            lhm_id = :new.lhm_id;

    end if;

exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
        v_err_text := v_err_text
                      || cr_lf()
                      || dbms_utility.format_error_backtrace;
        raise_application_error(-20000 - v_err_nr, v_err_text, true);
    when others then
        if v_err_nr is not null then
            v_err_text := v_err_text
                          || cr_lf()
                          || dbms_utility.format_error_backtrace;
            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || cr_lf()
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
        end if;
end;
/

alter trigger dirkspzm32.tr_lvs_lam_bh_bi enable;


-- sqlcl_snapshot {"hash":"9577df5ed9b6e9eb39e093957e49d96749bea77f","type":"TRIGGER","name":"TR_LVS_LAM_BH_BI","schemaName":"DIRKSPZM32","sxml":""}