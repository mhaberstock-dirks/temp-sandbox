
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_LAM_BIU" 
  before insert or update on DIRKSPZM32.lvs_lam
  for each row
declare
  -- local variables here
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(255);
begin
  if  :new.akt_inventur_id is not NULL
  and :new.order_pos_auf_id is not NULL
  then
    v_err_text := 'Fehler: Eine Inventur und die Reservierung für LHM: ' || :new.lhm_id || ' kann nicht gleichzeitig geschaltet werden.';
    v_err_nr := 10;
    raise v_error;
  end if;
  :new.lam_mhd := trunc(:new.lam_mhd);
  :new.lam_mhd_ausgabe := trunc(:new.lam_mhd_ausgabe);
  if :new.hersteller_kuerzel_liste = ';'
  then
    :new.hersteller_kuerzel_liste := NULL;
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
end tr_lvs_lam_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_LAM_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"145caff0da14bf877e0bfdf95ba3c7cd9b821ad4","type":"TRIGGER","name":"TR_LVS_LAM_BIU","schemaName":"DIRKSPZM32","sxml":""}