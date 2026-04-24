create or replace editionable trigger dirkspzm32.tr_s_send_bew_biud before
    insert or update or delete on dirkspzm32.s_send_bew
    for each row
declare
    v_bew s_send_bew%rowtype;
begin
    v_bew.bew_id := :new.bew_id;
    v_bew.firma_nr := :new.firma_nr;
    v_bew.herkunft := :new.herkunft;
    v_bew.tabelle := :new.tabelle;
    v_bew.auf_id := :new.auf_id;
    v_bew.status := :new.status;
    v_bew.aktion := :new.aktion;
    v_bew.ma_status := :new.ma_status;
    v_bew.ma_s_grund := :new.ma_s_grund;
    v_bew.res_id := :new.res_id;
    v_bew.lte_nr := :new.lte_nr;
    v_bew.lhm_nr := :new.lhm_nr;
    v_bew.lagerort := :new.lagerort;
    v_bew.zlagerort := :new.zlagerort;
    v_bew.menge := :new.menge;
    v_bew.menge_b := :new.menge_b;
    v_bew.schrott := :new.schrott;
    v_bew.r_menge := :new.r_menge;
    v_bew.r_menge_b := :new.r_menge_b;
    v_bew.r_schrott := :new.r_schrott;
    v_bew.stoerzeit_ist := :new.stoerzeit_ist;
    v_bew.ruestzeit_ist := :new.ruestzeit_ist;
    v_bew.prodzeit_ist := :new.prodzeit_ist;
    v_bew.ext_lief_nr := :new.ext_lief_nr;
    v_bew.ext_lief_pos := :new.ext_lief_pos;
    v_bew.charge := :new.charge;
    v_bew.serie := :new.serie;
    v_bew.arbeitsplatz_id := :new.arbeitsplatz_id;
    v_bew.ist_bestand := :new.ist_bestand;
    v_bew.artikel := :new.artikel;
    v_bew.b_datum := nvl(:new.b_datum,
                         sysdate);
    v_bew.lam_id := :new.lam_id;
    v_bew.lam_bh_id := :new.lam_bh_id;
    v_bew.lam_bh_typ := :new.lam_bh_typ;
    v_bew.leitzahl := :new.leitzahl;
    v_bew.fa_ag := :new.fa_ag;
    v_bew.fa_upos := :new.fa_upos;
    v_bew.lam_ag := :new.lam_ag;
    v_bew.text := :new.text;
    v_bew.err_nr := :new.err_nr;
    v_bew.user_name := :new.user_name;
    v_bew.ma_last_s_grund := :new.ma_last_s_grund;
    v_bew.pers_nr := :new.pers_nr;
    v_bew.sper_grund := :new.sper_grund;
    v_bew.lagerplatz := :new.lagerplatz;
    v_bew.zlagerplatz := :new.zlagerplatz;
    v_bew.labor_status := :new.labor_status;
    v_bew.lam_sel1 := :new.lam_sel1;
    v_bew.lam_sel2 := :new.lam_sel2;
    v_bew.lam_sel3 := :new.lam_sel3;
    v_bew.lam_sel4 := :new.lam_sel4;
    v_bew.lam_sel5 := :new.lam_sel5;
    v_bew.lam_sel6 := :new.lam_sel6;
    v_bew.lam_sel7 := :new.lam_sel7;
    v_bew.lam_sel8 := :new.lam_sel8;
    v_bew.lam_sel9 := :new.lam_sel9;
    v_bew.lam_sel10 := :new.lam_sel10;
    v_bew.lte_name := :new.lte_name;
    v_bew.order_pos_auf_id := :new.order_pos_auf_id;
    if inserting then
    -- 27.08.2008 -AG- Datum in der Schnitstelle ist immer wenn in der Schnittstelle gebucht wird
        :new.b_datum := sysdate;
        select
            seq_s_send_bew_id.nextval
        into :new.bew_id
        from
            dual;

        if :new.status = 'UE' then
            v_bew.bew_id := :new.bew_id;
            s_schnittstelle.send_host_bew(v_bew);
            :new.send_id := v_bew.send_id;
        end if;

    elsif updating then
        if
            :new.status = 'UE'
            and nvl(:old.status,
                    'NULL') != 'UE'
        then
            s_schnittstelle.send_host_bew(v_bew);
            :new.send_id := v_bew.send_id;
      -- 27.08.2008 -AG- Datum in der Schnitstelle ist immer wenn in der Schnittstelle gebucht wird
            :new.b_datum := sysdate;
        end if;
    end if;

end tr_s_send_bew_biud;
/

alter trigger dirkspzm32.tr_s_send_bew_biud enable;


-- sqlcl_snapshot {"hash":"834515b9e7f09749603bea59b923be8fb233b5a3","type":"TRIGGER","name":"TR_S_SEND_BEW_BIUD","schemaName":"DIRKSPZM32","sxml":""}