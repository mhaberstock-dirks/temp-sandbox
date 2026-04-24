create or replace package body dirkspzm32.lvs_p_inventur is

    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end get_version;

    procedure set_artikel_akt_inventur_id (
        in_sid             in lvs_artikel_status.sid%type,
        in_firma_nr        in lvs_artikel_status.firma_nr%type,
        in_artikel_id      in lvs_artikel_status.artikel_id%type,
        in_leitzahl        in lvs_artikel_status.leitzahl%type,
        in_fa_ag           in lvs_artikel_status.fa_ag%type,
        in_akt_inventur_id in lvs_artikel_status.akt_inventur_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(2550);
    -------------------------------------------------------------------------------------------------------

        v_artikel_status lvs_artikel_status%rowtype;
        v_artikel        isi_artikel%rowtype;
    begin
        if not isi_allg.get_artikel_by_artikel_id(in_sid, in_artikel_id, v_artikel) then
            v_err_nr := 5;
            v_err_text := lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                   nvl(
                                                to_char(in_artikel_id),
                                                'null'
                                            ));

            raise v_error;
        end if;

        if not lvs_p_base.get_artikel_status(in_sid, in_firma_nr, in_artikel_id, in_leitzahl, in_fa_ag,
                                             v_artikel_status, true) then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_inv_artikel_status_erst,
                                   nvl(
                                                to_char(v_artikel.artikel),
                                                'null'
                                            ));

            raise v_error;
        end if;

        if
            v_artikel_status.akt_inventur_id is not null
            and v_artikel_status.akt_inventur_id != in_akt_inventur_id
        then
            v_err_nr := 20;
            v_err_text := lc.ec_p2(lc.o_tp2_inv_artikel_ist_invertur,
                                   nvl(
                                                to_char(v_artikel.artikel),
                                                'null'
                                            ),
                                   to_char(v_artikel_status.akt_inventur_id));

            raise v_error;
        end if;

    -- Neuen Wert speichern
        update lvs_artikel_status t
        set
            t.akt_inventur_id = in_akt_inventur_id
        where
                t.sid = v_artikel_status.sid
            and t.artikel_status_id = v_artikel_status.artikel_status_id;

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

    procedure set_artikel_letzte_inventur (
        in_sid                in lvs_artikel_status.sid%type,
        in_firma_nr           in lvs_artikel_status.firma_nr%type,
        in_artikel_id         in lvs_artikel_status.artikel_id%type,
        in_leitzahl           in lvs_artikel_status.leitzahl%type,
        in_fa_ag              in lvs_artikel_status.fa_ag%type,
        in_letzte_inventur_id in lvs_artikel_status.akt_inventur_id%type,
        in_letzte_inv_datum   in lvs_artikel_status.letzte_inventur_datum%type,
        in_letzte_in_login_id in lvs_artikel_status.letzte_inventur_login_id%type,
        in_reset_akt_inv_id   in varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(2550);
    -------------------------------------------------------------------------------------------------------
        v_artikel_status lvs_artikel_status%rowtype;
        v_artikel        isi_artikel%rowtype;
    begin
        if not isi_allg.get_artikel_by_artikel_id(in_sid, in_artikel_id, v_artikel) then
            v_err_nr := 5;
            v_err_text := lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                   nvl(
                                                to_char(in_artikel_id),
                                                'null'
                                            ));

            raise v_error;
        end if;

        if not lvs_p_base.get_artikel_status(in_sid, in_firma_nr, in_artikel_id, in_leitzahl, in_fa_ag,
                                             v_artikel_status, true) then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_inv_artikel_status_erst,
                                   nvl(
                                                to_char(v_artikel.artikel),
                                                'null'
                                            ));

            raise v_error;
        end if;

    -- Neuen Wert speichern
        update lvs_artikel_status t
        set
            t.letzte_inventur_id = in_letzte_inventur_id,
            t.letzte_inventur_datum = in_letzte_inv_datum,
            t.letzte_inventur_login_id = in_letzte_in_login_id
        where
                t.sid = v_artikel_status.sid
            and t.artikel_status_id = v_artikel_status.artikel_status_id;

        if in_reset_akt_inv_id = c.c_true then
            update lvs_artikel_status t
            set
                t.akt_inventur_id = null
            where
                    t.sid = v_artikel_status.sid
                and t.artikel_status_id = v_artikel_status.artikel_status_id;

        end if;

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

  /*
    20160831 Neue Funktion, die ermittelt ob für eine Artikel eine Inventur durchgeführt werden kann
             - Aus Fehler euscher W20310-28
  */
    function artikel_fuer_inventur_da (
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
            and lte.lte_status in ( 'LF', 'BS', 'BF', 'AF' )
            and ( lte.lgr_ort = in_lgr_ort
                  or in_lgr_ort is null ); -- (optional) nur in diesem Lagerort
    begin
        open c_lam_art;
        fetch c_lam_art into
            v_count,
            v_menge;
        v_result := c_lam_art%found;
        close c_lam_art;

    -- v_result korrigieren, falls keine Mengen vorhanden sind.
        v_result :=
            v_result
            and v_count > 0
            and v_menge > 0;
        return ( v_result );
    end;

end lvs_p_inventur;
/


-- sqlcl_snapshot {"hash":"6a3e4b8f3bdab311416bb348153e2ff120eca7c6","type":"PACKAGE_BODY","name":"LVS_P_INVENTUR","schemaName":"DIRKSPZM32","sxml":""}