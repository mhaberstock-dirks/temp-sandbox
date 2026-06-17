create or replace 
procedure DIRKSPZM32.bde_pd_kopf_schicht_e
/*
In dieser Procedure werden Kopfdaten einer Produktionschicht in den Produktionsdaten abgeschlossen.
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

@see bde_pd_kopf_schicht_b In dieser Procedure werden Kopfdaten einer Produktionschicht in die Produktionsdaten geschrieben.
*/
 (in_sid         in isi_sid.sid%type,
  in_firma_nr    in isi_firma.firma_nr%type,
  in_res_id      in isi_resource.res_id%type,
  in_pers_nr     in isi_user.pers_nr%type,
  in_ls_login_id in isi_user.login_id%type) is

  v_sysdate   date;                                            -- Speichern der Zeit (Jetzt) für alle Tabelleneinträge
  v_schicht_tag date;                                          -- Zugehoeriger Tag (Schicht)
  v_sysdate_m date;                                            -- Mittelwert aus anfang und Ende bilden
  v_pd_k              bde_pd_kopf%rowtype;                     -- Schichtkopfdaten
  v_found             boolean;                                 -- Daten gefunden ?
  v_schicht           pzm_schichtarten%rowtype;                -- Schichtdaten
  v_schicht_ok        integer;                                 -- 1 wenn OK

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  -- Cursor zum Lesen des Eintrags
  CURSOR c_pd_k is
    SELECT *
      FROM bde_pd_kopf pd_k
      WHERE pd_k.sid = in_sid and
            pd_k.firma_nr = in_firma_nr and
            pd_k.res_id = in_res_id and
            pd_k.pd_kopf_ende is NULL;

begin
  v_sysdate := sysdate;                           -- Speichern der Zeit (Jetzt) für alle Tabelleneinträge
  v_sysdate_m := sysdate;                         -- Speichern der Zeit (Jetzt) für alle Tabelleneinträge
  v_schicht_tag := NULL;                          -- Wird in der Funktion ermittelt

  v_err_nr := NULL;
  v_err_text := NULL;
  OPEN c_pd_k;              -- Lesen des Eintrags
  FETCH c_pd_k into v_pd_k;
  v_found := c_pd_k%FOUND;  -- Merken ob einer gefunden wo auch die Pers_nr OK ist
  CLOSE c_pd_k;

  if v_found then
    if v_pd_k.sa_kurzname is NULL then
      -- Noch keine Schicht gefunden dann mit dem Mittelwert azus Beginn und Ende suchen
      v_sysdate_m := v_sysdate - ((v_sysdate - v_pd_k.pd_kopf_beginn) / 2);
      -- Vesuche mit den bekannten Daten eine Schicht zu finden
      v_schicht_ok := get_schicht_daten(in_pers_nr, v_sysdate_m, v_schicht_tag, v_schicht.sa_kurzname, v_schicht.sa_beginn,
                                        v_schicht.sa_ende, v_schicht.sa_std_pro_tag);
      if v_schicht_ok = 0 or
         nvl(v_schicht.sa_kurzname, '') = nvl(pzm_utils.get_standard_schicht_by_pers_nr(in_pers_nr), '')  then
        v_schicht.sa_kurzname := NULL;
        v_schicht.sa_beginn := v_pd_k.sa_beginn;
        v_schicht.sa_ende  := v_sysdate;
      end if;
    else
      v_schicht.sa_kurzname := v_pd_k.sa_kurzname;  -- Daten aus gespeicherten übernehmen
      if v_pd_k.sa_beginn is NULL then
        v_schicht.sa_beginn := v_sysdate;
      else
        v_schicht.sa_beginn := v_pd_k.sa_beginn;
      end if;
      v_schicht.sa_ende := v_pd_k.sa_ende;
    end if;
    update bde_pd_kopf pd_k
      set pd_k.sa_kurzname = v_schicht.sa_kurzname,
          pd_k.sa_beginn = v_schicht.sa_beginn,
          pd_k.sa_ende = v_schicht.sa_ende,
          pd_kopf_ende = v_sysdate
       WHERE sid = in_sid and
             firma_nr = in_firma_nr and
             res_id = in_res_id and
             pd_kopf_ende is NULL;
    -- Jetzt noch im aktuelle Zustand der Maschine eintragen
    update isi_resource_zust_akt
       set pers_nr = NULL
       where sid = in_sid and
             res_id = in_res_id;

    -- DTs, E20BDE-15, 20191022
    update bde_pd_kopf_ma
      set pd_kopf_ende = v_sysdate
    where pers_nr = in_pers_nr
      and pd_kopf_ende is NULL
      and pd_kopf_beginn is not NULL;

  else
      v_err_nr := 10;
      v_err_text := 'Kann Schichtdaten für aktuelle Schicht nicht lesen.';
      -- raise v_error;
  end if;
  update isi_resource_zust_akt
     set pers_nr = NULL
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
end bde_pd_kopf_schicht_e;
/



-- sqlcl_snapshot {"hash":"1f4c9c18963e8fe72c642649d2f5f6074d4f752c","type":"PROCEDURE","name":"BDE_PD_KOPF_SCHICHT_E","schemaName":"DIRKSPZM32","sxml":""}