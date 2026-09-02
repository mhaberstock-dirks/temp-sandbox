
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_LVS_LHM_BD" 
  before delete on lvs_lhm
  for each row
declare
  -- local variables here
begin
  delete lvs_lhm_hist t
   where t.lhm_id = :old.lhm_id;

  insert into lvs_lhm_hist
       values (:old.sid,
               :old.firma_nr,
               :old.lhm_id,
               :old.lte_id,
               :old.lhm_name,
               :old.lgr_platz,
               :old.lhm_vol_hoehe,
               :old.lhm_vol_breite,
               :old.lhm_vol_tiefe,
               :old.lhm_vol,
               :old.lhm_akt_kg,
               :old.lhm_letzte_buchung,
               :old.lhm_eti_druck_status,
               :old.komm_quell_lte_id,
               :old.komm_quell_lgr_platz,
               :old.komm_neu_lhm_name);
end tr_lvs_lhm_bd;


/
ALTER TRIGGER "TR_LVS_LHM_BD" ENABLE;


-- sqlcl_snapshot {"hash":"f052d88849d25c50df5caf3fe6266a9e541aba19","type":"TRIGGER","name":"TR_LVS_LHM_BD","schemaName":"DIRKSPZM32","sxml":""}