create or replace 
procedure DIRKSPZM32.bde_pd_lte_fertig
/*
In dieser Procedure wird eine LTE einer Resource (Maschine) als Fertig befüllt gebucht.
Die Tabellen wie isi_resource_zust_akt werden aktuallisiert und in der LTE in der tabelle LVS_LTE wird der Staus aud 'BF' = Befüllen gesetzt
Zusätzlich wird für die LTE ein Etikett erzeugt, wenn ein gültiger Drucker übergeben wird

-- Die Procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden erzeugt

@param in_sid             in isi_sid.sid
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER
@param in_lte_id          in lvs_lte.lte_id                    LTE_ID der Palette
@param in_drucker in pe_drucker_cfg.drucker_name               Druckername zum Drucken des LTE-Etikets

@see bde_pd_lte_delete In dieser Procedure wird eine LTE gelöscht und dabei die Tabelle LVS_LGR aktualisiert
@see bde_pd_lte_aktiv In dieser Procedure wird eine LTE eine Resource (Maschine) als aktuelle zum befüllen zugeordnet.
*/
 (in_sid in isi_sid.sid%type,
  in_res_id in isi_resource.res_id%type,
  in_ls_login_id in isi_user.login_id%type,
  in_lte_id in lvs_lte.lte_id%type,
  in_drucker in pe_drucker_cfg.drucker_name%type default NULL
  )  is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  /*
  -------------------------------------------------------------------------------------------------------
  -- -AG- Erweiterung automatischen LHM druchen aus BDE wenn Palette abgeschlossen wird und STATUS 'SD'
  --      in LHM
  -------------------------------------------------------------------------------------------------------
  */
  v_res       isi_resource%rowtype;
  v_drucker   pe_drucker_cfg%rowtype;
  v_lhm_id    lvs_lhm.lhm_id%type;
  v_kunde_nr  lvs_lam.kunden_nr%type;

  CURSOR c_lhm is
    select t.lhm_id, l.kunden_nr
      from lvs_lhm t,
           lvs_lam l
     where t.lte_id = in_lte_id
       and t.lhm_eti_druck_status = 'SD'
       and t.lhm_id = l.lhm_id
    order by l.lhm_lfd_nr;
begin
  v_err_nr := NULL;

  update lvs_lte lte
     set lte.lte_status = 'BF'
   where lte.sid = in_sid and
         lte.lte_id = in_lte_id;

  update isi_resource_zust_akt res
     set res.lte_id = NULL               -- In aktueller Maschienenzustan SPEICHERN
   where res.sid = in_sid and
         res.res_id = in_res_id and
         res.lte_id = in_lte_id;
  commit;


  if in_drucker is not NULL -- -AG- Drucker ist übergeben und vorhanden
  and isi_p_base.get_resource(in_sid, in_res_id, v_res)
  and print_allg.get_drucker(v_res.sid,             -- in_sid             in pe_drucker_cfg.sid%type,
                             v_res.firma_nr,        -- in_firma_nr        in pe_drucker_cfg.firma_nr%type,
                             in_drucker,            -- in_drucker_name    in pe_drucker_cfg.drucker_name%type,
                             v_drucker)             -- io_drucker         in out pe_drucker_cfg%rowtype)
  then
    OPEN c_lhm;
    LOOP
      FETCH c_lhm into v_lhm_id, v_kunde_nr;
      EXIT when c_lhm%NOTFOUND;
      lvs_p_lte.lvs_lhm_drucken(v_lhm_id, v_kunde_nr, in_drucker);
    END LOOP;
    CLOSE c_lhm;
  end if;
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
end bde_pd_lte_fertig;
/



-- sqlcl_snapshot {"hash":"78a23d8a5b420e03f37d161e47b087c7f375890b","type":"PROCEDURE","name":"BDE_PD_LTE_FERTIG","schemaName":"DIRKSPZM32","sxml":""}