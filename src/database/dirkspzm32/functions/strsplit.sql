create or replace function dirkspzm32.strsplit (
    p_list varchar2,
    p_del  varchar2 := ';'
) return split_tbl
    pipelined
is
    l_idx   pls_integer;
    l_list  varchar2(4000) := p_list;
    l_value varchar2(4000);
begin
    loop
        l_idx := instr(l_list, p_del);
        if l_idx > 0 then
            pipe row ( substr(l_list, 1, l_idx - 1) );
            l_list := substr(l_list,
                             l_idx + length(p_del));
        else
            pipe row ( l_list );
            exit;
        end if;

    end loop;

    return;
end strsplit;
/


-- sqlcl_snapshot {"hash":"fa59fcbefc87403d1057f4c96a543bd6704e7903","type":"FUNCTION","name":"STRSPLIT","schemaName":"DIRKSPZM32","sxml":""}