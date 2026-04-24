create or replace package body dirkspzm32.bde_funktionen is

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


  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Standard Fehler Felder für Exception
    v_error exception;
  -- Standard Fehler Felder für Exception Nummer
    v_err_nr   number;
  -- Standard Fehler Felder für Exception Text
    v_err_text varchar2(255);

  -- Function and procedure implementations

/*
  Die Funktion gibt die Version des Package zurueck
  @author -AG- Hans Joachim Gödeke
  @return v_version_str
*/
    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end get_version;

/*
  Die Funktion setzt den Auswertugsbegin fuer Views
  @author -AG- Hans Joachim Gödeke
  @param in_ausw_begin für die View, in der dieses Datum als Start benötigt wird
  @return p_ausw_begin
*/
    function set_aus_begin (
        in_ausw_begin in date
    ) return date is
    begin
        p_ausw_begin := in_ausw_begin;
        return ( p_ausw_begin );
    end;
/*
  Die Funktion setzt den Auswertugsende fuer Views
  @author -AG- Hans Joachim Gödeke
  @param in_ausw_ende für die View, in der dieses Datum als Ende benötigt wird
  @return p_ausw_ende
*/
    function set_aus_ende (
        in_ausw_ende in date
    ) return date is
    begin
        p_ausw_ende := in_ausw_ende;
        return ( p_ausw_ende );
    end;
/*
  Die Funktion holt den Auswertugsbegin fuer Views
  @author -AG- Hans Joachim Gödeke
  @return p_ausw_begin
*/
    function get_ausw_begin return date is
    begin
        return ( p_ausw_begin );
    end;
/*
  Die Funktion holt das Auswertugsende fuer Views
  @author -AG- Hans Joachim Gödeke
  @return p_ausw_ende
*/
    function get_ausw_ende return date is
    begin
        return ( p_ausw_ende );
    end;
-------------------------------------------------------------------------
/*
Die Procedure setzt alle Reservierungen für eien FA-Auftrag zurück
@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid%type,
@param in_firma          in isi_firma.firma_nr%type,
@param in_leitzahl       in bde_fa_auftrag.leitzahl%type Für diesen Fertigungsauftrag werden alle Resevierungen zurückgesetzt
*/
    procedure c_reset_res_lte_fa_auftrag (
        in_sid      in isi_sid.sid%type,
        in_firma    in isi_firma.firma_nr%type,
        in_leitzahl in bde_fa_auftrag.leitzahl%type
    ) is
-------------------------------------------------------------------------------------------------------

    begin
    -- Wenn keine Leitzahl übergeben wurde, dann ist nichts zu tun
        if in_leitzahl is null then
            return;
        end if;
    -- Fehlernummer setzen, falls in dem Update ein Fehler passiert
    /*
    v_err_nr := 1;
    v_err_text := 'Reservierung für FA-Auftrag: <' || to_char(in_leitzahl) || '> konnte nicht zurückgesetzt werden';
    UPDATE lvs_lte lte
       set lte.order_vorgang_id = NULL
     where lte.sid = in_sid
       and lte.firma_nr = in_firma
       and lte.order_vorgang_id = in_leitzahl
       and lte.order_auf_id is NULL;
    Commit;
    */

    -- Neue Variante der BDE Reservierung
        pps_p_bde.storno_bde_fa_dispo(in_sid, in_firma, in_leitzahl, null, null,
                                      -1);
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;
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
    function get_fa_zeiten (
        in_sid      in isi_sid.sid%type,
        in_firma    in isi_firma.firma_nr%type,
        in_leitzahl in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_res_id   in isi_resource.res_id%type
    ) return number is
    begin
        return ( bde_funktionen.get_fa_zeiten_upos(in_sid,        --                   in isi_sid.sid%type,
         in_firma,      --                   in isi_firma.firma_nr%type,
         in_leitzahl,   --                   in bde_fa_auftrag.leitzahl%type,
         in_fa_ag,      --                   in bde_fa_auftrag.fa_ag%type,
         null,          -- in_fa_upos        in bde_fa_auftrag.fa_upos%type,
                                                   in_res_id) );   --                   in isi_resource.res_id%type)
    end;
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
    function get_fa_zeiten_upos (
        in_sid      in isi_sid.sid%type,
        in_firma    in isi_firma.firma_nr%type,
        in_leitzahl in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_fa_upos  in bde_fa_auftrag.fa_upos%type,
        in_res_id   in isi_resource.res_id%type
    ) return number is
    begin
        return ( bde_funktionen.get_fa_zeit_mg_upos_von_bis(in_sid,        --                   in isi_sid.sid%type,
         in_firma,      --                   in isi_firma.firma_nr%type,
         in_leitzahl,   --                   in bde_fa_auftrag.leitzahl%type,
         in_fa_ag,      --                   in bde_fa_auftrag.fa_ag%type,
         in_fa_upos,    -- in_fa_upos        in bde_fa_auftrag.fa_upos%type,
                                                            in_res_id,     --                   in isi_resource.res_id%type)
                                                             null,          --                   in_von_datum
                                                             null) );        --                   in_bis_datum
    end;
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
    function get_fa_zeit_mg_upos_von_bis (
        in_sid       in isi_sid.sid%type,
        in_firma     in isi_firma.firma_nr%type,
        in_leitzahl  in bde_fa_auftrag.leitzahl%type,
        in_fa_ag     in bde_fa_auftrag.fa_ag%type,
        in_fa_upos   in bde_fa_auftrag.fa_upos%type,
        in_res_id    in isi_resource.res_id%type,
        in_von_datum in date,
        in_bis_datum in date
    ) return number is

        v_prod_daten     bde_pd_prod%rowtype;
        v_prod_kopf      bde_pd_kopf%rowtype;
        v_res_status     isi_res_status%rowtype;
        v_res_status_cfg isi_res_status_cfg%rowtype;
        v_found          boolean;
        cursor c_prod_daten is
        select
            pd_fa.*
        from
            bde_pd_prod pd_fa
        where
                pd_fa.leitzahl = in_leitzahl
            and pd_fa.fa_ag = in_fa_ag
            and pd_fa.fa_upos = nvl(in_fa_upos, pd_fa.fa_upos)
            and ( pd_fa.vorg_typ = 'PA'
                  or pd_fa.vorg_typ = 'RA' )
            and pd_fa.res_id = nvl(in_res_id, pd_fa.res_id)
            and pd_fa.prod_beginn >= nvl(in_von_datum, pd_fa.prod_beginn)
            and pd_fa.prod_ende <= nvl(in_bis_datum, pd_fa.prod_ende);

        cursor c_kopf_daten is
        select
            pk.*
        from
            bde_pd_kopf pk
        where
                pk.res_id = v_prod_daten.res_id
            and nvl(pk.pd_kopf_ende, sysdate) > v_prod_daten.prod_beginn
        order by
            pk.pd_kopf_beginn;

        cursor c_res_status is
        select
            rs.*
        from
            isi_res_status rs
        where
                rs.res_id = v_prod_daten.res_id
            and nvl(rs.st_ende, sysdate) > v_prod_kopf.pd_kopf_beginn
        order by
            rs.st_start;

        cursor c_res_status_cfg is
        select
            rsc.*
        from
            isi_res_status_cfg rsc
        where
                rsc.sid = in_sid
            and rsc.firma_nr = in_firma
            and rsc.res_st_id = v_res_status.res_st_id;

    begin
        if
            v_ausw_funk = 'get_fa_zeiten'
            and nvl(v_ausw_res_id, -1) = nvl(in_res_id, -1)
            and v_ausw_leitzahl = in_leitzahl
            and v_ausw_fa_ag = in_fa_ag
        then
            return ( v_anmeld_std );
        end if;

        v_ausw_funk := 'get_fa_zeiten';
        v_ausw_res_id := in_res_id;
        v_ausw_leitzahl := in_leitzahl;
        v_ausw_fa_ag := in_fa_ag;
        v_prod_std := 0;
        v_ruest_std := 0;
        v_unterb_std := 0;
        v_up_unterb_std := 0;
        v_anmeld_std := 0;
        v_count_ruest := 0;
        v_count_stoer := 0;
        v_count_ustoer := 0;
        v_prod_gut_mg := 0;
        v_prod_b_mg := 0;
        v_prod_schrott_mg := 0;
        open c_prod_daten;
        loop
            fetch c_prod_daten into v_prod_daten;
            v_found := c_prod_daten%found;
            if not v_found then
                exit;
            else
                v_prod_gut_mg := v_prod_gut_mg + v_prod_daten.menge_a;
                v_prod_b_mg := v_prod_b_mg + v_prod_daten.menge_b;
                v_prod_schrott_mg := v_prod_schrott_mg + v_prod_daten.schrott;
                open c_kopf_daten;
                loop
                    fetch c_kopf_daten into v_prod_kopf;
                    v_found := c_kopf_daten%found;
                    if not v_found then
                        exit;
                    else
                        if v_prod_kopf.pd_kopf_beginn > v_prod_daten.prod_ende then
                            exit;
                        else
                            if nvl(v_prod_kopf.pd_kopf_ende, sysdate) > v_prod_daten.prod_ende then
                                v_prod_kopf.pd_kopf_ende := v_prod_daten.prod_ende;
                            end if;

                            if v_prod_kopf.pd_kopf_beginn < v_prod_daten.prod_beginn then
                                v_prod_kopf.pd_kopf_beginn := v_prod_daten.prod_beginn;
                            end if;

                            v_anmeld_std := v_anmeld_std + ( nvl(v_prod_kopf.pd_kopf_ende, sysdate) - v_prod_kopf.pd_kopf_beginn ) * 24
                            ;

                            open c_res_status;
                            loop
                                fetch c_res_status into v_res_status;
                                v_found := c_res_status%found;
                                if not v_found then
                                    exit;
                                else
                                    if v_res_status.st_start > nvl(v_prod_kopf.pd_kopf_ende, sysdate) then
                                        exit;
                                    else
                                        if nvl(v_res_status.st_ende, sysdate) > nvl(v_prod_kopf.pd_kopf_ende, sysdate) then
                                            v_res_status.st_ende := nvl(v_prod_kopf.pd_kopf_ende, sysdate);
                                        end if;

                                        if v_res_status.st_start < v_prod_kopf.pd_kopf_beginn then
                                            v_res_status.st_start := v_prod_kopf.pd_kopf_beginn;
                                        end if;

                                        open c_res_status_cfg;
                                        fetch c_res_status_cfg into v_res_status_cfg;
                                        close c_res_status_cfg;
                                        if v_res_status_cfg.res_st_id != 0 then
                                            if v_res_status_cfg.st_gruppe = 'R' -- Rüsten
                                             then
                                                v_count_ruest := v_count_ruest + 1;
                                                v_ruest_std := v_ruest_std + ( nvl(v_res_status.st_ende, sysdate) - v_res_status.st_start
                                                ) * 24;

                                            else
                                                v_count_stoer := v_count_stoer + 1;
                                                v_unterb_std := v_unterb_std + ( nvl(v_res_status.st_ende, sysdate) - v_res_status.st_start
                                                ) * 24;

                                                if v_res_status_cfg.st_gruppe = 'E' -- E-Störung ungeplant
                                                or v_res_status_cfg.st_gruppe = 'M' -- E-Störung ungeplant
                                                 then
                                                    v_count_ustoer := v_count_ustoer + 1;
                                                    v_up_unterb_std := v_up_unterb_std + ( v_res_status.st_ende - v_res_status.st_start
                                                    ) * 24;
                                                end if;

                                            end if;
                                        else
                                            v_prod_std := v_prod_std + ( nvl(v_res_status.st_ende, sysdate) - v_res_status.st_start ) * 24
                                            ;
                                        end if;

                                    end if;
                                end if;

                            end loop;

                            close c_res_status;
                        end if;
                    end if;

                end loop;

                close c_kopf_daten;
            end if;

        end loop;

        close c_prod_daten;
        return ( v_anmeld_std );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_ruest_std return number is
    begin
        return ( v_ruest_std );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_prod_std return number is
    begin
        return ( v_prod_std );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_unterbr_std return number is
    begin
        return ( v_unterb_std );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_up_unterbr_std return number is
    begin
        return ( v_up_unterb_std );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_unterbr_count return number is
    begin
        return ( v_count_stoer );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_up_unterbr_count return number is
    begin
        return ( v_count_ustoer );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_ruest_count return number is
    begin
        return ( v_count_ruest );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_prod_mg_a return number is
    begin
        return ( v_prod_gut_mg );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_prod_mg_b return number is
    begin
        return ( v_prod_b_mg );
    end;
/*
Die Function gibt die Werte eines FA_Arbeitsgangs-> mit Unterposition (Split) in einem Zeitraun zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_fa_zeit_mg_upos_von_bis
*/
    function get_prod_mg_s return number is
    begin
        return ( v_prod_schrott_mg );
    end;
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
    function get_bde_gut_mengen (
        in_res_id    in bde_pd_prod.res_id%type,
        in_leitzahl  in bde_pd_prod.leitzahl%type,
        in_von_datum in bde_pd_prod.prod_ende%type,
        in_bis_datum in bde_pd_prod.prod_ende%type
    ) return number is

        v_bde_prod bde_pd_prod%rowtype;
        cursor c_bde_prod is
        select
            *
        from
            bde_pd_prod p
        where
                p.res_id = in_res_id
            and p.vorg_typ = 'PP'
            and p.leitzahl = nvl(in_leitzahl, p.leitzahl)
            and p.prod_ende >= in_von_datum
            and p.prod_ende < in_bis_datum;

    begin
        if in_res_id is null then
            if v_bde_gut_mg = 0 then
                if v_bde_schrott_mg = 0 then
                    return ( 1 );
                else
                    return ( v_bde_schrott_mg );
                end if;

            else
                return ( v_bde_gut_mg );
            end if;
        end if;

        v_bde_gut_mg := 0;
        v_bde_b_mg := 0;
        v_bde_schrott_mg := 0;
        v_bde_f_gut_mg := 0;
        v_bde_f_b_mg := 0;
        v_bde_f_schrott_mg := 0;
        v_bde_s_gut_mg := 0;
        v_bde_s_b_mg := 0;
        v_bde_s_schrott_mg := 0;
        v_bde_n_gut_mg := 0;
        v_bde_n_b_mg := 0;
        v_bde_n_schrott_mg := 0;
        open c_bde_prod;
        loop
            fetch c_bde_prod into v_bde_prod;
            exit when c_bde_prod%notfound;
            v_bde_gut_mg := v_bde_gut_mg + nvl(v_bde_prod.menge_a, 0);
            v_bde_b_mg := v_bde_b_mg + nvl(v_bde_prod.menge_b, 0);
            v_bde_schrott_mg := v_bde_schrott_mg + nvl(v_bde_prod.schrott, 0);
            if
                ( v_bde_prod.prod_ende - trunc(v_bde_prod.prod_ende) < 14 / 24 )
                and ( v_bde_prod.prod_ende - trunc(v_bde_prod.prod_ende) >= 6 / 24 )
            then
                v_bde_f_gut_mg := v_bde_f_gut_mg + nvl(v_bde_prod.menge_a, 0);
                v_bde_f_b_mg := v_bde_f_b_mg + nvl(v_bde_prod.menge_b, 0);
                v_bde_f_schrott_mg := v_bde_f_schrott_mg + nvl(v_bde_prod.schrott, 0);
            elsif
                ( v_bde_prod.prod_ende - trunc(v_bde_prod.prod_ende) < 22 / 24 )
                and ( v_bde_prod.prod_ende - trunc(v_bde_prod.prod_ende) >= 14 / 24 )
            then
                v_bde_s_gut_mg := v_bde_s_gut_mg + nvl(v_bde_prod.menge_a, 0);
                v_bde_s_b_mg := v_bde_s_b_mg + nvl(v_bde_prod.menge_b, 0);
                v_bde_s_schrott_mg := v_bde_s_schrott_mg + nvl(v_bde_prod.schrott, 0);
            else
                v_bde_n_gut_mg := v_bde_n_gut_mg + nvl(v_bde_prod.menge_a, 0);
                v_bde_n_b_mg := v_bde_n_b_mg + nvl(v_bde_prod.menge_b, 0);
                v_bde_n_schrott_mg := v_bde_n_schrott_mg + nvl(v_bde_prod.schrott, 0);
            end if;

        end loop;

        close c_bde_prod;
        return ( v_bde_gut_mg );
    end get_bde_gut_mengen;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_b_mengen return number is
    begin
        return ( v_bde_b_mg );
    end get_bde_b_mengen;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_schrott_mengen return number is
    begin
        return ( v_bde_schrott_mg );
    end;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_f_gut_mengen return number is
    begin
        return ( v_bde_f_gut_mg );
    end;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_f_b_mengen return number is
    begin
        return ( v_bde_f_b_mg );
    end;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_f_schrott_mengen return number is
    begin
        return ( v_bde_f_schrott_mg );
    end;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_s_gut_mengen return number is
    begin
        return ( v_bde_s_gut_mg );
    end;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_s_b_mengen return number is
    begin
        return ( v_bde_s_b_mg );
    end;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_s_schrott_mengen return number is
    begin
        return ( v_bde_s_schrott_mg );
    end;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_n_gut_mengen return number is
    begin
        return ( v_bde_n_gut_mg );
    end;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_n_b_mengen return number is
    begin
        return ( v_bde_n_b_mg );
    end;
/*
Die Function gibt die BDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_bde_gut_mengen
*/
    function get_bde_n_schrott_mengen return number is
    begin
        return ( v_bde_n_schrott_mg );
    end;
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
    function get_mde_gut_mengen (
        in_res_id    in mde_cfg.res_id%type,
        in_name      in mde_statistik.name%type,
        in_leitzahl  in mde_statistik.leitzahl%type,
        in_von_datum in mde_statistik.datum%type,
        in_bis_datum in mde_statistik.datum%type
    ) return number is

        v_mde_cfg       mde_cfg%rowtype;
        v_mde_stat      mde_statistik%rowtype;
        v_l_gut_mg      number;
        v_l_b_mg        number;
        v_l_schrott_mg  number;
        v_l_micro_stops number;
        cursor c_mde_cfg is
        select
            *
        from
            mde_cfg cfg
        where
            cfg.res_id = in_res_id;

        cursor c_mde_stat is
        select
            *
        from
            mde_statistik m
        where
                m.name = in_name
            and m.leitzahl = nvl(in_leitzahl, m.leitzahl)
            and m.datum >= in_von_datum
            and m.datum < in_bis_datum;

    begin
        if in_res_id is null then
            if v_gut_mg = 0 then
                if v_schrott_mg = 0 then
                    return ( 1 );
                else
                    return ( v_schrott_mg );
                end if;

            else
                return ( v_gut_mg );
            end if;
        end if;

        open c_mde_cfg;
        fetch c_mde_cfg into v_mde_cfg;
        close c_mde_cfg;
        v_l_gut_mg := 0;
        v_l_b_mg := 0;
        v_l_schrott_mg := 0;
        v_l_micro_stops := 0;
        v_gut_mg := 0;
        v_b_mg := 0;
        v_schrott_mg := 0;
        v_micro_stops := 0;
        v_f_gut_mg := 0;
        v_f_b_mg := 0;
        v_f_schrott_mg := 0;
        v_f_micro_stops := 0;
        v_s_gut_mg := 0;
        v_s_b_mg := 0;
        v_s_schrott_mg := 0;
        v_s_micro_stops := 0;
        v_n_gut_mg := 0;
        v_n_b_mg := 0;
        v_n_schrott_mg := 0;
        v_n_micro_stops := 0;
        open c_mde_stat;
        loop
            fetch c_mde_stat into v_mde_stat;
            exit when c_mde_stat%notfound;
            v_l_gut_mg := v_gut_mg;
            v_l_b_mg := v_b_mg;
            v_l_schrott_mg := v_schrott_mg;
            v_l_micro_stops := v_l_micro_stops;
            if v_mde_cfg.fkt_zaehler_0 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_0;
            end if;

            if v_mde_cfg.fkt_zaehler_0 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_0;
            end if;

            if v_mde_cfg.fkt_zaehler_0 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_0;
            end if;

            if v_mde_cfg.fkt_zaehler_0 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_0;
            end if;

            if v_mde_cfg.fkt_zaehler_1 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_1;
            end if;

            if v_mde_cfg.fkt_zaehler_1 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_1;
            end if;

            if v_mde_cfg.fkt_zaehler_1 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_1;
            end if;

            if v_mde_cfg.fkt_zaehler_1 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_1;
            end if;

            if v_mde_cfg.fkt_zaehler_2 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_2;
            end if;

            if v_mde_cfg.fkt_zaehler_2 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_2;
            end if;

            if v_mde_cfg.fkt_zaehler_2 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_2;
            end if;

            if v_mde_cfg.fkt_zaehler_2 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_2;
            end if;

            if v_mde_cfg.fkt_zaehler_3 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_3;
            end if;

            if v_mde_cfg.fkt_zaehler_3 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_3;
            end if;

            if v_mde_cfg.fkt_zaehler_3 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_3;
            end if;

            if v_mde_cfg.fkt_zaehler_3 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_3;
            end if;

            if v_mde_cfg.fkt_zaehler_4 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_4;
            end if;

            if v_mde_cfg.fkt_zaehler_4 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_4;
            end if;

            if v_mde_cfg.fkt_zaehler_4 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_4;
            end if;

            if v_mde_cfg.fkt_zaehler_4 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_4;
            end if;

            if v_mde_cfg.fkt_zaehler_5 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_5;
            end if;

            if v_mde_cfg.fkt_zaehler_5 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_5;
            end if;

            if v_mde_cfg.fkt_zaehler_5 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_5;
            end if;

            if v_mde_cfg.fkt_zaehler_5 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_5;
            end if;

            if v_mde_cfg.fkt_zaehler_6 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_6;
            end if;

            if v_mde_cfg.fkt_zaehler_6 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_6;
            end if;

            if v_mde_cfg.fkt_zaehler_6 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_6;
            end if;

            if v_mde_cfg.fkt_zaehler_6 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_6;
            end if;

            if v_mde_cfg.fkt_zaehler_7 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_7;
            end if;

            if v_mde_cfg.fkt_zaehler_7 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_7;
            end if;

            if v_mde_cfg.fkt_zaehler_7 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_7;
            end if;

            if v_mde_cfg.fkt_zaehler_7 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_7;
            end if;

            if v_mde_cfg.fkt_zaehler_8 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_8;
            end if;

            if v_mde_cfg.fkt_zaehler_8 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_8;
            end if;

            if v_mde_cfg.fkt_zaehler_8 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_8;
            end if;

            if v_mde_cfg.fkt_zaehler_8 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_8;
            end if;

            if v_mde_cfg.fkt_zaehler_9 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_9;
            end if;

            if v_mde_cfg.fkt_zaehler_9 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_9;
            end if;

            if v_mde_cfg.fkt_zaehler_9 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_9;
            end if;

            if v_mde_cfg.fkt_zaehler_9 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_9;
            end if;

            if v_mde_cfg.fkt_zaehler_10 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_10;
            end if;

            if v_mde_cfg.fkt_zaehler_10 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_10;
            end if;

            if v_mde_cfg.fkt_zaehler_10 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_10;
            end if;

            if v_mde_cfg.fkt_zaehler_10 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_10;
            end if;

            if v_mde_cfg.fkt_zaehler_11 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_11;
            end if;

            if v_mde_cfg.fkt_zaehler_11 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_11;
            end if;

            if v_mde_cfg.fkt_zaehler_11 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_11;
            end if;

            if v_mde_cfg.fkt_zaehler_11 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_11;
            end if;

            if v_mde_cfg.fkt_zaehler_12 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_12;
            end if;

            if v_mde_cfg.fkt_zaehler_12 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_12;
            end if;

            if v_mde_cfg.fkt_zaehler_12 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_12;
            end if;

            if v_mde_cfg.fkt_zaehler_12 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_12;
            end if;

            if v_mde_cfg.fkt_zaehler_13 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_13;
            end if;

            if v_mde_cfg.fkt_zaehler_13 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_13;
            end if;

            if v_mde_cfg.fkt_zaehler_13 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_13;
            end if;

            if v_mde_cfg.fkt_zaehler_13 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_13;
            end if;

            if v_mde_cfg.fkt_zaehler_14 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_14;
            end if;

            if v_mde_cfg.fkt_zaehler_14 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_14;
            end if;

            if v_mde_cfg.fkt_zaehler_14 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_14;
            end if;

            if v_mde_cfg.fkt_zaehler_14 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_14;
            end if;

            if v_mde_cfg.fkt_zaehler_15 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_15;
            end if;

            if v_mde_cfg.fkt_zaehler_15 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_15;
            end if;

            if v_mde_cfg.fkt_zaehler_15 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_15;
            end if;

            if v_mde_cfg.fkt_zaehler_15 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_15;
            end if;

            if v_mde_cfg.fkt_zaehler_16 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_16;
            end if;

            if v_mde_cfg.fkt_zaehler_16 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_16;
            end if;

            if v_mde_cfg.fkt_zaehler_16 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_16;
            end if;

            if v_mde_cfg.fkt_zaehler_16 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_16;
            end if;

            if v_mde_cfg.fkt_zaehler_17 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_17;
            end if;

            if v_mde_cfg.fkt_zaehler_17 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_17;
            end if;

            if v_mde_cfg.fkt_zaehler_17 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_17;
            end if;

            if v_mde_cfg.fkt_zaehler_17 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_17;
            end if;

            if v_mde_cfg.fkt_zaehler_18 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_18;
            end if;

            if v_mde_cfg.fkt_zaehler_18 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_18;
            end if;

            if v_mde_cfg.fkt_zaehler_18 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_18;
            end if;

            if v_mde_cfg.fkt_zaehler_18 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_18;
            end if;

            if v_mde_cfg.fkt_zaehler_19 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_19;
            end if;

            if v_mde_cfg.fkt_zaehler_19 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_19;
            end if;

            if v_mde_cfg.fkt_zaehler_19 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_19;
            end if;

            if v_mde_cfg.fkt_zaehler_19 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_19;
            end if;

            if v_mde_cfg.fkt_zaehler_20 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_20;
            end if;

            if v_mde_cfg.fkt_zaehler_20 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_20;
            end if;

            if v_mde_cfg.fkt_zaehler_20 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_20;
            end if;

            if v_mde_cfg.fkt_zaehler_20 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_20;
            end if;

            if v_mde_cfg.fkt_zaehler_21 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_21;
            end if;

            if v_mde_cfg.fkt_zaehler_21 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_21;
            end if;

            if v_mde_cfg.fkt_zaehler_21 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_21;
            end if;

            if v_mde_cfg.fkt_zaehler_21 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_21;
            end if;

            if v_mde_cfg.fkt_zaehler_22 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_22;
            end if;

            if v_mde_cfg.fkt_zaehler_22 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_22;
            end if;

            if v_mde_cfg.fkt_zaehler_22 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_22;
            end if;

            if v_mde_cfg.fkt_zaehler_22 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_22;
            end if;

            if v_mde_cfg.fkt_zaehler_23 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_23;
            end if;

            if v_mde_cfg.fkt_zaehler_23 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_23;
            end if;

            if v_mde_cfg.fkt_zaehler_23 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_23;
            end if;

            if v_mde_cfg.fkt_zaehler_23 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_23;
            end if;

            if v_mde_cfg.fkt_zaehler_24 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_24;
            end if;

            if v_mde_cfg.fkt_zaehler_24 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_24;
            end if;

            if v_mde_cfg.fkt_zaehler_24 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_24;
            end if;

            if v_mde_cfg.fkt_zaehler_24 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_24;
            end if;

            if v_mde_cfg.fkt_zaehler_25 = 2 then
                v_gut_mg := v_gut_mg + v_mde_stat.delta_zaehler_25;
            end if;

            if v_mde_cfg.fkt_zaehler_25 = 3 then
                v_b_mg := v_b_mg + v_mde_stat.delta_zaehler_25;
            end if;

            if v_mde_cfg.fkt_zaehler_25 = 4 then
                v_schrott_mg := v_schrott_mg + v_mde_stat.delta_zaehler_25;
            end if;

            if v_mde_cfg.fkt_zaehler_25 = 5 then
                v_micro_stops := v_micro_stops + v_mde_stat.delta_zaehler_25;
            end if;

            if
                ( v_mde_stat.datum - trunc(v_mde_stat.datum) < 14 / 24 )
                and ( v_mde_stat.datum - trunc(v_mde_stat.datum) >= 6 / 24 )
            then
                v_f_gut_mg := v_f_gut_mg + v_gut_mg - v_l_gut_mg;
                v_f_b_mg := v_f_b_mg + v_b_mg - v_l_b_mg;
                v_f_schrott_mg := v_f_schrott_mg + v_schrott_mg - v_l_schrott_mg;
                v_f_micro_stops := v_f_micro_stops + v_micro_stops - v_l_micro_stops;
            elsif
                ( v_mde_stat.datum - trunc(v_mde_stat.datum) < 22 / 24 )
                and ( v_mde_stat.datum - trunc(v_mde_stat.datum) >= 14 / 24 )
            then
                v_s_gut_mg := v_s_gut_mg + v_gut_mg - v_l_gut_mg;
                v_s_b_mg := v_s_b_mg + v_b_mg - v_l_b_mg;
                v_s_schrott_mg := v_s_schrott_mg + v_schrott_mg - v_l_schrott_mg;
                v_s_micro_stops := v_s_micro_stops + v_micro_stops - v_l_micro_stops;
            else
                v_n_gut_mg := v_n_gut_mg + v_gut_mg - v_l_gut_mg;
                v_n_b_mg := v_n_b_mg + v_b_mg - v_l_b_mg;
                v_n_schrott_mg := v_n_schrott_mg + v_schrott_mg - v_l_schrott_mg;
                v_n_micro_stops := v_n_micro_stops + v_micro_stops - v_l_micro_stops;
            end if;

        end loop;

        close c_mde_stat;
        return ( v_gut_mg );
    end get_mde_gut_mengen;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_b_mengen return number is
    begin
        return ( v_b_mg );
    end get_mde_b_mengen;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_schrott_mengen return number is
    begin
        return ( v_schrott_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_micro_stop return number is
    begin
        return ( v_micro_stops );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_f_gut_mengen return number is
    begin
        return ( v_f_gut_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_f_b_mengen return number is
    begin
        return ( v_f_b_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_f_schrott_mengen return number is
    begin
        return ( v_f_schrott_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_f_micro_stop return number is
    begin
        return ( v_f_micro_stops );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_s_gut_mengen return number is
    begin
        return ( v_s_gut_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_s_b_mengen return number is
    begin
        return ( v_s_b_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_s_schrott_mengen return number is
    begin
        return ( v_s_schrott_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_s_micro_stop return number is
    begin
        return ( v_s_micro_stops );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_n_gut_mengen return number is
    begin
        return ( v_n_gut_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_n_b_mengen return number is
    begin
        return ( v_n_b_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_n_schrott_mengen return number is
    begin
        return ( v_n_schrott_mg );
    end;
/*
Die Function gibt die MDE Mengen für einen Zeitraum und ggf. eines FA_Arbeitsgangs zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_mde_gut_mengen
*/
    function get_mde_n_micro_stop return number is
    begin
        return ( v_n_micro_stops );
    end;
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
    function get_res_prod_std (
        in_res_id     in isi_resource.res_id%type,
        in_ausw_begin in isi_res_status.st_start%type,
        in_ausw_ende  in isi_res_status.st_ende%type
    ) return number is

        v_res_status     isi_res_status%rowtype;
        v_pd_kopf        bde_pd_kopf%rowtype;
        v_res_status_cfg isi_res_status_cfg%rowtype;
        v_begin          date;
        v_ende           date;
        v_ende_status    date;
        v_status         isi_res_status_cfg.st_gruppe%type;
        v_found          boolean;
        cursor c_pd_kopf is
        select
            *
        from
            bde_pd_kopf t
        where
                t.pd_kopf_ende > in_ausw_begin
            and t.pd_kopf_beginn < in_ausw_ende
            and t.res_id = in_res_id
        order by
            t.pd_kopf_beginn;

        cursor c_res_status is
        select
            rs.*
        from
            isi_res_status rs
        where
                rs.res_id = in_res_id
            and rs.st_ende > in_ausw_begin
            and rs.st_start < in_ausw_ende
        order by
            rs.st_start;

        cursor c_res_status_cfg is
        select
            rsc.*
        from
            isi_res_status_cfg rsc
        where
                rsc.sid = v_res_status.sid
            and rsc.firma_nr = v_res_status.firma_nr
            and rsc.res_st_id = v_res_status.res_st_id;

    begin
        if
            v_ausw_funk = 'get_res_prod_std'
            and v_ausw_res_id = in_res_id
            and v_ausw_begin = in_ausw_begin
            and v_ausw_ende = in_ausw_ende
        then
            return ( v_prod_std );
        end if;

        v_ausw_funk := 'get_res_prod_std';
        v_ausw_res_id := in_res_id;
        v_ausw_begin := in_ausw_begin;
        v_ausw_ende := in_ausw_ende;
        v_unterb_std := 0;
        v_up_unterb_std := 0;
        v_ruest_std := 0;
        v_prod_std := 0;
        v_hnz_std := 0;
        v_sz_tz_lz_std := 0;
        v_su_std := 0;

    --v_l_unterb_std := 0;
    --v_l_ruest_std := 0;
    --v_l_prod_std := 0;

        v_f_unterb_std := 0;
        v_f_ruest_std := 0;
        v_f_prod_std := 0;
        v_s_unterb_std := 0;
        v_s_ruest_std := 0;
        v_s_prod_std := 0;
        v_n_unterb_std := 0;
        v_n_ruest_std := 0;
        v_n_prod_std := 0;
        open c_pd_kopf;
        open c_res_status;
        fetch c_pd_kopf into v_pd_kopf;
        loop
      --v_l_unterb_std := v_unterb_std;
      --v_l_ruest_std := v_ruest_std;
      --v_l_prod_std := v_prod_std;
            fetch c_res_status into v_res_status;
            loop
                exit when v_pd_kopf.pd_kopf_ende > v_res_status.st_start
                or c_pd_kopf%notfound;
                fetch c_pd_kopf into v_pd_kopf;
            end loop;

            v_ende_status := v_res_status.st_ende;
            v_found :=
                c_res_status%found
                and c_pd_kopf%found;
            if not v_found then
                exit;
            else
                if v_res_status.st_start > in_ausw_ende then
                    exit;
                else
                    v_ende_status := v_res_status.st_ende;
                    if v_res_status.st_ende > in_ausw_ende then
                        v_res_status.st_ende := in_ausw_ende;
                        v_ende_status := v_res_status.st_ende;
                    end if;

                    loop
                        v_res_status.st_ende := v_ende_status;
                        if v_res_status.st_ende > in_ausw_ende then
                            v_res_status.st_ende := in_ausw_ende;
                        end if;
                        if v_res_status.st_ende > v_pd_kopf.pd_kopf_ende then
                            v_res_status.st_ende := v_pd_kopf.pd_kopf_ende;
                        end if;

                        if v_res_status.st_start < in_ausw_begin then
                            v_res_status.st_start := in_ausw_begin;
                        end if;
                        if v_res_status.st_start < v_pd_kopf.pd_kopf_beginn then
                            v_res_status.st_start := v_pd_kopf.pd_kopf_beginn;
                        end if;

                        if v_res_status.st_start > v_res_status.st_ende then
                            v_res_status.st_ende := v_res_status.st_start;
                            exit;
                        end if;

                        open c_res_status_cfg;
                        fetch c_res_status_cfg into v_res_status_cfg;
                        close c_res_status_cfg;
                        if v_res_status_cfg.res_st_id != 0 then
                            if v_res_status_cfg.st_gruppe = 'R' -- Rüsten
                             then
                                v_status := 'R';
                                v_ruest_std := v_ruest_std + ( v_res_status.st_ende - v_res_status.st_start ) * 24;
                            else
                                v_status := 'U';
                                v_unterb_std := v_unterb_std + ( v_res_status.st_ende - v_res_status.st_start ) * 24;
                                if v_res_status_cfg.st_gruppe = 'E' -- E-Störung ungeplant
                                or v_res_status_cfg.st_gruppe = 'M' -- E-Störung ungeplant
                                or v_res_status_cfg.st_gruppe = 'SU' -- E-Störung ungeplant
                                 then
                                    v_up_unterb_std := v_up_unterb_std + ( v_res_status.st_ende - v_res_status.st_start ) * 24;
                                end if;

                            end if;

                            if v_res_status_cfg.st_gruppe = 'P' then
                                v_hnz_std := v_hnz_std + ( v_res_status.st_ende - v_res_status.st_start ) * 24;
                            elsif v_res_status_cfg.st_gruppe = 'E' -- E-Störung ungeplant
                            or v_res_status_cfg.st_gruppe = 'M' -- M-Störung ungeplant
                            or v_res_status_cfg.st_gruppe = 'SU' -- Störung ungeplant
                             then
                                v_su_std := v_su_std + ( v_res_status.st_ende - v_res_status.st_start ) * 24;
                            else
                                v_sz_tz_lz_std := v_sz_tz_lz_std + ( v_res_status.st_ende - v_res_status.st_start ) * 24;
                            end if;

                        else
                            v_status := 'P';
                            v_prod_std := v_prod_std + ( v_res_status.st_ende - v_res_status.st_start ) * 24;
                            v_hnz_std := v_hnz_std + ( v_res_status.st_ende - v_res_status.st_start ) * 24;
                        end if;

                        v_begin := v_res_status.st_start;
                        v_ende := v_res_status.st_ende;
                        loop
                            exit when v_begin >= v_ende;
                            if v_begin - trunc(v_begin) < 6 / 24
                            or v_begin - trunc(v_begin) >= 22 / 24 then
                                if v_ende - trunc(v_begin) > 30 / 24 then
                                    v_ende := trunc(v_begin) + 30 / 24;
                                end if;

                                if v_status = 'R' then
                                    v_n_ruest_std := v_n_ruest_std + ( v_ende - v_begin ) * 24;
                                elsif v_status = 'U' then
                                    v_n_unterb_std := v_n_unterb_std + ( v_ende - v_begin ) * 24;
                                else
                                    v_n_prod_std := v_n_prod_std + ( v_ende - v_begin ) * 24;
                                end if;

                            end if;

                            if
                                v_begin - trunc(v_begin) < 14 / 24
                                and v_begin - trunc(v_begin) >= 6 / 24
                            then
                                if v_ende - trunc(v_begin) > 14 / 24 then
                                    v_ende := trunc(v_begin) + 14 / 24;
                                end if;

                                if v_status = 'R' then
                                    v_f_ruest_std := v_f_ruest_std + ( v_ende - v_begin ) * 24;
                                elsif v_status = 'U' then
                                    v_f_unterb_std := v_f_unterb_std + ( v_ende - v_begin ) * 24;
                                else
                                    v_f_prod_std := v_f_prod_std + ( v_ende - v_begin ) * 24;
                                end if;

                            end if;

                            if
                                v_begin - trunc(v_begin) < 22 / 24
                                and v_begin - trunc(v_begin) >= 14 / 24
                            then
                                if v_ende - trunc(v_begin) > 22 / 24 then
                                    v_ende := trunc(v_begin) + 22 / 24;
                                end if;

                                if v_status = 'R' then
                                    v_s_ruest_std := v_s_ruest_std + ( v_ende - v_begin ) * 24;
                                elsif v_status = 'U' then
                                    v_s_unterb_std := v_s_unterb_std + ( v_ende - v_begin ) * 24;
                                else
                                    v_s_prod_std := v_s_prod_std + ( v_ende - v_begin ) * 24;
                                end if;

                            end if;

                            if v_res_status.st_ende > v_pd_kopf.pd_kopf_ende then
                                fetch c_pd_kopf into v_pd_kopf;
                            end if;
                            v_begin := v_ende;
                            v_ende := v_res_status.st_ende;
                        end loop;

                        if v_res_status.st_ende = v_pd_kopf.pd_kopf_ende then
                            loop
                                fetch c_pd_kopf into v_pd_kopf;
                                exit when v_res_status.st_ende < v_pd_kopf.pd_kopf_ende
                                or c_pd_kopf%notfound;
                            end loop;
                        end if;

                        exit when v_res_status.st_ende = v_ende_status
                        or c_pd_kopf%notfound;
                    end loop;

                end if;
            end if;

        end loop;

        close c_res_status;
        close c_pd_kopf;
        return ( v_prod_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_ruest_std return number is
    begin
        return ( v_ruest_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_unterbr_std return number is
    begin
        return ( v_unterb_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_up_unterbr_std return number is
    begin
        return ( v_up_unterb_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_hnz_std return number is
    begin
        return ( v_hnz_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_su_std return number is
    begin
        return ( v_su_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_sz_tz_lz_std return number is
    begin
        return ( v_sz_tz_lz_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_f_prod_std return number is
    begin
        return ( v_f_prod_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_f_ruest_std return number is
    begin
        return ( v_f_ruest_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_f_unterbr_std return number is
    begin
        return ( v_f_unterb_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_s_prod_std return number is
    begin
        return ( v_s_prod_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_s_ruest_std return number is
    begin
        return ( v_s_ruest_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_s_unterbr_std return number is
    begin
        return ( v_s_unterb_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_n_prod_std return number is
    begin
        return ( v_n_prod_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_n_ruest_std return number is
    begin
        return ( v_n_ruest_std );
    end;
/*
Die Function gibt die Zeiten einer Resource (RES) für einen Zeitraum zurück
gesetzt werden dei Werte durch die Funktion bde_funktionen.get_res_prod_std
*/
    function get_res_n_unterbr_std return number is
    begin
        return ( v_n_unterb_std );
    end;
/*
Die Function ermittelt alle Auftragswechsel einer Resource (Maschine) in einem Zeitraun

@see * Die Funktion greift auf die Tabelle bde_pd_prod
@see ** Wenn die Parameter unglücklich gesetzt werden, kann es zu einem Langläufer werden

@author -AG- Hans Joachim Gödeke
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_ausw_begin     in isi_res_status.st_start Start der Auswerung
@param in_ausw_ende      in isi_res_status.st_ende Ende der Auswertung
@return v_auftr_wechsel Return ist die Anzahl der Auftragswechsel
*/
    function get_res_auf_wechsel (
        in_res_id     in isi_resource.res_id%type,
        in_ausw_begin in isi_res_status.st_start%type,
        in_ausw_ende  in isi_res_status.st_ende%type
    ) return number is

        cursor c_anz_letzt_leit is
        select
            t.leitzahl
        from
            bde_pd_prod t
        where
                t.res_id = in_res_id
            and t.prod_ende >= in_ausw_begin - 4
            and t.prod_ende < in_ausw_ende
            and t.prod_beginn < in_ausw_begin
            and t.vorg_typ = 'PA'
        order by
            t.prod_beginn desc;

        cursor c_anz_aw is
        select
            t.leitzahl
        from
            bde_pd_prod t
        where
                t.res_id = in_res_id
            and t.prod_beginn >= in_ausw_begin
            and t.prod_beginn < in_ausw_ende
            and t.vorg_typ = 'PA'
        order by
            t.prod_beginn;

        v_leitzahl      number;
        v_l_leitzahl    number;
        v_auftr_wechsel number;
    begin
        v_auftr_wechsel := 0;
        v_l_leitzahl := 0;
        open c_anz_letzt_leit;
        fetch c_anz_letzt_leit into v_l_leitzahl;
        close c_anz_letzt_leit;
        open c_anz_aw;
        loop
            fetch c_anz_aw into v_leitzahl;
            exit when c_anz_aw%notfound;
            if v_leitzahl != v_l_leitzahl then
                v_l_leitzahl := v_leitzahl;
                v_auftr_wechsel := v_auftr_wechsel + 1;
            end if;

        end loop;

        return ( v_auftr_wechsel );
    end;

/*
Die Function ermittelt die Produktionstage einer Resource (Maschine) in einem Zeitraun

@see * Die Funktion greift auf die Tabelle bde_pd_kopf

@author -AG- Hans Joachim Gödeke
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_ausw_begin     in isi_res_status.st_start Start der Auswerung
@param in_ausw_ende      in isi_res_status.st_ende Ende der Auswertung
@return v_prod_tage Return ist die Anzahl der Produktionstage
*/
    function get_res_prod_tage (
        in_res_id     in isi_resource.res_id%type,
        in_ausw_begin in isi_res_status.st_start%type,
        in_ausw_ende  in isi_res_status.st_ende%type
    ) return number is
    begin
        if in_res_id is null then
            return ( v_prod_tage );
        end if;
        select
            count(*)
        into v_prod_tage
        from
            (
                select
                    count(trunc(t.sa_beginn - 5.5 / 24))
                from
                    bde_pd_kopf t
                where
                        t.res_id = in_res_id
                    and t.sa_beginn >= in_ausw_begin
                    and t.sa_beginn < in_ausw_ende
                group by
                    trunc(t.sa_beginn - 5.5 / 24)
            );

        return ( v_prod_tage );
    end;

/*
Die Function ermittelt dir Produktionsschichten einer Resource (Maschine) in einem Zeitraun

@see * Die Funktion greift auf die Tabelle bde_pd_kopf

@author -AG- Hans Joachim Gödeke
@param in_res_id         in isi_resource.res_id Für diese Resource (maschine) werden alle Zeiten ermittelt
@param in_ausw_begin     in isi_res_status.st_start Start der Auswerung
@param in_ausw_ende      in isi_res_status.st_ende Ende der Auswertung
@return v_prod_Schichten Return ist die Anzahl der Produktionsschichten
*/
    function get_res_prod_schichten (
        in_res_id     in isi_resource.res_id%type,
        in_ausw_begin in isi_res_status.st_start%type,
        in_ausw_ende  in isi_res_status.st_ende%type
    ) return number is
    begin
        if in_res_id is null then
            return ( v_prod_schichten );
        end if;
        select
            count(*)
        into v_prod_schichten
        from
            (
                select
                    count(trunc(t.sa_beginn - 5.5 / 24))
                from
                    bde_pd_kopf t
                where
                        t.res_id = in_res_id
                    and t.sa_beginn >= in_ausw_begin
                    and t.sa_beginn < in_ausw_ende
                group by
                    trunc(t.sa_beginn - 5.5 / 24), -- Schichttag
                  -- und Schicht im Dreischicht 6:00 - 14:00 - 22:00
                    decode((round(((t.sa_beginn - 5.5 / 24) - trunc(t.sa_beginn)) * 24 / 8)),
                           -1,
                           2,
                           (round(((t.sa_beginn - 5.5 / 24) - trunc(t.sa_beginn)) * 24 / 8)))
            );
--         group by trunc(t.sa_beginn - 5.5 / 24)
--           + (round(((t.sa_beginn - 5.5 / 24) - trunc(t.sa_beginn)) * 24 / 8)) / 24);
        return ( v_prod_schichten );
    end;

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
    function get_anmelde_std (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_begin    in bde_pd_kopf.pd_kopf_beginn%type,
        in_ende     in bde_pd_kopf.pd_kopf_ende%type,
        in_res_id   in isi_resource.res_id%type
    ) return number is

        v_anm_std number;
        cursor c_anm_std is
        select
            sum((
                case
                    when p.pd_kopf_ende > in_ende then
                        in_ende
                    else
                        p.pd_kopf_ende
                end
                -
                case
                    when p.pd_kopf_beginn < in_begin then
                        in_begin
                    else
                        p.pd_kopf_beginn
                end
            ) * 24)
        from
            bde_pd_kopf p
        where
                p.sid = in_sid
            and p.firma_nr = in_firma_nr
            and p.res_id = in_res_id
            and p.pd_kopf_ende > in_begin
            and p.pd_kopf_beginn < in_ende;

    begin
        if
            v_ausw_funk = 'get_anmelde_std'
            and v_ausw_res_id = in_res_id
            and v_ausw_begin = in_begin
            and v_ausw_ende = in_ende
        then
            return ( v_anm_std );
        end if;

        v_ausw_funk := 'get_anmelde_std';
        v_ausw_res_id := in_res_id;
        v_ausw_begin := in_begin;
        v_ausw_ende := in_ende;
        v_anm_std := null;
        open c_anm_std;
        fetch c_anm_std into v_anm_std;
        close c_anm_std;
        v_anm_std := nvl(v_anm_std, 0);
        return ( v_anm_std );
    end;
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
    procedure c_set_zug_menge_lhm_fa (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_leitzahl in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_fa_upos  in bde_fa_auftrag.fa_upos%type,
        in_menge    in bde_fa_auftrag.lhm_menge%type
    ) is

        v_pd_prod       bde_pd_prod%rowtype;
        v_fa_auftrag    bde_fa_auftrag%rowtype;
        v_lam_bh        lvs_lam_bh%rowtype;
        v_lam_anz_menge number;
        v_found         boolean;
        cursor c_fa_auftrag is
        select
            *
        from
            bde_fa_auftrag t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.leitzahl = in_leitzahl
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos;

        cursor c_pd_prod is
        select
            *
        from
            bde_pd_prod p
        where
                p.leitzahl = in_leitzahl
            and p.fa_ag = in_fa_ag
            and p.fa_upos = in_fa_upos
            and ( p.vorg_typ = 'PA'
                  or p.vorg_typ = 'RA' )
            and p.prod_ende is null;

        cursor c_lam_bh is
        select
            *
        from
            lvs_lam_bh t
        where
                t.leitzahl = in_leitzahl
            and nvl(t.fa_ag, -1) = decode(v_fa_auftrag.kenz_letzt_ag, 1, -1, in_fa_ag)
            and nvl(t.fa_upos, -1) = decode(v_fa_auftrag.kenz_letzt_ag, 1, -1, in_fa_upos)
            and t.buch_datum > v_pd_prod.prod_beginn;

        cursor c_lam_bh_lhm is
        select
            count(*)
        from
            lvs_lam_bh t
        where
                t.leitzahl = in_leitzahl
            and nvl(t.fa_ag, -1) = decode(v_fa_auftrag.kenz_letzt_ag, 1, -1, in_fa_ag)
            and nvl(t.fa_upos, -1) = decode(v_fa_auftrag.kenz_letzt_ag, 1, -1, in_fa_upos)
            and t.lhm_id = v_lam_bh.lhm_id
            and t.menge > 0;

    begin
        v_pd_prod := null;
        v_err_nr := 1;
        open c_pd_prod;
        fetch c_pd_prod into v_pd_prod;
        v_found := c_pd_prod%found;
        close c_pd_prod;
        if not v_found then
            v_err_text := 'Der Auftrag ist nicht an der Machine angemeldet.';
            raise v_error;
        end if;
        v_err_nr := 2;
        v_fa_auftrag := null;
        open c_fa_auftrag;
        fetch c_fa_auftrag into v_fa_auftrag;
        v_found := c_fa_auftrag%found;
        close c_fa_auftrag;
        if not v_found then
            v_err_text := 'Fehler beim lesen des FA-Auftrags.';
            raise v_error;
        end if;
        v_err_text := 'Fehler beim ändern der Buchungen';
        v_err_nr := 3;
        open c_lam_bh;
        loop
            fetch c_lam_bh into v_lam_bh;
            exit when c_lam_bh%notfound;
            v_lam_anz_menge := 0;
            if v_lam_bh.menge = 0 then
                open c_lam_bh_lhm;
                fetch c_lam_bh_lhm into v_lam_anz_menge;
                close c_lam_bh_lhm;
                v_lam_anz_menge := nvl(v_lam_anz_menge, 0);
            end if;

      -- -AG- 23.09.2008 Beim Rüsten abmelden auch hier den FA korrigieren
            if
                v_pd_prod.vorg_typ = 'RA'
                and v_lam_bh.menge != in_menge
            then
        -- Die Menge muss - der bereits gebuchten und + der neuen Menge geaendert werden
                update bde_fa_auftrag t
                set
                    t.ag_ist_mg = t.ag_ist_mg - v_lam_bh.menge + in_menge
                where
                        t.sid = in_sid
                    and t.firma_nr = in_firma_nr
                    and t.leitzahl = in_leitzahl
                    and t.fa_ag = in_fa_ag
                    and t.fa_upos = in_fa_upos;

            end if;

            if v_lam_anz_menge = 0 then
                bde_pd_prod_p_pp_u(in_sid, v_lam_bh.lam_id, in_menge, null);
                update lvs_lam_bh t
                set
                    t.menge = in_menge
                where
                    t.lam_bh_id = v_lam_bh.lam_bh_id;

            end if;

        end loop;

        close c_lam_bh;
        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when others then
            if c_lam_bh%isopen then
                close c_lam_bh;
            end if;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
                rollback;
            else
                raise;
            end if;

    end;
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
    procedure c_insert_bde_pd_schrott (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_res_id    in isi_resource.res_id%type,
        in_pd_beginn in bde_pd_prod.prod_beginn%type,
        in_login_id  in isi_user.login_id%type,
        in_leitzahl  in bde_fa_auftrag.leitzahl%type,
        in_fa_ag     in bde_fa_auftrag.fa_ag%type,
        in_fa_upos   in bde_fa_auftrag.fa_upos%type,
        in_menge     in bde_fa_auftrag.lhm_menge%type
    ) is

        v_vorg_id     number;
        v_bde_pd_prod bde_pd_prod%rowtype;
        v_found       boolean;
        cursor c_bde_pd_prod is
        select
            *
        from
            bde_pd_prod p
        where
                nvl(p.res_id, -1) = in_res_id
            and p.leitzahl = in_leitzahl
            and p.prod_ende = in_pd_beginn
            and p.fa_ag = in_fa_ag
            and p.fa_upos = in_fa_upos
            and p.artikel_id is null;

    begin
        open c_bde_pd_prod;
        fetch c_bde_pd_prod into v_bde_pd_prod;
        v_found := c_bde_pd_prod%found;
        close c_bde_pd_prod;
    -- Suchen des Satz, ob schon vorhanden. Wenn nicht dann anlegen
        if not v_found then
            select
                seq_vorg_id.nextval
            into v_vorg_id
            from
                dual;

            insert into bde_pd_prod values ( in_sid,                         -- SID           VARCHAR2(2) not null,
                                             v_vorg_id,                      -- VORG_ID       NUMBER not null,
                                             'PP',                           -- VORG_TYP      VARCHAR2(2) not null,
                                             in_firma_nr,                    -- FIRMA_NR      NUMBER(2) not null,
                                             in_leitzahl,                    -- LEITZAHL      NUMBER not null,
                                             in_fa_ag,                       -- FA_AG         NUMBER not null,
                                             in_fa_upos,                     -- FA_UPOS       NUMBER,
                                             null,                           -- ABNR          VARCHAR2(20),
                                             in_res_id,                      -- RES_ID        NUMBER not null,
                                             in_pd_beginn,                   -- PROD_BEGINN   DATE not null,
                                             in_pd_beginn,                   -- PROD_ENDE     DATE,
                                             0,                              -- PERS_NR       NUMBER,
                                             null,                           -- LAM_ID        NUMBER,
                                             null,                           -- ARTIKEL_ID    NUMBER,
                                             0,                              -- MENGE_A       NUMBER,
                                             0,                              -- MENGE_B       NUMBER,
                                             0,                              -- SCHROTT       NUMBER,
                                             in_login_id,                    -- LS_LOGIN_ID   NUMBER,
                                             0,                              -- PD_NETTO_ZEIT NUMBER
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null );

        end if;

    end;
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
    procedure c_change_zug_menge_lhm_fa (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_leitzahl  in bde_fa_auftrag.leitzahl%type,
        in_fa_ag     in bde_fa_auftrag.fa_ag%type,
        in_fa_upos   in bde_fa_auftrag.fa_upos%type,
        in_lam_id    in lvs_lam.lam_id%type,
        in_menge     in bde_fa_auftrag.lhm_menge%type,
        in_old_menge in bde_fa_auftrag.ag_ist_mg%type,
        in_buch_dat  in date
    ) is
    begin
        update bde_fa_auftrag t
        set
            t.ag_ist_mg = t.ag_ist_mg + in_menge - in_old_menge
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.leitzahl = in_leitzahl
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos;

        update bde_pd_prod p
        set
            p.menge_a = p.menge_a + in_menge - in_old_menge
        where
                p.leitzahl = in_leitzahl
            and p.fa_ag = in_fa_ag
            and p.fa_upos = in_fa_upos
            and p.vorg_typ = 'PA'
            and p.prod_beginn <= in_buch_dat
            and p.prod_ende >= in_buch_dat;

        update lvs_lam_bh t
        set
            t.menge = in_menge
        where
                t.lam_id = in_lam_id
            and t.bus = c.lam_bh_bus_zug
            and t.menge = in_old_menge;

        commit;
    end;
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
    procedure c_change_schrott_menge (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_leitzahl  in bde_fa_auftrag.leitzahl%type,
        in_fa_ag     in bde_fa_auftrag.fa_ag%type,
        in_fa_upos   in bde_fa_auftrag.fa_upos%type,
        in_menge     in bde_fa_auftrag.lhm_menge%type,
        in_old_menge in bde_fa_auftrag.ag_ist_mg%type,
        in_buch_dat  in date
    ) is
    begin
        update bde_fa_auftrag t
        set
            t.ag_ist_mg_schrott = nvl(t.ag_ist_mg_schrott, 0) + in_menge - in_old_menge
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.leitzahl = in_leitzahl
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos;

        update bde_pd_prod p
        set
            p.schrott = nvl(p.schrott, 0) + in_menge - in_old_menge
        where
                p.leitzahl = in_leitzahl
            and p.fa_ag = in_fa_ag
            and p.fa_upos = in_fa_upos
            and p.vorg_typ = 'PA'
            and p.prod_beginn <= in_buch_dat
            and p.prod_ende >= in_buch_dat;

        commit;
    end;
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
    procedure c_insert_bde_prod (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_res_id     in isi_resource.res_id%type,
        in_leitzahl   in bde_fa_auftrag.leitzahl%type,
        in_fa_ag      in bde_fa_auftrag.fa_ag%type,
        in_fa_upos    in bde_fa_auftrag.fa_upos%type,
        in_artikel_id in isi_artikel.artikel_id%type,
        in_pd_beginn  in bde_pd_prod.prod_beginn%type,
        in_pd_ende    in bde_pd_prod.prod_ende%type,
        in_menge      in bde_pd_prod.menge_a%type,
        in_menge_b    in bde_pd_prod.menge_b%type,
        in_schrott    in bde_pd_prod.schrott%type,
        in_login_id   in isi_user.login_id%type
    ) is
        v_vorg_id number;
    begin
    -- Korrektur / Eintragen der Menge im Fertigungsauftrag
        update bde_fa_auftrag t
        set
            t.ag_ist_mg = nvl(t.ag_ist_mg, 0) + nvl(in_menge, 0),
            t.ag_ist_mg_b = nvl(t.ag_ist_mg_b, 0) + nvl(in_menge_b, 0),
            t.ag_ist_mg_schrott = nvl(t.ag_ist_mg_schrott, 0) + nvl(in_schrott, 0)
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.leitzahl = in_leitzahl
            and t.fa_ag = in_fa_ag
            and t.fa_upos = nvl(in_fa_upos, 0);

        select
            seq_vorg_id.nextval
        into v_vorg_id
        from
            dual;
    -- Buchen in den Produktionsmengen
        insert into bde_pd_prod values ( in_sid,                         -- SID           VARCHAR2(2) not null,
                                         v_vorg_id,                      -- VORG_ID       NUMBER not null,
                                         'PP',                           -- VORG_TYP      VARCHAR2(2) not null,
                                         in_firma_nr,                    -- FIRMA_NR      NUMBER(2) not null,
                                         nvl(in_leitzahl, 0),            -- LEITZAHL      NUMBER not null,
                                         nvl(in_fa_ag, 0),               -- FA_AG         NUMBER not null,
                                         nvl(in_fa_upos, 0),             -- FA_UPOS       NUMBER,
                                         null,                           -- ABNR          VARCHAR2(20),
                                         in_res_id,                      -- RES_ID        NUMBER not null,
                                         in_pd_beginn,                   -- PROD_BEGINN   DATE not null,
                                         in_pd_ende,                     -- PROD_ENDE     DATE,
                                         0,                              -- PERS_NR       NUMBER,
                                         null,                           -- LAM_ID        NUMBER,
                                         in_artikel_id,                  -- ARTIKEL_ID    NUMBER,
                                         in_menge,                       -- MENGE_A       NUMBER,
                                         in_menge_b,                     -- MENGE_B       NUMBER,
                                         in_schrott,                     -- SCHROTT       NUMBER,
                                         in_login_id,                    -- LS_LOGIN_ID   NUMBER,
                                         0,                              -- PD_NETTO_ZEIT NUMBER
                                         null,
                                         null,
                                         null,
                                         null,
                                         null,
                                         null,
                                         null,
                                         null,
                                         null,
                                         null,
                                         null,
                                         null,
                                         null );

        commit;
    end;
/*
Ermittelt die Mitarbeiterstunden an einer Resource für einen Zeitraum

@author -DTs- Dionysios Tsekas
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_res_id         in isi_resource.res_id RES_ID der Maschine auf der Gebucht werden soll
@param in_aufgabe_seit   in isi_resource_zust_akt.akt_aufgabe_seit Auswertung von
@param in_res_id         in date Ende des Auswertungszeitraum
*/
    function get_ma_erf_zeiten (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_res_id       in isi_resource.res_id%type,
        in_aufgabe_seit in isi_resource_zust_akt.akt_aufgabe_seit%type,
        in_aufgabe_bis  in date
    ) return number is

        v_ma_erf_zeiten number;
        v_found         boolean;
        cursor c_prod_kopf_ma is
        select
            kma.res_id,
            kma.ls_login_id,
            kma.pd_kopf_beginn,
            in_aufgabe_seit,
            kma.pd_kopf_ende,
            in_aufgabe_bis,
            (
                case
                    when nvl(kma.pd_kopf_ende, sysdate) > in_aufgabe_bis then
                        in_aufgabe_bis
                    else
                        nvl(kma.pd_kopf_ende, sysdate)
                end
                -
                case
                    when kma.pd_kopf_beginn < in_aufgabe_seit then
                        in_aufgabe_seit
                    else
                        kma.pd_kopf_beginn
                end
            ) * 24 ma_zeit_erf
        from
            bde_pd_kopf_ma kma
        where
                kma.sid = in_sid
            and kma.firma_nr = in_firma_nr
            and kma.res_id = in_res_id
            and kma.pd_kopf_beginn > in_aufgabe_seit - 1
            and nvl(kma.pd_kopf_ende, sysdate) > in_aufgabe_seit
            and kma.pd_kopf_beginn <= in_aufgabe_bis;

        v_prod_kopf_ma  c_prod_kopf_ma%rowtype;
    begin
        v_ma_erf_zeiten := 0;
        open c_prod_kopf_ma;
        fetch c_prod_kopf_ma into v_prod_kopf_ma;
        v_found := c_prod_kopf_ma%found;
        loop
            exit when not v_found;
            v_ma_erf_zeiten := v_ma_erf_zeiten + v_prod_kopf_ma.ma_zeit_erf;
            fetch c_prod_kopf_ma into v_prod_kopf_ma;
            v_found := c_prod_kopf_ma%found;
        end loop;

        close c_prod_kopf_ma;
        return ( v_ma_erf_zeiten );
    end;
--begin
  -- Initialization
  --<Statement>;
end bde_funktionen;
/


-- sqlcl_snapshot {"hash":"7e0d484108fe467d5d1a5c64cd0bc6dc7de131ee","type":"PACKAGE_BODY","name":"BDE_FUNKTIONEN","schemaName":"DIRKSPZM32","sxml":""}