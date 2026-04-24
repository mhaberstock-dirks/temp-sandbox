create or replace editionable trigger dirkspzm32.tr_s_erp_rcv_kunden_auf_p_biu before
    insert or update on dirkspzm32.s_erp_rcv_kunden_auftr_pos
    for each row
declare
  -- local variables here
    v_kd_auf_pos_id number;
    v_status        varchar2(20);
begin
    if updating
    or inserting then
        if inserting then
            if :new.created_date is null then
                :new.created_date := sysdate;
            end if;

            if :new.created_login_id is null then
                :new.created_login_id := -1;
            end if;

        end if;

        if updating then
            if :new.last_change_date = :old.last_change_date
            or :new.last_change_date is null then
                :new.last_change_date := sysdate;
            end if;

        end if;

        begin
            insert into s_rcv_kunden_auftr_pos kap (
                kap.sid,
                kap.firma_nr,
                kap.kunden_auftr_pos_id,
                kap.status,
                kap.auftrag,
                kap.pos_nr,
                kap.upos_nr,
                kap.adr_art,
                kap.adr_nr,
                kap.adr_liefer,
                kap.login_id,
                kap.arbeitsplatz_id,
                kap.artikel,
                kap.fa_nr,
                kap.fa_ag,
                kap.fa_upos,
                kap.charge,
                kap.seriennr,
                kap.strategie,
                kap.mhd,
                kap.kom_info,
                kap.soll_menge,
                kap.mengeneinheit,
                kap.wae_ziel,
                kap.besteller,
                kap.freigabe,
                kap.freigabe_datum,
                kap.freigegeben_datum,
                kap.order_datum,
                kap.liefer_datum,
                kap.fertig_datum,
                kap.prioritaet,
                kap.anbruch,
                kap.min_mhd_tage,
                kap.min_reifezeit,
                kap.best_nr_kunde,
                kap.zeichnung_index,
                kap.li_nr,
                kap.li_pos_nr,
                kap.lam_sel1,
                kap.lam_sel2,
                kap.lam_sel3,
                kap.lam_sel4,
                kap.lam_sel5,
                kap.lam_sel6,
                kap.lam_sel7,
                kap.lam_sel8,
                kap.lam_sel9,
                kap.lam_sel10,
                kap.prod_params,
                kap.ziel
            ) values ( :new.sid,
                       :new.firma_nr,
                       :new.kunden_auftr_pos_id,
                       :new.status,
                       :new.auftrag,
                       :new.pos_nr,
                       :new.upos_nr,
                       :new.adr_art,
                       :new.adr_nr,
                       :new.adr_liefer,
                       :new.login_id,
                       :new.arbeitsplatz_id,
                       :new.artikel,
                       :new.fa_nr,
                       :new.fa_ag,
                       :new.fa_upos,
                       :new.charge,
                       :new.seriennr,
                       :new.strategie,
                       :new.mhd,
                       :new.kom_info,
                       :new.soll_menge,
                       :new.mengeneinheit,
                       :new.wae_ziel,
                       :new.besteller,
                       :new.freigabe,
                       :new.freigabe_datum,
                       :new.freigegeben_datum,
                       :new.order_datum,
                       :new.liefer_datum,
                       :new.fertig_datum,
                       :new.prioritaet,
                       :new.anbruch,
                       :new.min_mhd_tage,
                       :new.min_reifezeit,
                       :new.best_nr_kunde,
                       :new.zeichnung_index,
                       :new.li_nr,
                       :new.li_pos_nr,
                       :new.lam_sel1,
                       :new.lam_sel2,
                       :new.lam_sel3,
                       :new.lam_sel4,
                       :new.lam_sel5,
                       :new.lam_sel6,
                       :new.lam_sel7,
                       :new.lam_sel8,
                       :new.lam_sel9,
                       :new.lam_sel10,
                       :new.prod_params,
                       :new.ziel );

        exception
            when dup_val_on_index then
                null;
        end;

        v_kd_auf_pos_id := :new.kunden_auftr_pos_id;
        v_status := :new.status;
        update s_rcv_kunden_auftr_pos kap
        set
            kap.sid = :new.sid,
            kap.firma_nr = :new.firma_nr,
            kap.kunden_auftr_pos_id = :new.kunden_auftr_pos_id,
            kap.status = :new.status,
            kap.auftrag = :new.auftrag,
            kap.pos_nr = :new.pos_nr,
            kap.upos_nr = :new.upos_nr,
            kap.adr_art = :new.adr_art,
            kap.adr_nr = :new.adr_nr,
            kap.adr_liefer = :new.adr_liefer,
            kap.login_id = :new.login_id,
            kap.arbeitsplatz_id = :new.arbeitsplatz_id,
            kap.artikel = :new.artikel,
            kap.fa_nr = :new.fa_nr,
            kap.fa_ag = :new.fa_ag,
            kap.fa_upos = :new.fa_upos,
            kap.charge = :new.charge,
            kap.seriennr = :new.seriennr,
            kap.strategie = :new.strategie,
            kap.mhd = :new.mhd,
            kap.kom_info = :new.kom_info,
            kap.soll_menge = :new.soll_menge,
            kap.mengeneinheit = :new.mengeneinheit,
            kap.wae_ziel = :new.wae_ziel,
            kap.besteller = :new.besteller,
            kap.freigabe = :new.freigabe,
            kap.freigabe_datum = :new.freigabe_datum,
            kap.freigegeben_datum = :new.freigegeben_datum,
            kap.order_datum = :new.order_datum,
            kap.liefer_datum = :new.liefer_datum,
            kap.fertig_datum = :new.fertig_datum,
            kap.prioritaet = :new.prioritaet,
            kap.anbruch = :new.anbruch,
            kap.min_mhd_tage = :new.min_mhd_tage,
            kap.min_reifezeit = :new.min_reifezeit,
            kap.best_nr_kunde = :new.best_nr_kunde,
            kap.zeichnung_index = :new.zeichnung_index,
            kap.li_nr = :new.li_nr,
            kap.li_pos_nr = :new.li_pos_nr,
            kap.lam_sel1 = :new.lam_sel1,
            kap.lam_sel2 = :new.lam_sel2,
            kap.lam_sel3 = :new.lam_sel3,
            kap.lam_sel4 = :new.lam_sel4,
            kap.lam_sel5 = :new.lam_sel5,
            kap.lam_sel6 = :new.lam_sel6,
            kap.lam_sel7 = :new.lam_sel7,
            kap.lam_sel8 = :new.lam_sel8,
            kap.lam_sel9 = :new.lam_sel9,
            kap.lam_sel10 = :new.lam_sel10,
            kap.prod_params = :new.prod_params,
            kap.ziel = :new.ziel
        where
                kap.firma_nr = :new.firma_nr
            and kap.sid = :new.sid
            and kap.kunden_auftr_pos_id = :new.kunden_auftr_pos_id;

    end if;
end tr_s_erp_rcv_kunden_auf_p_biu;
/

alter trigger dirkspzm32.tr_s_erp_rcv_kunden_auf_p_biu enable;


-- sqlcl_snapshot {"hash":"0f974215a500aac919fca5c167f85980e5564eb0","type":"TRIGGER","name":"TR_S_ERP_RCV_KUNDEN_AUF_P_BIU","schemaName":"DIRKSPZM32","sxml":""}