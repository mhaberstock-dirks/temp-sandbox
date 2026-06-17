create or replace 
TYPE DIRKSPZM32."STRING_AGG_TYPE" as object
(
   total varchar2(4000),
   def_delimiter varchar2(1),

   static function
        ODCIAggregateInitialize(sctx IN OUT string_agg_type )
        return number,

   member function
        ODCIAggregateIterate(self IN OUT string_agg_type ,
                             value IN varchar2)
        return number,

   member function
        ODCIAggregateTerminate(self IN string_agg_type,
                               returnValue OUT  varchar2,
                               flags IN number)
        return number,

   member function
        ODCIAggregateMerge(self IN OUT string_agg_type,
                           ctx2 IN string_agg_type)
        return number
);
/


-- sqlcl_snapshot {"hash":"68372a39b57acd8a4ba3bc2749018c9ae3656171","type":"TYPE_SPEC","name":"STRING_AGG_TYPE","schemaName":"DIRKSPZM32","sxml":""}