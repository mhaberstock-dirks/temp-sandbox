create or replace 
function DIRKSPZM32.PZM_GET_ABT_ZU_PERS_NR(in_pers_nr in number)
  return varchar2 is
  Result                   varchar2(4096);
  v_abteilung              pzm_abteilungen%rowtype;
  v_produktionsbereich     pzm_produktionsbereiche%rowtype;
  v_personal               pzm_personal%rowtype;
  v_abt_leitung            pzm_abt_leitung%rowtype;
  
  CURSOR c_personal IS
    SELECT *
      FROM pzm_personal p
     WHERE p.pers_nr = in_pers_nr;

  CURSOR c_abteilung IS
    SELECT *
      FROM pzm_abteilungen a
     WHERE a.abt_id = v_personal.pers_abt_id;
     
  CURSOR c_produktionsbereich IS
    SELECT *
      FROM pzm_produktionsbereiche pb
     WHERE pb.pb_id = nvl(v_personal.pers_pb_id, v_abteilung.abt_pb_id);

  CURSOR c_abt_leitung IS
    SELECT *
      FROM pzm_abt_leitung al
     WHERE al.abt_l_pers_nr = in_pers_nr;
     
begin
  OPEN c_personal;
  FETCH c_personal INTO v_personal;
  CLOSE c_personal;

  OPEN c_abteilung;
  FETCH c_abteilung INTO v_abteilung;
  CLOSE c_abteilung;

  OPEN c_produktionsbereich;
  FETCH c_produktionsbereich INTO v_produktionsbereich;
  CLOSE c_produktionsbereich;

  OPEN c_abt_leitung;
  FETCH c_abt_leitung INTO v_abt_leitung;
  CLOSE c_abt_leitung;

  Result := v_abteilung.abt_name;

  -- Eigene Abteilung ist die Zuständige Personalabteilung
  -- Oder über die Hirachie und Leitungsfunktion 
  select ';' || stradd_distinct(res.abt_id) || ';' into result
  from
    ( 
      select a.abt_id
        from pzm_abteilungen a
       where a.abt_pb_id = v_produktionsbereich.pb_id
         and nvl(a.abt_personal_abt_id, v_produktionsbereich.pb_personal_abt_id) = v_abteilung.abt_id 
      Union
      select a.abt_id 
        from pzm_abteilungen a
        start with a.abt_id = v_abt_leitung.abt_l_abt_id
        connect by prior a.abt_id = a.abt_parent_abt_id
    ) res;
  
  return(Result);
end PZM_GET_ABT_ZU_PERS_NR;
/



-- sqlcl_snapshot {"hash":"7c891a0cdd03bdb6eb71b800d74e9f81fc609d1a","type":"FUNCTION","name":"PZM_GET_ABT_ZU_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}