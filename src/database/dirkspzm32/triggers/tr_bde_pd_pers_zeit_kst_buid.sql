
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_PD_PERS_ZEIT_KST_BUID" 
  before insert or update or delete on DIRKSPZM32.BDE_PD_PERS_ZEIT_KST
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

  if not deleting
  then
    if :new.pd_pers_ende != to_date('31.12.3000', 'dd.mm.yyyy')
    then
      :new.pd_pers_zeit_min := (:new.pd_pers_ende - :new.pd_pers_beginn) * 1440;
    end if;
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
end TR_BDE_FA_AUFTRAG_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_PD_PERS_ZEIT_KST_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"f92f8642fb541c17ac0034e96ddbdd517fbca596","type":"TRIGGER","name":"TR_BDE_PD_PERS_ZEIT_KST_BUID","schemaName":"DIRKSPZM32","sxml":""}