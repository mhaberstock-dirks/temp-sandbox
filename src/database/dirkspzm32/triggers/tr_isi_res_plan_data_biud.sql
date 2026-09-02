
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RES_PLAN_DATA_BIUD" 
  before insert or update or delete on ISI_RES_PLAN_DATA
  for each row
declare

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);
  
  v_res       isi_resource%rowtype;

  
begin
  -- Init Fehlervariablen
  v_err_nr := NULL;
  v_err_text := NULL;
  
  if inserting
  then
    if :new.sm_name is NULL
    then
      if not isi_p_base.get_resource(:new.sid, :new.res_id, v_res)
      then
        v_err_nr := 10;
        v_err_text := lc.ec_p1(lc.O_TP1_RESOURCE_FEHLT, to_char(:new.res_id));
        raise v_error;
      end if;
      :new.arbeitszeitmodellnr := 'R' || v_res.res_name;
    end if;
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
ALTER TRIGGER "TR_ISI_RES_PLAN_DATA_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"066cb9ddfa1f06e0c54aa22f2c0f381d46c2206e","type":"TRIGGER","name":"TR_ISI_RES_PLAN_DATA_BIUD","schemaName":"DIRKSPZM32","sxml":""}