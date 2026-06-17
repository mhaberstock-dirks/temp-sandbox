create or replace 
TYPE BODY DIRKSPZM32."STRING_AGG_CR_TYPE" is

  static function ODCIAggregateInitialize(sctx IN OUT string_agg_cr_type) return number is
  begin
      sctx := string_agg_cr_type(null, chr(13));
      return ODCIConst.Success;
  end;

  member function ODCIAggregateIterate(self IN OUT string_agg_cr_type,
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

  member function ODCIAggregateTerminate(self IN string_agg_cr_type,
                                         returnValue OUT varchar2,
                                         flags IN number) return number is
  begin
    returnValue := ltrim(self.total, def_delimiter);
    return ODCIConst.Success;
  end;

  member function ODCIAggregateMerge(self IN OUT string_agg_cr_type,
                                     ctx2 IN string_agg_cr_type) return number is
  begin
    if (nvl(length(self.total), 0) + nvl(length(ctx2.total), 0)) < 4000
    then
      self.total := self.total || ctx2.total;
    end if;
    return ODCIConst.Success;
  end;
end;
/



-- sqlcl_snapshot {"hash":"e7876e7d287cc48ca6c5525a0a3fc20d4a3f6c41","type":"TYPE_BODY","name":"STRING_AGG_CR_TYPE","schemaName":"DIRKSPZM32","sxml":""}