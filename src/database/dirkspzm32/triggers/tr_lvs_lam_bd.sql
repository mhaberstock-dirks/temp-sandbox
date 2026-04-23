create or replace editionable trigger dirkspzm32.tr_lvs_lam_bd before
    delete on dirkspzm32.lvs_lam
    for each row
declare
  -- local variables here
 begin
    delete lvs_lam_bh lam_bh
    where
        lam_bh.lam_id = :old.lam_id;

    insert into lvs_lam_hist values ( :old.sid,
                                      :old.firma_nr,
                                      :old.lam_id,
                                      :old.artikel_id,
                                      :old.lgr_platz,
                                      :old.lte_id,
                                      :old.lhm_id,
                                      :old.charge_id,
                                      :old.serie_id,
                                      :old.leitzahl,
                                      :old.fa_ag,
                                      :old.fa_upos,
                                      :old.abnr,
                                      :old.best_nr,
                                      :old.best_pos,
                                      :old.res_id,
                                      :old.prod_datum,
                                      :old.zug_datum,
                                      :old.ls_login_id,
                                      :old.menge,
                                      :old.lam_kg,
                                      :old.lam_text,
                                      :old.labor_status,
                                      :old.labor_text,
                                      :old.lam_mhd,
                                      :old.kunden_nr,
                                      :old.kd_art_nr,
                                      :old.lieferant_nr,
                                      :old.lam_mhd_ausgabe,
                                      :old.menge_basis,
                                      :old.mengeneinheit_basis,
                                      :old.order_pos_auf_id,
                                      :old.zeichnung,
                                      :old.zeichnung_index,
                                      :old.li_nr_lief,
                                      :old.lte_id_lieferant,
                                      :old.sonst_id_lieferant,
                                      :old.akt_inventur_id,
                                      :old.letzte_inventur_id,
                                      :old.letzte_inventur_datum,
                                      :old.letzte_inventur_login_id,
                                      :old.lam_p1,
                                      :old.lam_p2,
                                      :old.lam_p3,
                                      :old.lam_p4,
                                      :old.lam_p5,
                                      :old.lam_p6,
                                      :old.lam_p7,
                                      :old.lam_p8,
                                      :old.lam_p9,
                                      :old.lam_p10,
                                      :old.res_menge,
                                      :old.res_ziel_lte_id,
                                      :old.res_login_id,
                                      :old.check_ware_transp_id,
                                      :old.fae_id,
                                      :old.fae_id_position,
                                      :old.qs_status,
                                      :old.waren_typ,
                                      :old.lhm_lfd_nr,
                                      :old.packschema_kopf_id,
                                      :old.packschema_lfdn,
                                      :old.lhm_c_lfd_nr,
                                      :old.owner_address_id,
                                      :old.lam_sel1,
                                      :old.lam_sel2,
                                      :old.lam_sel3,
                                      :old.lam_sel4,
                                      :old.lam_sel5,
                                      :old.lam_sel6,
                                      :old.lam_sel7,
                                      :old.lam_sel8,
                                      :old.lam_sel9,
                                      :old.lam_sel10,
                                      :old.hersteller_kuerzel_liste,
                                      :old.nr_pruefung );

end tr_lvs_lam_bd;
/

alter trigger dirkspzm32.tr_lvs_lam_bd enable;


-- sqlcl_snapshot {"hash":"4d2c12fa3454f24c660210858b152ce578d977a1","type":"TRIGGER","name":"TR_LVS_LAM_BD","schemaName":"DIRKSPZM32","sxml":""}