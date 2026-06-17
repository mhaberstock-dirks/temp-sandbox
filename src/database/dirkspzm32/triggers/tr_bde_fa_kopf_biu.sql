
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_FA_KOPF_BIU" 
  before insert or update on DIRKSPZM32.BDE_FA_KOPF
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
  --:new.fa_nr := round(:new.fa_nr, 0);

  if updating
  then
    if  :old.status = 'N'
    and :new.status != 'N'
    then
      update pps_plan_auftrag t
         set t.status = 'B'
       where t.sid = :new.sid
         and t.firma_nr = :new.firma_nr
         and t.plan_auf_id = :new.fa_nr
         and (t.status = 'UBDE'
           or t.status = 'N'
           or t.status = 'T');
    end if;

    if  :new.status = 'F'
    then
      update pps_plan_auftrag t
         set t.status = 'F'
       where t.sid = :new.sid
         and t.firma_nr = :new.firma_nr
         and t.plan_auf_id = :new.fa_nr
         and t.status != 'FH';
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
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_FA_KOPF_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"a7324fd89e249e322c364493d1b0c4e5594bb768","type":"TRIGGER","name":"TR_BDE_FA_KOPF_BIU","schemaName":"DIRKSPZM32","sxml":""}