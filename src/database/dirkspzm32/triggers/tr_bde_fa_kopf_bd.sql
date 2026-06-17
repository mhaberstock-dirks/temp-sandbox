
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_FA_KOPF_BD" 
  before delete on DIRKSPZM32.BDE_FA_KOPF
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  -- local variables here
begin
  delete bde_fa_auftrag t
    where t.sid = :old.sid
      and t.firma_nr = :old.firma_nr
      and t.leitzahl = :old.fa_nr;


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
end TR_BDE_FA_AUFTRAG_BD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_FA_KOPF_BD" ENABLE;


-- sqlcl_snapshot {"hash":"60c508773b35970ca460da95331a6f4d675fc75a","type":"TRIGGER","name":"TR_BDE_FA_KOPF_BD","schemaName":"DIRKSPZM32","sxml":""}