
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."LVS_V_KONSI_BESTAND_RW_KOMP" ("ADR_NR", "NAME_1", "ADR_LIEFER", "LGR_PLATZ", "LTE_ID", "LTE_NAME", "LGR_ORT", "ARTIKEL", "BEZEICHNUNG1", "WAREN_GRUPPE", "LTE_LETZTE_BUCHUNG", "MENGENEINHEIT", "MENGE", "LABOR_STATUS", "VERBAUT") AS 
  select adr.adr_nr,
       adr.name_1,
       adr.adr_liefer,
       lam.lgr_platz,
       lam.lte_id,
       lte.lte_name,
       lgr.lgr_ort,
       a.artikel,
       a.bezeichnung1,
       a.waren_gruppe,
       lte.lte_letzte_buchung,
       a.mengeneinheit,
       sum(lam.menge) menge,
       lam.labor_status,
       'F' verbaut
  from lvs_lam lam,
       lvs_lte lte,
       isi_artikel a,
       lvs_lgr lgr,
       isi_adressen adr
where lam.artikel_id = a.artikel_id
  and lam.fa_ag is NULL
  and lam.lte_id = lte.lte_id
  and lam.fa_ag is NULL
  and lgr.lgr_platz = lte.lgr_platz
  and lgr.akt_inventur_id is null                      -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
  --and lam.labor_status = 'F'
  and lte.lte_status != 'AG'
  and lte.lte_status != 'KF'
  and lte.lte_status != 'PF'
  and (   a.waren_typ = 'RW'
       or (a.waren_typ = 'FW' and lam.leitzahl is NULL)
      )
  and lam.owner_address_id is not NULL
  and lam.owner_address_id = adr.adress_id
  and isi_allg.c_get_firma_cfg_param(in_sid => lgr.sid,
                                     in_firma_nr => lgr.firma_nr,
                                     in_kategorie => 'CFG',
                                     in_kategorie_ix => 'LGR_PLAETZE_NICHT_BERUEKSICHTIGEN',
                                     in_parameter_name => 'LVS_V_KONSI_BESTAND_RW_KOMP',
                                     in_modul_name => 'lvs',
                                     in_typ => 'CFG',
                                     in_default_param_wert => 'None;',
                                     in_default_param_typ => 'STRING') not like '%' || lgr.lgr_platz ||';%'
  and (lgr.lgr_verwendung = 'Lager' or
       lgr.lgr_platz in (select x.lager_roh from isi_resource x) or
       lgr.lgr_platz in (select x.lager_fertig from isi_resource x)or
       lgr.lgr_platz in (select x.res_name from isi_resource x))
group by a.artikel,
         a.bezeichnung1,
         a.waren_gruppe,
         lam.hersteller_kuerzel_liste,
         lam.owner_address_id,
         lam.labor_status,
         lgr.lgr_ort,
         a.mengeneinheit,
         a.waren_gruppe,
         lgr.lgr_platz,
         adr.adr_liefer,
         adr.adr_nr,
         adr.name_1,
         lam.lte_id,
         lam.lgr_platz,
         lte.lgr_ort,
         lte.lte_letzte_buchung,
         lte.lte_name
union all
select adr.adr_nr,
       adr.name_1,
       adr.adr_liefer,
       lam.lgr_platz,
       lam.lte_id,
       lte.lte_name,
       lte.lgr_ort,
       stl_a.artikel,
       stl_a.bezeichnung1,
       stl_a.waren_gruppe,
       lte.lte_letzte_buchung,
       stl_a.mengeneinheit,
       sum(lam.menge),
       lam.labor_status,
       'T' verbaut
  from lvs_lam lam,
       lvs_lte lte,
       isi_artikel a,
       lvs_lgr lgr,
       bde_pd_prod pd,
       pps_v_artikel_stl stl,
       isi_artikel stl_a,
       isi_adressen adr,
       lvs_lam lam_k
where lam.artikel_id = a.artikel_id
  and lam.fa_ag is NULL
  and lam.lte_id = lte.lte_id
  and lam.fa_ag is NULL
  and lgr.lgr_platz = lte.lgr_platz
  and lgr.akt_inventur_id is null                      -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
  -- and lam.labor_status = 'F'
  and lte.lte_status != 'AG'
  and lte.lte_status != 'KF'
  and lte.lte_status != 'PF'
  and a.artikel = stl.artikel
  and stl.stl_artikel = stl_a.artikel
  and lam_k.owner_address_id is not NULL
  and lam_k.owner_address_id = adr.adress_id(+)
  and lam.fae_id = pd.fae_id
  and pd.vorg_typ = 'PB'
  and pd.artikel_id = stl_a.artikel_id
  and pd.lam_id = lam_k.lam_id
  and isi_allg.c_get_firma_cfg_param(in_sid => lgr.sid,
                                     in_firma_nr => lgr.firma_nr,
                                     in_kategorie => 'CFG',
                                     in_kategorie_ix => 'LGR_PLAETZE_NICHT_BERUEKSICHTIGEN',
                                     in_parameter_name => 'LVS_V_KONSI_BESTAND_RW_KOMP',
                                     in_modul_name => 'lvs',
                                     in_typ => 'CFG',
                                     in_default_param_wert => 'None;',
                                     in_default_param_typ => 'STRING') not like '%' || lgr.lgr_platz ||';%'
  and (lgr.lgr_verwendung = 'Lager' or
       lgr.lgr_platz in (select x.lager_roh from isi_resource x) or
       lgr.lgr_platz in (select x.lager_fertig from isi_resource x)or
       lgr.lgr_platz in (select x.res_name from isi_resource x))
group by stl_a.artikel,
         stl_a.bezeichnung1,
         stl_a.waren_gruppe,
         lam_k.hersteller_kuerzel_liste,
         lam_k.owner_address_id,
         lam.labor_status,
         lam.lgr_platz,
         lgr.lgr_ort,
         stl_a.mengeneinheit,
         lgr.lgr_platz,
         adr.adr_nr,
         adr.adr_liefer,
         adr.name_1,
         lam.lte_id,
         lte.lgr_ort,
         lte.lte_letzte_buchung,
         lte.lte_name
union all
select adr.adr_nr,
       adr.name_1,
       adr.adr_liefer,
       lam.lgr_platz,
       lam.lte_id,
       lte.lte_name,
       lte.lgr_ort,
       stl_a.artikel,
       stl_a.bezeichnung1,
       stl_a.waren_gruppe,
       lte.lte_letzte_buchung,
       stl_a.mengeneinheit,
       sum(lam.menge),
       lam.labor_status,
       'T' verbaut
  from lvs_lam lam,
       lvs_lte lte,
       isi_artikel a,
       lvs_lgr lgr,
       bde_pd_prod pd,
       pps_v_artikel_stl stl,
       isi_artikel stl_a,
       isi_adressen adr,
       lvs_lam_hist lam_k
where lam.artikel_id = a.artikel_id
  and lam.fa_ag is NULL
  and lam.lte_id = lte.lte_id
  and lam.fa_ag is NULL
  and lgr.lgr_platz = lte.lgr_platz
  and lgr.akt_inventur_id is null                      -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
  --and lam.labor_status = 'F'
  and lte.lte_status != 'AG'
  and lte.lte_status != 'KF'
  and lte.lte_status != 'PF'
  and a.artikel = stl.artikel
  and stl.stl_artikel = stl_a.artikel
  and lam_k.owner_address_id is not NULL
  and lam_k.owner_address_id = adr.adress_id(+)
  and lam.fae_id = pd.fae_id
  and pd.vorg_typ = 'PB'
  and pd.artikel_id = stl_a.artikel_id
  and pd.lam_id = lam_k.lam_id
  and isi_allg.c_get_firma_cfg_param(in_sid => lgr.sid,
                                     in_firma_nr => lgr.firma_nr,
                                     in_kategorie => 'CFG',
                                     in_kategorie_ix => 'LGR_PLAETZE_NICHT_BERUEKSICHTIGEN',
                                     in_parameter_name => 'LVS_V_KONSI_BESTAND_RW_KOMP',
                                     in_modul_name => 'lvs',
                                     in_typ => 'CFG',
                                     in_default_param_wert => 'None;',
                                     in_default_param_typ => 'STRING') not like '%' || lgr.lgr_platz ||';%'
  and (lgr.lgr_verwendung = 'Lager' or
       lgr.lgr_platz in (select x.lager_roh from isi_resource x) or
       lgr.lgr_platz in (select x.lager_fertig from isi_resource x)or
       lgr.lgr_platz in (select x.res_name from isi_resource x))
group by stl_a.artikel,
         stl_a.bezeichnung1,
         stl_a.waren_gruppe,
         lam_k.hersteller_kuerzel_liste,
         lam_k.owner_address_id,
         lam.labor_status,
         lam.lgr_platz,
         lgr.lgr_ort,
         stl_a.mengeneinheit,
         lgr.lgr_platz,
         adr.adr_nr,
         adr.adr_liefer,
         adr.name_1,
         lam.lte_id,
         lte.lgr_ort,
         lte.lte_letzte_buchung,
         lte.lte_name
;


-- sqlcl_snapshot {"hash":"429d5ee2fc8e27fe9a976b69eb231269340c9a9e","type":"VIEW","name":"LVS_V_KONSI_BESTAND_RW_KOMP","schemaName":"DIRKSPZM32","sxml":""}