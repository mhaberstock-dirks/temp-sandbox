create or replace 
package DIRKSPZM32.bde_funktionen is

/*
  Hier werden Funktionen zur BDE-Auswertung zur Verfügung gestellt. Diese können dann in SQLs und Reports mit besserem Zeitverhalten genutzt werden. Zusätzlich sind in diesm package methoten, zur Erzeugeung manueller BDE-Buchungen wie z.B. Schrotterfassung
  @author -AG- Hans Joachim Gödeke

-- HISTORY
--__________________________________________________
-- Datum       Version     AUTOR    Comment
--11.02.2015   3.5.8.x     (-AG-)   Kommentare in JavaDoc-Style geändert
--27.11.2009   3.5.0.1     (-BW-)   Minor Release
--11.11.2009   3.4.13.1    (-BW-)   Anzeige Freie Plätze anstatt bel. Plätze.
--22.10.2009   3.4.12.1    (-BW-)   Visu Erzeugt
--*            3.4.1.1     (-HJG-)  Einbau BDE-Datenerfassung Manuell
--*            3.3.4.1     (-HJG-)  Einbau neuer Fuktionen c_insert_bde_pd_schrott
--*                                 > Aenerung des Rueckgabewerts beim zaehlen der Prod-Tage
--*                                 > und der Schichten
--*            3.3.4.0: > Einbau der Versionierung

*/


v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';

/*
  Die Funktion gibt die Version des Package zurueck
  @author -AG- Hans Joachim Gödeke
  @return v_version_str
*/
function get_version return varchar2;


/*
  Die Funktion setzt den Auswertugsbegin fuer Views
  @author -AG- Hans Joachim Gödeke
  @param in_ausw_begin für die View, in der dieses Datum als Start benötigt wird
  @return p_ausw_begin
*/
  function set_aus_begin(in_ausw_begin in date) return date;
/*
  Die Funktion setzt den Auswertugsende fuer Views
  @author -AG- Hans Joachim Gödeke
  @param in_ausw_ende für die View, in der dieses Datum als Ende benötigt wird
  @return p_ausw_ende
*/
  function set_aus_ende(in_ausw_ende in date) return date;
/*
  Die Funktion holt den Auswertugsbegin fuer Views
  @author -AG- Hans Joachim Gödeke
  @return p_ausw_begin
*/
  function get_ausw_begin return date;
/*
  Die Funktion holt das Auswertugsende fuer Views
  @author -AG- Hans Joachim Gödeke
  @return p_ausw_ende
*/
  function get_ausw_ende return date;

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;
    p_ausw_begin           date;
    p_ausw_ende            date;

    v_ausw_funk            varchar2(50);
    v_ausw_begin           date;
    v_ausw_ende            date;
    v_ausw_res_id          isi_resource.res_id%type;
    v_ausw_leitzahl        bde_fa_auftrag.leitzahl%type;
    v_ausw_fa_ag           bde_fa_auftrag.fa_ag%type;

    v_anmeld_std           number;
    v_prod_std             number;
    v_ruest_std            number;
    v_unterb_std           number;
    v_up_unterb_std        number;
    -- Störgruppen und HNZ nach VDMA
    v_hnz_std              number;
    v_su_std               number;
    v_sz_tz_lz_std         number;

    v_count_stoer          number;          -- Anzahl der Störungen
    v_count_ustoer         number;          -- Anzahl der ungeplanten Störung
    v_count_ruest          number;          -- Anzahl Rüsten
    v_prod_gut_mg          number;
    v_prod_b_mg            number;
    v_prod_schrott_mg      number;

    v_f_prod_std             number;
    v_f_ruest_std            number;
    v_f_unterb_std           number;
    v_s_prod_std             number;
    v_s_ruest_std            number;
    v_s_unterb_std           number;
    v_n_prod_std             number;
    v_n_ruest_std            number;
    v_n_unterb_std           number;

    v_bde_gut_mg                 number;
    v_bde_b_mg                   number;
    v_bde_schrott_mg             number;

    v_bde_f_gut_mg               number;
    v_bde_f_b_mg                 number;
    v_bde_f_schrott_mg           number;

    v_bde_s_gut_mg               number;
    v_bde_s_b_mg                 number;
    v_bde_s_schrott_mg           number;

    v_bde_n_gut_mg               number;
    v_bde_n_b_mg                 number;
    v_bde_n_schrott_mg           number;

    v_gut_mg                     number;
    v_b_mg                       number;
    v_schrott_mg                 number;
    v_micro_stops                number;

    v_f_gut_mg                   number;
    v_f_b_mg                     number;
    v_f_schrott_mg               number;
    v_f_micro_stops              number;

    v_s_gut_mg                   number;
    v_s_b_mg                     number;
    v_s_schrott_mg               number;
    v_s_micro_stops              number;

    v_n_gut_mg                   number;
    v_n_b_mg                     number;
    v_n_schrott_mg               number;
    v_n_micro_stops              number;

    v_prod_tage                  number;
    v_prod_Schichten             number;

  -- Public function and procedure declarations
-------------------------------------------------------------------------
/*
Die Procedure setzt alle Reservierungen für eien FA-Auftrag zurück
@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid%type,
@param in_firma          in isi_firma.firma_nr%type,
@param in_leitzahl       in bde_fa_auftrag.leitzahl%type Für diesen Fertigungsauftrag werden alle Resevierungen zurückgesetzt
*/
  procedure c_reset_res_lte_fa_auftrag(in_sid            in isi_sid.sid%type,
                                       in_firma          in isi_firma.firma_nr%type,
                                       in_leitzahl       in bde_fa_auftrag.leitzahl%type);

/*
Die Function ermittelt alle Zeiten eines FA_Arbeitsgangs
@deprecated (see bde_funktionen.get_fa_zeiten_upos)
@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_leitzahl       in bde_fa_auftrag.leitzahl Für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_fa_ag          in bde_fa_auftrag.fa_ag Für diesen Arbeitsgang werden alle Zeiten ermittelt
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@return Return sind die Ges. Zeiten
*/
  function get_fa_zeiten(in_sid            in isi_sid.sid%type,
                         in_firma          in isi_firma.firma_nr%type,
                         in_leitzahl       in bde_fa_auftrag.leitzahl%type,
                         in_fa_ag          in bde_fa_auftrag.fa_ag%type,
                         in_res_id         in isi_resource.res_id%type)
                         return number;

/*
Die Function ermittelt alle Zeiten eines FA_Arbeitsgangs-> mit Unterposition (Split)
@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_leitzahl       in bde_fa_auftrag.leitzahl Für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_fa_ag          in bde_fa_auftrag.fa_ag Für diesen Arbeitsgang werden alle Zeiten ermittelt
@param in_fa_upos        in bde_fa_auftrag.in_fa_upos Für diesen Arbeitsgangunterposition (Split) werden alle Zeiten ermittelt
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@return Return sind die Ges. Zeiten
@see bde_funktionen.get_fa_zeit_mg_upos_von_bis Hier ist die Funktionalität implementiert. Die Parameter in_von_datum und in_bis_datum weden mit NULL übergeben
*/
  function get_fa_zeiten_upos(in_sid            in isi_sid.sid%type,
                              in_firma          in isi_firma.firma_nr%type,
                              in_leitzahl       in bde_fa_auftrag.leitzahl%type,
                              in_fa_ag          in bde_fa_auftrag.fa_ag%type,
                              in_fa_upos        in bde_fa_auftrag.fa_upos%type,
                              in_res_id         in isi_resource.res_id%type)
                         return number;
/*
Die Function ermittelt alle Zeiten eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun

@see * Die Funktion greift auf die Tabelle bde_pd_kopf, bde_pd_prod, isi_res_status
@see ** Wenn die Parameter unglücklich gesetzt werden, kann es zu einem Langläufer werden

@see * Gestezt werden folgende Werte
@see ** v_prod_std := 0; Return über Funktion get_prod_std
@see ** v_ruest_std := 0; Return über Funktion get_ruest_std
@see ** v_unterb_std := 0; Return über Funktion get_unterbr_std
@see ** v_up_unterb_std := 0; Return über Funktion get_up_unterbr_std
@see ** v_anmeld_std := 0; Return über Funktion diser Funktion
@see ** v_count_ruest := 0; Return über Funktion get_ruest_count
@see ** v_count_stoer := 0; Return über Funktion get_unterbr_count
@see ** v_count_ustoer := 0; Return über Funktion get_up_unterbr_count
@see ** v_prod_gut_mg := 0; Return über Funktion get_prod_mg_a
@see ** v_prod_b_mg := 0; Return über Funktion get_prod_mg_b
@see ** v_prod_schrott_mg := 0; Return über Funktion get_prod_mg_s

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_leitzahl       in bde_fa_auftrag.leitzahl Für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_fa_ag          in bde_fa_auftrag.fa_ag Für diesen Arbeitsgang werden alle Zeiten ermittelt
@param in_fa_upos        in bde_fa_auftrag.in_fa_upos Für diesen Arbeitsgangunterposition (Split) werden alle Zeiten ermittelt
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_von_datum      in date Wenn NULL dan keine Einschränkung
@param in_bis_datum      in date Wenn NULL dan keine Einschränkung
@return Return sind die Ges. Zeiten
*/
    function get_fa_zeit_mg_upos_von_bis(in_sid            in isi_sid.sid%type,
                                         in_firma          in isi_firma.firma_nr%type,
                                         in_leitzahl       in bde_fa_auftrag.leitzahl%type,
                                         in_fa_ag          in bde_fa_auftrag.fa_ag%type,
                                         in_fa_upos        in bde_fa_auftrag.fa_upos%type,
                                         in_res_id         in isi_resource.res_id%type,
                                         in_von_datum      in date,
                                         in_bis_datum      in date)
                                         return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_ruest_std return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_prod_std return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_unterbr_std return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_up_unterbr_std return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_unterbr_count return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_up_unterbr_count return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_ruest_count return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_prod_mg_a return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_prod_mg_b return number;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
  function get_prod_mg_s return number;

  -- BDE ----------------------------------------------------------------------------
/*
Die Function ermittelt alle BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück

@see * Die Funktion greift auf die Tabelle bde_pd_prod

@see * Gestezt werden folgende Werte
@see ** v_bde_gut_mg := 0; Return über diese Funktion get_bde_gut_mengen
@see ** v_bde_b_mg := 0; Return über Funktion get_bde_b_mengen
@see ** v_bde_schrott_mg := 0;  Return über Funktion get_bde_schrott_mengen
@see ** v_bde_f_gut_mg := 0; Return über Funktion get_bde_f_gut_mengen Frühschicht
@see ** v_bde_f_b_mg := 0; Return über Funktion get_bde_f_b_mengen Frühschicht
@see ** v_bde_f_schrott_mg := 0; Return über Funktion get_bde_f_schrott_mengen Frühschicht
@see ** v_bde_s_gut_mg := 0; Return über Funktion get_bde_s_gut_mengen Spätschicht
@see ** v_bde_s_b_mg := 0; Return über Funktion get_bde_s_b_mengen Spätschicht
@see ** v_bde_s_schrott_mg := 0; Return über Funktion get_bde_s_schrott_mengen Spätschicht
@see ** v_bde_n_gut_mg := 0; Return über Funktion get_bde_n_gut_mengen Nachtschicht
@see ** v_bde_n_b_mg := 0; Return über Funktion get_bde_n_b_mengen Nachtschicht
@see ** v_bde_n_schrott_mg := 0; Return über Funktion get_bde_n_schrott_mengen Nachtschicht

@author -AG- Hans Joachim Gödeke
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_leitzahl       in bde_fa_auftrag.leitzahl Null dann alle FAs im Zeitraum sonst für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_von_datum      in bde_pd_prod.prod_ende Die Menge muss in diesem Zeitraum fertig geworden sein
@param in_bis_datum      in bde_pd_prod.prod_ende Die Menge muss in diesem Zeitraum fertig geworden sein
@return v_bde_gut_mg     Gutmenge im Zeitraum
*/
  function get_bde_gut_mengen (in_res_id                 in bde_pd_prod.res_id%type,
                               in_leitzahl               in bde_pd_prod.leitzahl%type,
                               in_von_datum              in bde_pd_prod.prod_ende%type,
                               in_bis_datum              in bde_pd_prod.prod_ende%type)
                               return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_b_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_schrott_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_f_gut_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_f_b_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_f_schrott_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_s_gut_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_s_b_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_s_schrott_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_n_gut_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_n_b_mengen return number;

/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
  function get_bde_n_schrott_mengen return number;

  -- MDE ----------------------------------------------------------------------------
/*
Die Function ermittelt alle MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück

@see * Die Funktion greift auf die Tabelle mde_cfg und mde_statistik

@see * Gestezt werden folgende Werte
@see ** v_bde_gut_mg := 0; Return über diese Funktion get_bde_gut_mengen

@see ** v_gut_mg := 0; Return über diese Funktion get_mde_gut_mengen
@see ** v_b_mg := 0; Return über Funktion get_mde_b_mengen
@see ** v_schrott_mg := 0;  Return über Funktion get_mde_schrott_mengen
@see ** v_f_gut_mg := 0; Return über Funktion get_mde_f_gut_mengen Frühschicht
@see ** v_f_b_mg := 0; Return über Funktion get_mde_f_b_mengen Frühschicht
@see ** v_f_schrott_mg := 0; Return über Funktion get_mde_f_schrott_mengen Frühschicht
@see ** v_s_gut_mg := 0; Return über Funktion get_mde_s_gut_mengen Spätschicht
@see ** v_s_b_mg := 0; Return über Funktion get_mde_s_b_mengen Spätschicht
@see ** v_s_schrott_mg := 0; Return über Funktion get_mde_s_schrott_mengen Spätschicht
@see ** v_n_gut_mg := 0; Return über Funktion get_mde_n_gut_mengen Nachtschicht
@see ** v_n_b_mg := 0; Return über Funktion get_mde_n_b_mengen Nachtschicht
@see ** v_n_schrott_mg := 0; Return über Funktion get_mde_n_schrott_mengen Nachtschicht

@author -AG- Hans Joachim Gödeke
@param in_res_id         in mde_cfg.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_leitzahl       in mde_statistik.leitzahl Null dann alle FAs im Zeitraum sonst für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_von_datum      in mde_statistik.datum Die Menge muss in diesem Zeitraum fertig geworden sein
@param in_bis_datum      in mde_statistik.datum Die Menge muss in diesem Zeitraum fertig geworden sein
@return v_mde_gut_mg     Gutmenge im Zeitraum
*/
  function get_mde_gut_mengen (in_res_id                 in mde_cfg.res_id%type,
                               in_name                   in mde_statistik.name%type,
                               in_leitzahl               in mde_statistik.leitzahl%type,
                               in_von_datum              in mde_statistik.datum%type,
                               in_bis_datum              in mde_statistik.datum%type)
                               return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_b_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_schrott_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_micro_stop return number;

/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_f_gut_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_f_b_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_f_schrott_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_f_micro_stop return number;

/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_s_gut_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_s_b_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_s_schrott_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_s_micro_stop return number;

/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_n_gut_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_n_b_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_n_schrott_mengen return number;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
  function get_mde_n_micro_stop return number;

/*
Die Function ermittelt alle Zeiten einer Resource (Maschine) in einem Zeitraun

@see * Es werden zusätzlich werte für die Ermittlung von Kennzahlen gebildet
@see ** hnz Hauptnutzungszeit (HNZ) {th} -> Die Hauptnutzungszeit ist die Zeit, in der die Maschine produziert. Sie beinhaltet nur die wertschöpfenden Prozesse.
@see ** sz_tz_lz Liegezeit (LZ) Stillstandszeit (SZ) Transportzeit (TZ)
@see ** su Störungsbedingte Unterbrechungen (SU) {TBS, TMS} -> Die störungsgedingten Unterbrechungen sind Zeiten, die während der Auftragsbearbeitung ungeplant auftreten und dadurch ungewollt die Belegungszeiten verlängern.

@see * Die Funktion greift auf die Tabelle bde_pd_kopf, isi_res_status, isi_res_status_cfg
@see ** Wenn die Parameter unglücklich gesetzt werden, kann es zu einem Langläufer werden

@see * Gestezt werden folgende Werte
@see ** v_prod_std := 0; Return über Funktion get_res_prod_std
@see ** v_ruest_std := 0; Return über Funktion get_res_ruest_std
@see ** v_unterb_std := 0; Return über Funktion get_res_unterbr_std
@see ** v_up_unterb_std := 0; Return über Funktion get_res_up_unterbr_std
@see ** v_hnz_std := 0; Return über Funktion get_res_hnz_std
@see ** v_sz_tz_lz_std := 0; Return über Funktion get_res_sz_tz_lz_std
@see ** v_su_std := 0; Return über Funktion get_res_su_std
@see ** v_f_gut_mg := 0; Return über Funktion get_res_f_gut_mengen Frühschicht
@see ** v_f_b_mg := 0; Return über Funktion get_res_f_b_mengen Frühschicht
@see ** v_f_schrott_mg := 0; Return über Funktion get_res_f_schrott_mengen Frühschicht
@see ** v_s_gut_mg := 0; Return über Funktion get_res_s_gut_mengen Spätschicht
@see ** v_s_b_mg := 0; Return über Funktion get_res_s_b_mengen Spätschicht
@see ** v_s_schrott_mg := 0; Return über Funktion get_res_s_schrott_mengen Spätschicht
@see ** v_n_gut_mg := 0; Return über Funktion get_res_n_gut_mengen Nachtschicht
@see ** v_n_b_mg := 0; Return über Funktion get_res_n_b_mengen Nachtschicht
@see ** v_n_schrott_mg := 0; Return über Funktion get_res_n_schrott_mengen Nachtschicht

@author -AG- Hans Joachim Gödeke
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_ausw_begin     in isi_res_status.st_start Start der Auswerung
@param in_ausw_ende      in isi_res_status.st_ende Ende der Auswertung
@return Return sind die Ges. Zeiten
*/
  function get_res_prod_std(in_res_id         in isi_resource.res_id%type,
                            in_ausw_begin     in isi_res_status.st_start%type,
                            in_ausw_ende      in isi_res_status.st_ende%type)
                            return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_ruest_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_unterbr_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_up_unterbr_std return number;

/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_hnz_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_su_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_sz_tz_lz_std return number;

/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_f_prod_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_f_ruest_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_f_unterbr_std return number;

/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_s_prod_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_s_ruest_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_s_unterbr_std return number;

/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_n_prod_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_n_ruest_std return number;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
  function get_res_n_unterbr_std return number;

/*
Die Function ermittelt alle Auftragswechsel einer Resource (Maschine) in einem Zeitraun

@see * Die Funktion greift auf die Tabelle bde_pd_prod
@see ** Wenn die Parameter unglücklich gesetzt werden, kann es zu einem Langläufer werden

@author -AG- Hans Joachim Gödeke
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_ausw_begin     in isi_res_status.st_start Start der Auswerung
@param in_ausw_ende      in isi_res_status.st_ende Ende der Auswertung
@return Return ist die Anzahl der Auftragswechsel
*/
  function get_res_auf_wechsel(in_res_id         in isi_resource.res_id%type,
                               in_ausw_begin     in isi_res_status.st_start%type,
                               in_ausw_ende      in isi_res_status.st_ende%type)
                               return number;

/*
Die Function ermittelt die Produktionstage einer Resource (Maschine) in einem Zeitraun

@see * Die Funktion greift auf die Tabelle bde_pd_kopf

@author -AG- Hans Joachim Gödeke
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_ausw_begin     in isi_res_status.st_start Start der Auswerung
@param in_ausw_ende      in isi_res_status.st_ende Ende der Auswertung
@return v_prod_tage Return ist die Anzahl der Produktionstage
*/
  function get_res_prod_tage(in_res_id         in isi_resource.res_id%type,
                             in_ausw_begin     in isi_res_status.st_start%type,
                             in_ausw_ende      in isi_res_status.st_ende%type)
                             return number;

/*
Die Function ermittelt dir Produktionsschichten einer Resource (Maschine) in einem Zeitraun

@see * Die Funktion greift auf die Tabelle bde_pd_kopf

@author -AG- Hans Joachim Gödeke
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_ausw_begin     in isi_res_status.st_start Start der Auswerung
@param in_ausw_ende      in isi_res_status.st_ende Ende der Auswertung
@return v_prod_Schichten Return ist die Anzahl der Produktionsschichten
*/
  function get_res_prod_Schichten(in_res_id         in isi_resource.res_id%type,
                                  in_ausw_begin     in isi_res_status.st_start%type,
                                  in_ausw_ende      in isi_res_status.st_ende%type)
                                  return number;
/*
  Die Funktion ermittelt die Stunden in der ein Mitarbeiter an der Maschine angemeldet war
  @author -AG- Hans Joachim Gödeke
  @param in_sid          in  isi_sid.sid%type
  @param in_firma_nr     in  isi_firma.firma_nr%type
  @param in_begin        in  bde_pd_kopf.pd_kopf_beginn%type
  @param in_ende         in  bde_pd_kopf.pd_kopf_ende%type
  @param in_res_id       in  isi_resource.res_id%type
  @Return v_anm_std
*/
  function get_anmelde_std(in_sid          in  isi_sid.sid%type,
                           in_firma_nr     in  isi_firma.firma_nr%type,
                           in_begin        in  bde_pd_kopf.pd_kopf_beginn%type,
                           in_ende         in  bde_pd_kopf.pd_kopf_ende%type,
                           in_res_id       in  isi_resource.res_id%type)
                           return number;

/*
Die Procedure passt die gebuchten Mengen in der BDE_FA_AUFTRAG, der bde_pd_prod und der lvs_lam_bh
nach der Änderung der LHM_MENGE im FA-Auftrag an die neue Menge an.
Dafür muss der FA an der Maschine angemeldet sein. Es werden nur die Buchungen der aktuellen Anmeldung bearbeitet.

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_leitzahl       in bde_fa_auftrag.leitzahl Für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_fa_ag          in bde_fa_auftrag.fa_ag Für diesen Arbeitsgang werden alle Zeiten ermittelt
@param in_fa_upos        in bde_fa_auftrag.in_fa_upos Für diesen Arbeitsgangunterposition (Split) werden alle Zeiten ermittelt
@param in_menge          in bde_fa_auftrag.lhm_menge Neue Zugangsmenge je LHM die jetzt in den aktuellen Buchungen korrigiert werden soll
*/
  procedure c_set_zug_menge_lhm_fa(in_sid          in  isi_sid.sid%type,
                                   in_firma_nr     in  isi_firma.firma_nr%type,
                                   in_leitzahl     in  bde_fa_auftrag.leitzahl%type,
                                   in_fa_ag        in  bde_fa_auftrag.fa_ag%type,
                                   in_fa_upos      in  bde_fa_auftrag.fa_upos%type,
                                   in_menge        in  bde_fa_auftrag.lhm_menge%type);

/*
Die Procedure erzeugt eine Schrottsatz für einen FA an einer Maschine in einer Schicht an, zur manuellen Erfassung von Schrottmengen

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_res_id         in  isi_resource.res_id RES_ID der Maschine auf der Gebucht werden soll
@param in_pd_beginn      in  bde_pd_prod.prod_beginn Datum und Uhrzeit der Buchung. Der Datensatz wird dann mit diesm Datum als Start- und Endedatum gebucht
@param in_login_id       in  isi_user.login_id Login_ID des angemeldeten USER
@param in_leitzahl       in bde_fa_auftrag.leitzahl Für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_fa_ag          in bde_fa_auftrag.fa_ag Für diesen Arbeitsgang werden alle Zeiten ermittelt
@param in_fa_upos        in bde_fa_auftrag.in_fa_upos Für diesen Arbeitsgangunterposition (Split) werden alle Zeiten ermittelt
@param in_menge          in bde_fa_auftrag.lhm_menge Neue Zugangsmenge je LHM die jetzt in den aktuellen Buchungen korrigiert werden soll
*/
  procedure c_insert_bde_pd_schrott(in_sid          in  isi_sid.sid%type,
                                    in_firma_nr     in  isi_firma.firma_nr%type,
                                    in_res_id       in  isi_resource.res_id%type,
                                    in_pd_beginn    in  bde_pd_prod.prod_beginn%type,
                                    in_login_id     in  isi_user.login_id%type,
                                    in_leitzahl     in  bde_fa_auftrag.leitzahl%type,
                                    in_fa_ag        in  bde_fa_auftrag.fa_ag%type,
                                    in_fa_upos      in  bde_fa_auftrag.fa_upos%type,
                                    in_menge        in  bde_fa_auftrag.lhm_menge%type);

/*
Ändert die Menge im Lagerbestand und korrigiert die Mengen im FA und der Produktionsauftragsmenge

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_login_id       in  isi_user.login_id Login_ID des angemeldeten USER
@param in_leitzahl       in bde_fa_auftrag.leitzahl Für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_fa_ag          in bde_fa_auftrag.fa_ag Für diesen Arbeitsgang werden alle Zeiten ermittelt
@param in_fa_upos        in bde_fa_auftrag.in_fa_upos Für diesen Arbeitsgangunterposition (Split) werden alle Zeiten ermittelt
@param in_lam_id         in lvs_lam.lam_id LAM_ID für die zu korrgierenden Menge (Kartonmenge im LHM)
@param in_menge          in bde_fa_auftrag.lhm_menge Neue Zugangsmenge je LHM die jetzt in den aktuellen Buchungen korrigiert werden soll
@param in_old_menge      in bde_fa_auftrag.ag_ist_mg Menge, die zuvor im Behälter war
@param in_buch_dat       in date
*/
  procedure c_change_zug_menge_lhm_fa(in_sid          in  isi_sid.sid%type,
                                      in_firma_nr     in  isi_firma.firma_nr%type,
                                      in_leitzahl     in  bde_fa_auftrag.leitzahl%type,
                                      in_fa_ag        in  bde_fa_auftrag.fa_ag%type,
                                      in_fa_upos      in  bde_fa_auftrag.fa_upos%type,
                                      in_lam_id       in  lvs_lam.lam_id%type,
                                      in_menge        in  bde_fa_auftrag.lhm_menge%type,
                                      in_old_menge    in  bde_fa_auftrag.ag_ist_mg%type,
                                      in_buch_dat     in  date);

/*
Ändert die Menge Schrott im FA und der Produktionsauftragsmenge (Satzart PA Auftragsanmeldung in BDE_PD_PROD)

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_leitzahl       in bde_fa_auftrag.leitzahl Für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_fa_ag          in bde_fa_auftrag.fa_ag Für diesen Arbeitsgang werden alle Zeiten ermittelt
@param in_fa_upos        in bde_fa_auftrag.in_fa_upos Für diesen Arbeitsgangunterposition (Split) werden alle Zeiten ermittelt
@param in_menge          in bde_fa_auftrag.lhm_menge Neue Zugangsmenge je LHM die jetzt in den aktuellen Buchungen korrigiert werden soll
@param in_old_menge      in bde_fa_auftrag.ag_ist_mg Menge, die zuvor im Behälter war
@param in_buch_dat       in date
*/
  procedure c_change_schrott_menge(in_sid          in  isi_sid.sid%type,
                                   in_firma_nr     in  isi_firma.firma_nr%type,
                                   in_leitzahl     in  bde_fa_auftrag.leitzahl%type,
                                   in_fa_ag        in  bde_fa_auftrag.fa_ag%type,
                                   in_fa_upos      in  bde_fa_auftrag.fa_upos%type,
                                   in_menge        in  bde_fa_auftrag.lhm_menge%type,
                                   in_old_menge    in  bde_fa_auftrag.ag_ist_mg%type,
                                   in_buch_dat     in  date);

/*
Erstellt einen Eintrag (Produktionsmeldung) für die manuelle Erfassung
Hierbei werden niemals Lagermengen Gebucht. Dient nur der Mengenerfassung im BDE

@see bde_c_barcode_buch Buchen einer Produktionsmenge (1 LHM) für einen angemeldeten FA auf einer Maschine auf die dort aktuell gebuchte Palette (LTE)
@see bde_pd_prod_insert In dieser Procedure werden die Produktionsdaten geschrieben. Bei Fertigware müssen Alle Rohstoffe an die Maschine gebucht sein. Damit werden alle Rohstoffbezieungen für Fertigware automatisch gebucht.

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_res_id         in isi_resource.res_id RES_ID der Maschine auf der Gebucht werden soll
@param in_leitzahl       in bde_fa_auftrag.leitzahl Für diesen Fertigungsauftrag werden alle Zeiten ermittelt
@param in_fa_ag          in bde_fa_auftrag.fa_ag Für diesen Arbeitsgang werden alle Zeiten ermittelt
@param in_fa_upos        in bde_fa_auftrag.in_fa_upos Für diesen Arbeitsgangunterposition (Split) werden alle Zeiten ermittelt
@param in_artikel_id     in isi_artikel.artikel_id Artikel_ID für die Buchung
@param in_pd_beginn      in bde_pd_prod.prod_beginn Produktionsbegin für die Menge
@param in_pd_ende        in bde_pd_prod.prod_ende Produktiondende für die Menge (Buchdatum)
@param in_menge          in bde_fa_auftrag.lhm_menge Neue Zugangsmenge je LHM die jetzt in den aktuellen Buchungen korrigiert werden soll
@param in_menge_b        in bde_pd_prod.menge_b Menge 2te Wahl
@param in_schrott        in bde_pd_prod.schrott Schrottmenge
@param in_login_id       in isi_user.login_id Login_ID des angemeldeten USER
*/
  procedure c_insert_bde_prod(in_sid          in  isi_sid.sid%type,
                              in_firma_nr     in  isi_firma.firma_nr%type,
                              in_res_id         in isi_resource.res_id%type,
                              in_leitzahl     in  bde_fa_auftrag.leitzahl%type,
                              in_fa_ag        in  bde_fa_auftrag.fa_ag%type,
                              in_fa_upos      in  bde_fa_auftrag.fa_upos%type,
                              in_artikel_id   in  isi_artikel.artikel_id%type,
                              in_pd_beginn    in  bde_pd_prod.prod_beginn%type,
                              in_pd_ende      in  bde_pd_prod.prod_ende%type,
                              in_menge        in  bde_pd_prod.menge_a%type,
                              in_menge_b      in  bde_pd_prod.menge_b%type,
                              in_schrott      in  bde_pd_prod.schrott%type,
                              in_login_id     in  isi_user.login_id%type);

/*
Ermittelt die Mitarbeiterstunden an einer Resource für einen Zeitraum

@author -DTs- Dionysios Tsekas
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_res_id         in isi_resource.res_id RES_ID der Maschine auf der Gebucht werden soll
@param in_aufgabe_seit   in isi_resource_zust_akt.akt_aufgabe_seit Auswertung von
@param in_res_id         in date Ende des Auswertungszeitraum
*/
  function get_ma_erf_zeiten (in_sid           in  isi_sid.sid%type,
                              in_firma_nr      in  isi_firma.firma_nr%type,
                              in_res_id        in  isi_resource.res_id%type,
                              in_aufgabe_seit  in  isi_resource_zust_akt.akt_aufgabe_seit%type,
                              in_aufgabe_bis   in  date)
                              return number;

end bde_funktionen;
/



-- sqlcl_snapshot {"hash":"c7e07ed97420644d1409c1871021e0859a03ffd1","type":"PACKAGE_SPEC","name":"BDE_FUNKTIONEN","schemaName":"DIRKSPZM32","sxml":""}