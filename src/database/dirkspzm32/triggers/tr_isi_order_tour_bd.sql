
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_TOUR_BD" 
  before delete on DIRKSPZM32.isi_order_tour
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

begin
  delete isi_order_pos t
   where t.vorgang_id = :old.vorgang_id;
  delete isi_order_kopf t
   where t.vorgang_id = :old.vorgang_id;
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
end tr_isi_order_kopf_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_TOUR_BD" ENABLE;


-- sqlcl_snapshot {"hash":"8616ad10a43c719cf37ff7ee3df35a2a005d58cc","type":"TRIGGER","name":"TR_ISI_ORDER_TOUR_BD","schemaName":"DIRKSPZM32","sxml":""}