create or replace 
package body DIRKSPZM32.tms_p_loading is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  05.03.2009
  __________________________________________________
  Description
  TMS TransportManagementSystem Loading Funktionen
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  05.03.2009   3.4.10.1    (-WK-)   package created
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

  function get_version return varchar2 is
  begin
    return(to_char(v_release_major) || '.' ||
           to_char(v_release_minor) || '.' ||
           to_char(v_revision) || '.' ||
           to_char(v_build_number) || ' / ' ||
           v_rev_date);
  end;

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


  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/
  procedure c_activate_loading(in_vorgang_id in tms_loading_points.order_vorgang_id%type,
                               in_lgr_platz in tms_loading_points.lgr_platz%type,
                               in_login_id in tms_loading_points.last_change_login_id%type,
                               in_firma_nr in tms_loading_points.firma_nr%type,
                               in_sid in tms_loading_points.sid%type) is
    v_transp_result number;
    v_transport_gruppe number;
    v_trans_id isi_transport.transp_id%type;
    v_loading_point tms_loading_points%rowtype;
    v_lte lvs_lte%rowtype;
    v_order_p isi_order_pos%rowtype;
    v_order_k isi_order_kopf%rowtype;
    v_transport isi_transport%rowtype;

    cursor c_order_lte_list is
      select t.*
        from lvs_lte t
       where t.order_vorgang_id = in_vorgang_id
       order by
             (select max(tr.transp_id) -- die letzte transport id für diese LTE ist maßgeblich für die transportreihenfolge zum tor
                from isi_transport tr
               where tr.lte_id = t.lte_id);

    cursor c_transp_by_lte is
      select t.*
        from isi_transport t
       where t.lte_id = v_lte.lte_id
       order by t.transp_id desc; -- immer den letzten Transport holen

  begin
    if not tms_p_base.get_loading_point(in_lgr_platz, in_firma_nr, in_sid, v_loading_point)
    then
      raise_isi_error(10, lc.ec_p1('O_TP1_TMS_LP_NA', in_lgr_platz));
    end if;

    if v_loading_point.status = 'FR'
    then
      raise_isi_error(20, lc.ec_p1('O_TP1_TMS_LP_VEHIC_N_ASSGN', in_lgr_platz));
    end if;

    if v_loading_point.status = 'CL'
    then
      raise_isi_error(30, lc.ec_p1('O_TP1_TMS_LP_IS_CLOSED', in_lgr_platz));
    end if;

    if v_loading_point.status != 'RES'
    then
      raise_isi_error(40, lc.ec_p1('O_TP1_TMS_LP_IS_OCCUPIED', in_lgr_platz));
    end if;

    update tms_loading_points t
       set t.order_vorgang_id = in_vorgang_id,
           t.loading_start_time = sysdate,
           t.status = 'OCC', -- belegt
           t.last_change_date = sysdate,
           t.last_change_login_id = in_login_id
     where t.lgr_platz = in_lgr_platz
       and t.firma_nr = in_firma_nr
       and t.sid = in_sid;

    open c_order_lte_list;
    loop
      fetch c_order_lte_list into v_lte;
      exit when c_order_lte_list%notfound;

      if not isi_p_order_base.get_order_pos(in_sid, v_lte.order_auf_id, v_order_p)
      then
        v_order_p := null;
      end if;

      if not isi_p_order_base.get_order_kopf(v_order_p.vorgang_id, v_order_p.vorgang_typ,
                                             v_order_p.li_nr, v_order_p.firma_nr, v_order_p.sid,
                                             v_order_k)
      then
        v_order_k := null;
      end if;

      open c_transp_by_lte;
      fetch c_transp_by_lte into v_transport;
      if c_transp_by_lte%notfound
      then
        v_transport := null;
      end if;
      close c_transp_by_lte;

      if nvl(v_transport.lgr_platz_ziel, v_lte.lgr_platz) is not null
         and nvl(v_transport.lgr_platz_ziel, v_lte.lgr_platz) != in_lgr_platz
      then
        -- -WK- 20090415: Transportgruppe aus der immer aus isi_order nehmen
        -- wegen umgekehrter Verladereihenfolge mit -1 multiplizieren
        v_transport_gruppe := v_order_p.transport_gruppe * -1;
        v_transp_result := lvs_transport.lvs_transp_lte(in_sid,
                                                        in_firma_nr,
                                                        'TMS', --in_modul_erzeuger,
                                                        'SLS', --in_modul_bearbeiter,
                                                        c.c_false, --in_frei_fahren
                                                        'A', --in_trans_typ
                                                        in_login_id,
                                                        v_order_p.auf_id, -- in_auftrag_id
                                                        v_order_p.auf_id_extern, -- in_auftrag_id_extern
                                                        nvl(v_order_p.prioritaet, 3), -- in_prio
                                                        0, 0, 0, -- in_progr_nr, in_quelle_leer_progr_nr, in_ziel_voll_progr_nr,
                                                        nvl(v_transport.lgr_platz_ziel, v_lte.lgr_platz), -- in_lgr_quell_lgr_platz,
                                                        in_lgr_platz, -- in_lgr_ziel_lgr_platz,
                                                        v_lte.lte_id, -- in_lte_id,
                                                        nvl(v_transport.kunden_nr, nvl(v_order_k.adress_id, 0)), -- in_kunde_nr,
                                                        nvl(v_transport.lieferschein, c.c_true), -- in_lieferschein,
                                                        v_order_p.li_nr, -- in_li_nr,
                                                        v_order_p.li_pos_nr, -- in_li_pos_nr,
                                                        in_vorgang_id,
                                                        null, -- in_fahrzeuge_ids,
                                                        null, -- in_lkw_nr,
                                                        v_transport_gruppe,
                                                        v_trans_id,
                                                        v_transport.transp_id,
                                                        null);
        if not v_transport.transp_id is null
        then
          -- es ist noch ein Transport aktiv, also Staffeltransport sperren
          v_transp_result := lvs_transport.transport_sperren(in_sid,
                                                             in_firma_nr,
                                                             in_login_id,
                                                             v_trans_id);
        end if;
      end if;
    end loop;

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

  procedure c_loading_complete(in_vorgang_id in tms_loading_points.order_vorgang_id%type,
                               in_lgr_platz  in tms_loading_points.lgr_platz%type,
                               in_login_id   in tms_loading_points.last_change_login_id%type,
                               in_firma_nr   in tms_loading_points.firma_nr%type,
                               in_sid        in tms_loading_points.sid%type) is
    v_li_nr isi_order_kopf.li_nr%type;
    -- KONSI-Lager berücksichtigen
    cursor c_order_lief is
      select t.li_nr
        from isi_order_kopf t
       where t.vorgang_id = in_vorgang_id
         and t.vorgang_typ in ('WAE', 'KWA')
         and t.satzart  in ('LI', 'RL', 'LK')
         and t.firma_nr = in_firma_nr
         and t.sid = in_sid;
  begin
    open c_order_lief;
    loop
      fetch c_order_lief into v_li_nr;
      exit when c_order_lief%notfound;

      isi_p_order.c_lief_ende(in_sid, in_firma_nr, v_li_nr, in_login_id, in_vorgang_id);
    end loop;

    -- wenn alle Lieferscheine abgeschlossen sind, Tor/Verladepunkt freigeben
    update tms_loading_points t
       set t.order_vorgang_id = null,
           t.status = 'FR', -- free
           t.vehicle_number_plate = null,
           t.arrival_time = null,
           t.loading_start_time = null,
           t.departure_time = null,
           t.driver_name = null,
           t.loading_temp_cent = null,
           t.vehicle_temp_cent = null,
           t.address_id_carrier = null,
           t.info = null,
           t.last_change_date = sysdate,
           t.last_change_login_id = in_login_id
     where t.lgr_platz = in_lgr_platz
       and t.firma_nr = in_firma_nr
       and t.sid = in_sid;

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

  --------------------------------------------------------------------------------
  -- function dupliziert eine ISI_ORDER (Nur den Kopf) aus eine Position mit AUF_ID
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure c_dup_order_kopf_by_auf_id(in_sid                 in isi_sid.sid%type,
                                       in_firma_nr            in isi_firma.firma_nr%type,
                                       in_auf_id              in isi_order_pos.auf_id%type,
                                       in_user_id             in isi_user.login_id%type,
                                       in_out_new_vorgang_id  in out isi_order_kopf.vorgang_id%type,
                                       in_out_new_li_nr       in out isi_order_kopf.li_nr%type
                                      ) is

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     exception;
    v_err_nr    number;
    v_err_text  varchar2(255);
    -------------------------------------------------------------------------------------------------------

    v_order_pos_row         isi_order_pos%rowtype;

    v_found          boolean;

  begin
    v_err_nr := null;

    v_found := isi_p_order_base.get_order_pos(in_sid => in_sid,
                                              in_auf_id => in_auf_id,
                                              io_order_pos => v_order_pos_row);

    if not v_found
    then
      v_err_nr := 20;
      v_err_text := LC.ec_p1(LC.O_TP1_ORDER_AUF_ID_FEHLT, in_auf_id);
      -- v_err_text := 'Ordernummer ' || nvl(to_char(v_transport.auf_id), '(NULL)') || ' konnte nicht gefunden werden.';
      raise v_error;
    end if;

    tms_p_loading.c_dup_order_kopf(in_sid => in_sid,
                                   in_firma_nr => in_firma_nr,
                                   in_vorgang_id => v_order_pos_row.vorgang_id,
                                   in_li_nr => v_order_pos_row.li_nr,
                                   in_user_id => in_user_id,
                                   in_out_new_vorgang_id => in_out_new_vorgang_id,
                                   in_out_new_li_nr => in_out_new_li_nr);


  end;

  --------------------------------------------------------------------------------
  -- function dupliziert eine ISI_ORDER (Nur den Kopf)
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure c_dup_order_kopf (in_sid                 in isi_sid.sid%type,
                              in_firma_nr            in isi_firma.firma_nr%type,
                              in_vorgang_id          in isi_order_kopf.vorgang_id%type,
                              in_li_nr               in isi_order_kopf.li_nr%type,
                              in_user_id             in isi_user.login_id%type,
                              in_out_new_vorgang_id  in out isi_order_kopf.vorgang_id%type,
                              in_out_new_li_nr       in out isi_order_kopf.li_nr%type
                             ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     exception;
    v_err_nr    number;
    v_err_text  varchar2(255);
    -------------------------------------------------------------------------------------------------------

    v_order_kopf_row isi_order_kopf%rowtype;
    v_new_li_nr      isi_order_kopf.li_nr%type;
    v_new_vorgang_id isi_order_kopf.vorgang_id%type;

    v_found          boolean;

  begin
    v_err_nr := null;

    v_found := isi_p_order_base.get_order_kopf(in_vorgang_id => in_vorgang_id,
                                              in_vorgang_typ => NULL,
                                              in_li_nr => in_li_nr,
                                              in_firma_nr => in_firma_nr,
                                              in_sid => in_sid,
                                              io_order_kopf => v_order_kopf_row);
    if not v_found
    then
      v_err_nr := 10;
      v_err_text := LC.ec_p2(LC.O_TP2_ORDER_VORG_KOPF_FEHLT, in_vorgang_id, in_li_nr);
      --v_err_text := 'Fehler: Kopfdaten für Tour: ' || v_pos.vorgang_id || ' Lieferschein ' || v_pos.li_nr || ' nicht vorhanden!';
      raise v_error;
    end if;
    if v_order_kopf_row.liefer_datum < trunc(sysdate)
    then
      v_order_kopf_row.liefer_datum := null;
    end if;
    if in_out_new_vorgang_id is NULL
    then
      select SEQ_TMS_ORDER_VORGANG_ID.Nextval into in_out_new_vorgang_id from dual;
    end if;
    if in_out_new_li_nr is NULL
    then
      select SEQ_TMS_ORDER_LI_NR.Nextval into in_out_new_li_nr from dual;
    end if;

    insert into isi_order_kopf
    values (v_order_kopf_row.sid,
            v_order_kopf_row.firma_nr,
            v_order_kopf_row.vorgang_typ,
            in_out_new_vorgang_id,
            in_out_new_li_nr,
            v_order_kopf_row.be_nr,
            v_order_kopf_row.satzart,
            v_order_kopf_row.adress_id,
            v_order_kopf_row.order_adress_id,
            in_user_id,
            v_order_kopf_row.arbeitsplatz_id,
            v_order_kopf_row.strategie,
            v_order_kopf_row.order_info,
            'N', -- status Neu
            v_order_kopf_row.quell_lagerorte,
            v_order_kopf_row.quelle,
            v_order_kopf_row.ziel,
            v_order_kopf_row.wae_ziel,
            v_order_kopf_row.besteller,
            v_order_kopf_row.freigabe,
            v_order_kopf_row.freigabe_datum, --freigabe_datum,
            null, --freigegeben_datum,
            v_order_kopf_row.order_datum, --order_datum, (wird im trigger gesetzt)
            v_order_kopf_row.liefer_datum,
            null, --fertig_datum,
            v_order_kopf_row.lvs_info,
            v_order_kopf_row.prioritaet,
            v_order_kopf_row.anbruch,
            v_order_kopf_row.ohne_transport,
            v_order_kopf_row.ohne_transp_anz,
            v_order_kopf_row.lkw_nr,
            v_order_kopf_row.transport_gruppe,
            null,
            null,
            v_order_kopf_row.sp_adress_id,
            null,  -- Zeit muss dann neu berechnet werden da Status Neu KOMM_ZEIT_SEC N NUMBER  Y     Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für diese Pos
            null,  -- Zeit muss dann neu berechnet werden da Status Neu TRANSP_ZEIT_SEC N NUMBER  Y     Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.
            null)  -- Zeit muss dann neu berechnet werden da Status Neu STARTZEITPUNKT_BERECHNET  N DATE  Y     Berechneter Startzeitpunkt für diese Position

    returning vorgang_id into in_out_new_vorgang_id;

    if in_out_new_vorgang_id is not null
    then

      begin
        insert into isi_order_tour
        select in_out_new_vorgang_id,
               t.tour,
               t.pack_lgr_platz,  -- PACK_LGR_PLATZ N VARCHAR2(30)  Y     Reservierter Packplatz nachdem er zugeordnet wurde
               NULL,              -- KOMM_ZEIT_SEC  N NUMBER  Y     Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für alle Positionen
               NULL,              -- TRANSP_ZEIT_SEC  N NUMBER  Y     Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.
               NULL               -- STARTZEITPUNKT_BERECHNET N DATE  Y     Berechneter Startzeitpunkt für die erste Posion dieser Klammer
          from isi_order_tour t
         where t.vorgang_id = v_order_kopf_row.vorgang_id;
      exception
        when others then NULL;    -- Jeglichen Fehler ignorieren
      end;
    end if;
    commit;
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt
    when v_error then
      rollback;
      raise_application_error(-20000 - v_err_nr, v_err_text);
    when others then
      rollback;
      if v_err_nr is not NULL then
        raise_application_error(-20000 - v_err_nr, v_err_text, true);
      else
        raise;
      end if;
  end;
  --------------------------------------------------------------------------------
  -- function dupliziert eine ISI_ORDER_POS
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure c_dup_order_pos(in_sid                 in isi_sid.sid%type,
                            in_firma_nr            in isi_firma.firma_nr%type,
                            in_auf_id              in isi_order_pos.auf_id%type,
                            in_user_id             in isi_user.login_id%type,
                            in_new_vorgang_id      in isi_order_kopf.vorgang_id%type,
                            in_new_li_nr           in isi_order_kopf.li_nr%type,
                            in_out_auf_id          in out isi_order_pos.auf_id%type
                           ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     exception;
    v_err_nr    number;
    v_err_text  varchar2(255);
    -------------------------------------------------------------------------------------------------------

    v_order_pos_row         isi_order_pos%rowtype;

    v_order_kopf_row isi_order_kopf%rowtype;
    v_new_li_nr      isi_order_kopf.li_nr%type;
    v_new_vorgang_id isi_order_kopf.vorgang_id%type;
    v_vorgang_pos    isi_order_pos.vorgang_pos%type;
    v_li_pos         isi_order_pos.li_pos_nr%type;
    v_ab_upos        isi_order_pos.li_pos_nr%type;

    v_found          boolean;

  begin
    v_err_nr := null;

    v_found := isi_p_order_base.get_order_kopf(in_vorgang_id => in_new_vorgang_id,
                                              in_vorgang_typ => NULL,
                                              in_li_nr => in_new_li_nr,
                                              in_firma_nr => in_firma_nr,
                                              in_sid => in_sid,
                                              io_order_kopf => v_order_kopf_row);
    if not v_found
    then
      v_err_nr := 10;
      v_err_text := LC.ec_p2(LC.O_TP2_ORDER_VORG_KOPF_FEHLT, in_new_vorgang_id, in_new_li_nr);
      --v_err_text := 'Fehler: Kopfdaten für Tour: ' || v_pos.vorgang_id || ' Lieferschein ' || v_pos.li_nr || ' nicht vorhanden!';
      raise v_error;
    end if;

    v_found := isi_p_order_base.get_order_pos(in_sid => in_sid,
                                              in_auf_id => in_auf_id,
                                              io_order_pos => v_order_pos_row);

    if not v_found
    then
      v_err_nr := 20;
      v_err_text := LC.ec_p1(LC.O_TP1_ORDER_AUF_ID_FEHLT, in_auf_id);
      -- v_err_text := 'Ordernummer ' || nvl(to_char(v_transport.auf_id), '(NULL)') || ' konnte nicht gefunden werden.';
      raise v_error;
    end if;

    select max(x.upos_nr) into v_ab_upos
      from isi_order_pos x
     where x.auftrag = v_order_pos_row.auftrag
       and x.pos_nr = v_order_pos_row.pos_nr;

    select max(x.vorgang_pos) into v_vorgang_pos
      from isi_order_pos x
     where x.vorgang_id = in_new_vorgang_id;
    v_vorgang_pos := nvl(v_vorgang_pos, 0) + 1;

    select max(x.li_pos_nr) into v_li_pos
      from isi_order_pos x
     where x.li_nr = in_new_li_nr;
    v_li_pos := nvl(v_li_pos, 0) + 1;

    insert into isi_order_pos
    select op.sid,
           op.firma_nr,
           null, -- auf_id
           op.auf_id_extern, -- auf_id_extern
           op.vorgang_typ,
           in_new_vorgang_id,
           v_vorgang_pos,
           v_order_kopf_row.transport_gruppe,
           op.satzart,
           op.auftrag,
           op.pos_nr,
           nvl(v_ab_upos, op.upos_nr) + 1,
           op.artikel_id,
           decode(v_order_kopf_row.status,
                                      'N', 'F',
                                      'V', 'F',
                                      'T'), -- ware_disponiert
           in_user_id,
           op.arbeitsplatz_id,
           op.leitzahl,
           op.fa_ag,
           op.fa_upos,
           op.charge_id,
           op.seriennr_id,
           v_order_kopf_row.strategie, --strategie, aus Kopf
           op.mhd,
           op.li_extern,
           in_new_li_nr,
           v_li_pos,
           op.order_info, -- order_info
           0, -- soll_menge
           0, -- ist_menge
           op.menge_basis,
           op.mengeneinheit,
           v_order_kopf_row.status, -- status Neu
           op.quell_lagerorte,
           op.quelle,
           op.ziel,
           v_order_kopf_row.wae_ziel, --op.wae_ziel, aus Kopf
           op.besteller,
           op.freigabe,
           null, -- freigabe_datum,
           null, -- freigegeben_datum,
           null, -- order_datum, (wird im trigger gesetzt)
           v_order_kopf_row.liefer_datum, --op.liefer_datum, aus Kopf
           null, -- fertig_datum,
           null, -- lvs_info,
           op.prioritaet,
           op.anbruch,
           op.min_mhd_tage,
           op.min_reifezeit,
           0, -- op.brutto_kg,
           op.best_nr_kunde,
           op.wa_menge_ueberlief,
           op.zeichnung_index,
           op.lam_sel1,
           op.lam_sel2,
           op.lam_sel3,
           op.lam_sel4,
           op.lam_sel5,
           op.lam_sel6,
           op.lam_sel7,
           op.lam_sel8,
           op.lam_sel9,
           op.lam_sel10,
           0, --op.kom_mg,
           op.kom_mengeneinheit,
           op.kom_lgr_orte,
           op.labor_status,
           op.ziel_packschema_kopf_id,
           op.ziel_lte_name,
           op.ziel_lhm_name,
           op.komplett_reservieren,
           op.komplett_bereitstellen,
           op.auto_depal,
           op.ziel_lhm_menge,
           op.komm_vorgabe_auto_depal,
           null,  -- Zeit muss dann neu berechnet werden da Status Neu KOMM_ZEIT_SEC  N NUMBER  Y     Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für diese Pos
           null,  -- Zeit muss dann neu berechnet werden da Status Neu TRANSP_ZEIT_SEC  N NUMBER  Y     Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.
           null,   -- Zeit muss dann neu berechnet werden da Status Neu STARTZEITPUNKT_BERECHNET  N DATE  Y     Berechneter Startzeitpunkt für diese Position
           op.prod_params
      from isi_order_pos op
     where op.sid = in_sid
       and op.firma_nr = in_firma_nr
       and op.auf_id = in_auf_id;

    in_out_auf_id := seq_isi_order.currval;
    commit;
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt
    when v_error then
      rollback;
      raise_application_error(-20000 - v_err_nr, v_err_text);
    when others then
      rollback;
      if v_err_nr is not NULL then
        raise_application_error(-20000 - v_err_nr, v_err_text, true);
      else
        raise;
      end if;
  end;

  --------------------------------------------------------------------------------
  -- function prüft eine eine ISI_ORDER_KOPF auf Lieferschein, Vorgang_ID und Artikel
  --------------------------------------------------------------------------------
  /*
     Auftragskopf (ISI_ORDER) anhand des Vorgangs, des Vorgangstyps
     und der Lieferschiennummer ermitteln und zurückliefern.

     ---- HISTORY ---
     30.10.2018 -HJG- Erstellt

     @param in_vorgang_id   Vorgangsnummer des Auftragskopfes
     @param in_li_nr        Lieferscheinnummer des Auftragskopfes
     @param in_firma_nr     (optinal) FirmaNr, ehem. Bestandteil des PK
     @param in_sid          (optinal) SID, ehem. Bestandteil des PK

     @returns             True, wenn für den definierten Schlüssel
                          ein Datensatz gefunden wurde. Sonst False.
  */
  --******************************************************************************
  function chk_order_kopf_by_li_nr_vor_id(in_sid                 in isi_sid.sid%type,
                                          in_firma_nr            in isi_firma.firma_nr%type,
                                          in_vorgang_id          in isi_order_kopf.vorgang_id%type,
                                          in_li_nr               in isi_order_kopf.li_nr%type
                                         ) return boolean
                                         is
    v_order_kopf_row isi_order_kopf%rowtype;

  begin
    return isi_p_order_base.get_order_kopf (in_vorgang_id => in_vorgang_id,
                                            in_vorgang_typ => NULL,
                                            in_li_nr => in_li_nr,
                                            in_firma_nr => in_firma_nr,
                                            in_sid => in_sid,
                                            io_order_kopf => v_order_kopf_row);


  end;

  --------------------------------------------------------------------------------
  -- function prüft eine eine ISI_ORDER_POS auf Lieferschein, Vorgang_ID und Artikel
  --------------------------------------------------------------------------------
  /*
     Auftragspos (ISI_ORDER) anhand des Vorgangs, des Vorgangstyps
     und der Lieferschiennummer ermitteln und zurückliefern.

     ---- HISTORY ---
     30.10.2018 -HJG- Erstellt

     @param in_vorgang_id   Vorgangsnummer des Auftragskopfes
     @param in_vorgang_typ  Vorgangtyp des Auftragskopfes
     @param in_li_nr        Lieferscheinnummer des Auftragskopfes
     @param in_firma_nr     (optinal) FirmaNr, ehem. Bestandteil des PK
     @param in_sid          (optinal) SID, ehem. Bestandteil des PK

     @returns             True, wenn für den definierten Schlüssel
                          ein Datensatz gefunden wurde. Sonst False.
  */
  --******************************************************************************
  function chk_order_pos_by_li_nr_artikel(in_sid                 in isi_sid.sid%type,
                                          in_firma_nr            in isi_firma.firma_nr%type,
                                          in_artikel_id          in isi_artikel.artikel_id%type,
                                          in_vorgang_id          in isi_order_kopf.vorgang_id%type,
                                          in_li_nr               in isi_order_kopf.li_nr%type
                                         ) return boolean
                                         is
    v_order_pos_row         isi_order_pos%rowtype;

  begin
    return isi_p_order_base.get_order_pos_by_li_nr_artikel(in_sid => in_sid,
                                                           in_firma_nr => in_firma_nr,
                                                           in_artikel_id => in_artikel_id,
                                                           in_vorgang_id => in_vorgang_id,
                                                           in_li_nr => in_li_nr,
                                                           out_order_pos_row => v_order_pos_row);

  end;

end tms_p_loading;
/



-- sqlcl_snapshot {"hash":"0adcf1a7fb650ea1fade8fbaa5c33d623a09d564","type":"PACKAGE_BODY","name":"TMS_P_LOADING","schemaName":"DIRKSPZM32","sxml":""}