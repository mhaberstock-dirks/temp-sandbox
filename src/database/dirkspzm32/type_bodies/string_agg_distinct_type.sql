create or replace type body dirkspzm32.string_agg_distinct_type is
    static function odciaggregateinitialize (
        sctx in out string_agg_distinct_type
    ) return number is
    begin
        sctx := string_agg_distinct_type(null, ';');
        return odciconst.success;
    end;

    member function odciaggregateiterate (
        self  in out string_agg_distinct_type,
        value in varchar2
    ) return number is
    begin
        if value is not null then
            if instr(
                nvl(self.total, ' '),
                def_delimiter || value
            ) = 0 --
             then
        -- nur wenn nicht vorhanden
                if ( nvl(
                    length(self.total),
                    0
                ) + length(def_delimiter) + nvl(
                    length(value),
                    0
                ) ) < 4000 then
                    self.total := nvl(self.total, '')
                                  || def_delimiter
                                  || value;

                end if;

            end if;
        end if;

        return odciconst.success;
    end;

    member function odciaggregateterminate (
        self        in string_agg_distinct_type,
        returnvalue out varchar2,
        flags       in number
    ) return number is
    begin
        returnvalue := ltrim(self.total, def_delimiter);
        return odciconst.success;
    end;

    member function odciaggregatemerge (
        self in out string_agg_distinct_type,
        ctx2 in string_agg_distinct_type
    ) return number is
    begin
        if ( length(self.total) + length(ctx2.total) ) < 4000 then
            self.total := self.total || ctx2.total;
        end if;

        return odciconst.success;
    end;

end;
/


-- sqlcl_snapshot {"hash":"fb717fca17cab7a75a8332dab499f641d2e8226f","type":"TYPE_BODY","name":"STRING_AGG_DISTINCT_TYPE","schemaName":"DIRKSPZM32","sxml":""}