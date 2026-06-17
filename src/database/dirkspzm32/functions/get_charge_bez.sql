create or replace 
function DIRKSPZM32.get_charge_bez(in_sid in isi_sid.sid%type,
                                          in_firma             in isi_firma.firma_nr%type)
                                         return varchar2 is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_parameter_wert                   varchar2(40);
  v_charge_bez lvs_charge.charge_bez%type;

begin
  -- Erst prüfen ob für diese Chargenbezeichnung bereits eine Charge existiert
  -- falls nicht, dann wird diese angelegt
  v_charge_bez := NULL;
  v_parameter_wert := isi_allg.c_get_firma_cfg_param (in_sid,
                                                      in_firma,
                                                      'CFG',                                -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                      NULL,                                 -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                      'CHARGE_FORMAT',                      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                      'CFG',                                -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                      'CFG',                                -- in_typ                   in isi_firma_cfg.typ%type,
                                                      'fehlt',                              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                      'STRING');                            -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type
  if v_parameter_wert = 'DATEJULIANISCH'
  then
    v_charge_bez := to_char(sysdate, 'YYDDD');
  end if;
  return(v_charge_bez);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end get_charge_bez;
/



-- sqlcl_snapshot {"hash":"1d4abdce0296256c5625aba5139ff9942b360ebf","type":"FUNCTION","name":"GET_CHARGE_BEZ","schemaName":"DIRKSPZM32","sxml":""}