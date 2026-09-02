create or replace 
function stradd_cr(input in varchar2) return varchar2
parallel_enable aggregate using string_agg_cr_type;
/



-- sqlcl_snapshot {"hash":"eb8b9e54bd39c67e42ad6bdf33ad717d5a0051df","type":"FUNCTION","name":"STRADD_CR","schemaName":"DIRKSPZM32","sxml":""}