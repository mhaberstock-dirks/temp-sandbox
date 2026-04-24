create or replace procedure dirkspzm32.bde_pd_prod_p_pp_u
/*
In dieser Procedure wird ein Update auf die Produktion eines LAM in den PP Satz gebucht.
Diese Procedure aktualisiert die Tabellen bde_pd_prod (Satzart PP und PA), lvs_lam_bh (Die dann
in der LVS_LAM bucht) und bde_fa_auftrag.

-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_leitzahl        in bde_fa_auftrag.leitzahl           Fertigungsauftrag
@param in_fa_ag           in bde_fa_auftrag.fa_ag              Arbeitsgang
@param in_fa_upos         in bde_fa_auftrag.fa_upos            Unterposition bzw. Split
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_menge           in bde_fa_auftrag.ag_ist_mg          Rückgabe der A-Qualätät
@param in_sysdate         in date                              bis zu dieseem Datum auswerten
@param in_pp_zeit         in number                            Benötigte Produktionszeit für diese Menge
@param in_akt_abfuell     in isi_resource_zust_akt.abfuell_ist Aktuell abgefüllte Menge aus Waage gespeichert in isi_resource_zust_akt.abfuell_ist

@see bde_funktionen.c_set_zug_menge_lhm_fa Aufruf in der DB von hier
*/ (
    in_sid      in isi_sid.sid%type,
    in_lam_id   in bde_pd_prod.lam_id%type,
    in_menge    in bde_fa_auftrag.ag_ist_mg%type,
    in_login_id in isi_user.login_id%type
) is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  15.02.2017
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  26.02.2017   3.5.10.1    (-AG-)   Bei automatischer Rückmeldung und zwei Linien auf der gleichen RES in einer SEK fuehr das zu Problemen
  */

    v_version_str constant varchar2(30) := '3.5.10.1 / 26.02.2017';
    v_prod_pp     bde_pd_prod%rowtype;               -- Hole den aktuellen Produktionssatz zu diesem
    v_prod_pa     bde_pd_prod%rowtype;               -- Hole den aktuellen Produktionssatz zu diesem
    v_found       boolean;                           -- Daten gefunden ???
    v_diff_mg     bde_fa_auftrag.ag_ist_mg%type;     -- Differnzmenge Alt Neu
    v_lhm_cfg     lvs_lhm_cfg%rowtype;               -- Daten um neues Lagerhilfsmittel in der LVS_LHM anzulegen
    v_lam_bh_kg   lvs_lam_bh.lam_bh_kg%type; -- Gewicht der Wahre

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr      number;
    v_err_text    varchar2(255);
    cursor c_bde_pd_pp is
    select
        *
    from
        bde_pd_prod pp
    where
            pp.sid = in_sid
        and pp.vorg_typ = 'PP'
        and pp.lam_id = in_lam_id;

    cursor c_bde_pd_prod is
    select
        *
    from
        bde_pd_prod pa
    where
            pa.sid = v_prod_pp.sid
        and pa.vorg_typ = 'PA'
        and pa.firma_nr = v_prod_pp.firma_nr
        and pa.leitzahl = v_prod_pp.leitzahl
        and pa.fa_ag = v_prod_pp.fa_ag
        and nvl(pa.fa_upos, 0) = nvl(v_prod_pp.fa_upos, 0)
        and pa.res_id = v_prod_pp.res_id
        and pa.prod_beginn <= v_prod_pp.prod_beginn
        and ( ( pa.prod_ende is null )
              or ( pa.prod_ende >= v_prod_pp.prod_beginn ) )
    order by
        pa.prod_beginn desc;

begin
  -- Erst mal kein Fehler
    v_err_nr := null;
    v_err_text := null;
    open c_bde_pd_pp;                     -- Den Entsprechenden Produktionssatz holen
    fetch c_bde_pd_pp into v_prod_pp;     -- Lesen der Daten
    v_found := c_bde_pd_pp%found;         -- Richtige Daten gefunden
    close c_bde_pd_pp;                    -- Cursor wider zu

    if v_found then
        v_diff_mg := in_menge - nvl(v_prod_pp.menge_a, 0);
        if v_diff_mg != 0 then
            update bde_pd_prod pp
            set
                pp.menge_a = in_menge
            where
                    pp.sid = in_sid
                and pp.vorg_typ = 'PP'
                and pp.lam_id = in_lam_id;

            open c_bde_pd_prod;                   -- Den Entsprechenden Summensatz der Produktion Suchen
                                            -- Nur dann Updaten wenn nch nicht geschlossen !!
            fetch c_bde_pd_prod into v_prod_pa;   -- Lesen der Daten
            v_found := c_bde_pd_prod%found;       -- Richtige Daten gefunden
            close c_bde_pd_prod;                  -- Cursor wider zu
            if v_found then                       -- Daten gefunden !!
                v_err_nr := 10;
                v_err_text := 'Fehler beim Eintragen der Produktionsmeldung:'
                              || v_prod_pp.leitzahl
                              || '/'
                              || v_prod_pp.fa_ag
                              || '/'
                              || v_prod_pp.fa_upos;

        -- 26.02.2017   3.5.10.1    (-AG-)   Bei automatischer Rückmeldung und zwei Linien auf der gleichen RES in einer SEK fuehr das zu Problemen    update bde_pd_prod pd
                update bde_pd_prod pa
                set
                    pa.menge_a = nvl(v_prod_pa.menge_a, 0) + v_diff_mg
                where
                        pa.sid = v_prod_pp.sid
                    and pa.vorg_typ = 'PA'
                    and pa.firma_nr = v_prod_pp.firma_nr
                    and pa.leitzahl = v_prod_pp.leitzahl
                    and pa.fa_ag = v_prod_pp.fa_ag
                    and nvl(pa.fa_upos, 0) = nvl(v_prod_pp.fa_upos, 0)
                    and pa.res_id = v_prod_pp.res_id
                    and
                -- pa.prod_beginn <= v_prod_pp.prod_beginn and  -- 26.02.2017   3.5.10.1    (-AG-)
                -- pa.prod_beginn = v_prod_pp.prod_beginn and       -- 26.02.2017   3.5.10.1    (-AG-)
                     pa.prod_beginn <= v_prod_pp.prod_beginn
                    and       -- 13.12.2018  Ticket W20310-185 (-SKo-)
                     ( ( pa.prod_ende is null )
                          or ( pa.prod_ende >= v_prod_pp.prod_beginn ) );

                if sql%rowcount != 1 then
                    v_err_nr := 20;
                    v_err_text := 'Fehler beim Eintragen der Produktionsmeldung: '
                                  || v_prod_pp.leitzahl
                                  || '/'
                                  || v_prod_pp.fa_ag
                                  || '/'
                                  || v_prod_pp.fa_upos
                                  || ' Eintrag nicht eindeutig.';

                    raise v_error;
                end if;
        -- Update des Aktuelle Zustands des Arbeitsgangs
                update bde_fa_auftrag fa
                set
                    fa.ag_ist_mg = nvl(fa.ag_ist_mg, 0) + v_diff_mg       -- Mengen addieren
                where
                        fa.sid = v_prod_pp.sid
                    and fa.leitzahl = v_prod_pp.leitzahl
                    and fa.fa_ag = v_prod_pp.fa_ag
                    and nvl(fa.fa_upos, 0) = nvl(v_prod_pp.fa_upos, 0);

            end if;

            update lvs_lam_bh lbh
            set
                lbh.menge = in_menge
            where
                    lbh.sid = v_prod_pp.sid
                and lbh.firma_nr = v_prod_pp.firma_nr
                and lbh.lam_id = v_prod_pp.lam_id
                and lbh.buch_datum = v_prod_pp.prod_ende;

        end if;

    end if;

    commit;
exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
    when v_error then  -- Update 2011 show Exception Source Line
        rollback;
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
        rollback;
        if v_err_nr is not null then
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
        end if;

end bde_pd_prod_p_pp_u;
/


-- sqlcl_snapshot {"hash":"1508558680e894da7d55e1dc10326ffac06a4092","type":"PROCEDURE","name":"BDE_PD_PROD_P_PP_U","schemaName":"DIRKSPZM32","sxml":""}