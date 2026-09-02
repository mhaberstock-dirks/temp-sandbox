
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RES_MAG_CFG_BIUD" 
  before insert or update or delete on ISI_RES_MAG_CFG
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
  elsif updating
  then
    :new.last_change_date := sysdate;
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

end tr_LVS_INVENTUR_JOB_KOPF_BIUD;


/
ALTER TRIGGER "TR_ISI_RES_MAG_CFG_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"b854ceb8ecc5f68b5d6848daf81ae4a2a68a9415","type":"TRIGGER","name":"TR_ISI_RES_MAG_CFG_BIUD","schemaName":"DIRKSPZM32","sxml":""}