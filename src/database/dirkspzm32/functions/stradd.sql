create or replace function dirkspzm32.stradd (
    input in varchar2
) return varchar2
    parallel_enable
aggregate using string_agg_type;
/


-- sqlcl_snapshot {"hash":"1cca766e146aa4f9645249ac6d836721cf8d36ee","type":"FUNCTION","name":"STRADD","schemaName":"DIRKSPZM32","sxml":""}