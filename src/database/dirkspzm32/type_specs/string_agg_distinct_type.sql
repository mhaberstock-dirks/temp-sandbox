create or replace type dirkspzm32.string_agg_distinct_type as object (
        total         varchar2(4000),
        def_delimiter varchar2(1),
        static function odciaggregateinitialize (
               sctx in out string_agg_distinct_type
           ) return number,
        member function odciaggregateiterate (
               self  in out string_agg_distinct_type,
               value in varchar2
           ) return number,
        member function odciaggregateterminate (
               self        in string_agg_distinct_type,
               returnvalue out varchar2,
               flags       in number
           ) return number,
        member function odciaggregatemerge (
               self in out string_agg_distinct_type,
               ctx2 in string_agg_distinct_type
           ) return number
);
/


-- sqlcl_snapshot {"hash":"ad8a4326aabe1d8ba81f887e99693b002e7883a0","type":"TYPE_SPEC","name":"STRING_AGG_DISTINCT_TYPE","schemaName":"DIRKSPZM32","sxml":""}