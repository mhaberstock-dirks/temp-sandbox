create or replace package body dirkspzm32.dw is

    function set_aus_begin (
        in_ausw_begin in date
    ) return date is
    begin
        p_ausw_begin := in_ausw_begin;
        return ( p_ausw_begin );
    end;

    function set_aus_ende (
        in_ausw_ende in date
    ) return date is
    begin
        p_ausw_ende := in_ausw_ende;
        return ( p_ausw_ende );
    end;

    function set_zins_proz (
        in_zins_proz in number
    ) return number is
    begin
        p_zins_proz := in_zins_proz;
        return ( p_zins_proz );
    end;

    function get_ausw_begin return date is
    begin
        return ( p_ausw_begin );
    end;

    function get_ausw_ende return date is
    begin
        return ( p_ausw_ende );
    end;

    function get_zins_proz return number is
    begin
        return ( p_zins_proz );
    end;

    procedure c_take_lvs_snapshot_lte_typ (
        in_sid        in dw_lvs_bestand.sid%type,
        in_firma_nr   in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum in dw_lvs_bestand.wert_datum%type default null
    ) is
    begin
        take_lvs_snapshot_lte_typ(in_sid, in_firma_nr, in_lgr_ort, in_wert_datum);
        commit;
    end;

  -- Schreibt nur die LTE-Daten (Name, Lagerort, Status, Basisname, Anzahl in die DW-Tabelle)
    procedure take_lvs_snapshot_lte_typ (
        in_sid        in dw_lvs_bestand.sid%type,
        in_firma_nr   in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum in dw_lvs_bestand.wert_datum%type default null
    ) is

        v_error exception;
        v_error_code         number;
        v_error_message      varchar2(800);
        v_found              boolean;
        v_lte_name           lvs_lte.lte_name%type;
        v_lte_basis_name     lvs_lte_cfg.basis_lte_name%type;
        v_lgr_ort            lvs_lte.lgr_ort%type;
        v_lte_status         lvs_lte.lte_status%type;
        v_lte_anzahl         dw_lvs_bestand.anz_lte%type;
        v_erfasst_date       date;
        cursor c_lte_typen is
        select
            l.lte_name,
            l.lgr_ort,
            l.lte_status,
            nvl(c.basis_lte_name, c.lte_name),
            count(l.lte_name)
        from
            lvs_lte     l,
            lvs_lte_cfg c
        where
                l.sid = in_sid
            and l.firma_nr = in_firma_nr
            and ( l.lgr_ort = in_lgr_ort
                  or in_lgr_ort is null )
            and l.lgr_platz is not null
            and c.sid = l.sid
            and c.firma_nr = l.firma_nr
            and c.lte_name = l.lte_name
        group by
            l.lte_name,
            l.lgr_ort,
            l.lte_status,
            nvl(c.basis_lte_name, c.lte_name);

        v_anz_dw_datensaetze number;
        cursor c_doppel_eintraege is
        select
            count(*)
        from
            dw_lvs_bestand t
        where
            t.wert_datum = in_wert_datum;

    begin
        isi_p_log.c_isi_system_meldung('01', 1, 'DB_HUF_JOBS', 'ORA-DB', 'dw.take_lvs_snapshot_lte_typ',
                                       null, null, null, null, null,
                                       'gestartet', 'IL');

        open c_doppel_eintraege;
        fetch c_doppel_eintraege into v_anz_dw_datensaetze;
        v_found := c_doppel_eintraege%found;
        close c_doppel_eintraege;
        if v_found then
            if v_anz_dw_datensaetze > 0 then
                isi_p_log.c_isi_system_meldung('01', 1, 'DB_HUF_JOBS', 'ORA-DB', 'dw.take_lvs_snapshot_lte_typ',
                                               null, null, null, null, null,
                                               'Es wurden Bereits Daten für den '
                                               || in_wert_datum
                                               || ' erfasst.', 'WL');

                return;
            end if;
        end if;

        v_erfasst_date := sysdate;
        begin
            open c_lte_typen;
            loop
                fetch c_lte_typen into
                    v_lte_name,
                    v_lgr_ort,
                    v_lte_status,
                    v_lte_basis_name,
                    v_lte_anzahl;
                exit when c_lte_typen%notfound;
                insert into dw_lvs_bestand values ( in_sid,                           -- SID	VARCHAR2(2)	N			Datenbank für Konsolidierung
                                                    in_firma_nr,                      -- FIRMA_NR	NUMBER(2)	N			Firmennummer in der Datenbank
                                                    null,                             -- DW_STAT_ID	NUMBER	N			Laufende Nummer
                                                    'DW_LTE_TYP_STATUS_IM_LAGER',     -- STAT_NAME	VARCHAR2(200)	N			Name der Statistik z.B. HUF_DW_STATISITIK
                                                    v_erfasst_date,                   -- ERFASST_AM	TIMESTAMP(6)	N			Zeitpunkt der Erfassung
                                                    v_lgr_ort,                        -- LGR_ORT	NUMBER(5)	Y			Lagerort
                                                    null,                             -- ARTIKEL_ID	NUMBER	Y			Artikel
                                                    null,                             -- LEITZAHL	NUMBER	Y			Leitzahl
                                                    null,                             -- FA_AG	NUMBER	Y			Arbeitsgang
                                                    null,                             -- CHARGE_ID	NUMBER	Y			Chargen-Nr.
                                                    null,                             -- MHD	DATE	Y			Mindest-Haltbarkeits-Datum
                                                    null,                             -- LABOR_STATUS	CHAR(1)	Y			Laborstatus
                                                    v_lte_name,                       -- LTE_NAME	VARCHAR2(15)	Y			Beschreibung / Text des LTE
                                                    v_lte_status,                     -- LTE_STATUS	VARCHAR2(2)	Y			Status der LTE (z.B. LF)
                                                    null,                             -- SUM_TEILEMENGE	NUMBER	Y			Anzahl der Teile
                                                    null,                             -- ANZ_LAM	NUMBER	Y			Anzahl der Behälter
                                                    v_lte_anzahl,                     -- ANZ_LTE	NUMBER(10,4)	Y			Anzahl der LTEs. Bei Mischpal. z.B. zwei Artikel auf einer LTE SUM_LTE = 0,5
                                                    v_lte_basis_name,                 -- BASIS_LTE_NAME Y    Basistyp der LTE
                                                    nvl(in_wert_datum, v_erfasst_date),-- WERT_DATUM	DATE	Y			Wert Datum nicht verwechseln mit Erfasst_am
                                                    null,                             -- WERT_DATUM	DATE_ENDE	Y	Wert Datum ende falls eine Zeitraum von Buchungen gemeint sind
                                                    null,                             -- MENGE_BASIS	VARCHAR2(3)	Y			LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit
                                                    null );                            -- MENGENEINHEIT_BASIS	VARCHAR2(10)	Y			Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE
            end loop;

            close c_lte_typen;
        exception
      -- Im Fehlerfall is der Fehler bereits gesetzt.
            when others then
                rollback;
                v_error_code := sqlcode;
                v_error_message := substr(sqlerrm, 1, 800);
                isi_p_log.c_isi_system_meldung('01', 1, 'DB_HUF_JOBS', 'ORA-DB', 'dw.take_lvs_snapshot_lte_typ',
                                               null, null, null, null, v_error_code,
                                               'Exception: ' || v_error_message, 'EL');

        end;

        isi_p_log.c_isi_system_meldung('01', 1, 'DB_HUF_JOBS', 'ORA-DB', 'dw.take_lvs_snapshot_lte_typ',
                                       null, null, null, null, null,
                                       'fertig', 'IL');

    end;

  -- Schreibt LAM-mengen (Name, Lagerort, Status, Basisname, Anzahl in die DW-Tabelle)
    procedure c_take_lvs_snapshot_lam_menge (
        in_sid        in dw_lvs_bestand.sid%type,
        in_firma_nr   in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum in dw_lvs_bestand.wert_datum%type default null
    ) is

        v_error exception;
        v_error_code          number;
        v_error_message       varchar2(800);
        v_found               boolean;
        v_artikel_id          lvs_lam.artikel_id%type;
        v_ag                  lvs_lam.fa_ag%type;
        v_menge_basis         lvs_lam.menge_basis%type;
        v_mengeneinheit_basis lvs_lam.mengeneinheit_basis%type;
        v_menge               lvs_lam.menge%type;
        v_anz_lam             number;
        v_lgr_ort             lvs_lgr_ort.lgr_ort%type;
        v_date                date;
        cursor c_lam_mengen is
        select
            l.artikel_id,
            l.fa_ag,                     -- NULL = Endprodukt außer bei HUF
            l.menge_basis,
            l.mengeneinheit_basis,
            sum(l.menge),
            count(l.lam_id),
            lg.lgr_ort
        from
            lvs_lam l,
            lvs_lgr lg
        where
                l.sid = in_sid
            and l.firma_nr = in_firma_nr
            and l.lgr_platz is not null
            and l.menge > 0
            and lg.sid = l.sid
            and lg.firma_nr = l.firma_nr
            and lg.lgr_platz = l.lgr_platz
            and ( lg.lgr_ort = in_lgr_ort
                  or in_lgr_ort is null )
        group by
            l.artikel_id,
            l.fa_ag,
            l.menge_basis,
            l.mengeneinheit_basis,
            lg.lgr_ort;

        v_anz_dw_datensaetze  number;
        cursor c_doppel_eintraege is
        select
            count(*)
        from
            dw_lvs_bestand t
        where
                t.wert_datum = v_date
            and t.stat_name like 'DW_LAM_ART_MENGE_IN_LAGERORT_TAG_%';

    begin
        v_date := nvl(in_wert_datum, sysdate);
        isi_p_log.c_isi_system_meldung('01', 1, 'LVS_DW_JOB', 'ORA-DB', 'dw.take_lvs_snapshot_lam_menge',
                                       null, null, null, null, null,
                                       'gestartet', 'IL');

        open c_doppel_eintraege;
        fetch c_doppel_eintraege into v_anz_dw_datensaetze;
        v_found := c_doppel_eintraege%found;
        close c_doppel_eintraege;
        if v_found then
            if v_anz_dw_datensaetze > 0 then
                isi_p_log.c_isi_system_meldung('01', 1, 'LVS_DW_JOB', 'ORA-DB', 'dw.take_lvs_snapshot_lam_menge',
                                               null, null, null, null, null,
                                               'Es wurden Bereits Daten für den '
                                               || in_wert_datum
                                               || ' erfasst.', 'WL');

                return;
            end if;
        end if;

        begin
            open c_lam_mengen;
            loop
                fetch c_lam_mengen into
                    v_artikel_id,
                    v_ag,
                    v_menge_basis,
                    v_mengeneinheit_basis,
                    v_menge,
                    v_anz_lam,
                    v_lgr_ort;
                exit when c_lam_mengen%notfound;
                insert into dw_lvs_bestand values ( in_sid,                           -- SID	VARCHAR2(2)	N			Datenbank für Konsolidierung
                                                    in_firma_nr,                      -- FIRMA_NR	NUMBER(2)	N			Firmennummer in der Datenbank
                                                    null,                             -- DW_STAT_ID	NUMBER	N			Laufende Nummer
                                                    'DW_LAM_ART_MENGE_IN_LAGERORT_TAG_' || v_mengeneinheit_basis,            -- STAT_NAME	VARCHAR2(200)	N			Name der Statistik z.B. HUF_DW_STATISITIK
                                                    sysdate,                          -- ERFASST_AM	TIMESTAMP(6)	N			Zeitpunkt der Erfassung
                                                    v_lgr_ort,                        -- LGR_ORT	NUMBER(5)	Y			Lagerort
                                                    v_artikel_id,                     -- ARTIKEL_ID	NUMBER	Y			Artikel
                                                    null,                             -- LEITZAHL	NUMBER	Y			Leitzahl
                                                    v_ag,                             -- FA_AG	NUMBER	Y			Arbeitsgang
                                                    null,                             -- CHARGE_ID	NUMBER	Y			Chargen-Nr.
                                                    null,                             -- MHD	DATE	Y			Mindest-Haltbarkeits-Datum
                                                    null,                             -- LABOR_STATUS	CHAR(1)	Y			Laborstatus
                                                    null,                             -- LTE_NAME	VARCHAR2(15)	Y			Beschreibung / Text des LTE
                                                    null,                             -- LTE_STATUS	VARCHAR2(2)	Y			Status der LTE (z.B. LF)
                                                    v_menge,                          -- SUM_MENGE	NUMBER	Y			Anzahl der Teile
                                                    v_anz_lam,                        -- ANZ_LAM	NUMBER	Y			Anzahl der Behälter
                                                    null,                             -- ANZ_LTE	NUMBER(10,4)	Y			Anzahl der LTEs. Bei Mischpal. z.B. zwei Artikel auf einer LTE SUM_LTE = 0,5
                                                    null,                             -- BASIS_LTE_NAME Y    Basistyp der LTE
                                                    v_date,                           -- WERT_DATUM	DATE	Y			Wert Datum nicht verwechseln mit Erfasst_am
                                                    null,                             -- WERT_DATUM	DATE_ENDE	Y	Wert Datum ende falls eine Zeitraum von Buchungen gemeint sind
                                                    v_menge_basis,                    -- MENGE_BASIS	VARCHAR2(3)	Y			LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit
                                                    v_mengeneinheit_basis );           -- MENGENEINHEIT_BASIS	VARCHAR2(10)	Y			Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE
            end loop;

            close c_lam_mengen;
        exception
      -- Im Fehlerfall is der Fehler bereits gesetzt.
            when others then
                rollback;
                if c_lam_mengen%isopen then
                    close c_lam_mengen;
                end if;
                v_error_code := sqlcode;
                v_error_message := substr(sqlerrm, 1, 800);
                isi_p_log.c_isi_system_meldung('01', 1, 'LVS_DW_JOB', 'ORA-DB', 'dw.take_lvs_snapshot_lam_menge',
                                               null, null, null, null, v_error_code,
                                               'Exception: ' || v_error_message, 'EL');

        end;

        isi_p_log.c_isi_system_meldung('01', 1, 'LVS_DW_JOB', 'ORA-DB', 'dw.take_lvs_snapshot_lam_menge',
                                       null, null, null, null, null,
                                       'fertig', 'IL');

    end;

  -- Schreibt LAM-Abg.-Mengen je tag und Artikel / AG
    procedure c_set_lvs_lam_bh_abgangtag (
        in_sid        in dw_lvs_bestand.sid%type,
        in_firma_nr   in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum in dw_lvs_bestand.wert_datum%type
    ) is

        v_error exception;
        v_error_code          number;
        v_error_message       varchar2(800);
        v_found               boolean;
        v_artikel_id          lvs_lam.artikel_id%type;
        v_ag                  lvs_lam.fa_ag%type;
        v_menge_basis         lvs_lam.menge_basis%type;
        v_mengeneinheit_basis lvs_lam.mengeneinheit_basis%type;
        v_menge               lvs_lam.menge%type;
        v_anz_lam             number;
        v_lgr_ort             lvs_lgr_ort.lgr_ort%type;
        cursor c_lam_bh is
        select
            lbh.artikel_id,
            l.fa_ag,                     -- NULL = Endprodukt außer bei HUF
            l.menge_basis,
            l.mengeneinheit_basis,
            sum(lbh.menge),
            count(l.lam_id) lam_anz,
            lg.lgr_ort
        from
            lvs_lam_bh lbh,
            lvs_lam    l,
            lvs_lgr    lg
        where
                lbh.sid = in_sid
            and lbh.firma_nr = in_firma_nr
            and lbh.buch_datum >= trunc(in_wert_datum)
            and lbh.buch_datum <= trunc(in_wert_datum) + 1
            and lbh.bus = 4
            and lbh.menge < 0
            and l.sid = in_sid
            and l.firma_nr = in_firma_nr
            and lbh.lam_id = l.lam_id
            and lg.sid = lbh.sid
            and lg.firma_nr = lbh.firma_nr
            and lg.lgr_platz = lbh.lgr_platz
            and ( lg.lgr_ort = in_lgr_ort
                  or in_lgr_ort is null )
        group by
            lbh.artikel_id,
            l.fa_ag,
            l.menge_basis,
            l.mengeneinheit_basis,
            lg.lgr_ort;

        cursor c_lam_bh_hist is
        select
            lbh.artikel_id,
            l.fa_ag,                     -- NULL = Endprodukt außer bei HUF
            l.menge_basis,
            l.mengeneinheit_basis,
            sum(lbh.menge),
            count(l.lam_id) lam_anz,
            lg.lgr_ort
        from
            lvs_lam_bh_hist lbh,
            lvs_lam_hist    l,
            lvs_lgr         lg
        where
                lbh.sid = in_sid
            and lbh.firma_nr = in_firma_nr
            and lbh.buch_datum >= trunc(in_wert_datum)
            and lbh.buch_datum <= trunc(in_wert_datum) + 1
            and lbh.bus = 4
            and lbh.menge < 0
            and l.sid = in_sid
            and l.firma_nr = in_firma_nr
            and lbh.lam_id = l.lam_id
            and lg.sid = lbh.sid
            and lg.firma_nr = lbh.firma_nr
            and lg.lgr_platz = lbh.lgr_platz
            and ( lg.lgr_ort = in_lgr_ort
                  or in_lgr_ort is null )
        group by
            lbh.artikel_id,
            l.fa_ag,
            l.menge_basis,
            l.mengeneinheit_basis,
            lg.lgr_ort;

        v_anz_dw_datensaetze  number;
        cursor c_doppel_eintraege is
        select
            count(*)
        from
            dw_lvs_bestand t
        where
                t.wert_datum = in_wert_datum
            and t.stat_name like 'DW_LAM_ART_ABG_LAGERORT_TAG_%';

        cursor c_dw_abg is
        select
            count(*)
        from
            dw_lvs_bestand t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.stat_name = 'DW_LAM_ART_ABG_LAGERORT_TAG_' || v_mengeneinheit_basis
            and t.lgr_ort = v_lgr_ort
            and t.wert_datum = in_wert_datum
            and t.artikel_id = v_artikel_id
            and t.fa_ag = v_ag;

    begin
        isi_p_log.c_isi_system_meldung('01',
                                       1,
                                       'LVS_DW_JOB',
                                       'ORA-DB',
                                       'dw.set_lvs_lam_bh_abg_menge_tag',
                                       null,
                                       null,
                                       null,
                                       null,
                                       null,
                                       'gestartet für '
                                       || to_char(
                                 trunc(in_wert_datum),
                                 'yyyy-mm-dd'
                             ),
                                       'IL');

        if in_wert_datum is null then
            isi_p_log.c_isi_system_meldung('01', 1, 'LVS_DW_JOB', 'ORA-DB', 'dw.set_lvs_lam_bh_abg_menge_tag',
                                           null, null, null, null, null,
                                           'Datum nicht gesetzt', 'IL');

            return;
        end if;

        open c_doppel_eintraege;
        fetch c_doppel_eintraege into v_anz_dw_datensaetze;
        v_found := c_doppel_eintraege%found;
        close c_doppel_eintraege;
        if v_found then
            if v_anz_dw_datensaetze > 0 then
                isi_p_log.c_isi_system_meldung('01', 1, 'LVS_DW_JOB', 'ORA-DB', 'dw.set_lvs_lam_bh_abg_menge_tag',
                                               null, null, null, null, null,
                                               'Es wurden Bereits Daten für den '
                                               || in_wert_datum
                                               || ' erfasst.', 'WL');

                return;
            end if;
        end if;

        begin
            open c_lam_bh;
            loop
                fetch c_lam_bh into
                    v_artikel_id,
                    v_ag,
                    v_menge_basis,
                    v_mengeneinheit_basis,
                    v_menge,
                    v_anz_lam,
                    v_lgr_ort;
                exit when c_lam_bh%notfound;
                insert into dw_lvs_bestand values ( in_sid,                           -- SID	VARCHAR2(2)	N			Datenbank für Konsolidierung
                                                    in_firma_nr,                      -- FIRMA_NR	NUMBER(2)	N			Firmennummer in der Datenbank
                                                    null,                             -- DW_STAT_ID	NUMBER	N			Laufende Nummer
                                                    'DW_LAM_ART_ABG_LAGERORT_TAG_' || v_mengeneinheit_basis,            -- STAT_NAME	VARCHAR2(200)	N			Name der Statistik z.B. HUF_DW_STATISITIK
                                                    sysdate,                          -- ERFASST_AM	TIMESTAMP(6)	N			Zeitpunkt der Erfassung
                                                    v_lgr_ort,                        -- LGR_ORT	NUMBER(5)	Y			Lagerort
                                                    v_artikel_id,                     -- ARTIKEL_ID	NUMBER	Y			Artikel
                                                    null,                             -- LEITZAHL	NUMBER	Y			Leitzahl
                                                    v_ag,                             -- FA_AG	NUMBER	Y			Arbeitsgang
                                                    null,                             -- CHARGE_ID	NUMBER	Y			Chargen-Nr.
                                                    null,                             -- MHD	DATE	Y			Mindest-Haltbarkeits-Datum
                                                    null,                             -- LABOR_STATUS	CHAR(1)	Y			Laborstatus
                                                    null,                             -- LTE_NAME	VARCHAR2(15)	Y			Beschreibung / Text des LTE
                                                    null,                             -- LTE_STATUS	VARCHAR2(2)	Y			Status der LTE (z.B. LF)
                                                    v_menge,                          -- SUM_MENGE	NUMBER	Y			Anzahl der Teile
                                                    v_anz_lam,                        -- ANZ_LAM	NUMBER	Y			Anzahl der Behälter
                                                    null,                             -- ANZ_LTE	NUMBER(10,4)	Y			Anzahl der LTEs. Bei Mischpal. z.B. zwei Artikel auf einer LTE SUM_LTE = 0,5
                                                    null,                             -- BASIS_LTE_NAME Y    Basistyp der LTE
                                                    in_wert_datum,                    -- WERT_DATUM	DATE	Y			Wert Datum nicht verwechseln mit Erfasst_am
                                                    null,                             -- WERT_DATUM	DATE_ENDE	Y	Wert Datum ende falls eine Zeitraum von Buchungen gemeint sind
                                                    v_menge_basis,                    -- MENGE_BASIS	VARCHAR2(3)	Y			LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit
                                                    v_mengeneinheit_basis );           -- MENGENEINHEIT_BASIS	VARCHAR2(10)	Y			Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE
            end loop;

            close c_lam_bh;
            open c_lam_bh_hist;
            loop
                fetch c_lam_bh_hist into
                    v_artikel_id,
                    v_ag,
                    v_menge_basis,
                    v_mengeneinheit_basis,
                    v_menge,
                    v_anz_lam,
                    v_lgr_ort;
                exit when c_lam_bh_hist%notfound;
                open c_dw_abg;
                fetch c_dw_abg into v_anz_dw_datensaetze;
                v_found := c_dw_abg%found;
                close c_dw_abg;
                if
                    v_found
                    and v_anz_dw_datensaetze = 1
                then
                    update dw_lvs_bestand t
                    set
                        t.sum_menge = t.sum_menge + v_menge,
                        t.anz_lam = t.anz_lam + v_anz_lam
                    where
                            t.sid = in_sid
                        and t.firma_nr = in_firma_nr
                        and t.stat_name = 'DW_LAM_ART_ABG_LAGERORT_TAG_' || v_mengeneinheit_basis
                        and t.lgr_ort = v_lgr_ort
                        and t.wert_datum = in_wert_datum
                        and t.artikel_id = v_artikel_id
                        and t.fa_ag = v_ag;

                else
                    insert into dw_lvs_bestand values ( in_sid,                           -- SID	VARCHAR2(2)	N			Datenbank für Konsolidierung
                                                        in_firma_nr,                      -- FIRMA_NR	NUMBER(2)	N			Firmennummer in der Datenbank
                                                        null,                             -- DW_STAT_ID	NUMBER	N			Laufende Nummer
                                                        'DW_LAM_ART_ABG_LAGERORT_TAG_' || v_mengeneinheit_basis,            -- STAT_NAME	VARCHAR2(200)	N			Name der Statistik z.B. HUF_DW_STATISITIK
                                                        sysdate,                          -- ERFASST_AM	TIMESTAMP(6)	N			Zeitpunkt der Erfassung
                                                        v_lgr_ort,                        -- LGR_ORT	NUMBER(5)	Y			Lagerort
                                                        v_artikel_id,                     -- ARTIKEL_ID	NUMBER	Y			Artikel
                                                        null,                             -- LEITZAHL	NUMBER	Y			Leitzahl
                                                        v_ag,                             -- FA_AG	NUMBER	Y			Arbeitsgang
                                                        null,                             -- CHARGE_ID	NUMBER	Y			Chargen-Nr.
                                                        null,                             -- MHD	DATE	Y			Mindest-Haltbarkeits-Datum
                                                        null,                             -- LABOR_STATUS	CHAR(1)	Y			Laborstatus
                                                        null,                             -- LTE_NAME	VARCHAR2(15)	Y			Beschreibung / Text des LTE
                                                        null,                             -- LTE_STATUS	VARCHAR2(2)	Y			Status der LTE (z.B. LF)
                                                        v_menge,                          -- SUM_MENGE	NUMBER	Y			Anzahl der Teile
                                                        v_anz_lam,                        -- ANZ_LAM	NUMBER	Y			Anzahl der Behälter
                                                        null,                             -- ANZ_LTE	NUMBER(10,4)	Y			Anzahl der LTEs. Bei Mischpal. z.B. zwei Artikel auf einer LTE SUM_LTE = 0,5
                                                        null,                             -- BASIS_LTE_NAME Y    Basistyp der LTE
                                                        in_wert_datum,                    -- WERT_DATUM	DATE	Y			Wert Datum nicht verwechseln mit Erfasst_am
                                                        null,                             -- WERT_DATUM	DATE_ENDE	Y	Wert Datum ende falls eine Zeitraum von Buchungen gemeint sind
                                                        v_menge_basis,                    -- MENGE_BASIS	VARCHAR2(3)	Y			LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit
                                                        v_mengeneinheit_basis );           -- MENGENEINHEIT_BASIS	VARCHAR2(10)	Y			Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE
                end if;

            end loop;

            close c_lam_bh_hist;
        exception
      -- Im Fehlerfall is der Fehler bereits gesetzt.
            when others then
                rollback;
                if c_lam_bh%isopen then
                    close c_lam_bh;
                end if;
                v_error_code := sqlcode;
                v_error_message := substr(sqlerrm, 1, 800);
                isi_p_log.c_isi_system_meldung('01', 1, 'LVS_DW_JOB', 'ORA-DB', 'dw.set_lvs_lam_bh_abg_menge_tag',
                                               null, null, null, null, v_error_code,
                                               'Exception: ' || v_error_message, 'EL');

        end;

        isi_p_log.c_isi_system_meldung('01', 1, 'LVS_DW_JOB', 'ORA-DB', 'dw.set_lvs_lam_bh_abg_menge_tag',
                                       null, null, null, null, null,
                                       'fertig', 'IL');

    end;
  -- Schreibt LAM-Abg.-Mengen je tag und Artikel / AG Von bis Datum
    procedure c_set_lvs_lam_bh_abgtag_v_b (
        in_sid            in dw_lvs_bestand.sid%type,
        in_firma_nr       in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort        in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum_von in dw_lvs_bestand.wert_datum%type,
        in_wert_datum_bis in dw_lvs_bestand.wert_datum%type
    ) is
        v_datum date;
    begin
    -- Call the procedure
        v_datum := trunc(in_wert_datum_von);
        loop
            c_set_lvs_lam_bh_abgangtag(in_sid, in_firma_nr, in_lgr_ort, v_datum);
            v_datum := v_datum + 1;
            exit when v_datum > trunc(in_wert_datum_bis);
        end loop;

    end;

end dw;
/


-- sqlcl_snapshot {"hash":"bff1c8524678ea7a68ff6dcabd25fe27dd289dec","type":"PACKAGE_BODY","name":"DW","schemaName":"DIRKSPZM32","sxml":""}