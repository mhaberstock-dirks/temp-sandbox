
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_APS_PLAN_AUSFUEHRUNG_H_BUI" 
  before update or insert
  on DIRKSPZM32.APS_PLAN_AUSFUEHRUNG_HIST 
  for each row
declare
  -- local variables here
  v_found                        boolean;
  
  v_aps_kpi                      aps_plan_ausfuehrung_kpi%rowtype;
  
  CURSOR c_aps_kpi is
    select * from aps_plan_ausfuehrung_kpi kpi
   where kpi.sid = :new.sid
     and kpi.firma_nr = :new.firma_nr
     and kpi.aps_plan_stufe_id = :new.aps_plan_stufe_id;
     
begin
  if inserting
  then
    if (:new.exec_date_start is null)
    then
      :new.exec_date_start := sysdate;
    end if;
  end if;
  if updating
  and :new.exec_date_end >= :new.exec_date_start
  then
    OPEN c_aps_kpi;
    FETCH c_aps_kpi into v_aps_kpi;
    v_found := c_aps_kpi%FOUND;
    CLOSE c_aps_kpi;
    if not v_found
    then
      insert into aps_plan_ausfuehrung_kpi
      values
        (:new.sid, 
         :new.firma_nr, 
         :new.aps_plan_stufe_id, 
         :new.aps_plan_stufe_text, 
         1,                      -- v_counter, 
         :new.exec_ms,           -- v_exec_ms_sum, 
         :new.exec_ms,           -- v_exec_ms_min, 
         :new.exec_ms,           -- v_exec_ms_max, 
         :new.exec_ms,           -- v_exec_ms_last, 
         :new.exec_date_start,   -- v_exec_date_start_min, 
         :new.exec_date_start,   -- v_exec_date_start_max, 
         :new.exec_date_start,   -- v_exec_date_start_last, 
         :new.exec_params,       -- v_exec_params_min, 
         :new.exec_params,       -- v_exec_params_max, 
         :new.exec_params,       -- v_exec_params_last, 
         :new.exec_bedarf,       -- v_exec_bedarf_min, 
         :new.exec_bedarf,       -- v_exec_bedarf_max, 
         :new.exec_bedarf,       -- v_exec_bedarf_last, 
         :new.exec_ergebnis,     -- v_exec_ergebnis_min, 
         :new.exec_ergebnis,     -- v_exec_ergebnis_max, 
         :new.exec_ergebnis);    -- v_exec_ergebnis_last);
    else  
      update aps_plan_ausfuehrung_kpi
         set counter = counter + 1,
             exec_ms_sum = exec_ms_sum + :new.exec_ms,
             exec_ms_min = case when :new.exec_ms < exec_ms_min
                                then :new.exec_ms
                                else exec_ms_min
                                end,
             exec_ms_max = case when :new.exec_ms > exec_ms_max
                                then :new.exec_ms
                                else exec_ms_max
                                end,
             exec_ms_last = :new.exec_ms,
             exec_date_start_min = case when :new.exec_ms < exec_ms_min
                                   then :new.exec_date_start
                                   else exec_date_start_min
                                   end,
             exec_date_start_max = case when :new.exec_ms > exec_ms_max
                                   then :new.exec_date_start
                                   else exec_date_start_max
                                   end,
             exec_date_start_last = :new.exec_date_start,
             exec_params_min = case when :new.exec_ms < exec_ms_min
                               then :new.exec_params
                               else exec_params_min
                               end,
             exec_params_max = case when :new.exec_ms > exec_ms_max
                               then :new.exec_params
                               else exec_params_max
                               end,
             exec_params_last = :new.exec_params,
             exec_bedarf_min = case when :new.exec_ms < exec_ms_min
                                then :new.exec_bedarf
                                else exec_bedarf_min
                                end,
             exec_bedarf_max = case when :new.exec_ms > exec_ms_max
                               then :new.exec_bedarf
                               else exec_bedarf_max
                               end,
             exec_bedarf_last = :new.exec_bedarf,
             exec_ergebnis_min = case when :new.exec_ms < exec_ms_min
                                 then :new.exec_ergebnis
                                 else exec_ergebnis_min
                                 end,
             exec_ergebnis_max = case when :new.exec_ms > exec_ms_max
                                 then :new.exec_ergebnis
                                 else exec_ergebnis_max
                                 end,
             exec_ergebnis_last = :new.exec_ergebnis
       where aps_plan_stufe_id = :new.aps_plan_stufe_id
         and firma_nr = :new.firma_nr
         and sid = :new.sid;
    end if;
  end if;

end tr_APS_PLAN_AUSFUEHRUNG_HIST;

/
ALTER TRIGGER "DIRKSPZM32"."TR_APS_PLAN_AUSFUEHRUNG_H_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"f29a8f4e63fd1af059daeb67db39effb943e7c81","type":"TRIGGER","name":"TR_APS_PLAN_AUSFUEHRUNG_H_BUI","schemaName":"DIRKSPZM32","sxml":""}