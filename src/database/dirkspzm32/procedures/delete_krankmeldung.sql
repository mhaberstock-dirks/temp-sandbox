create or replace 
procedure DELETE_KRANKMELDUNG(p_km_id in number) is
begin
  DELETE FROM pzm_abwesenheitsmeldungen
   WHERE km_id = p_km_id;

  COMMIT;
end DELETE_KRANKMELDUNG;
/



-- sqlcl_snapshot {"hash":"ca825d2ab5a3ccf85b8624674dc9100cf312f577","type":"PROCEDURE","name":"DELETE_KRANKMELDUNG","schemaName":"DIRKSPZM32","sxml":""}