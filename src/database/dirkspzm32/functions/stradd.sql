create or replace 
function DIRKSPZM32.stradd(input in varchar2) return varchar2
parallel_enable aggregate using string_agg_type;
/



-- sqlcl_snapshot {"hash":"82bae4a49a639f2de4a37d509dc5d42d7d99e8b4","type":"FUNCTION","name":"STRADD","schemaName":"DIRKSPZM32","sxml":""}