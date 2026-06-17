create or replace 
function DIRKSPZM32.pivot( p_stmt in varchar2, p_fmt in varchar2 := 'upper(@p@)', dummy in number := 0 )
return anydataset pipelined using PivotImpl;
/



-- sqlcl_snapshot {"hash":"193bda25c97a082af027cf223bc5662383ee3a48","type":"FUNCTION","name":"PIVOT","schemaName":"DIRKSPZM32","sxml":""}