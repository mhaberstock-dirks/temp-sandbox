create or replace package body dirkspzm32.lvs_ausl is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr                number;
    v_err_text              varchar2(2550);
  -------------------------------------------------------------------------------------------------------

    v_last_id_bewertet      lvs_lte.lte_id%type;
    v_last_id_bewertet_wert number;
    v_last_id_bewertet_date date;
    v_ret_menge             number;

    procedure raise_isi_error (
        in_err_nr   in number,
        in_err_text in varchar2
    ) is
    begin
        v_err_nr := in_err_nr;
        v_err_text := in_err_text;
        raise v_error;
    end;

    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end get_version;

procedure lvs_ohne_transp_lte_pruefen (
    in_lte_id in lvs_lte.lte_id%type
);

  -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
    function lvs_lam_abgang_r_menge (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_out_artikel_id in out isi_artikel.artikel_id%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_lhm_id         in lvs_lhm.lhm_id%type,
        in_abnr           in bde_fa_auftrag.abnr%type,
        in_res_id         in isi_resource.res_id%type,
        in_abg_datum      in date,
        in_ls_login_id    in isi_user.login_id%type,
        in_vorgag_id      in lvs_lam_bh.vorg_id%type,
        in_bew_id         in s_send_bew.bew_id%type,
        in_leitzahl       in bde_fa_auftrag.leitzahl%type,
        in_fa_ag          in bde_fa_auftrag.fa_ag%type,
        in_fa_upos        in bde_fa_auftrag.fa_upos%type,
        in_abnr_extern    in bde_fa_auftrag.abnr%type,
        in_lam_bh_bus     in lvs_lam_bh.bus%type,
        in_tour           in isi_order_pos.vorgang_id%type,
        in_li_nr          in isi_order_pos.li_nr%type,
        in_li_pos_nr      in isi_order_pos.li_pos_nr%type,
        out_menge         out number
    ) return number is
        v_lam_id number;
    begin
        v_lam_id := lvs_lam_abgang(in_sid,            -- in isi_sid.sid%type,
         in_firma_nr,       -- in isi_firma.firma_nr%type,
         in_out_artikel_id, -- in out isi_artikel.artikel_id%type,
         in_lte_id,         -- in lvs_lte.lte_id%type,
         in_lhm_id,         -- in lvs_lhm.lhm_id%type,
                                   in_abnr,           -- in bde_fa_auftrag.abnr%type,
                                    in_res_id,         -- in isi_resource.res_id%type,
                                    in_abg_datum,      -- in date,
                                    in_ls_login_id,    -- in isi_user.login_id%type,
                                    in_vorgag_id,      -- in lvs_lam_bh.vorg_id%type,
                                   in_bew_id,         -- in s_send_bew.bew_id%type,
                                    in_leitzahl,       -- in bde_fa_auftrag.leitzahl%type,
                                    in_fa_ag,          -- in bde_fa_auftrag.fa_ag%type,
                                    in_fa_upos,        -- in bde_fa_auftrag.fa_upos%type,
                                    in_abnr_extern,    -- in bde_fa_auftrag.abnr%type,
                                   in_lam_bh_bus,     -- in lvs_lam_bh.bus%type,
                                    in_tour,           -- in isi_order_pos.vorgang_id%type
                                    in_li_nr,          -- in isi_order_pos.li_nr%type,
                                    in_li_pos_nr       -- in isi_order_pos.li_pos_nr%type
                                   );

        out_menge := v_ret_menge;
        return ( v_lam_id );
    end;

  -- Function and procedure implementations
    function lvs_lam_abgang (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_out_artikel_id in out isi_artikel.artikel_id%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_lhm_id         in lvs_lhm.lhm_id%type,
        in_abnr           in bde_fa_auftrag.abnr%type,
        in_res_id         in isi_resource.res_id%type,
        in_abg_datum      in date,
        in_ls_login_id    in isi_user.login_id%type,
        in_vorgag_id      in lvs_lam_bh.vorg_id%type,
        in_bew_id         in s_send_bew.bew_id%type,
        in_leitzahl       in bde_fa_auftrag.leitzahl%type,
        in_fa_ag          in bde_fa_auftrag.fa_ag%type,
        in_fa_upos        in bde_fa_auftrag.fa_upos%type,
        in_abnr_extern    in bde_fa_auftrag.abnr%type,
        in_lam_bh_bus     in lvs_lam_bh.bus%type,
        in_tour           in isi_order_pos.vorgang_id%type,
        in_li_nr          in isi_order_pos.li_nr%type,
        in_li_pos_nr      in isi_order_pos.li_pos_nr%type
    ) return number is

        v_lam_id      lvs_lam.lam_id%type;          -- Neu LAM_ID aus Sequenz
        v_lam_bh_id   lvs_lam_bh.lam_bh_id%type; -- Neu LAM_BH_ID aus Sequenz
        v_vorg_id     lvs_lam_bh.vorg_id%type;     -- Neu VORGang_ID aus Sequenz
        v_lam         lvs_lam%rowtype;                 -- Lager Artikel Bestands

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  -- -AG- BugFix für die Verarbeitung von Mischpaletten
        v_error exception;
        v_err_nr      number;
        v_err_text    varchar2(2550);
        v_found       boolean;
        v_lte_akt_lhm lvs_lte.lte_akt_lhm%type;
        v_bew         s_send_bew%rowtype;
        v_bew_lhm     s_send_bew%rowtype;
        v_fa_auftrag  bde_fa_auftrag%rowtype;
        v_art         isi_artikel%rowtype;
        v_charge      lvs_charge%rowtype;
        v_order_pos   isi_order_pos%rowtype;
        v_anz_frei    number;            -- Anzahl der nicht gesperrten VE's
        v_anz_gesp    number;            -- Anzahl der gesperrten VE's

        v_bew_id      number;

  -- Lesen des Lagerbestands für diese Lagerhilfsmittel
        cursor c_lhm is
        select
            *
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.lhm_id = in_lhm_id;
  -- Lesen des Lagerbestands für diese Transporteinheit
        cursor c_lte is
        select
            *
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.lte_id = in_lte_id
        order by
            lam.order_pos_auf_id;

  -- Lesen der Palette
        cursor c_lte_akt_lhm is
        select
            lte.lte_akt_lhm
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.lte_id = in_lte_id;

        cursor c_send_bew is
        select
            *
        from
            s_send_bew bew
        where
            bew.bew_id = in_bew_id;

        cursor c_send_bew_lhm is                    -- Suche eintrag in der Schnittstelle
        select
            *
        from
            s_send_bew bew
        where
                bew.lam_id = v_lam.lam_id
            and bew.lam_bh_typ = c.lam_bh_abgagng
            and bew.lhm_nr = v_lam.lhm_id
            and bew.status is null
            and bew.lam_bh_id is null;

        cursor c_fa_auftrag is
        select
            *
        from
            bde_fa_auftrag fa
        where
                fa.sid = in_sid
            and fa.firma_nr = in_firma_nr
            and fa.leitzahl = in_leitzahl
            and fa.ag_artikel_id = in_out_artikel_id;

        cursor c_fa_auftrag_l is
        select
            *
        from
            bde_fa_auftrag fa
        where
                fa.sid = in_sid
            and fa.firma_nr = in_firma_nr
            and fa.leitzahl = in_leitzahl
            and fa.fa_ag = in_fa_ag
            and fa.fa_upos = in_fa_upos;

  -- -AG- 26.11.2010 Fehler: Bei Mischpaletten muss der Artikel je LAM gelesen werden
        cursor c_art is
        select
            *
        from
            isi_artikel art
        where
            art.artikel_id = v_lam.artikel_id;

        cursor c_charge is
        select
            *
        from
            lvs_charge c
        where
            c.charge_id = v_lam.charge_id;

  -- -AG- fehler Mischpaletten
        cursor c_order_pos is
        select
            ord.*
        from
            isi_order_pos ord
        where
                ord.sid = in_sid
            and ord.firma_nr = in_firma_nr
            and ord.auf_id = v_lam.order_pos_auf_id;

    begin
        v_ret_menge := 0;
        v_anz_frei := 0;
        v_anz_gesp := 0;
        if
            in_lte_id is null
            and in_lhm_id is null
        then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_buchen_o_id_n_moeglich);
            raise v_error;
        end if;

        if in_vorgag_id is null then
            v_err_nr := 20;
            v_err_text := lc.ec(lc.o_txt_seq_err);
     -- Holen der neuen Nummern für diesen Vorgang
            select
                seq_vorg_id.nextval
            into v_vorg_id
            from
                dual;

        else
            v_vorg_id := in_vorgag_id;
        end if;

        v_err_nr := null;
        v_err_text := null;
        v_fa_auftrag.leitzahl := null;
        v_fa_auftrag.fa_ag := null;
        v_fa_auftrag.fa_upos := null;
        v_fa_auftrag.ag_id := null;
        if in_lhm_id is null then -- Kein Lagerhilfsmittel übergeben,dann buchen über Transporteinheit
            v_order_pos.auf_id := null; -- INIT
            open c_lte;
     -- Ersten Eintrag lesen
            fetch c_lte into v_lam;
            if c_lte%notfound then -- Kein Eintrag vorhanden, das ist ein Fehler (Abbruch)
                v_err_nr := 30;
                v_err_text := lc.ec_p1(lc.o_tp1_lte_id_ist_leer, in_lte_id);
       -- raise v_error; -AG- 2015.10.08 Ohne Menge muss nicht gebucht werden (Fuer Leeerbehaelter OK)
            else
                if v_lam.labor_status = c.lab_stat_f then
                    v_anz_frei := v_anz_frei + 1;                -- VE is nicht gesperrt
                else
                    v_anz_gesp := v_anz_gesp + 1;                -- VE gesperrt
                end if;

                in_out_artikel_id := v_lam.artikel_id;             -- Aus Stamm uebernehmen
                v_bew_id := in_bew_id;
                loop
         -- -AG- BugFix für die Verarbeitung von Mischpaletten
         -- Lesen der Order-POS falls nötig für jede LAM-Position der Palette
                    if v_order_pos.auf_id != v_lam.order_pos_auf_id
                    or v_order_pos.auf_id is null then
                        open c_order_pos;
                        fetch c_order_pos into v_order_pos; -- Lesen der ISI_ORDER
                        if c_order_pos%notfound then
                            v_order_pos.vorgang_id := null;
                            v_order_pos.li_nr := null;
                            v_order_pos.li_pos_nr := null;
                            v_order_pos := null;
                        end if;

                        close c_order_pos;
                    end if;

                    if v_bew_id is not null then
                        open c_send_bew_lhm;
                        fetch c_send_bew_lhm into v_bew_lhm;
                        v_found := c_send_bew_lhm%found;
                        close c_send_bew_lhm;

           -- BugFix Der Bezug zu dem FA muss in allen LHM's dieser Palette hergestellt werden
                        if
                            not v_found
                            and v_fa_auftrag.sid is not null
                        then
                            v_bew_id := s_schnittstelle.write_host_prod_bew(v_fa_auftrag.sid, v_fa_auftrag.firma_nr, v_fa_auftrag, null
                            , null,
                                                                            c.lam_bh_bus_abg, c.lam_bh_abgagng, 'S_FA', null);
                        end if;

                        open c_send_bew;
                        fetch c_send_bew into v_bew;
                        v_found := c_send_bew%found;
                        close c_send_bew;
                        if v_found then
                            v_fa_auftrag.ag_id := null;
                            v_fa_auftrag.leitzahl := null;
                            v_fa_auftrag.fa_ag := null;
                            v_fa_auftrag.fa_upos := null;
                            v_art.artikel := null;
                            open c_fa_auftrag_l;
                            fetch c_fa_auftrag_l into v_fa_auftrag;
                            if v_fa_auftrag.ab_artikel_id = in_out_artikel_id then
                                v_found := c_fa_auftrag_l%found;
                            else
                                v_found := false;
                            end if;

                            close c_fa_auftrag_l;
                            if not v_found then
                                open c_fa_auftrag;
                                fetch c_fa_auftrag into v_fa_auftrag;
                                v_found := c_fa_auftrag%found;
                                close c_fa_auftrag;
                            end if;

             -- -AG- Unabhängig ob der FA vorhanden oder nich muss immer der Artikel gelesen werden
                            open c_art;
                            fetch c_art into v_art;
                            v_found := c_art%found;
                            close c_art;
                            open c_charge;
                            fetch c_charge into v_charge;
                            close c_charge;
                            update s_send_bew bew
                            set
                                bew.auf_id = v_fa_auftrag.ag_id,
                                bew.artikel = nvl(v_art.artikel, bew.artikel), -- Bei Dummy MA nicht gefüllt
                                bew.lam_id = v_lam.lam_id,
                                bew.lhm_nr = v_lam.lhm_id,
                                bew.charge = v_charge.charge_bez,
                                bew.leitzahl = v_fa_auftrag.leitzahl,
                                bew.fa_ag = v_fa_auftrag.fa_ag,
                                bew.fa_upos = v_fa_auftrag.fa_upos,
                                bew.lam_ag = v_lam.fa_ag
                            where
                                bew.bew_id = v_bew_id;

                        end if;

                    end if;
         -- Holen der neuen Nummern für diese Buchung
                    v_err_nr := 40;
                    v_err_text := lc.ec(lc.o_txt_seq_err);
                    select
                        seq_lam_bh.nextval
                    into v_lam_bh_id
                    from
                        dual;

                    v_err_nr := 50;
                    v_err_text := lc.ec_p1(lc.o_tp1_buch_err, v_lam_bh_id);
                    insert into lvs_lam_bh values ( in_sid,
                                                    in_firma_nr,
                                                    v_vorg_id,
                                                    c.lam_bh_abgagng,
                                                    v_lam_bh_id,
                                                    v_lam.lam_id,
                                                    v_lam.artikel_id,
                                                    in_lam_bh_bus,
                                                    in_abg_datum,
                                                    in_ls_login_id,
                                                    v_lam.lgr_platz,
                                                    v_lam.lte_id,
                                                    v_lam.lhm_id,
                                                    v_lam.charge_id,
                                                    v_lam.serie_id,
                                                    in_abnr,
                                                    v_lam.menge,
                                                    v_lam.lam_kg,
                                                    v_lam.lam_kg / decode(v_lam.menge, 0, 1, v_lam.menge),
                                                    in_res_id,
                                                    v_fa_auftrag.leitzahl,
                                                    v_fa_auftrag.fa_ag,
                                                    v_fa_auftrag.fa_upos,
                                                    v_fa_auftrag.ag_id,
                                                    v_order_pos.vorgang_id,
                                                    v_order_pos.li_nr,
                                                    v_order_pos.li_pos_nr,
                                                    sysdate,                     -- CREATED_DATE          creation date+time of this dataset
                                                    in_ls_login_id,              -- CREATED_LOGIN_ID      login id of the user creating this dataset
                                                    sysdate,                     -- LAST_CHANGE_DATE      change date+time of this dataset
                                                    in_ls_login_id,              -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
                                                    null,                        -- CHANGE_MENGE          Menge die geändert wurde
                                                    v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                                                    null );                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
                    v_ret_menge := v_ret_menge + v_lam.menge;

         -- Kein Fehler
                    v_err_nr := null;
                    v_err_text := null;
                    fetch c_lte into v_lam;
                    exit when c_lte%notfound;
                end loop;

            end if;

            close c_lte;
     -- 09.10.2008 -AG- BugFix Hier ist die Palette immer ganz leer
            update lvs_lte lte
            set
                lte.lte_status = c.lte_ag_stat
            where
                    lte.sid = in_sid
                and lte.firma_nr = in_firma_nr
                and lte.lte_id = in_lte_id;

        else -- Lagerhilfsmittel übergeben,dann buchen über Lagerhilfsmittel
            open c_lhm;
     -- Eintrag lesen
            fetch c_lhm into v_lam;
            if c_lhm%notfound then -- Kein Eintrag vorhanden, das ist ein Fehler (Abbruch)
                v_err_nr := 70;
                v_err_text := lc.ec_p1(lc.o_tp1_lhm_id_fehlt, in_lhm_id);
                raise v_error;
            else
                if v_lam.labor_status = c.lab_stat_f then
                    v_anz_frei := v_anz_frei + 1;                -- VE is nicht gesperrt
                else
                    v_anz_gesp := v_anz_gesp + 1;                -- VE gesperrt
                end if;

                in_out_artikel_id := v_lam.artikel_id;             -- Aus Stamm uebernehmen
       -- Holen der neuen Nummern für diese Buchung
                if in_bew_id is not null then
                    open c_send_bew;
                    fetch c_send_bew into v_bew;
                    v_found := c_send_bew%found;
                    close c_send_bew;
                    if v_found then
                        open c_fa_auftrag;
                        v_fa_auftrag.ag_id := null;
                        v_art.artikel := null;
                        fetch c_fa_auftrag into v_fa_auftrag;
                        v_found := c_fa_auftrag%found;
                        close c_fa_auftrag;
                        if v_found then
                            open c_art;
                            fetch c_art into v_art;
                            close c_art;
                        end if;
                        open c_charge;
                        fetch c_charge into v_charge;
                        close c_charge;
                        update s_send_bew bew
                        set
                            bew.auf_id = v_fa_auftrag.ag_id,
                            bew.artikel = nvl(v_art.artikel, bew.artikel),
                            bew.lam_id = v_lam.lam_id,
                            bew.lhm_nr = v_lam.lhm_id,
                            bew.charge = v_charge.charge_bez,
                            bew.lam_ag = v_lam.fa_ag
                        where
                            bew.bew_id = in_bew_id;

                    end if;

                end if;

                v_err_nr := 80;
                v_err_text := lc.ec(lc.o_txt_seq_err);
                select
                    seq_lam_bh.nextval
                into v_lam_bh_id
                from
                    dual;

                v_err_nr := 90;
                v_err_text := lc.ec_p1(lc.o_tp1_buch_err, v_lam_bh_id);
                insert into lvs_lam_bh values ( in_sid,
                                                in_firma_nr,
                                                v_vorg_id,
                                                c.lam_bh_abgagng,
                                                v_lam_bh_id,
                                                v_lam.lam_id,
                                                in_out_artikel_id,
                                                in_lam_bh_bus,
                                                in_abg_datum,
                                                in_ls_login_id,
                                                v_lam.lgr_platz,
                                                v_lam.lte_id,
                                                v_lam.lhm_id,
                                                v_lam.charge_id,
                                                v_lam.serie_id,
                                                in_abnr,
                                                v_lam.menge,
                                                v_lam.lam_kg,
                                                v_lam.lam_kg / decode(v_lam.menge, 0, 1, v_lam.menge),
                                                in_res_id,
                                                in_leitzahl,
                                                in_fa_ag,
                                                in_fa_upos,
                                                in_abnr_extern,
                                                in_tour,
                                                in_li_nr,
                                                in_li_pos_nr,
                                                sysdate,                     -- CREATED_DATE          creation date+time of this dataset
                                                in_ls_login_id,              -- CREATED_LOGIN_ID      login id of the user creating this dataset
                                                sysdate,                     -- LAST_CHANGE_DATE      change date+time of this dataset
                                                in_ls_login_id,              -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
                                                null,                        -- CHANGE_MENGE          Menge die geändert wurde
                                                v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                                                null );                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
                v_ret_menge := v_ret_menge + v_lam.menge;
       -- Kein Fehler
                v_err_nr := null;
                v_err_text := null;
            end if;

            close c_lhm;
     -- 09.10.2008 -AG- BugFix Eine Palette darf nur dann den status AG bekommen, wenn sie leer ist
            open c_lte_akt_lhm;
            fetch c_lte_akt_lhm into v_lte_akt_lhm;
            close c_lte_akt_lhm;
            if nvl(v_lte_akt_lhm, 0) = 0 -- LTE ist leer dann Status AG
             then
                update lvs_lte lte
                set
                    lte.lte_status = c.lte_ag_stat
                where
                        lte.sid = in_sid
                    and lte.firma_nr = in_firma_nr
                    and lte.lte_id = in_lte_id;

            end if;

        end if;

        v_lam_id := v_lam.lam_id;  -- Letzen Eintrag merken
        if v_anz_gesp > 0 then
            if v_anz_frei > 0 then
                return ( -1 ); -- Freie und gesperrte VS's auf eine Palette
            end if;
            return ( -2 );  -- Nur gesperrte VE's auf der Palette
        end if;

        return ( v_lam_id );
    exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_lhm%isopen then
                close c_lhm;
            end if;
            if c_lte%isopen then
                close c_lte;
            end if;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_lhm%isopen then
                close c_lhm;
            end if;
            if c_lte%isopen then
                close c_lte;
            end if;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end lvs_lam_abgang;

    function lvs_pruefe_tour_ausl (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) return number is

        result         number;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr       number;
        v_err_text     varchar2(2550);
        v_found        boolean;                        -- Daten im CURSOR gefunden?
        v_order_kopf   isi_order_kopf%rowtype;         -- Auftragskopfdaten aus ISI-Order
        v_pos_wae      number;                         -- Anzahl Positionen ohne WA

        v_lkw_nr       number;
        v_sql_querry   varchar(4000);
        v_anz_o_quelle number;
        type t_order_kopf is ref cursor;
        c_order_kopf   t_order_kopf;

  -- KONSI-Lager berücksichtigen
        cursor c_pos is
        select
            count(pos.pos_nr)
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
            and pos.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                 'LNK' )
            and pos.vorgang_id = in_tour_nr
            and pos.ziel is null
        group by
            pos.vorgang_id;

        cursor c_pos_o_quelle is
        select
            count(op.vorgang_pos)
        from
            isi_order_pos op
        where
                op.vorgang_id = in_tour_nr
            and op.quell_lagerorte is null;

    begin
        v_err_nr := null;
        v_err_text := null;

  -- KONSI-Lager berücksichtigen
        v_sql_querry := 'select *'
                        || '  from isi_order_kopf k'
                        || ' where k.sid = '
                        || in_sid
                        || '  and k.satzart in (''LI'', ''RL'', ''LK'', ''MAK'', ''LAK'', ''LNK'') '
                        || '  and k.vorgang_typ in (''WAE'', ''KWA'', ''WAI'', ''WUI'') '
                        || '  and k.vorgang_id = '
                        || in_tour_nr;

        open c_order_kopf for v_sql_querry;

        fetch c_order_kopf into v_order_kopf;
        if v_order_kopf.lkw_nr is not null then
            v_lkw_nr := v_order_kopf.lkw_nr;
            close c_order_kopf;
    -- KONSI-Lager berücksichtigen
            v_sql_querry := 'select *'
                            || '  from isi_order_kopf k'
                            || ' where k.sid = '
                            || in_sid
                            || '  and k.satzart in (''LI'', ''RL'', ''LK'', ''MAK'', ''LAK'', ''LNK'') '
                            || '  and k.vorgang_typ in (''WAE'', ''KWA'', ''WAI'', ''WUI'') '
                            || '  and k.lkw_nr      = '
                            || v_lkw_nr
                            || '  and k.freigegeben_datum is NULL ';

            open c_order_kopf for v_sql_querry;

            fetch c_order_kopf into v_order_kopf;
        end if;

        loop
            v_found := c_order_kopf%found;
            if v_found then
                if nvl(v_order_kopf.freigabe_datum, sysdate) > sysdate then
                    v_err_nr := 10;
                    v_err_text := lc.ec_p3(lc.o_tp3_order_freidatum_err,
                                           in_tour_nr,
                                           v_order_kopf.li_nr,
                                           to_char(v_order_kopf.freigabe_datum, 'dd.mm.yyyy hh24:mi'));

                    raise v_error;
                end if;

                if
                    v_order_kopf.arbeitsplatz_id is null
                    and v_order_kopf.satzart not in ( 'MAK', 'LAK', 'LNK' )
                then
                    open c_pos_o_quelle;
                    fetch c_pos_o_quelle into v_anz_o_quelle;
                    close c_pos_o_quelle;
                    if nvl(v_anz_o_quelle, 0) > 0 then
                        v_err_nr := 20;
                        v_err_text := lc.ec_p2(lc.o_tp2_order_aktiv_ohne_arbplz, in_tour_nr, v_order_kopf.li_nr);
                        raise v_error;
                    end if;

                end if;

                if v_order_kopf.ziel is null then    -- Wenn im Kopf kein WA angegeben, dann muessen alle Position Eintraege haben
                    open c_pos;
                    fetch c_pos into v_pos_wae;
                    v_found := c_pos%found;
                    close c_pos;
                    if v_found then
                        v_err_nr := 30;
                        v_err_text := lc.ec_p1(lc.o_tp1_order_pos_wa_fehlt, in_tour_nr);
                        close c_order_kopf;
                        raise v_error;
                    end if;

                end if;
      -- KONSI-Lager berücksichtigen
                update isi_order_pos pos
                set
                    pos.ziel = v_order_kopf.ziel,
                    pos.arbeitsplatz_id = v_order_kopf.arbeitsplatz_id
                where
                        pos.sid = in_sid
                    and pos.firma_nr = in_firma_nr
                    and pos.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
                    and pos.satzart in ( 'LI', 'RL', 'LK'/*, 'MAK', 'LAK', 'LNK' */ ) -- -AG- Nicht bei KOMM-Aufträgen POS-Ziel verändern
                    and pos.vorgang_id = in_tour_nr
                    and pos.li_nr = v_order_kopf.li_nr;

            else
                exit;
            end if;

            fetch c_order_kopf into v_order_kopf;
        end loop;

        close c_order_kopf;
        return ( result );
    exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_order_kopf%isopen then
                close c_order_kopf;
            end if;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_order_kopf%isopen then
                close c_order_kopf;
            end if;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end lvs_pruefe_tour_ausl;

    function lvs_pruefe_lief_pos (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_lief_nr     in isi_order_pos.li_nr%type,
        in_lief_pos    in isi_order_pos.li_pos_nr%type,
        out_order_kopf out isi_order_kopf%rowtype,         -- Auftragskopfdaten aus ISI-Order
        in_typ         in varchar2,
        in_satzart     in varchar2,
        in_tour_nr     in isi_order_kopf.vorgang_id%type
    ) return number is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
        v_found    boolean;                        -- Daten im CURSOR gefunden?

        cursor c_order_kopf is
        select
            *
        from
            isi_order_kopf k
        where
                k.sid = in_sid
            and k.firma_nr = in_firma_nr
            and k.satzart = in_satzart
            and k.vorgang_id = nvl(in_tour_nr, k.vorgang_id)
            and k.vorgang_typ = in_typ
            and k.li_nr = in_lief_nr;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_order_kopf;
        fetch c_order_kopf into out_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if not v_found then
            v_err_nr := 20;
            v_err_text := lc.ec_p2(lc.o_tp2_order_lief_kopf_fehlt, in_lief_nr, in_lief_pos);
            raise v_error;
        end if;

        return ( 0 );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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
    end lvs_pruefe_lief_pos;

    function lvs_strategie_ausl_bewerten (
        in_mhd_tage      in number,   -- MHD Differnz in Tagen ab heute
        in_strategie     in varchar2, -- z.Zt. nur FIFI, LIFO
        in_blockierer    in number,   -- Paletten die im Weg sind für erste richtige Palette
        in_zug_datum     in number,   -- Zugangsdatum
        in_position      in number,   -- Position dieser Platte (Kanal, Einlagerzeitpunkt)
        in_lam_prod_date in lvs_lam.prod_datum%type
    ) return number is
        result      number;
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_prod_diff number;
    begin
  -- Differenz zwischen Heute und Produktionsdatum
        v_prod_diff := trunc(sysdate) - nvl(
            trunc(in_lam_prod_date),
            trunc(sysdate) - 1000
        );

        if in_strategie = 'LIFO' then
            result := in_mhd_tage * -1000000000000 + v_prod_diff * 10000000000 + in_blockierer * 1000000 + round(in_zug_datum * 1440,
            0) - 0.99 + in_position / 100;

        elsif in_strategie = 'FIFO' then
            result := in_mhd_tage * 1000000000000 + v_prod_diff * -10000000000 + in_blockierer * 1000000 + round(in_zug_datum * 1440,
            0) * -1 + in_position / 100;
        end if;

        return ( result );
    exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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
    end lvs_strategie_ausl_bewerten;

/*
@skip
Test-SQL für Platz Bewerten
select a.artikel,
       sum(m.menge) menge,
       m.mengeneinheit_basis,
       decode(lte.waren_typ, 'MP', 'Mix', lte.waren_typ) waren_typ,
       m.lgr_platz,
       (trunc(sysdate) - trunc(max(m.zug_datum))) reifezeit,
       max(m.zug_datum) zug_datum,
       a.reife_zeit_tage,
       m.labor_status,
       c.decode_labor_status_farbe(m.labor_status) labor,
       c.decode_lgr_sperre_farbe(l.gesperrt) lager,
       min(m.lam_mhd) lam_mhd,
       lte.res_mhd,
       l.lgr_platz_gruppe,
       l.lgr_dim_fifo_nr,
       l.gesperrt,
       l.uml_erlaubt,
       o.lgr_ort_modul,
       m.lte_id,
       stradd_distinct(m.lam_text) lam_text,
       min(m.lam_id),
       c.charge_bez,
       lvs_p_lgr_grp_fahrzeuge.chk_lte_lgr_zugriff_ok(lte.lte_id) lte_zugriff_ok,
       trunc(lvs_ausl.lvs_lte_platz_bewerten(m.sid,
                                             m.firma_nr,
                                             'FIFO',
                                             'I',
                                             lte.lte_voll,
                                             nvl(min(m.lam_mhd), lte.res_mhd),
                                             trunc(min(m.prod_datum)),
                                             lte.lte_id,
                                             lte.lgr_platz,
                                             lte.res_string,
                                             l.lgr_platz_gruppe,
                                             l.lgr_typ,
                                             m.artikel_id)) ausl_sort,
       lvs_ausl.lvs_lte_platz_bewerten(m.sid,
                                       m.firma_nr,
                                       'FIFO',
                                       'I',
                                       lte.lte_voll,
                                       nvl(min(m.lam_mhd),
                                           lte.res_mhd),
                                       trunc(min(m.prod_datum)),
                                       lte.lte_id,
                                       lte.lgr_platz,
                                       lte.res_string,
                                       l.lgr_platz_gruppe,
                                       l.lgr_typ,
                                       m.artikel_id) ausl_sort2,
       lte.rowid
  from isi_artikel a,
       lvs_lam     m,
       lvs_charge  c,
       lvs_lgr     l,
       lvs_lgr_ort o,
       lvs_lte     lte
 where m.artikel_id = a.artikel_id
   -- -WK- 2013-12-09 Konsi-Bestand ausschließen
   and m.owner_address_id is null
   and c.charge_id(+) = m.charge_id
   and l.lgr_platz = m.lgr_platz
   and (
        (l.lgr_verwendung = 'Lager' and lte.lte_status = 'LF')
        or (l.lgr_verwendung = 'Puffer' and lte.lte_status = 'LF')
        or (l.lgr_verwendung = 'WE' and lte.lte_status = 'BF')
        or (l.lgr_verwendung = 'LagerP' and l.lgr_dispo_einl_te = 0)
       )
   and o.sid = l.sid
   and o.firma_nr = l.firma_nr
   and o.lgr_ort = l.lgr_ort
   and lte.order_vorgang_id is null
   and lte.lte_id = m.lte_id
   --and lvs_p_lgr_grp_fahrzeuge.chk_lte_lgr_zugriff_ok(lte.lte_id) = 'T'
 group by
       a.artikel,
       m.mengeneinheit_basis,
       m.lgr_platz,
       a.reife_zeit_tage,
       m.labor_status,
       l.gesperrt,
       -- m.lam_mhd,
       lte.res_mhd,
       l.lgr_platz_gruppe,
       l.lgr_dim_fifo_nr,
       l.gesperrt,
       l.uml_erlaubt,
       o.lgr_ort_modul,
       m.lte_id,
       c.charge_bez,
       lte.lte_id,
       lte.waren_typ,
       m.sid,
       m.firma_nr,
       lte.lte_voll,
       -- m.lam_mhd,
       lte.res_mhd,
       -- m.prod_datum,
       lte.lgr_platz,
       lte.res_string,
       l.lgr_platz_gruppe,
       l.lgr_typ,
       l.lgr_dim_p,
       m.artikel_id,
       lte.rowid
 order by a.artikel,
          decode(isi_allg.get_firma_cfg_param(m.sid,
                                              m.firma_nr,
                                              'AUSL_STRAT',
                                              null,
                                              'STRENG_FIFO',
                                              'LVS',
                                              'CFG',
                                              'F',
                                              'BOOLEAN'),
                                              'T', min(m.prod_datum) - sysdate,
                                              0),
          ausl_sort,
          -- in der PL  ---> decode(v_streng_fifo, 'T', 'X', decode(v_kl_menge_prio, 'T', 'X', lgr.lgr_platz_gruppe)),
          decode(isi_allg.get_firma_cfg_param(m.sid,
                                              m.firma_nr,
                                              'AUSL_STRAT',
                                              null,
                                              'STRENG_FIFO',
                                              'LVS',
                                              'CFG',
                                              'F',
                                              'BOOLEAN'),
                 'T',
                 'X',
                 decode(isi_allg.get_firma_cfg_param(m.sid,
                                                     m.firma_nr,
                                                     'AUSL_STRAT',
                                                     null,
                                                     'KL_MENGE_PRIO',
                                                     'LVS',
                                                     'CFG',
                                                     'F',
                                                     'BOOLEAN'),
                        'T',
                        'X',
                        l.lgr_platz_gruppe)),
          -- in der PL  ---> decode(v_streng_fifo, 'T', 'X', decode(v_kl_menge_prio, 'T', 'X', lgr.lgr_dim_p)),
          decode(isi_allg.get_firma_cfg_param(m.sid,
                                              m.firma_nr,
                                              'AUSL_STRAT',
                                              null,
                                              'STRENG_FIFO',
                                              'LVS',
                                              'CFG',
                                              'F',
                                              'BOOLEAN'),
                 'T',
                 'X',
                 decode(isi_allg.get_firma_cfg_param(m.sid,
                                                     m.firma_nr,
                                                     'AUSL_STRAT',
                                                     null,
                                                     'KL_MENGE_PRIO',
                                                     'LVS',
                                                     'CFG',
                                                     'F',
                                                     'BOOLEAN'),
                        'T',
                        'X',
                        l.lgr_dim_p)),
          ausl_sort2,
          -- in der PL  ---> decode(v_streng_fifo, 'T', min(lam.prod_datum) - sysdate, 0),
          decode(isi_allg.get_firma_cfg_param(m.sid,
                                              m.firma_nr,
                                              'AUSL_STRAT',
                                              null,
                                              'STRENG_FIFO',
                                              'LVS',
                                              'CFG',
                                              'F',
                                              'BOOLEAN'),
                 'T',
                 min(m.prod_datum) - sysdate,
                 0),
          -- in der PL  ---> decode(v_kl_menge_prio, 'T', sum(lam.menge), 0);
          decode(isi_allg.get_firma_cfg_param(m.sid,
                                              m.firma_nr,
                                              'AUSL_STRAT',
                                              null,
                                              'KL_MENGE_PRIO',
                                              'LVS',
                                              'CFG',
                                              'F',
                                              'BOOLEAN'),
                 '
                                               T',
                 sum(m.menge),
                 0)

*/
    function lvs_lte_platz_bewerten (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_order_strategie  in isi_order_pos.strategie%type,
        in_order_anbruch    in isi_order_pos.anbruch%type,
        in_lte_voll         in lvs_lte.lte_voll%type,
        in_lam_mhd          in lvs_lam.lam_mhd%type,
        in_lam_prod_datum   in lvs_lam.prod_datum%type,
        in_lte_id           in lvs_lte.lte_id%type,
        in_lte_lgr_platz    in lvs_lgr.lgr_platz%type,
        in_lte_res_string   in lvs_lgr.res_string%type,
        in_lgr_platz_gruppe in lvs_lgr.lgr_platz_gruppe%type,
        in_lgr_platz_typ    in lvs_lgr.lgr_typ%type,
        in_artikel_id       in isi_artikel.artikel_id%type
    ) return number is

        result               number;
  ------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  ------------------------------------------------------------------------------
        v_error exception;
        v_err_nr             number;
        v_err_text           varchar2(2550);
        v_lgr                lvs_lgr%rowtype;           -- Lagerdaten (Lagerplatz)
        v_lte_lgr            lvs_lgr%rowtype;           -- Lagerdaten (Lagerplatz)
        v_lte                lvs_lte%rowtype;           -- Lagerdaten (Paletten LTE)
        v_lte_cfg            lvs_lte_cfg%rowtype;       -- LTE_Konfig (Paletten LTE)
        v_artikel            isi_artikel%rowtype;       -- Artikeldaten

        v_blockierer         number;
        v_lgr_dispo_einl_te  number;
        v_lam_mhd            date;
        v_zugdatum           date;
        v_zugdatumd          number;
        v_position           number;
        v_lam_mg_sum         number;
        v_lam_p_datum        date;
        v_lam_prod_datum     lvs_lam.prod_datum%type;
        v_lam_min_prod_datum lvs_lam.prod_datum%type;
        cursor c_lgr is
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.sid = in_sid
            and lgr.lgr_platz = in_lte_lgr_platz;

        cursor c_lgr_zug_datum is
        select
            max(lam.zug_datum),
            trunc(min(lam.prod_datum)),
            sum(lgr.lgr_dispo_einl_te)
        from
            lvs_lgr lgr,
            lvs_lam lam
        where
                lgr.lgr_platz_gruppe = in_lgr_platz_gruppe
            and lgr.lgr_platz = lam.lgr_platz (+)
            and lam.artikel_id (+) = in_artikel_id
        group by
            lgr.lgr_platz_gruppe;

        cursor c_lgr_seg1 is
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.sid = in_sid
            and lgr.lgr_platz_gruppe = in_lgr_platz_gruppe
            and lgr.lgr_dim_g = v_lte_lgr.lgr_dim_g
            and lgr.lgr_dim_r = v_lte_lgr.lgr_dim_r
            and lgr.lgr_dim_p = v_lte_lgr.lgr_dim_p
            and lgr.lgr_dim_e = v_lte_lgr.lgr_dim_e
            and lgr.lgr_dim_fifo_nr > v_lte_lgr.lgr_dim_fifo_nr + decode(lgr.lgr_typ, c.r_seg_duedo1, 1, 0)
        order by
            lgr.lgr_dim_platz,
            lgr.lgr_dim_fifo_nr desc;

        cursor c_lgr_sat1_kanal1 is
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.sid = in_sid
            and lgr.lgr_platz_gruppe = in_lgr_platz_gruppe
        order by
            lgr.lgr_dim_fifo_nr desc;

        cursor c_lgr_kanal_bkl1 is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and ( lte.lgr_platz = in_lte_lgr_platz
                  and lte.ziel_lgr_platz is null
                  or lte.ziel_lgr_platz = in_lte_lgr_platz
                  or lte.ziel_lgr_platz_n_freif = in_lte_lgr_platz )
       --and lte.res_string = in_lte_res_string
       --and lte.ziel_lgr_ort is NULL                  -- Noch keine Auslagerung auf diese Palette geplant
        order by
            lte.res_mhd,
            lte.lte_letzte_buchung desc;

        cursor c_lgr_stap_flae is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and ( lte.lgr_platz = in_lte_lgr_platz
                  and lte.ziel_lgr_platz is null
                  or lte.ziel_lgr_platz = in_lte_lgr_platz
                  or lte.ziel_lgr_platz_n_freif = in_lte_lgr_platz )
       --and lte.res_string = in_lte_res_string
       --and lte.ziel_lgr_ort is NULL                  -- Noch keine Auslagerung auf diese Palette geplant
        order by
            lte.lte_offset_z desc;

        cursor c_lgr_durchl1 is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and ( lte.lgr_platz = in_lte_lgr_platz
                  and lte.ziel_lgr_platz is null
                  or lte.ziel_lgr_platz = in_lte_lgr_platz
                  or lte.ziel_lgr_platz_n_freif = in_lte_lgr_platz )
       --and lte.res_string = in_lte_res_string
       --and lte.ziel_lgr_ort is NULL                  -- Noch keine Auslagerung auf diese Palette geplant
        order by
            lte.lte_letzte_buchung;

        cursor c_lgr_bkl1 is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and ( lte.lgr_platz = in_lte_lgr_platz
                  and lte.ziel_lgr_platz is null
                  or lte.ziel_lgr_platz = in_lte_lgr_platz
                  or lte.ziel_lgr_platz_n_freif = in_lte_lgr_platz )
       --and lte.res_string = in_lte_res_string
       --and lte.ziel_lgr_ort is NULL                  -- Noch keine Auslagerung auf diese Palette geplant
        order by
            lte.res_mhd,
            lte.lte_letzte_buchung desc;

        cursor c_lam is
        select
            trunc(min(l.prod_datum))
        from
            lvs_lam l
        where
                l.sid = in_sid
            and l.firma_nr = v_lgr.firma_nr
            and l.lgr_platz = v_lgr.lgr_platz;

        cursor c_lam_mg_sum is
        select
            nvl(
                sum(l.menge),
                0
            )
        from
            lvs_lam l
        where
                l.sid = in_sid
            and l.lte_id = in_lte_id
            and l.artikel_id = in_artikel_id;

        cursor c_lam_min_mhd is
        select
            trunc(min(l.lam_mhd)),
            trunc(min(l.prod_datum))
        from
            lvs_lam l,
            lvs_lgr lgr
        where
                l.sid = in_sid
            and l.firma_nr = in_firma_nr
            and l.artikel_id = in_artikel_id
            and l.lgr_platz = lgr.lgr_platz
            and lgr.lgr_platz_gruppe = in_lgr_platz_gruppe
        group by
            lgr.lgr_platz_gruppe;

    begin
        v_lte.lte_id := null; -- init
        if v_last_id_bewertet != in_lte_id
        or nvl(v_last_id_bewertet_date, sysdate - 1) != sysdate
        or v_last_id_bewertet is null then
            v_lam_mhd := in_lam_mhd;
            v_lam_min_prod_datum := null;
            v_lam_prod_datum := in_lam_prod_datum;
            v_last_id_bewertet_date := sysdate;
            v_blockierer := 0;                                 -- Keine Paletten im Weg
            v_position := 0;                                   -- Noch keine Position gefunden
            if in_lgr_platz_typ = c.sat1
            or                    -- Bei Kanal und Blocklaegern die Position beachten
             in_lgr_platz_typ = c.kanal1 then
                if isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'AUSL_STRAT', null, 'FIFO_LGR_PLATZ_GRP_GLEICH',
                                                'LVS', 'CFG', 'F', 'BOOLEAN') = c.c_true then
                    open c_lam_min_mhd;
                    fetch c_lam_min_mhd into
                        v_lam_mhd,
                        v_lam_min_prod_datum;
                    close c_lam_min_mhd;
                end if;

                open c_lgr_sat1_kanal1;
                loop
                    fetch c_lgr_sat1_kanal1 into v_lgr;
                    exit when c_lgr_sat1_kanal1%notfound
                    or v_lgr.lgr_platz = in_lte_lgr_platz;
                    if v_lgr.res_string != in_lte_res_string then
          -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
                        if
                            nvl(v_lgr.uml_erlaubt, c.c_true) != c.c_false
                            and isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'AUSL_STRAT', null, 'FIFO_LGR_PLATZ_GRP_GLEICH',
                                                             'LVS', 'CFG', 'F', 'BOOLEAN') = c.c_false
                        then
                            open c_lam;
                            fetch c_lam into v_lam_p_datum;
                            close c_lam;
                            if in_lam_prod_datum < v_lam_p_datum then
                                v_lam_prod_datum := v_lam_p_datum;
                                v_blockierer := v_blockierer + v_lgr.lgr_akt_te - nvl(v_lgr.lgr_dispo_ausl_te, 0);
                            end if;
--          else
--            v_blockierer := v_blockierer + 1;
                        end if;
                    end if;

                    v_position := v_position + v_lgr.lgr_akt_te + v_lgr.lgr_dim_fifo_nr;
                end loop;

                close c_lgr_sat1_kanal1;
            elsif in_lgr_platz_typ = c.seg1
            or in_lgr_platz_typ = c.seg_duedo1 then
                open c_lgr;
                fetch c_lgr into v_lte_lgr;
                close c_lgr;
                if isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'AUSL_STRAT', null, 'FIFO_LGR_PLATZ_GRP_GLEICH',
                                                'LVS', 'CFG', 'F', 'BOOLEAN') = c.c_true then
                    open c_lam_min_mhd;
                    fetch c_lam_min_mhd into
                        v_lam_mhd,
                        v_lam_min_prod_datum;
                    close c_lam_min_mhd;
                end if;

                open c_lgr_seg1;
                loop
                    fetch c_lgr_seg1 into v_lgr;
                    exit when c_lgr_seg1%notfound
                    or v_lgr.lgr_platz = in_lte_lgr_platz;
                    if v_lgr.res_string != in_lte_res_string then
                        v_blockierer := v_blockierer + 1;
                    else
          -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
                        if
                            nvl(v_lgr.uml_erlaubt, c.c_true) != c.c_false
                            and isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'AUSL_STRAT', null, 'FIFO_LGR_PLATZ_GRP_GLEICH',
                                                             'LVS', 'CFG', 'F', 'BOOLEAN') = c.c_false
                        then
                            open c_lam;
                            fetch c_lam into v_lam_p_datum;
                            close c_lam;
                            if in_lam_prod_datum < v_lam_p_datum then
                                v_lam_prod_datum := v_lam_p_datum;
                                v_blockierer := v_blockierer + 1;
                            end if;

                        end if;
                    end if;

                    v_position := v_position + v_lgr.lgr_akt_te + v_lgr.lgr_dim_fifo_nr;
                end loop;

                close c_lgr_seg1;
            elsif in_lgr_platz_typ = c.kanal_bkl1
     --  or in_lgr_platz_typ = c.REG_FACH1
             then
                open c_lgr_kanal_bkl1;
                loop
                    fetch c_lgr_kanal_bkl1 into v_lte;               -- Palettendaten lesen
                    exit when c_lgr_kanal_bkl1%notfound
                    or v_lte.lte_id = in_lte_id;
                    if v_lte.res_string != in_lte_res_string
                    or v_lte.ziel_lgr_platz = in_lte_lgr_platz
                    or v_lte.ziel_lgr_platz_n_freif = in_lte_lgr_platz then
                        v_blockierer := v_blockierer + 1;
                    end if;

                    v_position := v_position + 1;
                end loop;

                close c_lgr_kanal_bkl1;
            elsif in_lgr_platz_typ = c.stap_flae1
            or in_lgr_platz_typ = c.stap_flae2 then
                open c_lgr_stap_flae;
                loop
                    fetch c_lgr_stap_flae into v_lte;               -- Palettendaten lesen
                    exit when c_lgr_stap_flae%notfound
                    or v_lte.lte_id = in_lte_id;
                    if v_lte.res_string != in_lte_res_string
                    or v_lte.ziel_lgr_platz = in_lte_lgr_platz
                    or v_lte.ziel_lgr_platz_n_freif = in_lte_lgr_platz then
                        v_blockierer := v_blockierer + 1;
                    end if;

                    v_position := v_position + 1;
                end loop;

                close c_lgr_stap_flae;
            elsif in_lgr_platz_typ = c.durchl1 then
                open c_lgr_durchl1;
                loop
                    fetch c_lgr_durchl1 into v_lte;               -- Palettendaten lesen
                    exit when c_lgr_durchl1%notfound
                    or v_lte.lte_id = in_lte_id;
                    v_blockierer := v_blockierer + 1;
                    v_position := v_position + 1;
                end loop;

                close c_lgr_durchl1;
    /* Jedes andere Lager nach MHD / Produktionsdatum
    else                                                 -- Blocklager
      OPEN c_lgr_bkl1;
      LOOP
        FETCH c_lgr_bkl1 into v_lte;               -- Palettendaten lesen
        EXIT when c_lgr_bkl1%NOTFOUND or
                  v_lte.lte_id = in_lte_id;
        if v_lte.res_string != in_lte_res_string
        or v_lte.ziel_lgr_platz = in_lte_lgr_platz
        or v_lte.ziel_lgr_platz_n_freif = in_lte_lgr_platz then
          v_blockierer := v_blockierer + 1;
        end if;
        v_position := v_position + 1;
      end LOOP;
      CLOSE c_lgr_bkl1;
    */
            end if;

            open c_lgr_zug_datum;
            fetch c_lgr_zug_datum into
                v_zugdatum,
                v_lam_min_prod_datum,
                v_lgr_dispo_einl_te;
            close c_lgr_zug_datum;
            if c.c_false = isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'AUSL_STRAT', null, 'STRENG_FIFO',
                                                        'LVS', 'CFG', 'F', 'BOOLEAN') then
                v_zugdatumd := sysdate - v_zugdatum;
            else
                v_zugdatumd := 1;
      -- -WK- 15.09.2008 Bei streng FIFO keine Berücksichtigung der Einlagerdispo
                v_lgr_dispo_einl_te := 0;
            end if;
    -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
            if
                nvl(v_lgr.uml_erlaubt, c.c_true) = c.c_false
                and v_lam_min_prod_datum is not null
            then
                v_lam_prod_datum := v_lam_min_prod_datum;
            end if;

            if
                isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'AUSL_STRAT', null, 'FIFO_LGR_PLATZ_GRP_GLEICH',
                                             'LVS', 'CFG', 'F', 'BOOLEAN') = c.c_true
                and v_lam_min_prod_datum is not null
            then
                v_lam_prod_datum := v_lam_min_prod_datum;
            end if;

            result := ( trunc(v_lam_mhd) - trunc(sysdate) );     -- Erst mal diifferenz in Tagen für MHD rechnen !!
            result := lvs_strategie_ausl_bewerten(result,
                                                  in_order_strategie,
                                                  v_blockierer,
                                                  v_zugdatumd,
                                                  v_position,
                                                  trunc(v_lam_prod_datum));

            result := result + 1000000000000000;
            if
                nvl(in_lte_voll, c.lte_voll_v) = c.lte_voll_v
                and in_order_anbruch = c.c_anbruch_ausnahme
            then
                result := result - 1000000000000000;
            elsif
                nvl(in_lte_voll, c.lte_voll_v) != c.lte_voll_v
                and in_order_anbruch = c.c_anbruch_vorzug
            then
                result := result - 1000000000000000;
      -- HJG 20190719 Bei Anbruch auch prüfen, ob die LHM auf der Paltette noch voll sind dann entsprechend beachten
                if v_lte.lte_id is null then
                    if not lvs_p_base.get_lte(in_lte_id, v_lte) then
                        v_lte.lte_id := null;
                    end if;

                end if;

                if v_lte.lte_id is not null then
                    if not lvs_p_base.get_lte_cfg(v_lte.sid, v_lte.lte_name, v_lte_cfg) -- LTE_Konfig lesen ob Behälter oder Palette
                     then
                        v_lte_cfg.transport_einheit := null;
                    end if;
                end if;
      -- -AG- 20190719 - Erweiterung Belimo allgemein gültig für Behälter
                if v_lte_cfg.transport_einheit = 'LTE_LHM'  -- Behälter - LHMs
                 then
                    if
                        isi_allg.get_artikel_by_artikel_id(in_sid, in_artikel_id, v_artikel)
                        and v_artikel.lhm_menge > 0
                    then
                        open c_lam_mg_sum; -- Std-Behaeltermenge holen
                        fetch c_lam_mg_sum into v_lam_mg_sum;
                        close c_lam_mg_sum;
                        if mod(v_lam_mg_sum, v_artikel.lhm_menge) = 0 then
                            result := result + 100000000000000;
                        else
                            result := result - 100000000000000;
                        end if;

                    end if;
                end if;

            elsif in_order_anbruch = c.c_volle_behaelter -- -AG- Neue Variante Volle Behälter (HUF)

             then
                if
                    isi_allg.get_artikel_by_artikel_id(in_sid, in_artikel_id, v_artikel)
                    and v_artikel.lhm_menge > 0
                then
                    open c_lam_mg_sum; -- Std-Behaeltermenge holen
                    fetch c_lam_mg_sum into v_lam_mg_sum;
                    close c_lam_mg_sum;
                    if mod(v_lam_mg_sum, v_artikel.lhm_menge) != 0 then
                        result := result + 10000000000000000;
                    elsif v_lam_mg_sum >= v_artikel.lhm_menge then
                        result := result - 1000000000000000;
                    end if;

                end if;
            end if;

            if v_lgr_dispo_einl_te > 0 then
                result := result * 10000;
            end if;
            v_last_id_bewertet_wert := result;
        else
            result := v_last_id_bewertet_wert;
        end if;

        return ( result );
    exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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
    end lvs_lte_platz_bewerten;

    function lvs_lte_reservieren (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_vorgang_id     in isi_transport.vorgang_id%type,
        in_auftrag_id     in isi_transport.auf_id%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_lte_vorgang_id in isi_transport.vorgang_id%type,
        in_lte_lgr_platz  in lvs_lte.lgr_platz%type,
        in_artikel_id     in isi_artikel.artikel_id%type
    ) return number is
        v_result number;
    begin
        v_result := lvs_lte_reserv_user_ziel(in_sid, in_firma_nr, in_vorgang_id, in_auftrag_id, in_lte_id,
                                             in_artikel_id, null, null);

        return ( v_result );
    end;

    function lvs_lte_reserv_user_ziel (
        in_sid                in isi_sid.sid%type,
        in_firma_nr           in isi_firma.firma_nr%type,
        in_vorgang_id         in isi_transport.vorgang_id%type,
        in_auftrag_id         in isi_transport.auf_id%type,
        in_lte_id             in lvs_lte.lte_id%type,
        in_artikel_id         in isi_artikel.artikel_id%type,
        in_res_login_id       in lvs_lte.res_login_id%type,
        in_res_ziel_lgr_platz in lvs_lte.res_ziel_lgr_platz%type,
        in_lhm_id             in lvs_lam.lhm_id%type default null
    ) return number is
        v_result number;
        v_lte    lvs_lte%rowtype;
    begin
        v_result := 0;
        if not lvs_p_base.get_lte(in_lte_id, v_lte) then
            raise_isi_error(5,
                            lc.ec_p1(lc.o_tp1_lte_id_fehlt, v_lte.lte_id));
      -- raise_isi_error(5, 'Für die LTE ID ' || nvl(in_lte_id, 'NULL') || ' konnten keine Daten gefunden werden.');
        end if;

    /* -AG- Hier nicht mehr Prüfen
    if  v_lte.lte_status != C.LTE_LF_STAT
    and v_lte.lte_status != C.LTE_BF_STAT
    and v_lte.lte_status != C.LTE_AF_STAT
    and v_lte.lte_status != C.LTE_UF_STAT
    then
      raise_isi_error(10, LC.ec_p2(LC.O_TP2_LTE_ID_ST_N_AUSL_BAR, v_lte.lte_id, v_lte.lte_status));
      --- raise_isi_error(10, 'LTE ' || v_lte.lte_id || ' mit Status ' || v_lte.lte_status || 'kann nicht Reserviert werden');
    end if;
    */

    -- LAM reservieren
    -- CMe 20220811: Nur alle LAM's reservieren, die noch MHD haben
    -- CMe 20230411 (W23910-343): Nur alle LAM's reservieren, die noch im Laborstatus (F)rei ist
        update lvs_lam lam
        set
            lam.order_pos_auf_id = in_auftrag_id,
            lam.res_menge = decode(in_auftrag_id, null, null, lam.menge),
            lam.res_login_id = in_res_login_id
        where
                lam.lte_id = in_lte_id
            and lam.artikel_id = in_artikel_id
            and nvl(lam.lhm_id, 'keine') = nvl(in_lhm_id,
                                               nvl(lam.lhm_id, 'keine'))
            and lam.lam_mhd >= sysdate
            and lam.order_pos_auf_id is null
            and lam.labor_status = c.lab_stat_f;

    -- LTE reservieren
        update lvs_lte lte
        set
            lte.order_vorgang_id = in_vorgang_id,
            lte.order_auf_id = in_auftrag_id,
            lte.res_login_id = in_res_login_id,
            lte.res_ziel_lgr_platz = in_res_ziel_lgr_platz
        where
                lte.sid = in_sid
            and lte.lte_id = in_lte_id;

    -- Anzahl der Resevierungen auf LGR Platz aktualisieren
        update lvs_lgr lgr
        set
            lgr.lgr_order_res_te = lgr.lgr_order_res_te + 1
        where
                lgr.sid = in_sid
            and lgr.lgr_platz = v_lte.lgr_platz;

        return ( v_result );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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

    function lvs_c_lte_reservieren (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_vorgang_id     in isi_transport.vorgang_id%type,
        in_auftrag_id     in isi_transport.auf_id%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_lte_vorgang_id in isi_transport.vorgang_id%type,
        in_lte_lgr_platz  in lvs_lte.lgr_platz%type,
        in_artikel_id     in isi_artikel.artikel_id%type
    ) return number is
  -------------------------------------------------------------------------

        result     number;

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
    begin
        result := lvs_lte_reservieren(in_sid, in_firma_nr, in_vorgang_id, in_auftrag_id, in_lte_id,
                                      in_lte_vorgang_id, in_lte_lgr_platz, in_artikel_id);

        commit;
        return ( result );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
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

    end lvs_c_lte_reservieren;

    function lvs_lte_res_rueck (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_vorgang_id     in isi_transport.vorgang_id%type,
        in_auftrag_id     in isi_transport.auf_id%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_lte_vorgang_id in isi_transport.vorgang_id%type,
        in_lte_lgr_platz  in lvs_lte.lgr_platz%type,
        in_res_user_rueck in varchar2
    ) return number is
  -------------------------------------------------------------------------

        result        number;

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr      number;
        v_err_text    varchar2(2550);
        v_vorgang_id  isi_order_pos.vorgang_id%type;
        v_anz_lam_res number;                         -- Anzahl der noch rreservierten LAM's auf dieser Palette
        v_lgr_platz   lvs_lgr.lgr_platz%type;
        v_lte         lvs_lte%rowtype;
        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.lte_id = in_lte_id;

        cursor c_lam is
        select
            count(lam.lte_id)
        from
            lvs_lam lam
        where
                lam.lte_id = in_lte_id
            and lam.order_pos_auf_id is not null
        group by
            lam.lte_id;

    begin
        update lvs_lam lam
        set
            lam.order_pos_auf_id = null,
            lam.res_menge = null,
            lam.res_ziel_lte_id = null,
            lam.res_login_id = null
        where
                lam.lte_id = in_lte_id
            and lam.order_pos_auf_id = in_auftrag_id;

        open c_lam;
        fetch c_lam into v_anz_lam_res;
        if c_lam%found then
            v_vorgang_id := in_vorgang_id;
        else
            v_vorgang_id := null;
        end if;

        close c_lam;
        v_lgr_platz := in_lte_lgr_platz;
        if v_lgr_platz is null then
            open c_lte;
            fetch c_lte into v_lte;
            close c_lte;
            v_lgr_platz := v_lte.lgr_platz;
        end if;

        update isi_komm_order t
        set
            t.status = 'KE'
        where
                t.auf_id = in_auftrag_id
            and t.lte_id = in_lte_id;

        update lvs_lte lte
        set
            lte.order_vorgang_id = v_vorgang_id,
            lte.order_auf_id = null,
            lte.res_ziel_lgr_platz = null
        where
            lte.lte_id = in_lte_id;

        if in_res_user_rueck = c.c_true then
            update lvs_lte lte
            set
                lte.res_login_id = null
            where
                lte.lte_id = in_lte_id;

        end if;

        update lvs_lgr lgr
        set
            lgr.lgr_order_res_te = lgr.lgr_order_res_te - 1
        where
                lgr.sid = in_sid
            and lgr.lgr_platz = v_lgr_platz;

        result := 0;
        return ( result );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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
    end lvs_lte_res_rueck;

    function lvs_c_lte_res_rueck (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_vorgang_id     in isi_transport.vorgang_id%type,
        in_auftrag_id     in isi_transport.auf_id%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_lte_vorgang_id in isi_transport.vorgang_id%type,
        in_lte_lgr_platz  in lvs_lte.lgr_platz%type
    ) return number is
        v_result number;
    begin
        v_result := lvs_lte_res_rueck(in_sid, in_firma_nr, in_vorgang_id, in_auftrag_id, in_lte_id,
                                      in_lte_vorgang_id, in_lte_lgr_platz, c.c_true);

        commit;
        return ( v_result );
    end;

    procedure c_ausl_res_rueck (
        in_sid        in lvs_lam.sid%type,
        in_firma_nr   in lvs_lam.firma_nr%type,
        in_lam_id     in lvs_lam.lam_id%type,
        in_login_id   in isi_user.login_id%type,
        in_fifo_pruef in varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr             number;
        v_err_text           varchar2(2550);
    -------------------------------------------------------------------------------------------------------
        v_result             number;
        v_lam                lvs_lam%rowtype;
        v_lte                lvs_lte%rowtype;
        v_order_pos          isi_order_pos%rowtype;
        cursor c_lam is
        select
            *
        from
            lvs_lam t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lam_id = in_lam_id;

        cursor c_lte is
        select
            *
        from
            lvs_lte t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lte_id = v_lam.lte_id;

        cursor c_order_pos is
        select
            *
        from
            isi_order_pos op
        where
                op.sid = in_sid
            and op.firma_nr = in_firma_nr
            and op.auf_id = v_lam.order_pos_auf_id;

        v_lam_fifo_pruef_anz number;
        cursor c_lam_fifo_pruef is
        select
            count(lam.order_pos_auf_id)
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.order_pos_auf_id = v_lam.order_pos_auf_id
            and nvl(lam.prod_datum, sysdate) > nvl(v_lam.prod_datum, sysdate)
            and lgr_platz is not null;

        v_found              boolean;
    begin
        open c_lam;
        fetch c_lam into v_lam;
        v_found := c_lam%found;
        close c_lam;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lam_fehlt, in_lam_id);
            raise v_error;
        end if;

        open c_lte;
        fetch c_lte into v_lte;
        v_found := c_lte%found;
        close c_lte;
        if not v_found then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, v_lam.lte_id);
            raise v_error;
        end if;

        if in_fifo_pruef = 'T' then
            open c_lam_fifo_pruef;
            fetch c_lam_fifo_pruef into v_lam_fifo_pruef_anz;
            v_found := c_lam_fifo_pruef%found;
            close c_lam_fifo_pruef;
            if
                v_found
                and ( v_lam_fifo_pruef_anz > 0 )
            then
                v_err_nr := 30;
                v_err_text := lc.ec(lc.o_txt_disop_l_err_fifo);
                raise v_error;
            end if;

        end if;

    -- Prüfen, ob eine Order vorhanden ist
        v_found := false;
        if v_lam.order_pos_auf_id > 0 then
            open c_order_pos;
            fetch c_order_pos into v_order_pos;
            v_found := c_order_pos%found;
            close c_order_pos;
        end if;

        if v_found then
            isi_p_order.res_rueck_order_pos(in_sid, in_firma_nr, in_login_id, v_order_pos.vorgang_id, v_order_pos.auf_id,
                                            v_order_pos.vorgang_typ, v_order_pos.satzart);
      -- Bei einer manuellen Auslagerung oder für den Fall dass der Besteller- und der
      -- Auslageruser gleich sind wird beim löschen der Dispo, der Status der Bestellung
      -- auf 'Abgelehnt' gesetzt (ist im LVS nicht mehr sichtbar).
            if v_order_pos.login_id = in_login_id then
                update isi_order_pos op
                set
                    op.status = 'Z',
                    op.lvs_info = 'DEL LVS man. Ausl.'
                where
                        op.sid = in_sid
                    and op.firma_nr = in_firma_nr
                    and op.auf_id = v_lam.order_pos_auf_id
                    and ( op.status = 'N'
                          or op.status = 'A' );

            end if;

        else
            v_result := lvs_lte_res_rueck(in_sid, in_firma_nr, v_lte.order_vorgang_id, v_lam.order_pos_auf_id, v_lte.lte_id,
                                          v_lte.order_vorgang_id, v_lte.lgr_platz, c.c_true);
        end if;

        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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

    procedure transp_res_lam_mit_teilmg (
        in_sid               in lvs_lam.sid%type,
        in_firma_nr          in lvs_lam.firma_nr%type,
        in_lam_id            in lvs_lam.lam_id%type,
        in_komm_neu_lte_name in lvs_lte.lte_name%type,
        in_modul_erzeuger    in isi_transport.modul_erzeuger%type,
        in_login_id          in isi_user.login_id%type,
        in_eti_druck_status  in lvs_lte.lte_eti_druck_status%type
    ) is

        v_lam                     lvs_lam%rowtype;
        v_lte                     lvs_lte%rowtype;
        v_lhm                     lvs_lhm%rowtype;
        v_lte_lams                lvs_lam%rowtype;
        v_komm_lte                lvs_lte%rowtype;
        v_charge                  lvs_charge%rowtype;
        v_user                    isi_user%rowtype;
        v_order_pos               isi_order_pos%rowtype;
        v_arbeitsplatz            isi_arbeitsplatz%rowtype;
        v_err_info                varchar2(255);
        v_result                  number;
        v_found                   boolean;
        v_gleiche_auf_id          boolean;
        v_gesamte_lte             boolean;
        v_lam_teil_menge_erl      boolean;
        v_transp_id               isi_transport.transp_id%type;
        v_transp_gruppe           isi_transport.transport_gruppe%type;
        v_komm_neu_lte_id         lvs_lte.lte_id%type;
        v_komm_neu_lte_name       lvs_lte.lte_name%type;
        v_komm_neu_lam_id         lvs_lam.lam_id%type;
        v_komm_neu_lhm_id         lvs_lam.lhm_id%type;
        v_lam_id_res_fuer_lte     lvs_lam.lam_id%type;
        v_anz_lams_auf_lte        number;
        v_komm_direkt_moegl       lvs_lgr_ort.komm_direkt_moegl%type;
        v_komm_ausweich_lgr_platz lvs_lgr_ort.komm_ausweich_lgr_platz%type;
        v_komm_picken_moegl       lvs_lgr_ort.komm_picken_moegl%type;
        v_komm_neu_lte_lgr_platz  lvs_lgr_ort.komm_neu_lte_lgr_platz%type;
        v_wa_menge_ueberlief      lvs_lgr.wa_menge_ueberlief%type;
        v_transp_ziel             lvs_lgr.lgr_platz%type;
        v_lte_eti_druck_status    lvs_lte.lte_eti_druck_status%type;
        cursor c_arbeitsplatz is
        select
            *
        from
            isi_arbeitsplatz t
        where
            t.arbeitsplatz_id = v_order_pos.arbeitsplatz_id;

        cursor c_lte_lams is
        select
            *
        from
            lvs_lam t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lte_id = v_lam.lte_id;

        cursor c_res_lams_fuer_lte is
        select
            t.lam_id
        from
            lvs_lam t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.res_ziel_lte_id = v_komm_neu_lte_id;

        cursor c_anz_lams_auf_lte is
        select
            count(*)
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.lte_id = v_lte.lte_id;

        cursor c_charge is
        select
            t.*
        from
            lvs_charge t
        where
            t.charge_id = v_lte_lams.charge_id;

    begin
    -- 2011-09-09 -AG- Nachdruck von Etiketten nur wenn im Vorfeld gedruckt wurde
    -- Alle relevanten Datensätze laden
        if not lvs_p_base.get_lam(in_sid, in_firma_nr, in_lam_id, v_lam) then
            raise_isi_error(1,
                            lc.ec_p1(lc.o_tp1_lam_id_fehlt, in_lam_id));
      -- raise_isi_error(1, 'Für die LAM ID ' || nvl(to_char(in_lam_id), 'NULL') || ' konnten keine Daten gefunden werden.');
        end if;

        if not lvs_p_base.get_lte(v_lam.lte_id, v_lte) then
            raise_isi_error(5,
                            lc.ec_p1(lc.o_tp1_lte_id_fehlt,
                                     nvl(v_lam.lte_id, 'NULL')));
      -- raise_isi_error(5, 'Für die LTE ID ' || nvl(v_lam.lte_id, 'NULL') || ' konnten keine Daten gefunden werden.');
        end if;

        v_komm_lte := null;
        if v_lam.res_ziel_lte_id is not null then
            if not lvs_p_base.get_lte(v_lam.res_ziel_lte_id, v_komm_lte) then
                raise_isi_error(7,
                                lc.ec_p1(lc.o_tp1_lte_id_fehlt,
                                         nvl(v_lam.lte_id, 'NULL')));
        -- raise_isi_error(7, 'Für die LTE ID ' || nvl(v_lam.res_ziel_lte_id, 'NULL') || ' konnten keine Daten gefunden werden.');
            end if;
        end if;

        if v_lte.lte_status not in ( c.lte_lf_stat, c.lte_af_stat, c.lte_bf_stat ) then
            v_err_info := ' von Benutzer: UNBEKANNT';
            if isi_allg.get_user_by_login_id(v_lte.sid, v_lam.res_login_id, v_user) then
                v_err_info := ' von Benutzer: ' || v_user.username;
            end if;

            if isi_p_order_base.get_order_pos(v_lam.sid, v_lam.order_pos_auf_id, v_order_pos) then
                open c_arbeitsplatz;
                fetch c_arbeitsplatz into v_arbeitsplatz;
                if c_arbeitsplatz%found then
                    v_err_info := v_err_info
                                  || ' Arbeitsplatz: '
                                  || v_arbeitsplatz.ip_name
                                  || ' (IP: '
                                  || v_arbeitsplatz.ip_adresse
                                  || ')';
                end if;

                close c_arbeitsplatz;
            end if;

            raise_isi_error(15,
                            lc.ec_p1(lc.o_tp1_lte_wird_schon_transp,
                                     nvl(v_lam.lte_id, 'NULL'))
                            || v_err_info);
      -- raise_isi_error(15, 'Die LTE ID ' || nvl(v_lam.lte_id, 'NULL') || ' ist bereits im Transport ' || v_err_info);
        else
            v_found := isi_p_order_base.get_order_pos(v_lam.sid, v_lam.order_pos_auf_id, v_order_pos);
        end if;

        if not lvs_p_base.get_lhm(v_lam.lhm_id, v_lhm) then
            raise_isi_error(6,
                            lc.ec_p1(lc.o_tp1_lhm_id_fehlt,
                                     nvl(v_lam.lhm_id, 'NULL')));
      -- raise_isi_error(6, 'Für die LHM ID ' || nvl(v_lam.lhm_id, 'NULL') || ' konnten keine Daten gefunden werden.');
        end if;

        v_lam_teil_menge_erl := true;
        v_transp_ziel := nvl(v_komm_lte.res_ziel_lgr_platz, v_lte.res_ziel_lgr_platz);
        if not lvs_p_base.get_lgr_komm_info(v_lte.lgr_platz, v_komm_direkt_moegl, v_komm_ausweich_lgr_platz, v_komm_picken_moegl, v_komm_neu_lte_lgr_platz
        ) then
            raise_isi_error(7,
                            'Für den Lagerplatz '
                            || nvl(v_lte.lgr_platz, 'NULL')
                            || ' konnten keine Kommissionierdaten gefunden werden.');
        end if;

        if
            ( v_komm_direkt_moegl = 'T'
            or v_komm_picken_moegl = 'T' )
            and v_komm_neu_lte_lgr_platz is null
        then
            raise_isi_error(8,
                            'Für den Lagerort '
                            || nvl(
                to_char(v_lte.lgr_ort),
                'NULL'
            )
                            || ' ist kein Kommissionierlagerplatz eingerichtet.');
        elsif
            ( v_komm_direkt_moegl = 'F'
            or v_komm_picken_moegl = 'F' )
            and v_komm_ausweich_lgr_platz is null
        then
            raise_isi_error(9,
                            'Für den Lagerort '
                            || nvl(
                to_char(v_lte.lgr_ort),
                'NULL'
            )
                            || ' ist kein Ausweichlagerplatz definiert, obwohl keine Kommissionierung möglich ist.');
        end if;

    -- 1. Pruefen, ob die gesamte LTE mit allen LAMs reserviert sind, und transportiert werden sollen
        v_gesamte_lte := true;
        open c_lte_lams;
        loop
            fetch c_lte_lams into v_lte_lams;
            exit when c_lte_lams%notfound;
            v_gleiche_auf_id :=
                ( v_lam.order_pos_auf_id = nvl(v_lte_lams.order_pos_auf_id, 0) )  -- gleicher Auftrag
                and ( ( v_lam.menge = nvl(v_lte_lams.res_menge, v_lam.menge) ) -- komplette LHM reserviert
                or not v_lam_teil_menge_erl );

            v_gesamte_lte :=
                v_gesamte_lte
                and nvl(v_gleiche_auf_id, false);
        end loop;

        close c_lte_lams;

    -- Transport zum Ausweichlagerplatz prüfen
        if lvs_p_base.get_lgr_wa_info(
            nvl(v_komm_lte.res_ziel_lgr_platz, v_lte.res_ziel_lgr_platz),
            v_wa_menge_ueberlief
        ) then
            if v_komm_direkt_moegl = 'F' then
                v_lam_teil_menge_erl := false;
        --if v_wa_menge_ueberlief = 'F'
        --then
          -- an diesem Lagerort kann nicht direkt kommissioniert werden, aber es gibt einen Kommissionierzwang für den WA
        --  v_transp_ziel := v_komm_ausweich_lgr_platz; -- Ausweichlagerplatz für Kommissionierung setzen
        --end if;
            end if;

      -- Wenn aus der ISI_ORDER_POS die WA_UEBERLIEFERUNG uebersteuert werden soll, dann jetzt hier eintragen
            if v_order_pos.wa_menge_ueberlief is not null then
                v_wa_menge_ueberlief := v_order_pos.wa_menge_ueberlief;
            end if;
            if v_komm_picken_moegl = 'F' then
                v_lam_teil_menge_erl := false;
                v_gesamte_lte := true;
                if v_wa_menge_ueberlief = 'F'
                or v_wa_menge_ueberlief = 'N'
                or v_wa_menge_ueberlief = 'EX' then
          -- an diesem Lagerort kann nicht "gepickt" werden, aber es gibt einen Kommissionierzwang für den WA
                    v_transp_ziel := v_komm_ausweich_lgr_platz; -- Ausweichlagerplatz für Kommissionierung setzen
                end if;

            end if;

        end if;

        v_komm_neu_lte_id := v_lam.res_ziel_lte_id;
        if
            v_gesamte_lte
            and ( (
                v_komm_neu_lte_id is null
                and v_lte.lte_name = c.keinelte
            )
            or v_lte.lte_name != c.keinelte )
        then
      -- wenn keine LAM eine Reservierung auf diese Ziel-LTE hat, kann der Transport gestartet werden.
            v_komm_neu_lte_id := v_lte.lte_id;
            open c_res_lams_fuer_lte;
            fetch c_res_lams_fuer_lte into v_lam_id_res_fuer_lte;
            v_found := c_res_lams_fuer_lte%found;
            close c_res_lams_fuer_lte;
            if v_found then
        -- rekursiv alle restlichen LHMs für diese LTE kommissionieren. Die letzte LHM aktiviert den Transport und den Etikettendruck
                transp_res_lam_mit_teilmg(in_sid, in_firma_nr, v_lam_id_res_fuer_lte, in_komm_neu_lte_name, in_modul_erzeuger,
                                          in_login_id, in_eti_druck_status);
                return;
            else
                if in_eti_druck_status is not null then
                    if v_lte.lte_name != c.keinelte then
            -- LTE Etikett muss bei echten LTEs auf jeden Fall neu gedruckt werden.
                        update lvs_lte t
                        set
                            t.lte_eti_druck_status = in_eti_druck_status
                        where
                                t.lte_id = v_lte.lte_id
                            and nvl(t.lte_eti_druck_status, 'D') != 'V';

                    end if;

          -- alle LHM dieser LTE, müssen wieder ein neues Etikett erhalten
                    update lvs_lhm t
                    set
                        t.lhm_eti_druck_status = in_eti_druck_status
                    where
                            t.sid = in_sid
                        and t.firma_nr = in_firma_nr
                        and t.lte_id = v_lte.lte_id
                        and nvl(t.lhm_eti_druck_status, 'D') != 'V';

                end if;

        -- Es wird die gesamte LTE transportiert, also für die Auslagerung nicht kommissioniert
        -- -> Löschen aller evtl. vorhandenen Kommissionierinformationen auf allen LHMs auf dieser LTE
                update lvs_lhm t
                set
                    t.komm_quell_lte_id = null,
                    t.komm_quell_lgr_platz = null,
                    t.komm_neu_lhm_name = null
                where
                        t.sid = in_sid
                    and t.firma_nr = in_firma_nr
                    and t.lte_id = v_lte.lte_id;

        -- Transport anlegen
                v_transp_gruppe := 0;
                v_result := lvs_transport.lvs_transp_lte(in_sid, in_firma_nr, in_modul_erzeuger, null, c.c_false,
                                                         'A', in_login_id, v_lam.order_pos_auf_id, null, 3,
                                                         0, 0, 0, v_lte.lgr_platz, v_transp_ziel,
                                                         v_lte.lte_id, v_lam.kunden_nr, c.c_false, null, null,
                                                         v_lte.order_vorgang_id, null, null, v_transp_gruppe, v_transp_id);

        -- ggf. Order mitteilen, dass der Transport für die Order angelegt wurde
                if v_lte.order_vorgang_id > 0 then
                    isi_p_order.teilmg_transport_begonnen(in_sid, in_firma_nr, v_transp_id);
                end if;

        -- Gesamte LTE fertig
                return;
            end if;

        end if;

    -- 2. wenn nur eine komplette LAM oder eine Teilmenge einer LAM transportiert werden soll,
    --    dann evtl. neue LTE (-Keine LTE) anlegen und draufkommissionieren oder auf in_komm_neu_lte_id
        if v_komm_neu_lte_id is null then
      -- Neue LTE anlegen, da noch keine vorhanden ist
      -- Alle LAMs werden einzeln auf eine eigene LTE gepackt
            v_komm_neu_lte_name := in_komm_neu_lte_name;
            if v_komm_neu_lte_name is null then
                v_komm_neu_lte_name := c.keinelte;
            end if;
            v_lte_eti_druck_status := in_eti_druck_status;
            if v_komm_neu_lte_name = c.keinelte then
                v_lte_eti_druck_status := null;
            end if;
            v_charge := null;
            open c_charge;
            fetch c_charge into v_charge;
            close c_charge;
            v_komm_neu_lte_id := lvs_p_lte.lvs_lte_insert_v358(in_sid, in_firma_nr, v_komm_neu_lte_name, null, in_login_id,
                                                               null, null, c.lte_pf_stat, null, v_lte_eti_druck_status,
                                                               v_charge.charge_id, v_charge.charge_bez, v_lte_lams.artikel_id, null, -- -AG- Kommision im Lager (Hier werden KOMM-Aufträge benötigt um ein Packschema vorzugeben
                                                                null,                    -- Auto Depal ist unbekannt
                                                               null,                    -- wickelprogramm ist unbekannt,
                                                                null);                   -- wickelprogramm_einl ist unbekannt
            update lvs_lte lte
            set
                lte.res_login_id = in_login_id,
                lte.res_ziel_lgr_platz = nvl(v_komm_lte.res_ziel_lgr_platz, v_lte.res_ziel_lgr_platz)
            where
                lte.lte_id = v_komm_neu_lte_id;

        end if;

    -- Kommissionier-LTE prüfen
        if not lvs_p_base.get_lte(v_komm_neu_lte_id, v_komm_lte) then
            raise_isi_error(10,
                            'Für die LTE ID '
                            || nvl(v_komm_neu_lte_id, 'NULL')
                            || ' konnten keine Daten gefunden werden.');
        end if;

    -- vor der Benutzung muss die Palette auf einen Kommissionierplatz gebucht werden
        if v_komm_lte.lgr_platz is null then
            lvs_p_lte.lvs_korr_te_einbuchen(in_sid, in_firma_nr, v_komm_neu_lte_id, null, in_sid,
                                            in_firma_nr, null, v_komm_neu_lte_lgr_platz, in_login_id, false);
        end if;

        open c_lte_lams;
        loop
            fetch c_lte_lams into v_lte_lams;
            exit when c_lte_lams%notfound;
            if ( v_lam.order_pos_auf_id = nvl(v_lte_lams.order_pos_auf_id, 0) )  -- gleicher Auftrag
             then
        -- Teilmengen abbuchen
                if
                    nvl(v_lte_lams.res_menge, v_lte_lams.menge) < v_lte_lams.menge
                    and not v_lam_teil_menge_erl
                    and ( v_wa_menge_ueberlief = 'F'
                    or v_wa_menge_ueberlief = 'N'
                    or v_wa_menge_ueberlief = 'EX' )
                then
          -- Es ist eine Teilentnahme reserviert
          -- An dem Lagerort ist keine Teilantnahme möglich / erlaubt
          -- Das Ziel darf nicht überlifert werden
          -- dann Ausweichlagerplatz setzen
                    v_transp_ziel := v_komm_ausweich_lgr_platz;
                end if;

                if
                    nvl(v_lte_lams.res_menge, v_lte_lams.menge) < v_lte_lams.menge
                    and v_lam_teil_menge_erl
                then
                    lvs_komm.lvs_komm_direct(in_sid, in_firma_nr, null, in_login_id, v_lte.lte_id,
                                             v_lte_lams.lam_id, v_lte_lams.res_menge, v_komm_neu_lte_id, v_komm_neu_lam_id, v_komm_neu_lhm_id
                                             );

          -- Bei Teilentnahme muss auf der Quell LAM die Reservierung zurückgesetzt werden.
          -- Die LoginID bleibt erhalten, für den Etikettendruck
                    update lvs_lam t
                    set
                        t.res_menge = null,
                        t.order_pos_auf_id = null,
                        t.res_ziel_lte_id = null
                    where
                            t.sid = in_sid
                        and t.firma_nr = in_firma_nr
                        and t.lam_id = v_lte_lams.lam_id;

          -- Reservierung für neue LAM übernehmen
                    update lvs_lam t
                    set
                        t.res_menge = v_lte_lams.res_menge,
                        t.order_pos_auf_id = v_lte_lams.order_pos_auf_id,
                        t.res_ziel_lte_id = null, -- ist ja schon drauf
                        t.res_login_id = v_lte_lams.res_login_id
                    where
                            t.sid = in_sid
                        and t.firma_nr = in_firma_nr
                        and t.lam_id = v_komm_neu_lam_id;

                    if in_eti_druck_status is not null then
            -- wegen Teilentnahme muss etkett auf jeden Fall neu gedruckt werden.
            -- alte LHM bleibt im Lager und bekommt ein neues Etikett
                        update lvs_lhm t
                        set
                            t.lhm_eti_druck_status = in_eti_druck_status
                        where
                                t.sid = in_sid
                            and t.firma_nr = in_firma_nr
                            and t.lhm_id = v_lte_lams.lhm_id
                            and nvl(t.lhm_eti_druck_status, 'D') != 'V';

            -- Die neue LHM bekommt ein neues Auslageretikett
                        update lvs_lhm t
                        set
                            t.lhm_eti_druck_status = in_eti_druck_status
                        where
                                t.sid = in_sid
                            and t.firma_nr = in_firma_nr
                            and t.lhm_id = v_komm_neu_lhm_id
                            and nvl(t.lhm_eti_druck_status, 'D') != 'V';

                    end if;

                else
                    lvs_p_lte_lhm.lvs_lhm_umpacken(in_sid, in_firma_nr, in_login_id, null, v_lte_lams.lhm_id,
                                                   v_komm_neu_lte_id);

                    update lvs_lam t
                    set
                        t.res_ziel_lte_id = null, -- ist ja jetzt schon drauf
                        t.order_pos_auf_id = v_lte_lams.order_pos_auf_id, -- beim Umpacken wird die Reservierung zurückgesetzt, diese wird aber noch benötigt
                        t.res_menge = v_lte_lams.res_menge -- wenn eine Teilmenge Reserviert ist, soll diese auch reserviert bleiben
                    where
                            t.sid = in_sid
                        and t.firma_nr = in_firma_nr
                        and t.lam_id = v_lte_lams.lam_id;

                    if in_eti_druck_status is not null then
                        if nvl(v_lte_lams.res_menge, v_lte_lams.menge) < v_lte_lams.menge then
              -- Bei Auslagerung, muss immer ein neues Etikett gedruckt werden
              -- bei teilentnahmen
                            update lvs_lhm t
                            set
                                t.lhm_eti_druck_status = in_eti_druck_status
                            where
                                    t.sid = in_sid
                                and t.firma_nr = in_firma_nr
                                and t.lhm_id = v_lte_lams.lhm_id;

                        else
              -- Bei Auslagerung, muss ein neues Etikett gedruckt werden
                            update lvs_lhm t
                            set
                                t.lhm_eti_druck_status = in_eti_druck_status
                            where
                                    t.sid = in_sid
                                and t.firma_nr = in_firma_nr
                                and t.lhm_id = v_lte_lams.lhm_id
                                and nvl(t.lhm_eti_druck_status, 'D') != 'V';

                        end if;
                    end if;

                end if;

            end if;

        end loop;

        close c_lte_lams;

    -- wenn dieses die letzte reservierte LHM auf dieser LTE ist, dann kann die Reservierung auf der LTE wieder weggenommen werden
    -- -WK- Die reservierung muss erhalten bleiben, bis der Transport quittiert wird.
    --v_result := lvs_lte_res_rueck(in_sid, in_firma_nr, v_lte.order_vorgang_id, v_lte.order_auf_id, v_lte.lte_id,
    --                              v_lte.order_vorgang_id, v_lte.lgr_platz, c.c_true);
        open c_anz_lams_auf_lte;
        fetch c_anz_lams_auf_lte into v_anz_lams_auf_lte;
        if c_anz_lams_auf_lte%notfound then
            v_anz_lams_auf_lte := 0;
        end if;
        close c_anz_lams_auf_lte;
        if v_anz_lams_auf_lte = 0 then
            v_result := lvs_lte_res_rueck(in_sid, in_firma_nr, v_lte.order_vorgang_id, v_lte.order_auf_id, v_lte.lte_id,
                                          v_lte.order_vorgang_id, v_lte.lgr_platz, c.c_true);
      -- LTE ID direkt ausbuchen, da keine LHM mehr drauf ist
            lvs_p_lte.lvs_korr_te_ausbuchen(in_sid, in_firma_nr, v_lte.lte_id, v_lte.lte_status, in_sid,
                                            in_firma_nr, v_lte.lgr_ort, v_lte.lgr_platz, in_login_id);

        else
      -- LTE bleibt im Lager
            if in_eti_druck_status is not null then
                update lvs_lte t
                set
                    t.res_login_id = in_login_id
                where
                    t.lte_id = v_lte.lte_id;

                if v_lte.lte_name != c.keinelte then
          -- LTE Etikett muss auf jeden Fall neu gedruckt werden.
                    update lvs_lte t
                    set
                        t.lte_eti_druck_status = 'ND'
                    where
                            t.lte_id = v_lte.lte_id
                        and nvl(t.lte_eti_druck_status, 'D') != 'V';

                end if;

            end if;
        end if;

    -- die neue Komm LTE ist für die selbe Order / Auf ID reserviert wie die Quell LTE
        v_result := lvs_ausl.lvs_lte_reserv_user_ziel(in_sid,
                                                      in_firma_nr,
                                                      v_lte.order_vorgang_id,
                                                      v_lam.order_pos_auf_id,
                                                      v_komm_neu_lte_id,
                                                      v_lam.artikel_id,
                                                      in_login_id,
                                                      nvl(v_komm_lte.res_ziel_lgr_platz, v_lte.res_ziel_lgr_platz));

    -- wenn keine LAM eine Reservierung auf diese Ziel-LTE hat, kann der Transport gestartet werden.
        open c_res_lams_fuer_lte;
        fetch c_res_lams_fuer_lte into v_lam_id_res_fuer_lte;
        v_found := c_res_lams_fuer_lte%found;
        close c_res_lams_fuer_lte;
        if v_found then
      -- rekursiv alle restlichen LHMs für diese LTE kommissionieren. Die letzte LHM aktiviert den Transport
            transp_res_lam_mit_teilmg(in_sid, in_firma_nr, v_lam_id_res_fuer_lte, in_komm_neu_lte_name, in_modul_erzeuger,
                                      in_login_id, in_eti_druck_status);
        else
      -- Keine weiteren LHMs für diese LTE reserviert
            if in_eti_druck_status is not null then
                if v_komm_lte.lte_name != c.keinelte then
          -- LTE Etikett muss vor dem Transport neu gedruckt werden.
                    update lvs_lte t
                    set
                        t.lte_eti_druck_status = in_eti_druck_status
                    where
                            t.lte_id = v_komm_neu_lte_id
                        and nvl(t.lte_eti_druck_status, 'D') != 'V';

                end if;
            end if;

      -- Transport anlegen
            v_transp_gruppe := 0;
            v_result := lvs_transport.lvs_transp_lte(in_sid,
                                                     in_firma_nr,
                                                     in_modul_erzeuger,
                                                     null,
                                                     c.c_false,
                                                     'A',
                                                     in_login_id,
                                                     v_lam.order_pos_auf_id,
                                                     null,
                                                     3,
                                                     0,
                                                     0,
                                                     0,
                                                     nvl(v_komm_neu_lte_lgr_platz, v_lte.lgr_platz),
                                                     v_transp_ziel,
                                                     v_komm_neu_lte_id,
                                                     v_lam.kunden_nr,
                                                     c.c_false,
                                                     null,
                                                     null,
                                                     v_lte.order_vorgang_id,
                                                     null,
                                                     null,
                                                     v_transp_gruppe,
                                                     v_transp_id);

      -- ggf. Order mitteilen, dass der Transport für die Order angelegt wurde
            if v_lte.order_vorgang_id > 0 then
                isi_p_order.teilmg_transport_begonnen(in_sid, in_firma_nr, v_transp_id);
            end if;

        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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

    procedure c_transp_res_lam_mit_teilmg (
        in_sid               in lvs_lam.sid%type,
        in_firma_nr          in lvs_lam.firma_nr%type,
        in_lam_id            in lvs_lam.lam_id%type,
        in_komm_neu_lte_name in lvs_lte.lte_name%type,
        in_modul_erzeuger    in isi_transport.modul_erzeuger%type,
        in_login_id          in isi_user.login_id%type,
        in_eti_druck_status  in lvs_lte.lte_eti_druck_status%type
    ) is
    begin
        transp_res_lam_mit_teilmg(in_sid, in_firma_nr, in_lam_id, in_komm_neu_lte_name, in_modul_erzeuger,
                                  in_login_id, in_eti_druck_status);
        commit;
    end;

    procedure c_lam_suche_res_ausl (
        in_sid                  in lvs_lam.sid%type,
        in_firma_nr             in lvs_lam.firma_nr%type,
        in_artikel_id           in lvs_lam.artikel_id%type,
        in_leitzahl             in lvs_lam.leitzahl%type,
        in_fa_ag                in lvs_lam.fa_ag%type,
        in_charge_id            in lvs_lam.charge_id%type,
        in_seriennr_id          in lvs_lam.serie_id%type,
        in_mhd                  in lvs_lam.lam_mhd%type,
        in_zeichnung_index      in lvs_lam.zeichnung_index%type,
        in_lgr_orte             in varchar2,
        in_menge                in number,
        in_ziel_lgr_platz       in lvs_lgr.lgr_platz%type,
        in_komm_ziel_lte_name   in lvs_lte_cfg.lte_name%type,
        in_komm_ziel_lte_id     in lvs_lte.lte_id%type,
        in_komm_anz_lhm_pro_lte in number,
        io_order_auf_id         in out lvs_lam.order_pos_auf_id%type,
        in_login_id             in isi_user.login_id%type,
        in_aktivieren           in varchar2 default 'F'
    ) is

        v_result          number;
        v_order_kopf      isi_order_kopf%rowtype;
        v_order_pos       isi_order_pos%rowtype;
        v_lgr_orte        varchar2(500);
        v_lgr_ort         lvs_lgr_ort.lgr_ort%type;
        v_ganze_lte       varchar2(1);
        cursor c_lgr_orte is
        select
            t.lgr_ort
        from
            lvs_lgr_ort t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr;

        cursor c_order_pos is
        select
            *
        from
            isi_order_pos op
        where
                op.sid = in_sid
            and op.firma_nr = in_firma_nr
            and op.auf_id = io_order_auf_id;

        cursor c_order_kopf is
        select
            *
        from
            isi_order_kopf ok
        where
                ok.sid = in_sid
            and ok.firma_nr = in_firma_nr
            and ok.vorgang_id = v_order_pos.vorgang_id
            and ok.vorgang_typ = v_order_pos.vorgang_typ
            and ok.li_nr = v_order_pos.li_nr;

        v_anz_res_lam     number;
        cursor c_order_res_mengen is
        select
            count(lam.lam_id)
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.order_pos_auf_id = v_order_pos.auf_id;

        v_found           boolean;
        v_neue_order      boolean;
        v_lgr_orte_fifo   varchar2(255);
        v_lgr_ort_fifo    varchar2(10);
        v_colon_pos       number;
        v_neu_std_anbruch varchar2(10);
        v_neu_std_strateg varchar2(10);
    begin
        if in_lgr_orte is null then
            v_lgr_orte := '';
            open c_lgr_orte;
            loop
                fetch c_lgr_orte into v_lgr_ort;
                exit when c_lgr_orte%notfound;
                v_lgr_orte := v_lgr_orte
                              || to_char(v_lgr_ort)
                              || ';';
            end loop;

            close c_lgr_orte;
        else
            v_lgr_orte := in_lgr_orte;
        end if;

        v_lgr_orte := lvs_lager_opt.lvs_lort_format(v_lgr_orte);
        v_neue_order := false;
        if nvl(io_order_auf_id, -1) <= 0 then
            v_neu_std_anbruch := isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'ORDER_NEU_STD', 'MA', 'ANBRUCH_LTE',
                                                              'order', 'CFG', 'I', 'STRING');

            v_neu_std_strateg := isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'ORDER_NEU_STD', 'MA', 'STRATEGIE',
                                                              'order', 'CFG', 'FIFO', 'STRING');
      -- manuelle Auslagerung
            v_order_pos := null;
            v_order_pos.sid := in_sid;
            v_order_pos.firma_nr := in_firma_nr;
            v_order_pos.anbruch := v_neu_std_anbruch;
            v_order_pos.strategie := v_neu_std_strateg;
            v_order_pos.ware_disponiert := c.c_false;
            v_order_pos.besteller := 'LVS';
            v_order_pos.login_id := in_login_id;
            v_order_pos.artikel_id := in_artikel_id;
            v_order_pos.leitzahl := in_leitzahl;
            v_order_pos.fa_ag := in_fa_ag;
            v_order_pos.charge_id := in_charge_id;
            v_order_pos.seriennr_id := in_seriennr_id;
            v_order_pos.mhd := in_mhd;
            v_order_pos.soll_menge := in_menge;
            v_order_pos.ist_menge := 0;
            v_order_pos.ziel := in_ziel_lgr_platz;
            v_order_pos.zeichnung_index := in_zeichnung_index;
            isi_p_order.man_lvs_wai_ma_order(v_order_pos);
            io_order_auf_id := v_order_pos.auf_id;
            v_neue_order := true;
            v_lgr_orte_fifo := isi_p_order.get_liefer_lgr_orte_fifo(in_sid, io_order_auf_id, null);
            v_lgr_orte_fifo := lvs_lager_opt.lvs_lort_format(v_lgr_orte_fifo);
            v_colon_pos := instr(v_lgr_orte_fifo, ';');
            if nvl(v_colon_pos, 0) > 0 then
                v_lgr_ort_fifo := substr(v_lgr_orte_fifo, 1, v_colon_pos);
                if v_lgr_orte not like '%'
                                       || v_lgr_ort_fifo
                                       || '%' then
          -- wenn der FIFO-Lagerort nicht in der aktuellen Liste enthalten ist, darf hier keine
          -- Ware reserviert werden. Die Order wird dann bei dem jew. Lagerort als neue Order sichtbar.
                    return;
                end if;
            end if;

        end if;

        open c_order_pos;
        fetch c_order_pos into v_order_pos;
        v_found := c_order_pos%found;
        close c_order_pos;
        if not v_found then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_order_auf_id_fehlt,
                                     to_char(io_order_auf_id)));
        end if;

        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if not v_found then
            raise_isi_error(20,
                            lc.ec_p1(lc.o_tp1_order_vorg_fehlt,
                                     nvl(
                      to_char(v_order_pos.vorgang_id),
                      '(null)'
                  )));
      -- raise_isi_error(20, 'Order-Kopf für Vorgang ID ' || nvl(to_char(v_order_pos.vorgang_id), '(null)') || ' nicht gefunden.');
        end if;

        if
            in_menge is not null
            and v_order_pos.soll_menge <> in_menge
        then
            v_order_pos.soll_menge := in_menge;
        end if;

        if
            in_ziel_lgr_platz is not null
            and v_order_pos.ziel <> in_ziel_lgr_platz
        then
            v_order_pos.ziel := in_ziel_lgr_platz;
        end if;

        if in_menge = 0 then
            v_ganze_lte := c.c_true;
        else
            v_ganze_lte := c.c_false;
        end if;

        v_result := lvs_lam_suche_buch_ausl(v_order_pos, v_order_kopf, v_lgr_orte, in_login_id, v_ganze_lte,
                                            in_komm_ziel_lte_id, in_komm_anz_lhm_pro_lte, in_aktivieren);

        if v_result <> 0 then
            raise_isi_error(30,
                            lc.ec_p1(lc.o_tp1_order_vorg_fehlt,
                                     nvl(
                      to_char(v_result),
                      '(null)'
                  )));
      -- raise_isi_error(30, 'Beim Reservieren ist ein Fehler Aufgetreten. Fehlernr. :' || nvl(to_char(v_result), '(null)'));
        end if;

        open c_order_res_mengen;
        fetch c_order_res_mengen into v_anz_res_lam;
        if c_order_res_mengen%notfound then
            v_anz_res_lam := 0;
        end if;
        close c_order_res_mengen;
        if
            not v_neue_order
            and v_anz_res_lam = 0
        then
            raise_isi_error(40,
                            lc.ec(lc.o_txt_kein_lagerbestand));
      -- raise_isi_error(40, 'Es konnte keine Ware gefunden werden.');
        end if;

    -- Der Order mitteilen, dass Ware reserviert wurde
        if v_anz_res_lam > 0 then
            update isi_order_pos op
            set
                op.status = 'D',
                op.ware_disponiert = c.c_true
            where
                    op.sid = v_order_pos.sid
                and op.firma_nr = v_order_pos.firma_nr
                and op.auf_id = v_order_pos.auf_id;

            update isi_order_kopf ok
            set
                ok.status = 'D'
            where
                    ok.sid = v_order_kopf.sid
                and ok.firma_nr = v_order_kopf.firma_nr
                and ok.vorgang_id = v_order_kopf.vorgang_id
                and ok.vorgang_typ = v_order_kopf.vorgang_typ
                and ok.li_nr = v_order_kopf.li_nr;

        end if;

        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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

    function lvs_lte_suche_buch_ausl (
        in_order_pos  in isi_order_pos%rowtype,
        in_order_kopf in isi_order_kopf%rowtype,
        in_lgr_orte   in varchar2,
        in_user_id    in isi_user.login_id%type,
        in_aktivieren in varchar2
    ) return number is
        v_result number;
    begin
        v_result := lvs_lam_suche_buch_ausl(in_order_pos, in_order_kopf, in_lgr_orte, in_user_id, c.c_true,
                                            null, null, in_aktivieren);

        return ( v_result );
    end;

    function lvs_lam_suche_buch_ausl (
        in_order_pos            in isi_order_pos%rowtype,
        in_order_kopf           in isi_order_kopf%rowtype,
        in_lgr_orte             in varchar2,
        in_user_id              in isi_user.login_id%type,
        in_ganze_lte_res        in varchar2,
        in_komm_ziel_lte_id     in lvs_lte.lte_id%type,
        in_komm_anz_lhm_pro_lte in number,
        in_aktivieren           in varchar2
    ) return number is
    begin
        return ( lvs_lam_suche_buch_ausl_359(in_order_pos, in_order_kopf, in_lgr_orte, in_user_id, in_ganze_lte_res,
                                             in_komm_ziel_lte_id, in_komm_anz_lhm_pro_lte, in_aktivieren, null) );
    end;

    function lvs_lam_suche_buch_ausl_359 (
        in_order_pos            in isi_order_pos%rowtype,
        in_order_kopf           in isi_order_kopf%rowtype,
        in_lgr_orte             in varchar2,
        in_user_id              in isi_user.login_id%type,
        in_ganze_lte_res        in varchar2,
        in_komm_ziel_lte_id     in lvs_lte.lte_id%type,
        in_komm_anz_lhm_pro_lte in number,
        in_aktivieren           in varchar2,
        in_lte_id               in lvs_lte.lte_id%type
    ) return number is

        result                    number;
        v_result                  number;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr                  number;
        v_err_text                varchar2(2550);
  -------------------------------------------------------------------------------------------------------

        v_found                   boolean;
        v_lgr_orte                varchar2(255);
        v_lgr_ort_count           number;
        v_lte_lgr_ort             lvs_lgr.lgr_ort%type;
        v_lam                     lvs_lam%rowtype;                      -- Lagerbestand
        v_lte                     lvs_lte%rowtype;                      -- LTE's
        v_art                     isi_artikel%rowtype;                  -- Artikeldaten
        v_lgr_ort                 lvs_lgr_ort%rowtype;
        v_adressen                isi_adressen%rowtype;
        v_charge                  lvs_charge%rowtype;
        v_lte_id                  lvs_lte.lte_id%type;
        v_lte_lgr_platz           lvs_lgr.lgr_platz%type;
        v_menge                   number;
        v_menge_sum               number;                               -- Summe der gefundenen Ware in Mengeneinheit (LAM-Menge)
        v_transport_id            number;                               -- Transportid
        v_transp_id               isi_transport.transp_id%type;
        v_modul_bearb             isi_transport.modul_bearbeiter%type;  -- Bearbeter

        v_sort                    number;
        v_sort2                   number;
        v_min_mhd                 date;                                 -- Mindest MHD
        v_min_prod                date;                                 -- Frühesters Produktionsdatum (Reifezeit)
        v_trans_typ               isi_transport.transp_typ%type;
        v_streng_fifo             varchar2(1);
        v_kl_menge_prio           varchar2(1);
        v_bh_menge_prio           varchar2(1);
        v_ohne_mhd_pruef          varchar2(1);
        v_min_mhd_tage            number;
        v_li_nr                   isi_order_pos.li_nr%type;
        cursor c_art is
        select
            *
        from
            isi_artikel art
        where
                art.sid = in_order_pos.sid
            and art.artikel_id = in_order_pos.artikel_id;

        cursor c_lgr_ort is
        select
            *
        from
            lvs_lgr_ort ort
        where
                ort.sid = in_order_pos.sid
            and ort.firma_nr = in_order_pos.firma_nr
            and ort.lgr_ort = v_lte_lgr_ort;

        cursor c_adressen is
        select
            *
        from
            isi_adressen adr
        where
                adr.sid = in_order_pos.sid
            and adr.adress_id = in_order_kopf.adress_id;

        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_order_pos.sid
            and lte.firma_nr = in_order_pos.firma_nr
            and lte.lte_id = v_lte_id
        order by
            lte.lgr_platz desc;

        cursor c_lam_auf_id is
        select
            lam.lte_id
        from
            lvs_lam lam,
            lvs_lte lte,
            lvs_lgr lgr
        where
                lam.sid = in_order_pos.sid
            and lam.order_pos_auf_id = in_order_pos.auf_id
            and lte.sid = in_order_pos.sid
            and lte.lte_id = lam.lte_id
            and lte.lgr_platz = lgr.lgr_platz (+)
        group by
            lam.lte_id,
            lgr.lgr_platz_gruppe,
            lgr.lgr_dim_fifo_nr,
            lte.res_mhd,
            lte.lte_letzte_buchung,
            lte.transport_gruppe,
            lgr.lgr_typ
        order by
            lte.transport_gruppe,
            lgr.lgr_platz_gruppe desc,
            decode(lgr.lgr_typ,
                   c.stap_flae1,
                   nvl(
                min(lte.lte_offset_z),
                0
            ), -- Oberste zuerst
                   c.stap_flae2,
                   nvl(
                min(lte.lte_offset_z),
                0
            ),
                   lgr.lgr_dim_fifo_nr) desc,
            decode(lgr.lgr_typ, c.durchl1, lte.lte_letzte_buchung, sysdate - 2),     -- Bei Durchlauflager in Einlagerreihenfolge
            lte.res_mhd,
            lte.lte_letzte_buchung desc;

        cursor c_ltes is
    -- Achtung dieser SELECT muß in der Funktion lvs_lte_suche_buch_ausl und im Delphi (ISI-ORDER) als Vorschlag
    -- fuer Auslagerungen identisch gehalten werden
        select
            lte.lte_id,
            lte.lgr_ort,
            lte.lgr_platz,
            decode(in_order_pos.menge_basis,
                   c.basis_lte,
                   count(lte.lte_id),
                   sum(lam.menge))                          menge,
            trunc(lvs_lte_platz_bewerten(in_order_pos.sid,
                                         in_order_pos.firma_nr,
                                         in_order_pos.strategie,
                                         in_order_pos.anbruch,
                                         lte.lte_voll,
                                         nvl(
                                  min(lam.lam_mhd),
                                  lte.res_mhd
                              ),
                                         trunc(min(lam.prod_datum)),
                                         lte.lte_id,
                                         lte.lgr_platz,
                                         lte.res_string,
                                         lgr.lgr_platz_gruppe,
                                         lgr.lgr_typ,
                                         in_order_pos.artikel_id))            ausl_sort,
            lvs_lte_platz_bewerten(in_order_pos.sid,
                                   in_order_pos.firma_nr,
                                   in_order_pos.strategie,
                                   in_order_pos.anbruch,
                                   lte.lte_voll,
                                   nvl(
                min(lam.lam_mhd),
                lte.res_mhd
            ),
                                   trunc(min(lam.prod_datum)),
                                   lte.lte_id,
                                   lte.lgr_platz,
                                   lte.res_string,
                                   lgr.lgr_platz_gruppe,
                                   lgr.lgr_typ,
                                   in_order_pos.artikel_id) ausl_sort2
        from
            lvs_lte lte,
            lvs_lam lam,
            lvs_lgr lgr
        where
                lte.sid = lam.sid
            and lte.lte_id = lam.lte_id
            and ( lte.lte_status = c.lte_lf_stat
                  or lte.lte_status = c.lte_bf_stat  -- Erst mal nur Paletten die fertig befüllt oder im Lager sind
                  or in_lte_id is not null )
            and lgr.sid = in_order_pos.sid
            and lgr.lgr_platz = lte.lgr_platz
            and ( lgr.lgr_verwendung = c.lgr_typ_lager           -- Lagertypen und Verwendungstypen erlaubt (Lager)
                  or ( lgr.lgr_verwendung = c.lgr_typ_we          -- Nur WE's wenn Palette grade fertig befüllt (Maschine)
                       and lte.lte_status = c.lte_bf_stat
                       and ( not exists (
                select
                    lgr_ort.lgr_ort           -- WE vom MFR sind TABU
                from
                    lvs_lgr_ort lgr_ort
                where
                        lgr_ort.sid = lgr.sid
                    and lgr_ort.firma_nr = lgr.firma_nr
                    and lgr_ort.lgr_ort = lgr.lgr_ort
                    and lgr_ort.lgr_ort_modul = c.lgr_modul_mfr
            ) )
                       or in_lte_id is not null )
                  or ( lgr.lgr_verwendung = c.lgr_typ_lagerp      -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                       and lte.lte_status = c.lte_bf_stat )
                  or ( lgr.lgr_verwendung = c.lgr_typ_puffer      -- Nur Puffer ist OK wenn Palette fertig is (LF)
                       and lte.lte_status = c.lte_lf_stat )
                  or in_lte_id is not null )
            and lam.sid = in_order_pos.sid
            and lam.firma_nr = in_order_pos.firma_nr
            and lam.artikel_id = in_order_pos.artikel_id        -- Richtigen Artikel waehlen
            and nvl(lam.leitzahl, -1) = nvl(in_order_pos.leitzahl,
                                            nvl(lam.leitzahl, -1)) -- Leitzahl beruecksichtigen
            and nvl(lam.fa_ag, -1) = nvl(in_order_pos.fa_ag, -1)-- Nur Ware die als Lagerware gilt !!!! AG <> NULL ist halbfertigware
            and lam.menge > 0                                   -- Nur wenn Lagermengen vorhanden
            and lam.akt_inventur_id is null                      -- nur Ware reservieren die nicht in Inventur sind
       -- -AG- 2015.05.12 Geaenderte selektirungsparameter Begin
            and lam.labor_status = nvl(in_order_pos.labor_status, c.lab_stat_f)
       -- -AG- 2015.05.12 Geaenderte selektirungsparameter End
       -- -AG- 2015.05.12 Neue selektirungsparameter Begin
            and nvl(lam.lam_sel1, 'lam.lam_sel') = nvl(in_order_pos.lam_sel1, 'lam.lam_sel')
            and nvl(lam.lam_sel2, 'lam.lam_sel') = nvl(in_order_pos.lam_sel2, 'lam.lam_sel')
            and nvl(lam.lam_sel3, 'lam.lam_sel') = nvl(in_order_pos.lam_sel3, 'lam.lam_sel')
            and nvl(lam.lam_sel4, 'lam.lam_sel') = nvl(in_order_pos.lam_sel4, 'lam.lam_sel')
            and nvl(lam.lam_sel5, 'lam.lam_sel') = nvl(in_order_pos.lam_sel5, 'lam.lam_sel')
            and nvl(lam.lam_sel6, 'lam.lam_sel') = nvl(in_order_pos.lam_sel6, 'lam.lam_sel')
            and nvl(lam.lam_sel7, 'lam.lam_sel') = nvl(in_order_pos.lam_sel7, 'lam.lam_sel')
            and nvl(lam.lam_sel8, 'lam.lam_sel') = nvl(in_order_pos.lam_sel8, 'lam.lam_sel')
            and nvl(lam.lam_sel9, 'lam.lam_sel') = nvl(in_order_pos.lam_sel9, 'lam.lam_sel')
            and nvl(lam.lam_sel10, 'lam.lam_sel') = nvl(in_order_pos.lam_sel10, 'lam.lam_sel')
       -- -AG- 2015.05.12 Neue selektirungsparameter End
            and nvl(lam.charge_id, -1) = nvl(in_order_pos.charge_id,
                                             nvl(lam.charge_id, -1)) -- Charge Passt?
            and nvl(lam.serie_id, -1) = nvl(in_order_pos.seriennr_id,
                                            nvl(lam.serie_id, -1)) -- SERIENNR passt?
            and trunc(lam.lam_mhd) = nvl(
                trunc(in_order_pos.mhd),
                trunc(lam.lam_mhd)
            )
            and ( lam.lam_mhd >= nvl(v_min_mhd, lam.lam_mhd) -- Wenn im Auftrag -1 als Min-MHD dann auch abgelaufene Ware OK
                  or in_order_pos.mhd is not null )
            and ( in_order_pos.anbruch = c.c_anbruch_ignore
                  or nvl(lte.lte_voll, c.lte_voll_a) = decode(in_order_pos.anbruch, c.c_true, c.lte_voll_a, c.c_anbruch_vorzug, c.lte_voll_a
                  ,
                                                              c.c_anbruch_ausnahme, c.lte_voll_a, c.lte_voll_v)
                  or nvl(lte.lte_voll, c.lte_voll_v) = decode(in_order_pos.anbruch, c.c_false, c.lte_voll_v, c.c_anbruch_vorzug, c.lte_voll_v
                  ,
                                                              c.c_anbruch_ausnahme, c.lte_voll_v, c.lte_voll_a) )
            and nvl(lam.order_pos_auf_id, in_order_pos.auf_id) = in_order_pos.auf_id
            and nvl(lte.order_vorgang_id, in_order_pos.vorgang_id) = in_order_pos.vorgang_id
       -- Jetzt noch Prüfen ob KONSI
            and ( ( lam.owner_address_id is null              -- Keine KONSI-Ware
                    and in_order_pos.satzart != 'LK'              -- Kein KONSI Lieferschein
                     )
                  or ( lam.owner_address_id is not null          -- KONSI-Ware
                       and in_order_pos.satzart = 'LK'               -- KONSI Lieferschein
                        ) )
            and ( nvl(sysdate - lam.prod_datum, -1) >= decode(sysdate - lam.prod_datum,
                                                              null,
                                                              -1,
                                                              nvl(sysdate - v_min_prod,
                                                                  nvl(sysdate - lam.prod_datum, -1)))
                  or v_min_prod = sysdate )
            and lgr.gesperrt = c.lgr_gesperrt_f
            and lgr.akt_inventur_id is null                      -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
            and ( ( instr(v_lgr_orte,
                          lpad(
                                    to_char(lte.lgr_ort),
                                    c.lort_laenge - 1,
                                    '0'
                                )
                          || ';') > 0 )
                  or in_lte_id is not null )
            and lvs_p_lgr_grp_fahrzeuge.chk_lte_lgr_zugriff_ok(lte.lte_id) = 'T'
       -- Berücksichtigen des Zeichnungsindex
            and nvl(lam.zeichnung_index, 'Kein_I') = nvl(
                nvl(in_order_pos.zeichnung_index, lam.zeichnung_index),
                'Kein_I'
            )
            and ( ( lte.auto_depal = c.c_true )
                  or ( nvl(in_order_pos.auto_depal, c.c_false) <> c.c_true ) )
            and ( lte.lte_id = in_lte_id
                  or in_lte_id is null )
        group by
            lte.lte_id,
            lte.lte_voll,
            lte.lte_letzte_buchung,
            lam.artikel_id,
            lte.lgr_ort,
            lte.lgr_platz,
            lte.res_string,
            lte.res_mhd,
            lte.order_vorgang_id,
            lgr.lgr_platz_gruppe,
            lgr.lgr_dim_p,
            lgr.lgr_typ,
            lgr.lgr_dim_platz
        order by
            decode(lte.order_vorgang_id, in_order_kopf.vorgang_id, 0, 1),
            decode(v_streng_fifo,
                   'T',
                   min(lam.prod_datum) - sysdate,
                   0), -- -AG- Neue Variante Volle Behälter (HUF)
            decode(lgr.lgr_typ, c.r_durchl1, lgr.lgr_dim_platz, 0) desc,
            decode(lgr.lgr_typ, c.r_durchl1, to_number(lte.lte_letzte_buchung), 0),
            ausl_sort,
            decode(v_streng_fifo,
                   'T',
                   'X',
                   decode(v_kl_menge_prio, 'T', 'X', lgr.lgr_platz_gruppe)),
            decode(v_streng_fifo,
                   'T',
                   'X',
                   decode(v_kl_menge_prio, 'T', 'X', lgr.lgr_dim_p)),
            ausl_sort2,
            decode(v_streng_fifo,
                   'T',
                   min(lam.prod_datum) - sysdate,
                   0),
           -- Die kleinste Menge gilt nur, wenn der Lagerort erreichbar ist
           --decode(instr(v_lgr_orte, lpad(to_char(lte.lgr_ort), c.LORT_LAENGE - 1, '0') || ';'), 0, 100000000000000000, decode(v_kl_menge_prio, 'T', sum(lam.menge), 0)),
           -- -AG- Ganze Behäöter beforzugt Behandeln berueksichtigen
            decode(
                instr(v_lgr_orte,
                      lpad(
                    to_char(lte.lgr_ort),
                    c.lort_laenge - 1,
                    '0'
                )
                      || ';'),
                0,
                100000000000000000,
                decode(v_bh_menge_prio,
                       'T',
                       sum(lam.menge),
                       0)
            ),
            decode(v_bh_menge_prio,
                   'B',
                   case
                       when sum(lam.menge) >= v_art.lhm_menge then
                           0
                       else
                           v_art.lhm_menge * 10000000
                   end,
                   0) desc,
           -- Hier wird die Reihenfolge der übergebenen Lagerorte bei gleichem FIFO berücksichtigt
            decode(
                instr(v_lgr_orte,
                      lpad(
                    to_char(lte.lgr_ort),
                    c.lort_laenge - 1,
                    '0'
                )
                      || ';'),
                0,
                1000000,
                instr(v_lgr_orte,
                      lpad(
                    to_char(lte.lgr_ort),
                    c.lort_laenge - 1,
                    '0'
                )
                      || ';')
            );

        v_lte_lams                lvs_lam%rowtype;
        cursor c_lte_lams is
        select
            *
        from
            lvs_lam t
        where
                t.sid = in_order_pos.sid
            and t.firma_nr = in_order_pos.firma_nr
            and t.lte_id = v_lte_id
        order by -- Hier wird sortiert, was bei der Auslagerung nicht berücksichtigt werden soll
            decode(v_streng_fifo,
                   'T',
                   t.prod_datum,
                   trunc(t.prod_datum)) desc,
            -- -AG- Besonderheit volle Beharlter beforzugt abarbeietn ->
            decode(v_bh_menge_prio, 'T', t.menge, 0) desc,
            decode(v_bh_menge_prio,
                   'B',
                   case
                    when t.menge = v_art.lhm_menge then
                        0                              -- Wenn Menge passt dann besonders gut
                    when t.menge < v_art.lhm_menge then
                        v_art.lhm_menge * 10000000     -- Wenn Menge im Behälter kleiner dann besonders schlecht (Restmenge)
                    else
                        abs(t.menge - v_art.lhm_menge) -- Wenn Menge im Behälter größer dann OK (Nicht jeder Behälter hat eine LAM) und den kleinsten nehmen (wahrscheinlich Anbruchpalette)
                   end,
                   0) desc,
            t.lam_id desc;

        cursor c_lte_lams_li_nr is
        select
            max(p.li_nr)
        from
            lvs_lam       lam,
            isi_order_pos p
        where
                lam.lte_id = v_lte_id
            and lam.order_pos_auf_id is not null
            and p.auf_id = lam.order_pos_auf_id
            and p.li_nr <> in_order_pos.li_nr
        group by
            lam.order_pos_auf_id;

        v_delta_menge             number;
        v_komm_anz_lam_ziel_lte   number;
        v_komm_ziel_lte_id        lvs_lte.lte_id%type;
        v_komm_ziel_lte           lvs_lte%rowtype;
        v_komm_lte_ziel_lgr_platz lvs_lte.lgr_platz%type;
        cursor c_komm_lte_ziel is
        select
            lte.res_ziel_lgr_platz
        from
            lvs_lam lam,
            lvs_lte lte
        where
                lam.res_ziel_lte_id = v_komm_ziel_lte_id
            and lte.lte_id = lam.lte_id
            and lte.lte_status = 'LF';

        cursor c_charge is
        select
            *
        from
            lvs_charge c
        where
            c.charge_id = v_lam.charge_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        v_last_id_bewertet := null;
        v_streng_fifo := isi_allg.get_firma_cfg_param(in_order_pos.sid, in_order_pos.firma_nr, 'AUSL_STRAT', null, 'STRENG_FIFO',
                                                      'LVS', 'CFG', 'F', 'BOOLEAN');

        v_kl_menge_prio := isi_allg.get_firma_cfg_param(in_order_pos.sid, in_order_pos.firma_nr, 'AUSL_STRAT', null, 'KL_MENGE_PRIO',
                                                        'LVS', 'CFG', 'F', 'BOOLEAN');

        v_ohne_mhd_pruef := isi_allg.get_firma_cfg_param(in_order_pos.sid, in_order_pos.firma_nr, 'AUSL_STRAT', null, 'OHNE_MHD_PRUEF'
        ,
                                                         'LVS', 'CFG', 'F', 'BOOLEAN');

        v_lgr_orte := lvs_lager_opt.lvs_lort_format(in_lgr_orte);   -- Formatiert die Lagerorte
        v_lgr_ort_count := lvs_lager_opt.lvs_lort_count(v_lgr_orte);     -- Anzahl der Lagerorte
        v_menge_sum := 0;                                        -- Noch keine Mengen gefunden

        open c_adressen;
        fetch c_adressen into v_adressen;
        v_found := c_adressen%found;
        close c_adressen;
        if not v_found then
            v_adressen.adr_nr := 0;
        end if;
        if in_order_pos.auf_id_extern is null then
            v_modul_bearb := c.lgr_modul_order;
        else
            v_modul_bearb := c.lgr_modul_host;
        end if;

  -- -AG- Ganze Behäöter beforzugt Behandeln berueksichtigen
        if in_order_pos.auf_id_extern is null then
            v_modul_bearb := c.lgr_modul_order;
        else
            v_modul_bearb := c.lgr_modul_host;
        end if;

        if in_order_pos.ware_disponiert = c.c_false then
            v_komm_ziel_lte_id := in_komm_ziel_lte_id;
            v_komm_ziel_lte := null;
            if lvs_p_base.get_lte(v_komm_ziel_lte_id, v_komm_ziel_lte) then
                v_komm_lte_ziel_lgr_platz := v_komm_ziel_lte.res_ziel_lgr_platz;
                if v_komm_ziel_lte.res_ziel_lgr_platz is null then
                    open c_komm_lte_ziel;
                    fetch c_komm_lte_ziel into v_komm_lte_ziel_lgr_platz;
                    if c_komm_lte_ziel%notfound then
                        v_komm_lte_ziel_lgr_platz := null;
                    end if;
                    close c_komm_lte_ziel;
                end if;

                if nvl(v_komm_lte_ziel_lgr_platz, in_order_pos.ziel) != in_order_pos.ziel then
                    raise_isi_error(5,
                                    lc.ec_p1(lc.o_tp1_lte_in_kommission, v_komm_lte_ziel_lgr_platz));
        --raise_isi_error(5, 'Fehler: Die Ziel-LTE für die Kommissionierung ist bereits für Ziel ' || v_komm_lte_ziel_lgr_platz || ' reserviert. Bitte eine neue LTE anlegen.');
                end if;

            end if;

    -- Ware ist noch nicht Disponiert
            open c_art;
            fetch c_art into v_art;                                              -- Artikeldaten lesen
            close c_art;
            if in_order_pos.min_reifezeit is null then
                v_min_prod := sysdate - v_art.reife_zeit_tage;                        -- Reifezeit beachten
            else
                v_min_prod := sysdate - in_order_pos.min_reifezeit;                   -- Reifezeit beachten
            end if;

            if in_order_pos.min_mhd_tage is null then
                if v_art.waren_typ = c.rohware then
                    v_min_mhd_tage := nvl(v_art.min_mhd_tage_ausl, c.mhd_rw_min_tage);
                elsif v_art.waren_typ = c.halbware then
                    v_min_mhd_tage := nvl(v_art.min_mhd_tage_ausl, c.mhd_hw_min_tage);
                else
                    v_min_mhd_tage := nvl(v_art.min_mhd_tage_ausl, c.mhd_fw_min_tage);
                end if;
            else
                v_min_mhd_tage := in_order_pos.min_mhd_tage;
            end if;

            if v_min_mhd_tage = -1
            or nvl(v_ohne_mhd_pruef, 'F') = 'T' then
                v_min_mhd := null;
            else
                if v_art.waren_typ = c.rohware then
                    v_min_mhd := sysdate + nvl(v_min_mhd_tage, c.mhd_rw_min_tage);
                elsif v_art.waren_typ = c.halbware then
                    v_min_mhd := sysdate + nvl(v_min_mhd_tage, c.mhd_hw_min_tage);
                else
                    v_min_mhd := sysdate + nvl(v_min_mhd_tage, c.mhd_fw_min_tage);
                end if;
            end if;

            open c_ltes;
            loop
                fetch c_ltes into
                    v_lte_id,
                    v_lte_lgr_ort,
                    v_lte_lgr_platz,
                    v_menge,
                    v_sort,
                    v_sort2;
                exit when c_ltes%notfound;
                if v_menge <= in_order_pos.soll_menge - nvl(in_order_pos.ist_menge, 0)
                or in_order_pos.wa_menge_ueberlief != 'ULTE' then
                    v_menge_sum := v_menge_sum + nvl(v_menge, 0);                        -- Gefundene Menge addieren
                    exit when
                        v_menge_sum > in_order_pos.soll_menge - nvl(in_order_pos.ist_menge, 0)
                        and v_menge_sum > nvl(v_menge, 0)
                        and in_order_pos.wa_menge_ueberlief = 'ULTE'; -- Fertig wenn Menge erreicht LTE Unterlieferung
                    open c_lte;
                    fetch c_lte into v_lte;
                    v_found := c_lte%found;
                    close c_lte;
                    if not v_found then
                        v_err_nr := 10;
                        v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, v_lte_id);
                        raise v_error;
                    end if;

                    v_li_nr := null;
                    open c_lte_lams_li_nr;
                    fetch c_lte_lams_li_nr into v_li_nr; -- Suchen der LI_Nummer <> Li-Nummer fuer Reservierung != Null wenn vorhanden
                    close c_lte_lams_li_nr;
                    if
                        ( instr(v_lgr_orte,
                                lpad(
                                                      to_char(v_lte.lgr_ort),
                                                      c.lort_laenge - 1,
                                                      '0'
                                                  )
                                || ';') > 0
                        or in_lte_id is not null )
                        and v_li_nr is null    -- Nur wenn auf der LTE keine Reservierung oder die gleiche LI_Nummer
                    then
                        open c_lgr_ort;
                        fetch c_lgr_ort into v_lgr_ort;
                        v_found := c_lgr_ort%found;
                        close c_lgr_ort;
                        if not v_found then
                            v_err_nr := 20;
                            v_err_text := lc.ec_p2(lc.o_tp2_lte_lgr_ort_fehlt, v_lte.lte_id, v_lte_lgr_ort);
                            raise v_error;
                        end if;

                        result := lvs_lte_reserv_user_ziel(in_order_pos.sid, in_order_pos.firma_nr, in_order_pos.vorgang_id, in_order_pos.auf_id
                        , v_lte_id,
                                                           in_order_pos.artikel_id, in_user_id, in_order_pos.ziel);

                        if
                            v_komm_ziel_lte_id is not null
                            and v_lte.lte_name = c.keinelte
                        then
            -- Wenn eine Kommissionierung erforderlich ist, dann werden alle Einzel-LHMs auf die neue Komm LTE reserviert
                            update lvs_lam lam
                            set
                                lam.res_ziel_lte_id = v_komm_ziel_lte_id
                            where
                                    lam.sid = v_lte.sid
                                and lam.firma_nr = v_lte.firma_nr
                                and lam.lte_id = v_lte.lte_id
                                and lam.order_pos_auf_id = in_order_pos.auf_id;

                        end if;

                        if in_ganze_lte_res = c.c_false             -- Alte HUF Loesung
                        or in_order_pos.wa_menge_ueberlief = 'ULHM' -- Underdelivery LHM bedeutet, dass solange LHM (Kartons) genommen werden, bis maximal die Menge erreicht ist. Bei dem ersten LHM, das die Menge überschreitet wird die Reservierung beendet ohne dieses zu reservieren
                        or in_order_pos.wa_menge_ueberlief = 'EX'   -- exakte Lieferung Die Menge muss exakt eingehalten werden, evtl. mit Einzelentnahmen in der Kommissionierung
                        or in_order_pos.wa_menge_ueberlief = 'OLHM' -- Overdelivery LHM bedeutet, dass solange LHMs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LHM mit der die Menge überschritten wird, wird auch komplett reserviert
                         then
            -- Es soll nicht die ganze lte reserviert werden, also Teilreservierungen auf LHMs
            -- zuviel reservierte LAMs zurücksetzen
                            v_delta_menge := v_menge_sum - ( in_order_pos.soll_menge - nvl(in_order_pos.ist_menge, 0) );

                            if v_delta_menge > 0 then
                                v_komm_anz_lam_ziel_lte := lvs_komm.get_komm_anz_lam_fuer_lte(in_order_pos.sid, in_order_pos.firma_nr
                                , v_komm_ziel_lte_id, in_order_pos.artikel_id);

                                if v_komm_anz_lam_ziel_lte >= nvl(in_komm_anz_lhm_pro_lte, v_komm_anz_lam_ziel_lte + 1) then
                -- Maximale Anzahl LHMs für LTE erreicht, neue LTE muss angelegt werden
                                    if v_komm_ziel_lte.lte_id is not null then
                                        v_charge := null;
                                        open c_charge;
                                        fetch c_charge into v_charge;
                                        close c_charge;
                                        v_komm_ziel_lte_id := lvs_p_lte.lvs_lte_insert_v358(in_order_pos.sid, in_order_pos.firma_nr, v_komm_ziel_lte.lte_name
                                        , null, null,
                                                                                            v_komm_ziel_lte.lgr_ort, v_komm_ziel_lte.lgr_platz
                                                                                            , c.lte_bf_stat, null, v_komm_ziel_lte.lte_eti_druck_status
                                                                                            ,
                                                                                            v_charge.charge_id, v_charge.charge_bez, v_lte_lams.artikel_id
                                                                                            , v_komm_ziel_lte.packschema_kopf_id, null
                                                                                            ,                    -- Auto Depal ist unbekannt
                                                                                            null,                    -- wickelprogramm ist unbekannt,
                                                                                             null);                   -- wickelprogramm_einl ist unbekannt
                                        v_komm_anz_lam_ziel_lte := 0;
                                    end if;

                                end if;

              -- neue LTE schon mal für den gleichen User reservieren (wiederverwendung möglich)
                                if v_komm_ziel_lte_id is not null then
                                    update lvs_lte lte
                                    set
                                        lte.res_login_id = in_user_id,
                                        lte.res_ziel_lgr_platz = in_order_pos.ziel
                                    where
                                        lte.lte_id = v_komm_ziel_lte_id;

                                end if;

              -- -AG- Besonderheit volle Beharlter beforzugt abarbeietn -> Steuerung CURSOR
                                if in_order_pos.anbruch = c.c_volle_behaelter then
                                    v_bh_menge_prio := c.c_volle_behaelter;
                                else
                                    v_bh_menge_prio := v_kl_menge_prio;
                                end if;

                                open c_lte_lams;
                                loop
                                    fetch c_lte_lams into v_lte_lams;
                                    exit when c_lte_lams%notfound;
                                    if v_lte_lams.order_pos_auf_id = in_order_pos.auf_id then
                                        if v_delta_menge > 0 then
                                            if v_lte_lams.menge <= v_delta_menge
                                            or (
                                                in_order_pos.wa_menge_ueberlief = 'ULHM' -- Underdelivery LHM bedeutet, dass solange LHM (Kartons) genommen werden, bis maximal die Menge erreicht ist. Bei dem ersten LHM, das die Menge überschreitet wird die Reservierung beendet ohne dieses zu reservieren
                                                and v_art.lhm_menge > 1
                                            )                  -- Bei LHM-Menge = 1, werden die Mengen zusammengefasst. Damm muss wie be EX teilmengen je LAM reserviert werden
                                             then
                      -- ganze LAM aus der reservierung rausnehmen
                                                update lvs_lam t
                                                set
                                                    t.order_pos_auf_id = null,
                                                    t.res_menge = null,
                                                    t.res_ziel_lte_id = null,
                                                    t.res_login_id = null
                                                where
                                                        t.sid = v_lte_lams.sid
                                                    and t.firma_nr = v_lte_lams.firma_nr
                                                    and t.lam_id = v_lte_lams.lam_id;

                                                v_menge := v_menge - v_lte_lams.menge;
                                                v_menge_sum := v_menge_sum - v_lte_lams.menge;
                                            else
                                                if in_order_pos.wa_menge_ueberlief != 'OLHM' -- Overdelivery LHM bedeutet, dass solange LHMs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LHM mit der die Menge überschritten wird, wird auch komplett reserviert
                                                 then
                        -- nur Teilmenge reserviert lassen (für spätere kommissionierung)
                                                    update lvs_lam t
                                                    set
                                                        t.res_menge = v_lte_lams.menge - v_delta_menge,
                                                        t.res_ziel_lte_id = v_komm_ziel_lte_id,
                                                        t.res_login_id = in_user_id
                                                    where
                                                            t.sid = v_lte_lams.sid
                                                        and t.firma_nr = v_lte_lams.firma_nr
                                                        and t.lam_id = v_lte_lams.lam_id;

                                                end if;

                                                v_menge := v_menge - ( v_lte_lams.menge - v_delta_menge );
                                                v_menge_sum := v_menge_sum - v_delta_menge;
                                            end if;

                                            if v_menge = 0 -- Von dieser Palette ist nichts mehr Reserviert

                                             then
                                                v_result := lvs_lte_res_rueck(in_order_pos.sid, in_order_pos.firma_nr, in_order_pos.vorgang_id
                                                , in_order_pos.auf_id, v_lte.lte_id,
                                                                              v_lte.order_vorgang_id, v_lte.lgr_platz, c.c_true);

                                            end if;

                                        else
                    -- Da von dieser LTE Kommissioniert wird, müssen alle reservierten LHMs fur eine Ziel LTE
                    -- reserviert werden.
                                            update lvs_lam t
                                            set
                                                t.res_ziel_lte_id = v_komm_ziel_lte_id
                                            where
                                                    t.sid = v_lte_lams.sid
                                                and t.firma_nr = v_lte_lams.firma_nr
                                                and t.lam_id = v_lte_lams.lam_id;

                                        end if;
                                    end if;

                                    if
                                        ( v_menge_sum - ( in_order_pos.soll_menge - nvl(in_order_pos.ist_menge, 0) ) = 0 )
                                        and v_komm_ziel_lte_id is not null
                                    then
                  -- wir können die alte LTE entlasten, die LoginID bleibt, damit ein Restmengen-Etikett
                  -- gedruckt werden kann
                                        update lvs_lte t
                                        set
                                            t.res_ziel_lgr_platz = null,
                         --t.res_login_id = null,
                                            t.order_auf_id = null,
                                            t.order_vorgang_id = null
                                        where
                                            t.lte_id = v_lte_lams.lte_id;

                                    end if;

                -- neu berechnen, was zuviel ist
                                    v_delta_menge := v_menge_sum - ( in_order_pos.soll_menge - nvl(in_order_pos.ist_menge, 0) );

                                end loop;

                                close c_lte_lams;
                            end if;

                        end if;

                    end if;

                    exit when v_menge_sum >= in_order_pos.soll_menge - nvl(in_order_pos.ist_menge, 0); -- Fertig wenn Menge erreicht
                end if;

            end loop;

            close c_ltes;
            if v_menge_sum = 0 then
      -- Falls nur Reservieren dann erst mal Fehler
                if in_aktivieren != c.c_true then
                    result := -1;
                end if;
            end if;

        else
    -- Es ist bereits Ware für diese Order disponiert worden.
            result := -10;
        end if;

        if in_aktivieren = c.c_true                                      -- Transport soll aktiviert werden

         then
            open c_lam_auf_id;
            loop
                fetch c_lam_auf_id into v_lte_id;
                exit when c_lam_auf_id%notfound;
                open c_lte;
                loop
                    fetch c_lte into v_lte;
                    exit when c_lte%notfound;
                    if
                        in_aktivieren = c.c_true
                        and ( v_lte.lte_status = c.lte_lf_stat
                        or v_lte.lte_status = c.lte_bf_stat ) -- Erst mal nur Paletten die fertig befüllt oder im Lager sind
                    then
                        v_lte_lgr_ort := v_lte.lgr_ort;
                        open c_lgr_ort;
                        fetch c_lgr_ort into v_lgr_ort;
                        v_found := c_lgr_ort%found;
                        close c_lgr_ort;
                        if not v_found then
                            v_err_nr := 30;
                            v_err_text := lc.ec_p2(lc.o_tp2_lte_lgr_ort_fehlt, v_lte.lte_id, v_lte_lgr_ort);
                            raise v_error;
                        end if;

                        v_trans_typ := null;
                        if in_order_pos.vorgang_typ like ( 'WE%' ) then
                            v_trans_typ := 'E';
                        elsif in_order_pos.vorgang_typ like ( 'WA%' ) then
                            v_trans_typ := 'A';
                        elsif in_order_pos.vorgang_typ like ( 'WU%' ) then
                            v_trans_typ := 'U';
                        end if;

                        if nvl(v_order_transport_gruppe, 0) != nvl(in_order_pos.transport_gruppe, 0)
                        or v_transport_gruppe is null then
                            if nvl(in_order_pos.vorgang_id, 0) != 0 then
                                select
                                    seq_transport_gruppe.nextval
                                into v_transport_gruppe
                                from
                                    dual;

                                v_order_transport_gruppe := in_order_pos.transport_gruppe;
                            end if;
                        end if;

                        if v_transport_gruppe is null then
                            v_transport_gruppe := 0;
                        end if;
                        result := lvs_transport.lvs_transp_lte(in_order_pos.sid,          -- in_sid                  IN isi_sid.sid%TYPE,
                         in_order_pos.firma_nr,     -- in_firma_nr             IN isi_firma.firma_nr%TYPE,
                         v_modul_bearb,             -- in_modul_erzeuger       IN isi_transport.modul_erzeuger%TYPE,
                         v_lgr_ort.lgr_ort_modul,   -- in_modul_bearbeiter     IN isi_transport.modul_bearbeiter%TYPE,
                         c.c_false,                 -- in_frei_fahren          IN varchar2,
                                                               v_trans_typ,               -- in_trans_typ            in varchar2,
                                                                in_user_id,                -- in_user_id              IN isi_user.login_id%TYPE,
                                                                in_order_pos.auf_id,       -- in_auftrag_id           IN isi_transport.auf_id%TYPE,
                                                                in_order_pos.auf_id_extern,-- in_auftrag_id_extern    IN isi_transport.auf_id_extern%TYPE,
                                                                in_order_pos.prioritaet,   -- in_prio                 IN isi_transport.prio%TYPE,
                                                               0,                         -- in_progr_nr             IN isi_transport.progr_nr%TYPE,
                                                                0,                         -- in_quelle_leer_progr_nr IN isi_transport.quelle_leer_progr_nr%TYPE,
                                                                0,                         -- in_ziel_voll_progr_nr   IN isi_transport.ziel_voll_progr_nr%TYPE,
                                                                v_lte.lgr_platz,           -- in_lgr_quell_lgr_platz  IN lvs_lte.lgr_platz%TYPE,
                                                                in_order_pos.ziel,         -- in_lgr_ziel_lgr_platz   IN lvs_lte.lgr_platz%TYPE,
                                                               v_lte.lte_id,              -- in_lte_id               IN lvs_lte.lte_id%TYPE,
                                                                v_adressen.adress_id,      -- in_kunde_nr             IN lvs_lam.kunden_nr%TYPE
                                                                c.c_true,                  -- in_lieferschein
                                                                in_order_pos.li_nr,        -- Lieferschein Nummer
                                                                in_order_pos.li_pos_nr,    -- Lieferscheinposition -Nummer
                                                               in_order_pos.vorgang_id,   -- Tournummer
                                                                null,                      -- in_fahrzeuge_IDs Hier nicht mehr Prüfen da die Paletten schon im Vorfeld Reserviert wurden
                                                                in_order_kopf.lkw_nr, v_transport_gruppe, v_transp_id);

                    end if;

                end loop;

                close c_lte;
            end loop;

            close c_lam_auf_id;
        end if;

        return ( result );
    exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_ltes%isopen then
                close c_ltes;
            end if;
            if c_lam_auf_id%isopen then
                close c_lam_auf_id;
            end if;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_ltes%isopen then
                close c_ltes;
            end if;
            if c_lam_auf_id%isopen then
                close c_lam_auf_id;
            end if;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

    function lvs_lam_bh_update_mg (
        in_lam_bh in lvs_lam_bh%rowtype,
        in_menge  in lvs_lam_bh.menge%type
    ) return integer is

        result                 integer;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
        v_error exception;                 --
        v_err_nr               number;
        v_err_text             varchar2(2550);
        v_neuer_status         lvs_lte.lte_status%type; -- neuer status der LTE

        v_lam                  lvs_lam%rowtype;    -- Lagerbestand der aktuellen Buchung
        v_lgr                  lvs_lgr%rowtype;    -- Lagerplatz des Materials
        v_lhm                  lvs_lhm%rowtype;    -- Lagerhilfsmittel des Materials
        v_lte                  lvs_lte%rowtype;    -- LagerTransporteinheit des Materials
        v_art                  isi_artikel%rowtype;-- Artikelstamm
        v_order_pos            isi_order_pos%rowtype;-- Bestellung oder Lieferung

        v_count                number;             -- Anzahl LHM's auf der LTE
        v_max_temp             number;             -- Maximaltemperatur für LTE
        v_min_temp             number;             -- Maximaltemperatur für LTE
        v_max_breite           number;             -- Maximaltemperatur für LTE
        v_max_tiefe            number;             -- Maximaltemperatur für LTE
        v_max_hoehe            number;             -- Maximaltemperatur für LTE
        v_max_wert_k           number;             -- Maximaltemperatur für LTE
        v_max_gefahren_k       number;             -- Maximaltemperatur für LTE

        v_art_lte_menge        number;
        v_anz_lagen            number(3);         -- Anzahl der Lagen auf der LTE (Palette)
        v_lte_akt_lhm          number(3);         -- Aktuelle LHM's auf LTE

        v_lte_cfg              lvs_lte_cfg%rowtype;-- Cfg Der LTE (Palette)
        v_tabelle              varchar2(10);
        v_res_mhd              date;               -- Datum gleiches MHD

        v_found                boolean;            -- Daten gefunden ?
        v_diff_mg              number;             -- Differenz Menge der Buchung
        v_diff_mg_s            number;             -- Differenz Menge der Schittstelle

        v_fa_auftrag           bde_fa_auftrag%rowtype;
        v_firma                isi_firma%rowtype;
        v_art_kd               isi_artikel_kunde%rowtype;
        v_art_lte_hoehe_max    v_art.lte_hoehe_max%type;
        v_art_lte_breite_max   v_art.lte_breite_max%type;
        v_art_lte_tiefe_max    v_art.lte_tiefe_max%type;
        v_art_lhm_hoehe_lage   v_art.lhm_hoehe_lage%type;
        v_art_lte_lhm_menge    v_art.lte_lhm_menge%type;
        v_art_lte_lhm_pro_lage v_art.lte_lhm_pro_lage%type;
        v_art_lte_lhm_lagen    v_art.lte_lhm_lagen%type;
        v_fa_ag                lvs_lam_bh.fa_ag%type;
        v_lte_hoehe            lvs_lte.lte_vol_hoehe%type;
        v_lte_hoehe_diff       lvs_lte.lte_vol_hoehe%type;
        v_raster_x             number;
        v_raster_y             number;

  -- -AG- BugFix Auftrag AG für Fertigprodukte wurde nicht mehr gefunden
        cursor c_fa_auftrag is
        select
            *
        from
            bde_fa_auftrag fa
        where
                fa.sid = in_lam_bh.sid
            and fa.firma_nr = in_lam_bh.firma_nr
            and fa.leitzahl = in_lam_bh.leitzahl
            and ( fa.fa_ag < v_fa_ag
                  or ( fa.fa_ag = v_fa_ag
                       and fa.satzart = 'MA' )
                  or ( v_fa_ag is null
                       and fa.kenz_letzt_ag = 1 ) )
            and fa.ag_artikel_id = in_lam_bh.artikel_id;

        cursor c_order_best is
        select
            *
        from
            isi_order_pos t
        where
            t.vorgang_typ in ( 'WEE', 'KWE' ) -- Bestellung -- -AG- 16.04.2015 Fix->Konsi Storno
            and t.vorgang_id = v_lam.best_nr
            and t.pos_nr = v_lam.best_pos;

        cursor c_lam is                        -- Cursor für den Lagerbestand der aktuellen Buchung
        select
            *
        from
            lvs_lam
        where
            lam_id = in_lam_bh.lam_id;

        cursor c_lgr is                        -- Lesen des Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz = in_lam_bh.lgr_platz;

        cursor c_lte is                        -- Lesen der Transporteinheit
        select
            *
        from
            lvs_lte lte
        where
            lte.lte_id = in_lam_bh.lte_id;

        cursor c_lte_cfg is                        -- Lesen der CFG Transporteinheit
        select
            *
        from
            lvs_lte_cfg lte_cfg
        where
                lte_cfg.sid = v_lte.sid
            and lte_cfg.firma_nr = v_lte.firma_nr
            and lte_cfg.lte_name = v_lte.lte_name;

        cursor c_lhm is                        -- Lesen des Lagerhilfsmittel
        select
            *
        from
            lvs_lhm lhm
        where
            lhm.lhm_id = in_lam_bh.lhm_id;

        cursor c_art is
        select
            *
        from
            isi_artikel art
        where
                art.sid = in_lam_bh.sid
            and art.artikel_id = in_lam_bh.artikel_id;

        cursor c_art_kd is
        select
            *
        from
            isi_artikel_kunde ak
        where
                ak.sid = in_lam_bh.sid
            and ak.artikel_id = in_lam_bh.artikel_id
            and ak.kunden_nr = v_lam.kunden_nr;

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
                lam_lte.sid = in_lam_bh.sid
            and lam_lte.lte_id = in_lam_bh.lte_id
            and lam_lte.menge > 0
            and art.sid = in_lam_bh.sid
            and art.artikel_id = in_lam_bh.artikel_id;

        cursor c_firma is
        select
            *
        from
            isi_firma f
        where
                f.sid = in_lam_bh.sid
            and f.firma_nr = in_lam_bh.firma_nr;

    begin
        open c_firma;
        fetch c_firma into v_firma;
        close c_firma;

  -- Lesen der Artikeldaten
        v_err_nr := null;
        v_err_text := null;
        v_diff_mg := 0;
---------------------------------------------------------------------------------------------------------------------------------
  -- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang
        if in_lam_bh.bus in ( c.lam_bh_bus_zug,        -- Zugang,
         c.lam_bh_bus_zug_komm,   -- Zugang KommDirekt,
         c.lam_bh_bus_zug_konsi )  -- Zugang Konsi
         then
            v_diff_mg := in_menge - in_lam_bh.menge;
            v_diff_mg_s := v_diff_mg;
            v_fa_ag := in_lam_bh.fa_ag + 1;
---------------------------------------------------------------------------------------------------------------------------------
  -- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang
        elsif in_lam_bh.bus in ( c.lam_bh_bus_abg,                -- Abgang
         c.lam_bh_bus_abg_komm,           -- Abgang KommDirekt
         c.lam_bh_bus_q,                  -- Abgang Quarantäne
         c.lam_bh_bus_abg_konsi )          -- Abgang Konsignationsware
         then
            v_diff_mg := in_lam_bh.menge - in_menge;
            v_diff_mg_s := v_diff_mg * -1;
            v_fa_ag := in_lam_bh.fa_ag;
        end if;

        if v_diff_mg = 0 then
            return ( 0 );
        end if;

  -- -AG- bugFix LTE wurde nicht gelesen
        open c_lte;
        fetch c_lte into v_lte;                -- Lesen der Daten
        close c_lte;                           -- Cursor wieder zu

        open c_lam;                            -- Lagerbestand oeffnen
        fetch c_lam into v_lam;                -- Lesen der Daten
        v_found := c_lam%found;                -- Daten gefunden ?
        close c_lam;                           -- Cursor wieder zu
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lam_fehlt, in_lam_bh.lam_id);
            raise v_error;
        else
            if v_lam.menge + v_diff_mg < 0 then
                v_err_nr := 20;
                v_err_text := lc.ec(lc.o_txt_bestand_kleiner_null);
                raise v_error;
            end if;

            if in_lam_bh.leitzahl is not null then
                open c_fa_auftrag;
                fetch c_fa_auftrag into v_fa_auftrag;
                v_found := c_fa_auftrag%found;
                close c_fa_auftrag;
            else
                v_found := false;
            end if;

            v_lam.lte_id := in_lam_bh.lte_id;
            v_lam.lhm_id := in_lam_bh.lhm_id;
            v_lam.lgr_platz := v_lte.lgr_platz;
            if v_found then
                if v_lam.lgr_platz is not null
                   or in_lam_bh.bus = c.lam_bh_bus_abg then
        -- -AG- BugFix: Wenn in der LAM kein lagerplatz ist, dann den aus der Buchung nehmen
                    if v_lam.lgr_platz is null then
                        v_lam.lgr_platz := in_lam_bh.lgr_platz;
                    end if;

                    s_schnittstelle.write_host_prod_bew_menge(in_lam_bh.sid, in_lam_bh.firma_nr, v_fa_auftrag, v_lam, in_lam_bh.lam_bh_id
                    ,
                                                              in_lam_bh.bus, in_lam_bh.vorg_typ, 'S_FA', 'UE', v_diff_mg_s,
                                                              in_lam_bh.ls_login_id);

                else
                    update s_send_bew s
                    set
                        s.menge = s.menge + v_diff_mg_s
                    where
                        s.lam_bh_id = in_lam_bh.lam_bh_id;

                end if;

                if in_lam_bh.bus = c.lam_bh_bus_abg                -- Abgang im FA Korrigieren

                 then
                    update bde_fa_auftrag fa
                    set
                        fa.ag_ist_mg = nvl(fa.ag_ist_mg, 0) + v_diff_mg_s
                    where
                            fa.sid = in_lam_bh.sid
                        and fa.firma_nr = in_lam_bh.firma_nr
                        and fa.leitzahl = v_fa_auftrag.leitzahl
                        and fa.fa_ag = v_fa_auftrag.fa_ag
                        and fa.fa_upos = v_fa_auftrag.fa_upos;

                end if;

            else
                v_order_pos := null;
      -- -AG- 16.04.2015 Fix->Konsi Storno
                if in_lam_bh.bus = c.lam_bh_bus_zug
                or in_lam_bh.bus = c.lam_bh_bus_zug_konsi then
                    v_tabelle := null;
                    if v_lam.best_nr is not null then
                        open c_order_best;
                        fetch c_order_best into v_order_pos;
                        v_found := c_order_best%found;
                        close c_order_best;
                        if v_found then
                            if v_order_pos.auf_id_extern is not null then
                                v_tabelle := 'S_AUF';
                            end if;
                        end if;

                    end if;

                else
                    if in_lam_bh.abnr_extern is null then
                        v_tabelle := null;
                    else
                        v_tabelle := 'S_AUF';
                    end if;
                end if;

                if v_lam.lgr_platz is not null then
                    s_schnittstelle.write_host_bew_menge(v_order_pos, v_lam, in_lam_bh.lam_bh_id, in_lam_bh.bus, in_lam_bh.vorg_typ,
                                                         v_tabelle, 'UE', v_lte.lgr_platz, null, in_lam_bh.ls_login_id,
                                                         v_diff_mg_s);
                else
                    update s_send_bew s
                    set
                        s.menge = s.menge + v_diff_mg_s
                    where
                        s.lam_bh_id = in_lam_bh.lam_bh_id;

                end if;

            end if;

            open c_lte;                            -- Palettendaten oeffnen
            fetch c_lte into v_lte;                -- Lesen der Daten
            v_found := c_lte%found;                -- Daten gefunden ?
            close c_lte;                           -- Cursor wieder zu
            if not v_found then
                v_err_nr := 20;
                v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_lam_bh.lte_id);
                raise v_error;
            end if;

            v_lte_hoehe := v_lte.lte_vol_hoehe;

    -- Artikeldaten lesen
            open c_art;
            fetch c_art into v_art;
            close c_art;
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

            if v_lte.lte_vol_hoehe < v_art.lte_hoehe_max then
                v_lte.lte_vol_hoehe := v_art.lte_hoehe_max;                   -- Artikel kann höher werden
            end if;

            if v_lte.lte_vol_breite < v_art.lte_breite_max then
                v_lte.lte_vol_breite := v_art.lte_breite_max;                 -- Artikel kann höher werden
            end if;

            if v_lte.lte_vol_tiefe < v_art.lte_tiefe_max then
                v_lte.lte_vol_tiefe := v_art.lte_tiefe_max;                   -- Artikel kann höher werden
            end if;

            if v_lte.res_artikel_id is null then
                v_lte.res_artikel_id := to_char(v_art.artikel_id);
            end if;

            if v_lte.res_artikel_id != to_char(v_art.artikel_id) then
                v_lte.res_artikel_id := 'MP';
            end if;

            if v_lte.waren_typ = c.leerpal then
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

            if v_art.gefahren_klasse > v_lte.gefahren_klasse then
                v_lte.gefahren_klasse := v_art.gefahren_klasse;
            end if;

            if v_art.wert_klasse > v_lte.wert_klasse then
                v_lte.wert_klasse := v_art.wert_klasse;
            end if;

            v_res_mhd := v_lte.res_mhd;        -- MHD für Gruppe
            if v_lte.res_string_statisch is null then
                v_lte.res_string := lvs_util.get_res_string_v359(in_lam_bh.sid, in_lam_bh.firma_nr, v_lte.waren_typ, v_lte.res_artikel_id
                , v_lam.hersteller_kuerzel_liste,
                                                                 v_lam.fa_ag, v_lam.charge_id, v_lam.serie_id, v_lam.leitzahl, v_lam.kunden_nr
                                                                 ,
                                                                 v_lam.lieferant_nr, v_lam.best_nr, v_lam.lam_mhd, 1, v_lam.labor_status
                                                                 ,
                                                                 v_lte.lte_voll, v_lam.owner_address_id, v_res_mhd);
            else
                v_lte.res_string := v_lte.res_string_statisch;
            end if;

            v_lte.res_mhd := v_res_mhd;        -- MHD für Gruppe
            if v_lte.waren_typ != 'MP' then
                begin
                    begin
                        if v_art_lhm_hoehe_lage is null then
                            v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe / nvl(v_art_lte_lhm_lagen, 1);
                        end if;
                    exception
                        when others then
                            v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe;
                    end;

                    if nvl(v_art_lte_lhm_pro_lage, 0) = 0 then
                        begin
                            if nvl(v_art_lte_lhm_menge / v_art_lte_lhm_lagen, 0) != 0 then
                                v_art_lte_lhm_pro_lage := v_art_lte_lhm_menge / v_art_lte_lhm_lagen;
                            else
                                v_art_lte_lhm_pro_lage := 1;
                            end if;

                        exception
                            when others then
                                v_art_lte_lhm_pro_lage := 1;
                        end;

                    end if;

                    if v_art.menge_basis = c.basis_lte then
                        v_art_lte_menge := 1;
                        v_anz_lagen := v_art_lte_lhm_lagen;
                    elsif v_art.menge_basis = c.basis_lhm then
                        v_art_lte_menge := v_art_lte_lhm_menge;
                        v_lte_akt_lhm := lvs_p_lte_lhm.lvs_lte_lhm_best(in_lam_bh.sid, in_lam_bh.firma_nr, in_lam_bh.lte_id, 'LTE');

                        v_anz_lagen := round((v_lte_akt_lhm / v_art_lte_lhm_pro_lage + 0.49), 0);
                    else
                        v_art_lte_menge := v_art_lte_menge;
                        v_anz_lagen := round((v_lte.lte_akt_lhm / v_art_lte_lhm_pro_lage) + 0.49, 0);

                    end if;

                    if
                        lvs_p_lte_lhm.lvs_lte_lhm_best(in_lam_bh.sid, in_lam_bh.firma_nr, in_lam_bh.lte_id, 'LTE') >= v_art_lte_menge * v_firma.proz_anbruch / 100
                        and v_art.waren_typ != c.rohware
                    then
                        v_lte.lte_voll := 'V';
                    else
                        if v_art.waren_typ != c.rohware then
                            open c_lte_cfg;
                            fetch c_lte_cfg into v_lte_cfg;
                            v_found := c_lte_cfg%found;
                            close c_lte_cfg;
                            if not v_found then
                                v_lte_cfg.lte_vol_hoehe := 0;
                            end if;
                            v_lte.lte_vol_hoehe := v_lte_cfg.lte_vol_hoehe + nvl(v_anz_lagen, 1) * v_art_lhm_hoehe_lage;
                        end if;

                        v_lte.lte_voll := 'A';
                    end if;

                exception
                    when others then
                        v_art_lte_lhm_lagen := 1;
                        v_art_lhm_hoehe_lage := v_lte.lte_vol_hoehe;
                end;
            end if;

            v_lte.lte_vol := v_lte.lte_vol_tiefe * v_lte.lte_vol_breite * v_lte.lte_vol_hoehe / 1000000000;                   -- Artikel kann höher werden

    -- Es war kein Bestand vorhande, es wird aber neuer Bestand gebucht (geändert)
            if
                v_lam.menge = 0
                and v_diff_mg > 0
            then
                if v_lte.lte_akt_lhm = 0
                or            -- Palette ist leer oder hat keinen Lagerplatz
                 v_lte.lgr_platz is null then
                    open c_lgr;
                    fetch c_lgr into v_lgr;
                    close c_lgr;
                    v_lgr.lgr_akt_kg := nvl(v_lgr.lgr_akt_kg, 0);
        -- -AG- 05.05.2011 Die Palette muss immer zugebucht werden, wenn die Anz-LHM von 0 auf > 0 geht.
                    v_lgr.lgr_akt_te := nvl(v_lgr.lgr_akt_te, 0) + 1;
                    v_lgr.lgr_akt_kg := nvl(v_lgr.lgr_akt_kg, 0) + v_lte.lte_akt_kg;
                    if v_lte.lgr_platz is null then      -- Palette hat keinen Lagerplatz
                        v_lte.lgr_platz := in_lam_bh.lgr_platz;
                        v_lte.lgr_ort := v_lgr.lgr_ort;
                    end if;

                    if v_lte.lte_akt_lhm = 0 then
                        if v_lgr.lgr_verwendung = c.lgr_typ_we then
                            v_neuer_status := c.lte_bf_stat;
                        elsif v_lgr.lgr_verwendung = c.lgr_typ_lagerp then
                            v_neuer_status := c.lte_bf_stat;
                        elsif v_lgr.lgr_verwendung = c.lgr_typ_wa then
                            v_neuer_status := c.lte_af_stat;
                        elsif v_lgr.lgr_verwendung = c.lgr_typ_ep then
                            v_neuer_status := c.lte_et_stat;
                        else
                            v_neuer_status := c.lte_lf_stat;
                        end if;

                        if
                            lvs_p_lte_lhm.lvs_lte_lhm_best(in_lam_bh.sid, in_lam_bh.firma_nr, in_lam_bh.lte_id, 'LTE') >= v_art_lte_menge * v_firma.proz_anbruch / 100
                            and v_art.waren_typ != c.rohware
                        then
                            v_lte.lte_voll := 'V';
                        else
                            v_lte.lte_voll := 'A';
                        end if;

                        update lvs_lte
                        set
                            lgr_platz = v_lte.lgr_platz,
                            lgr_ort = v_lte.lgr_ort,
                            lgr_platz_gruppe = v_lgr.lgr_platz_gruppe,
                            lte_status = v_neuer_status,
                            lte_voll = v_lte.lte_voll,
                            res_artikel_id = v_lte.res_artikel_id,
                            waren_typ = v_lte.waren_typ,
                            res_string = v_lte.res_string,
                            res_mhd = v_lte.res_mhd
                        where
                            lte_id = in_lam_bh.lte_id;

                    end if;

                    update lvs_lgr
                    set
                        lgr_akt_te = v_lgr.lgr_akt_te,
                        lgr_akt_kg = v_lgr.lgr_akt_kg,
                        lgr_einl_te_verfueg = nvl(lgr_max_te, 0) - nvl(lgr_akt_te, 0) - nvl(lgr_dispo_einl_te, 0)
                    where
                        lgr_platz = v_lte.lgr_platz;

                end if;

                update lvs_lam
                set
                    lgr_platz = v_lte.lgr_platz,
                    lte_id = in_lam_bh.lte_id,
                    lhm_id = in_lam_bh.lhm_id
                where
                    lam_id = in_lam_bh.lam_id;

                update lvs_lhm
                set
                    lgr_platz = v_lte.lgr_platz,
                    lte_id = in_lam_bh.lte_id
                where
                    lhm_id = in_lam_bh.lhm_id;

                update lvs_lte
                set
                    lte_akt_lhm = v_lte.lte_akt_lhm + 1,
                    min_temp = nvl(v_lte.min_temp, -300),
                    max_temp = nvl(v_lte.max_temp, 300),
                    lte_vol_hoehe = v_lte.lte_vol_hoehe,
                    lte_vol_breite = v_lte.lte_vol_breite,
                    lte_vol_tiefe = v_lte.lte_vol_tiefe,
                    lte_vol = v_lte.lte_vol,
                    wert_klasse = v_lte.wert_klasse,
                    gefahren_klasse = v_lte.gefahren_klasse
                where
                    lte_id = in_lam_bh.lte_id;

                v_lte_hoehe_diff := v_lte.lte_vol_hoehe - v_lte_hoehe;
                update lvs_lgr
                set
                    lgr_frei_hoehe = lgr_frei_hoehe + decode(lgr_typ, c.reg_fach1, v_lte_hoehe_diff, c.stap_flae1, v_lte_hoehe_diff,
                                                             c.stap_flae2, v_lte_hoehe_diff, 0)
                where
                    lgr_platz = v_lte.lgr_platz;

            end if;

            if v_lam.menge + v_diff_mg = 0 then
                update lvs_lam
                set
                    lgr_platz = null,
                    lte_id = null,
                    lhm_id = null
                where
                    lam_id = in_lam_bh.lam_id;

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
                v_lte_hoehe_diff := v_lte.lte_vol_hoehe - v_lte_hoehe;
                if v_lte.lte_akt_lhm = 1 then            -- Palette wird leer

        -- 09.10.2008 -AG- Anpassung, alle Paletten in status Befüllen oder Befüllen fertig werden nicht
        -- ausgebuchrt, wenn sie durch eine Mengenänderung leer sind (Können dann weiter befüllt werden)
                    update lvs_lte                         -- Eine LHM weniger
                    set
                        lte_akt_lhm = v_lte.lte_akt_lhm - 1,
                        lgr_platz = decode(lte_status, c.lte_bs_stat, lgr_platz, c.lte_bf_stat, lgr_platz,
                                           null),
                        lgr_platz_gruppe = decode(lte_status, c.lte_bs_stat, lgr_platz_gruppe, c.lte_bf_stat, lgr_platz_gruppe,
                                                  null),
                        lte_status = decode(lte_status, c.lte_bs_stat, lte_status, c.lte_bf_stat, c.lte_bs_stat,
                                            c.lte_ag_stat),
                        min_temp = - 300,
                        max_temp = 300,
                        lte_vol_hoehe = v_lte.lte_vol_hoehe,
                        lte_vol_breite = v_lte.lte_vol_breite,
                        lte_vol_tiefe = v_lte.lte_vol_tiefe,
                        lte_vol = v_lte.lte_vol,
                        lte_voll = null,
                        wert_klasse = 0,
                        gefahren_klasse = 0,
                        res_artikel_id = null,
                        waren_typ = c.leerpal,
                        res_string = null,
                        res_mhd = null
                    where
                        lte_id = in_lam_bh.lte_id;
        -- AG 2019-01-08 Updatereihenfolge geaendert (DeadLock)
                    update lvs_lgr                         -- Lagerplatz entlasten und Palettengewicht abziehen
                    set
                        lgr_akt_te = nvl(lgr_akt_te, 0) - 1,
                        lgr_akt_kg = nvl(lgr_akt_kg, 0) - nvl(v_lte.lte_akt_kg, 0) + nvl(in_lam_bh.lam_bh_kg, 0),
                        lgr_einl_te_verfueg = nvl(lgr_max_te, 0) - nvl(lgr_akt_te, 0) - nvl(lgr_dispo_einl_te, 0),
                        lgr_frei_hoehe = lgr_frei_hoehe + decode(lgr_typ, c.reg_fach1, v_lte_hoehe_diff, c.stap_flae1, v_lte_hoehe_diff
                        ,
                                                                 c.stap_flae2, v_lte_hoehe_diff, 0)
                    where
                        lgr_platz = v_lte.lgr_platz;

                else
                    update lvs_lte                         -- Eine LHM weniger
                    set
                        lte_akt_lhm = v_lte.lte_akt_lhm - 1
                    where
                        lte_id = in_lam_bh.lte_id;

                end if;

                update lvs_lhm
                set
                    lgr_platz = null,
                    lte_id = null
                where
                    lhm_id = in_lam_bh.lhm_id;

            end if;

        end if;

        return ( 1 );
    exception
  -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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
    end lvs_lam_bh_update_mg;

--------------------------------------------------------------------------------
-- procedure LVS_OHNE_TRANSP_LTE_PRUEFEN
-- LTE fuer schnellverladung pruefen
--------------------------------------------------------------------------------
    procedure lvs_ohne_transp_lte_pruefen (
        in_lte_id in lvs_lte.lte_id%type
    ) is

        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
        v_found    boolean;
        v_lte      lvs_lte%rowtype;
        v_lgr_ort  lvs_lgr_ort%rowtype;
        cursor c_lte is
        select
            lte.*
        from
            lvs_lte lte
        where
            lte.lte_id = in_lte_id;

        cursor c_lgr_ort is
        select
            ort.*
        from
            lvs_lgr_ort ort
        where
                ort.sid = v_lte.sid
            and ort.lgr_ort = v_lte.lgr_ort;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_lte;
        fetch c_lte into v_lte;
        v_found := c_lte%found;
        close c_lte;
        if not v_found then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_lte_id);
            raise v_error;
        end if;

        if v_lte.lte_status not in ( c.lte_lf_stat, c.lte_bf_stat, c.lte_af_stat ) then
            v_err_nr := 10;
            v_err_text := lc.ec_p4(lc.o_tp4_lte_status_falsch, v_lte.lte_status, c.lte_lf_stat, c.lte_bf_stat, in_lte_id);

            raise v_error;
        end if;

        if v_lte.order_vorgang_id is not null then
            v_err_nr := 15;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_ist_res, in_lte_id);
            raise v_error;
        end if;

        open c_lgr_ort;
        fetch c_lgr_ort into v_lgr_ort;
        v_found := c_lgr_ort%found;
        close c_lgr_ort;
        if not v_found then
            v_err_nr := 30;
            v_err_text := lc.ec_p2(lc.o_tp2_lte_lgr_ort_fehlt, in_lte_id, v_lte.lgr_ort);
            raise v_error;
        end if;

        if
            v_lgr_ort.lgr_ort_modul <> c.lgr_modul_sls
            and v_lgr_ort.lgr_ort_modul <> c.lgr_modul_papier
        then
            v_err_nr := 40;
            v_err_text := lc.ec_p2(lc.o_tp2_lgr_ort_keine_schnellver, v_lte.lgr_ort, v_lgr_ort.lgr_ort_modul);

            raise v_error;
        end if;

    exception
  -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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
    end lvs_ohne_transp_lte_pruefen;

--------------------------------------------------------------------------------
-- procedure LVS_C_OHNE_TRANSP_START
-- Schnellverladung starten
-- If we have already Task for my res_id, in out_lte_id we will get the LTE
-- number, in out_transp_id - transport identifier.
-- If not, we will get in out_lte_id and in out_transp_id NULL's.
--------------------------------------------------------------------------------
    procedure lvs_c_ohne_transp_start (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_vorgang_id  in isi_order_kopf.vorgang_id%type,
        in_li_nr       in isi_order_kopf.li_nr%type,
        in_res_id      in isi_resource.res_id%type,
        out_lte_id     out lvs_lte.lte_id%type,
        out_transp_id  out isi_transport.transp_id%type
    ) is

        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(2550);
        v_found      boolean;
        v_order_kopf isi_order_kopf%rowtype;
        v_transport  isi_transport%rowtype;
        cursor c_order_kopf is
        select
            t.*
        from
            isi_order_kopf t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.vorgang_typ = in_vorgang_typ
            and t.vorgang_id = in_vorgang_id
            and t.li_nr = in_li_nr;

        cursor c_transport is
        select
            t.*
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.li_nr = in_li_nr
            and t.modul_erzeuger = c.lgr_modul_sls
            and t.modul_bearbeiter = c.lgr_modul_sls
            and t.res_id = in_res_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_order_fehlt);
            raise v_error;
        end if;

        if v_order_kopf.status = 'E' then
            v_err_nr := 20;
            v_err_text := lc.ec(lc.o_txt_order_auft_zu);
            raise v_error;
        end if;

        open c_transport;
        fetch c_transport into v_transport;
        v_found := c_transport%found;
        close c_transport;
        if v_found then
            out_lte_id := v_transport.lte_id;
            out_transp_id := v_transport.transp_id;
        else
            if v_order_kopf.ohne_transport = c.c_false then
                v_err_nr := 30;
                v_err_text := lc.ec(lc.o_txt_order_auft_dir_verl);
                raise v_error;
            end if;

            out_lte_id := null;
            out_transp_id := null;
            update isi_order_kopf t
            set
                t.ohne_transp_anz = nvl(t.ohne_transp_anz, 0) + 1,
                t.status = 'A'
            where
                    t.sid = in_sid
                and t.firma_nr = in_firma_nr
                and t.vorgang_typ = in_vorgang_typ
                and t.vorgang_id = in_vorgang_id
                and t.li_nr = in_li_nr;

            if sql%rowcount <> 1 then
                v_err_nr := 30;
                v_err_text := lc.ec(lc.o_txt_order_auft_no_update);
                raise v_error;
            end if;

        end if;

        commit;
    exception
  -- Im Fehlerfall ist der Fehler bereits gesetzt,
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

    end lvs_c_ohne_transp_start;

--------------------------------------------------------------------------------
-- procedure LVS_C_OHNE_TRANSP_LTE
-- LTE - Schnellverladung
--------------------------------------------------------------------------------
    procedure lvs_c_ohne_transp_lte (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_vorgang_id  in isi_order_kopf.vorgang_id%type,
        in_li_nr       in isi_order_kopf.li_nr%type,
        in_res_id      in isi_resource.res_id%type,
        in_user_id     in isi_user.login_id%type,
        in_lte_id      in lvs_lte.lte_id%type,
        out_transp_id  out isi_transport.transp_id%type
    ) is

        v_error exception;
        v_err_nr            number;
        v_ret_val           number;
        v_err_text          varchar2(2550);
        v_found             boolean;
        v_artikel_id        isi_artikel.artikel_id%type;
        v_lam_bh_vorgang_id isi_transport.lam_bh_vorgang_id%type;
        v_order_kopf        isi_order_kopf%rowtype;
        v_trans_typ         isi_transport.transp_typ%type;
        cursor c_order_kopf is
        select
            t.*
        from
            isi_order_kopf t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.vorgang_typ = in_vorgang_typ
            and t.vorgang_id = in_vorgang_id
            and t.li_nr = in_li_nr;

    begin
        v_err_nr := null;
        v_err_text := null;
        lvs_ohne_transp_lte_pruefen(in_lte_id);
        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_order_fehlt);
            raise v_error;
        end if;

        if v_order_kopf.status = 'E' then
            v_err_nr := 20;
            v_err_text := lc.ec(lc.o_txt_order_auft_zu);
            raise v_error;
        end if;

        v_trans_typ := null;
        if in_vorgang_typ like ( 'WE%' ) then
            v_trans_typ := 'E';
        elsif in_vorgang_typ like ( 'WA%' ) then
            v_trans_typ := 'A';
        elsif in_vorgang_typ like ( 'WU%' ) then
            v_trans_typ := 'U';
        end if;

        v_transport_gruppe := 0;
        v_ret_val := lvs_transport.lvs_transp_lte(in_sid,                 -- in_sid                  in  isi_sid.sid%type,
         in_firma_nr,            -- in_firma_nr             in  isi_firma.firma_nr%type,
         c.lgr_modul_sls,        -- in_modul_erzeuger       in  isi_transport.modul_erzeuger%type,
         c.lgr_modul_sls,        -- in_modul_bearbeiter     in  isi_transport.modul_bearbeiter%type,
         c.c_false,              -- in_frei_fahren          in  varchar2,
                                                  v_trans_typ,            -- in_trans_typ            in varchar2,
                                                   in_user_id,             -- in_user_id              in  isi_user.login_id%type,
                                                   null,                   -- in_auftrag_id           in  isi_transport.auf_id%type,
                                                   null,                   -- in_auftrag_id_extern    in  isi_transport.auf_id_extern%type,
                                                   0,                      -- in_prio                 in  isi_transport.prio%type,
                                                  null,                   -- in_progr_nr             in  isi_transport.progr_nr%type,
                                                   null,                   -- in_quelle_leer_progr_nr in  isi_transport.quelle_leer_progr_nr%type,
                                                   null,                   -- in_ziel_voll_progr_nr   in  isi_transport.ziel_voll_progr_nr%type,
                                                   null,                   -- in_lgr_quell_lgr_platz  in  lvs_lte.lgr_platz%type,
                                                   v_order_kopf.ziel,      -- in_lgr_ziel_lgr_platz   in  lvs_lte.lgr_platz%type,
                                                  in_lte_id,              -- in_lte_id               in  lvs_lte.lte_id%type,
                                                   v_order_kopf.adress_id, -- in_kunde_nr             in  lvs_lam.kunden_nr%type,  -- hier adress_id
                                                   c.c_true,               -- in_lieferschein         in  isi_transport.lieferschein%type,
                                                   v_order_kopf.li_nr,     -- in_li_nr                in  isi_transport.li_nr%type,
                                                   null,                   -- in_li_pos_nr            in  isi_transport.li_pos_nr%type,
                                                  in_vorgang_id,          -- in_vorgang_id           in  isi_transport.vorgang_id
                                                   null,                   -- in_fahrzeuge_IDs Hier wird bereits Transportiert, da muss nicht geprüft werden ob das fahrzeug OK ist
                                                   v_order_kopf.lkw_nr, v_transport_gruppe, out_transp_id);         -- out_transp_id           out isi_transport.transp_id%type)

  -- After successfully started the neu task, it is needed
  -- to set transport status for this task.
        v_ret_val := lvs_transport.lvs_transp_transport(in_sid,               -- in_sid             in     isi_sid.sid%type,
         in_firma_nr,          -- in_firma_nr        in     isi_firma.firma_nr%type,
         in_user_id,           -- in_ls_login_id     in     isi_user.login_id%type,
         out_transp_id,        -- in_transport_id    in     isi_transport.transp_id%type,
         in_lte_id,            -- in_lte_id          in     lvs_lte.lte_id%type,
                                                        in_res_id,            -- in_res_id          in     isi_resource.res_id%type,
                                                         v_lam_bh_vorgang_id); -- in_out_lam_bh_vorg in out isi_transport.lam_bh_vorgang_id%type)
        commit;
    exception
  -- Im Fehlerfall ist der Fehler bereits gesetzt.
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

    end lvs_c_ohne_transp_lte;

--------------------------------------------------------------------------------
-- procedure LVS_C_OHNE_TRANSP_TOR
-- LTE - Schnellverladung - TOR
--------------------------------------------------------------------------------
    procedure lvs_c_ohne_transp_tor (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_vorgang_id  in isi_order_kopf.vorgang_id%type,
        in_li_nr       in isi_order_kopf.li_nr%type,
        in_res_id      in isi_resource.res_id%type,
        in_user_id     in isi_user.login_id%type,
        in_lte_id      in lvs_lte.lte_id%type,
        in_transp_id   in isi_transport.transp_id%type
    ) is

        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(2550);
        v_ret_val    number;
        v_found      boolean;
        v_order_kopf isi_order_kopf%rowtype;
        cursor c_order_kopf is
        select
            t.*
        from
            isi_order_kopf t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.vorgang_typ = in_vorgang_typ
            and t.vorgang_id = in_vorgang_id
            and t.li_nr = in_li_nr;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_order_fehlt);
            raise v_error;
        end if;

        if v_order_kopf.status = 'E' then
            v_err_nr := 20;
            v_err_text := lc.ec(lc.o_txt_order_auft_zu);
            raise v_error;
        end if;

  -- We can close our Task. Our "LTE" arrived the target.
        v_ret_val := lvs_transport.lvs_transp_fertig(in_sid,            -- in_sid          in isi_sid.sid%type,
         in_firma_nr,       -- in_firma_nr     in isi_firma.firma_nr%type,
         in_user_id,        -- in_user_id      in isi_user.login_id%type,
         in_transp_id,      -- in_transport_id in isi_transport.transp_id%type,
         in_lte_id,         -- in_lte_id       in lvs_lte.lte_id%type,
                                                     in_res_id,         -- in_res_id       in isi_resource.res_id%type,
                                                      v_order_kopf.ziel, -- in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                                      c.c_false);         -- in_ausgelagert  in varchar2)
        commit;
    exception
  -- Im Fehlerfall ist der Fehler bereits gesetzt,
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

    end lvs_c_ohne_transp_tor;

--------------------------------------------------------------------------------
-- procedure LVS_C_OHNE_TRANSP_ABSCHLUSS
-- Schnellverladung - Schliessen
-- Auftrag schliessen
-- Wenn in_set_status = 'T' -> status aendern und ohne_transp_anz unten zaehlen
-- Wenn in_set_status = 'F' -> status nicht aendern, nur ohne_transp_anz unten
--                             zaehlen
--------------------------------------------------------------------------------
    procedure lvs_c_ohne_transp_abschluss (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_vorgang_id  in isi_order_kopf.vorgang_id%type,
        in_li_nr       in isi_order_kopf.li_nr%type,
        in_res_id      in isi_resource.res_id%type,
        in_set_status  in varchar2
    ) is

        v_error exception;
        v_err_nr       number;
        v_err_text     varchar2(2550);
        v_found        boolean;
        v_status       isi_order_kopf.status%type;
        v_fertig_datum isi_order_kopf.fertig_datum%type;
        v_order_kopf   isi_order_kopf%rowtype;
        v_transport    isi_transport%rowtype;
        cursor c_order_kopf is
        select
            t.*
        from
            isi_order_kopf t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.vorgang_typ = in_vorgang_typ
            and t.vorgang_id = in_vorgang_id
            and t.li_nr = in_li_nr;

        cursor c_transport is
        select
            t.*
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.li_nr = in_li_nr
            and t.modul_erzeuger = c.lgr_modul_sls
            and t.modul_bearbeiter = c.lgr_modul_sls
            and t.res_id = in_res_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_order_fehlt);
            raise v_error;
        end if;

        if in_set_status = c.c_true then
            if v_order_kopf.status = 'E' then
                v_err_nr := 20;
                v_err_text := lc.ec(lc.o_txt_order_auft_zu);
                raise v_error;
            end if;

            open c_transport;
            fetch c_transport into v_transport;
            v_found := c_transport%found;
            close c_transport;
            if v_found then
                v_err_nr := 30;
                v_err_text := lc.ec(lc.o_txt_order_m_trans_n_close);
                raise v_error;
            else
                if nvl(v_order_kopf.ohne_transp_anz, 1) = 1 then
                    v_status := 'E';
                    v_fertig_datum := sysdate;
                else
                    v_status := v_order_kopf.status;
                    v_fertig_datum := v_order_kopf.fertig_datum;
                end if;

                update isi_order_kopf t
                set
                    t.ohne_transp_anz = nvl(t.ohne_transp_anz, 1) - 1,
                    t.status = v_status,
                    t.fertig_datum = v_fertig_datum
                where
                        t.sid = in_sid
                    and t.firma_nr = in_firma_nr
                    and t.vorgang_typ = in_vorgang_typ
                    and t.vorgang_id = in_vorgang_id
                    and t.li_nr = in_li_nr;

                if sql%rowcount <> 1 then
                    v_err_nr := 40;
                    v_err_text := lc.ec(lc.o_txt_order_auft_no_update);
                    raise v_error;
                end if;

            end if;

        else
            update isi_order_kopf t
            set
                t.ohne_transp_anz = nvl(t.ohne_transp_anz, 1) - 1
            where
                    t.sid = in_sid
                and t.firma_nr = in_firma_nr
                and t.vorgang_typ = in_vorgang_typ
                and t.vorgang_id = in_vorgang_id
                and t.li_nr = in_li_nr;

            if sql%rowcount <> 1 then
                v_err_nr := 50;
                v_err_text := lc.ec(lc.o_txt_order_auft_no_update);
                raise v_error;
            end if;

        end if;

        commit;
    exception
  -- Im Fehlerfall ist der Fehler bereits gesetzt,
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

    end lvs_c_ohne_transp_abschluss;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function prüft, ob alle Parameter eine Auslagerung jetzt erlauben
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    function lvs_pruefe_umla_ausl (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_umla_nr  in isi_order_kopf.vorgang_id%type
    ) return number is

        result       number;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(2550);
        v_found      boolean;                        -- Daten im CURSOR gefunden?
        v_order_kopf isi_order_kopf%rowtype;         -- Auftragskopfdaten aus ISI-Order
        v_pos_wae    number;                         -- Anzahl Positionen ohne WA

        cursor c_order_kopf is
        select
            *
        from
            isi_order_kopf k
        where
                k.sid = in_sid
            and k.satzart = 'LU'
            and k.vorgang_typ = 'WUE'
            and k.vorgang_id = in_umla_nr;

        cursor c_pos is
        select
            count(pos.pos_nr)
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.satzart = 'LU'
            and pos.vorgang_id = in_umla_nr
            and pos.vorgang_typ = 'WUE'
            and pos.ziel is null
        group by
            pos.vorgang_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_order_kopf;
        loop
            fetch c_order_kopf into v_order_kopf;
            v_found := c_order_kopf%found;
            if v_found then
                if nvl(v_order_kopf.freigabe_datum, sysdate) > sysdate then
                    v_err_nr := 10;
                    v_err_text := lc.ec_p2(lc.o_tp2_order_uml_freidatum_err,
                                           in_umla_nr,
                                           to_char(v_order_kopf.freigabe_datum, 'dd.mm.yyyy hh24:mi'));

                    raise v_error;
                end if;

                if v_order_kopf.ziel is null then    -- Wenn im Kopf kein WA angegeben, dann muessen alle Position Eintraege haben
                    open c_pos;
                    fetch c_pos into v_pos_wae;
                    v_found := c_pos%found;
                    close c_pos;
                    if v_found then
                        v_err_nr := 30;
                        v_err_text := lc.ec_p1(lc.o_tp1_order_uml_pos_wa_fehlt, in_umla_nr);
                        close c_order_kopf;
                        raise v_error;
                    end if;

                end if;

                update isi_order_pos pos
                set
                    pos.ziel = v_order_kopf.ziel,
                    pos.arbeitsplatz_id = v_order_kopf.arbeitsplatz_id
                where
                        pos.sid = in_sid
                    and pos.firma_nr = in_firma_nr
                    and pos.satzart = 'LU'
                    and pos.vorgang_typ = 'WUE'
                    and pos.vorgang_id = in_umla_nr
                    and pos.li_nr = v_order_kopf.li_nr;

            else
                exit;
            end if;

        end loop;

        close c_order_kopf;
        return ( result );
    exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then  -- Update 2011 show Exception Source Line
            if c_order_kopf%isopen then
                close c_order_kopf;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if c_order_kopf%isopen then
                close c_order_kopf;
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

    end lvs_pruefe_umla_ausl;

    procedure lvs_liefers_erzeuge_daten (
        in_isi_transport in isi_transport%rowtype,
        in_lam           in lvs_lam%rowtype,
        in_order_pos     in isi_order_pos%rowtype,
        in_lam_bh_id     in lvs_lam_bh.lam_bh_id%type,
        in_lte           in lvs_lte%rowtype,
        in_v_lhm         in isi_liefs.v_lhm_id%type
    ) is

        v_err_nr          integer;
        v_err_text        varchar2(2550);
        v_error exception;
        v_found           boolean;
        v_vorgang_id      isi_liefs.vorgang_id%type;
        v_vorgang_pos     isi_liefs.vorgang_pos%type;
        v_vorgang_typ     isi_liefs.vorgang_typ%type;
        v_be_nr           isi_liefs.be_nr%type;
        v_kunden_nr       isi_liefs.adress_nr%type;
        v_adress_id       isi_liefs.adress_id%type;
        v_order_adress_id isi_liefs.order_adress_id%type;
        v_pos_nr          isi_liefs.pos_nr%type;
        v_upos_nr         isi_liefs.upos_nr%type;
        v_auftrag         isi_liefs.auftrag%type;
        v_login_id        isi_liefs.login_id%type;
        v_order_kopf      isi_order_kopf%rowtype;
        v_li_nr           isi_transport.li_nr%type;
        v_li_pos_nr       isi_transport.li_pos_nr%type;
        cursor c_order_kopf is
        select
            order_kopf.*
        from
            isi_order_kopf order_kopf
        where
                order_kopf.sid = in_lam.sid
            and order_kopf.firma_nr = in_lam.firma_nr
            and order_kopf.vorgang_typ = nvl(in_order_pos.vorgang_typ, order_kopf.vorgang_typ)
            and order_kopf.vorgang_id = nvl(in_order_pos.vorgang_id, in_isi_transport.vorgang_id);

        cursor c_liefs_max_pos is
        select
            max(li_pos_nr)
        from
            isi_liefs
        where
                sid = in_isi_transport.sid
            and firma_nr = in_isi_transport.firma_nr
            and li_nr = in_isi_transport.li_nr;

    begin
        v_err_nr := null;
        v_err_text := null;
        if in_order_pos.sid is not null then
            v_vorgang_id := in_order_pos.vorgang_id;
            v_vorgang_pos := in_order_pos.vorgang_pos;
            v_vorgang_typ := in_order_pos.vorgang_typ;
            v_pos_nr := in_order_pos.pos_nr;
            v_upos_nr := in_order_pos.upos_nr;
            v_auftrag := in_order_pos.auftrag;
            v_login_id := in_order_pos.login_id;
            open c_order_kopf;
            fetch c_order_kopf into v_order_kopf;
            v_found := c_order_kopf%found;
            close c_order_kopf;
            if v_found then
                v_be_nr := v_order_kopf.be_nr;
                v_adress_id := v_order_kopf.adress_id;
                v_order_adress_id := v_order_kopf.order_adress_id;
                v_kunden_nr := in_isi_transport.kunden_nr;
            else
                v_be_nr := null;
                v_adress_id := in_isi_transport.kunden_nr;
                v_order_adress_id := null;
                v_kunden_nr := null;
            end if;

        else
            v_order_kopf := null;
            open c_order_kopf;
            fetch c_order_kopf into v_order_kopf;
            v_found := c_order_kopf%found;
            close c_order_kopf;
            v_vorgang_id := in_isi_transport.vorgang_id;
            v_vorgang_pos := null;
            v_vorgang_typ := nvl(v_order_kopf.vorgang_typ, 'WAE');
            v_pos_nr := null;
            v_upos_nr := null;
            v_auftrag := null;
            v_login_id := in_isi_transport.transp_id;
            v_be_nr := v_order_kopf.be_nr;
            v_kunden_nr := in_isi_transport.kunden_nr;
            v_adress_id := v_order_kopf.adress_id;
            v_order_adress_id := v_order_kopf.order_adress_id;
        end if;

        v_li_nr := nvl(in_isi_transport.li_nr, 0);
        if in_isi_transport.li_pos_nr is not null then
            v_li_pos_nr := in_isi_transport.li_pos_nr;
 -- 20190918, DTs, E20DB-32
        elsif in_order_pos.li_pos_nr is not null then
            v_li_pos_nr := in_order_pos.li_pos_nr;
------------------------------------------------
        else
            open c_liefs_max_pos;
            fetch c_liefs_max_pos into v_li_pos_nr;
            close c_liefs_max_pos;
            v_li_pos_nr := nvl(v_li_pos_nr, 0) + 10;
        end if;

        begin
            insert into isi_liefs values ( in_lam.sid, -- sid              varchar2(2) not NULL,
                                           in_lam.firma_nr, -- firma_nr         number(2) not NULL,
                                           v_vorgang_typ, -- vorgang_typ      varchar2(3) default 'WAE' not NULL,
                                           v_vorgang_id, -- vorgang_id       number not NULL,
                                           v_vorgang_pos, -- vorgang_pos      number not NULL,
                                           v_kunden_nr, -- adress_nr        number not NULL,
                                           v_adress_id, -- adress_id        number,
                                           v_order_adress_id, -- order_adress_id  number,
                                           v_li_nr, -- li_nr            number(10) not NULL,
                                           v_li_pos_nr, -- li_pos_nr        number(10) not NULL,
                                           v_auftrag, -- auftrag          number(10),
                                           v_pos_nr, -- pos_nr           number(10),
                                           v_upos_nr, -- upos_nr          number(10),
                                           in_lam_bh_id, -- lam_bh_id        number not NULL,
                                           in_lam.lam_id, -- lam_id           number not NULL,
                                           in_isi_transport.lte_id, -- lte_id           varchar2(19),
                                           in_lam.lhm_id, -- lhm_id           varchar2(19),
                                           in_lam.artikel_id, -- artikel_id       number,
                                           v_login_id, -- login_id         number,
                                           in_lam.charge_id, -- charge_id        number,
                                           in_lam.serie_id, -- serie_id         number,
                                           in_lam.menge, -- menge            number,
                                           sysdate, -- liefs_datum      date,
                                           in_lam.res_id, -- res_id           number,
                                           null, -- uebergabe_temp   number,
                                           null, -- fahrzeug_ankunft date,
                                           null, -- fahrzeug_abfahrt date,
                                           null, -- fahrzeug_kennz   varchar2(20),
                                           null, -- TRANSPORTEUR     VARCHAR2(30)
                                           v_be_nr, -- be_nr            number
                                           in_lte.lte_name, -- LTE_NAME            VARCHAR2(10) not null,
                                           in_lam.menge_basis, -- MENGE_BASIS         VARCHAR2(3) not null,
                                           in_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) not null,
                                           in_lam.lam_mhd, -- LAM_MHD             DATE
                                           in_v_lhm, -- v_lhm_id            varchar2(19)
                                           null, -- INAKTIV_GRUND       NUMBER
                                           null,  -- LOGIN_ID_VERANTWORTUNG NUMBER LOGIN ID des Erzeugers des Lieferscheins (Druck des Lieferscheinpapiers)
                                           in_isi_transport.info_text, -- INFO_TEXT Varchar(40)aus dem Transport
                                           'N', -- AVIS_STATUS VARCHAR2(2) Status: N=Neu, U=Übertragung läuft, UE= Übertragen
                                           null, -- Temperatur aus Scirpt gelesen aus Anlage
                                           null ); -- Zollplombe
        exception
            when others then
                null;
        end;

    exception
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
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
    end lvs_liefers_erzeuge_daten;

end lvs_ausl;
/


-- sqlcl_snapshot {"hash":"ea67f2aea51d15d649bd46478e5b3f6890004ee7","type":"PACKAGE_BODY","name":"LVS_AUSL","schemaName":"DIRKSPZM32","sxml":""}