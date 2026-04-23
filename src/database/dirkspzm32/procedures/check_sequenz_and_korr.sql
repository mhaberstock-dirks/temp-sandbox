create or replace procedure dirkspzm32.check_sequenz_and_korr (
    in_seq_owner varchar2
) as

    v_isi_seq    v_isi_check_sequences%rowtype;
    cursor c_isi_check_sequences is
    select
        *
    from
        v_isi_check_sequences t
    where
        t.seq_tab_werte not like 'OK%';

    v_seq_lastnr number;
    v_seq_maxval number;
    v_tab_max_nr number; --max Wert der Tabelle
    v_seq_value  number;
    v_sel_seq    varchar2(255);
    v_length     number;
begin
    open c_isi_check_sequences;
    loop
        fetch c_isi_check_sequences into v_isi_seq;
        exit when c_isi_check_sequences%notfound;
        v_seq_value := isi_get_seq_last_number(v_isi_seq.seq_name_); -- aktuellen Wert der Sequenz ermitteln
        v_tab_max_nr := get_max_index(
            upper(v_isi_seq.table_name_),
            upper(v_isi_seq.field_name_)
        ); --max Wert der Tabelle ermitteln

        if
            v_seq_value < v_tab_max_nr
            and v_seq_value is not null
        then
            dbms_output.put_line('SEQ-Value: '
                                 || v_seq_value
                                 || ',  TAB-max-Value: ' || v_tab_max_nr);

      /*
      Zuerst das MAX VALUE der Sequenz setzen wenn dies nötig ist
      Es ist vorgekommen dass der last_number > max_value war, dann muss max_value korrigiert werden
      wenn die Zahl (z.B. 235.678) z.B. 6 Zeichen enthält dann (1*10**6)-1, und die max_value wäre 1.000.000 - 1 = 999.999
      */
      --v_SEL_SEQ := 'SELECT t.last_number FROM USER_SEQUENCES t WHERE SEQUENCE_NAME = ' || '''' || v_isi_seq.SEQ_Name_ || '''' ;
      --execute immediate v_SEL_SEQ into v_SEQ_lastnr;

      --Korrektur DTs20201204
      --Denn Wert von Max. value des Sequenz ermitteln
            v_sel_seq := 'SELECT t.max_value FROM USER_SEQUENCES t WHERE SEQUENCE_NAME = '
                         || ''''
                         || v_isi_seq.seq_name_
                         || '''';
            execute immediate v_sel_seq
            into v_seq_maxval;
      -- prüfen ob der SEQ-Max value kleiner als der ermittelte und zu setzende Tabellenwert ist
            if v_seq_maxval < v_tab_max_nr then
                v_length := length(to_char(v_tab_max_nr));
                v_seq_maxval := 1 * ( 10**v_length ) - 1;
                dbms_output.put_line('SEQ-max Value: ' || v_seq_maxval);
        -- Korrektur des MAXVALUE der Sequence
                execute immediate 'ALTER SEQUENCE '
                                  || in_seq_owner
                                  || '.'
                                  || v_isi_seq.seq_name_
                                  || ' MAXVALUE '
                                  || v_seq_maxval;

            end if;

      -- Erst dann die Werte setzen
            execute immediate 'ALTER SEQUENCE '
                              || in_seq_owner
                              || '.'
                              || v_isi_seq.seq_name_
                              || ' INCREMENT BY '
                              || ( v_tab_max_nr - v_seq_value );

            execute immediate 'SELECT '
                              || in_seq_owner
                              || '.'
                              || v_isi_seq.seq_name_
                              || '.NEXTVAL FROM DUAL'
            into v_seq_value;

            execute immediate 'ALTER SEQUENCE '
                              || in_seq_owner
                              || '.'
                              || v_isi_seq.seq_name_
                              || ' INCREMENT BY 1';
            execute immediate 'SELECT '
                              || in_seq_owner
                              || '.'
                              || v_isi_seq.seq_name_
                              || '.NEXTVAL FROM DUAL'
            into v_seq_value;

        end if;

    end loop;

    close c_isi_check_sequences;
end;
/


-- sqlcl_snapshot {"hash":"e74f38bbea2cbad83f7179cea6b5177222fda11a","type":"PROCEDURE","name":"CHECK_SEQUENZ_AND_KORR","schemaName":"DIRKSPZM32","sxml":""}