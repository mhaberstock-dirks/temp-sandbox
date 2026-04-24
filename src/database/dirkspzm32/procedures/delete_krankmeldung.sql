create or replace procedure dirkspzm32.delete_krankmeldung (
    p_km_id in number
) is
begin
    delete from pzm_abwesenheitsmeldungen
    where
        km_id = p_km_id;

    commit;
end delete_krankmeldung;
/


-- sqlcl_snapshot {"hash":"1ef776199c373465b2a44bc42f4841ca7f1966db","type":"PROCEDURE","name":"DELETE_KRANKMELDUNG","schemaName":"DIRKSPZM32","sxml":""}