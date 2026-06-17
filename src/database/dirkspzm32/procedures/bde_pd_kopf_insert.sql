create or replace 
procedure DIRKSPZM32.bde_pd_kopf_insert
/*
In dieser Procedure wird ein neuer Eintrag in den Kopfdaten einer Produktionschicht für eine maschine erstellt.
Damit wird der Verantwortliche für die Produktion ab diesen Zeitpunkt für die Maschine festgelegt

-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden in der Methode nicht erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_res_id          in isi_resource.res_id                RES_ID der Maschine auf der Gebucht werden soll
@param in_pers_nr         in isi_user.pers_nr                   Personalnummer des Mitarbeiters
@param in_sysdate         in date                               Buchungsdatum (Schichtstart)
@param in_ls_login_id     in isi_user.login_id                  Login_ID des angemeldeten USER

@see bde_pd_kopf_schicht_b In dieser Procedure werden Kopfdaten einer Produktionschicht in die Produktionsdaten geschrieben. 
*/
(in_sid         in isi_sid.sid%type,
 in_firma_nr    in isi_firma.firma_nr%type,
 in_res_id      in isi_resource.res_id%type,
 in_pers_nr     in isi_user.pers_nr%type,
 in_sysdate     in date,
 in_ls_login_id in isi_user.login_id%type) is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_res       isi_resource%rowtype;             -- Stamdaten der Resource
  v_personal  pzm_personal%rowtype;     -- Details z.B. Kostenstelle des MA

begin
  v_err_nr := NULL;
  v_err_text := NULL;

  if not isi_p_base.get_resource(in_sid, in_res_id, v_res)
  then
    v_res := NULL;
  end if;

  if not pzm_p_base.get_personal(in_pers_nr, v_personal)
  then
    v_personal := NULL;
  end if;

  insert into bde_pd_kopf
    values (in_sid,
            in_firma_nr,
            in_res_id,
            NULL,
            in_sysdate,
            in_sysdate,
            in_pers_nr,
            in_sysdate,
            NULL,
            in_ls_login_id,
            v_res.res_kst,
            v_personal.pers_abt_id);

exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
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
end bde_pd_kopf_insert;
/



-- sqlcl_snapshot {"hash":"07bdf6edcdb4534ee555af8a8c51c67b8ef89b02","type":"PROCEDURE","name":"BDE_PD_KOPF_INSERT","schemaName":"DIRKSPZM32","sxml":""}