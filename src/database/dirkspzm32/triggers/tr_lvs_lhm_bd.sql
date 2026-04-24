create or replace editionable trigger dirkspzm32.tr_lvs_lhm_bd before
    delete on dirkspzm32.lvs_lhm
    for each row
declare
  -- local variables here
 begin
    delete lvs_lhm_hist t
    where
        t.lhm_id = :old.lhm_id;

    insert into lvs_lhm_hist values ( :old.sid,
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
                                      :old.komm_neu_lhm_name );

end tr_lvs_lhm_bd;
/

alter trigger dirkspzm32.tr_lvs_lhm_bd enable;


-- sqlcl_snapshot {"hash":"628fa22df4edeb4e9405089c1b415b4b1065e58e","type":"TRIGGER","name":"TR_LVS_LHM_BD","schemaName":"DIRKSPZM32","sxml":""}