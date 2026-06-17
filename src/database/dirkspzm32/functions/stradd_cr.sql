create or replace 
function DIRKSPZM32.stradd_cr(input in varchar2) return varchar2
parallel_enable aggregate using string_agg_cr_type;
/



-- sqlcl_snapshot {"hash":"93ff730138c2ff013c3b1e05040e0895dcb28e84","type":"FUNCTION","name":"STRADD_CR","schemaName":"DIRKSPZM32","sxml":""}