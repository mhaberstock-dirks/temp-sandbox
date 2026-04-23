create or replace package body dirkspzm32.fls_p_base is

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

end fls_p_base;
/


-- sqlcl_snapshot {"hash":"f39e9381b7901a54ff9dfcb582b2455506fb1e06","type":"PACKAGE_BODY","name":"FLS_P_BASE","schemaName":"DIRKSPZM32","sxml":""}