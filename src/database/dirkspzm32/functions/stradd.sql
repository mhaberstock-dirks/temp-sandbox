create or replace 
function stradd(input in varchar2) return varchar2
parallel_enable aggregate using string_agg_type;
/



-- sqlcl_snapshot {"hash":"83377fc47c595f6ecc13b2cf8e735f7817febf5d","type":"FUNCTION","name":"STRADD","schemaName":"DIRKSPZM32","sxml":""}