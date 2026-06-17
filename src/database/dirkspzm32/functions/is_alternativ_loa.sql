create or replace 
function DIRKSPZM32.IS_ALTERNATIV_LOA(in_loa in pzm_lohnarten.lz_id%type) return boolean is
  Result boolean;
  v_Lohnart pzm_lohnarten.lz_id%TYPE;
  v_AltLOA pzm_lohnarten.lz_alternativ_loa_id%TYPE;

  CURSOR c_lohnarten IS
    select lz_lohnart, lz_alternativ_loa_id
      from pzm_lohnarten t
     where lz_alternativ_loa_id = in_loa;
begin
  Result := false;
  OPEN c_lohnarten;

  FETCH c_lohnarten INTO v_Lohnart, v_AltLOA;
  Result := c_lohnarten%FOUND;
  CLOSE c_lohnarten;

  return(Result);
end IS_ALTERNATIV_LOA;
/



-- sqlcl_snapshot {"hash":"9587b1046880aa48375a591c7d000a03f7b45fa2","type":"FUNCTION","name":"IS_ALTERNATIV_LOA","schemaName":"DIRKSPZM32","sxml":""}