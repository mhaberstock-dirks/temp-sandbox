create or replace function dirkspzm32.isi_get_seq_last_number
/*
  Test ermitttle Sequence
*/ (
    in_seq_name in user_sequences.sequence_name%type
) return number is
    v_seq_last_number number;
    cursor c_seq is
    select
        t.last_number
    from
        user_sequences t
    where
        t.sequence_name = in_seq_name;

begin
    v_seq_last_number := null;
    open c_seq;
    fetch c_seq into v_seq_last_number;
    close c_seq;
    return v_seq_last_number;
end isi_get_seq_last_number;
/


-- sqlcl_snapshot {"hash":"0560a59a464b0997295361d33f0e823de2cec8d0","type":"FUNCTION","name":"ISI_GET_SEQ_LAST_NUMBER","schemaName":"DIRKSPZM32","sxml":""}