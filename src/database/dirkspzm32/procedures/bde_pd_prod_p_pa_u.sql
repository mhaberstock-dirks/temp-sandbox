create or replace 
procedure DIRKSPZM32.bde_pd_prod_p_pa_u
/*
In dieser Procedure wird die Produktion eines LAM in den PA Satz gebucht.
Der PA-Satz ist die Zusammenfassung aller Produktionssätzen PP die Zusammenhängen Produzuert wurden.
Diese Funktion wird nur in der DB intern benutzt und hält die tabellen bde_pd_prod und bde_fa_auftrag aktuell 

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

@see bde_pd_prod_insert Aufruf von hier
@see bde_scanner.bde_sc_pd_prod_insert Aufruf von hier
*/
(in_sid         in isi_sid.sid%type,
 in_firma_nr    in isi_firma.firma_nr%type,
 in_leitzahl    in bde_fa_auftrag.leitzahl%type,
 in_fa_ag       in bde_fa_auftrag.fa_ag%type,
 in_fa_upos     in bde_fa_auftrag.fa_upos%type,
 in_res_id      in isi_resource.res_id%type,
 in_menge       in bde_fa_auftrag.ag_ist_mg%type,
 in_sysdate     in date,
 in_pp_zeit     in number,
 in_akt_abfuell in isi_resource_zust_akt.abfuell_ist%type) is

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

  v_version_str    constant  varchar2(30) := '3.5.10.1 / 26.02.2017';

  v_prod_pa          bde_pd_prod%rowtype;      -- Hole den aktuellen Produktionssatz zu diesem
  v_found            boolean;                  -- Daten gefunden ???
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);
  

  CURSOR c_bde_pd_prod  IS
    SELECT *
      FROM bde_pd_prod pp
      WHERE pp.sid = in_sid and
            pp.vorg_typ = 'PA' and
            pp.firma_nr = in_firma_nr and
            pp.leitzahl = in_leitzahl and
            pp.fa_ag = in_fa_ag and
            nvl(pp.fa_upos, 0) = nvl(in_fa_upos, 0) and
            pp.res_id = in_res_id and
            pp.prod_beginn <= in_sysdate and
            ((pp.prod_ende is NULL) or
             (pp.prod_ende >= in_sysdate))
       order by pp.prod_beginn desc;

begin
  -- Erst mal kein Fehler
  v_err_nr := NULL;
  v_err_text := NULL;

  OPEN c_bde_pd_prod;                   -- Den Entsprechenden Summensatz der Produktion Suchen
  FETCH c_bde_pd_prod into v_prod_pa;   -- Lesen der Daten
  v_found := c_bde_pd_prod%FOUND;       -- Richtige Daten gefunden
  CLOSE c_bde_pd_prod;                  -- Cursor wider zu
  if v_found then                       -- Daten gefunden !!
    v_err_nr := 10;
    v_err_text := 'Fehler beim Eintragen der Produktionsmeldung:' || in_leitzahl || '/' || in_fa_ag || '/' || in_fa_upos ;
     -- 26.02.2017   3.5.10.1    (-AG-)   Bei automatischer Rückmeldung und zwei Linien auf der gleichen RES in einer SEK fuehr das zu Problemen    
     update bde_pd_prod pd
      set pd.menge_a = nvl(v_prod_pa.menge_a, 0) + in_menge,
          pd.abfuell_ist = nvl(pd.abfuell_ist, 0) + in_akt_abfuell
      where pd.sid = in_sid and
            pd.vorg_typ = 'PA' and
            pd.firma_nr = in_firma_nr and
            pd.leitzahl = in_leitzahl and
            pd.fa_ag = in_fa_ag and
            nvl(pd.fa_upos, 0) = nvl(in_fa_upos, 0) and
            pd.res_id = in_res_id and
            -- pd.prod_beginn <= in_sysdate and -- 26.02.2017   3.5.10.1    (-AG-) 
            pd.prod_beginn = v_prod_pa.prod_beginn and -- 26.02.2017   3.5.10.1    (-AG-) 
            ((pd.prod_ende is NULL) or
             (pd.prod_ende >= in_sysdate));
    if sql%rowcount != 1 then
      v_err_nr := 20;
      v_err_text := 'Fehler beim Eintragen der Produktionsmeldung: ' || in_leitzahl || '/' || in_fa_ag || '/' || in_fa_upos || ' Eintrag nicht eindeutig.';
      raise v_error;
    end if;
  end if;

    -- Update des Aktuelle Zustands des Arbeitsgangs
  update bde_fa_auftrag fa
     set --fa.res_id = in_res_id,
         fa.lhm_anz_ist = nvl(fa.lhm_anz_ist, 0) + 1,
         -- -AG- Losgroesse
         fa.ag_los_ist_mg = nvl(fa.ag_los_ist_mg, 0) + 1,
         fa.ag_ist_mg = nvl(fa.ag_ist_mg, 0) + nvl(in_menge, 0),                     -- Mengen addieren
         fa.prod_zeit_ist = nvl(fa.prod_zeit_ist, 0) + in_pp_zeit
     where fa.sid = in_sid and
           fa.leitzahl = in_leitzahl and
           fa.fa_ag = in_fa_ag and
           nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);
exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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
end bde_pd_prod_p_pa_u;
/



-- sqlcl_snapshot {"hash":"19fa74212bf7e00c175226da6468c139bc04c17e","type":"PROCEDURE","name":"BDE_PD_PROD_P_PA_U","schemaName":"DIRKSPZM32","sxml":""}