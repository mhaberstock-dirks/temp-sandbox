
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_LTE_BD" 
  before delete on DIRKSPZM32.lvs_lte
  for each row
declare
  -- local variables here
begin
  insert into lvs_lte_hist
       values (:old.sid,
               :old.firma_nr,
               :old.lte_id,
               :old.lte_name,
               :old.lgr_ort,
               :old.lgr_platz,
               :old.lgr_platz_gruppe,
               :old.lte_vol_hoehe,
               :old.lte_vol_breite,
               :old.lte_vol_tiefe,
               :old.lte_vol,
               :old.lte_akt_kg,
               :old.lte_akt_lhm,
               :old.ls_login_id,
               sysdate,
               :old.lte_status,
               :old.lte_voll,
               :old.ziel_lgr_ort,
               :old.ziel_lgr_platz,
               :old.nve_nr,
               :old.min_temp,
               :old.max_temp,
               :old.abc,
               :old.wert_klasse,
               :old.gefahren_klasse,
               :old.waren_typ,
               :old.res_string,
               :old.res_artikel_id,
               :old.res_mhd,
               :old.order_vorgang_id,
               :old.res_string_statisch,
               :old.ziel_lgr_ort_n_freif,
               :old.ziel_lgr_platz_n_freif,
               :old.order_auf_id,
               :old.lte_inv_status,
               :old.anz_uml,
               :old.lte_eti_druck_status,
               :old.res_login_id,
               :old.res_ziel_lgr_platz,
               :old.packschema_kopf_id,
               :old.transport_gruppe,
               :old.lkw_nr,
               :old.lte_offset_x,
               :old.lte_offset_y,
               :old.lte_offset_z,
               :old.auto_depal,
               :old.wickelprogramm,
               :old.wickelprogramm_einl,
               :old.komm_menge_kontrolle,
               :old.akt_inventur_id,
               :old.letzte_inventur_id,
               :old.letzte_inventur_datum,
               :old.letzte_inventur_login_id);
end tr_lvs_lte_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_LTE_BD" ENABLE;


-- sqlcl_snapshot {"hash":"8707ab01a3b8474d506c150cfbbccebbdcdab51c","type":"TRIGGER","name":"TR_LVS_LTE_BD","schemaName":"DIRKSPZM32","sxml":""}