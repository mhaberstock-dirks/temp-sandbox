create or replace 
TYPE BODY DIRKSPZM32."STRING_AGG_TYPE" is

  static function ODCIAggregateInitialize(sctx IN OUT string_agg_type) return number is
  begin
    sctx := string_agg_type(null, ';');
    return ODCIConst.Success;
  end;

  member function ODCIAggregateIterate(self IN OUT string_agg_type,
                                       value IN varchar2) return number is
  begin
    if (nvl(length(self.total), 0)
        + length(def_delimiter)
        + nvl(length(value), 0)) < 4000
    then
      self.total := self.total || def_delimiter || value;
    end if;
    return ODCIConst.Success;
  end;

  member function ODCIAggregateTerminate(self IN string_agg_type,
                                         returnValue OUT varchar2,
                                         flags IN number) return number is
  begin
    returnValue := ltrim(self.total, def_delimiter);
    return ODCIConst.Success;
  end;

  member function ODCIAggregateMerge(self IN OUT string_agg_type,
                                     ctx2 IN string_agg_type) return number is
  begin
    if (length(self.total) + length(ctx2.total)) < 4000
    then
      self.total := self.total || ctx2.total;
    end if;
    return ODCIConst.Success;
  end;
end;
/



-- sqlcl_snapshot {"hash":"bbc8d9dfcdbae94a671251f904a051bfcd00833c","type":"TYPE_BODY","name":"STRING_AGG_TYPE","schemaName":"DIRKSPZM32","sxml":""}