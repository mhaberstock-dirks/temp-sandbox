
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_APS_PLAN_ERGEBNIS_BUI" 
  before insert or update
  on APS_PLAN_ERGEBNIS
  for each row
declare
  -- local variables here
begin

  if updating
  and :new.transfer_status = 'F' -- Ein Fehler beim Übertragen
  and :old.transfer_status != 'F'
  then
    update aps_order_materialrelation pm
       set pm.materialrelation_valide = 'F',
           pm.materialrelation_info = substr(to_char(:new.fehler_code) || ' ' || :new.fehler_text || cr_lf()  || pm.materialrelation_info, 1, 1000)
     where pm.aps_plan_status = :new.aps_plan_status
       and pm.child_id = :new.aps_plan_auftrag_nr;
  end if;
end TR_Z_DIR_APS_PLAN_MATR_bui;


/
ALTER TRIGGER "TR_APS_PLAN_ERGEBNIS_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"bef7d1f6367c0df10afeac3fddfcae35d85c6e30","type":"TRIGGER","name":"TR_APS_PLAN_ERGEBNIS_BUI","schemaName":"DIRKSPZM32","sxml":""}