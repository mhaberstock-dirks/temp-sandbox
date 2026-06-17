create or replace 
TYPE DIRKSPZM32."STRING_AGG_CR_TYPE" as object
(
   total varchar2(4000),
   def_delimiter varchar2(1),

   static function
        ODCIAggregateInitialize(sctx IN OUT string_agg_cr_type )
        return number,

   member function
        ODCIAggregateIterate(self IN OUT string_agg_cr_type ,
                             value IN varchar2)
        return number,

   member function
        ODCIAggregateTerminate(self IN string_agg_cr_type,
                               returnValue OUT  varchar2,
                               flags IN number)
        return number,

   member function
        ODCIAggregateMerge(self IN OUT string_agg_cr_type,
                           ctx2 IN string_agg_cr_type)
        return number
);
/


-- sqlcl_snapshot {"hash":"36e4417accbb682e27b7fa33dc1fd6a3705b812d","type":"TYPE_SPEC","name":"STRING_AGG_CR_TYPE","schemaName":"DIRKSPZM32","sxml":""}