create or replace 
function ISI_CHECK_SEQUENCE
/*
  Test ermitttle Sequence
*/
( in_seq_name                in user_sequences.sequence_name%type,
  in_max_table_Number        in user_sequences.sequence_name%type
)

return varchar2 is

v_seq_last_number number;

begin
  v_seq_last_number := ISI_GET_SEQ_LAST_NUMBER(in_seq_name);
  if (v_seq_last_number is null) then
    Return 'Sequence Not Found';
  end if;
  if (in_max_table_Number is null) then
    Return 'OK                ' || '[SEQ] ' || to_char(v_seq_last_number) || ' ,[TAB] ' || 'Empty';
  end if;
  if (v_seq_last_number >= in_max_table_Number) then
    Return 'OK                ' || '[SEQ] ' || to_char(v_seq_last_number) || ' ,[TAB] ' || to_char(in_max_table_Number);
  else
    Return 'KO Seq No [!!! SEQ anpassen !!!] ' || '[SEQ] ' || to_char(v_seq_last_number) || ' ,[TAB] ' || to_char(in_max_table_Number);
  end if;
end ISI_CHECK_SEQUENCE;
/



-- sqlcl_snapshot {"hash":"21a8eb0d3645015a81a2f7db7c744bb72d777358","type":"FUNCTION","name":"ISI_CHECK_SEQUENCE","schemaName":"DIRKSPZM32","sxml":""}