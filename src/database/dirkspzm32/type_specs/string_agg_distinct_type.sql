create or replace 
TYPE "STRING_AGG_DISTINCT_TYPE" as object
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


-- sqlcl_snapshot {"hash":"2d2c1572c14a3cbf510fd1641c38011f2a530f42","type":"TYPE_SPEC","name":"STRING_AGG_DISTINCT_TYPE","schemaName":"DIRKSPZM32","sxml":""}