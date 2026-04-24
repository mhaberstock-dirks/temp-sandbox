create or replace type dirkspzm32.pivotimpl as object (
        ret_type anytype,      -- The return type of the table function
        stmt     varchar2(32767),
        fmt      varchar2(32767),
        cur      integer,
        static function odcitabledescribe (
               rtype  out anytype,
               p_stmt in varchar2,
               p_fmt  in varchar2 := 'upper(@p@)',
               dummy  in number := 0
           ) return number,
        static function odcitableprepare (
               sctx   out pivotimpl,
--                                   ti in sys.ODCITabFuncInfo,
               p_stmt in varchar2,
               p_fmt  in varchar2 := 'upper(@p@)',
               dummy  in number := 0
           ) return number,
        static function odcitablestart (
               sctx   in out pivotimpl,
               p_stmt in varchar2,
               p_fmt  in varchar2 := 'upper(@p@)',
               dummy  in number := 0
           ) return number,
        member function odcitablefetch (
               self   in out pivotimpl,
               nrows  in number,
               outset out anydataset
           ) return number,
        member function odcitableclose (
               self in pivotimpl
           ) return number
);
/


-- sqlcl_snapshot {"hash":"d111649f38d491aa9c0a1489ca0512b98bfb7cd3","type":"TYPE_SPEC","name":"PIVOTIMPL","schemaName":"DIRKSPZM32","sxml":""}