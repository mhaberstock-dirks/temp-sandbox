create or replace function dirkspzm32.isi_check_sequence
/*
  Test ermitttle Sequence
*/ (
    in_seq_name         in user_sequences.sequence_name%type,
    in_max_table_number in user_sequences.sequence_name%type
) return varchar2 is
    v_seq_last_number number;
begin
    v_seq_last_number := isi_get_seq_last_number(in_seq_name);
    if ( v_seq_last_number is null ) then
        return 'Sequence Not Found';
    end if;
    if ( in_max_table_number is null ) then
        return 'OK                '
               || '[SEQ] '
               || to_char(v_seq_last_number)
               || ' ,[TAB] '
               || 'Empty';
    end if;

    if ( v_seq_last_number >= in_max_table_number ) then
        return 'OK                '
               || '[SEQ] '
               || to_char(v_seq_last_number)
               || ' ,[TAB] '
               || to_char(in_max_table_number);
    else
        return 'KO Seq No [!!! SEQ anpassen !!!] '
               || '[SEQ] '
               || to_char(v_seq_last_number)
               || ' ,[TAB] '
               || to_char(in_max_table_number);
    end if;

end isi_check_sequence;
/


-- sqlcl_snapshot {"hash":"4230aa25eab618dab14089527a2ca02a9709333c","type":"FUNCTION","name":"ISI_CHECK_SEQUENCE","schemaName":"DIRKSPZM32","sxml":""}