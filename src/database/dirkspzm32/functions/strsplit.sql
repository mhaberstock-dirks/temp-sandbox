create or replace 
function strsplit(p_list varchar2,
                                    p_del varchar2 := ';'
                                   ) return split_tbl pipelined is
  l_idx    pls_integer;
  l_list   varchar2(4000) := p_list;

  l_value  varchar2(4000);
begin
  loop
    l_idx := instr(l_list, p_del);
    if l_idx > 0
    then
      pipe row(substr(l_list, 1, l_idx - 1));
      l_list := substr(l_list, l_idx + length(p_del));
    else
      pipe row(l_list);
      exit;
    end if;
  end loop;

  return;
end strsplit;
/



-- sqlcl_snapshot {"hash":"e12163898af544eb2bb3109883f3949b87171023","type":"FUNCTION","name":"STRSPLIT","schemaName":"DIRKSPZM32","sxml":""}