create or replace editionable trigger dirkspzm32.tr_isi_transport_bd before
    delete on dirkspzm32.isi_transport
    for each row
declare
  -- local variables here
 begin
    insert into isi_transport_log values ( :old.sid,
                                           :old.firma_nr,
                                           seq_transp_log_id.nextval,
                                           :old.transp_id,
                                           'D', -- Deleted = wenn DS gelöscht wird, wird der letzte Status nicht geändert, deshalb 'D'
                                           null, -- user_id ist hier falsch, da das der Erzeuger ist
                                           systimestamp,
                                           'STAT', -- log_typ
                                           null, -- arbeitsplatz_id
                                           null, -- check_typ
                                           null, -- scan_data
                                           null,  --check_q_eti_typ
                                           null, -- check_passed
                                           null,
                                           null,
                                           :old.res_id,
                                           :old.parent_transp_id,
                                           :old.lte_id );

    begin
        if :old.transp_typ = 'E' then
            update lvs_fahrzeuge f
            set
                f.akt_trans_lte = f.akt_trans_lte - 1
            where
                f.res_id = :old.res_id;

        end if;

        insert into isi_transport_hist values ( :old.sid,
                                                :old.firma_nr,
                                                :old.modul_erzeuger,
                                                :old.modul_bearbeiter,
                                                :old.transp_id,
                                                :old.transp_id_source,
                                                :old.ts,
                                                :old.transp_typ,
                                                :old.transportmittel_gruppe,
                                                :old.transportmittel_id,
                                                :old.transportmittel_typ,
                                                :old.status,
                                                :old.lgr_platz_quelle,
                                                :old.lgr_platz_ziel,
                                                :old.lgr_verwendung_quelle,
                                                :old.lgr_verwendung_ziel,
                                                :old.lgr_ort_quelle,
                                                :old.lgr_ort_ziel,
                                                :old.vorgang_id,
                                                :old.transport_gruppe,
                                                :old.lte_id,
                                                :old.auf_id,
                                                :old.auf_id_extern,
                                                :old.prio,
                                                :old.progr_nr,
                                                :old.quelle_leer_progr_nr,
                                                :old.ziel_voll_progr_nr,
                                                :old.kunden_nr,
                                                :old.user_id,
                                                :old.freifahrauftrag,
                                                :old.lieferschein,
                                                :old.res_id,
                                                :old.lam_bh_vorgang_id,
                                                :old.li_nr,
                                                :old.li_pos_nr,
                                                :old.lte_letzte_buchung,
                                                :old.lkw_nr,
                                                :old.leitzahl,
                                                :old.info_text,
                                                :old.soll_fertig_bis,
                                                :old.check_ware_login_id,
                                                :old.check_platz_z_login_id,
                                                :old.check_platz_q_login_id,
                                                :old.parent_transp_id,
                                                :old.transport_reihenfolge,
                                                :old.uml_ziel_res_id,
                                                :old.p_komm_id,
                                                :old.p_komm_lte_lhm_lagen,
                                                :old.p_komm_lte_lhm_pro_lage,
                                                :old.p_komm_lhm_hoehe_lage,
                                                :old.p_komm_packschema_kopf_id,
                                                :old.lgr_platz_ziel_check_new );

    exception
        when others then
            null;
    end;

end tr_isi_transport_bi;
/

alter trigger dirkspzm32.tr_isi_transport_bd enable;


-- sqlcl_snapshot {"hash":"75c9e23846d22b1ccc0b7e0eb596a4d316aa2eaf","type":"TRIGGER","name":"TR_ISI_TRANSPORT_BD","schemaName":"DIRKSPZM32","sxml":""}