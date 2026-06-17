create or replace 
function DIRKSPZM32.GET_PERS_MONAT_SOLL_STD(in_pers_nr in pzm_personal.pers_nr%type,
                                                   in_kst_id  in  pzm_ze_tagessatz.ts_day_kst_id%type,
                                                   in_datum   in  date
                                        ) return number is

  v_start_datum                         date;
  v_ende_datum                          date;
  v_unb_std                             number;

  CURSOR c_soll_std is
    select sum(t.ts_day_abw_std + t.ts_day_arb_std) soll
      from PZM_ZE_TAGESSATZ t
     where t.ts_pers_nr = in_pers_nr
       and t.ts_datum >= v_start_datum
       and t.ts_datum <= v_ende_datum
       and t.ts_day_kst_id = nvl(in_kst_id, t.ts_day_kst_id)
       and (isi_utils.Iso_WeekDay(t.ts_datum) not in (7) or isi_utils.Iso_WeekDay(t.ts_day_ist_ende) = 1); -- keinen Sontag außer Nachtschicht in den Montag
    
  CURSOR c_unb_std is
    select sum(t.ts_day_abw_std) unb
      from PZM_ZE_TAGESSATZ t,
           pzm_abwesenheitsarten aa, 
           pzm_lohnarten loa       
     where t.ts_pers_nr = in_pers_nr
       and t.ts_datum >= v_start_datum
       and t.ts_datum <= v_ende_datum
       and t.ts_day_kst_id = nvl(in_kst_id, t.ts_day_kst_id)
       and aa.aa_id = t.ts_aa_id 
       and aa.lz_id = loa.lz_id 
       and loa.lz_operator = 'UNB'
       and (isi_utils.Iso_WeekDay(t.ts_datum) not in (7) or isi_utils.Iso_WeekDay(t.ts_day_ist_ende) = 1);

  Result number;
begin
  v_start_datum := trunc(in_datum, 'MONTH');
  v_ende_datum :=  add_months(v_start_datum, 1) - 1;
  result := 0;
  OPEN c_soll_std;
  FETCH c_soll_std into Result;
  close c_soll_std;
  OPEN c_unb_std;
  FETCH c_unb_std into v_unb_std;
  close c_unb_std;
  Result := Result - nvl(v_unb_std, 0);
  return Result;
exception
  when others then
    return(NULL);
end GET_PERS_MONAT_SOLL_STD;
/



-- sqlcl_snapshot {"hash":"cd39817b1c7b95289d72367926ff91126fa7a85b","type":"FUNCTION","name":"GET_PERS_MONAT_SOLL_STD","schemaName":"DIRKSPZM32","sxml":""}