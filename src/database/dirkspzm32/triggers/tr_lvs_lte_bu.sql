
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_LTE_BU" 
  before update on DIRKSPZM32.lvs_lte
  for each row
declare
  -- local variables here
  v_lte_cfg          lvs_lte_cfg%rowtype;
begin
  --
  if :new.lte_status = c.LTE_KF_STAT
  or :new.lte_status = c.LTE_AG_STAT
  then
    :new.ziel_lgr_platz := null;
    :new.ziel_lgr_ort := null;
    :new.ziel_lgr_ort_n_freif := null;
    :new.ziel_lgr_platz_n_freif := null;
  end if;

  if :new.lte_akt_lhm < 0         -- Fehler
  then
    :new.lte_akt_lhm := 0;
  end if;

  if :new.res_string is NULL
  and :new.lte_akt_lhm = 0         -- c.LEERPAL
  then
    :new.res_string := :new.lte_name;    -- -AG- Fuer Leerbehältereinlagerung und Gleichverteilung
  end if;

  if :new.lte_akt_lhm = 0         -- c.LEERPAL
  and :new.lte_status != c.LTE_KF_STAT -- und nicht KF
  and :new.lte_status != c.LTE_PF_STAT -- und nicht PF
  then
    if lvs_p_base.get_lte_cfg(:new.sid, :new.lte_name, v_lte_cfg)
    then
      :new.lte_vol_hoehe := nvl(:new.lte_vol_hoehe, v_lte_cfg.lte_vol_hoehe);
      :new.lte_vol_breite := nvl(:new.lte_vol_breite, v_lte_cfg.lte_vol_breite );
      :new.lte_vol_tiefe := nvl(:new.lte_vol_tiefe, v_lte_cfg.lte_vol_tiefe);
    end if;
  end if;


end tr_lvs_lte_bu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_LTE_BU" ENABLE;


-- sqlcl_snapshot {"hash":"22bdb7c93b884b7711ddf7767246aa074c12b3d6","type":"TRIGGER","name":"TR_LVS_LTE_BU","schemaName":"DIRKSPZM32","sxml":""}