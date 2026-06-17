create or replace 
procedure DIRKSPZM32.pzm_antr_urlaub_genehmigen(in_pers_nr in pzm_abwesenheits_antr.au_pers_nr%type,
                                                       in_au_begin in pzm_abwesenheits_antr.au_beginn%type,
                                                       in_pruef_pers_nr in pzm_abwesenheits_antr.au_pruef_pers_nr%type,
                                                       in_pruef_au_datum in pzm_abwesenheits_antr.au_datum%type
                                                      ) is
  v_schicht_tag date;
  v_result_code number;
  v_result_info varchar2(255);

  v_antr_urlaub pzm_abwesenheits_antr%rowtype;

  cursor c_antr_urlaub is
    select t.*
      from pzm_abwesenheits_antr t
     where t.au_pers_nr = in_pers_nr
       and t.au_beginn = in_au_begin
       and (t.au_datum = in_pruef_au_datum or (in_pruef_au_datum is NULL and t.au_status = 1)) ; -- 20170331 MW Anpassung an PK au_datum bzw. Antrag genehmigt und Status 1


  v_found boolean;
begin
  open c_antr_urlaub;
  fetch c_antr_urlaub into v_antr_urlaub;
  v_found := c_antr_urlaub%found;
  close c_antr_urlaub;

  if not v_found
  then
    return;
  end if;

  update pzm_abwesenheits_antr t
     set t.au_status = 1,
         t.au_pruef_pers_nr = in_pruef_pers_nr
   where t.au_pers_nr = in_pers_nr
     and t.au_beginn = in_au_begin
     and (t.au_datum = in_pruef_au_datum or (in_pruef_au_datum is NULL and t.au_status = 1)) ; -- 20170331 MW Anpassung an PK au_datum bzw. Antrag genehmigt und Status 1

/*
  v_schicht_tag := trunc(v_antr_urlaub.au_beginn);
  while v_schicht_tag <= trunc(v_antr_urlaub.au_ende)
        and v_schicht_tag < trunc(sysdate)
  loop
    -- Versuchen die Tage innerhalb des genehmigten Zeitraums nachträglich
    -- neu zu bewerten
    delete pzm_zeiterfassung t
     where t.ze_resource = v_antr_urlaub.au_pers_nr
       and t.ze_schicht_tag = v_schicht_tag
       and t.ze_korr_pers_nr is null
       and t.ze_ist_start is null
       and t.ze_ist_ende is null
       and t.ze_typ = 'A'
       and (t.ze_aa_status != v_antr_urlaub.au_abwes_art or t.ze_aa_status is null);

    update_pers_ze_tag(v_antr_urlaub.au_pers_nr, v_schicht_tag, v_result_code, v_result_info);

    v_schicht_tag := v_schicht_tag + 1;
  end loop;

  pzm_abwes_plan_vorbereiten(trunc(v_antr_urlaub.au_beginn), trunc(v_antr_urlaub.au_ende), v_antr_urlaub.au_pers_nr);
*/
  commit;
end;
/



-- sqlcl_snapshot {"hash":"79e2a8e55be7a1e29f750583a53d2986d086415c","type":"PROCEDURE","name":"PZM_ANTR_URLAUB_GENEHMIGEN","schemaName":"DIRKSPZM32","sxml":""}