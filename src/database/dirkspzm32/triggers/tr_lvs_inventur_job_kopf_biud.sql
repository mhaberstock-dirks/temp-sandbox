create or replace editionable trigger dirkspzm32.tr_lvs_inventur_job_kopf_biud before
    insert or update or delete on dirkspzm32.lvs_inventur_job_kopf
    for each row
declare

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr                     number;
    v_err_text                   varchar2(255);
    v_lgr                        lvs_lgr%rowtype;
    v_lgr_ort                    lvs_lgr_ort%rowtype;
    v_lam                        lvs_lam%rowtype;
    v_lam_delete_pos             lvs_lam%rowtype;
    v_artikel_id                 lvs_inventur_job_kopf.artikel_id%type;
    v_fa_ag                      lvs_inventur_job_kopf.fa_ag%type;
    v_lgr_platz                  lvs_lgr.lgr_platz%type;
    v_lgr_platz_inv_id           lvs_lgr.akt_inventur_id%type;
    v_lam_inv_id                 lvs_lam.akt_inventur_id%type;
    v_inventur_pk_id             lvs_inventur_job_pos.inventur_pk_id%type;
    v_geschaefts_jahr_beg        date;
    v_geschaefts_jahr_startdatum date;
    v_geschaefts_jahr_endedatum  date;
    v_lte_id                     lvs_lte.lte_id%type;
    v_menge                      number;
    v_dieseinventur              number;
    v_falscheinventur            number;
    cursor c_lgr_platz is
    select
        *
    from
        lvs_lgr l
    where
            l.lgr_ort = :new.lgr_ort
        and l.lgr_dim_g >= :new.lgr_dim_g_von
        and l.lgr_dim_g <= :new.lgr_dim_g_bis
        and l.lgr_dim_r >= :new.lgr_dim_r_von
        and l.lgr_dim_r <= :new.lgr_dim_r_bis
        and l.lgr_dim_p >= :new.lgr_dim_p_von
        and l.lgr_dim_p <= :new.lgr_dim_p_bis
        and l.lgr_dim_e >= :new.lgr_dim_e_von
        and l.lgr_dim_e <= :new.lgr_dim_e_bis
        and l.lgr_dim_t >= :new.lgr_dim_t_von
        and l.lgr_dim_t <= :new.lgr_dim_t_bis;

    cursor c_lgr_platz_count is
    select
        l.lgr_platz,
        l.akt_inventur_id
    from
        lvs_lgr l
    where
            l.lgr_ort = :new.lgr_ort
        and l.lgr_dim_g >= :new.lgr_dim_g_von
        and l.lgr_dim_g <= :new.lgr_dim_g_bis
        and l.lgr_dim_r >= :new.lgr_dim_r_von
        and l.lgr_dim_r <= :new.lgr_dim_r_bis
        and l.lgr_dim_p >= :new.lgr_dim_p_von
        and l.lgr_dim_p <= :new.lgr_dim_p_bis
        and l.lgr_dim_e >= :new.lgr_dim_e_von
        and l.lgr_dim_e <= :new.lgr_dim_e_bis
        and l.lgr_dim_t >= :new.lgr_dim_t_von
        and l.lgr_dim_t <= :new.lgr_dim_t_bis
        and l.akt_inventur_id is not null;

    cursor c_lgr_aus_ort is
    select
        *
    from
        lvs_lgr l
    where
        l.lgr_ort = :new.lgr_ort;

    cursor c_lgr_ort is
    select
        *
    from
        lvs_lgr_ort l
    where
        l.lgr_ort = :new.lgr_ort;

    cursor c_lam is
    select
        l.*
    from
        lvs_lam         l,
        lvs_lte         lte,
          -- MWe 20190103 Ticket E20WMS-19
         (
            lvs_lgr         lgr
            left join lvs_lgr_ort_cfg loc on ( lgr.lgr_ort = loc.lgr_ort
                                               and loc.lgr_ort_cfg_param = 'INV_PRUEF' )
        )
        left join lvs_lgr_cfg     lgc on ( lgr.lgr_platz = lgc.lgr_platz
                                       and lgc.lgr_platz_cfg_param = 'INV_PRUEF' )
    where
            1 = 1
        and l.lgr_platz = v_lgr.lgr_platz
        and l.lte_id = lte.lte_id
        and lte.akt_inventur_id is null
        and lte.lte_status in ( 'LF', 'BS', 'BF', 'AF' )
       -- MWe 20190103 Ticket E20WMS-19
        and lgr.lgr_platz = l.lgr_platz
        and ( lgc.lgr_platz_cfg_param_wert = 'T'
              or ( lgc.lgr_platz_cfg_param_wert is null
                   and ( loc.lgr_ort_cfg_param_default = 'T'
                         or loc.lgr_ort_cfg_param_default is null ) ) );

    cursor c_lam_art is
    select
        l.*
    from
        lvs_lam         l,
        lvs_lte         lte,
          -- MWe 20190103 Ticket E20WMS-15
         (
            lvs_lgr         lgr
            left join lvs_lgr_ort_cfg loc on ( lgr.lgr_ort = loc.lgr_ort
                                               and loc.lgr_ort_cfg_param = 'INV_PRUEF' )
        )
        left join lvs_lgr_cfg     lgc on ( lgr.lgr_platz = lgc.lgr_platz
                                       and lgc.lgr_platz_cfg_param = 'INV_PRUEF' )
    where
            l.artikel_id = v_artikel_id
        and nvl(l.fa_ag, -1) = nvl(v_fa_ag,
                                   nvl(l.fa_ag, -1))
        and l.lte_id = lte.lte_id
        and lte.akt_inventur_id is null
        and lte.lte_status in ( 'LF', 'BS', 'BF', 'AF' )
       -- MWe 20190103 Ticket E20WMS-15
        and lgr.lgr_platz = l.lgr_platz
        and ( lgc.lgr_platz_cfg_param_wert = 'T'
              or ( lgc.lgr_platz_cfg_param_wert is null
                   and ( loc.lgr_ort_cfg_param_default = 'T'
                         or loc.lgr_ort_cfg_param_default is null ) ) );

    cursor c_lam_alle is
    select
        l.*
    from
        lvs_lam l,
        lvs_lte lte
    where
        l.lgr_platz is not null
        and l.lte_id = lte.lte_id
        and lte.akt_inventur_id is null
        and lte.lte_status in ( 'LF', 'BS', 'BF', 'AF' );

    cursor c_lam_alle_count is
    select
        l.akt_inventur_id
    from
        lvs_lam l,
        lvs_lte lte
    where
        l.akt_inventur_id is not null
        and l.lgr_platz is not null
        and l.lte_id = lte.lte_id
        and lte.akt_inventur_id is null
        and lte.lte_status in ( 'LF', 'BS', 'BF', 'AF' );

    cursor c_lam_getallbyproperties is
    select
        lam.*
    from
        lvs_lam         lam,
        isi_artikel     a,
        lvs_lte         lte,
           -- MWe 20190103 Ticket E20WMS-15
         (
            lvs_lgr         lgr
            left join lvs_lgr_ort_cfg loc on ( lgr.lgr_ort = loc.lgr_ort
                                               and loc.lgr_ort_cfg_param = 'INV_PRUEF' )
        )
        left join lvs_lgr_cfg     lgc on ( lgr.lgr_platz = lgc.lgr_platz
                                       and lgc.lgr_platz_cfg_param = 'INV_PRUEF' )
    where
            lte.lte_id = lam.lte_id
        and lte.akt_inventur_id is null
        and a.artikel_id = lam.artikel_id
        and lgr.lgr_platz = lam.lgr_platz
        and a.artikel >= nvl(:new.von_artikel,
                             ' ')
        and a.artikel <= nvl(:new.bis_artikel,
                             'ß')
        and ( lgr.lgr_ort >= :new.von_lagerort
              or :new.von_lagerort is null )
        and ( lgr.lgr_ort <= :new.bis_lagerort
              or :new.bis_lagerort is null )
        and lam.menge between nvl(:new.von_menge,
                                  lam.menge) and nvl(:new.bis_menge,
                                                     lam.menge)
        and lam.lte_id >= nvl(:new.von_transporteinheit,
                              lam.lte_id)
        and lam.lte_id <= nvl(:new.bis_transporteinheit,
                              lam.lte_id)
        and lam.zug_datum >= nvl(:new.von_datum,
                                 lam.zug_datum)
        and lam.zug_datum <= nvl(:new.bis_datum,
                                 lam.zug_datum)
        and nvl(lte.letzte_inventur_datum, to_date('01.01.0001', 'DD.MM.YYYY')) not between v_geschaefts_jahr_startdatum and v_geschaefts_jahr_endedatum
        and lte.order_vorgang_id is null
            -- MWe 20190103 Ticket E20WMS-15
        and ( lgc.lgr_platz_cfg_param_wert = 'T'
              or ( lgc.lgr_platz_cfg_param_wert is null
                   and ( loc.lgr_ort_cfg_param_default = 'T'
                         or loc.lgr_ort_cfg_param_default is null ) ) );

    v_found                      boolean;
begin
  -- Init Fehlervariablen
    v_err_nr := null;
    v_err_text := null;
    if inserting then
        if :new.inv_type = 'Artikel' then
            if not lvs_p_inventur.artikel_fuer_inventur_da(:new.sid,
                                                           :new.firma_nr,
                                                           :new.artikel_id,
                                                           null,
                                                           :new.fa_ag,
                                                           null,
                                                           null) then
                v_err_nr := 5;
                v_err_text := 'Fehler: Für den ausgewählten Artikel ist kein Lagerbestand verfügbar. Die Inventur kann nicht angelegt werden.'
                ;
                raise v_error;
            end if;
        end if;

        select
            seq_inventur.nextval
        into :new.inventur_id
        from
            dual;

    end if;

    if updating
    or inserting then
        if updating then
            if
                :old.inv_status = 'I'
                and :new.inv_status = 'I'
            then
                return;
            end if;
        end if;

        if :new.inv_status = 'I' -- Inventur begonnen

         then
            :new.ist_start_datum := sysdate;
            if :new.inv_type = 'Gesamt' then
                open c_lam_alle_count;
                fetch c_lam_alle_count into v_lam_inv_id;
                v_found := c_lam_alle_count%found;
                close c_lam_alle_count;
                if v_found then
                    v_err_nr := 10;
                    v_err_text := 'Fehler: Es sind noch Mengen mit Inventur '
                                  || v_lam_inv_id
                                  || ' aktiv. Aktivierung nicht möglich.';
                    raise v_error;
                end if;

                open c_lam_alle;
                fetch c_lam_alle into v_lam;
                loop
                    exit when c_lam_alle%notfound;
                    select
                        seq_lvs_inventur_pos_pk_id.nextval
                    into v_inventur_pk_id
                    from
                        dual;

                    insert into lvs_inventur_job_pos values ( :new.sid,              -- SID              VARCHAR2(2) not null,
                                                              :new.firma_nr,         -- FIRMA_NR         NUMBER not null,
                                                              :new.inventur_id,      -- INVENTUR_ID      NUMBER not null,
                                                              v_lam.lgr_platz,       -- LGR_PLATZ        VARCHAR2(30) not null,
                                                              v_lam.lam_id,          -- LAM_ID           NUMBER not null,
                                                              null,                  -- PRUEF_DATUM      DATE,
                                                              null,                  -- PRUEF_LOGIN_ID   NUMBER,
                                                              null,                  -- IST_MENGE        NUMBER,
                                                              v_lam.menge,           -- LETZTE_MENGE_LAM NUMBER
                                                              v_inventur_pk_id );     -- INVENTUR_PK_ID NUMBER
                    fetch c_lam_alle into v_lam;
                end loop;

                close c_lam_alle;
                update lvs_lgr_ort l
                set
                    l.akt_inventur_id = :new.inventur_id
                where
                    l.akt_inventur_id is null;

            elsif :new.inv_type = 'Lagerort' then
                v_lgr_ort := null;
                open c_lgr_ort;
                fetch c_lgr_ort into v_lgr_ort;
                close c_lgr_ort;
                if v_lgr_ort.akt_inventur_id is not null then
                    v_err_nr := 20;
                    v_err_text := 'Fehler: Der Lagerort '
                                  || :new.lgr_ort
                                  || ' ist bereits in Inventur.';
                    raise v_error;
                end if;

                open c_lgr_aus_ort;
                fetch c_lgr_aus_ort into v_lgr;
                loop
                    exit when c_lgr_aus_ort%notfound;
                    if v_lgr.akt_inventur_id is not null then
                        v_err_nr := 21;
                        v_err_text := 'Fehler: Der Lagerplatz '
                                      || v_lgr.lgr_platz
                                      || ' ist bereits in Inventur.';
                        raise v_error;
                    end if;

                    open c_lam;
                    fetch c_lam into v_lam;
                    if c_lam%notfound then
                        select
                            seq_lvs_inventur_pos_pk_id.nextval
                        into v_inventur_pk_id
                        from
                            dual;

                        insert into lvs_inventur_job_pos values ( :new.sid,              -- SID              VARCHAR2(2) not null,
                                                                  :new.firma_nr,         -- FIRMA_NR         NUMBER not null,
                                                                  :new.inventur_id,      -- INVENTUR_ID      NUMBER not null,
                                                                  v_lgr.lgr_platz,       -- LGR_PLATZ        VARCHAR2(30) not null,
                                                                  null,                  -- LAM_ID           NUMBER not null,
                                                                  null,                  -- PRUEF_DATUM      DATE,
                                                                  null,                  -- PRUEF_LOGIN_ID   NUMBER,
                                                                  null,                  -- IST_MENGE        NUMBER,
                                                                  0,           -- LETZTE_MENGE_LAM NUMBER
                                                                  v_inventur_pk_id );     -- INVENTUR_PK_ID NUMBER
                    else
                        loop
                            exit when c_lam%notfound;
                            select
                                seq_lvs_inventur_pos_pk_id.nextval
                            into v_inventur_pk_id
                            from
                                dual;

                            insert into lvs_inventur_job_pos values ( :new.sid,              -- SID              VARCHAR2(2) not null,
                                                                      :new.firma_nr,         -- FIRMA_NR         NUMBER not null,
                                                                      :new.inventur_id,      -- INVENTUR_ID      NUMBER not null,
                                                                      v_lam.lgr_platz,       -- LGR_PLATZ        VARCHAR2(30) not null,
                                                                      v_lam.lam_id,          -- LAM_ID           NUMBER not null,
                                                                      null,                  -- PRUEF_DATUM      DATE,
                                                                      null,                  -- PRUEF_LOGIN_ID   NUMBER,
                                                                      null,                  -- IST_MENGE        NUMBER,
                                                                      v_lam.menge,           -- LETZTE_MENGE_LAM NUMBER
                                                                      v_inventur_pk_id );     -- INVENTUR_PK_ID NUMBER
                            fetch c_lam into v_lam;
                        end loop;
                    end if;

                    close c_lam;
                    fetch c_lgr_aus_ort into v_lgr;
                end loop;

                close c_lgr_aus_ort;
                update lvs_lgr_ort l
                set
                    l.akt_inventur_id = :new.inventur_id
                where
                        l.lgr_ort = :new.lgr_ort
                    and l.akt_inventur_id is null;

            elsif :new.inv_type = 'Lagerplatz' then
                open c_lgr_platz_count;
                fetch c_lgr_platz_count into
                    v_lgr_platz,
                    v_lgr_platz_inv_id;
                v_found := c_lgr_platz_count%found;
                close c_lgr_platz_count;
                if v_found then
                    v_err_nr := 30;
                    v_err_text := 'Fehler: Es sind noch Plätze  mit Inventur '
                                  || v_lgr_platz_inv_id
                                  || ' aktiv! Aktivierung nicht möglich.';
                    raise v_error;
                end if;

                open c_lgr_platz;
                fetch c_lgr_platz into v_lgr;
                loop
                    exit when c_lgr_platz%notfound;
                    if v_lgr.akt_inventur_id is not null then
                        v_err_nr := 31;
                        v_err_text := 'Fehler: Der Lagerplatz '
                                      || v_lgr.lgr_platz
                                      || ' ist bereits in Inventur.';
                        raise v_error;
                    end if;

                    open c_lam;
                    fetch c_lam into v_lam;
                    if c_lam%notfound then
                        select
                            seq_lvs_inventur_pos_pk_id.nextval
                        into v_inventur_pk_id
                        from
                            dual;

                        insert into lvs_inventur_job_pos values ( :new.sid,              -- SID              VARCHAR2(2) not null,
                                                                  :new.firma_nr,         -- FIRMA_NR         NUMBER not null,
                                                                  :new.inventur_id,      -- INVENTUR_ID      NUMBER not null,
                                                                  v_lgr.lgr_platz,       -- LGR_PLATZ        VARCHAR2(30) not null,
                                                                  null,                  -- LAM_ID           NUMBER not null,
                                                                  null,                  -- PRUEF_DATUM      DATE,
                                                                  null,                  -- PRUEF_LOGIN_ID   NUMBER,
                                                                  null,                  -- IST_MENGE        NUMBER,
                                                                  0,           -- LETZTE_MENGE_LAM NUMBER
                                                                  v_inventur_pk_id );     -- INVENTUR_PK_ID NUMBER
                    else
                        loop
                            exit when c_lam%notfound;
                            select
                                seq_lvs_inventur_pos_pk_id.nextval
                            into v_inventur_pk_id
                            from
                                dual;

                            insert into lvs_inventur_job_pos values ( :new.sid,              -- SID              VARCHAR2(2) not null,
                                                                      :new.firma_nr,         -- FIRMA_NR         NUMBER not null,
                                                                      :new.inventur_id,      -- INVENTUR_ID      NUMBER not null,
                                                                      v_lam.lgr_platz,       -- LGR_PLATZ        VARCHAR2(30) not null,
                                                                      v_lam.lam_id,          -- LAM_ID           NUMBER not null,
                                                                      null,                  -- PRUEF_DATUM      DATE,
                                                                      null,                  -- PRUEF_LOGIN_ID   NUMBER,
                                                                      null,                  -- IST_MENGE        NUMBER,
                                                                      v_lam.menge,           -- LETZTE_MENGE_LAM NUMBER
                                                                      v_inventur_pk_id );     -- INVENTUR_PK_ID NUMBER
                            fetch c_lam into v_lam;
                        end loop;
                    end if;

                    close c_lam;
                    fetch c_lgr_platz into v_lgr;
                end loop;

                close c_lgr_platz;
                update lvs_lgr l
                set
                    l.akt_inventur_id = :new.inventur_id
                where
                        l.lgr_ort = :new.lgr_ort
                    and l.lgr_dim_g >= :new.lgr_dim_g_von
                    and l.lgr_dim_g <= :new.lgr_dim_g_bis
                    and l.lgr_dim_r >= :new.lgr_dim_r_von
                    and l.lgr_dim_r <= :new.lgr_dim_r_bis
                    and l.lgr_dim_p >= :new.lgr_dim_p_von
                    and l.lgr_dim_p <= :new.lgr_dim_p_bis
                    and l.lgr_dim_e >= :new.lgr_dim_e_von
                    and l.lgr_dim_e <= :new.lgr_dim_e_bis
                    and l.lgr_dim_t >= :new.lgr_dim_t_von
                    and l.lgr_dim_t <= :new.lgr_dim_t_bis
                    and l.akt_inventur_id is null;

            elsif :new.inv_type = 'Artikel' then
                lvs_p_inventur.set_artikel_akt_inventur_id(:new.sid,
                                                           :new.firma_nr,
                                                           :new.artikel_id,
                                                           null,
                                                           :new.fa_ag,
                                                           :new.inventur_id);

                v_artikel_id := :new.artikel_id;
                v_fa_ag := :new.fa_ag;
        -- leitzahl?
        -- zeichnung_index?

                open c_lam_art;
                fetch c_lam_art into v_lam;
                loop
                    exit when c_lam_art%notfound;
                    select
                        seq_lvs_inventur_pos_pk_id.nextval
                    into v_inventur_pk_id
                    from
                        dual;

                    insert into lvs_inventur_job_pos values ( :new.sid,              -- SID              VARCHAR2(2) not null,
                                                              :new.firma_nr,         -- FIRMA_NR         NUMBER not null,
                                                              :new.inventur_id,      -- INVENTUR_ID      NUMBER not null,
                                                              v_lam.lgr_platz,       -- LGR_PLATZ        VARCHAR2(30) not null,
                                                              v_lam.lam_id,          -- LAM_ID           NUMBER not null,
                                                              null,                  -- PRUEF_DATUM      DATE,
                                                              null,                  -- PRUEF_LOGIN_ID   NUMBER,
                                                              null,                  -- IST_MENGE        NUMBER,
                                                              v_lam.menge,           -- LETZTE_MENGE_LAM NUMBER
                                                              v_inventur_pk_id );     -- INVENTUR_PK_ID NUMBER
                    fetch c_lam_art into v_lam;
                end loop;

                close c_lam_art;
            elsif :new.inv_type = 'TransportUnit' then
        -- ALLG_FIRMA_GESCHAEFTSJAHR_BEG
                v_geschaefts_jahr_beg := to_date ( isi_allg.c_get_firma_cfg_param(:new.sid,              -- in_default_param_typ
                                                                                  :new.firma_nr,         -- in isi_firma_cfg.parameter_typ%type,
                                                                                  'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                                                  null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                                                  'ALLG_FIRMA_GESCHAEFTSJAHR_BEG', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                                  'Allgemein',           -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                                  'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                                                  '01.01.',              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                                  'STRING')
                                                   || to_char(sysdate, 'YYYY'),
                'DD.MM.YYYY' );

                if ( sysdate < v_geschaefts_jahr_beg ) then
                    v_geschaefts_jahr_endedatum := v_geschaefts_jahr_beg - 1;
                    v_geschaefts_jahr_startdatum := add_months(v_geschaefts_jahr_beg, -12);
                else
                    v_geschaefts_jahr_startdatum := v_geschaefts_jahr_beg;
                    v_geschaefts_jahr_endedatum := add_months(v_geschaefts_jahr_startdatum, 12) - 1;
                end if;

                if :new.von_transporteinheit = :new.bis_transporteinheit then
                    v_geschaefts_jahr_startdatum := v_geschaefts_jahr_endedatum;
                end if;

                open c_lam_getallbyproperties;
                fetch c_lam_getallbyproperties into v_lam;

        -- Init
                v_lte_id := v_lam.lte_id;
                v_menge := v_lam.menge;
                v_artikel_id := v_lam.artikel_id;
                loop
                    exit when c_lam_getallbyproperties%notfound;
                    select
                        seq_lvs_inventur_pos_pk_id.nextval
                    into v_inventur_pk_id
                    from
                        dual;

                    insert into lvs_inventur_job_pos values ( :new.sid,              -- SID              VARCHAR2(2) not null,
                                                              :new.firma_nr,         -- FIRMA_NR         NUMBER not null,
                                                              :new.inventur_id,      -- INVENTUR_ID      NUMBER not null,
                                                              v_lam.lgr_platz,       -- LGR_PLATZ        VARCHAR2(30) not null,
                                                              v_lam.lam_id,          -- LAM_ID           NUMBER not null,
                                                              null,                  -- PRUEF_DATUM      DATE,
                                                              null,                  -- PRUEF_LOGIN_ID   NUMBER,
                                                              null,                  -- IST_MENGE        NUMBER,
                                                              v_lam.menge,           -- LETZTE_MENGE_LAM NUMBER
                                                              v_inventur_pk_id );     -- INVENTUR_PK_ID NUMBER
          -- Hier findet eine Behälterinventur statt, die auch Transportiert werden muss. Daher muss die Invetur-ID aus der LAM entfernt werden
                    fetch c_lam_getallbyproperties into v_lam;
                    if v_lam.lte_id != v_lte_id -- Nur für jede LTE einmal aufrufen
                    or c_lam_getallbyproperties%notfound   -- Letzte LTE noch eintragen
                     then
                        if :new.zaehlungsart = 'TransportAndCounting' then
                            update lvs_lam t
                            set
                                t.akt_inventur_id = null
                            where
                                t.lte_id = v_lte_id;

                            insert into isi_komm_order (
                                sid,
                                firma_nr,
                                p_komm_id,
                                komm_typ,
                                status,
                                modul_erzeuger,
                                modul_bearbeiter,
                                login_id,
                                info_text,
                                freigabe,
                                lte_id,
                                artikel_id,
                                menge
                            ) values ( :new.sid,                 -- SID der Inventur
                                       :new.firma_nr,            -- Firma (Mandant der Inventur)
                                       :new.inventur_id,         -- Inventur-ID als Klammer/Ausloeser eintragen
                                       'MV',                     -- Menge Validieren
                                       'N',                      -- Eintrag ist neu
                                       'INV',                    -- Modulerzeiger
                                       'KOMM',                   -- Module Bearbeiter ist KOMMissionierung
                                       :new.erstellt_login_id,  -- LOGIN-ID der Inventurerzeugers
                                       :new.inv_type
                                       || ' INV-ID '
                                       || to_char(:new.inventur_id),-- Inventurinfo im KOMM-DIALOG
                                       'M',                      -- Manuelle Freigabe (Durch Start der Inventur)
                                       v_lte_id,                 -- LTE-ID Eintragen
                                       v_artikel_id,             -- Artikel eintragen
                                       v_menge );

                            update lvs_lte l
                            set
                                l.akt_inventur_id = :new.inventur_id
                            where
                                l.akt_inventur_id is null
                                and l.lte_id = v_lte_id;

                        end if;

                        v_artikel_id := v_lam.artikel_id;
                        v_lte_id := v_lam.lte_id;
                        v_menge := 0;
                    end if;

                    v_menge := v_menge + v_lam.menge;
                end loop;

                close c_lam_getallbyproperties;
            end if;

        elsif :new.inv_status = 'F' -- Fertig

         then
            :new.ist_ende_datum := sysdate;

      -- Je nach Typ muss aus der richtigen LVS-Tabelle der Inventureintrag rausgenommen werden
            if :new.inv_type = 'Gesamt' then
                update lvs_lgr_ort l
                set
                    l.akt_inventur_id = null,
                    l.letzte_inventur_id = :new.inventur_id,
                    l.letzte_inventur_datum = :new.ist_ende_datum,
                    l.letzte_inventur_login_id = :new.ist_ende_login_id
                where
                    l.akt_inventur_id = :new.inventur_id;

            elsif :new.inv_type = 'Lagerort' then
                update lvs_lgr_ort l
                set
                    l.akt_inventur_id = null,
                    l.letzte_inventur_id = :new.inventur_id,
                    l.letzte_inventur_datum = :new.ist_ende_datum,
                    l.letzte_inventur_login_id = :new.ist_ende_login_id
                where
                        l.lgr_ort = :new.lgr_ort
                    and l.akt_inventur_id = :new.inventur_id;

            elsif :new.inv_type = 'Lagerplatz' then
                update lvs_lgr l
                set
                    l.akt_inventur_id = null,
                    l.letzte_inventur_id = :new.inventur_id,
                    l.letzte_inventur_datum = :new.ist_ende_datum,
                    l.letzte_inventur_login_id = :new.ist_ende_login_id
                where
                        l.lgr_ort = :new.lgr_ort
                    and l.lgr_dim_g >= :new.lgr_dim_g_von
                    and l.lgr_dim_g <= :new.lgr_dim_g_bis
                    and l.lgr_dim_r >= :new.lgr_dim_r_von
                    and l.lgr_dim_r <= :new.lgr_dim_r_bis
                    and l.lgr_dim_p >= :new.lgr_dim_p_von
                    and l.lgr_dim_p <= :new.lgr_dim_p_bis
                    and l.lgr_dim_e >= :new.lgr_dim_e_von
                    and l.lgr_dim_e <= :new.lgr_dim_e_bis
                    and l.lgr_dim_t >= :new.lgr_dim_t_von
                    and l.lgr_dim_t <= :new.lgr_dim_t_bis
                    and l.akt_inventur_id = :new.inventur_id;

            elsif :new.inv_type = 'Artikel' then
                lvs_p_inventur.set_artikel_letzte_inventur(:new.sid,
                                                           :new.firma_nr,
                                                           :new.artikel_id,
                                                           null,
                                                           :new.fa_ag,
                                                           :new.inventur_id,
                                                           :new.ist_ende_datum,
                                                           :new.ist_ende_login_id,
                                                           'T');
            elsif :new.inv_type = 'TransportUnit' then
                update lvs_lte l
                set
                    l.akt_inventur_id = null,
                    l.letzte_inventur_id = :new.inventur_id,
                    l.letzte_inventur_datum = :new.ist_ende_datum,
                    l.letzte_inventur_login_id = :new.ist_ende_login_id
                where
                        l.akt_inventur_id = :new.inventur_id
                    and exists (
                        select
                            xl.lte_id
                        from
                            lvs_inventur_job_pos x,
                            lvs_lam              xl
                        where
                                x.lam_id = xl.lam_id
                            and xl.lte_id = l.lte_id
                            and x.ist_menge is not null
                    );

                update lvs_lte l
                set
                    l.akt_inventur_id = null
                where
                    l.akt_inventur_id = :new.inventur_id;

                update isi_komm_order o
                set
                    o.status = 'KE'
                where
                        o.p_komm_id = :new.inventur_id
                    and o.komm_typ = 'MV'
                    and o.status != 'KE'
                    and o.status != 'Z';

            end if;

      -- Jetzt die noch nicht abgeschlossenen Positionen updaten
            update lvs_inventur_job_pos i
            set
                i.pruef_datum = :new.ist_ende_datum,
                i.pruef_login_id = nvl(i.pruef_login_id,
                                       :new.ist_ende_login_id)
            where
                    i.inventur_id = :new.inventur_id
                and i.pruef_datum is null;

        elsif :new.inv_status = 'A' -- Abgebrochen

         then
       -- Erst mal die noch nicht gezählten Positionen loeschen
            delete lvs_inventur_job_pos i
            where
                i.inventur_id = :new.inventur_id;

      -- Je nach Typ muss aus der richtigen LVS-Tabelle der Inventureintrag rausgenommen werden
            if :new.inv_type = 'Gesamt' then
                update lvs_lgr_ort l
                set
                    l.akt_inventur_id = null
                where
                    l.akt_inventur_id = :new.inventur_id;

            elsif :new.inv_type = 'Lagerort' then
                update lvs_lgr_ort l
                set
                    l.akt_inventur_id = null
                where
                        l.lgr_ort = :new.lgr_ort
                    and l.akt_inventur_id = :new.inventur_id;

            elsif :new.inv_type = 'Lagerplatz' then
                update lvs_lgr l
                set
                    l.akt_inventur_id = null
                where
                        l.lgr_ort = :new.lgr_ort
                    and l.lgr_dim_g >= :new.lgr_dim_g_von
                    and l.lgr_dim_g <= :new.lgr_dim_g_bis
                    and l.lgr_dim_r >= :new.lgr_dim_r_von
                    and l.lgr_dim_r <= :new.lgr_dim_r_bis
                    and l.lgr_dim_p >= :new.lgr_dim_p_von
                    and l.lgr_dim_p <= :new.lgr_dim_p_bis
                    and l.lgr_dim_e >= :new.lgr_dim_e_von
                    and l.lgr_dim_e <= :new.lgr_dim_e_bis
                    and l.lgr_dim_t >= :new.lgr_dim_t_von
                    and l.lgr_dim_t <= :new.lgr_dim_t_bis
                    and l.akt_inventur_id = :new.inventur_id;

            elsif :new.inv_type = 'Artikel' then
                lvs_p_inventur.set_artikel_akt_inventur_id(:new.sid,
                                                           :new.firma_nr,
                                                           :new.artikel_id,
                                                           null,
                                                           :new.fa_ag,
                                                           null); -- Keine Inventur mehr auf dem Artikel
            elsif :new.inv_type = 'TransportUnit' then
                update lvs_lte l
                set
                    l.akt_inventur_id = null,
                    l.letzte_inventur_datum = :new.ist_ende_datum,
                    l.letzte_inventur_login_id = :new.ist_ende_login_id
                where
                    l.akt_inventur_id = :new.inventur_id;

                update isi_komm_order o
                set
                    o.status = 'Z'
                where
                        o.p_komm_id = :new.inventur_id
                    and o.komm_typ = 'MV'
                    and o.status != 'KE';

            end if;

        end if;

    end if; -- inserting or updating
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
        if c_lam_alle%isopen then
            close c_lam_alle;
        end if;
        if c_lgr_aus_ort%isopen then
            close c_lgr_aus_ort;
        end if;
        if c_lam%isopen then
            close c_lam;
        end if;
        if c_lam_art%isopen then
            close c_lam_art;
        end if;
        if c_lgr_platz%isopen then
            close c_lgr_platz;
        end if;
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
    when others then
        if c_lam_alle%isopen then
            close c_lam_alle;
        end if;
        if c_lgr_aus_ort%isopen then
            close c_lgr_aus_ort;
        end if;
        if c_lam%isopen then
            close c_lam;
        end if;
        if c_lam_art%isopen then
            close c_lam_art;
        end if;
        if c_lgr_platz%isopen then
            close c_lgr_platz;
        end if;
        if v_err_nr is not null then
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
        end if;

end;
/

alter trigger dirkspzm32.tr_lvs_inventur_job_kopf_biud enable;


-- sqlcl_snapshot {"hash":"6e4600d7450279b54b97c1b1758093023475c960","type":"TRIGGER","name":"TR_LVS_INVENTUR_JOB_KOPF_BIUD","schemaName":"DIRKSPZM32","sxml":""}