create or replace 
package body DIRKSPZM32.fls_p_base is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);
  -------------------------------------------------------------------------------------------------------

  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  function get_version return varchar2 is
  begin
    return(v_version_str);
  end;

end fls_p_base;
/



-- sqlcl_snapshot {"hash":"6b8ef86ae1c18825866510f49166e1209f6987ba","type":"PACKAGE_BODY","name":"FLS_P_BASE","schemaName":"DIRKSPZM32","sxml":""}