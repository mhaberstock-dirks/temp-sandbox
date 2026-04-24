create or replace package body dirkspzm32.bde_p_pps is

/*
Funktionen für die Erzeugung von Fertigungsaufträgen über PPS-Tabellen Hier werden 
Deckel zur Verfügung gestell, die dann Funktionrn im pps_p_bde aufrufen. Da die 
hier benötigten Aufrufe aus Triggern aufgerufen werden, und einen Commit haben, 
werden die Methoden hier mit pragma autonomous_transaction bereitgestellt.

@author -HJG- Hans Joachim Gödeke

-- HISTORY
--__________________________________________________
-- Datum       Version     AUTOR    Comment
--27.11.2009   3.4.4.1     (-HJG-)  erstellt
--11.02.2015   3.5.8.x     (-HJG-)  Kommentare in JavaDoc-Style geändert

*/

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);

    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end;

    procedure raise_isi_error (
        in_err_nr   in number,
        in_err_text in varchar2
    ) is
    begin
        v_err_nr := in_err_nr;
        v_err_text := in_err_text;
        raise v_error;
    end;
  -------------------------------------------------------------------------------------------------------

/*
procedure c_create_bde_fa_auftrag_a_plan Ruft die gleichnamige Funktion im PPS_P_BDE
Erzeugt Eintraege in der BDE_FA_AUFTRAG auf der Grundlage der PPS_ARB_PLAN Daten.

@author -HJG- Hans Joachim Gödeke

@param in_sid              in isi_sid.sid
@param in_firma_nr         in isi_firma.firma_nr
@param in_artikel_id       in isi_artikel.artikel_id Artikel ID des Fertigprodukts
@param in_charge_bez       in lvs_charge.charge_bez Charge für die Produktion
@param in_res_id           in isi_resource.res_id Resource, auf der gefertigt werden soll
@param in_login_id         in isi_user.login_id Login-ID des Erstellers
@param in_menge            in lvs_lam.menge Zu produtzierende Menge
@param in_ab_text1         in bde_fa_auftrag.ab_text1 Kopf-Text 1 für Produktion
@param in_ab_text2         in bde_fa_auftrag.ab_text2 Kopf-Text 2 für Produktion
@param in_ab_text3         in bde_fa_auftrag.ab_text3 Kopf-Text 3 für Produktion
@param in_soll_betriebsart in bde_fa_kopf.soll_betriebsart NULL = nicht relevant, 'A' = Automatik, 'M' = Manuell, 'TESTA' = Testmodus-Automatik, 'TESTM' = Testmodus-Manuell, 'TEACH' = Teachmodus
@param in_kunden_nr        in bde_fa_auftrag.kunden_nr Kundennummer, für die produziert werden soll
@param in_kd_art_nr        in bde_fa_auftrag.kd_art_nr Kundenartikelnummer für die produziert werden soll
@param in_ag_name1         in bde_fa_auftrag.ag_bez1 Arbeitsgangbezeichnung 1 
@param in_ag_name2         in bde_fa_auftrag.ag_bez2 Arbeitsgangbezeichnung 2 
@param in_ag_text1         in bde_fa_auftrag.ag_text1 Tesxt zum Arbeitsgang 1 (Infotext)
@param in_ag_text2         in bde_fa_auftrag.ag_text2 Tesxt zum Arbeitsgang 2 (Infotext)
@param in_ag_text3         in bde_fa_auftrag.ag_text3 Tesxt zum Arbeitsgang 3 (Infotext)
@param in_kenz_lhm_druck   in bde_fa_auftrag.kenz_lhm_druck Soll bei der Produktion je LHM eine Etikett gedruckt werden 'T' = Bei jedem Karton soll auch ein Etikett gedruckt werden
@param in_anz_lte          in bde_fa_auftrag.lte_anz Sollmenge Anz. LTE
@param in_anz_lhm          in bde_fa_auftrag.lhm_anz Sollmenge Anz. Gebinde
@param in_bestnr_kd        in bde_fa_auftrag.best_nr_kunde Bestellnummer des Kunden
@param in_abnr             in bde_fa_auftrag.abnr Auftrag Bestätigungsnummer Kunde
@param in_serie_id         in bde_fa_kopf.serie_id Seriennummer für die nächste Fertigungseinheit
@param in_serie_auto_inc   in bde_fa_kopf.serie_auto_inc "T" = Serien ID automatisch inkrementieren, "F" = nur SERIE_ID übernehmen
@param in_fa_gruppe        in bde_fa_kopf.fa_gruppe Gruppierungsmerkmal / -schlüssel um Fertigungsaufträge gruppieren zu können
@param in_out_leitzahl     in out bde_fa_auftrag.leitzahl eindeutige Nummer, Fertigungsauftrags-Nr. (LEITZAHL in AG) ISIPlus PPS

-- HISTORY
--__________________________________________________
-- Datum       Version     AUTOR    Comment
--27.11.2009   3.4.4.1     (-HJG-)  erstellt

@see pps_p_bde.c_create_bde_fa_auftrag_a_plan
*/
    procedure c_create_bde_fa_auftrag_a_plan (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_artikel_id       in isi_artikel.artikel_id%type,
        in_charge_bez       in lvs_charge.charge_bez%type,
        in_res_id           in isi_resource.res_id%type,
        in_login_id         in isi_user.login_id%type,
        in_menge            in lvs_lam.menge%type,
        in_ab_text1         in bde_fa_auftrag.ab_text1%type,
        in_ab_text2         in bde_fa_auftrag.ab_text2%type,
        in_ab_text3         in bde_fa_auftrag.ab_text3%type,
        in_soll_betriebsart in bde_fa_kopf.soll_betriebsart%type,
        in_kunden_nr        in bde_fa_auftrag.kunden_nr%type,
        in_kd_art_nr        in bde_fa_auftrag.kd_art_nr%type,
        in_ag_name1         in bde_fa_auftrag.ag_bez1%type,
        in_ag_name2         in bde_fa_auftrag.ag_bez2%type,
        in_ag_text1         in bde_fa_auftrag.ag_text1%type,
        in_ag_text2         in bde_fa_auftrag.ag_text2%type,
        in_ag_text3         in bde_fa_auftrag.ag_text3%type,
        in_kenz_lhm_druck   in bde_fa_auftrag.kenz_lhm_druck%type,
        in_anz_lte          in bde_fa_auftrag.lte_anz%type,
        in_anz_lhm          in bde_fa_auftrag.lhm_anz%type,
        in_bestnr_kd        in bde_fa_auftrag.best_nr_kunde%type,
        in_abnr             in bde_fa_auftrag.abnr%type,
        in_serie_id         in bde_fa_kopf.serie_id%type,
        in_serie_auto_inc   in bde_fa_kopf.serie_auto_inc%type,
        in_fa_gruppe        in bde_fa_kopf.fa_gruppe%type,
        in_out_leitzahl     in out bde_fa_auftrag.leitzahl%type
    ) is
        pragma autonomous_transaction;
    begin
        create_bde_fa_auftrag_a_plan(in_sid,               -- in isi_sid.sid%type,
         in_firma_nr,          -- in isi_firma.firma_nr%type,
         in_artikel_id,        -- in isi_artikel.artikel_id%type,
         in_charge_bez,        -- in lvs_charge.charge_bez%type,
         in_res_id,            -- in isi_resource.res_id%type,
                                     in_login_id,          -- in isi_user.login_id%type,
                                      in_menge,             -- in lvs_lam.menge%type,
                                      in_ab_text1,          -- in bde_fa_auftrag.ab_text1%type,
                                      in_ab_text2,          -- in bde_fa_auftrag.ab_text2%type,
                                      in_ab_text3,          -- in bde_fa_auftrag.ab_text3%type,
                                     in_soll_betriebsart,  -- in bde_fa_kopf.soll_betriebsart%type,
                                      in_kunden_nr,         -- in bde_fa_auftrag.kunden_nr%type,
                                      in_kd_art_nr,         -- in bde_fa_auftrag.kd_art_nr%type,
                                      in_ag_name1,          -- in bde_fa_auftrag.ag_bez1%type,
                                      in_ag_name2,          -- in bde_fa_auftrag.ag_bez2%type,
                                     in_ag_text1,          -- in bde_fa_auftrag.ag_text1%type,
                                      in_ag_text2,          -- in bde_fa_auftrag.ag_text2%type,
                                      in_ag_text3,          -- in bde_fa_auftrag.ag_text3%type,
                                      in_kenz_lhm_druck,    -- in bde_fa_auftrag.kenz_lhm_druck%type,
                                      in_anz_lte,           -- in bde_fa_auftrag.lte_anz%type,
                                     in_anz_lhm,           -- in bde_fa_auftrag.lhm_anz%type,
                                      in_bestnr_kd,         -- in bde_fa_auftrag.best_nr_kunde%type,
                                      in_abnr,              -- in bde_fa_auftrag.abnr%type,
                                      in_serie_id,          -- in bde_fa_kopf.serie_id%type,
                                      in_serie_auto_inc,    -- in bde_fa_kopf.serie_auto_inc%type,
                                     in_fa_gruppe,         -- in bde_fa_kopf.fa_gruppe%type,
                                      in_out_leitzahl);     -- in out bde_fa_auftrag.leitzahl%type)
        commit;
    end;

    procedure create_bde_fa_auf_a_plan_dispo (
        in_sid               in isi_sid.sid%type,
        in_firma_nr          in isi_firma.firma_nr%type,
        in_artikel_id        in isi_artikel.artikel_id%type,
        in_charge_bez        in lvs_charge.charge_bez%type,
        in_res_id            in isi_resource.res_id%type,
        in_login_id          in isi_user.login_id%type,
        in_menge             in lvs_lam.menge%type,
        in_ab_text1          in bde_fa_auftrag.ab_text1%type,
        in_ab_text2          in bde_fa_auftrag.ab_text2%type,
        in_ab_text3          in bde_fa_auftrag.ab_text3%type,
        in_soll_betriebsart  in bde_fa_kopf.soll_betriebsart%type,
        in_kunden_nr         in bde_fa_auftrag.kunden_nr%type,
        in_kd_art_nr         in bde_fa_auftrag.kd_art_nr%type,
        in_ag_name1          in bde_fa_auftrag.ag_bez1%type,
        in_ag_name2          in bde_fa_auftrag.ag_bez2%type,
        in_ag_text1          in bde_fa_auftrag.ag_text1%type,
        in_ag_text2          in bde_fa_auftrag.ag_text2%type,
        in_ag_text3          in bde_fa_auftrag.ag_text3%type,
        in_kenz_lhm_druck    in bde_fa_auftrag.kenz_lhm_druck%type,
        in_anz_lte           in bde_fa_auftrag.lte_anz%type,
        in_anz_lhm           in bde_fa_auftrag.lhm_anz%type,
        in_bestnr_kd         in bde_fa_auftrag.best_nr_kunde%type,
        in_abnr              in bde_fa_auftrag.abnr%type,
        in_serie_id          in bde_fa_kopf.serie_id%type,
        in_serie_auto_inc    in bde_fa_kopf.serie_auto_inc%type,
        in_fa_gruppe         in bde_fa_kopf.fa_gruppe%type,
        in_dispo_charge_rein in varchar2,      -- T = Chargenrein, H = Herstellerrein, F oder NULL Nur nach FIFO
        in_out_leitzahl      in out bde_fa_auftrag.leitzahl%type
    ) is
    begin
        pps_p_bde.create_bde_fa_auf_a_plan_dispo(in_sid,               -- in isi_sid.sid%type,
         in_firma_nr,          -- in isi_firma.firma_nr%type,
         in_artikel_id,        -- in isi_artikel.artikel_id%type,
         in_charge_bez,        -- in lvs_charge.charge_bez%type,
         in_res_id,            -- in isi_resource.res_id%type,
                                                 in_login_id,          -- in isi_user.login_id%type,
                                                  in_menge,             -- in lvs_lam.menge%type,
                                                  in_ab_text1,          -- in bde_fa_auftrag.ab_text1%type,
                                                  in_ab_text2,          -- in bde_fa_auftrag.ab_text2%type,
                                                  in_ab_text3,          -- in bde_fa_auftrag.ab_text3%type,
                                                 in_soll_betriebsart,  -- in bde_fa_kopf.soll_betriebsart%type,
                                                  in_kunden_nr,         -- in bde_fa_auftrag.kunden_nr%type,
                                                  in_kd_art_nr,         -- in bde_fa_auftrag.kd_art_nr%type,
                                                  in_ag_name1,          -- in bde_fa_auftrag.ag_bez1%type,
                                                  in_ag_name2,          -- in bde_fa_auftrag.ag_bez2%type,
                                                 in_ag_text1,          -- in bde_fa_auftrag.ag_text1%type,
                                                  in_ag_text2,          -- in bde_fa_auftrag.ag_text2%type,
                                                  in_ag_text3,          -- in bde_fa_auftrag.ag_text3%type,
                                                  in_kenz_lhm_druck,    -- in bde_fa_auftrag.kenz_lhm_druck%type,
                                                  in_anz_lte,           -- in bde_fa_auftrag.lte_anz%type,
                                                 in_anz_lhm,           -- in bde_fa_auftrag.lhm_anz%type,
                                                  in_bestnr_kd,         -- in bde_fa_auftrag.best_nr_kunde%type,
                                                  in_abnr,              -- in bde_fa_auftrag.abnr%type,
                                                  in_serie_id,          -- in bde_fa_kopf.serie_id%type,
                                                  in_serie_auto_inc,    -- in bde_fa_kopf.serie_auto_inc%type,
                                                 in_fa_gruppe,         -- in bde_fa_kopf.fa_gruppe%type,
                                                  in_dispo_charge_rein, -- in varchar2,      -- T = Chargenrein, H = Herstellerrein, F oder NULL Nur nach FIFO
                                                  in_out_leitzahl);     -- in out bde_fa_auftrag.leitzahl%type)
    end;

    procedure create_bde_fa_auftrag_a_plan (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_artikel_id       in isi_artikel.artikel_id%type,
        in_charge_bez       in lvs_charge.charge_bez%type,
        in_res_id           in isi_resource.res_id%type,
        in_login_id         in isi_user.login_id%type,
        in_menge            in lvs_lam.menge%type,
        in_ab_text1         in bde_fa_auftrag.ab_text1%type,
        in_ab_text2         in bde_fa_auftrag.ab_text2%type,
        in_ab_text3         in bde_fa_auftrag.ab_text3%type,
        in_soll_betriebsart in bde_fa_kopf.soll_betriebsart%type,
        in_kunden_nr        in bde_fa_auftrag.kunden_nr%type,
        in_kd_art_nr        in bde_fa_auftrag.kd_art_nr%type,
        in_ag_name1         in bde_fa_auftrag.ag_bez1%type,
        in_ag_name2         in bde_fa_auftrag.ag_bez2%type,
        in_ag_text1         in bde_fa_auftrag.ag_text1%type,
        in_ag_text2         in bde_fa_auftrag.ag_text2%type,
        in_ag_text3         in bde_fa_auftrag.ag_text3%type,
        in_kenz_lhm_druck   in bde_fa_auftrag.kenz_lhm_druck%type,
        in_anz_lte          in bde_fa_auftrag.lte_anz%type,
        in_anz_lhm          in bde_fa_auftrag.lhm_anz%type,
        in_bestnr_kd        in bde_fa_auftrag.best_nr_kunde%type,
        in_abnr             in bde_fa_auftrag.abnr%type,
        in_serie_id         in bde_fa_kopf.serie_id%type,
        in_serie_auto_inc   in bde_fa_kopf.serie_auto_inc%type,
        in_fa_gruppe        in bde_fa_kopf.fa_gruppe%type,
        in_out_leitzahl     in out bde_fa_auftrag.leitzahl%type
    ) is
    begin
        pps_p_bde.create_bde_fa_auftrag_a_plan(in_sid, in_firma_nr, in_artikel_id, in_charge_bez, in_res_id,
                                               in_login_id, in_menge, in_ab_text1, in_ab_text2, in_soll_betriebsart,
                                               in_ab_text3, in_kunden_nr, in_kd_art_nr, in_ag_name1, in_ag_name2,
                                               in_ag_text1, in_ag_text2, in_ag_text3, in_kenz_lhm_druck, in_anz_lte,
                                               in_anz_lhm, in_bestnr_kd, in_abnr, in_serie_id, in_serie_auto_inc,
                                               in_fa_gruppe, in_out_leitzahl);
    end;

/*
procedure c_create_bde_fa_auftrag_a_pps Ruft die gleichnamige Funktion im PPS_P_BDE
Erzeugt Eintraege in der BDE_FA_AUFTRAG auf der Grundlage der ausgeplanten 
PPS_AUFTRAEGE pps_plan_auftrag.

@author -HJG- Hans Joachim Gödeke

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_plan_auf_id     in pps_plan_auftrag.plan_auf_id  Arbeitsplan ID au der Erstellt werdn soll
@param in_login_id        in isi_user.login_id             Login-ID Ersteller

-- HISTORY
--__________________________________________________
-- Datum       Version     AUTOR    Comment
--27.11.2009   3.4.4.1     (-HJG-)  erstellt

@see pps_p_bde.c_create_bde_fa_auftrag_a_pps
*/
    procedure c_create_bde_fa_auftrag_a_pps (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_plan_auf_id in pps_plan_auftrag.plan_auf_id%type,
        in_login_id    in isi_user.login_id%type
    ) is
        pragma autonomous_transaction;
    begin
        pps_p_bde.c_create_bde_fa_auftrag_a_pps(in_sid, in_firma_nr, in_plan_auf_id, in_login_id);
        commit;
    end;

/*
Die Funktion Liest einen Satz in der pps_ruestmatrix_opt_grp

@author -WK- Wilhelm Kröker
@param in_sid            in bde_fa_kopf.sid
@param in_firma          in isi_firma.firma_nr
@param in_opt_grp        in pps_ruestmatrix_opt_grp.opt_grp Optimierungsgruppe
@param out_opt_grp      out pps_ruestmatrix_opt_grp%rowtype Rückgabe des Datentensatz

@return True=Datensatz gefunden False=Datensatz nicht vorhanden
*/
    function get_pps_ruestmatrix_opt_grp (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_opt_grp  in pps_ruestmatrix_opt_grp.opt_grp%type,
        out_opt_grp out pps_ruestmatrix_opt_grp%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_opt_grp is
        select
            *
        from
            pps_ruestmatrix_opt_grp t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.opt_grp = in_opt_grp;

    begin
        open c_opt_grp;
        fetch c_opt_grp into out_opt_grp;
        v_result := c_opt_grp%found;
        close c_opt_grp;
        return ( v_result );
    end;

end bde_p_pps;
/


-- sqlcl_snapshot {"hash":"10a8e68407ac9e0dd9c1bc322af94c323661bee2","type":"PACKAGE_BODY","name":"BDE_P_PPS","schemaName":"DIRKSPZM32","sxml":""}