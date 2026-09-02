create or replace 
function pivot( p_stmt in varchar2, p_fmt in varchar2 := 'upper(@p@)', dummy in number := 0 )
return anydataset pipelined using PivotImpl;
/



-- sqlcl_snapshot {"hash":"5d0b6faba48a068d266ad2477be10dc72c64dd4e","type":"FUNCTION","name":"PIVOT","schemaName":"DIRKSPZM32","sxml":""}