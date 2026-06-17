
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_KPI_BIUD" 
  before insert or update on DIRKSPZM32.isi_kpi
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

    if :new.wert_intervall_datum is not NULL -- Initial alle Refresh-Daten setzen
    then
      if :new.wert_intervall_next is NULL
      or :new.wert_intervall_next < :new.wert_intervall_datum
      then
        :new.wert_intervall_next := :new.wert_intervall_datum; -- Initial setzen wenn NULL
      end if;
      LOOP
        EXIT when :new.wert_intervall_next > sysdate;
        :new.wert_intervall_datum := :new.wert_intervall_next;
        :new.wert_intervall_next := :new.wert_intervall_datum + :new.wert_intervall_sek / 86400; -- nächsten Aufruf neu setzen
      end LOOP;
    else
      if :new.wert_intervall_next is NULL
      or :new.wert_intervall_next < sysdate
      then
        :new.wert_intervall_next := sysdate; -- Initial setzen
      end if;
      LOOP
        EXIT when :new.wert_intervall_next > sysdate;
        :new.wert_intervall_next := :new.wert_intervall_next + :new.wert_intervall_sek / 86400; -- nächsten Aufruf neu setzen
      end LOOP;
    end if;

  elsif UPDATING
  then
    if :new.wert_datum != :old.wert_datum
    or :new.wert_kpi_aktuell != :old.wert_kpi_aktuell
    then
      :new.wert_kpi_letzter := :old.wert_kpi_aktuell;
      if :new.wert_datum = :old.wert_datum
      then
        :new.wert_datum := sysdate;
      end if;
    end if;
    if :new.last_change_date = :old.last_change_date
    or :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;

    if :new.wert_datum >= :new.wert_intervall_next    -- Nächster Intervall muss berechnet werden
    or :new.wert_intervall_next is NULL               -- Interwalldatum nicht gesetzt
    then
      if :new.wert_intervall_datum is not NULL        -- Initial alle Refresh-Daten setzen
      then
        if :new.wert_intervall_next is NULL
        or :new.wert_intervall_next < :new.wert_intervall_datum
        then
          :new.wert_intervall_next := :new.wert_intervall_datum; -- Initial setzen wenn NULL
        end if;
        LOOP
          EXIT when :new.wert_intervall_next > sysdate and :new.wert_intervall_next > :new.wert_datum;
          :new.wert_intervall_datum := :new.wert_intervall_next;
          :new.wert_intervall_next := :new.wert_intervall_datum + :new.wert_intervall_sek / 86400; -- nächsten Aufruf neu setzen
        end LOOP;
      else
        if :new.wert_intervall_next is NULL
        or :new.wert_intervall_next < sysdate
        then
          :new.wert_intervall_next := sysdate; -- Initial setzen
        end if;
        LOOP
          EXIT when :new.wert_intervall_next > sysdate;
          :new.wert_intervall_next := :new.wert_intervall_next + :new.wert_intervall_sek / 86400; -- nächsten Aufruf neu setzen
        end LOOP;
      end if;
    end if;
  elsif DELETING then
    NULL;
  end if;
  if :new.wert_datum is NULL
  then
    :new.wert_datum := sysdate;
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
end tr_ISI_KPI_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_KPI_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"c30fb68891c03e552b7e8b7f0499dec56bd6993d","type":"TRIGGER","name":"TR_ISI_KPI_BIUD","schemaName":"DIRKSPZM32","sxml":""}