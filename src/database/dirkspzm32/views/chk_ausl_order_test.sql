
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."CHK_AUSL_ORDER_TEST" ("VORGANG_ID", "AUF_ID", "ARTIKEL", "LTE_ID", "LGR_PLATZ", "RESERVIERT", "LGR_VERWENDUNG_LTE_STATUS", "CHECK_FA", "Q_LGR_ORT_SEMIKOLON", "LAM_MENGE_ULHM", "Q_LGR_ORT_ORDER_LTE", "ORDER_POS_AUTO_DEPAL", "ORDER_POS_WARE_DISPONIERT", "M_INV", "LABOR_ST", "LAM_SEL1_10", "CHARGE", "SERIE", "MHD", "MIN_MHD", "ANBRUCH", "CHK_RESERV", "KONSI", "P_DATUM", "LGR_GESPERRT", "L_INV", "L_ORTE", "FARZEUG_OK", "Z_IDX", "Z_MENGE", "LEITZAHL", "FA_AG", "MENGE", "RESERVIERTE_MENGE", "ReifeZeit", "LAM_TEXT", "ZUG_DATUM", "LABOR_STATUS", "LAM_RES_FUER_AUF_ID", "LTE_RES_FUER_VORGANG_ID", "PLATZ_GESP", "LGR_VERWENDUNG", "LAM_MHD", "RES_MHD", "CHARGE_BEZ", "MIN_MHD_R", "AUSL_SORT", "AUSL_SORT2", "KUNDEN_NR", "NAME_1") AS 
  select op.vorgang_id,
           op.auf_id,
           a.artikel,
           lte.lte_id,
           lte.lgr_platz,
           decode(nvl(lte.order_vorgang_id, lam.order_pos_auf_id), NULL, 'Frei', 'Reserviert') Reserviert,
           case when (lgr.lgr_verwendung = C.R_LGR_TYP_LAGER
                   and   lte.lte_status = C.R_LTE_LF_STAT)
                  or (lgr.lgr_verwendung = C.R_LGR_TYP_WE          -- Nur WE's wenn Palette grade fertig befüllt (Maschine)
                   and   lte.lte_status = C.R_LTE_BF_STAT
                   and not exists (select lgr_ort.lgr_ort           -- WE vom MFR sind TABU
                                     from lvs_lgr_ort lgr_ort
                                    where lgr_ort.sid = lgr.sid
                                      and lgr_ort.firma_nr = lgr.firma_nr
                                      and lgr_ort.lgr_ort = lgr.lgr_ort
                                      and lgr_ort.lgr_ort_modul = 'MFR'))
                  or    (lgr.lgr_verwendung = C.R_LGR_TYP_LAGERP      -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                   and   lte.lte_status = C.R_LTE_BF_STAT)
                  then 'OK LGR ' || lgr.lgr_verwendung || ' mit LTE_Status ' || lte.lte_status
                  else case when lte.lte_status = C.R_LTE_LF_STAT or lte.lte_status = C.R_LTE_BF_STAT
                            then '??? LGR ' || lgr.lgr_verwendung || ' mit LTE_Status ' || lte.lte_status
                            else 'ERR LGR ' || lgr.lgr_verwendung || ' mit LTE_Status ' || lte.lte_status
                            end
                  end LGR_VERWENDUNG_LTE_STATUS,
           case when nvl(lam.leitzahl, -1) = nvl(op.leitzahl, nvl(lam.leitzahl, -1)) -- Leitzahl beruecksichtigen
                 and nvl(lam.fa_ag, -1) = nvl(op.fa_ag, -1)-- Nur Ware die als Lagerware gilt !!!! AG <> NULL ist halbfertigware
                 then
                   'OK FA'
                 else
                   'ERR FA'
                end check_fa,
           case when op.quell_lagerorte like '%;'
                 then
                   'OK'
                 else
                   'ERR: ' || op.quell_lagerorte
                 end q_lgr_ort_semikolon,
           case when (min(op.soll_menge) - min(op.ist_menge)) < min(lam.menge)
                 and min(op.wa_menge_ueberlief) = 'ULHM'
                 then
                   'ERR: ' || to_char((min(op.soll_menge) - min(op.ist_menge))) || ' < ' || to_char(min(lam.menge))
                 else
                   'OK'
                 end LAM_Menge_ULHM,
           case when op.quell_lagerorte like '%' || lte.lgr_ort || ';%'
                 then
                   'OK'
                 else
                   'ERR: ' || op.quell_lagerorte || '-> ' || lte.lgr_ort
                 end q_lgr_ort_order_lte,
           case when lte.auto_depal = 'T'
                 then
                   'OK'
                 else
                   case when op.komm_vorgabe_auto_depal = 'R'
                   then
                     'ERR: LTE_AUTO_DEPAL!'
                   else
                     'OK'
                   end
                 end order_pos_auto_depal,
           case when op.ware_disponiert = 'F'
                 then
                   'OK'
                 else
                   'ERR: Ware bereits disponiert!'
                 end order_pos_ware_disponiert,
           case when lam.akt_inventur_id is null                      -- nur Ware reservieren die nicht in Inventur sind
                 then
                   'OK'
                 else
                   'ERR'
                end m_inv,
           case when lam.labor_status = nvl(op.labor_status, c.R_LAB_STAT_F)
                 then
                   'OK'
                 else
                   'ERR ' || lam.labor_status
                end Labor_ST,
           case when nvl(lam.lam_sel1, 'lam.lam_sel') = nvl(op.lam_sel1, 'lam.lam_sel')
                 and nvl(lam.lam_sel2, 'lam.lam_sel') = nvl(op.lam_sel2, 'lam.lam_sel')
                 and nvl(lam.lam_sel3, 'lam.lam_sel') = nvl(op.lam_sel3, 'lam.lam_sel')
                 and nvl(lam.lam_sel4, 'lam.lam_sel') = nvl(op.lam_sel4, 'lam.lam_sel')
                 and nvl(lam.lam_sel5, 'lam.lam_sel') = nvl(op.lam_sel5, 'lam.lam_sel')
                 and nvl(lam.lam_sel6, 'lam.lam_sel') = nvl(op.lam_sel6, 'lam.lam_sel')
                 and nvl(lam.lam_sel7, 'lam.lam_sel') = nvl(op.lam_sel7, 'lam.lam_sel')
                 and nvl(lam.lam_sel8, 'lam.lam_sel') = nvl(op.lam_sel8, 'lam.lam_sel')
                 and nvl(lam.lam_sel9, 'lam.lam_sel') = nvl(op.lam_sel9, 'lam.lam_sel')
                 and nvl(lam.lam_sel10, 'lam.lam_sel') = nvl(op.lam_sel10, 'lam.lam_sel')
                 then
                   'OK'
                 else
                   'ERR'
                end lam_sel1_10,
           case when nvl(lam.charge_id, -1) = nvl(op.charge_id, nvl(lam.charge_id, -1)) -- Charge Passt?
                 then
                   'OK'
                 else
                   'ERR'
                end charge,
           case when nvl(lam.serie_id, -1) = nvl(op.seriennr_id, nvl(lam.serie_id, -1)) -- SERIENNR passt?
                 then
                   'OK'
                 else
                   'ERR'
                end serie,
           case when trunc(lam.lam_mhd) = nvl(trunc(op.mhd), trunc(lam.lam_mhd))
                 then
                   'OK'
                 else
                   'ERR'
                end mhd,
           case when (lam.lam_mhd >= nvl(sysdate + nvl(op.min_mhd_tage, 0), lam.lam_mhd) -- Wenn im Auftrag -1 als Min-MHD dann auch abgelaufene Ware OK
                       or op.mhd is not NULL)
                 then
                   'OK'
                 else
                   'ERR'
                end min_mhd,
           case when ( nvl(op.anbruch, C.R_C_ANBRUCH_IGNORE) = C.R_C_ANBRUCH_IGNORE
                       or nvl(lte.lte_voll, C.R_LTE_VOLL_A) = decode(op.anbruch,
                                                                     C.R_C_TRUE, C.R_LTE_VOLL_A,
                                                                     C.R_C_ANBRUCH_VORZUG, C.R_LTE_VOLL_A,
                                                                     C.R_C_ANBRUCH_AUSNAHME, C.R_LTE_VOLL_A,
                                                                     C.R_LTE_VOLL_V)
                       or nvl(lte.lte_voll, C.R_LTE_VOLL_V) = decode(op.anbruch,
                                                                     C.R_C_FALSE, C.R_LTE_VOLL_V,
                                                                     C.R_C_ANBRUCH_VORZUG, C.R_LTE_VOLL_V,
                                                                     C.R_C_ANBRUCH_AUSNAHME, C.R_LTE_VOLL_V,
                                                                     C.R_LTE_VOLL_A)
                      )
                 then
                   'OK ' || C.DECODE_LTE_VOLL(lte.lte_voll)
                 else
                   'ERR ' || C.DECODE_LTE_VOLL(lte.lte_voll)
                end anbruch,
           case when nvl(lam.order_pos_auf_id, op.auf_id) != op.auf_id
                  or nvl(lte.order_vorgang_id, op.vorgang_id) != op.vorgang_id
                 then
                   'ERR'
                 else
                   'OK'
                end chk_reserv,
           -- Jetzt noch Prüfen ob KONSI
           case when (   (    lam.owner_address_id is NULL              -- Keine KONSI-Ware
                          and nvl(op.satzart, 'LK') = 'LK'              -- Kein KONSI Lieferschein
                         )
                      or (    lam.owner_address_id is NOT NULL          -- KONSI-Ware
                          and nvl(op.satzart, 'X') != 'LK'               -- KONSI Lieferschein
                         )
                     )
                 then
                   'ERR'
                 else
                   'OK'
                end KONSI,
           case when nvl(sysdate - lam.prod_datum, -1) >= decode (sysdate - lam.prod_datum, NULL, -1, nvl(nvl(op.min_reifezeit * -1, -1), nvl(sysdate - lam.prod_datum, -1)))
                 then
                   'OK'
                 else
                   'ERR'
                end p_datum,
           case when lgr.gesperrt = C.R_LGR_GESPERRT_F
                 then
                   'OK'
                 else
                   'ERR'
                end LGR_GESPERRT,
           case when lgr.akt_inventur_id is null                      -- nur Ware reservieren die nicht in Inventur sind
                 then
                   'OK'
                 else
                   'ERR'
                end l_inv,
           case when op.quell_lagerorte like '%' || lte.lgr_ort || ';%'
                  or (instr(nvl(lvs_lager_opt.lvs_lort_format(op.kom_lgr_orte), (select lvs_lager_opt.lvs_lort_format(ap.modul_parameter) lo
                                                    from isi_arbeitsplatz_cfg ap
                                                   where ap.arbeitsplatz_id = 1
                                                     and ap.modul_name = 'LVS'
                                                     and ap.modul_funktion = 'AUSL_ORTE')),
                                                     lpad(to_char(lte.lgr_ort), c.R_LORT_LAENGE - 1, '0') || ';') > 0)
                 then
                   'OK'
                 else
                   'ERR M ' || lpad(to_char(lte.lgr_ort), c.R_LORT_LAENGE - 1, '0') || ';' ||
                      ' O ' || nvl(lvs_lager_opt.lvs_lort_format(op.kom_lgr_orte), (select lvs_lager_opt.lvs_lort_format(ap.modul_parameter) lo
                                                    from isi_arbeitsplatz_cfg ap
                                                   where ap.arbeitsplatz_id = 1
                                                     and ap.modul_name = 'LVS'
                                                     and ap.modul_funktion = 'AUSL_ORTE'))
                end l_orte,
           lvs_p_lgr_grp_fahrzeuge.chk_lte_lgr_zugriff_ok(lte.lte_id) Farzeug_OK,
          -- Berücksichtigen des Zeichnungsindex
           case when nvl(lam.zeichnung_index, 'Kein_I') = nvl(nvl(op.zeichnung_index, lam.zeichnung_index), 'Kein_I')
                 then
                   'OK'
                 else
                   'ERR MI <' || lam.zeichnung_index || '>, OI <' || op.zeichnung_index || '>'
                end z_idx,
           case when nvl(sum(lam.menge), 0) > 0
                 then
                   'OK'
                 else
                   'ERR'
                end z_menge,
           lam.leitzahl,
           lam.fa_ag,
           sum(lam.menge) menge,
           sum(lam.res_menge) reservierte_menge,
           (trunc(sysdate)-trunc(min(lam.zug_datum))) As "ReifeZeit" ,
           lam.lam_text,
           lam.zug_datum,
           lam.labor_status,
           lam.order_pos_auf_id lam_res_fuer_auf_id,
           lte.order_vorgang_id lte_res_fuer_vorgang_id,
           lgr.gesperrt platz_gesp,
           lgr.lgr_verwendung,
           lam.lam_mhd,
           lte.res_mhd,
           ch.charge_bez,
           nvl(op.min_mhd_tage, C.R_MHD_FW_MIN_TAGE) min_mhd_r,
           trunc(lvs_ausl.lvs_lte_platz_bewerten(op.sid, op.firma_nr, op.strategie, op.anbruch,
                                                 lte.lte_voll, nvl(min(lam.lam_mhd), lte.res_mhd), trunc(min(lam.prod_datum)), lte.lte_id, lte.lgr_platz, lte.res_string,
                                                 lgr.lgr_platz_gruppe, lgr.lgr_typ, a.artikel_id)) ausl_sort,
           lvs_ausl.lvs_lte_platz_bewerten(op.sid, op.firma_nr, op.strategie, op.anbruch,
                                           lte.lte_voll, nvl(min(lam.lam_mhd), lte.res_mhd), trunc(min(lam.prod_datum)), lte.lte_id, lte.lgr_platz, lte.res_string,
                                           lgr.lgr_platz_gruppe, lgr.lgr_typ, a.artikel_id) ausl_sort2,
           min(lam.kunden_nr) kunden_nr,
           min(adr.name_1) name_1
      from lvs_lte lte,
           lvs_lam lam,
           lvs_lgr lgr,
           lvs_charge ch,
           isi_adressen adr,
           isi_artikel a,
           isi_order_pos op
     where lte.sid = lam.sid
       and lte.lte_id = lam.lte_id
       and lte.lte_status not in ('AF', 'AG', 'KF')
       and lgr.sid = op.sid
       and lgr.lgr_platz = lte.lgr_platz
       and lam.sid = op.sid
       and lam.firma_nr = op.firma_nr
       and lam.artikel_id = a.artikel_id
       and a.artikel_id = op.artikel_id
       and lam.sid = ch.sid(+)
       and lam.charge_id = ch.charge_id(+)
       and adr.sid(+) = lam.sid
       and adr.firma_nr(+) = lam.firma_nr
       and adr.adr_art(+) = 'K'
       and adr.adr_nr(+) = lam.kunden_nr
       and adr.adr_liefer(+) = 0
  group by lgr.sid,
           lgr.firma_nr,
           lgr.lgr_ort,
           lte.lte_id,
           lte.lte_voll,
           lam.lam_mhd,
           lam.artikel_id,
           lam.order_pos_auf_id,
           trunc(lam.prod_datum),
           lam.lam_text,
           lam.charge_id,
           lam.labor_status,
           lam.akt_inventur_id,
           a.artikel_id,
           a.artikel,
           lam.zug_datum,
           ch.charge_bez,
           lgr.lgr_platz,
           lgr.gesperrt,
           lte.lgr_ort, lte.lgr_platz,
           lte.res_string,
           lte.res_mhd,
           lte.order_vorgang_id,
           lgr.lgr_platz_gruppe, lgr.lgr_typ,
           lgr.akt_inventur_id,
           lam.mengeneinheit_basis,
           lam.leitzahl,
           lam.fa_ag,
           lte.lte_status,
           lgr.lgr_verwendung,
           op.leitzahl,
           op.fa_ag,
           op.labor_status,
           op.komm_vorgabe_auto_depal,
           op.soll_menge,
           lam.lam_sel1,
           lam.lam_sel2,
           lam.lam_sel3,
           lam.lam_sel4,
           lam.lam_sel5,
           lam.lam_sel6,
           lam.lam_sel7,
           lam.lam_sel8,
           lam.lam_sel9,
           lam.lam_sel10,
           lam.charge_id,
           lam.serie_id,
           lam.owner_address_id,
           lam.prod_datum,
           lam.zeichnung_index,
           op.seriennr_id,
           trunc(op.mhd),
           op.satzart,
           op.min_mhd_tage,
           op.charge_id,
           op.lam_sel1,
           op.lam_sel2,
           op.lam_sel3,
           op.lam_sel4,
           op.lam_sel5,
           op.lam_sel6,
           op.lam_sel7,
           op.lam_sel8,
           op.lam_sel9,
           op.lam_sel10,
           op.anbruch,
           op.strategie,
           op.auf_id,
           op.vorgang_id,
           op.min_reifezeit,
           op.zeichnung_index,
           op.kom_lgr_orte,
           op.sid,
           op.firma_nr,
           op.mhd,
           op.quell_lagerorte,
           op.ware_disponiert,
           lte.auto_depal,
           op.auto_depal
  order by decode(lte.order_vorgang_id, op.vorgang_id, 0, 1), ausl_sort, lgr.lgr_platz_gruppe, ausl_sort2
;


-- sqlcl_snapshot {"hash":"ab223e2132bff7b00695d51411eddcc5cc220098","type":"VIEW","name":"CHK_AUSL_ORDER_TEST","schemaName":"DIRKSPZM32","sxml":""}