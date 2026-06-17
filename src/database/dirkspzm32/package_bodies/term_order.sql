create or replace 
package body DIRKSPZM32.term_order is

  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr   := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
  function get_version return varchar2 is
	begin
		return(v_version_str);
	end;

end term_order;
/



-- sqlcl_snapshot {"hash":"81544ad0125bb7ae86b5a78fcd558e337bfa7c77","type":"PACKAGE_BODY","name":"TERM_ORDER","schemaName":"DIRKSPZM32","sxml":""}