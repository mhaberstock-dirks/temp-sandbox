create or replace package body dirkspzm32.bde_rueckverfolg is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --v_lam_bh                  lvs_lam_bh%rowtype := NULL;

  -- Function and procedure implementations

  /*************************************************************************************************************************
    Commit: Function erstellt Tabelle für die Rueckverfolgung über bestimmte Kriterien und gibt die Nummer der Abfrage zurück
  **************************************************************************************************************************/
    function c_rueckverfolg_create (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_lhm_id     in lvs_lam_bh.lhm_id%type,
        in_lte_id     in lvs_lte.lte_id%type,
        in_leitzahl   in lvs_lam_bh.leitzahl%type,
        in_charge_bez in lvs_charge.charge_bez%type,
        in_artikel_id in lvs_charge.artikel_id%type
    ) return number is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_ret      number;
    begin
        v_ret := rueckverfolg_create(in_sid, --            in isi_sid.sid%type,
         in_firma_nr, --       in isi_firma.firma_nr%type,
         in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
         in_lte_id, --         in lvs_lte.lte_id%type,
         in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                     in_charge_bez, --     in lvs_charge.charge_bez%type,
                                      in_artikel_id, --     in lvs_charge.artikel_id%type
                                      null);

        commit;
        return ( v_ret );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end c_rueckverfolg_create;

    function c_rueckverfolg_create_v2 (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_lhm_id      in lvs_lam_bh.lhm_id%type,
        in_lte_id      in lvs_lte.lte_id%type,
        in_leitzahl    in lvs_lam_bh.leitzahl%type,
        in_charge_bez  in lvs_charge.charge_bez%type,
        in_artikel_id  in lvs_charge.artikel_id%type,
        in_order_li_nr in isi_order_pos.li_nr%type
    ) return number is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_ret      number;
    begin
        v_ret := rueckverfolg_create(in_sid, --            in isi_sid.sid%type,
         in_firma_nr, --       in isi_firma.firma_nr%type,
         in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
         in_lte_id, --         in lvs_lte.lte_id%type,
         in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                     in_charge_bez, --     in lvs_charge.charge_bez%type,
                                      in_artikel_id, --     in lvs_charge.artikel_id%type
                                      in_order_li_nr);

        commit;
        return ( v_ret );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end c_rueckverfolg_create_v2;
  /*************************************************************************************************************************
    Function erstellt Tabelle für die Rueckverfolgung über bestimmte Kriterien und gibt die Nummer der Abfrage zurück
  **************************************************************************************************************************/
    function rueckverfolg_create (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_lhm_id      in lvs_lam_bh.lhm_id%type,
        in_lte_id      in lvs_lte.lte_id%type,
        in_leitzahl    in lvs_lam_bh.leitzahl%type,
        in_charge_bez  in lvs_charge.charge_bez%type,
        in_artikel_id  in lvs_charge.artikel_id%type,
        in_order_li_nr in isi_order_pos.li_nr%type
    ) return number is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(255);

    -------------------------------------------------------------

        v_pd_prod_vorg_id   bde_pd_prod.vorg_id%type;
        v_pd_prod_vorg_id_l bde_pd_prod.vorg_id%type;
        v_pd_prod           bde_pd_prod%rowtype;
        v_lam               lvs_lam%rowtype;
        v_lam_bh_s          lvs_lam_bh%rowtype; -- Um naechsten Eintrag zu lesen.
        v_lam_bh            lvs_lam_bh%rowtype;
        v_lam_bh_up         lvs_lam_bh%rowtype; -- Für lam_bh Buchungen beim picken
        v_lam_bh_next       lvs_lam_bh%rowtype; -- Für lam_bh Buchung der LTE von der gepickt wurde
        v_lam_next          lvs_lam%rowtype; -- Für lvs_lam der LTE von der gepickt wurde
        v_abfr_id           bde_pd_rueckverfolgung.abfr_id%type;
        v_charge            lvs_charge%rowtype;
        v_l_lam_letzte_id   lvs_lam_bh.lam_id%type;
        v_l_zeile           number;
        v_l_zeile_u         number;
        cursor c_pd_prod_start is
        select
            pd.*
        from
            bde_pd_prod pd
        where
            pd.vorg_id = v_pd_prod_vorg_id
          -- Mwe add or Ticket: W24210-125
      --    or pd.fae_id in (select t.fae_id from bde_pd_prod t where t.vorg_id = 15866491 and ROWNUM >= 1 ) and pd.vorg_typ in ('PP','PB')
        order by
            pd.vorg_typ desc;

        cursor c_charge is
        select
            *
        from
            lvs_charge c
        where
                c.sid = in_sid
            and c.charge_id = v_lam.charge_id;

        cursor c_charge_next is
        select
            *
        from
            lvs_charge c
        where
                c.sid = in_sid
            and c.charge_id = v_lam_next.charge_id;

    begin
        v_anz_rueck := 0;

    -- Maximale Anzahl der Ergebnismenge
        v_max_rueck := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null, -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'MAX_RUECKVERFOLGUNG', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                      'BDE_DB', -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                       'CFG', -- in_typ                   in isi_firma_cfg.typ%type,
                                                       '2500', -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                       'INTEGER'); -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
        if
            in_artikel_id is null
            and in_leitzahl is null
            and in_lhm_id is null
            and in_lte_id is null
            and in_order_li_nr is null
        then
            v_err_nr := 1;
            v_err_text := 'Keine Selektion für die Abfrage eingegeben!';
            raise v_error;
        end if;

        if
            in_charge_bez is null
            and in_leitzahl is null
            and in_lhm_id is null
            and in_lte_id is null
            and in_order_li_nr is null
        then
            v_err_nr := 2;
            v_err_text := 'Bei Rückverfolgung eines Artikels muss eine Charge angegeben werden!!';
            raise v_error;
        end if;

        v_pd_prod_vorg_id_l := 0;
        v_abfr_id := null;
        v_zeile := null;
        v_l_lam_letzte_id := 1;
        loop
            v_lam_letzte_id := v_l_lam_letzte_id;
            v_lam_bh_s := null;
            v_pd_prod_vorg_id := find_pd_vorgang_id(in_sid, --            in isi_sid.sid%type,
             in_firma_nr, --       in isi_firma.firma_nr%type,
             in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
             in_lte_id, --         in lvs_lte.lte_id%type,
             in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                                    in_charge_bez, --     in lvs_charge.charge_bez%type,
                                                     in_artikel_id, --    in lvs_charge.artikel_id%type
                                                     null, in_order_li_nr, v_pd_prod_vorg_id_l,
                                                    v_lam_bh_s, 'PP', false);

            v_l_lam_letzte_id := v_lam_letzte_id;
            v_lam_letzte_id := 0;
            if
                v_pd_prod_vorg_id is null
                and v_pd_prod_vorg_id_l = 0
            then
        -- Keine Produktion Daten gefunden. Prüfen ob auf die LTE gepackt worden ist
                v_l_lam_letzte_id := 1;
                loop
                    v_lam_letzte_id := v_l_lam_letzte_id;
                    v_lam_bh_up := find_lam_bh_buch(in_sid, --            in isi_sid.sid%type,
                     in_firma_nr, --       in isi_firma.firma_nr%type,
                     in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
                     in_lte_id, --         in lvs_lte.lte_id%type,
                     in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                                    in_charge_bez, --     in lvs_charge.charge_bez%type,
                                                     in_artikel_id, --    in lvs_charge.artikel_id%type
                                                     'UP', null, in_order_li_nr); --    in bde_pd_prod.vorg_typ%type
                    v_l_lam_letzte_id := v_lam_letzte_id;
                    v_lam_letzte_id := 0;
                    if not v_lam_bh_up.lam_id is null then
                        v_zeile := nvl(v_zeile, 0) + 1;
                        v_l_zeile := v_zeile;
                        v_lam := ret_lam_v(in_sid, in_firma_nr, v_lam_bh_up.lam_id);
                        v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_lam_bh_up.lam_id);
                        v_anz_rueck := v_anz_rueck + 1;
                        if v_anz_rueck > v_max_rueck then
                            v_err_nr := 5;
                            v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                            (v_max_rueck);
                            raise v_error;
                        end if;
            --Prüfen ob es eine ID gibt von der gepickt worden ist
                        v_lam_bh_next := ret_lam_bh_pick_by_vorgang_id(in_sid, --in isi_sid.sid%type,
                         in_firma_nr, --in isi_firma.firma_nr%type,
                         v_lam_bh_up.vorg_id, --in lvs_lam_bh.vorg_id%type,
                         v_lam_bh_up.lte_id --in lvs_lam_bh.lhm_id%type
                        );
                        if v_lam_bh_next.lte_id is null then
                            v_err_nr := 10;
                            v_err_text := 'Keine Produktionsdaten für Abgefragte Daten gefunden';
                            raise v_error;
                        end if;
            -- Vorab Prüfen ob es für die Pick einen Eintrag gibt
                        v_pd_prod_vorg_id := find_pd_vorgang_id(in_sid, --            in isi_sid.sid%type,
                         in_firma_nr, --       in isi_firma.firma_nr%type,
                         in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
                         v_lam_bh_next.lte_id, --         in lvs_lte.lte_id%type,
                         in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                                                in_charge_bez, --     in lvs_charge.charge_bez%type,
                                                                 in_artikel_id, --    in lvs_charge.artikel_id%type
                                                                 null, in_order_li_nr, v_pd_prod_vorg_id_l,
                                                                v_lam_bh_s, 'PP', false);

                        if
                            v_pd_prod_vorg_id is null
                            and v_pd_prod_vorg_id_l = 0
                        then
                            v_err_nr := 10;
                            v_err_text := 'Keine Produktionsdaten für Abgefragte Daten gefunden';
                            raise v_error;
                        end if;

                        v_pd_prod_vorg_id_l := v_pd_prod_vorg_id;
                        v_lam_next := ret_lam_v(in_sid, in_firma_nr, v_lam_bh_next.lam_id);
                        if v_abfr_id is null then
                            select
                                seq_bde_pd_rueckverfolgung.nextval
                            into v_abfr_id
                            from
                                dual;

                            insert into bde_pd_rueckverf_sel values ( in_sid,
                                                                      in_firma_nr,
                                                                      sysdate,
                                                                      v_abfr_id,
                                                                      in_lhm_id,
                                                                      in_lte_id,
                                                                      in_leitzahl,
                                                                      in_charge_bez,
                                                                      in_artikel_id,
                                                                      'TD',
                                                                      null,
                                                                      null,
                                                                      in_order_li_nr );

                        end if;

                        insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                    v_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                    'TB', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                    v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                    v_l_zeile, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                    in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                    v_lam.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                    v_lam.fa_ag, -- FA_AG               NUMBER not null,
                                                                    v_lam.fa_upos, -- FA_UPOS             NUMBER,
                                                                    v_lam_bh_up.res_id, -- RES_ID              NUMBER not null,
                                                                    null, -- PERS_NR             NUMBER,
                                                                    v_lam_bh_up.last_change_login_id, -- USER_ID             NUMBER,
                                                                    v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                    v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                    v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                    v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                    v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                    v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                    v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                    v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                    v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                    v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                    v_lam_bh.menge, -- MENGE               NUMBER,
                                                                    v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                    v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                    v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                    v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                    v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                    v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                    v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                    v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                    null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                    null ); -- QUELL_LHM_ID        VARCHAR2(20)
                        v_l_zeile_u := v_zeile;
                        get_pick_lte_by_vorgang_id(in_sid, -- in_sid            in isi_sid.sid%type,
                         in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                         v_lam_bh_up.vorg_id, -- in_vorgang_id     in lvs_lam_bh.vorg_id%type
                         v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                         v_abfr_id, -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
                                                   v_lam_bh_up.lte_id); -- in_put_lhm_id     in lvs_lam_bh.lhm_id%type
                        open c_charge_next;
                        fetch c_charge_next into v_charge;
                        close c_charge_next;
                        rueckverfolg_weiter(in_sid, -- in_sid            in isi_sid.sid%type,
                         in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                         v_lam_bh_next.lhm_id, -- in_lhm_id         in lvs_lam_bh.lhm_id%type,
                         v_lam_bh_next.lte_id, -- in_lte_id         in lvs_lte.lte_id%type,
                         v_lam_next.leitzahl, -- in_leitzahl       in lvs_lam_bh.leitzahl%type,
                                            v_charge.charge_bez, -- in_charge_bez     in lvs_charge.charge_bez%type,
                                             v_charge.artikel_id, -- in_artikel_id     in lvs_charge.artikel_id%type,
                                             v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                                             v_abfr_id); -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
                    else
                        exit;
                    end if;

                end loop;

                exit;
        --v_err_nr := 10;
        --v_err_text := 'Keine Produktionsdaten für Abgefragte Daten gefunden';
        --raise v_error;
            else
                if v_pd_prod_vorg_id is null then
                    exit; -- Jetz fertig, Keine Paletten mehr offen
                end if;
                v_pd_prod_vorg_id_l := v_pd_prod_vorg_id;
                if v_abfr_id is null then
                    select
                        seq_bde_pd_rueckverfolgung.nextval
                    into v_abfr_id
                    from
                        dual;

                    insert into bde_pd_rueckverf_sel values ( in_sid,
                                                              in_firma_nr,
                                                              sysdate,
                                                              v_abfr_id,
                                                              in_lhm_id,
                                                              in_lte_id,
                                                              in_leitzahl,
                                                              in_charge_bez,
                                                              in_artikel_id,
                                                              'TD',
                                                              null,
                                                              null,
                                                              in_order_li_nr );

                end if;

                open c_pd_prod_start;
                loop
                    v_pd_prod := null;
                    fetch c_pd_prod_start into v_pd_prod;
                    exit when c_pd_prod_start%notfound;
                    if v_pd_prod.vorg_typ = 'PP' then
                        v_zeile := nvl(v_zeile, 0) + 1;
                        v_l_zeile := v_zeile;
                        v_lam := ret_lam_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_anz_rueck := v_anz_rueck + 1;
                        if v_anz_rueck > v_max_rueck then
                            v_err_nr := 5;
                            v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                            (v_max_rueck);
                            raise v_error;
                        end if;

                        insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                    v_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                    'TP', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                    v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                    null, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                    in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                    v_pd_prod.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                    v_pd_prod.fa_ag, -- FA_AG               NUMBER not null,
                                                                    v_pd_prod.fa_upos, -- FA_UPOS             NUMBER,
                                                                    v_pd_prod.res_id, -- RES_ID              NUMBER not null,
                                                                    v_pd_prod.pers_nr, -- PERS_NR             NUMBER,
                                                                    v_pd_prod.ls_login_id, -- USER_ID             NUMBER,
                                                                    v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                    v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                    v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                    v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                    v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                    v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                    v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                    v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                    v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                    v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                    v_lam_bh.menge, -- MENGE               NUMBER,
                                                                    v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                    v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                    v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                    v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                    v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                    v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                    v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                    v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                    null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                    null ); -- QUELL_LHM_ID        VARCHAR2(20)
                    else
                        v_zeile := nvl(v_zeile, 1) + 1;
                        v_lam := ret_lam_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_anz_rueck := v_anz_rueck + 1;
                        if v_anz_rueck > v_max_rueck then
                            v_err_nr := 5;
                            v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                            (v_max_rueck);
                            raise v_error;
                        end if;

                        insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                    v_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                    'TB', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                    v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                    v_l_zeile, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                    in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                    v_lam.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                    v_lam.fa_ag, -- FA_AG               NUMBER not null,
                                                                    v_lam.fa_upos, -- FA_UPOS             NUMBER,
                                                                    v_pd_prod.res_id, -- RES_ID              NUMBER not null,
                                                                    v_pd_prod.pers_nr, -- PERS_NR             NUMBER,
                                                                    v_pd_prod.ls_login_id, -- USER_ID             NUMBER,
                                                                    v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                    v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                    v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                    v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                    v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                    v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                    v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                    v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                    v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                    v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                    v_lam_bh.menge, -- MENGE               NUMBER,
                                                                    v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                    v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                    v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                    v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                    v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                    v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                    v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                    v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                    null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                    null ); -- QUELL_LHM_ID        VARCHAR2(20)
                        open c_charge;
                        fetch c_charge into v_charge;
                        close c_charge;
                        v_l_zeile_u := v_zeile;
                        if v_lam_bh.bus = c.r_lam_bh_bus_zug_komm then
                            get_komm_lte_by_vorgang_id(in_sid, -- in_sid            in isi_sid.sid%type,
                             in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                             v_lam_bh.vorg_id, -- in_vorgang_id     in lvs_lam_bh.vorg_id%type
                             v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                             v_abfr_id); -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
              --elsif v_lam_bh.bus = c.R_LAM_BH_BUS_UP then
              --  get_pick_lte_by_vorgang_id (in_sid,                 -- in_sid            in isi_sid.sid%type,
              --                              in_firma_nr,            -- in_firma_nr       in isi_firma.firma_nr%type,
              --                             v_lam_bh.vorg_id,       -- in_vorgang_id     in lvs_lam_bh.vorg_id%type
              --                              v_l_zeile_u,            -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
              --                              v_abfr_id ,             -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
              --                              v_lam_bh.lhm_id);       -- in_put_lhm_id     in lvs_lam_bh.lhm_id%type
                        else
                            rueckverfolg_weiter(in_sid, -- in_sid            in isi_sid.sid%type,
                             in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                             v_lam_bh.lhm_id, -- in_lhm_id         in lvs_lam_bh.lhm_id%type,
                             v_lam_bh.lte_id, -- in_lte_id         in lvs_lte.lte_id%type,
                             v_lam.leitzahl, -- in_leitzahl       in lvs_lam_bh.leitzahl%type,
                                                v_charge.charge_bez, -- in_charge_bez     in lvs_charge.charge_bez%type,
                                                 v_charge.artikel_id, -- in_artikel_id     in lvs_charge.artikel_id%type,
                                                 v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                                                 v_abfr_id); -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
                        end if;

                    end if;

                end loop;

                close c_pd_prod_start;
        --
            end if;

        end loop;

    -- Update der Laufzeit um die Gesammt Laufzeit einzelner Abfragen berehcnen zu können
        update bde_pd_rueckverf_sel t
        set
            t.abfr_enddatum = sysdate
        where
            t.abfr_id = v_abfr_id;

        return ( v_abfr_id );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
            if c_pd_prod_start%isopen then
                close c_pd_prod_start;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if c_pd_prod_start%isopen then
                close c_pd_prod_start;
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

    end rueckverfolg_create;

  /*************************************************************************************************************************
  Function erstellt Tabelle für die Rueckverfolgung über bestimmte Kriterien und gibt die Nummer der Abfrage zurück
  **************************************************************************************************************************/
    procedure rueckverfolg_weiter (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_lhm_id     in lvs_lam_bh.lhm_id%type,
        in_lte_id     in lvs_lte.lte_id%type,
        in_leitzahl   in lvs_lam_bh.leitzahl%type,
        in_charge_bez in lvs_charge.charge_bez%type,
        in_artikel_id in lvs_charge.artikel_id%type,
        in_zeile      in bde_pd_rueckverfolgung.abfr_zeile%type,
        in_abfr_id    in bde_pd_rueckverfolgung.abfr_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr          number;
        v_err_text        varchar2(255);

    -------------------------------------------------------------

        v_pd_prod_vorg_id bde_pd_prod.vorg_id%type;
        v_pd_prod         bde_pd_prod%rowtype;
        v_lam             lvs_lam%rowtype;
        v_lam_bh          lvs_lam_bh%rowtype;
        v_lam_bh_s        lvs_lam_bh%rowtype; -- Um naechsten Eintrag zu lesen.
        v_charge          lvs_charge%rowtype;
        v_l_zeile         number;
        v_l_zeile_u       number;
        cursor c_pd_prod is
        select
            pd.*
        from
            bde_pd_prod pd
        where
            pd.vorg_id = v_pd_prod_vorg_id
        order by
            pd.vorg_typ desc;

        cursor c_charge is
        select
            *
        from
            lvs_charge c
        where
                c.sid = in_sid
            and c.charge_id = v_lam.charge_id;

    begin
        v_lam_letzte_id := 0;
        v_lam_bh_s := null;
        v_pd_prod_vorg_id := find_pd_vorgang_id(in_sid, --            in isi_sid.sid%type,
         in_firma_nr, --       in isi_firma.firma_nr%type,
         in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
         in_lte_id, --         in lvs_lte.lte_id%type,
         in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                                in_charge_bez, --     in lvs_charge.charge_bez%type,
                                                 in_artikel_id, --    in lvs_charge.artikel_id%type,
                                                 null, null, 0,
                                                v_lam_bh_s, 'PP', false);

        if v_pd_prod_vorg_id is null then
            return; -- Hier ist keine Vorproduktion mehr
        else
            v_l_zeile := in_zeile;
            open c_pd_prod;
            loop
                v_pd_prod := null;
                fetch c_pd_prod into v_pd_prod;
                exit when c_pd_prod%notfound;
                if v_pd_prod.vorg_typ = 'PP' then
                    v_zeile := nvl(v_zeile, 1) + 1;
                    v_lam := ret_lam_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                    v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                    v_anz_rueck := v_anz_rueck + 1;
                    if v_anz_rueck > v_max_rueck then
                        v_err_nr := 5;
                        v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                        (v_max_rueck);
                        raise v_error;
                    end if;

                    insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                in_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                'TP', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                v_l_zeile, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                v_pd_prod.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                v_pd_prod.fa_ag, -- FA_AG               NUMBER not null,
                                                                v_pd_prod.fa_upos, -- FA_UPOS             NUMBER,
                                                                v_pd_prod.res_id, -- RES_ID              NUMBER not null,
                                                                v_pd_prod.pers_nr, -- PERS_NR             NUMBER,
                                                                v_pd_prod.ls_login_id, -- USER_ID             NUMBER,
                                                                v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                v_lam_bh.menge, -- MENGE               NUMBER,
                                                                v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                null ); -- QUELL_LHM_ID        VARCHAR2(20)
                else
                    v_zeile := nvl(v_zeile, 1) + 1;
                    v_lam := ret_lam_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                    v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                    v_anz_rueck := v_anz_rueck + 1;
                    if v_anz_rueck > v_max_rueck then
                        v_err_nr := 5;
                        v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                        (v_max_rueck);
                        raise v_error;
                    end if;

                    insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                in_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                'TB', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                v_l_zeile, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                v_pd_prod.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                v_pd_prod.fa_ag, -- FA_AG               NUMBER not null,
                                                                v_pd_prod.fa_upos, -- FA_UPOS             NUMBER,
                                                                v_pd_prod.res_id, -- RES_ID              NUMBER not null,
                                                                v_pd_prod.pers_nr, -- PERS_NR             NUMBER,
                                                                v_pd_prod.ls_login_id, -- USER_ID             NUMBER,
                                                                v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                v_lam_bh.menge, -- MENGE               NUMBER,
                                                                v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                null ); -- QUELL_LHM_ID        VARCHAR2(20)
                    open c_charge;
                    fetch c_charge into v_charge;
                    close c_charge;
                    v_l_zeile_u := v_zeile;
                    if v_lam_bh.bus = c.r_lam_bh_bus_zug_komm then
                        get_komm_lte_by_vorgang_id(in_sid, -- in_sid            in isi_sid.sid%type,
                         in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                         v_lam_bh.vorg_id, -- in_vorgang_id     in lvs_lam_bh.vorg_id%type
                         v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                         in_abfr_id); -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
            -- elsif v_lam_bh.bus = c.R_LAM_BH_BUS_UP then
            --    get_pick_lte_by_vorgang_id (in_sid,                 -- in_sid            in isi_sid.sid%type,
            --                                in_firma_nr,            -- in_firma_nr       in isi_firma.firma_nr%type,
            --                                v_lam_bh.vorg_id,       -- in_vorgang_id     in lvs_lam_bh.vorg_id%type
            --                                v_l_zeile_u,            -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
            --                                in_abfr_id ,            -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
            --                                v_lam_bh.lhm_id);       -- in_put_lhm_id     in lvs_lam_bh.lhm_id%type
                    else
                        rueckverfolg_weiter(in_sid, -- in_sid            in isi_sid.sid%type,
                         in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                         v_lam_bh.lhm_id, -- in_lhm_id         in lvs_lam_bh.lhm_id%type,
                         v_lam_bh.lte_id, -- in_lte_id         in lvs_lte.lte_id%type,
                         v_lam.leitzahl, -- in_leitzahl       in lvs_lam_bh.leitzahl%type,
                                            v_charge.charge_bez, -- in_charge_bez     in lvs_charge.charge_bez%type,
                                             v_charge.artikel_id, -- in_artikel_id     in lvs_charge.artikel_id%type,
                                             v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                                             in_abfr_id); -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
                    end if;

                end if;

            end loop;

            close c_pd_prod;
        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
            if c_pd_prod%isopen then
                close c_pd_prod;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if c_pd_prod%isopen then
                close c_pd_prod;
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

    end rueckverfolg_weiter;

  /*************************************************************************************************************************
    Commit: Function erstellt Tabelle für die Vorwaertsverfolgung über bestimmte Kriterien und gibt die Nummer der Abfrage zurück
  **************************************************************************************************************************/
    function c_vorwaerts_create (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_lhm_id     in lvs_lam_bh.lhm_id%type,
        in_lte_id     in lvs_lte.lte_id%type,
        in_leitzahl   in lvs_lam_bh.leitzahl%type,
        in_charge_bez in lvs_charge.charge_bez%type,
        in_artikel_id in lvs_charge.artikel_id%type
    ) return number is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_ret      number;
    begin
        v_ret := vorwaerts_create(in_sid, --            in isi_sid.sid%type,
         in_firma_nr, --       in isi_firma.firma_nr%type,
         in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
         in_lte_id, --         in lvs_lte.lte_id%type,
         in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                  in_charge_bez, --     in lvs_charge.charge_bez%type,
                                   in_artikel_id, --     in lvs_charge.artikel_id%type
                                   null);

        commit;
        return ( v_ret );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end c_vorwaerts_create;

    function c_vorwaerts_create_v2 (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_lhm_id     in lvs_lam_bh.lhm_id%type,
        in_lte_id     in lvs_lte.lte_id%type,
        in_leitzahl   in lvs_lam_bh.leitzahl%type,
        in_charge_bez in lvs_charge.charge_bez%type,
        in_artikel_id in lvs_charge.artikel_id%type,
        in_li_nr_lief in lvs_lam.li_nr_lief%type
    ) return number is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_ret      number;
    begin
        v_ret := vorwaerts_create(in_sid, --            in isi_sid.sid%type,
         in_firma_nr, --       in isi_firma.firma_nr%type,
         in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
         in_lte_id, --         in lvs_lte.lte_id%type,
         in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                  in_charge_bez, --     in lvs_charge.charge_bez%type,
                                   in_artikel_id, --     in lvs_charge.artikel_id%type
                                   in_li_nr_lief);

        commit;
        return ( v_ret );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end c_vorwaerts_create_v2;

  /*************************************************************************************************************************
    Function erstellt Tabelle für die Vorwaertsverfolgung über bestimmte Kriterien und gibt die Nummer der Abfrage zurück
  **************************************************************************************************************************/
    function vorwaerts_create (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_lhm_id     in lvs_lam_bh.lhm_id%type,
        in_lte_id     in lvs_lte.lte_id%type,
        in_leitzahl   in lvs_lam_bh.leitzahl%type,
        in_charge_bez in lvs_charge.charge_bez%type,
        in_artikel_id in lvs_charge.artikel_id%type,
        in_li_nr_lief in lvs_lam.li_nr_lief%type
    ) return number is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(255);

    -------------------------------------------------------------

        v_pd_prod_vorg_id   bde_pd_prod.vorg_id%type;
        v_pd_prod_vorg_id_l bde_pd_prod.vorg_id%type;
        v_pd_prod           bde_pd_prod%rowtype;
        v_lam               lvs_lam%rowtype;
        v_lam_bh            lvs_lam_bh%rowtype;
        v_lam_bh_s          lvs_lam_bh%rowtype; -- Um naechsten Eintrag zu lesen.
        v_abfr_id           bde_pd_rueckverfolgung.abfr_id%type;
        v_lam_bh_up         lvs_lam_bh%rowtype; -- Für lam_bh Buchungen beim picken
        v_lam_bh_next       lvs_lam_bh%rowtype; -- Für lam_bh Buchung der LTE von der gepickt wurde
        v_lam_next          lvs_lam%rowtype; -- Für lvs_lam der LTE von der gepickt wurde
        v_charge            lvs_charge%rowtype;
        v_l_lam_letzte_id   lvs_lam_bh.lam_id%type;
        v_b_lam_letzte_id   lvs_lam_bh.lam_id%type;
        v_l_zeile           number;
        v_l_zeile_u         number;
        cursor c_pd_prod_start is
        select
            pd.*
        from
            bde_pd_prod pd
        where
            pd.vorg_id = v_pd_prod_vorg_id
        order by
            pd.vorg_typ,
            pd.vorg_id;

        cursor c_charge is
        select
            *
        from
            lvs_charge c
        where
                c.sid = in_sid
            and c.charge_id = v_lam.charge_id;

        cursor c_charge_next is
        select
            *
        from
            lvs_charge c
        where
                c.sid = in_sid
            and c.charge_id = v_lam_next.charge_id;

    begin
        v_anz_rueck := 0;

    -- Maximale Anzahl der Ergebnismenge
        v_max_rueck := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null, -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'MAX_RUECKVERFOLGUNG', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                      'BDE_DB', -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                       'CFG', -- in_typ                   in isi_firma_cfg.typ%type,
                                                       '2500', -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                       'INTEGER'); -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
        if
            in_artikel_id is null
            and in_leitzahl is null
            and in_lhm_id is null
            and in_lte_id is null
            and in_li_nr_lief is null
        then
            v_err_nr := 1;
            v_err_text := 'Keine Selektion für die Abfrage eingegeben!';
            raise v_error;
        end if;

        if
            in_charge_bez is null
            and in_leitzahl is null
            and in_lhm_id is null
            and in_lte_id is null
            and in_li_nr_lief is null
        then
            v_err_nr := 2;
            v_err_text := 'Bei Rückverfolgung eines Artikels muss eine Charge angegeben werden!!';
            raise v_error;
        end if;

        if
            in_charge_bez is not null
            and in_artikel_id is null
        then
            v_err_nr := 3;
            v_err_text := 'Bei Rückverfolgung über eine Charge muss der Artikel angegeben werden!!';
            raise v_error;
        end if;

        v_pd_prod_vorg_id_l := 0;
        v_abfr_id := null;
        v_zeile := null;
        v_lam_bh_s := null;
        v_l_lam_letzte_id := 1;
        v_b_lam_letzte_id := 0;
        loop
            v_lam_letzte_id := v_l_lam_letzte_id;
            v_pd_prod_vorg_id := find_pd_vorgang_id(in_sid, --            in isi_sid.sid%type,
             in_firma_nr, --       in isi_firma.firma_nr%type,
             in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
             in_lte_id, --         in lvs_lte.lte_id%type,
             in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                                    in_charge_bez, --     in lvs_charge.charge_bez%type,
                                                     in_artikel_id, --    in lvs_charge.artikel_id%type
                                                     in_li_nr_lief, null, v_pd_prod_vorg_id_l,
                                                    v_lam_bh_s, 'PB', true);

            v_l_lam_letzte_id := v_lam_letzte_id;
            v_lam_letzte_id := 0;
            if
                v_pd_prod_vorg_id is null
                and v_pd_prod_vorg_id_l = 0
            then
        -- Keine Produktion Daten gefunden. Prüfen ob auf die LTE gepackt worden ist
                loop
                    v_lam_letzte_id := v_l_lam_letzte_id;
                    v_lam_bh_up := find_lam_bh_buch(in_sid, --            in isi_sid.sid%type,
                     in_firma_nr, --       in isi_firma.firma_nr%type,
                     in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
                     in_lte_id, --         in lvs_lte.lte_id%type,
                     in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                                    in_charge_bez, --     in lvs_charge.charge_bez%type,
                                                     in_artikel_id, --    in lvs_charge.artikel_id%type
                                                     'UP', in_li_nr_lief, null); --    in bde_pd_prod.vorg_typ%type
                    v_l_lam_letzte_id := v_lam_letzte_id;
                    v_lam_letzte_id := 0;
                    if not v_lam_bh_up.lam_id is null then
                        v_zeile := nvl(v_zeile, 0) + 1;
                        v_l_zeile := v_zeile;
                        v_lam := ret_lam_v(in_sid, in_firma_nr, v_lam_bh_up.lam_id);
                        v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_lam_bh_up.lam_id);
                        v_anz_rueck := v_anz_rueck + 1;
                        if v_anz_rueck > v_max_rueck then
                            v_err_nr := 5;
                            v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                            (v_max_rueck);
                            raise v_error;
                        end if;
            --Prüfen ob es eine ID gibt von der gepickt worden ist
                        v_lam_bh_next := ret_lam_bh_pick_by_vorgang_id(in_sid, --in isi_sid.sid%type,
                         in_firma_nr, --in isi_firma.firma_nr%type,
                         v_lam_bh_up.vorg_id, --in lvs_lam_bh.vorg_id%type,
                         v_lam_bh_up.lte_id --in lvs_lam_bh.lhm_id%type
                        );
                        if v_lam_bh_next.lte_id is null then
                            v_err_nr := 10;
                            v_err_text := 'Keine Produktionsdaten für Abgefragte Daten gefunden';
                            raise v_error;
                        end if;
            -- Vorab Prüfen ob es für die Pick einen Eintrag gibt
                        v_pd_prod_vorg_id := find_pd_vorgang_id(in_sid, --            in isi_sid.sid%type,
                         in_firma_nr, --       in isi_firma.firma_nr%type,
                         in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
                         v_lam_bh_next.lte_id, --         in lvs_lte.lte_id%type,
                         in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                                                in_charge_bez, --     in lvs_charge.charge_bez%type,
                                                                 in_artikel_id, --    in lvs_charge.artikel_id%type
                                                                 in_li_nr_lief, null, v_pd_prod_vorg_id_l,
                                                                v_lam_bh_s, 'PP', false);

                        if
                            v_pd_prod_vorg_id is null
                            and v_pd_prod_vorg_id_l = 0
                        then
                            v_err_nr := 10;
                            v_err_text := 'Keine Produktionsdaten für Abgefragte Daten gefunden';
                            raise v_error;
                        end if;

                        v_pd_prod_vorg_id_l := v_pd_prod_vorg_id;
                        v_lam_next := ret_lam_v(in_sid, in_firma_nr, v_lam_bh_next.lam_id);
                        if v_abfr_id is null then
                            select
                                seq_bde_pd_rueckverfolgung.nextval
                            into v_abfr_id
                            from
                                dual;

                            insert into bde_pd_rueckverf_sel values ( in_sid,
                                                                      in_firma_nr,
                                                                      sysdate,
                                                                      v_abfr_id,
                                                                      in_lhm_id,
                                                                      in_lte_id,
                                                                      in_leitzahl,
                                                                      in_charge_bez,
                                                                      in_artikel_id,
                                                                      'BU',
                                                                      null,
                                                                      in_li_nr_lief,
                                                                      null );

                        end if;

                        insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                    v_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                    'TB', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                    v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                    v_l_zeile, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                    in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                    v_lam.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                    v_lam.fa_ag, -- FA_AG               NUMBER not null,
                                                                    v_lam.fa_upos, -- FA_UPOS             NUMBER,
                                                                    v_lam_bh_up.res_id, -- RES_ID              NUMBER not null,
                                                                    null, -- PERS_NR             NUMBER,
                                                                    v_lam_bh_up.last_change_login_id, -- USER_ID             NUMBER,
                                                                    v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                    v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                    v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                    v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                    v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                    v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                    v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                    v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                    v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                    v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                    v_lam_bh.menge, -- MENGE               NUMBER,
                                                                    v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                    v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                    v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                    v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                    v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                    v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                    v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                    v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                    null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                    null ); -- QUELL_LHM_ID        VARCHAR2(20)
                        v_l_zeile_u := v_zeile;
                        get_pick_lte_by_vorgang_id(in_sid, -- in_sid            in isi_sid.sid%type,
                         in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                         v_lam_bh_up.vorg_id, -- in_vorgang_id     in lvs_lam_bh.vorg_id%type
                         v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                         v_abfr_id, -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
                                                   v_lam_bh_up.lte_id); -- in_put_lhm_id     in lvs_lam_bh.lhm_id%type
                        open c_charge_next;
                        fetch c_charge_next into v_charge;
                        close c_charge_next;
                        rueckverfolg_weiter(in_sid, -- in_sid            in isi_sid.sid%type,
                         in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                         v_lam_bh_next.lhm_id, -- in_lhm_id         in lvs_lam_bh.lhm_id%type,
                         v_lam_bh_next.lte_id, -- in_lte_id         in lvs_lte.lte_id%type,
                         v_lam_next.leitzahl, -- in_leitzahl       in lvs_lam_bh.leitzahl%type,
                                            v_charge.charge_bez, -- in_charge_bez     in lvs_charge.charge_bez%type,
                                             v_charge.artikel_id, -- in_artikel_id     in lvs_charge.artikel_id%type,
                                             v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                                             v_abfr_id); -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
                    else
                        exit;
                    end if;

                end loop;
       -- if v_abfr_id is NULL then
       --   v_err_nr := 10;
       --   v_err_text := 'Keine Produktionsdaten für Abgefragte Daten gefunden';
       --   raise v_error;
       -- end if;
                exit;
            else
                if v_pd_prod_vorg_id is null then
                    exit; -- Jetz fertig, Keine Paletten mehr offen
                end if;
                v_pd_prod_vorg_id_l := v_pd_prod_vorg_id;
                if v_abfr_id is null then
                    select
                        seq_bde_pd_rueckverfolgung.nextval
                    into v_abfr_id
                    from
                        dual;

                    v_anz_rueck := v_anz_rueck + 1;
                    if v_anz_rueck > v_max_rueck then
                        v_err_nr := 5;
                        v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                        (v_max_rueck);
                        raise v_error;
                    end if;

                    insert into bde_pd_rueckverf_sel values ( in_sid,
                                                              in_firma_nr,
                                                              sysdate,
                                                              v_abfr_id,
                                                              in_lhm_id,
                                                              in_lte_id,
                                                              in_leitzahl,
                                                              in_charge_bez,
                                                              in_artikel_id,
                                                              'BU',
                                                              null,
                                                              in_li_nr_lief,
                                                              null );

                end if;

                open c_pd_prod_start;
                loop
                    v_pd_prod := null;
                    fetch c_pd_prod_start into v_pd_prod;
                    exit when c_pd_prod_start%notfound;
                    if v_pd_prod.vorg_typ = 'PB' then
                        if v_b_lam_letzte_id != v_pd_prod.lam_id then
                            v_b_lam_letzte_id := v_pd_prod.lam_id;
                            v_zeile := nvl(v_zeile, 0) + 1;
                            v_l_zeile := v_zeile;
                            v_lam := ret_lam_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                            v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                            v_anz_rueck := v_anz_rueck + 1;
                            if v_anz_rueck > v_max_rueck then
                                v_err_nr := 5;
                                v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                                (v_max_rueck);
                                raise v_error;
                            end if;

                            insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                        v_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                        'BB', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                        v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                        null, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                        in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                        v_pd_prod.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                        v_pd_prod.fa_ag, -- FA_AG               NUMBER not null,
                                                                        v_pd_prod.fa_upos, -- FA_UPOS             NUMBER,
                                                                        v_pd_prod.res_id, -- RES_ID              NUMBER not null,
                                                                        v_pd_prod.pers_nr, -- PERS_NR             NUMBER,
                                                                        v_pd_prod.ls_login_id, -- USER_ID             NUMBER,
                                                                        v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                        v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                        v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                        v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                        v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                        v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                        v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                        v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                        v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                        v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                        v_lam_bh.menge, -- MENGE               NUMBER,
                                                                        v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                        v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                        v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                        v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                        v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                        v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                        v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                        v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                        null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                        null ); -- QUELL_LHM_ID        VARCHAR2(20)
                            if v_lam_bh.bus = c.r_lam_bh_bus_zug_komm then
                                get_komm_lte_by_vorgang_id(in_sid, in_firma_nr, v_lam_bh.vorg_id, v_zeile, v_abfr_id);
                            end if;

                        end if;
                    else
                        v_zeile := nvl(v_zeile, 1) + 1;
                        v_lam := ret_lam_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_anz_rueck := v_anz_rueck + 1;
                        if v_anz_rueck > v_max_rueck then
                            v_err_nr := 5;
                            v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                            (v_max_rueck);
                            raise v_error;
                        end if;

                        insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                    v_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                    'BP', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                    v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                    v_l_zeile, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                    in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                    v_lam.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                    v_lam.fa_ag, -- FA_AG               NUMBER not null,
                                                                    v_lam.fa_upos, -- FA_UPOS             NUMBER,
                                                                    v_pd_prod.res_id, -- RES_ID              NUMBER not null,
                                                                    v_pd_prod.pers_nr, -- PERS_NR             NUMBER,
                                                                    v_pd_prod.ls_login_id, -- USER_ID             NUMBER,
                                                                    v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                    v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                    v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                    v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                    v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                    v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                    v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                    v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                    v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                    v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                    v_lam_bh.menge, -- MENGE               NUMBER,
                                                                    v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                    v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                    v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                    v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                    v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                    v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                    v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                    v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                    null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                    null ); -- QUELL_LHM_ID        VARCHAR2(20)
                        open c_charge;
                        fetch c_charge into v_charge;
                        close c_charge;
                        v_l_zeile_u := v_zeile;
                        if v_lam_bh.bus = c.r_lam_bh_bus_zug_komm then
                            get_komm_lte_by_vorgang_id(in_sid, in_firma_nr, v_lam_bh.vorg_id, v_l_zeile_u, v_abfr_id);
                        else
                            vorwaerts_weiter(in_sid, -- in_sid            in isi_sid.sid%type,
                             in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                             v_lam_bh.lhm_id, -- in_lhm_id         in lvs_lam_bh.lhm_id%type,
                             v_lam_bh.lte_id, -- in_lte_id         in lvs_lte.lte_id%type,
                             v_lam.leitzahl, -- in_leitzahl       in lvs_lam_bh.leitzahl%type,
                                             v_charge.charge_bez, -- in_charge_bez     in lvs_charge.charge_bez%type,
                                              v_charge.artikel_id, -- in_artikel_id     in lvs_charge.artikel_id%type,
                                              v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                                              v_abfr_id); -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
                        end if;

                    end if;

                end loop;

                close c_pd_prod_start;
            end if;

        end loop;

    -- Update der Laufzeit um die Gesammt Laufzeit einzelner Abfragen berehcnen zu können
        update bde_pd_rueckverf_sel t
        set
            t.abfr_enddatum = sysdate
        where
            t.abfr_id = v_abfr_id;

        return ( v_abfr_id );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
            if c_pd_prod_start%isopen then
                close c_pd_prod_start;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if c_pd_prod_start%isopen then
                close c_pd_prod_start;
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

    end vorwaerts_create;

  /*************************************************************************************************************************
  Function erstellt Tabelle für die Vorwaertverfolgsung über bestimmte Kriterien und gibt die Nummer der Abfrage zurück
  **************************************************************************************************************************/
    procedure vorwaerts_weiter (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_lhm_id     in lvs_lam_bh.lhm_id%type,
        in_lte_id     in lvs_lte.lte_id%type,
        in_leitzahl   in lvs_lam_bh.leitzahl%type,
        in_charge_bez in lvs_charge.charge_bez%type,
        in_artikel_id in lvs_charge.artikel_id%type,
        in_zeile      in bde_pd_rueckverfolgung.abfr_zeile%type,
        in_abfr_id    in bde_pd_rueckverfolgung.abfr_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr          number;
        v_err_text        varchar2(255);

    -------------------------------------------------------------

        v_pd_prod_vorg_id bde_pd_prod.vorg_id%type;
        v_pd_prod         bde_pd_prod%rowtype;
        v_lam             lvs_lam%rowtype;
        v_lam_bh          lvs_lam_bh%rowtype;
        v_lam_bh_s        lvs_lam_bh%rowtype; -- Um naechsten Eintrag zu lesen.
        v_charge          lvs_charge%rowtype;
        v_l_zeile         number;
        v_l_zeile_u       number;
        v_l_lam_letzte_id lvs_lam_bh.lam_id%type;
        cursor c_pd_prod is
        select
            pd.*
        from
            bde_pd_prod pd
        where
            pd.vorg_id = v_pd_prod_vorg_id
        order by
            pd.vorg_typ,
            pd.vorg_id;

        cursor c_charge is
        select
            *
        from
            lvs_charge c
        where
                c.sid = in_sid
            and c.charge_id = v_lam.charge_id;

    begin
        v_lam_bh_s := null;
        v_lam_letzte_id := 0;
        v_pd_prod_vorg_id := 0;
        v_l_lam_letzte_id := 0;
        loop
            v_lam_letzte_id := v_l_lam_letzte_id;
            v_pd_prod_vorg_id := find_pd_vorgang_id(in_sid, --            in isi_sid.sid%type,
             in_firma_nr, --       in isi_firma.firma_nr%type,
             in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
             in_lte_id, --         in lvs_lte.lte_id%type,
             null, --       in lvs_lam_bh.leitzahl%type,
                                                    in_charge_bez, --     in lvs_charge.charge_bez%type,
                                                     in_artikel_id, --    in lvs_charge.artikel_id%type
                                                     null, null, v_pd_prod_vorg_id,
                                                    v_lam_bh_s, 'PB', false);

            v_l_lam_letzte_id := v_lam_letzte_id;
            if v_pd_prod_vorg_id is null then
                exit; -- Hier ist keine Vorproduktion mehr
            else
                v_l_zeile := in_zeile;
                open c_pd_prod;
                loop
                    v_pd_prod := null;
                    fetch c_pd_prod into v_pd_prod;
                    exit when c_pd_prod%notfound;
                    if v_pd_prod.vorg_typ = 'PB' then
                        v_zeile := nvl(v_zeile, 1) + 1;
                        v_lam := ret_lam_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_anz_rueck := v_anz_rueck + 1;
                        if v_anz_rueck > v_max_rueck then
                            v_err_nr := 5;
                            v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                            (v_max_rueck);
                            raise v_error;
                        end if;

                        insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                    in_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                    'BB', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                    v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                    v_l_zeile, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                    in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                    v_pd_prod.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                    v_pd_prod.fa_ag, -- FA_AG               NUMBER not null,
                                                                    v_pd_prod.fa_upos, -- FA_UPOS             NUMBER,
                                                                    v_pd_prod.res_id, -- RES_ID              NUMBER not null,
                                                                    v_pd_prod.pers_nr, -- PERS_NR             NUMBER,
                                                                    v_pd_prod.ls_login_id, -- USER_ID             NUMBER,
                                                                    v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                    v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                    v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                    v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                    v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                    v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                    v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                    v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                    v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                    v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                    v_lam_bh.menge, -- MENGE               NUMBER,
                                                                    v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                    v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                    v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                    v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                    v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                    v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                    v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                    v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                    null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                    null ); -- QUELL_LHM_ID        VARCHAR2(20)
                        if v_lam_bh.bus = c.r_lam_bh_bus_zug_komm then
                            get_komm_lte_by_vorgang_id(in_sid, in_firma_nr, v_lam_bh.vorg_id, v_zeile, in_abfr_id);
                        end if;

                    else
                        v_zeile := nvl(v_zeile, 1) + 1;
                        v_lam := ret_lam_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_lam_bh := ret_lam_bh_v(in_sid, in_firma_nr, v_pd_prod.lam_id);
                        v_anz_rueck := v_anz_rueck + 1;
                        if v_anz_rueck > v_max_rueck then
                            v_err_nr := 5;
                            v_err_text := 'Ergebnissmenge zu groß, bitte genauer einschrenken. Maximale Anzahl ist (MAX_RUECKVERFOLGUNG): ' || to_char
                            (v_max_rueck);
                            raise v_error;
                        end if;

                        insert into bde_pd_rueckverfolgung values ( in_sid, -- SID                 VARCHAR2(2) not null,
                                                                    in_abfr_id, -- ABFR_ID             NUMBER not null,
                                                                    'BP', -- ABFR_TYP            VARCHAR2(2) not null,
                                                                    v_zeile, -- ABFR_ZEILE          NUMBER,
                                                                    v_l_zeile, -- ABFR_PARENT_ZEILE   NUMBER,
                                                                    in_firma_nr, -- FIRMA_NR            NUMBER(2) not null,
                                                                    v_pd_prod.leitzahl, -- LEITZAHL            NUMBER not null,
                                                                    v_pd_prod.fa_ag, -- FA_AG               NUMBER not null,
                                                                    v_pd_prod.fa_upos, -- FA_UPOS             NUMBER,
                                                                    v_pd_prod.res_id, -- RES_ID              NUMBER not null,
                                                                    v_pd_prod.pers_nr, -- PERS_NR             NUMBER,
                                                                    v_pd_prod.ls_login_id, -- USER_ID             NUMBER,
                                                                    v_pd_prod.lam_id, -- LAM_ID              NUMBER,
                                                                    v_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
                                                                    v_lam.charge_id, -- CHANGE_ID           NUMBER,
                                                                    v_lam.serie_id, -- SERIE_ID            NUMBER,
                                                                    v_lam.best_nr, -- BEST_NR             VARCHAR2(20),
                                                                    v_lam.best_pos, -- BEST_POS            VARCHAR2(5),
                                                                    v_lam.prod_datum, -- PROD_DATUM          DATE,
                                                                    v_lam.zug_datum, -- ZUG_DATUM           DATE,
                                                                    v_lam_bh.lte_id, -- LTE_ID              VARCHAR2(19),
                                                                    v_lam_bh.lhm_id, -- LHM_ID              VARCHAR2(19),
                                                                    v_lam_bh.menge, -- MENGE               NUMBER,
                                                                    v_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                                                                    v_lam_bh.lam_bh_kg, -- GEWICHT_KG          NUMBER,
                                                                    v_lam.zeichnung, -- ZEICHNUNG           VARCHAR2(255),
                                                                    v_lam.zeichnung_index, -- ZEICHNUNG_INDEX     VARCHAR2(10),
                                                                    v_lam.li_nr_lief, -- LI_NR_LIEF          VARCHAR2(20)
                                                                    v_lam.lieferant_nr, -- Lieferantennummer (Anlieferung)
                                                                    v_lam.lte_id_lieferant, -- LTE_ID_LIEFERANT    VARCHAR2(20),
                                                                    v_lam.sonst_id_lieferant, -- SONST_ID_LIEFERANT  VARCHAR2(20)
                                                                    null, -- QUELL_LTE_ID        VARCHAR2(20)
                                                                    null ); -- QUELL_LHM_ID        VARCHAR2(20)
                        open c_charge;
                        fetch c_charge into v_charge;
                        close c_charge;
                        v_l_zeile_u := v_zeile;
                        if v_lam_bh.bus = c.r_lam_bh_bus_zug_komm then
                            get_komm_lte_by_vorgang_id(in_sid, in_firma_nr, v_lam_bh.vorg_id, v_l_zeile_u, in_abfr_id);
                        else
                            vorwaerts_weiter(in_sid, -- in_sid            in isi_sid.sid%type,
                             in_firma_nr, -- in_firma_nr       in isi_firma.firma_nr%type,
                             v_lam_bh.lhm_id, -- in_lhm_id         in lvs_lam_bh.lhm_id%type,
                             v_lam_bh.lte_id, -- in_lte_id         in lvs_lte.lte_id%type,
                             v_lam.leitzahl, -- in_leitzahl       in lvs_lam_bh.leitzahl%type,
                                             v_charge.charge_bez, -- in_charge_bez     in lvs_charge.charge_bez%type,
                                              v_charge.artikel_id, -- in_artikel_id     in lvs_charge.artikel_id%type,
                                              v_l_zeile_u, -- in_zeile          in bde_pd_rueckverfolgung.abfr_zeile%type
                                              in_abfr_id); -- in_abfr_id        in bde_pd_rueckverfolgung.abfr_id%type
                        end if;

                    end if;

                end loop;

                close c_pd_prod;
            end if;

        end loop;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
            if c_pd_prod%isopen then
                close c_pd_prod;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if c_pd_prod%isopen then
                close c_pd_prod;
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

    end vorwaerts_weiter;

  /*************************************************************************************************************************
    Fuktion sucht Buchung Zugang dieser LAM
  **************************************************************************************************************************/
    function find_lam_bh_buch (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_lhm_id      in lvs_lam_bh.lhm_id%type,
        in_lte_id      in lvs_lte.lte_id%type,
        in_leitzahl    in lvs_lam_bh.leitzahl%type,
        in_charge_bez  in lvs_charge.charge_bez%type,
        in_artikel_id  in lvs_charge.artikel_id%type,
        in_vorg_type   in bde_pd_prod.vorg_typ%type,
        in_li_nr_lief  in lvs_lam.li_nr_lief%type,
        in_order_li_nr in isi_order_pos.li_nr%type
    ) return lvs_lam_bh%rowtype is

        v_lam_bh     lvs_lam_bh%rowtype;
        v_charge     lvs_charge%rowtype;
        v_sql_querry varchar(4000);
        v_add_where  boolean;                 -- Kenner ob eine where Bedingung gesetzt wurde

        type t_curs is ref cursor;
        c_lam_bh     t_curs;
        cursor c_charge is
        select
            *
        from
            lvs_charge ch
        where
                ch.charge_bez = in_charge_bez
            and ch.artikel_id = in_artikel_id;

    begin
        v_lam_bh := null;
        v_add_where := false;                   -- Default false

    --  -AG- Wegen geänderten Index
    --  v_sql_querry := 'select bh.* from lvs_v_lam_bh bh where bh.bus = decode(''' || in_vorg_type || ''', ''PP'', ' ||  c.R_LAM_BH_BUS_ZUG || ', ' || c.R_LAM_BH_BUS_ABG || ') ';

        --    v_sql_querry := 'select bh.* from lvs_v_lam_bh bh where bh.sid = ''' || in_sid ||
    --                    ''' and bh.firma_nr = ' || in_firma_nr ||
    --                    ' and bh.bus = decode(''' || in_vorg_type || ''', ''PP'', ' ||  c.R_LAM_BH_BUS_ZUG || ', ' || c.R_LAM_BH_BUS_ABG || ') ';
        if in_li_nr_lief is not null then
            v_sql_querry := 'select bh.* from lvs_v_lam lam left join lvs_v_lam_bh bh on bh.LAM_ID = lam.LAM_ID where bh.bus = decode('''
                            || in_vorg_type
                            || ''', ''PP'', '
                            || c.r_lam_bh_bus_zug
                            || ', ''UP'', '
                            || c.r_lam_bh_bus_up
                            || ', '
                            || c.r_lam_bh_bus_abg
                            || ') ';
        else
            if in_order_li_nr is not null then
                v_sql_querry := 'select bh.* from lvs_v_lam_bh bh left join isi_liefs li on li.lam_id = bh.LAM_ID where bh.bus = decode('''
                                || in_vorg_type
                                || ''', ''PP'', '
                                || c.r_lam_bh_bus_zug
                                || ', ''UP'', '
                                || c.r_lam_bh_bus_up
                                || ', '
                                || c.r_lam_bh_bus_abg
                                || ') ';

            else
                v_sql_querry := 'select bh.* from lvs_v_lam_bh bh where bh.bus = decode('''
                                || in_vorg_type
                                || ''', ''PP'', '
                                || c.r_lam_bh_bus_zug
                                || ', ''UP'', '
                                || c.r_lam_bh_bus_up
                                || ', '
                                || c.r_lam_bh_bus_abg
                                || ') ';
            end if;
        end if;

        if in_lhm_id is not null then
            v_sql_querry := v_sql_querry
                            || ' and bh.lhm_id = '''
                            || in_lhm_id
                            || '''';
            v_add_where := true;
        end if;

        if in_lte_id is not null then
            v_sql_querry := v_sql_querry
                            || ' and bh.lte_id = '''
                            || in_lte_id
                            || '''';
            v_add_where := true;
        end if;

        if in_leitzahl is not null then
            v_sql_querry := v_sql_querry
                            || ' and bh.leitzahl = '
                            || in_leitzahl;
            if v_lam_letzte_id > 0 then
                v_sql_querry := v_sql_querry || ' and bh.fa_ag is NULL';
            end if;
            v_add_where := true;
        end if;

        if in_charge_bez is not null then
            if in_artikel_id is not null then
                v_sql_querry := v_sql_querry
                                || ' and bh.artikel_id = '
                                || in_artikel_id;
            end if;

            open c_charge;
            fetch c_charge into v_charge;
            v_sql_querry := v_sql_querry
                            || ' and bh.charge_id in ('
                            || v_charge.charge_id;
            loop
                fetch c_charge into v_charge;
                exit when c_charge%notfound;
                v_sql_querry := v_sql_querry
                                || ' ,'
                                || v_charge.charge_id;
            end loop;

            close c_charge;
            v_sql_querry := v_sql_querry || ')';
            v_add_where := true;
        end if;

        if in_li_nr_lief is not null then
            if v_add_where = true then
                v_sql_querry := v_sql_querry
                                || ' and (lam.li_nr_lief = '''
                                || in_li_nr_lief
                                || ''' or lam.li_nr_lief is null)';
            else
                v_sql_querry := v_sql_querry
                                || ' and lam.li_nr_lief = '''
                                || in_li_nr_lief
                                || '''';
            end if;

            v_add_where := true;
        end if;

        if in_order_li_nr is not null then
            if v_add_where = true then
                v_sql_querry := v_sql_querry
                                || ' and (li.li_nr = '
                                || in_order_li_nr
                                || ' or li.li_nr is null)';
            else
                v_sql_querry := v_sql_querry
                                || ' and li.li_nr = '
                                || in_order_li_nr;
            end if;

            v_add_where := true;
        end if;

        if
            v_lam_letzte_id is not null
            and v_lam_letzte_id <> 0
        then
            v_sql_querry := v_sql_querry
                            || ' and nvl(bh.lam_id, '
                            || v_lam_letzte_id
                            || ') > '
                            || v_lam_letzte_id;
            v_add_where := true;
        end if;

        if in_lte_id is not null
           or in_lhm_id is not null then
     --  v_sql_querry := v_sql_querry || ' order by bh.lam_id desc';
            v_sql_querry := v_sql_querry || ' order by bh.fa_ag desc,bh.lam_id asc';
        else
            v_sql_querry := v_sql_querry || ' order by bh.lam_id asc';
        end if;

    -- Wurde überhaupt eine where Bedingung gesetzt?
        if v_add_where = true then
            if v_lam_letzte_id is not null then
                open c_lam_bh for v_sql_querry;

                fetch c_lam_bh into v_lam_bh;
                close c_lam_bh;
                v_lam_letzte_id := v_lam_bh.lam_id;
            end if;
        end if;

        return v_lam_bh;
    end find_lam_bh_buch;

  /*************************************************************************************************************************
    Fuktion gibt die Vorgangs_ID von der Produktion eines LAM's zurueck
  **************************************************************************************************************************/
    function find_pd_vorgang_id (
        in_sid             in isi_sid.sid%type,
        in_firma_nr        in isi_firma.firma_nr%type,
        in_lhm_id          in lvs_lam_bh.lhm_id%type,
        in_lte_id          in lvs_lte.lte_id%type,
        in_leitzahl        in lvs_lam_bh.leitzahl%type,
        in_charge_bez      in lvs_charge.charge_bez%type,
        in_artikel_id      in lvs_charge.artikel_id%type,
        in_li_nr_lief      in lvs_lam.li_nr_lief%type,
        in_order_li_nr     in isi_order_pos.li_nr%type,
        in_vorg_id         in bde_pd_prod.vorg_id%type,
        in_out_lam_bh      in out lvs_lam_bh%rowtype,
        in_vorg_type       in bde_pd_prod.vorg_typ%type,
        in_test_for_abgang in boolean
    ) return number is

        v_pd_prod bde_pd_prod%rowtype;
        v_vorg_id bde_pd_prod.vorg_id%type; -- NEU 2016.06.10
        v_lam_id  lvs_lam.lam_id%type;
        cursor c_pd_prod is
        select
            *
        from
            bde_pd_prod pd
        where
                pd.sid = in_sid
            and pd.firma_nr = in_firma_nr
            and pd.lam_id = in_out_lam_bh.lam_id
            and pd.vorg_typ = in_vorg_type
            and pd.vorg_id > v_vorg_id -- NEU 2016.06.10
      -- and pd.vorg_id > in_vorg_id    -- NEU 2016.06.10
        order by
            pd.vorg_id;

    begin
        v_vorg_id := in_vorg_id; -- NEU 2016.06.10
        v_lam_letzte_id_abgang := in_out_lam_bh.lam_id;
        loop
            v_pd_prod.vorg_id := null;
            v_lam_id := v_lam_letzte_id_abgang;
            if in_out_lam_bh.lam_id is null
               or in_vorg_type != 'PB' then
                in_out_lam_bh := find_lam_bh_buch(in_sid, --            in isi_sid.sid%type,
                 in_firma_nr, --       in isi_firma.firma_nr%type,
                 in_lhm_id, --         in lvs_lam_bh.lhm_id%type,
                 in_lte_id, --         in lvs_lte.lte_id%type,
                 in_leitzahl, --       in lvs_lam_bh.leitzahl%type,
                                                  in_charge_bez, --     in lvs_charge.charge_bez%type,
                                                   in_artikel_id, --    in lvs_charge.artikel_id%type
                                                   in_vorg_type, in_li_nr_lief, in_order_li_nr); --    in bde_pd_prod.vorg_typ%type
            end if;

            if in_out_lam_bh.lam_id is not null then
                open c_pd_prod;
                fetch c_pd_prod into v_pd_prod;
                close c_pd_prod;
            else
                if in_test_for_abgang then
                    in_out_lam_bh := ret_lam_bh_v_abgang(in_sid, in_firma_nr, in_lte_id, in_lhm_id, v_lam_id,
                                                         in_vorg_type);
                    if in_out_lam_bh.lam_id is not null then
                        v_lam_letzte_id_abgang := in_out_lam_bh.lam_id;
                        open c_pd_prod;
                        fetch c_pd_prod into v_pd_prod;
                        close c_pd_prod;
                    end if;

                end if;
            end if;
      -- Nichts gefunden, wenn nicht vom Rohstoff gesucht wird dann FERTIG
            if
                v_pd_prod.vorg_id is null
                and in_vorg_type = 'PB'
                and in_out_lam_bh.lam_id is not null
            then
                in_out_lam_bh.lam_id := null;
        -- NEU 2016.06.10
                v_vorg_id := 0; -- für neue LAM in PD wieder wieder von vorne suchen
            else
                exit;
            end if;

        end loop;

        return v_pd_prod.vorg_id;
    end find_pd_vorgang_id;

  /*************************************************************************************************************************
    Fuktion den LAM-Satz zurück
  **************************************************************************************************************************/
    function ret_lam_v (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lam_id   in lvs_lam.lam_id%type
    ) return lvs_lam%rowtype is

        v_lam lvs_lam%rowtype;
        cursor c_lam_v is
        select /*+ INDEX(lam.pk_lvs_lam lvs_lam) index(lam.pk_lvs_lam_hist lvs_lam_hist) */
            lam.*
        from
            lvs_v_lam lam
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.lam_id = in_lam_id;

    begin
        v_lam := null;
        open c_lam_v;
        fetch c_lam_v into v_lam;
        close c_lam_v;
        return ( v_lam );
    end ret_lam_v;

  /*************************************************************************************************************************
    Fuktion gibt die die Zugangsbuchung eines LAM's zurueck
  **************************************************************************************************************************/
    function ret_lam_bh_v (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lam_id   in lvs_lam.lam_id%type
    ) return lvs_lam_bh%rowtype is

        v_lam_bh lvs_lam_bh%rowtype;
        cursor c_lam_bh_v is
        select /*+ INDEX(bh.IX_LAM_BH_LAM_ID lvs_lam_bh) index(bh.IX_LAM_BH_LAM_ID_hist lvs_lam_bh_hist) */
            bh.*
        from
            lvs_v_lam_bh bh
        where
                bh.lam_id = in_lam_id
            and ( bh.bus = c.r_lam_bh_bus_zug
                  or bh.bus = c.r_lam_bh_bus_zug_komm
                  or bh.bus = c.r_lam_bh_bus_up
                  or bh.bus = c.r_lam_bh_bus_zug_konsi );

    begin
        v_lam_bh := null;
        open c_lam_bh_v;
        fetch c_lam_bh_v into v_lam_bh;
        close c_lam_bh_v;
        return ( v_lam_bh );
    end ret_lam_bh_v;

  -- Created on 05.11.2009 by HJGOEDEKE
    function ret_lam_id_root (
        in_sid    in isi_sid.sid%type,
        in_lam_id in lvs_lam.lam_id%type
    ) return lvs_lam.lam_id%type is

        v_bde_prod    bde_pd_prod%rowtype;
        v_bde_prod_pb bde_pd_prod%rowtype;
        v_lam_id      lvs_lam.lam_id%type;
        v_found       boolean;
        cursor c_bde_prod is
        select
            *
        from
            bde_pd_prod t
        where
                t.lam_id = v_lam_id
            and t.vorg_typ = 'PP';

        cursor c_bde_prod_pb is
        select
            *
        from
            bde_pd_prod t
        where
                t.vorg_id = v_bde_prod.vorg_id
            and t.vorg_typ = 'PB';

        cursor c_lam is
        select
            *
        from
            lvs_lam t
        where
            t.lam_id = v_bde_prod_pb.lam_id;

    begin
    -- Test statements here
        v_lam_id := in_lam_id;
        open c_bde_prod;
        fetch c_bde_prod into v_bde_prod;
        v_found := c_bde_prod%found;
        close c_bde_prod;
        v_bde_prod_pb := null;
        if v_found then
            loop
                open c_bde_prod_pb;
                fetch c_bde_prod_pb into v_bde_prod_pb;
                v_found := c_bde_prod_pb%found;
                close c_bde_prod_pb;
                if not v_found then
                    exit;
                end if;
                v_lam_id := v_bde_prod_pb.lam_id;
                open c_bde_prod;
                fetch c_bde_prod into v_bde_prod;
                v_found := c_bde_prod%found;
                close c_bde_prod;
                if not v_found then
                    exit;
                end if;
            end loop;
        end if;

        return v_bde_prod_pb.lam_id;
    end;

    procedure get_komm_lte_by_vorgang_id (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_vorgang_id in lvs_lam_bh.vorg_id%type,
        in_zeile      in bde_pd_rueckverfolgung.abfr_zeile%type,
        in_abfr_id    in bde_pd_rueckverfolgung.abfr_id%type
    ) is

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);

    -------------------------------------------------------------------------------------------------------

        v_lam_bh   lvs_lam_bh%rowtype;
        v_lam      lvs_lam%rowtype;
        v_found    boolean;
        cursor c_komm_lte_lam_bh is
        select
            bh.*
        from
            lvs_lam_bh bh
        where
                bh.vorg_id = in_vorgang_id
            and bh.bus = c.r_lam_bh_bus_abg_komm;

        cursor c_komm_lte_lam_bh_hist is
        select
            bh.*
        from
            lvs_lam_bh_hist bh
        where
                bh.vorg_id = in_vorgang_id
            and bh.bus = c.r_lam_bh_bus_abg_komm;

    begin
        if in_vorgang_id is not null then
            open c_komm_lte_lam_bh;
            fetch c_komm_lte_lam_bh into v_lam_bh;
            v_found := c_komm_lte_lam_bh%found;
            close c_komm_lte_lam_bh;
            if v_found then
                v_lam := ret_lam_v(in_sid, in_firma_nr, v_lam_bh.lam_id);
                update bde_pd_rueckverfolgung rueck
                set
                    rueck.quell_lte_id = v_lam_bh.lte_id,
                    rueck.quell_lhm_id = v_lam_bh.lhm_id,
                    rueck.res_id = nvl(rueck.res_id, v_lam_bh.res_id)
                where
                        rueck.abfr_id = in_abfr_id
                    and rueck.abfr_zeile = in_zeile
                    and rueck.sid = in_sid
                    and rueck.firma_nr = in_firma_nr;

            else
                open c_komm_lte_lam_bh_hist;
                fetch c_komm_lte_lam_bh_hist into v_lam_bh;
                v_found := c_komm_lte_lam_bh_hist%found;
                close c_komm_lte_lam_bh_hist;
                if v_found then
                    v_lam := ret_lam_v(in_sid, in_firma_nr, v_lam_bh.lam_id);
                    update bde_pd_rueckverfolgung rueck
                    set
                        rueck.quell_lte_id = v_lam_bh.lte_id,
                        rueck.quell_lhm_id = v_lam_bh.lhm_id,
                        rueck.res_id = nvl(rueck.res_id, v_lam_bh.res_id)
                    where
                            rueck.abfr_id = in_abfr_id
                        and rueck.abfr_zeile = in_zeile
                        and rueck.sid = in_sid
                        and rueck.firma_nr = in_firma_nr;

                end if;

            end if;

        end if;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end get_komm_lte_by_vorgang_id;

    procedure get_pick_lte_by_vorgang_id (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_vorgang_id in lvs_lam_bh.vorg_id%type,
        in_zeile      in bde_pd_rueckverfolgung.abfr_zeile%type,
        in_abfr_id    in bde_pd_rueckverfolgung.abfr_id%type,
        in_put_lte_id in lvs_lam_bh.lte_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);

    -------------------------------------------------------------------------------------------------------

        v_lam_bh   lvs_lam_bh%rowtype;
        v_lam      lvs_lam%rowtype;
        v_found    boolean;
        cursor c_pick_lte_lam_bh is
        select
            bh.*
        from
            lvs_lam_bh bh
        where
                bh.vorg_id = in_vorgang_id
            and bh.bus = c.r_lam_bh_bus_up
            and bh.lte_id <> in_put_lte_id;

        cursor c_pick_lte_lam_bh_hist is
        select
            bh.*
        from
            lvs_lam_bh_hist bh
        where
                bh.vorg_id = in_vorgang_id
            and bh.bus = c.r_lam_bh_bus_up
            and bh.lte_id <> in_put_lte_id;

    begin
        if
            in_vorgang_id is not null
            and in_put_lte_id is not null
        then
            open c_pick_lte_lam_bh;
            fetch c_pick_lte_lam_bh into v_lam_bh;
            v_found := c_pick_lte_lam_bh%found;
            close c_pick_lte_lam_bh;
            if v_found then
                v_lam := ret_lam_v(in_sid, in_firma_nr, v_lam_bh.lam_id);
                update bde_pd_rueckverfolgung rueck
                set
                    rueck.quell_lte_id = v_lam_bh.lte_id,
                    rueck.quell_lhm_id = v_lam_bh.lhm_id,
                    rueck.res_id = nvl(rueck.res_id, v_lam_bh.res_id)
                where
                        rueck.abfr_id = in_abfr_id
                    and rueck.abfr_zeile = in_zeile
                    and rueck.sid = in_sid
                    and rueck.firma_nr = in_firma_nr;

            else
                open c_pick_lte_lam_bh_hist;
                fetch c_pick_lte_lam_bh_hist into v_lam_bh;
                v_found := c_pick_lte_lam_bh_hist%found;
                close c_pick_lte_lam_bh_hist;
                if v_found then
                    v_lam := ret_lam_v(in_sid, in_firma_nr, v_lam_bh.lam_id);
                    update bde_pd_rueckverfolgung rueck
                    set
                        rueck.quell_lte_id = v_lam_bh.lte_id,
                        rueck.quell_lhm_id = v_lam_bh.lhm_id,
                        rueck.res_id = nvl(rueck.res_id, v_lam_bh.res_id)
                    where
                            rueck.abfr_id = in_abfr_id
                        and rueck.abfr_zeile = in_zeile
                        and rueck.sid = in_sid
                        and rueck.firma_nr = in_firma_nr;

                end if;

            end if;

        end if;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end get_pick_lte_by_vorgang_id;

    function ret_lam_bh_pick_by_vorgang_id (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_vorgang_id in lvs_lam_bh.vorg_id%type,
        in_put_lte_id in lvs_lam_bh.lte_id%type
    ) return lvs_lam_bh%rowtype is

        v_lam_bh lvs_lam_bh%rowtype;
        v_lam    lvs_lam%rowtype;
        v_found  boolean;
        cursor c_pick_lte_lam_bh is
        select
            bh.*
        from
            lvs_lam_bh bh
        where
                bh.vorg_id = in_vorgang_id
            and bh.bus = c.r_lam_bh_bus_up
            and bh.lte_id <> in_put_lte_id;

        cursor c_pick_lte_lam_bh_hist is
        select
            bh.*
        from
            lvs_lam_bh_hist bh
        where
                bh.vorg_id = in_vorgang_id
            and bh.bus = c.r_lam_bh_bus_up
            and bh.lte_id <> in_put_lte_id;

    begin
        v_lam_bh := null;
        if
            in_vorgang_id is not null
            and in_put_lte_id is not null
        then
            open c_pick_lte_lam_bh;
            fetch c_pick_lte_lam_bh into v_lam_bh;
            v_found := c_pick_lte_lam_bh%found;
            close c_pick_lte_lam_bh;
            if not v_found then
                open c_pick_lte_lam_bh_hist;
                fetch c_pick_lte_lam_bh_hist into v_lam_bh;
                v_found := c_pick_lte_lam_bh_hist%found;
                close c_pick_lte_lam_bh_hist;
            end if;

        end if;

        return ( v_lam_bh );
    end ret_lam_bh_pick_by_vorgang_id;

/*************************************************************************************************************************
    Fuktion gibt gibt eine lam zurück, die aus einer eingegeben Quelle entnommen wurde
 **************************************************************************************************************************/
    function ret_lam_bh_v_abgang (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_lte_id    in lvs_lam.lte_id%type,
        in_lhm_id    in lvs_lam.lhm_id%type,
        in_lam_id    in lvs_lam_bh.lam_id%type,
        in_vorg_type in bde_pd_prod.vorg_typ%type
    ) return lvs_lam_bh%rowtype is

        v_lam_bh_ret lvs_lam_bh%rowtype;
        v_lte_id     lvs_lam.lte_id%type;
        v_lam_id     lvs_lam.lam_id%type;
        v_found      boolean;
        cursor c_lam_bh_v is
        select
            bh.lte_id,
            bh.lam_id
        from
            lvs_v_lam_bh bh,
            (
                select
                    x.vorg_id,
                    x.lte_id
                from
                    lvs_v_lam_bh x
                where
                    ( x.lte_id = nvl(in_lte_id, 0)
                      or x.lam_id = nvl(in_lhm_id, 0) )
                    and ( x.bus = c.r_lam_bh_bus_abg
                          or x.bus = c.r_lam_bh_bus_abg_komm
                          or x.bus = c.r_lam_bh_bus_up )
            )            y
        where
                bh.vorg_id = y.vorg_id
            and bh.lte_id <> y.lte_id
            and bh.lam_id > nvl(v_lam_id, 0)
            and ( bh.bus = c.r_lam_bh_bus_zug
                  or bh.bus = c.r_lam_bh_bus_zug_komm
                  or bh.bus = c.r_lam_bh_bus_up )
        order by
            bh.lam_id asc;

    begin
        v_lam_bh_ret := null;
        v_lte_id := null;
        v_lam_id := in_lam_id;
        loop
            open c_lam_bh_v;
            fetch c_lam_bh_v into
                v_lte_id,
                v_lam_id;
            v_found := c_lam_bh_v%found;
            close c_lam_bh_v;
            if v_found then
                if v_lam_letzte_id is null then
                    v_lam_letzte_id := 1;
                end if;
                v_lam_bh_ret := find_lam_bh_buch(in_sid, --            in isi_sid.sid%type,
                 in_firma_nr, --       in isi_firma.firma_nr%type,
                 null, --         in lvs_lam_bh.lhm_id%type,
                 v_lte_id, --         in lvs_lte.lte_id%type,
                 null, --       in lvs_lam_bh.leitzahl%type,
                                                 null, --     in lvs_charge.charge_bez%type,
                                                  null, --    in lvs_charge.artikel_id%type
                                                  in_vorg_type, null, null); --    in bde_pd_prod.vorg_typ%type
            else
                exit;
            end if;

            if v_lam_bh_ret.lte_id is not null then
                exit;
            end if;
        end loop;

        return ( v_lam_bh_ret );
    end ret_lam_bh_v_abgang;

end bde_rueckverfolg;
/


-- sqlcl_snapshot {"hash":"e7fb641b4eefe4be837fcc09bd50a93432b7a37d","type":"PACKAGE_BODY","name":"BDE_RUECKVERFOLG","schemaName":"DIRKSPZM32","sxml":""}