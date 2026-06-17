create or replace 
package body DIRKSPZM32.pzm_P_PERS_ZEIT_KST is

  -- Function and procedure implementations
  procedure pzm_c_pd_pers_zeit_berech (in_sid                      in  pzm_ze_pers_kst_monat_ab.sid%type,
                                     in_firma_nr                 in  pzm_ze_pers_kst_monat_ab.firma_nr%type,
                                     in_datum                    in  pzm_ze_pers_kst_monat_ab.datum%type,
                                     in_loa                      in  pzm_ze_pers_kst_monat_ab.lohnart%type)
                                     is
    v_pers_nr                        pzm_ze_tagessatz.ts_pers_nr%type;
    v_kst                            pzm_ze_tagessatz.ts_day_kst_id%type;
    v_start_datum                    date;
    v_ende_datum                     date;
    v_std                            number;
    v_std_u                          number;
    v_std_b                          number;
    v_std_pause                        number;
    v_vert_kst                       bde_pd_pers_zeit_kst.pd_res_kst%type;
    v_vert_std                       number;
    v_vert_std_u                     number;

    v_pers_nr_std                    number;

  CURSOR c_pzm_ze_tagessatz is
    select t.ts_pers_nr,
           min(t.ts_day_kst_id) ts_day_kst,
           sum(t.ts_day_arb_std + t.ts_day_flex_std + t.ts_day_ueb_std + nvl(get_sum_loa_std(t.ts_pers_nr, t.ts_datum, '0111'),0)) std,
           sum(t.ts_day_pause_std) std_abw,
           min(nvl(t.ts_day_ist_start, t.ts_day_wert_start - 0.25)) start_date,
           max(nvl(t.ts_day_ist_ende, t.ts_day_wert_ende + 0.25)) ende_date
          from pzm_ze_tagessatz t
         where t.ts_datum >= trunc(in_datum, 'MONTH')
           and t.ts_datum <= last_day(in_datum)
    group by t.ts_pers_nr
    order by t.ts_pers_nr;

  CURSOR c_bde_pd_pers_zeit_kst is
    select t.pd_res_kst, sum(t.pd_pers_zeit_anteil_min / 60) std
      from bde_pd_pers_zeit_kst t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.pers_nr = v_pers_nr
         and  (    t.pd_pers_beginn >= v_start_datum
               and t.pd_pers_beginn < v_ende_datum
               and t.pd_pers_ende > v_start_datum
               and t.pd_pers_ende <= v_ende_datum
              )
         and t.pd_pers_ende != to_date('31.12.3000', 'dd.mm.yyyy')
     group by t.sid, t.firma_nr, t.pd_res_kst;

  CURSOR c_pzm_ze_pers_kst_monat_ab_sum is
    select t.pers_nr, sum(t.kst_std) kst_std
      from pzm_ze_pers_kst_monat_ab t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.datum = last_day(in_datum)
     group by t.sid, t.firma_nr, t.pers_nr;

  begin
    delete pzm_ze_pers_kst_monat_ab t
     where t.datum = last_day(in_datum);

    OPEN c_pzm_ze_tagessatz;
    LOOP
      FETCH c_pzm_ze_tagessatz into v_pers_nr, v_kst, v_std, v_std_pause, v_start_datum, v_ende_datum;
      EXIT when c_pzm_ze_tagessatz%NOTFOUND;
      v_std_b := v_std;
      v_std_u := v_std;
      OPEN c_bde_pd_pers_zeit_kst;
      LOOP
        FETCH c_bde_pd_pers_zeit_kst into v_vert_kst, v_vert_std;
        EXIT when c_bde_pd_pers_zeit_kst%NOTFOUND;

        if v_vert_kst != v_kst
        then
          v_vert_std_u := v_vert_std;
          if v_std_b > 0
          then
            v_vert_std := v_vert_std * v_std_b / (v_std_b + v_std_pause);
          end if;

          if v_vert_std > v_std
          then
            v_vert_std := v_std;
          end if;

          --dbms_output.put_line('V  ' || v_pers_nr || 'LOA' || in_loa || 'KST' || v_vert_kst);
          insert into pzm_ze_pers_kst_monat_ab
            values(in_sid,
                   in_firma_nr,
                   v_pers_nr,
                   in_loa,
                   last_day(in_datum),
                   nvl(v_vert_std, 0),
                   NULL,
                   v_vert_kst,
                   v_vert_std_u);
          v_std := v_std - v_vert_std;
          v_std_u := v_std_u - v_vert_std_u;

        end if;
      end LOOP;
      CLOSE c_bde_pd_pers_zeit_kst;
      --dbms_output.put_line('Ab ' || v_pers_nr || 'LOA' || in_loa || 'KST' || v_kst);
      insert into pzm_ze_pers_kst_monat_ab
        values(in_sid,
               in_firma_nr,
               v_pers_nr,
               in_loa,
               last_day(in_datum),
               nvl(v_std, 0),
               NULL,
               v_kst,
               NULL);
    end LOOP;
    CLOSE c_pzm_ze_tagessatz;
    commit;

    OPEN c_pzm_ze_pers_kst_monat_ab_sum;
    FETCH c_pzm_ze_pers_kst_monat_ab_sum into v_pers_nr, v_pers_nr_std;
    while c_pzm_ze_pers_kst_monat_ab_sum%FOUND
    LOOP
      update pzm_ze_pers_kst_monat_ab t
         set t.kst_proz = decode(v_pers_nr_std, 0, 100, t.kst_std / v_pers_nr_std * 100)
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.datum = last_day(in_datum)
         and t.pers_nr = v_pers_nr;
      commit;
      FETCH c_pzm_ze_pers_kst_monat_ab_sum into v_pers_nr, v_pers_nr_std;
    end LOOP;

    CLOSE c_pzm_ze_pers_kst_monat_ab_sum;
    commit;
  end;

end pzm_P_PERS_ZEIT_KST;
/



-- sqlcl_snapshot {"hash":"77c43db47842a4cf8785cf9df64c200dfb058445","type":"PACKAGE_BODY","name":"PZM_P_PERS_ZEIT_KST","schemaName":"DIRKSPZM32","sxml":""}