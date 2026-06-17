create or replace 
function DIRKSPZM32.stradd_distinct(input in varchar2) return varchar2
parallel_enable aggregate using string_agg_distinct_type;
/



-- sqlcl_snapshot {"hash":"60b9bac8b92078d4fa6f2245b116ae2f31229647","type":"FUNCTION","name":"STRADD_DISTINCT","schemaName":"DIRKSPZM32","sxml":""}