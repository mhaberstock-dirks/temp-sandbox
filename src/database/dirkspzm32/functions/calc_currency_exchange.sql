create or replace function dirkspzm32.calc_currency_exchange (
    in_source_currency    in varchar2,               --# Source currency to lookup currency rates
    in_target_currency    in varchar2,               --# Target currency to lookup currency rates
    in_source_value       in number,                    --# Original value for source currency
    in_exchange_base_date in date default sysdate --# (optional) base date to select valid currency rate
) return number is                            --# Calculated value for target currency
------------------------------------------------------------------------------------------------
--# Helper function to calculate currency value by defined exchange rated
--# ---- HISTORY ---
--# 2013-09-11: (wkroeker) function created due to requirement in project 6039
------------------------------------------------------------------------------------------------

    v_result               number;
    v_currencyexchangerate number;
begin
    v_result := null;
    v_currencyexchangerate := get_currency_rate(in_source_currency, in_target_currency, in_exchange_base_date);
    if v_currencyexchangerate is not null then
        v_result := in_source_value / v_currencyexchangerate;
    end if;
    return ( v_result );
end;
/


-- sqlcl_snapshot {"hash":"4cfeb1820df463ea2059d2f1173e1aabd533c99b","type":"FUNCTION","name":"CALC_CURRENCY_EXCHANGE","schemaName":"DIRKSPZM32","sxml":""}