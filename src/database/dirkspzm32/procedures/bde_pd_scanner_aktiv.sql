create or replace procedure dirkspzm32.bde_pd_scanner_aktiv
/*
Trägt den User mit der Login_ID in dieser Tabelle ein, und wird für die Scanneranmeldung über BDE-Terminal benötigt

-- Die procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden erzeugt

@param in_ip_adresse      in isi_term_res.ip_adresse           IP oder Name des Terminals
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER
@param in_ls_login_name   in isi_term_res.ls_login_name        Loginname des Mitarbeiters
*/ (
    in_ip_adresse    in isi_term_res.ip_adresse%type,
    in_ls_login_id   in isi_user.login_id%type,
    in_ls_login_name in isi_term_res.ls_login_name%type
) is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
begin
    v_err_nr := null;

  -- Namen und Login ID in die Tabelle eintragen !!
    update isi_term_res term
    set
        term.ls_login_id = in_ls_login_id,
        term.ls_login_name = in_ls_login_name
    where
        term.ip_adresse = in_ip_adresse;

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

end bde_pd_scanner_aktiv;
/


-- sqlcl_snapshot {"hash":"09bd81f7ef40717873cc984f2c1708586a57f15c","type":"PROCEDURE","name":"BDE_PD_SCANNER_AKTIV","schemaName":"DIRKSPZM32","sxml":""}