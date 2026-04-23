create or replace type dirkspzm32.string_agg_cr_type as object (
        total         varchar2(4000),
        def_delimiter varchar2(1),
        static function odciaggregateinitialize (
               sctx in out string_agg_cr_type
           ) return number,
        member function odciaggregateiterate (
               self  in out string_agg_cr_type,
               value in varchar2
           ) return number,
        member function odciaggregateterminate (
               self        in string_agg_cr_type,
               returnvalue out varchar2,
               flags       in number
           ) return number,
        member function odciaggregatemerge (
               self in out string_agg_cr_type,
               ctx2 in string_agg_cr_type
           ) return number
);
/


-- sqlcl_snapshot {"hash":"0537b2df328153433303ad762a713237e12365c6","type":"TYPE_SPEC","name":"STRING_AGG_CR_TYPE","schemaName":"DIRKSPZM32","sxml":""}