create or replace 
procedure DIRKSPZM32.pzm_kst_id_neu_von_bis_datum(in_pers_nr in pzm_personal.pers_nr%type,
                                                         in_kst_id           in pzm_personal.pers_kst_id%type,
                                                         in_personal_aendern in number, -- Auch im Personalstamm ändern = 1
                                                         in_von_datum        in date,
                                                         in_bis_datum        in date) is
  v_datum                                                date;
  v_result                                               number;
  v_res_info                                             varchar2(500);
begin
  if in_personal_aendern = 1
  then
    update pzm_personal t
       set t.pers_kst_id = in_kst_id
     where t.pers_nr = in_pers_nr;
  end if;
  update pzm_zeiterfassung t
     set t.ze_kst_id = in_kst_id
   where t.ze_pers_nr = in_pers_nr
     and t.ze_schicht_tag >= nvl(in_von_datum, t.ze_schicht_tag)
     and t.ze_schicht_tag <= nvl(in_bis_datum, t.ze_schicht_tag);
  update pzm_ze_loa_ausw t
     set t.zeaw_kst_id = in_kst_id
   where t.zeaw_pers_nr = in_pers_nr
     and t.zeaw_datum >= nvl(in_von_datum, t.zeaw_datum)
     and t.zeaw_datum <= nvl(in_bis_datum, t.zeaw_datum);  
  v_datum := trunc(in_von_datum);
  loop
    update_pers_ze_tag (in_pers_nr,
                        v_datum,
                        v_result,
                        v_res_info,
                        0);
    v_datum := v_datum + 1;
    EXIT when v_datum > trunc(nvl(in_bis_datum, sysdate-1));
  end loop;                         
  commit;
end pzm_kst_id_neu_von_bis_datum;
/



-- sqlcl_snapshot {"hash":"8948bc9735abde7e70cdae1e97d1b12e87022d0a","type":"PROCEDURE","name":"PZM_KST_ID_NEU_VON_BIS_DATUM","schemaName":"DIRKSPZM32","sxml":""}