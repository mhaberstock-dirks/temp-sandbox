create or replace 
function ISI_GET_SEQ_LAST_NUMBER
/*
  Test ermitttle Sequence
*/
(   in_seq_name        in user_sequences.sequence_name%type
)

return number is

v_seq_last_number number;

cursor c_seq is
    select t.last_number
      from user_sequences t
     where t.sequence_name = in_seq_name;

begin
  v_seq_last_number := null;
  open c_seq;
  fetch c_seq into v_seq_last_number;
  close c_seq;
  return v_seq_last_number;
end ISI_GET_SEQ_LAST_NUMBER;
/



-- sqlcl_snapshot {"hash":"1b75b632f62551ead4f00ece091ec80a7eb5d4de","type":"FUNCTION","name":"ISI_GET_SEQ_LAST_NUMBER","schemaName":"DIRKSPZM32","sxml":""}