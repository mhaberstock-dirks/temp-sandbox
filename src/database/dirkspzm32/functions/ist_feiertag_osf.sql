create or replace 
function ist_feiertag_osf(in_pers_nr in pzm_personal.pers_nr%type,
                                            in_pb_id            in pzm_produktionsbereiche.pb_id%type,
                                            in_abt_id           in pzm_abteilungen.abt_id%type,
                                            in_kst_id           in pzm_personal.pers_kst_id%type,
                                            in_datum            in date
) return integer is
  v_feiertag     varchar2(20);
begin
  return ist_feiertag(in_pers_nr,
                      in_pb_id,
                      in_abt_id,
                      in_kst_id,
                      in_datum,
                      v_feiertag);
end;
/



-- sqlcl_snapshot {"hash":"fbfc23443f585866a14eebf23f5342786309a6c1","type":"FUNCTION","name":"IST_FEIERTAG_OSF","schemaName":"DIRKSPZM32","sxml":""}