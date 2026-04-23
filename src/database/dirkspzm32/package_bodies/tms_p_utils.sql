create or replace package body dirkspzm32.tms_p_utils is

    v_build_number constant number := 1;
  /*
  *  Build history
  *  date       | version    | info
  *  ---------------------------------------------------------------------------------
  *  27.02.2009 | 3.4.10.1   | (-WK-) package created
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

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/
end tms_p_utils;
/


-- sqlcl_snapshot {"hash":"d85917f336cda74983b357c88bcfca26a2a8f0a8","type":"PACKAGE_BODY","name":"TMS_P_UTILS","schemaName":"DIRKSPZM32","sxml":""}