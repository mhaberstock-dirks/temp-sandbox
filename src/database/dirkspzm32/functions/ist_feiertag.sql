create or replace 
function DIRKSPZM32.ist_feiertag(in_pers_nr in pzm_personal.pers_nr%type,
                                        in_pb_id            in pzm_produktionsbereiche.pb_id%type,
                                        in_abt_id           in pzm_abteilungen.abt_id%type,
                                        in_kst_id           in pzm_personal.pers_kst_id%type,
                                        in_datum            in date,
                                        out_sonder_feiertag out varchar2
) return integer is

  v_result integer;
  v_region_code isi_adressen.region_code%type;

  cursor c_feiertag is
    select f_sonder_feiertag

      from pzm_produktionsbereiche pb,
           isi_adressen ap,
           pzm_abteilungen abt,
           isi_adressen aa,
           isi_kostenstellen kst,
           isi_adressen akst,
           pzm_personal p,
           isi_feiertage f,
           table(strsplit(f.region_codes_csv, ';')) rc
     where pb.pb_id = in_pb_id
       and pb.pb_adress_id = ap.adress_id(+)
       and abt.abt_id = in_abt_id
       and abt.abt_adress_id = aa.adress_id(+)
       and kst.kst_nr(+) = nvl(in_kst_id, nvl(p.pers_kst_id, nvl(abt.abt_kst_id, pb.pb_kst_id)))
       and akst.adress_id(+) = kst.kst_adress_id
       and p.pers_nr = in_pers_nr
       and nvl(v_region_code, nvl(p.pers_region_code, nvl(akst.region_code, nvl(aa.region_code, nvl(ap.region_code, rc.column_value)))))  like rc.column_value || '%'
       and f.f_datum = trunc(in_datum)
     order by f_datum;
begin
  v_result := 0;
  if in_pb_id is NULL
  then
    begin
      select t.region_code
        into v_region_code
        from ISI_ADRESSEN t
       where t.adr_art ='E'
         and t.adr_nr = 1
         and t.adr_liefer = 0;
    exception
      when others then NULL;
    end;
  end if;  

  open c_feiertag;

  fetch c_feiertag into out_sonder_feiertag;
  if c_feiertag%found
  then
    v_result := 1;
  end if;
  close c_feiertag;

  return v_result;
end;
/



-- sqlcl_snapshot {"hash":"238c22f28df88663eb0b3a2aeec4d9228148c3e0","type":"FUNCTION","name":"IST_FEIERTAG","schemaName":"DIRKSPZM32","sxml":""}