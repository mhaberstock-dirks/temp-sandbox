create or replace 
procedure DIRKSPZM32.c_gen_all_arb_plan is
  -- Local variables here
  i integer;

  v_pps_artikel_res_leistung                  pps_artikel_res_leistung.artikel_id%type;

  CURSOR c_pps_artikel_res_leistung is
    select t.artikel_id
      from pps_artikel_res_leistung t
     group by t.artikel_id;
begin
  delete pps_arb_plan t where t.arb_plan_id > 0;
  delete pps_arb_plan_ag t where t.arb_plan_id > 0;
  delete pps_arb_plan_ag_op_rel t where t.arb_plan_id > 0;
  delete pps_arb_plan_ag_op_res t where t.arb_plan_id > 0;
  delete pps_arb_plan_ag_stl t where t.arb_plan_pos_id > 0;
  delete pps_arb_plan_ag_res_id_liste t where t.arb_plan_pos_id > 0;
  delete pps_arb_plan_ag_pers_q_list t where t.arb_plan_id > 0;

  commit;

  OPEN c_pps_artikel_res_leistung;
  LOOP
    FETCH c_pps_artikel_res_leistung into v_pps_artikel_res_leistung;
    EXIT when c_pps_artikel_res_leistung%NOTFOUND;

    --pps_p_utils.c_gen_arbeitsplan(v_pps_artikel_res_leistung);
    pps_p_utils.c_gen_arbeitsplan_res_list(v_pps_artikel_res_leistung);

  end LOOP;
  CLOSE c_pps_artikel_res_leistung;

end;
/



-- sqlcl_snapshot {"hash":"945a077f020bb409cb797b84ec3e5134310c128b","type":"PROCEDURE","name":"C_GEN_ALL_ARB_PLAN","schemaName":"DIRKSPZM32","sxml":""}