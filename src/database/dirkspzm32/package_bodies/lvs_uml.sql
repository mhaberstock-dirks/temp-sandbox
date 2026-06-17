create or replace 
package body DIRKSPZM32.LVS_UML is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);
  -------------------------------------------------------------------------------------------------------

  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

  procedure c_res_lte_erz_transp_gesp(in_sid              in lvs_lte.sid%type,
                                      in_firma_nr         in lvs_lte.firma_nr%type,
                                      in_lte_id           in lvs_lte.lte_id%type,
                                      in_ziel_lgr_platz   in lvs_lte.lgr_platz%type,
                                      in_login_id         in lvs_lte.res_login_id%type,
                                      in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
                                      in_prio             in isi_transport.prio%type) is
    v_lte    lvs_lte%rowtype;
    v_result number;

    v_transport_gruppe isi_transport.transport_gruppe%type;
    v_transp_id        isi_transport.transp_id%type;

  begin
    if not lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(in_lte_id, '(null)')));
      -- raise_isi_error(10, 'LTE ID ' || nvl(in_lte_id, '(null)') || ' konnte nicht gefunden werden.');
    end if;

    v_result := lvs_ausl.lvs_lte_reserv_user_ziel(in_sid,
                                                  in_firma_nr,
                                                  -2, -- vorgang_id (-2 = Konstante für Umlgaerungsreservierung)
                                                  -2, -- auf_id
                                                  in_lte_id,
                                                  null,
                                                  in_login_id,
                                                  in_ziel_lgr_platz);
    if v_result != 0
    then
      raise_isi_error(20, c.decode_function_fehler(v_result));
    end if;

    v_transport_gruppe := 0;
    v_result := lvs_transport.lvs_gesperrter_transp_lte (in_sid,
                                                         in_firma_nr,
                                                         in_modul_erzeuger,
                                                         null,
                                                         c.C_FALSE,
                                                         'U',
                                                         in_login_id,
                                                         null,
                                                         null,
                                                         in_prio,
                                                         0,
                                                         0,
                                                         0,
                                                         v_lte.lgr_platz,
                                                         in_ziel_lgr_platz,
                                                         in_lte_id,
                                                         null,
                                                         c.C_FALSE,
                                                         null,
                                                         null,
                                                         null,
                                                         null,
                                                         null,
                                                         v_transport_gruppe,
                                                         v_transp_id);

    if v_result != 0
    then
      raise_isi_error(30, c.decode_function_fehler(v_result));
    end if;

    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end;

  procedure c_res_lhm_erz_transp_gesp(in_sid            in lvs_lhm.sid%type,
                                      in_firma_nr       in lvs_lhm.firma_nr%type,
                                      in_lhm_id         in lvs_lhm.lhm_id%type,
                                      in_neu_lhm_name   in lvs_lhm.lhm_name%type,
                                      in_ziel_lgr_platz in lvs_lhm.lgr_platz%type,
                                      in_login_id       in lvs_lte.res_login_id%type,
                                      in_modul_erzeuger in isi_transport.modul_erzeuger%type,
                                      in_prio           in isi_transport.prio%type) is
    v_lhm                     lvs_lhm%rowtype;
    v_q_lte                   lvs_lte%rowtype;
    v_komm_lte                lvs_lte%rowtype;

    v_lhm_cfg                 lvs_lhm_cfg%rowtype;
    v_charge                  lvs_charge%rowtype;
    v_lam                     lvs_lam%rowtype;

    v_komm_neu_lte_id         lvs_lte.lte_id%type;
    v_komm_direkt_moegl       lvs_lgr_ort.komm_direkt_moegl%type;
    v_komm_ausweich_lgr_platz lvs_lgr_ort.komm_ausweich_lgr_platz%type;
    v_komm_picken_moegl       lvs_lgr_ort.komm_picken_moegl%type;
    v_komm_neu_lte_lgr_platz  lvs_lte.lgr_platz%type;

    v_result                  number;
    v_transport_gruppe        isi_transport.transport_gruppe%type;
    v_transp_id               isi_transport.transp_id%type;
  begin
    if not lvs_p_base.get_lhm(in_lhm_id, v_lhm)
    then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_LHM_ID_FEHLT, nvl(in_lhm_id, '(null)')));
      -- raise_isi_error(10, 'Für die LHM ID ' || nvl(in_lhm_id, '(null)') || ' konnten keine Daten gefunden werden.');
    end if;

    if not lvs_p_base.get_lte(v_lhm.lte_id, v_q_lte)
    then
      raise_isi_error(20, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(v_lhm.lte_id, '(null)')));
      -- raise_isi_error(20, 'Für die LTE ID ' || nvl(v_lhm.lte_id, '(null)') || ' konnten keine Daten gefunden werden.');
    end if;

    if v_q_lte.lte_name = c.KeineLTE
    then
      -- Umlagern der ganzen LTE mit evtl. Änderung des LHM Typs (wenn in_neu_lhm_name != null)
      update lvs_lhm t
         set t.komm_neu_lhm_name = in_neu_lhm_name
       where t.lhm_id = in_lhm_id;

      c_res_lte_erz_transp_gesp(in_sid, in_firma_nr, v_q_lte.lte_id, in_ziel_lgr_platz, in_login_id,
                                in_modul_erzeuger, in_prio);
      return;
    else
      -- Prüfen, ob von der Quelle etwas abkommissioniert werden kann
      if not lvs_p_base.get_lgr_komm_info(v_q_lte.lgr_platz, v_komm_direkt_moegl, v_komm_ausweich_lgr_platz,
                                          v_komm_picken_moegl, v_komm_neu_lte_lgr_platz)
      then
        raise_isi_error(30, LC.ec_p1(LC.O_TP1_LGR_PLATZ_O_KOMM, nvl(v_q_lte.lgr_platz, '(null)')));
        --raise_isi_error(30, 'Für den Lagerplatz ' || nvl(v_q_lte.lgr_platz, '(null)') ||
        --                    ' konnten keine Kommissionierdaten gefunden werden.');
      end if;

      if (v_komm_direkt_moegl = 'T' or v_komm_picken_moegl = 'T')
      and v_komm_neu_lte_lgr_platz is null
      then
        raise_isi_error(32, LC.ec_p1(LC.O_TP1_LGR_ORT_O_KOMM, nvl(v_q_lte.lgr_ort, '(null)')));
        -- raise_isi_error(32, 'Für den Lagerort ' || nvl(to_char(v_q_lte.lgr_ort), '(null)') ||
        --                    ' ist kein Kommissionierlagerplatz eingerichtet.');
      elsif (v_komm_direkt_moegl = 'F' or v_komm_picken_moegl = 'F')
      and v_komm_ausweich_lgr_platz is null
      then
        raise_isi_error(32, LC.ec_p1(LC.O_TP1_LGR_ORT_O_K_AUSW_PL, nvl(v_q_lte.lgr_ort, '(null)')));
        --raise_isi_error(34, 'Für den Lagerort ' || nvl(to_char(v_q_lte.lgr_ort), '(null)') ||
        --                    ' ist kein Ausweichlagerplatz definiert, obwohl keine Kommissionierung möglich ist.');
      end if;

      if not lvs_p_base.get_lhm_cfg(in_sid, nvl(in_neu_lhm_name, v_lhm.lhm_name), v_lhm_cfg)
      then
        raise_isi_error(36, LC.ec_p1(LC.O_TP1_LHM_CFG_FEHLT, nvl(nvl(in_neu_lhm_name, v_lhm.lhm_name), '(null)')));
        --raise_isi_error(36, 'Für den LHM Typ ' || nvl(nvl(in_neu_lhm_name, v_lhm.lhm_name), '(null)') ||
        --                    ' konnten keine Daten gefunden werden.');
      end if;

      if not lvs_p_base.get_lam_by_lhm_id(v_lhm.sid, v_lhm.firma_nr, in_lhm_id, v_lam)
      then
        raise_isi_error(37, LC.ec_p1(LC.O_TP1_LHM_ID_OHNE_BESTAND, nvl(to_char(in_lhm_id), '(null)')));
        -- raise_isi_error(37, 'Für die LHM ID ' || nvl(to_char(in_lhm_id), '(null)') || ' konnten keine Materialdaten gefunden werden.');
      end if;
      if not lvs_p_base.get_charge(v_lam.charge_id, v_charge)
      then
        raise_isi_error(38, LC.ec_p1(LC.O_TP1_CHARGE_ID_FEHLT, nvl(to_char(v_lam.charge_id), '(null)')));
        -- raise_isi_error(38, 'Die Charge mit ID ' || nvl(to_char(v_lam.charge_id), '(null)') || ' fehlt.');
      end if;

      -- Neue Ziel-LTE für die Umlagerung (Abkommissionierung) einer LHM anlegen
      v_komm_neu_lte_id := lvs_p_lte.lvs_lte_insert_v358 (in_sid,
                                                          in_firma_nr,
                                                          c.KeineLTE,
                                                          null,
                                                          in_login_id,
                                                          null,
                                                          null,
                                                          c.lte_pf_stat,
                                                          null,
                                                          null,
                                                          v_charge.charge_id,
                                                          v_charge.charge_bez,
                                                          v_lam.artikel_id,
                                                          NULL, -- -AG- In diesem Fall kann kein Packschema vorgegeben werden
                                                          null,                    -- Auto Depal ist unbekannt
                                                          null,                    -- wickelprogramm ist unbekannt,
                                                          null);                   -- wickelprogramm_einl ist unbekannt

      if not lvs_p_base.get_lte(v_komm_neu_lte_id, v_komm_lte)
      then
        raise_isi_error(40, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(v_komm_neu_lte_id, '(null)')));
        -- raise_isi_error(40, 'Für die LTE ID ' || nvl(v_komm_neu_lte_id, '(null)') || ' konnten keine Daten gefunden werden.');
      end if;

      -- Die Quell-LTE wird für das Abpacken reserviert
      v_result := lvs_ausl.lvs_lte_reserv_user_ziel(in_sid,
                                                    in_firma_nr,
                                                    -2, -- vorgang_id (-2 = Konstante für Umlagerungsreservierung)
                                                    -2, -- auf_id
                                                    v_q_lte.lte_id,
                                                    null,
                                                    in_login_id,
                                                    null);

      if v_result != 0
      then
        raise_isi_error(50, c.decode_function_fehler(v_result));
      end if;

      -- LHM wird für die Ziel LTE reserviert
      update lvs_lam t
         set t.res_ziel_lte_id = v_komm_neu_lte_id
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lhm_id = v_lhm.lhm_id;

      -- vor der Benutzung muss die Palette auf einen Kommissionierplatz gebucht werden
      if v_komm_lte.lgr_platz is null
      then
        lvs_p_lte.lvs_korr_te_einbuchen(in_sid, in_firma_nr, v_komm_neu_lte_id, null, in_sid, in_firma_nr,
                                        null, v_komm_neu_lte_lgr_platz, in_login_id, false);
      end if;

      -- Die Ziel-LTE wird für das Aufpacken reserviert
      v_result := lvs_ausl.lvs_lte_reserv_user_ziel(in_sid,
                                                    in_firma_nr,
                                                    -2, -- vorgang_id (-2 = Konstante für Umlagerungsreservierung)
                                                    -2, -- auf_id
                                                    v_komm_neu_lte_id,
                                                    null,
                                                    in_login_id,
                                                    in_ziel_lgr_platz);

      if v_result != 0
      then
        raise_isi_error(60, c.decode_function_fehler(v_result));
      end if;

      -- vor dem Transport noch den neuen LHM Typ speichern
      if in_neu_lhm_name is not null
      then
        update lvs_lhm t
           set t.komm_neu_lhm_name = in_neu_lhm_name
         where t.lhm_id = in_lhm_id;
      end if;

      v_transport_gruppe := 0;
      v_result := lvs_transport.lvs_gesperrter_transp_lte (in_sid,
                                                           in_firma_nr,
                                                           in_modul_erzeuger,
                                                           null,
                                                           c.C_FALSE,
                                                           'U',
                                                           in_login_id,
                                                           null,
                                                           null,
                                                           in_prio,
                                                           0,
                                                           0,
                                                           0,
                                                           v_komm_neu_lte_lgr_platz,
                                                           in_ziel_lgr_platz,
                                                           v_komm_neu_lte_id,
                                                           null,
                                                           c.C_FALSE,
                                                           null,
                                                           null,
                                                           null,
                                                           null,
                                                           null,
                                                           v_transport_gruppe,
                                                           v_transp_id);

      if v_result != 0
      then
        raise_isi_error(70, c.decode_function_fehler(v_result));
      end if;

      commit;
    end if;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end;

  procedure c_uml_gesp_transp_delete(in_sid       in isi_transport.sid%type,
                                     in_firma_nr  in isi_transport.firma_nr%type,
                                     in_login_id  in isi_transport.user_id%type,
                                     in_transp_id in isi_transport.transp_id%type) is
    v_transport      isi_transport%rowtype;
    v_lte            lvs_lte%rowtype;
    v_q_lte          lvs_lte%rowtype;
    v_lhm            lvs_lhm%rowtype;

    cursor c_res_lhm is
      select t.*
        from lvs_lam lam,
             lvs_lhm t
       where lam.res_ziel_lte_id = v_lte.lte_id
         and t.lhm_id = lam.lhm_id;

    v_found      boolean;
    v_t_result   number;
    v_res_result number;
  begin
    if not lvs_p_base.get_transport(in_sid, in_transp_id, v_transport)
    then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_TRAM_MIT_ID_FEHLT, nvl(to_char(in_transp_id), '(null)')));
      --raise_isi_error(10, 'Die Daten für Transport ID ' || nvl(to_char(in_transp_id), '(null)') ||
      --                    ' konnten nicht gefunden werden.');
    end if;

    if not lvs_p_base.get_lte(v_transport.lte_id, v_lte)
    then
      raise_isi_error(20, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(v_transport.lte_id, '(null)')));
      -- raise_isi_error(20, 'Die Daten für LTE ID ' || nvl(v_transport.lte_id, '(null)') ||
      --                    ' konnten nicht gefunden werden.');
    end if;

    v_t_result := lvs_transport.lvs_transp_loeschen(in_sid, in_firma_nr, in_login_id, in_transp_id, c.c_true);
    if v_t_result != 0
    then
      raise_isi_error(30, c.decode_function_fehler(v_t_result));
    end if;

    -- Reservierung auf der Transp-LTE zurücknehmen
    v_res_result := lvs_ausl.lvs_lte_res_rueck(in_sid,
                                               in_firma_nr,
                                               -2, -- vorgang_id (-2 = Konstante für Umlgaerungsreservierung)
                                               -2, -- auf_id
                                               v_lte.lte_id,
                                               v_lte.order_vorgang_id,
                                               v_lte.lgr_platz,
                                               c.c_true);

    if v_res_result != 0
    then
      raise_isi_error(40, c.decode_function_fehler(v_res_result));
    end if;

    if v_lte.lte_name = c.KeineLTE
    then
      -- Einzel LHM
      if nvl(v_lte.lte_akt_lhm, 0) = 0
      then
        -- "pseudo" LTE für Kommissionierung
        open c_res_lhm;
        fetch c_res_lhm into v_lhm;
        v_found := c_res_lhm%found;
        close c_res_lhm;

        if not v_found
        then
          raise_isi_error(50, LC.ec_p1(LC.O_TP1_LTE_ID_O_RESERVIERUNG, nvl(v_lte.lte_id, '(null)')));
          --raise_isi_error(50, 'Für LTE ID ' || nvl(v_lte.lte_id, '(null)') ||
          --                    ' konnte keine reservierte LHM gefunden werden.');
        end if;

        if not lvs_p_base.get_lte(v_lhm.lte_id, v_q_lte)
        then
          raise_isi_error(55, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(v_lte.lte_id, '(null)')));
          --raise_isi_error(55, 'Die Daten für LTE ID ' || nvl(v_lhm.lte_id, '(null)') ||
          --                    ' konnten nicht gefunden werden.');
        end if;

        -- Reservierung auf der Quell-LTE zurücknehmen
        v_res_result := lvs_ausl.lvs_lte_res_rueck(in_sid,
                                                   in_firma_nr,
                                                   -2, -- vorgang_id (-2 = Konstante für Umlgaerungsreservierung)
                                                   -2, -- auf_id
                                                   v_q_lte.lte_id,
                                                   v_q_lte.order_vorgang_id,
                                                   v_q_lte.lgr_platz,
                                                   c.c_true);
        if v_res_result != 0
        then
          raise_isi_error(60, c.decode_function_fehler(v_res_result));
        end if;

        update lvs_lam t
           set t.res_ziel_lte_id = null
         where t.lhm_id = v_lhm.lhm_id;

        -- Leere "pseudo" LTE kann gelöscht werden
        if v_lte.lgr_platz is not null
        then
          lvs_p_lte.lvs_korr_te_ausbuchen(in_sid, in_firma_nr, v_lte.lte_id, v_lte.lte_status, in_sid, in_firma_nr,
                                          v_lte.lgr_ort, v_lte.lgr_platz, in_login_id);
        end if;

        lvs_p_lte.lvs_lte_delete(in_sid, v_lte.lte_id, in_login_id, v_lte.lte_status);
      else
        -- Einzel LHM Daten holen
        if not lvs_p_base.get_lhm_by_lte_id(v_lte.lte_id, null, v_lhm)
        then
          raise_isi_error(70, LC.ec_p1(LC.O_TP1_LTE_ID_IST_LEER, nvl(v_transport.lte_id, '(null)')));
          -- raise_isi_error(70, 'Auf der LTE ID ' || nvl(v_transport.lte_id, '(null)') ||
          --                     ' konnte keine LHM gefunden werden.');
        end if;
      end if;

      if v_lhm.komm_neu_lhm_name is not null
      then
        update lvs_lhm t
           set t.komm_neu_lhm_name = null
         where t.lhm_id = v_lhm.lhm_id;
      end if;
    end if;

    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end;

  procedure c_uml_gesp_transp_freigeben(in_sid              in isi_transport.sid%type,
                                        in_firma_nr         in isi_transport.firma_nr%type,
                                        in_login_id         in isi_transport.user_id%type,
                                        in_transp_id        in isi_transport.transp_id%type,
                                        in_eti_druck_status in lvs_lte.lte_eti_druck_status%type) is
    v_transport      isi_transport%rowtype;
    v_lte            lvs_lte%rowtype;
    v_q_lte          lvs_lte%rowtype;
    v_lhm            lvs_lhm%rowtype;
    v_lhm_cfg        lvs_lhm_cfg%rowtype;
    v_lam            lvs_lam%rowtype;
    v_lam_bh_vorg_id lvs_lam_bh.vorg_id%type;

    cursor c_res_lhm is
      select t.*
        from lvs_lam lam,
             lvs_lhm t
       where lam.res_ziel_lte_id = v_lte.lte_id
         and t.lhm_id = lam.lhm_id;

    v_found      boolean;
    v_t_result   number;
    v_res_result number;
  begin
    -- Transport holen
    -- LTE holen
    -- wenn LTE = -Keine LTE (ansonsten nur neues LTE Etikett + LHM Etiketten, bei denen eins drauf war)
    -- -> LHM direkt oder über res_fuer_lte_id holen
    --    wenn LHM über res_fuer_lte_id geholt
    --    -> LHM Umpacken auf Ziel LTE
    --       Reservierung von alte LTE zurücksetzen (neues LTE Etiektt für alte LTE)
    --    wenn komm_neu_lhm_name != null
    --    -> neue LHM hoehe, breite, tiefe auf LHM und LTE buchen
    --       neues LHM/LTE Gewicht berechnen + buchen
    --       neuen LHM Typ in LHM setzen
    --    neues LHM Etikett
    -- Transport freigeben

    if not lvs_p_base.get_transport(in_sid, in_transp_id, v_transport)
    then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(to_char(in_transp_id), 'NULL')));
      -- raise_isi_error(10, 'Die Daten für Transport ID ' || nvl(to_char(in_transp_id), '(null)') ||
      --                    ' konnten nicht gefunden werden.');
    end if;

    if not lvs_p_base.get_lte(v_transport.lte_id, v_lte)
    then
      raise_isi_error(20, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(v_transport.lte_id, '(null)')));
      -- raise_isi_error(20, 'Die Daten für LTE ID ' || nvl(v_transport.lte_id, '(null)') ||
      --                    ' konnten nicht gefunden werden.');
    end if;

    if v_lte.lte_name = c.KeineLTE
    then
      -- Einzelne LHM wird transportiert, evtl. hat sich der LHM Typ geändert
      if nvl(v_lte.lte_akt_lhm, 0) = 0
      then
        -- Auf dieser LTE ist keine LHM vorhanden, also prüfen, ob für diese LTE eine LAM/LHM reserviert ist.
        open c_res_lhm;
        fetch c_res_lhm into v_lhm;
        v_found := c_res_lhm%found;
        close c_res_lhm;

        if not v_found
        then
          raise_isi_error(30, LC.ec_p1(LC.O_TP1_LTE_ID_O_RESERVIERUNG, nvl(v_transport.lte_id, '(null)')));
          -- raise_isi_error(30, 'Für LTE ID ' || nvl(v_transport.lte_id, '(null)') ||
          --                     ' konnte keine reservierte LHM gefunden werden.');
        end if;

        if not lvs_p_base.get_lte(v_lhm.lte_id, v_q_lte)
        then
          raise_isi_error(35, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(v_lhm.lte_id, '(null)')));
          --raise_isi_error(35, 'Die Daten für LTE ID ' || nvl(v_lhm.lte_id, '(null)') ||
          --                    ' konnten nicht gefunden werden.');
        end if;

        -- erstmal mit altem LHM typ von der Quelle abpacken
        lvs_p_lte_lhm.lvs_lhm_umpacken(in_sid, in_firma_nr, in_login_id, null, v_lhm.lhm_id, v_lte.lte_id);
        -- Reservierung für diese LTE entfernen
        update lvs_lam t
           set t.res_ziel_lte_id = null
         where t.lhm_id = v_lhm.lhm_id;
        -- Die Volumenwerte von der LHM auf die neue LTE anwenden (da der LTE Typ "-Keine LTE" ist)
        update lvs_lte t
           set t.lte_vol_hoehe = v_lhm.lhm_vol_hoehe,
               t.lte_vol_breite = v_lhm.lhm_vol_breite,
               t.lte_vol_tiefe = v_lhm.lhm_vol_tiefe,
               t.lte_akt_kg = v_lhm.lhm_akt_kg
         where t.lte_id = v_lte.lte_id;

        -- Reservierung auf der Quell-LTE zurücknehmen
        v_res_result := lvs_ausl.lvs_lte_res_rueck(in_sid,
                                                   in_firma_nr,
                                                   -2, -- vorgang_id (-2 = Konstante für Umlgaerungsreservierung)
                                                   -2, -- auf_id
                                                   v_q_lte.lte_id,
                                                   v_q_lte.order_vorgang_id,
                                                   v_q_lte.lgr_platz,
                                                   c.c_true);
        if v_res_result != 0
        then
          raise_isi_error(40, c.decode_function_fehler(v_res_result));
        end if;

        if v_q_lte.lte_akt_lhm = 1
        then
          -- letzte LHM wurde abgepackt
          lvs_p_lte.lvs_korr_te_ausbuchen(in_sid, in_firma_nr, v_q_lte.lte_id, v_q_lte.lte_status, in_sid, in_firma_nr,
                                          v_q_lte.lgr_ort, v_q_lte.lgr_platz, in_login_id);
        end if;


        if in_eti_druck_status is not null
        and v_q_lte.lte_akt_lhm > 1
        then
          -- für die Quell LTE Etikett drucken
          update lvs_lte t
             set t.lte_eti_druck_status = decode(t.lte_eti_druck_status,
                                                 null, c.ETI_STATUS_SOLL_DRUCKEN,
                                                 c.ETI_STATUS_NEU_DRUCKEN),
                 t.res_login_id = in_login_id
           where t.lte_id = v_q_lte.lte_id;
        end if;
      else
        if not lvs_p_base.get_lhm_by_lte_id(v_lte.lte_id, null, v_lhm)
        then
          raise_isi_error(50, LC.ec_p1(LC.O_TP1_LTE_ID_IST_LEER, nvl(v_transport.lte_id, '(null)')));
          --raise_isi_error(50, 'Auf der LTE ID ' || nvl(v_transport.lte_id, '(null)') ||
          --                    ' konnte keine LHM gefunden werden.');
        end if;

        -- weil sich der LHM Typ ändert muss vorher die Quelle entlastet werden, damit die
        -- neuen Volumendimensionen nicht auf dem alten Lagerplatz angewendet werden
        if v_lhm.komm_neu_lhm_name is not null
        then
          v_t_result := lvs_transport.lvs_transp_transport(in_sid, in_firma_nr, in_login_id, in_transp_id,
                                                           v_lte.lte_id, null, v_lam_bh_vorg_id);

          if v_t_result != 0
          then
            raise_isi_error(60, c.decode_function_fehler(v_t_result));
          end if;
        end if;
      end if;

      if v_lhm.komm_neu_lhm_name is not null
      then
        -- Der LHM Typ ändert sich
        if not lvs_p_base.get_lhm_cfg(in_sid, v_lhm.komm_neu_lhm_name, v_lhm_cfg)
        then
          raise_isi_error(70, LC.ec_p1(LC.O_TP1_LHM_TYP_FEHLT, v_lhm.komm_neu_lhm_name));
          -- raise_isi_error(70, 'Die Konfigurationsdaten für LHM Typ ' || v_lhm.komm_neu_lhm_name ||
          --                    ' konnten nicht gefunden werden.');
        end if;

        if not lvs_p_base.get_lam_by_lhm_id(in_sid, in_firma_nr, v_lhm.lhm_id, v_lam)
        then
          raise_isi_error(80, LC.ec_p1(LC.O_TP1_LHM_ID_OHNE_BESTAND, v_lhm.lhm_id));
          -- raise_isi_error(80, 'Die LAM-Daten für LHM ID ' || v_lhm.lhm_id || ' konnten nicht gefunden werden.');
        end if;

        v_lhm.lhm_name := v_lhm.komm_neu_lhm_name;
        v_lhm.lhm_vol_hoehe := v_lhm_cfg.lhm_vol_hoehe;
        v_lhm.lhm_vol_breite := v_lhm_cfg.lhm_vol_breite;
        v_lhm.lhm_vol_tiefe := v_lhm_cfg.lhm_vol_tiefe;
        v_lhm.lhm_akt_kg := nvl(v_lhm_cfg.lhm_gew_kg, 0) + nvl(v_lam.lam_kg, 0);

        update lvs_lhm t
           set t.lhm_name = v_lhm.lhm_name,
               t.komm_neu_lhm_name = null,
               t.lhm_vol_hoehe = v_lhm.lhm_vol_hoehe,
               t.lhm_vol_breite = v_lhm.lhm_vol_breite,
               t.lhm_vol_tiefe = v_lhm.lhm_vol_tiefe,
               t.lhm_akt_kg = v_lhm.lhm_akt_kg
         where t.lhm_id = v_lhm.lhm_id;

        update lvs_lte t
           set t.lte_vol_hoehe = v_lhm.lhm_vol_hoehe,
               t.lte_vol_breite = v_lhm.lhm_vol_breite,
               t.lte_vol_tiefe = v_lhm.lhm_vol_tiefe,
               t.lte_akt_kg = v_lhm.lhm_akt_kg
         where t.lte_id = v_lte.lte_id;
        -- Auf dem Ziellagerplatz ist bereits die neue Höhe der LTE reserviert worden -> kein Update am Lagerplatz
      end if;

      if in_eti_druck_status is not null
      then
        update lvs_lhm t
           set t.lhm_eti_druck_status = decode(t.lhm_eti_druck_status,
                                               null, c.ETI_STATUS_SOLL_DRUCKEN,
                                               c.ETI_STATUS_NEU_DRUCKEN)
         where t.lhm_id = v_lhm.lhm_id;
      end if;
    else
      -- Ganze (echte) LTE wird unverändert transportiert
      if in_eti_druck_status is not null
      then
        -- LTE bekommt ein neues Etikett
        update lvs_lte t
           set t.lte_eti_druck_status = decode(v_lte.lte_eti_druck_status,
                                                null, c.ETI_STATUS_SOLL_DRUCKEN,
                                                c.ETI_STATUS_NEU_DRUCKEN)
         where t.lte_id = v_lte.lte_id;

        -- LHMs auf der LTE, die ein Etikett haben, bekommen ein neues Etikett
        update lvs_lhm t
           set t.lhm_eti_druck_status = c.ETI_STATUS_NEU_DRUCKEN
         where t.lte_id = v_lte.lte_id
           and t.lhm_eti_druck_status is not null;
      end if;
    end if;

    v_t_result := lvs_transport.transport_freigeben(in_sid, in_firma_nr, in_login_id, in_transp_id);
    if v_t_result != 0
    then
      raise_isi_error(90, c.decode_function_fehler(v_t_result));
    end if;

    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
  end;

end LVS_UML;
/



-- sqlcl_snapshot {"hash":"a85c5ce9944f43cc905f6b6e5d7069e3662d4ef2","type":"PACKAGE_BODY","name":"LVS_UML","schemaName":"DIRKSPZM32","sxml":""}