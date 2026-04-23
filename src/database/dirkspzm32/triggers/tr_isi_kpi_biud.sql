create or replace editionable trigger dirkspzm32.tr_isi_kpi_biud before
    insert or update on dirkspzm32.isi_kpi
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
    v_err_nr := null;
    v_err_text := null;
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        if :new.created_login_id is null then
            :new.created_login_id := -1;
        end if;

        if :new.wert_intervall_datum is not null -- Initial alle Refresh-Daten setzen

         then
            if :new.wert_intervall_next is null
               or :new.wert_intervall_next < :new.wert_intervall_datum then
                :new.wert_intervall_next := :new.wert_intervall_datum; -- Initial setzen wenn NULL
            end if;

            loop
                exit when :new.wert_intervall_next > sysdate;
                :new.wert_intervall_datum := :new.wert_intervall_next;
                :new.wert_intervall_next := :new.wert_intervall_datum + :new.wert_intervall_sek / 86400; -- nächsten Aufruf neu setzen
            end loop;

        else
            if :new.wert_intervall_next is null
               or :new.wert_intervall_next < sysdate then
                :new.wert_intervall_next := sysdate; -- Initial setzen
            end if;

            loop
                exit when :new.wert_intervall_next > sysdate;
                :new.wert_intervall_next := :new.wert_intervall_next + :new.wert_intervall_sek / 86400; -- nächsten Aufruf neu setzen
            end loop;

        end if;

    elsif updating then
        if :new.wert_datum != :old.wert_datum
        or :new.wert_kpi_aktuell != :old.wert_kpi_aktuell then
            :new.wert_kpi_letzter := :old.wert_kpi_aktuell;
            if :new.wert_datum = :old.wert_datum then
                :new.wert_datum := sysdate;
            end if;

        end if;

        if :new.last_change_date = :old.last_change_date
        or :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;

        if :new.wert_datum >= :new.wert_intervall_next    -- Nächster Intervall muss berechnet werden
        or :new.wert_intervall_next is null               -- Interwalldatum nicht gesetzt
         then
            if :new.wert_intervall_datum is not null        -- Initial alle Refresh-Daten setzen
             then
                if :new.wert_intervall_next is null
                   or :new.wert_intervall_next < :new.wert_intervall_datum then
                    :new.wert_intervall_next := :new.wert_intervall_datum; -- Initial setzen wenn NULL
                end if;

                loop
                    exit when
                        :new.wert_intervall_next > sysdate
                        and :new.wert_intervall_next > :new.wert_datum;

                    :new.wert_intervall_datum := :new.wert_intervall_next;
                    :new.wert_intervall_next := :new.wert_intervall_datum + :new.wert_intervall_sek / 86400; -- nächsten Aufruf neu setzen
                end loop;

            else
                if :new.wert_intervall_next is null
                   or :new.wert_intervall_next < sysdate then
                    :new.wert_intervall_next := sysdate; -- Initial setzen
                end if;

                loop
                    exit when :new.wert_intervall_next > sysdate;
                    :new.wert_intervall_next := :new.wert_intervall_next + :new.wert_intervall_sek / 86400; -- nächsten Aufruf neu setzen
                end loop;

            end if;
        end if;

    elsif deleting then
        null;
    end if;

    if :new.wert_datum is null then
        :new.wert_datum := sysdate;
    end if;

exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
        if v_err_nr is not null then
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
        end if;
end tr_isi_kpi_biu;
/

alter trigger dirkspzm32.tr_isi_kpi_biud enable;


-- sqlcl_snapshot {"hash":"5b72777c34f9848fbaa5822eb341ab70208e46ec","type":"TRIGGER","name":"TR_ISI_KPI_BIUD","schemaName":"DIRKSPZM32","sxml":""}