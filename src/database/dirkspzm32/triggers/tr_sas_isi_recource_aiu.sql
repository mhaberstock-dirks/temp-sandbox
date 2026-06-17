
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_SAS_ISI_RECOURCE_AIU" 
  after insert or update or delete on DIRKSPZM32.isi_resource
  for each row
declare
  -- local variables here
  v_fls_ele_id  number;
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler-Variablen für eine Exception
  -------------------------------------------------------------------------------------------------------
  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);
begin
  -- Erst mal kein Fehler
  v_err_nr   := null;
  v_err_text := null;

  if :new.typ != 'MS'
  then
    return;
  else
    if updating
    and :new.kategorie != 'WA'
    and :old.kategorie = 'WA'
    then
      delete fls_element_cfg f
       where f.res_id = :new.res_id;
    end if;
    if :new.kategorie != 'WA'
    then
      return;
    end if;
  end if;

  select max(e.element_id) into v_fls_ele_id from fls_element_cfg e;

  if not DELETING then
    begin
      v_fls_ele_id := v_fls_ele_id + 1;

      insert into FLS_ELEMENT_CFG
        values (:new.sid,                 -- sid
                :new.firma_nr,            -- firma
                1,                        -- INSTANCE_ID
                1,                        -- RESET_GRUPPEN_ID
                v_fls_ele_id,             -- ELEMENT_ID
                :new.res_id,              -- RES_ID
                'T',                      -- ENABLED
                'F',                      -- EDITOR_SPERRE
                :new.kategorie_typ,       -- ELEMENT_TYP
                v_fls_ele_id,             -- ELEMENT_IX
                :new.res_ext_name,        -- ELEMENT_NAME
                :new.res_name,            -- KURZNAME
                1,                        -- GEWERKE_NR
                1,                        -- POS_NR
                1,                        -- MAX_FE
                1,                        -- AUFTR_ART
                0,                        -- GROB_FEIN
                0,                        -- GESCHWINDIGKEIT_CM_PRO_MIN
                0,                        -- PROGR_NR
                0,                        -- TELEGR_MT_BELEGT
                0,                        -- TELEGR_MT_FREIPLATZ
                0,                        -- TELEGR_MT_ABMELDUNG
                0,                        -- TELEGR_FC
                0,                        -- TELEGR_FE_ID_ANFANG
                0,                        -- TELEGR_FE_ID_ENDE
                1,                        -- TELEGR_SPS_BEREICH_NR
                0,                        -- TELEGR_MELD_NR
                0,                        -- TELEGR_KOPPL_NR
                0,                        -- TELEGR_KONTUREN_KONTROLLE
                0,                        -- TELEGR_PALETTEN_TYP
                0,                        -- TELEGR_PALETTEN_HOEHE
                0,                        -- STRATEGIE_TOURREIHENFOLGE
                0,                        -- STRATEGIE_EINL_AUSL_VERH
                0,                        -- STRATEGIE_PKT_BELEGUNG
                0,                        -- STRATEGIE_PKT_WARTEN
                0,                        -- STRATEGIE_PRIO_XPROZ_BEF
                0,                        -- STRATEGIE_PKT_MAX_PROZ
                0,                        -- STRATEGIE_PKT_PRIO
                0,                        -- STRATEGIE_PKT_WEGOPTI
                0,                        -- SIMULAT_SPS_PQ_ZENTEL_SEK
                0,                        -- SIMULAT_SPS_MT_ZENTEL_SEK
                0,                        -- KOORDINAT_POS_X_ANFANG_CM
                0,                        -- KOORDINAT_POS_Y_ANFANG_CM
                0,                        -- KOORDINAT_POS_Z_ANFANG_CM
                0,                        -- KOORDINAT_POS_X_ENDE_CM
                0,                        -- KOORDINAT_POS_Y_ENDE_CM
                0,                        -- KOORDINAT_POS_Z_ENDE_CM
                0,                        -- KOORDINAT_BEWEGUNG
                0,                        -- KOORDINAT_GESAMTLAENGE_CM
                0,                        -- STRATEGIE_PUNKTEVERGABE
                0,                        -- STRATEGIE_FLS_MELD_EXTERN
                0,                        -- STRATEGIE_DEFEKT_MOEGL
                0,                        -- STRATEGIE_PKT_ANZ_QUELL_PRUEF
                100,                      -- STRATEGIE_AUFTR_TIMEOUT_ZS
                'F',                      -- TELEGR_GRUNDST_MOEGL
                null,                     -- DEFAULT_ZIEL_ID
                'F',                      -- IS_DEFEKT
                'F',                      -- IS_HOLEN_GESPERRT
                'F',                      -- IS_BRINGEN_GESPERRT
                0,                        -- IS_IPUNKT
                0,                        -- IS_ZIEL
                'F',                      -- IS_AUFSETZ_PUNKT
                0,                        -- IS_ENTSCHEID_PUNKT
                'LOGIK_Waage',            -- AKTIONS_LOGIK
                null,                     -- ZUSATZ_LOGIK_NAMEN
                null,                     -- KONFIG_PARAMS
                0,                        -- TELEGR_MT_WE
                'F',                      -- STRATEGIE_VERL_ST_VORG
                null,                     -- STRATEGIE_LAGERPLATZ
                null,                     -- DEFAULT_QUELL_ID
                0,                        -- STRATEGIE_REIHENFOLGE_VON
                0,                        -- STRATEGIE_REIHENFOLGE_BIS
                0,                        -- STRATEGIE_AUSSCHLEUS_MOEGL
                1,                        -- IS_AUTO_WARENAUSZEICHN
                null,                     -- STRATEGIE_AUSSCHLEUS_ZIEL_ID
                null,                     -- STRATEGIE_ERSATZ_ZIEL_ID
                null,                     -- STRATEGIE_AUTO_TRANSP_ZIEL_ID
                0,                        -- STRATEGIE_SCANN_BETR_WAEHLEN
                0,                        -- STRATEGIE_DURCHSCHL_MOEGLICH
                null,                     -- STRATEGIE_DEFEKT_DEF_ZIEL_ID
                null);                    -- VISU_LOGIK
    exception
      when others then
                    update fls_element_cfg f
                       set f.element_typ = :new.kategorie_typ,      -- ELEMENT_TYP
                           f.element_name = :new.res_ext_name,      -- ELEMENT_NAME
                           f.kurzname = :new.res_name,              -- KURZNAME
                           f.aktions_logik = 'LOGIK_Waage'
                     where f.res_id = :new.res_id;
    end;
  end if;
  if DELETING then
    delete fls_element_cfg f
     where f.res_id = :old.res_id;
  end if;

exception
  when v_error then
    raise_application_error(-20000 - v_err_nr, v_err_text);
  when others then
    if v_err_nr is not null
    then
      -- unseren Fehler oben drauf setzen
      raise_application_error(-20000 - v_err_nr, v_err_text, true);
    else
      raise;
    end if;
end tr_sas_isi_recource_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_SAS_ISI_RECOURCE_AIU" ENABLE;


-- sqlcl_snapshot {"hash":"6fe94f4fe9610726c74437b5d8d03728cf75b3df","type":"TRIGGER","name":"TR_SAS_ISI_RECOURCE_AIU","schemaName":"DIRKSPZM32","sxml":""}