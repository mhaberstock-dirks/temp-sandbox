create or replace package body dirkspzm32.isi_p_order is

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

  -- Lokale Deklarationen für dieses Package
procedure rest_mg_wai_ma_pruefen_rt (
    in_sid       in isi_sid.sid%type,
    in_firma_nr  in isi_firma.firma_nr%type,
    in_order_pos in isi_order_pos%rowtype
);

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function loescht alle Transporte einer Order optinal einer Order_AufID
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure abbruch_transporte (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_id  in isi_order_kopf.vorgang_id%type,
        in_auf_id      in isi_order_pos.auf_id%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_satzart     in isi_order_kopf.satzart%type,
        in_user_id     in isi_user.login_id%type,
        in_res_rueck   in varchar2               -- False (Reservirung stehen lassen)
    ) is
    begin
        abbruch_transporte_359(in_sid, in_firma_nr, in_vorgang_id, null, null,
                               in_auf_id, in_vorgang_typ, in_satzart, in_user_id, 'T',
                               in_res_rueck);
    end;
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function loescht alle Transporte einer Order optinal einer Order_AufID
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure abbruch_transporte_359 (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_id  in isi_order_kopf.vorgang_id%type,
        in_li_nr       in isi_order_pos.li_nr%type,
        in_li_pos_nr   in isi_order_pos.li_pos_nr%type,
        in_auf_id      in isi_order_pos.auf_id%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_satzart     in isi_order_kopf.satzart%type,
        in_user_id     in isi_user.login_id%type,
        in_del_transp  in varchar2,              -- FALSE (Keine Transporte löschen)
        in_res_rueck   in varchar2               -- False (Reservirung stehen lassen)
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(255);
        v_pos        isi_order_pos%rowtype;                    -- Positionsdaten

    --v_found                   boolean;                                  -- Dtaen gefunden
        v_transporte isi_transport%rowtype;
        v_lte        lvs_lte%rowtype;          --

        v_result     number;
        v_n_status   varchar2(1);

    -- KONSI-Lager und Retoure berücksichtigen
        cursor c_pos is
        select
            pos.*
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and ( ( pos.satzart = in_satzart
                    and pos.vorgang_typ = in_vorgang_typ )
                  or ( in_auf_id is null
                       and pos.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                            'LNK' )
                       and pos.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' ) ) )
            and pos.vorgang_id = in_vorgang_id
            and ( pos.li_nr = in_li_nr
                  or in_li_nr is null )                   -- optional nur einen Lieferschein bearbeiten
            and ( pos.li_pos_nr = in_li_pos_nr
                  or in_li_pos_nr is null )       -- optional nur einen Lieferscheinposition bearbeiten
            and ( ( pos.status in ( 'D', 'R', 'T' )
                    and in_del_transp = c.c_true )
                  or pos.status in ( 'D', 'R', 'V' ) )
            and ( pos.auf_id = in_auf_id
                  or in_auf_id is null )                -- optional nur eine auf_id bearbeiten
        order by
            pos.transport_gruppe desc,
            pos.vorgang_id,
            pos.li_nr,
            pos.li_pos_nr;

        cursor c_transporte is
        select
            *
        from
            isi_transport tra
        where
                tra.sid = in_sid
            and tra.firma_nr = in_firma_nr
            and tra.auf_id = v_pos.auf_id;

        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.firma_nr = in_firma_nr
            and ( lte.order_auf_id = v_pos.auf_id
                  or lte.order_vorgang_id = v_pos.vorgang_id );

    begin
        v_err_nr := null;
        v_err_text := null;
        if in_res_rueck = c.c_true then
            v_n_status := 'N';
        else
            v_n_status := 'D';
        end if;

        update isi_order_kopf kopf
        set
            kopf.freigegeben_datum = null,
            kopf.status = v_n_status
        where
                kopf.sid = in_sid
            and kopf.firma_nr = in_firma_nr
            and kopf.vorgang_typ = in_vorgang_typ
            and kopf.vorgang_id = in_vorgang_id
            and ( kopf.li_nr = in_li_nr
                  or in_li_nr is null )
            and kopf.satzart = in_satzart
            and kopf.status != 'E'
            and kopf.freigabe_datum is null;

        open c_pos;
        loop
            fetch c_pos into v_pos;                                             -- Positionsdaten lesen
            exit when c_pos%notfound;

      -- Transporte für diese Order_Pos löschen
            open c_transporte;
            loop
                fetch c_transporte into v_transporte;
                exit when c_transporte%notfound;
                begin
          -- Transporte löschen
                    v_result := lvs_transport.lvs_transp_loeschen(in_sid, in_firma_nr, in_user_id, v_transporte.transp_id, 'F');
          /* Referenz zur Tour stehen lassen
          if v_result != 0 then
            -- Transporte nicht mehr zu loeschen
            update isi_transport tra
               set tra.vorgang_id = NULL,
                   tra.auf_id = NULL,
                   tra.auf_id_extern = NULL
             where tra.sid = in_sid
               and tra.firma_nr = in_firma_nr
               and tra.transp_id = v_transporte.transp_id;
          end if;
          */
                exception
                    when others then
                        null;
                end;

            end loop;

            close c_transporte;

      -- LTE's dieser Order_Pos zurücksetzen
            if in_res_rueck = c.c_true then
                open c_lte;
                loop
                    fetch c_lte into v_lte;
                    exit when c_lte%notfound;                       -- Reservierungen Ruecksetzen

                    v_result := lvs_ausl.lvs_lte_res_rueck(v_pos.sid, v_pos.firma_nr, v_pos.vorgang_id, v_pos.auf_id, v_lte.lte_id,
                                                           v_lte.order_vorgang_id, v_lte.lgr_platz, c.c_true);

                end loop;

                close c_lte;
                delete isi_komm_order t
                where
                    t.auf_id = v_pos.auf_id;

                update isi_order_pos pos
                set
                    pos.freigegeben_datum = null,                    -- FreigabeDatum setzen
                    pos.ware_disponiert = 'F',
                    pos.status = 'N'
                where
                        pos.sid = v_pos.sid
                    and pos.firma_nr = v_pos.firma_nr
                    and pos.auf_id = v_pos.auf_id;

            else
                update isi_order_pos pos
                set
                    pos.freigegeben_datum = null,                    -- FreigabeDatum setzen
                    pos.status = 'R'
                where
                        pos.sid = v_pos.sid
                    and pos.firma_nr = v_pos.firma_nr
                    and pos.auf_id = v_pos.auf_id;

            end if;

        end loop;

        close c_pos;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_pos%isopen then
                close c_pos;
            end if;
            if c_transporte%isopen then
                close c_transporte;
            end if;
            if c_lte%isopen then
                close c_lte;
            end if;
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            if c_pos%isopen then
                close c_pos;
            end if;
            if c_transporte%isopen then
                close c_transporte;
            end if;
            if c_lte%isopen then
                close c_lte;
            end if;
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function loescht alle Transporte einer Order optinal einer Order_AufID
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_abbruch_transporte (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_id  in isi_order_kopf.vorgang_id%type,
        in_auf_id      in isi_order_pos.auf_id%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_satzart     in isi_order_kopf.satzart%type,
        in_user_id     in isi_user.login_id%type,
        in_res_rueck   in varchar2               -- False (Reservirung stehen lassen)
    ) is
    begin
        abbruch_transporte(in_sid, in_firma_nr, in_vorgang_id, in_auf_id, in_vorgang_typ,
                           in_satzart, in_user_id, in_res_rueck);

        commit;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function loescht alle Transporte einer Verladung
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_abbr_trans_lief (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_tour_nr   in isi_order_kopf.vorgang_id%type,
        in_user_id   in isi_user.login_id%type,
        in_res_rueck in varchar2               -- False (Reservirung stehen lassen)
    ) is
    begin
        abbruch_transporte(in_sid, in_firma_nr, in_tour_nr, null, 'WAE',
                           'LI', in_user_id, in_res_rueck);

        commit;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function loescht alle Transporte einer Verladung
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_abbr_trans_lief_359 (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_tour_nr    in isi_order_kopf.vorgang_id%type,
        in_li_nr      in isi_order_pos.li_nr%type,
        in_li_pos_nr  in isi_order_pos.li_pos_nr%type,
        in_user_id    in isi_user.login_id%type,
        in_del_transp in varchar2,              -- FALSE (Keine Transporte löschen)
        in_res_rueck  in varchar2               -- False (Reservirung stehen lassen)
    ) is
    begin
        abbruch_transporte_359(in_sid, in_firma_nr, in_tour_nr, in_li_nr, in_li_pos_nr,
                               null, 'WAE', 'LI', in_user_id, in_del_transp,
                               in_res_rueck);

        commit;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- peocedure bereitet eine Order vor, dass diese in der PRIO auf 9 und im
  -- Freigabedatum audn SYSDATE (soforrt) und den Status auf 'V' (Vorbereitet
  -- Diese Order wired dann im KOM-Prozess als nächstet gestartet
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure vorbereiten_trans_lief (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type,
        in_user_id  in isi_user.login_id%type
    ) is

        v_order_kopf isi_order_kopf%rowtype;
        v_found      boolean;                                  -- Dtaen gefunden

        cursor c_order_kopf is
        select
            *
        from
            isi_order_kopf k
        where
                k.vorgang_id = in_tour_nr
            and k.firma_nr = in_firma_nr
            and k.sid = in_sid
            and k.status != 'N';

    begin
        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if v_found then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_order_auft_no_update);
      -- v_err_text := 'Fehler: Es sind noch Transporte für diese Tour eingetragen, die nicht gelöscht werden konnten. Bitte Transporte prüfen und nochmals versuchen.';
            raise v_error;
        end if;

        update isi_order_kopf t
        set
            t.prioritaet = 9,
            t.freigabe_datum = sysdate,
            t.status = 'V'
        where
            t.vorgang_id = in_tour_nr;

        update isi_order_pos t
        set
            t.prioritaet = 9,
            t.freigabe_datum = sysdate,
            t.status = 'V'
        where
            t.vorgang_id = in_tour_nr;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- peocedure bereitet eine Order vor, dass diese in der PRIO auf 9 und im
  -- Freigabedatum audn SYSDATE (soforrt) und den Status auf 'V' (Vorbereitet
  -- Diese Order wired dann im KOM-Prozess als nächstet gestartet
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_vorbereiten_trans_lief (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type,
        in_user_id  in isi_user.login_id%type
    ) is
    begin
        null; -- -Todo: impl
        commit;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function aktiviert alle Transporte einer Verladung
  --
  -- mit COMMIT
  --  Achtung diese procedure macht schon ein COMMIT nach jedem Loeschen eines
  --  Transports. Hier kann die die Transaktion durchbrochen werden
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_aktiv_trans_lief (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_tour_nr    in isi_order_kopf.vorgang_id%type,
        in_user_id    in isi_user.login_id%type,
        in_aktivieren in varchar2               -- False (Nur Reservieren)
    ) is
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2056);
        v_ret_text varchar2(2056);
  --******************************************************************************
    begin
        v_ret_text := aktiv_trans_lief(in_sid,               -- in_sid         in isi_sid.sid%type,
         in_firma_nr,          -- in_firma_nr    in isi_firma.firma_nr%type,
         in_tour_nr,           -- in_tour_nr     in isi_order_kopf.vorgang_id%type,
         in_user_id,           -- in_user_id     in isi_user.login_id%type,
         in_aktivieren);       -- in_aktivieren  in varchar2               -- False (Nur Reservieren)
        commit;
        if v_ret_text is not null then
            v_err_nr := 99;
            v_err_text := v_ret_text;
            raise v_error;
        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end c_aktiv_trans_lief;
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function aktiviert alle Transporte einer Verladung
  --
  -- mit COMMIT
  --  Achtung diese procedure macht schon ein COMMIT nach jedem Loeschen eines
  --  Transports. Hier kann die die Transaktion durchbrochen werden
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_aktiv_trans_lief_359 (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_tour_nr    in isi_order_kopf.vorgang_id%type,
        in_li_nr      in isi_order_pos.li_nr%type,
        in_li_pos_nr  in isi_order_pos.li_pos_nr%type,
        in_anz_pos    in number,
        in_user_id    in isi_user.login_id%type,
        in_aktivieren in varchar2               -- False (Nur Reservieren)
    ) is
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2056);
        v_ret_text varchar2(2056);
  --******************************************************************************
    begin
        v_ret_text := aktiv_trans_lief_359(in_sid,               -- in_sid         in isi_sid.sid%type,
         in_firma_nr,          -- in_firma_nr    in isi_firma.firma_nr%type,
         in_tour_nr,           -- in_tour_nr     in isi_order_kopf.vorgang_id%type,
         in_li_nr,             -- in isi_order_pos.li_nr%type,
         in_li_pos_nr,         -- in isi_order_pos.li_pos_nr%type,
                                           in_anz_pos,           -- in number,
                                            in_user_id,           -- in_user_id     in isi_user.login_id%type,
                                            in_aktivieren);       -- in_aktivieren  in varchar2               -- False (Nur Reservieren)
        commit;
        if v_ret_text is not null then
            v_err_nr := 99;
            v_err_text := v_ret_text;
            raise v_error;
        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end c_aktiv_trans_lief_359;

  --------------------------------------------------------------------------------
  -- function aktiviert alle Transporte einer Verladung
  --
  -- ohne COMMIT
  --  Achtung diese procedure macht schon ein COMMIT nach jedem Loeschen eines
  --  Transports. Hier kann die die Transaktion durchbrochen werden
  --------------------------------------------------------------------------------
  --******************************************************************************
    function aktiv_trans_lief (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_tour_nr    in isi_order_kopf.vorgang_id%type,
        in_user_id    in isi_user.login_id%type,
        in_aktivieren in varchar2               -- False (Nur Reservieren)
    ) return varchar2 is
        v_ret_text varchar2(2056);
    begin
        v_ret_text := aktiv_trans_lief_359(in_sid,               -- in_sid         in isi_sid.sid%type,
         in_firma_nr,          -- in_firma_nr    in isi_firma.firma_nr%type,
         in_tour_nr,           -- in_tour_nr     in isi_order_kopf.vorgang_id%type,
         null,                 -- in isi_order_pos.li_nr%type,
         null,                 -- in isi_order_pos.li_pos_nr%type,
                                           null,                 -- in number,
                                            in_user_id,           -- in_user_id     in isi_user.login_id%type,
                                            in_aktivieren);       -- in_aktivieren  in varchar2               -- False (Nur Reservieren)
        return ( v_ret_text );
    end;
  --------------------------------------------------------------------------------
  -- function aktiviert alle Transporte einer Verladung
  --
  -- ohne COMMIT
  --  Achtung diese procedure macht schon ein COMMIT nach jedem Loeschen eines
  --  Transports. Hier kann die die Transaktion durchbrochen werden
  --------------------------------------------------------------------------------
  --******************************************************************************
    function aktiv_trans_lief_359 (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_tour_nr    in isi_order_kopf.vorgang_id%type,
        in_li_nr      in isi_order_pos.li_nr%type,
        in_li_pos_nr  in isi_order_pos.li_pos_nr%type,
        in_anz_pos    in number,
        in_user_id    in isi_user.login_id%type,
        in_aktivieren in varchar2               -- False (Nur Reservieren)
    ) return varchar2 is

  --------------------------------------------------------------------------------
  --
  --
  --  Achtung diese procedure macht schon ein COMMIT nach jedem Loeschen eines
  --  Transports. Hier kann die die Transaktion durchbrochen werden
  --
  --
  --
  --------------------------------------------------------------------------------

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr               number;
        v_err_text             varchar2(2056);

    --v_kopf_min_frei_datum     isi_order_kopf.freigabe_datum%type;       -- Kopfdaten Freigabedatum
    --v_kopf_max_freigegrben    isi_order_kopf.freigegeben_datum%type;    -- Kopfdaten Freigabedatum

        v_pos                  isi_order_pos%rowtype;                    -- Positionsdaten
        v_kopf                 isi_order_kopf%rowtype;                   -- Kopfdaten

        v_found                boolean;                                  -- Dtaen gefunden
        v_freigabe_datum       date;
        v_pos_menge            number;
    --v_lgr_orte                varchar2(512);                            -- Gültige Lagerorte

        v_result               number;
        v_arbeitsplatz         isi_arbeitsplatz_cfg%rowtype;
        v_transport            isi_transport%rowtype;
        v_transport_anz        number;
        v_menge                number;
        v_ret_text             varchar2(2056);
        v_ganze_lte_res        varchar2(1);
        v_komm_ziel_lte_id     lvs_lte.lte_id%type;
        v_komm_anz_lhm_pro_lte number;
        v_anz_pos              number;

    -- KONSI-Lager berücksichtigen
        cursor c_pos is
        select
            pos.*
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                 'LNK' )
            and pos.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
            and ( pos.vorgang_id = in_tour_nr
                  or pos.vorgang_id in (
                select
                    t.vorgang_id
                from
                    isi_order_kopf t
                where
                        t.sid = in_sid
                    and t.firma_nr = in_firma_nr
                    and t.lkw_nr = (
                        select
                            decode(
                                min(kopf.lkw_nr),
                                max(kopf.lkw_nr),
                                min(kopf.lkw_nr),
                                null
                            )
                        from
                            isi_order_kopf kopf
                        where
                                kopf.sid = in_sid
                            and kopf.firma_nr = in_firma_nr
                            and kopf.vorgang_id = in_tour_nr
                            and kopf.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
                            and kopf.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                                  'LNK' )
                    )
                    and t.lkw_nr > 0
                    and t.freigegeben_datum = v_freigabe_datum
            ) )
            and ( pos.li_nr = in_li_nr
                  or in_li_nr is null )
            and ( pos.li_pos_nr = in_li_pos_nr
                  or in_li_pos_nr is null )
            and ( pos.freigegeben_datum is null
                  or pos.status = 'T' )
        order by
            pos.transport_gruppe desc,
            pos.vorgang_id,
            pos.li_nr,
            pos.li_pos_nr;

    -- KONSI-Lager berücksichtigen
        cursor c_tour is
        select
            kopf.*
        from
            isi_order_kopf kopf
        where
                kopf.sid = in_sid
            and kopf.firma_nr = in_firma_nr
            and kopf.vorgang_id = in_tour_nr
            and ( kopf.li_nr = in_li_nr
                  or in_li_nr is null )
            and kopf.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
            and kopf.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                  'LNK' );

    -- KONSI-Lager berücksichtigen
        cursor c_kopf is
        select
            kopf.*
        from
            isi_order_kopf kopf
        where
                kopf.sid = in_sid
            and kopf.firma_nr = in_firma_nr
            and kopf.vorgang_id = v_pos.vorgang_id
            and ( kopf.li_nr = in_li_nr
                  or in_li_nr is null )
            and kopf.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
            and kopf.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                  'LNK' )
            and kopf.li_nr = v_pos.li_nr;

    --cursor c_lts is
    --  select *
    --    from lvs_lte lte,
    --         lvs_lam lam
    --   where lam.sid = in_sid
    --     and lam.firma_nr = in_firma_nr
    --     and lam.artikel_id = v_pos.artikel_id
    --     and lam.menge > 0
    --order by lam.lam_mhd;
        cursor c_arbeitsplatz is
        select
            *
        from
            isi_arbeitsplatz_cfg ap
        where
                ap.arbeitsplatz_id = v_pos.arbeitsplatz_id
            and ap.modul_name = 'LVS'
            and ap.modul_funktion = 'AUSL_ORTE';

        cursor c_lam_auf_id is
        select
            sum(nvl(lam.res_menge, lam.menge))
        from
            lvs_lam lam
        where
                lam.sid = v_pos.sid
            and lam.order_pos_auf_id = v_pos.auf_id
        group by
            lam.order_pos_auf_id;

        cursor c_lte_auf_id is
        select
            count(nvl(lam.res_menge, lam.menge))
        from
            lvs_lam lam
        where
                lam.sid = v_pos.sid
            and lam.order_pos_auf_id = v_pos.auf_id
        group by
            lam.order_pos_auf_id;

        cursor c_transport is
        select
            *
        from
            isi_transport tra
        where
                tra.sid = in_sid
            and tra.vorgang_id = in_tour_nr
            and ( tra.li_nr = in_li_nr
                  or in_li_nr is null )
            and ( tra.li_pos_nr = in_li_pos_nr
                  or in_li_pos_nr is null )
            and tra.lgr_ort_quelle = tra.lgr_ort_ziel
            and tra.lgr_verwendung_ziel != c.lgr_typ_lager
            and tra.lgr_verwendung_ziel != c.lgr_typ_puffer
        order by
            tra.freifahrauftrag,
            tra.transport_reihenfolge desc,
            tra.prio,
            tra.transp_id desc;

    begin
        v_err_nr := null;
        v_err_text := null;
        v_ret_text := null;
        if in_li_nr is null -- Nur pruefen wenn Ganze Tour aktiviert werden soll
         then
            v_result := lvs_ausl.lvs_pruefe_tour_ausl(in_sid, in_firma_nr, in_tour_nr);
        end if;

        v_freigabe_datum := sysdate;
        open c_tour;
        fetch c_tour into v_kopf;                                             -- Kopfdaten lesen
        v_found := c_tour%found;
        close c_tour;
        if in_aktivieren = c.c_true then
            open c_transport;
            fetch c_transport into v_transport;
            v_transport_anz := 0;
            loop
                exit when c_transport%notfound;
                begin
                    v_result := lvs_transport.lvs_transp_loeschen(in_sid, in_firma_nr, in_user_id, v_transport.transp_id, 'F');

                    commit;
                    fetch c_transport into v_transport;
                exception -- Löschen des Transport hat nicht geklapt
                    when others then
                        v_transport_anz := 1;
                end;
        -- Hier nachlesen sonst Endlosschleife im Fehlerfall
                commit;
                fetch c_transport into v_transport;
            end loop;

            close c_transport;
            if v_transport_anz != 0 then
                open c_transport;
                fetch c_transport into v_transport;
                v_found := c_transport%found;
                close c_transport;
                if v_found then
                    v_err_nr := 10;
                    v_err_text := lc.ec(lc.o_txt_order_m_trans_n_close);
          -- v_err_text := 'Fehler: Es sind noch Transporte für diese Tour eingetragen, die nicht gelöscht werden konnten. Bitte Transporte prüfen und nochmals versuchen.';
                    raise v_error;
                end if;

            end if;

    -- KONSI-Lager berücksichtigen
            update isi_order_kopf kopf
            set
                kopf.freigegeben_datum = v_freigabe_datum,
                kopf.liefer_datum = nvl(kopf.liefer_datum, sysdate),
                kopf.status = 'T'
            where
                    kopf.sid = in_sid
                and kopf.firma_nr = in_firma_nr
                and kopf.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
                and ( kopf.vorgang_id = in_tour_nr
                      or kopf.lkw_nr = v_kopf.lkw_nr )
                and ( kopf.li_nr = in_li_nr
                      or in_li_nr is null )
                and kopf.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                      'LNK' )
                and kopf.status != 'E'
                and kopf.freigabe_datum is null;

        else  -- Nur reservieren
            update isi_order_kopf kopf
            set
                kopf.status = 'D'
            where
                    kopf.sid = in_sid
                and kopf.firma_nr = in_firma_nr
                and kopf.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
                and ( kopf.vorgang_id = in_tour_nr
                      or kopf.lkw_nr = v_kopf.lkw_nr )
                and ( kopf.li_nr = in_li_nr
                      or in_li_nr is null )
                and kopf.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                      'LNK' )
                and kopf.status != 'E'
                and kopf.freigabe_datum is null;

        end if;

        lvs_ausl.v_sperr_transport_gruppe := false;
        lvs_ausl.v_order_transport_gruppe := null;
        lvs_ausl.v_transport_gruppe := null;
        v_anz_pos := 1;
        open c_pos;
        loop
            exit when v_anz_pos > in_anz_pos;
            fetch c_pos into v_pos;
            exit when c_pos%notfound;
            v_anz_pos := v_anz_pos + 1;
            open c_kopf;
            fetch c_kopf into v_kopf;                                             -- Kopfdaten lesen
            v_found := c_kopf%found;
            close c_kopf;
            if not v_found then
                v_err_nr := 20;
                v_err_text := lc.ec_p2(lc.o_tp2_order_vorg_kopf_fehlt, v_pos.vorgang_id, v_pos.li_nr);
        --v_err_text := 'Fehler: Kopfdaten für Tour: ' || v_pos.vorgang_id || ' Lieferschein ' || v_pos.li_nr || ' nicht vorhanden!';
                raise v_error;
            end if;

            v_pos_menge := v_pos.soll_menge;
            if not v_found then
                v_err_nr := 20;
                v_err_text := lc.ec_p1(lc.o_tp1_lagero_f_arbeitspl_fehlt, v_pos.arbeitsplatz_id);
        -- v_err_text := 'Lagerorte für Arbeitsplatz ' || v_pos.arbeitsplatz_id || ' nicht gefunden!';
                raise v_error;
            end if;

            if
                v_pos.arbeitsplatz_id is null
                and v_pos.satzart not in ( 'MAK', 'LAK', 'LNK' )
            then
                v_pos.arbeitsplatz_id := v_kopf.arbeitsplatz_id;
                v_pos.ziel := v_kopf.ziel;
                update isi_order_pos pos
                set
                    pos.arbeitsplatz_id = v_pos.arbeitsplatz_id,
                    pos.ziel = v_pos.ziel
                where
                        pos.sid = v_pos.sid
                    and pos.firma_nr = v_pos.firma_nr
                    and pos.auf_id = v_pos.auf_id;

            end if;

            open c_arbeitsplatz;
            fetch c_arbeitsplatz into v_arbeitsplatz;    -- Lesen der Lagerorte für Lagerplatz
            v_found := c_arbeitsplatz%found;
            close c_arbeitsplatz;
            v_komm_ziel_lte_id := null;
            v_komm_anz_lhm_pro_lte := null;
            if
                v_pos.satzart in ( 'MAK', 'LAK', 'LNK' )
                and v_pos.wa_menge_ueberlief != 'OLTE'
                and v_pos.wa_menge_ueberlief != 'ULTE'
            then
                v_ganze_lte_res := c.c_false;
            else
                v_ganze_lte_res := c.c_true;
            end if;

            v_result := lvs_ausl.lvs_lam_suche_buch_ausl(v_pos,
                                                         v_kopf,
                                                         nvl(v_pos.quell_lagerorte, v_arbeitsplatz.modul_parameter),
                                                         in_user_id,
                                                         v_ganze_lte_res,
                                                         v_komm_ziel_lte_id,
                                                         v_komm_anz_lhm_pro_lte,
                                                         in_aktivieren);

            if in_aktivieren = c.c_true then
                update isi_order_pos pos
                set
                    pos.freigegeben_datum = v_freigabe_datum,                    -- FreigabeDatum setzen
                    pos.ware_disponiert = 'T',
                    pos.status = 'T'
                where
                        pos.sid = v_pos.sid
                    and pos.firma_nr = v_pos.firma_nr
                    and pos.auf_id = v_pos.auf_id;

            else
                update isi_order_pos pos
                set
                    pos.ware_disponiert = 'T',
                    pos.status = 'D'
                where
                        pos.sid = v_pos.sid
                    and pos.firma_nr = v_pos.firma_nr
                    and pos.auf_id = v_pos.auf_id;

            end if;

            v_menge := 0;
            if v_pos.menge_basis = c.basis_lte then
                open c_lte_auf_id;
                fetch c_lte_auf_id into v_menge;
                close c_lte_auf_id;
            else
                open c_lam_auf_id;
                fetch c_lam_auf_id into v_menge;
                close c_lam_auf_id;
            end if;

      -- Wenn die Menge nicht stimmt dann immer einen Fehler erzeugen
            if v_result is not null
               or nvl(v_menge, 0) != v_pos.soll_menge - v_pos.ist_menge then
                if (
                    nvl(v_menge, 0) < v_pos.soll_menge - v_pos.ist_menge
                    and nvl(v_pos.wa_menge_ueberlief, 'EX') != 'ULHM'
                    and nvl(v_pos.wa_menge_ueberlief, 'EX') != 'ULTE'
                )
                or ( nvl(v_menge, 0) = 0 ) then
                    if v_ret_text is null then
                        v_ret_text := lc.ec_p5(lc.o_tp5_bestands_mg_fehlt_l1,
                                               to_char(v_pos.li_nr),
                                               to_char(v_pos.li_pos_nr),
                                               v_pos.soll_menge,
                                               v_pos.mengeneinheit,
                                               v_menge)
                                      || chr(13)
                                      || chr(10)
                                      || to_char(v_pos.li_nr)
                                      || '/'
                                      || to_char(v_pos.li_pos_nr)
                                      || ' '
                                      || v_pos.soll_menge
                                      || ' '
                                      || v_pos.mengeneinheit
                                      || ' '
                                      || v_menge
                                      || ' -> '
                                      || to_char(v_menge - v_pos.soll_menge)
                                      || chr(13)
                                      || chr(10);

                    else
                        v_ret_text := v_ret_text
                                      || to_char(v_pos.li_nr)
                                      || '/'
                                      || to_char(v_pos.li_pos_nr)
                                      || ' '
                                      || v_pos.soll_menge
                                      || ' '
                                      || v_pos.mengeneinheit
                                      || ' '
                                      || v_menge
                                      || ' -> '
                                      || to_char(v_menge - v_pos.soll_menge)
                                      || chr(13)
                                      || chr(10);
                    end if;
          --v_ret_text := nvl(v_ret_text, 'Warnung: Bestandsmengen nicht Ausreichend!' || CHR(13) || CHR(10)) ||
          --             'Lieferschein ' || to_char(v_pos.li_nr) || '/' || to_char(v_pos.li_pos_nr) || ' benötigt ' ||
          --              v_pos.soll_menge || ' ' || v_pos.mengeneinheit || ', ' || v_menge || ' reserviert!' || CHR(13) || CHR(10);
                elsif
                    nvl(v_menge, 0) > v_pos.soll_menge - v_pos.ist_menge
                    and nvl(v_pos.wa_menge_ueberlief, 'EX') != 'OLHM'
                    and nvl(v_pos.wa_menge_ueberlief, 'EX') != 'OLTE'
                then
                    if v_ret_text is null then
                        v_ret_text := lc.ec_p5(lc.o_tp5_bestands_mg_z_viel_l1,
                                               to_char(v_pos.li_nr),
                                               to_char(v_pos.li_pos_nr),
                                               v_pos.soll_menge,
                                               v_pos.mengeneinheit,
                                               v_menge)
                                      || chr(13)
                                      || chr(10)
                                      || to_char(v_pos.li_nr)
                                      || '/'
                                      || to_char(v_pos.li_pos_nr)
                                      || ' '
                                      || v_pos.soll_menge
                                      || ' '
                                      || v_pos.mengeneinheit
                                      || ' '
                                      || v_menge
                                      || ' -> '
                                      || to_char(v_menge - v_pos.soll_menge)
                                      || chr(13)
                                      || chr(10);

                    else
                        v_ret_text := v_ret_text
                                      || to_char(v_pos.li_nr)
                                      || '/'
                                      || to_char(v_pos.li_pos_nr)
                                      || ' '
                                      || v_pos.soll_menge
                                      || ' '
                                      || v_pos.mengeneinheit
                                      || ' -> '
                                      || to_char(v_menge - v_pos.soll_menge)
                                      || chr(13)
                                      || chr(10);
                    end if;
          --v_ret_text := nvl(v_ret_text, LC.ec_p5(LC.O_TP5_BESTANDS_MG_Z_VIEL_L1, to_char(v_pos.li_nr), to_char(v_pos.li_pos_nr), v_pos.soll_menge, v_pos.mengeneinheit, v_menge)) || CHR(13) || CHR(10);
          --v_ret_text := nvl(v_ret_text, 'Warnung: Zu viel reserviert!' || CHR(13) || CHR(10)) ||
          --             'Lieferschein ' || to_char(v_pos.li_nr) || '/' || to_char(v_pos.li_pos_nr) || ' benötigt ' ||
          --              v_pos.soll_menge || ' ' || v_pos.mengeneinheit || ', ' || v_menge || ' reserviert!' || CHR(13) || CHR(10);
                end if;
            end if;

        end loop;

        close c_pos;
        return ( v_ret_text );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_pos%isopen then
                close c_pos;
            end if;
            if c_transport%isopen then
                close c_transport;
            end if;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_pos%isopen then
                close c_pos;
            end if;
            if c_transport%isopen then
                close c_transport;
            end if;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end aktiv_trans_lief_359;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure löscht einen kompletten Lieferschein mit allen Positionen
  -- und löscht alle Transporte und Reservierungen
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_del_lief (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lief_nr  in isi_order_kopf.li_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) is
    begin
        c_del_lief_359(in_sid,          -- in isi_sid.sid%type,
         in_firma_nr,     -- in isi_firma.firma_nr%type,
         in_lief_nr,      -- in isi_order_kopf.li_nr%type,
         null, in_user_id,      -- in isi_user.login_id%type,
                       in_tour_nr       -- in isi_order_kopf.vorgang_id%type
                       );
    end;
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure löscht einen kompletten Lieferschein mit allen Positionen
  -- und löscht alle Transporte und Reservierungen
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_del_lief_359 (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lief_nr  in isi_order_pos.li_nr%type,
        in_lief_pos in isi_order_pos.li_pos_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(255);

    --v_found     boolean;                                -- Daten Gefunfen?
        v_result     number;
        v_order_pos  isi_order_pos%rowtype;
        v_transporte isi_transport%rowtype;
        v_lte        lvs_lte%rowtype;          --
        v_pos_nr     isi_order_pos.li_pos_nr%type;
        v_found      boolean;

    -- KONSI-Lager berücksichtigen
        cursor c_order_pos is
        select
            *
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.vorgang_id = nvl(in_tour_nr, pos.vorgang_id)
            and pos.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                 'LNK' )
            and pos.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
            and pos.li_nr = in_lief_nr
            and pos.li_pos_nr = nvl(v_pos_nr, pos.li_pos_nr);

        cursor c_transporte is
        select
            *
        from
            isi_transport tra
        where
                tra.sid = in_sid
            and tra.firma_nr = in_firma_nr
            and tra.auf_id = v_order_pos.auf_id;

        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.firma_nr = in_firma_nr
            and lte.order_auf_id = v_order_pos.auf_id;

    begin
        v_err_nr := null;
        v_pos_nr := in_lief_pos;
        open c_order_pos;
        loop
            fetch c_order_pos into v_order_pos;
            exit when c_order_pos%notfound;
            if v_order_pos.freigegeben_datum is not null then
                open c_transporte;
                loop
                    fetch c_transporte into v_transporte;
                    exit when c_transporte%notfound;
                    begin
                        v_result := lvs_transport.lvs_transp_loeschen(in_sid, in_firma_nr, in_user_id, v_transporte.transp_id, 'F');
                    exception
                        when others then
                            null;
                    end;

                end loop;

                close c_transporte;
            elsif v_order_pos.ware_disponiert = c.c_true then
                open c_lte;
                loop
                    fetch c_lte into v_lte;
                    exit when c_lte%notfound;
                    v_result := lvs_ausl.lvs_lte_res_rueck(v_order_pos.sid, v_order_pos.firma_nr, v_order_pos.vorgang_id, v_order_pos.auf_id
                    , v_lte.lte_id,
                                                           v_lte.order_vorgang_id, v_lte.lgr_platz, c.c_true);

                end loop;

                close c_lte;
            end if;

        end loop;

        close c_order_pos;

    -- KONSI-Lager berücksichtigen
        delete from isi_order_pos p
        where
                p.sid = in_sid
            and p.firma_nr = in_firma_nr
            and p.vorgang_id = nvl(in_tour_nr, p.vorgang_id)
            and p.li_nr = in_lief_nr
            and p.li_pos_nr = nvl(v_pos_nr, p.li_pos_nr)
            and p.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                               'LNK' );

    -- Jetzt prüfen ob noch POSITIONEN
        v_found := false;
        if in_lief_pos is not null then
            v_pos_nr := null;
            open c_order_pos;
            fetch c_order_pos into v_order_pos;
            v_found := c_order_pos%found;
            close c_order_pos;
        end if;

        if in_lief_pos is null
           or not v_found then
      -- KONSI-Lager berücksichtigen
            delete from isi_order_kopf k
            where
                    k.sid = in_sid
                and k.firma_nr = in_firma_nr
                and k.vorgang_id = nvl(in_tour_nr, k.vorgang_id)
                and k.li_nr = in_lief_nr
                and k.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                   'LNK' );

        end if;

        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_order_pos%isopen then
                close c_order_pos;
            end if;
            if c_transporte%isopen then
                close c_transporte;
            end if;
            if c_lte%isopen then
                close c_lte;
            end if;
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_order_pos%isopen then
                close c_order_pos;
            end if;
            if c_transporte%isopen then
                close c_transporte;
            end if;
            if c_lte%isopen then
                close c_lte;
            end if;
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end c_del_lief_359;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function reserviert automatisch genug Ware für eine Lieferscheinposition
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_res_lief_pos (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lief_nr  in isi_order_pos.li_nr%type,
        in_lief_pos in isi_order_pos.li_pos_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_typ      in varchar2,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_menge    number;
        v_pos      isi_order_pos%rowtype;                    -- Positionsdaten

        v_satzart  isi_order_kopf.satzart%type;
        v_found    boolean;                                  -- Dtaen gefunden

        cursor c_pos is
        select
            pos.*
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.satzart = nvl(v_satzart, pos.satzart)
            and pos.vorgang_typ = in_typ
            and pos.vorgang_id = nvl(in_tour_nr, pos.vorgang_id)
            and pos.li_nr = in_lief_nr
            and pos.li_pos_nr = in_lief_pos;

        cursor c_lam_auf_id is
        select
            sum(nvl(lam.res_menge, lam.menge))
        from
            lvs_lam lam
        where
                lam.sid = v_pos.sid
            and lam.order_pos_auf_id = v_pos.auf_id
        group by
            lam.order_pos_auf_id;

        cursor c_lte_auf_id is
        select
            count(nvl(lam.res_menge, lam.menge))
        from
            lvs_lam lam
        where
                lam.sid = v_pos.sid
            and lam.order_pos_auf_id = v_pos.auf_id
        group by
            lam.order_pos_auf_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        if in_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' ) then
            v_satzart := null;
        else
            v_satzart := 'LU';
        end if;

        open c_pos;
        fetch c_pos into v_pos;                                             -- Positionsdaten lesen
        v_found := c_pos%found;
        close c_pos;
        v_satzart := v_pos.satzart;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p2(lc.o_tp2_order_lief_kopf_fehlt, in_lief_nr, in_lief_pos);
      -- v_err_text := 'Fehler: Lieferschein ' || in_lief_nr || ' Position ' || in_lief_pos || ' nicht vorhanden!';
            raise v_error;
        end if;

        res_lief_pos(in_sid, in_firma_nr, in_lief_nr, in_lief_pos, in_user_id,
                     in_typ, v_satzart, in_tour_nr);

        commit;
        v_menge := 0;
        if v_pos.menge_basis = c.basis_lte then
            open c_lte_auf_id;
            fetch c_lte_auf_id into v_menge;
            close c_lte_auf_id;
        else
            open c_lam_auf_id;
            fetch c_lam_auf_id into v_menge;
            close c_lam_auf_id;
        end if;

        if nvl(v_menge, 0) < v_pos.soll_menge - v_pos.ist_menge then
            v_err_nr := 20;
            v_err_text := lc.ec_p5(lc.o_tp5_bestands_mg_fehlt_l1,
                                   to_char(in_lief_nr),
                                   to_char(in_lief_pos),
                                   v_pos.soll_menge,
                                   v_pos.mengeneinheit,
                                   v_menge)
                          || chr(13)
                          || chr(10);
      --v_err_text := 'Warnung: Bestand nicht ausreichend! Lieferschein ' || in_lief_nr || '/' || in_lief_pos || ' benötigt ' ||
      --               v_pos.soll_menge || ' ' || v_pos.mengeneinheit || '. Es waren nur ' || v_menge || ' im Lager verfügbar!';
            raise v_error;
        elsif nvl(v_menge, 0) > v_pos.soll_menge - v_pos.ist_menge then
            v_err_nr := 30;
            v_err_text := lc.ec_p5(lc.o_tp5_bestands_mg_z_viel_l1,
                                   to_char(in_lief_nr),
                                   to_char(in_lief_pos),
                                   v_pos.soll_menge,
                                   v_pos.mengeneinheit,
                                   v_menge)
                          || chr(13)
                          || chr(10);
      -- v_err_text := 'Zu viel reserviert! Lieferschein ' || in_lief_nr || '/' || in_lief_pos || ' benötigt ' ||
      --                v_pos.soll_menge || ' ' || v_pos.mengeneinheit || '. Es sind jedoch ' || v_menge || ' reserviert!';
            raise v_error;
        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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

    end c_res_lief_pos;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function reserviert automatisch genug Ware für eine Lieferscheinposition
  --
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure res_lief_pos (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lief_nr  in isi_order_pos.li_nr%type,
        in_lief_pos in isi_order_pos.li_pos_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_typ      in varchar2,
        in_satzart  in varchar2,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) is
    begin
        res_lief_pos_359(in_sid,         --in isi_sid.sid%type,
         in_firma_nr,    -- in isi_firma.firma_nr%type,
         in_lief_nr,     -- in isi_order_pos.li_nr%type,
         in_lief_pos,    -- in isi_order_pos.li_pos_nr%type,
         in_user_id,     -- in isi_user.login_id%type,
                         in_typ,         -- in varchar2,
                          in_satzart,     -- in varchar2,
                          in_tour_nr,     -- in isi_order_kopf.vorgang_id%type
                          null            -- in lvs_lte.lte_id%type
                         );
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function reserviert automatisch genug Ware für eine Lieferscheinposition
  --
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure res_lief_pos_359 (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lief_nr  in isi_order_pos.li_nr%type,
        in_lief_pos in isi_order_pos.li_pos_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_typ      in varchar2,
        in_satzart  in varchar2,
        in_tour_nr  in isi_order_kopf.vorgang_id%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr               number;
        v_err_text             varchar2(255);
        v_pos                  isi_order_pos%rowtype;                    -- Positionsdaten
        v_kopf                 isi_order_kopf%rowtype;                   -- Kopfdaten

        v_found                boolean;                                  -- Dtaen gefunden
        v_pos_menge            number;
        v_lte_menge            number;
    --v_lgr_orte                varchar2(512);                            -- Gültige Lagerorte

        v_result               number;
        v_arbeitsplatz         isi_arbeitsplatz_cfg%rowtype;
        v_ganze_lte_res        varchar2(1);
        v_komm_ziel_lte_id     lvs_lte.lte_id%type;
        v_komm_anz_lhm_pro_lte number;
        cursor c_kopf is
        select
            kopf.*
        from
            isi_order_kopf kopf
        where
                kopf.sid = in_sid
            and kopf.firma_nr = in_firma_nr
            and kopf.vorgang_id = v_pos.vorgang_id
            and kopf.vorgang_typ = in_typ
            and kopf.satzart = in_satzart
            and kopf.li_nr = v_pos.li_nr;

        cursor c_pos is
        select
            pos.*
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.satzart = in_satzart
            and pos.vorgang_typ = in_typ
            and pos.vorgang_id = nvl(in_tour_nr, pos.vorgang_id)
            and pos.li_nr = in_lief_nr
            and pos.li_pos_nr = in_lief_pos
            and pos.freigegeben_datum is null;

    --cursor c_lts is
    --  select *
    --    from lvs_lte lte,
    --         lvs_lam lam
    --   where lam.sid = in_sid
    --     and lam.firma_nr = in_firma_nr
    --     and lam.artikel_id = v_pos.artikel_id
    --     and lam.menge > 0
    --order by lam.lam_mhd;
        cursor c_arbeitsplatz is
        select
            *
        from
            isi_arbeitsplatz_cfg ap
        where
                ap.arbeitsplatz_id = v_pos.arbeitsplatz_id
            and ap.modul_name = 'LVS'
            and ap.modul_funktion = 'AUSL_ORTE';

    begin
        v_err_nr := null;
        v_err_text := null;
        v_result := lvs_ausl.lvs_pruefe_lief_pos(in_sid, in_firma_nr, in_lief_nr, in_lief_pos, v_kopf,
                                                 in_typ, in_satzart, in_tour_nr);

        open c_pos;
        fetch c_pos into v_pos;                                             -- Positionsdaten lesen
        v_found := c_pos%found;
        close c_pos;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p2(lc.o_tp2_order_lief_kopf_fehlt, in_lief_nr, in_lief_pos);
      -- v_err_text := 'Fehler: Lieferschein ' || in_lief_nr || ' Position ' || in_lief_pos || ' nicht vorhanden!';
            raise v_error;
        end if;

        if
            v_pos.arbeitsplatz_id is null
            and v_pos.satzart not in ( 'MAK', 'LAK', 'LNK' )
        then
            open c_kopf;
            fetch c_kopf into v_kopf;                                             -- Kopfdaten lesen
            v_found := c_kopf%found;
            close c_kopf;
            if not v_found then
                v_err_nr := 20;
                v_err_text := lc.ec_p2(lc.o_tp2_order_vorg_kopf_fehlt, v_pos.vorgang_id, v_pos.li_nr);
        -- v_err_text := 'Fehler: Kopfdaten für Tour: ' || v_pos.vorgang_id || ' Lieferschein ' || v_pos.li_nr || ' nicht vorhanden!';
                raise v_error;
            end if;

            v_pos.arbeitsplatz_id := v_kopf.arbeitsplatz_id;
            v_pos.ziel := v_kopf.ziel;
            update isi_order_pos pos
            set
                pos.arbeitsplatz_id = v_pos.arbeitsplatz_id,
                pos.ziel = v_pos.ziel
            where
                    pos.sid = v_pos.sid
                and pos.firma_nr = v_pos.firma_nr
                and pos.auf_id = v_pos.auf_id;

        end if;

    --v_pos_menge := v_pos.soll_menge;

        open c_arbeitsplatz;
        fetch c_arbeitsplatz into v_arbeitsplatz;    -- Lesen der Lagerorte für Lagerplatz
        v_found := c_arbeitsplatz%found;
        close c_arbeitsplatz;
        if
            not v_found
            and v_pos.quell_lagerorte is null
        then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_lagero_f_arbeitspl_fehlt, v_pos.arbeitsplatz_id);
      -- v_err_text := 'Lagerorte für Arbeitsplatz ' || v_pos.arbeitsplatz_id || ' nicht gefunden!';
            raise v_error;
        end if;

        if
            v_pos.satzart in ( 'MAK', 'LAK', 'LNK' )
            and v_pos.wa_menge_ueberlief != 'OLTE'
            and v_pos.wa_menge_ueberlief != 'ULTE'
        then
            v_ganze_lte_res := c.c_false;
        else
            v_ganze_lte_res := c.c_true;
        end if;

        v_komm_ziel_lte_id := null;
        v_komm_anz_lhm_pro_lte := null;
        v_lte_menge := lvs_ausl.lvs_lam_suche_buch_ausl_359(v_pos,
                                                            v_kopf,
                                                            nvl(v_pos.quell_lagerorte, v_arbeitsplatz.modul_parameter),
                                                            in_user_id,
                                                            v_ganze_lte_res,
                                                            v_komm_ziel_lte_id,
                                                            v_komm_anz_lhm_pro_lte,
                                                            c.c_false,
                                                            in_lte_id);

    --v_pos_menge := v_pos_menge - v_lte_menge;
        select
            sum(nvl(l.res_menge, 0))
        into v_lte_menge
        from
            lvs_lam l
        where
            l.order_pos_auf_id = v_pos.auf_id;

    -- -AG- 20250516 - Bei Unterlieferung und Reservierung < SOLL, dann SOLL = Reservierte Menge
        if
            v_pos.wa_menge_ueberlief in ( 'ULTE', 'ULHM' )
            and v_lte_menge < v_pos.soll_menge
            and isi_allg.get_firma_cfg_param(v_pos.sid, v_pos.firma_nr, 'AUSL_RESERVIEREN',       -- in_kategorie             in isi_firma_cfg.kategorie%type,
             'ULTE_ULHM_MINDERMENGE_ERLAUBT',            -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
             'ORDER_DISPO',            -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                             'Order',                  -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                              'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                              'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                              'BOOLEAN') = c.c_true     -- in_default_param_typ
        then
            v_pos_menge := v_lte_menge;
        else
            v_pos_menge := v_pos.soll_menge;
        end if;

        update isi_order_pos pos
        set
            pos.ware_disponiert = 'T',
            pos.status = 'D',
            pos.soll_menge = v_pos_menge
        where
                pos.sid = v_pos.sid
            and pos.firma_nr = v_pos.firma_nr
            and pos.auf_id = v_pos.auf_id;
    -- KONSI-Lager berücksichtigen
        update isi_order_kopf kopf
        set
            kopf.status = 'D'
        where
                kopf.sid = v_pos.sid
            and kopf.firma_nr = v_pos.firma_nr
            and kopf.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
            and kopf.vorgang_id = v_pos.vorgang_id
            and kopf.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                  'LNK' )
            and kopf.status = 'N';

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end res_lief_pos_359;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function storno der Reservierung für eine Order Position
  --
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure res_rueck_order_pos (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_user_id     in isi_user.login_id%type,
        in_vorgang_id  in isi_order_pos.vorgang_id%type,
        in_auf_id      in isi_order_pos.auf_id%type,
        in_vorgang_typ in isi_order_pos.vorgang_typ%type,
        in_satzart     in isi_order_pos.satzart%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_err_nr        number;
        v_err_text      varchar2(255);
        v_error exception;
    -------------------------------------------------------------------------------------------------------

        v_pos           isi_order_pos%rowtype;                    -- Positionsdaten
        v_lam_lte_id    lvs_lam.lte_id%type;
        v_lam_lgr_platz lvs_lam.lgr_platz%type;
        v_found         boolean;                                  -- Daten gefunden

        v_result        number;
        cursor c_pos is
        select
            pos.*
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and ( pos.vorgang_typ = in_vorgang_typ
                  or in_vorgang_typ is null )
            and ( pos.satzart = in_satzart
                  or in_satzart is null )
            and pos.vorgang_id = in_vorgang_id
            and pos.auf_id = in_auf_id
            and pos.freigegeben_datum is null;

        cursor c_lam is
        select
            lam.lte_id,
            lam.lgr_platz
        from
            lvs_lam lam,
            lvs_lgr lgr
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.order_pos_auf_id = v_pos.auf_id
            and lam.sid = lgr.sid
            and lam.lgr_platz = lgr.lgr_platz
            and lgr.lgr_verwendung != c.lgr_typ_wa
            and lgr.lgr_res_strat != 'O'                   -- Puffer mit Order Reservierung bereits Vorbereitet
        group by
            lam.lte_id,
            lam.lgr_platz;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_pos;
        fetch c_pos into v_pos;                                             -- Positionsdaten lesen
        v_found := c_pos%found;
        close c_pos;
        if not v_found then
            v_err_nr := 11;
            v_err_text := lc.ec_p2(lc.o_tp2_order_vorg_aufid_fehlt, in_vorgang_id, in_auf_id);
      -- v_err_text := 'Fehler: Order VorgangIS ' || in_vorgang_id || ' AufID ' || in_auf_id || ' nicht vorhanden!';
            raise v_error;
        end if;

        open c_lam;
        loop
            fetch c_lam into
                v_lam_lte_id,
                v_lam_lgr_platz;
            exit when c_lam%notfound;
            v_result := lvs_ausl.lvs_lte_res_rueck(in_sid, in_firma_nr, v_pos.vorgang_id, v_pos.auf_id, v_lam_lte_id,
                                                   v_pos.vorgang_id, v_lam_lgr_platz, c.c_true);

        end loop;

        close c_lam;
        delete isi_komm_order t
        where
            t.auf_id = v_pos.auf_id;

        update isi_order_pos pos
        set
            pos.ware_disponiert = 'F',
            pos.status = 'N'                  -- Neu ist jetzt 'N' nicht mehr NULL
        where
                pos.sid = v_pos.sid
            and pos.firma_nr = v_pos.firma_nr
            and pos.auf_id = v_pos.auf_id;

        if
            v_pos.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
            and v_pos.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                   'LNK' )
        then
            update isi_order_kopf ok
            set
                ok.status = 'N'                  -- Neu ist jetzt 'N' nicht mehr NULL
            where
                    ok.sid = v_pos.sid
                and ok.firma_nr = v_pos.firma_nr
                and ok.vorgang_id = v_pos.vorgang_id
                and ok.vorgang_typ = v_pos.vorgang_typ
                and ok.satzart = v_pos.satzart
                and ok.status != 'E'
                and 0 = (
                    select
                        count(*)
                    from
                        isi_order_pos op
                    where
                            op.vorgang_id = v_pos.vorgang_id
                        and ok.vorgang_typ = v_pos.vorgang_typ
                        and ok.satzart = v_pos.satzart
                        and ( op.status <> 'N'
                              and op.status <> 'E' )
                );

        end if;

        if
            v_pos.vorgang_typ = 'WAI'
            and v_pos.satzart = 'MA'
        then
            update isi_order_kopf ok
            set
                ok.status = 'N'                  -- Neu ist jetzt 'N' nicht mehr NULL
            where
                    ok.sid = v_pos.sid
                and ok.firma_nr = v_pos.firma_nr
                and ok.vorgang_id = v_pos.vorgang_id
                and ok.vorgang_typ = v_pos.vorgang_typ
                and ok.satzart = v_pos.satzart;

        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_lam%isopen then
                close c_lam;
            end if;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            if c_lam%isopen then
                close c_lam;
            end if;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function storno der Reservierung für eine Lieferscheinposition
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_res_rueck_order_pos (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_user_id     in isi_user.login_id%type,
        in_vorgang_id  in isi_order_pos.vorgang_id%type,
        in_auf_id      in isi_order_pos.auf_id%type,
        in_vorgang_typ in isi_order_pos.vorgang_typ%type,
        in_satzart     in isi_order_pos.satzart%type
    ) is
    begin
        res_rueck_order_pos(in_sid, in_firma_nr, in_user_id, in_vorgang_id, in_auf_id,
                            in_vorgang_typ, in_satzart);
        commit;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function storno der Reservierung für eine Lieferscheinposition
  --
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure res_rueck_lief_pos (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lief_nr  in isi_order_pos.li_nr%type,
        in_lief_pos in isi_order_pos.li_pos_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_typ      in varchar2,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_err_nr     number;
        v_err_text   varchar2(255);
        v_error exception;
    -------------------------------------------------------------------------------------------------------

        v_vorgang_id isi_order_pos.vorgang_id%type;
        v_auf_id     isi_order_pos.auf_id%type;
        v_satzart    isi_order_pos.satzart%type;
        cursor c_order_lief_pos is
        select
            pos.vorgang_id,
            pos.auf_id,
            pos.satzart
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.satzart = nvl(v_satzart, pos.satzart)
            and pos.vorgang_typ = in_typ
            and pos.vorgang_id = nvl(in_tour_nr, pos.vorgang_id)
            and pos.li_nr = in_lief_nr
            and pos.li_pos_nr = in_lief_pos;

        v_found      boolean;
    begin
        if in_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' ) then
            v_satzart := null;
        else
            v_satzart := 'LU';
        end if;

        open c_order_lief_pos;
        fetch c_order_lief_pos into
            v_vorgang_id,
            v_auf_id,
            v_satzart;
        v_found := c_order_lief_pos%found;
        close c_order_lief_pos;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p2(lc.o_tp2_order_lief_kopf_fehlt, in_lief_nr, in_lief_pos);
      -- v_err_text := 'Fehler: Lieferschin ' || in_lief_nr || ' Position ' || in_lief_pos || ' nicht vorhanden!';
            raise v_error;
        end if;

        res_rueck_order_pos(in_sid, in_firma_nr, in_user_id, v_vorgang_id, v_auf_id,
                            in_typ, v_satzart);
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function storno der Reservierung für eine Lieferscheinposition
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_res_rueck_lief_pos (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lief_nr  in isi_order_pos.li_nr%type,
        in_lief_pos in isi_order_pos.li_pos_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_typ      in varchar2,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
    begin
        res_rueck_lief_pos(in_sid, in_firma_nr, in_lief_nr, in_lief_pos, in_user_id,
                           in_typ, in_tour_nr);
        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end c_res_rueck_lief_pos;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function aktiviert alle Transporte einer Umlagerung
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_aktiv_trans_umla (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_umla_nr    in isi_order_kopf.vorgang_id%type,
        in_user_id    in isi_user.login_id%type,
        in_aktivieren in varchar2               -- False (Nur Reservieren)
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr               number;
        v_err_text             varchar2(2056);
        v_kopf_min_frei_datum  isi_order_kopf.freigabe_datum%type;       -- Kopfdaten Freigabedatum
        v_kopf_max_freigegrben isi_order_kopf.freigegeben_datum%type;    -- Kopfdaten Freigabedatum

        v_pos                  isi_order_pos%rowtype;                    -- Positionsdaten
        v_kopf                 isi_order_kopf%rowtype;                   -- Kopfdaten

        v_found                boolean;                                  -- Dtaen gefunden
        v_freigabe_datum       date;
        v_pos_menge            number;
        v_lgr_orte             varchar2(512);                            -- Gültige Lagerorte
        v_lgr_ort              lvs_lgr_ort.lgr_ort%type;
        v_result               number;
        v_menge                number;
        v_ret_text             varchar2(2056);
        cursor c_pos is
        select
            pos.*
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.satzart = 'LU'
            and pos.vorgang_typ = 'WUE'
            and pos.vorgang_id = in_umla_nr
            and pos.freigegeben_datum is null;

        cursor c_kopf is
        select
            kopf.*
        from
            isi_order_kopf kopf
        where
                kopf.sid = in_sid
            and kopf.firma_nr = in_firma_nr
            and kopf.vorgang_id = in_umla_nr
            and kopf.vorgang_typ = 'WUE'
            and kopf.satzart = 'LU';

        cursor c_lts is
        select
            *
        from
            lvs_lte lte,
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.artikel_id = v_pos.artikel_id
            and lam.menge > 0
        order by
            lam.lam_mhd;

        cursor c_lam_auf_id is
        select
            sum(lam.menge)
        from
            lvs_lam lam
        where
                lam.sid = v_pos.sid
            and lam.order_pos_auf_id = v_pos.auf_id
        group by
            lam.order_pos_auf_id;

        cursor c_lte_auf_id is
        select
            count(lam.menge)
        from
            lvs_lam lam
        where
                lam.sid = v_pos.sid
            and lam.order_pos_auf_id = v_pos.auf_id
        group by
            lam.order_pos_auf_id;

        cursor c_lgr_orte is
        select
            ort.lgr_ort
        from
            lvs_lgr_ort ort
        where
                ort.sid = in_sid
            and ort.firma_nr = in_firma_nr
            and ort.adress_id = v_kopf.quelle;

    begin
        v_err_nr := null;
        v_err_text := null;
        v_ret_text := null;
        v_result := lvs_ausl.lvs_pruefe_umla_ausl(in_sid, in_firma_nr, in_umla_nr);
        v_freigabe_datum := sysdate;
        if in_aktivieren = c.c_true then
            update isi_order_kopf kopf
            set
                kopf.freigegeben_datum = v_freigabe_datum,
                kopf.status = 'T'
            where
                    kopf.sid = in_sid
                and kopf.firma_nr = in_firma_nr
                and kopf.vorgang_typ = 'WUE'
                and kopf.vorgang_id = in_umla_nr
                and kopf.satzart = 'LU'
                and kopf.status != 'E'
                and kopf.freigabe_datum is null;

        end if;

        open c_pos;
        loop
            fetch c_pos into v_pos;                                             -- Positionsdaten lesen
            exit when c_pos%notfound;
            open c_kopf;
            fetch c_kopf into v_kopf;                                             -- Kopfdaten lesen
            v_found := c_kopf%found;
            close c_kopf;
            if not v_found then
                v_err_nr := 20;
                v_err_text := lc.ec_p1(lc.o_tp1_order_lief_umla_fehlt, in_umla_nr);
        -- v_err_text := 'Fehler: Kopfdaten für Umlagerung: ' || in_umla_nr || ' nicht vorhanden!';
                raise v_error;
            end if;

            v_pos_menge := v_pos.soll_menge;
            v_lgr_orte := hole_lgr_orte_in_str(in_sid, in_firma_nr, v_kopf.quelle);
            v_result := lvs_ausl.lvs_lte_suche_buch_ausl(v_pos, v_kopf, v_lgr_orte, in_user_id, in_aktivieren);
            if in_aktivieren = c.c_true then
                update isi_order_pos pos
                set
                    pos.freigegeben_datum = v_freigabe_datum,                    -- FreigabeDatum setzen
                    pos.ware_disponiert = 'T',
                    pos.status = 'T'
                where
                        pos.sid = v_pos.sid
                    and pos.firma_nr = v_pos.firma_nr
                    and pos.auf_id = v_pos.auf_id;

            else
                update isi_order_pos pos
                set
                    pos.ware_disponiert = 'T',
                    pos.status = 'D'
                where
                        pos.sid = v_pos.sid
                    and pos.firma_nr = v_pos.firma_nr
                    and pos.auf_id = v_pos.auf_id;

            end if;

            v_menge := 0;
            if v_pos.menge_basis = c.basis_lte then
                open c_lte_auf_id;
                fetch c_lte_auf_id into v_menge;
                close c_lte_auf_id;
            else
                open c_lam_auf_id;
                fetch c_lam_auf_id into v_menge;
                close c_lam_auf_id;
            end if;

            if nvl(v_menge, 0) < v_pos.soll_menge - v_pos.ist_menge then
                if v_ret_text is null then
                    v_ret_text := lc.ec_p5(lc.o_tp5_bestands_ul_fehlt_l1,
                                           to_char(v_pos.li_nr),
                                           to_char(v_pos.li_pos_nr),
                                           v_pos.soll_menge,
                                           v_pos.mengeneinheit,
                                           v_menge)
                                  || chr(13)
                                  || chr(10)
                                  || to_char(v_pos.li_nr)
                                  || '/'
                                  || to_char(v_pos.li_pos_nr)
                                  || ' '
                                  || v_pos.soll_menge
                                  || ' '
                                  || v_pos.mengeneinheit
                                  || ' '
                                  || v_menge
                                  || ' -> '
                                  || to_char(v_menge - v_pos.soll_menge)
                                  || chr(13)
                                  || chr(10);

                else
                    v_ret_text := v_ret_text
                                  || to_char(v_pos.li_nr)
                                  || '/'
                                  || to_char(v_pos.li_pos_nr)
                                  || ' '
                                  || v_pos.soll_menge
                                  || ' '
                                  || v_pos.mengeneinheit
                                  || ' '
                                  || v_menge
                                  || ' -> '
                                  || to_char(v_menge - v_pos.soll_menge)
                                  || chr(13)
                                  || chr(10);
                end if;
        --v_ret_text := nvl(v_ret_text, 'Warnung: Bestandsmengen nicht Ausreichend!' || CHR(13) || CHR(10)) ||
        --             'Umlagerung ' || to_char(v_pos.vorgang_id) || '/' || to_char(v_pos.vorgang_pos) || ' benötigt ' ||
        --              v_pos.soll_menge || ' ' || v_pos.mengeneinheit || ', ' || v_menge || ' reserviert!' || CHR(13) || CHR(10);
            elsif nvl(v_menge, 0) > v_pos.soll_menge - v_pos.ist_menge then
                if v_ret_text is null then
                    v_ret_text := lc.ec_p5(lc.o_tp5_bestands_ul_z_viel_l1,
                                           to_char(v_pos.li_nr),
                                           to_char(v_pos.li_pos_nr),
                                           v_pos.soll_menge,
                                           v_pos.mengeneinheit,
                                           v_menge)
                                  || chr(13)
                                  || chr(10)
                                  || to_char(v_pos.li_nr)
                                  || '/'
                                  || to_char(v_pos.li_pos_nr)
                                  || ' '
                                  || v_pos.soll_menge
                                  || ' '
                                  || v_pos.mengeneinheit
                                  || ' '
                                  || v_menge
                                  || ' -> '
                                  || to_char(v_menge - v_pos.soll_menge)
                                  || chr(13)
                                  || chr(10);

                else
                    v_ret_text := v_ret_text
                                  || to_char(v_pos.li_nr)
                                  || '/'
                                  || to_char(v_pos.li_pos_nr)
                                  || ' '
                                  || v_pos.soll_menge
                                  || ' '
                                  || v_pos.mengeneinheit
                                  || ' '
                                  || v_menge
                                  || ' -> '
                                  || to_char(v_menge - v_pos.soll_menge)
                                  || chr(13)
                                  || chr(10);
                end if;
        --v_ret_text := nvl(v_ret_text, 'Warnung: Zu viel reserviert!' || CHR(13) || CHR(10)) ||
        --             'Lieferschein ' || to_char(v_pos.li_nr) || '/' || to_char(v_pos.li_pos_nr) || ' benötigt ' ||
        --              v_pos.soll_menge || ' ' || v_pos.mengeneinheit || ', ' || v_menge || ' reserviert!' || CHR(13) || CHR(10);
            end if;

        end loop;

        close c_pos;
        commit;
        if v_ret_text is not null then
            v_err_nr := 99;
            v_err_text := v_ret_text;
            raise v_error;
        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_pos%isopen then
                close c_pos;
            end if;
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_pos%isopen then
                close c_pos;
            end if;
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end c_aktiv_trans_umla;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function holt die Lagerorte eine Adresse als String mit ';' getrennt
  --
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
    function hole_lgr_orte_in_str (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_adress_id in isi_adressen.adress_id%type
    ) return varchar2 is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2056);
        v_lgr_orte varchar2(512);                            -- Gültige Lagerorte
        v_lgr_ort  lvs_lgr_ort.lgr_ort%type;
        cursor c_lgr_orte is
        select
            ort.lgr_ort
        from
            lvs_lgr_ort ort
        where
                ort.sid = in_sid
            and ort.firma_nr = in_firma_nr
            and ort.adress_id = in_adress_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        v_lgr_orte := null;
        open c_lgr_orte;
        loop
            fetch c_lgr_orte into v_lgr_ort;
            exit when c_lgr_orte%notfound;
            v_lgr_orte := v_lgr_orte
                          || to_char(v_lgr_ort)
                          || ';';
        end loop;

        close c_lgr_orte;
        return v_lgr_orte;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end hole_lgr_orte_in_str;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function löscht einen komplette Umlagerung mit allen Positionen
  -- und löscht alle Transporte und Reservierungen
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_del_umla (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_umla_nr  in isi_order_kopf.li_nr%type,
        in_user_id  in isi_user.login_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(255);
        v_found      boolean;                                -- Daten Gefunfen?
        v_result     number;
        v_order_pos  isi_order_pos%rowtype;
        v_transporte isi_transport%rowtype;
        v_lte        lvs_lte%rowtype;          --

        cursor c_order_pos is
        select
            *
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.satzart = 'LU'
            and pos.vorgang_typ = 'WUE'
            and pos.vorgang_id = in_umla_nr;

        cursor c_transporte is
        select
            *
        from
            isi_transport tra
        where
                tra.sid = in_sid
            and tra.firma_nr = in_firma_nr
            and tra.auf_id = v_order_pos.auf_id;

        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.firma_nr = in_firma_nr
            and lte.order_auf_id = v_order_pos.auf_id;

    begin
        v_err_nr := null;
        open c_order_pos;
        loop
            fetch c_order_pos into v_order_pos;
            exit when c_order_pos%notfound;
            if v_order_pos.freigegeben_datum is not null then
                open c_transporte;
                loop
                    fetch c_transporte into v_transporte;
                    exit when c_transporte%notfound;
                    begin
                        v_result := lvs_transport.lvs_transp_loeschen(in_sid, in_firma_nr, in_user_id, v_transporte.transp_id, 'F');
                    exception
                        when others then
                            null;
                    end;

                end loop;

                close c_transporte;
            elsif v_order_pos.ware_disponiert = c.c_true then
                open c_lte;
                loop
                    fetch c_lte into v_lte;
                    exit when c_lte%notfound;
                    v_result := lvs_ausl.lvs_lte_res_rueck(v_order_pos.sid, v_order_pos.firma_nr, v_order_pos.vorgang_id, v_order_pos.auf_id
                    , v_lte.lte_id,
                                                           v_lte.order_vorgang_id, v_lte.lgr_platz, c.c_true);

                end loop;

                close c_lte;
            end if;

        end loop;

        close c_order_pos;
        delete from isi_order_pos p
        where
                p.sid = in_sid
            and p.firma_nr = in_firma_nr
            and p.vorgang_typ = 'WUE'
            and p.vorgang_id = in_umla_nr
            and p.satzart = 'LU';

        delete from isi_order_kopf k
        where
                k.sid = in_sid
            and k.firma_nr = in_firma_nr
            and k.vorgang_typ = 'WUE'
            and k.vorgang_id = in_umla_nr
            and k.satzart = 'LU';

        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_order_pos%isopen then
                close c_order_pos;
            end if;
            if c_lte%isopen then
                close c_lte;
            end if;
            if c_transporte%isopen then
                close c_transporte;
            end if;
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_order_pos%isopen then
                close c_order_pos;
            end if;
            if c_lte%isopen then
                close c_lte;
            end if;
            if c_transporte%isopen then
                close c_transporte;
            end if;
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end c_del_umla;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function löscht eine komplette Bestellung mit allen Positionen
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_del_best (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_id  in isi_order_kopf.vorgang_id%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_satzart     in isi_order_kopf.satzart%type,
        in_user_id     in isi_user.login_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
    begin
        v_err_nr := null;

    -- Es müssen erst alle Positionen gelöscht werden, bevor ein Kopf gelöscht werden kann.
        delete from isi_order_pos p
        where
                p.sid = in_sid
            and p.firma_nr = in_firma_nr
            and ( p.vorgang_typ = in_vorgang_typ
                  or in_vorgang_typ is null )
            and p.vorgang_id = in_vorgang_id
            and p.satzart = in_satzart;

        delete from isi_order_kopf k
        where
                k.sid = in_sid
            and k.firma_nr = in_firma_nr
            and ( k.vorgang_typ = in_vorgang_typ
                  or in_vorgang_typ is null )
            and k.vorgang_id = in_vorgang_id
            and k.satzart = in_satzart;

        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end c_del_best;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function definiert, ob eine Order eine Vorbestellung ist
  -- COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    function is_vorbestellung (
        in_sid    in isi_order_pos.sid%type,
        in_auf_id in isi_order_pos.auf_id%type
    ) return varchar2 is

        v_ret_val   varchar2(10);
        v_order_pos isi_order_pos%rowtype;
        v_lam_menge number;
        cursor c_order_pos is
        select
            *
        from
            isi_order_pos op
        where
                op.sid = in_sid
            and op.auf_id = in_auf_id;

        cursor c_lam_menge is
        select
            nvl(
                sum(lam.menge),
                0
            )
        from
            lvs_lam lam
        where
                lam.sid = v_order_pos.sid
            and lam.artikel_id = v_order_pos.artikel_id
            and nvl(lam.zeichnung_index, 'Keine_') = nvl(v_order_pos.zeichnung_index,
                                                         nvl(lam.zeichnung_index, 'Keine_'))
            and ( lam.leitzahl = v_order_pos.leitzahl
                  or v_order_pos.leitzahl is null )
            and ( lam.fa_ag = v_order_pos.fa_ag
                  or v_order_pos.fa_ag is null )
            and lam.lgr_platz is not null
            and lam.order_pos_auf_id is null
            and lam.labor_status = 'F'
            and lam.lte_id = (
                select
                    t2.lte_id
                from
                    lvs_lte t2
                where
                        t2.lte_id = lam.lte_id
                    and t2.lte_status = 'LF'
            );

    begin
        v_ret_val := c.c_false;
        open c_order_pos;
        fetch c_order_pos into v_order_pos;
        if c_order_pos%found then
            open c_lam_menge;
            fetch c_lam_menge into v_lam_menge;
            if c_lam_menge%found then
                if v_lam_menge = 0 then
                    v_ret_val := c.c_true;
                end if;
            end if;

            close c_lam_menge;
        end if;

        close c_order_pos;
        return ( v_ret_val );
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function definiert, von welchen Lagerorten (nach FIFO) eine Order beliefert wird
  --------------------------------------------------------------------------------
  --******************************************************************************
    function get_liefer_lgr_orte_fifo (
        in_sid       in isi_order_pos.sid%type,
        in_auf_id    in isi_order_pos.auf_id%type,
        in_adress_id in lvs_lgr_ort.adress_id%type
    ) return varchar2 is

        v_ret_val   varchar2(255);
        v_order_pos isi_order_pos%rowtype;
        cursor c_order_pos is
        select
            *
        from
            isi_order_pos op
        where
                op.sid = in_sid
            and op.auf_id = in_auf_id;

        cursor c_lam_menge is
        select
            stradd_distinct(to_char(x.lgr_ort)) lgr_orte
        from
            (
                select
                    lte.lgr_ort
                from
                    lvs_lam     lam,
                    lvs_lte     lte,
                    lvs_lgr     lgr,
                    lvs_lgr_ort lo
                where
                        lam.sid = v_order_pos.sid
                    and lam.artikel_id = v_order_pos.artikel_id
                    and nvl(lam.zeichnung_index, 'Keine_') = nvl(v_order_pos.zeichnung_index,
                                                                 nvl(lam.zeichnung_index, 'Keine_'))
                    and ( lam.leitzahl = v_order_pos.leitzahl
                          or v_order_pos.leitzahl is null )
                    and ( lam.fa_ag = v_order_pos.fa_ag
                          or v_order_pos.fa_ag is null )
                    and lam.order_pos_auf_id is null
                    and lam.labor_status = 'F'
                    and lte.lte_id = lam.lte_id
                    and lgr.lgr_platz = lte.lgr_platz
                    and lgr.gesperrt = 'F'
                    and ( ( lgr.lgr_verwendung = c.lgr_typ_lager
                            and lte.lte_status = c.lte_lf_stat )
                          or ( lgr.lgr_verwendung = c.lgr_typ_we
                               and lte.lte_status = c.lte_bf_stat )
                          or ( lgr.lgr_verwendung = c.lgr_typ_lagerp
                               and lte.lte_status = c.lte_bf_stat ) )
                    and lo.sid = lte.sid
                    and lo.firma_nr = lte.firma_nr
                    and lo.lgr_ort = lte.lgr_ort
                    and ( lo.adress_id = in_adress_id
                          or in_adress_id is null )
                order by
                    lam.prod_datum,
                    lo.lgr_ort
            ) x;

    begin
        v_ret_val := null;
        open c_order_pos;
        fetch c_order_pos into v_order_pos;
        if c_order_pos%found then
            open c_lam_menge;
            fetch c_lam_menge into v_ret_val;
            if
                c_lam_menge%found
                and v_ret_val is not null
            then
                v_ret_val := v_ret_val || ';';
                null;
            end if;

            close c_lam_menge;
        end if;

        close c_order_pos;
        return ( v_ret_val );
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function löscht alle Vorbestellungen in einem vorgegebenen Zeitraum mit
  -- COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    function c_order_v_delete (
        in_von_datum   in varchar2,
        in_bis_datum   in varchar2,
        in_login_id    in isi_user.login_id%type,
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_satzart     in isi_order_kopf.satzart%type
    ) return number is

    --v_vorgang_id  isi_order_pos.vorgang_id%type;
        v_del_count number default 0;
        v_rec_count number default 0;
        v_pos       isi_order_pos%rowtype;

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(255);
        cursor c_pos is
        select
            op.*
        from
            isi_order_pos op
        where
            op.order_datum between to_date(nvl(in_von_datum, '01.01.1900')
                                           || ' 00:00:00',
        'dd.mm.yyyy hh24:mi:ss') and to_date(in_bis_datum || ' 23:59:59', 'dd.mm.yyyy hh24:mi:ss')
            and ( op.login_id = in_login_id
                  or in_login_id is null )
            and op.vorgang_typ = nvl(in_vorgang_typ, 'WAI')
            and op.status = 'N'
         -- pruefen, wieviel auf Lager ist
            and (
                select
                    nvl(
                        sum(lam.menge),
                        0
                    )
                from
                    lvs_lam lam
                where
                        lam.sid = op.sid
                    and lam.artikel_id = op.artikel_id
                    and ( lam.zeichnung_index = op.zeichnung_index
                          or op.zeichnung_index is null )
                    and ( lam.leitzahl = op.leitzahl
                          or op.leitzahl is null )
                    and ( lam.fa_ag = op.fa_ag
                          or op.fa_ag is null )
                    and lam.lgr_platz is not null
                    and lam.order_pos_auf_id is null
                    and lam.labor_status = 'F'
                    and lam.lte_id = (
                        select
                            t2.lte_id
                        from
                            lvs_lte t2
                        where
                                t2.lte_id = lam.lte_id
                            and t2.lte_status = 'LF'
                    )
            ) = 0;

    begin
        for v_pos in c_pos loop
            delete isi_order_pos op                                 -- Position löschen
            where
                    op.sid = in_sid
                and op.firma_nr = in_firma_nr
                and op.vorgang_typ = v_pos.vorgang_typ
                and op.satzart = v_pos.satzart
                and op.auf_id = v_pos.auf_id;

            v_del_count := v_del_count + 1;                         -- Löschvorgänge zählen
            select
                count(*)
            into v_rec_count                        -- im Kopf vorhanden Positionen zählen
            from
                isi_order_pos op                                 -- 99 als default, wenn Vorgang_ID nicht da, dann nicht löschen
            where
                    op.sid = in_sid
                and op.firma_nr = in_firma_nr
                and ( op.vorgang_typ = in_vorgang_typ
                      or in_vorgang_typ is null )
                and ( op.satzart = in_satzart
                      or in_satzart is null )
                and op.vorgang_id = v_pos.vorgang_id;

            if v_rec_count = 0                                      -- wenn keine Positionen im Kopf vorhanden sind

             then                                                    -- kann der Kopf gelöscht werden
                delete isi_order_kopf ok
                where
                        ok.sid = v_pos.sid
                    and ok.firma_nr = v_pos.firma_nr
                    and ok.vorgang_typ = v_pos.vorgang_typ
                    and ok.vorgang_id = v_pos.vorgang_id;

            end if;

            if ( v_del_count mod 10 ) = 0 then
                commit;
            end if;
        end loop;

        commit;
        return v_del_count;
    exception
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

            return 0;
    end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure reserviert automatisch die LTE's für diese Tour
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_tour_vorb_res (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type,
        in_user_id  in isi_user.login_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr       number;
        v_err_text     varchar2(2056);
        v_pos          isi_order_pos%rowtype;                    -- Positionsdaten
        v_kopf         isi_order_kopf%rowtype;                   -- Kopfdaten

        v_lte          lvs_lte%rowtype;                      -- LTE's
        v_lgr          lvs_lgr%rowtype;                      -- LTE's
        v_lte_id       lvs_lte.lte_id%type;
        v_lte_lgr_grp  lvs_lte.lgr_platz_gruppe%type;
        v_arbeitsplatz isi_arbeitsplatz_cfg%rowtype;
        v_lgr_orte     varchar2(255);
        v_found        boolean;                                  -- Dtaen gefunden

        v_transport    isi_transport%rowtype;
        cursor c_transport is
        select
            *
        from
            isi_transport tra
        where
                tra.sid = in_sid
            and tra.vorgang_id = in_tour_nr
        order by
            tra.freifahrauftrag,
            tra.transport_reihenfolge desc,
            tra.prio,
            tra.transp_id desc;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_transport;
        fetch c_transport into v_transport;
        v_found := c_transport%found;
        close c_transport;
        if v_found then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_order_tour_hat_transp);
      -- v_err_text := 'Fehler: Es sind bereits Transporte für diese Tour eingetragen.';
            raise v_error;
        end if;

        c_aktiv_trans_lief(in_sid, in_firma_nr, in_tour_nr, in_user_id, 'F');
        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end c_tour_vorb_res;

--------------------------------------------------------------------------------
-- procedure LVS_SUCHE_UM_PLATZ
-- suche um lagerplatz x nach einem freien Lagerplatz
--------------------------------------------------------------------------------
    function tour_suche_um_platz (
        in_lte             in lvs_lte%rowtype,
        in_lvs_akt_lgr     in lvs_lgr%rowtype,
        in_lgr_platz_grp   in varchar2,
        in_tranport_gruppe in isi_transport.transport_gruppe%type,
        out_lvs_lgr        out lvs_lgr%rowtype,
        out_fahrzeuge_ids  out varchar2
    ) return varchar2 is

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr              number;
        v_err_text            varchar2(2056);
        v_found               boolean;
        v_reservierung        lvs_lte.res_string%type;
        v_lgr_platz           lvs_lgr.lgr_platz%type;
        v_lgr_dim_platz_ref   lvs_lgr.lgr_dim_platz%type;
        v_ausl_dispo_faktor   number;
        v_ausl_dispo_bestand  number;
        v_dat                 date;
        v_lgr_platz_gruppe    lvs_lgr.lgr_platz_gruppe%type;
        v_start_pos           number;
        v_ende_pos            number;
        v_fahrzeuge_id        lvs_fahrzeuge.res_id%type;
        v_firma_cfg_lager_erl varchar2(1);
        v_lte_cfg             lvs_lte_cfg%rowtype;
        v_basis_lte_name      lvs_lte_cfg.basis_lte_name%type;
        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = in_lte.sid
            and t.firma_nr = in_lte.firma_nr
            and t.lte_name = in_lte.lte_name;

        cursor c_um_lgr is
        select
            lgr.*
        from
            lvs_lgr     lgr,
            lvs_lgr_ort zlo,
            lvs_lgr_ort qlo
        where
                lgr.sid = in_lvs_akt_lgr.sid
            and lgr.firma_nr = in_lvs_akt_lgr.firma_nr
            and lgr.lgr_platz_gruppe = v_lgr_platz_gruppe
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.lgr_typ = in_lvs_akt_lgr.lgr_typ
                  or ( lgr.lgr_ort != in_lvs_akt_lgr.lgr_ort
                       and lgr.lgr_verwendung = c.lgr_typ_puffer ) )
            and ( ( lgr.lgr_verwendung = c.lgr_typ_lager
                    and v_firma_cfg_lager_erl = c.c_true
                    and lgr.lgr_typ != c.sat_epl1
                    and lgr.lgr_typ != c.sat_epl2 )
                  or lgr.lgr_verwendung = c.lgr_typ_puffer )
            and lgr.lgr_platz_gruppe <> in_lvs_akt_lgr.lgr_platz_gruppe
         -- CMe 20210504 Auf LTE Basis Name prüfen, falls dieser vorhanden ist
         -- Ticket: E70397-623
            and instr(
                nvl(lgr.lte_namen, v_basis_lte_name),
                v_basis_lte_name
            ) > 0
            and ( nvl(lgr.res_string,
                      to_char(in_tranport_gruppe)) = to_char(in_tranport_gruppe)
                  or lgr.lgr_ort = in_lvs_akt_lgr.lgr_ort )
            and in_lvs_akt_lgr.sid = qlo.sid
            and in_lvs_akt_lgr.firma_nr = qlo.firma_nr
            and in_lvs_akt_lgr.lgr_ort = qlo.lgr_ort
            and ( qlo.verl_vorb_lgr_orte like ( '%;'
                                                || to_char(lgr.lgr_ort) || ';%' )
                  or qlo.verl_vorb_lgr_orte like ( to_char(lgr.lgr_ort) || ';%' )
                  or qlo.verl_vorb_lgr_orte like ( '%;' || to_char(lgr.lgr_ort) )
                  or ( lgr.lgr_ort = qlo.lgr_ort
                       and qlo.verl_vorb_lgr_orte is null ) )
            and lgr.sid = zlo.sid
            and lgr.firma_nr = zlo.firma_nr
            and lgr.lgr_ort = zlo.lgr_ort
         -- STAP_FLAE2 (Genrell pruefen wenn gefuellt---------------
            and lgr.lgr_vol_breite >= in_lte.lte_vol_breite
            and nvl(lgr.lgr_min_lte_breite, 0) <= in_lte.lte_vol_breite
            and lgr.lgr_vol_tiefe >= in_lte.lte_vol_tiefe
            and nvl(lgr.lgr_min_lte_tiefe, 0) <= in_lte.lte_vol_tiefe
            and nvl(lgr.lgr_min_lte_hoehe, 0) <= in_lte.lte_vol_hoehe
         -- --------------------------------------------------------
            and ( ( lgr.lgr_typ != c.stap_flae1 )
                  or ( lgr.lgr_typ = c.stap_flae1
                       and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
                       and lgr.lgr_frei_breite <= in_lte.lte_vol_breite + nvl(zlo.lgr_ort_raster_x, 0)
                       and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
                       and lgr.lgr_frei_tiefe <= in_lte.lte_vol_tiefe + nvl(zlo.lgr_ort_raster_y, 0) ) )
        order by
            lgr.lgr_dim_fifo_nr asc;

        cursor c_fahrzeuge is
        select
            f.res_id
        from
            lvs_fahrzeuge        f,
            lvs_lgr_grp_fahrzeug gf
        where
                gf.lgr_ort = out_lvs_lgr.lgr_ort
            and gf.lgr_gruppe_id = out_lvs_lgr.lgr_gruppe_id
            and f.res_id = gf.res_id;

    begin
      -- AG 2019-01-07 Einbau, dass Lager als Vorbereitung abgeschaltet wird
        if isi_allg.get_firma_cfg_param(in_lte.sid, in_lte.firma_nr, 'AUSL_VORBER',            -- in_kategorie             in isi_firma_cfg.kategorie%type,
         'TYP_ERLAUBT',            -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'LAGER',                  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'Order',                  -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                         'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                         'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                         'BOOLEAN') = c.c_true     -- in_default_param_typ
                                         then
            v_firma_cfg_lager_erl := c.c_true;
        else
            v_firma_cfg_lager_erl := c.c_false;
        end if;

        v_err_nr := null;
        v_err_text := null;
        v_start_pos := 1;
        v_ende_pos := 1;
        while ( v_ende_pos > 0 ) loop
            v_ende_pos := instr(in_lgr_platz_grp, ';', v_start_pos, 1);
            if ( v_ende_pos > 0 ) then
                v_lgr_platz_gruppe := substr(in_lgr_platz_grp, v_start_pos, v_ende_pos - v_start_pos);
                if v_lgr_platz_gruppe is null   -- Fals Fehler dann diesen auch melden
                 then
                    v_err_nr := 30;
                    v_err_text := lc.ec(lc.o_txt_frei_plaetze_n_ausr);
          -- v_err_text := 'Fehler: Nicht genügend freie Lagerplätze. ';
                    raise v_error;
                end if;

                if v_lgr_platz_gruppe = '1-38250.4750' then
                    null;
                end if;
                v_start_pos := v_ende_pos + 1;

        -- CMe 20210504 Anfang:
        -- Basis LTE Name muss jetzt frueher geholt werden, da er in c_um_lgr benötigt wird
        -- Ticket: E70397-623
                open c_lte_cfg;
                fetch c_lte_cfg into v_lte_cfg;
                close c_lte_cfg;
                v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, in_lte.lte_name);
        -- CMe 20210504 Ende

                open c_um_lgr;
                fetch c_um_lgr into out_lvs_lgr;
                v_found := c_um_lgr%found;
                close c_um_lgr;
                if v_found then
                    out_fahrzeuge_ids := null;
                    open c_fahrzeuge;
                    fetch c_fahrzeuge into v_fahrzeuge_id;
                    loop
                        exit when c_fahrzeuge%notfound;
                        out_fahrzeuge_ids := ';' || to_char(v_fahrzeuge_id);
                        fetch c_fahrzeuge into v_fahrzeuge_id;
                    end loop;

                    close c_fahrzeuge;
                    if out_fahrzeuge_ids is not null then
                        out_fahrzeuge_ids := out_fahrzeuge_ids || ';';
                    end if;
                    v_err_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, v_basis_lte_name, v_lte_cfg.flaechen_stellplatz_erf
                    , out_lvs_lgr, 'U',
                                                                           out_fahrzeuge_ids);

                    if v_err_text is null then
                        return v_err_text;
                    end if;
                end if;

            end if;

        end loop;

        out_lvs_lgr := null;
        return v_err_text;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end tour_suche_um_platz;

--------------------------------------------------------------------------------
-- -AG- 27.01.2011
-- Alle procedure und fuction im Bereich der Vorbereitung hatten nur eine
-- Prototyp Karakter.
-- Jetzt fuktional umgesetzt - Im gleichen oder anderem Lagerort
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- procedure TOUR_VORB_TRANS
-- tour_suche_um_platz aufrufen
-- Dispo in Ziel buchen
-- Transportauftrag generieren
--------------------------------------------------------------------------------
    procedure tour_vorb_uml (
        in_lte              in lvs_lte%rowtype,
        in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
        in_prio             in isi_transport.prio%type,
        in_lgr_platz_grp    in varchar2,
        in_tour_nr          in isi_order_kopf.vorgang_id%type,
        in_order_pos        in isi_order_pos%rowtype,
        in_user_id          in isi_user.login_id%type,
        in_lkw_id           in isi_transport.lkw_nr%type
    ) is

        v_err_nr             pls_integer;
        v_err_text           varchar2(2056);
        v_error exception;
        v_transp_lte         number;
        v_quelle_lvs_lgr_rec lvs_lgr%rowtype;
        v_ziel_lvs_lgr_rec   lvs_lgr%rowtype;
        v_lgr_ort            lvs_lgr_ort%rowtype;
        v_lgr_platz          lvs_lgr.lgr_platz%type;
        v_found              boolean;
        v_transport_id       isi_transport.transp_id%type;
        v_trans_typ          isi_transport.transp_typ%type;
        v_fahrzeuge_ids      varchar2(50);
        v_last_transp_grp    isi_transport.transport_gruppe%type;
        cursor c_lgr is
        select
            lgr.*
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz = in_lte.lgr_platz
            and lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr;

    begin
        v_err_nr := null;
        v_err_text := null;
        v_lgr_platz := in_lte.lgr_platz;
        open c_lgr;
        fetch c_lgr into v_quelle_lvs_lgr_rec;
        v_found := c_lgr%found;
        close c_lgr;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt,
                                   nvl(in_lte.lgr_platz, '<NULL>'));
      -- v_err_text := 'Fehler: Lagerplatz ''' || NVL(in_lte.lgr_platz, '<NULL>') || ''' ist unbekannt';
            raise v_error;
        end if;

    -- -AG- Bei der Vorbereitung muss die Transportgruppe ermittetlt werden, damit die LTE's auch bei von Lagerort
    -- zu lagerort korrekt einsortiert werden
    -- v_transport_gruppe := 0;
        if nvl(lvs_ausl.v_order_transport_gruppe, 0) != in_order_pos.transport_gruppe
        or lvs_ausl.v_transport_gruppe is null then
            if isi_allg.get_firma_cfg_param(in_lte.sid, in_lte.firma_nr, 'AUSL_STRAT',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
             null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
             'ORDER_AUSL_VORB_PAR',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                            'Order',                  -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                             'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                             'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                             'BOOLEAN') = c.c_false    -- in_default_param_typ
                                             then
                if lvs_ausl.v_order_transport_gruppe is not null then
                    lvs_ausl.v_sperr_transport_gruppe := true;
                    v_last_transp_grp := lvs_ausl.v_transport_gruppe;
                end if;
            end if;

            lvs_ausl.v_transport_gruppe := null;
            select
                max(lte.transport_gruppe)
            into lvs_ausl.v_transport_gruppe
            from
                lvs_lte lte
            where
                lte.order_auf_id in (
                    select
                        p.auf_id
                    from
                        isi_order_pos p
                    where
                            p.vorgang_id = (
                                select
                                    p2.vorgang_id
                                from
                                    isi_order_pos p2
                                where
                                    p2.auf_id = in_order_pos.auf_id
                            )
                        and p.transport_gruppe = (
                            select
                                p2.transport_gruppe
                            from
                                isi_order_pos p2
                            where
                                p2.auf_id = in_order_pos.auf_id
                        )
                )
                and lte.transport_gruppe is not null;

            if nvl(lvs_ausl.v_transport_gruppe, 0) = 0 -- Noch keine LTE Vorbereitet

             then
                select
                    seq_transport_gruppe.nextval
                into lvs_ausl.v_transport_gruppe
                from
                    dual; -- Dann neue Nummer holen
            end if;

            dbms_output.put_line('auf_id='
                                 || to_char(in_order_pos.auf_id)
                                 || ' Tgpr=' || to_char(lvs_ausl.v_transport_gruppe));

            lvs_ausl.v_order_transport_gruppe := in_order_pos.transport_gruppe;
            if lvs_ausl.v_sperr_transport_gruppe then
                update lvs_lgr t
                set
                    t.res_string = to_char(lvs_ausl.v_transport_gruppe)
                where
                        t.res_string = to_char(v_last_transp_grp)
                    and t.lgr_akt_te < t.lgr_max_te;

            end if;

        end if;

        if to_char(lvs_ausl.v_transport_gruppe) = v_quelle_lvs_lgr_rec.res_string then
            return;
        end if;
        v_err_text := tour_suche_um_platz(in_lte, v_quelle_lvs_lgr_rec, in_lgr_platz_grp, lvs_ausl.v_transport_gruppe, v_ziel_lvs_lgr_rec
        ,
                                          v_fahrzeuge_ids);

        if
            v_err_text is null
            and v_ziel_lvs_lgr_rec.lgr_platz is null
        then
            if
                lvs_p_base.get_lgr_ort(v_quelle_lvs_lgr_rec.sid, v_quelle_lvs_lgr_rec.firma_nr, v_quelle_lvs_lgr_rec.lgr_ort, v_lgr_ort
                )
                and v_lgr_ort.verl_vorb_lgr_orte is not null
            then
                v_err_text := lc.ec(lc.o_txt_vorb_frei_plaetze_n_ausr);
            else
                return;
            end if;
        end if;

        if v_err_text is not null
           or v_ziel_lvs_lgr_rec.lgr_platz is null then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_vorb_frei_plaetze_n_ausr);
      -- v_err_text := 'Fehler: Nicht genügend Lagerplätze die die Bedingungen für die Paletten in dieser Tour erfüllen. ' || v_err_text;
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

        v_transp_lte := lvs_transport.lvs_transp_lte(in_lte.sid,                     -- in_sid                  IN isi_sid.sid%TYPE,

         in_lte.firma_nr,                -- in_firma_nr             IN isi_firma.firma_nr%TYPE,

         in_modul_erzeuger,              -- in_modul_erzeuger       IN isi_transport.modul_erzeuger%TYPE,

         in_modul_bearbeiter,            -- in_modul_bearbeiter     IN isi_transport.modul_bearbeiter%TYPE,

         c.c_false,                      -- in_frei_fahren          IN varchar2,
                                                     v_trans_typ,                    -- in_trans_typ            in varchar2,
                                                      in_user_id,                     -- in_user_id              IN isi_user.login_id%TYPE,
                                                      in_order_pos.auf_id,            -- in_auftrag_id           IN isi_transport.auf_id%TYPE,
                                                      in_order_pos.auf_id_extern,     -- in_auftrag_id_extern    IN isi_transport.auf_id_extern%TYPE,
                                                      in_prio,                        -- in_prio                 IN isi_transport.prio%TYPE,
                                                     0,                              -- in_progr_nr             IN isi_transport.progr_nr%TYPE,
                                                      0,                              -- in_quelle_leer_progr_nr IN isi_transport.quelle_leer_progr_nr%TYPE,
                                                      0,                              -- in_ziel_voll_progr_nr   IN isi_transport.ziel_voll_progr_nr%TYPE,
                                                      v_quelle_lvs_lgr_rec.lgr_platz, -- in_lgr_quell_lgr_platz  IN lvs_lte.lgr_platz%TYPE,
                                                      v_ziel_lvs_lgr_rec.lgr_platz,   -- in_lgr_ziel_lgr_platz   IN lvs_lte.lgr_platz%TYPE,
                                                     in_lte.lte_id,                  -- in_lte_id               IN lvs_lte.lte_id%TYPE,
                                                      0,                              -- in_kunde_nr             IN lvs_lam.kunden_nr%TYPE
                                                      c.c_false,                      -- in_lieferschein
                                                      null,                           -- Lieferschein Nummer
                                                      null,                           -- Lieferscheinposition -Nummer
                                                     in_tour_nr, v_fahrzeuge_ids, in_lkw_id, lvs_ausl.v_transport_gruppe, v_transport_id
                                                     );

        if lvs_ausl.v_sperr_transport_gruppe then
            v_transp_lte := lvs_transport.transport_sperren(in_lte.sid, in_lte.firma_nr, in_user_id, v_transport_id);
        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end tour_vorb_uml;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure reserviert automatisch die LTE's für diese Tour
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_tour_vorb_trans (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_tour_nr   in isi_order_kopf.vorgang_id%type,
        in_platz_grp in varchar2,
        in_user_id   in isi_user.login_id%type
    ) is
    begin
        tour_vorb_trans(in_sid,        -- in_sid         in isi_sid.sid%type,
         in_firma_nr,   -- in_firma_nr    in isi_firma.firma_nr%type,
         in_tour_nr,    -- in_tour_nr     in isi_order_kopf.vorgang_id%type,
         in_platz_grp,  -- in_platz_grp   in varchar2,
         in_user_id,    -- in_user_id     in isi_user.login_id%type
                        null);
        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when others then
            rollback;
            raise;
    end c_tour_vorb_trans;
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure reserviert automatisch die LTE's für diese Tour
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure tour_vorb_trans (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_tour_nr   in isi_order_kopf.vorgang_id%type,
        in_platz_grp in varchar2,
        in_user_id   in isi_user.login_id%type,
        in_lkw_nr    in isi_transport.lkw_nr%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr        number;
        v_err_text      varchar2(2056);
        v_pos           isi_order_pos%rowtype;                    -- Positionsdaten
        v_lte           lvs_lte%rowtype;
        v_lte_id        lvs_lte.lte_id%type;
        v_quell_lgr_ort lvs_lgr_ort%rowtype;       -- Lagerort der LTE
        v_found         boolean;                   -- Dummy Var für gefunden im CURSOR
        v_anz_transp    number;

    -- KONSI-Lager berücksichtigen
        cursor c_pos is
        select
            pos.*
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                 'LNK' )
            and pos.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
            and pos.vorgang_id = in_tour_nr
            and pos.freigegeben_datum is null
        order by
            pos.vorgang_id desc,
            pos.transport_gruppe,
            pos.li_nr desc,
            pos.li_pos_nr desc;

        cursor c_lgr_ort is                             -- Lesen des Lagerplatz
        select
            *
        from
            lvs_lgr_ort ort
        where
                ort.lgr_ort = v_lte.lgr_ort
            and ort.sid = in_sid;

        cursor c_lam_auf_id is
        select
            lam.lte_id
        from
            lvs_lam lam,
            lvs_lte lte,
            lvs_lgr lgr
        where
                lam.sid = v_pos.sid
            and lam.order_pos_auf_id = v_pos.auf_id
            and lte.sid = v_pos.sid
            and lte.lte_id = lam.lte_id
            and lte.ziel_lgr_platz is null
            and lte.lgr_platz = lgr.lgr_platz
            and nvl(
                to_char(lte.transport_gruppe),
                lte.res_string || 'X'
            ) != nvl(lgr.res_string, 'xx') -- Wenn Transportgruppe = Res-Struíng dann bereits vortereitet
        group by
            lam.lte_id,
            lgr.lgr_platz_gruppe,
            lgr.lgr_dim_fifo_nr,
            lgr.lgr_typ,
            lte.res_mhd,
            lte.lte_letzte_buchung
        order by
            decode(lgr.lgr_typ,
                   c.stap_flae1,
                   nvl(
                min(lte.lte_offset_z * -1),
                0
            ),
                   c.stap_flae2,
                   nvl(
                min(lte.lte_offset_z * -1),
                0
            ),
                   0),
            lgr.lgr_platz_gruppe desc,
            lgr.lgr_dim_fifo_nr desc,
            decode(lgr.lgr_typ, c.durchl1, lte.lte_letzte_buchung, sysdate - 2),     -- Bei Durchlauflager in Einlagerreihenfolge
            lte.res_mhd,
            lte.lte_letzte_buchung desc;

        cursor c_lte is
        select
            lte.*
        from
            lvs_lte lte
        where
                lte.sid = v_pos.sid
            and lte.lte_id = v_lte_id;

        cursor c_trans_anz is
        select
            count(*)
        from
            isi_transport t
        where
            t.vorgang_id = in_tour_nr;

    begin
        v_err_nr := null;
        v_err_text := null;
        lvs_ausl.v_sperr_transport_gruppe := false;
        lvs_ausl.v_order_transport_gruppe := null;
        lvs_ausl.v_transport_gruppe := null;
        open c_pos;
        loop
            fetch c_pos into v_pos;                                             -- Positionsdaten lesen
            exit when c_pos%notfound;
            open c_lam_auf_id;
            loop
                fetch c_lam_auf_id into v_lte_id;
                v_found := c_lam_auf_id%found;
                if v_found then
                    open c_lte;
                    fetch c_lte into v_lte;
                    close c_lte;
                    open c_lgr_ort;
                    fetch c_lgr_ort into v_quell_lgr_ort;
                    close c_lgr_ort;
                    if lvs_transport.lvs_check_lte_stap_flae_frei(v_lte) > 0 -- Sonst ist die Palette frei. Freifahren nicht nötig
                     then
                        tour_vorb_uml(v_lte, 'ORD', v_quell_lgr_ort.lgr_ort_modul, 0, in_platz_grp,
                                      in_tour_nr, v_pos, in_user_id, in_lkw_nr);
                    end if;

                else
                    exit;
                end if;

            end loop;

            close c_lam_auf_id;
        end loop;

        close c_pos;
        open c_trans_anz;
        fetch c_trans_anz into v_anz_transp;
        close c_trans_anz;
        if nvl(v_anz_transp, 0) > 0 then
      -- KONSI-Lager berücksichtigen
            update isi_order_kopf k
            set
                k.status = 'R'
            where
                    k.sid = in_sid
                and k.firma_nr = in_firma_nr
                and k.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                   'LNK' )
                and k.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
                and k.vorgang_id = in_tour_nr
                and k.status != 'E'
                and k.freigegeben_datum is null;

            update isi_order_pos p
            set
                p.status = 'R'
            where
                    p.sid = in_sid
                and p.firma_nr = in_firma_nr
                and p.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                   'LNK' )
                and p.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
                and p.vorgang_id = in_tour_nr
                and p.status != 'E'
                and p.freigegeben_datum is null;

        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_lam_auf_id%isopen then
                close c_lam_auf_id;
            end if;
            if c_pos%isopen then
                close c_pos;
            end if;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_lam_auf_id%isopen then
                close c_lam_auf_id;
            end if;
            if c_pos%isopen then
                close c_pos;
            end if;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end tour_vorb_trans;

  --******************************************************************************
  --------------------------------------------------------------------------------

  -- Suchen nach Vorbereitungsplätzen für die VorabOptimierung. Prüfen und Verladevorb. Starten
  -- generiert alle  Umlageraufträge oder Rollback
  -- mit COMMIT
  -- Ware muss disponiert sein.
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_tour_vorb_start (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type,
        in_user_id  in isi_user.login_id%type
    ) is
    begin
        tour_vorb_start(in_sid,                   -- in_sid         in isi_sid.sid%type,
         in_firma_nr,              -- in_firma_nr    in isi_firma.firma_nr%type,
         in_tour_nr,               -- in_tour_nr     in isi_order_kopf.vorgang_id%type,
         in_user_id);              -- in_user_id     in isi_user.login_id%type
        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when others then
            rollback;
            raise;
    end c_tour_vorb_start;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function die Lagerplätze die verwenden werden könne zurück und prüft ob ausreichend
  -- plaetze vorhanden sind
  --------------------------------------------------------------------------------
  --******************************************************************************
    function tour_tour_vl (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type,
        in_ziel     in isi_order_kopf.ziel%type,
        in_lgr_wa   in lvs_lgr%rowtype
    ) return varchar2 is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(2056);
        v_lte_anz           number;
        v_lte_name_anz      number;
        v_lte_name          lvs_lte_cfg.lte_name%type;
        v_lgr_ort           lvs_lgr_ort.lgr_ort%type;
        v_lte_tra_grp       lvs_lte.transport_gruppe%type;
        v_lgr_orte          lvs_lgr_ort.verl_vorb_lgr_orte%type;
        v_lgr               lvs_lgr%rowtype;           -- Lager
        v_freie_plaetze     number;
        v_lgr_platz_grp     varchar2(4096);
        v_abstand_abs       number;
        v_freie_plaetze_typ number;
        v_lte_typen         varchar2(500);
        v_found             boolean;
        cursor c_order_lte_ges_anz is
        select
            count(lte.order_vorgang_id)
        from
            lvs_lte     lte,
            lvs_lte_cfg cfg,
            lvs_lgr     lgr
        where
                lte.sid = in_sid
            and lte.order_vorgang_id = in_tour_nr
            and lte.sid = cfg.sid
            and lte.firma_nr = cfg.firma_nr
            and lte.lte_name = cfg.lte_name
            and lte.lgr_platz = lgr.lgr_platz
            and nvl(
                to_char(lte.transport_gruppe),
                lte.res_string || 'X'
            ) != nvl(lgr.res_string, 'xx') -- Wenn Transportgruppe = Res-Struíng dann bereits vortereitet
        group by
            lte.order_vorgang_id;

        cursor c_order_lte_anz is
        select
            count(lte.order_vorgang_id),
            nvl(cfg.basis_lte_name, lte.lte_name) lte_name,
            decode(
                max(lte.lgr_ort),
                min(lte.lgr_ort),
                max(lte.lgr_ort),
                null
            )                                     lgr_ort
        from
            lvs_lte     lte,
            lvs_lte_cfg cfg,
            lvs_lgr     lgr
        where
                lte.sid = in_sid
            and lte.order_vorgang_id = in_tour_nr
            and lte.sid = cfg.sid
            and lte.firma_nr = cfg.firma_nr
            and lte.lte_name = cfg.lte_name
            and lte.lgr_platz = lgr.lgr_platz
            and nvl(
                to_char(lte.transport_gruppe),
                lte.res_string || 'X'
            ) != nvl(lgr.res_string, 'xx') -- Wenn Transportgruppe = Res-Struíng dann bereits vortereitet
        group by
            lte.order_vorgang_id,
            nvl(cfg.basis_lte_name, lte.lte_name);

        cursor c_vorb_lgr_plaetze is
        select
            gb.*
        from
            (
                select
                    t.lgr_ort,
                    t.lgr_platz_gruppe,
                    t.lgr_typ,
                    ( abs(t.lgr_ort - in_lgr_wa.lgr_ort) * 100000000 + abs(trunc((t.lgr_dim_r + 1) / 2) - in_lgr_wa.lgr_dim_r) + abs(
                    t.lgr_dim_e - in_lgr_wa.lgr_dim_e) + decode(t.lgr_typ,
                                                                                                                                 c.stap_flae1
                                                                                                                                 ,
                                                                                                                                 case
                                                                                                                                     when
                                                                                                                                     abs
                                                                                                                                     (
                                                                                                                                     t.lgr_dim_p - in_lgr_wa.lgr_dim_p
                                                                                                                                     ) > abs
                                                                                                                                     (
                                                                                                                                     min
                                                                                                                                     (
                                                                                                                                     t.lgr_dim_t
                                                                                                                                     ) - in_lgr_wa.lgr_dim_t
                                                                                                                                     )
                                                                                                                                     then
                                                                                                                                                          abs
                                                                                                                                                          (
                                                                                                                                                          t.lgr_dim_p - in_lgr_wa.lgr_dim_p
                                                                                                                                                          )
                                                                                                                                     else
                                                                                                                                         abs
                                                                                                                                         (
                                                                                                                                         min
                                                                                                                                         (
                                                                                                                                         t.lgr_dim_t
                                                                                                                                         ) - in_lgr_wa.lgr_dim_t
                                                                                                                                         )
                                                                                                                                 end,
                                                                                                                                 c.stap_flae2
                                                                                                                                 ,
                                                                                                                                 case
                                                                                                                                     when
                                                                                                                                     abs
                                                                                                                                     (
                                                                                                                                     t.lgr_dim_p - in_lgr_wa.lgr_dim_p
                                                                                                                                     ) > abs
                                                                                                                                     (
                                                                                                                                     min
                                                                                                                                     (
                                                                                                                                     t.lgr_dim_t
                                                                                                                                     ) - in_lgr_wa.lgr_dim_t
                                                                                                                                     )
                                                                                                                                     then
                                                                                                                                                          abs
                                                                                                                                                          (
                                                                                                                                                          t.lgr_dim_p - in_lgr_wa.lgr_dim_p
                                                                                                                                                          )
                                                                                                                                     else
                                                                                                                                         abs
                                                                                                                                         (
                                                                                                                                         min
                                                                                                                                         (
                                                                                                                                         t.lgr_dim_t
                                                                                                                                         ) - in_lgr_wa.lgr_dim_t
                                                                                                                                         )
                                                                                                                                 end,
                                                                                                                                 abs(
                                                                                                                                 t.lgr_dim_p - in_lgr_wa.lgr_dim_p
                                                                                                                                 )) ) porder2
                                                                                                                                 ,
                    min(t.lgr_verwendung)                     verwendung,
                    sum(t.lgr_akt_te)                         lte,
                    sum(t.lgr_max_te)                         max_lte,
                    sum(t.lgr_einl_te_verfueg)                lgr_einl_te_verfueg
                from
                    lvs_lgr t
                where
                    ( t.lgr_verwendung = c.r_lgr_typ_lager
                      or t.lgr_verwendung = c.r_lgr_typ_puffer )
                    and t.sid = in_sid
                    and t.firma_nr = in_firma_nr
                    and nvl(v_lgr_platz_grp, '?') not like '%;'
                    || t.lgr_platz_gruppe
                    || ';%'
                       and nvl(v_lgr_platz_grp, '?') not like t.lgr_platz_gruppe || ';%'
                    and ( v_lgr_orte like '%;'
                                          || to_char(t.lgr_ort)
                                          || ';%'
                          or v_lgr_orte like to_char(t.lgr_ort)
                                             || ';%' )
                    and t.gesperrt = c.r_lgr_gesperrt_f
                    and t.akt_inventur_id is null
                    and nvl(t.lte_namen, v_lte_name || ';') like '%'
                                                                 || v_lte_name
                                                                 || ';%'
                group by
                    t.lgr_platz_gruppe,
                    t.lgr_verwendung,
                    t.lgr_typ,
                    t.lgr_ort,
                    t.lgr_dim_g,
                    t.lgr_dim_r,
                    t.lgr_dim_p,
                    t.lgr_dim_e
            )           gb,
            lvs_lgr     lgr,
            lvs_lgr_ort ort
        where
                lgr.lgr_platz = gb.lgr_platz_gruppe
            and ( ( ( ( ( gb.lte = 0
                          or lgr.res_string in (
                select
                    to_char(lte.transport_gruppe)
                from
                    lvs_lte lte
                where
                        lte.order_vorgang_id = in_tour_nr
                    and lte.transport_gruppe is not null
            ) )
                        and gb.lgr_typ != c.r_sat_epl1            -- Bei EinzelplatzSatelitenlager nur in Puffern vorbereiten
                        and gb.lgr_typ != c.r_sat_epl2            -- Bei EinzelplatzSatelitenlager nur in Puffern vorbereiten
                         )
                      or gb.verwendung = c.r_lgr_typ_puffer )
                    and ( lgr.res_string is null
                          or lgr.res_string in (
                select
                    to_char(lte.transport_gruppe)
                from
                    lvs_lte lte
                where
                        lte.order_vorgang_id = in_tour_nr
                    and lte.transport_gruppe is not null
            ) )
                    and lgr.res_artikel_id is null )
                  or gb.lgr_typ = c.stap_flae1
                  or gb.lgr_typ = c.stap_flae2 )
            and ort.lgr_ort = lgr.lgr_ort
        order by
            decode(ort.verl_vorb_lgr_orte, null, porder2, lte * -1),
            gb.lgr_platz_gruppe,
            decode(ort.verl_vorb_lgr_orte,
                   null,
                   abs(lgr.lgr_dim_platz - in_lgr_wa.lgr_dim_platz),
                   0);

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_order_lte_ges_anz;
        fetch c_order_lte_ges_anz into v_lte_anz;
        close c_order_lte_ges_anz;
        v_lgr_platz_grp := null;
        if nvl(v_lte_anz, 0) = 0 then
            return ( v_lgr_platz_grp );
        end if;
        v_lgr_orte := get_lgr_orte_vorbereitung(in_sid, in_firma_nr, in_tour_nr, in_ziel);
        v_lte_anz := 0;
        open c_order_lte_anz;
        loop
            fetch c_order_lte_anz into
                v_lte_name_anz,
                v_lte_name,
                v_lgr_ort;
            exit when c_order_lte_anz%notfound
            or v_freie_plaetze < v_lte_name_anz;
            open c_vorb_lgr_plaetze;
            loop
                fetch c_vorb_lgr_plaetze into
                    v_lgr.lgr_ort,
                    v_lgr.lgr_platz_gruppe,
                    v_lgr.lgr_typ,
                    v_abstand_abs,
                    v_lgr.lgr_verwendung,
                    v_lgr.lgr_akt_te,
                    v_lgr.lgr_max_te,
                    v_lgr.lgr_einl_te_verfueg;

                exit when c_vorb_lgr_plaetze%notfound;
                v_freie_plaetze := nvl(v_freie_plaetze, 0) + v_lgr.lgr_max_te;
                v_lgr_platz_grp := nvl(v_lgr_platz_grp, '')
                                   || v_lgr.lgr_platz_gruppe
                                   || ';';
                exit when v_freie_plaetze >= v_lte_name_anz;
            end loop;

            close c_vorb_lgr_plaetze;
        end loop;

        close c_order_lte_anz;
        if v_freie_plaetze < v_lte_name_anz then
            v_err_nr := 30;
            v_err_text := lc.ec(lc.o_txt_frei_plaetze_n_ausr);
      -- v_err_text := 'Fehler: Nicht genügend freie Lagerplätze. ';
            raise v_error;
        end if;

    -- AG 2017.09.11 Hier muss die Platz-Gruppe ein reset bekommen, da er bei der weiteren Suche ueber alle Plaätze ausgegrenzt würde
        v_lgr_platz_grp := null;
        v_lte_anz := 0;
        v_lte_typen := null;
        open c_order_lte_anz;
        loop
            fetch c_order_lte_anz into
                v_lte_name_anz,
                v_lte_name,
                v_lgr_ort;
            exit when c_order_lte_anz%notfound;
            v_freie_plaetze_typ := 0;
            open c_vorb_lgr_plaetze;
            loop
                fetch c_vorb_lgr_plaetze into
                    v_lgr.lgr_ort,
                    v_lgr.lgr_platz_gruppe,
                    v_lgr.lgr_typ,
                    v_abstand_abs,
                    v_lgr.lgr_verwendung,
                    v_lgr.lgr_akt_te,
                    v_lgr.lgr_max_te,
                    v_lgr.lgr_einl_te_verfueg;

                exit when c_vorb_lgr_plaetze%notfound;
                if v_freie_plaetze_typ = 0 then
                    if v_lte_typen is null then
                        v_lte_typen := v_lte_name;
                    else
                        v_lte_typen := v_lte_typen
                                       || '; '
                                       || v_lte_name;
                    end if;
                end if;

                v_freie_plaetze := nvl(v_freie_plaetze, 0) + v_lgr.lgr_max_te;
                v_freie_plaetze_typ := v_freie_plaetze_typ + v_lgr.lgr_max_te;
                v_lgr_platz_grp := nvl(v_lgr_platz_grp, '')
                                   || v_lgr.lgr_platz_gruppe
                                   || ';';
            end loop;

            close c_vorb_lgr_plaetze;
            if v_freie_plaetze_typ = 0 then
                v_err_nr := 10;
                v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_tpy_art_err,
                                       nvl(v_lte_typen, '????'),
                                       v_lte_name);
        -- v_err_text := 'Fehler: Es sind noch Transporte für diese Tour eingetragen, die nicht gelöscht werden konnten. Bitte Transporte prüfen und nochmals versuchen.';
                raise v_error;
                close c_order_lte_anz;
            end if;

        end loop;

        close c_order_lte_anz;
        dbms_output.put_line('lGR-Plaetze=' || v_lgr_platz_grp);
        return ( v_lgr_platz_grp );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end tour_tour_vl;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Suchen nach Lagerplätzen für die VorabOptimierung suchen und Verladevorb. Starten
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure tour_vorb_start (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type,
        in_user_id  in isi_user.login_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr        number;
        v_err_text      varchar2(2056);
        v_pos           isi_order_pos%rowtype;                    -- Positionsdaten
        v_lte           lvs_lte%rowtype;
        v_lte_id        lvs_lte.lte_id%type;
        v_lgr_wa        lvs_lgr%rowtype;           -- Lager WA

        v_found         boolean;                   -- Dummy Var für gefunden im CURSOR
        v_order_kopf    isi_order_kopf%rowtype;
        v_lgr_platz_grp varchar2(4096);
        cursor c_lgr is
        select
            lgr.*
        from
            lvs_lgr lgr
        where
                lgr.sid = in_sid
            and lgr.firma_nr = in_firma_nr
            and lgr.lgr_platz = v_order_kopf.ziel;

    -- KONSI-Lager berücksichtigen
        cursor c_kopf is
        select
            kopf.*
        from
            isi_order_kopf kopf
        where
                kopf.sid = in_sid
            and kopf.firma_nr = in_firma_nr
            and kopf.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                  'LNK' )
            and kopf.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
            and kopf.vorgang_id = in_tour_nr
        order by
            kopf.vorgang_id desc,
            kopf.li_nr desc;

    begin
        v_err_nr := null;
        v_err_text := null;
        lvs_ausl.v_sperr_transport_gruppe := false;
        lvs_ausl.v_order_transport_gruppe := null;
        lvs_ausl.v_transport_gruppe := null;
        v_order_kopf := null;
        open c_kopf;
        fetch c_kopf into v_order_kopf;
        v_found := c_kopf%found;
        close c_kopf;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p2(lc.o_tp2_order_vorg_kopf_fehlt, in_tour_nr, '????');
      -- v_err_text := 'Fehler: Lieferschein/Tour <' || in_tour_nr || '> fehlt. ';
            raise v_error;
        end if;

        open c_lgr;
        fetch c_lgr into v_lgr_wa;
        v_found := c_lgr%found;
        close c_lgr;
        if not v_found then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, v_order_kopf.ziel);
      -- v_err_text := 'Fehler: Lagerplatz <' || v_order_kopf.ziel || '> fehlt. ';
            raise v_error;
        end if;

        v_lgr_platz_grp := tour_tour_vl(in_sid, in_firma_nr, in_tour_nr, v_order_kopf.ziel, v_lgr_wa);
        if v_lgr_platz_grp is null      -- Nichts zu tun oder Exeption in Funktion
         then
            v_err_nr := 25;
            v_err_text := lc.ec(lc.o_txt_order_auft_no_update);
            raise v_error;
        end if;

        tour_vorb_trans(in_sid,          -- in_sid         in isi_sid.sid%type,

         in_firma_nr,     -- in isi_firma.firma_nr%type,

         in_tour_nr,      -- in isi_order_kopf.vorgang_id%type,

         v_lgr_platz_grp, -- in_platz_grp   in varchar2,

         in_user_id,      -- in isi_user.login_id%type
                        v_order_kopf.lkw_nr);
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end tour_vorb_start;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function gibt die Anzahl der Res. LTE's für eine Tour zurück
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
    function tour_anz_res (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) return number is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2056);
        v_lte_anz  number;
        v_found    boolean;
        cursor c_order_lte_anz is
        select
            count(lte.order_vorgang_id)
        from
            lvs_lte     lte,
            lvs_lte_cfg cfg
        where
                lte.sid = in_sid
            and lte.order_vorgang_id = in_tour_nr
            and lte.sid = cfg.sid
            and lte.firma_nr = cfg.firma_nr
            and lte.lte_name = cfg.lte_name
        group by
            lte.order_vorgang_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        v_lte_anz := 0;
        open c_order_lte_anz;
        fetch c_order_lte_anz into v_lte_anz;
        close c_order_lte_anz;
        return ( v_lte_anz );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end tour_anz_res;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure meldet einen kompletten Lieferschein mit allen Positionen fertig,
  -- wenn keine offenen Positionen vorhanden sind
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_check_lief_fuer_lief_ende (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_vorgang_typ in isi_order_pos.vorgang_typ%type,
        in_lief_nr     in isi_order_kopf.li_nr%type,
        in_user_id     in isi_user.login_id%type,
        in_tour_nr     in isi_order_kopf.vorgang_id%type
    ) is

    ----------------------------------------------------------------------------
    -- Lokale Variablen
    ----------------------------------------------------------------------------
        v_found             boolean;                           -- Dummy Var für gefunden im CURSOR
        v_order_vorgang_id  isi_order_kopf.vorgang_id%type;
        v_order_vorgang_typ isi_order_kopf.vorgang_typ%type;
        v_order_satzart     isi_order_kopf.satzart%type;
        v_anz_pos           number; -- Anzahl der AUF_ID's diesen Vorgangs
        v_transporte        isi_transport%rowtype;
        cursor c_pos_anz is
        select
            count(auf_id)
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.vorgang_typ = in_vorgang_typ
            and pos.status != 'E'
            and pos.status != 'X'               -- Auch X ist fertig
            and ( pos.vorgang_id = in_tour_nr
                  or ( in_tour_nr is null
                       and pos.li_nr = in_lief_nr ) )
        group by
            pos.vorgang_typ,
            pos.vorgang_id;

        cursor c_order_kopf is
        select
            min(k.vorgang_typ),
            k.vorgang_id,
            k.satzart
        from
            isi_order_kopf k
        where
                k.sid = in_sid
            and k.firma_nr = in_firma_nr
            and ( k.vorgang_id = in_tour_nr
                  or ( in_tour_nr is null
                       and k.li_nr = in_lief_nr ) )
            and k.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                               'LNK' )
        group by
            k.vorgang_id,
            k.satzart;

        cursor c_transporte is
        select
            *
        from
            isi_transport tra
        where
                tra.sid = in_sid
            and tra.firma_nr = in_firma_nr
            and tra.vorgang_id = v_order_vorgang_id;

    begin
        begin
            open c_pos_anz; -- Offene Positionen Lesen
            fetch c_pos_anz into v_anz_pos;
            v_found := c_pos_anz%found; -- Keine offenen Positionen mehr
            close c_pos_anz;
            open c_order_kopf; -- Offene Kopf
            fetch c_order_kopf into
                v_order_vorgang_typ,
                v_order_vorgang_id,
                v_order_satzart;
            close c_order_kopf;
            if not v_found
            or v_anz_pos = 0 then
                update isi_order_kopf kopf
                set
                    kopf.status = 'X',
                    kopf.fertig_datum = sysdate
                where
                        kopf.sid = in_sid
                    and kopf.vorgang_typ = v_order_vorgang_typ
                    and kopf.vorgang_id = v_order_vorgang_id
                    and kopf.status != 'E';

                if isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,

                 v_order_satzart,          -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,

                 'TMS_ORD_AUTO_FERTIG',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                'TMS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                 'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                 'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                 'BOOLEAN') = c.c_true     -- in_default_param_typ
                                                 then
                    open c_transporte;
                    fetch c_transporte into v_transporte;
                    v_found := c_transporte%found;
                    close c_transporte;
                    if not v_found then
                        lief_ende(in_sid,         -- isi_sid.sid%type,
                         in_firma_nr,    -- isi_firma.firma_nr%type,
                         in_lief_nr,     -- isi_order_kopf.li_nr%type,
                         in_user_id,     -- isi_user.login_id%type,
                         in_tour_nr      -- isi_order_kopf.vorgang_id%type
                        );
                    end if;

                end if;

            end if;

            commit;
        exception
            when others then
                null; -- Order konnte nicht geschlossen werden, kein Fehler melden
        end;
    end c_check_lief_fuer_lief_ende;
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure meldet einen kompletten Lieferschein mit allen Positionen fertig
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_lief_ende (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lief_nr  in isi_order_kopf.li_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
    begin
        lief_ende(in_sid,         -- isi_sid.sid%type,
         in_firma_nr,    -- isi_firma.firma_nr%type,
         in_lief_nr,     -- isi_order_kopf.li_nr%type,
         in_user_id,     -- isi_user.login_id%type,
         in_tour_nr      -- isi_order_kopf.vorgang_id%type
        );
        commit;
    end c_lief_ende;
 --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure meldet einen kompletten Lieferschein mit allen Positionen fertig
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure lief_ende (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lief_nr  in isi_order_kopf.li_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_tour_nr  in isi_order_kopf.vorgang_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(255);
        v_found      boolean;                                -- Daten Gefunfen?
        v_result     number;
        v_order_pos  isi_order_pos%rowtype;
        v_transporte isi_transport%rowtype;

    -- KONSI-Lager berücksichtigen
        cursor c_order_pos is
        select
            *
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and pos.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                 'LNK' )
            and pos.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' )
         --and nvl(pos.status, 'F') != 'E'
            and ( pos.vorgang_id = in_tour_nr
                  or ( in_tour_nr is null
                       and pos.li_nr = in_lief_nr ) );

        cursor c_transporte is
        select
            *
        from
            isi_transport tra
        where
                tra.sid = in_sid
            and tra.firma_nr = in_firma_nr
            and tra.vorgang_id = v_order_pos.vorgang_id;

    begin
        v_err_nr := null;
        open c_order_pos;
        loop
            fetch c_order_pos into v_order_pos;
            exit when c_order_pos%notfound;
            if v_order_pos.freigegeben_datum is not null then
                open c_transporte;
                fetch c_transporte into v_transporte;
                v_found := c_transporte%found;
                close c_transporte;
                if v_found then
                    v_err_nr := 10;
                    v_err_text := lc.ec(lc.o_txt_order_m_trans_n_close);
          -- v_err_text := 'Es sind noch Transporte für diese Tour offen, Fertigmeldung nicht möglich';
                    raise v_error;
                end if;

            end if;

            if v_order_pos.li_extern != 'B' -- Bei Beistellung zur Bestellungen nur die noch offenen
            or v_order_pos.status != 'E'    -- wenn nicht geschlossen
             then
                lte_lief_ende(v_order_pos, in_user_id);
            end if;

            update isi_order_pos p
            set
                p.status = v_order_pos.status
            where
                    p.sid = in_sid
                and p.firma_nr = in_firma_nr
                and p.auf_id = v_order_pos.auf_id;

        end loop;

        close c_order_pos;

    -- KONSI-Lager berücksichtigen
        update isi_order_kopf k
        set
            k.status = 'E'
        where
                k.sid = in_sid
            and k.firma_nr = in_firma_nr
            and ( k.vorgang_id = in_tour_nr
                  or ( in_tour_nr is null
                       and k.li_nr = in_lief_nr ) )
            and k.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                               'LNK' );

        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_order_pos%isopen then
                close c_order_pos;
            end if;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_order_pos%isopen then
                close c_order_pos;
            end if;
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end lief_ende;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure meldet eine Lieferscheinposition fertig und bucht alle LTE's mit
  --           Status 'AF' als Ausgelagert. Falls noch LTE's mit AD (Dispo) im Lager
  --           sind, wird ein Fehler gerissen (Exeption)
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure lte_lief_ende (
        in_out_order_pos in out isi_order_pos%rowtype,
        in_user_id       in isi_user.login_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(255);
        v_lgr       lvs_lgr%rowtype;           -- Lagerplatzdaten
        v_liefs     isi_liefs%rowtype;         -- Lieferscheindaten
        v_lte       lvs_lte%rowtype;          --
        v_lam       lvs_lam%rowtype;           -- Lagerbestand Menge

        v_lgr_platz lvs_lgr.lgr_platz%type;    -- Lagerplatz für CURSOR
        v_found     boolean;                                -- Daten Gefunfen?
        v_result    number;                                 -- Result von Res_Rueck

        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_out_order_pos.sid
            and lte.firma_nr = in_out_order_pos.firma_nr
            and lte.order_auf_id = in_out_order_pos.auf_id;

        cursor c_liefs is
        select
            *
        from
            isi_liefs liefs
        where
                liefs.sid = in_out_order_pos.sid
            and liefs.firma_nr = firma_nr
            and liefs.lte_id = v_lte.lte_id
            and liefs.vorgang_id = v_lte.order_vorgang_id
            and liefs.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' );

        cursor c_lgr is                             -- Lesen des Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz = v_lgr_platz
            and lgr.sid = in_out_order_pos.sid;

    begin
        open c_lte;
        loop
            fetch c_lte into v_lte;
            v_found := c_lte%found;
            v_lgr_platz := v_lte.lgr_platz;
            if v_found then
                if v_lte.lte_status = c.lte_af_stat then
                    open c_liefs;
                    fetch c_liefs into v_liefs;
                    v_found := c_liefs%found;
                    close c_liefs;
                    if
                        v_found
                        and v_liefs.inaktiv_grund is null
                    then
                        open c_lgr;
                        fetch c_lgr into v_lgr;
                        v_found := c_lgr%found;
                        close c_lgr;
                        v_lam.artikel_id := null;
            -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
                        v_lam.lam_id := lvs_ausl.lvs_lam_abgang(in_out_order_pos.sid, in_out_order_pos.firma_nr, v_lam.artikel_id, v_lte.lte_id
                        , null,
                                                                in_out_order_pos.auftrag, null, sysdate, in_user_id, null,
                                                                null, null, null, null, null,
                                                                c.lam_bh_bus_abg, in_out_order_pos.vorgang_id, in_out_order_pos.li_nr
                                                                , in_out_order_pos.li_pos_nr);

                        if v_lam.lam_id <= 0 then
                            v_err_nr := 10;
                            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_gesp_ware_ausl,
                                                   nvl(v_lte.lte_id, 'NULL'));
              -- v_err_text := 'Fehler: Auf der Palette <' || nvl(v_lte.lte_id, 'NULL') || '> befindet sich gesperrte Ware! ';
                            raise v_error;
                        end if;

                        update lvs_lte lte
                        set
                            lte.lgr_platz = null,
                            lte.lgr_platz_gruppe = null,
                            lte.lgr_ort = null,
                            lte.ziel_lgr_ort = null,
                            lte.ziel_lgr_platz = null,
                            lte.ziel_lgr_ort_n_freif = null,
                            lte.ziel_lgr_platz_n_freif = null
                        where
                                lte.sid = in_out_order_pos.sid
                            and lte.lte_id = v_lte.lte_id;

                    end if;

                elsif v_lte.lte_status = c.lte_ad_stat then
                    close c_lte;
                    v_err_nr := 20;
                    v_err_text := lc.ec(lc.o_txt_tour_hat_noch_res);
          -- v_err_text := 'Es sind noch Transporteinheiten für diese Tour reserviert, Fertigmeldung nicht möglich';
                    raise v_error;
                else
                    v_result := lvs_ausl.lvs_lte_res_rueck(in_out_order_pos.sid, in_out_order_pos.firma_nr, in_out_order_pos.vorgang_id
                    , in_out_order_pos.auf_id, v_lte.lte_id,
                                                           in_out_order_pos.vorgang_id, v_lte.lgr_platz, c.c_true);
                end if;
            else
                exit;
            end if;

        end loop;

        close c_lte;
    -- Die Felder für das Schnittstelleschreiben verbiegen
        in_out_order_pos.status := 'E';
        if in_out_order_pos.li_extern = 'B' then
            in_out_order_pos.vorgang_typ := 'BLF';
        else
            in_out_order_pos.vorgang_typ := 'LIF';
        end if;

        v_lam.lte_id := null;
        v_lam.artikel_id := null;
        v_lam.charge_id := null;
        v_lam.sid := in_out_order_pos.sid;
        v_lam.firma_nr := in_out_order_pos.firma_nr;
        s_schnittstelle.write_host_bew(in_out_order_pos,             -- in_order_pos   in isi_order_pos%rowtype,
         v_lam,                        -- in_lam         in lvs_lam%rowtype,
         null,                         -- in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
         null,                         -- in_lam_bh_bus  in lvs_lam_bh.bus%type,
         null,                         -- in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                                       'S_AUF',                      -- in_tabelle     in varchar2,
                                        'UE',                         -- in_status      in s_send_bew.status%type,
                                        null,                         -- in_quell_lgr   in lvs_lgr%rowtype,
                                        null,                         -- in_ziel_lgr    in lvs_lgr%rowtype,
                                        null,                         -- in_login_id    in isi_user.login_id%type,
                                       in_out_order_pos.ist_menge);  -- in_menge       in number default NULL
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_lte%isopen then
                close c_lte;
            end if;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_lte%isopen then
                close c_lte;
            end if;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end lte_lief_ende;



  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure meldet einen komplette Bestellung mit allen Positionen fertig
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_best_ende (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_best_nr  in isi_order_kopf.li_nr%type,
        in_user_id  in isi_user.login_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(255);
        v_found      boolean;                                -- Daten Gefunfen?
        v_result     number;
        v_lam        lvs_lam%rowtype;           -- Lagerbestand Menge
        v_lgr_platz  lvs_lgr.lgr_platz%type;    -- Lagerplatz für CURSOR
        v_lgr        lvs_lgr%rowtype;           -- Lagerplatzdaten

        v_order_pos  isi_order_pos%rowtype;
        v_transporte isi_transport%rowtype;
        v_lte        lvs_lte%rowtype;          --

    -- KONSI-Bestellung mit berücksichtigen
        cursor c_order_pos is
        select
            *
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and ( ( pos.satzart = 'BE'
                    and pos.vorgang_typ = 'WEE' )
                  or ( pos.satzart = 'BK'                  -- KONSI-Bestellung
                       and pos.vorgang_typ = 'KWE' ) )
            and nvl(pos.status, 'N') != 'E'
            and pos.vorgang_id = in_best_nr;

    begin
        v_err_nr := null;
        open c_order_pos;
        loop
            fetch c_order_pos into v_order_pos;
            exit when c_order_pos%notfound;
      -- Die Felder für das Schnittstelleschreiben verbiegen
            v_order_pos.status := 'E';
            v_order_pos.vorgang_typ := 'BEF';
            v_lam.lte_id := null;
            v_lam.artikel_id := null;
            v_lam.charge_id := null;
            s_schnittstelle.write_host_bew(v_order_pos,             -- in_order_pos   in isi_order_pos%rowtype,
             v_lam,                   -- in_lam         in lvs_lam%rowtype,
             null,                    -- in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
             null,                    -- in_lam_bh_bus  in lvs_lam_bh.bus%type,
             null,                    -- in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                                           'S_AUF',                 -- in_tabelle     in varchar2,
                                            'UE',                    -- in_status      in s_send_bew.status%type,
                                            null,                    -- in_quell_lgr   in lvs_lgr%rowtype,
                                            null,                    -- in_ziel_lgr    in lvs_lgr%rowtype,
                                            null,                    -- in_login_id    in isi_user.login_id%type,
                                           v_order_pos.ist_menge);  -- in_menge       in number default NULL
            update isi_order_pos p
            set
                p.status = v_order_pos.status
            where
                    p.sid = in_sid
                and p.firma_nr = in_firma_nr
                and p.auf_id = v_order_pos.auf_id;

        end loop;

        close c_order_pos;

    -- KONSI-Bestellung mit berücksichtigen
        update isi_order_kopf k
        set
            k.status = 'E'
        where
                k.sid = in_sid
            and k.firma_nr = in_firma_nr
            and k.vorgang_id = in_best_nr
            and ( k.satzart = 'BE'
                  or k.satzart = 'BK' );      -- KONSI-Bestellung
        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            if c_order_pos%isopen then
                close c_order_pos;
            end if;
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if c_order_pos%isopen then
                close c_order_pos;
            end if;
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end c_best_ende;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure Prüft, ob alle LAM's der LTE in dieser Order reserviert sind, wenn nicht dann exception
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure pruefe_lte_kompl_in_order (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_vorgang  in isi_order_kopf.vorgang_id%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(255);
        v_found     boolean;                                -- Daten Gefunfen?
        v_lam       lvs_lam%rowtype;           -- Lagerbestand Menge

        v_order_pos isi_order_pos%rowtype;
        cursor c_lam is
        select
            *
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.lte_id = in_lte_id
            and lam.lgr_platz is not null
            and lam.menge > 0;

    -- KONSI-Lager berücksichtigen
        cursor c_order_pos is
        select
            *
        from
            isi_order_pos pos
        where
                pos.sid = in_sid
            and pos.firma_nr = in_firma_nr
            and ( ( pos.satzart in ( 'LI', 'RL', 'LK', 'MAK', 'LAK',
                                     'LNK' )
                    and pos.vorgang_typ in ( 'WAE', 'KWA', 'WAI', 'WUI' ) )
                  or ( pos.satzart = 'MA'
                       and pos.vorgang_typ = 'WAI' ) )
            and pos.vorgang_id = in_vorgang;

    begin
        v_err_nr := null;
        if in_vorgang is null then
            return;
        end if;
        open c_lam;
        loop
            fetch c_lam into v_lam;
            exit when c_lam%notfound;
            if v_lam.order_pos_auf_id is null then
                v_err_nr := 10;
                v_err_text := lc.ec(lc.o_txt_lte_hat_noch_lhm_o_res);
        -- v_err_text := 'Es ist Ware auf der LTE, die für keien Auftrag Reserviert wurde. Diese Ware muss erst abpackt werden. ';
                exit;
            end if;

            v_found := false;
            open c_order_pos;
            loop
                fetch c_order_pos into v_order_pos;
                exit when c_order_pos%notfound;
                if v_order_pos.auf_id = v_lam.order_pos_auf_id then
                    v_found := true;
                    exit;
                end if;

            end loop;

            close c_order_pos;
            if not v_found then
                v_err_nr := 20;
                v_err_text := lc.ec(lc.o_txt_lte_hat_noch_lhm_f_res);
        -- v_err_text := 'Es befindet sich Ware auf der LTE, die nicht zu diesem Auftrag gehört. Diese muss vor der Verladung erst abpackt werden. ';
                exit;
            end if;

        end loop;

        close c_lam;
        if v_err_nr is not null then
            raise v_error;
        end if;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end pruefe_lte_kompl_in_order;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function dupliziert eine komplette Bestellung mit allen Positionen
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_duplicate_best (
        in_sid             in isi_sid.sid%type,
        in_firma_nr        in isi_firma.firma_nr%type,
        in_vorgang_id      in isi_order_kopf.vorgang_id%type,
        in_vorgang_typ     in isi_order_kopf.vorgang_typ%type,
        in_satzart         in isi_order_kopf.satzart%type,
        in_user_id         in isi_user.login_id%type,
        in_arbeitsplatz_id in isi_arbeitsplatz.arbeitsplatz_id%type,
        out_vorgang_id     out isi_order_kopf.vorgang_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(255);
    -------------------------------------------------------------------------------------------------------

        v_order_kopf_row isi_order_kopf%rowtype;
        cursor c_order_kopf is
        select
            ok.*
        from
            isi_order_kopf ok
        where
                ok.sid = in_sid
            and ok.firma_nr = in_firma_nr
            and ok.vorgang_typ = in_vorgang_typ
            and ok.vorgang_id = in_vorgang_id
            and ok.satzart = in_satzart;

    begin
        v_err_nr := null;
        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf_row;
        if c_order_kopf%found then
            if v_order_kopf_row.liefer_datum < trunc(sysdate) then
                v_order_kopf_row.liefer_datum := null;
            end if;

            insert into isi_order_kopf values ( v_order_kopf_row.sid,
                                                v_order_kopf_row.firma_nr,
                                                v_order_kopf_row.vorgang_typ,
                                                null, -- vorgang_id (wird im trigger gesetzt)
                                                v_order_kopf_row.li_nr,
                                                v_order_kopf_row.be_nr,
                                                v_order_kopf_row.satzart,
                                                v_order_kopf_row.adress_id,
                                                v_order_kopf_row.order_adress_id,
                                                in_user_id,
                                                in_arbeitsplatz_id,
                                                v_order_kopf_row.strategie,
                                                v_order_kopf_row.order_info,
                                                null, -- status
                                                v_order_kopf_row.quell_lagerorte,
                                                v_order_kopf_row.quelle,
                                                v_order_kopf_row.ziel,
                                                v_order_kopf_row.wae_ziel,
                                                v_order_kopf_row.besteller,
                                                v_order_kopf_row.freigabe,
                                                null, --freigabe_datum,
                                                null, --freigegeben_datum,
                                                null, --order_datum, (wird im trigger gesetzt)
                                                v_order_kopf_row.liefer_datum,
                                                null, --fertig_datum,
                                                v_order_kopf_row.lvs_info,
                                                v_order_kopf_row.prioritaet,
                                                v_order_kopf_row.anbruch,
                                                v_order_kopf_row.ohne_transport,
                                                v_order_kopf_row.ohne_transp_anz,
                                                v_order_kopf_row.lkw_nr,
                                                v_order_kopf_row.transport_gruppe,
                                                null,
                                                null,
                                                v_order_kopf_row.sp_adress_id,
                                                null,  -- Zeit muss dann neu berechnet werden da Status Neu KOMM_ZEIT_SEC N NUMBER  Y     Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für diese Pos
                                                null,  -- Zeit muss dann neu berechnet werden da Status Neu TRANSP_ZEIT_SEC N NUMBER  Y     Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.
                                                null )  -- Zeit muss dann neu berechnet werden da Status Neu STARTZEITPUNKT_BERECHNET  N DATE  Y     Berechneter Startzeitpunkt für diese Position
                                                 returning vorgang_id into out_vorgang_id;

            if out_vorgang_id is not null then
                begin
                    insert into isi_order_tour
                        select
                            out_vorgang_id,
                            t.tour,
                            t.pack_lgr_platz,  -- PACK_LGR_PLATZ N VARCHAR2(30)  Y     Reservierter Packplatz nachdem er zugeordnet wurde
                            null,              -- KOMM_ZEIT_SEC  N NUMBER  Y     Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für alle Positionen
                            null,              -- TRANSP_ZEIT_SEC  N NUMBER  Y     Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.
                            null               -- STARTZEITPUNKT_BERECHNET N DATE  Y     Berechneter Startzeitpunkt für die erste Posion dieser Klammer
                        from
                            isi_order_tour t
                        where
                            t.vorgang_id = v_order_kopf_row.vorgang_id;

                exception
                    when others then
                        null;    -- Jeglichen Fehler ignorieren
                end;

                insert into isi_order_pos
                    select
                        op.sid,
                        op.firma_nr,
                        null, -- auf_id
                        null, -- auf_id_extern
                        op.vorgang_typ,
                        out_vorgang_id,
                        min(op.vorgang_pos),
                        op.transport_gruppe,
                        op.satzart,
                        op.auftrag,
                        min(op.pos_nr),
                        min(op.upos_nr),
                        op.artikel_id,
                        'F', -- ware_disponiert
                        in_user_id,
                        in_arbeitsplatz_id,
                        op.leitzahl,
                        op.fa_ag,
                        min(op.fa_upos),
                        op.charge_id,
                        op.seriennr_id,
                        v_order_kopf_row.strategie, --strategie, aus Kopf
                        min(op.mhd),
                        min(op.li_extern),
                        min(op.li_nr),
                        min(op.li_pos_nr),
                        null, -- order_info
                        sum(op.soll_menge),
                        0, -- ist_menge
                        min(op.menge_basis),
                        min(op.mengeneinheit),
                        null, -- status
                        min(op.quell_lagerorte),
                        v_order_kopf_row.quelle, --op.quelle, aus Kopf
                        v_order_kopf_row.ziel, --op.ziel, aus Kopf
                        v_order_kopf_row.wae_ziel, --op.wae_ziel, aus Kopf
                        v_order_kopf_row.besteller, --op.besteller, aus Kopf (ISI)
                        v_order_kopf_row.freigabe, --op.freigabe, aus Kopf
                        null, -- freigabe_datum,
                        null, -- freigegeben_datum,
                        null, -- order_datum, (wird im trigger gesetzt)
                        v_order_kopf_row.liefer_datum, --op.liefer_datum, aus Kopf
                        null, -- fertig_datum,
                        null, -- lvs_info,
                        min(op.prioritaet),
                        v_order_kopf_row.anbruch, --op.anbruch, aus Kopf
                        min(op.min_mhd_tage),
                        max(op.min_reifezeit),
                        sum(op.brutto_kg),
                        min(op.best_nr_kunde),
                        min(op.wa_menge_ueberlief),
                        min(op.zeichnung_index),
                        op.lam_sel1,
                        op.lam_sel2,
                        op.lam_sel3,
                        op.lam_sel4,
                        op.lam_sel5,
                        op.lam_sel6,
                        op.lam_sel7,
                        op.lam_sel8,
                        op.lam_sel9,
                        op.lam_sel10,
                        sum(op.kom_mg),
                        op.kom_mengeneinheit,
                        min(op.kom_lgr_orte),
                        op.labor_status,
                        op.ziel_packschema_kopf_id,
                        op.ziel_lte_name,
                        op.ziel_lhm_name,
                        op.komplett_reservieren,
                        op.komplett_bereitstellen,
                        op.auto_depal,
                        op.ziel_lhm_menge,
                        op.komm_vorgabe_auto_depal,
                        null,  -- Zeit muss dann neu berechnet werden da Status Neu KOMM_ZEIT_SEC  N NUMBER  Y     Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für diese Pos
                        null,  -- Zeit muss dann neu berechnet werden da Status Neu TRANSP_ZEIT_SEC  N NUMBER  Y     Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.
                        null,   -- Zeit muss dann neu berechnet werden da Status Neu STARTZEITPUNKT_BERECHNET  N DATE  Y     Berechneter Startzeitpunkt für diese Position
                        op.prod_params
                    from
                        isi_order_pos op
                    where
                            op.sid = in_sid
                        and op.firma_nr = in_firma_nr
                        and op.vorgang_typ = in_vorgang_typ
                        and op.vorgang_id = in_vorgang_id
                        and op.satzart = in_satzart
                    group by
                        op.sid,
                        op.firma_nr,
                        op.vorgang_typ,
                        op.transport_gruppe,
                        op.satzart,
                        op.auftrag,
                        op.artikel_id,
                        op.leitzahl,
                        op.fa_ag,
                        op.charge_id,
                        op.seriennr_id,
                        op.lam_sel1,
                        op.lam_sel2,
                        op.lam_sel3,
                        op.lam_sel4,
                        op.lam_sel5,
                        op.lam_sel6,
                        op.lam_sel7,
                        op.lam_sel8,
                        op.lam_sel9,
                        op.lam_sel10,
                        op.kom_mengeneinheit,
                        op.labor_status,
                        op.auto_depal,
                        op.ziel_lhm_menge,
                        op.komm_vorgabe_auto_depal;

            end if;

            commit;
        end if;

        close c_order_kopf;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt
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

    procedure teilmg_transport_begonnen (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_transp_id in isi_transport.transp_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(255);
    -------------------------------------------------------------------------------------------------------

        v_transport      isi_transport%rowtype;
        v_order          isi_order_pos%rowtype;
        v_order_auf_id   isi_order_pos.auf_id%type;
        v_transp_menge   number;
        v_transp_z_index lvs_lam.zeichnung_index%type;
        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.transp_id = in_transp_id;

        cursor c_order is
        select
            *
        from
            isi_order_pos t
        where
                t.sid = v_transport.sid
            and t.firma_nr = v_transport.firma_nr
            and t.auf_id = v_order_auf_id;

        cursor c_transport_mengen is
        select
            t.order_pos_auf_id,
            sum(t.menge),
            min(t.zeichnung_index)
        from
            lvs_lam t
        where
                t.sid = v_transport.sid
            and t.firma_nr = v_transport.firma_nr
            and t.lte_id = v_transport.lte_id
            and t.order_pos_auf_id is not null
        group by
            t.order_pos_auf_id;

        v_found          boolean;
    begin
        open c_transport;
        fetch c_transport into v_transport;
        v_found := c_transport%found;
        close c_transport;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt,
                                   nvl(
                                                to_char(in_transp_id),
                                                '(NULL)'
                                            ));
      -- v_err_text := 'Transport ID ' || nvl(to_char(in_transp_id), '(NULL)') || ' konnte nicht gefunden werden.';
            raise v_error;
        end if;

        open c_transport_mengen;
        loop
            fetch c_transport_mengen into
                v_order_auf_id,
                v_transp_menge,
                v_transp_z_index;
            exit when c_transport_mengen%notfound;
            open c_order;
            fetch c_order into v_order;
            v_found := c_order%found;
            close c_order;
            if not v_found then
                v_err_nr := 10;
                v_err_text := lc.ec_p1(lc.o_tp1_order_auf_id_fehlt,
                                       nvl(
                                                        to_char(v_transport.auf_id),
                                                        '(NULL)'
                                                    ));
        -- v_err_text := 'Ordernummer ' || nvl(to_char(v_transport.auf_id), '(NULL)') || ' konnte nicht gefunden werden.';
                raise v_error;
            end if;

            v_order.status := 'T';
            v_order.freigegeben_datum := sysdate;
            update isi_order_pos t
            set
                t.status = v_order.status,
                t.freigegeben_datum = v_order.freigegeben_datum
            where
                    t.sid = v_order.sid
                and t.firma_nr = v_order.firma_nr
                and t.auf_id = v_order.auf_id;

            if
                v_order.vorgang_typ = 'WAI'
                and v_order.satzart = 'MA'
            then
        -- Bei Materialanforderungen müssen noch weitere Felder aktualisiert werden.
        -- -WK- derzeit für Huf umgesetzt, für einsatz bei anderen Kunden muss die Logik noch überprüft werden
        -- lvs_info wird benutzt, um anzuzeigen, welcher index geliefert wurde und von welchem Lagerort
                v_order.lvs_info := nvl(v_transp_z_index, '0000')
                                    || ', '
                                    || nvl(
                    to_char(v_transport.lgr_ort_quelle),
                    '--'
                );

                update isi_order_pos t
                set
                    t.lvs_info = v_order.lvs_info
                where
                        t.sid = v_order.sid
                    and t.firma_nr = v_order.firma_nr
                    and t.auf_id = v_order.auf_id;

        -- den selben Status auch im Order-Kopf übernehmen
                update isi_order_kopf ok
                set
                    ok.status = v_order.status,
                    ok.freigegeben_datum = v_order.freigegeben_datum
                where
                        ok.sid = v_order.sid
                    and ok.vorgang_id = v_order.vorgang_id
                    and ok.vorgang_typ = v_order.vorgang_typ
                    and ok.satzart = v_order.satzart;

        -- Prüfen, ob die Bestellung komplett oder nur teilweise erfüllt wurde
                rest_mg_wai_ma_pruefen_rt(in_sid, in_firma_nr, v_order);
            end if;

        end loop;

        close c_transport_mengen;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt
        when v_error then
            rollback;
            if c_transport_mengen%isopen then
                close c_transport_mengen;
            end if;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if c_transport_mengen%isopen then
                close c_transport_mengen;
            end if;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

    procedure rest_mg_wai_ma_pruefen (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_auf_id   in isi_order_pos.auf_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
    -------------------------------------------------------------------------------------------------------

        v_order    isi_order_pos%rowtype;
        cursor c_order is
        select
            *
        from
            isi_order_pos t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.auf_id = in_auf_id;

        v_found    boolean;
    begin
        open c_order;
        fetch c_order into v_order;
        v_found := c_order%found;
        close c_order;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_order_auf_id_fehlt,
                                   nvl(
                                                to_char(in_auf_id),
                                                '(NULL)'
                                            ));
      -- v_err_text := 'Ordernummer ' || nvl(to_char(in_auf_id), '(NULL)') || ' konnte nicht gefunden werden.';
            raise v_error;
        end if;

        rest_mg_wai_ma_pruefen_rt(in_sid, in_firma_nr, v_order);
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt
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

  -- rt = rowtype (von order pos)
    procedure rest_mg_wai_ma_pruefen_rt (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_order_pos in isi_order_pos%rowtype
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr             number;
        v_err_text           varchar2(255);
    -------------------------------------------------------------------------------------------------------

        v_order_id_restmenge isi_order_pos.auf_id%type;
        cursor c_order_restmenge is
        select
            t.auf_id
        from
            isi_order_pos t
        where
                t.vorgang_id = in_order_pos.vorgang_id
            and t.status = 'N'
            and t.artikel_id = in_order_pos.artikel_id
            and t.fa_ag = in_order_pos.fa_ag
            and t.ziel = in_order_pos.ziel
            and t.login_id = in_order_pos.login_id;

        v_anz_ausl_dispos    number;
        cursor c_anz_auslager_dispos is
        select
            count(lam.lam_id)
        from
            lvs_lam lam,
            lvs_lte lte,
            lvs_lgr lgr
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.order_pos_auf_id = in_order_pos.auf_id
            and lte.sid = lam.sid
            and lte.firma_nr = lam.firma_nr
            and lte.lte_id = lam.lte_id
            and lte.lte_status = c.lte_lf_stat
            and lte.sid = lgr.sid
            and lte.firma_nr = lgr.firma_nr
            and lte.lgr_platz = lgr.lgr_platz
            and ( lgr.lgr_verwendung = c.lgr_typ_lager
                  or lgr.lgr_verwendung = c.lgr_typ_lagerp );

        v_sum_transp_menge   number;
        v_transp_zindex      lvs_lam.zeichnung_index%type;
        cursor c_transport_mengen is
        select
            sum(lam.menge)
        from
            lvs_lam       lam,
            isi_transport t
        where
                lam.sid = in_order_pos.sid
            and lam.firma_nr = in_order_pos.firma_nr
            and lam.order_pos_auf_id = in_order_pos.auf_id
            and lam.lte_id = t.lte_id;

        v_found              boolean;
    begin
    -- Anzahl Auslagerdisponierungen für diese Order
        open c_anz_auslager_dispos;
        fetch c_anz_auslager_dispos into v_anz_ausl_dispos;
        if c_anz_auslager_dispos%notfound then
            v_anz_ausl_dispos := 0;
        end if;
        close c_anz_auslager_dispos;

    -- Summe der Auslagermengen für diese Order, die im Transport sind
        open c_transport_mengen;
        fetch c_transport_mengen into v_sum_transp_menge;
        if c_transport_mengen%notfound then
            v_sum_transp_menge := 0;
        end if;
        close c_transport_mengen;
        if
            ( nvl(v_anz_ausl_dispos, 0) = 0 )
            and ( nvl(v_sum_transp_menge, 0) = 0 )
            and ( nvl(in_order_pos.ist_menge, 0) = 0 )
       --and nvl(v_order.order_durchlagerung, 'N') = 'N'
        then
      -- Es liegen keine Disponierungen und auch keine Aufträge vor
      -- Deshalb muß der Order-Status wieder auf 'Neu' gesetzt werden.
      -- Ist für löschen von reservierungen erforderlich

            if in_order_pos.status in ( 'T', 'A', 'F', 'D', 'R' ) then
                update isi_order_pos t
                set
                    t.status = 'N',
                    t.freigegeben_datum = null
                where
                        t.sid = in_order_pos.sid
                    and t.firma_nr = in_order_pos.firma_nr
                    and t.auf_id = in_order_pos.auf_id;

                update isi_order_kopf ok
                set
                    ok.status = 'N'
                where
                        ok.sid = in_order_pos.sid
                    and ok.vorgang_id = in_order_pos.vorgang_id
                    and ok.li_nr = in_order_pos.li_nr
                    and ok.vorgang_typ = in_order_pos.vorgang_typ
                    and ok.satzart = in_order_pos.satzart;

            end if;
        elsif
            ( in_order_pos.ist_menge + v_sum_transp_menge ) < in_order_pos.soll_menge
            and ( in_order_pos.ist_menge + v_sum_transp_menge ) > 0
        then
      -- Diese Order wurde nur Teilweise erfüllt
            if nvl(v_anz_ausl_dispos, 0) = 0 then
        -- Es liegen auch keine Disponierungen vor, aus denen die
        -- Erfüllung dieser Order hervor gehen könnte
        -- Also: Restmenge in einer neuen Order bestellen

                open c_order_restmenge;
                fetch c_order_restmenge into v_order_id_restmenge;
                v_found := c_order_restmenge%found;
                close c_order_restmenge;
                if not v_found then
          -- NUR neu anlegen, wenn nicht sowieso schon eine offene Restmengen-Order vorliegt

                    v_transp_zindex := in_order_pos.zeichnung_index;
                    if not lvs_p_base.lagerbestand_vorhanden(in_order_pos.sid, in_order_pos.firma_nr, in_order_pos.artikel_id, in_order_pos.leitzahl
                    , in_order_pos.fa_ag,
                                                             in_order_pos.zeichnung_index, null) then
            -- von dem gewünschten Zeichnungsindex ist kein Bestand mehr vorhanden
            -- also soll die Resmenge ohne Zeichnungsindex angelegt werden.
                        v_transp_zindex := null;
                    end if;

                    insert into isi_order_pos values ( in_order_pos.sid, -- sid,
                                                       in_order_pos.firma_nr, -- firma_nr,
                                                       null, -- auf_id,
                                                       null, -- auf_id_extern,
                                                       in_order_pos.vorgang_typ, -- vorgang_typ,
                                                       in_order_pos.vorgang_id, -- vorgang_id,
                                                       null, -- vorgang_pos,
                                                       in_order_pos.transport_gruppe, -- transport_gruppe,
                                                       in_order_pos.satzart, -- satzart,
                                                       null, -- auftrag,
                                                       null, -- pos_nr,
                                                       null, -- upos_nr,
                                                       in_order_pos.artikel_id, -- artikel_id,
                                                       'F', -- ware_disponiert,
                                                       in_order_pos.login_id, -- login_id, (Besteller)
                                                       null, -- arbeitsplatz_id,
                                                       in_order_pos.leitzahl, -- leitzahl,
                                                       in_order_pos.fa_ag, -- fa_ag,
                                                       in_order_pos.fa_upos, -- fa_upos,
                                                       in_order_pos.charge_id, -- charge_id,
                                                       in_order_pos.seriennr_id, -- seriennr_id,
                                                       in_order_pos.strategie, -- strategie,
                                                       in_order_pos.mhd, -- mhd,
                                                       in_order_pos.li_extern, -- li_extern,
                                                       in_order_pos.li_nr, -- li_nr,
                                                       in_order_pos.li_pos_nr, -- li_pos_nr,
                                                       in_order_pos.order_info, -- order_info,
                                                       in_order_pos.soll_menge - ( in_order_pos.ist_menge + v_sum_transp_menge ), -- soll_menge,
                                                       0, -- ist_menge,
                                                       in_order_pos.menge_basis, -- menge_basis,
                                                       in_order_pos.mengeneinheit, -- mengeneinheit,
                                                       null, -- status,
                                                       in_order_pos.quell_lagerorte, -- quell_lagerorte,
                                                       null, -- quelle,
                                                       in_order_pos.ziel, -- ziel,
                                                       in_order_pos.wae_ziel, -- wae_ziel,
                                                       in_order_pos.besteller, -- besteller,
                                                       in_order_pos.freigabe, -- freigabe,
                                                       null, -- freigabe_datum,
                                                       null, -- freigegeben_datum,
                                                       in_order_pos.order_datum, -- order_datum,
                                                       in_order_pos.liefer_datum, -- liefer_datum, (wuschdatum)
                                                       null, -- fertig_datum,
                                                       null, -- lvs_info,
                                                       in_order_pos.prioritaet, -- prioritaet,
                                                       in_order_pos.anbruch, -- anbruch,
                                                       in_order_pos.min_mhd_tage, -- min_mhd_tage,
                                                       in_order_pos.min_reifezeit, -- min_reifezeit,
                                                       in_order_pos.brutto_kg, -- brutto_kg,
                                                       in_order_pos.best_nr_kunde, -- best_nr_kunde
                                                       in_order_pos.wa_menge_ueberlief, -- WA_MENGE_UEBERLIEF
                                                       v_transp_zindex,                 -- zeichnung_index
                                                       in_order_pos.lam_sel1,
                                                       in_order_pos.lam_sel2,
                                                       in_order_pos.lam_sel3,
                                                       in_order_pos.lam_sel4,
                                                       in_order_pos.lam_sel5,
                                                       in_order_pos.lam_sel6,
                                                       in_order_pos.lam_sel7,
                                                       in_order_pos.lam_sel8,
                                                       in_order_pos.lam_sel9,
                                                       in_order_pos.lam_sel10,
                                                       in_order_pos.kom_mg,
                                                       in_order_pos.kom_mengeneinheit,
                                                       in_order_pos.kom_lgr_orte,
                                                       in_order_pos.labor_status,
                                                       in_order_pos.ziel_packschema_kopf_id,
                                                       in_order_pos.ziel_lte_name,
                                                       in_order_pos.ziel_lhm_name,
                                                       in_order_pos.komplett_bereitstellen,
                                                       in_order_pos.komplett_bereitstellen,
                                                       in_order_pos.auto_depal,
                                                       in_order_pos.ziel_lhm_menge,
                                                       in_order_pos.komm_vorgabe_auto_depal,
                                                       null,  -- Zeit muss dann neu berechnet werden da Status Neu KOMM_ZEIT_SEC  N NUMBER  Y     Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für diese Pos
                                                       null,  -- Zeit muss dann neu berechnet werden da Status Neu TRANSP_ZEIT_SEC  N NUMBER  Y     Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.
                                                       null,   -- Zeit muss dann neu berechnet werden da Status Neu STARTZEITPUNKT_BERECHNET  N DATE  Y     Berechneter Startzeitpunkt für diese Position
                                                       in_order_pos.prod_params );

          --soll_menge an ist_menge anpassen, da aus der Restmenge eine neue bestellung entsteht
                    update isi_order_pos op
                    set
                        op.soll_menge = ( op.ist_menge + v_sum_transp_menge )
                    where
                            op.sid = in_order_pos.sid
                        and op.firma_nr = in_order_pos.firma_nr
                        and op.auf_id = in_order_pos.auf_id;

          -- Da es eine neue Bestellung in einer Position gibt, kann der Status im Kopf auf neu gesetzt werden
                    update isi_order_kopf ok
                    set
                        ok.status = 'N'
                    where
                            ok.sid = in_order_pos.sid
                        and ok.vorgang_id = in_order_pos.vorgang_id
                        and ok.li_nr = in_order_pos.li_nr
                        and ok.vorgang_typ = in_order_pos.vorgang_typ
                        and ok.satzart = in_order_pos.satzart;

                end if;

            end if;
        end if;

    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt
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

    procedure man_lvs_wai_ma_order (
        io_order_pos in out isi_order_pos%rowtype
    ) is

        v_artikel isi_artikel%rowtype;
        cursor c_artikel is
        select
            a.*
        from
            isi_artikel a
        where
                a.sid = io_order_pos.sid
            and a.artikel_id = io_order_pos.artikel_id;

        v_found   boolean;
    begin
        open c_artikel;
        fetch c_artikel into v_artikel;
        v_found := c_artikel%found;
        close c_artikel;
        if not v_found then
      -- TODO: raise ...
            null;
        end if;
        io_order_pos.auf_id := null;
        io_order_pos.vorgang_typ := 'WAI';
        io_order_pos.satzart := 'MA';
        io_order_pos.menge_basis := v_artikel.menge_basis;
        io_order_pos.mengeneinheit := v_artikel.mengeneinheit;
        io_order_pos.ware_disponiert := c.c_false;
        io_order_pos.freigabe := 'M';
        io_order_pos.freigabe_datum := null;
        io_order_pos.order_datum := sysdate;
        io_order_pos.liefer_datum := io_order_pos.order_datum;
        insert into isi_order_kopf values ( io_order_pos.sid,
                                            io_order_pos.firma_nr,
                                            io_order_pos.vorgang_typ,
                                            null, -- vorgang_id
                                            null, -- li_nr
                                            null, -- be_nr
                                            io_order_pos.satzart,
                                            null, -- adress_id
                                            null, -- order_adress_id
                                            io_order_pos.login_id,
                                            io_order_pos.arbeitsplatz_id,
                                            io_order_pos.strategie,
                                            null, -- order_info
                                            io_order_pos.status,
                                            io_order_pos.quell_lagerorte,
                                            io_order_pos.quelle,
                                            io_order_pos.ziel,
                                            io_order_pos.wae_ziel,
                                            io_order_pos.besteller,
                                            io_order_pos.freigabe,
                                            io_order_pos.freigabe_datum,
                                            io_order_pos.freigegeben_datum,
                                            io_order_pos.order_datum,
                                            io_order_pos.liefer_datum,
                                            io_order_pos.fertig_datum,
                                            null, -- LVS Info
                                            io_order_pos.prioritaet,
                                            io_order_pos.anbruch,
                                            'F', -- ohne_transport
                                            0, -- ohne_transp_anz
                                            null, -- lkw_nr
                                            io_order_pos.transport_gruppe,
                                            null,
                                            null,
                                            null,
                                            null,  -- Zeit muss dann neu berechnet werden  KOMM_ZEIT_SEC N NUMBER  Y     Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für diese Pos
                                            null,  -- Zeit muss dann neu berechnet werden  TRANSP_ZEIT_SEC N NUMBER  Y     Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.
                                            null   -- Zeit muss dann neu berechnet werden  STARTZEITPUNKT_BERECHNET  N DATE  Y     Berechneter Startzeitpunkt für diese Position
                                             ) returning vorgang_id,
                                                             li_nr into io_order_pos.vorgang_id, io_order_pos.li_nr;

        insert into isi_order_pos values io_order_pos returning auf_id into io_order_pos.auf_id;

    end;

    function get_lgr_orte_vorbereitung (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_vorgang_id     in isi_order_kopf.vorgang_typ%type,
        in_transport_ziel in lvs_lgr.lgr_platz%type
    ) return varchar2 is

        v_z_platz              lvs_lgr%rowtype;
        v_lvs_lgr_ort_ue_platz lvs_lgr_ort_ue_platz%rowtype;
        v_ort_o_weg            lvs_lgr_ort.lgr_ort%type;
        v_q_ort                lvs_lgr_ort.lgr_ort%type;
        v_q_orte               lvs_lgr_ort.verl_vorb_lgr_orte%type;
        v_akt_ort              lvs_lgr_ort.lgr_ort%type;
        v_akt_orte             lvs_lgr_ort.verl_vorb_lgr_orte%type;
        v_last_orte            lvs_lgr_ort.verl_vorb_lgr_orte%type;
        v_neue_orte            lvs_lgr_ort.verl_vorb_lgr_orte%type;
        v_lte_name             lvs_lte.lte_name%type;
        v_start_pos            number;
        v_ende_pos             number;
        v_found                boolean;

    -- AG 20170814 Übergabeplatz ggf. nur fuer bestimmte Palettentypen
        cursor c_lvs_lgr_ort_ue_platz is
        select
            *
        from
            lvs_lgr_ort_ue_platz t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort_quelle = v_akt_ort
            and t.lgr_ort_ziel = v_z_platz.lgr_ort
            and ( t.lte_name = v_lte_name
                  or ( v_lte_name is null
                       and t.lte_name is null )
                  or t.lte_name is null )
        order by
            nvl(t.lte_name, v_lte_name || 'X');

        cursor c_order_lte_orte is
        select
            lo.verl_vorb_lgr_orte,
            lo.lgr_ort,
            decode(
                min(lte.lte_name),
                max(lte.lte_name),
                min(lte.lte_name),
                null
            )
        from
            lvs_lte     lte,
            lvs_lgr_ort lo
        where
                lte.sid = in_sid
            and lte.order_vorgang_id = in_vorgang_id
            and lte.sid = lo.sid
            and lte.firma_nr = lo.firma_nr
            and lte.lgr_ort = lo.lgr_ort
        group by
            lo.lgr_ort,
            lo.verl_vorb_lgr_orte;

    begin
        if not lvs_p_base.get_lgr_platz(in_transport_ziel, v_z_platz) then
            v_err_nr := 5;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, in_transport_ziel);
            raise_application_error(-20000 - v_err_nr, v_err_text);
        end if;

        open c_order_lte_orte;
        loop
            fetch c_order_lte_orte into
                v_akt_orte,
                v_q_ort,
                v_lte_name;
            exit when c_order_lte_orte%notfound;
            v_q_orte := nvl(v_q_orte, '')
                        || to_char(v_q_ort)
                        || ';';

            if v_akt_orte is null then
                v_akt_orte := v_q_orte;
            end if;
            v_neue_orte := v_last_orte;
            v_start_pos := 1;
            v_ende_pos := 1;
            while ( v_ende_pos > 0 ) loop
                v_ende_pos := instr(v_akt_orte, ';', v_start_pos, 1);
                v_akt_ort := substr(v_akt_orte, v_start_pos, v_ende_pos - v_start_pos);
                open c_lvs_lgr_ort_ue_platz;
                fetch c_lvs_lgr_ort_ue_platz into v_lvs_lgr_ort_ue_platz;
                v_found := c_lvs_lgr_ort_ue_platz%found;
                close c_lvs_lgr_ort_ue_platz;
                if
                    v_found
                    and v_lvs_lgr_ort_ue_platz.lgr_platz is null     -- Kein Weg
                then
                    v_ort_o_weg := v_akt_ort;
                else
                    if ( v_ende_pos > 0 ) then
                        if v_last_orte not like '%;'
                                                || substr(v_akt_orte, v_start_pos, v_ende_pos - v_start_pos)
                                                || ';%'
                           or v_last_orte not like substr(v_akt_orte, v_start_pos, v_ende_pos - v_start_pos)
                                                   || ';%'
                           or v_last_orte is null then
                            if v_neue_orte is null then
                                v_neue_orte := substr(v_akt_orte, v_start_pos, v_ende_pos - v_start_pos)
                                               || ';';
                            else
                                v_neue_orte := v_neue_orte
                                               || substr(v_akt_orte, v_start_pos, v_ende_pos - v_start_pos)
                                               || ';';
                            end if;

                        end if;

                    end if;
                end if;

                v_start_pos := v_ende_pos + 1;
            end loop;

            v_last_orte := v_neue_orte;
        end loop;

        close c_order_lte_orte;
        if v_last_orte is null then
            v_err_nr := 10;
            v_err_text := lc.ec_p2(lc.o_tp2_weg_von_nach_falsch,
                                   nvl(
                                                to_char(v_ort_o_weg),
                                                nvl(v_q_orte, '??')
                                            ),
                                   in_transport_ziel);

            raise_application_error(-20000 - v_err_nr, v_err_text);
        end if;

        return ( v_last_orte );
    end get_lgr_orte_vorbereitung;

    /*
  __________________________________________________
  Author    : CMe
  Created   : 15.07.2020 09:44:00
  __________________________________________________
  Description
  Die funktion prüft auf Basis der übergeben auf_id oder des zur LTe korrespondierende
  Fertigungsauftrages, ob eine VErladung für die übergebene LTE Id vorgesehen ist.

  Wenn Ja:
  Die Lte wird für die entsprechende Order reserviert. Im Anschluss werden
  abhängig von Status der Order unterschiedliche Aktionen ausgeführt:

  (N)eu: Lte wird in das Fertiglager transportiert. Der Status wird auf (D)isponiert
         umgeschaltet
  (D)isponiert: Die Lte wird in das Fertiglager transportiert
  (V)orbereiten: Lte wird auf den Puffer vor der Verladeposition gebracht
  (T)ransport: Lte wird in die Verladung transportiert (Puffer)

  Rückgabewert:
  1. Wenn eine Order gefunden und ein Transport erzeugt wurde --> True
  2. Wenn keine Order gefunden wurde oder ein Fehler auftritt --> False

  Prozessbeschreibung: https://portal.isi-automation.com:8443/x/UwDKCQ
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  13.07.2020   DB31_1      (-CMe-)  Funktion erstellt
                                    Ticket: P70397-375
  */

    function gen_trans_check_order (
        in_sid             in isi_sid.sid%type,
        in_firma_nr        in isi_firma.firma_nr%type,
        in_lte_id          in lvs_lte.lte_id%type,
        in_quell_lgr_platz in lvs_lgr.lgr_platz%type,
        in_auf_id          in isi_order_pos.auf_id%type
    ) return boolean is

        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(2550);
        v_found             boolean;
        v_lvs_lte           lvs_lte%rowtype;
        v_lvs_lam           lvs_lam%rowtype;
        v_order_kopf        isi_order_kopf%rowtype;
        v_order_pos         isi_order_pos%rowtype;
        v_ziel_lgr_platz    lvs_lgr.lgr_platz%type;
        v_lgr_quelle        lvs_lgr%rowtype;
        v_lgr_ziel          lvs_lgr%rowtype;
        v_transport_id      isi_transport.transp_id%type;
        v_res_id_trans      isi_resource.res_id%type;
        v_reservierung      number;
        v_transport_result  number;
        v_transport_gruppe  isi_transport.transport_gruppe%type;
        v_lgr_vorbereitung  lvs_lgr.einl_ort_default_liste%type;
        v_trans_created     boolean;
        v_lte_transp_gruppe lvs_lte.transport_gruppe%type;
        v_lgr_einl_ziele    isi_order_pos.quell_lagerorte%type;
        v_lgr_platz_grp     varchar2(4096);
        v_fahrzeuge_ids     varchar2(50);
        v_trans_typ         isi_transport.transp_typ%type;

  --cursor c_get_transp_gruppe is
  --  select max(lte.transport_gruppe)
  --    from lvs_lte lte
  --    join lvs_lam lam on lam.lte_id = lte.lte_id
  --   where lam.order_pos_auf_id = v_order_pos.auf_id;

        cursor c_get_transp_gruppe is
        select
            max(lte.transport_gruppe)
        into lvs_ausl.v_transport_gruppe
        from
            lvs_lte lte
        where
            lte.order_auf_id in (
                select
                    p.auf_id
                from
                    isi_order_pos p
                where
                        p.vorgang_id = (
                            select
                                p2.vorgang_id
                            from
                                isi_order_pos p2
                            where
                                p2.auf_id = v_order_pos.auf_id
                        )
                    and p.transport_gruppe = (
                        select
                            p2.transport_gruppe
                        from
                            isi_order_pos p2
                        where
                            p2.auf_id = v_order_pos.auf_id
                    )
            )
            and lte.transport_gruppe is not null;

        cursor c_get_lvs_lam is
        select
            lam.*
        from
            lvs_lam lam
        where
                lam.sid = v_lvs_lte.sid
            and lam.firma_nr = v_lvs_lte.firma_nr
            and lam.lam_id = (
                select
                    max(x.lam_id)
                from
                    lvs_lam x
                where
                        x.sid = v_lvs_lte.sid
                    and x.firma_nr = v_lvs_lte.firma_nr
                    and x.lte_id = v_lvs_lte.lte_id
            );

        cursor c_get_order_pos_by_auf_id is
        select
            opos.*
        from
            isi_order_pos opos
        where
                opos.sid = in_sid
            and opos.firma_nr = in_firma_nr
            and opos.auf_id = in_auf_id;

        cursor c_get_order_pos_by_fag is
        select
            opos.*
        from
                 bde_fa_auftrag fag
            join isi_order_pos opos on opos.auftrag = fag.kunden_ab
                                       and opos.pos_nr = fag.kunden_ab_pos
        where
                fag.sid = in_sid
            and fag.firma_nr = in_firma_nr
            and fag.kenz_letzt_ag = 1
            and fag.leitzahl = (
                select
                    x.leitzahl
                from
                         bde_fa_auftrag x
                    join lvs_lam lam on lam.leitzahl = x.leitzahl
                where
                        lam.lam_id = v_lvs_lam.lam_id
                    and x.kenz_letzt_ag = 1
            );

        cursor c_get_order_kopf is
        select
            okop.*
        from
            isi_order_kopf okop
        where
                okop.sid = v_order_pos.sid
            and okop.firma_nr = v_order_pos.firma_nr
            and okop.vorgang_id = v_order_pos.vorgang_id;

    begin
        v_trans_created := false;
        v_found := lvs_p_base.get_lgr_platz(in_quell_lgr_platz, -- in_lgr_platz in lvs_lgr.lgr_platz%type,
         v_lgr_quelle);             -- io_lgr       in out lvs_lgr%rowtype)

        if ( not v_found ) then
            v_err_nr := 11;
            v_err_text := 'Quell Lagerplatz '
                          || in_quell_lgr_platz
                          || ' umbekannt !';
            raise v_error;
        end if;

        v_found := lvs_p_base.get_lte(in_lte_id,  -- in_lte_id in lvs_lte.lte_id%type,

         v_lvs_lte); -- io_lte    in out lvs_lte%rowtype) return boolean is
        if ( not v_found ) then
            v_err_nr := 12;
            v_err_text := lc.ec(lc.o_txt_lte_anleg_err);
            raise v_error;
        end if;

        open c_get_lvs_lam;
        fetch c_get_lvs_lam into v_lvs_lam;
        v_found := c_get_lvs_lam%found;
        close c_get_lvs_lam;
        if ( not v_found ) then
            v_err_nr := 13;
            v_err_text := 'LAM fuer Lte Id '
                          || v_lvs_lte.lte_id
                          || 'umbekannt';
            raise v_error;
        end if;
    -- Lte auf die Quelle umbuchen
        if ( v_lvs_lte.lgr_platz is null )
        or ( v_lvs_lte.lgr_platz <> v_lgr_quelle.lgr_platz ) then
            lvs_transport.lvs_lte_transport(
                in_lte_id        => in_lte_id,
                in_von_lgr_platz => null,
                in_zu_lgr_platz  => v_lgr_quelle.lgr_platz,
                in_user_id       => '-1'
            );

            v_found := lvs_p_base.get_lte(in_lte_id,  -- in_lte_id in lvs_lte.lte_id%type,

             v_lvs_lte); -- io_lte    in out lvs_lte%rowtype) return boolean is
            if ( not v_found ) then
                v_err_nr := 12;
                v_err_text := lc.ec(lc.o_txt_lte_anleg_err);
                raise v_error;
            end if;

     /* Alte Variante Geändert 20201126 CMe wegen falscher Inventur Buchungen
     if (v_lvs_lte.lgr_platz is not null)
     then
       lvs_p_lte.lvs_korr_te_ausbuchen(v_lvs_lte.sid,        -- in_te_sid         in lvs_lte.sid%TYPE,
                                     v_lvs_lte.firma_nr,   -- in_te_firma_nr    in lvs_lte.firma_nr%TYPE,
                                     v_lvs_lte.lte_id,     -- in_lte_id         in LVS_LTE.LTE_ID%TYPE,
                                     v_lvs_lte.lte_status, -- in_lte_status     in lvs_lte.lte_status%TYPE,
                                     v_lvs_lte.sid,        -- in_lgr_sid        in lvs_lgr.sid%TYPE,
                                     v_lvs_lte.firma_nr,   -- in_lgr_firma_nr   in lvs_lgr.firma_nr%TYPE,
                                     v_lvs_lte.lgr_ort,    -- in_lgr_ort        in lvs_lgr.lgr_ort%TYPE,
                                     v_lvs_lte.lgr_platz,  -- in_lgr_lagerplatz in LVS_LTE.LGR_PLATZ%TYPE,
                                     '-1');                -- in_ls_login_id    in isi_user.login_id%TYPE)
     end if;
     lvs_p_lte.lvs_korr_te_einbuchen(v_lvs_lte.sid,         -- in_te_sid              in lvs_lte.sid%TYPE,
                                     v_lvs_lte.firma_nr,    -- in_te_firma_nr         in lvs_lte.firma_nr%TYPE,
                                     v_lvs_lte.lte_id,      -- in_lte_id              in lvs_lte.lte_id%type,
                                     'BF',                  -- in_lte_status          in lvs_lte.lte_status%TYPE,
                                     v_lgr_quelle.sid,       -- in_lgr_sid             in lvs_lgr.sid%TYPE,
                                     v_lgr_quelle.firma_nr,  -- in_lgr_firma_nr        in lvs_lgr.firma_nr%TYPE,
                                     v_lgr_quelle.lgr_ort,   -- in_lgr_einl_ort        in lvs_lgr.lgr_ort%TYPE,
                                     v_lgr_quelle.lgr_platz, -- in_lgr_einl_lagerplatz in lvs_lte.lgr_platz%type,
                                     '-1',                  -- in_ls_login_id         in isi_user.login_id%TYPE,
                                     true);                 -- in_lgr_platz_pruefen   in boolean default true)
     */
        end if;

        v_found := false;
        if ( in_auf_id is null ) then
            open c_get_order_pos_by_fag;
            fetch c_get_order_pos_by_fag into v_order_pos;
            v_found := c_get_order_pos_by_fag%found;
            close c_get_order_pos_by_fag;
        else
            open c_get_order_pos_by_auf_id;
            fetch c_get_order_pos_by_auf_id into v_order_pos;
            v_found := c_get_order_pos_by_auf_id%found;
            close c_get_order_pos_by_auf_id;
        end if;

        if ( v_found ) then
            open c_get_order_kopf;
            fetch c_get_order_kopf into v_order_kopf;
            v_found := c_get_order_kopf%found;
            close c_get_order_kopf;
            if ( v_found ) then
                if ( v_order_pos.quell_lagerorte is not null ) then
                    v_lgr_einl_ziele := v_order_pos.quell_lagerorte;
                else
                    v_lgr_einl_ziele := v_lgr_quelle.einl_ort_default_liste;
                    update isi_order_kopf okop
                    set
                        okop.quell_lagerorte = v_lgr_einl_ziele
                    where
                            okop.sid = v_order_kopf.sid
                        and okop.firma_nr = v_order_kopf.firma_nr
                        and okop.vorgang_id = v_order_kopf.vorgang_id;

                    update isi_order_pos opos
                    set
                        opos.quell_lagerorte = v_lgr_einl_ziele
                    where
                            opos.sid = v_order_kopf.sid
                        and opos.firma_nr = v_order_kopf.firma_nr
                        and opos.vorgang_id = v_order_kopf.vorgang_id;

                end if;

                if ( v_order_kopf.status <> 'N' ) then
                    v_reservierung := lvs_ausl.lvs_lte_reservieren(v_order_kopf.sid,       -- in_sid                  in isi_sid.sid%TYPE,
                     v_order_kopf.firma_nr,  -- in_firma_nr             in isi_firma.firma_nr%TYPE,
                     v_order_pos.vorgang_id, -- in_vorgang_id           in isi_transport.vorgang_id%type,
                     v_order_pos.auf_id,     -- in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                     v_lvs_lte.lte_id,       -- in_lte_id               in lvs_lte.lte_id%type,
                                                                   v_order_pos.vorgang_id, -- in_lte_vorgang_id       in isi_transport.vorgang_id%type,
                                                                    v_lgr_quelle.lgr_platz, -- in_lte_lgr_platz        in LVS_LTE.LGR_PLATZ%TYPE,
                                                                    v_lvs_lam.artikel_id);  -- in_artikel_id           in isi_artikel.artikel_id%type
                else
                    res_lief_pos_359(v_order_kopf.sid,         -- in_sid         in isi_sid.sid%type,
                     v_order_kopf.firma_nr,    -- in_firma_nr    in isi_firma.firma_nr%type,
                     v_order_pos.li_nr,        -- in_lief_nr     in isi_order_pos.li_nr%type,
                     v_order_pos.li_pos_nr,    -- in_lief_pos    in isi_order_pos.li_pos_nr%type,
                     '-1',                     -- in_user_id     in isi_user.login_id%type,
                                     v_order_kopf.vorgang_typ, -- in_typ         in varchar2,
                                      v_order_kopf.satzart,     -- in_satzart     in varchar2,
                                      v_order_pos.vorgang_id,   -- in_tour_nr     in isi_order_kopf.vorgang_id%type,
                                      v_lvs_lte.lte_id);        -- in_lte_id      in lvs_lte.lte_id%type
                end if;

                if ( v_order_kopf.status = 'N' )
                or ( v_order_kopf.status = 'D' ) then
                    lvs_platz.lvs_transp_suche_einl_p_rid(v_lvs_lte.lte_id,                   -- in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                     v_lgr_einl_ziele,                   -- in_lgr_orte             in varchar2,
                     '',                                 -- in_fahrzeuge_IDs        in varchar2,
                     'LVS',                              -- in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                     'SLS',                              -- in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                                          '-1',                               -- in_user_ID              in isi_user.login_id%TYPE,
                                                           4,                                  -- in_prio                 in isi_transport.Prio%TYPE,
                                                           '',                                 -- in_progr_nr             in isi_transport.progr_nr%TYPE,
                                                           '',                                 -- in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                                           '',                                 -- in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                                          v_lgr_quelle.lgr_platz,              -- in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                                           v_lvs_lam.lam_text,                 -- in_aktuelle_position    in lvs_lam.lam_text%type,
                                                           v_ziel_lgr_platz,                   -- out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                                           v_transport_id,                     -- out_transport_id        out number,
                                                           v_res_id_trans);                    -- out_res_id              out isi_resource.res_id%type
                    v_trans_created := true;
                end if;

                if ( v_order_kopf.status = 'V' )
                or ( v_order_kopf.status = 'R' ) then
                    open c_get_transp_gruppe;
                    fetch c_get_transp_gruppe into v_lte_transp_gruppe;
                    v_found := c_get_transp_gruppe%found;
                    close c_get_transp_gruppe;
                    if ( v_found )
                    or ( v_lte_transp_gruppe is not null ) then
                        update lvs_lte lte
                        set
                            lte.transport_gruppe = v_lte_transp_gruppe
                        where
                            lte.lte_id = v_lvs_lte.lte_id;

                        v_found := lvs_p_base.get_lgr_platz(v_order_pos.ziel, -- in_lgr_platz in lvs_lgr.lgr_platz%type,

                         v_lgr_ziel);      -- io_lgr       in out lvs_lgr%rowtype)
                        if ( not v_found ) then
                            v_err_nr := 21;
                            v_err_text := 'Ziel Lagerplatz '
                                          || in_quell_lgr_platz
                                          || ' umbekannt !';
                            raise v_error;
                        end if;

                        v_lgr_platz_grp := tour_tour_vl(v_order_pos.sid,        -- in_sid         in isi_sid.sid%type,

                         v_order_pos.firma_nr,   -- in_firma_nr    in isi_firma.firma_nr%type,

                         v_order_pos.vorgang_id, -- in_tour_nr     in isi_order_kopf.vorgang_id%type,

                         v_order_pos.ziel,       -- in_ziel        in isi_order_kopf.ziel%type,

                         v_lgr_ziel);            -- in_lgr_wa      in lvs_lgr%ROWTYPE

                        v_err_text := tour_suche_um_platz(v_lvs_lte,           --in_lte            in  lvs_lte%ROWTYPE,

                         v_lgr_quelle,        --in_lvs_akt_lgr      in  lvs_lgr%ROWTYPE,

                         v_lgr_platz_grp,     --in_lgr_platz_grp    in  varchar2,

                         v_lte_transp_gruppe, --in_tranport_gruppe  in  isi_transport.transport_gruppe%type,

                         v_lgr_ziel,          --out_lvs_lgr         out lvs_lgr%ROWTYPE,
                                                          v_fahrzeuge_ids);    --out_fahrzeuge_IDs   out varchar2)
                        if v_err_text is not null
                           or v_lgr_ziel.lgr_platz is null then
                            return ( v_trans_created );
                        end if;

                        v_trans_typ := null;
                        if v_order_pos.vorgang_typ like ( 'WE%' ) then
                            v_trans_typ := 'E';
                        elsif v_order_pos.vorgang_typ like ( 'WA%' ) then
                            v_trans_typ := 'A';
                        elsif v_order_pos.vorgang_typ like ( 'WU%' ) then
                            v_trans_typ := 'U';
                        end if;

                        v_transport_result := lvs_transport.lvs_transp_lte(in_sid,                    -- in_sid                  in isi_sid.sid%TYPE,

                         in_firma_nr,               -- in_firma_nr             in isi_firma.firma_nr%TYPE,

                         'ORD',                     -- in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,

                         'SLS',                     -- in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,

                         'F',                       -- in_frei_fahren          in varchar2,
                                                                           v_trans_typ,               -- in_trans_typ            in varchar2,
                                                                            '-1',                      -- in_user_ID              in isi_user.login_id%TYPE,
                                                                            v_order_pos.auf_id,        -- in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                                                                            v_order_pos.auf_id_extern, -- in_auftrag_id_extern    in isi_transport.Auf_Id_extern%TYPE,
                                                                            5,                         -- in_prio                 in isi_transport.Prio%TYPE,
                                                                           '',                        -- in_progr_nr             in isi_transport.progr_nr%TYPE,
                                                                            '',                        -- in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                                                            '',                        -- in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                                                            v_lgr_quelle.lgr_platz,    -- in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                                                                            v_lgr_ziel.lgr_platz,      -- in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                                                                           v_lvs_lte.lte_id,          -- in_lte_id               in lvs_lte.lte_id%TYPE,
                                                                            v_lvs_lam.kunden_nr,       -- in_kunde_nr             in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                                                                            'T',                       -- in_lieferschein         in isi_transport.lieferschein%type,
                                                                            v_order_pos.li_nr,         -- in_li_nr                in isi_transport.li_nr%type,
                                                                            v_order_pos.li_pos_nr,     -- in_li_pos_nr            in isi_transport.li_pos_nr%type,
                                                                           v_order_pos.vorgang_id,    -- in_vorgang_id           in isi_transport.vorgang_id%type,
                                                                            v_fahrzeuge_ids,           -- in_fahrzeuge_IDs        in varchar2,
                                                                            '',                        -- in_lkw_nr               in isi_transport.lkw_nr%type,
                                                                            v_transport_gruppe,        -- in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                                                                            v_transport_id,            -- out_transp_id           out isi_transport.transp_id%type,
                                                                           '',                        -- in_parent_transp_id     in isi_transport.transp_id%type default NULL,
                                                                            '');                       -- in_fetig_bis
                        v_trans_created := true;
                    end if;

                end if;

                if ( v_order_kopf.status = 'T' ) then
                    v_found := lvs_p_base.get_lgr_platz(v_order_pos.ziel, -- in_lgr_platz in lvs_lgr.lgr_platz%type,
                     v_lgr_ziel);      -- io_lgr       in out lvs_lgr%rowtype)
                    if ( not v_found ) then
                        return ( v_trans_created );
                    end if;
                    v_trans_typ := null;
                    if v_order_pos.vorgang_typ like ( 'WE%' ) then
                        v_trans_typ := 'E';
                    elsif v_order_pos.vorgang_typ like ( 'WA%' ) then
                        v_trans_typ := 'A';
                    elsif v_order_pos.vorgang_typ like ( 'WU%' ) then
                        v_trans_typ := 'U';
                    end if;

                    v_transport_result := lvs_transport.lvs_transp_lte(in_sid,                    -- in_sid                  in isi_sid.sid%TYPE,

                     in_firma_nr,               -- in_firma_nr             in isi_firma.firma_nr%TYPE,

                     'ORD',                     -- in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,

                     'SLS',                     -- in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,

                     'F',                       -- in_frei_fahren          in varchar2,
                                                                       v_trans_typ,               -- in_trans_typ            in varchar2,
                                                                        '-1',                      -- in_user_ID              in isi_user.login_id%TYPE,
                                                                        v_order_pos.auf_id,        -- in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                                                                        v_order_pos.auf_id_extern, -- in_auftrag_id_extern    in isi_transport.Auf_Id_extern%TYPE,
                                                                        5,                         -- in_prio                 in isi_transport.Prio%TYPE,
                                                                       '',                        -- in_progr_nr             in isi_transport.progr_nr%TYPE,
                                                                        '',                        -- in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                                                        '',                        -- in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                                                        v_lgr_quelle.lgr_platz,    -- in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                                                                        v_lgr_ziel.lgr_platz,      -- in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                                                                       v_lvs_lte.lte_id,          -- in_lte_id               in lvs_lte.lte_id%TYPE,
                                                                        v_lvs_lam.kunden_nr,       -- in_kunde_nr             in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                                                                        'T',                       -- in_lieferschein         in isi_transport.lieferschein%type,
                                                                        v_order_pos.li_nr,         -- in_li_nr                in isi_transport.li_nr%type,
                                                                        v_order_pos.li_pos_nr,     -- in_li_pos_nr            in isi_transport.li_pos_nr%type,
                                                                       v_order_pos.vorgang_id,    -- in_vorgang_id           in isi_transport.vorgang_id%type,
                                                                        '',                        -- in_fahrzeuge_IDs        in varchar2,
                                                                        '',                        -- in_lkw_nr               in isi_transport.lkw_nr%type,
                                                                        v_transport_gruppe,        -- in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                                                                        v_transport_id,            -- out_transp_id           out isi_transport.transp_id%type,
                                                                       '',                        -- in_parent_transp_id     in isi_transport.transp_id%type default NULL,
                                                                        '');                       -- in_fetig_bis            in date default NULL
                    v_trans_created := true;
                end if;

            end if;

        end if;

        return ( v_trans_created );
    exception
        when v_error then
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

    end gen_trans_check_order;

end isi_p_order;
/


-- sqlcl_snapshot {"hash":"be2712d1a895ffcd4451c995c053c0055b1da742","type":"PACKAGE_BODY","name":"ISI_P_ORDER","schemaName":"DIRKSPZM32","sxml":""}