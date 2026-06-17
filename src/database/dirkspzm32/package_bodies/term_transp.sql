create or replace 
package body DIRKSPZM32.term_transp is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  12.02.2009
  __________________________________________________
  Description
  Terminal Funktionen ersatz für das alte Package SLS_Terminal!!!
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  12.02.2009   3.4.10.1    (-WK-)   package created
  */


  v_build_number constant number := 1;

  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr   := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
  procedure reset_isi_error is
  begin
    v_err_nr := null;
    v_err_text := null;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
  function get_release return varchar2 is
  begin
		return(v_release_str);
  end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
  function get_version return varchar2 is
	begin
    return(to_char(v_release_major) || '.' ||
           to_char(v_release_minor) || '.' ||
           to_char(v_revision) || '.' ||
           to_char(v_build_number) || ' / ' ||
           v_rev_date);
	end;

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2
                          ) is
  begin
    out_rel_major := v_release_major;
    out_rel_minor := v_release_minor;
    out_revision := v_revision;
    out_buid_number := v_build_number;
    out_rev_date := v_rev_date;
  end;

  /******************************************************************************************************
   * private functions
   ******************************************************************************************************/
  -- Foreward declarations
  procedure check_man_einl_prio_sat1(in_transport   in isi_transport%rowtype);

  -------------------------------------------------------------------------------------------------------
  -- Gibt eine Liste mit Transport ID's der ausführbaren Transporte zurück
  -------------------------------------------------------------------------------------------------------

  function get_global_transp_cfg(in_sid        in isi_firma_cfg.sid%type,
                                 in_firma_nr   in isi_firma_cfg.firma_nr%type,
                                 in_param_name in isi_firma_cfg.parameter_name%type,
                                 in_def_value  in isi_firma_cfg.parameter_wert%type,
                                 in_param_type in isi_firma_cfg.parameter_typ%type default null
                                ) return varchar2 is
    v_result isi_firma_cfg.parameter_wert%type;
  begin
    v_result := isi_allg.get_firma_cfg_param(in_sid,                        -- in_sid                   in isi_firma_cfg.sid%type,
                                             in_firma_nr,                   -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                             'CFG',                         -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                             NULL,                          -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                             in_param_name,                 -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                             'transport',                   -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                             'CFG',                         -- in_typ                   in isi_firma_cfg.typ%type,
                                             in_def_value,                  -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                             nvl(in_param_type, 'STRING')); -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type
    return(v_result);
  end;

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/

  -------------------------------------------------------------------------------------------------------
  -- Gibt eine Liste mit Transport ID's der ausführbaren Transporte zurück
  -------------------------------------------------------------------------------------------------------
  function get_next_transp_list_csv(in_sid                 in isi_transport.sid%type,
                                    in_firma_nr            in isi_transport.firma_nr%type,
                                    in_login_id            in isi_user.login_id%type,
                                    in_res_id              in isi_transport.res_id%type,
                                    in_max_count           in number,
                                    out_transp_id_list_csv out varchar2
                                   ) return varchar2 is
    v_fahrzeug         lvs_fahrzeuge%rowtype;
    v_transp_id        isi_transport.transp_id%type;
    v_transp_erz       isi_transport.modul_erzeuger%type;
    v_transp_bearb     isi_transport.modul_bearbeiter%type;
    v_transp_ls_id_q   lvs_lgr_ort.stapler_ls_id%type;
    v_transp_ls_id_z   lvs_lgr_ort.stapler_ls_id%type;
    v_urgent_index     number;
    v_we_anz           number;
    v_we_anz_prio_high number;

    v_transp_dauer number;
    v_calc_transp_ende date;

    cursor c_transport is
      select t.transp_id,
             t.modul_erzeuger,
             t.modul_bearbeiter,
             loq.stapler_ls_id stapler_ls_id_q,
             loz.stapler_ls_id stapler_ls_id_z,
             round(t.soll_fertig_bis - v_calc_transp_ende, 2) urgent,
             (select decode(count(*), 0, null, count(*))
                from isi_transport t1
               where t1.lgr_platz_quelle = t.lgr_platz_quelle
                 and t1.transp_typ = 'E'
                 and ((t1.status = 'F' and t1.res_id is NULL)
                      or t1.res_id = in_res_id)) we_anz,
             isi_allg.get_firma_cfg_param(t.sid, t.firma_nr, 'CFG', t.lgr_platz_quelle,
                                          'we_anz_prio_high', 'transport', 'CFG',
                                          null, 'INTEGER') we_anz_prio_high
        from isi_transport t,
             lvs_lgr_ort loz,
             lvs_lgr_ort loq
       where t.sid              = in_sid
         and t.firma_nr         = in_firma_nr
         and t.modul_bearbeiter = 'SLS'
         and ((t.status = 'F' and t.res_id is NULL)
              or t.res_id = in_res_id)
         and (t.transp_typ != 'A'
              or t.freifahrauftrag = 'T'
              or (t.transp_typ = 'A'
                  and not exists (select t2.transp_id
                                    from isi_transport t2
                                   where nvl(t2.lkw_nr, t2.vorgang_id) = nvl(t.lkw_nr, t.vorgang_id)
                                     and t2.transport_gruppe < t.transport_gruppe
                                     and t2.lgr_platz_ziel = t.lgr_platz_ziel)))
         and loq.sid = t.sid
         and loq.firma_nr = t.firma_nr
         and loq.lgr_ort = t.lgr_ort_quelle
         and loz.sid = t.sid
         and loz.firma_nr = t.firma_nr
         and loz.lgr_ort = t.lgr_ort_ziel
       order by
             abs(nvl(t.res_id, -1) - in_res_id), -- eigene transporte zuerst
             t.freifahrauftrag desc, -- erst freifahren
             t.transport_reihenfolge, -- Dann Reihenfolge beachten
             decode(we_anz - we_anz_prio_high,
                    null, 1, -- keine Relevanz
                    abs(we_anz - we_anz_prio_high), 0, -- (positiv = 0 = dringend)
                    1), -- dringende Einlagerungen
             decode(urgent, abs(urgent), 1, 0), -- positive Werte sind Transporte die später fertig sein dürfen
             t.prio desc, -- höchste prio zuerst
             (t.soll_fertig_bis - v_calc_transp_ende), -- zuerst die, die früher fertig sein sollen
             t.transport_gruppe,
             t.li_nr,
             t.li_pos_nr,
             decode(t.status, 'G', 2, 1),
             t.transp_id; -- zuletzt die Eingabereihenfolge
             
    -- -AG- 20190913 Einbau mechfach LSL-ID je Stapler
    CURSOR c_get_ls_id_s is
      select ';' || stradd_distinct(lsid.stapler_ls_id) || ';'
        from lvs_fahrzeuge_ls_id lsid
       where lsid.sid = v_fahrzeug.sid
         and lsid.firma_nr = v_fahrzeug.firma_nr
         and lsid.res_id = v_fahrzeug.res_id
         and lsid.stapler_ls_id_enable = c.C_TRUE; -- -AG-  20191011 - Operativ wird ein Ein- und Abschalten benötigt

    v_transp_counter number;
    v_result         varchar2(1);
    v_ls_ids         varchar2(1000);
  begin
    v_result := c.c_false;
    out_transp_id_list_csv := '';

    v_transp_dauer := to_number(get_global_transp_cfg(in_sid, in_firma_nr,
                                                      'STD_TRANSPORT_ZEIT_MIN', '15',
                                                      'INTEGER'));
    v_calc_transp_ende := sysdate + (v_transp_dauer + 5) / 1440;
    v_transp_counter := 0;

    -- Leitsystem des aktuellen Staplers holen
    if not lvs_p_base.get_fahrzeug(in_res_id, v_fahrzeug)
    then
      v_ls_ids := null;
    else
      OPEN c_get_ls_id_s;
      FETCH c_get_ls_id_s into v_ls_ids;
      CLOSE c_get_ls_id_s;
      
      if v_ls_ids = ';;'
      then
        v_ls_ids := null;
      end if;
      
      if  v_fahrzeug.stapler_ls_id is not NULL 
      and v_ls_ids is not NULL
      then
        v_ls_ids := v_ls_ids || v_fahrzeug.stapler_ls_id || ';';
      elsif v_fahrzeug.stapler_ls_id is not NULL
      then
        v_ls_ids := v_fahrzeug.stapler_ls_id;
      end if;
    end if;

    open c_transport;
    loop
      fetch c_transport into v_transp_id, v_transp_erz, v_transp_bearb,
                             v_transp_ls_id_q, v_transp_ls_id_z, v_urgent_index,
                             v_we_anz, v_we_anz_prio_high;
      exit when c_transport%notfound;

      if v_ls_ids is null -- dieses Fahrzeug darf alles anfahren
         or v_ls_ids like '%;' || to_char(v_transp_ls_id_q) || ';%'  -- dieses Fahrzeug darf die Transportquelle anfahren
         or v_ls_ids like '%;' || to_char(v_transp_ls_id_z) || ';%' -- dieses Fahrzeug darf das Transportziel anfahren
      then
        out_transp_id_list_csv := out_transp_id_list_csv || to_char(v_transp_id) || ';';
        v_transp_counter := v_transp_counter + 1;
        v_result := c.c_true;
        exit when v_transp_counter >= in_max_count;
      end if;
    end loop;
    close c_transport;

    return(v_result);
  exception
    when others then
      if c_transport%isopen
      then
        close c_transport;
      end if;
      raise;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Zuweisung eines Transports zu einer Ressource
  -------------------------------------------------------------------------------------------------------
  procedure c_assign_transp_to_resource(in_sid       in isi_transport.sid%type,
                                        in_firma_nr  in isi_transport.firma_nr%type,
                                        in_transp_id in isi_transport.transp_id%type,
                                        in_res_id    in isi_transport.res_id%type,
                                        in_login_id  in isi_user.login_id%type
                                       ) is
    v_transport_n isi_transport%rowtype;
    v_transport   isi_transport%rowtype;
    v_ret_val     number;
    v_error_code  number;

  begin
    reset_isi_error;

    -- lets see if the transport still exists
    if not lvs_p_base.get_transport(in_sid, in_transp_id, v_transport)
    then
      raise_isi_error(10, lc.ec_p1(lc.O_TP1_TRANSP_ID_NF, in_transp_id));
    end if;

    -- Zugriffsmöglichkeit auf den Transport prüfen
    v_ret_val := lvs_transport.lvs_transp_check_zugriff(in_sid, in_firma_nr,
                                                        v_transport.modul_erzeuger,
                                                        v_transport.modul_bearbeiter,
                                                        c.c_true, -- stapler terminal kann immer freifahren
                                                        in_login_id,
                                                        v_transport.transp_id,
                                                        ';' || to_char(in_res_id) || ';'); -- hier wird eine Liste erwartet
    if v_ret_val = 1 -- neuer Transport zum freifahren wurde angelegt (siehe "lvs_transport").
    then
      commit;
      -- CMe 20220324 (): Transport LTE darf geändert werden
      if isi_allg.get_firma_cfg_param(v_transport.sid,
                                      v_transport.firma_nr, 
                                      'CFG', 
                                      null, 
                                      'TMS_CHG_TRANSPORT_LTE', 
                                      'LVS', 
                                      'CFG', 
                                      c.C_FALSE, 
                                      'BOOLEAN') = c.c_true
      then
        -- CMe 20220324 (): Prüfen ob Transport LTE geändert wurde, wenn ja andere Message senden
        if (lvs_p_base.get_transport(in_sid, in_transp_id, v_transport_n)) and
           (v_transport_n.lte_id != v_transport.lte_id)
        then
          raise_isi_error(20, lc.ec(lc.O_TXT_TRANSP_LTE_CHANGED));
        else
          raise_isi_error(20, lc.ec('O_TXT_RELOC_TRANSP_CREATED'));
        end if;
      else
        -- wegen neuem Transport muss die Liste nochmal geholt werden.
        raise_isi_error(20, lc.ec('O_TXT_RELOC_TRANSP_CREATED')); -- 'TODO: new const -> Freifahrtransport wurde angelegt');
      end if;
    elsif v_ret_val = -1
    then
      raise_isi_error(30, lc.ec('O_TXT_TU_BLOCKED_BY_OTHER_TU')); --'TODO: new const -> LTE muss erst freigefahren werden');
    end if;

    v_error_code := lvs_transport.lvs_transp_beginnen(in_sid,
                                                      in_firma_nr,
                                                      in_login_id,
                                                      in_transp_id,
                                                      v_transport.lte_id,
                                                      in_res_id);
    if v_error_code != 0
    then
      raise_isi_error(abs(v_error_code), lc.ec_p2(lc.C_TP2_TRANSP_RES_ASSIGN_FAIL, in_transp_id, in_res_id));
    end if;

    if v_transport.transp_typ = 'E'
    then
      check_man_einl_prio_sat1(v_transport);
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

  -------------------------------------------------------------------------------------------------------
  -- Aufheben der Zuweisung eines Transports zu einer Ressource
  -------------------------------------------------------------------------------------------------------
  procedure c_release_assigned_transp(in_sid       in isi_transport.sid%type,
                                      in_transp_id in isi_transport.transp_id%type,
                                      in_res_id    in isi_transport.res_id%type
                                     ) is
  begin
    update isi_transport t
       set t.res_id = null,
		       t.status = 'F'
     where t.transp_id = nvl(in_transp_id, t.transp_id)
       and t.sid = in_sid
       and t.res_id = in_res_id
       and t.status in ('B', 'Z');

    commit;
  exception
    when others then
      rollback;
      raise;
  end;

  -------------------------------------------------------------------------------------------------------
  -- behandelt den Fehlerfall, wenn die Transportquelle leer ist
  -------------------------------------------------------------------------------------------------------
  procedure c_handle_storage_cell_empty(in_sid       in isi_transport.sid%type,
                                        in_transp_id in isi_transport.transp_id%type,
                                        in_login_id  in isi_user.login_id%type
                                       ) is
    v_transport isi_transport%rowtype;
    v_error_code varchar2(255);
  begin
    reset_isi_error;

    -- lets see if the transport still exists
    if not lvs_p_base.get_transport(in_sid, in_transp_id, v_transport)
    then
      raise_isi_error(10, lc.ec_p1(lc.O_TP1_TRANSP_ID_NF, in_transp_id));
    end if;

    -- try to find another transport unit with the same article criteria
    v_error_code := lvs_p_lte.lvs_suche_neue_lte(v_transport,
                                                 in_login_id);
    -- the transport was modified another transport unit was found, so we have to commit here
    commit; -- for modified transports etc.

    if instr('O_', v_error_code) > 0
    then
      -- the result is an error constant
      raise_isi_error(20, v_error_code);
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

  -------------------------------------------------------------------------------------------------------
  -- behandelt den fall, dass eine andere LTE genommen werden soll
  -------------------------------------------------------------------------------------------------------
  procedure c_handle_storage_lte_alter(in_sid       in isi_transport.sid%type,
                                        in_transp_id in isi_transport.transp_id%type,
                                        in_login_id  in isi_user.login_id%type,
                                        in_lte_id lvs_lte.lte_id%type
                                       ) is
    v_transport isi_transport%rowtype;
    v_error_code varchar2(255);
  begin
    reset_isi_error;

    -- lets see if the transport still exists
    if not lvs_p_base.get_transport(in_sid, in_transp_id, v_transport)
    then
      raise_isi_error(10, lc.ec_p1(lc.O_TP1_TRANSP_ID_NF, in_transp_id));
    end if;

    -- try to find another transport unit with the same article criteria
    v_error_code := lvs_p_lte.lvs_suche_neue_lte_old_crtl(v_transport,       -- in_transport       in isi_transport%rowtype,
                                                          in_login_id,       -- in_user_id         in isi_user.login_id%type,
                                                          'ALTER_LTE',       -- in_lte_crtl        in varchar2,
                                                          in_lte_id          -- in lvs_lte.lte_id%type
                                                         );
    -- the transport was modified another transport unit was found, so we have to commit here
    commit; -- for modified transports etc.

    if instr('O_', v_error_code) > 0
    then
      -- the result is an error constant
      raise_isi_error(20, v_error_code);
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

  -------------------------------------------------------------------------------------------------------
  -- behandelt den Fehlerfall, wenn das Transportziel voll ist
  -------------------------------------------------------------------------------------------------------
     procedure c_handle_storage_cell_occupied(in_sid               in isi_transport.sid%type,
                                           in_transp_id         in isi_transport.transp_id%type,
                                           in_login_id          in isi_user.login_id%type,
                                           out_new_storage_cell out isi_transport.lgr_platz_ziel%type
                                          ) is
    v_transport isi_transport%rowtype;
    v_pos integer;

  begin
    reset_isi_error;

    -- lets see if the transport still exists
    if not lvs_p_base.get_transport(in_sid, in_transp_id, v_transport)
    then
      raise_isi_error(10, lc.ec_p1(lc.O_TP1_TRANSP_ID_NF, in_transp_id));
    end if;

    -- try to find a new storage cell
    out_new_storage_cell := lvs_p_lte.lvs_c_suche_neuen_platz(v_transport, in_login_id, null);
    -- if returns multilang text instead off storage_cell  Bugfix 17.12.2010 -BW-
    v_pos  := instr(out_new_storage_cell, '@[', 1, 1);   -- LC.CPTRENNER
    if v_pos >1
    then
      out_new_storage_cell := subStr(out_new_storage_cell, v_pos + 2, length(out_new_storage_cell) -v_pos -2);
    end if;

    -- the transport was modified when another destination was found, so we have to commit here
    commit; -- for modified transports

    if out_new_storage_cell is null
    then
      -- the result is an error constant
      raise_isi_error(20, lc.ec_p1(lc.O_TP1_LGR_F_LTE_N_GEFUNDEN, v_transport.lte_id));
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

  -------------------------------------------------------------------------------------------------------
  -- behandelt den Fall, wenn das Transportziel geändert werden soll
  -------------------------------------------------------------------------------------------------------
  procedure c_handle_storage_cell_alter(in_sid               in isi_transport.sid%type,
                                           in_transp_id         in isi_transport.transp_id%type,
                                           in_login_id          in isi_user.login_id%type,
                                           out_new_storage_cell out isi_transport.lgr_platz_ziel%type
                                          ) is
    v_transport isi_transport%rowtype;
    v_pos integer;

  begin
    reset_isi_error;

    -- lets see if the transport still exists
    if not lvs_p_base.get_transport(in_sid, in_transp_id, v_transport)
    then
      raise_isi_error(10, lc.ec_p1(lc.O_TP1_TRANSP_ID_NF, in_transp_id));
    end if;

    -- try to find a new storage cell
    out_new_storage_cell := lvs_p_lte.lvs_suche_neuen_platz_v349(v_transport,
                                                                 in_login_id,
                                                                 null);
    -- if returns multilang text instead off storage_cell  Bugfix 17.12.2010 -BW-
    v_pos  := instr(out_new_storage_cell, '@[', 1, 1);   -- LC.CPTRENNER
    if v_pos >1
    then
      out_new_storage_cell := subStr(out_new_storage_cell, v_pos + 2, length(out_new_storage_cell) -v_pos -2);
    end if;

    -- the transport was modified when another destination was found, so we have to commit here
    commit; -- for modified transports

    if out_new_storage_cell is null
    then
      -- the result is an error constant
      raise_isi_error(20, lc.ec_p1(lc.O_TP1_LGR_F_LTE_N_GEFUNDEN, v_transport.lte_id));
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

  -------------------------------------------------------------------------------------------------------
  -- Versuchen anhand einer anderen LTE_ID den Transport der neuen LTE vorzuziehen
  -------------------------------------------------------------------------------------------------------
  procedure c_change_transp_diff_tu(in_sid                 in isi_transport.sid%type,
                                    in_transp_id           in isi_transport.transp_id%type,
                                    in_diff_transp_unit_id in isi_transport.lte_id%type,
                                    in_login_id            in isi_user.login_id%type,
                                    in_res_id              in isi_transport.res_id%type
                                   ) is
    v_curr_transport isi_transport%rowtype;
    v_diff_transport isi_transport%rowtype;
    v_lgr_ziel       lvs_lgr%rowtype;
    v_diff_lte       lvs_lte%rowtype;
    v_error_code     number;
  begin
    reset_isi_error;

    -- do we have a valid transp unit?
    if not lvs_p_base.get_lte(in_diff_transp_unit_id, v_diff_lte)
    then
      raise_isi_error(10, lc.ec_p1(lc.O_TP1_LTE_ID_FEHLT, in_diff_transp_unit_id));
    end if;

    -- do we have an active (waiting) transport for the transp unit?
    if not lvs_p_base.get_transport_by_lte_id(in_diff_transp_unit_id, v_diff_transport)
    then
      raise_isi_error(20, lc.ec_p1(lc.O_TP1_TRANSP_DATA_BY_TU_NF, in_diff_transp_unit_id));
    end if;

    -- now check if we can use this transport
    if  v_diff_transport.status != 'F'
    and v_diff_transport.status != 'B' -- Auch begonnen können genommen werden
    then
      raise_isi_error(30, lc.ec_p1('O_TP1_TRANSP_NOT_EXECUTABLE', in_transp_id)); -- 'TODO: new const');
    end if;

    -- now get data for current transport
    if not lvs_p_base.get_transport(in_sid, in_transp_id, v_curr_transport)
    then
      raise_isi_error(40, lc.ec_p1(lc.O_TP1_TRANSP_DATA_NF, in_transp_id));
    end if;

    -- -AG- Egal, Palette ist jetzt gescannt und soll transportiert werden
    -- check if both transports are for the same source
    -- if v_diff_transport.lgr_platz_quelle != v_curr_transport.lgr_platz_quelle
    -- then
    --   raise_isi_error(50, lc.ec_p1('O_TP1_TRANSP_N_CHG_DIFF_SRC', v_curr_transport.lgr_platz_quelle)); --'TODO: new const -> change of transport is only allowed on the same source');
    -- end if;

    -- check for outgoing goods
    if v_diff_transport.transp_typ = 'A'
    then
      -- Read lgr_platz_ziel
      if lvs_p_base.get_lgr_platz(v_diff_transport.lgr_platz_ziel, v_lgr_ziel)
      then
        -- OK when not a WA or WA not a LDPR
        -- -AG- 14.01.2010 BugFix Nur am Auslagerpunkt prüfrn (Verladung auf den LKW)
        if v_lgr_ziel.lgr_verwendung = c.LGR_TYP_WA
        and nvl(v_lgr_ziel.wa_typ, 'LDPO') = 'LDPO'
        and isi_allg.c_get_firma_cfg_param(v_diff_transport.sid, -- -AG- 20211206 Pruefung jetzt über Firma_CFG abschaltbar 
                                           v_diff_transport.firma_nr, 
                                           'CFG', -- Kategorie 
                                           NULL,  -- Kategorie IDX
                                           'TMS_AUSL_CHECK_TOUR', -- Parameter Name 
                                           'TMS',              -- Modul-Name 
                                           'CFG',
                                           c.C_TRUE, 
                                           'BOOLEAN') = c.C_TRUE
        then
          -- change is only allowed for the same load/tour number
          if nvl(v_diff_transport.lkw_nr, v_diff_transport.vorgang_id) != nvl(v_curr_transport.lkw_nr, v_curr_transport.vorgang_id)
          then
            raise_isi_error(60, lc.ec_p1('O_TP1_TRANSP_N_CHG_DIFF_TOUR',
                                         nvl(v_curr_transport.lkw_nr, v_curr_transport.vorgang_id))); --'TODO: new const -> change of transport is only allowed on the same source');
          end if;

          -- check the required order for the transport units
          if v_curr_transport.transport_gruppe < v_diff_transport.transport_gruppe
          then
            raise_isi_error(70, lc.ec_p2('O_TP2_TRANSP_N_CHG_ORDER',
                                         v_curr_transport.transport_gruppe,
                                         v_diff_transport.transport_gruppe)); --'TODO: new const -> wrong order of transport units');
          end if;
        end if;
      end if;
    end if;

    -- now release the transport and commit this process
    c_release_assigned_transp(v_curr_transport.sid,
                              NULL,  -- release all for this Res_ID
                              in_res_id);

    -- assign the new transport
    v_error_code := lvs_transport.lvs_transp_beginnen(v_diff_transport.sid,
                                                      v_diff_transport.firma_nr,
                                                      in_login_id,
                                                      v_diff_transport.transp_id,
                                                      v_diff_lte.lte_id,
                                                      in_res_id);
    if v_error_code != 0
    then
      raise_isi_error(abs(v_error_code), lc.ec_p2(lc.C_TP2_TRANSP_RES_ASSIGN_FAIL, v_diff_transport.transp_id, in_res_id));
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

	-------------------------------------------------------------------------------------------------------
	--
	-------------------------------------------------------------------------------------------------------
  function get_loading_transp_list_csv(in_sid                 in tms_loading_points.sid%type,
                                       in_firma_nr            in tms_loading_points.firma_nr%type,
                                       in_loading_point       in tms_loading_points.lgr_platz%type,
                                       out_transp_id_list_csv out varchar2
                                      ) return varchar2 is
    v_loading_point tms_loading_points%rowtype;
    v_transp_id     isi_transport.transp_id%type;
    v_result        varchar2(10);

    cursor c_transport is
      select t.transp_id
        from isi_transport t
       where t.vorgang_id = v_loading_point.order_vorgang_id
         and t.lgr_platz_ziel = v_loading_point.lgr_platz
       order by
             t.transport_gruppe,
             decode(t.status, 'G', 2, 1),
             t.li_nr,
             t.li_pos_nr,
             t.transp_id;
  begin
    reset_isi_error();
    v_result := 'F';
    out_transp_id_list_csv := '';

    if not tms_p_base.get_loading_point(in_loading_point, in_firma_nr, in_sid, v_loading_point)
    then
      raise_isi_error(10, lc.ec_p1('O_TP1_TMS_LP_NA', in_loading_point));
    end if;

    open c_transport;
    loop
      fetch c_transport into v_transp_id;
      exit when c_transport%notfound;

      if out_transp_id_list_csv is not null
      then
        out_transp_id_list_csv := out_transp_id_list_csv || ';';
      end if;

      out_transp_id_list_csv := out_transp_id_list_csv || v_transp_id;
      v_result := 'T';
    end loop;
    close c_transport;

    return (v_result);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_transport%isopen
      then
        close c_transport;
      end if;
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_transport%isopen
      then
        close c_transport;
      end if;
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

  procedure check_man_einl_prio_sat1(in_transport   in isi_transport%rowtype) is
    -- Wenn Transporte manuell durchgeführt werden, muss die Quelle und das Ziel geprüft
    -- werden, ob es sich um Kanallager handelt. Wenn ja, dann müssen alle Transporte
    -- für diesen kanal un von dieser Quelle eine höhere PRIO bekommen

    v_lgr_quelle lvs_lgr%rowtype;
    v_lgr_ziel   lvs_lgr%rowtype;
    v_max_prio   isi_transport.prio%type;
    v_max_tr_id  isi_transport.transp_id%type;
  begin
    -- Wenn Transporte manuell durchgeführt werden, muss die Quelle und das Ziel geprüft
    -- werden, ob es sich um Kanallager handelt. Wenn ja, dann müssen alle Transporte
    -- für diesen kanal un von dieser Quelle eine höhere PRIO bekommen (In einem Rutsch)
    if  in_transport.transp_typ = 'E' -- Jetzt erst mal nur einlagern
    and lvs_p_base.get_lgr_platz(in_transport.lgr_platz_quelle, v_lgr_quelle)
    and lvs_p_base.get_lgr_platz(in_transport.lgr_platz_ziel, v_lgr_ziel)
    then
      -- manuell geführtes Satelitenlager
      if v_lgr_quelle.lgr_typ = c.SAT1
      or v_lgr_ziel.lgr_typ = c.SAT1
      or v_lgr_quelle.lgr_typ = c.KANAL1
      or v_lgr_ziel.lgr_typ = c.KANAL1
      then
        -- Suche den Maxwert ID der Transporte
        -- Ohne Freifaheren die nicht vom gleichen Typ sind
        select max(t.prio) into v_max_prio
          from isi_transport t
         where t.freifahrauftrag = c.C_FALSE
           and t.transp_typ != in_transport.transp_typ
           and (t.lgr_ort_quelle = in_transport.lgr_ort_quelle
             or t.lgr_ort_quelle = in_transport.lgr_ort_ziel)
           and (t.lgr_ort_ziel = in_transport.lgr_ort_ziel
             or t.lgr_ort_ziel = in_transport.lgr_ort_quelle);

        if in_transport.prio > v_max_prio
        then
          v_max_prio := in_transport.prio;
        elsif in_transport.prio <= v_max_prio
        then
          v_max_prio := v_max_prio + 1;
        end if;

        /* Auslagerungen raus
        -- in der Regel Auslagerungen
        if v_lgr_quelle.lgr_typ = c.SAT1
        then
          -- Alle Paletten die in den gleichen Kanal sind
          -- Diese Paletten sollen jetzt als Gruppe vorgezogen werden
          -- damit der manuelle Satelit nicht immer hin und her gefahren wird
          -- sollen vorgezogen werden
          update isi_transport t
             set t.prio = v_max_prio
           where t.transport_gruppe <= in_transport.transport_gruppe
             and t.prio != v_max_prio
             and t.lgr_platz_quelle in (select l.lgr_platz
                                          from lvs_lgr l
                                         where l.lgr_platz_gruppe = v_lgr_quelle.lgr_platz_gruppe);
        end if;
        */

        -- in der Regel Auslagerungen oder Umlagerungen
        if v_lgr_ziel.lgr_typ = c.SAT1
        or v_lgr_ziel.lgr_typ = c.KANAL1
        then
          -- Alle Paletten die in den gleichen Kanal sollen +
          -- sicherheitshalber wegen der Reihenfolge die Paletten
          -- die dazwischen stehen
          select max(t.transp_id) into v_max_tr_id
            from isi_transport t
           where t.transport_gruppe <= in_transport.transport_gruppe
             and t.freifahrauftrag = c.C_FALSE
             and t.transp_typ = in_transport.transp_typ
             and t.lgr_platz_quelle = in_transport.lgr_platz_quelle
             and t.lgr_platz_ziel in (select l.lgr_platz
                                        from lvs_lgr l
                                       where l.lgr_platz_gruppe = v_lgr_ziel.lgr_platz_gruppe);
          -- Diese Paletten sollen jetzt als Gruppe vorgezogen werden
          -- damit der manuelle Satelit nicht immer hin und her gefahren wird
          -- sollen vorgezogen werden
          update isi_transport t
             set t.prio = v_max_prio
           where t.transport_gruppe <= in_transport.transport_gruppe
             and t.prio != v_max_prio
             and t.lgr_platz_quelle = in_transport.lgr_platz_quelle
             and t.transp_id <= v_max_tr_id;

        end if;
      end if;
    end if;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
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


end term_transp;
/



-- sqlcl_snapshot {"hash":"3e8e711dba924a4bb0359a337a57f0187cace75c","type":"PACKAGE_BODY","name":"TERM_TRANSP","schemaName":"DIRKSPZM32","sxml":""}