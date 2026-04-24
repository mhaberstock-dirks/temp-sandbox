create or replace package body dirkspzm32.lvs_komm is

    function get_komm_anz_lam_fuer_lte (
        in_sid              in lvs_lam.sid%type,
        in_firma_nr         in lvs_lam.firma_nr%type,
        in_komm_ziel_lte_id in lvs_lam.lte_id%type,
        in_artikel_id       in lvs_lam.artikel_id%type
    ) return number is

        v_result number;
        cursor c_komm_lam_anz is
        select
            count(*)
        from
            lvs_lam t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.artikel_id = in_artikel_id
            and ( t.lte_id = in_komm_ziel_lte_id
                  or t.res_ziel_lte_id = in_komm_ziel_lte_id );

    begin
        open c_komm_lam_anz;
        fetch c_komm_lam_anz into v_result;
        if c_komm_lam_anz%notfound then
            v_result := 0;
        end if;
        close c_komm_lam_anz;
        return ( v_result );
    end;

  --------------------------------------------------------------------------------
  -- procedure LVS_C_KOMM_DIRECT
  --------------------------------------------------------------------------------
    procedure lvs_c_komm_direct (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_user_id       in isi_user.login_id%type,
        in_quelle_lte_id in lvs_lte.lte_id%type,
        in_lam_id        in lvs_lam.lam_id%type,
        in_menge         in lvs_lam.menge%type,
        in_ziel_lte_id   in lvs_lte.lte_id%type
    ) is
        v_komm_neu_lam_id lvs_lam.lam_id%type;
        v_komm_neu_lhm_id lvs_lhm.lhm_id%type;
    begin
        lvs_komm_direct(in_sid, in_firma_nr, in_res_id, in_user_id, in_quelle_lte_id,
                        in_lam_id, in_menge, in_ziel_lte_id, v_komm_neu_lam_id, v_komm_neu_lhm_id);

        commit;
    end;

    procedure lvs_komm_direct (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_user_id       in isi_user.login_id%type,
        in_quelle_lte_id in lvs_lte.lte_id%type,
        in_lam_id        in lvs_lam.lam_id%type,
        in_menge         in lvs_lam.menge%type,
        in_ziel_lte_id   in lvs_lte.lte_id%type,
        out_neu_lam_id   out lvs_lam.lam_id%type,
        out_neu_lhm_id   out lvs_lhm.lhm_id%type
    ) is
    begin
        lvs_komm_direct_r359(in_sid,             -- in_sid,           in isi_sid.sid%type,
         in_firma_nr,        -- in_firma_nr      in isi_firma.firma_nr%type,
         in_res_id,          -- in_res_id        in isi_resource.res_id%type,
         in_user_id,         -- in_user_id       in isi_user.login_id%type,
         in_quelle_lte_id,   -- in_quelle_lte_id in lvs_lte.lte_id%type,
                             in_lam_id,          -- in_lam_id        in lvs_lam.lam_id%type,
                              in_menge,           -- in_menge         in lvs_lam.menge%type,
                              in_ziel_lte_id,     -- in_ziel_lte_id   in lvs_lte.lte_id%type,
                              null,               -- in_ziel_lhm_id   in lvs_lhm.lhm_id%type,
                              out_neu_lam_id,     -- out_neu_lam_id   out lvs_lam.lam_id%type,
                             out_neu_lhm_id);    -- out_neu_lhm_id   out lvs_lhm.lhm_id%type)
    end;

    procedure lvs_komm_direct_r359 (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_user_id       in isi_user.login_id%type,
        in_quelle_lte_id in lvs_lte.lte_id%type,
        in_lam_id        in lvs_lam.lam_id%type,
        in_menge         in lvs_lam.menge%type,
        in_ziel_lte_id   in lvs_lte.lte_id%type,
        in_ziel_lhm_id   in lvs_lhm.lhm_id%type,
        out_neu_lam_id   out lvs_lam.lam_id%type,
        out_neu_lhm_id   out lvs_lhm.lhm_id%type
    ) is

    ----------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    ----------------------------------------------------------------------------
        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(255);

    ----------------------------------------------------------------------------
    -- Lokale Variablen
    ----------------------------------------------------------------------------
        v_found             boolean;                           -- Dummy Var für gefunden im CURSOR
        v_quelle_lte        lvs_lte%rowtype;
        v_ziel_lte          lvs_lte%rowtype;
        v_lam               lvs_lam%rowtype;
        v_lhm               lvs_lhm%rowtype;
        v_ziel_lam          lvs_lam%rowtype;
        v_charge            lvs_charge%rowtype;
        v_art               isi_artikel%rowtype;
        v_order_pos         isi_order_pos%rowtype;
        v_bde_auf           bde_fa_auftrag%rowtype;
        v_art_ctrl          isi_artikel_ctrl%rowtype;
        v_hersteller        isi_hersteller%rowtype;    -- Daten aus isi-Hersteller

        v_lam_id            lvs_lam.lam_id%type;               -- Neu LAM_ID aus Sequenz
        v_lhm_id            lvs_lam.lhm_id%type;               -- Neu LHM Karton ID
        v_vorg_id           lvs_lam_bh.vorg_id%type;           -- Neu VORGang_ID aus Sequenz
        v_lam_bh_id         lvs_lam_bh.lam_bh_id%type;         -- Neu LAM_BH_ID aus Sequenz
        v_lam_bh_kg         lvs_lam_bh.lam_bh_id%type;         -- Gewicht der Wahre
        v_lam_bh_kg_einheit lvs_lam_bh.lam_bh_kg_einheit%type; -- Gewicht der eine Wahre
        v_ziel_lte_id       lvs_lte.lte_id%type;               -- Ziel LTE_ID
        v_auf_id            lvs_lam.order_pos_auf_id%type;     -- Auf_ID der Reservierung
        v_vorgang_id        lvs_lte.order_vorgang_id%type;     -- Vorgang_ID der Reservierung
        v_anz_res           number;
        v_rest_res_menge    number;
        v_anz_res_ziel      number;
        v_typ               varchar2(10);
        v_h_tag             isi_hersteller.tag%type;
        v_lhm_cfg           lvs_lhm_cfg%rowtype;
        v_lhm_vol           lvs_lhm.lhm_vol%type;
        v_org_lhm           lvs_lhm%rowtype;

    -- Lesen des Lagerbestands für quelle Transporteinheit
        cursor c_quelle_lte is
        select
            lte.*
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.firma_nr = in_firma_nr
            and lte.lte_id = in_quelle_lte_id;

    -- Lesen des Lagerbestands für ziel Transporteinheit
        cursor c_ziel_lte is
        select
            lte.*
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.firma_nr = in_firma_nr
            and lte.lte_id = v_ziel_lte_id;

    -- Lesen des Lagerbestands für LAM
        cursor c_lam is
        select
            lam.*
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.lam_id = in_lam_id;

    -- Lesen die Lams auf die ZielPalette
        cursor c_ziel_lam is
        select
            lam.*
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.lte_id = v_ziel_lte_id;

        cursor c_lam_res is
        select
            count(lam.lte_id)
        from
            lvs_lam lam
        where
                lam.lte_id = in_quelle_lte_id
            and lam.order_pos_auf_id is not null
        group by
            lam.lte_id;
    
    -- Lesen Rerservier auf Ziel Palette (W23910-241)
        cursor c_lam_res_ziel is
        select
            count(lam.lte_id)
        from
            lvs_lam lam
        where
                lam.lte_id = v_ziel_lte_id
            and lam.order_pos_auf_id is not null
        group by
            lam.lte_id;

        cursor c_charge is
        select
            t.*
        from
            lvs_charge t
        where
            t.charge_id = v_lam.charge_id;

        cursor c_lhm_cfg is
        select
            t.*
        from
            lvs_lhm_cfg t
        where
                t.sid = v_art.sid
            and t.lhm_name = v_art.lhm_name;

        cursor c_get_org_lhm is
        select
            lhm.*
        from
            lvs_lhm lhm
        where
                1 = 1
            and lhm.sid = v_lam.sid
            and lhm.firma_nr = v_lam.firma_nr
            and lhm.lhm_id = v_lam.lhm_id;

    begin
        if nvl(in_quelle_lte_id, '_') = nvl(in_ziel_lte_id, '_') then
            v_err_nr := 5;
            v_err_text := lc.ec_p2(lc.o_tp2_lte_zlte_gliech_qlte, in_quelle_lte_id, in_ziel_lte_id);
            raise v_error;
        end if;

        if in_ziel_lte_id = c.lte_komm_gleich_lte then
            v_ziel_lte_id := in_quelle_lte_id;
        else
            v_ziel_lte_id := in_ziel_lte_id;
        end if;

        open c_quelle_lte;
        fetch c_quelle_lte into v_quelle_lte;
        v_found := c_quelle_lte%found;
        close c_quelle_lte;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_quelle_lte_id);
            raise v_error;
        end if;

        if v_quelle_lte.lgr_platz is null then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_ohne_lgr_platz, in_quelle_lte_id);
            raise v_error;
        end if;

        open c_ziel_lte;
        fetch c_ziel_lte into v_ziel_lte;
        v_found := c_ziel_lte%found;
        close c_ziel_lte;
        if not v_found then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_ziel_lte_id);
            raise v_error;
        end if;

        if v_ziel_lte.lgr_platz is null then
            v_err_nr := 25;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_ohne_lgr_platz, in_ziel_lte_id);
            raise v_error;
        end if;

        open c_lam;
        fetch c_lam into v_lam;
        v_found := c_lam%found;
        close c_lam;
        if not v_found then
            v_err_nr := 35;
            v_err_text := lc.ec_p1(lc.o_tp1_lam_fehlt, in_lam_id);
            raise v_error;
        end if;
    
    /*
    -- CMe 20220214 --> Wenn konfiguruert umpacken auf bereits reservierte Paletten
    -- unterbinden, da ansonsten vorhandene Reservierungen gelöscht werden. 
    -- Siehe hierfür auch Kommentar weiter unten(W23910-241)
    open c_lam_res_ziel;
    fetch c_lam_res_ziel into v_anz_res_ziel;
    v_found := c_lam_res_ziel%FOUND;
    close c_lam_res_ziel;
    
    if (v_found) and
       (v_anz_res_ziel > 0) and
       (v_ziel_lte_id <> in_quelle_lte_id) and
       (v_lam.order_pos_auf_id is null)
    then
      if isi_allg.c_get_firma_cfg_param(v_ziel_lte.sid,
                                        v_ziel_lte.firma_nr,
                                        'LVS',                             -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                              -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'KOMM_ON_RES_TARGET_ALLOWED',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'LVS',                             -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                             -- in_typ                   in isi_firma_cfg.typ%type,
                                        'T',                               -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_FALSE              -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
      then
        v_err_nr := 35;
        v_err_text := 'Ziel ' || v_ziel_lte_id || 'ist bereits reserviert. Umpacken nicht möglich !';
        raise v_error;
      end if;
    end if;*/
    
    -- Wenn unsere Palette nicht MischPalette ist, wir setzten
    -- Palette in MischPalette wenn Palette nicht leer ist.
        if
            v_ziel_lte.res_artikel_id <> c.mischpal
            and v_ziel_lte.res_artikel_id <> to_char(v_lam.artikel_id)
        then
            open c_ziel_lam;
            fetch c_ziel_lam into v_ziel_lam;
            v_found := c_ziel_lam%found;
            close c_ziel_lam;
            if v_found then
                update lvs_lte lte
                set
                    lte.res_artikel_id = c.mischpal
                where
                        lte.sid = in_sid
                    and lte.firma_nr = in_firma_nr
                    and lte.lte_id = v_ziel_lte_id;

            end if;

        end if;

        v_err_nr := 40;
        v_err_text := lc.ec(lc.o_txt_seq_err);
        select
            seq_lam.nextval
        into v_lam_id
        from
            dual;

        out_neu_lam_id := v_lam_id;
        open c_charge;
        fetch c_charge into v_charge;
        close c_charge;

    -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
        if not isi_p_base.get_isi_artikel(in_sid, v_lam.artikel_id, v_art) then
            v_art.artikel_fuer_kunde_etikett := null;
        end if;

    -- -AG- 2015.08.10 Prüfen ob übergebene LHM bereits vorhanden
        if
            in_ziel_lhm_id is not null
            and lvs_p_base.get_lhm(in_ziel_lhm_id, v_lhm)
        then                                  -- wenn vorhanden dann Variable setzetn
            v_lhm_id := in_ziel_lhm_id;
        else -- wenn nicht dann ggf. mit übergebener oder neuen ID anlegen
            if in_ziel_lhm_id is null then
                if
                    v_lam.hersteller_kuerzel_liste is not null
                    and v_lam.hersteller_kuerzel_liste != ';'
                    and isi_p_base.get_artikel_ctrl_typ(v_lam.sid,
                                                        v_lam.artikel_id,
                                                        substr(v_lam.hersteller_kuerzel_liste,
                                                               1,
                                                               length(v_lam.hersteller_kuerzel_liste) - 1),
                                                        v_art_ctrl)
                then
                    v_typ := v_art_ctrl.prod_params;
                else
                    v_typ := '0000000000';
                end if;

                if
                    v_lam.hersteller_kuerzel_liste is not null
                    and v_lam.hersteller_kuerzel_liste != ';'
                    and isi_p_base.get_hersteller(
                        substr(v_lam.hersteller_kuerzel_liste,
                               1,
                               length(v_lam.hersteller_kuerzel_liste) - 1),
                        v_hersteller
                    )
                then
                    v_h_tag := v_hersteller.tag;
                else
                    v_h_tag := rpad('0', 20, '0');
                end if;

                v_lhm_id := lvs_p_lte.lvs_lte_lhm_next_id_v35(v_lam.sid, v_lam.firma_nr, c.basis_lhm, v_charge.charge_bez, v_lam.artikel_id
                ,
                                                              v_art.artikel_fuer_kunde_etikett, v_typ, v_h_tag);

            else
                v_lhm_id := in_ziel_lhm_id;
            end if;
      
      --CMe 20220909 (W23910-279): Alte Variante geht davon, dass die original LHM immer vorhanden ist.
      --                           Fix: Jetzt wird geprüft ob die alte LHM noch gibt bzw. ob in lvs_lam
      --                           eine LHM ID vorhanden ist. Wenn ja wird werden von der LHM die Daten als Vorlage 
      --                           verwendet. Sonst werden die Daten aus der LHM CFG geladen und eingetragen    
            open c_get_org_lhm;
            fetch c_get_org_lhm into v_org_lhm;
            v_found := c_get_org_lhm%found;
            close c_get_org_lhm;
            if ( v_found ) then
                insert into lvs_lhm (
                    sid,
                    firma_nr,
                    lhm_id,
                    lte_id,
                    lhm_name,
                    lgr_platz,
                    lhm_vol_hoehe,
                    lhm_vol_breite,
                    lhm_vol_tiefe,
                    lhm_vol,
                    lhm_akt_kg,
                    lhm_letzte_buchung,
                    lhm_eti_druck_status,
                    komm_quell_lte_id,
                    komm_quell_lgr_platz,
                    komm_neu_lhm_name
                ) values ( v_lam.sid,
                           v_lam.firma_nr,
                           v_lhm_id,
                           v_ziel_lte.lte_id,
                           v_org_lhm.lhm_name,
                           v_ziel_lte.lgr_platz,
                           nvl(v_org_lhm.lhm_vol_hoehe, 0),
                           nvl(v_org_lhm.lhm_vol_breite, 0),
                           nvl(v_org_lhm.lhm_vol_tiefe, 0),
                           nvl(v_org_lhm.lhm_vol, 0),
                           nvl(v_org_lhm.lhm_akt_kg, 0),
                           sysdate,
                           null,
                           v_lam.lte_id,
                           v_lam.lgr_platz,
                           null );

            else
                open c_lhm_cfg;
                fetch c_lhm_cfg into v_lhm_cfg;
                close c_lhm_cfg;
                v_lhm_vol := nvl(v_lhm_cfg.lhm_vol_hoehe, 0) * nvl(v_lhm_cfg.lhm_vol_breite, 0) * nvl(v_lhm_cfg.lhm_vol_tiefe, 0) / 1000000000
                ;

                insert into lvs_lhm (
                    sid,
                    firma_nr,
                    lhm_id,
                    lte_id,
                    lhm_name,
                    lgr_platz,
                    lhm_vol_hoehe,
                    lhm_vol_breite,
                    lhm_vol_tiefe,
                    lhm_vol,
                    lhm_akt_kg,
                    lhm_letzte_buchung,
                    lhm_eti_druck_status,
                    komm_quell_lte_id,
                    komm_quell_lgr_platz,
                    komm_neu_lhm_name
                ) values ( v_lam.sid,
                           v_lam.firma_nr,
                           v_lhm_id,
                           v_ziel_lte.lte_id,
                           v_lhm_cfg.lhm_name,
                           v_ziel_lte.lgr_platz,
                           nvl(v_lhm_cfg.lhm_vol_hoehe, 0),
                           nvl(v_lhm_cfg.lhm_vol_breite, 0),
                           nvl(v_lhm_cfg.lhm_vol_tiefe, 0),
                           v_lhm_vol,
                           0,
                           sysdate,
                           null,
                           v_lam.lte_id,
                           v_lam.lgr_platz,
                           null );

            end if;

        end if;

        out_neu_lhm_id := v_lhm_id;
        v_auf_id := null;
        v_vorgang_id := null;
        if isi_p_order_base.get_order_pos(in_sid, v_lam.order_pos_auf_id, v_order_pos) then
            if (
                v_order_pos.satzart = 'MA'
                and v_ziel_lte.order_vorgang_id = v_order_pos.vorgang_id
            )
            or v_order_pos.satzart != 'MA' then
                v_vorgang_id := v_order_pos.vorgang_id;
                if v_ziel_lte.order_auf_id is null
                   or nvl(v_ziel_lte.order_auf_id, 0) = v_order_pos.auf_id then
                    v_auf_id := v_order_pos.auf_id;
                end if;

                if
                    v_ziel_lte.order_vorgang_id is not null
                    and v_auf_id is not null
                then
                    update lvs_lte t
                    set
                        t.order_vorgang_id = v_vorgang_id,
                        t.order_auf_id = v_auf_id
                    where
                        t.lte_id = v_ziel_lte.lte_id;

                elsif v_ziel_lte.order_vorgang_id is null then
                    v_anz_res := lvs_ausl.lvs_lte_reservieren(in_sid, in_firma_nr, v_vorgang_id, v_auf_id, v_ziel_lte.lte_id,
                                                              v_vorgang_id, v_ziel_lte.lgr_platz, v_order_pos.artikel_id);
                end if;

                v_auf_id := v_order_pos.auf_id;
            end if;
        else
            if bde_p_base.get_fa_by_auf_id(in_sid, in_firma_nr, v_lam.order_pos_auf_id, v_bde_auf) then
                v_vorgang_id := v_bde_auf.leitzahl;
                v_auf_id := v_bde_auf.auf_id;
                v_anz_res := lvs_ausl.lvs_lte_reservieren(in_sid, in_firma_nr, v_bde_auf.leitzahl, v_bde_auf.auf_id, v_ziel_lte.lte_id
                ,
                                                          v_bde_auf.leitzahl, v_ziel_lte.lgr_platz, v_bde_auf.ag_artikel_id);
      /*else
        -- CMe 20220214 --> Sorgt bei einer bereits reservierten Zielpalette dafür
        -- das die Reservierungen gelöscht werden (W23910-241)
        update lvs_lte t
           set t.order_vorgang_id = NULL,
               t.order_auf_id = NULL
         where t.lte_id = v_ziel_lte.lte_id;
        update lvs_lam t
           set t.order_pos_auf_id = NULL
         where t.lte_id = v_ziel_lte.lte_id;*/
            end if;
        end if;

        v_err_nr := null;
    -- Gewicht und Menge wird im Trigger LAM_BH gesetzt
    -- -AG- 06.09.2010 Erweiterung LFDN in der Charge
        insert into lvs_lam values ( v_lam.sid,                 -- SID                 VARCHAR2(2) not null,
                                     v_lam.firma_nr,            -- FIRMA_NR            NUMBER(2) not null,
                                     v_lam_id,                  -- LAM_ID              NUMBER not null,
                                     v_lam.artikel_id,          -- ARTIKEL_ID          NUMBER,
                                     v_ziel_lte.lgr_platz,      -- LGR_PLATZ           VARCHAR2(30),
                                     v_ziel_lte.lte_id,         -- LTE_ID              VARCHAR2(19),
                                     v_lhm_id,                  -- LHM_ID              VARCHAR2(19),
                                     v_lam.charge_id,           -- CHARGE_ID           NUMBER,
                                     v_lam.serie_id,            -- SERIE_ID            NUMBER,
                                     v_lam.leitzahl,            -- LEITZAHL            NUMBER,
                                     v_lam.fa_ag,               -- FA_AG               NUMBER,
                                     v_lam.fa_upos,             -- FA_UPOS             NUMBER,
                                     v_lam.abnr,                -- ABNR                VARCHAR2(20),
                                     null,                      -- BEST_NR             VARCHAR2(20),
                                     null,                      -- BEST_POS            VARCHAR2(5),
                                     v_lam.res_id,              -- RES_ID              NUMBER,
                                     v_lam.prod_datum,          -- PROD_DATUM          DATE,
                                     v_lam.zug_datum,           -- ZUG_DATUM           DATE,
                                     v_lam.ls_login_id,         -- LS_LOGIN_ID         NUMBER,
                                     0,                         -- MENGE               NUMBER,
                                     0,                         -- LAM_KG              NUMBER,
                                     v_lam.lam_text,            -- LAM_TEXT            VARCHAR2(20),
                                     v_lam.labor_status,        -- LABOR_STATUS        CHAR(1),
                                     v_lam.labor_text,          -- LABOR_TEXT          VARCHAR2(30),
                                     v_lam.lam_mhd,             -- LAM_MHD             DATE,
                                     v_lam.kunden_nr,           -- KUNDEN_NR           VARCHAR2(10),
                                     v_lam.kd_art_nr,           -- KD_ART_NR           VARCHAR2(30),
                                     v_lam.lieferant_nr,        -- LIEFERANT_NR        VARCHAR2(10),
                                     v_lam.lam_mhd_ausgabe,     -- LAM_MHD_AUSGABE     DATE,
                                     v_lam.menge_basis,         -- MENGE_BASIS         VARCHAR2(3) default 'LKE' not null,
                                     v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                     v_auf_id,                  -- ORDER_POS_AUF_ID    NUMBER
                                     v_lam.zeichnung,
                                     v_lam.zeichnung_index,
                                     v_lam.li_nr_lief,
                                     v_lam.lte_id_lieferant,
                                     v_lam.sonst_id_lieferant,
                                     v_lam.akt_inventur_id,
                                     v_lam.letzte_inventur_id,
                                     v_lam.letzte_inventur_datum,
                                     v_lam.letzte_inventur_login_id,
                                     v_lam.lam_p1,
                                     v_lam.lam_p2,
                                     v_lam.lam_p3,
                                     v_lam.lam_p4,
                                     v_lam.lam_p5,
                                     v_lam.lam_p6,
                                     v_lam.lam_p7,
                                     v_lam.lam_p8,
                                     v_lam.lam_p9,
                                     v_lam.lam_p10,
                                     decode(v_auf_id, null, null, in_menge), -- WK 2015-09-16: Es muss in dem Zielgebinde "nur" das reserviert sein, was auch umgepackt wurde (v_lam.res_menge,)
                                     null,
                                     v_lam.res_login_id,
                                     v_lam.check_ware_transp_id,
                                     v_lam.fae_id,
                                     v_lam.fae_id_position,
                                     v_lam.qs_status,
                                     v_lam.waren_typ,
                                     v_lam.lhm_lfd_nr,
                                     lvs_komm.get_packschema_kopf_id(in_sid, in_firma_nr, v_ziel_lte.lte_id),
                                     lvs_komm.get_packschema_lfdn(in_sid, in_firma_nr, v_ziel_lte.lte_id),
                                     v_lam.lhm_c_lfd_nr,
                                     v_lam.owner_address_id,             -- Besitzer wird aus der LAM übernommen
                                     v_lam.lam_sel1,                       -- LAM_SEL1  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.lam_sel2,                       -- LAM_SEL2  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.lam_sel3,                       -- LAM_SEL3  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.lam_sel4,                       -- LAM_SEL4  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.lam_sel5,                       -- LAM_SEL5  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.lam_sel6,                       -- LAM_SEL6  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.lam_sel7,                       -- LAM_SEL7  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.lam_sel8,                       -- LAM_SEL8  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.lam_sel9,                       -- LAM_SEL9  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.lam_sel10,                      -- LAM_SEL10  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                                     v_lam.hersteller_kuerzel_liste,
                                     v_lam.nr_pruefung );

        v_err_nr := 50;
        v_err_text := lc.ec(lc.o_txt_seq_err);
        select
            seq_vorg_id.nextval
        into v_vorg_id
        from
            dual;

        v_err_nr := 60;
        v_err_text := lc.ec(lc.o_txt_seq_err);
        select
            seq_lam_bh.nextval
        into v_lam_bh_id
        from
            dual;

        v_err_nr := null;
        begin
            if ( nvl(v_lam.menge, 0) <> 0 ) then
                v_lam_bh_kg := ( nvl(v_lam.lam_kg, 0) * nvl(in_menge, 0) ) / nvl(v_lam.menge, 0);

                v_lam_bh_kg_einheit := nvl(v_lam.lam_kg, 0) / nvl(v_lam.menge, 0);

            else
                v_lam_bh_kg := 0;
                v_lam_bh_kg_einheit := 0;
            end if;
        exception
            when others then
                v_lam_bh_kg := 0;
                v_lam_bh_kg_einheit := 0;
        end;

        if
            v_lam.order_pos_auf_id is not null
            and v_ziel_lte.order_vorgang_id is null
            and v_quelle_lte.lte_status = c.lte_af_stat
        then -- Bei Nachschub nicht LNK, MAK mit KOMM dann von AF abziehen
            update isi_order_pos p
            set
                p.ist_menge = p.ist_menge + ( nvl(in_menge, 0) * - 1 ),
                p.brutto_kg = p.brutto_kg + ( nvl(v_lam_bh_kg, 0) * - 1 )
            where
                    p.sid = v_quelle_lte.sid
                and p.firma_nr = v_quelle_lte.firma_nr
                and p.auf_id = v_lam.order_pos_auf_id
                and p.satzart in ( 'MA' );

        end if;

        if
            v_lam.order_pos_auf_id is not null
            and v_order_pos.satzart in ( 'LNK', 'MAK' )
        then -- Bei Nachschub LNK, MAK mit KOMM menge addieren
            update isi_order_pos p
            set
                p.ist_menge = p.ist_menge + ( nvl(in_menge, 0) ),
                p.brutto_kg = p.brutto_kg + ( nvl(v_lam_bh_kg, 0) ),
                p.status =
                    case
                        when ( p.ist_menge + ( nvl(in_menge, 0) ) >= p.soll_menge ) then
                            'X'
                        else
                            p.status
                    end
            where
                    p.sid = v_quelle_lte.sid
                and p.firma_nr = v_quelle_lte.firma_nr
                and p.auf_id = v_lam.order_pos_auf_id
                and p.satzart in ( 'LNK', 'MAK' );

        end if;

        v_err_nr := null;
    -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
        insert into lvs_lam_bh values ( in_sid,                 -- SID               VARCHAR2(2) not null,
                                        in_firma_nr,            -- FIRMA_NR          NUMBER(2) not null,
                                        v_vorg_id,              -- VORG_ID           NUMBER not null,
                                        c.lam_bh_abgagng,       -- VORG_TYP          VARCHAR2(2) not null,
                                        v_lam_bh_id,            -- LAM_BH_ID         NUMBER not null,
                                        in_lam_id,              -- LAM_ID            NUMBER not null,
                                        v_lam.artikel_id,       -- ARTIKEL_ID        NUMBER,
                                        c.lam_bh_bus_abg_komm,  -- BUS               NUMBER,
                                        sysdate,                -- BUCH_DATUM        DATE,
                                        in_user_id,             -- LS_LOGIN_ID       NUMBER,
                                        v_quelle_lte.lgr_platz, -- LGR_PLATZ         VARCHAR2(30),
                                        in_quelle_lte_id,       -- LTE_ID            VARCHAR2(19),
                 -- WK 20110606: Bugfix, Abgang aus "alte" LHM
                                        v_lam.lhm_id,           -- LHM_ID            VARCHAR2(19),
                                        v_lam.charge_id,        -- CHARGE_ID         NUMBER,
                                        v_lam.serie_id,         -- SERIE_ID          NUMBER,
                                        null,                   -- ABNR              VARCHAR2(20),
                                        nvl(in_menge, 0),       -- MENGE             NUMBER,
                                        v_lam_bh_kg,            -- LAM_BH_KG         NUMBER,
                                        v_lam_bh_kg_einheit,    -- LAM_BH_KG_EINHEIT NUMBER,
                                        in_res_id,              -- RES_ID            NUMBER
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        sysdate,                     -- CREATED_DATE          creation date+time of this dataset
                                        in_user_id,                  -- CREATED_LOGIN_ID      login id of the user creating this dataset
                                        sysdate,                     -- LAST_CHANGE_DATE      change date+time of this dataset
                                        in_user_id,                  -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
                                        null,                        -- CHANGE_MENGE          Menge die geändert wurde
                                        v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                                        null );                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
        v_rest_res_menge := v_lam.res_menge - in_menge;
        if v_rest_res_menge <= 0 then
      -- -AG- 2015.09.04 Reservierung aus der LAM nehmen falls vorhanden war
            update lvs_lam t
            set
                t.res_menge = null,
                t.order_pos_auf_id = null,
                t.res_ziel_lte_id = null,
                t.res_login_id = null
            where
                t.lam_id = in_lam_id;

        else
      -- -WK- 215-09-15 Reservierte Menge auf die Restmenge reduzieren, Reservierung beibehalten
      -- (für Kommi-Split = Zielgebinde ist voll, und es soll gleich in ein neues Zielgebinde kommissioniert werden)
            update lvs_lam t
            set
                t.res_menge = v_rest_res_menge
            where
                t.lam_id = in_lam_id;

        end if;

    -- -AG- 2015.08.10 Buchen in der KOMM_ORDER wenn Auftrag vorhanden
        update isi_komm_order t
        set
            t.komm_ist_menge = nvl(t.komm_ist_menge, 0) + in_menge
        where
                t.auf_id = v_lam.order_pos_auf_id
            and t.lte_id = v_lam.lte_id
            and nvl(t.komm_ziel_lte_id, v_ziel_lte_id) = v_ziel_lte_id;

        v_err_nr := 70;
        v_err_text := lc.ec(lc.o_txt_seq_err);
        select
            seq_lam_bh.nextval
        into v_lam_bh_id
        from
            dual;

        v_err_nr := null;
    -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
        insert into lvs_lam_bh values ( in_sid,              -- SID               VARCHAR2(2) not null,
                                        in_firma_nr,         -- FIRMA_NR          NUMBER(2) not null,
                                        v_vorg_id,           -- VORG_ID           NUMBER not null,
                                        c.lam_bh_zugagng,    -- VORG_TYP          VARCHAR2(2) not null,
                                        v_lam_bh_id,         -- LAM_BH_ID         NUMBER not null,
                                        v_lam_id,            -- LAM_ID            NUMBER not null,
                                        v_lam.artikel_id,    -- ARTIKEL_ID        NUMBER,
                                        c.lam_bh_bus_zug_komm,    -- BUS               NUMBER,
                                        sysdate,             -- BUCH_DATUM        DATE,
                                        in_user_id,          -- LS_LOGIN_ID       NUMBER,
                                        v_ziel_lte.lgr_platz,-- LGR_PLATZ         VARCHAR2(30),
                                        v_ziel_lte_id,       -- LTE_ID            VARCHAR2(19),
                 -- WK 20110606: Bugfix, Zugang in "neue" LHM
                                        v_lhm_id,            -- LHM_ID            VARCHAR2(19),
                                        v_lam.charge_id,     -- CHARGE_ID         NUMBER,
                                        v_lam.serie_id,      -- SERIE_ID          NUMBER,
                                        null,                -- ABNR              VARCHAR2(20),
                                        nvl(in_menge, 0),    -- MENGE             NUMBER,
                                        v_lam_bh_kg,         -- LAM_BH_KG         NUMBER,
                                        v_lam_bh_kg_einheit, -- LAM_BH_KG_EINHEIT NUMBER,
                                        in_res_id,           -- RES_ID            NUMBER
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        sysdate,                     -- CREATED_DATE          creation date+time of this dataset
                                        in_user_id,                  -- CREATED_LOGIN_ID      login id of the user creating this dataset
                                        sysdate,                     -- LAST_CHANGE_DATE      change date+time of this dataset
                                        in_user_id,                  -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
                                        null,                        -- CHANGE_MENGE          Menge die geändert wurde
                                        v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                                        null );                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
     -- Jetzt Quell_LTE evtl. die Reservierung rausnehmen
        open c_lam_res;
        fetch c_lam_res into v_anz_res;
        close c_lam_res;
        if nvl(v_anz_res, 0) = 0  -- Nichts mehr Reserviert auf der Quelle
         then
            v_anz_res := lvs_ausl.lvs_lte_res_rueck(in_sid, in_firma_nr, null, null, in_quelle_lte_id,
                                                    null, null, c.c_true);
        end if;

    exception
    -- Im Fehlerfall is v_err_nr bereits gesetzt
        when v_error then  -- Update 2011 show Exception Source Line
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        when others then
            rollback;
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

  --------------------------------------------------------------------------------
  -- procedure LVS_C_LTE_PLATZ_LOESCHEN
  -- Mit diesem Funktion eine Palette von seinem Platz gelöscht werden kann.
  --------------------------------------------------------------------------------
    procedure lvs_c_lte_platz_loeschen (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) is

        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_found    boolean;
        v_lte      lvs_lte%rowtype;
        cursor c_lvs_lte is
        select
            lte.*
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.firma_nr = in_firma_nr
            and lte.lte_id = in_lte_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_lvs_lte;
        fetch c_lvs_lte into v_lte;
        v_found := c_lvs_lte%found;
        close c_lvs_lte;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_lte_id);
            raise v_error;
        end if;

        if v_lte.lte_status != c.lte_lf_stat then
            v_err_nr := 20;
            v_err_text := lc.ec_p2(lc.o_tp2_lte_m_status_loeschen, in_lte_id, v_lte.lte_status);
            raise v_error;
        end if;

        lvs_p_lte.lvs_c_korr_te_ausbuchen(in_sid,           -- in_te_sid               in lvs_lte.sid%TYPE,

         in_firma_nr,      -- in_te_firma_nr          in lvs_lte.firma_nr%TYPE,

         in_lte_id,        -- in_lte_id               in LVS_LTE.LTE_ID%TYPE,

         v_lte.lte_status, -- in_lte_status           in lvs_lte.lte_status%TYPE,

         in_sid,           -- in_lgr_sid              in lvs_lgr.sid%TYPE,
                                          in_firma_nr,      -- in_lgr_firma_nr         in lvs_lgr.firma_nr%TYPE,
                                           v_lte.lgr_ort,    -- in_lgr_ort              in lvs_lgr.lgr_ort%TYPE,
                                           v_lte.lgr_platz,  -- in_lgr_lagerplatz       in LVS_LTE.LGR_PLATZ%TYPE,
                                           null);            -- in_ls_login_id          in isi_user.login_id%TYPE) is
        commit;
    exception
    -- Im Fehlerfall ist der Fehlertext bereits gesetzt,
        when v_error then  -- Update 2011 show Exception Source Line
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
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

    end lvs_c_lte_platz_loeschen;

    function get_packschema_kopf_id (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) return lvs_packschema_kopf.packschema_kopf_id%type is

        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_lte      lvs_lte%rowtype;
        cursor c_lte is
        select
            t.*
        from
            lvs_lte t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lte_id = in_lte_id;

    begin
        v_lte := null;
        open c_lte;
        fetch c_lte into v_lte;
        close c_lte;
        return ( v_lte.packschema_kopf_id );
    exception
    -- Im Fehlerfall ist der Fehlertext bereits gesetzt,
        when v_error then  -- Update 2011 show Exception Source Line
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
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

    end get_packschema_kopf_id;

    function get_packschema_lfdn (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) return number is

        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_lfdn     number;
        v_lam      lvs_lam%rowtype;
        cursor c_lam is
        select
            t.*
        from
            lvs_lam t
        where
            ( t.sid = in_sid
              and t.firma_nr = in_firma_nr
              and t.lte_id = in_lte_id
              or t.res_ziel_lte_id = in_lte_id )
        order by
            t.packschema_lfdn;

    begin
        v_lfdn := 1;      -- Erst mal auf position 1
        open c_lam;
        loop
            fetch c_lam into v_lam;
            exit when c_lam%notfound;
            if v_lam.packschema_lfdn = v_lfdn -- Diese Position ist vergeben
             then
                v_lfdn := v_lfdn + 1;
            else -- Position ist nicht vergeben
                exit;
            end if;

        end loop;

        close c_lam;
        return ( v_lfdn );
    exception
    -- Im Fehlerfall ist der Fehler bereits gesetzt,
        when v_error then  -- Update 2011 show Exception Source Line
            if c_lam%isopen then
                close c_lam;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        when others then
            if c_lam%isopen then
                close c_lam;
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

    end get_packschema_lfdn;

    function get_packschema_max_lfdn (
        in_sid                in isi_sid.sid%type,
        in_firma_nr           in isi_firma.firma_nr%type,
        in_packschema_kopf_id in lvs_lte.lte_id%type
    ) return number is

        v_lfdn number;
        cursor c_pack_max_lfdn is
        select
            count(pp.packschema_pos_nr) * pk.anz_lagen
        from
            lvs_packschema_pos  pp,
            lvs_packschema_kopf pk
        where
                pp.sid = in_sid
            and pp.firma_nr = in_firma_nr
            and pp.packschema_kopf_id = in_packschema_kopf_id
            and pk.packschema_kopf_id = pp.packschema_kopf_id
        group by
            pk.packschema_kopf_id,
            pk.anz_lagen;

    begin
        v_lfdn := 0;
        open c_pack_max_lfdn;
        fetch c_pack_max_lfdn into v_lfdn;
        close c_pack_max_lfdn;
        return v_lfdn;
    end get_packschema_max_lfdn;

    function get_packschema_max_lage (
        in_sid                in isi_sid.sid%type,
        in_firma_nr           in isi_firma.firma_nr%type,
        in_packschema_kopf_id in lvs_lte.lte_id%type
    ) return number is

        v_lfdn number;
        cursor c_pack_max_lfdn is
        select
            count(pp.packschema_pos_nr)
        from
            lvs_packschema_pos pp
        where
                pp.sid = in_sid
            and pp.firma_nr = in_firma_nr
            and pp.packschema_kopf_id = in_packschema_kopf_id
        group by
            pp.packschema_kopf_id;

    begin
        v_lfdn := 0;
        open c_pack_max_lfdn;
        fetch c_pack_max_lfdn into v_lfdn;
        close c_pack_max_lfdn;
        return v_lfdn;
    end get_packschema_max_lage;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure Legt eine LHM von einer Palette auf eine andere
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure lvs_lte_lhm_umpacken (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_res_id   in isi_resource.res_id%type,
        in_q_lte_id in lvs_lhm.lhm_id%type,
        in_z_lte_id in lvs_lte.lte_id%type,
        in_auf_id   in isi_order_pos.auf_id%type,
        in_lhm_uanz in number
    ) is

    ----------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    ----------------------------------------------------------------------------
        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(255);
        v_order_pos  isi_order_pos%rowtype;
        v_bde_auf    bde_fa_auftrag%rowtype;
        v_ziel_lte   lvs_lte%rowtype;
        v_auf_id     lvs_lam.order_pos_auf_id%type;     -- Auf_ID der Reservierung
        v_vorgang_id lvs_lte.order_vorgang_id%type;     -- Vorgang_ID der Reservierung

        v_found      boolean;
        v_lam        lvs_lam%rowtype;
        v_anz_res    number;
        i            number;

    -- Lesen des Lagerbestands für ziel Transporteinheit
        cursor c_ziel_lte is
        select
            lte.*
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.firma_nr = in_firma_nr
            and lte.lte_id = in_z_lte_id;

        cursor c_lam_res is
        select
            count(lam.lte_id)
        from
            lvs_lam lam
        where
                lam.lte_id = in_q_lte_id
            and lam.order_pos_auf_id is not null
        group by
            lam.lte_id;

        cursor c_lam is
        select
            *
        from
            lvs_lam t
        where
                t.lte_id = in_q_lte_id
            and nvl(t.order_pos_auf_id, 0) = nvl(in_auf_id, 0)
        order by
            t.menge desc,
            nvl(t.packschema_lfdn, t.lhm_c_lfd_nr) desc;

    begin
    -- Est mal keine Gebinde umgepackt I = Zähler
        i := 0;
        open c_ziel_lte;
        fetch c_ziel_lte into v_ziel_lte;
        v_found := c_ziel_lte%found;
        close c_ziel_lte;
        if not v_found then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_z_lte_id);
            raise v_error;
        end if;

        v_auf_id := null;
        v_vorgang_id := null;
        if isi_p_order_base.get_order_pos(in_sid, in_auf_id, v_order_pos) then
            if (
                v_order_pos.satzart = 'MA'
                and v_ziel_lte.order_vorgang_id = v_order_pos.vorgang_id
            )
            or v_order_pos.satzart != 'MA' then
                v_vorgang_id := v_order_pos.vorgang_id;
                if v_ziel_lte.order_auf_id is null
                   or nvl(v_ziel_lte.order_auf_id, 0) = v_order_pos.auf_id then
                    v_auf_id := v_order_pos.auf_id;
                end if;

                if
                    v_ziel_lte.order_vorgang_id is not null
                    and v_auf_id is not null
                then
                    update lvs_lte t
                    set
                        t.order_vorgang_id = v_vorgang_id,
                        t.order_auf_id = v_auf_id
                    where
                        t.lte_id = v_ziel_lte.lte_id;

                elsif v_ziel_lte.order_vorgang_id is null then
                    v_anz_res := lvs_ausl.lvs_lte_reservieren(in_sid, in_firma_nr, v_vorgang_id, v_auf_id, v_ziel_lte.lte_id,
                                                              v_vorgang_id, v_ziel_lte.lgr_platz, v_order_pos.artikel_id);
                end if;

                v_auf_id := v_order_pos.auf_id;
            end if;
        else
            if bde_p_base.get_fa_by_auf_id(in_sid, in_firma_nr, in_auf_id, v_bde_auf) then
                v_vorgang_id := v_bde_auf.leitzahl;
                v_auf_id := v_bde_auf.auf_id;
                v_anz_res := lvs_ausl.lvs_lte_reservieren(in_sid, in_firma_nr, v_bde_auf.leitzahl, v_bde_auf.auf_id, v_ziel_lte.lte_id
                ,
                                                          v_bde_auf.leitzahl, v_ziel_lte.lgr_platz, v_bde_auf.ag_artikel_id);

            end if;
        end if;

        open c_lam;
        fetch c_lam into v_lam;
        v_found := c_lam%found;
        loop
            exit when i >= in_lhm_uanz
            or not v_found;
      -- Anpassung P80032 Belimo Uebernahme Inventurkennzeichen aus der Quelle ins Ziel
            if
                v_ziel_lte.lte_akt_lhm = 0                            -- -AG- 20260330 Zielpalette ist leer
                and c.c_true = isi_allg.get_firma_cfg_param(v_ziel_lte.sid, v_ziel_lte.firma_nr, 'LTE_KOMM', null, 'LVS_LTE_INV_UEBERNAME'
                ,
                                                            'LVS', 'CFG', 'F', 'BOOLEAN')
            then
                update lvs_lte t
                set
                    t.letzte_inventur_id = v_lam.letzte_inventur_id,
                    t.letzte_inventur_datum = v_lam.letzte_inventur_datum,
                    t.letzte_inventur_login_id = v_lam.letzte_inventur_login_id
                where
                    t.lte_id = v_ziel_lte.lte_id;

                v_ziel_lte.lte_akt_lhm := 1;
            end if;
      -- habe passende Gebinde gefunden
            lvs_p_lte_lhm.lvs_lhm_umpacken(in_sid, in_firma_nr, in_user_id, in_res_id, v_lam.lhm_id,
                                           in_z_lte_id); -- Dann auf neue Palette umpacken
            i := i + 1;                            -- Zählen des Gebinde
            fetch c_lam into v_lam;                -- Versuch nächstes Gebinde zu lesen
            v_found := c_lam%found;                -- Merken ob ein weiteres gefunden wurde
        end loop;

        close c_lam;
        if i < in_lhm_uanz -- Zu wenig Reserviert odr bei AUF_ID NULL auf der palette
         then
            v_err_nr := 5;
            v_err_text := lc.ec(lc.o_txt_menge_fehler);
            raise v_error;
        end if;

     -- Jetzt Quell_LTE evtl. die Reservierung rausnehmen
        open c_lam_res;
        fetch c_lam_res into v_anz_res;
        close c_lam_res;
        if nvl(v_anz_res, 0) = 0  -- Nichts mehr Reserviert auf der Quelle
         then
            v_anz_res := lvs_ausl.lvs_lte_res_rueck(in_sid, in_firma_nr, null, null, in_q_lte_id,
                                                    null, null, c.c_true);
        end if;

    /* Passiert jetzt im Transport fertig
    if v_order_pos.satzart in ('LNK', 'MAK')      -- Nachschub für Produktion oder Lager, dann muss die Reservierung aus dem Ziel genommen werden
    then
      v_anz_res := lvs_ausl.lvs_lte_res_rueck(in_sid,
                                              in_firma_nr,
                                              v_order_pos.vorgang_id,
                                              v_order_pos.auf_id,
                                              v_ziel_lte.lte_id,
                                              v_order_pos.vorgang_id,
                                              v_ziel_lte.lgr_platz,
                                              c.C_TRUE);

    end if;
    */

    /* -- HJG Alt 2016-07-19
    update lvs_lte t
       set t.komm_menge_kontrolle = 'TD'
     where t.lte_id in (in_q_lte_id, in_z_lte_id)
       and t.komm_menge_kontrolle != 'TK';
    */
    -- HJG Alt 2016-07-19 Jedes Zielgebinde ist direkt lieferbar
        update lvs_lte t
        set
            t.komm_menge_kontrolle = 'TD'
        where
            t.lte_id = in_z_lte_id;
    -- HJG Alt 2016-07-19 Jedes Quellgebinde ist direkt lieferbar, wenn nicht Kontrolliert werden muss
        update lvs_lte t
        set
            t.komm_menge_kontrolle = 'TD'
        where
                t.lte_id = in_q_lte_id
            and t.komm_menge_kontrolle != 'TK';

    exception
    -- Im Fehlerfall ist der Fehler bereits gesetzt,
        when v_error then  -- Update 2011 show Exception Source Line
            if c_lam%isopen then
                close c_lam;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        when others then
            if c_lam%isopen then
                close c_lam;
            end if;
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure Legt eine LHM von einer Palette auf eine andere
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************

    procedure lvs_c_lte_lhm_umpacken (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_res_id   in isi_resource.res_id%type,
        in_q_lte_id in lvs_lhm.lhm_id%type,
        in_z_lte_id in lvs_lte.lte_id%type,
        in_auf_id   in isi_order_pos.auf_id%type,
        in_lhm_uanz in number
    ) is
    begin
        lvs_komm.lvs_lte_lhm_umpacken(in_sid, in_firma_nr, in_user_id, in_res_id, in_q_lte_id,
                                      in_z_lte_id, in_auf_id, in_lhm_uanz);

        commit;
    end;

    procedure lvs_c_lte_umpack_q_platz_leer (
        in_q_platz_leeren in varchar2, -- T/F T = LTE vom Quellplatz ausbuchen
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_user_id        in isi_user.login_id%type,
        in_res_id         in isi_resource.res_id%type,
        in_q_lte_id       in lvs_lhm.lhm_id%type,
        in_z_lte_id       in lvs_lte.lte_id%type,
        in_auf_id         in isi_order_pos.auf_id%type,
        in_lhm_uanz       in number
    ) is
        v_lte lvs_lte%rowtype;
    begin
        lvs_komm.lvs_lte_lhm_umpacken(in_sid, in_firma_nr, in_user_id, in_res_id, in_q_lte_id,
                                      in_z_lte_id, in_auf_id, in_lhm_uanz);

        if
            in_q_platz_leeren = c.c_true
            and lvs_p_base.get_lte(in_q_lte_id, v_lte)
            and v_lte.lte_akt_lhm = 0
        then
            lvs_p_lte.lvs_korr_te_ausbuchen(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, v_lte.lte_status, v_lte.sid,
                                            v_lte.firma_nr, v_lte.lgr_ort, v_lte.lgr_platz, in_user_id);

        end if;

        commit;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure Legt eine LHM von einer Palette auf eine andere
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure lvs_c_lte_menge_umpacken (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_res_id   in isi_resource.res_id%type,
        in_q_lte_id in lvs_lhm.lhm_id%type,
        in_z_lte_id in lvs_lte.lte_id%type,
        in_auf_id   in isi_order_pos.auf_id%type,
        in_menge    in number,
        in_neg_komm in varchar2
    ) is
    begin
        lvs_lte_menge_umpacken(in_sid,        -- in isi_sid.sid%type,
         in_firma_nr,   -- in isi_firma.firma_nr%type,
         in_user_id,    -- in isi_user.login_id%type,
         in_res_id,     -- in isi_resource.res_id%type,
         in_q_lte_id,   -- in lvs_lhm.Lhm_Id%type,
                               in_z_lte_id,   -- in lvs_lte.lte_id%type,
                                in_auf_id,     -- in isi_order_pos.auf_id%type,
                                in_menge,      -- in number,
                                in_neg_komm);  -- in varchar2);
        commit;
    end;

    procedure lvs_lte_menge_umpacken (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_res_id   in isi_resource.res_id%type,
        in_q_lte_id in lvs_lhm.lhm_id%type,
        in_z_lte_id in lvs_lte.lte_id%type,
        in_auf_id   in isi_order_pos.auf_id%type,
        in_menge    in number,
        in_neg_komm in varchar2
    ) is

    ----------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    ----------------------------------------------------------------------------
        v_error exception;
        v_err_nr           number;
        v_err_text         varchar2(255);
        v_found            boolean;
        v_found_lam        boolean;
        v_res              isi_resource%rowtype;
        v_lam              lvs_lam%rowtype;
        v_lam_lhm_id       lvs_lam.lhm_id%type;
        v_neu_lam_id       lvs_lam.lam_id%type;
        v_lhm_id           lvs_lhm.lhm_id%type;
        v_neu_lhm_id       lvs_lhm.lhm_id%type;
        v_order_pos        isi_order_pos%rowtype;
        v_bde_auf          bde_fa_auftrag%rowtype;
        v_ziel_lte         lvs_lte%rowtype;
        v_quell_lte        lvs_lte%rowtype;
        v_auf_id           lvs_lam.order_pos_auf_id%type;     -- Auf_ID der Reservierung
        v_vorgang_id       lvs_lte.order_vorgang_id%type;     -- Vorgang_ID der Reservierung

        v_benoetigte_menge number;
        v_menge            number;
        v_res_menge        number;
        v_ges_menge        number;
        v_anz_res          number;
        v_login_id         lvs_lam.res_login_id%type;

    -- Lesen des Lagerbestands für ziel Transporteinheit
        cursor c_ziel_lte is
        select
            lte.*
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.firma_nr = in_firma_nr
            and lte.lte_id = in_z_lte_id;

        cursor c_lam_res is
        select
            count(lam.lte_id),
            max(lam.res_login_id)
        from
            lvs_lam lam
        where
                lam.lte_id = in_q_lte_id
            and lam.order_pos_auf_id is not null
        group by
            lam.lte_id;

        cursor c_lam_mg is
        select
            t.lhm_id,
            t.order_pos_auf_id,
            sum(t.menge),
            sum(nvl(t.res_menge, 0))
        from
            lvs_lam t
        where
                t.lte_id = in_q_lte_id
            and ( ( nvl(t.order_pos_auf_id, 0) = nvl(in_auf_id, 0)
                    and in_neg_komm = c.c_false )
                  or ( nvl(t.order_pos_auf_id, 0) != nvl(in_auf_id, 0)
                       and in_neg_komm = c.c_true )
                  or ( t.menge != nvl(t.res_menge, 0)
                       and in_neg_komm = c.c_true ) )
        group by
            t.lhm_id,
            t.order_pos_auf_id,
            t.packschema_lfdn,
            t.lhm_c_lfd_nr
        order by
            sum(t.menge) desc,
            nvl(t.packschema_lfdn, t.lhm_c_lfd_nr) desc;

        cursor c_lam is
        select
            *
        from
            lvs_lam t
        where
                t.lte_id = in_q_lte_id
            and t.lhm_id = v_lam_lhm_id
            and ( ( nvl(t.order_pos_auf_id, 0) = nvl(in_auf_id, 0)
                    and in_neg_komm = c.c_false )
                  or ( nvl(t.order_pos_auf_id, 0) != nvl(in_auf_id, 0)
                       and in_neg_komm = c.c_true )
                  or ( t.menge != nvl(t.res_menge, 0)
                       and in_neg_komm = c.c_true ) )
        order by
            nvl(t.packschema_lfdn, t.lhm_c_lfd_nr) desc;

    begin
    -- Est mal keine Gebinde umgepackt Menge ist 0
        v_ges_menge := 0;
        v_benoetigte_menge := in_menge;
        v_res.kategorie_typ := null;
        if
            in_neg_komm = c.c_true     -- Bei negativ Kommissionierung
            and in_auf_id is null
        then
            v_err_nr := 5;
            v_err_text := lc.ec_p1(lc.o_tp1_buch_err, 'lvs_c_lte_menge_umpacken NEG_KOMM & AUF_ID NULL');
            raise v_error;
        end if;

        if isi_p_order_base.get_order_pos(in_sid, in_auf_id, v_order_pos) then
            open c_ziel_lte;
            fetch c_ziel_lte into v_ziel_lte;
            v_found := c_ziel_lte%found;
            close c_ziel_lte;
            if not v_found then
                v_err_nr := 20;
                v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_z_lte_id);
                raise v_error;
            end if;

            if (
                v_order_pos.satzart = 'MA'
                and v_ziel_lte.order_vorgang_id = v_order_pos.vorgang_id
            )
            or v_order_pos.satzart != 'MA' then
                v_vorgang_id := v_order_pos.vorgang_id;
                if v_ziel_lte.order_auf_id is null                          -- LTE hat keine AUF_ID dann setzte die aktuelle
                   or nvl(v_ziel_lte.order_auf_id, 0) = v_order_pos.auf_id then
                    v_auf_id := v_order_pos.auf_id;
                end if;

                if
                    v_ziel_lte.order_vorgang_id is not null                  -- LTE hat Reservierung
                    and v_auf_id is not null
                then
                    update lvs_lte t
                    set
                        t.order_vorgang_id = v_vorgang_id,
                        t.order_auf_id = v_auf_id
                    where
                        t.lte_id = v_ziel_lte.lte_id;

                elsif v_ziel_lte.order_vorgang_id is null                   -- Jetzt die Zielpalette Reservieren

                 then
                    v_anz_res := lvs_ausl.lvs_lte_reservieren(in_sid, in_firma_nr, v_vorgang_id, v_auf_id, in_z_lte_id,
                                                              v_vorgang_id, v_ziel_lte.lgr_platz, v_order_pos.artikel_id);
                end if;

                v_auf_id := v_order_pos.auf_id;
            end if;

        else
            if bde_p_base.get_fa_by_auf_id(in_sid, in_firma_nr, in_auf_id, v_bde_auf) then
                v_vorgang_id := v_bde_auf.leitzahl;
                v_auf_id := v_bde_auf.auf_id;
                v_anz_res := lvs_ausl.lvs_lte_reservieren(in_sid, in_firma_nr, v_bde_auf.leitzahl, v_bde_auf.auf_id, in_z_lte_id,
                                                          v_bde_auf.leitzahl, v_ziel_lte.lgr_platz, v_bde_auf.ag_artikel_id);

            end if;
        end if;

        if ( not isi_p_base.get_resource(in_sid, in_res_id, v_res) ) -- Jetzt RES lesen und ggf. kategorie_typ merken für Update der LTE ob die LTE zukünftig über eine KOMMPlatz in der Menge kontrolliert werden muss
        or v_res.kategorie != 'KOMM'
        or v_res.kategorie_typ not in ( 'TK', 'TD' ) then
            v_res.kategorie_typ := null;                             -- Keine Änderung Behältertransport (TD Direkt TK mit Kontrolle)
        end if;

        open c_lam_mg;
        fetch c_lam_mg into
            v_lam_lhm_id,
            v_auf_id,
            v_menge,
            v_res_menge;
        v_found := c_lam_mg%found;
        loop
            exit when not v_found
            or (
                in_neg_komm = c.c_false
                and v_ges_menge >= in_menge
            );
            if
                in_neg_komm = c.c_false     -- Bei normaler Kommissionierung
                and v_ges_menge <= in_menge
            then
        -- habe passende Gebinde gefunden
                if
                    v_menge <= in_menge - v_ges_menge -- Ganzes Gebinde umpacken
                    and ( v_res_menge = v_menge            -- -AG- 2015.09.04 Komplett Reserviert
                    or in_auf_id is null )
                then
                    v_auf_id := null;
                    v_vorgang_id := null;
                    lvs_p_lte_lhm.lvs_lhm_umpacken(in_sid, in_firma_nr, in_user_id, in_res_id, v_lam_lhm_id,
                                                   in_z_lte_id); -- Dann auf neue Palette umpacken
                    v_ges_menge := v_ges_menge + v_menge;                            -- Zählen des Gebinde
                    v_benoetigte_menge := v_benoetigte_menge - v_menge;
                else
                    v_lhm_id := null;
          -- Lesen der LAM-Einträge für diese LHM_ID (Meistens immer nur 1 Eintrag je LHM_ID
                    open c_lam;
                    fetch c_lam into v_lam;
                    v_found_lam := c_lam%found;
                    loop
                        exit when v_ges_menge >= in_menge
                        or not v_found_lam;
                        if in_auf_id is null then
                            v_menge := v_lam.menge;                                    -- Ohne Reservierung
                        else
                            v_menge := v_lam.res_menge;                                -- Reserviete Menge fürs umpacken
                        end if;

                        if ( v_menge > v_benoetigte_menge ) then
              -- WK 2015-09-14: Bei Kommi-Split wird auch schon mal weniger
              -- umgepackt als tatsächlich reserviert wurde, da der Rest auf ein
              -- neues Gebinde gepackt wird
                            v_menge := v_benoetigte_menge;
                        end if;
                        lvs_komm_direct_r359(in_sid, in_firma_nr, in_res_id, in_user_id, in_q_lte_id,
                                             v_lam.lam_id, v_menge, in_z_lte_id, v_lhm_id, v_neu_lam_id,
                                             v_neu_lhm_id);

                        v_ges_menge := v_ges_menge + v_menge;                      -- Zählen des Gebinde mit Menge auf Gesamtmenge
                        v_benoetigte_menge := v_benoetigte_menge - v_menge;
                        v_lhm_id := v_neu_lhm_id;
                        fetch c_lam into v_lam;                -- Versuch nächstes Gebinde zu lesen
                        v_found_lam := c_lam%found;                -- Merken ob ein weiteres gefunden wurde
                    end loop;

                    close c_lam;
                end if;
        -- Jetzt Quell_LTE evtl. die Reservierung rausnehmen
                open c_lam_res;
                fetch c_lam_res into
                    v_anz_res,
                    v_login_id;
                close c_lam_res;
                if nvl(v_anz_res, 0) = 0  -- Nichts mehr Reserviert auf der Quelle
                 then
                    v_anz_res := lvs_ausl.lvs_lte_res_rueck(in_sid, in_firma_nr, null, null, in_q_lte_id,
                                                            null, null, c.c_true);
                end if;

            elsif in_neg_komm = c.c_true     -- Bei negativ Kommissionierung ist die Menge egal. Es wird alles umgepackt, was nicht fuer die AUF_ID reserviert ist

             then
        -- Login_ID der Reservierung merken
                open c_lam_res;
                fetch c_lam_res into
                    v_anz_res,
                    v_login_id;
                close c_lam_res;
        -- habe passende Gebinde gefunden
                if nvl(v_auf_id, 0) != nvl(in_auf_id, 0) -- Ganzes Gebinde umpacken, da nicht Reserviert oder für anderen Auftrag
                 then
                    lvs_p_lte_lhm.lvs_lhm_umpacken(in_sid, in_firma_nr, in_user_id, in_res_id, v_lam_lhm_id,
                                                   in_z_lte_id); -- Dann auf neue Palette umpacken
                else
                    v_lhm_id := null;
                    open c_lam;
                    fetch c_lam into v_lam;
                    v_found_lam := c_lam%found;
                    loop
                        exit when not v_found_lam;
                        v_menge := v_lam.menge - nvl(v_lam.res_menge, 0);                     -- Menge nicht Reserviert
                        if v_menge > 0 then
                            if ( not isi_p_base.get_resource(in_sid, in_res_id, v_res) ) -- Jetzt RES lesen und ggf. kategorie_typ merken für Update der LTE ob die LTE zukünftig über eine KOMMPlatz in der Menge kontrolliert werden muss
                            or v_res.kategorie != 'KOMM'
                            or v_res.kategorie_typ not in ( 'TK', 'TD' ) then
                                v_res.kategorie_typ := null;
                            end if;

                            lvs_komm_direct_r359(in_sid, in_firma_nr, in_res_id, in_user_id, in_q_lte_id,
                                                 v_lam.lam_id, v_menge, in_z_lte_id, v_lhm_id, v_neu_lam_id,
                                                 v_neu_lhm_id);

                            v_lhm_id := v_neu_lhm_id;
                        end if;

                        fetch c_lam into v_lam;                -- Versuch nächstes Gebinde zu lesen
                        v_found_lam := c_lam%found;            -- Merken ob ein weiteres gefunden wurde
                    end loop;

                    close c_lam;
                end if;
        -- -AG- 2015.09.04 Bei negativer KOMMM Ziel wieder Reservierung löschen
                update lvs_lam t
                set
                    t.res_menge = null,
                    t.order_pos_auf_id = null,
                    t.res_ziel_lte_id = null,
                    t.res_login_id = null
                where
                    t.lte_id = v_auf_id;

                v_anz_res := lvs_ausl.lvs_lte_res_rueck(in_sid, in_firma_nr, null, null, in_z_lte_id,
                                                        null, null, c.c_true);

        -- -AG- 2015.09.04 Bei negativer KOMMM Quelle wieder Reservieren
                update lvs_lam t
                set
                    t.order_pos_auf_id = v_auf_id,
                    t.res_menge = t.menge,
                    t.res_ziel_lte_id = null,
                    t.res_login_id = v_login_id
                where
                    t.lte_id = v_auf_id;

                v_anz_res := lvs_ausl.lvs_lte_reservieren(in_sid, in_firma_nr, v_vorgang_id, v_auf_id, in_q_lte_id,
                                                          v_vorgang_id, null, v_order_pos.artikel_id);

        -- -AG- 2015.08.10 Buchen in der KOMM_ORDER alles fertig wenn NEG_KOMM
                update isi_komm_order t
                set
                    t.komm_ist_menge = t.komm_soll_menge
                where
                        t.auf_id = in_auf_id
                    and t.lte_id = in_q_lte_id
                    and nvl(t.komm_ziel_lte_id, in_z_lte_id) = in_z_lte_id;

            end if;

            fetch c_lam_mg into
                v_lam_lhm_id,
                v_auf_id,
                v_menge,
                v_res_menge;                -- Versuch nächstes Gebinde zu lesen
            v_found := c_lam_mg%found;                -- Merken ob ein weiteres gefunden wurde
        end loop;

        close c_lam_mg;
        if
            v_ges_menge != in_menge      -- Zu wenig Reserviert auf der Palette
            and in_neg_komm = c.c_false     -- Bei normaler Kommissionierung
        then
            v_err_nr := 5;
            v_err_text := lc.ec(lc.o_txt_menge_fehler);
            raise v_error;
        end if;

    /* Passiert jetzt im Transport fertig
    if v_order_pos.satzart in ('LNK', 'MAK')      -- Nachschub für Produktion oder Lager, dann muss die Reservierung aus dem Ziel genommen werden
    then
      v_anz_res := lvs_ausl.lvs_lte_res_rueck(in_sid,
                                              in_firma_nr,
                                              v_order_pos.vorgang_id,
                                              v_order_pos.auf_id,
                                              in_z_lte_id,
                                              v_order_pos.vorgang_id,
                                              v_ziel_lte.lgr_platz,
                                              c.C_TRUE);

    end if;
    */

    -- HJG Alt 2016-07-19 Jedes Zielgebinde ist direkt lieferbar
        update lvs_lte t
        set
            t.komm_menge_kontrolle = 'TD'
        where
            t.lte_id = in_z_lte_id;
    /* -- HJG 2016-07-19 Das war falsch
    update lvs_lte t
       set t.komm_menge_kontrolle = 'TD'
     where t.lte_id = in_q_lte_id
       and t.komm_menge_kontrolle != 'TK';
    */
        commit;

    /* -- HJG Alt 2016-07-19
     -- HJG 2016-07-19 Das war falsch */
        if v_res.kategorie_typ = 'TK' -- Hier wird jetzt eingetragen, ob die LTE zukünftig über eine KOMMPlatz in der Menge kontrolliert werden muss
         then
            update lvs_lte t
            set
                t.komm_menge_kontrolle = v_res.kategorie_typ,
                t.auto_depal = 'F'
            where
                t.lte_id = in_q_lte_id;

        else
            update lvs_lte t
            set
                t.komm_menge_kontrolle = 'TD'
            where
                t.lte_id in ( in_q_lte_id, in_z_lte_id )
                and t.komm_menge_kontrolle != 'TK';

        end if;

    /* -- HJG Alt 2016-07-19
    if v_res.kategorie_typ = 'TK' -- Hier wird jetzt eingetragen, ob die LTE zukünftig über eine KOMMPlatz in der Menge kontrolliert werden muss
    then
      if not lvs_p_base.get_lte(in_q_lte_id, v_quell_lte)
      then
        v_quell_lte.auto_depal := c.C_FALSE;
      end if;

      if v_order_pos.satzart in ('LNK', 'MAK')
      then
        update lvs_lte t
           set t.komm_menge_kontrolle = 'TD',
               t.auto_depal = v_quell_lte.auto_depal
         where t.lte_id =  in_z_lte_id;
      else
        update lvs_lte t
           set t.komm_menge_kontrolle = v_res.kategorie_typ,
               t.auto_depal = 'F'
         where t.lte_id in (in_q_lte_id, in_z_lte_id);
      end if;
    else
      update lvs_lte t
         set t.komm_menge_kontrolle = 'TD'
       where t.lte_id in (in_q_lte_id, in_z_lte_id)
         and t.komm_menge_kontrolle != 'TK';
    end if;
    */
    exception
    -- Im Fehlerfall ist der Fehler bereits gesetzt,
        when v_error then  -- Update 2011 show Exception Source Line
            if c_lam%isopen then
                close c_lam;
            end if;
            if c_lam_mg%isopen then
                close c_lam_mg;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        when others then
            if c_lam%isopen then
                close c_lam;
            end if;
            if c_lam_mg%isopen then
                close c_lam_mg;
            end if;
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
    end;

end lvs_komm;
/


-- sqlcl_snapshot {"hash":"138ed1ea442a350d69ab74648fee6d053b23acd0","type":"PACKAGE_BODY","name":"LVS_KOMM","schemaName":"DIRKSPZM32","sxml":""}