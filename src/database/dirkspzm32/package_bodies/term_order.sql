create or replace package body dirkspzm32.term_order is

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

end term_order;
/


-- sqlcl_snapshot {"hash":"78e4104aeeb12c0a45611f5cd597cffee69a0401","type":"PACKAGE_BODY","name":"TERM_ORDER","schemaName":"DIRKSPZM32","sxml":""}