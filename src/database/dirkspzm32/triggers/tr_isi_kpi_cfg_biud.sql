
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_KPI_CFG_BIUD" 
  before insert or update on DIRKSPZM32.ISI_KPI_CFG
  for each row
declare
  -- local variables here
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler-Variablen für eine Exception
  -------------------------------------------------------------------------------------------------------
  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

begin
  -- Erst mal kein Fehler
  v_err_nr   := null;
  v_err_text := null;

  if INSERTING then
    if :new.created_date is NULL
    then
      :new.created_date := sysdate;
    end if;
    if :new.created_login_id is NULL
    then
      :new.created_login_id := -1;
    end if;
  elsif UPDATING
  then
    if :new.last_change_date = :old.last_change_date
    or :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
  elsif DELETING then
    NULL;
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
end tr_ISI_KPI_CFG_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_KPI_CFG_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"088a0119a1d7dfe27d79dfc98d36bebd2e923a40","type":"TRIGGER","name":"TR_ISI_KPI_CFG_BIUD","schemaName":"DIRKSPZM32","sxml":""}