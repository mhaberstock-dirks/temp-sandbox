create or replace type body dirkspzm32.string_agg_cr_type is
    static function odciaggregateinitialize (
        sctx in out string_agg_cr_type
    ) return number is
    begin
        sctx := string_agg_cr_type(null,
                                   chr(13));
        return odciconst.success;
    end;

    member function odciaggregateiterate (
        self  in out string_agg_cr_type,
        value in varchar2
    ) return number is
    begin
        if ( nvl(
            length(self.total),
            0
        ) + length(def_delimiter) + nvl(
            length(value),
            0
        ) ) < 4000 then
            self.total := self.total
                          || def_delimiter
                          || value;
        end if;

        return odciconst.success;
    end;

    member function odciaggregateterminate (
        self        in string_agg_cr_type,
        returnvalue out varchar2,
        flags       in number
    ) return number is
    begin
        returnvalue := ltrim(self.total, def_delimiter);
        return odciconst.success;
    end;

    member function odciaggregatemerge (
        self in out string_agg_cr_type,
        ctx2 in string_agg_cr_type
    ) return number is
    begin
        if ( nvl(
            length(self.total),
            0
        ) + nvl(
            length(ctx2.total),
            0
        ) ) < 4000 then
            self.total := self.total || ctx2.total;
        end if;

        return odciconst.success;
    end;

end;
/


-- sqlcl_snapshot {"hash":"ab3b225fbca95867deff4819d40ea5cb9a5b588d","type":"TYPE_BODY","name":"STRING_AGG_CR_TYPE","schemaName":"DIRKSPZM32","sxml":""}