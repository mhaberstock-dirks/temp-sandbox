create or replace 
function DIRKSPZM32.get_anz_arbeitstage_R32(p_pers_nr in integer,
                                                   p_start_datum    in date,
                                                   p_ende_datum     in date) 
  return number is
  Result number(15, 1);

  i             integer;
  tage          integer;
  v_SAKurzname  varchar2(10);
  v_SABeginn    date;
  v_SAEnde      date;
  v_SAStdProTag number(4, 2);

  v_Datum          date;
  v_DayOfWeek      integer;
  v_SonderFeiertag varchar2(20);
  v_isFeiertag boolean;
  
  v_pers_nr number;
  v_pb_id number;
  v_abt_id number;
  v_kst_id number;
  v_aa_id number;
  cursor c_ts_krank_o_unb is
    select t.ts_aa_id from pzm_ze_tagessatz t
    where t.ts_pers_nr = p_pers_nr
      and t.ts_datum = v_Datum
      and t.ts_aa_id in (select x1.aa_id 
                           from pzm_abwesenheitsarten x1,
                                pzm_lohnarten x2
                                 where x1.aa_id = t.ts_aa_id
                                   and x1.lz_id = x2.lz_id
                                   and x2.lz_operator in ('K', 'KUGK', 'UNB'));
  
  cursor c_pers is
    select t.pers_nr,
           t.pers_pb_id,
           t.pers_abt_id,
           t.pers_kst_id
      from pzm_personal t
     where t.pers_nr = p_pers_nr;
  
begin
  Result := 0;

  open c_pers;
  fetch c_pers into v_pers_nr, v_pb_id, v_abt_id, v_kst_id;
  close c_pers;

  if v_kst_id is NULL
  then
    v_kst_id := get_pers_kst_id(v_pers_nr);
  end if;
  if v_pb_id is NULL
  then
    v_pb_id := get_pers_pb_id(v_pers_nr);
  end if;
  

  tage := (trunc(p_ende_datum) - trunc(p_start_datum));
  for i in 0 .. tage loop
    v_Datum      := p_start_datum + i;
    v_SAKurzname := NULL;

    if get_schicht_daten(p_pers_nr,
                         v_Datum,
                         v_Datum,
                         v_SAKurzname,
                         v_SABeginn,
                         v_SAEnde,
                         v_SAStdProTag) = 1 
    then
      v_isFeiertag := ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_Datum, v_SonderFeiertag) = 1;
      v_aa_id := NULL;
      if v_isFeiertag
      then
        OPEN c_ts_krank_o_unb;
        FETCH c_ts_krank_o_unb into v_aa_id;
        CLOSE c_ts_krank_o_unb;
        if v_aa_id is not NULL
        then
          v_isFeiertag := false;
        end if;
      end if;
      
      if not v_isFeiertag
         and v_SAKurzname <> pzm_utils.get_standard_schicht_by_pers_nr(v_pers_nr)
         and v_SAStdProTag > 0
      then
        Result := Result + 1.0;
        -- DKr - F90080-107 - Heiligabend und Silvester sind in DE halbe Feiertage -> halbe Urlaubstage moglich
      elsif v_isFeiertag
        and (v_SAKurzname <> pzm_utils.get_standard_schicht_by_pers_nr(v_pers_nr) or v_SAStdProTag = 0)
        and (to_char(v_Datum, 'dd.mm.') = '24.12.' or to_char(v_Datum, 'dd.mm.') = '31.12.')
      then
        Result := Result + 0.5;
      end if;
    else
      -- wenn keine Schichtdaten vohanden sind, nehmen wir die 5 Werktage Woche
      --v_DayOfWeek := to_number(to_char(v_Datum, 'D')); -- INFO: 1 = Mo, 2 = Di, ...
      v_DayOfWeek := isi_utils.Iso_WeekDay(v_Datum);-- INFO: 1 = Mo, 2 = Di, ...
      
      if (v_DayOfWeek >= 1) AND (v_DayOfWeek <= 5) then
        if ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_Datum, v_SonderFeiertag) = 0 then
          Result := Result + 1.0;
          -- DKr - F90080-107 - Heiligabend und Silvester sind in DE halbe Feiertage -> halbe Urlaubstage moglich
        elsif ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_Datum, v_SonderFeiertag) = 1 and
              (to_char(v_Datum, 'dd.mm.') = '24.12.' or
               to_char(v_Datum, 'dd.mm.') = '31.12.') then
          Result := Result + 0.5;
        end if;
      end if;
    end if;
  end loop;
  return(Result); 
end;
/



-- sqlcl_snapshot {"hash":"51e8a78b64f95a35f0ed8eda35aff421e4ba6540","type":"FUNCTION","name":"GET_ANZ_ARBEITSTAGE_R32","schemaName":"DIRKSPZM32","sxml":""}