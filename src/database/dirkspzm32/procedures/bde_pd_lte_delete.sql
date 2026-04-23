create or replace procedure dirkspzm32.bde_pd_lte_delete
/*
In dieser Procedure wird eine LTE gelöscht und dabei die Tabelle LVS_LGR aktualisiert

-- Die Procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden erzeugt

@param in_sid             in isi_sid.sid
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER
@param in_lte_id          in lvs_lte.lte_id                    LTE_ID der Palette

@see bde_pd_lte_aktiv In dieser Procedure wird eine LTE eine Resource (Maschine) als aktuelle zum befüllen zugeordnet.
@see bde_pd_lte_fertig In dieser Procedure wird eine LTE einer Resource (Maschine) als Fertig befüllt gebucht.
*/ (
    in_sid         in isi_sid.sid%type,
    in_lte_id      in lvs_lte.lte_id%type,
    in_ls_login_id in isi_user.login_id%type
) is

    v_lte      lvs_lte%rowtype;                -- Daten aus der LTE

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
    v_found    boolean;
    cursor c_lvs_lte is
    select
        *
    from
        lvs_lte
    where
            lvs_lte.sid = in_sid
        and lvs_lte.lte_id = in_lte_id;

begin
    v_err_nr := null;
    open c_lvs_lte;
    fetch c_lvs_lte into v_lte;                  -- Daten lesen
    v_found := c_lvs_lte%found;
    close c_lvs_lte;
    delete lvs_lte lte
    where
            lte.sid = in_sid
        and lte.lte_id = in_lte_id;
  -- AG 2019-01-08 Updatereihenfolge geaendert (DeadLock)
    if v_found then                      -- LTE Gefunden
        update lvs_lgr lgr
        set
            lgr.lgr_akt_te = lgr.lgr_akt_te - 1,
            lgr.lgr_akt_kg = nvl(lgr.lgr_akt_kg, 0) - nvl(v_lte.lte_akt_kg, 0)
        where
                lgr.sid = v_lte.sid
            and lgr.firma_nr = v_lte.firma_nr
            and lgr.lgr_platz = v_lte.lgr_platz;

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

end bde_pd_lte_delete;
/


-- sqlcl_snapshot {"hash":"38dfcb994f8c0444d6efafba9dfa477b712ce838","type":"PROCEDURE","name":"BDE_PD_LTE_DELETE","schemaName":"DIRKSPZM32","sxml":""}