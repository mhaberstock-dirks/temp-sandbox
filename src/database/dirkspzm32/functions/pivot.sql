create or replace function dirkspzm32.pivot (
    p_stmt in varchar2,
    p_fmt  in varchar2 := 'upper(@p@)',
    dummy  in number := 0
) return anydataset
    pipelined
using pivotimpl;
/


-- sqlcl_snapshot {"hash":"c162fc987e632773af54f837ec68323b928e70c7","type":"FUNCTION","name":"PIVOT","schemaName":"DIRKSPZM32","sxml":""}