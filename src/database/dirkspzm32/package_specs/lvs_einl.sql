create or replace 
package DIRKSPZM32.LVS_EINL is

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
  21.11.2013   3.5.7       (-WK-)   Erweiterungen für Eigentümer (Konsignationsware)
  27.11.2009   3.5.0.3     (-BW-)   Minor Release
  22.09.2008   3.4.8.2     (-WK-)   neue Function c_lte_erz_transp mit automatischem
  *                                 Etikettendruck und Transport zum Lagerplatz
  22.04.2008   3.4.4.1     (-AM-)   lvs_lam_zugang: keine LTE für
  *                                 gescannte Leerkartons anlegen
  25.10.2006   3.3.4.0     (-AG-)   Erstellung des Package
  */

  -------------------------------------------------------------------------------------------------------
  -- Release handling
  -------------------------------------------------------------------------------------------------------
  v_release_major  constant number := 3;
  v_release_minor  constant number := 5;
  v_revision       constant number := 7;
  -- the build number is counted in the package body
  v_rev_date       constant varchar2(20) := '21.11.2013';
  v_release_str    constant  varchar2(20) := to_char(v_release_major) || '.' ||
                                             to_char(v_release_minor) || '.' ||
                                             to_char(v_revision) || ' / ' ||
                                             v_rev_date;

  --v_version_str    constant  varchar2(20) := '3.5.7.4 / 21.11.2013';
  function get_release return varchar2;
  function get_version return varchar2;
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2);

  -------------------------------------------------------------------------------------------------------
  -- Public declarations
  -------------------------------------------------------------------------------------------------------

  /* function lvs_lam_zugang
     Bucht einen Artikel-/Material-Zugang über die Tabelle lvs_lam_bh

     ---- HISTORY ---
     25.10.2006 -AG- Erstellt

     @param in_artikel_id    Eindeutige ID des Artikels (nicht Artikenummer!), dessen Zugang gebucht werden soll
     ...
   */
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
  ) return number;

  /* function lvs_lam_zugang
     Bucht einen Artikel-/Material-Zugang über die Tabelle lvs_lam_bh
     ggf. mit Zuordnung des Eigentümers

     ---- HISTORY ---
     21.11.2013 -WK- Erstellt für Erweiterung Konsignationsware und Konsignationslager

     @param in_artikel_id        Eindeutige ID des Artikels (nicht Artikenummer!), dessen Zugang gebucht werden soll
     ...
     @param in_owner_address_id  Adress ID des Eigentümers (i.d.R. Lieferant) der Konsignationsware (NULL = eigene Ware)
   */
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
  ) return number;
  /* function lvs_lam_zugang
     Bucht einen Artikel-/Material-Zugang über die Tabelle lvs_lam_bh
     ggf. mit Zuordnung des Eigentümers

     ---- HISTORY ---
     21.11.2013 -HJG- Erstellt für Erweiterung LHM_VOL_xx

     @param in_artikel_id        Eindeutige ID des Artikels (nicht Artikenummer!), dessen Zugang gebucht werden soll
     ...
     @param in_owner_address_id  Adress ID des Eigentümers (i.d.R. Lieferant) der Konsignationsware (NULL = eigene Ware)
  */
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
  ) return number;

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
  ) return number;
  /* procedure lvs_c_transp_einl_pruef_rid
     TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung

     ---- HISTORY ---

     @param in_lte_id            TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung
     ...
   */
  procedure lvs_c_transp_einl_pruef_rid(
    in_lte_id               in lvs_lte.lte_id%type,
    in_lgr_platz            in varchar2,
    in_fahrzeuge_ids        in varchar2,
    in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
    in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
    in_user_id              in isi_user.login_id%type,
    in_prio                 in isi_transport.prio%type,
    in_progr_nr             in isi_transport.progr_nr%type,
    in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
    in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
    in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
    in_aktuelle_position    in lvs_lam.lam_text%type,
    out_lgr_platz           out lvs_lgr.lgr_platz%type,
    out_transport_id        out number,
    out_res_id              out isi_resource.res_id%type
  );

  /* function lvs_c_lte_erz_transp_gesp
     TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung

     ---- HISTORY ---

     @param in_lte_id            TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung
     ...
   */
  function lvs_c_lte_erz_transp_gesp(
    in_sid            in isi_sid.sid%type,
    in_firma_nr       in isi_firma.firma_nr%type,
    in_linie          in lvs_prod_linie.linie_nr%type,
    in_we_lgr_platz   in lvs_lgr.lgr_platz%type,
    in_modul_erzeuger in isi_transport.modul_erzeuger%type,
    in_ziel_lgr_platz in lvs_lgr.lgr_platz_gruppe%type,
    in_prio           in isi_transport.prio%type,
    in_login_id       in isi_user.login_id%type
  ) return varchar2;

  /* function lvs_c_lte_erz_order_wai
     TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung

     ---- HISTORY ---

     @param in_lte_id            TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung
     ...
   */
  function lvs_c_lte_erz_order_wai(
    in_sid              in isi_sid.sid%type,
    in_firma_nr         in isi_firma.firma_nr%type,
    in_linie            in lvs_prod_linie.linie_nr%type,
    in_we_lgr_platz     in lvs_lgr.lgr_platz%type,
    in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
    in_order_auf_id     in isi_order_pos.auf_id%type,
    in_prio             in isi_transport.prio%type,
    in_login_id         in isi_user.login_id%type,
    in_arbeitsplatz_id  in isi_order_pos.arbeitsplatz_id%type,
    in_transp_sperren   in varchar2
  ) return varchar2;

  /* procedure lvs_c_lte_transp_delete
     TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung

     ---- HISTORY ---

     @param in_lte_id            TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung
     ...
   */
  procedure lvs_c_lte_transp_delete (
    in_sid         in isi_sid.sid%type,
    in_firma_nr    in lvs_lte.firma_nr%type,
    in_lte_id      in lvs_lte.lte_id%type,
    in_login_id    in isi_user.login_id%type
  );

  /* function c_lte_erz_transp
     TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung

     ---- HISTORY ---

     @param in_lte_id            TODO: HJG kommentieren bzw. kommentieren lassen nach Schulung
     ...
   */
  function c_lte_erz_transp(
    in_sid              in isi_sid.sid%type,
    in_firma_nr         in isi_firma.firma_nr%type,
    in_linie            in lvs_prod_linie.linie_nr%type,
    in_we_lgr_platz     in lvs_lgr.lgr_platz%type,
    in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
    in_ziel_lgr_platz   in lvs_lgr.lgr_platz_gruppe%type,
    in_prio             in isi_transport.prio%type,
    in_login_id         in isi_user.login_id%type,
    in_lhm_drucker_name in pe_jobs.drucker_name%type,
    in_lte_drucker_name in pe_jobs.drucker_name%type
  ) return varchar2;

  function check_lte_name_einl(
                                in_sid              in isi_sid.sid%type,
                                in_firma_nr         in isi_firma.firma_nr%type,
                                in_lgr_ort          in lvs_lgr_ort.lgr_ort%type,
                                in_lgr_gruppe_id    in lvs_lgr.lgr_gruppe_id%type,
                                in_lte_name         in lvs_lte_cfg.lte_name%type,
                                in_einl_extern      in varchar2,
                                in_anz_lte          in number
  ) return varchar2;

end;
/



-- sqlcl_snapshot {"hash":"ce585d8457ec413f91c983cda39b1a58bfe16e33","type":"PACKAGE_SPEC","name":"LVS_EINL","schemaName":"DIRKSPZM32","sxml":""}