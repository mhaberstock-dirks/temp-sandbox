
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_CURRENCY_BIUD" 
  before insert or update or delete on DIRKSPZM32.ISI_CURRENCY
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
  or updating
  then
    if :new.base_currency is NULL
    then
      select t.waehrung into :new.base_currency
        from isi_adressen t
       where t.sid = :new.sid
         and t.firma_nr = :new.firma_nr
         and t.adr_art = 'E'
         and t.adr_nr = :new.firma_nr
         and t.adr_liefer = '0';
    end if;
    if :new.currency is NULL
    then
      select t.waehrung into :new.currency
        from isi_adressen t
       where t.sid = :new.sid
         and t.firma_nr = :new.firma_nr
         and t.adr_art = 'E'
         and t.adr_nr = :new.firma_nr
         and t.adr_liefer = '0';
    end if;
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
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_CURRENCY_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"811940dabc36ca0a44b5581d071d2eb7469e6174","type":"TRIGGER","name":"TR_ISI_CURRENCY_BIUD","schemaName":"DIRKSPZM32","sxml":""}