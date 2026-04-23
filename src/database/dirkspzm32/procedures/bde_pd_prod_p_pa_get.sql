create or replace procedure dirkspzm32.bde_pd_prod_p_pa_get
/*
In dieser Procedure werden die Mengen der PA Sätze einen FA's auf einer Resource bis zum in_sysdate ermittelt. 
Die Werte werden in den OUT-Parametern zurückgegeben
Der PA-Satz ist die Zusammenfassung aller Produktionssätzen PP die Zusammenhängen Produzuert wurden.
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden hier nicht erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_leitzahl        in bde_fa_auftrag.leitzahl           Fertigungsauftrag
@param in_fa_ag           in bde_fa_auftrag.fa_ag              Arbeitsgang
@param in_fa_upos         in bde_fa_auftrag.fa_upos            Unterposition bzw. Split
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param out_menge_a       out bde_fa_auftrag.ag_ist_mg          Rückgabe der A-Qualätät
@param out_menge_b       out bde_fa_auftrag.ag_ist_mg          Rückgabe der B-Qualätät
@param out_schrott       out bde_fa_auftrag.ag_ist_mg          Rückgabe der Schrottmenge
@param in_sysdate         in date                              bis zu dieseem Datum auswerten
*/ (
    in_sid      in isi_sid.sid%type,
    in_firma_nr in isi_firma.firma_nr%type,
    in_leitzahl in bde_fa_auftrag.leitzahl%type,
    in_fa_ag    in bde_fa_auftrag.fa_ag%type,
    in_fa_upos  in bde_fa_auftrag.fa_upos%type,
    in_res_id   in isi_resource.res_id%type,
    out_menge_a out bde_fa_auftrag.ag_ist_mg%type,
    out_menge_b out bde_fa_auftrag.ag_ist_mg%type,
    out_schrott out bde_fa_auftrag.ag_ist_mg%type,
    in_sysdate  in date
) is

    v_prod_pa  bde_pd_prod%rowtype;      -- Hole den aktuellen Produktionssatz zu diesem
    v_found    boolean;                  -- Daten gefunden ???

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
    cursor c_bde_pd_prod is
    select
        *
    from
        bde_pd_prod pp
    where
            pp.sid = in_sid
        and pp.vorg_typ = 'PA'
        and pp.firma_nr = in_firma_nr
        and pp.leitzahl = in_leitzahl
        and pp.fa_ag = in_fa_ag
        and nvl(pp.fa_upos, 0) = nvl(in_fa_upos, 0)
        and pp.res_id = in_res_id
        and pp.prod_beginn <= in_sysdate
        and ( ( pp.prod_ende is null )
              or ( pp.prod_ende >= in_sysdate ) );

begin
  -- Erst mal kein Fehler
    v_err_nr := null;
    v_err_text := null;
    out_menge_a := 0;   -- Initialisiere Menge A-Qualität
    out_menge_b := 0;   -- Initialisiere Menge B-Qualität
    out_schrott := 0;   -- Initialisiere Menge Schrott

    open c_bde_pd_prod;                   -- Den Entsprechenden Summensatz der Produktion Suchen
    fetch c_bde_pd_prod into v_prod_pa;   -- Lesen der Daten
    v_found := c_bde_pd_prod%found;       -- Richtige Daten gefunden
    close c_bde_pd_prod;                  -- Cursor wider zu
    if v_found then                       -- Daten gefunden !!
        out_menge_a := v_prod_pa.menge_a;   -- Aktuelle Menge A-Qualität
        out_menge_b := v_prod_pa.menge_b;   -- Aktuelle Menge B-Qualität
        out_schrott := v_prod_pa.schrott;   -- Aktuelle Menge Schrott
    end if;

exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
    when v_error then  -- Update 2011 show Exception Source Line
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
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
end bde_pd_prod_p_pa_get;
/


-- sqlcl_snapshot {"hash":"49ac703c1db0936572476acf29254669b0b71704","type":"PROCEDURE","name":"BDE_PD_PROD_P_PA_GET","schemaName":"DIRKSPZM32","sxml":""}