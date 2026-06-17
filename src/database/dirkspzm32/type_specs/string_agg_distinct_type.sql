create or replace 
TYPE DIRKSPZM32."STRING_AGG_DISTINCT_TYPE" as object
(
   total varchar2(4000),
   def_delimiter varchar2(1),

   static function
        ODCIAggregateInitialize(sctx IN OUT string_agg_distinct_type )
        return number,

   member function
        ODCIAggregateIterate(self IN OUT string_agg_distinct_type ,
                             value IN varchar2)
        return number,

   member function
        ODCIAggregateTerminate(self IN string_agg_distinct_type,
                               returnValue OUT  varchar2,
                               flags IN number)
        return number,

   member function
        ODCIAggregateMerge(self IN OUT string_agg_distinct_type,
                           ctx2 IN string_agg_distinct_type)
        return number
);
/


-- sqlcl_snapshot {"hash":"d4d11fc87e618001849bce9f05262c7d7ecf2343","type":"TYPE_SPEC","name":"STRING_AGG_DISTINCT_TYPE","schemaName":"DIRKSPZM32","sxml":""}