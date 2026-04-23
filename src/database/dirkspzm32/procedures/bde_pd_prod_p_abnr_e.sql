create or replace procedure dirkspzm32.bde_pd_prod_p_abnr_e
/*
In dieser Procedure wird Produktion Auftrag Ende gebucht

-- Die procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden hier nicht erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_abnr            in bde_fa_auftrag.abnr               Fertigungsauftrag-ID
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_akt_term        in isi_arbeitsplatz.ip_name          Name der Arbeitstation, von der gebucht wird          
@param in_menge_a         in bde_pd_prod.Menge_a               Menge A-Qualität Wenn alle Mengen NULL oder 0, dann werden diese aus den Bucungen in der BDE_PD_PROD ermittelt
@param in_menge_b         in bde_pd_prod.Menge_b               Menge B-Qualität - 2te Wahl
@param in_schrott         in bde_pd_prod.schrott               Schrottmenge
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER

*/ (
    in_sid         in isi_sid.sid%type,
    in_firma_nr    in isi_firma.firma_nr%type,
    in_abnr        in bde_fa_auftrag.abnr%type,
    in_res_id      in isi_resource.res_id%type,
    in_sysdate     date,
    in_menge_a     in bde_pd_prod.menge_a%type,
    in_menge_b     in bde_pd_prod.menge_b%type,
    in_schrott     in bde_pd_prod.schrott%type,
    in_ls_login_id in isi_user.login_id%type
) is
  --------------------------------------------------------------------------------------------------------------------
  -- In dieser Procedure wird Produktion Auftrag Ende gebucht
  --------------------------------------------------------------------------------------------------------------------

    v_anz_fas    number;                 --  Merken ob nur von Ruesten nach Produktion geschaltet wurde; Dann keien zus. Resource
    v_fa_auftrag bde_fa_auftrag%rowtype;            --  Fertigungsauftrag

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  -- -AG- Beachtung der Losmengen (neu) R3.4.11
  -- -AG- Speichern, welche Mengen an den Host geschickt wurden
    v_error exception;
    v_err_nr     number;
    v_err_text   varchar2(255);

	-- Holen des Auftrags genau für diese Leitzahl an dieser Maschine
    cursor c_bde_fa_auftrag_anz is
    select
        count(fa_a.abnr)
    from
        bde_fa_auftrag fa_a
    where
            fa_a.sid = in_sid
        and fa_a.firma_nr = in_firma_nr
        and fa_a.abnr = in_abnr;

    cursor c_fa_auftrag is
    select
        *
    from
        bde_fa_auftrag fa
    where
            fa.sid = in_sid
        and fa.abnr = in_abnr;

begin
    v_anz_fas := 0;
    open c_bde_fa_auftrag_anz;
    fetch c_bde_fa_auftrag_anz into v_anz_fas;
    close c_bde_fa_auftrag_anz;
    if nvl(v_anz_fas, 0) != 1 then
        v_err_nr := 1;
        v_err_text := 'Dieser FA Auftrag :'
                      || in_abnr
                      || ' hat '
                      || to_char(nvl(v_anz_fas, 0))
                      || ' Einträge. Erlaubt sind 1.';

        raise v_error;
    end if;

    open c_fa_auftrag;
    fetch c_fa_auftrag into v_fa_auftrag;
    close c_fa_auftrag;

  -- Call the procedure
    bde_pd_prod_p_ag_e(in_sid,                 -- => :in_sid,
     in_firma_nr,            -- => :in_firma_nr,
     v_fa_auftrag.leitzahl,  -- => :in_leitzahl,
     v_fa_auftrag.fa_ag,     -- => :in_fa_ag,
     v_fa_auftrag.fa_upos,   -- => :in_fa_upos,
                       in_res_id,              -- => :in_res_id,
                        in_sysdate,             -- => :in_sysdate,
                        in_menge_a,             -- => :in_menge_a,
                        in_menge_b,             -- => :in_menge_b,
                        in_schrott,             -- => :in_schrott,
                       in_ls_login_id);        -- => :in_ls_login_id);
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

end bde_pd_prod_p_abnr_e;
/


-- sqlcl_snapshot {"hash":"4a4f675f46d51b671e41d2f6a4be85b0ef825c7a","type":"PROCEDURE","name":"BDE_PD_PROD_P_ABNR_E","schemaName":"DIRKSPZM32","sxml":""}