
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RES_SCHICHT_BI" 
  before insert on isi_res_schicht
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);

begin
  if :new.SCHICHT_ID is NULL then
    select seq_isi_res_schicht_id.nextval into :new.Schicht_ID from dual;
  end if;
  if :new.schicht_type = 'S' then -- Schicht
    :new.Parent_id := :new.Schicht_id;
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
end TR_ISI_RES_SCHICHT_BI;


/
ALTER TRIGGER "TR_ISI_RES_SCHICHT_BI" ENABLE;


-- sqlcl_snapshot {"hash":"cccf15f6ba29fe403450cb17223caff80d663372","type":"TRIGGER","name":"TR_ISI_RES_SCHICHT_BI","schemaName":"DIRKSPZM32","sxml":""}