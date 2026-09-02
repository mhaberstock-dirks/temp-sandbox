create or replace 
TYPE "STRING_AGG_CR_TYPE" as object
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


-- sqlcl_snapshot {"hash":"5e70956a405637e0f5ad36a9d1d1fc4db4a2411f","type":"TYPE_SPEC","name":"STRING_AGG_CR_TYPE","schemaName":"DIRKSPZM32","sxml":""}