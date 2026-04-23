create or replace function dirkspzm32.stradd_distinct (
    input in varchar2
) return varchar2
    parallel_enable
aggregate using string_agg_distinct_type;
/


-- sqlcl_snapshot {"hash":"3da6012fbab99649ab1b948db469a7c484bf9235","type":"FUNCTION","name":"STRADD_DISTINCT","schemaName":"DIRKSPZM32","sxml":""}