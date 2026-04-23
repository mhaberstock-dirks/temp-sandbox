create or replace procedure dirkspzm32.sequence_newvalue_mhk (
    seqowner varchar2,
    seqname  varchar2,
    newvalue number
) as
    ln number;
    ib number;
begin
    select
        last_number,
        increment_by
    into
        ln,
        ib
    from
        all_sequences
    where
            sequence_owner = upper(seqowner)
        and sequence_name = upper(seqname);

    execute immediate 'ALTER SEQUENCE '
                      || seqowner
                      || '.'
                      || seqname
                      || ' INCREMENT BY '
                      || ( newvalue - ln );

    execute immediate 'SELECT '
                      || seqowner
                      || '.'
                      || seqname
                      || '.NEXTVAL FROM DUAL'
    into ln;
    execute immediate 'ALTER SEQUENCE '
                      || seqowner
                      || '.'
                      || seqname
                      || ' INCREMENT BY '
                      || ib;

end;
/


-- sqlcl_snapshot {"hash":"8a59ba9cb668a03737f408886e14d12c99e18033","type":"PROCEDURE","name":"SEQUENCE_NEWVALUE_MHK","schemaName":"DIRKSPZM32","sxml":""}