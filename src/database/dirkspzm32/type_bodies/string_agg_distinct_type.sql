create or replace 
TYPE BODY DIRKSPZM32."STRING_AGG_DISTINCT_TYPE" is

  static function ODCIAggregateInitialize(sctx IN OUT string_agg_distinct_type) return number is
  begin
    sctx := string_agg_distinct_type(null, ';');
    return ODCIConst.Success;
  end;

  member function ODCIAggregateIterate(self IN OUT string_agg_distinct_type,
                                       value IN varchar2) return number is
  begin
    if value is not null
    then
      if instr(nvl(self.total, ' '), def_delimiter || value) = 0 --
      then
        -- nur wenn nicht vorhanden
        if (nvl(length(self.total), 0)
            + length(def_delimiter)
            + nvl(length(value), 0)) < 4000
        then
          self.total := nvl(self.total, '') || def_delimiter || value;
        end if;
      end if;
    end if;
    return ODCIConst.Success;
  end;

  member function ODCIAggregateTerminate(self IN string_agg_distinct_type,
                                         returnValue OUT varchar2,
                                         flags IN number) return number is
  begin
    returnValue := ltrim(self.total, def_delimiter);
    return ODCIConst.Success;
  end;

  member function ODCIAggregateMerge(self IN OUT string_agg_distinct_type,
                                     ctx2 IN string_agg_distinct_type) return number is
  begin
    if (length(self.total) + length(ctx2.total)) < 4000
    then
      self.total := self.total || ctx2.total;
    end if;
    return ODCIConst.Success;
  end;
end;
/



-- sqlcl_snapshot {"hash":"51737ff6c99bb74f9843c544eaee8e60f79ce54b","type":"TYPE_BODY","name":"STRING_AGG_DISTINCT_TYPE","schemaName":"DIRKSPZM32","sxml":""}