create or replace 
procedure DIRKSPZM32.DELETE_KRANKMELDUNG(p_km_id in number) is
begin
  DELETE FROM pzm_abwesenheitsmeldungen
   WHERE km_id = p_km_id;

  COMMIT;
end DELETE_KRANKMELDUNG;
/



-- sqlcl_snapshot {"hash":"07247e010b4771b091557376764150bfaded26f0","type":"PROCEDURE","name":"DELETE_KRANKMELDUNG","schemaName":"DIRKSPZM32","sxml":""}