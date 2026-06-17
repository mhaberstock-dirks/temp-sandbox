
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PPS_SIMPLE_FA_BUID" 
  before insert or update or delete on DIRKSPZM32.pps_simple_fa
  for each row
declare

  v_anz_bde_beg                 number;
  v_bde_chargerein              varchar2(100);

  CURSOR c_bde_begonnen is
    select count(t.freig_status)
      from bde_fa_auftrag t
     where t.sid = :old.sid
       and t.firma_nr = :old.firma_nr
       and t.leitzahl = :old.leitzahl
       and t.freig_status != 'N';

begin
  if inserting or updating
  then
    :new.created_date := nvl(:new.created_date, sysdate);
    :new.created_login_id := nvl(:new.created_login_id, -1);

    v_bde_chargerein := isi_allg.c_get_firma_cfg_param (:new.sid,
                                                        :new.firma_nr,
                                                        'BDE_CHARGE',          -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                        NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                        'BDE_RES_CHARGEREIN',  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                        'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                        'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                        'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                        'STRING');             -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    if :new.res_id = 0 -- R4 Fehler 0 ist nicht möglich
    then
      :new.res_id := NULL;
    end if;

    pps_p_bde.crt_bde_fa_auft_a_plan_DB31 (:new.sid,
                                           :new.firma_nr,
                                           :new.artikel_id,
                                           :new.charge_bez,
                                           :new.res_id,
                                           :new.login_id,
                                           :new.menge,
                                           :new.text1,
                                           :new.text2,
                                           :new.text3,
                                           :new.soll_betriebsart,
                                           :new.kunden_nr,
                                           NULL,  -- in_kd_art_nr => :in_kd_art_nr,
                                           NULL,  -- in_ag_name1 => :in_ag_name1,
                                           NULL,  -- in_ag_name2 => :in_ag_name2,
                                           NULL,  -- in_ag_text1 => :in_ag_text1,
                                           NULL,  -- in_ag_text2 => :in_ag_text2,
                                           NULL,  -- in_ag_text3 => :in_ag_text3,
                                           :new.kenz_lhm_druck,
                                           NULL,  -- in_anz_lte => :in_anz_lte,
                                           NULL,  -- in_anz_lhm => :in_anz_lhm,
                                           :new.best_nr_kunde,
                                           :new.abnr,  -- in_abnr => :in_abnr,
                                           NULL,  -- in_serie_id => :in_serie_id,
                                           NULL,  -- in_serie_auto_inc => :in_serie_auto_inc,
                                           NULL,  -- in_fa_gruppe => :in_fa_gruppe,
                                           v_bde_chargerein,   -- in_dispo_charge_rein => :in_dispo_charge_rein,
                                           :new.hersteller_kuerzel_liste, -- in_hersteller_liste,  -- in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                           :new.lam_sel1,        -- in_lam_sel1          in lvs_lam.LAM_SEL1%type,
                                           :new.lam_sel2,        -- in_lam_sel2          in lvs_lam.LAM_SEL2%type,
                                           :new.lam_sel3,        -- in_lam_sel3          in lvs_lam.LAM_SEL3%type,
                                           :new.lam_sel4,        -- in_lam_sel4          in lvs_lam.LAM_SEL4%type,
                                           :new.lam_sel5,        -- in_lam_sel5          in lvs_lam.LAM_SEL5%type,
                                           :new.lam_sel6,        -- in_lam_sel6          in lvs_lam.LAM_SEL6%type,
                                           :new.lam_sel7,        -- in_lam_sel7          in lvs_lam.LAM_SEL7%type,
                                           :new.lam_sel8,        -- in_lam_sel8          in lvs_lam.LAM_SEL8%type,
                                           :new.lam_sel9,        -- in_lam_sel9          in lvs_lam.LAM_SEL9%type,
                                           :new.lam_sel10,       -- in_lam_sel10         in lvs_lam.LAM_SEL10%type,
                                           :new.adress_id,       -- in_adress_id         in bde_fa_auftrag.adress_id%type,
                                           :new.lohn_arbeit,     -- in_lohn_arbeit
                                           :new.seq_nr,          -- SEQ_NR  N NUMBER  Y     N   Sequenz-Nummer, für das Zielprodukt auf der Fertigungslinie Montage - Ab DB31
                                           :new.lead_leitzahl,   -- LEAD_LEITZAHL N NUMBER  Y     N   Leitzahl des Vorgängerauftrags
                                           :new.primaer_leitzahl,-- PRIMAER_LEITZAHL  N NUMBER  Y     N   Leitzahl des Primärauftrag
                                           :new.leitzahl         -- in_out_leitzahl => :in_out_leitzahl);
                                           );

  else
    -- Pruefen ob der Auftrag breits begonnen ist
    OPEN c_bde_begonnen;
    FETCH c_bde_begonnen into v_anz_bde_beg;
    CLOSE c_bde_begonnen;

    if v_anz_bde_beg > 0
    then
      RAISE_APPLICATION_ERROR(-20005, lc.ec_p2(lc.O_TP2_ARB_PPS_AG_BDE_BEG, :old.leitzahl, v_anz_bde_beg), true);
    end if;
    -- Loeschen derBDE-Daten fuer diesen FA_Auftrag
    delete bde_fa_kopf t
      where t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.fa_nr = :old.leitzahl;

  end if;
end tr_pps_plan_auftrag_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PPS_SIMPLE_FA_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"be0f0cc552fa46b9122050530b3839a9626ac979","type":"TRIGGER","name":"TR_PPS_SIMPLE_FA_BUID","schemaName":"DIRKSPZM32","sxml":""}