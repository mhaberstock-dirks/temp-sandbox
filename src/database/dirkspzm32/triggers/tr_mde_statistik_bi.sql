create or replace editionable trigger dirkspzm32.tr_mde_statistik_bi before
    insert on dirkspzm32.mde_statistik
    for each row
declare
    v_merk_leitzahl bde_fa_auftrag.leitzahl%type;
    v_mde_statistik mde_statistik%rowtype;
    v_res_zust_akt  isi_resource_zust_akt%rowtype;
    v_bde_pd_prod   bde_pd_prod%rowtype;
    v_mde_cfg       mde_cfg%rowtype;
    v_fa_auftrag    bde_fa_auftrag%rowtype;
    v_schrott_mg    number;
    v_vorg_id       number;
    v_found         boolean;
    cursor c_mde_statistik is
    select
        ms.*
    from
        mde_statistik ms
    where
            ms.leitzahl = :new.leitzahl
        and ms.fa_ag = :new.fa_ag
        and ms.datum < :new.datum
    order by
        ms.datum desc;

    cursor c_res_zus_akt is
    select
        t.*
    from
        isi_resource          r,
        isi_resource_zust_akt t
    where
            r.res_ext_name = :new.name
        and t.sid = :new.sid
        and t.res_id = r.res_id;

    cursor c_bde_pd_prod is
    select
        *
    from
        bde_pd_prod p
    where
            p.vorg_typ = 'PP'
        and p.leitzahl = :new.leitzahl
        and p.prod_ende = trunc(:new.datum,
                                'HH24')
        and p.res_id = v_res_zust_akt.res_id;

    cursor c_fa_auftrag is
    select
        *
    from
        bde_fa_auftrag fa
    where
            fa.sid = :new.sid
        and fa.firma_nr = :new.firma_nr
        and fa.leitzahl = :new.leitzahl
        and fa.fa_ag = :new.fa_ag
        and fa.fa_upos = :new.fa_upos;

    cursor c_mde_cfg is
    select
        *
    from
        mde_cfg cfg
    where
        cfg.res_id = v_res_zust_akt.res_id;

begin
    open c_res_zus_akt;
    fetch c_res_zus_akt into v_res_zust_akt;
    close c_res_zus_akt;
    v_merk_leitzahl := nvl(:new.leitzahl,
                           -1);
    :new.leitzahl := v_res_zust_akt.leitzahl;
    :new.fa_ag := v_res_zust_akt.fa_ag;
    :new.fa_upos := v_res_zust_akt.fa_upos;
    if :new.leitzahl > 0 then
        if
            ( :new.delta_zaehler_2 < 0
            or :new.zaehler_2 > :new.zaehler_3 )
            and :new.zaehler_2 != 0
        then
            open c_mde_statistik;
            fetch c_mde_statistik into v_mde_statistik;
            close c_mde_statistik;
            :new.delta_zaehler_2 := :new.zaehler_2 - nvl(v_mde_statistik.zaehler_2, 0);

            if :new.delta_zaehler_2 < 0
            or :new.delta_zaehler_2 > :new.delta_zaehler_3 * 2 then
                :new.delta_zaehler_2 := :new.delta_zaehler_3;
            else
                if
                    :new.zaehler_2 = :new.delta_zaehler_2
                    and nvl(v_mde_statistik.zaehler_2, 0) = 0
                    and :new.delta_zaehler_3 = 0
                then
                    :new.delta_zaehler_2 := :new.delta_zaehler_3;
                    :new.zaehler_2 := :new.zaehler_3;
                end if;
            end if;

        end if;
    end if;
  -- Falscher FA im MDE-Server --> Dann für aktuellen FA im MDE Speichern und Message an MDE-Server
    if v_merk_leitzahl <> v_res_zust_akt.leitzahl
    or nvl(v_res_zust_akt.leitzahl, 0) > 0 then
        open c_fa_auftrag;
        fetch c_fa_auftrag into v_fa_auftrag;
        close c_fa_auftrag;
        if
            nvl(v_res_zust_akt.leitzahl, 0) != 0
            and v_fa_auftrag.anz_res = 1
        then
            update bde_fa_auftrag t
            set
                t.mde_ist_mg = :new.zaehler_2,
                t.mde_ist_mg_t = :new.zaehler_3
            where
                    t.sid = v_res_zust_akt.sid
                and t.firma_nr = v_res_zust_akt.firma_nr
                and t.leitzahl = v_res_zust_akt.leitzahl
                and t.fa_ag = v_res_zust_akt.fa_ag
                and nvl(t.fa_upos, 0) = nvl(v_res_zust_akt.fa_upos, 0);

        end if;

    end if;

    if c.c_true = isi_allg.get_firma_cfg_param(:new.sid,                                -- in_sid                   in isi_firma_cfg.sid%type,
                                               :new.firma_nr,                           -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                               'CFG',                                   -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                               null,                                    -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                               'BDE_ADD_MDE_SCHROTT',                   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                               'MDE',                                   -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG',                                   -- in_typ                   in isi_firma_cfg.typ%type,
                                               'F',                                     -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'BOOLEAN')                               -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type
                                                then
        v_schrott_mg := 0;
        open c_mde_cfg;
        fetch c_mde_cfg into v_mde_cfg;
        close c_mde_cfg;
        if v_mde_cfg.fkt_zaehler_0 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_0;
        end if;

        if v_mde_cfg.fkt_zaehler_1 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_1;
        end if;

        if v_mde_cfg.fkt_zaehler_2 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_2;
        end if;

        if v_mde_cfg.fkt_zaehler_3 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_3;
        end if;

        if v_mde_cfg.fkt_zaehler_4 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_4;
        end if;

        if v_mde_cfg.fkt_zaehler_5 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_5;
        end if;

        if v_mde_cfg.fkt_zaehler_6 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_6;
        end if;

        if v_mde_cfg.fkt_zaehler_7 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_7;
        end if;

        if v_mde_cfg.fkt_zaehler_8 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_8;
        end if;

        if v_mde_cfg.fkt_zaehler_9 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_9;
        end if;

        if v_mde_cfg.fkt_zaehler_10 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_10;
        end if;

        if v_mde_cfg.fkt_zaehler_11 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_11;
        end if;

        if v_mde_cfg.fkt_zaehler_12 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_12;
        end if;

        if v_mde_cfg.fkt_zaehler_13 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_13;
        end if;

        if v_mde_cfg.fkt_zaehler_14 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_14;
        end if;

        if v_mde_cfg.fkt_zaehler_15 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_15;
        end if;

        if v_mde_cfg.fkt_zaehler_16 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_16;
        end if;

        if v_mde_cfg.fkt_zaehler_17 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_17;
        end if;

        if v_mde_cfg.fkt_zaehler_18 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_18;
        end if;

        if v_mde_cfg.fkt_zaehler_19 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_19;
        end if;

        if v_mde_cfg.fkt_zaehler_20 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_20;
        end if;

        if v_mde_cfg.fkt_zaehler_21 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_21;
        end if;

        if v_mde_cfg.fkt_zaehler_22 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_22;
        end if;

        if v_mde_cfg.fkt_zaehler_23 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_23;
        end if;

        if v_mde_cfg.fkt_zaehler_24 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_24;
        end if;

        if v_mde_cfg.fkt_zaehler_25 = 4 then
            v_schrott_mg := v_schrott_mg + :new.delta_zaehler_25;
        end if;

        open c_bde_pd_prod;
        fetch c_bde_pd_prod into v_bde_pd_prod;
        v_found := c_bde_pd_prod%found;
        close c_bde_pd_prod;
        if v_schrott_mg > 0 then
            if v_found then
                update bde_pd_prod p
                set
                    p.schrott = p.schrott + v_schrott_mg
                where
                        p.vorg_typ = 'PP'
                    and p.leitzahl = :new.leitzahl
                    and p.prod_ende = trunc(:new.datum,
                                            'HH24')
                    and p.res_id = v_res_zust_akt.res_id;

            else
                select
                    seq_vorg_id.nextval
                into v_vorg_id
                from
                    dual;

                insert into bde_pd_prod values ( :new.sid,                       -- SID           VARCHAR2(2) not null,
                                                 v_vorg_id,                      -- VORG_ID       NUMBER not null,
                                                 'PP',                           -- VORG_TYP      VARCHAR2(2) not null,
                                                 :new.firma_nr,                  -- FIRMA_NR      NUMBER(2) not null,
                                                 :new.leitzahl,                  -- LEITZAHL      NUMBER not null,
                                                 :new.fa_ag,                     -- FA_AG         NUMBER not null,
                                                 :new.fa_upos,                   -- FA_UPOS       NUMBER,
                                                 null,                           -- ABNR          VARCHAR2(20),
                                                 v_res_zust_akt.res_id,          -- RES_ID        NUMBER not null,
                                                 trunc(:new.datum,
                                                       'HH24'),      -- PROD_BEGINN   DATE not null,
                                                 trunc(:new.datum,
                                                       'HH24'),      -- PROD_ENDE     DATE,
                                                 0,                              -- PERS_NR       NUMBER,
                                                 null,                           -- LAM_ID        NUMBER,
                                                 null,                           -- ARTIKEL_ID    NUMBER,
                                                 0,                              -- MENGE_A       NUMBER,
                                                 0,                              -- MENGE_B       NUMBER,
                                                 v_schrott_mg,                   -- SCHROTT       NUMBER,
                                                 0,                              -- LS_LOGIN_ID   NUMBER,
                                                 0,                             -- PD_NETTO_ZEIT NUMBER
                                                 v_res_zust_akt.abfuell_abschalt_grob,
                                                 v_res_zust_akt.abfuell_abschalt_mittel,
                                                 v_res_zust_akt.abfuell_abschalt_fein,
                                                 v_res_zust_akt.abfuell_toleranz_plus,
                                                 v_res_zust_akt.abfuell_toleranz_minus,
                                                 v_res_zust_akt.abfuell_silo,
                                                 v_res_zust_akt.abfuell_soll,
                                                 v_res_zust_akt.abfuell_ist,
                                                 v_res_zust_akt.prod_params,
                                                 null,
                                                 null,
                                                 null,
                                                 null );

            end if;

            update bde_fa_auftrag a
            set
                a.ag_ist_mg_schrott = a.ag_ist_mg_schrott + v_schrott_mg
            where
                    a.leitzahl = :new.leitzahl
                and a.fa_ag = :new.fa_ag
                and a.fa_upos = nvl(:new.fa_upos,
                                    0);

        end if;

    end if;

end tr_mde_statistik_bi;
/

alter trigger dirkspzm32.tr_mde_statistik_bi enable;


-- sqlcl_snapshot {"hash":"9a175153c49ef421fe8349e8586fb219c080d556","type":"TRIGGER","name":"TR_MDE_STATISTIK_BI","schemaName":"DIRKSPZM32","sxml":""}