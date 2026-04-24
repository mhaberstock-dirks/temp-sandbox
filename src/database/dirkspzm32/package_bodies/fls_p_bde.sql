create or replace package body dirkspzm32.fls_p_bde is

    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
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

	-------------------------------------------------------------------------------------------------------
	-- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
	-------------------------------------------------------------------------------------------------------
    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end;

	-------------------------------------------------------------------------------------------------------
	-- Nächsten FA holen, der Verarbeitet werden kann
	-------------------------------------------------------------------------------------------------------
    function get_next_new_fa (
        out_fa_nr out bde_fa_auftrag.leitzahl%type
    ) return varchar2 is

        v_result varchar2(1);
        cursor c_bde_fa_auftr is
        select
            t.fa_nr
        from
            bde_fa_kopf t
        where
            t.status = 'N'
        order by
            t.termin_soll_start,
            t.fa_nr;

        v_found  boolean;
    begin
        v_result := c.c_false;
        out_fa_nr := null;
        open c_bde_fa_auftr;
        fetch c_bde_fa_auftr into out_fa_nr;
        v_found := c_bde_fa_auftr%found;
        close c_bde_fa_auftr;
        if
            v_found
            and out_fa_nr is not null
        then
            v_result := c.c_true;
        end if;
        return ( v_result );
    end;

	-------------------------------------------------------------------------------------------------------
	-- Nächsten FA holen, der Verarbeitet werden kann und als Begonnen kennzeichnen
	-------------------------------------------------------------------------------------------------------
    function c_start_next_new_fa (
        in_sid      in bde_fa_kopf.sid%type,
        in_firma_nr in bde_fa_kopf.firma_nr%type,
        out_fa_nr   out bde_fa_kopf.fa_nr%type
    ) return varchar2 is
        v_result varchar2(1);
    begin
        v_result := get_next_new_fa(out_fa_nr);
        if v_result = c.c_true then
      -- Status im Kopf nachziehen
            update bde_fa_kopf t
            set
                t.status = 'B'
            where
                    t.fa_nr = out_fa_nr
                and t.firma_nr = in_firma_nr
                and t.sid = in_sid
                and t.status = 'N';

            if sql%rowcount = 0 then
        -- wenn der Status nicht gesetzt werden konnte,
        -- können wir disen Auftrag jetzt gerade nicht bearbeiten.
        -- Nach einem nagtiven Result wird die Anwendung wieder versuchen, den
        -- nächsten Auftrag zu aktivieren.
                v_result := c.c_false;
            end if;
        end if;

        commit;
        return ( v_result );
    exception
        when others then
      -- do rollback here, before the application gets the exception
            rollback;
            raise;
    end c_start_next_new_fa;

	-------------------------------------------------------------------------------------------------------
	-- Fertigungsbeginn des FA_AG anmelden. Buchung in "bde_pd_prod".
	-------------------------------------------------------------------------------------------------------
    procedure c_fa_ag_anmelden (
        in_sid      in bde_fa_auftrag.sid%type,
        in_firma_nr in bde_fa_auftrag.firma_nr%type,
        in_fa_nr    in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_fa_upos  in bde_fa_auftrag.fa_upos%type,
        in_res_id   in isi_resource.res_id%type,
        in_ip_name  in isi_arbeitsplatz.ip_name%type,
        in_login_id in isi_user.login_id%type,
        out_vorg_id out bde_pd_prod.vorg_id%type
    ) is
    begin
        out_vorg_id := bde_pd_prod_p_ag_b_f(in_sid, -- in isi_sid.sid%type,
         in_firma_nr, -- in isi_firma.firma_nr%type,
         in_fa_nr, -- in bde_fa_auftrag.leitzahl%type,
         in_fa_ag, -- in bde_fa_auftrag.fa_ag%type,
         in_fa_upos, -- in bde_fa_auftrag.fa_upos%type,
                                            in_res_id, -- in isi_resource.res_id%type,
                                             in_ip_name, -- in isi_arbeitsplatz.ip_name%type,
                                             in_login_id); -- in isi_user.login_id%type)
        commit;
    exception
        when others then
      -- do rollback here, before the application gets the exception
            rollback;
            raise;
    end c_fa_ag_anmelden;

	-------------------------------------------------------------------------------------------------------
	-- Fertigung des FA_AG abmelden. Buchung in "bde_pd_prod".
	-- Ob der AG komplett fertig ist, kann mit "soll_menge = ist_menge" geprüft werden.
	-- D.h. "Abmelden" ist nicht zwangläufig "Fertigmelden"
	-------------------------------------------------------------------------------------------------------
    procedure c_fa_ag_abmelden (
        in_sid           in bde_fa_auftrag.sid%type,
        in_firma_nr      in bde_fa_auftrag.firma_nr%type,
        in_fa_nr         in bde_fa_auftrag.leitzahl%type,
        in_fa_ag         in bde_fa_auftrag.fa_ag%type,
        in_fa_upos       in bde_fa_auftrag.fa_upos%type,
        in_res_id        in isi_resource.res_id%type,
        in_login_id      in isi_user.login_id%type,
        in_menge_a       in bde_pd_prod.menge_a%type,
        in_menge_b       in bde_pd_prod.menge_b%type,
        in_menge_schrott in bde_pd_prod.schrott%type
    ) is
    begin
        bde_pd_prod_p_ag_e(in_sid, -- in_sid         in isi_sid.sid%type,
         in_firma_nr, -- in_firma_nr    in isi_firma.firma_nr%type,
         in_fa_nr, -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
         in_fa_ag, -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
         in_fa_upos, -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                           in_res_id, -- in_res_id      in isi_resource.res_id%type,
                            sysdate, -- in_sysdate     date,
                            in_menge_a, -- in_menge_a     in bde_pd_prod.menge_a%type,
                            in_menge_b, -- in_menge_b     in bde_pd_prod.menge_b%type,
                            in_menge_schrott, -- in_schrott     in bde_pd_prod.schrott%type,
                           in_login_id); -- in_ls_login_id in isi_user.login_id%type) is
        commit;
    exception
        when others then
      -- do rollback here, before the application gets the exception
            rollback;
            raise;
    end c_fa_ag_abmelden;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fa_ag_menge_buchen (
        in_sid           in bde_fa_auftrag.sid%type,
        in_firma_nr      in bde_fa_auftrag.firma_nr%type,
        in_vorg_typ      in bde_pd_prod.vorg_typ%type,
        in_fa_nr         in bde_fa_auftrag.leitzahl%type,
        in_fa_ag         in bde_fa_auftrag.fa_ag%type,
        in_fa_upos       in bde_fa_auftrag.fa_upos%type,
        in_res_id        in isi_resource.res_id%type,
        in_login_id      in isi_user.login_id%type,
        in_menge_a       in bde_pd_prod.menge_a%type,
        in_menge_b       in bde_pd_prod.menge_b%type,
        in_menge_schrott in bde_pd_prod.schrott%type,
        in_fae_id        in bde_pd_prod.fae_id%type,
        in_fae_id_pos    in bde_pd_prod.fae_id_position%type
    ) is
        v_res_zust_akt isi_resource_zust_akt%rowtype;
    begin
        if not isi_p_base.get_res_zust_akt(in_sid, in_res_id, v_res_zust_akt) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_resourcenzustand_fehlt, in_res_id));
        end if;

        bde_pd_prod_insert(in_sid, in_vorg_typ, --'PP',

         in_firma_nr, null, -- in_barcode

         in_fa_nr,
                           in_fa_ag, in_fa_upos, in_res_id, v_res_zust_akt.pers_nr, in_menge_a,
                           in_menge_b, in_menge_schrott, in_login_id, in_fae_id, in_fae_id_pos,
                           null);

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
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

    end c_fa_ag_menge_buchen;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fa_ag_bereit (
        in_sid      in bde_fa_auftrag.sid%type,
        in_firma_nr in bde_fa_auftrag.firma_nr%type,
        in_fa_nr    in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_fa_upos  in bde_fa_auftrag.fa_upos%type,
        in_login_id in isi_user.login_id%type
    ) is
    begin
		-- Der AG kann angefangen werden (Status 'A')
        update bde_fa_auftrag t
        set
            t.freig_status = 'A',
            t.freig_wann = sysdate,
            t.freig_wer = in_login_id
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.leitzahl = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos
            and t.freig_status = 'N';

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end c_fa_ag_bereit;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fa_ag_fe_erzeugen (
        in_sid      in bde_fa_auftrag.sid%type,
        in_firma_nr in bde_fa_auftrag.firma_nr%type,
        in_fa_nr    in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_fa_upos  in bde_fa_auftrag.fa_upos%type,
        in_res_id   in isi_resource.res_id%type,
        in_login_id in isi_user.login_id%type,
        out_lam_id  out lvs_lam.lam_id%type
    ) is

        v_artikel         isi_artikel%rowtype;
        v_bde_fa_kopf     bde_fa_kopf%rowtype;
        v_bde_fa_ag       bde_fa_auftrag%rowtype;
        v_serie_id        lvs_lam.serie_id%type;
        v_fa_nr           bde_fa_auftrag_stl.leitzahl%type;
        v_ma_fa_ag        bde_fa_auftrag_stl.ma_fa_ag%type;
        v_ma_fa_upos      bde_fa_auftrag_stl.ma_fa_upos%type;
        v_prod_menge_ix   bde_fa_auftrag_stl.prod_menge_ix%type;
        v_menge_p_einheit bde_fa_auftrag_stl.prod_menge_p_einheit%type;
        v_fa_ag_stl_id    bde_fa_auftrag_stl.fa_ag_stl_id%type;
        v_fa_ag           bde_fa_auftrag_stl.fa_ag%type;
        v_fa_upos         bde_fa_auftrag_stl.fa_upos%type;
        v_ma_artikel_id   bde_fa_auftrag.ag_artikel_id%type;
        cursor c_ma_mengen is
        select
            fa.leitzahl,
            ag_stl.ma_fa_ag,
            ag_stl.ma_fa_upos,
            ag_stl.prod_menge_ix,
            ag_stl.prod_menge_p_einheit,
            ag_stl.fa_ag_stl_id,
            ag_stl.fa_ag,
            ag_stl.fa_upos,
            fa.ag_artikel_id
        from
            bde_fa_auftrag     fa,
            bde_fa_auftrag_stl ag_stl
        where
                fa.leitzahl = in_fa_nr
            and fa.satzart = 'MA'
            and ag_stl.leitzahl = fa.leitzahl
            and ag_stl.ma_fa_ag = fa.fa_ag
            and ag_stl.ma_fa_upos = fa.fa_upos
            and ag_stl.firma_nr = fa.firma_nr
            and ag_stl.sid = fa.sid
            and ag_stl.fa_ag = (
                select
                    min(t.fa_ag)
                from
                    bde_fa_auftrag_stl t,
                    bde_fa_auftrag     t1
                where
                        t.leitzahl = ag_stl.leitzahl
                    and t.ma_fa_ag = ag_stl.ma_fa_ag
                    and t.ma_fa_upos = ag_stl.ma_fa_upos
                    and t.firma_nr = ag_stl.firma_nr
                    and t.sid = ag_stl.sid
                    and t1.sid = t.sid
                    and t1.firma_nr = t.firma_nr
                    and t1.leitzahl = t.leitzahl
                    and t1.fa_ag = t.fa_ag
                    and t1.fa_upos = t.fa_upos
                    and t1.satzart = 'V'
            )
        order by
            ag_stl.ma_fa_ag,
            ag_stl.ma_fa_upos,
            ag_stl.prod_menge_ix;

    begin
        if not bde_p_base.get_fa_kopf(in_sid, in_firma_nr, in_fa_nr, v_bde_fa_kopf) then
            raise_isi_error(10,
                            lc.ec_p3(lc.o_tp3_fa_auftrg_fehlt,
                                     to_char(in_fa_nr),
                                     to_char(in_fa_ag),
                                     to_char(in_fa_upos)));
        end if;

        if
            nvl(in_fa_ag, 0) > 0
            and not bde_p_base.get_fa_ag(in_sid, in_firma_nr, in_fa_nr, in_fa_ag, in_fa_upos,
                                         v_bde_fa_ag)
        then
            raise_isi_error(20,
                            lc.ec_p3(lc.o_tp3_fa_auftrg_fehlt,
                                     to_char(in_fa_nr),
                                     to_char(in_fa_ag),
                                     to_char(in_fa_upos)));

        end if;

        if not isi_p_base.get_isi_artikel(in_sid, v_bde_fa_kopf.artikel_id, v_artikel) then
            raise_isi_error(30,
                            lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                     to_char(v_bde_fa_kopf.artikel_id)));
        end if;

        v_serie_id := v_bde_fa_kopf.serie_id;
        if v_bde_fa_kopf.serie_auto_inc = c.c_true then
            v_serie_id := v_serie_id + 1;
      -- letzte seriennummer speichern
            update bde_fa_kopf t
            set
                t.serie_id = v_serie_id
            where
                    t.sid = v_bde_fa_kopf.sid
                and t.firma_nr = v_bde_fa_kopf.firma_nr
                and t.fa_nr = v_bde_fa_kopf.fa_nr;

        end if;

        insert into lvs_lam (
            sid,
            firma_nr,
            lam_id,
            artikel_id,
            serie_id,
            leitzahl,
            fa_ag,
            fa_upos,
            res_id,
            prod_datum,
            ls_login_id,
            menge,
            lam_kg,
            labor_status,
            kunden_nr,
            kd_art_nr,
            menge_basis,
            mengeneinheit_basis,
            zeichnung,
            zeichnung_index
        ) values ( in_sid,
                   in_firma_nr,
                   seq_lam.nextval,
                   v_bde_fa_kopf.artikel_id,
                   v_serie_id,
                   in_fa_nr,
                   in_fa_ag,
                   in_fa_upos,
                   in_res_id,
                   sysdate,
                   in_login_id,
                   0,
                   0,
                   'P', -- in Produktion
                   v_bde_fa_kopf.kunden_nr,
                   v_bde_fa_kopf.kd_art_nr,
                   v_artikel.menge_basis,
                   v_artikel.mengeneinheit_basis,
                   v_bde_fa_kopf.zeichnung,
                   v_bde_fa_kopf.zeichnung_index ) returning lam_id into out_lam_id;

        insert into bde_pd_lam_stl_daten
            select
                fa.sid,
                fa.firma_nr,
                null,
                out_lam_id,
                fa.leitzahl                   fa_nr,
                fa.fa_ag,
                fa.fa_upos,
                ag_stl.fa_ag_stl_id,
                null                          stl_lam_id,
                0                             stl_lam_ab_menge,
                0                             stl_lam_ist_menge,
                'N'                           status,
                sysdate                       aend_datum,
                - 1                           aend_login_id,
           -- -BW- Nur Maschinen und Maschinennahe Resourcen bekommene die ID
                decode(r.typ, 'MS', r.res_id, 'MPP', r.res_id,
                       'MPG', r.res_id, null) res_id,
                null                          res_status_id,
                null                          result_params
            from
                bde_fa_auftrag     fa,
                bde_fa_auftrag_stl ag_stl,
                isi_resource       r
            where
                    fa.leitzahl = in_fa_nr
                and fa.satzart != 'MA'
                and ag_stl.leitzahl (+) = fa.leitzahl
                and ag_stl.fa_ag (+) = fa.fa_ag
                and ag_stl.fa_upos (+) = fa.fa_upos
                and ag_stl.sid (+) = fa.sid
                and ag_stl.firma_nr (+) = fa.firma_nr
                and r.sid (+) = fa.sid
                and r.firma_nr (+) = fa.firma_nr
                and r.res_id (+) = fa.res_id
            order by
                fa.fa_ag,
                fa.fa_upos,
                ag_stl.prod_reihenfolge,
                ag_stl.ma_fa_ag,
                ag_stl.ma_fa_upos;

        update isi_resource_zust_akt t
        set
            t.fert_lam_id = out_lam_id
        where
                t.res_id = in_res_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

    -- -WK- Übernahme der Sollmengen in die Fertigungseinheit
        open c_ma_mengen;
        loop
            fetch c_ma_mengen into
                v_fa_nr,
                v_ma_fa_ag,
                v_ma_fa_upos,
                v_prod_menge_ix,
                v_menge_p_einheit,
                v_fa_ag_stl_id,
                v_fa_ag,
                v_fa_upos,
                v_ma_artikel_id;

            exit when c_ma_mengen%notfound;
            update bde_pd_lam_stl_daten t
            set
                t.stl_lam_ab_menge = v_menge_p_einheit
            where
                    t.fert_lam_id = out_lam_id
                and t.fa_nr = v_fa_nr
                and t.fa_ag = v_fa_ag
                and t.fa_upos = v_fa_upos
                and t.fa_ag_stl_id = v_fa_ag_stl_id;

        end loop;

        close c_ma_mengen;
        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end c_fa_ag_fe_erzeugen;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_ma_remove_all_res_lam_akt (
        in_sid    in isi_resource_lam_akt.sid%type,
        in_res_id in isi_resource_lam_akt.res_id%type
    ) is
    begin
        delete isi_resource_lam_akt t
        where
                t.sid = in_sid
            and t.res_id = in_res_id;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_ma_add_new_res_lam_akt (
        in_sid        in isi_resource_lam_akt.sid%type,
        in_firma_nr   in lvs_lam.firma_nr%type,
        in_res_id     in isi_resource_lam_akt.res_id%type,
        in_artikel_id in isi_resource_lam_akt.artikel_id%type,
        in_charge_id  in lvs_lam.charge_id%type,
        in_zeichnung  in lvs_lam.zeichnung%type,
        in_zindex     in lvs_lam.zeichnung_index%type,
        in_menge      in lvs_lam.menge%type
    ) is
        v_artikel     isi_artikel%rowtype;
        v_res_lam_akt isi_resource_lam_akt%rowtype;
        v_lam         lvs_lam%rowtype;
    begin
        if not isi_p_base.get_isi_artikel(in_sid, in_artikel_id, v_artikel) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                     to_char(in_artikel_id)));
        end if;

        v_res_lam_akt := null;
        v_lam := null;
        if isi_p_base.get_res_lam_akt(in_sid, in_res_id, in_artikel_id, v_res_lam_akt) then
      -- Prüfen, ob beim vorhandenen Datensatz die Menge = 0 ist, kann er gelöscht werden
            if lvs_p_base.get_lam(in_sid, in_firma_nr, v_res_lam_akt.lam_id, v_lam) then
                if v_lam.menge > 0 then
                    raise_isi_error(20,
                                    lc.ec_p3('lc.o_tp3_res_lam_akt_n_leer',
                                             to_char(in_res_id),
                                             to_char(in_artikel_id),
                                             to_char(v_lam.menge)));

                end if;

            end if;
        end if;

        insert into lvs_lam (
            sid,
            firma_nr,
            lam_id,
            artikel_id,
            charge_id,
            res_id,
            menge,
            labor_status,
            menge_basis,
            mengeneinheit_basis,
            zeichnung,
            zeichnung_index
        ) values ( in_sid,
                   in_firma_nr,
                   seq_lam.nextval,
                   in_artikel_id,
                   in_charge_id,
                   in_res_id,
                   in_menge,
                   'F', -- Frei
                   v_artikel.menge_basis,
                   v_artikel.mengeneinheit_basis,
                   in_zeichnung,
                   in_zindex ) returning lam_id into v_lam.lam_id;

        if v_res_lam_akt.res_id is null -- kein Datensatz gefunden, also neuen anlegen

         then
            insert into isi_resource_lam_akt values ( in_sid,
                                                      in_res_id,
                                                      in_artikel_id,
                                                      v_lam.lam_id,
                                                      null, -- keine LTE hier
                                                      sysdate,
                                                      null -- keine Params bekannt hier
                                                       );

        else
            update isi_resource_lam_akt t
            set
                t.lam_id = v_lam.lam_id,
                t.b_datum = sysdate
            where
                    t.sid = in_sid
                and t.res_id = in_res_id
                and t.artikel_id = in_artikel_id;

        end if;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_ma_add_res_lam_akt_menge (
        in_sid        in isi_resource_lam_akt.sid%type,
        in_firma_nr   in lvs_lam.firma_nr%type,
        in_res_id     in isi_resource_lam_akt.res_id%type,
        in_artikel_id in isi_resource_lam_akt.artikel_id%type,
        in_lam_id     in isi_resource_lam_akt.lam_id%type,
        in_menge      in lvs_lam.menge%type
    ) is
        v_artikel     isi_artikel%rowtype;
        v_res_lam_akt isi_resource_lam_akt%rowtype;
        v_lam         lvs_lam%rowtype;
    begin
        if not isi_p_base.get_isi_artikel(in_sid, in_artikel_id, v_artikel) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                     to_char(in_artikel_id)));
        end if;

        if not lvs_p_base.get_lam(in_sid, in_firma_nr, in_lam_id, v_lam) then
            raise_isi_error(20,
                            lc.ec_p1(lc.o_tp1_lam_fehlt,
                                     to_char(in_lam_id)));

        end if;

        if isi_p_base.get_res_lam_akt(in_sid, in_res_id, in_artikel_id, v_res_lam_akt) then
            if v_res_lam_akt.lam_id != in_lam_id then
                raise_isi_error(30,
                                lc.ec_p3('lc.o_tp3_res_lam_akt_falsch',
                                         to_char(in_res_id),
                                         to_char(v_res_lam_akt.lam_id),
                                         to_char(in_lam_id)));

            end if;
        else
            insert into isi_resource_lam_akt values ( in_sid,
                                                      in_res_id,
                                                      in_artikel_id,
                                                      v_lam.lam_id,
                                                      null, -- keine LTE hier
                                                      sysdate,
                                                      null -- keine Params bekannt hier
                                                       );

        end if;

        update lvs_lam t
        set
            t.menge = t.menge + in_menge
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lam_id = in_lam_id;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_ma_reduce_res_lam_akt_menge (
        in_sid        in isi_resource_lam_akt.sid%type,
        in_firma_nr   in lvs_lam.firma_nr%type,
        in_res_id     in isi_resource_lam_akt.res_id%type,
        in_artikel_id in isi_resource_lam_akt.artikel_id%type,
        in_lam_id     in isi_resource_lam_akt.lam_id%type,
        in_menge      in lvs_lam.menge%type
    ) is
        v_artikel     isi_artikel%rowtype;
        v_res_lam_akt isi_resource_lam_akt%rowtype;
        v_lam         lvs_lam%rowtype;
    begin
        if not isi_p_base.get_isi_artikel(in_sid, in_artikel_id, v_artikel) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                     to_char(in_artikel_id)));
        end if;

        if not lvs_p_base.get_lam(in_sid, in_firma_nr, in_lam_id, v_lam) then
            raise_isi_error(20,
                            lc.ec_p1(lc.o_tp1_lam_fehlt,
                                     to_char(in_lam_id)));

        end if;

        if not isi_p_base.get_res_lam_akt(in_sid, in_res_id, in_artikel_id, v_res_lam_akt) then
            raise_isi_error(30,
                            lc.ec_p3('lc.o_tp3_res_lam_akt_fehlt',
                                     to_char(in_res_id),
                                     to_char(v_res_lam_akt.lam_id),
                                     to_char(in_artikel_id)));
        end if;

        if v_res_lam_akt.lam_id != in_lam_id then
            raise_isi_error(30,
                            lc.ec_p3('lc.o_tp3_res_lam_akt_falsch',
                                     to_char(in_res_id),
                                     to_char(v_res_lam_akt.lam_id),
                                     to_char(in_lam_id)));
        end if;

        update lvs_lam t
        set
            t.menge = t.menge - in_menge
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lam_id = in_lam_id;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_ma_set_res_lam_akt_params (
        in_sid        in isi_resource_lam_akt.sid%type,
        in_res_id     in isi_resource_lam_akt.res_id%type,
        in_artikel_id in isi_resource_lam_akt.artikel_id%type,
        in_params_csv in isi_resource_lam_akt.res_lam_params%type
    ) is
        v_artikel     isi_artikel%rowtype;
        v_res_lam_akt isi_resource_lam_akt%rowtype;
    begin
        if not isi_p_base.get_isi_artikel(in_sid, in_artikel_id, v_artikel) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                     to_char(in_artikel_id)));
        end if;

        if not isi_p_base.get_res_lam_akt(in_sid, in_res_id, in_artikel_id, v_res_lam_akt) then
            raise_isi_error(30,
                            lc.ec_p3('lc.o_tp3_res_lam_akt_fehlt',
                                     to_char(in_res_id),
                                     to_char(v_res_lam_akt.lam_id),
                                     to_char(in_artikel_id)));

        end if;

        update isi_resource_lam_akt t
        set
            t.res_lam_params = in_params_csv
        where
                t.sid = in_sid
            and t.res_id = in_res_id
            and t.artikel_id = in_artikel_id;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_bereit (
        in_sid         in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr    in bde_pd_lam_stl_daten.firma_nr%type,
        in_fert_lam_id in bde_pd_lam_stl_daten.fert_lam_id%type,
        in_fa_nr       in bde_pd_lam_stl_daten.fa_nr%type,
        in_fa_ag       in bde_pd_lam_stl_daten.fa_ag%type,
        in_fa_upos     in bde_pd_lam_stl_daten.fa_upos%type,
        in_res_id      in bde_pd_lam_stl_daten.res_id%type
    ) is
    begin
        update bde_pd_lam_stl_daten t
        set
            t.status = 'A', -- kann angefangen werden
            t.aend_datum = sysdate,
            t.aend_login_id = - 1,
            t.res_id = nvl(in_res_id, t.res_id)
        where
                t.fert_lam_id = in_fert_lam_id
            and t.fa_nr = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.status in ( 'N', 'AP', 'AR' );

        if sql%rowcount = 0 then
            raise_isi_error(10, 'Keine Daten aktualisiert!');
        end if;
        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_reset (
        in_sid         in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr    in bde_pd_lam_stl_daten.firma_nr%type,
        in_fert_lam_id in bde_pd_lam_stl_daten.fert_lam_id%type,
        in_fa_nr       in bde_pd_lam_stl_daten.fa_nr%type,
        in_fa_ag       in bde_pd_lam_stl_daten.fa_ag%type,
        in_fa_upos     in bde_pd_lam_stl_daten.fa_upos%type,
        in_res_id      in bde_pd_lam_stl_daten.res_id%type
    ) is
    begin
        update bde_pd_lam_stl_daten t
        set
            t.status = 'N', -- Neu, noch nicht bearbeitet
            t.aend_datum = sysdate,
            t.aend_login_id = - 1
        where
                t.fert_lam_id = in_fert_lam_id
            and t.fa_nr = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.status = 'A'
            and ( t.res_id = in_res_id
                  or in_res_id is null );

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	-- Fertigmeldung eines kompletten AG einer Fertigungseinheit (incl. aller noch nicht
  -- fertiggemeldeten Stücklistenpositionen)
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_fertig (
        in_sid           in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,
        in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
        in_fa_nr         in bde_pd_lam_stl_daten.fa_nr%type,
        in_fa_ag         in bde_pd_lam_stl_daten.fa_ag%type,
        in_fa_upos       in bde_pd_lam_stl_daten.fa_upos%type,
        in_res_id        in bde_pd_lam_stl_daten.res_id%type,
        in_menge_io      in bde_pd_prod.menge_a%type,
        in_menge_nio     in bde_pd_prod.menge_b%type,
        in_menge_schrott in bde_pd_prod.schrott%type
    ) is

        v_lam           lvs_lam%rowtype;
        v_lam_menge     number;
        v_menge_io      number;
        v_menge_nio     number;
        v_menge_schrott number;
        v_fa_ag         bde_fa_auftrag%rowtype;
    begin
        if not lvs_p_base.get_lam(in_sid, in_firma_nr, in_fert_lam_id, v_lam) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_lam_fehlt,
                                     to_char(in_fert_lam_id)));
        end if;

        if not bde_p_base.get_fa_ag(in_sid, in_firma_nr, in_fa_nr, in_fa_ag, in_fa_upos,
                                    v_fa_ag) then
            raise_isi_error(20,
                            lc.ec_p3(lc.o_tp3_fa_auftrg_fehlt,
                                     to_char(in_fa_nr),
                                     to_char(in_fa_ag),
                                     to_char(in_fa_upos)));

        end if;

        update bde_pd_lam_stl_daten t
        set
            t.status = 'F', -- fertig verrrichtet
            t.aend_datum = sysdate,
            t.aend_login_id = - 1
           --t.res_id = in_res_id
        where
                t.fert_lam_id = in_fert_lam_id
            and t.fa_nr = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.status in ( 'N', 'A', 'AP' );

        v_menge_io := in_menge_io;
        v_menge_nio := in_menge_nio;
        v_menge_schrott := in_menge_schrott;
        v_lam_menge := v_menge_io;
        if v_menge_io = 0 then
            v_lam_menge := v_menge_nio;
        end if;
    --if v_lam.labor_status in ('F', 'P', 'B') -- F = frei, P = in Produktion, B = bedingt frei
    --then
    --  v_menge_io := v_lam.menge;
    --elsif v_lam.labor_status in ('N') -- N = NIO
    --then
    --  v_menge_nio := v_menge_nio + v_lam.menge;
    --elsif v_lam.labor_status in ('S', 'G') -- S = Schrott, G = gesperrt
    --then
    --  v_menge_schrott := v_menge_schrott + v_lam.menge;
    --end if;

        update lvs_lam t
        set
            t.leitzahl = in_fa_nr,
            t.fa_ag = decode(v_fa_ag.kenz_letzt_ag, 1, null, in_fa_ag),
            t.fa_upos = decode(v_fa_ag.kenz_letzt_ag, 1, null, in_fa_upos),
            t.prod_datum = sysdate,
            t.menge = v_lam_menge
        where
                t.lam_id = in_fert_lam_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

        commit;
        if v_fa_ag.freig_status = 'AP' then
            c_fa_ag_menge_buchen(in_sid, in_firma_nr, 'PP', in_fa_nr, in_fa_ag,
                                 in_fa_upos, in_res_id, null, v_menge_io, v_menge_nio,
                                 v_menge_schrott, v_lam.fae_id, v_lam.fae_id_position);
        end if;

    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_stl_lam_status (
        in_sid                 in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr            in bde_pd_lam_stl_daten.firma_nr%type,
        in_fe_lam_stl_daten_id in bde_pd_lam_stl_daten.pd_lam_stl_daten_id%type,
        in_status              in bde_pd_lam_stl_daten.status%type,
        in_res_id              in bde_pd_lam_stl_daten.res_id%type
    ) is
    begin
        update bde_pd_lam_stl_daten t
        set
            t.status = in_status,
            t.aend_datum = sysdate,
            t.aend_login_id = - 1,
            t.res_id = nvl(in_res_id, t.res_id)
        where
                t.pd_lam_stl_daten_id = in_fe_lam_stl_daten_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;
       --and t.status not in ('F');
        if sql%rowcount = 0 then
            raise_isi_error(10, 'Keine Daten aktualisiert!');
        end if;
        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_stl_lam_fertig (
        in_sid          in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr     in bde_pd_lam_stl_daten.firma_nr%type,
        in_fert_lam_id  in bde_pd_lam_stl_daten.fert_lam_id%type,
        in_fa_nr        in bde_pd_lam_stl_daten.fa_nr%type,
        in_fa_ag        in bde_pd_lam_stl_daten.fa_ag%type,
        in_fa_upos      in bde_pd_lam_stl_daten.fa_upos%type,
        in_fa_ag_stl_id in bde_pd_lam_stl_daten.fa_ag_stl_id%type,
        in_res_id       in bde_pd_lam_stl_daten.res_id%type
    ) is
    begin
        update bde_pd_lam_stl_daten t
        set
            t.status = 'F', -- fertig verrrichtet
            t.aend_datum = sysdate,
            t.aend_login_id = - 1,
            t.res_id = nvl(in_res_id, t.res_id)
        where
                t.fert_lam_id = in_fert_lam_id
            and t.fa_nr = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos
            and t.fa_ag_stl_id = in_fa_ag_stl_id
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.status in ( 'N', 'A', 'AP' );

        if sql%rowcount = 0 then
            raise_isi_error(10, 'Keine Daten aktualisiert!');
        end if;
        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	-- Setzt die IST-Menge der verbrauchten, bzw. eingesetzten Bauteile auf den übergebenen Wert.
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_stl_lam_ist_menge (
        in_sid          in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr     in bde_pd_lam_stl_daten.firma_nr%type,
        in_fert_lam_id  in bde_pd_lam_stl_daten.fert_lam_id%type,
        in_fa_nr        in bde_pd_lam_stl_daten.fa_nr%type,
        in_fa_ag        in bde_pd_lam_stl_daten.fa_ag%type,
        in_fa_upos      in bde_pd_lam_stl_daten.fa_upos%type,
        in_fa_ag_stl_id in bde_pd_lam_stl_daten.fa_ag_stl_id%type,
        in_ist_menge    in bde_pd_lam_stl_daten.stl_lam_ist_menge%type
    ) is
    begin
        update bde_pd_lam_stl_daten t
        set
            t.stl_lam_ist_menge = in_ist_menge
        where
                t.fert_lam_id = in_fert_lam_id
            and t.fa_nr = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos
            and t.fa_ag_stl_id = in_fa_ag_stl_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_upd_result_params (
        in_sid           in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,
        in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
        in_fa_nr         in bde_pd_lam_stl_daten.fa_nr%type,
        in_fa_ag         in bde_pd_lam_stl_daten.fa_ag%type,
        in_fa_upos       in bde_pd_lam_stl_daten.fa_upos%type,
        in_fa_ag_stl_id  in bde_pd_lam_stl_daten.fa_ag_stl_id%type,
        in_result_params in bde_pd_lam_stl_daten.result_params%type
    ) is
    begin
        update bde_pd_lam_stl_daten t
        set
            t.result_params = in_result_params
        where
                t.fert_lam_id = in_fert_lam_id
            and t.fa_nr = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos
            and t.fa_ag_stl_id = in_fa_ag_stl_id
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr;

        if sql%rowcount = 0 then
            raise_isi_error(10, 'Keine Daten aktualisiert!');
        end if;
        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_stl_lam_res_status (
        in_sid           in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,
        in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
        in_fa_nr         in bde_pd_lam_stl_daten.fa_nr%type,
        in_fa_ag         in bde_pd_lam_stl_daten.fa_ag%type,
        in_fa_upos       in bde_pd_lam_stl_daten.fa_upos%type,
        in_fa_ag_stl_id  in bde_pd_lam_stl_daten.fa_ag_stl_id%type,
        in_res_id        in bde_pd_lam_stl_daten.res_id%type,
        in_res_status_id in bde_pd_lam_stl_daten.res_status_id%type
    ) is
    begin
        update bde_pd_lam_stl_daten t
        set
            t.res_id = nvl(in_res_id, t.res_id),
            t.res_status_id = in_res_status_id
        where
                t.fert_lam_id = in_fert_lam_id
            and t.fa_nr = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos
            and t.fa_ag_stl_id = in_fa_ag_stl_id
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr;

        if sql%rowcount = 0 then
            raise_isi_error(10, 'Keine Daten aktualisiert!');
        end if;
        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	-- automatische Anmeldung des AG an der Ressource, wenn nicht schon vorher geschehen.
  -- Zusätzlich: Anmeldung der Ferigungseinheit an der Ressource und Setzen des Status
  -- beim AG der Fertigungseinheit, dass die Produktion aktiviert wude ("AP").
  -- Die Bauteil-Sollmenge wird hierbei in die IST-Menge eingetragen, da hier davon ausgegangen
  -- werden kann, dass nach Fertigstellung mindestens die Sollmenge an Bauteilen in diesem AG
  -- verbraucht werden.
  -- Wenn die IST-Menge am Ende des AG nicht korrekt ist, muss ein Bediener die Werte korrigieren.
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_res_anmelden (
        in_sid         in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr    in bde_pd_lam_stl_daten.firma_nr%type,
        in_fert_lam_id in bde_pd_lam_stl_daten.fert_lam_id%type,
        in_fa_nr       in bde_pd_lam_stl_daten.fa_nr%type,
        in_fa_ag       in bde_pd_lam_stl_daten.fa_ag%type,
        in_fa_upos     in bde_pd_lam_stl_daten.fa_upos%type,
        in_res_id      in bde_pd_lam_stl_daten.res_id%type
    ) is
        v_res_zust_akt isi_resource_zust_akt%rowtype;
    begin
        if not isi_p_base.get_res_zust_akt(in_sid, in_res_id, v_res_zust_akt) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_resourcenzustand_fehlt, in_res_id));
        end if;

        if
            v_res_zust_akt.fert_lam_id is not null
            and v_res_zust_akt.fert_lam_id != in_fert_lam_id
        then
            raise_isi_error(20,
                            lc.ec_p1('lc.o_tp1_res_zust_fe_lam_belegt', in_res_id));
        end if;

        if v_res_zust_akt.leitzahl is not null then
            if v_res_zust_akt.leitzahl != in_fa_nr then
                raise_isi_error(30,
                                lc.ec_p1('lc.o_tp1_res_zust_fa_nr_falsch', in_res_id));
            end if;

            if v_res_zust_akt.fa_ag != in_fa_ag then
                raise_isi_error(40,
                                lc.ec_p1('lc.o_tp1_res_zust_fa_ag_falsch', in_res_id));
            end if;

        else
            bde_pd_prod_p_ag_b(in_sid, -- in isi_sid.sid%type,
             in_firma_nr, -- in isi_firma.firma_nr%type,
             in_fa_nr, -- in bde_fa_auftrag.leitzahl%type,
             in_fa_ag, -- in bde_fa_auftrag.fa_ag%type,
             in_fa_upos, -- in bde_fa_auftrag.fa_upos%type,
                               in_res_id, -- in isi_resource.res_id%type,
                                null, -- in isi_arbeitsplatz.ip_name%type,
                                null); -- in isi_user.login_id%type)
        end if;

        update isi_resource_zust_akt t
        set
            t.fert_lam_id = in_fert_lam_id
        where
                t.res_id = in_res_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

        update bde_pd_lam_stl_daten t
        set
            t.status = 'AP', -- Produktion läuft
            t.stl_lam_ist_menge = decode(
                nvl(t.stl_lam_ist_menge, 0),
                0,
                nvl(t.stl_lam_ab_menge, 0), -- wenn noch keine IST-Menge, dann Sollmenge übenehmen
                t.stl_lam_ist_menge
            ) -- ansonsten IST-Menge beibehalten
        where
                t.fert_lam_id = in_fert_lam_id
            and t.fa_nr = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.status in ( 'N', 'A' );

    --if sql%rowcount = 0
    --then
    --  raise_isi_error(10, 'Keine Daten aktualisiert!');
    --end if;
        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_ag_res_abmelden (
        in_sid         in bde_pd_lam_stl_daten.sid%type,
        in_firma_nr    in bde_pd_lam_stl_daten.firma_nr%type,
        in_fert_lam_id in bde_pd_lam_stl_daten.fert_lam_id%type,
        in_res_id      in bde_pd_lam_stl_daten.res_id%type
    ) is
        v_res_zust_akt isi_resource_zust_akt%rowtype;
    begin
        if not isi_p_base.get_res_zust_akt(in_sid, in_res_id, v_res_zust_akt) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_resourcenzustand_fehlt, in_res_id));
        end if;

        if v_res_zust_akt.fert_lam_id is not null then
            if v_res_zust_akt.fert_lam_id != in_fert_lam_id then
                raise_isi_error(20,
                                lc.ec_p1('lc.o_tp1_res_zust_fe_lam_falsch', in_res_id));
            end if;

            update isi_resource_zust_akt t
            set
                t.fert_lam_id = null
            where
                    t.res_id = in_res_id
                and t.firma_nr = in_firma_nr
                and t.sid = in_sid;

        end if;

        if sql%rowcount = 0 then
            raise_isi_error(10, 'Keine Daten aktualisiert!');
        end if;
        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_update_qs_status (
        in_sid         in lvs_lam.sid%type,
        in_firma_nr    in lvs_lam.firma_nr%type,
        in_fert_lam_id in lvs_lam.lam_id%type,
        in_qs_status   in lvs_lam.qs_status%type
    ) is
    begin
        update lvs_lam t
        set
            t.qs_status = in_qs_status
        where
                t.lam_id = in_fert_lam_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_update_last_fa_ag (
        in_sid         in lvs_lam.sid%type,
        in_firma_nr    in lvs_lam.firma_nr%type,
        in_fert_lam_id in lvs_lam.lam_id%type,
        in_fa_ag       in lvs_lam.fa_ag%type,
        in_fa_upos     in lvs_lam.fa_upos%type
    ) is
    begin
        update lvs_lam t
        set
            t.fa_ag = in_fa_ag,
            t.fa_upos = in_fa_upos
        where
                t.lam_id = in_fert_lam_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_entnahme_buchen (
        in_sid         in lvs_lam.sid%type,
        in_firma_nr    in lvs_lam.firma_nr%type,
        in_fert_lam_id in lvs_lam.lam_id%type,
        in_res_id      in lvs_lam.res_id%type
    ) is
    --v_lam       lvs_lam%rowtype;
        v_resource  isi_resource%rowtype;
        v_res_zust  isi_resource_zust_akt%rowtype;
        v_nio_count number;
        cursor c_nio_daten is
        select
            count(*)
        from
            bde_pd_nio_daten t
        where
            t.fert_lam_id = in_fert_lam_id;

    begin
        if isi_p_base.get_resource(in_sid, in_res_id, v_resource) then
            if isi_p_base.get_res_zust_akt(in_sid, in_res_id, v_res_zust) then
                if v_res_zust.fert_lam_id = in_fert_lam_id then
                    update isi_resource_zust_akt t
                    set
                        t.fert_lam_id = null
                    where
                            t.res_id = in_res_id
                        and t.firma_nr = in_firma_nr
                        and t.sid = in_sid;

                end if;

            end if;
        end if;

    /*
    if not lvs_p_base.get_lam(in_sid, in_firma_nr, in_fert_lam_id, v_lam)
    then
			raise_isi_error(20,
											lc.ec_p1(lc.o_tp1_lam_fehlt,
                               to_char(in_fert_lam_id)));
    end if;
    */

        v_nio_count := 0;
        open c_nio_daten;
        fetch c_nio_daten into v_nio_count;
        close c_nio_daten;
        update lvs_lam t
        set
            t.lgr_platz = null,
            t.labor_status = decode(t.labor_status,
                                    'P',
                                    decode(v_nio_count, 0, 'F', 'G'),
                                    t.labor_status),
            t.prod_datum = sysdate,
            t.lam_text = v_resource.res_name
        where
                t.lam_id = in_fert_lam_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_nio_insert (
        in_sid                 in bde_pd_nio_daten.sid%type,
        in_firma_nr            in bde_pd_nio_daten.firma_nr%type,
        in_fert_lam_id         in bde_pd_nio_daten.fert_lam_id%type,
        in_fe_lam_stl_daten_id in bde_pd_nio_daten.pd_lam_stl_daten_id%type,
        in_res_id              in bde_pd_nio_daten.res_id%type,
        in_nio_nr              in bde_pd_nio_daten.nio_nr%type,
        in_nio_status          in bde_pd_nio_daten.nio_status%type,
        in_nio_params          in bde_pd_nio_daten.nio_params%type,
        out_nio_daten_id       out bde_pd_nio_daten.nio_daten_id%type
    ) is
        v_res_zust isi_resource_zust_akt%rowtype;
    begin
        if not isi_p_base.get_res_zust_akt(in_sid, in_res_id, v_res_zust) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_resourcenzustand_fehlt,
                                     to_char(in_res_id)));
        end if;

        insert into bde_pd_nio_daten values ( in_sid,
                                              in_firma_nr,
                                              seq_bde_pd_nio_daten.nextval,
                                              in_fert_lam_id,
                                              in_fe_lam_stl_daten_id,
                                              in_nio_nr,
                                              sysdate,
                                              in_nio_status,
                                              in_res_id,
                                              v_res_zust.status_id, -- res_id_status
                                              in_nio_params,
                                              'F', -- nachbearb
                                              null, -- na_datum
                                              null, -- na_login_id
                                              'F', -- na_io
                                              0, -- na_dauer_min
                                              null, -- aend_datum
                                              null -- aend_login_id
                                               ) returning nio_daten_id into out_nio_daten_id;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_nio_update_status (
        in_sid          in bde_pd_nio_daten.sid%type,
        in_firma_nr     in bde_pd_nio_daten.firma_nr%type,
        in_nio_daten_id in bde_pd_nio_daten.nio_daten_id%type,
        in_nio_status   in bde_pd_nio_daten.nio_status%type,
        in_res_id       in bde_pd_nio_daten.res_id%type
    ) is
        v_res_zust isi_resource_zust_akt%rowtype;
    begin
        if not isi_p_base.get_res_zust_akt(in_sid, in_res_id, v_res_zust) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_resourcenzustand_fehlt,
                                     to_char(in_res_id)));
        end if;

        update bde_pd_nio_daten t
        set
            t.nio_status = in_nio_status,
            t.aend_datum = sysdate,
            t.res_id = in_res_id,
            t.res_status_id = v_res_zust.status_id
        where
                t.nio_daten_id = in_nio_daten_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_fe_nio_update_params (
        in_sid          in bde_pd_nio_daten.sid%type,
        in_firma_nr     in bde_pd_nio_daten.firma_nr%type,
        in_nio_daten_id in bde_pd_nio_daten.nio_daten_id%type,
        in_nio_params   in bde_pd_nio_daten.nio_params%type
    ) is
    begin
        update bde_pd_nio_daten t
        set
            t.nio_params = in_nio_params
        where
                t.nio_daten_id = in_nio_daten_id
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
    procedure c_res_status_beg (
        in_sid      in bde_pd_nio_daten.sid%type,
        in_firma_nr in bde_pd_nio_daten.firma_nr%type,
        in_res_id   in isi_resource.res_id%type,
        in_st_id    in isi_res_status_cfg.res_st_id%type,
        in_st_ug_id in isi_res_status.res_st_ug_id%type,     -- in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
        v_login_id  in isi_user.login_id%type
    ) is

        v_resource isi_resource%rowtype;
        v_found    boolean;
        cursor c_res is
        select
            *
        from
            isi_resource res
        where
                res.sid = in_sid
            and res.firma_nr = in_firma_nr
            and res.res_id = in_res_id;

    begin
        open c_res;
        fetch c_res into v_resource;
        v_found := c_res%found;
        close c_res;
        if not v_found then
            v_err_nr := 20;
            v_err_text := 'Maschine fehlt ';
            raise v_error;
        end if;

        res_status.res_status_beg(in_sid,                       -- in_sid           in isi_sid.sid%type,

         in_firma_nr,                  -- in_firma_nr      in isi_firma.firma_nr%type,

         v_resource.res_id,            -- in_res_id        in isi_resource.res_id%type,

         v_login_id,                   -- in_ls_login_id   in isi_user.login_id%type,

         in_st_id,                     -- in_res_st_id     in isi_res_status_cfg.res_st_id%type,
                                  v_resource.typ,               -- in_res_typ       in isi_res_status_cfg.res_typ%type,
                                   in_st_ug_id,                  -- in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
                                   v_resource.fehler_schluessel, -- in_fehler_res_id in isi_res_status.fehler_res_id%type,
                                   sysdate);                     -- in_sysdate       in date default null) is
        commit;
    exception
		-- Im Fehlerfall is der v_err_nr bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

end fls_p_bde;
/


-- sqlcl_snapshot {"hash":"0b25dd14714fab98899062f2540eeeccc2819fb9","type":"PACKAGE_BODY","name":"FLS_P_BDE","schemaName":"DIRKSPZM32","sxml":""}