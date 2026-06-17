
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_APS_ERGEBNISINFO_BIU" 
  before insert or update on DIRKSPZM32.APS_ERGEBNISINFO
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

begin
  if inserting
  then
    :new.erstelltam := sysdate;
  end if;
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
end TR_APS_ERGEBNISINFO_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_APS_ERGEBNISINFO_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"885a42d860130d11642e4888fe6b56430f8ac894","type":"TRIGGER","name":"TR_APS_ERGEBNISINFO_BIU","schemaName":"DIRKSPZM32","sxml":""}