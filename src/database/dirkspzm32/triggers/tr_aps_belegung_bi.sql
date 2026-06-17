
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_APS_BELEGUNG_BI" 
  before insert on DIRKSPZM32.aps_belegung
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

begin
  if :new.ressourcentyp = 1           -- Typ Maschine
  then
    update aps_fa_vorgangs_position t
       set t.plan_res_name = :new.ressourcennr
        where t.fakopfnr = :new.fakopfnr
          and t.favorgangsnr = :new.favorgangsnr
          and nvl(t.favorgangsalternative, -1) = nvl(:new.favorgangsalternative, -1)
          and t.favorgangssplittnr = :new.favorgangssplittnr
          and t.plan_res_name is NULL;
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
ALTER TRIGGER "DIRKSPZM32"."TR_APS_BELEGUNG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"cc828e31e574ee1ece2526ba51e6bde9f096435b","type":"TRIGGER","name":"TR_APS_BELEGUNG_BI","schemaName":"DIRKSPZM32","sxml":""}