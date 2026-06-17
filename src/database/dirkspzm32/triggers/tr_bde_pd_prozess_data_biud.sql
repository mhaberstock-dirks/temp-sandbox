
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_PD_PROZESS_DATA_BIUD" 
  before insert or update or delete on DIRKSPZM32.bde_pd_prozess_data
  for each row
declare

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);

begin
  -- Init Fehlervariablen
  v_err_nr := NULL;
  v_err_text := NULL;

  if inserting
  then
    :new.created_date := sysdate;
    if :new.res_prozess_data_date is NULL
    then
      :new.res_prozess_data_date := sysdate;
    end if;
    if :new.id is NULL
    then
      :new.id := sys_guid();
    end if;
  elsif updating
  then
    :new.last_change_date := sysdate;
    if :new.id is NULL
    then
      :new.id := sys_guid();
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

end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_PD_PROZESS_DATA_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"193cdbaf71f66359840634f26822ffb00f5c7fe2","type":"TRIGGER","name":"TR_BDE_PD_PROZESS_DATA_BIUD","schemaName":"DIRKSPZM32","sxml":""}