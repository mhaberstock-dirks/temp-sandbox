create or replace function dirkspzm32.z_nls_testing return varchar2 is
    functionresult varchar2(255 char);
begin
    functionresult := 'Hällööö Wörld';
    return ( functionresult );
end z_nls_testing;
/


-- sqlcl_snapshot {"hash":"a196e47463f92455aba88228b3a8665c37670782","type":"FUNCTION","name":"Z_NLS_TESTING","schemaName":"DIRKSPZM32","sxml":""}