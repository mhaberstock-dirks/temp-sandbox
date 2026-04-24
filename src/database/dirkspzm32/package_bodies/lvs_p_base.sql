create or replace package body dirkspzm32.lvs_p_base is

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
    end get_version;

    function get_lte_cfg (
        in_sid      in lvs_lte_cfg.sid%type,
        in_lte_name in lvs_lte_cfg.lte_name%type,
        io_lte_cfg  in out lvs_lte_cfg%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_lte_cfg is
        select
            *
        from
            lvs_lte_cfg t
        where
                t.sid = in_sid
            and t.lte_name = in_lte_name;

    begin
        open c_lte_cfg;
        fetch c_lte_cfg into io_lte_cfg;
        v_result := c_lte_cfg%found;
        close c_lte_cfg;
        return ( v_result );
    end;

    function get_lhm_cfg (
        in_sid      in lvs_lhm_cfg.sid%type,
        in_lhm_name in lvs_lhm_cfg.lhm_name%type,
        io_lhm_cfg  in out lvs_lhm_cfg%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_lhm_cfg is
        select
            *
        from
            lvs_lhm_cfg t
        where
                t.sid = in_sid
            and t.lhm_name = in_lhm_name;

    begin
        open c_lhm_cfg;
        fetch c_lhm_cfg into io_lhm_cfg;
        v_result := c_lhm_cfg%found;
        close c_lhm_cfg;
        return ( v_result );
    end;

    function get_lgr_ort (
        in_sid      in lvs_lgr_ort.sid%type,
        in_firma_nr in lvs_lgr_ort.firma_nr%type,
        in_lgr_ort  in lvs_lgr_ort.lgr_ort%type,
        io_lgr_ort  in out lvs_lgr_ort%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_lgr_ort is
        select
            *
        from
            lvs_lgr_ort t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort = in_lgr_ort;

    begin
        open c_lgr_ort;
        fetch c_lgr_ort into io_lgr_ort;
        v_result := c_lgr_ort%found;
        close c_lgr_ort;
        return ( v_result );
    end;

    function get_lgr_platz (
        in_lgr_platz in lvs_lgr.lgr_platz%type,
        io_lgr       in out lvs_lgr%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_lgr_platz is
        select
            *
        from
            lvs_lgr t
        where
            t.lgr_platz = in_lgr_platz;

    begin
        open c_lgr_platz;
        fetch c_lgr_platz into io_lgr;
        v_result := c_lgr_platz%found;
        close c_lgr_platz;
        return ( v_result );
    end;

    function get_lgr_komm_info (
        in_lgr_platz                in lvs_lgr.lgr_platz%type,
        out_komm_direkt_moegl       out lvs_lgr_ort.komm_direkt_moegl%type,
        out_komm_ausweich_lgr_platz out lvs_lgr_ort.komm_ausweich_lgr_platz%type,
        out_komm_picken_moegl       out lvs_lgr_ort.komm_picken_moegl%type,
        out_komm_neu_lte_lgr_platz  out lvs_lgr_ort.komm_neu_lte_lgr_platz%type
    ) return boolean is

        cursor c_lgr_info is
        select
            lo.komm_direkt_moegl,
            lo.komm_ausweich_lgr_platz,
            lo.komm_picken_moegl,
            lo.komm_neu_lte_lgr_platz
        from
            lvs_lgr     lgr,
            lvs_lgr_ort lo
        where
                lgr.lgr_platz = in_lgr_platz
            and lo.sid = lgr.sid
            and lo.firma_nr = lgr.firma_nr
            and lo.lgr_ort = lgr.lgr_ort;

        v_result boolean;
    begin
        open c_lgr_info;
        fetch c_lgr_info into
            out_komm_direkt_moegl,
            out_komm_ausweich_lgr_platz,
            out_komm_picken_moegl,
            out_komm_neu_lte_lgr_platz;
        v_result := c_lgr_info%found;
        close c_lgr_info;
        return ( v_result );
    end;

    function get_lgr_wa_info (
        in_lgr_platz          in lvs_lgr.lgr_platz%type,
        out_wa_menge_uebelief out lvs_lgr.wa_menge_ueberlief%type
    ) return boolean is

        cursor c_lgr_info is
        select
            lgr.wa_menge_ueberlief
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz = in_lgr_platz
            and lgr.lgr_verwendung = c.lgr_typ_wa;

        v_result boolean;
    begin
        open c_lgr_info;
        fetch c_lgr_info into out_wa_menge_uebelief;
        v_result := c_lgr_info%found;
        close c_lgr_info;
        return ( v_result );
    end;

    function get_artikel_status (
        in_sid            in lvs_artikel_status.sid%type,
        in_firma_nr       in lvs_artikel_status.firma_nr%type,
        in_artikel_id     in lvs_artikel_status.artikel_id%type,
        in_leitzahl       in lvs_artikel_status.leitzahl%type,
        in_fa_ag          in lvs_artikel_status.fa_ag%type,
        io_artikel_status in out lvs_artikel_status%rowtype,
        in_auto_insert    in boolean
    ) return boolean is

        v_result boolean;
        cursor c_artikel_status is
        select
            t.*
        from
            lvs_artikel_status t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.artikel_id = in_artikel_id
            and ( t.leitzahl = in_leitzahl
                  or ( in_leitzahl is null
                       and t.leitzahl is null ) )
            and ( t.fa_ag = in_fa_ag
                  or ( in_fa_ag is null
                       and t.fa_ag is null ) );

    begin
        open c_artikel_status;
        fetch c_artikel_status into io_artikel_status;
        v_result := c_artikel_status%found;
        close c_artikel_status;
        if
            not v_result
            and in_auto_insert
        then
            insert into lvs_artikel_status (
                sid,
                firma_nr,
                artikel_id,
                leitzahl,
                fa_ag
            ) values ( in_sid,
                       in_firma_nr,
                       in_artikel_id,
                       in_leitzahl,
                       in_fa_ag );

            open c_artikel_status;
            fetch c_artikel_status into io_artikel_status;
            v_result := c_artikel_status%found;
            close c_artikel_status;
        end if;

        return v_result;
    end;

    procedure set_artikel_letztes_einl_datum (
        in_sid                in lvs_artikel_status.sid%type,
        in_firma_nr           in lvs_artikel_status.firma_nr%type,
        in_artikel_id         in lvs_artikel_status.artikel_id%type,
        in_leitzahl           in lvs_artikel_status.leitzahl%type,
        in_fa_ag              in lvs_artikel_status.fa_ag%type,
        in_letztes_einl_datum in lvs_artikel_status.letztes_einl_datum%type
    ) is
        v_artikel_status lvs_artikel_status%rowtype;
        pragma autonomous_transaction;
    begin
        if not get_artikel_status(in_sid, in_firma_nr, in_artikel_id, in_leitzahl, in_fa_ag,
                                  v_artikel_status, true) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_artikel_id_status_erst,
                                     nvl(
                      to_char(in_artikel_id),
                      'null'
                  )));
        end if;

    -- Neuen Wert speichern
        update lvs_artikel_status t
        set
            t.letztes_einl_datum =
                case
                    when in_letztes_einl_datum > nvl(t.letztes_einl_datum, in_letztes_einl_datum - 1) then
                        in_letztes_einl_datum
                    else
                        t.letztes_einl_datum
                end
        where
                t.sid = v_artikel_status.sid
            and t.artikel_status_id = v_artikel_status.artikel_status_id
            and t.letztes_einl_datum != in_letztes_einl_datum;

        commit;
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
    end;

    procedure set_artikel_letztes_ausl_datum (
        in_sid                in lvs_artikel_status.sid%type,
        in_firma_nr           in lvs_artikel_status.firma_nr%type,
        in_artikel_id         in lvs_artikel_status.artikel_id%type,
        in_leitzahl           in lvs_artikel_status.leitzahl%type,
        in_fa_ag              in lvs_artikel_status.fa_ag%type,
        in_letztes_ausl_datum in lvs_artikel_status.letztes_ausl_datum%type
    ) is
        v_artikel_status lvs_artikel_status%rowtype;
        pragma autonomous_transaction;
    begin
        if not get_artikel_status(in_sid, in_firma_nr, in_artikel_id, in_leitzahl, in_fa_ag,
                                  v_artikel_status, true) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_artikel_id_status_erst,
                                     nvl(
                      to_char(in_artikel_id),
                      'null'
                  )));
        end if;

    -- Neuen Wert speichern
        update lvs_artikel_status t
        set
            t.letztes_ausl_datum =
                case
                    when in_letztes_ausl_datum > nvl(t.letztes_ausl_datum, in_letztes_ausl_datum - 1) then
                        in_letztes_ausl_datum
                    else
                        t.letztes_ausl_datum
                end
        where
                t.sid = v_artikel_status.sid
            and t.artikel_status_id = v_artikel_status.artikel_status_id
            and t.letztes_ausl_datum != in_letztes_ausl_datum;

        commit;
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
    end;

    procedure set_artikel_letzte_buchung (
        in_sid            in lvs_artikel_status.sid%type,
        in_firma_nr       in lvs_artikel_status.firma_nr%type,
        in_artikel_id     in lvs_artikel_status.artikel_id%type,
        in_leitzahl       in lvs_artikel_status.leitzahl%type,
        in_fa_ag          in lvs_artikel_status.fa_ag%type,
        in_letzte_buchung in lvs_artikel_status.letzte_buchung%type
    ) is
        v_artikel_status lvs_artikel_status%rowtype;
        pragma autonomous_transaction;
    begin
        if not get_artikel_status(in_sid, in_firma_nr, in_artikel_id, in_leitzahl, in_fa_ag,
                                  v_artikel_status, true) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_artikel_id_status_erst,
                                     nvl(
                      to_char(in_artikel_id),
                      'null'
                  )));
        end if;

    -- Neuen Wert speichern
        update lvs_artikel_status t
        set
            t.letzte_buchung =
                case
                    when in_letzte_buchung > nvl(t.letzte_buchung, in_letzte_buchung - 1) then
                        in_letzte_buchung
                    else
                        t.letzte_buchung
                end
        where
                t.sid = v_artikel_status.sid
            and t.artikel_status_id = v_artikel_status.artikel_status_id
            and t.letzte_buchung != in_letzte_buchung;

        commit;
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
    end;

    function get_lte (
        in_lte_id in lvs_lte.lte_id%type,
        io_lte    in out lvs_lte%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_lte is
        select
            *
        from
            lvs_lte t
        where
            t.lte_id = in_lte_id;

    begin
        open c_lte;
        fetch c_lte into io_lte;
        v_result := c_lte%found;
        close c_lte;
        return ( v_result );
    end;

    function get_lte_hist (
        in_lte_id in lvs_lte.lte_id%type,
        io_lte    in out lvs_lte%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_lte is
        select
            *
        from
            lvs_lte_hist t
        where
            t.lte_id = in_lte_id;

    begin
        open c_lte;
        fetch c_lte into io_lte;
        v_result := c_lte%found;
        close c_lte;
        return ( v_result );
    end;

    function get_lhm (
        in_lhm_id in lvs_lhm.lhm_id%type,
        io_lhm    in out lvs_lhm%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_lhm is
        select
            *
        from
            lvs_lhm t
        where
            t.lhm_id = in_lhm_id;

    begin
        open c_lhm;
        fetch c_lhm into io_lhm;
        v_result := c_lhm%found;
        close c_lhm;
        return ( v_result );
    end;

    function get_lhm_by_lte_id (
        in_lte_id in lvs_lhm.lte_id%type,
        in_lhm_id in lvs_lhm.lhm_id%type,
        io_lhm    in out lvs_lhm%rowtype
    ) return boolean is

        v_lte    lvs_lte%rowtype;
        v_result boolean;
        cursor c_lhm is
        select
            *
        from
            lvs_lhm t
        where
                t.lte_id = in_lte_id
            and ( t.lhm_id = in_lhm_id
                  or in_lhm_id is null );

    begin
        if not get_lte(in_lte_id, v_lte) then
            raise_isi_error(10,
                            lc.ec_p1(lc.o_tp1_lte_id_fehlt,
                                     nvl(in_lte_id, 'null')));
        end if;

        if
            in_lhm_id is null
            and nvl(v_lte.lte_akt_lhm, 0) > 1
        then
            raise_isi_error(20,
                            lc.ec_p1(lc.o_tp1_lhm_auf_lte_n_uninque,
                                     nvl(in_lte_id, 'null')));

        end if;

        open c_lhm;
        fetch c_lhm into io_lhm;
        v_result := c_lhm%found;
        close c_lhm;
        return ( v_result );
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
    end;

    function get_lam (
        in_sid      in lvs_lam.sid%type,
        in_firma_nr in lvs_lam.firma_nr%type,
        in_lam_id   in lvs_lam.lam_id%type,
        io_lam      in out lvs_lam%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_lam is
        select
            *
        from
            lvs_lam t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lam_id = in_lam_id;

    begin
        open c_lam;
        fetch c_lam into io_lam;
        v_result := c_lam%found;
        close c_lam;
        return ( v_result );
    end;

    function get_lam_by_lhm_id (
        in_sid      in lvs_lam.sid%type,
        in_firma_nr in lvs_lam.firma_nr%type,
        in_lhm_id   in lvs_lam.lhm_id%type,
        io_lam      in out lvs_lam%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_lam is
        select
            *
        from
            lvs_lam t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lhm_id = in_lhm_id;

    begin
        open c_lam;
        fetch c_lam into io_lam;
        v_result := c_lam%found;
        close c_lam;
        return ( v_result );
    end;

    function get_lam_by_lte_id (
        in_sid      in lvs_lam.sid%type,
        in_firma_nr in lvs_lam.firma_nr%type,
        in_lte_id   in lvs_lam.lte_id%type,
        io_lam      in out lvs_lam%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_lam is
        select
            *
        from
            lvs_lam t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lte_id = in_lte_id;

    begin
        open c_lam;
        fetch c_lam into io_lam;
        v_result := c_lam%found;
        if c_lam%rowcount > 1 -- Es gibt mehr als einen Eintrag
         then
            io_lam := null;     -- dann keine Daten
            v_result := null;
        end if;

        close c_lam;
        return ( v_result );
    end;

    function get_lam_bh_by_id (
        in_lam_bh_id in lvs_lam_bh.lam_bh_id%type,
        io_lam_bh    in out lvs_lam_bh%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_lam_bh is
        select
            t.*
        from
            lvs_lam_bh t
        where
            t.lam_bh_id = in_lam_bh_id;

    begin
        open c_lam_bh;
        fetch c_lam_bh into io_lam_bh;
        v_result := c_lam_bh%found;
        close c_lam_bh;
        return ( v_result );
    end;

    function get_charge (
        in_charge_id in lvs_charge.charge_id%type,
        io_charge    in out lvs_charge%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_charge is
        select
            *
        from
            lvs_charge t
        where
            t.charge_id = in_charge_id;

    begin
        open c_charge;
        fetch c_charge into io_charge;
        v_result := c_charge%found;
        close c_charge;
        return ( v_result );
    end;

    function get_charge_bez (
        in_sid        in lvs_charge.sid%type,
        in_charge     in lvs_charge.charge_bez%type,
        in_artikel_id in lvs_charge.artikel_id%type,
        io_charge     in out lvs_charge%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_charge is
        select
            *
        from
            lvs_charge t
        where
                t.sid = in_sid
            and t.charge_bez = in_charge
            and t.artikel_id = in_artikel_id;

    begin
        open c_charge;
        fetch c_charge into io_charge;
        v_result := c_charge%found;
        close c_charge;
        return ( v_result );
    end;

    function get_transport (
        in_sid       in isi_transport.sid%type,
        in_transp_id in isi_transport.transp_id%type,
        io_transport in out isi_transport%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.transp_id = in_transp_id;

    begin
        open c_transport;
        fetch c_transport into io_transport;
        v_result := c_transport%found;
        close c_transport;
        return ( v_result );
    end;

    function get_transport_by_lte_id (
        in_lte_id    in isi_transport.lte_id%type,
        io_transport in out isi_transport%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
            t.lte_id = in_lte_id;

    begin
        open c_transport;
        fetch c_transport into io_transport;
        v_result := c_transport%found;
        close c_transport;
        return ( v_result );
    end;

    function get_fahrzeug (
        in_res_id   in lvs_fahrzeuge.res_id%type,
        io_fahrzeug in out lvs_fahrzeuge%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_fahrzeuge is
        select
            *
        from
            lvs_fahrzeuge t
        where
            t.res_id = in_res_id;

    begin
        open c_fahrzeuge;
        fetch c_fahrzeuge into io_fahrzeug;
        v_result := c_fahrzeuge%found;
        close c_fahrzeuge;
        return ( v_result );
    end;

    function get_lvs_lgr_ort_ue_platz (
        in_sid                  in lvs_lam.sid%type,
        in_firma_nr             in lvs_lam.firma_nr%type,
        in_lgr_ort_quelle       in lvs_lgr_ort_ue_platz.lgr_ort_quelle%type,
        in_lgr_ort_ziel         in lvs_lgr_ort_ue_platz.lgr_ort_ziel%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_name             in lvs_lte.lte_name%type,
        io_lvs_lgr_ort_ue_platz in out lvs_lgr_ort_ue_platz%rowtype
    ) return boolean is
    -- Tabelle für die Erzeugung von Staffeltransporten
        v_result boolean;

    -- AG 20170814 Übergabeplatz ggf. nur fuer bestimmte Palettentypen
        cursor c_lvs_lgr_ort_ue_platz is
        select
            *
        from
            lvs_lgr_ort_ue_platz t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort_quelle = in_lgr_ort_quelle
            and t.lgr_ort_ziel = in_lgr_ort_ziel
            and ( t.lte_name = in_lte_name
                  or ( in_lte_name is null
                       and t.lte_name is null )
                  or t.lte_name is null )
            and nvl(t.lgr_platz, in_lgr_platz || 'X') != in_lgr_platz -- -AG- 27.01.2011 NULL bedeutet, dass kein Weg vorhanden ist
        order by
            nvl(t.lte_name, in_lte_name || 'X');

    begin
        io_lvs_lgr_ort_ue_platz := null;
        open c_lvs_lgr_ort_ue_platz;
        fetch c_lvs_lgr_ort_ue_platz into io_lvs_lgr_ort_ue_platz;
        v_result := c_lvs_lgr_ort_ue_platz%found;
        close c_lvs_lgr_ort_ue_platz;
        return v_result;
    end;

    function lagerbestand_vorhanden_menge (
        in_sid             in lvs_lam.sid%type,
        in_firma_nr        in lvs_lam.firma_nr%type,
        in_artikel_id      in lvs_lam.artikel_id%type,
        in_leitzahl        in lvs_lam.leitzahl%type,
        in_fa_ag           in lvs_lam.fa_ag%type,
        in_zeichnung_index in lvs_lam.zeichnung_index%type,
        in_lgr_ort         in lvs_lgr.lgr_ort%type,
        out_menge_ges      out number,
        out_anzahl_lam     out number
    ) return boolean is

        v_result boolean;
        cursor c_lam_art is
        select
            count(*),
            sum(l.menge)
        from
            lvs_lam l,
            lvs_lte lte
        where
                l.artikel_id = in_artikel_id
            and nvl(l.leitzahl, -1) = nvl(in_leitzahl,
                                          nvl(l.leitzahl, -1))
            and nvl(l.fa_ag, -1) = nvl(in_fa_ag,
                                       nvl(l.fa_ag, -1))
            and nvl(l.zeichnung_index, '@@NULL@@') = nvl(in_zeichnung_index,
                                                         nvl(l.zeichnung_index, '@@NULL@@'))
            and l.lgr_platz is not null -- LAM ist auf einem Lagerplatz
            and l.lte_id = lte.lte_id
            and lte.lte_status = c.lte_lf_stat -- steht im Lager
            and ( lte.lgr_ort = in_lgr_ort
                  or in_lgr_ort is null ); -- (optional) nur in diesem Lagerort
    begin
        open c_lam_art;
        fetch c_lam_art into
            out_anzahl_lam,
            out_menge_ges;
        v_result := c_lam_art%found;
        close c_lam_art;

    -- v_result korrigieren, falls keine Mengen vorhanden sind.
        v_result :=
            v_result
            and out_anzahl_lam > 0
            and out_menge_ges > 0;
        return ( v_result );
    end;

    function lagerbestand_verfuegbar_menge (
        in_sid             in lvs_lam.sid%type,
        in_firma_nr        in lvs_lam.firma_nr%type,
        in_artikel_id      in lvs_lam.artikel_id%type,
        in_leitzahl        in lvs_lam.leitzahl%type,
        in_fa_ag           in lvs_lam.fa_ag%type,
        in_zeichnung_index in lvs_lam.zeichnung_index%type,
        in_lgr_ort         in lvs_lgr.lgr_ort%type,
        out_menge_ges      out number,
        out_anzahl_lam     out number
    ) return boolean is

        v_result boolean;
        cursor c_lam_art is
        select
            count(*),
            sum(l.menge)
        from
            lvs_lam l,
            lvs_lte lte
        where
                l.artikel_id = in_artikel_id
            and nvl(l.leitzahl, -1) = nvl(in_leitzahl,
                                          nvl(l.leitzahl, -1))
            and nvl(l.fa_ag, -1) = nvl(in_fa_ag,
                                       nvl(l.fa_ag, -1))
            and nvl(l.zeichnung_index, '@@NULL@@') = nvl(in_zeichnung_index,
                                                         nvl(l.zeichnung_index, '@@NULL@@'))
            and l.lgr_platz is not null -- LAM ist auf einem Lagerplatz
            and l.lte_id = lte.lte_id
            and lte.lte_status = c.lte_lf_stat -- steht im Lager
            and ( lte.lgr_ort = in_lgr_ort
                  or in_lgr_ort is null ) -- (optional) nur in diesem Lagerort
            and l.order_pos_auf_id is null -- keine Reservierung auf LAM
            and l.labor_status = 'F' -- nicht gesperrt oder quarantäne
            and lte.order_vorgang_id is null -- keine Reservierung auf LTE
            and l.akt_inventur_id is null; -- keine aktive Inventur
    begin
        open c_lam_art;
        fetch c_lam_art into
            out_anzahl_lam,
            out_menge_ges;
        v_result := c_lam_art%found;
        close c_lam_art;

    -- v_result korrigieren, falls keine Mengen vorhanden sind.
        v_result :=
            v_result
            and out_anzahl_lam > 0
            and out_menge_ges > 0;
        return ( v_result );
    end;

    function lagerbestand_vorhanden (
        in_sid             in lvs_lam.sid%type,
        in_firma_nr        in lvs_lam.firma_nr%type,
        in_artikel_id      in lvs_lam.artikel_id%type,
        in_leitzahl        in lvs_lam.leitzahl%type,
        in_fa_ag           in lvs_lam.fa_ag%type,
        in_zeichnung_index in lvs_lam.zeichnung_index%type,
        in_lgr_ort         in lvs_lgr.lgr_ort%type
    ) return boolean is
        v_menge  number;
        v_count  number;
        v_result boolean;
    begin
        v_result := lagerbestand_vorhanden_menge(in_sid, in_firma_nr, in_artikel_id, in_leitzahl, in_fa_ag,
                                                 in_zeichnung_index, in_lgr_ort, v_menge, v_count);

        return ( v_result );
    end;

    function lagerbestand_verfuegbar (
        in_sid             in lvs_lam.sid%type,
        in_firma_nr        in lvs_lam.firma_nr%type,
        in_artikel_id      in lvs_lam.artikel_id%type,
        in_leitzahl        in lvs_lam.leitzahl%type,
        in_fa_ag           in lvs_lam.fa_ag%type,
        in_zeichnung_index in lvs_lam.zeichnung_index%type,
        in_lgr_ort         in lvs_lgr.lgr_ort%type
    ) return boolean is
        v_menge  number;
        v_count  number;
        v_result boolean;
    begin
        v_result := lagerbestand_verfuegbar_menge(in_sid, in_firma_nr, in_artikel_id, in_leitzahl, in_fa_ag,
                                                  in_zeichnung_index, in_lgr_ort, v_menge, v_count);

        return ( v_result );
    end;

    function get_packschema_kopf (
        in_sid                in lvs_packschema_kopf.sid%type,
        in_firma_nr           in lvs_packschema_kopf.firma_nr%type,
        in_packschema_kopf_id in lvs_packschema_kopf.packschema_kopf_id%type,
        io_packschema_kopf    in out lvs_packschema_kopf%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_packschema_kopf is
        select
            t.*
        from
            lvs_packschema_kopf t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.packschema_kopf_id = in_packschema_kopf_id;

    begin
        open c_packschema_kopf;
        fetch c_packschema_kopf into io_packschema_kopf;
        v_result := c_packschema_kopf%found;
        close c_packschema_kopf;
        return ( v_result );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_transp_by_lte_id (
        in_sid     in isi_sid.sid%type,
        in_lte_id  in lvs_lte.lte_id%type,
        out_transp out isi_transport%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_transp is
        select
            t.*
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.lte_id = in_lte_id;

    begin
        out_transp := null;
        open c_transp;
        fetch c_transp into out_transp;
        v_found := c_transp%found;
        close c_transp;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_transp_by_transp_id (
        in_sid       in isi_sid.sid%type,
        in_transp_id in isi_transport.transp_id%type,
        out_transp   out isi_transport%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_transp is
        select
            t.*
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.transp_id = in_transp_id;

    begin
        out_transp := null;
        open c_transp;
        fetch c_transp into out_transp;
        v_found := c_transp%found;
        close c_transp;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_transp_grp_by_lte_id (
        in_sid         in isi_sid.sid%type,
        in_lte_id      in lvs_lte.lte_id%type,
        out_transp_grp out isi_transport_grp%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_transp is
        select
            t.*
        from
            isi_transport_grp t
        where
                t.sid = in_sid
            and t.lte_id = in_lte_id;

    begin
        out_transp_grp := null;
        open c_transp;
        fetch c_transp into out_transp_grp;
        v_found := c_transp%found;
        close c_transp;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_transp_grp_by_lte_grp_id (
        in_sid         in isi_sid.sid%type,
        in_lte_grp_id  in lvs_lte.lte_id%type,
        out_transp_grp out isi_transport_grp%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_transp is
        select
            t.*
        from
            isi_transport_grp t
        where
                t.sid = in_sid
            and t.lte_grp_id = in_lte_grp_id;

    begin
        out_transp_grp := null;
        open c_transp;
        fetch c_transp into out_transp_grp;
        v_found := c_transp%found;
        close c_transp;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_transp_grp_by_transp_id (
        in_sid           in isi_sid.sid%type,
        in_transp_grp_id in isi_transport.transp_id%type,
        out_transp_grp   out isi_transport_grp%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_transp is
        select
            t.*
        from
            isi_transport_grp t
        where
                t.sid = in_sid
            and t.transp_id = in_transp_grp_id;

    begin
        out_transp_grp := null;
        open c_transp;
        fetch c_transp into out_transp_grp;
        v_found := c_transp%found;
        close c_transp;
        return ( v_found );
    end;

    function get_transp_id_by_lte_id (
        in_sid        in isi_sid.sid%type,
        in_lte_id     in lvs_lte.lte_id%type,
        out_transp_id out isi_transport.transp_id%type
    ) return boolean is
        v_found boolean;
        cursor c_transp_id is
        select
            t.transp_id
        from
            isi_transport t
        where
            t.lte_id = in_lte_id;

    begin
        out_transp_id := null;
        open c_transp_id;
        fetch c_transp_id into out_transp_id;
        v_found := c_transp_id%found;
        close c_transp_id;
        return ( v_found );
    end;

    function get_lgr_ort_fuellg_chk_by_p (
        in_sid                       in isi_sid.sid%type,
        in_firma_nr                  in isi_firma.firma_nr%type,
        in_lgr_ort                   in lvs_lgr_ort.lgr_ort%type,
        in_lgr_gruppe_id             in lvs_lgr.lgr_gruppe_id%type,
        in_lte_name                  in lvs_lte_cfg.lte_name%type,
        out_lvs_lgr_ort_fuellg_check out lvs_lgr_ort_fuellg_check%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_lvs_lgr_ort_fuellg_check is
        select
            *
        from
            lvs_lgr_ort_fuellg_check t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort = in_lgr_ort
            and nvl(t.lgr_gruppe_id,
                    nvl(in_lgr_gruppe_id, -1)) = nvl(in_lgr_gruppe_id, -1)
            and nvl(t.lte_name,
                    nvl(in_lte_name, 'XXXX')) = nvl(in_lte_name, 'XXXX');

    begin
        open c_lvs_lgr_ort_fuellg_check;
        fetch c_lvs_lgr_ort_fuellg_check into out_lvs_lgr_ort_fuellg_check;
        v_found := c_lvs_lgr_ort_fuellg_check%found;
        close c_lvs_lgr_ort_fuellg_check;
        return ( v_found );
    end;

end lvs_p_base;
/


-- sqlcl_snapshot {"hash":"6949979261e02750a7598107f1a5d750a44b9179","type":"PACKAGE_BODY","name":"LVS_P_BASE","schemaName":"DIRKSPZM32","sxml":""}