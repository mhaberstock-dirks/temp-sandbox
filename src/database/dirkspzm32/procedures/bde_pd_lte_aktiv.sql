create or replace 
procedure DIRKSPZM32.bde_pd_lte_aktiv
/*
In dieser Procedure wird eine LTE eine Resource (Maschine) als aktuelle zum befüllen zugeordnet.
Die Tabellen wie isi_resource_zust_akt werden aktuallisiert und in der LTE in der tabelle LVS_LTE wird der Staus aud 'B' = Befüllen gesetzt

-- Die Procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden erzeugt

@param in_sid             in isi_sid.sid
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER
@param in_lte_id          in lvs_lte.lte_id                    LTE_ID der Palette

@see bde_pd_lte_delete In dieser Procedure wird eine LTE gelöscht und dabei die Tabelle LVS_LGR aktualisiert
@see bde_pd_lte_fertig In dieser Procedure wird eine LTE einer Resource (Maschine) als Fertig befüllt gebucht.
*/
(in_sid in isi_sid.sid%type,
 in_res_id in isi_resource.res_id%type,
 in_ls_login_id in isi_user.login_id%type,
 in_lte_id in lvs_lte.lte_id%type
 )  is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_lte       lvs_lte%rowtype;

begin
  v_err_nr := NULL;

  if not lvs_p_base.get_lte(in_lte_id, v_lte)
  then
    v_err_nr := 10;
    v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
    raise v_error;
  else
    if v_lte.lte_status like ('%T')
    or v_lte.lte_status like ('%D')
    then
      v_err_nr := 15;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_W_TRANSPORTIERT, in_lte_id);
      raise v_error;
    end if;
  end if;

  update lvs_lte lte
     set lte.lte_status = 'B'
   where lte.sid = in_sid and
         lte.lte_id = in_lte_id;

  update isi_resource_zust_akt
     set lte_id = in_lte_id                 -- In aktueller Maschienenzustan SPEICHERN
   where sid = in_sid and
         res_id = in_res_id;
  commit;

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
end bde_pd_lte_aktiv;
/



-- sqlcl_snapshot {"hash":"72fa9d3f9137e8d7fbb3ec918859a7a677c43bfc","type":"PROCEDURE","name":"BDE_PD_LTE_AKTIV","schemaName":"DIRKSPZM32","sxml":""}