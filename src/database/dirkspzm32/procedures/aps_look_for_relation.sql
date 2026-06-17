create or replace 
procedure DIRKSPZM32.aps_look_for_relation(in_auftrag_nr in aps_order_materialrelation.auftrag_nr%type,
                                                  in_pos_nr          in aps_order_materialrelation.pos_nr%type,
                                                  in_upos_nr         in aps_order_materialrelation.upos_nr%type,
                                                  in_artikel_id      in isi_artikel.artikel_id%type,
                                                  in_aps_plan_status in aps_order_materialrelation.aps_plan_status%type,
                                                  in_aps_plan_st_ret in aps_order_materialrelation.aps_plan_status%type
                                                 ) 
                                                 is
  v_found                                        boolean;
  
  v_aps_mr                                       aps_order_materialrelation%rowtype;
 
  CURSOR c_check_bestand is
    select apmr.*
      from aps_order_materialrelation apmr,
           lvs_lam lam,
           lvs_lgr lgr
     where apmr.auftrag_nr = in_auftrag_nr
       and apmr.pos_nr = in_pos_nr
       and apmr.upos_nr = in_upos_nr
       and apmr.aps_plan_status = in_aps_plan_st_ret
       and apmr.materialrelation_type = 8
       and not exists (select * from aps_order_materialrelation apmrx where apmrx.child_id = apmr.child_id and apmrx.materialrelation_type = apmr.materialrelation_type and apmrx.aps_plan_status = 'PS')
       and apmr.child_id = lam.lte_id
       and lam.labor_status in ('F', 'Q')
       and lgr.lgr_platz =  lam.lgr_platz
       and lgr.gesperrt = 'F';

  CURSOR c_get_alternativ_lte is
    select apmr.*
      from aps_order_auftr_pos ap,
           aps_order_materialrelation apmr,
           lvs_lam lam,
           lvs_lgr lgr
     where ap.artikel_id = in_artikel_id
       and ap.aps_plan_status = in_aps_plan_st_ret
       and ap.auftrag_nr = apmr.auftrag_nr
       and ap.pos_nr = apmr.pos_nr
       and ap.upos_nr = apmr.upos_nr
       and apmr.aps_plan_status = ap.aps_plan_status
       and apmr.materialrelation_type = 8
       and not exists (select * 
                         from aps_order_auftr_pos apx,
                              aps_order_materialrelation apmrx
                        where apmrx.child_id = apmr.child_id
                          and apx.auftrag_nr = apmrx.auftrag_nr
                          and apx.pos_nr = apmrx.pos_nr
                          and apx.upos_nr = apmrx.upos_nr
                          and apx.aps_plan_status = in_aps_plan_status
                          and apx.aps_plan_status = apmrx.aps_plan_status
                          and nvl(apx.hersteller_kuerzel_liste, 'Keiner') = nvl(ap.hersteller_kuerzel_liste, 'Keiner')
                          and apmrx.materialrelation_type = 8)
       and apmr.child_id(+) = lam.lte_id
       and lam.lgr_platz(+) is not NULL
       and lam.labor_status(+) in ('F', 'Q')
       and lgr.lgr_platz(+) = lam.lgr_platz
       and lgr.gesperrt(+) = 'F'
    order by ap.prioritaet desc, ap.planreihenfolge desc, ap.auftrag_nr desc, ap.pos_nr desc, ap.upos_nr desc;  
begin
  
  OPEN c_check_bestand;
  FETCH c_check_bestand into v_aps_mr;
  v_found := c_check_bestand%FOUND;
  CLOSE c_check_bestand;
  
  if v_found 
  then
    update aps_order_materialrelation apmr
       set apmr.materialrelation_type = v_aps_mr.materialrelation_type,
           apmr.child_id = v_aps_mr.child_id,
           apmr.child_artikel_id = v_aps_mr.child_artikel_id
     where apmr.aps_plan_status = in_aps_plan_status
       and apmr.auftrag_nr = v_aps_mr.auftrag_nr
       and apmr.pos_nr = v_aps_mr.pos_nr
       and apmr.upos_nr = v_aps_mr.upos_nr
       and apmr.aps_plan_status = in_aps_plan_status;
  else
    OPEN c_get_alternativ_lte;
    FETCH c_get_alternativ_lte into v_aps_mr;
    v_found := c_get_alternativ_lte%FOUND;
    CLOSE c_get_alternativ_lte;
      if v_found 
      then
        update aps_order_materialrelation apmr
           set apmr.materialrelation_type = v_aps_mr.materialrelation_type,
               apmr.child_id = v_aps_mr.child_id,
               apmr.child_artikel_id = v_aps_mr.child_artikel_id
         where apmr.aps_plan_status = in_aps_plan_status
           and apmr.auftrag_nr = v_aps_mr.auftrag_nr
           and apmr.pos_nr = v_aps_mr.pos_nr
           and apmr.upos_nr = v_aps_mr.upos_nr
           and apmr.aps_plan_status = in_aps_plan_status;
      end if;
  end if;
end aps_look_for_relation;
/



-- sqlcl_snapshot {"hash":"e9b6a2d1e486852f23ee5eed6667c02a07c52109","type":"PROCEDURE","name":"APS_LOOK_FOR_RELATION","schemaName":"DIRKSPZM32","sxml":""}