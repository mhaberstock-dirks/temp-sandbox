create or replace package body dirkspzm32.tms_p_delivery is

    v_build_number constant number := 1;
  /*
  *  Build history
  *  date       | version    | info
  *  ---------------------------------------------------------------------------------
  *  27.01.2010   3.5.2.1    | (-BW-) Erweiterung Spedition
  *  06.03.2009 | 3.4.10.1   | (-WK-) package created
  */
    v_error exception;
    v_err_nr       number;
    v_err_text     varchar2(255);

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
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
    procedure reset_isi_error is
    begin
        v_err_nr := null;
        v_err_text := null;
    end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
    function get_release return varchar2 is
    begin
        return ( v_release_str );
    end;

    function get_version return varchar2 is
    begin
        return ( to_char(v_release_major)
                 || '.'
                 || to_char(v_release_minor)
                 || '.'
                 || to_char(v_revision)
                 || '.'
                 || to_char(v_build_number)
                 || ' / ' || v_rev_date );
    end;

    procedure get_version_ex (
        out_rel_major   out number,
        out_rel_minor   out number,
        out_revision    out number,
        out_buid_number out number,
        out_rev_date    out varchar2
    ) is
    begin
        out_rel_major := v_release_major;
        out_rel_minor := v_release_minor;
        out_revision := v_revision;
        out_buid_number := v_build_number;
        out_rev_date := v_rev_date;
    end;

  /******************************************************************************************************
   * private functions
   ******************************************************************************************************/
    function get_deliv_order_li_nr (
        in_sid        in isi_order_pos.sid%type,
        in_firma_nr   in isi_order_pos.firma_nr%type,
        in_vorgang_id in isi_order_pos.vorgang_id%type,
        in_auftrag_nr in isi_order_pos.auftrag%type
    ) return number is

        v_li_nr isi_order_pos.li_nr%type;
        cursor c_order_pos is
        select
            t.li_nr
        from
            isi_order_pos t
        where
                t.vorgang_id = in_vorgang_id
            and t.vorgang_typ = 'WAE'
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid
            and t.auftrag = in_auftrag_nr;

        v_found boolean;
    begin
    -- für jeden Auftrag in einem Vorgang muss eine neue Lieferscheinnummer generiert werden
    -- oder die bereits vorhandene Lieferscheinnummer des Auftrags verwendet werden
        open c_order_pos;
        fetch c_order_pos into v_li_nr;
        v_found := c_order_pos%found;
        close c_order_pos;
        if not v_found then
            select
                seq_tms_order_li_nr.nextval
            into v_li_nr
            from
                dual;

        end if;
        return ( v_li_nr );
    end;

    function get_deliv_order_li_pos_nr (
        in_sid        in isi_order_pos.sid%type,
        in_firma_nr   in isi_order_pos.firma_nr%type,
        in_vorgang_id in isi_order_pos.vorgang_id%type,
        in_li_nr      in isi_order_pos.li_nr%type
    ) return number is

        v_li_pos_nr isi_order_pos.li_pos_nr%type;
        cursor c_order_pos is
        select
            max(t.li_pos_nr)
        from
            isi_order_pos t
        where
                t.vorgang_id = in_vorgang_id
            and t.vorgang_typ = 'WAE'
            and t.li_nr = in_li_nr
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

    begin
        open c_order_pos;
        fetch c_order_pos into v_li_pos_nr;
        if not c_order_pos%found then
            v_li_pos_nr := 0;
        end if;
        close c_order_pos;
        v_li_pos_nr := nvl(v_li_pos_nr, 0) + 10;
        return ( v_li_pos_nr );
    end;

    function get_deliv_sped_adress_id (
        in_sid        in isi_order_kopf.sid%type,
        in_firma_nr   in isi_order_kopf.firma_nr%type,
        in_vorgang_id in isi_order_kopf.vorgang_id%type
    ) return number is

        v_order_sp_adress_id isi_order_kopf.sp_adress_id%type;
        cursor c_order_kopf is
        select
            t.sp_adress_id
        from
            isi_order_kopf t
        where
                t.vorgang_id = in_vorgang_id
            and t.vorgang_typ = 'WAE'
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid
        order by
            t.transport_gruppe;

    begin
        v_order_sp_adress_id := null;
        open c_order_kopf;
        fetch c_order_kopf into v_order_sp_adress_id;
        close c_order_kopf;
        return ( v_order_sp_adress_id );
    end;

    function get_deliv_transport_group (
        in_sid        in isi_order_kopf.sid%type,
        in_firma_nr   in isi_order_kopf.firma_nr%type,
        in_vorgang_id in isi_order_kopf.vorgang_id%type,
        in_adress_id  in isi_order_kopf.adress_id%type
    ) return number is

        v_order_adress_id  isi_order_kopf.adress_id%type;
        v_order_transp_grp isi_order_kopf.transport_gruppe%type;
        v_next_transp_grp  isi_order_kopf.transport_gruppe%type;
        cursor c_order_kopf is
        select
            t.adress_id,
            t.transport_gruppe
        from
            isi_order_kopf t
        where
                t.vorgang_id = in_vorgang_id
            and t.vorgang_typ = 'WAE'
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid
        order by
            t.transport_gruppe;

    begin
        v_next_transp_grp := 10;
        open c_order_kopf;
        loop
            fetch c_order_kopf into
                v_order_adress_id,
                v_order_transp_grp;
            exit when c_order_kopf%notfound;

      -- nächte Transportgruppe schon mal aktuelle + 10
            v_next_transp_grp := nvl(v_order_transp_grp, 0) + 10;
            if v_order_adress_id = in_adress_id then
        -- Transportgruppe mit der selben adresse vorhanden
                v_next_transp_grp := v_order_transp_grp;
                exit;
            end if;
        end loop;

        close c_order_kopf;
        return ( v_next_transp_grp );
    end;

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/
    function c_create_new_delivery_order (
        in_sid          in isi_order_pos.sid%type,
        in_firma_nr     in isi_order_pos.firma_nr%type,
        in_auftrag_nr   in isi_order_pos.auftrag%type,
        in_pos_nr       in isi_order_pos.pos_nr%type,
        in_upos_nr      in isi_order_pos.upos_nr%type,
        in_login_id     in isi_order_pos.login_id%type,
        in_sp_adress_id in isi_order_kopf.sp_adress_id%type
    ) return number is
        v_vorgang_id isi_order_kopf.vorgang_id%type;
    begin
        v_vorgang_id := tms_p_delivery.c_create_new_delivery_ord_3511(in_sid, in_firma_nr, in_auftrag_nr, in_pos_nr, in_upos_nr,
                                                                      in_login_id, in_sp_adress_id, 'LI', null,           -- in_lam_sel1                  in lvs_lam.lam_sel1%type,
                                                                       null,           -- in_lam_sel2                  in lvs_lam.lam_sel2%type,
                                                                      null,           -- in_lam_sel3                  in lvs_lam.lam_sel3%type,
                                                                       null,           -- in_lam_sel4                  in lvs_lam.lam_sel4%type,
                                                                       null,           -- in_lam_sel5                  in lvs_lam.lam_sel5%type,
                                                                       null,           -- in_lam_sel6                  in lvs_lam.lam_sel6%type,
                                                                       null,           -- in_lam_sel7                  in lvs_lam.lam_sel7%type,
                                                                      null,           -- in_lam_sel8                  in lvs_lam.lam_sel8%type,
                                                                       null,           -- in_lam_sel9                  in lvs_lam.lam_sel9%type,
                                                                       null,           -- in_lam_sel10                 in lvs_lam.lam_sel10%type
                                                                       null,           --in_anbruch                   in isi_order_pos.anbruch%type,
                                                                       null            -- in_quell_lagerorte           in isi_order_pos.quell_lagerorte%type
                                                                      );

        return ( v_vorgang_id );
    end;

    function create_new_tour_nr (
        in_sid      in isi_order_pos.sid%type,
        in_firma_nr in isi_order_pos.firma_nr%type
    ) return number is
        v_vorgang_id isi_order_kopf.vorgang_id%type;
    begin
        reset_isi_error();
        select
            seq_tms_order_vorgang_id.nextval
        into v_vorgang_id
        from
            dual;

        return ( v_vorgang_id );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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

    end;

    function c_create_new_delivery_ord_3511 (
        in_sid             in isi_order_pos.sid%type,
        in_firma_nr        in isi_order_pos.firma_nr%type,
        in_auftrag_nr      in isi_order_pos.auftrag%type,
        in_pos_nr          in isi_order_pos.pos_nr%type,
        in_upos_nr         in isi_order_pos.upos_nr%type,
        in_login_id        in isi_order_pos.login_id%type,
        in_sp_adress_id    in isi_order_kopf.sp_adress_id%type,
        in_satzart         in isi_order_kopf.satzart%type,
        in_lam_sel1        in lvs_lam.lam_sel1%type,
        in_lam_sel2        in lvs_lam.lam_sel2%type,
        in_lam_sel3        in lvs_lam.lam_sel3%type,
        in_lam_sel4        in lvs_lam.lam_sel4%type,
        in_lam_sel5        in lvs_lam.lam_sel5%type,
        in_lam_sel6        in lvs_lam.lam_sel6%type,
        in_lam_sel7        in lvs_lam.lam_sel7%type,
        in_lam_sel8        in lvs_lam.lam_sel8%type,
        in_lam_sel9        in lvs_lam.lam_sel9%type,
        in_lam_sel10       in lvs_lam.lam_sel10%type,
        in_anbruch         in isi_order_pos.anbruch%type,
        in_quell_lagerorte in isi_order_pos.quell_lagerorte%type
    ) return number is
        v_vorgang_id isi_order_kopf.vorgang_id%type;
    begin
        reset_isi_error();
        v_vorgang_id := create_new_tour_nr(in_sid, in_firma_nr);
        c_add_pos_to_delivery_order(in_sid, in_firma_nr, v_vorgang_id, in_auftrag_nr, in_pos_nr,
                                    in_upos_nr, in_login_id, in_sp_adress_id);

        return ( v_vorgang_id );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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

    end;

    procedure c_add_pos_to_delivery_order (
        in_sid          in isi_order_pos.sid%type,
        in_firma_nr     in isi_order_pos.firma_nr%type,
        in_vorgang_id   in isi_order_pos.vorgang_id%type,
        in_auftrag_nr   in isi_order_pos.auftrag%type,
        in_pos_nr       in isi_order_pos.pos_nr%type,
        in_upos_nr      in isi_order_pos.upos_nr%type,
        in_login_id     in isi_order_pos.login_id%type,
        in_sp_adress_id in isi_order_kopf.sp_adress_id%type  -- Neu 3.5.2
    ) is
    begin
        tms_p_delivery.c_add_pos_to_delivery_ord_3511(in_sid, in_firma_nr, in_vorgang_id, in_auftrag_nr, in_pos_nr,
                                                      in_upos_nr, in_login_id, in_sp_adress_id, 'LI', null,           -- in_lam_sel1                  in lvs_lam.lam_sel1%type,
                                                      null,           -- in_lam_sel2                  in lvs_lam.lam_sel2%type,
                                                       null,           -- in_lam_sel3                  in lvs_lam.lam_sel3%type,
                                                       null,           -- in_lam_sel4                  in lvs_lam.lam_sel4%type,
                                                       null,           -- in_lam_sel5                  in lvs_lam.lam_sel5%type,
                                                       null,           -- in_lam_sel6                  in lvs_lam.lam_sel6%type,
                                                      null,           -- in_lam_sel7                  in lvs_lam.lam_sel7%type,
                                                       null,           -- in_lam_sel8                  in lvs_lam.lam_sel8%type,
                                                       null,           -- in_lam_sel9                  in lvs_lam.lam_sel9%type,
                                                       null,           -- in_lam_sel10                 in lvs_lam.lam_sel10%type
                                                       null,           --in_anbruch                   in isi_order_pos.anbruch%type,
                                                      null            -- in_quell_lagerorte           in isi_order_pos.quell_lagerorte%type
                                                      );
    end;

    procedure c_add_pos_to_delivery_ord_3511 (
        in_sid             in isi_order_pos.sid%type,
        in_firma_nr        in isi_order_pos.firma_nr%type,
        in_vorgang_id      in isi_order_pos.vorgang_id%type,
        in_auftrag_nr      in isi_order_pos.auftrag%type,
        in_pos_nr          in isi_order_pos.pos_nr%type,
        in_upos_nr         in isi_order_pos.upos_nr%type,
        in_login_id        in isi_order_pos.login_id%type,
        in_sp_adress_id    in isi_order_kopf.sp_adress_id%type,
        in_satzart         in isi_order_kopf.satzart%type,
        in_lam_sel1        in lvs_lam.lam_sel1%type,
        in_lam_sel2        in lvs_lam.lam_sel2%type,
        in_lam_sel3        in lvs_lam.lam_sel3%type,
        in_lam_sel4        in lvs_lam.lam_sel4%type,
        in_lam_sel5        in lvs_lam.lam_sel5%type,
        in_lam_sel6        in lvs_lam.lam_sel6%type,
        in_lam_sel7        in lvs_lam.lam_sel7%type,
        in_lam_sel8        in lvs_lam.lam_sel8%type,
        in_lam_sel9        in lvs_lam.lam_sel9%type,
        in_lam_sel10       in lvs_lam.lam_sel10%type,
        in_anbruch         in isi_order_pos.anbruch%type,
        in_quell_lagerorte in isi_order_pos.quell_lagerorte%type
    ) is

        v_kunden_auftr_pos tms_kunden_auftr_pos%rowtype;
        v_order_kopf       isi_order_kopf%rowtype;
        v_order_pos        isi_order_pos%rowtype;
        v_vorgang_status   varchar2(255);
        v_order_li_nr      isi_order_kopf.li_nr%type;
        v_order_li_pos_nr  isi_order_pos.li_pos_nr%type;
        v_sped_adress_id   isi_order_kopf.sp_adress_id%type;
        cursor c_order_kopf is
        select
            ok.*
        from
            isi_order_kopf ok
        where
                ok.vorgang_id = in_vorgang_id
            and ok.vorgang_typ = 'WAE' -- delivery immer WAE
            and ok.li_nr = v_order_li_nr
            and ok.firma_nr = in_firma_nr
            and ok.sid = in_sid;

        cursor c_order_pos is
        select
            op.*
        from
            isi_order_pos op
        where
                op.vorgang_id = in_vorgang_id
            and op.vorgang_typ = 'WAE' -- delivery immer WAE
            and op.li_nr = v_order_li_nr
            and op.li_pos_nr = v_order_li_pos_nr
            and op.firma_nr = in_firma_nr
            and op.sid = in_sid;

        cursor c_order_vorgang_status is
        select
            nvl(
                stradd_distinct(ok.status),
                'N'
            )
        from
            isi_order_kopf ok
        where
                ok.vorgang_id = in_vorgang_id
            and ok.vorgang_typ = 'WAE'; -- delivery immer WAE
        v_found            boolean;
    begin
        reset_isi_error();
        if not tms_p_base.get_kunden_auftr_pos_by_uix(in_auftrag_nr, in_pos_nr, in_upos_nr, in_firma_nr, in_sid,
                                                      v_kunden_auftr_pos) then
            raise_isi_error(10,
                            lc.ec_p3('O_TP3_CUST_ORDER_LINE_NA', in_auftrag_nr, in_pos_nr, in_upos_nr));
        end if;

        v_order_li_nr := v_kunden_auftr_pos.li_nr;
        if v_order_li_nr is null then
            v_order_li_nr := get_deliv_order_li_nr(in_sid, in_firma_nr, in_vorgang_id, in_auftrag_nr);
        end if;

        v_order_li_pos_nr := v_kunden_auftr_pos.li_pos_nr;
        if v_order_li_pos_nr is null then
            v_order_li_pos_nr := get_deliv_order_li_pos_nr(in_sid, in_firma_nr, in_vorgang_id, v_order_li_nr);
        end if;

        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        v_sped_adress_id := in_sp_adress_id;
        if v_sped_adress_id is null then
            v_sped_adress_id := get_deliv_sped_adress_id(in_sid, in_firma_nr, in_vorgang_id);
        end if;

        if not v_found then
            v_vorgang_status := null;
            open c_order_vorgang_status;
            fetch c_order_vorgang_status into v_vorgang_status;
            close c_order_vorgang_status;
            if v_vorgang_status <> 'N' then
                raise_isi_error(20,
                                lc.ec_p1('O_TP1_DELIV_ORDER_STATUS_ERR', in_vorgang_id));
            end if;

            v_order_kopf.sid := v_kunden_auftr_pos.sid;
            v_order_kopf.firma_nr := v_kunden_auftr_pos.firma_nr;
            v_order_kopf.vorgang_typ := 'WAE';
            v_order_kopf.vorgang_id := in_vorgang_id;
            v_order_kopf.li_nr := v_order_li_nr;
            v_order_kopf.be_nr := null; -- bei Satzart = 'LI' immer NULL (-AG- 20090306)
            v_order_kopf.satzart := in_satzart;
            v_order_kopf.adress_id := v_kunden_auftr_pos.adress_id_liefer;
            v_order_kopf.order_adress_id := v_kunden_auftr_pos.adress_id_rechn;
            v_order_kopf.login_id := in_login_id;
            v_order_kopf.arbeitsplatz_id := v_kunden_auftr_pos.arbeitsplatz_id;
            v_order_kopf.strategie := v_kunden_auftr_pos.strategie;
            v_order_kopf.order_info := v_kunden_auftr_pos.order_info;
            v_order_kopf.status := 'N';
            v_order_kopf.quell_lagerorte := in_quell_lagerorte;
            v_order_kopf.quelle := null;
            v_order_kopf.ziel := v_kunden_auftr_pos.ziel; -- wird bei der Verladung zugewiesen
            v_order_kopf.wae_ziel := v_kunden_auftr_pos.wae_ziel;
            v_order_kopf.besteller := v_kunden_auftr_pos.besteller;
            v_order_kopf.freigabe := v_kunden_auftr_pos.freigabe;
            v_order_kopf.freigabe_datum := v_kunden_auftr_pos.freigabe_datum;
            v_order_kopf.freigegeben_datum := v_kunden_auftr_pos.freigegeben_datum;
            v_order_kopf.order_datum := v_kunden_auftr_pos.auftr_datum;
            v_order_kopf.liefer_datum := v_kunden_auftr_pos.liefer_datum;
            v_order_kopf.fertig_datum := null;
            v_order_kopf.lvs_info := v_kunden_auftr_pos.lvs_info;
            v_order_kopf.prioritaet := v_kunden_auftr_pos.prioritaet;
            v_order_kopf.anbruch := nvl(in_anbruch, 'I');
            v_order_kopf.ohne_transport := 'F'; -- erstmal keine Schnellverladung vorgesehen
            v_order_kopf.ohne_transp_anz := 0;
            v_order_kopf.lkw_nr := null; -- wird bei der Verladung zugewiesen
            v_order_kopf.transport_gruppe := get_deliv_transport_group(v_kunden_auftr_pos.sid, v_kunden_auftr_pos.firma_nr, in_vorgang_id
            , v_kunden_auftr_pos.adress_id_liefer);

            v_order_kopf.wa_verladepunkt := null;  -- wird bei der Verladung zugewiesen
            v_order_kopf.sp_adress_id := v_sped_adress_id;  -- Spedition adress id
      -- Verladezeitpunkt schon mal auf das Lieferdatum setzen
      -- wird später über die Verladekontrolle korrigiert
            v_order_kopf.wa_verl_start_soll := v_kunden_auftr_pos.liefer_datum;
            insert into isi_order_kopf ok values v_order_kopf;

        end if;

        open c_order_pos;
        fetch c_order_pos into v_order_pos;
        v_found := c_order_pos%found;
        close c_order_pos;
        v_order_pos.sid := v_kunden_auftr_pos.sid;
        v_order_pos.firma_nr := v_kunden_auftr_pos.firma_nr;
        v_order_pos.auf_id := null; -- trigger/sequence
        v_order_pos.auf_id_extern := v_kunden_auftr_pos.kunden_auftr_pos_id; -- ???
        v_order_pos.vorgang_typ := 'WAE';
        v_order_pos.vorgang_id := in_vorgang_id;
        v_order_pos.vorgang_pos := null; -- wird im trigger automatisch berechnet
        v_order_pos.transport_gruppe := v_order_kopf.transport_gruppe;
        v_order_pos.satzart := in_satzart;
        v_order_pos.auftrag := v_kunden_auftr_pos.auftrag_nr;
        v_order_pos.pos_nr := v_kunden_auftr_pos.pos_nr;
        v_order_pos.upos_nr := v_kunden_auftr_pos.upos_nr;
        v_order_pos.artikel_id := v_kunden_auftr_pos.artikel_id;
        v_order_pos.ware_disponiert := 'F';
        v_order_pos.login_id := in_login_id;
        v_order_pos.arbeitsplatz_id := v_kunden_auftr_pos.arbeitsplatz_id;
        v_order_pos.leitzahl := v_kunden_auftr_pos.fa_nr;
        v_order_pos.fa_ag := v_kunden_auftr_pos.fa_ag;
        v_order_pos.fa_upos := v_kunden_auftr_pos.fa_upos;
        v_order_pos.charge_id := v_kunden_auftr_pos.charge_id;
        v_order_pos.seriennr_id := v_kunden_auftr_pos.seriennr_id;
        v_order_pos.strategie := v_kunden_auftr_pos.strategie;
        v_order_pos.mhd := v_kunden_auftr_pos.mhd;
        v_order_pos.li_extern := 'F';
        v_order_pos.li_nr := v_order_li_nr;
        v_order_pos.li_pos_nr := v_order_li_pos_nr;
        v_order_pos.order_info := v_kunden_auftr_pos.order_info;
        v_order_pos.soll_menge := v_kunden_auftr_pos.soll_menge;
        v_order_pos.ist_menge := 0; --v_kunden_auftr_pos.ist_menge
        v_order_pos.menge_basis := v_kunden_auftr_pos.menge_basis;
        v_order_pos.mengeneinheit := v_kunden_auftr_pos.mengeneinheit;
        v_order_pos.status := 'N';
        v_order_pos.quell_lagerorte := nvl(in_quell_lagerorte, v_kunden_auftr_pos.quell_lagerorte);
        v_order_pos.quelle := null;
        v_order_pos.ziel := v_kunden_auftr_pos.ziel;
        v_order_pos.wae_ziel := v_kunden_auftr_pos.wae_ziel;
        v_order_pos.besteller := v_kunden_auftr_pos.besteller;
        v_order_pos.freigabe := v_kunden_auftr_pos.freigabe;
        v_order_pos.freigabe_datum := v_kunden_auftr_pos.freigabe_datum;
        v_order_pos.freigegeben_datum := v_kunden_auftr_pos.freigegeben_datum;
        v_order_pos.order_datum := v_kunden_auftr_pos.auftr_datum;
        v_order_pos.liefer_datum := v_kunden_auftr_pos.liefer_datum;
        v_order_pos.fertig_datum := null;
        v_order_pos.lvs_info := v_kunden_auftr_pos.lvs_info;
        v_order_pos.prioritaet := v_kunden_auftr_pos.prioritaet;
        v_order_pos.anbruch := v_kunden_auftr_pos.anbruch;
        v_order_pos.min_mhd_tage := v_kunden_auftr_pos.min_mhd_tage;
        v_order_pos.min_reifezeit := v_kunden_auftr_pos.min_reifezeit;
        v_order_pos.brutto_kg := null; -- ???v_kunden_auftr_pos.b
        v_order_pos.best_nr_kunde := v_kunden_auftr_pos.best_nr_kunde;
        v_order_pos.wa_menge_ueberlief := null;
        v_order_pos.zeichnung_index := v_kunden_auftr_pos.zeichnung_index;
        v_order_pos.komplett_reservieren := c.c_true;
        v_order_pos.komplett_bereitstellen := c.c_false;
        v_order_pos.lam_sel1 := in_lam_sel1;
        v_order_pos.lam_sel2 := in_lam_sel2;
        v_order_pos.lam_sel3 := in_lam_sel3;
        v_order_pos.lam_sel4 := in_lam_sel4;
        v_order_pos.lam_sel5 := in_lam_sel5;
        v_order_pos.lam_sel6 := in_lam_sel6;
        v_order_pos.lam_sel7 := in_lam_sel7;
        v_order_pos.lam_sel8 := in_lam_sel8;
        v_order_pos.lam_sel9 := in_lam_sel9;
        v_order_pos.lam_sel10 := in_lam_sel10;
        v_order_pos.prod_params := v_kunden_auftr_pos.prod_params;
        if v_found then
            delete isi_order_pos op
            where
                    op.vorgang_id = in_vorgang_id
                and op.vorgang_typ = 'WAE' -- delivery immer WAE
                and op.li_nr = v_order_li_nr
                and op.li_pos_nr = v_order_li_pos_nr
                and op.firma_nr = in_firma_nr
                and op.sid = in_sid;

        end if;

        insert into isi_order_pos values v_order_pos;

        update tms_kunden_auftr_pos t
        set
            t.status = 'B', -- dieser Kundenauftrag ist jetzt in Bearbeitung
            t.aend_login_id = in_login_id,
            t.aend_datum = sysdate
        where
                t.kunden_auftr_pos_id = v_kunden_auftr_pos.kunden_auftr_pos_id
            and t.firma_nr = v_kunden_auftr_pos.firma_nr
            and t.sid = v_kunden_auftr_pos.sid;

        commit;
        if v_kunden_auftr_pos.besteller = 'WAWI' then
            update isi_purch_kopf pk
            set
                pk.status = 'B', -- dieser Kundenauftrag ist jetzt in Bearbeitung
                pk.lieferschein_nr = v_order_kopf.li_nr
            where
                    pk.id = in_auftrag_nr
                and pk.firma_nr = v_kunden_auftr_pos.firma_nr
                and pk.sid = v_kunden_auftr_pos.sid;

        end if;

        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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

    end;

    procedure c_mov_pos_to_delivery_order (
        in_sid            in isi_order_pos.sid%type,
        in_firma_nr       in isi_order_pos.firma_nr%type,
        in_old_vorgang_id in isi_order_pos.vorgang_id%type,
        in_lief_nr        in isi_order_pos.li_nr%type,
        in_new_vorgang_id in isi_order_pos.vorgang_id%type,
        in_login_id       in isi_order_pos.login_id%type
    ) is

        v_found       boolean;
        v_vorgang_id  isi_order_kopf.vorgang_id%type;
        v_order_pos   isi_order_pos%rowtype;
        v_vorgang_pos isi_order_pos.vorgang_pos%type;
        cursor c_order_pos is
        select
            *
        from
            isi_order_pos t
        where
            t.vorgang_id = v_vorgang_id
        order by
            t.li_nr,
            t.li_pos_nr;

    begin
        reset_isi_error();
        if in_new_vorgang_id = in_old_vorgang_id then
            return;
        end if;
        update isi_order_kopf t
        set
            t.vorgang_id = in_new_vorgang_id
        where
                t.vorgang_id = in_old_vorgang_id
            and t.li_nr = in_lief_nr;

        update isi_order_pos t
        set
            t.vorgang_id = in_new_vorgang_id
        where
                t.vorgang_id = in_old_vorgang_id
            and t.li_nr = in_lief_nr;

        v_vorgang_id := in_old_vorgang_id;
        loop
            open c_order_pos;
            v_vorgang_pos := 1;
            loop
                fetch c_order_pos into v_order_pos;
                exit when c_order_pos%notfound;
                update isi_order_pos t
                set
                    t.vorgang_pos = v_vorgang_pos
                where
                    t.auf_id = v_order_pos.auf_id;

                v_vorgang_pos := v_vorgang_pos + 1;
            end loop;

            close c_order_pos;
            exit when v_order_pos.vorgang_id = in_new_vorgang_id;
            v_vorgang_id := in_new_vorgang_id;
        end loop;

        commit;
    end;

    procedure c_del_pos_from_delivery_order (
        in_sid        in isi_order_pos.sid%type,
        in_firma_nr   in isi_order_pos.firma_nr%type,
        in_vorgang_id in isi_order_pos.vorgang_id%type,
        in_li_nr      in isi_order_pos.li_nr%type,
        in_li_pos_nr  in isi_order_pos.li_pos_nr%type,
        in_login_id   in isi_order_pos.login_id%type
    ) is

        v_ok_status        isi_order_kopf.status%type;
        v_op_status        isi_order_pos.status%type;
        v_op_auf_id_extern isi_order_pos.auf_id_extern%type;
        cursor c_order_kopf is
        select
            ok.status
        from
            isi_order_kopf ok
        where
                ok.vorgang_id = in_vorgang_id
            and ok.vorgang_typ = 'WAE'
            and ok.li_nr = in_li_nr
            and ok.firma_nr = in_firma_nr
            and ok.sid = in_sid;

        cursor c_order_pos is
        select
            op.status,
            op.auf_id_extern
        from
            isi_order_pos op
        where
                op.li_nr = in_li_nr
            and op.li_pos_nr = in_li_pos_nr
            and op.vorgang_typ = 'WAE'
            and op.vorgang_id = in_vorgang_id;

        v_found            boolean;
    begin
        reset_isi_error();
        open c_order_kopf;
        fetch c_order_kopf into v_ok_status;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if not v_found then
            raise_isi_error(10,
                            lc.ec_p2('O_TP2_ORDER_KOPF_LI_DATA_NA', in_vorgang_id, in_li_nr));
        end if;

        if nvl(v_ok_status, 'N') != 'N' then
            raise_isi_error(20,
                            lc.ec_p2('O_TP3_ORDER_KOPF_LI_ACTIVE', in_vorgang_id, in_li_nr));
        end if;

        open c_order_pos;
        fetch c_order_pos into
            v_op_status,
            v_op_auf_id_extern;
        v_found := c_order_pos%found;
        close c_order_pos;
        if not v_found then
            raise_isi_error(30,
                            lc.ec_p3('O_TP3_ORDER_POS_LI_DATA_NA', in_vorgang_id, in_li_nr, in_li_pos_nr));
        end if;

        if v_op_status <> 'N' then
            raise_isi_error(40,
                            lc.ec_p3('O_TP3_ORDER_POS_LI_ACTIVE', in_vorgang_id, in_li_nr, in_li_pos_nr));
        end if;

        delete isi_order_pos op
        where
                op.li_nr = in_li_nr
            and op.li_pos_nr = in_li_pos_nr
            and op.vorgang_typ = 'WAE'
            and op.vorgang_id = in_vorgang_id;

    -- wenn keine Unterpositionen vorhanden sind, Kopf-Daten auch löschen
        delete isi_order_kopf ok
        where
                ok.vorgang_id = in_vorgang_id
            and ok.vorgang_typ = 'WAE'
            and ok.li_nr = in_li_nr
            and ok.firma_nr = in_firma_nr
            and ok.sid = in_sid
            and ok.vorgang_id not in (
                select
                    op.vorgang_id
                from
                    isi_order_pos op
                where
                        op.li_nr = ok.li_nr
                    and op.vorgang_typ = 'WAE'
                    and op.vorgang_id = in_vorgang_id
                    and op.firma_nr = in_firma_nr
                    and op.sid = in_sid
            );

        update tms_kunden_auftr_pos t
        set
            t.status = 'N', -- dieser Kundenauftrag ist jetzt wieder neu
            t.aend_login_id = in_login_id,
            t.aend_datum = sysdate
        where
                t.kunden_auftr_pos_id = v_op_auf_id_extern
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid
            and t.status = 'B';

        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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

    end;

end tms_p_delivery;
/


-- sqlcl_snapshot {"hash":"f070b6f67d1447da702e1fd243d716d4047eaad7","type":"PACKAGE_BODY","name":"TMS_P_DELIVERY","schemaName":"DIRKSPZM32","sxml":""}