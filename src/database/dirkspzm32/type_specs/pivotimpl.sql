create or replace 
TYPE "PIVOTIMPL" as object
(
  ret_type anytype,      -- The return type of the table function
  stmt varchar2(32767),
  fmt  varchar2(32767),
  cur integer,

  static function ODCITableDescribe( rtype out anytype, p_stmt in varchar2, p_fmt in varchar2 := 'upper(@p@)', dummy in number := 0 )
  return number,

  static function ODCITablePrepare(sctx out PivotImpl,
--                                   ti in sys.ODCITabFuncInfo,
                                   p_stmt in varchar2,
                                   p_fmt in varchar2 := 'upper(@p@)',
                                   dummy in number := 0 )
  return number,

  static function ODCITableStart( sctx in out PivotImpl, p_stmt in varchar2, p_fmt in varchar2 := 'upper(@p@)', dummy in number := 0 )
  return number,

  member function ODCITableFetch( self in out PivotImpl, nrows in number, outset out anydataset )
  return number,
  member function ODCITableClose( self in PivotImpl )
  return number
);
/


-- sqlcl_snapshot {"hash":"e010b313b9fdab4d1990545bdefe35c5c4e4973f","type":"TYPE_SPEC","name":"PIVOTIMPL","schemaName":"DIRKSPZM32","sxml":""}