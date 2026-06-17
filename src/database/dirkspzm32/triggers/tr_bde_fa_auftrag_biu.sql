
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_FA_AUFTRAG_BIU" 
  before insert or update on DIRKSPZM32.BDE_FA_AUFTRAG
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_found     boolean;

  -- local variables here
  --v_art              isi_artikel%rowtype;
  --v_charge           lvs_charge%rowtype;

  --v_found            boolean;
  --v_anz_lam_res      number;                         -- Anzahl der noch rreservierten LAM's für diese AUF_ID

  --v_anz_res_new                                      bde_fa_auftrag.anz_res%type;
  --v_anz_res_old                                      bde_fa_auftrag.anz_res%type;


  v_ab_ist_mg_new                                    bde_fa_auftrag.ab_ist_mg%type;
  v_ab_ist_mg_old                                    bde_fa_auftrag.ab_ist_mg%type;
  v_ag_ist_mg_new                                    bde_fa_auftrag.ag_ist_mg%type;
  v_ag_ist_mg_old                                    bde_fa_auftrag.ag_ist_mg%type;
  v_ag_ist_mg_b_new                                  bde_fa_auftrag.ag_ist_mg_b%type;
  v_ag_ist_mg_b_old                                  bde_fa_auftrag.ag_ist_mg_b%type;
  v_ag_ist_mg_schrott_new                            bde_fa_auftrag.ag_ist_mg_schrott%type;
  v_ag_ist_mg_schrott_old                            bde_fa_auftrag.ag_ist_mg_schrott%type;
  v_ag_ist_mg_ruesten_new                            bde_fa_auftrag.ag_ist_mg_ruesten%type;
  v_ag_ist_mg_ruesten_old                            bde_fa_auftrag.ag_ist_mg_ruesten%type;
  v_ruest_zeit_ist_new                               bde_fa_auftrag.ruest_zeit_ist%type;
  v_ruest_zeit_ist_old                               bde_fa_auftrag.ruest_zeit_ist%type;
  v_prod_zeit_ist_new                                bde_fa_auftrag.prod_zeit_ist%type;
  v_prod_zeit_ist_old                                bde_fa_auftrag.prod_zeit_ist%type;
  v_stoer_zeit_ist_new                               bde_fa_auftrag.stoer_zeit_ist%type;
  v_stoer_zeit_ist_old                               bde_fa_auftrag.stoer_zeit_ist%type;
  v_zeit_einheit_new                                 bde_fa_auftrag.zeit_einheit%type;
  v_zeit_einheit_old                                 bde_fa_auftrag.zeit_einheit%type;
  v_termin_start_ist_new                             bde_fa_auftrag.termin_start_ist%type;
  v_termin_start_ist_old                             bde_fa_auftrag.termin_start_ist%type;
  v_termin_ende_ist_new                              bde_fa_auftrag.termin_ende_ist%type;
  v_termin_ende_ist_old                              bde_fa_auftrag.termin_ende_ist%type;
  v_freig_status_new                                 bde_fa_auftrag.freig_status%type;
  v_freig_status_old                                 bde_fa_auftrag.freig_status%type;
  --v_freig_wer_new                                    bde_fa_auftrag.freig_wer%type;
  --v_freig_wer_old                                    bde_fa_auftrag.freig_wer%type;
  --v_freig_wann_new                                   bde_fa_auftrag.freig_wann%type;
  --v_freig_wann_old                                   bde_fa_auftrag.freig_wann%type;
  --v_status_res_id_new                                bde_fa_auftrag.status_res_id%type;
  --v_status_res_id_old                                bde_fa_auftrag.status_res_id%type;
  --v_status_id_new                                    bde_fa_auftrag.status_id%type;
  --v_status_id_old                                    bde_fa_auftrag.status_id%type;
  --v_sattus_begin_new                                 bde_fa_auftrag.sattus_begin%type;
  --v_sattus_begin_old                                 bde_fa_auftrag.sattus_begin%type;
  --v_schrott_proz_new                                 bde_fa_auftrag.schrott_proz%type;
  --v_schrott_proz_old                                 bde_fa_auftrag.schrott_proz%type;
  v_nutzen_new                                       bde_fa_auftrag.nutzen%type;
  v_nutzen_old                                       bde_fa_auftrag.nutzen%type;
  v_gewicht_new                                      bde_fa_auftrag.gewicht%type;
  v_gewicht_old                                      bde_fa_auftrag.gewicht%type;
  v_schrott_new                                      bde_fa_auftrag.schrott%type;
  v_schrott_old                                      bde_fa_auftrag.schrott%type;
  v_verbrauch_new                                    bde_fa_auftrag.verbrauch%type;
  v_verbrauch_old                                    bde_fa_auftrag.verbrauch%type;
  v_einsatz_new                                      bde_fa_auftrag.einsatz%type;
  v_einsatz_old                                      bde_fa_auftrag.einsatz%type;
  v_status_freigabe_new                              bde_fa_auftrag.status_freigabe%type;
  --v_status_freigabe_old                              bde_fa_auftrag.status_freigabe%type;
  --v_ag_id_new                                        bde_fa_auftrag.ag_id%type;
  --v_ag_id_old                                        bde_fa_auftrag.ag_id%type;
  --v_charge_id_new                                    bde_fa_auftrag.charge_id%type;
  --v_charge_id_old                                    bde_fa_auftrag.charge_id%type;
  --v_kenz_letzt_ag_new                                bde_fa_auftrag.kenz_letzt_ag%type;
  --v_kenz_letzt_ag_old                                bde_fa_auftrag.kenz_letzt_ag%type;
  v_ag_artikel_id_old                                bde_fa_auftrag.ag_artikel_id%type;
  v_ag_artikel_id_new                                bde_fa_auftrag.ag_artikel_id%type;
  v_fa_auftrag                                       bde_fa_auftrag%rowtype;

  v_bew_id                                           number;
  v_lte_id                      lvs_lte.lte_id%type;
  v_result                      number;

  v_lte                                              lvs_lte%rowtype;
  v_res_result                                       number;

  v_res_name                                         varchar2(50);

  v_opt_grp                                          pps_ruestmatrix_opt_grp%rowtype;
  v_res_zust_akt                                     isi_resource_zust_akt%rowtype;
  v_bde_lte_pool                                     bde_fa_auftrag_lte_pool%rowtype;

  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.order_vorgang_id = :new.leitzahl;

  CURSOR c_lam_lte is
    select l.lte_id, lte.lgr_platz
      from lvs_lam l,
           lvs_lte lte
     where l.order_pos_auf_id = :old.auf_id
       and l.lte_id = lte.lte_id
     group by l.lte_id, lte.lgr_platz;

  v_lam_lte                                          c_lam_lte%rowtype;

  CURSOR c_bde_lte_pool is
    select *
      from bde_fa_auftrag_lte_pool t
     where t.leitzahl = :new.leitzahl
       and t.lte_verwendet != 'V'
       and t.lte_verwendet != 'A';

  /*
  CURSOR c_charge is
    select *
      from lvs_charge c
      where c.sid = :new.sid
        and c.charge_id = :new.charge_id;
  */
begin

  -- AG Bugfix aufgegallen bei Euscher. Evtl durch geänderte SAP-Aufträge
  :new.ag_ist_mg := nvl(:new.ag_ist_mg, 0);
  --v_anz_res_new                     := :new.anz_res;
  --v_anz_res_old                     := :old.anz_res;
  v_ab_ist_mg_new                   := :new.ab_ist_mg;
  v_ab_ist_mg_old                   := :old.ab_ist_mg;
  v_ag_ist_mg_new                   := :new.ag_ist_mg;
  v_ag_ist_mg_old                   := :old.ag_ist_mg;
  v_ag_ist_mg_b_new                 := :new.ag_ist_mg_b;
  v_ag_ist_mg_b_old                 := :old.ag_ist_mg_b;
  v_ag_ist_mg_schrott_new           := :new.ag_ist_mg_schrott;
  v_ag_ist_mg_schrott_old           := :old.ag_ist_mg_schrott;
  v_ag_ist_mg_ruesten_new           := :new.ag_ist_mg_ruesten;
  v_ag_ist_mg_ruesten_old           := :old.ag_ist_mg_ruesten;
  v_ruest_zeit_ist_new              := :new.ruest_zeit_ist;
  v_ruest_zeit_ist_old              := :old.ruest_zeit_ist;
  v_prod_zeit_ist_new               := :new.prod_zeit_ist;
  v_prod_zeit_ist_old               := :old.prod_zeit_ist;
  v_stoer_zeit_ist_new              := :new.stoer_zeit_ist;
  v_stoer_zeit_ist_old              := :old.stoer_zeit_ist;
  v_zeit_einheit_new                := :new.zeit_einheit;
  v_zeit_einheit_old                := :old.zeit_einheit;
  v_termin_start_ist_new            := :new.termin_start_ist;
  v_termin_start_ist_old            := :old.termin_start_ist;
  v_termin_ende_ist_new             := :new.termin_ende_ist;
  v_termin_ende_ist_old             := :old.termin_ende_ist;
  v_freig_status_new                := :new.freig_status;
  v_freig_status_old                := :old.freig_status;
  --v_freig_wer_new                   := :new.freig_wer;
  --v_freig_wer_old                   := :old.freig_wer;
  --v_freig_wann_new                  := :new.freig_wann;
  --v_freig_wann_old                  := :old.freig_wann;
  --v_status_res_id_new               := :new.status_res_id;
  --v_status_res_id_old               := :old.status_res_id;
  --v_status_id_new                   := :new.status_id;
  --v_status_id_old                   := :old.status_id;
  --v_sattus_begin_new                := :new.sattus_begin;
  --v_sattus_begin_old                := :old.sattus_begin;
  --v_schrott_proz_new                := :new.schrott_proz;
  --v_schrott_proz_old                := :old.schrott_proz;
  v_nutzen_new                      := :new.nutzen;
  v_nutzen_old                      := :old.nutzen;
  v_gewicht_new                     := :new.gewicht;
  v_gewicht_old                     := :old.gewicht;
  v_schrott_new                     := :new.schrott;
  v_schrott_old                     := :old.schrott;
  v_verbrauch_new                   := :new.verbrauch;
  v_verbrauch_old                   := :old.verbrauch;
  v_einsatz_new                     := :new.einsatz;
  v_einsatz_old                     := :old.einsatz;
  v_status_freigabe_new             := :new.status_freigabe;
  --v_status_freigabe_old             := :old.status_freigabe;
  --v_charge_id_new                   := :new.charge_id;
  --v_charge_id_old                   := :old.charge_id;
  --v_kenz_letzt_ag_new               := :new.kenz_letzt_ag;
  --v_kenz_letzt_ag_old               := :old.kenz_letzt_ag;
  v_ag_artikel_id_old               := :old.ag_artikel_id;
  v_ag_artikel_id_new               := :new.ag_artikel_id;

  if :new.auf_id is NULL
  then
    select SEQ_ISI_ORDER.NEXTVAL into :new.auf_id from dual;
  end if;

  if :new.ag_opt_grp is not NULL
  and not bde_p_pps.get_pps_ruestmatrix_opt_grp(:new.sid, :new.firma_nr, :new.ag_opt_grp, v_opt_grp)
  then
    insert into pps_ruestmatrix_opt_grp
      values(:new.sid,
             :new.firma_nr,
             :new.ag_opt_grp,
             :new.ag_opt_grp,
             sysdate,
             -1,
             NULL,
             NULL,
             NULL,
             0);
  end if;

  :new.prod_zeit_erf := nvl(:new.prod_zeit_erf, 0);
  :new.ruest_zeit_erf := nvl(:new.ruest_zeit_erf, 0);
  :new.rcv_prod_zeit_erf := nvl(:new.rcv_prod_zeit_erf, 0);
  :new.rcv_ruest_zeit_erf := nvl(:new.rcv_ruest_zeit_erf, 0);

  if inserting
  then
    if :new.CREATED_DATE is NULL
    then
      :new.CREATED_DATE := sysdate;
    end if;
    if :new.CREATED_LOGIN_ID is NULL
    then
      :new.CREATED_LOGIN_ID := -1;
    end if;
  end if;

  if isi_allg.get_firma_cfg_param (:new.sid,
                                   :new.firma_nr,
                                   'BDE',
                                   null,
                                   'BDE_FA_GEN_LTE_ID',
                                   'BDE',
                                   'CFG',
                                   'F',
                                   'BOOLEAN') = c.C_TRUE
  and :new.freig_status = 'N'
  and :new.satzart = 'V'
  and :new.lte_name is not NULL
  then
    update bde_fa_auftrag_lte_pool lte
       set lte.lte_verwendet = 'A'
     where lte.sid = :new.sid
       and lte.firma_nr = :new.firma_nr
       and lte.leitzahl = :new.leitzahl
       and lte.lte_verwendet = 'V';

    OPEN c_bde_lte_pool;
    FETCH c_bde_lte_pool into v_bde_lte_pool;
    v_found := c_bde_lte_pool%FOUND;
    CLOSE c_bde_lte_pool;

    if not v_found
    then
      v_lte_id := lvs_p_lte.lvs_lte_insert_v34(:new.sid,        -- in_sid => :in_sid,
                                               :new.firma_nr,   -- in_firma_nr => :in_firma_nr,
                                               :new.lte_name,   -- in_lte_name => :in_lte_name,
                                               NULL,            -- in_lte_id => :in_lte_id,
                                               -1,              -- in_ls_login_id => :in_ls_login_id,
                                               NULL,            -- in_lgr_ort => :in_lgr_ort,
                                               NULL,            -- in_lgr_platz => :in_lgr_platz,
                                               NULL,            -- in_lte_status => :in_lte_status,
                                               NULL,            -- in_sep_nve => :in_sep_nve,
                                               NULL,            -- in_lte_eti_druck_status => :in_lte_eti_druck_status,
                                               NULL,            -- in_charge_id => :in_charge_id,
                                               NULL,            -- in_charge => :in_charge,
                                               NULL);           -- in_artikel_id => :in_artikel_id);
      insert into bde_fa_auftrag_lte_pool
      values
        (:new.sid,
         :new.firma_nr,
         v_lte_id,
         'R', -- v_lte_verwendet, reserviert
         :new.leitzahl,
         'N',   -- v_status Neu
         nvl((select max(x.lte_lfdn) from bde_fa_auftrag_lte_pool x where x.leitzahl = :new.leitzahl), 0) + 1);
    end if;
  end if;


  if updating
  then
    :new.last_change_date := sysdate;
    if :new.LAST_CHANGE_LOGIN_ID is NULL
    then
      :new.LAST_CHANGE_LOGIN_ID := -1;
    end if;

    if :new.nr_pruefung is not NULL
    and :old.nr_pruefung is NULL
    then
      update lvs_lam l
         set l.nr_pruefung = :new.nr_pruefung
       where l.sid = :new.sid
         and l.firma_nr = :new.firma_nr
         and l.leitzahl = :new.leitzahl
         and ((  l.fa_ag = :new.fa_ag
             and l.fa_upos = :new.fa_upos
              )
           or (  l.fa_ag is NULL
             and :new.kenz_letzt_ag = 1
              )
             )
         and l.nr_pruefung is NULL;
    end if;

    if  :old.job_sequenz is not NULL
    and :new.job_sequenz is NULL
    then
      update aps_fa_vorgangs_position aps
         set aps.fixiert = 0
       where aps.fakopfnr = 'FA' || to_char(:new.leitzahl)
         and aps.favorgangsnr = :new.fa_ag
         and aps.favorgangssplittnr = :new.fa_upos
         and aps.fixiert != 0;
    end if;

    if :new.anz_res > 1
    and isi_allg.get_firma_cfg_param (:new.sid,
                                      :new.firma_nr,
                                      'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                      NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                      'ALLG_RESSOURCE_GRP',  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'Allgemein',           -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                      'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                      'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                      'BOOLEAN') != c.C_TRUE -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    and isi_allg.get_firma_cfg_param (:new.sid,
                                      :new.firma_nr,
                                      'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                      NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                      'ALLG_RESOURCE_LINIE', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'Allgemein',           -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                      'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                      'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                      'BOOLEAN') != c.C_TRUE -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    then
      select r.res_name into v_res_name
        from isi_resource r
       where r.res_id = :old.res_id;
      v_err_nr := 10;
      v_err_text := 'Der FA-Auftrag ist noch an der Maschine ' ||
                    v_res_name ||
                    ' angemeldte.';
      raise v_error;
    end if;
    if v_ag_artikel_id_old <> v_ag_artikel_id_new
    then
      begin
        update isi_resource_lam_akt res
           set res.artikel_id = v_ag_artikel_id_new
         where res.sid = :new.sid
           and res.res_id = :new.res_id
           and res.artikel_id = v_ag_artikel_id_old;
      exception
        when others then NULL; -- Kann denn Satz nicht ändern (Rohstoff bereits in Liste
      end;
    end if;

    -- Diese Werte werden nur von ISIPlus geändert !!!
    if nvl(v_freig_status_new, 'N') != nvl(v_freig_status_old, 'N')
    or nvl(v_freig_status_new, 'AP') != nvl(v_freig_status_old, 'AP')
    or nvl(v_freig_status_new, 'AR') != nvl(v_freig_status_old, 'AR')
    or nvl(v_ab_ist_mg_new, 0) != nvl(v_ab_ist_mg_old, 0)
    or nvl(v_ag_ist_mg_new, 0) != nvl(v_ag_ist_mg_old, 0)
    or nvl(v_ag_ist_mg_b_new, 0) != nvl(v_ag_ist_mg_b_old, 0)
    or nvl(v_ag_ist_mg_schrott_new, 0) != nvl(v_ag_ist_mg_schrott_old, 0)
    or nvl(v_ag_ist_mg_ruesten_new, 0) != nvl(v_ag_ist_mg_ruesten_old, 0)
    or nvl(v_ruest_zeit_ist_new, 0) != nvl(v_ruest_zeit_ist_old, 0)
    or nvl(v_prod_zeit_ist_new, 0) != nvl(v_prod_zeit_ist_old, 0)
    or nvl(v_stoer_zeit_ist_new, 0) != nvl(v_stoer_zeit_ist_old, 0)
    or nvl(v_zeit_einheit_new, 0) != nvl(v_zeit_einheit_old, 0)
    or nvl(v_termin_start_ist_new - sysdate, 0) != nvl(v_termin_start_ist_old - sysdate, 0)
    or nvl(v_termin_ende_ist_new - sysdate, 0) != nvl(v_termin_ende_ist_old - sysdate, 0)
--    or nvl(v_freig_wer_new, 0) != nvl(v_freig_wer_old, 0)
--    or nvl(v_freig_wann_new - sysdate, 0) != nvl(v_freig_wann_old - sysdate, 0)
--    or nvl(v_status_res_id_new, 0) != nvl(v_status_res_id_old, 0)
--    or nvl(v_status_id_new, 0) != nvl(v_status_id_old, 0)
--    or nvl(v_sattus_begin_new - sysdate, 0) != nvl(v_sattus_begin_old - sysdate, 0)
--    or nvl(v_schrott_proz_new, 0) != nvl(v_schrott_proz_old, 0)
    or nvl(v_nutzen_new, 0) != nvl(v_nutzen_old, 0)
    or nvl(v_gewicht_new, 0) != nvl(v_gewicht_old, 0)
    or nvl(v_schrott_new, 0) != nvl(v_schrott_old, 0)
    or nvl(v_verbrauch_new, 0) != nvl(v_verbrauch_old, 0)
    or nvl(v_einsatz_new, 0) != nvl(v_einsatz_old, 0)
--    or nvl(v_status_freigabe_new, 0) != nvl(v_status_freigabe_old, 0)
--    or nvl(v_kenz_letzt_ag_new, 0) != nvl(v_kenz_letzt_ag_old, 0)
    then
      -- AG 20170308 Reservierung löschen wenn aus Dialog der Auftrag als Fertig gesetzt wurde
      if :new.freig_status = 'XF'
      then
        if :new.ma_reserviert = c.C_TRUE
        then
          -- XF ist Ende / Abbruch aus dem Dialog
          OPEN c_lam_lte;
          FETCH c_lam_lte into v_lam_lte;
          LOOP
            EXIT when c_lam_lte%notfound;
            v_res_result := lvs_ausl.lvs_lte_res_rueck(:new.sid,
                                                       :new.firma_nr,
                                                       :new.leitzahl,
                                                       :new.auf_id,
                                                       v_lam_lte.lte_id,
                                                       :new.leitzahl,
                                                       v_lam_lte.lgr_platz,
                                                       c.c_true);
            FETCH c_lam_lte into v_lam_lte;
          end LOOP;
          CLOSE c_lam_lte;
        end if;
      end if;

      if  :new.freig_status = 'TF'
      and :new.ag_ist_mg >= :new.ag_soll_mg
      and :old.ag_ist_mg < :new.ag_ist_mg
      then
        :new.freig_status := 'XF';
      end if;

      if :new.freig_status = 'XF'
      then
        -- dieser Auftruf initialisiert die Auswertung neu und darf nicht gelöscht werden
        :new.prod_zeit_ist := bde_funktionen.get_fa_zeiten(NULL, NULL, NULL, NULL, NULL);
        -- Auswertung der Produktionszeit ermitteln
        :new.prod_zeit_ist := bde_funktionen.get_fa_zeiten_upos(:new.sid, :new.firma_nr, :new.leitzahl, :new.fa_ag, :new.fa_upos, NULL);
        -- Ausgewertete Daten holen
        :new.prod_zeit_ist  := bde_funktionen.get_prod_std() * 60;
        :new.stoer_zeit_ist := bde_funktionen.get_unterbr_std() * 60;
        :new.ruest_zeit_ist := bde_funktionen.get_ruest_std() * 60;
        v_fa_auftrag.sid                   := :new.sid;
        v_fa_auftrag.firma_nr              := :new.firma_nr;
        v_fa_auftrag.abnr                  := :new.abnr;
        v_fa_auftrag.leitzahl              := :new.leitzahl;
        v_fa_auftrag.fa_ag                 := :new.fa_ag;
        v_fa_auftrag.fa_upos               := :new.fa_upos;
        v_fa_auftrag.satzart               := :new.satzart;
        v_fa_auftrag.res_id                := :new.res_id;
        v_fa_auftrag.anz_res               := :new.anz_res;
        v_fa_auftrag.ab_artikel_id         := :new.ab_artikel_id;
        v_fa_auftrag.ab_soll_mg            := :new.ab_soll_mg;
        v_fa_auftrag.ab_ist_mg             := :new.ab_ist_mg;
        v_fa_auftrag.ab_text1              := :new.ab_text1;
        v_fa_auftrag.ab_text2              := :new.ab_text2;
        v_fa_auftrag.ab_text3              := :new.ab_text3;
        v_fa_auftrag.ab_ende_status        := :new.ab_ende_status;
        v_fa_auftrag.ag_soll_mg            := :new.ag_soll_mg;
        v_fa_auftrag.ag_ist_mg             := :new.ag_ist_mg;
        v_fa_auftrag.ag_ist_mg_b           := :new.ag_ist_mg_b;
        v_fa_auftrag.ag_ist_mg_schrott     := :new.ag_ist_mg_schrott;
        v_fa_auftrag.ag_ist_mg_ruesten     := :new.ag_ist_mg_ruesten;
        v_fa_auftrag.ruest_zeit_gepl       := :new.ruest_zeit_gepl;
        v_fa_auftrag.ruest_zeit_ist        := :new.ruest_zeit_ist;
        v_fa_auftrag.prod_zeit_gepl        := :new.prod_zeit_gepl;
        v_fa_auftrag.prod_zeit_ist         := :new.prod_zeit_ist;
        v_fa_auftrag.stoer_zeit_gepl       := :new.stoer_zeit_gepl;
        v_fa_auftrag.stoer_zeit_ist        := :new.stoer_zeit_ist;
        v_fa_auftrag.zeit_einheit          := :new.zeit_einheit;
        v_fa_auftrag.termin_start_gepl     := :new.termin_start_gepl;
        v_fa_auftrag.termin_ende_gepl      := :new.termin_ende_gepl;
        v_fa_auftrag.termin_start_ist      := :new.termin_start_ist;
        v_fa_auftrag.termin_ende_ist       := :new.termin_ende_ist;
        v_fa_auftrag.freig_status          := 'F'; -- :new.freig_status;
        v_fa_auftrag.freig_wer             := :new.freig_wer;
        v_fa_auftrag.freig_wann            := :new.freig_wann;
        v_fa_auftrag.status_res_id         := :new.status_res_id;
        v_fa_auftrag.status_id             := :new.status_id;
        v_fa_auftrag.status_begin          := :new.status_begin;
        v_fa_auftrag.kunden_nr             := :new.kunden_nr;
        v_fa_auftrag.ag_artikel_id         := :new.ag_artikel_id;
        v_fa_auftrag.kd_art_nr             := :new.kd_art_nr;
        v_fa_auftrag.ag_bez1               := :new.ag_bez1;
        v_fa_auftrag.ag_bez2               := :new.ag_bez2;
        v_fa_auftrag.ag_text1              := :new.ag_text1;
        v_fa_auftrag.ag_text2              := :new.ag_text2;
        v_fa_auftrag.ag_text3              := :new.ag_text3;
        v_fa_auftrag.zeichnung             := :new.zeichnung;
        v_fa_auftrag.schrott_proz          := :new.schrott_proz;
        v_fa_auftrag.nutzen                := :new.nutzen;
        v_fa_auftrag.gewicht               := :new.gewicht;
        v_fa_auftrag.schrott               := :new.schrott;
        v_fa_auftrag.verbrauch             := :new.verbrauch;
        v_fa_auftrag.einsatz               := :new.einsatz;
        v_fa_auftrag.max_takt_ausf_zeit    := :new.max_takt_ausf_zeit;
        v_fa_auftrag.min_takt_zeit         := :new.min_takt_zeit;
        v_fa_auftrag.max_takt_zeit         := :new.max_takt_zeit;
        v_fa_auftrag.status_freigabe       := :new.status_freigabe;
        v_fa_auftrag.ag_id                 := :new.ag_id;
        v_fa_auftrag.charge_id             := :new.charge_id;
        v_fa_auftrag.kenz_letzt_ag         := :new.kenz_letzt_ag;
        v_fa_auftrag.zeichnung_index       := :new.zeichnung_index;
        v_fa_auftrag.lhm_name              := :new.lhm_name;
        v_fa_auftrag.lhm_menge             := :new.lhm_menge;
        v_fa_auftrag.lte_name              := :new.lte_name;
        v_fa_auftrag.lte_menge             := :new.lte_menge;
        v_fa_auftrag.rcv_ag_ist_mg         := :new.rcv_ag_ist_mg;
        v_fa_auftrag.rcv_ag_ist_mg_b       := :new.rcv_ag_ist_mg_b;
        v_fa_auftrag.rcv_ag_ist_mg_schrott := :new.rcv_ag_ist_mg_schrott;
        v_fa_auftrag.rcv_ag_ist_mg_ruesten := :new.rcv_ag_ist_mg_ruesten;
        v_fa_auftrag.rcv_ruest_zeit_ist    := :new.rcv_ruest_zeit_ist;
        -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
        v_fa_auftrag.rcv_prod_zeit_ist     := :new.rcv_prod_zeit_ist;
        v_fa_auftrag.rcv_stoer_zeit_ist    := :new.rcv_stoer_zeit_ist;
        v_fa_auftrag.rcv_ruest_zeit_erf    := :new.rcv_ruest_zeit_erf;
        v_fa_auftrag.rcv_prod_zeit_erf     := :new.rcv_prod_zeit_erf;

        v_bew_id := s_schnittstelle.write_host_prod_bew(v_fa_auftrag.sid, v_fa_auftrag.firma_nr,
                    v_fa_auftrag, NULL, NULL, NULL, NULL, 'S_FA', 'UE');

        :new.freig_status := 'F';
         -- -AG- Auftrag Status ist Fertig und Mengen und zeit sin zum Host übergeben
        :new.rcv_ag_ist_mg         := :new.ag_ist_mg;
        :new.rcv_ag_ist_mg_b       := :new.ag_ist_mg_b;
        :new.rcv_ag_ist_mg_schrott := :new.ag_ist_mg_schrott;
        :new.rcv_ag_ist_mg_ruesten := :new.ag_ist_mg_ruesten;
        :new.rcv_ruest_zeit_ist    := :new.ruest_zeit_ist;
        :new.rcv_prod_zeit_ist     := :new.prod_zeit_ist;
        :new.rcv_stoer_zeit_ist    := :new.stoer_zeit_ist;
        :new.rcv_ruest_zeit_erf    := :new.ruest_zeit_erf;
        :new.rcv_prod_zeit_erf     := :new.prod_zeit_erf;
      end if;

      if  nvl(v_freig_status_old, 'N') = 'N'
      and nvl(v_freig_status_new, 'N') != 'N'
      then
        insert into s_send_bew send
           values (
              NULL,                    -- BEW_ID          NUMBER,
              :new.firma_nr,           -- FIRMA_NR        NUMBER(3),
              'ISI',                   -- HERKUNFT        VARCHAR2(3),
              'S_FA',                  -- TABELLE         VARCHAR2(5),
              :new.ag_id,              -- AUF_ID          NUMBER,
              'UE',                    -- STATUS          VARCHAR2(3),
              'AA',                    -- AKTION          VARCHAR2(3),
              NULL,                    -- MA_STATUS       VARCHAR2(1),
              NULL,                    -- MA_S_GRUND      NUMBER(3),
              NULL,                    -- MA_ID           VARCHAR2(10),
              NULL,                    -- LTE_NR          VARCHAR2(20),
              NULL,                    -- LHM_NR          VARCHAR2(20),
              NULL,                    -- LAGERORT        VARCHAR2(10),
              NULL,                    -- ZLAGERORT       VARCHAR2(10),
              NULL,                    -- MENGE           NUMBER(12,3),
              NULL,                    -- MENGE_B         NUMBER(12,3),
              NULL,                    -- SCHROTT         NUMBER(12,3),
              NULL,                    -- R_MENGE         NUMBER(12,3),
              NULL,                    -- R_MENGE_B       NUMBER(12,3),
              NULL,                    -- R_SCHROTT       NUMBER(12,3),
              NULL,                    -- STOERZEIT_IST   NUMBER,
              NULL,                    -- RUESTZEIT_IST   NUMBER,
              NULL,                    -- PRODZEIT_IST    NUMBER,
              NULL,                    -- EXT_LIEF_NR     VARCHAR2(15),
              NULL,                    -- EXT_LIEF_POS    VARCHAR2(5),
              NULL,                    -- CHARGE          VARCHAR2(20),
              NULL,                    -- SERIE           VARCHAR2(20),
              NULL,                    -- ARBEITSPLATZ_ID VARCHAR2(20),
              NULL,                    -- IST_BESTAND     NUMBER,
              NULL,                    -- ARTIKEL         VARCHAR2(20),
              sysdate,                 -- B_DATUM         DATE,
              NULL,                    -- LAM_ID          NUMBER,
              NULL,                    -- LAM_BH_ID       NUMBER,
              NULL,                    -- LAM_BH_TYP      VARCHAR2(2)
              :new.leitzahl,           -- LEITZAHL        NUMBER,
              :new.fa_ag,              -- FA_AG           NUMBER,
              :new.fa_upos,            -- FA_UPOS         NUMBER
              NULL,                    -- LAM_AG          NUMBER
              NULL,                    -- BRUTTO_KG
              NULL,                    -- TEXT            VARCHAR2(40),
              NULL,                    -- ERR_NR          NUMBER
              NULL,                    -- USER_NAME       VARCHAR2(100),
              NULL,                    -- RES_ID          NUMBER
              NULL,                    -- SEND_ID         NUMBER
              NULL,                    -- MA_LAST_S_GRUND  NUMBER
              NULL,                    -- PERS_NR          NUMBER
              NULL,                    -- SPER_GRUND      VARCHAR2(30)
              NULL,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
              NULL,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
              NULL,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
              NULL,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                     -- LTE_NAME N VARCHAR2(15)  Y     Art, Name der Transporteinheit
              NULL,                     -- ORDER_POS_AUF_ID N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
              NULL,                     -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
              NULL);                    -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden



        update bde_fa_kopf t
           set t.status = 'B'
         where t.sid = :new.sid
           and t.firma_nr = :new.firma_nr
           and t.fa_nr = :new.leitzahl
           and t.status = 'N';
      end if;

      if  :new.freig_status = 'F'
      and :new.kenz_letzt_ag = 1
      then
        update bde_fa_kopf t
           set t.status = 'F'
         where t.sid = :new.sid
           and t.firma_nr = :new.firma_nr
           and t.fa_nr = :new.leitzahl
           and t.status != 'FH';
        OPEN c_lte;
        FETCH c_lte into v_lte;
        LOOP
          EXIT when c_lte%notfound;
          v_res_result := lvs_ausl.lvs_lte_res_rueck(v_lte.sid,
                                                     v_lte.firma_nr,
                                                     v_lte.order_vorgang_id,
                                                     v_lte.order_auf_id,
                                                     v_lte.lte_id,
                                                     v_lte.order_vorgang_id,
                                                     v_lte.lgr_platz,
                                                     c.c_true);
          FETCH c_lte into v_lte;
        end LOOP;
        CLOSE c_lte;
      end if;
      /* Wird nicht mehr benötigt
      update s_rcv_fa_auf fa_auf
         set
            fa_auf.ag_status = :new.freig_status,
            fa_auf.ab_ist = v_ab_ist_mg_new,
            fa_auf.ag_ist_mg = v_ag_ist_mg_new,
            fa_auf.ag_ist_mg_b = v_ag_ist_mg_b_new,
            fa_auf.ag_ist_schrott = v_ag_ist_mg_schrott_new,
            fa_auf.ag_ist_ruesten = v_ag_ist_mg_ruesten_new,
            fa_auf.ruest_zeit_ist = v_ruest_zeit_ist_new,
            fa_auf.prod_zeit_ist = v_prod_zeit_ist_new,
            fa_auf.stoer_zeit_ist = v_stoer_zeit_ist_new,
            fa_auf.zeit_einheit = v_zeit_einheit_new,
            fa_auf.start_ist = v_termin_start_ist_new,
            fa_auf.ende_ist = v_termin_ende_ist_new,
            fa_auf.nutzen = v_nutzen_new,
            fa_auf.gewicht = v_gewicht_new,
            fa_auf.schrott = v_schortt_new,
            fa_auf.verbrauch = v_verbrauch_new,
            fa_auf.einsatz = v_einsatz_new,
            fa_auf.ag_freigabe_st = v_status_freigabe_new
         where fa_auf.auf_id = to_number(:new.ag_id);
      */
    end if;
  end if;

exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end TR_BDE_FA_AUFTRAG_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_FA_AUFTRAG_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"c084f3d444aea4235344f79b78c22d5e69f77464","type":"TRIGGER","name":"TR_BDE_FA_AUFTRAG_BIU","schemaName":"DIRKSPZM32","sxml":""}