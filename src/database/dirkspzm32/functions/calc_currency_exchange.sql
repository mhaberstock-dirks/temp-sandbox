create or replace 
function DIRKSPZM32.calc_currency_exchange(
  in_source_currency in varchar2,               --# Source currency to lookup currency rates
  in_target_currency in varchar2,               --# Target currency to lookup currency rates
  in_source_value in number,                    --# Original value for source currency
  in_exchange_base_date in date default sysdate --# (optional) base date to select valid currency rate
  ) return number is                            --# Calculated value for target currency
------------------------------------------------------------------------------------------------
--# Helper function to calculate currency value by defined exchange rated
--# ---- HISTORY ---
--# 2013-09-11: (wkroeker) function created due to requirement in project 6039
------------------------------------------------------------------------------------------------

  v_Result number;
  v_CurrencyExchangeRate number;
  
begin
  v_Result := null;
  v_CurrencyExchangeRate := get_currency_rate(in_source_currency,
    in_target_currency, in_exchange_base_date);
    
  if v_CurrencyExchangeRate is not null
  then
    v_Result := in_source_value / v_CurrencyExchangeRate;
  end if;
  return(v_Result);
end;
/



-- sqlcl_snapshot {"hash":"6359dbc6093e5966dfaec478ae745d418cc928df","type":"FUNCTION","name":"CALC_CURRENCY_EXCHANGE","schemaName":"DIRKSPZM32","sxml":""}