create or replace package body dirkspzm32.print_allg is

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

  --------------------------------------------------------------------------------
  -- Function gibt einen Druckedrdatensatz zurück
  --
  --------------------------------------------------------------------------------

    function get_drucker (
        in_sid          in pe_drucker_cfg.sid%type,
        in_firma_nr     in pe_drucker_cfg.firma_nr%type,
        in_drucker_name in pe_drucker_cfg.drucker_name%type,
        io_drucker      in out pe_drucker_cfg%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_drucker is
        select
            d.*
        from
            pe_drucker_cfg d
        where
                d.sid = in_sid
            and d.firma_nr = in_firma_nr
            and d.drucker_name = in_drucker_name;

    begin
        open c_drucker;
        fetch c_drucker into io_drucker;
        v_result := c_drucker%found;
        close c_drucker;
        return ( v_result );
    end;

  --------------------------------------------------------------------------------
  -- Function gibt einen Druckedrdatensatz zurück
  --
  --------------------------------------------------------------------------------

    function get_eti_drucker_typ (
        in_drucker_typ in pe_eti_drucker_typen.lp_type%type,
        io_drucker_typ in out pe_eti_drucker_typen%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_drucker_typ is
        select
            d.*
        from
            pe_eti_drucker_typen d
        where
            d.lp_type = in_drucker_typ;

    begin
        open c_drucker_typ;
        fetch c_drucker_typ into io_drucker_typ;
        v_result := c_drucker_typ%found;
        close c_drucker_typ;
        return ( v_result );
    end;

  --------------------------------------------------------------------------------
  -- Diese Funktion gibt ggf. ein Layoutmapping für einen Drucker zurück
  --------------------------------------------------------------------------------

    function get_drucker_layout_cfg (
        in_sid                in pe_drucker_layout_cfg.sid%type,
        in_firma_nr           in pe_drucker_layout_cfg.firma_nr%type,
        in_drucker_name       in pe_drucker_layout_cfg.drucker_name%type,
        in_layout_name        in pe_drucker_layout_cfg.src_layout_name%type,
        in_layout_datei       in pe_drucker_layout_cfg.src_layout_datei%type,
        io_drucker_layout_cfg in out pe_drucker_layout_cfg%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_drucker_layout_cfg is
        select
            t.*
        from
            pe_drucker_layout_cfg t
        where
                t.drucker_name = in_drucker_name
            and t.src_layout_name = in_layout_name
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

    begin
        open c_drucker_layout_cfg;
        fetch c_drucker_layout_cfg into io_drucker_layout_cfg;
        v_result := c_drucker_layout_cfg%found;
        close c_drucker_layout_cfg;
        return ( v_result );
    end;

end print_allg;
/


-- sqlcl_snapshot {"hash":"c99a3ee112e8be2aba51924351d7c4cd604642e6","type":"PACKAGE_BODY","name":"PRINT_ALLG","schemaName":"DIRKSPZM32","sxml":""}