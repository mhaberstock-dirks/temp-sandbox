create or replace 
procedure DIRKSPZM32.aps_c_sort_plan_ergebnis (in_aps_plan_status in aps_order_materialrelation.aps_plan_status%type
                                                     ) 
                                                     is
  v_found                                        boolean;
  
  i_pos                                          number;
  v_start_zeitpunkt                              date;
  v_r_num                                        number;
  v_r_last                                       number;
  
  CURSOR c_ergebnis is
    select x.*
      from (
      select --p.aps_plan_status st,
             p.artikel_id,
             p.order_info,
             p.jis_linie,
             p.prioritaet prio, p.planreihenfolge reihe, p.hersteller_kuerzel_liste herst
             -- , a.artikel_p6 reifen, a.artikel_p7 Rad, a.artikel kpr
             , p.auftrag_nr, p.pos_nr
             , pm.materialrelation_type r_typ, pm.materialrelation_valide r_valide
             , pm.materialrelation_info r_info
             , pm.child_id
             , pe.abnr Batch
        from Aps_Order_Auftr_Pos p,
             aps_order_materialrelation pm,
             aps_plan_ergebnis pe
      where 1=1
        and p.aps_plan_status = in_aps_plan_status
        and pm.aps_plan_status = p.aps_plan_status
        and p.auftrag_nr = pm.auftrag_nr
        and p.pos_nr = pm.pos_nr
        and p.upos_nr = pm.upos_nr
        and pe.aps_plan_status(+) = p.aps_plan_status
        and pe.aps_plan_auftrag_nr(+) = pm.child_id
      ) x
     where 1 = 1
    order by  --decode(x.r_valide,
              --       'F', 1,
              --       'T', 2,
              --       3),
              --x.batch,
              --x.herst,
              x.prio, x.reihe,
              x.auftrag_nr,
              x.pos_nr;
  v_ergebnis                               c_ergebnis%rowtype;
  
  CURSOR c_reihenfolge_fehler is
      select x.*
        from (
        select --p.aps_plan_status st,
               p.artikel_id,
               p.order_info,
               p.jis_linie,
               p.prioritaet prio, p.planreihenfolge reihe, p.hersteller_kuerzel_liste herst
               -- , a.artikel_p6 reifen, a.artikel_p7 Rad, a.artikel kpr
               , p.auftrag_nr, p.pos_nr
               , pm.materialrelation_type r_typ, pm.materialrelation_valide r_valide
               , pm.materialrelation_info r_info
               , pm.child_id
               , pe.abnr Batch
          from Aps_Order_Auftr_Pos p,
               aps_order_materialrelation pm,
               aps_plan_ergebnis pe
        where 1=1
          and p.artikel_id = v_ergebnis.artikel_id
          and p.aps_plan_status = in_aps_plan_status
          and pm.aps_plan_status = p.aps_plan_status
          and p.auftrag_nr = pm.auftrag_nr
          and p.pos_nr = pm.pos_nr
          and p.upos_nr = pm.upos_nr
          and pe.aps_plan_status(+) = p.aps_plan_status
          and pe.aps_plan_auftrag_nr(+) = pm.child_id
        ) x
       where 1 = 1
         and x.artikel_id = v_ergebnis.artikel_id
         and x.herst = v_ergebnis.herst
         and x.r_valide = c.C_TRUE
         and (    x.r_typ > v_ergebnis.r_typ
              or (x.r_typ = 2 and v_ergebnis.r_typ = 2 and x.batch like 'SISI%' and v_ergebnis.batch not like 'SISI%'))
         and (    x.prio > v_ergebnis.prio
              or (x.prio = v_ergebnis.prio and x.reihe > v_ergebnis.reihe)
             )
      order by  x.r_typ desc,  -- 8 = Lager, 2 = Produktion
                case when nvl (x.batch, 'SISIx') like 'SISI%' -- Prüfen FA oder Plan
                     then 0
                     else 1
                     end,
                x.prio desc, 
                x.reihe desc,
                x.auftrag_nr desc,
                x.pos_nr desc;
                
   v_reihenfolge_fehler                                                 c_reihenfolge_fehler%rowtype;

begin
  if  isi_allg.c_get_firma_cfg_param('01',
                                     1,
                                     'APS',                      -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                     'ZDIRSLAPSPLANGEN',         -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                     'APS_PLAN_ERGEBNIS_SORT',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                     'APS',                      -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                     'CFG',                      -- in_typ                   in isi_firma_cfg.typ%type,
                                     'F',                        -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                     'BOOLEAN') = c.C_FALSE       -- in_default_param_typ
  then
    return;
  end if;
  
  v_start_zeitpunkt := sysdate;
  
  v_r_last := 0;
  v_r_num := 0;
  i_pos := 0;
  OPEN c_ergebnis;
  FETCH c_ergebnis into v_ergebnis;
  v_found := c_ergebnis%found;
  LOOP
    EXIT when not v_found;
    v_r_num := v_r_num + 1;
    if v_r_num > v_r_last
    then
      OPEN c_reihenfolge_fehler;
      FETCH c_reihenfolge_fehler into v_reihenfolge_fehler;
      v_found := c_reihenfolge_fehler%found;
      CLOSE c_reihenfolge_fehler;
      if v_found
      then
        i_pos := i_pos + 1;
        -- Ringtausch 3 
        update aps_order_materialrelation mr
           set mr.auftrag_nr = 1,
               mr.pos_nr = 1
         where mr.auftrag_nr = v_reihenfolge_fehler.auftrag_nr
           and mr.pos_nr = v_reihenfolge_fehler.pos_nr
           and mr.aps_plan_status = in_aps_plan_status;    
        -- Besseren Eintrag nach forne
        update aps_order_materialrelation mr
           set mr.auftrag_nr = v_reihenfolge_fehler.auftrag_nr,
               mr.pos_nr = v_reihenfolge_fehler.pos_nr
         where mr.auftrag_nr = v_ergebnis.auftrag_nr
           and mr.pos_nr = v_ergebnis.pos_nr
           and mr.aps_plan_status = in_aps_plan_status;    
        -- Schlechteren Eintrag nach hinten
        update aps_order_materialrelation mr
           set mr.auftrag_nr = v_ergebnis.auftrag_nr,
               mr.pos_nr = v_ergebnis.pos_nr
         where mr.auftrag_nr = 1
           and mr.pos_nr = 1
           and mr.aps_plan_status = in_aps_plan_status;
        commit;
        CLOSE c_ergebnis;        
        OPEN c_ergebnis;
        v_r_last := v_r_num;
        -- Nur debug
        /*
        dbms_output.put_line ('Auftrag ' || v_ergebnis.auftrag_nr || '/' || v_ergebnis.pos_nr || ' Typ ' || v_ergebnis.r_typ || ' PRIO ' || v_ergebnis.prio || ' R ' || v_ergebnis.reihe || ' B ' || v_ergebnis.batch || 
                --' Artikel ' || v_ergebnis.artikel_id || 
                ' H ' || v_ergebnis.Herst ||  
                ' tauscht mit Auftfrag ' || v_reihenfolge_fehler.auftrag_nr || '/' || v_reihenfolge_fehler.pos_nr || ' Typ ' || v_reihenfolge_fehler.r_typ  || ' PRIO ' || v_reihenfolge_fehler.prio || ' R ' || v_reihenfolge_fehler.reihe || ' B ' || v_reihenfolge_fehler.batch || 
                -- ' Artikel ' || v_reihenfolge_fehler.artikel_id || 
                ' H ' || v_reihenfolge_fehler.Herst);
        */
      end if;
    end if;
    
    FETCH c_ergebnis into v_ergebnis;
    v_found := c_ergebnis%found;
    if i_pos > 50
    or (sysdate - v_start_zeitpunkt) * 1440 * 60 > 45 -- Läuft länger als 45 Sekunden
    then
      v_found := false;
    end if;
  end LOOP;
  CLOSE c_ergebnis;
end;
/



-- sqlcl_snapshot {"hash":"0c73a465f583b6382cacdb081889a324d2a6b58a","type":"PROCEDURE","name":"APS_C_SORT_PLAN_ERGEBNIS","schemaName":"DIRKSPZM32","sxml":""}