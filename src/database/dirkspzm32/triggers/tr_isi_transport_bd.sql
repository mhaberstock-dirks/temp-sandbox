
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_TRANSPORT_BD" 
  before delete on DIRKSPZM32.isi_TRANSPORT
  for each row
declare
  -- local variables here
begin
  insert into isi_transport_log
  values (
    :old.sid,
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
    :old.lte_id
  );

  begin
    if :old.transp_typ = 'E'
    then
      update lvs_fahrzeuge f
         set f.akt_trans_lte = f.akt_trans_lte - 1
       where f.res_id = :old.res_id;
    end if;
    insert into isi_transport_hist
      values (
              :old.SID,
              :old.FIRMA_NR,
              :old.MODUL_ERZEUGER,
              :old.MODUL_BEARBEITER,
              :old.TRANSP_ID,
              :old.TRANSP_ID_SOURCE,
              :old.TS,
              :old.TRANSP_TYP,
              :old.TRANSPORTMITTEL_GRUPPE,
              :old.TRANSPORTMITTEL_ID,
              :old.TRANSPORTMITTEL_TYP,
              :old.STATUS,
              :old.LGR_PLATZ_QUELLE,
              :old.LGR_PLATZ_ZIEL,
              :old.LGR_VERWENDUNG_QUELLE,
              :old.LGR_VERWENDUNG_ZIEL,
              :old.LGR_ORT_QUELLE,
              :old.LGR_ORT_ZIEL,
              :old.VORGANG_ID,
              :old.TRANSPORT_GRUPPE,
              :old.LTE_ID,
              :old.AUF_ID,
              :old.AUF_ID_EXTERN,
              :old.PRIO,
              :old.PROGR_NR,
              :old.QUELLE_LEER_PROGR_NR,
              :old.ZIEL_VOLL_PROGR_NR,
              :old.KUNDEN_NR,
              :old.USER_ID,
              :old.FREIFAHRAUFTRAG,
              :old.LIEFERSCHEIN,
              :old.RES_ID,
              :old.LAM_BH_VORGANG_ID,
              :old.LI_NR,
              :old.LI_POS_NR,
              :old.LTE_LETZTE_BUCHUNG,
              :old.LKW_NR,
              :old.LEITZAHL,
              :old.INFO_TEXT,
              :old.SOLL_FERTIG_BIS,
              :old.CHECK_WARE_LOGIN_ID,
              :old.CHECK_PLATZ_Z_LOGIN_ID,
              :old.CHECK_PLATZ_Q_LOGIN_ID,
              :old.PARENT_TRANSP_ID,
              :old.TRANSPORT_REIHENFOLGE,
              :old.uml_ziel_res_id,
              :old.p_komm_id,
              :old.p_komm_lte_lhm_lagen,
              :old.p_komm_lte_lhm_pro_lage,
              :old.p_komm_lhm_hoehe_lage,
              :old.p_komm_packschema_kopf_id,
              :old.lgr_platz_ziel_check_new
             );
  exception
     when others then
       NULL;
  end;

end TR_ISI_TRANSPORT_BI;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_TRANSPORT_BD" ENABLE;


-- sqlcl_snapshot {"hash":"18bb09c42021b9521f02b9b98167303794c7edb6","type":"TRIGGER","name":"TR_ISI_TRANSPORT_BD","schemaName":"DIRKSPZM32","sxml":""}