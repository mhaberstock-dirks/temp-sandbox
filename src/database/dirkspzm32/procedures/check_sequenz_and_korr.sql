create or replace 
PROCEDURE DIRKSPZM32.CHECK_SEQUENZ_AND_KORR(in_SEQ_owner varchar2) AS
  v_isi_seq                 v_isi_check_sequences%rowtype;

  cursor c_isi_check_sequences is
    select *
      from v_isi_check_sequences t
     where t.SEQ_TAB_Werte not like 'OK%';

  v_SEQ_lastnr        number;
  v_SEQ_maxval        number;
  v_TAB_max_nr        number; --max Wert der Tabelle
  v_SEQ_value         number;
  v_SEL_SEQ           varchar2(255);
  v_length            number;

begin

  open c_isi_check_sequences;
  loop
    fetch c_isi_check_sequences into v_isi_seq;
    exit when c_isi_check_sequences%NOTFOUND;

    v_SEQ_value   := ISI_GET_SEQ_LAST_NUMBER(v_isi_seq.SEQ_Name_); -- aktuellen Wert der Sequenz ermitteln
    v_TAB_max_nr  := get_max_index(upper(v_isi_seq.table_name_), upper(v_isi_seq.field_name_)); --max Wert der Tabelle ermitteln

    if v_SEQ_value < v_TAB_max_nr and v_SEQ_value is not null then
       dbms_output.put_line('SEQ-Value: ' || v_SEQ_value || ',  TAB-max-Value: '||v_TAB_max_nr);

      /*
      Zuerst das MAX VALUE der Sequenz setzen wenn dies nötig ist
      Es ist vorgekommen dass der last_number > max_value war, dann muss max_value korrigiert werden
      wenn die Zahl (z.B. 235.678) z.B. 6 Zeichen enthält dann (1*10**6)-1, und die max_value wäre 1.000.000 - 1 = 999.999
      */
      --v_SEL_SEQ := 'SELECT t.last_number FROM USER_SEQUENCES t WHERE SEQUENCE_NAME = ' || '''' || v_isi_seq.SEQ_Name_ || '''' ;
      --execute immediate v_SEL_SEQ into v_SEQ_lastnr;

      --Korrektur DTs20201204
      --Denn Wert von Max. value des Sequenz ermitteln
      v_SEL_SEQ := 'SELECT t.max_value FROM USER_SEQUENCES t WHERE SEQUENCE_NAME = ' || '''' || v_isi_seq.SEQ_Name_ || '''' ;
      execute immediate v_SEL_SEQ into v_SEQ_maxval;
      -- prüfen ob der SEQ-Max value kleiner als der ermittelte und zu setzende Tabellenwert ist
      if v_SEQ_maxval < v_TAB_max_nr then
        v_length := length(to_char(v_TAB_max_nr));
        v_SEQ_maxval := 1*(10**v_length)-1;
        dbms_output.put_line('SEQ-max Value: ' || v_SEQ_maxval);
        -- Korrektur des MAXVALUE der Sequence
        execute immediate 'ALTER SEQUENCE ' || in_SEQ_owner || '.' || v_isi_seq.SEQ_Name_ || ' MAXVALUE ' || v_SEQ_maxval ;
      end if;

      -- Erst dann die Werte setzen
      execute immediate 'ALTER SEQUENCE ' || in_SEQ_owner || '.' || v_isi_seq.SEQ_Name_ || ' INCREMENT BY ' || (v_TAB_max_nr - v_SEQ_value);
      execute immediate 'SELECT ' || in_SEQ_owner || '.' || v_isi_seq.SEQ_Name_ || '.NEXTVAL FROM DUAL' into v_SEQ_value;
      execute immediate 'ALTER SEQUENCE ' || in_SEQ_owner || '.' || v_isi_seq.SEQ_Name_ || ' INCREMENT BY 1';
      execute immediate 'SELECT ' || in_SEQ_owner || '.' || v_isi_seq.SEQ_Name_ || '.NEXTVAL FROM DUAL' into v_SEQ_value;

    end if;
  end loop;
  close c_isi_check_sequences;
end;
/



-- sqlcl_snapshot {"hash":"e0aa26d4aebbe4755dbf2b0385c98a25fe353aa1","type":"PROCEDURE","name":"CHECK_SEQUENZ_AND_KORR","schemaName":"DIRKSPZM32","sxml":""}