create or replace 
function stradd_distinct(input in varchar2) return varchar2
parallel_enable aggregate using string_agg_distinct_type;
/



-- sqlcl_snapshot {"hash":"e81e2718d7f7aa943de53335a8d20c1d12b345c4","type":"FUNCTION","name":"STRADD_DISTINCT","schemaName":"DIRKSPZM32","sxml":""}