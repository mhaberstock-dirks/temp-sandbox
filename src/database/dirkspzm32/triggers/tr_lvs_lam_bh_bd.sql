create or replace editionable trigger dirkspzm32.tr_lvs_lam_bh_bd before
    delete on dirkspzm32.lvs_lam_bh
    for each row
begin
    insert into lvs_lam_bh_hist values ( :old.sid,
                                         :old.firma_nr,
                                         :old.vorg_id,
                                         :old.vorg_typ,
                                         :old.lam_bh_id,
                                         :old.lam_id,
                                         :old.artikel_id,
                                         :old.bus,
                                         :old.buch_datum,
                                         :old.ls_login_id,
                                         :old.lgr_platz,
                                         :old.lte_id,
                                         :old.lhm_id,
                                         :old.charge_id,
                                         :old.serie_id,
                                         :old.abnr,
                                         :old.menge,
                                         :old.lam_bh_kg,
                                         :old.lam_bh_kg_einheit,
                                         :old.res_id,
                                         :old.leitzahl,
                                         :old.fa_ag,
                                         :old.fa_upos,
                                         :old.abnr_extern,
                                         :old.vorgang_id,
                                         :old.li_nr,
                                         :old.li_pos_nr,
                                         :old.created_date,
                                         :old.created_login_id,
                                         :old.last_change_date,
                                         :old.last_change_login_id,
                                         :old.change_menge,
                                         :old.owner_address_id,
                                         :old.owner_address_id_new );

end;
/

alter trigger dirkspzm32.tr_lvs_lam_bh_bd enable;


-- sqlcl_snapshot {"hash":"c20da647d2c2bf7a977c5c182c74bc9e9628faa4","type":"TRIGGER","name":"TR_LVS_LAM_BH_BD","schemaName":"DIRKSPZM32","sxml":""}