create or replace 
package body DIRKSPZM32.LVS_EINL is
  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  01.09.2004 18:13:10
  __________________________________________________
  Description
  Lagerverwaltung Einlagern
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  12.11.2019   DB31_5      (-CMe-)  20191112 Wenn die LAM Id gefüllt ist und die LAM in der LVS_LAM nicht vorhanden ist,
                                    muss der Datensatz angelegt werden (lvs_lam_zugang_owner_size)
  21.11.2013   3.5.7.4     (-WK-)   Header added and new release and version handling
  27.11.2009   3.5.0.3     (-BW-)   Minor Release
  25.10.2006   3.3.4.0     (-AG-)   package created
  */

  v_build_number constant number := 4;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
  procedure reset_isi_error is
  begin
    v_err_nr := null;
    v_err_text := null;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
  function get_release return varchar2 is
  begin
    return(v_release_str);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_version return varchar2 is
  begin
    return(to_char(v_release_major) || '.' ||
           to_char(v_release_minor) || '.' ||
           to_char(v_revision) || '.' ||
           to_char(v_build_number) || ' / ' ||
           v_rev_date);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2
                          ) is
  begin
    out_rel_major := v_release_major;
    out_rel_minor := v_release_minor;
    out_revision := v_revision;
    out_buid_number := v_build_number;
    out_rev_date := v_rev_date;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Function and procedure implementations
  -------------------------------------------------------------------------------------------------------

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function lvs_lam_zugang (
    in_sid                  in isi_sid.sid%type,
    in_firma_nr             in isi_firma.firma_nr%type,
    in_artikel_id           in isi_artikel.artikel_id%type,
    in_lte_id               in lvs_lte.lte_id%type,
    in_lhm_id               in out lvs_lhm.lhm_id%type,
    in_charge_id            in lvs_lam.charge_id%type,
    in_serie_id             in lvs_lam.serie_id%type,
    in_leitzahl             in bde_fa_auftrag.leitzahl%type,
    in_fa_ag                in bde_fa_auftrag.fa_ag%type,
    in_fa_upos              in bde_fa_auftrag.fa_upos%type,
    in_abnr                 in bde_fa_auftrag.abnr%type,
    in_best_nr              in lvs_lam.best_nr%type,
    in_best_pos             in lvs_lam.best_pos%type,
    in_res_id               in isi_resource.res_id%type,
    in_prod_datum           in date,
    in_zug_datum            in date,
    in_ls_login_id          in isi_user.login_id%type,
    in_out_menge            in out lvs_lam.menge%type,
    in_lhm_name             in lvs_lhm_cfg.lhm_name%type,
    in_kunde_nr             in lvs_lam.kunden_nr%type,
    in_kd_art_nr            in lvs_lam.kd_art_nr%type,
    in_mhd                  in lvs_lam.lam_mhd%type,
    in_zeichnung            in lvs_lam.zeichnung%type,
    in_zeichnung_i          in lvs_lam.zeichnung_index%type,
    in_bew_id               in s_send_bew.bew_id%type,
    in_lieferant            in isi_adressen.adr_nr%type,
    in_li_nr_lief           in lvs_lam.li_nr_lief%type,
    in_lte_id_lief          in lvs_lam.lte_id_lieferant%type,
    in_sonst_lief_id        in lvs_lam.lte_id_lieferant%type,
    in_menge_basis          in lvs_lam.menge_basis%type,
    in_mengeneinheit_basis  in lvs_lam.mengeneinheit_basis%type,
    in_labor_status         in lvs_lam.labor_status%type,
    in_lam_p1               in lvs_lam.lam_p1%type,
    in_lam_p2               in lvs_lam.lam_p2%type,
    in_lam_p3               in lvs_lam.lam_p3%type,
    in_lam_p4               in lvs_lam.lam_p4%type,
    in_lam_p5               in lvs_lam.lam_p5%type,
    in_lam_p6               in lvs_lam.lam_p6%type,
    in_lam_p7               in lvs_lam.lam_p7%type,
    in_lam_p8               in lvs_lam.lam_p8%type,
    in_lam_p9               in lvs_lam.lam_p9%type,
    in_lam_p10              in lvs_lam.lam_p10%type,
    in_lhm_eti_druck_status in lvs_lhm.lhm_eti_druck_status%type,
    in_lam_text             in lvs_lam.lam_text%type,
    in_labor_text           in lvs_lam.labor_text%type,
    in_fae_id               in bde_pd_prod.fae_id%type,
    in_fae_id_position      in bde_pd_prod.fae_id_position%type,
    in_lam_id               in lvs_lam.lam_id%type,
    in_qs_status            in lvs_lam.qs_status%type,
    in_lhm_lfd_nr           in lvs_lam.lhm_lfd_nr%type
  ) return number is
  begin
    return lvs_lam_zugang_owner(
      in_artikel_id,
      in_lte_id, in_lhm_id,
      in_charge_id, in_serie_id,
      in_leitzahl, in_fa_ag, in_fa_upos, in_abnr, in_best_nr, in_best_pos,
      in_res_id, in_prod_datum, in_zug_datum, in_ls_login_id,
      in_out_menge, in_lhm_name,
      in_kunde_nr, in_kd_art_nr, in_mhd,
      in_zeichnung, in_zeichnung_i, in_bew_id,
      in_lieferant, in_li_nr_lief, in_lte_id_lief, in_sonst_lief_id,
      in_menge_basis, in_mengeneinheit_basis,
      in_labor_status,
      in_lam_p1, in_lam_p2, in_lam_p3, in_lam_p4, in_lam_p5,
      in_lam_p6, in_lam_p7, in_lam_p8, in_lam_p9, in_lam_p10,
      in_lhm_eti_druck_status,
      in_lam_text, in_labor_text,
      in_fae_id, in_fae_id_position,
      in_lam_id,
      in_qs_status,
      in_lhm_lfd_nr,
      null -- no owner_adress_id > our product / material
    );
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -- -AG- 06.09.2010 Erweiterung LFDN in der Charge
  -------------------------------------------------------------------------------------------------------
  function lvs_lam_zugang_owner (
    in_artikel_id           in isi_artikel.artikel_id%type,
    in_lte_id               in lvs_lte.lte_id%type,
    in_lhm_id               in out lvs_lhm.lhm_id%type,
    in_charge_id            in lvs_lam.charge_id%type,
    in_serie_id             in lvs_lam.serie_id%type,
    in_leitzahl             in bde_fa_auftrag.leitzahl%type,
    in_fa_ag                in bde_fa_auftrag.fa_ag%type,
    in_fa_upos              in bde_fa_auftrag.fa_upos%type,
    in_abnr                 in bde_fa_auftrag.abnr%type,
    in_best_nr              in lvs_lam.best_nr%type,
    in_best_pos             in lvs_lam.best_pos%type,
    in_res_id               in isi_resource.res_id%type,
    in_prod_datum           in date,
    in_zug_datum            in date,
    in_ls_login_id          in isi_user.login_id%type,
    in_out_menge            in out lvs_lam.menge%type,
    in_lhm_name             in lvs_lhm_cfg.lhm_name%type,
    in_kunde_nr             in lvs_lam.kunden_nr%type,
    in_kd_art_nr            in lvs_lam.kd_art_nr%type,
    in_mhd                  in lvs_lam.lam_mhd%type,
    in_zeichnung            in lvs_lam.zeichnung%type,
    in_zeichnung_i          in lvs_lam.zeichnung_index%type,
    in_bew_id               in s_send_bew.bew_id%type,
    in_lieferant            in isi_adressen.adr_nr%type,
    in_li_nr_lief           in lvs_lam.li_nr_lief%type,
    in_lte_id_lief          in lvs_lam.lte_id_lieferant%type,
    in_sonst_lief_id        in lvs_lam.lte_id_lieferant%type,
    in_menge_basis          in lvs_lam.menge_basis%type,
    in_mengeneinheit_basis  in lvs_lam.mengeneinheit_basis%type,
    in_labor_status         in lvs_lam.labor_status%type,
    in_lam_p1               in lvs_lam.lam_p1%type,
    in_lam_p2               in lvs_lam.lam_p2%type,
    in_lam_p3               in lvs_lam.lam_p3%type,
    in_lam_p4               in lvs_lam.lam_p4%type,
    in_lam_p5               in lvs_lam.lam_p5%type,
    in_lam_p6               in lvs_lam.lam_p6%type,
    in_lam_p7               in lvs_lam.lam_p7%type,
    in_lam_p8               in lvs_lam.lam_p8%type,
    in_lam_p9               in lvs_lam.lam_p9%type,
    in_lam_p10              in lvs_lam.lam_p10%type,
    in_lhm_eti_druck_status in lvs_lhm.lhm_eti_druck_status%type,
    in_lam_text             in lvs_lam.lam_text%type,
    in_labor_text           in lvs_lam.labor_text%type,
    in_fae_id               in bde_pd_prod.fae_id%type,
    in_fae_id_position      in bde_pd_prod.fae_id_position%type,
    in_lam_id               in lvs_lam.lam_id%type,
    in_qs_status            in lvs_lam.qs_status%type,
    in_lhm_lfd_nr           in lvs_lam.lhm_lfd_nr%type,
    in_owner_address_id     in lvs_lam.owner_address_id%type
  ) return number is
  begin
    return lvs_lam_zugang_owner_size(
      in_artikel_id,
      in_lte_id, in_lhm_id,
      in_charge_id, in_serie_id,
      in_leitzahl, in_fa_ag, in_fa_upos, in_abnr, in_best_nr, in_best_pos,
      in_res_id, in_prod_datum, in_zug_datum, in_ls_login_id,
      in_out_menge, in_lhm_name,
      in_kunde_nr, in_kd_art_nr, in_mhd,
      in_zeichnung, in_zeichnung_i, in_bew_id,
      in_lieferant, in_li_nr_lief, in_lte_id_lief, in_sonst_lief_id,
      in_menge_basis, in_mengeneinheit_basis,
      in_labor_status,
      in_lam_p1, in_lam_p2, in_lam_p3, in_lam_p4, in_lam_p5,
      in_lam_p6, in_lam_p7, in_lam_p8, in_lam_p9, in_lam_p10,
      in_lhm_eti_druck_status,
      in_lam_text, in_labor_text,
      in_fae_id, in_fae_id_position,
      in_lam_id,
      in_qs_status,
      in_lhm_lfd_nr,
      in_owner_address_id, -- no owner_adress_id > our product / material,
      NULL,                -- in_hoehe                in lvs_lhm.lhm_vol_hoehe%type,
      NULL,                -- in_breite               in lvs_lhm.lhm_vol_breite%type,
      NULL,                -- in_tiefe                in lvs_lhm.lhm_vol_tiefe%type
      NULL,                -- LAM_SEL1  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL,                -- LAM_SEL2  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL,                -- LAM_SEL3  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL,                -- LAM_SEL4  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL,                -- LAM_SEL5  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL,                -- LAM_SEL6  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL,                -- LAM_SEL7  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL,                -- LAM_SEL8  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL,                -- LAM_SEL9  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL,                -- LAM_SEL10 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      NULL                 -- HERSTELLER_KUERZEL_LISTE  N VARCHAR2(100) Y     Liste der Hersteller als Kürzel mit Semikolon getrennt
    );
  end;

  function lvs_lam_zugang_owner_size (
    in_artikel_id           in isi_artikel.artikel_id%type,
    in_lte_id               in lvs_lte.lte_id%type,
    in_lhm_id               in out lvs_lhm.lhm_id%type,
    in_charge_id            in lvs_lam.charge_id%type,
    in_serie_id             in lvs_lam.serie_id%type,
    in_leitzahl             in bde_fa_auftrag.leitzahl%type,
    in_fa_ag                in bde_fa_auftrag.fa_ag%type,
    in_fa_upos              in bde_fa_auftrag.fa_upos%type,
    in_abnr                 in bde_fa_auftrag.abnr%type,
    in_best_nr              in lvs_lam.best_nr%type,
    in_best_pos             in lvs_lam.best_pos%type,
    in_res_id               in isi_resource.res_id%type,
    in_prod_datum           in date,
    in_zug_datum            in date,
    in_ls_login_id          in isi_user.login_id%type,
    in_out_menge            in out lvs_lam.menge%type,
    in_lhm_name             in lvs_lhm_cfg.lhm_name%type,
    in_kunde_nr             in lvs_lam.kunden_nr%type,
    in_kd_art_nr            in lvs_lam.kd_art_nr%type,
    in_mhd                  in lvs_lam.lam_mhd%type,
    in_zeichnung            in lvs_lam.zeichnung%type,
    in_zeichnung_i          in lvs_lam.zeichnung_index%type,
    in_bew_id               in s_send_bew.bew_id%type,
    in_lieferant            in isi_adressen.adr_nr%type,
    in_li_nr_lief           in lvs_lam.li_nr_lief%type,
    in_lte_id_lief          in lvs_lam.lte_id_lieferant%type,
    in_sonst_lief_id        in lvs_lam.lte_id_lieferant%type,
    in_menge_basis          in lvs_lam.menge_basis%type,
    in_mengeneinheit_basis       in lvs_lam.mengeneinheit_basis%type,
    in_labor_status              in lvs_lam.labor_status%type,
    in_lam_p1                    in lvs_lam.lam_p1%type,
    in_lam_p2                    in lvs_lam.lam_p2%type,
    in_lam_p3                    in lvs_lam.lam_p3%type,
    in_lam_p4                    in lvs_lam.lam_p4%type,
    in_lam_p5                    in lvs_lam.lam_p5%type,
    in_lam_p6                    in lvs_lam.lam_p6%type,
    in_lam_p7                    in lvs_lam.lam_p7%type,
    in_lam_p8                    in lvs_lam.lam_p8%type,
    in_lam_p9                    in lvs_lam.lam_p9%type,
    in_lam_p10                   in lvs_lam.lam_p10%type,
    in_lhm_eti_druck_status      in lvs_lhm.lhm_eti_druck_status%type,
    in_lam_text                  in lvs_lam.lam_text%type,
    in_labor_text                in lvs_lam.labor_text%type,
    in_fae_id                    in bde_pd_prod.fae_id%type,
    in_fae_id_position           in bde_pd_prod.fae_id_position%type,
    in_lam_id                    in lvs_lam.lam_id%type,
    in_qs_status                 in lvs_lam.qs_status%type,
    in_lhm_lfd_nr                in lvs_lam.lhm_lfd_nr%type,
    in_owner_address_id          in lvs_lam.owner_address_id%type,
    in_hoehe                     in lvs_lhm.lhm_vol_hoehe%type,
    in_breite                    in lvs_lhm.lhm_vol_breite%type,
    in_tiefe                     in lvs_lhm.lhm_vol_tiefe%type,
    in_lam_sel1                  in lvs_lam.lam_sel1%type,
    in_lam_sel2                  in lvs_lam.lam_sel2%type,
    in_lam_sel3                  in lvs_lam.lam_sel3%type,
    in_lam_sel4                  in lvs_lam.lam_sel4%type,
    in_lam_sel5                  in lvs_lam.lam_sel5%type,
    in_lam_sel6                  in lvs_lam.lam_sel6%type,
    in_lam_sel7                  in lvs_lam.lam_sel7%type,
    in_lam_sel8                  in lvs_lam.lam_sel8%type,
    in_lam_sel9                  in lvs_lam.lam_sel9%type,
    in_lam_sel10                 in lvs_lam.lam_sel10%type,
    in_hersteller_kuerzel_liste  in lvs_lam.hersteller_kuerzel_liste%type
  ) return number is
  begin
    return lvs_lam_zugang_DB31(
      in_artikel_id,
      in_lte_id, in_lhm_id,
      in_charge_id, in_serie_id,
      in_leitzahl, in_fa_ag, in_fa_upos, in_abnr, in_best_nr, in_best_pos,
      in_res_id, in_prod_datum, in_zug_datum, in_ls_login_id,
      in_out_menge, in_lhm_name,
      in_kunde_nr, in_kd_art_nr, in_mhd,
      in_zeichnung, in_zeichnung_i, in_bew_id,
      in_lieferant, in_li_nr_lief, in_lte_id_lief, in_sonst_lief_id,
      in_menge_basis, in_mengeneinheit_basis,
      in_labor_status,
      in_lam_p1, in_lam_p2, in_lam_p3, in_lam_p4, in_lam_p5,
      in_lam_p6, in_lam_p7, in_lam_p8, in_lam_p9, in_lam_p10,
      in_lhm_eti_druck_status,
      in_lam_text, in_labor_text,
      in_fae_id, in_fae_id_position,
      in_lam_id,
      in_qs_status,
      in_lhm_lfd_nr,
      in_owner_address_id,        -- no owner_adress_id > our product / material,
      in_hoehe,                   -- in_hoehe                in lvs_lhm.lhm_vol_hoehe%type,
      in_breite,                  -- in_breite               in lvs_lhm.lhm_vol_breite%type,
      in_tiefe,                   -- in_tiefe                in lvs_lhm.lhm_vol_tiefe%type
      in_lam_sel1,                -- LAM_SEL1  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_lam_sel2,                -- LAM_SEL2  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_lam_sel3,                -- LAM_SEL3  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_lam_sel4,                -- LAM_SEL4  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_lam_sel5,                -- LAM_SEL5  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_lam_sel6,                -- LAM_SEL6  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_lam_sel7,                -- LAM_SEL7  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_lam_sel8,                -- LAM_SEL8  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_lam_sel9,                -- LAM_SEL9  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_lam_sel10,               -- LAM_SEL10 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
      in_hersteller_kuerzel_liste,-- HERSTELLER_KUERZEL_LISTE  N VARCHAR2(100) Y     Liste der Hersteller als Kürzel mit Semikolon getrennt
      NULL                        -- NR_PRUEFUNG
    );
  end;

  function lvs_lam_zugang_DB31 (
    in_artikel_id           in isi_artikel.artikel_id%type,
    in_lte_id               in lvs_lte.lte_id%type,
    in_lhm_id               in out lvs_lhm.lhm_id%type,
    in_charge_id            in lvs_lam.charge_id%type,
    in_serie_id             in lvs_lam.serie_id%type,
    in_leitzahl             in bde_fa_auftrag.leitzahl%type,
    in_fa_ag                in bde_fa_auftrag.fa_ag%type,
    in_fa_upos              in bde_fa_auftrag.fa_upos%type,
    in_abnr                 in bde_fa_auftrag.abnr%type,
    in_best_nr              in lvs_lam.best_nr%type,
    in_best_pos             in lvs_lam.best_pos%type,
    in_res_id               in isi_resource.res_id%type,
    in_prod_datum           in date,
    in_zug_datum            in date,
    in_ls_login_id          in isi_user.login_id%type,
    in_out_menge            in out lvs_lam.menge%type,
    in_lhm_name             in lvs_lhm_cfg.lhm_name%type,
    in_kunde_nr             in lvs_lam.kunden_nr%type,
    in_kd_art_nr            in lvs_lam.kd_art_nr%type,
    in_mhd                  in lvs_lam.lam_mhd%type,
    in_zeichnung            in lvs_lam.zeichnung%type,
    in_zeichnung_i          in lvs_lam.zeichnung_index%type,
    in_bew_id               in s_send_bew.bew_id%type,
    in_lieferant            in isi_adressen.adr_nr%type,
    in_li_nr_lief           in lvs_lam.li_nr_lief%type,
    in_lte_id_lief          in lvs_lam.lte_id_lieferant%type,
    in_sonst_lief_id        in lvs_lam.lte_id_lieferant%type,
    in_menge_basis          in lvs_lam.menge_basis%type,
    in_mengeneinheit_basis       in lvs_lam.mengeneinheit_basis%type,
    in_labor_status              in lvs_lam.labor_status%type,
    in_lam_p1                    in lvs_lam.lam_p1%type,
    in_lam_p2                    in lvs_lam.lam_p2%type,
    in_lam_p3                    in lvs_lam.lam_p3%type,
    in_lam_p4                    in lvs_lam.lam_p4%type,
    in_lam_p5                    in lvs_lam.lam_p5%type,
    in_lam_p6                    in lvs_lam.lam_p6%type,
    in_lam_p7                    in lvs_lam.lam_p7%type,
    in_lam_p8                    in lvs_lam.lam_p8%type,
    in_lam_p9                    in lvs_lam.lam_p9%type,
    in_lam_p10                   in lvs_lam.lam_p10%type,
    in_lhm_eti_druck_status      in lvs_lhm.lhm_eti_druck_status%type,
    in_lam_text                  in lvs_lam.lam_text%type,
    in_labor_text                in lvs_lam.labor_text%type,
    in_fae_id                    in bde_pd_prod.fae_id%type,
    in_fae_id_position           in bde_pd_prod.fae_id_position%type,
    in_lam_id                    in lvs_lam.lam_id%type,
    in_qs_status                 in lvs_lam.qs_status%type,
    in_lhm_lfd_nr                in lvs_lam.lhm_lfd_nr%type,
    in_owner_address_id          in lvs_lam.owner_address_id%type,
    in_hoehe                     in lvs_lhm.lhm_vol_hoehe%type,
    in_breite                    in lvs_lhm.lhm_vol_breite%type,
    in_tiefe                     in lvs_lhm.lhm_vol_tiefe%type,
    in_lam_sel1                  in lvs_lam.lam_sel1%type,
    in_lam_sel2                  in lvs_lam.lam_sel2%type,
    in_lam_sel3                  in lvs_lam.lam_sel3%type,
    in_lam_sel4                  in lvs_lam.lam_sel4%type,
    in_lam_sel5                  in lvs_lam.lam_sel5%type,
    in_lam_sel6                  in lvs_lam.lam_sel6%type,
    in_lam_sel7                  in lvs_lam.lam_sel7%type,
    in_lam_sel8                  in lvs_lam.lam_sel8%type,
    in_lam_sel9                  in lvs_lam.lam_sel9%type,
    in_lam_sel10                 in lvs_lam.lam_sel10%type,
    in_hersteller_kuerzel_liste  in lvs_lam.hersteller_kuerzel_liste%type,
    in_nr_pruefung               in lvs_lam.nr_pruefung%type
  ) return number is

    v_lam_id             lvs_lam.lam_id%TYPE;          -- Neu LAM_ID aus Sequenz
    v_lam_bh_id          lvs_lam_bh.lam_bh_id%TYPE; -- Neu LAM_BH_ID aus Sequenz
    v_vorg_id            lvs_lam_bh.vorg_id%TYPE;   -- Neu VORGang_ID aus Sequenz
    v_lam_bh_kg          lvs_lam_bh.lam_bh_kg%TYPE; -- Gewicht der Wahre
    v_lam_bh_kg_einheit  lvs_lam_bh.lam_bh_kg%TYPE; -- Gewicht der Wahre
    v_lam                lvs_lam%ROWTYPE;           -- Daten aus der LAM
    v_lhm_cfg            lvs_lhm_cfg%ROWTYPE;       -- Daten um neues Lagerhilfsmittel in der LVS_LHM anzulegen
    v_lhm_cfg_art        lvs_lhm_cfg%ROWTYPE;       -- Daten um neues Lagerhilfsmittel in der LVS_LHM anzulegen
    v_lhm                lvs_lhm%ROWTYPE;           -- Daten des Lagerhilfsmittel
    v_lte                lvs_lte%ROWTYPE;           -- Daten der transporteinheit (Für den Lagerplatz)
    v_art                isi_artikel%ROWTYPE;       -- Daten des Artikels
    v_kd_art             isi_artikel_kunde%ROWTYPE; -- Daten des KundenArtikels
    v_art_ctrl           isi_artikel_ctrl%rowtype;  -- Daten aus Artikel-CRTL
    v_hersteller         isi_hersteller%rowtype;    -- Daten aus isi-Hersteller
    v_found              boolean;                   -- Dummy Var für gefunden im CURSOR
    v_lhm_vol            number;                    -- Volumen in m3 für Lagerhilfsmittel
    v_lhm_gew_kg         lvs_lhm_cfg.lhm_gew_kg%TYPE;
    v_lhm_name           lvs_lhm.lhm_name%TYPE;          -- Name der LHM
    v_lhm_menge          isi_artikel.lhm_menge%TYPE;     -- Menge je Karton
    v_lte_lhm_menge      isi_artikel.lte_lhm_menge%Type; -- Anz Karton
    v_lhm_gewicht_kg     isi_artikel.lhm_gewicht_kg%TYPE;-- Gewicht je Karton
    v_lam_mhd            date;                           -- MHD aus Berechnung
    v_lam_mhd_ausgabe    date;                           -- MHD für die Ausgabe
    v_charge             lvs_charge%rowtype;
    v_barcode_id         number;
    v_typ                varchar2(10);
    v_h_tag              isi_hersteller.tag%type;

    v_mhd_berechnen      varchar2(2);

    v_firma              isi_firma%ROWTYPE;               -- Firmenstamm

    CURSOR c_lhm is                        -- Lesen des Lagerhilfsmittel
      select *
        from lvs_lhm lhm
       where lhm.lhm_id = in_lhm_id;

    CURSOR c_lte is                        -- Lesen der Transporteinheit für den Lagerplatz
      select *
        from lvs_lte lte
       where lte.lte_id = in_lte_id;

    CURSOR c_art is                        -- Lesen des Artikels
      select *
        from isi_artikel art
       where art.artikel_id = in_artikel_id;

    CURSOR c_kd_art is                        -- Lesen des Artikel Kunden
      select *
        from isi_artikel_kunde art
       where art.artikel_id = in_artikel_id;

    CURSOR c_firma is                      -- Lesen der Firma
      select *
        from isi_firma firma
       where firma.firma_nr = 1;

    CURSOR c_lam is
      select t.*
        from lvs_lam t
       where t.lam_id = in_lam_id;

    CURSOR c_lam_bh is
      select t.lam_bh_id
        from lvs_lam_bh t
       where t.lhm_id = in_lhm_id;

  begin
     -- Lesen der Artikeldaten
     reset_isi_error();

     v_lhm_name := in_lhm_name;           -- Übergebenen Namen nehmen

     -- -AG- Prüfen ob die LHM-ID Unique seien soll
     if isi_allg.get_global_param ('lvs', 'LVS_UNIQUE_LHM_ID', 'F') = c.C_TRUE
     then
       OPEN c_lam_bh;
       FETCH c_lam_bh into v_barcode_id; -- Nur Dummy zu Prüfung ob es schon Buchungen mit der LHM_ID gab
       v_barcode_id := NULL;
       v_found := c_lam_bh%FOUND;
       CLOSE c_lam_bh;
       if v_found
       then
         v_err_nr := c.FMID_Artikelnummer_Fehlt;
         v_err_text := LC.ec_p1(LC.O_TP1_LHM_UNIQUE_ERROR, in_lhm_id);
         raise v_error;
       end if;
     end if;

    -------------------------------------------------------------------------------------------------------
    -- Holen von Stammdaten aus dem Artikel oder aus den Kundenartikeldaten
    -------------------------------------------------------------------------------------------------------

     OPEN c_firma;                      -- Firmenstamm holen
     FETCH c_firma into v_firma;        --
     CLOSE c_firma;

     if not lvs_p_base.get_charge(in_charge_id,                 -- in_charge     in lvs_charge.charge_bez%type,
                                  v_charge)                     -- io_charge     in out lvs_charge%rowtype)
     then
       v_charge.charge_lhm_lfdn := 1;
     end if;

     OPEN c_art;
     FETCH c_art into v_art;
     v_found := c_art%FOUND;
     CLOSE c_art;
     if not v_found then               -- Ganz schlecht, weil man hier nur hinkommt, wenn es den Artikel gibt
       v_err_nr := c.FMID_Artikelnummer_Fehlt;
       v_err_text := LC.ec_p1(LC.O_TP1_ARTIKEL_ID_FEHLT, in_artikel_id);
       raise v_error;
     end if;

     -- -AG- 2008-04-24 BugFix: Lesen des Gewichts aus den Behaelter, der im Artikel hinterlegt ist (Um Nettogewicht zu rechnen)
     if not lvs_p_base.get_lhm_cfg('01', v_art.lhm_name, v_lhm_cfg_art)
     then
       v_lhm_cfg_art.lhm_gew_kg := 0;
     end if;

     OPEN c_kd_art;
     FETCH c_kd_art into v_kd_art;
     v_found := c_kd_art%FOUND;
     CLOSE c_kd_art;


     if v_found then               -- KundenArtikel Daten gefunden
       if v_lhm_name is NULL then
         if v_kd_art.lhm_name is NULL then
           v_lhm_name := v_art.lhm_name;          -- Namen der Verpakung aus dem Artikel
         else
           v_lhm_name := v_kd_art.lhm_name;       -- Namen der Verpakung aus dem KundenArtikel
         end if;
       end if;
       if in_out_menge is NULL then
         if nvl(in_menge_basis, v_art.Menge_Basis) = c.Basis_Lte
         then
             in_out_menge := 1;
         elsif nvl(in_menge_basis, v_art.Menge_Basis) = c.Basis_Lhm
         then
           if v_kd_art.lte_lhm_menge is NULL then
             in_out_menge := v_art.lte_lhm_menge;   -- Ohne Menge dann Std-Menge
           else
             in_out_menge := v_kd_art.lte_lhm_menge;-- Ohne Menge dann Std-Menge Kunde
           end if;
         else
           if v_kd_art.lhm_menge is NULL then
             in_out_menge := v_art.lhm_menge;   -- Ohne Menge dann Std-Menge
           else
             in_out_menge := v_kd_art.lhm_menge;-- Ohne Menge dann Std-Menge Kunde
           end if;
         end if;
       end if;
       if v_kd_art.lhm_menge is NULL then
         v_lhm_menge := v_art.lhm_menge;     -- Menge je Einheit aus dem Artikel
       else
         v_lhm_menge := v_kd_art.lhm_menge;  -- Menge je Einheit aus dem KundenArtikel
       end if;
       if v_kd_art.lte_lhm_menge is NULL then
         v_lte_lhm_menge := v_art.lte_lhm_menge;     -- Menge je Einheit aus dem Artikel
       else
         v_lte_lhm_menge := v_kd_art.lte_lhm_menge;  -- Menge je Einheit aus dem KundenArtikel
       end if;

       if v_kd_art.lhm_gewicht_kg is NULL then
         v_lhm_gewicht_kg := v_art.lhm_gewicht_kg; -- Gewicht aus dem Artikel
       else
         v_lhm_gewicht_kg := v_kd_art.lhm_gewicht_kg; -- Gewicht aus dem Kundenartikel
       end if;
     else
       if in_out_menge is NULL then
         if nvl(in_menge_basis, v_art.Menge_Basis) = c.Basis_Lte
         then
             in_out_menge := 1;
         elsif nvl(in_menge_basis, v_art.Menge_Basis) = c.Basis_Lhm
         then
           in_out_menge := v_art.lte_lhm_menge;-- Ohne Menge dann Std-Menge Kunde
         else
           in_out_menge := v_art.lhm_menge;-- Ohne Menge dann Std-Menge Kunde
         end if;
       end if;
       if v_lhm_name is NULL then
         v_lhm_name := v_art.lhm_name;           -- Namen aus dem Artikel übernehmen
       end if;
       v_lte_lhm_menge := v_art.lte_lhm_menge;     -- Menge je Einheit aus dem Artikel
       v_lhm_menge := v_art.lhm_menge;           -- Menge je Einheit aus dem KundenArtikel
       v_lhm_gewicht_kg := v_art.lhm_gewicht_kg; -- Gewicht aus dem Artikel
     end if;

    -------------------------------------------------------------------------------------------------------
    -- Holen der neuen Nummern
    -------------------------------------------------------------------------------------------------------
     if in_lam_id is NULL
     then
       v_err_nr := 20;
       v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
       select seq_lam.nextval into v_lam_id from dual;
     else
       v_lam_id := in_lam_id;
     end if;
     v_err_nr := 30;
     v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
     select seq_lam_bh.nextval into v_lam_bh_id from dual;
     v_err_nr := 40;
     v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
     select seq_vorg_id.nextval into v_vorg_id from dual;
     reset_isi_error();
    -------------------------------------------------------------------------------------------------------
    -- Jetzt wird erst mal die LHM geprüft, und evtl neu angelegt !!!!
    -------------------------------------------------------------------------------------------------------
     OPEN c_lte;
     FETCH c_lte into v_lte;
     v_found := c_lte%FOUND;
     CLOSE c_lte;

     if not v_found then
       v_err_nr := c.FMID_LTE_ID_Fehlt;
       v_err_text := LC.ec(LC.O_TXT_LTE_FUER_MATERIAL_N_GEBU);
       raise v_error;
     end if;

     v_found := lvs_p_base.get_lhm_cfg('01', v_lhm_name, v_lhm_cfg);

     if not v_found then               -- Ganz schlecht, weil nicht gefunden. Muss auch ohne gehen
       -- v_err_text := 'Configdaten für Lagerhilfsmittel ' || v_lhm_name || ' fehlt';;
       v_lhm_cfg.lhm_vol_hoehe := NULL;
       v_lhm_cfg.lhm_vol_breite := NULL;
       v_lhm_cfg.lhm_vol_tiefe  := NULL;
       v_lhm_cfg.lhm_gew_kg := 0;
     end if;

     -- Jetzt wird erst mal die LHM geprüft, und evtl neu angelegt !!!!
     if in_lhm_id is not NULL then
       OPEN c_lhm;
       FETCH c_lhm into v_lhm;
       v_found := c_lhm%FOUND;
       CLOSE c_lhm;
     else
       v_found := false;
     end if;

    if  in_hersteller_kuerzel_liste is not NULL
    and in_hersteller_kuerzel_liste != ';'
    and isi_p_base.get_artikel_ctrl_typ('01',
                                        in_artikel_id,
                                        substr(in_hersteller_kuerzel_liste, 1, length(in_hersteller_kuerzel_liste) -1),
                                        v_art_ctrl)
    then
      v_typ := v_art_ctrl.prod_params;
    else
      v_typ := '0000000000';
    end if;
    if  in_hersteller_kuerzel_liste is not NULL
    and in_hersteller_kuerzel_liste != ';'
    and isi_p_base.get_hersteller(substr(in_hersteller_kuerzel_liste, 1, length(in_hersteller_kuerzel_liste) -1),
                                  v_hersteller)
    then
      v_h_tag := v_hersteller.tag;
    else
      v_h_tag := rpad('0', 20, '0');
    end if;


     if not v_found then
       if in_lhm_id is NULL then
         -- Holen der neuen Nummer
         -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
         in_lhm_id := lvs_p_lte.lvs_lte_lhm_next_id_v35 ('01', 1, c.BASIS_LHM,
                                                         v_charge.charge_bez,
                                                         in_artikel_id,
                                                         v_art.artikel_fuer_kunde_etikett,
                                                         v_typ,
                                                         v_h_tag);
       else
         if v_firma.lhm_barcode_type = c.LTE_BARCODE_SPEZ
         then
           isi_utils.spez_barcode_lfdn('01',
                                       1,
                                       in_lhm_id,
                                       c.BASIS_LHM,
                                       v_barcode_id);
         end if;
       end if;

       -- Jetzt Gewichte rechnen
       v_lhm_gew_kg := nvl(v_lhm_cfg.lhm_gew_kg, 0);                        -- Verpackungsgewicht
       -- -AG- 2008-04-24 BugFix: Lesen des Gewichts aus den Behaelter, der im Artikel hinterlegt ist (Um Nettogewicht zu rechnen)
       v_lam_bh_kg  := nvl(v_art.lhm_gewicht_kg, 0) - nvl(v_lhm_cfg_art.lhm_gew_kg, 0); -- Nettogewicht
       begin
          if nvl(in_menge_basis, v_art.Menge_Basis) = c.Basis_Lte
          then
            v_lam_bh_kg_einheit := v_lam_bh_kg * v_lte_lhm_menge;          -- Gewicht je Einheit (Stk)
            v_lam_bh_kg  := v_lam_bh_kg * in_out_menge * v_lte_lhm_menge;  -- Gewicht auf Menge Rechnen
          elsif nvl(in_menge_basis, v_art.Menge_Basis) = c.Basis_Lhm
          then
            v_lam_bh_kg_einheit := v_lam_bh_kg;                                 -- Gewicht je Einheit (Stk)
            v_lam_bh_kg  := v_lam_bh_kg * in_out_menge;                         -- Gewicht auf Menge Rechnen
          else
            v_lam_bh_kg_einheit := v_lam_bh_kg / v_lhm_menge;                   -- Gewicht je Einheit (Stk)
            v_lam_bh_kg  := v_lam_bh_kg * in_out_menge / v_lhm_menge;           -- Gewicht auf Menge Rechnen
          end if;
       exception
          when others then
            v_lam_bh_kg := 0;    -- Netto 0 KG
            v_lhm_menge := 0;
            v_lam_bh_kg_einheit := 0;
            v_lte_lhm_menge := 0;
       end;

       -- Volumen rechnen in m3

       if in_lhm_id is NULL
       then
         v_err_nr := c.FMID_LTE_ID_Null;
         v_err_text := LC.ec_p1(LC.O_TP1_LHM_ID_FEHLT, 'NULL');
         raise v_error;
       end if;

       v_lhm_cfg.lhm_vol_hoehe  := nvl(in_hoehe, v_lhm_cfg.lhm_vol_hoehe);
       v_lhm_cfg.lhm_vol_breite := nvl(in_breite, v_lhm_cfg.lhm_vol_breite);
       v_lhm_cfg.lhm_vol_tiefe  := nvl(in_tiefe, v_lhm_cfg.lhm_vol_tiefe);

       v_lhm_vol := v_lhm_cfg.lhm_vol_hoehe * v_lhm_cfg.lhm_vol_breite * v_lhm_cfg.lhm_vol_tiefe / 1000000000;
       insert into lvs_lhm
          values
                ('01',
                 1,
                 in_lhm_id,
                 in_lte_id,
                 v_lhm_name,
                 v_lte.lgr_platz,
                 v_lhm_cfg.lhm_vol_hoehe,
                 v_lhm_cfg.lhm_vol_breite,
                 v_lhm_cfg.lhm_vol_tiefe,
                 v_lhm_vol,
                 v_lhm_gew_kg,
                 sysdate,
                 in_lhm_eti_druck_status,
                 null,
                 null,
                 null);
     else
       -- Gewicht rechnen
       -- -AG- 2008-04-24 BugFix: Lesen des Gewichts aus den Behaelter, der im Artikel hinterlegt ist (Um Nettogewicht zu rechnen)
       v_lam_bh_kg  := v_lhm_gewicht_kg - nvl(v_lhm_cfg_art.lhm_gew_kg, 0); -- Nettogewicht
       begin
          if nvl(in_menge_basis, v_art.Menge_Basis) = c.Basis_Lte
          then
            v_lam_bh_kg  := v_lam_bh_kg * in_out_menge * v_lte_lhm_menge;  -- Gewicht auf Menge Rechnen
          elsif nvl(in_menge_basis, v_art.Menge_Basis) = c.Basis_Lhm
          then
            v_lam_bh_kg  := v_lam_bh_kg * in_out_menge;                         -- Gewicht auf Menge Rechnen
          else
            v_lam_bh_kg  := v_lam_bh_kg * in_out_menge / v_lhm_menge;           -- Gewicht auf Menge Rechnen
          end if;

       exception
          when others then
            v_lam_bh_kg  := 0;    -- Netto 0 KG
       end;

       -- -AG- 10.11.2010 Wenn eine LHM wieder verwendet wird, dann muss bei der Einlagerung die LTE-ID eingetragen werden
       update lvs_lhm lhm
          set lhm.lgr_platz = v_lte.lgr_platz,
              lhm.lte_id = in_lte_id,
              lhm.lhm_name = nvl(v_lhm_name, lhm.lhm_name),
              lhm.lhm_vol_hoehe  = nvl(in_hoehe, lhm.lhm_vol_hoehe),
              lhm.lhm_vol_breite = nvl(in_breite, lhm.lhm_vol_breite),
              lhm.lhm_vol_tiefe  = nvl(in_tiefe, lhm.lhm_vol_tiefe)
        where lhm.lhm_id = in_lhm_id;
     end if;
     -- Stammdaten für den Lagerbestand eintragen
     if in_lam_id is NULL
     then
       v_err_nr := 60;
       v_err_text := LC.ec_p1(LC.O_TP1_LAM_ZUG_BUCHUNG_ERR, v_lam_id);

       v_mhd_berechnen := nvl(v_art.mhd_berechnung, nvl(v_firma.mhd_berechnung, 'TA'));

       -- -AG- BugFix:  20.08.2009 Fehler beim Berechnen des MHD Datums
       if in_mhd is NULL
       then
         if v_art.mhd_festes_datum is not NULL
         then
           v_lam_mhd := v_art.mhd_festes_datum;
         else
           v_lam_mhd := lvs_p_lte_lhm.lvs_mhd_berechne(trunc(nvl(in_prod_datum, sysdate)),
                                                       v_art.mhd_tage,
                                                       v_mhd_berechnen);
         end if;
       else
         v_lam_mhd := in_mhd;
       end if;

       -- v_lam_mhd := nvl(trunc(in_mhd), trunc(nvl(in_prod_datum, sysdate) + v_art.mhd_tage));

       v_lam_mhd_ausgabe := v_lam_mhd;

       -- -AG- 06.09.2010 Erweiterung LFDN in der Charge
       insert into lvs_lam
           values('01',
                  1,
                  v_lam_id,
                  in_artikel_id,
                  v_lte.lgr_platz,
                  in_lte_id,
                  in_lhm_id,
                  in_charge_id,
                  in_serie_id,
                  in_leitzahl,
                  in_fa_ag,
                  in_fa_upos,
                  in_abnr,
                  in_best_nr,
                  in_best_pos,
                  in_res_id,
                  nvl(in_prod_datum, trunc(sysdate)),
                  in_zug_datum,
                  in_ls_login_id,
                  0,                       -- Gewicht und Menge wird im Trigger LAM_BH gesetzt
                  0,
                  in_lam_text,
                  nvl(in_labor_status, v_art.labor_vorgabe_status),
                  in_labor_text,
                  v_lam_mhd,
                  in_kunde_nr,
                  in_kd_art_nr,
                  in_lieferant,
                  v_lam_mhd_ausgabe,
                  nvl(in_menge_basis, v_art.Menge_Basis),
                  nvl(in_mengeneinheit_basis, v_art.mengeneinheit_basis),
                  null,
                  in_zeichnung,
                  in_zeichnung_i,
                  in_li_nr_lief,
                  in_lte_id_lief,
                  in_sonst_lief_id,
                  null,
                  null,
                  null,
                  null,
                  in_lam_p1,
                  in_lam_p2,
                  in_lam_p3,
                  in_lam_p4,
                  in_lam_p5,
                  in_lam_p6,
                  in_lam_p7,
                  in_lam_p8,
                  in_lam_p9,
                  in_lam_p10,
                  null,
                  null,
                  null,
                  null,
                  in_fae_id,
                  in_fae_id_position,
                  in_qs_status,
                  v_art.waren_typ,
                  in_lhm_lfd_nr,
                  lvs_komm.get_packschema_kopf_id('01', 1, in_lte_id),
                  lvs_komm.get_packschema_lfdn('01', 1, in_lte_id),
                  v_charge.charge_lhm_lfdn,
                  in_owner_address_id,
                  in_lam_sel1,                       -- LAM_SEL1  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_lam_sel2,                       -- LAM_SEL2  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_lam_sel3,                       -- LAM_SEL3  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_lam_sel4,                       -- LAM_SEL4  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_lam_sel5,                       -- LAM_SEL5  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_lam_sel6,                       -- LAM_SEL6  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_lam_sel7,                       -- LAM_SEL7  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_lam_sel8,                       -- LAM_SEL8  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_lam_sel9,                       -- LAM_SEL9  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_lam_sel10,                      -- LAM_SEL10 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                  in_hersteller_kuerzel_liste,
                  in_nr_pruefung
                  );
      else
        OPEN c_lam;
        FETCH c_lam into v_lam;
        v_found := c_lam%FOUND;
        CLOSE c_lam;
        if v_found
        and v_lam.menge != 0
        then
          v_err_nr := 60;
          v_err_text := LC.ec_p1(LC.O_TP1_LAM_ZUG_BUCHUNG_ERR, v_lam_id);
          raise v_error;
        end if;
        -- -CMe 20191112- Wenn die LAM Id gefüllt ist und die LAM in der LVS_LAM nicht vorhanden ist,
        --                muss der Datensatz angelegt werden
        if not v_found
        then
          v_err_nr := 70;
          v_err_text := LC.ec_p1(LC.O_TP1_LAM_ZUG_BUCHUNG_ERR, v_lam_id);

          v_mhd_berechnen := nvl(v_art.mhd_berechnung, nvl(v_firma.mhd_berechnung, 'TA'));

          -- -AG- BugFix:  20.08.2009 Fehler beim Berechnen des MHD Datums
          if in_mhd is NULL
          then
            if v_art.mhd_festes_datum is not NULL
            then
              v_lam_mhd := v_art.mhd_festes_datum;
            else
              v_lam_mhd := lvs_p_lte_lhm.lvs_mhd_berechne(trunc(nvl(in_prod_datum, sysdate)),
                                                          v_art.mhd_tage,
                                                          v_mhd_berechnen);
            end if;
          else
            v_lam_mhd := in_mhd;
          end if;
          -- v_lam_mhd := nvl(trunc(in_mhd), trunc(nvl(in_prod_datum, sysdate) + v_art.mhd_tage));
          v_lam_mhd_ausgabe := v_lam_mhd;
          -- -AG- 06.09.2010 Erweiterung LFDN in der Charge
          insert into lvs_lam
              values('01',
                     1,
                     v_lam_id,
                     in_artikel_id,
                     v_lte.lgr_platz,
                     in_lte_id,
                     in_lhm_id,
                     in_charge_id,
                     in_serie_id,
                     in_leitzahl,
                     in_fa_ag,
                     in_fa_upos,
                     in_abnr,
                     in_best_nr,
                     in_best_pos,
                     in_res_id,
                     nvl(in_prod_datum, trunc(sysdate)),
                     in_zug_datum,
                     in_ls_login_id,
                     0,                       -- Gewicht und Menge wird im Trigger LAM_BH gesetzt
                     0,
                     in_lam_text,
                     nvl(in_labor_status, v_art.labor_vorgabe_status),
                     in_labor_text,
                     v_lam_mhd,
                     in_kunde_nr,
                     in_kd_art_nr,
                     in_lieferant,
                     v_lam_mhd_ausgabe,
                     nvl(in_menge_basis, v_art.Menge_Basis),
                     nvl(in_mengeneinheit_basis, v_art.mengeneinheit_basis),
                     null,
                     in_zeichnung,
                     in_zeichnung_i,
                     in_li_nr_lief,
                     in_lte_id_lief,
                     in_sonst_lief_id,
                     null,
                     null,
                     null,
                     null,
                     in_lam_p1,
                     in_lam_p2,
                     in_lam_p3,
                     in_lam_p4,
                     in_lam_p5,
                     in_lam_p6,
                     in_lam_p7,
                     in_lam_p8,
                     in_lam_p9,
                     in_lam_p10,
                     null,
                     null,
                     null,
                     null,
                     in_fae_id,
                     in_fae_id_position,
                     in_qs_status,
                     v_art.waren_typ,
                     in_lhm_lfd_nr,
                     lvs_komm.get_packschema_kopf_id('01', 1, in_lte_id),
                     lvs_komm.get_packschema_lfdn('01', 1, in_lte_id),
                     v_charge.charge_lhm_lfdn,
                     in_owner_address_id,
                     in_lam_sel1,                       -- LAM_SEL1  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_lam_sel2,                       -- LAM_SEL2  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_lam_sel3,                       -- LAM_SEL3  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_lam_sel4,                       -- LAM_SEL4  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_lam_sel5,                       -- LAM_SEL5  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_lam_sel6,                       -- LAM_SEL6  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_lam_sel7,                       -- LAM_SEL7  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_lam_sel8,                       -- LAM_SEL8  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_lam_sel9,                       -- LAM_SEL9  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_lam_sel10,                      -- LAM_SEL10 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                     in_hersteller_kuerzel_liste,
                     in_nr_pruefung
                     );
        end if;
      end if;

      update lvs_lam l
         set l.fae_id = in_fae_id,
             l.fae_id_position = in_fae_id_position,
             l.qs_status = in_qs_status,
             l.li_nr_lief = in_li_nr_lief,
             l.lte_id_lieferant = in_lte_id_lief,
             l.sonst_id_lieferant = in_sonst_lief_id,
             l.lam_p1 = in_lam_p1,
             l.lam_p2 = in_lam_p2,
             l.lam_p3 = in_lam_p3,
             l.lam_p4 = in_lam_p4,
             l.lam_p5 = in_lam_p5,
             l.lam_p6 = in_lam_p6,
             l.lam_p7 = in_lam_p7,
             l.lam_p8 = in_lam_p8,
             l.lam_p9 = in_lam_p9,
             l.lam_p10 = in_lam_p10,
             l.owner_address_id = in_owner_address_id
       where l.lam_id = in_lam_id;

      update s_send_bew bew
         set bew.lte_nr = in_lte_id,
             bew.lhm_nr = in_lhm_id,
             bew.menge = in_out_menge,
             bew.lam_id = v_lam_id,
             bew.lam_ag = in_fa_ag
      where bew.bew_id = in_bew_id;

     -- Erst die Buchung in die Historie schreiben
     v_err_nr := 70;
     v_err_text := LC.ec_p3(LC.O_TP3_LAM_BH_BUCH_F_LAM_N_MOEG, v_vorg_id, v_lam_bh_id, v_lam_id);
     -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
     insert into lvs_lam_bh
         values('01',
                1,
                v_vorg_id,
                c.LAM_BH_ZUGAGNG,
                v_lam_bh_id,
                v_lam_id,
                in_artikel_id,
                decode(in_owner_address_id,
                       NULL, c.LAM_BH_BUS_ZUG,
                       decode (nvl(in_leitzahl, 0),  -- Mit Leitzahl ist Produktion dann BUS Zugang
                       0, c.LAM_BH_BUS_ZUG_KONSI,    -- Wenn owner gesetzt, dann Zugang KONSI
                       c.LAM_BH_BUS_ZUG)),
                in_zug_datum,
                in_ls_login_id,
                v_lte.lgr_platz,
                in_lte_id,
                in_lhm_id,
                in_charge_id,
                in_serie_id,
                in_abnr,
                in_out_menge,
                v_lam_bh_kg,
                v_lam_bh_kg_einheit,
                in_res_id,
                in_leitzahl,
                in_fa_ag,
                in_fa_upos,
                in_abnr,
                NULL,
                NULL,
                NULL,
                sysdate,                     -- CREATED_DATE          creation date+time of this dataset
                in_ls_login_id,              -- CREATED_LOGIN_ID      login id of the user creating this dataset
                sysdate,                     -- LAST_CHANGE_DATE      change date+time of this dataset
                in_ls_login_id,              -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
                null,                        -- CHANGE_MENGE          Menge die geändert wurde
                in_owner_address_id,         -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

    -- Kein Fehler
    reset_isi_error();

    return(v_lam_id);
  exception
    -- Im Exception-Fall is die Fehlervariable bereits gesetzt
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  procedure lvs_c_transp_einl_pruef_rid(in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                        in_lgr_platz            in varchar2,
                                        in_fahrzeuge_IDs        in varchar2,
                                        in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                        in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                        in_user_ID              in isi_user.login_id%TYPE,
                                        in_prio                 in isi_transport.Prio%TYPE,
                                        in_progr_nr             in isi_transport.progr_nr%TYPE,
                                        in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                        in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                        in_aktuelle_position    in lvs_lam.lam_text%type,
                                        out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                        out_transport_id        out number,
                                        out_res_id              out isi_resource.res_id%type
                                        ) is
    --
    v_error EXCEPTION;
    v_err_nr       number;
    v_err_text     varchar2(2550);
    v_neuer_status lvs_lte.lte_status%TYPE;
    v_found        boolean;
    v_lgr_platz    lvs_lgr.lgr_platz%TYPE;
    v_lgr          lvs_lgr%ROWTYPE;
    v_lte          lvs_lte%ROWTYPE; -- LTE
    v_result       number;
    v_transport_gruppe       isi_transport.transport_gruppe%type;

    v_lte_cfg            lvs_lte_cfg%rowtype;
    v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

    CURSOR c_lte_cfg is
      select t.*
        from lvs_lte_cfg t
       where t.sid = v_lte.sid
         and t.firma_nr = v_lte.firma_nr
         and t.lte_name = v_lte.lte_name;

    CURSOR c_lvs_lte is -- Lesen des Lagerhilfsmittel
      select * from lvs_lte lte where lte.lte_id = in_LTE_ID;

    CURSOR c_lvs_lgr is -- Lesen des Start Lagerplatz
      select * from lvs_lgr lgr where lgr.lgr_platz = in_lgr_platz;

  begin
    v_err_nr   := NULL;
    v_err_text := NULL;
    v_lgr      := NULL;

    out_transport_id := 0;

    -- LTE Einlesen
    OPEN c_lvs_lte;
    FETCH c_lvs_lte
      into v_lte;
    v_found := c_lvs_lte%FOUND;
    CLOSE c_lvs_lte;

    if not v_found then
      v_err_nr   := c.FMID_LTE_ID_Fehlt;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
      raise v_error;
    end if;
    -- lagerplatz aus lvs_lgr lesen
    OPEN c_lvs_lgr;
    FETCH c_lvs_lgr
      into v_lgr;
    v_found := c_lvs_lgr%FOUND;
    CLOSE c_lvs_lgr;
    if not v_found then
      v_err_nr   := c.FMID_Lager_Platz_fehlt;
      v_err_text := LC.ec_p2(LC.O_TP2_LGR_PLATZ_FEHLT_C_LTE, in_lgr_platz, v_lte.lte_id);
      raise v_error;
    end if;


    if v_lte.lte_status != C.LTE_KF_STAT and
       --v_lte.lte_status != C.LTE_ET_STAT and
       v_lte.lte_status != C.LTE_AF_STAT and
       v_lte.lte_status != C.LTE_AG_STAT and
       v_lte.lte_status != C.LTE_BF_STAT and
       v_lte.lte_status != C.LTE_PF_STAT then
      v_err_nr   := c.FMID_Falscher_LTE_Status;
      v_err_text := LC.ec_p2(LC.O_TP2_LTE_ID_ST_N_EINL_BAR, in_lte_id, v_lte.lte_status);
      raise v_error;
    end if;

    if in_lgr_platz_quelle is null then
      v_lgr_platz := v_lte.lgr_platz;
    else
      v_lgr_platz := in_lgr_platz_quelle;
    end if;

    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;
    CLOSE c_lte_cfg;

    v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
    v_err_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(v_lte,
                                                           v_basis_lte_name,
                                                           v_lte_cfg.flaechen_stellplatz_erf,
                                                           v_lgr,
                                                           'E',
                                                           in_fahrzeuge_IDs);
    if v_err_text != NULL
    then
      v_err_nr   := lvs_platz.v_lgr_platz_fehler;
      raise v_error;
    end if;

    if (v_lgr.sid is NOT NULL) then
      v_transport_gruppe := 0;
      v_result := lvs_transport.lvs_transp_lte(v_lte.sid,
                                           v_lte.firma_nr,
                                           in_modul_erzeuger,
                                           in_modul_bearbeiter,
                                           'F',
                                           'E',
                                           in_user_ID,
                                           null,
                                           null,
                                           in_prio,
                                           in_progr_nr,
                                           in_quelle_Leer_progr_nr,
                                           in_ziel_voll_Progr_nr,
                                           v_lgr_platz,
                                           v_lgr.lgr_platz,
                                           in_lte_id,
                                           null,
                                           'F',
                                           null,
                                           null,
                                           null,
                                           in_fahrzeuge_IDs,
                                           NULL,
                                           v_transport_gruppe,
                                           out_transport_id);
    end if;

    if v_result = 0 then
      out_lgr_platz := v_lgr.lgr_platz;
      Commit;
    else
      out_lgr_platz    := NULL;
      out_transport_id := NULL;
      rollback;
    end if;
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
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
  end LVS_C_TRANSP_EINL_PRUEF_RID;

/*******************************************************************************
 * procedure lvs_c_lte_erz_transp_gesp(...)
 *
 * Erzeugen eine Palette über Liniendaten Tabelle: LVS_PROD_LINIE,
 *                                                 LVS_PROD_LINIE WAREN
 *******************************************************************************/

  function lvs_c_lte_erz_transp_gesp(in_sid            in isi_sid.sid%type,
                                     in_firma_nr       in isi_firma.firma_nr%type,
                                     in_linie          in lvs_prod_linie.linie_nr%type,
                                     in_we_lgr_platz   in lvs_lgr.lgr_platz%type,
                                     in_modul_erzeuger in isi_transport.modul_erzeuger%type,
                                     in_ziel_lgr_platz in lvs_lgr.lgr_platz_gruppe%type,
                                     in_prio           in isi_transport.prio%type,
                                     in_login_id       in isi_user.login_id%type)
                                     return varchar2 is
  -------------------------------------------------------------------------------------------------------
    v_result           integer;
    v_transp_id        isi_transport.transp_id%type;
    v_transport_gruppe isi_transport.transport_gruppe%type;

    v_lte_id           lvs_lte.lte_id%type;

    v_linie            lvs_prod_linie%rowtype;
    v_linie_waren      lvs_prod_linie_waren%rowtype;
    v_linie_waren2     lvs_prod_linie_waren%rowtype;

    v_lte              lvs_lte%rowtype;
    v_lte_cfg          lvs_lte_cfg%rowtype;
    v_lgr              lvs_lgr%rowtype;

    cursor c_linie is
      select t.*
        from lvs_prod_linie t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.linie_nr = in_linie;

    cursor c_linie_waren is
      select t.*
        from lvs_prod_linie_waren t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.linie_nr = in_linie;

    v_found boolean;
    v_menge_erz_ges number;
  begin
    reset_isi_error();

    open c_linie;
    fetch c_linie into v_linie;
    v_found := c_linie%found;
    close c_linie;

    if not v_found
    then
      v_err_nr := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_LVS_PROD_LINIE_FEHLT, nvl(to_char(in_linie), 'null'));
      raise v_error;
    end if;

    if not lvs_p_base.get_lgr_platz(in_ziel_lgr_platz, v_lgr)
    then
      v_err_nr := 20;
      v_err_text := LC.ec_p1(LC.O_TP1_LAGERPLATZ_FEHLT, in_ziel_lgr_platz);
      raise v_error;
    end if;


    if v_linie.lte_name = c.KeineLTE
    then
      -- wenn LTE Typ = "-KeineLTE", dann bei mehreren LHMs einzelne LTEs erzeugen
      open c_linie_waren;
      fetch c_linie_waren into v_linie_waren;
      v_found := c_linie_waren%found;
      if v_found
      then
        fetch c_linie_waren into v_linie_waren2;
        if c_linie_waren%found
        then
          close c_linie_waren;
          v_err_nr := 20;
          v_err_text := LC.ec(LC.O_TXT_LTE_N_POS_OHNE_LTE_ERR);
          raise v_error;
        end if;
      end if;
      close c_linie_waren;

      v_menge_erz_ges := 0;
      loop
        exit when v_menge_erz_ges >= v_linie_waren.menge;
        -- Wir haben uns die Mengen aus der Linie gemerkt, jetzt passen wir die Liniendaten an,
        -- damit immer nur eine LTE pro LHM erzeugt wird
        if (v_menge_erz_ges + v_linie_waren.menge_je_karton) > v_linie_waren.menge
        then
          -- Restmenge
          v_linie_waren.menge_je_karton := v_linie_waren.menge - v_menge_erz_ges;
        end if;

        -- Mengen so setzen, dass immer nur ein LHM und eine LTE erzeugt wird
        update lvs_prod_linie_waren t
           set t.menge           = v_linie_waren.menge_je_karton,
               t.menge_je_karton = v_linie_waren.menge_je_karton
         where t.sid = v_linie_waren.sid
           and t.firma_nr = v_linie_waren.firma_nr
           and t.linie_nr = v_linie_waren.linie_nr
           and t.waren_nr = v_linie_waren.waren_nr;

        -- lte erzeugen für jede LHM
        v_lte_id := lvs_p_lte.lvs_lte_erzeugen(in_sid, in_firma_nr, in_linie, null, in_login_id, null, null);

        if not lvs_p_base.get_lte(v_lte_id, v_lte)
        then
          v_err_nr := 40;
          v_err_text := LC.ec(LC.O_TXT_LTE_ANLEG_ERR);
          raise v_error;
        end if;

        if not lvs_p_base.get_lte_cfg(in_sid, v_lte.lte_name, v_lte_cfg)
        then
          v_err_nr := 45;
          v_err_text := LC.ec_p1(LC.O_TP1_LTE_CFG_FEHLT, v_lte.lte_name);
          raise v_error;
        end if;

        lvs_platz.lvs_platz_einl_pruefen_R30(v_lte,
                                             v_lte_cfg.basis_lte_name,
                                             v_lte_cfg.flaechen_stellplatz_erf,
                                             v_lgr,
                                             'E',
                                             null); -- keine Fahrzeuge

        v_transport_gruppe := 0;
        v_result := lvs_transport.lvs_transp_lte (in_sid,
                                                  in_firma_nr,
                                                  in_modul_erzeuger,
                                                  null,
                                                  C.C_FALSE,
                                                  'E',
                                                  in_login_id,
                                                  null,
                                                  null,
                                                  in_prio,
                                                  0,
                                                  0,
                                                  0,
                                                  in_we_lgr_platz,
                                                  in_ziel_lgr_platz,
                                                  v_lte_id,
                                                  null,
                                                  c.c_false,
                                                  null,
                                                  null,
                                                  null,
                                                  null,             -- in_fahrzeuge_IDs Transport soll in jedem Fall erzeugt werden, auch wenn das Fahrzeug gestört ist
                                                  null,
                                                  v_transport_gruppe,
                                                  v_transp_id);

        if v_result != 0
        then
          v_err_nr := 10;
          v_err_text := c.decode_function_fehler(v_result);
          raise v_error;
        end if;

        v_result := lvs_transport.transport_sperren(in_sid, in_firma_nr, in_login_id, v_transp_id);

        -- erzeugte Mengen merken
        v_menge_erz_ges := v_menge_erz_ges + v_linie_waren.menge_je_karton;

        commit;
      end loop;
    else
      v_lte_id := lvs_p_lte.lvs_lte_erzeugen(in_sid, in_firma_nr, in_linie, null, in_login_id, null, null);

      if not lvs_p_base.get_lte(v_lte_id, v_lte)
      then
        v_err_nr := 50;
        v_err_text := LC.ec(LC.O_TXT_LTE_ANLEG_ERR);
        raise v_error;
      end if;

      if not lvs_p_base.get_lte_cfg(in_sid, v_lte.lte_name, v_lte_cfg)
      then
        v_err_nr := 55;
        v_err_text := LC.ec_p1(LC.O_TP1_LTE_CFG_FEHLT, v_lte.lte_name);
        raise v_error;
      end if;

      lvs_platz.lvs_platz_einl_pruefen_R30(v_lte,
                                           v_lte_cfg.basis_lte_name,
                                           v_lte_cfg.flaechen_stellplatz_erf,
                                           v_lgr,
                                           'E',
                                           null); -- keine Fahrzeuge

      v_transport_gruppe := 0;
      v_result := lvs_transport.lvs_transp_lte ( in_sid,
                                                in_firma_nr,
                                                in_modul_erzeuger,
                                                null,
                                                C.C_FALSE,
                                                'E',
                                                in_login_id,
                                                null,
                                                null,
                                                in_prio,
                                                0,
                                                0,
                                                0,
                                                in_we_lgr_platz,
                                                in_ziel_lgr_platz,
                                                v_lte_id,
                                                null,
                                                c.c_false,
                                                null,
                                                null,
                                                null,
                                                null,             -- in_fahrzeuge_IDs Transport soll in jedem Fall erzeugt werden, auch wenn das Fahrzeug gestört ist
                                                null,
                                                v_transport_gruppe,
                                                v_transp_id);

      if v_result != 0
      then
        v_err_nr := 60;
        v_err_text := c.decode_function_fehler(v_result);
        raise v_error;
      end if;

      v_result := lvs_transport.transport_sperren(in_sid, in_firma_nr, in_login_id, v_transp_id);
    end if;

    commit;

    return v_lte_id;
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
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
  end;

/*******************************************************************************
 * procedure lvs_c_lte_erz_order_wai(...)
 *
 * Erzeugen eine Palette über Liniendaten Tabelle: LVS_PROD_LINIE,
 *                                                 LVS_PROD_LINIE WAREN
 * direkt für einen Order (durchlagern zur Abladestelle)
 *******************************************************************************/

  function lvs_c_lte_erz_order_wai(in_sid              in isi_sid.sid%type,
                                   in_firma_nr         in isi_firma.firma_nr%type,
                                   in_linie            in lvs_prod_linie.linie_nr%type,
                                   in_we_lgr_platz     in lvs_lgr.lgr_platz%type,
                                   in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
                                   in_order_auf_id     in isi_order_pos.auf_id%type,
                                   in_prio             in isi_transport.prio%type,
                                   in_login_id         in isi_user.login_id%type,
                                   in_arbeitsplatz_id  in isi_order_pos.arbeitsplatz_id%type,
                                   in_transp_sperren   in varchar2)
                                  return varchar2 is
  -------------------------------------------------------------------------------------------------------
    v_result           integer;
    v_transp_id        isi_transport.transp_id%type;
    v_transport_gruppe isi_transport.transport_gruppe%type;

    v_lte_id lvs_lte.lte_id%type;

    v_order_pos isi_order_pos%rowtype;

    cursor c_order_pos is
      select *
        from isi_order_pos op
       where op.sid = in_sid
         and op.firma_nr = in_firma_nr
         and op.auf_id = in_order_auf_id;

    v_found boolean;
  begin
    reset_isi_error();

    open c_order_pos;
    fetch c_order_pos into v_order_pos;
    v_found := c_order_pos%found;
    close c_order_pos;

    if not v_found
    then
      v_err_nr := 1;
      v_err_text := LC.ec_p1(LC.O_TP1_ORDER_AUF_ID_FEHLT, in_order_auf_id);
      raise v_error;
    end if;

    if v_order_pos.satzart = 'MA'
    and v_order_pos.vorgang_typ = 'WAI'
    then
      -- Die Rücklagerung darf bei Vorbestellungen nicht gesperrt werden,
      -- da noch keine wirkliche Rücklagerung erfolgt ist.
      update lvs_prod_linie_waren t
         set t.sonst_id_lieferant = null
       where t.linie_nr = in_linie
         and t.sonst_id_lieferant is not null;
    end if;

    v_lte_id := lvs_p_lte.lvs_lte_erzeugen(in_sid, in_firma_nr, in_linie, null, in_login_id, null, null);

    -- wir müssen die gerade erzeugte palette gleich reservieren,
    -- damit sie sofort ausgelagert werden kann
    update lvs_lte t
       set t.lte_status = c.LTE_BF_STAT
     where t.lte_id = v_lte_id;

    v_result := lvs_ausl.lvs_lte_reservieren(in_sid, in_firma_nr, v_order_pos.vorgang_id, in_order_auf_id, v_lte_id, null, null, v_order_pos.artikel_id);

    update isi_order_pos op
       set op.arbeitsplatz_id = in_arbeitsplatz_id,
           op.status = 'A',
           op.ware_disponiert = 'T',
           op.freigegeben_datum = sysdate
     where op.sid = v_order_pos.sid
       and op.auf_id = v_order_pos.auf_id;

    v_transport_gruppe := 0;
    v_result := lvs_transport.lvs_transp_lte (in_sid,
                                              in_firma_nr,
                                              in_modul_erzeuger,
                                              null,
                                              C.C_FALSE,
                                              'E',
                                              in_login_id,
                                              in_order_auf_id,
                                              null,
                                              in_prio,
                                              0,
                                              0,
                                              0,
                                              in_we_lgr_platz,
                                              v_order_pos.ziel,
                                              v_lte_id,
                                              null,
                                              c.c_false,
                                              null,
                                              null,
                                              v_order_pos.vorgang_id,
                                              null,             -- in_fahrzeuge_IDs Transport soll in jedem Fall erzeugt werden, auch wenn das Fahrzeug gestört ist
                                              null,
                                              v_transport_gruppe,
                                              v_transp_id);


    if v_result != 0
    then
      v_err_nr := 10;
      v_err_text := c.decode_function_fehler(v_result);
      raise v_error;
    end if;

    --if in_transp_sperren = c.c_true
    --then
    v_result := lvs_transport.transport_sperren(in_sid, in_firma_nr, in_login_id, v_transp_id);
    --end if;

    commit;

    return v_lte_id;
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
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
  end;

/*******************************************************************************
 * procedure lvs_c_lte_transp_delete(...)
 *
 * Löscht eine LTE und den zugehörigen (gesperrten) Transport
 * (erforderlich bei Einlagerung mit Platzdisponierung)
 *******************************************************************************/
  procedure lvs_c_lte_transp_delete (in_sid         in isi_sid.sid%type,
                                     in_firma_nr    in lvs_lte.firma_nr%type,
                                     in_lte_id      in lvs_lte.lte_id%type,
                                     in_login_id    in isi_user.login_id%type
                                    ) is

    v_lte                           lvs_lte%rowtype;
    v_lam                           lvs_lam%rowtype;
    v_transport                     isi_transport%rowtype;
    v_result                        number;
    v_artikel_id                    isi_artikel.artikel_id%type;
    v_order_pos                     isi_order_pos%rowtype;

    cursor c_lam is
      select *
        from lvs_lam l
       where l.lte_id = in_lte_id;

    cursor c_lte is
      select *
        from lvs_lte t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = in_lte_id;

    cursor c_transport is
      select *
        from isi_transport t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = in_lte_id;

    v_anz_order_pos number;
    cursor c_anz_order_res is
      select count(*)
        from lvs_lte t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id != v_lte.lte_id
         and t.order_auf_id = v_lte.order_auf_id; -- -WK- 2008-04-11: Problem bei Restmengen einer Bestellung order_vorgang_id = v_lte.order_vorgang_id;
    v_found boolean;
  begin
    reset_isi_error();

    open c_lte;
    fetch c_lte into v_lte;
    if c_lte%found
    then
      OPEN c_lam;
      FETCH c_lam into v_lam;
      CLOSE c_lam;

      if v_lte.order_vorgang_id is not null
      then
        open c_anz_order_res;
        fetch c_anz_order_res into v_anz_order_pos;
        v_found := c_anz_order_res%found;
        close c_anz_order_res;

        if v_found and v_anz_order_pos > 0
        then
          -- Es gibt noch andere LTEs, die für diese Order reserviert sind
          v_result := lvs_ausl.lvs_lte_res_rueck(in_sid, in_firma_nr, v_lte.order_vorgang_id, v_lte.order_auf_id,
                                                 v_lte.lte_id, v_lte.order_vorgang_id, v_lte.lgr_platz, c.c_true);
        else
          -- Die gesamte Order zurücksetzen
          if isi_p_order_base.get_order_pos(in_sid, v_lte.order_auf_id, v_order_pos)
          then
            isi_p_order.abbruch_transporte(in_sid, in_firma_nr, v_order_pos.vorgang_id, v_order_pos.auf_id,
                                           v_order_pos.vorgang_typ, v_order_pos.satzart, in_login_id, c.c_true);
            -- Die Bindung an den Arbeitsplatz freigeben
            update isi_order_pos op
               set op.arbeitsplatz_id = null
             where op.sid = in_sid
               and op.auf_id = v_lte.order_auf_id;
          end if;
        end if;
      end if;

      open c_transport;
      fetch c_transport into v_transport;
      v_found := c_transport%found;
      close c_transport;

      if v_found
      then
        v_result := lvs_transport.lvs_transp_loeschen(in_sid, in_firma_nr, in_login_id, v_transport.transp_id, c.c_true);
      end if;


      if v_lte.lgr_platz is not null
      then
        -- Die Zugänge müssen auf jeden Fall wieder Abgebucht werden,
        -- Wenn bei den Zugängen auf einen WE kein Zugang in die Schnittstelle
        -- gebucht wird, dann muss auch kein Abgang mehr gebucht werden
        v_artikel_id := v_lam.artikel_id;
        -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
        if (lvs_ausl.lvs_lam_abgang(in_sid,                        -- in_sid         in isi_sid.sid%type,
                                    in_firma_nr,                   -- in_firma_nr    in isi_firma.firma_nr%type,
                                    v_artikel_id,                  -- in_out_artikel_id  in out isi_artikel.artikel_id%type,
                                    v_lte.lte_id,                  -- in_lte_id      in lvs_lte.lte_id%type,
                                    v_lam.lhm_id,                  -- in_lhm_id      in lvs_lhm.lhm_id%type,
                                    NULL,                          -- in_abnr        in bde_fa_auftrag.abnr%type,
                                    NULL,                          -- in_res_id      in isi_resource.res_id%type,
                                    sysdate,                       -- in_abg_datum   in date,
                                    in_login_id,                   -- in_ls_login_id in isi_user.login_id%type,
                                    NULL,                          -- in_vorgag_id   in lvs_lam_bh.vorg_id%type,
                                    NULL,                          -- in_bew_id      in s_send_bew.bew_id%type,
                                    v_lam.leitzahl,                -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                                    v_lam.fa_ag,                   -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                                    v_lam.fa_upos,                 -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                    NULL,                          -- in_abnr_extern in bde_fa_auftrag.abnr%type,
                                    c.LAM_BH_BUS_ABG,              -- in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                    null,                           -- in_tour        in isi_order_pos.vorgang_id%type
                                    null,
                                    null)
                                    = 0)
        then
          v_err_nr := 10;
          v_err_text := LC.ec_p2(LC.O_TP2_LTE_M_STATUS_LOESCHEN, v_lte.lte_id, v_lte.lte_status);
          raise v_error;
        end if;
        --lvs_p_lte.lvs_korr_te_ausbuchen(in_sid, in_firma_nr, v_lte.lte_id, v_lte.lte_status, in_sid,
        --                                in_firma_nr, v_lte.lgr_ort, v_lte.lgr_platz, in_login_id);
      end if;

      delete lvs_lam t
       where t.sid = v_lam.sid
         and t.firma_nr = v_lam.firma_nr
         and t.lam_id = v_lam.lam_id;

      delete lvs_lhm t
       where t.lhm_id = v_lam.lhm_id;

      -- !! commited Funktion
      lvs_p_lte.lvs_c_lte_delete(in_sid, in_lte_id, in_login_id);
    end if;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_lte%isopen
      then
        close c_lte;
      end if;
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_lte%isopen
      then
        close c_lte;
      end if;
      rollback;
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
  end lvs_c_lte_transp_delete;

/*******************************************************************************
 * procedure c_lte_erz_transp(...)
 *
 * Erzeugen einer Palette über Liniendaten Tabelle: LVS_PROD_LINIE,
 *                                                  LVS_PROD_LINIE WAREN
 * Automatischer Etikettendruck und Transport zum Lagerplatz
 *******************************************************************************/

  function c_lte_erz_transp(in_sid              in isi_sid.sid%type,
                            in_firma_nr         in isi_firma.firma_nr%type,
                            in_linie            in lvs_prod_linie.linie_nr%type,
                            in_we_lgr_platz     in lvs_lgr.lgr_platz%type,
                            in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
                            in_ziel_lgr_platz   in lvs_lgr.lgr_platz_gruppe%type,
                            in_prio             in isi_transport.prio%type,
                            in_login_id         in isi_user.login_id%type,
                            in_lhm_drucker_name in pe_jobs.drucker_name%type,
                            in_lte_drucker_name in pe_jobs.drucker_name%type)
                            return varchar2 is
    v_result           integer;

    v_lgr     lvs_lgr%rowtype;

    v_lte_id  lvs_lte.lte_id%type;
    v_lte     lvs_lte%rowtype;

    v_lte_cfg lvs_lte_cfg%rowtype;

    v_transp_id        isi_transport.transp_id%type;
    v_transport_gruppe isi_transport.transport_gruppe%type;

    cursor c_lhm_soll_druck is
      select t.lhm_id
        from lvs_lhm t
       where t.lte_id = v_lte_id
         and t.lhm_eti_druck_status = c.ETI_STATUS_SOLL_DRUCKEN;

    v_lhm_id  lvs_lhm.lhm_id%type;
  begin
    reset_isi_error();

    if not lvs_p_base.get_lgr_platz(in_ziel_lgr_platz, v_lgr)
    then
      raise_isi_error(20, lc.ec_p1(LC.O_TP1_LAGERPLATZ_FEHLT, in_ziel_lgr_platz));
    end if;

    v_lte_id := lvs_p_lte.lvs_lte_erzeugen(in_sid, in_firma_nr, in_linie, null, in_login_id, null, null);

    if not lvs_p_base.get_lte(v_lte_id, v_lte)
    then
      raise_isi_error(50, lc.ec(LC.O_TXT_LTE_ANLEG_ERR));
    end if;

    if not lvs_p_base.get_lte_cfg(in_sid, v_lte.lte_name, v_lte_cfg)
    then
      raise_isi_error(55, lc.ec_p1(lc.O_TP1_LTE_CFG_FEHLT, v_lte.lte_name));
    end if;

    lvs_platz.lvs_platz_einl_pruefen_R30(v_lte,
                                         v_lte_cfg.basis_lte_name,
                                         v_lte_cfg.flaechen_stellplatz_erf,
                                         v_lgr,
                                         'E',
                                         null); -- keine Fahrzeuge

    v_transport_gruppe := 0;
    v_result := lvs_transport.lvs_transp_lte (in_sid,
                                              in_firma_nr,
                                              in_modul_erzeuger,
                                              null,
                                              C.C_FALSE,
                                              'E',
                                              in_login_id,
                                              null,
                                              null,
                                              in_prio,
                                              0,
                                              0,
                                              0,
                                              in_we_lgr_platz,
                                              in_ziel_lgr_platz,
                                              v_lte_id,
                                              null,
                                              c.c_false,
                                              null,
                                              null,
                                              null,
                                              null,             -- in_fahrzeuge_IDs Transport soll in jedem Fall erzeugt werden, auch wenn das Fahrzeug gestört ist
                                              null,
                                              v_transport_gruppe,
                                              v_transp_id);

    if v_result != 0
    then
      raise_isi_error(60, c.decode_function_fehler(v_result));
    end if;

    if nvl(in_lte_drucker_name, in_lhm_drucker_name) is not null
    then
      -- automatischer Etkettendruck bei mitgeliefertem Druckername
      open c_lhm_soll_druck;
      loop
        fetch c_lhm_soll_druck into v_lhm_id;
        exit when c_lhm_soll_druck%notfound;

        lvs_p_lte.lvs_lhm_drucken(v_lhm_id, null, in_lhm_drucker_name);
      end loop;
      close c_lhm_soll_druck;

      if v_lte.lte_eti_druck_status = c.ETI_STATUS_SOLL_DRUCKEN
      then
        v_result := lvs_p_lte.lvs_lte_drucken(v_lte.lte_id, null, nvl(in_lte_drucker_name, in_lhm_drucker_name));
      end if;
    end if;

    commit;

    return v_lte_id;
  exception
    -- Im Fehlerfall is v_err_nr bereits gesetzt
     when v_error then  -- Update 2011 show Exception Source Line
      if c_lhm_soll_druck%isopen
      then
        close c_lhm_soll_druck;
      end if;
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_lhm_soll_druck%isopen
      then
        close c_lhm_soll_druck;
      end if;
      rollback;
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
  end;

  function check_lte_name_einl( in_sid              in isi_sid.sid%type,
                                in_firma_nr         in isi_firma.firma_nr%type,
                                in_lgr_ort          in lvs_lgr_ort.lgr_ort%type,
                                in_lgr_gruppe_id    in lvs_lgr.lgr_gruppe_id%type,
                                in_lte_name         in lvs_lte_cfg.lte_name%type,
                                in_einl_extern      in varchar2,
                                in_anz_lte          in number)
                        return varchar2 is

  v_return                    varchar2(1);

  v_lvs_lgr_ort_fuellg_check  lvs_lgr_ort_fuellg_check%rowtype;
  v_lgr_check_proz            number;


  CURSOR c_lgr_check is
    select lgr.lgr_ort,
           sum(lgr.lgr_max_te) lgr_max_te,
           sum(lgr.lgr_akt_te) lgr_akt_te,
           sum(lgr.lgr_dispo_ausl_te) lgr_dispo_ausl_te,
           sum(lgr.lgr_dispo_einl_te) lgr_dispo_einl_te,
           sum(lgr.lgr_max_te) -sum(lgr.lgr_akt_te) + sum(lgr.lgr_dispo_ausl_te) - sum(lgr.lgr_dispo_einl_te) lgr_anz_ver
      from lvs_lgr lgr
     where lgr.sid = in_sid
       and lgr.firma_nr = in_firma_nr
       and lgr.lgr_ort = in_lgr_ort
       and lgr.lgr_gruppe_id = nvl(in_lgr_gruppe_id, lgr.lgr_gruppe_id)
       and (  nvl(lgr.lte_namen_cfg, nvl(in_lte_name, 'XXXX')) like '%;' || nvl(in_lte_name, 'XXXX') || ';%'
           or nvl(lgr.lte_namen_cfg, nvl(in_lte_name, 'XXXX')) like nvl(in_lte_name, 'XXXX') || ';%'
           )
       and lgr.lte_namen != 'Keine'
     group by lgr.lgr_ort;

     v_lgr_check         c_lgr_check%rowtype;
  begin
    v_return := c.C_TRUE;

    OPEN c_lgr_check;
    FETCH c_lgr_check into v_lgr_check;
    CLOSE c_lgr_check;

    if lvs_p_base.get_lgr_ort_fuellg_chk_by_p(in_sid, in_firma_nr, in_lgr_ort, in_lgr_gruppe_id, in_lte_name, v_lvs_lgr_ort_fuellg_check)
    then
      v_lgr_check_proz := 100 - ((v_lgr_check.lgr_anz_ver - in_anz_lte) / v_lgr_check.lgr_max_te * 100);   -- Verfuegbarer %-Satz
      if v_lgr_check_proz > v_lvs_lgr_ort_fuellg_check.lgr_ort_fuellg_max_proz
      or (   in_einl_extern = c.C_TRUE
         and v_lgr_check_proz > v_lvs_lgr_ort_fuellg_check.lgr_ort_fuellg_wee_max_p
         )
      then
        v_return := c.C_FALSE;
      end if;
    end if;

    return (v_return);
  end;

end LVS_EINL;
/



-- sqlcl_snapshot {"hash":"f8dff8239c344db53e801f5c3f6f6841824b7b62","type":"PACKAGE_BODY","name":"LVS_EINL","schemaName":"DIRKSPZM32","sxml":""}