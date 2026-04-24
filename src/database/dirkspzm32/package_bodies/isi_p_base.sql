create or replace package body dirkspzm32.isi_p_base is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);

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

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end get_version;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_isi_firma (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        out_firma   out isi_firma%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_firma is
        select
            *
        from
            isi_firma t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr;

    begin
        out_firma := null;
        open c_firma;
        fetch c_firma into out_firma;
        v_found := c_firma%found;
        close c_firma;
        return ( v_found );
    end get_isi_firma;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_isi_artikel_kd (
        in_sid        in isi_sid.sid%type,
        in_artikel_id in isi_artikel_kunde.artikel_id%type,
        in_kundennr   in isi_artikel_kunde.kunden_nr%type,
        out_artikel   out isi_artikel_kunde%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_artikel_kd is
        select
            *
        from
            isi_artikel_kunde t
        where
                t.sid = in_sid
            and t.artikel_id = in_artikel_id
            and t.kunden_nr = in_kundennr;

    begin
        out_artikel := null;
        open c_artikel_kd;
        fetch c_artikel_kd into out_artikel;
        v_found := c_artikel_kd%found;
        close c_artikel_kd;
        return ( v_found );
    end get_isi_artikel_kd;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_isi_artikel (
        in_sid        in isi_sid.sid%type,
        in_artikel_id in isi_artikel.artikel_id%type,
        out_artikel   out isi_artikel%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_artikel is
        select
            *
        from
            isi_artikel t
        where
                t.sid = in_sid
            and t.artikel_id = in_artikel_id;

    begin
        out_artikel := null;
        open c_artikel;
        fetch c_artikel into out_artikel;
        v_found := c_artikel%found;
        close c_artikel;
        return ( v_found );
    end get_isi_artikel;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_isi_artikel_id_by_nr (
        in_sid         in isi_sid.sid%type,
        in_artikel     in isi_artikel.artikel%type,
        out_artikel_id out isi_artikel.artikel_id%type
    ) return boolean is

        v_found boolean;
        cursor c_artikel is
        select
            artikel_id
        from
            isi_artikel t
        where
                t.sid = in_sid
            and t.artikel = in_artikel;

    begin
        out_artikel_id := null;
        open c_artikel;
        fetch c_artikel into out_artikel_id;
        v_found := c_artikel%found;
   -- if v_found then
       --out_artikel_id := v_artikel_id;
   -- end if;
        close c_artikel;
        return ( v_found );
    end get_isi_artikel_id_by_nr;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_isi_artikel_nr_by_id (
        in_sid         in isi_sid.sid%type,
        in_artikel_id  in isi_artikel.artikel_id%type,
        out_artikel_nr out isi_artikel.artikel%type
    ) return boolean is

        v_found boolean;
        cursor c_artikel is
        select
            t.artikel
        from
            isi_artikel t
        where
                t.sid = in_sid
            and t.artikel_id = in_artikel_id;

    begin
        out_artikel_nr := null;
        open c_artikel;
        fetch c_artikel into out_artikel_nr;
        v_found := c_artikel%found;
   -- if v_found then
       --out_artikel_id := v_artikel_id;
   -- end if;
        close c_artikel;
        return ( v_found );
    end get_isi_artikel_nr_by_id;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_isi_artikel_by_nr (
        in_artikel_nr in isi_artikel.artikel%type,
        out_artikel   out isi_artikel%rowtype
    ) return boolean is
        v_found boolean;
        cursor c_artikel is
        select
            t.*
        from
            isi_artikel t
        where
            t.artikel = in_artikel_nr;

    begin
        out_artikel := null;
        open c_artikel;
        fetch c_artikel into out_artikel;
        v_found := c_artikel%found;
        close c_artikel;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_res_zust_akt (
        in_sid           in isi_sid.sid%type,
        in_res_id        in isi_resource.res_id%type,
        out_res_zust_akt out isi_resource_zust_akt%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_res_zust_akt is
        select
            t.*
        from
            isi_resource_zust_akt t
        where
                t.sid = in_sid
            and t.res_id = in_res_id;

    begin
        out_res_zust_akt := null;
        open c_res_zust_akt;
        fetch c_res_zust_akt into out_res_zust_akt;
        v_found := c_res_zust_akt%found;
        close c_res_zust_akt;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_res_lam_akt (
        in_sid          in isi_resource_lam_akt.sid%type,
        in_res_id       in isi_resource_lam_akt.res_id%type,
        in_artikel_id   in isi_resource_lam_akt.artikel_id%type,
        out_res_lam_akt out isi_resource_lam_akt%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_res_lam_akt is
        select
            t.*
        from
            isi_resource_lam_akt t
        where
                t.sid = in_sid
            and t.res_id = in_res_id
            and t.artikel_id = in_artikel_id;

    begin
        out_res_lam_akt := null;
        open c_res_lam_akt;
        fetch c_res_lam_akt into out_res_lam_akt;
        v_found := c_res_lam_akt%found;
        close c_res_lam_akt;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_resource (
        in_sid       in isi_sid.sid%type,
        in_res_id    in isi_resource.res_id%type,
        out_resource out isi_resource%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_resource is
        select
            t.*
        from
            isi_resource t
        where
                t.sid = in_sid
            and t.res_id = in_res_id;

    begin
        out_resource := null;
        open c_resource;
        fetch c_resource into out_resource;
        v_found := c_resource%found;
        close c_resource;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_resource_by_ext_name (
        in_res_ext_name in isi_resource.res_ext_name%type,
        out_resource    out isi_resource%rowtype
    ) return boolean is
        v_found boolean;
        cursor c_resource is
        select
            t.*
        from
            isi_resource t
        where
            t.res_ext_name = in_res_ext_name;

    begin
        out_resource := null;
        open c_resource;
        fetch c_resource into out_resource;
        v_found := c_resource%found;
        close c_resource;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_resource_by_name (
        in_res_name  in isi_resource.res_ext_name%type,
        out_resource out isi_resource%rowtype
    ) return boolean is
        v_found boolean;
        cursor c_resource is
        select
            t.*
        from
            isi_resource t
        where
            t.res_name = in_res_name;

    begin
        out_resource := null;
        open c_resource;
        fetch c_resource into out_resource;
        v_found := c_resource%found;
        close c_resource;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_scanner_by_res_id (
        in_sid      in isi_sid.sid%type,
        in_res_id   in isi_resource.res_id%type,
        out_scanner out isi_scanner_cfg%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_scanner is
        select
            t.*
        from
            isi_scanner_cfg t
        where
                t.sid = in_sid
            and t.res_id = in_res_id;

    begin
        out_scanner := null;
        open c_scanner;
        fetch c_scanner into out_scanner;
        v_found := c_scanner%found;
        close c_scanner;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_resource_zust_akt (
        in_sid                in isi_sid.sid%type,
        in_res_id             in isi_resource.res_id%type,
        out_resource_zust_akt out isi_resource_zust_akt%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_resource_zust_akt is
        select
            t.*
        from
            isi_resource_zust_akt t
        where
                t.sid = in_sid
            and t.res_id = in_res_id;

    begin
        out_resource_zust_akt := null;
        open c_resource_zust_akt;
        fetch c_resource_zust_akt into out_resource_zust_akt;
        v_found := c_resource_zust_akt%found;
        close c_resource_zust_akt;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_scanner (
        in_sid         in isi_sid.sid%type,
        in_scaner_name in isi_scanner_cfg.scanner_name%type,
        out_scanner    out isi_scanner_cfg%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_scanner is
        select
            t.*
        from
            isi_scanner_cfg t
        where
                t.sid = in_sid
            and t.scanner_name = in_scaner_name;

    begin
        out_scanner := null;
        open c_scanner;
        fetch c_scanner into out_scanner;
        v_found := c_scanner%found;
        close c_scanner;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_artikel_gruppe (
        in_sid           in isi_sid.sid%type,
        in_art_gruppe_id in isi_artikel_gruppe.art_gruppe_id%type,
        out_art_gruppe   out isi_artikel_gruppe%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_artikel_gruppe is
        select
            t.*
        from
            isi_artikel_gruppe t
        where
                t.sid = in_sid
            and t.art_gruppe_id = in_art_gruppe_id;

    begin
        open c_artikel_gruppe;
        fetch c_artikel_gruppe into out_art_gruppe;
        v_found := c_artikel_gruppe%found;
        close c_artikel_gruppe;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_artikel_ctrl (
        in_sid        in isi_sid.sid%type,
        in_artikel_id in isi_artikel_ctrl.artikel_id%type,
        in_zeichnung  in isi_artikel_ctrl.zeichnung%type,
        in_zindex     in isi_artikel_ctrl.zeichnung_index%type,
        in_leitzahl   in isi_artikel_ctrl.leitzahl%type,
        in_fa_ag      in isi_artikel_ctrl.fa_ag%type,
        out_art_ctrl  out isi_artikel_ctrl%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_artikel_ctrl is
        select
            t.*
        from
            isi_artikel_ctrl t
        where
                t.sid = in_sid
            and t.artikel_id = in_artikel_id
            and ( t.zeichnung = in_zeichnung
                  or in_zeichnung is null )
            and ( t.zeichnung_index = in_zindex
                  or ( in_zindex is null
                       and t.zeichnung_index is null ) )
            and ( t.leitzahl = in_leitzahl
                  or t.leitzahl is null )
            and ( t.fa_ag = in_fa_ag
                  or t.fa_ag is null );

    begin
        open c_artikel_ctrl;
        fetch c_artikel_ctrl into out_art_ctrl;
        v_found := c_artikel_ctrl%found;
        close c_artikel_ctrl;
        return ( v_found );
    end;

    function get_artikel_ctrl_typ (
        in_sid         in isi_sid.sid%type,
        in_artikel_id  in isi_artikel_ctrl.artikel_id%type,
        in_herstelle_k in isi_hersteller.kuerzel%type,
        out_art_ctrl   out isi_artikel_ctrl%rowtype
    ) return boolean is

        v_found       boolean;
        v_herstelle_k isi_hersteller.kuerzel%type;
        cursor c_artikel_ctrl is
        select
            t.*
        from
            isi_artikel_ctrl t
        where
                t.sid = in_sid
            and t.artikel_id = in_artikel_id
            and t.funktion = 'ISI_HERSTELLER_TYP'
            and t.param_wert = nvl(v_herstelle_k, t.param_wert);

    begin
        v_herstelle_k := in_herstelle_k;
        open c_artikel_ctrl;
        fetch c_artikel_ctrl into out_art_ctrl;
        v_found := c_artikel_ctrl%found;
        close c_artikel_ctrl;
        if
            not v_found
            and in_herstelle_k is not null
        then
            v_herstelle_k := null;  -- Wenn für Hersteller nicht gefunden dann eine allgemeinen Eintrag finden
            open c_artikel_ctrl;
            fetch c_artikel_ctrl into out_art_ctrl;
            v_found := c_artikel_ctrl%found;
            close c_artikel_ctrl;
        end if;

        return ( v_found );
    end;
  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_hersteller (
        in_herstelle_k in isi_hersteller.kuerzel%type,
        out_art_ctrl   out isi_hersteller%rowtype
    ) return boolean is
        v_found boolean;
        cursor c_hersteller is
        select
            t.*
        from
            isi_hersteller t
        where
            t.kuerzel = in_herstelle_k;

    begin
        open c_hersteller;
        fetch c_hersteller into out_art_ctrl;
        v_found := c_hersteller%found;
        close c_hersteller;
        return ( v_found );
    end;
  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_adresse (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_adressen.firma_nr%type,
        in_adr_art   in isi_adressen.adr_art%type,
        in_adr_nr    in isi_adressen.adr_nr%type,
        in_adr_lief  in isi_adressen.adr_liefer%type,
        out_adressen out isi_adressen%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_adr is
        select
            t.*
        from
            isi_adressen t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.adr_art = in_adr_art
            and t.adr_nr = in_adr_nr
            and t.adr_liefer = in_adr_lief;

    begin
        open c_adr;
        fetch c_adr into out_adressen;
        v_found := c_adr%found;
        close c_adr;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_adress_nr_by_id (
        in_sid        in isi_sid.sid%type,
        in_adress_id  in isi_adressen.adress_id%type,
        out_adress_nr out isi_adressen.adr_nr%type
    ) return boolean is

        v_found boolean;
        cursor c_adr is
        select
            t.adr_nr
        from
            isi_adressen t
        where
                t.sid = in_sid
            and t.adress_id = in_adress_id;

    begin
        open c_adr;
        fetch c_adr into out_adress_nr;
        v_found := c_adr%found;
        close c_adr;
        return ( v_found );
    end;

  -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
    function get_adress_next_lfdn_id (
        in_sid                   in isi_sid.sid%type,
        in_adress_id             in isi_adressen.adress_id%type,
        out_nummernkreis_aktuell out isi_adressen.lte_lhm_nummernkreis_aktuell%type
    ) return boolean is

        v_adr   isi_adressen%rowtype;
        v_found boolean;
        cursor c_adr is
        select
            t.*
        from
            isi_adressen t
        where
                t.sid = in_sid
            and t.adress_id = in_adress_id;

        pragma autonomous_transaction;
    begin
        open c_adr;
        fetch c_adr into v_adr;
        v_found := c_adr%found;
        close c_adr;
        if v_found then
            if v_adr.lte_lhm_nummernkreis_von > v_adr.lte_lhm_nummernkreis_aktuell
            or v_adr.lte_lhm_nummernkreis_bis <= v_adr.lte_lhm_nummernkreis_aktuell then
                raise_isi_error(10,
                                lc.ec(lc.o_txt_id_leangenueberlauf));
            end if;

            update isi_adressen t
            set
                t.lte_lhm_nummernkreis_aktuell = t.lte_lhm_nummernkreis_aktuell + 1
            where
                    t.sid = in_sid
                and t.adress_id = in_adress_id
            returning t.lte_lhm_nummernkreis_aktuell into out_nummernkreis_aktuell;

        end if;

        commit;
        return ( v_found );
    end;

end isi_p_base;
/


-- sqlcl_snapshot {"hash":"ddef6525c0f5a765625329e2d3b0ebe41a3fb294","type":"PACKAGE_BODY","name":"ISI_P_BASE","schemaName":"DIRKSPZM32","sxml":""}