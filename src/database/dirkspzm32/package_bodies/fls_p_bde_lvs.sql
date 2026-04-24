create or replace package body dirkspzm32.fls_p_bde_lvs is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(2550);
  -------------------------------------------------------------------------------------------------------

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
    end;

  -- In dieser Funktion wird eine Palette angelegt und Produktion gebucht.
  -- Die Palette hat dann noch keien Lagerplatz
    procedure c_bde_prod_lte_o_platz (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_lte_barcode  in lvs_lte.lte_id%type,
        in_lhm_barcode  in lvs_lhm.lhm_id%type,
        in_res_id       in isi_resource.res_id%type,
        in_login_id     in isi_user.login_id%type,
        in_menge_a      in lvs_lam.menge%type,
        in_menge_b      in lvs_lam.menge%type,
        in_schrott      in lvs_lam.menge%type,
        in_abfuell_ist  in bde_pd_prod.abfuell_ist%type,
        in_abfuell_tara in bde_pd_prod.abfuell_tara%type,
        out_leitzahl    out bde_fa_auftrag.leitzahl%type,
        out_fa_ag       out bde_fa_auftrag.fa_ag%type,
        out_fa_upos     out bde_fa_auftrag.fa_upos%type
    ) is

        v_artikel     isi_artikel%rowtype;
        v_charge_bez  varchar2(100);
        v_prod_datum  date;
        v_menge       number;
        v_ean         varchar2(100);
        v_lfd_nr_str  varchar2(100);
        v_linie_str   varchar2(20);
        v_res         isi_resource%rowtype;
        v_res_akt     isi_resource_zust_akt%rowtype;
        v_charge      lvs_charge%rowtype;
        v_fa_auftrag  bde_fa_auftrag%rowtype;
        v_lte         lvs_lte%rowtype;
        v_firma       isi_firma%rowtype;
        v_barcode     lvs_lte.lte_id%type;
        v_barcode_lte lvs_lte.lte_id%type;
        v_leitzahl    bde_fa_auftrag.leitzahl%type;
        v_fa_ag       bde_fa_auftrag.fa_ag%type;
        v_fa_upos     bde_fa_auftrag.fa_upos%type;
        v_found       boolean;
        pe_job_nr     integer;
        cursor c_res is
        select
            *
        from
            isi_resource t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.res_id = in_res_id;

        cursor c_res_akt is
        select
            *
        from
            isi_resource_zust_akt t
        where
            t.res_id = in_res_id;

        cursor c_fa_auftrag is
        select
            t.*
        from
            bde_fa_auftrag t
        where
                t.leitzahl = v_res_akt.leitzahl
            and t.fa_ag = v_res_akt.fa_ag
            and t.fa_upos = v_res_akt.fa_upos;

        cursor c_lte is
        select
            *
        from
            lvs_lte t
        where
            t.lte_id = in_lte_barcode;

        cursor c_charge is
        select
            t.*
        from
            lvs_charge t
        where
            t.charge_id = v_fa_auftrag.charge_id;

    begin
        if isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_LTE_ERZ',            -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'BDE_LTE_LGR_PLATZ_MUSS', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                          'BDE_DB',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                           'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                           'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                           'BOOLEAN') = c.c_true     -- in_default_param_typ
                                           then
            raise_isi_error(10,
                            lc.ec(lc.o_txt_lte_err_ohne_lgr_platz));
        end if;

        v_lte := null;
        open c_lte;
        fetch c_lte into v_lte;
        v_found := c_lte%found;
        close c_lte;
        if
            v_found
            and v_lte.lgr_platz is not null
        then
            raise_isi_error(10,
                            lc.ec(lc.o_txt_lte_id_schon_vorhanden));
        end if;

        v_res := null;
        open c_res;
        fetch c_res into v_res;
        v_found := c_res%found;
        close c_res;
        if not v_found then
            raise_isi_error(20,
                            lc.ec_p1(lc.o_tp1_resource_fehlt,
                                     to_char(in_res_id)));
        end if;

        if
            v_lte.lte_id is not null
            and ( v_res.kategorie != 'WA'
            or v_res.kategorie_typ != 3 )
        then
            raise_isi_error(10,
                            lc.ec(lc.o_txt_lte_id_schon_vorhanden));
        end if;

        v_res_akt := null;
        open c_res_akt;
        fetch c_res_akt into v_res_akt;
        v_found := c_res_akt%found;
        close c_res_akt;
        if not v_found then
            raise_isi_error(30,
                            lc.ec_p1(lc.o_tp1_resourcenzustand_fehlt, v_res.res_name));
        end if;

        v_fa_auftrag := null;
        open c_fa_auftrag;
        fetch c_fa_auftrag into v_fa_auftrag;
        v_found := c_fa_auftrag%found;
        close c_fa_auftrag;
        if not v_found then
            raise_isi_error(30,
                            lc.ec_p3(lc.o_tp3_fa_auftrg_fehlt,
                                     to_char(v_res_akt.leitzahl),
                                     to_char(v_res_akt.fa_ag),
                                     to_char(v_res_akt.fa_upos)));
        end if;

        v_barcode := in_lte_barcode;
        open c_charge;
        fetch c_charge into v_charge;
        close c_charge;
        if v_barcode is not null then
            if isi_allg.get_firma(in_sid, in_firma_nr, v_firma) then
                if v_firma.lte_barcode_type = 'SPEZ' then
                    lvs_p_lte_lhm.spez_barcode_result(v_firma.sid,             -- in in_sid
                     v_firma.firma_nr,        -- in in_firma_nr
                     v_barcode, v_firma.lte_barcode_kopf,         -- in_format     in varchar2,
                     v_artikel,                   -- out_artikel
                                                      v_charge_bez,                -- out varchar2,
                                                       v_prod_datum,                -- out date,
                                                       v_menge,                     -- out number,
                                                       v_ean,                       -- out varchar2
                                                       v_lfd_nr_str,            -- out varchar2
                                                      v_linie_str);            -- out varchar2
                    if nvl(v_artikel.artikel_id, v_fa_auftrag.ag_artikel_id) != v_fa_auftrag.ag_artikel_id
                    or nvl(v_charge_bez, v_charge.charge_bez) != v_charge.charge_bez then
                        raise_isi_error(30,
                                        lc.ec_p4(lc.o_tp4_art_charge_im_fa_falsch,
                                                 to_char(v_res_akt.leitzahl),
                                                 to_char(v_res_akt.fa_ag),
                                                 to_char(v_res_akt.fa_upos),
                                                 v_barcode));

                    end if;

                end if;

            end if;
        end if;

        if v_lte.lte_id is null then
            v_barcode := lvs_p_lte.lvs_lte_insert_v358(v_res_akt.sid,            -- SID der Maschine
                                                       v_res_akt.firma_nr,       -- Firma der Maschine
                                                       v_fa_auftrag.lte_name,    -- Palettemtype Bsp. 'EURO'
                                                       v_barcode,                -- ID der Transporteinheit
                                                       in_login_id,              -- Login ID aktuelle User
                                                       null,                     -- Kein Lager
                                                       null,                     -- Fertigwarenlager der Maschine
                                                       'PF',                     -- Status ist auf befüllen gesetzt
                                                       null,
                                                       null,
                                                       v_charge.charge_id,
                                                       v_charge.charge_bez,
                                                       v_fa_auftrag.ag_artikel_id,
                                                       nvl(v_fa_auftrag.packschema_kopf_id, v_artikel.packschema_kopf_id),
                                                       null,                    -- Auto Depal ist unbekannt
                                                       null,                    -- wickelprogramm ist unbekannt,
                                                       null);                   -- wickelprogramm_einl ist unbekannt
        end if;

        update isi_resource_zust_akt t
        set
            t.lte_id = v_barcode,                  -- Ergebnis im aktuelle Maschienenzustan SPEICHERN
            t.abfuell_ist = in_abfuell_ist,        -- Abfuell ist eintragen
            t.abfuell_tara = in_abfuell_tara
        where
                sid = v_res.sid
            and res_id = v_res.res_id;

        v_barcode_lte := v_barcode;
        if isi_allg.get_firma_cfg_param(v_res.sid, v_res.firma_nr, 'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'ET_LTE_ID_ON_ID_LHM',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                         'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                         'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                         'BOOLEAN') = c.c_true     -- in_default_param_typ
                                         then
            v_barcode := null;
        else
            v_barcode := in_lhm_barcode;
        end if;

        v_barcode := bde_c_barcode_buch(v_res_akt.sid,            -- SID der Maschine

         v_res_akt.firma_nr,       -- Firma der Maschine

         v_barcode,                -- in_barcode => :barcode,

         v_res.res_id,             -- in_res_id => :res_id,

         in_login_id,              -- in_ls_login_id => :login_id,
                                        in_menge_a,               -- in_menge_a => :menge_a,
                                         in_menge_b,               -- in_menge_b => :menge_b,
                                         in_schrott,               -- in_schrott => :schrott,
                                         'ZUGANG',                 -- in_aufgabe => 'ZUGANG',
                                         v_barcode,                -- in_fae_id
                                        null,                     -- in_fae_id_pos
                                         v_leitzahl,               -- out_leitzahl => :leitzahl,
                                         v_fa_ag,                  -- out_fa_ag => :fa_ag,
                                         v_fa_upos);               -- out_fa_upos => :fa_upos);
        if v_res.drucker is not null then
            update isi_resource_zust_akt t
            set
                t.lte_id = null
            where
                    sid = v_res.sid
                and res_id = v_res.res_id;

            pe_job_nr := lvs_p_lte.lvs_c_lte_drucken(v_barcode_lte,
                                                     to_char(v_fa_auftrag.kunden_nr),
                                                     v_res.drucker);

            pe_job_nr := lvs_p_lte.lvs_c_lte_drucken(v_barcode_lte,
                                                     to_char(v_fa_auftrag.kunden_nr),
                                                     v_res.drucker);

        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt
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

    procedure c_bde_prod_lhm_o_platz (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_lte_barcode  in lvs_lte.lte_id%type,
        in_lhm_barcode  in lvs_lhm.lhm_id%type,
        in_res_id       in isi_resource.res_id%type,
        in_login_id     in isi_user.login_id%type,
        in_menge_a      in lvs_lam.menge%type,
        in_menge_b      in lvs_lam.menge%type,
        in_schrott      in lvs_lam.menge%type,
        in_abfuell_ist  in bde_pd_prod.abfuell_ist%type,
        in_abfuell_tara in bde_pd_prod.abfuell_tara%type,
        out_leitzahl    out bde_fa_auftrag.leitzahl%type,
        out_fa_ag       out bde_fa_auftrag.fa_ag%type,
        out_fa_upos     out bde_fa_auftrag.fa_upos%type
    ) is

        v_artikel     isi_artikel%rowtype;
        v_charge_bez  varchar2(100);
        v_prod_datum  date;
        v_menge       number;
        v_ean         varchar2(100);
        v_lfd_nr_str  varchar2(100);
        v_linie_str   varchar2(20);
        v_res         isi_resource%rowtype;
        v_res_akt     isi_resource_zust_akt%rowtype;
        v_charge      lvs_charge%rowtype;
        v_fa_auftrag  bde_fa_auftrag%rowtype;
        v_lte         lvs_lte%rowtype;
        v_firma       isi_firma%rowtype;
        v_drucker     pe_drucker_cfg%rowtype;
        v_bestand     number;
        v_barcode     lvs_lte.lte_id%type;
        v_lte_barcode lvs_lte.lte_id%type;
        v_leitzahl    bde_fa_auftrag.leitzahl%type;
        v_fa_ag       bde_fa_auftrag.fa_ag%type;
        v_fa_upos     bde_fa_auftrag.fa_upos%type;
        pe_job_nr     integer;
        v_found       boolean;
        cursor c_res is
        select
            *
        from
            isi_resource t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.res_id = in_res_id;

        cursor c_fa_auftrag is
        select
            t.*
        from
            bde_fa_auftrag t
        where
                t.leitzahl = v_res_akt.leitzahl
            and t.fa_ag = v_res_akt.fa_ag
            and t.fa_upos = v_res_akt.fa_upos;

        cursor c_lte is
        select
            *
        from
            lvs_lte t
        where
            t.lte_id = v_lte_barcode;

        cursor c_charge is
        select
            t.*
        from
            lvs_charge t
        where
            t.charge_id = v_fa_auftrag.charge_id;

        cursor c_res_roboter is
        select
            t2.*
        from
            isi_resource t,
            isi_resource t2
        where
                t.res_id = in_res_id
            and t2.linie_res_id = t.linie_res_id
            and t2.kategorie = 'RO';

    begin
        if isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_LTE_ERZ',            -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'BDE_LTE_LGR_PLATZ_MUSS', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                          'BDE_DB',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                           'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                           'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                           'BOOLEAN') = c.c_true     -- in_default_param_typ
                                           then
            raise_isi_error(10,
                            lc.ec(lc.o_txt_lte_err_ohne_lgr_platz));
        end if;

        v_found := isi_p_base.get_res_zust_akt(in_sid, in_res_id, v_res_akt);
        if not v_found then
            raise_isi_error(30,
                            lc.ec_p1(lc.o_tp1_resourcenzustand_fehlt, v_res.res_name));
        end if;

        if in_lte_barcode is null then
            v_lte_barcode := v_res_akt.lte_id;
        else
            v_lte_barcode := in_lte_barcode;
        end if;

        v_lte := null;
        open c_lte;
        fetch c_lte into v_lte;
        v_found := c_lte%found;
        close c_lte;
        if v_lte.lgr_platz is not null -- Palette schon gescannt, dann ist jetzt auf jedem fall die nächste drann
         then
            v_lte := null;
            v_res_akt.lte_id := null;
            v_lte_barcode := null;
        end if;

        v_res := null;
        open c_res;
        fetch c_res into v_res;
        v_found := c_res%found;
        close c_res;
        if not v_found then
            raise_isi_error(20,
                            lc.ec_p1(lc.o_tp1_resource_fehlt,
                                     to_char(in_res_id)));
        end if;

        v_fa_auftrag := null;
        open c_fa_auftrag;
        fetch c_fa_auftrag into v_fa_auftrag;
        v_found := c_fa_auftrag%found;
        close c_fa_auftrag;
        if not v_found then
            raise_isi_error(30,
                            lc.ec_p3(lc.o_tp3_fa_auftrg_fehlt,
                                     to_char(v_res_akt.leitzahl),
                                     to_char(v_res_akt.fa_ag),
                                     to_char(v_res_akt.fa_upos)));
        end if;

    -- Palette ist voll und es wurde keine Palettenid mitgegeben
        if
            v_fa_auftrag.lte_lhm_lagen * v_fa_auftrag.lte_lhm_pro_lage <= v_lte.lte_akt_lhm
            and in_lte_barcode is null
            and ( v_res.kategorie != 'WA'  -- Waggen mit Kategorietyp 3 nicht die LTE-ID wechseln
            or (
                v_res.kategorie = 'WA'
                and v_res.kategorie_typ = '1'
            ) ) -- Keine Kontrollwaage dan init an Drucker für Absackung
        then
            v_lte_barcode := null;
            v_lte := null;
        end if;

        open c_charge;
        fetch c_charge into v_charge;
        close c_charge;
        if v_lte_barcode is not null then
            if isi_allg.get_firma(in_sid, in_firma_nr, v_firma) then
                if v_firma.lte_barcode_type = 'SPEZ' then
                    lvs_p_lte_lhm.spez_barcode_result(v_firma.sid,             -- in in_sid
                     v_firma.firma_nr,        -- in in_firma_nr
                     v_lte_barcode, v_firma.lte_barcode_kopf,         -- in_format     in varchar2,
                     v_artikel,                   -- out_artikel
                                                      v_charge_bez,                -- out varchar2,
                                                       v_prod_datum,                -- out date,
                                                       v_menge,                     -- out number,
                                                       v_ean,                       -- out varchar2
                                                       v_lfd_nr_str,            -- out varchar2
                                                      v_linie_str);            -- out varchar2
                    if nvl(v_artikel.artikel_id, v_fa_auftrag.ag_artikel_id) != v_fa_auftrag.ag_artikel_id
          -- Charge aus dem Barcode ist evtl mit 0 aufgefüllt
          --or nvl(v_charge_bez, v_charge.charge_bez) != v_charge.charge_bez
                     then
                        if in_lte_barcode is not null then
                            raise_isi_error(30,
                                            lc.ec_p4(lc.o_tp4_art_charge_im_fa_falsch,
                                                     to_char(v_res_akt.leitzahl),
                                                     to_char(v_res_akt.fa_ag),
                                                     to_char(v_res_akt.fa_upos),
                                                     v_barcode));

                        else
                            v_lte_barcode := null;
                            v_lte := null;
                            if v_res.drucker is not null then
                                pe_job_nr := lvs_p_lte.lvs_c_lte_drucken(v_barcode,
                                                                         to_char(v_fa_auftrag.kunden_nr),
                                                                         v_res.drucker);
                            end if;

                        end if;

                    end if;

                end if;

            end if;
        end if;

        if v_lte.lte_id is null then
            if
                v_res.kategorie = 'WA'    -- Kontrollwaage?
                and v_res.kategorie_typ = '3' -- Kontrollwaage dan init an Drucker für Absackung
            then
                if isi_allg.get_firma(in_sid, in_firma_nr, v_firma) then
                    if v_firma.lte_barcode_type = 'SPEZ' -- Dann noch spez_barcode a la Sasol
                     then
                        v_barcode := lvs_p_lte.format_barcode(in_sid, v_firma.lte_barcode_kopf, 0, v_firma.lte_barcode_laenge, null,
                                                              v_charge.charge_bez, v_fa_auftrag.ag_artikel_id, null, 0, '0000000000',
                                                              '000');

                    end if;

                end if;
            end if;

            v_barcode := lvs_p_lte.lvs_lte_insert_v358(v_res_akt.sid,            -- SID der Maschine
                                                       v_res_akt.firma_nr,       -- Firma der Maschine
                                                       v_fa_auftrag.lte_name,    -- Palettemtype Bsp. 'EURO'
                                                       v_barcode,                -- ID der Transporteinheit
                                                       in_login_id,              -- Login ID aktuelle User
                                                       null,                     -- Kein Lager
                                                       null,                     -- Fertigwarenlager der Maschine
                                                       'PF',                     -- Status ist auf befüllen gesetzt
                                                       null,
                                                       null,
                                                       v_charge.charge_id,
                                                       v_charge.charge_bez,
                                                       v_fa_auftrag.ag_artikel_id,
                                                       nvl(v_fa_auftrag.packschema_kopf_id, v_artikel.packschema_kopf_id),
                                                       null,                    -- Auto Depal ist unbekannt
                                                       null,                    -- wickelprogramm ist unbekannt,
                                                       null);                   -- wickelprogramm_einl ist unbekannt
            v_lte_barcode := v_barcode;
            v_lte := null;
            open c_lte;
            fetch c_lte into v_lte;
            v_found := c_lte%found;
            close c_lte;
        end if;

        if isi_allg.get_firma_cfg_param(v_res.sid, v_res.firma_nr, 'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,

         null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,

         'ET_LTE_ID_ON_ID_LHM',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                         'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                         'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                         'BOOLEAN') = c.c_true     -- in_default_param_typ
                                         then
            v_barcode := null;
        else
            v_barcode := in_lhm_barcode;
        end if;

        if v_barcode is null then
            v_barcode := lvs_p_lte.lvs_lte_lhm_next_id_v34(v_res_akt.sid,            -- SID der Maschine
             v_res_akt.firma_nr,       -- Firma der Maschine
             c.basis_lhm, v_charge.charge_bez, v_fa_auftrag.ag_artikel_id);
        end if;

        update isi_resource_zust_akt t
        set
            t.lte_id = v_lte_barcode,              -- Ergebnis im aktuelle Maschienenzustan SPEICHERN
            t.abfuell_ist = in_abfuell_ist,        -- Abfuell ist eintragen
            t.abfuell_tara = in_abfuell_tara
        where
                sid = v_res.sid
            and res_id = v_res.res_id;

        v_bestand := bde_c_barcode_buch(v_res_akt.sid,            -- SID der Maschine

         v_res_akt.firma_nr,       -- Firma der Maschine

         v_barcode,                -- in_barcode => :barcode,

         v_res.res_id,             -- in_res_id => :res_id,

         in_login_id,              -- in_ls_login_id => :login_id,
                                        in_menge_a,               -- in_menge_a => :menge_a,
                                         in_menge_b,               -- in_menge_b => :menge_b,
                                         in_schrott,               -- in_schrott => :schrott,
                                         'ZUGANG',                 -- in_aufgabe => 'ZUGANG',
                                         v_barcode,                -- in_fae_id
                                        null,                     -- in_fae_id_pos
                                         v_leitzahl,               -- out_leitzahl => :leitzahl,
                                         v_fa_ag,                  -- out_fa_ag => :fa_ag,
                                         v_fa_upos);               -- out_fa_upos => :fa_upos);
        v_lte.lte_akt_lhm := v_lte.lte_akt_lhm + 1;
        if v_res.kategorie = 'RO'  -- Roboter hat den Drucker für Gebinde im kategorie_typ
         then
            if v_res.kategorie_typ is not null then
                pe_job_nr := lvs_p_lte.lvs_c_lte_drucken(v_barcode,
                                                         to_char(v_fa_auftrag.kunden_nr),
                                                         v_res.kategorie_typ);
            end if;

            if
                v_res.drucker is not null -- Palettendrucker INIT
      -- -AG- Losgroesse beachten
                and ( v_fa_auftrag.lhm_anz_ist = 0
                or v_fa_auftrag.ag_los_ist_mg = 0
        -- -AG- 04.05.2011 Wenn Charge neu dann auch Daten zum Drucker senden
                or v_charge.charge_lte_lfdn = 0 )
            then
                if print_allg.get_drucker(in_sid, in_firma_nr, v_res.drucker, v_drucker) then
                    pe_job_nr := lvs_p_lte.lvs_c_lte_drucken(v_lte_barcode,
                                                             to_char(v_fa_auftrag.kunden_nr),
                                                             v_res.drucker);

                    if v_drucker.drucker_typ = print_allg.pe_typ_eti then
                        if upper(v_drucker.eti_drucker_typ) like '%LOGOPAK%' then
                            print_engine.insert_new_job(in_sid,
                                                        in_firma_nr,
                                                        null,
                                                        null,
                                                        print_engine.jdt_direkt,
                                                        ' *SETCOUNT,01,'
                                                        || to_char(v_charge.charge_lte_lfdn)
                                                        || '<CR>',
                                                        v_res.drucker,
                                                        1,
                                                        pe_job_nr);

                        end if;

                    end if;

                end if;

            end if;

        else
            if
                v_res.drucker is not null
                and v_res.kategorie_typ != '3'
            then
                pe_job_nr := lvs_p_lte.lvs_c_lte_drucken(v_barcode,
                                                         to_char(v_fa_auftrag.kunden_nr),
                                                         v_res.drucker);

            end if;
        end if;

        if
            ( v_res.kategorie = 'RO'  -- Roboter hat den Drucker für Gebinde im kategorie_typ
            or (
                v_res.kategorie = 'WA'  -- Roboter hat den Drucker für Gebinde im kategorie_typ
                and v_res.kategorie_typ = '1'
            ) ) -- Absackwaage
            and v_res.drucker is not null
            and v_fa_auftrag.lte_lhm_lagen * v_fa_auftrag.lte_lhm_pro_lage <= v_lte.lte_akt_lhm
        then
            update isi_resource_zust_akt t
            set
                t.lte_id = null
            where
                    sid = v_res.sid
                and res_id = v_res.res_id;

            if v_res.kategorie <> 'RO'  -- Roboter darf nur INIT schiken

             then
                pe_job_nr := lvs_p_lte.lvs_c_lte_drucken(v_lte_barcode,
                                                         to_char(v_fa_auftrag.kunden_nr),
                                                         v_res.drucker);

            end if;

        end if;

        if
            v_res.kategorie = 'WA'    -- Kontrollwaage?
            and v_res.kategorie_typ = '3' -- Kontrollwaage dann init an Drucker für Absackung
    -- -AG- Losgroesse beachten
            and ( v_fa_auftrag.lhm_anz_ist = 0
            or v_fa_auftrag.ag_los_ist_mg = 0 )
        then
            open c_res_roboter;
            fetch c_res_roboter into v_res;
            v_found := c_res_roboter%found;
            close c_res_roboter;
            if v_found then
                if print_allg.get_drucker(in_sid, in_firma_nr, v_res.drucker, v_drucker) then
                    pe_job_nr := lvs_p_lte.lvs_c_lte_drucken(v_lte_barcode,
                                                             to_char(v_fa_auftrag.kunden_nr),
                                                             v_res.drucker);

                    if v_drucker.drucker_typ = print_allg.pe_typ_eti then
                        if upper(v_drucker.eti_drucker_typ) like '%LOGOPAK%' then
                            print_engine.insert_new_job(in_sid,
                                                        in_firma_nr,
                                                        null,
                                                        null,
                                                        print_engine.jdt_direkt,
                                                        ' *SETCOUNT,01,'
                                                        || to_char(v_charge.charge_lte_lfdn)
                                                        || '<CR>',
                                                        v_res.drucker,
                                                        1,
                                                        pe_job_nr);

                        end if;

                    end if;

                end if;
            end if;

        end if;

        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt
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

    procedure c_bde_res_print_lte (
        in_sid    in isi_sid.sid%type,
        in_res_id in isi_resource.res_id%type
    ) is

        v_res_zus_akt isi_resource_zust_akt%rowtype;
        v_res         isi_resource%rowtype;
        v_lte         lvs_lte%rowtype;
        v_fa_auftrag  bde_fa_auftrag%rowtype;
        v_pe_job_nr   number;
        cursor c_fa_auftrag is
        select
            t.*
        from
            bde_fa_auftrag t
        where
                t.leitzahl = v_res_zus_akt.leitzahl
            and t.fa_ag = v_res_zus_akt.fa_ag
            and t.fa_upos = v_res_zus_akt.fa_upos;

    begin
    -- lesen den Zustand der Resource
        if isi_p_base.get_res_zust_akt(in_sid, in_res_id, v_res_zus_akt) then
      -- Es ist eine Palette an der Maschine
            if v_res_zus_akt.lte_id is not null then
                if isi_p_base.get_resource(in_sid, in_res_id, v_res) then
                    if lvs_p_base.get_lte(v_res_zus_akt.lte_id, v_lte) then
                        if v_res.drucker is not null then
                            if v_lte.lte_akt_lhm > 0 then
                                v_fa_auftrag := null;
                                open c_fa_auftrag;
                                fetch c_fa_auftrag into v_fa_auftrag;
                                close c_fa_auftrag;

                --CMe 20210422 Drucken nur wenn Lte nicht im Status gedruckt ist
                                if ( nvl(v_lte.lte_eti_druck_status, c.eti_status_soll_drucken) != c.eti_status_gedruckt ) then
                                    v_pe_job_nr := lvs_p_lte.lvs_c_lte_drucken(v_res_zus_akt.lte_id,
                                                                               to_char(v_fa_auftrag.kunden_nr),
                                                                               v_res.drucker);
                                end if;

                            end if;

                        end if;

                    end if;

                end if;

            end if;
        end if;

        commit;
    end;

    procedure c_bde_linie_fertig (
        in_sid    in isi_sid.sid%type,
        in_res_id in isi_resource.res_id%type
    ) is
        v_res isi_resource%rowtype;
    begin
        if isi_p_base.get_resource(in_sid, in_res_id, v_res) then
            update isi_resource_zust_akt t
            set
                t.auftrag_status = 'F'
            where
                t.res_id in (
                    select
                        t2.res_id
                    from
                        isi_resource t2
                    where
                        t2.linie_res_id = v_res.linie_res_id
                );

        end if;

        commit;
    end;

    procedure c_bde_res_print_str (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_res_id   in isi_resource.res_id%type,
        in_prn_str  in varchar2
    ) is
        v_res     isi_resource%rowtype;
        pe_job_nr integer;
    begin
        if isi_p_base.get_resource(in_sid, in_res_id, v_res) then
            if v_res.drucker is not null then
                print_engine.insert_new_job(in_sid, in_firma_nr, null, null, print_engine.jdt_direkt,
                                            in_prn_str, v_res.drucker, 1, pe_job_nr);

            end if;
        end if;

        commit;
    end;

end fls_p_bde_lvs;
/


-- sqlcl_snapshot {"hash":"bf6d464aba673ff90c99c905c0642245dbc1b91c","type":"PACKAGE_BODY","name":"FLS_P_BDE_LVS","schemaName":"DIRKSPZM32","sxml":""}