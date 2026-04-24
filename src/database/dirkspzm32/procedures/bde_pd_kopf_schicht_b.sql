create or replace procedure dirkspzm32.bde_pd_kopf_schicht_b
/*
In dieser Procedure werden Kopfdaten einer Produktionschicht in die Produktionsdaten geschrieben.
Aus den PZM-Schichtdaten wird versucht die Schicht zu finden um damit die Schichtanmeldung im BDE zu aktualisieren
Die Tabellen wie isi_resource_zust_akt werden aktuallisiert 

-- Die Procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden hier nicht erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_pers_nr         in isi_user.pers_nr                  Personalnummer des Mitarbeiters
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER

@see bde_pd_kopf_insert In dieser Procedure wird ein neuer Eintrag in den Kopfdaten einer Produktionschicht für eine maschine erstellt. 
@see bde_pd_kopf_schicht_e In dieser Procedure werden Kopfdaten einer Produktionschicht in den Produktionsdaten abgeschlossen.
*/ (
    in_sid         in isi_sid.sid%type,
    in_firma_nr    in isi_firma.firma_nr%type,
    in_res_id      in isi_resource.res_id%type,
    in_pers_nr     in isi_user.pers_nr%type,
    in_ls_login_id in isi_user.login_id%type
) is
  --------------------------------------------------------------------------------------------------------------------
  -- 
  --------------------------------------------------------------------------------------------------------------------
    v_sysdate     date;                                            -- Speichern der Zeit (Jetzt) für alle Tabelleneinträge
    v_schicht_tag date;                                          -- Schichttag
    v_schicht     pzm_schichtarten%rowtype;            -- Schichtdaten
    v_schicht_ok  integer;                                 -- 1 wenn OK
    v_pd_k        bde_pd_kopf%rowtype;                     -- Schichtkopfdaten
    v_pd_k_c      integer;                                 -- Wieviele Einträge gibt es, die passen
    v_found       boolean;                                 -- Daten gefunden ?
  -- debug: v_date              varchar2(20);
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr      number;
    v_err_text    varchar2(255);

  -- Cursor zur Bestimmung (Anzahl der möglichen Einträge)
    cursor c_pd_k_c is
    select
        count(pers_nr)
    from
        bde_pd_kopf pd_k_c
    where
            pd_k_c.sid = in_sid
        and pd_k_c.firma_nr = in_firma_nr
        and pd_k_c.res_id = in_res_id
        and
--            pd_k_c.sa_beginn <= v_schicht.sa_beginn and
         pd_k_c.sa_ende > v_schicht.sa_beginn
    group by
        pd_k_c.res_id;

  -- Cursor zum Lesen der Einträge
    cursor c_pd_k is
    select
        *
    from
        bde_pd_kopf pd_k
    where
            pd_k.sid = in_sid
        and pd_k.firma_nr = in_firma_nr
        and pd_k.res_id = in_res_id
        and pd_k.pers_nr = in_pers_nr
        and
--            pd_k.sa_beginn <= v_schicht.sa_beginn and
         pd_k.sa_ende > v_schicht.sa_beginn;

begin
    v_sysdate := sysdate;                           -- Speichern der Zeit (Jetzt) für alle Tabelleneinträge
    v_schicht_tag := null;                          -- Wird in der Funktion ermittelt
    v_schicht.sa_kurzname := null;

  -- Vesuche mit den bekannten Daten eine Schicht zu finden
    v_schicht_ok := get_schicht_daten(in_pers_nr, v_sysdate, v_schicht_tag, v_schicht.sa_kurzname, v_schicht.sa_beginn,
                                      v_schicht.sa_ende, v_schicht.sa_std_pro_tag);

  -- Keine Daten gefunde, bzw. nur Standardschicht
    if v_schicht_ok = 0
    or nvl(v_schicht.sa_kurzname, '') = nvl(
        pzm_utils.get_standard_schicht_by_pers_nr(in_pers_nr),
        ''
    ) then
        v_schicht.sa_kurzname := null;
        v_schicht.sa_beginn := v_sysdate;
        v_schicht.sa_ende := v_sysdate;
    end if;

    open c_pd_k_c;               -- Lesen der Einträge
    fetch c_pd_k_c into v_pd_k_c;
    close c_pd_k_c;
    v_found := false;
    if v_pd_k_c = 1 then
        open c_pd_k;              -- Lesen des Eintrags
        fetch c_pd_k into v_pd_k;
        v_found := c_pd_k%found;  -- Merken ob einer gefunden wo auch die Pers_nr OK ist
        close c_pd_k;
    end if;

    if nvl(v_pd_k_c, 0) != 1
    or  -- Nicht nur einer der von der Zeit passen kann
     v_found = false then       -- oder dieser ist nicht für diese Personalnummer
    -- Maschinenstatus neu setzen

    --bde_pd_status_u(in_sid, in_firma_nr, in_res_id, in_ls_login_id, v_sysdate);
        res_status.res_status_unterb(in_sid, in_firma_nr, in_res_id, in_ls_login_id, v_sysdate);
        bde_pd_kopf_insert(in_sid, in_firma_nr, in_res_id, in_pers_nr, v_sysdate,
                           in_ls_login_id);
    elsif
        nvl(v_pd_k_c, 0) = 1
        and v_found = true
    then
        v_sysdate := v_pd_k.pd_kopf_beginn;     -- Ursprünglichen Anfang merken
    end if;

  -- debug: v_date := to_char(v_sysdate, 'dd.mm.yyyy hh24:mi:ss');
    update bde_pd_kopf
    set
        sa_kurzname = v_schicht.sa_kurzname,
        sa_beginn = v_schicht.sa_beginn,
        sa_ende = v_schicht.sa_ende,
        pd_kopf_beginn = v_sysdate,
        pd_kopf_ende = null
    where
            sid = in_sid
        and firma_nr = in_firma_nr
        and res_id = in_res_id
        and pers_nr = in_pers_nr
        and pd_kopf_beginn = v_sysdate;
  -- Jetzt noch im aktuelle Zustand der Maschine eintragen
    update isi_resource_zust_akt
    set
        pers_nr = in_pers_nr
    where
            sid = in_sid
        and res_id = in_res_id;

    v_err_nr := null;
    v_err_text := null;
    update bde_fa_auftrag t
    set
        t.mde_ist_mg_t = 0,
        t.mde_ist_mg_b_t = 0,
        t.mde_ist_mg_schrott_t = 0,
        t.mde_ist_mg_ruesten_t = 0,
        t.mde_micro_stop_t = 0
    where
            t.res_id = in_res_id
        and t.leitzahl = (
            select
                leitzahl
            from
                isi_resource_zust_akt
            where
                    sid = in_sid
                and res_id = in_res_id
        );

    commit;
    return;
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

end bde_pd_kopf_schicht_b;
/


-- sqlcl_snapshot {"hash":"f9de79a832951983de6d9891299f9c9e576a23a0","type":"PROCEDURE","name":"BDE_PD_KOPF_SCHICHT_B","schemaName":"DIRKSPZM32","sxml":""}