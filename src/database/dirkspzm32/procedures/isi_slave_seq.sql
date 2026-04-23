create or replace procedure dirkspzm32.isi_slave_seq (
    in_seqname in varchar2,
    in_value   in number
) is
    v_seq      user_sequences%rowtype;
    slavevalue integer;
    v_my_sql   varchar2(512);
begin
 -- geht nicht immer Select SEQ_TEST_BW.currval into SlaveValue from dual;
    select
        seq.*
    into v_seq
    from
        user_sequences seq
    where
        seq.sequence_name = in_seqname;

    slavevalue := in_value - v_seq.last_number;
    if slavevalue <> 0 then
        v_my_sql := 'alter Sequence '
                    || in_seqname
                    || ' increment by '
                    || to_char(slavevalue)
                    || ' nocache';

        execute immediate v_my_sql;
        v_my_sql := 'declare '
                    || 'SlaveValue integer; '
                    || 'begin '
                    || 'select '
                    || in_seqname
                    || '.NextVal into SlaveValue from dual; '
                    || 'end;';

        execute immediate v_my_sql;
        v_my_sql := 'Alter Sequence '
                    || in_seqname
                    || ' increment by  '
                    || v_seq.increment_by;
        if v_seq.cache_size = 0 then
            v_my_sql := v_my_sql || ' nocache';
        else
            v_my_sql := v_my_sql
                        || ' cache '
                        || to_char(v_seq.cache_size);
        end if;

        execute immediate v_my_sql;
    end if;

end isi_slave_seq;
/


-- sqlcl_snapshot {"hash":"9e6c744d5c4c323ad48398c2857e612b5c3e05e7","type":"PROCEDURE","name":"ISI_SLAVE_SEQ","schemaName":"DIRKSPZM32","sxml":""}