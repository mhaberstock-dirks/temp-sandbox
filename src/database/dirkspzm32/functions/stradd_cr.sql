create or replace function dirkspzm32.stradd_cr (
    input in varchar2
) return varchar2
    parallel_enable
aggregate using string_agg_cr_type;
/


-- sqlcl_snapshot {"hash":"2474fa866f0086762c203e3898cd857843ee1fa2","type":"FUNCTION","name":"STRADD_CR","schemaName":"DIRKSPZM32","sxml":""}