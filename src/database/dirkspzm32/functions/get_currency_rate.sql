create or replace function dirkspzm32.get_currency_rate (
    in_source_currency    in varchar2,               --# Source currency to lookup currency rates
    in_target_currency    in varchar2,               --# Target currency to lookup currency rates
    in_exchange_base_date in date default sysdate --# (optional) base date to select valid currency rate
) return number is                            --# Valid currency exchange rate within the defined base date
------------------------------------------------------------------------------------------------
--# Helper function to retrieve currency exchange rate
--# ---- HISTORY ---
--# 2013-09-11: (wkroeker) function created due to requirement in project 6039
------------------------------------------------------------------------------------------------
    v_result number;
    cursor c_currency_exchange_rate is
    select
        cur.wechselkurs
    from
        isi_currency cur
    where
            cur.currency = in_source_currency
        and cur.base_currency = in_target_currency
        and cur.valide_date <= in_exchange_base_date
    order by
        cur.valide_date desc;

begin
    v_result := null;
    open c_currency_exchange_rate;
    fetch c_currency_exchange_rate into v_result;
    close c_currency_exchange_rate;
    return ( v_result );
end;
/


-- sqlcl_snapshot {"hash":"524e3827a1a6c07b2f5327f5a692609ff41ef4fd","type":"FUNCTION","name":"GET_CURRENCY_RATE","schemaName":"DIRKSPZM32","sxml":""}