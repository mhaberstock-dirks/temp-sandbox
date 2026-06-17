create or replace 
package body DIRKSPZM32.lvs_transport is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  14.08.2006 16:30:12
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  15.02.2017   3.5.10.1    (-AG-)   Transport löschen bei Transport GRP eingebaut
  30.11.2009   3.5.0.1     (-BW-)   BugFix Aktivierung_Prio -> Aktivierung_Prio
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
               3.4.2.1              BugFix Transport Fertig auf einem WE hatte die LTE den Status LF und nicht BF
               3.3.4.2              BugFix im Transport löschen
               3.3.4.1              Funktionen Transport sperren unf freigeben eingebaut
               3.3.4.0              Einbau der Versionierung
  */



  v_version_str    constant  varchar2(30) := '3.5.10.1 / 16.02.2017';

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error        EXCEPTION;
  v_err_nr       number;
  v_err_text     varchar2(2550);

  procedure transport_grp_sub(in_sid                   in isi_sid.sid%type,
                              in_firma_nr              in isi_firma.firma_nr%type,
                              in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                              in_lte_id                in isi_transport_grp.lte_grp_id%type,
                              in_user_ID               in isi_user.login_id%TYPE);

  FUNCTION lvs_transp_fertig_buchen(in_sid          in isi_sid.sid%type,
                                    in_firma_nr     IN isi_firma.firma_nr%TYPE,
                                    in_user_id      IN isi_user.login_id%TYPE,
                                    in_transport_id IN isi_transport.transp_id%TYPE,
                                    in_lte_id       in lvs_lte.lte_id%type,
                                    in_res_id       in isi_resource.res_id%type,
                                    in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                    in_ausgelagert  in varchar2,
                                    in_offset_x     in lvs_lte.lte_offset_x%type,
                                    in_offset_y     in lvs_lte.lte_offset_y%type,
                                    in_offset_z     in lvs_lte.lte_offset_z%type) RETURN INTEGER;

  FUNCTION lvs_transp_loeschen_buchen(in_sid             in isi_sid.sid%type,
                                      in_firma_nr        in isi_firma.firma_nr%type,
                                      in_user_id         in isi_user.login_id%type,
                                      in_transport_id    in isi_transport.transp_id%type,
                                      in_immer_loeschen  in varchar2)
                                      RETURN INTEGER;
  -------------------------------------------------------------------------
  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

   -------------------------------------------------------------------------
  -- Traegt den transport eien Palette ein. Setzt alle DISPOS etc.
  -- und sperrt den Transport
  -------------------------------------------------------------------------
  function lvs_c_gesperrter_transp_lte (in_sid                  in isi_sid.sid%TYPE,
                                        in_firma_nr             in isi_firma.firma_nr%TYPE,
                                        in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                        in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                        in_frei_fahren          in varchar2,
                                        in_trans_typ            in varchar2,
                                        in_user_ID              in isi_user.login_id%TYPE,
                                        in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                                        in_auftrag_id_extern    in isi_transport.Auf_Id_extern%TYPE,
                                        in_prio                 in isi_transport.Prio%TYPE,
                                        in_progr_nr             in isi_transport.progr_nr%TYPE,
                                        in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                        in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                        in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                                        in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                                        in_lte_id               in lvs_lte.lte_id%TYPE,
                                        in_kunde_nr             in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                                        in_lieferschein         in isi_transport.lieferschein%type,
                                        in_li_nr                in isi_transport.li_nr%type,
                                        in_li_pos_nr            in isi_transport.li_pos_nr%type,
                                        in_vorgang_id           in isi_transport.vorgang_id%type,
                                        in_fahrzeuge_IDs        in varchar2,
                                        in_lkw_nr               in isi_transport.lkw_nr%type,
                                        in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                                        out_transp_id           out isi_transport.transp_id%type)
    return number is

    v_result       number;
    v_transp_id    isi_transport.transp_id%type;
  begin
     v_result := lvs_gesperrter_transp_lte  (in_sid,
                                             in_firma_nr,
                                             in_modul_erzeuger,
                                             in_modul_bearbeiter,
                                             in_frei_fahren,
                                             in_trans_typ,
                                             in_user_ID,
                                             in_auftrag_id,
                                             in_auftrag_id_extern,
                                             in_prio,
                                             in_progr_nr,
                                             in_quelle_Leer_progr_nr,
                                             in_ziel_voll_Progr_nr,
                                             in_lgr_quell_lgr_platz,
                                             in_lgr_ziel_lgr_platz,
                                             in_lte_id,
                                             in_kunde_nr,
                                             in_lieferschein,
                                             in_li_nr,
                                             in_li_pos_nr,
                                             in_vorgang_id,
                                             in_fahrzeuge_IDs,             -- in_fahrzeuge_IDs Transport soll in jedem Fall erzeugt werden, auch wenn das Fahrzeug gestört ist
                                             in_lkw_nr,
                                             in_out_transport_gruppe,
                                             v_transp_id);

    commit;
    return (v_result);
  end lvs_c_gesperrter_transp_lte;
   -------------------------------------------------------------------------
  -- Traegt den transport eien Palette ein. Setzt alle DISPOS etc.
  -- und sperrt den Transport
  -------------------------------------------------------------------------
  function lvs_gesperrter_transp_lte(in_sid                  in isi_sid.sid%TYPE,
                          in_firma_nr             in isi_firma.firma_nr%TYPE,
                          in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                          in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                          in_frei_fahren          in varchar2,
                          in_trans_typ            in varchar2,
                          in_user_ID              in isi_user.login_id%TYPE,
                          in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                          in_auftrag_id_extern    in isi_transport.Auf_Id_extern%TYPE,
                          in_prio                 in isi_transport.Prio%TYPE,
                          in_progr_nr             in isi_transport.progr_nr%TYPE,
                          in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                          in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                          in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                          in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                          in_lte_id               in lvs_lte.lte_id%TYPE,
                          in_kunde_nr             in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                          in_lieferschein         in isi_transport.lieferschein%type,
                          in_li_nr                in isi_transport.li_nr%type,
                          in_li_pos_nr            in isi_transport.li_pos_nr%type,
                          in_vorgang_id           in isi_transport.vorgang_id%type,
                          in_fahrzeuge_IDs        in varchar2,
                          in_lkw_nr               in isi_transport.lkw_nr%type,
                          in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                          out_transp_id           out isi_transport.transp_id%type,
                          in_parent_transp_id     in isi_transport.transp_id%type default NULL,
                          in_fetig_bis            in date default NULL)
    return number is

    v_result       number;
    v_transp_id    isi_transport.transp_id%type;
  begin
     v_result := lvs_transp_lte (in_sid,
                                 in_firma_nr,
                                 in_modul_erzeuger,
                                 in_modul_bearbeiter,
                                 in_frei_fahren,
                                 in_trans_typ,
                                 in_user_ID,
                                 in_auftrag_id,
                                 in_auftrag_id_extern,
                                 in_prio,
                                 in_progr_nr,
                                 in_quelle_Leer_progr_nr,
                                 in_ziel_voll_Progr_nr,
                                 in_lgr_quell_lgr_platz,
                                 in_lgr_ziel_lgr_platz,
                                 in_lte_id,
                                 in_kunde_nr,
                                 in_lieferschein,
                                 in_li_nr,
                                 in_li_pos_nr,
                                 in_vorgang_id,
                                 in_fahrzeuge_IDs,             -- in_fahrzeuge_IDs Transport soll in jedem Fall erzeugt werden, auch wenn das Fahrzeug gestört ist
                                 in_lkw_nr,
                                 in_out_transport_gruppe,
                                 v_transp_id,
                                 in_parent_transp_id,
                                 in_fetig_bis);

    if v_result != 0
    then
      v_err_nr := 10;
      v_err_text := c.decode_function_fehler(v_result);
      raise v_error;
    end if;

    v_result := lvs_transport.transport_sperren(in_sid, in_firma_nr, in_user_ID, v_transp_id);

    return (v_result);
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


  -------------------------------------------------------------------------
  -- Traegt den transport eien Palette ein. Setzt alle DISPOS etc.
  -------------------------------------------------------------------------
  function lvs_transp_lte_intern (in_sid                  in isi_sid.sid%TYPE,
                                  in_firma_nr             in isi_firma.firma_nr%TYPE,
                                  in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                  in_user_ID              in isi_user.login_id%TYPE,
                                  in_prio                 in isi_transport.Prio%TYPE,
                                  in_lte_id               in lvs_lte.lte_id%TYPE,
                                  in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_fahrzeuge_IDs        in varchar2,
                                  in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                                  out_transp_id           out isi_transport.transp_id%type,
                                  in_fetig_bis            in date default NULL
                                  )
    return number is

    v_result       number;
    
  begin
   
     v_result := lvs_transp_lte_353 (in_sid,
                                     in_firma_nr,
                                     in_modul_erzeuger,
                                     NULL,                                -- in_modul_bearbeiter,
                                     'F',                                 -- in_frei_fahren,
                                     NULL,                                -- in_trans_typ,
                                     in_user_ID,
                                     NULL,                                -- in_auftrag_id,
                                     NULL,                                -- in_auftrag_id_extern,
                                     in_prio,
                                     0,                                   -- in_progr_nr,
                                     0,                                   -- in_quelle_Leer_progr_nr,
                                     0,                                   -- in_ziel_voll_Progr_nr,
                                     in_lgr_quell_lgr_platz,
                                     in_lgr_ziel_lgr_platz,
                                     in_lte_id,
                                     NULL,                                -- in_kunde_nr,
                                     'F',                                 -- in_lieferschein,
                                     NULL,                                -- in_li_nr,
                                     NULL,                                -- in_li_pos_nr,
                                     NULL,                                -- in_vorgang_id,
                                     in_fahrzeuge_IDs,                    -- in_fahrzeuge_IDs Transport soll in jedem Fall erzeugt werden, auch wenn das Fahrzeug gestört ist
                                     NULL,                                -- in_lkw_nr,
                                     NULL,                                -- in_komm_id                 in isi_transport.p_komm_id%type,
                                     NULL,                                -- in_komm_lte_lhm_lagen      in isi_transport.p_komm_lte_lhm_lagen%type,
                                     NULL,                                -- in_komm_lte_lhm_pro_lage   in isi_transport.p_komm_lte_lhm_pro_lage%type,
                                     NULL,                                -- in_komm_lhm_hoehe_lage     in isi_transport.p_komm_lhm_hoehe_lage%type,
                                     NULL,                                -- in_komm_packscheme_kopf_id in isi_transport.p_komm_packschema_kopf_id%type,
                                     in_out_transport_gruppe,
                                     out_transp_id,
                                     NULL,                                -- in_parent_transp_id,
                                     in_fetig_bis
                                     );

    return (v_result);
    
  end;

  -------------------------------------------------------------------------
  -- Traegt den transport eien Palette ein. Setzt alle DISPOS etc.
  -------------------------------------------------------------------------
  function lvs_transp_lte(in_sid                  in isi_sid.sid%TYPE,
                          in_firma_nr             in isi_firma.firma_nr%TYPE,
                          in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                          in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                          in_frei_fahren          in varchar2,
                          in_trans_typ            in varchar2,
                          in_user_ID              in isi_user.login_id%TYPE,
                          in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                          in_auftrag_id_extern    in isi_transport.Auf_Id_extern%TYPE,
                          in_prio                 in isi_transport.Prio%TYPE,
                          in_progr_nr             in isi_transport.progr_nr%TYPE,
                          in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                          in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                          in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                          in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                          in_lte_id               in lvs_lte.lte_id%TYPE,
                          in_kunde_nr             in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                          in_lieferschein         in isi_transport.lieferschein%type,
                          in_li_nr                in isi_transport.li_nr%type,
                          in_li_pos_nr            in isi_transport.li_pos_nr%type,
                          in_vorgang_id           in isi_transport.vorgang_id%type,
                          in_fahrzeuge_IDs        in varchar2,
                          in_lkw_nr               in isi_transport.lkw_nr%type,
                          in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                          out_transp_id           out isi_transport.transp_id%type,
                          in_parent_transp_id     in isi_transport.transp_id%type default NULL,
                          in_fetig_bis            in date default NULL
                          )
    return number is

    v_result       number;

  begin
     v_result := lvs_transp_lte_353 (in_sid,
                                     in_firma_nr,
                                     in_modul_erzeuger,
                                     in_modul_bearbeiter,
                                     in_frei_fahren,
                                     in_trans_typ,
                                     in_user_ID,
                                     in_auftrag_id,
                                     in_auftrag_id_extern,
                                     in_prio,
                                     in_progr_nr,
                                     in_quelle_Leer_progr_nr,
                                     in_ziel_voll_Progr_nr,
                                     in_lgr_quell_lgr_platz,
                                     in_lgr_ziel_lgr_platz,
                                     in_lte_id,
                                     in_kunde_nr,
                                     in_lieferschein,
                                     in_li_nr,
                                     in_li_pos_nr,
                                     in_vorgang_id,
                                     in_fahrzeuge_IDs,             -- in_fahrzeuge_IDs Transport soll in jedem Fall erzeugt werden, auch wenn das Fahrzeug gestört ist
                                     in_lkw_nr,
                                     NULL,                         -- in_komm_id                 in isi_transport.p_komm_id%type,
                                     NULL,                         -- in_komm_lte_lhm_lagen      in isi_transport.p_komm_lte_lhm_lagen%type,
                                     NULL,                         -- in_komm_lte_lhm_pro_lage   in isi_transport.p_komm_lte_lhm_pro_lage%type,
                                     NULL,                         -- in_komm_lhm_hoehe_lage     in isi_transport.p_komm_lhm_hoehe_lage%type,
                                     NULL,                         -- in_komm_packscheme_kopf_id in isi_transport.p_komm_packschema_kopf_id%type,
                                     in_out_transport_gruppe,
                                     out_transp_id,
                                     in_parent_transp_id,
                                     in_fetig_bis
                                     );

    return (v_result);
    
  end;
  -------------------------------------------------------------------------
  -- Traegt den transport eien Palette ein. Setzt alle DISPOS etc.
  -------------------------------------------------------------------------
  -------------------------------------------------------------------------
  -- Traegt den transport eien Palette ein. Setzt alle DISPOS etc.
  -------------------------------------------------------------------------
  function lvs_transp_lte_353(in_sid                     in isi_sid.sid%TYPE,
                              in_firma_nr                in isi_firma.firma_nr%TYPE,
                              in_modul_erzeuger          in isi_transport.Modul_Erzeuger%TYPE,
                              in_modul_bearbeiter        in isi_transport.Modul_Bearbeiter%TYPE,
                              in_frei_fahren             in varchar2,
                              in_trans_typ               in varchar2,
                              in_user_ID                 in isi_user.login_id%TYPE,
                              in_auftrag_id              in isi_transport.Auf_Id%TYPE,
                              in_auftrag_id_extern       in isi_transport.Auf_Id_extern%TYPE,
                              in_prio                    in isi_transport.Prio%TYPE,
                              in_progr_nr                in isi_transport.progr_nr%TYPE,
                              in_quelle_Leer_progr_nr    in isi_transport.quelle_leer_progr_nr%TYPE,
                              in_ziel_voll_Progr_nr      in isi_transport.ziel_voll_progr_nr%TYPE,
                              in_lgr_quell_lgr_platz     in LVS_LTE.LGR_PLATZ%TYPE,
                              in_lgr_ziel_lgr_platz      in LVS_LTE.LGR_PLATZ%TYPE,
                              in_lte_id                  in lvs_lte.lte_id%TYPE,
                              in_kunde_nr                in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                              in_lieferschein            in isi_transport.lieferschein%type,
                              in_li_nr                   in isi_transport.li_nr%type,
                              in_li_pos_nr               in isi_transport.li_pos_nr%type,
                              in_vorgang_id              in isi_transport.vorgang_id%type,
                              in_fahrzeuge_IDs           in varchar2,
                              in_lkw_nr                  in isi_transport.lkw_nr%type,
                              in_komm_id                 in isi_transport.p_komm_id%type,
                              in_komm_lte_lhm_lagen      in isi_transport.p_komm_lte_lhm_lagen%type,
                              in_komm_lte_lhm_pro_lage   in isi_transport.p_komm_lte_lhm_pro_lage%type,
                              in_komm_lhm_hoehe_lage     in isi_transport.p_komm_lhm_hoehe_lage%type,
                              in_komm_packscheme_kopf_id in isi_transport.p_komm_packschema_kopf_id%type,
                              in_out_transport_gruppe    in out isi_transport.transport_gruppe%type,
                              out_transp_id              out isi_transport.transp_id%type,
                              in_parent_transp_id        in isi_transport.transp_id%type default NULL,
                              in_fetig_bis               in date default NULL
                              )
    return number is
    
    v_lte                     lvs_lte%rowtype;
    v_lgr                     lvs_lgr%rowtype;
    v_lgr_ort                 lvs_lgr_ort%rowtype;
    
    v_lgr_platz               lvs_lgr.lgr_platz%type;
    
    v_lvs_transp_check        isi_firma_cfg.parameter_wert%type;
    v_result                  number;
    
  begin

    v_err_nr   := NULL;
    v_err_text := NULL;

    if lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      -- Quell lagerplatz aus lvs_lgr lesen
      if in_lgr_quell_lgr_platz is not null then
        v_lgr_platz := in_lgr_quell_lgr_platz;
      else
        v_lgr_platz := v_lte.lgr_platz; -- Aktuelle Position der Palette ist Quellplatz
      end if;

      if lvs_p_base.get_lgr_platz(v_lgr_platz, v_lgr) 
      and lvs_p_base.get_lgr_ort(in_sid, in_firma_nr, v_lgr.lgr_ort, v_lgr_ort)
      and nvl(v_lgr_ort.lgr_ort_fuehrend_system, 'ISI') != 'ISI'
      then
         v_lvs_transp_check := (isi_allg.get_firma_cfg_param(in_sid, 
                                                             in_firma_nr, 
                                                             'CFG', 
                                                             null, 
                                                             'LVS_BEW_' || v_lgr_ort.lgr_ort_fuehrend_system || '_TRANSPORT', 
                                                             'LVS', 
                                                             'CFG', 
                                                             'ISI', 
                                                             'STRING'));
        if v_lvs_transp_check != 'ISI'
        then
          if  lvs_p_base.get_lgr_platz(in_lgr_ziel_lgr_platz, v_lgr)
          then
            if v_lgr.lgr_verwendung != c.LGR_TYP_WA
            then
              v_err_nr   := c.FMID_Weg_von_nach_falsch;
              v_err_text := LC.ec_p2(LC.O_TP2_WEG_VON_NACH_FALSCH, v_lgr_platz, v_lgr.lgr_platz);
              raise v_error;
            end if;
          else
            v_err_nr   := c.FMID_Ziel_Existiert_Nicht;
            v_err_text := LC.ec_p1(LC.O_TP1_Z_LGR_PLATZ_FEHLT, in_lgr_Ziel_lgr_platz);
            raise v_error;
          end if;
          EXECUTE IMMEDIATE
             'BEGIN
                ' || v_lvs_transp_check || '( :1,  :2,  :3,  :4,  :5,  :6,  :7,  :8,  :9,  :10,
                                              :11, :12, :13, :14, :15, :16, :17, :18, :19, :20,
                                              :21, :22, :23, :24, :25, :26, :27, :28, :29, :30,
                                              :31, :32, :33);
             END;'
          USING in_sid,                     -- :1 in isi_sid.sid%TYPE,
                in_firma_nr,                -- :2 in isi_firma.firma_nr%TYPE,
                in_modul_erzeuger,          -- :3 in isi_transport.Modul_Erzeuger%TYPE,
                in_modul_bearbeiter,        -- :4 in isi_transport.Modul_Bearbeiter%TYPE,
                in_frei_fahren,             -- :5 in varchar2,
                in_trans_typ,               -- :6 in varchar2,
                in_user_ID,                 -- :7 in isi_user.login_id%TYPE,
                in_auftrag_id,              -- :8 in isi_transport.Auf_Id%TYPE,
                in_auftrag_id_extern,       -- :9 in isi_transport.Auf_Id_extern%TYPE,
                in_prio,                    -- :10 in isi_transport.Prio%TYPE,
                in_progr_nr,                -- :11 in isi_transport.progr_nr%TYPE,
                in_quelle_Leer_progr_nr,    -- :12 in isi_transport.quelle_leer_progr_nr%TYPE,
                in_ziel_voll_Progr_nr,      -- :13 in isi_transport.ziel_voll_progr_nr%TYPE,
                in_lgr_quell_lgr_platz,     -- :14 in LVS_LTE.LGR_PLATZ%TYPE,
                in_lgr_ziel_lgr_platz,      -- :15 in LVS_LTE.LGR_PLATZ%TYPE,
                in_lte_id,                  -- :16 in lvs_lte.lte_id%TYPE,
                in_kunde_nr,                -- :17 in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                in_lieferschein,            -- :18 in isi_transport.lieferschein%type,
                in_li_nr,                   -- :19 in isi_transport.li_nr%type,
                in_li_pos_nr,               -- :20 in isi_transport.li_pos_nr%type,
                in_vorgang_id,              -- :21 in isi_transport.vorgang_id%type,
                in_fahrzeuge_IDs,           -- :22 in varchar2,
                in_lkw_nr,                  -- :23 in isi_transport.lkw_nr%type,
                in_komm_id,                 -- :24 in isi_transport.p_komm_id%type,
                in_komm_lte_lhm_lagen,      -- :25 in isi_transport.p_komm_lte_lhm_lagen%type,
                in_komm_lte_lhm_pro_lage,   -- :26 in isi_transport.p_komm_lte_lhm_pro_lage%type,
                in_komm_lhm_hoehe_lage,     -- :27 in isi_transport.p_komm_lhm_hoehe_lage%type,
                in_komm_packscheme_kopf_id, -- :28 in isi_transport.p_komm_packschema_kopf_id%type,
                in out in_out_transport_gruppe,    -- :29 in out isi_transport.transport_gruppe%type,
                OUT out_transp_id,                 -- :30 out isi_transport.transp_id%type,
                in_parent_transp_id,        -- :31 in isi_transport.transp_id%type default NULL,
                in_fetig_bis,               -- :32 in date default NULL;
                out v_result;               -- :33 return
          return(v_result);
        end if;
      end if;
    end if;
    
    return (lvs_transp_lte_insert(in_sid,                     -- in isi_sid.sid%TYPE,
                                  in_firma_nr,                -- in isi_firma.firma_nr%TYPE,
                                  in_modul_erzeuger,          -- in isi_transport.Modul_Erzeuger%TYPE,
                                  in_modul_bearbeiter,        -- in isi_transport.Modul_Bearbeiter%TYPE,
                                  in_frei_fahren,             -- in varchar2,
                                  in_trans_typ,               -- in varchar2,
                                  in_user_ID,                 -- in isi_user.login_id%TYPE,
                                  in_auftrag_id,              -- in isi_transport.Auf_Id%TYPE,
                                  in_auftrag_id_extern,       -- in isi_transport.Auf_Id_extern%TYPE,
                                  in_prio,                    -- in isi_transport.Prio%TYPE,
                                  in_progr_nr,                -- in isi_transport.progr_nr%TYPE,
                                  in_quelle_Leer_progr_nr,    -- in isi_transport.quelle_leer_progr_nr%TYPE,
                                  in_ziel_voll_Progr_nr,      -- in isi_transport.ziel_voll_progr_nr%TYPE,
                                  in_lgr_quell_lgr_platz,     -- in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_lgr_ziel_lgr_platz,      -- in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_lte_id,                  -- in lvs_lte.lte_id%TYPE,
                                  in_kunde_nr,                -- in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                                  in_lieferschein,            -- in isi_transport.lieferschein%type,
                                  in_li_nr,                   -- in isi_transport.li_nr%type,
                                  in_li_pos_nr,               -- in isi_transport.li_pos_nr%type,
                                  in_vorgang_id,              -- in isi_transport.vorgang_id%type,
                                  in_fahrzeuge_IDs,           -- in varchar2,
                                  in_lkw_nr,                  -- in isi_transport.lkw_nr%type,
                                  in_komm_id,                 -- in isi_transport.p_komm_id%type,
                                  in_komm_lte_lhm_lagen,      -- in isi_transport.p_komm_lte_lhm_lagen%type,
                                  in_komm_lte_lhm_pro_lage,   -- in isi_transport.p_komm_lte_lhm_pro_lage%type,
                                  in_komm_lhm_hoehe_lage,     -- in isi_transport.p_komm_lhm_hoehe_lage%type,
                                  in_komm_packscheme_kopf_id, -- in isi_transport.p_komm_packschema_kopf_id%type,
                                  in_out_transport_gruppe,    -- in out isi_transport.transport_gruppe%type,
                                  out_transp_id,              -- out isi_transport.transp_id%type,
                                  in_parent_transp_id,        -- in isi_transport.transp_id%type default NULL,
                                  in_fetig_bis                -- in date default NULL
                                  ));
    
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

  function lvs_transp_lte_insert (in_sid                     in isi_sid.sid%TYPE,
                                  in_firma_nr                in isi_firma.firma_nr%TYPE,
                                  in_modul_erzeuger          in isi_transport.Modul_Erzeuger%TYPE,
                                  in_modul_bearbeiter        in isi_transport.Modul_Bearbeiter%TYPE,
                                  in_frei_fahren             in varchar2,
                                  in_trans_typ               in varchar2,
                                  in_user_ID                 in isi_user.login_id%TYPE,
                                  in_auftrag_id              in isi_transport.Auf_Id%TYPE,
                                  in_auftrag_id_extern       in isi_transport.Auf_Id_extern%TYPE,
                                  in_prio                    in isi_transport.Prio%TYPE,
                                  in_progr_nr                in isi_transport.progr_nr%TYPE,
                                  in_quelle_Leer_progr_nr    in isi_transport.quelle_leer_progr_nr%TYPE,
                                  in_ziel_voll_Progr_nr      in isi_transport.ziel_voll_progr_nr%TYPE,
                                  in_lgr_quell_lgr_platz     in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_lgr_ziel_lgr_platz      in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_lte_id                  in lvs_lte.lte_id%TYPE,
                                  in_kunde_nr                in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                                  in_lieferschein            in isi_transport.lieferschein%type,
                                  in_li_nr                   in isi_transport.li_nr%type,
                                  in_li_pos_nr               in isi_transport.li_pos_nr%type,
                                  in_vorgang_id              in isi_transport.vorgang_id%type,
                                  in_fahrzeuge_IDs           in varchar2,
                                  in_lkw_nr                  in isi_transport.lkw_nr%type,
                                  in_komm_id                 in isi_transport.p_komm_id%type,
                                  in_komm_lte_lhm_lagen      in isi_transport.p_komm_lte_lhm_lagen%type,
                                  in_komm_lte_lhm_pro_lage   in isi_transport.p_komm_lte_lhm_pro_lage%type,
                                  in_komm_lhm_hoehe_lage     in isi_transport.p_komm_lhm_hoehe_lage%type,
                                  in_komm_packscheme_kopf_id in isi_transport.p_komm_packschema_kopf_id%type,
                                  in_out_transport_gruppe    in out isi_transport.transport_gruppe%type,
                                  out_transp_id              out isi_transport.transp_id%type,
                                  in_parent_transp_id        in isi_transport.transp_id%type default NULL,
                                  in_fetig_bis               in date default NULL
                                  )
    return number is
    -------------------------------------------------------------------------

    -------------------------------------------------------------------------------------------------------

    v_neuer_Status    lvs_lte.lte_status%TYPE; -- neuer status der LTE
    v_found           boolean; -- Dummy Var für gefunden im CURSOR
    v_lte             lvs_lte%ROWTYPE; -- Daten der transporteinheit (Für den Lagerplatz)
    v_Quell_lgr_ort   lvs_lgr_ort%ROWTYPE; -- Lagerort der LTE
    v_Ziel_lgr_ort    lvs_lgr_ort%ROWTYPE; -- Lagerort der LTE
    v_lgr_ort_mb      lvs_lgr_ort.lgr_ort%type;
    v_Quell_lgr       lvs_lgr%ROWTYPE; -- Lagerplatz auf dem die LTE steht
    v_Ziel_lgr        lvs_lgr%ROWTYPE; -- Lagerplatz auf dem die LTE steht
    v_transport       isi_transport%ROWTYPE;
    v_lgr_platz       lvs_lgr.lgr_platz%type; -- Lagerplatz für CURSOR
    v_order_pos       isi_order_pos%rowtype; -- ISI-Order wenn vorhanden
    v_modul_bearb     isi_transport.modul_bearbeiter%type;
    v_prio            isi_transport.prio%type;
    v_Lgr_Gruppe_Id   lvs_lgr.lgr_gruppe_id%type;
    v_lgr_ort         lvs_lgr_ort.lgr_ort%type;
    v_leitzahl        lvs_lam.leitzahl%type;
    v_transp_id       isi_transport.transp_id%type;
    v_transp_id_p     isi_transport.transp_id%type;
    v_transp_richtung varchar2(3);
    v_res_id          isi_resource.res_id%type;
    v_trans_typ       isi_transport.transp_typ%type;

    v_result        INTEGER; -- return value

    -- Tabelle für die Erzeugung von Staffeltransporten
    v_lvs_lgr_ort_ue_platz       lvs_lgr_ort_ue_platz%rowtype;

    v_lam           lvs_lam%rowtype; -- Lagerbestand Menge

    v_ziel_lgr_ort_n_freif   lvs_lte.ziel_lgr_ort_n_freif%type;
    v_ziel_lgr_platz_n_freif lvs_lte.ziel_lgr_platz_n_freif%type;
    v_parent_transp_id       isi_transport.transp_id%type;

    v_lte_cfg            lvs_lte_cfg%rowtype;
    v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

    v_staffel_transport  boolean;

    CURSOR c_lte_cfg is
      select t.*
        from lvs_lte_cfg t
       where t.sid = v_lte.sid
         and t.firma_nr = v_lte.firma_nr
         and t.lte_name = v_lte.lte_name;

    CURSOR c_order is
      select *
        from isi_order_pos o_pos
       where o_pos.sid = in_sid
         and o_pos.auf_id = in_auftrag_id;

    CURSOR c_lgr is -- Lesen des Lagerplatz
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = v_lgr_platz
         and lgr.sid = in_sid;

    CURSOR c_lam is -- Lesen des Lagermaterial
      select nvl(decode (max(fa.leitzahl), min(fa.leitzahl), min(fa.leitzahl), NULL),
                 decode (max(lam.leitzahl), min(lam.leitzahl), min(lam.leitzahl), NULL))
        from lvs_lam lam,
             bde_fa_auftrag fa
       where lam.lte_id = in_lte_id
         and lam.sid = in_sid
         and lam.order_pos_auf_id = fa.auf_id(+)
       group by lam.lte_id;

    CURSOR c_lgr_ort is -- Lesen des Lagerplatz
      select *
        from lvs_lgr_ort ort
       where ort.lgr_ort = v_lgr_ort_mb
         and ort.sid = in_sid;

    CURSOR c_lvs_lte is -- Lesen des Lagerhilfsmittel
      select * from lvs_lte lte where lte.lte_id = in_LTE_ID;

    CURSOR c_lvs_lgr_grp_fahrzeug is
      select decode (min(fg.res_id), max(fg.res_id), min(fg.res_id), NULL) Res_Id
        from lvs_lgr_grp_fahrzeug fg,
             lvs_fahrzeuge f
       where fg.lgr_gruppe_id = v_Lgr_Gruppe_Id
         and fg.lgr_ort = v_Lgr_Ort
         and fg.res_id = f.res_id
         and v_transp_richtung like ('%' || f.transp_richtung || '%');

    CURSOR c_transport is
      select *
        from isi_transport tra
       where tra.sid = in_sid
         and tra.vorgang_id = v_order_pos.vorgang_id
         and tra.lte_id = in_lte_id
         and (  tra.lgr_verwendung_ziel = c.LGR_TYP_Lager
             or tra.lgr_verwendung_ziel = c.LGR_TYP_Puffer);

    CURSOR c_lam_vl_transp is
      select l.*
        from lvs_lam l,
             isi_transport t
       where l.res_ziel_lte_id = in_lte_id
         and t.lte_id != in_lte_id
         and t.lte_id like 'LTE_VL%'
         and l.lte_id = t.lte_id;
  begin
    -- Lesen der Artikeldaten
    v_err_nr   := NULL;
    v_err_text := NULL;
    v_transp_id_p := in_parent_transp_id;
    v_parent_transp_id := in_parent_transp_id;
    lvs_platz.v_fahrz_ziel_res_id := NULL;

    v_staffel_transport := nvl(v_staffel_transport, false);

    if in_auftrag_id is NULL then
      v_order_pos := NULL;
    else
      OPEN c_order;
      FETCH c_order
        into v_order_pos;
      CLOSE c_order;

      OPEN c_transport;
      FETCH c_transport into v_transport;
      v_found := c_transport%FOUND;
      CLOSE c_transport;
      if v_found  -- Ist noch eine Transport für diese Tour als Vorbereitung unterwegs?
      then
        v_parent_transp_id := v_transport.transp_id;
        v_transp_id_p := v_parent_transp_id;
      end if;
    end if;

    OPEN c_lvs_lte;
    FETCH c_lvs_lte
      into v_lte;
    v_found := c_lvs_lte%FOUND;
    CLOSE c_lvs_lte;
    if not v_found then
      v_err_nr   := c.FMID_LTE_ID_SCHON_VORHANDEN;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
      raise v_error;
    end if;

    if not v_staffel_transport
    and v_parent_transp_id is NULL
    then
      -- Achtung!!! Ein Ziellagerort ist nur dann ein Fehler, wenn nicht freigefahern wird
      if (v_lte.Ziel_lgr_ort is not null) then
        if in_frei_fahren = c.C_TRUE then
          v_ziel_lgr_ort_n_freif   := v_lte.ziel_lgr_ort;
          v_ziel_lgr_platz_n_freif := v_lte.ziel_lgr_platz;
        else
          v_err_nr   := c.FMID_LTE_hat_Transport;
          v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_W_TRANSPORTIERT, in_lte_id);
          raise v_error;
        end if;
      end if;
    end if;

    -- Quell lagerplatz aus lvs_lgr lesen
    if in_lgr_quell_lgr_platz is not null then
      v_lgr_platz := in_lgr_quell_lgr_platz;
    else
      v_lgr_platz := v_lte.lgr_platz; -- Aktuelle Position der Palette ist Quellplatz
    end if;

    if not v_staffel_transport
    and v_parent_transp_id is NULL
    then
      if v_lgr_platz != v_lte.lgr_platz
      then
        v_err_nr   := c.FMID_Lte_falscher_Platz;
        v_err_text := LC.ec_p2(LC.O_TP2_LTE_PLATZ_T_PLATZ_DIFF, v_lte.lgr_platz, v_lgr_platz);
        raise v_error;
      end if;
    end if;
    if v_lgr_platz is not null or (v_lte.lte_status != C.LTE_PF_STAT and
       v_lte.lte_status != C.LTE_KF_STAT) then
      --or
      --     in_modul_bearbeiter = 'MFR' then
      OPEN c_lgr; --
      FETCH c_lgr
        into v_quell_lgr; -- Lesen den Eintrag des Lagerplatz
      v_found := c_lgr%FOUND;
      CLOSE c_lgr;

      if not v_found then
        v_err_nr   := c.FMID_Quelle_Existiert_Nicht;
        v_err_text := LC.ec_p1(LC.O_TP1_Q_LGR_PLATZ_FEHLT, nvl(v_lgr_platz, 'NULL'));
        raise v_error;
      else
        if v_quell_lgr.Gesperrt <> 'F' then
          -- Fehler Lagerplatz ist gesperrt
          v_err_nr   := c.FMID_Lagerplatz_Gesperrt;
          v_err_text := LC.ec_p2(LC.O_TP2_LAGERPLATZ_GESPERRT, v_lgr_platz, v_quell_lgr.gesp_grund);
          raise v_error;
        end if;
        if v_quell_lgr.akt_inventur_id is not NULL then
          -- Fehler Lagerplatz ist in Inventur
          v_err_nr   := c.FMID_Lagerplatz_Gesperrt;
          v_err_text := LC.ec_p1(LC.O_TP1_LAGERPLATZ_IN_INVENTUR, v_lgr_platz);
          raise v_error;
        end if;
      end if;
    end if;

    if in_modul_bearbeiter is NULL then
      v_lgr_ort_mb := v_Quell_lgr.Lgr_Ort;
      OPEN c_lgr_ort;
      FETCH c_lgr_ort
        into v_quell_lgr_ort; -- Lagerortdaten lesen
      CLOSE c_lgr_ort;
      v_modul_bearb := v_quell_lgr_ort.lgr_ort_modul;
    else
      v_modul_bearb := in_modul_bearbeiter;
    end if;

    -- Ziel lagerplatz aus lvs_lgr lesen
    v_lgr_platz := in_lgr_ziel_lgr_platz;
    OPEN c_lgr; --
    FETCH c_lgr
      into v_ziel_lgr; -- Lesen den Eintrag des Lagerplatz
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;

    -- AG 20170814 Übergabeplatz ggf. nur fuer bestimmte Palettentypen
    v_staffel_transport := lvs_p_base.get_lvs_lgr_ort_ue_platz(in_sid,                 -- in_sid                  in lvs_lam.sid%type,
                                                               in_firma_nr,            -- in_firma_nr             in lvs_lam.firma_nr%type,
                                                               v_Quell_lgr.Lgr_Ort,    -- in_lgr_ort_quelle       in lvs_lgr_ort_ue_platz.lgr_ort_quelle%type,
                                                               v_Ziel_lgr.Lgr_Ort,     -- in_lgr_ort_ziel         in lvs_lgr_ort_ue_platz.lgr_ort_ziel%type,
                                                               v_Quell_lgr.Lgr_Platz,     -- in_lgr_platz            in lvs_lgr.lgr_platz%type,
                                                               v_lte.lte_name,            -- LTE-Nmae für Suche
                                                               v_lvs_lgr_ort_ue_platz);-- io_lvs_lgr_ort_ue_platz in out lvs_lgr_ort_ue_platz%rowtype)


    if v_staffel_transport
    then
      v_lgr_platz := v_lvs_lgr_ort_ue_platz.lgr_platz;
      OPEN c_lgr; --
      FETCH c_lgr
        into v_ziel_lgr; -- Lesen den Eintrag des Lagerplatz
      v_found := c_lgr%FOUND;
      CLOSE c_lgr;
      if not v_found
      then
        -- -AG- 27.01.2011 Wenn ein Satz vorhanden ist, indem kein Platz steht oder ein Platz der im LVS_LGR nicht vorhanden ist,
        -- dann können keine Staffeltransporte erzeugt werden. Dann diesen Fehler melden (kein Weg)
        v_err_nr   := c.FMID_Weg_von_nach_falsch;
        v_err_text := LC.ec_p2(LC.O_TP2_WEG_VON_NACH_FALSCH, v_Quell_lgr.Lgr_Platz, v_Ziel_lgr.Lgr_Platz);
        raise v_error;
      end if;
    end if;

    if in_modul_bearbeiter is NULL
    or v_staffel_transport
    or v_parent_transp_id is NOT NULL
    then
      v_lgr_ort_mb := v_Ziel_lgr.Lgr_Ort;
      OPEN c_lgr_ort;
      FETCH c_lgr_ort
        into v_ziel_lgr_ort; -- Lagerortdaten lesen
      CLOSE c_lgr_ort;
      v_modul_bearb := v_ziel_lgr_ort.lgr_ort_modul;
    end if;

    -- Beim MFR darf kein Staffeltransport erzeugt werden.
    -- Alle Transporte zum oder vom MFR sind immer Auslöser (Alos ohne Parent).
    if  v_modul_bearb = c.LGR_MODUL_MFR
    and v_parent_transp_id is not NULL
    then
      return (0);
    end if;

    -- Falls bei der Auftragserzeugung aus dem HOST / ISIOrder ...
    -- keine Prio festgelegt wurde, wird die PRIO aus dem Zielplatz genommen
    if in_prio is NULL
    then
      v_prio := nvl(v_Ziel_lgr.Aktivierung_Prio, 0);
    else
      v_prio := in_prio;
    end if;

    if not v_found then
      v_err_nr   := c.FMID_Ziel_Existiert_Nicht;
      v_err_text := LC.ec_p1(LC.O_TP1_Z_LGR_PLATZ_FEHLT, in_lgr_Ziel_lgr_platz);
      raise v_error;
    else
      if v_ziel_lgr.Gesperrt <> 'F' then
        -- Fehler Lagerplatz ist gesperrt
        v_err_nr   := c.FMID_Lagerplatz_Gesperrt;
        v_err_text := LC.ec_p2(LC.O_TP2_LAGERPLATZ_GESPERRT, in_lgr_Ziel_lgr_platz, v_quell_lgr.gesp_grund);
        raise v_error;
      end if;
      if v_ziel_lgr.akt_inventur_id is not NULL then
        -- Fehler Lagerplatz ist in Inventur
        v_err_nr   := c.FMID_Lagerplatz_Gesperrt;
        v_err_text := LC.ec_p1(LC.O_TP1_LAGERPLATZ_IN_INVENTUR, in_lgr_Ziel_lgr_platz);
        raise v_error;
      end if;
    end if;
    
    if in_trans_typ is NOT NULL
    then
      v_trans_typ := in_trans_typ;
    else
      if ((v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_Lager
      or   v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_Puffer
      or   v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_LagerP
      or   v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_EP
          )
      and  (v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_Lager
      or    v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_Puffer
      or    v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_LagerP
      or    v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_EP
           )
         )
      then
        v_trans_typ := 'U';                                 -- Von zu Lager ist eine Umlagerung
      elsif v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_WA
      then
        v_trans_typ := 'A';                                 -- Zu einem WA ist eine Auslagerung
      elsif v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_WE
         or v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_WEP
      then
        v_trans_typ := 'U';                                 -- Zu einem WE ist ??? Erst mal Umlagerung
      elsif v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_Lager
      or    v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_Puffer
      or    v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_LagerP
      or    v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_EP
      then
        v_trans_typ := 'E';                                 -- Diese Ziele sind Einlagerung, wenn die quelle nicht 
      end if;
    end if;

    if v_trans_typ = 'A'
    then
      OPEN c_lam_vl_transp;                         -- Ist eine LAM mit Ziel dieser LTE in System
      FETCH c_lam_vl_transp into v_lam;
      v_found := c_lam_vl_transp%FOUND;
      CLOSE c_lam_vl_transp;
      if v_found                                    -- dann nicht auslagern und Fehler reißssen
      then
        v_err_nr   := c.FMID_Falscher_LTE_Status;
        v_err_text := LC.ec(LC.O_TXT_LTE_HAT_RES_AUFT_ERR);
        raise v_error;
      end if;
    end if;

    -- -WK- 20090409: bei Staffeltransporten kann die Quelle schon entlastet sein,
    -- während wir diesen Transport anlegen (evtl. noch "in_lgr_quell_lgr_platz" abfragen)
    if  (v_lte.lgr_platz is null and v_parent_transp_id is null)
    and v_trans_typ != 'E'
    then
      v_err_nr   := c.FMID_Lte_falscher_Platz;
      v_err_text := LC.ec_p1(LC.O_TP1_LAGERPLATZ_FEHLT, 'NULL');
      raise v_error;
    end if;

    if not v_staffel_transport
    and v_parent_transp_id is NULL
    then
      if nvl(v_Quell_lgr.Lgr_Akt_Te, 1) = 0
      and v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_Lager
      and v_trans_typ != 'E'
      then
        v_err_nr   := c.FMID_QuellKanal_Leer;
        v_err_text := LC.ec_p1(LC.O_TP1_LGR_PLATZ_LEER, v_Quell_lgr.Lgr_Platz);
        raise v_error;
      end if;

      if v_lte.lgr_platz != v_Quell_lgr.Lgr_Platz
      then
        v_err_nr   := c.FMID_Lte_falscher_Platz;
        v_err_text := LC.ec_p2(LC.O_TP2_LTE_PLATZ_T_PLATZ_DIFF, v_lte.Lgr_Platz, v_Quell_lgr.Lgr_Platz);
        raise v_error;
      end if;
    end if;


    if  v_modul_bearb = c.LGR_MODUL_MFR
    then
      -- Beim MFR muss die Qulle oder das Ziel ein Lagerplatz sein
      -- oder von einem WE auf einen WA transportiert werden
      if ((v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_Lager
      or    v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_Lager
      or   v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_Puffer
      or   v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_Puffer
      or   v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_LagerP
      or   v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_LagerP
      or   v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_LagerP
      or   v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_LagerP
      or   v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_EP
      or   v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_EP)
      or   (v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_WA
      and   v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_WE)
      -- Transport zum WA vom WA auch erlauben (Für neg. Komm nötig)
      or   (v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_WA
      and   v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_WA)
      -- Koppeltransport zum WE des MFR ist OK
      or   (v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_WE
      and   v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_WE
      and   v_Quell_lgr_ort.lgr_ort_modul != c.LGR_MODUL_MFR))
      then
        v_err_nr   := NULL;
        v_err_text := NULL;
      else
        v_err_nr   := c.FMID_Weg_von_nach_falsch;
        v_err_text := LC.ec_p2(LC.O_TP2_WEG_VON_NACH_FALSCH, v_Quell_lgr.Lgr_Platz, v_Ziel_lgr.Lgr_Platz);
        raise v_error;
      end if;
    end if;

    -- Von WE zu WE oder WA zu WA hat immer die Quelle das BearbeiterModul
    if   (v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_WE
    and   v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_WE)
    or   (v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_WA
    and   v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_WA)
    then
      v_lgr_ort_mb := v_Quell_lgr.Lgr_Ort;
      OPEN c_lgr_ort;
      FETCH c_lgr_ort
        into v_quell_lgr_ort; -- Lagerortdaten lesen
      CLOSE c_lgr_ort;
      v_modul_bearb := v_quell_lgr_ort.lgr_ort_modul;
    end if;


    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;
    CLOSE c_lte_cfg;

    v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
    lvs_platz.lvs_platz_einl_pruefen_R30(v_lte,
                                         v_basis_lte_name,
                                         v_lte_cfg.flaechen_stellplatz_erf,
                                         v_ziel_lgr,
                                         v_trans_typ,
                                         in_fahrzeuge_IDs);

    v_Lgr_Gruppe_Id := v_ziel_lgr.Lgr_Gruppe_Id;
    v_lgr_ort := v_ziel_lgr.lgr_ort;
    if v_trans_typ = 'E'
    then
      v_transp_richtung := 'EB';
    elsif v_trans_typ = 'A'
    then
      v_transp_richtung := 'AB';
    else
      v_transp_richtung := 'AB';
    end if;

    if v_quell_lgr.lgr_platz is not NULL and
       v_ziel_lgr_platz_n_freif is NULL then
      lvs_platz.lvs_platz_ausl_disp_setzen(v_lte, v_quell_lgr);
    end if;
    v_neuer_status := c.LTE_ED_STAT;

    if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_WA
    or (v_ziel_lgr.lgr_verwendung = c.LGR_TYP_Puffer
    and v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_Lager)
    or (v_ziel_lgr.lgr_verwendung = c.LGR_TYP_EP
    and v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_Lager) then
      v_neuer_Status := c.LTE_AD_STAT;
      v_Lgr_Gruppe_Id := v_Quell_lgr.Lgr_Gruppe_Id;
      v_lgr_ort := v_Quell_lgr.lgr_ort;
    end if;

    if (v_quell_lgr.lgr_verwendung = c.LGR_TYP_Lager
      or v_quell_lgr.lgr_verwendung = c.LGR_TYP_Puffer
      or v_quell_lgr.lgr_verwendung = c.LGR_TYP_LagerP)
    and
       (v_ziel_lgr.lgr_verwendung = c.Lgr_Typ_Lager
     or v_ziel_lgr.lgr_verwendung = c.LGR_TYP_Puffer
     or v_ziel_lgr.lgr_verwendung = c.Lgr_Typ_LagerP) then
      v_neuer_Status := c.LTE_UD_STAT;
    end if;

    if in_frei_fahren = c.C_TRUE then
      v_neuer_Status := c.LTE_FF_STAT;
    end if;

    if v_parent_transp_id is NOT NULL
    then
      -- -AG- In Staffeltransporten löschen, sonst wird Ziel Nach feifahren gefüllt
      v_lte.ziel_lgr_ort := NULL;
      v_lte.ziel_lgr_platz := NULL;
    end if;

    if in_out_transport_gruppe is NULL
    then
      -- select seq_transport_gruppe.nextval into in_out_transport_gruppe from dual;
      in_out_transport_gruppe := 0;
    end if;

    if v_quell_lgr.lgr_typ != c.DURCHL1 -- Im Durchlauflager soll die Letzte Buchunh nicht durch das Anlegen eines Transports veraendert werden
    then
      v_lte.lte_letzte_buchung := systimestamp;
    end if;

    lvs_p_lte.LVS_TE_LAGERZIEL_UMBUCHEN_353(v_lte.sid,
                                            v_lte.firma_nr,
                                            v_lte.lte_id,
                                            v_lte.lgr_platz,
                                            v_lte.lgr_ort,
                                            v_lte.lgr_platz_gruppe,
                                            v_ziel_lgr.lgr_platz,
                                            v_ziel_lgr.lgr_ort,
                                            v_neuer_status,
                                            v_lte.lte_status,
                                            v_lte.ziel_lgr_platz,
                                            v_lte.ziel_lgr_ort,
                                            v_lte.lte_letzte_buchung,
                                            in_auftrag_id,
                                            v_order_pos.vorgang_id,
                                            v_order_pos.artikel_id,
                                            in_out_transport_gruppe,
                                            in_lkw_nr,
                                            v_lte.lte_offset_x,
                                            v_lte.lte_offset_y,
                                            v_lte.lte_offset_z);

    v_found := True;

    -- Jetzt wird noch ein Fahrzeug gesucht. Es wird nur dann eingetragen, wenn
    -- ein Eindeutiges Fahrzeug für diesen Lagerplatz gefunden wird
    if v_transp_id_p is NULL
    then
      OPEN c_lvs_lgr_grp_fahrzeug;
      FETCH c_lvs_lgr_grp_fahrzeug into lvs_platz.v_fahrz_res_id;
      v_res_id := lvs_platz.v_fahrz_res_id;
      CLOSE c_lvs_lgr_grp_fahrzeug;
    else
      v_res_id := NULL;
    end if;

    if  v_neuer_Status = c.LTE_UD_STAT -- Umlagerung
    and (   v_ziel_lgr.lgr_ort !=  v_Quell_lgr.Lgr_Ort
         or v_ziel_lgr.Lgr_Gruppe_Id != v_Quell_lgr.Lgr_Gruppe_Id)
    then
      v_Lgr_Gruppe_Id := v_ziel_lgr.Lgr_Gruppe_Id;
      v_lgr_ort := v_ziel_lgr.lgr_ort;
      v_transp_richtung := 'EB';

      OPEN c_lvs_lgr_grp_fahrzeug;
      FETCH c_lvs_lgr_grp_fahrzeug into lvs_platz.v_fahrz_ziel_res_id;

      CLOSE c_lvs_lgr_grp_fahrzeug;

    end if;

    v_leitzahl := NULL;
    OPEN c_lam;
    FETCH c_lam into v_leitzahl;
    CLOSE c_lam;
    
    if  v_trans_typ = 'A'
    and v_Quell_lgr.Lgr_Ort = v_Quell_lgr.Lgr_Ort
    and (v_res_id = nvl(lvs_platz.v_fahrz_ziel_res_id, v_res_id) or v_res_id is NULL)
    then
      if v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_Lager
      or v_Ziel_lgr.Lgr_Verwendung = c.LGR_TYP_Puffer
      then
        v_trans_typ := 'U'; 
      end if;
    end if;

    INSERT INTO isi_transport t
    VALUES
      (in_sid, -- sid
       in_firma_nr, -- firma_nr
       in_modul_erzeuger, -- modul_erzeuger
       v_modul_bearb, -- modul_bearbeiter
       NULL, -- transp_id
       null, -- transp_id_source
       SYSTIMESTAMP, -- ts
       v_trans_typ, -- transp_typ
       NULL, -- transportmittel_gruppe
       NULL, -- transport mittel id
       NULL, -- transportmittel typ
       c.TRANS_FREI, -- status
       v_Quell_lgr.lgr_platz, -- lgr_platz_quelle
       v_Ziel_lgr.lgr_platz, -- lgr_platz_ziel
       v_Quell_lgr.lgr_Verwendung, -- lgr_verwendung_quelle
       v_Ziel_lgr.lgr_Verwendung, -- lgr_verwendung_Ziel
       v_Quell_lgr.lgr_ort, -- lgr_ort_quelle
       v_Ziel_lgr.lgr_ort, -- lgr_ort_Ziel
       in_vorgang_id, -- vorgang_id
       in_out_transport_gruppe, -- transport-gruppe
       v_lte.lte_id, -- lte_id
       in_Auftrag_ID, -- auf_id
       in_Auftrag_ID_extern, -- auf_id_extern
       v_prio, -- prio
       in_progr_nr, -- progr_nr
       in_quelle_Leer_Progr_nr, -- quelle_leer_progr_nr
       in_ziel_voll_Progr_nr, -- ziel_voll_progr_nr
       in_kunde_nr, -- kunden_nr (Hier Ardess_id)
       in_user_id, -- user_id
       in_frei_fahren, -- freifahrauftrag
       in_lieferschein, -- Lieferscheindaten erzeugen 'T' = Ja, erzeugen, 'F' = Nein, wird nicht erzeut
       v_res_id, -- Resource aus isi_resource die mit dem Transport beauftragt wird
       null, -- Vorgangs_ID für die Zusammenfassung von LAM-Buchungen
       in_li_nr, -- Lieferschein Nummer
       in_li_pos_nr, -- Lieferscheinposition -Nummer
       v_lte.lte_letzte_buchung, -- Letzte Buchung vor diesem Transport
       in_lkw_nr,
       v_leitzahl,
       v_order_pos.order_info,       -- Transportinfo
       in_fetig_bis,                 -- Soll_Fertig_Bis
       null, -- check_ware
       null, -- check_lgr_platz_q
       null, -- check_lgr_platz_z
       v_transp_id_p,  -- PARENT_TRANSP_ID
       9999999999,     -- TRANSPORT_REIHENFOLGE
       lvs_platz.v_fahrz_ziel_res_id,
       in_komm_id,
       in_komm_lte_lhm_lagen,      -- isi_transport.p_komm_lte_lhm_lagen%type,
       in_komm_lte_lhm_pro_lage,   -- isi_transport.p_komm_lte_lhm_pro_lage%type,
       in_komm_lhm_hoehe_lage,     -- isi_transport.p_komm_lhm_hoehe_lage%type,
       in_komm_packscheme_kopf_id, -- isi_transport.p_komm_packschema_kopf_id%type,
       NULL                        -- isi__transport.lgr_platz_ziel_zugeordnet

       )
    returning t.transp_id into out_transp_id;
    -- AG 19.08.2014 Wenn Transport eingetragen wird, dann soll dies in der ISI-Komm-Order
    -- als  TVK=Transp. vor Kommission eingetragen werden wenn die Kommorder nocht keinen
    -- hoeheren Status hat
    if nvl(in_komm_id, 0) != 0
    then
      update isi_komm_order t
         set t.ts = sysdate,
             t.transp_id_vor_komm = nvl(t.transp_id_vor_komm, out_transp_id), -- Nur setzen nicht überschreiben
             t.transport_vor_komm = c.C_TRUE,
             t.status = 'TVK'
       where t.p_komm_id = in_komm_id
         and nvl(t.lte_id, v_lte.lte_id) = v_lte.lte_id   -- Nur für diese LTE 
         and t.status in ('N', 'FB', 'B')                 -- N=Neu; FB=zur Bearb. Freigeg.; B=Bearb. beg. (Ware res.);
         and t.komm_typ in ('KE', 'MV', 'UP', 'W', 'D', 'ZE', 'UPA'); -- UP=Umpacken, W=Palettenwechsler, D=reines doppeln, ZE=Zusatzetikett (z.B. Routinglabel), UPA=Artikelreines Umpacken
    end if;
    v_transp_id_p := out_transp_id;
    v_lte.transport_gruppe := in_out_transport_gruppe;
    lvs_platz.lvs_platz_einl_disp_setzen(v_lte, v_ziel_lgr);

    if v_lte.order_vorgang_id is not NULL
    and v_trans_typ = 'A'
    then
      update lvs_lgr t
         set t.lgr_order_res_te = t.lgr_order_res_te - 1
       where t.lgr_platz = v_lte.lgr_platz;
    end if;

    if v_staffel_transport
    then
      v_result   := lvs_gesperrter_transp_lte(in_sid,
                                              in_firma_nr,
                                              in_modul_erzeuger,
                                              in_modul_bearbeiter,
                                              in_frei_fahren,
                                              v_trans_typ,
                                              in_user_ID,
                                              in_auftrag_id,
                                              in_auftrag_id_extern,
                                              in_prio,
                                              in_progr_nr,
                                              in_quelle_Leer_progr_nr,
                                              in_ziel_voll_Progr_nr,
                                              v_Ziel_lgr.Lgr_Platz, -- In Staffelauftrag ist das letzte Zeil dann die Quelle
                                              in_lgr_ziel_lgr_platz,
                                              in_lte_id,
                                              in_kunde_nr,
                                              in_lieferschein,
                                              in_li_nr,
                                              in_li_pos_nr,
                                              in_vorgang_id,
                                              in_fahrzeuge_IDs,
                                              in_lkw_nr,
                                              in_out_transport_gruppe,
                                              v_transp_id,
                                              v_transp_id_p,
                                              in_fetig_bis);
      if v_result != 0
      then
        rollback;
        return v_result;
      end if;
    end if;

    return 0;
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
  end lvs_transp_lte_insert;

  ---------------------------------
  -- Freien Transport sperren
  -- übergebener user_id wird wegen Verantwortung in den Transport geschrieben
  ---------------------------------
  function transport_sperren(in_sid             in isi_sid.sid%type,
                             in_firma_nr        in isi_firma.firma_nr%type,
                             in_user_id         in isi_user.login_id%type,
                             in_transport_id    in isi_transport.transp_id%type)
                             return integer is

    v_ret_value integer; -- return value

    v_transport isi_transport%rowtype;

    cursor c_transport is
      select *
        from isi_transport t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.transp_id = in_transport_id;

    v_found boolean;
  begin
    v_ret_value := 0;

    open c_transport;
    fetch c_transport into v_transport;
    v_found := c_transport%found;
    close c_transport;

    if v_found
    then
      if v_transport.status = c.TRANS_FREI
      then
        update isi_transport t
           set t.status = c.TRANS_GESPERRT,
               t.user_id = nvl(in_user_id, t.user_id)
         where t.sid = in_sid
           and t.firma_nr = in_firma_nr
           and t.transp_id = in_transport_id;
      else
        v_err_nr := 1;
        v_err_text := LC.ec(LC.O_TXT_NUR_FREI_TRANS_SPERREN);
        raise v_error;
      end if;
    end if;

    return(v_ret_value);
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

  ---------------------------------
  -- Gesperrten Transport freigeben
  -- übergebener user_id wird wegen Verantwortung in den Transport geschrieben
  ---------------------------------
  function transport_freigeben(in_sid             in isi_sid.sid%type,
                               in_firma_nr        in isi_firma.firma_nr%type,
                               in_user_id         in isi_user.login_id%type,
                               in_transport_id    in isi_transport.transp_id%type)
                               return integer is

    v_ret_value integer; -- return value

    v_transport isi_transport%rowtype;
    v_lam lvs_lam%rowtype;
    v_send_bew s_send_bew%rowtype;

    cursor c_transport is
      select *
        from isi_transport t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.transp_id = in_transport_id;

    cursor c_lams is
      select t.*
        from lvs_lam t
       where t.lte_id = v_transport.lte_id;

    v_found boolean;
  begin
    v_ret_value := 0;

    open c_transport;
    fetch c_transport into v_transport;
    v_found := c_transport%found;
    close c_transport;

    if v_found
    then
      if v_transport.status = c.TRANS_GESPERRT
      then
        -- Nur gesperrten Transport freigeben, ansonsten ist der Transport trotz Sperre von jemandem begonnen worden
        if v_transport.transp_typ = 'E'
        then
          -- wenn in der Schnittstelle die Zugangsbuchung noch nicht übernommen wurde
          -- muss sie spätestens jetzt übernommen werden.
          update s_send_bew t
             set t.status = 'UE'
           where t.status is null
             and t.lam_bh_typ = 'LZ'
             and t.lte_nr = v_transport.lte_id;
        end if;

        update isi_transport t
           set t.status = c.TRANS_FREI,
               t.user_id = nvl(in_user_id, t.user_id)
         where t.sid = in_sid
           and t.firma_nr = in_firma_nr
           and t.transp_id = in_transport_id;

        if v_transport.vorgang_id is not null
           and v_transport.auf_id is not null
        then
          isi_p_order.teilmg_transport_begonnen(in_sid, in_firma_nr, in_transport_id);
        end if;
      end if;
    end if;

    return(v_ret_value);
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


  --------------------------------------------------------------------------------
  -- procedure LVS_c.TRANSP_FREI
  -- Transport mit der ID xx wird eien RES_ID zugewiesen
  --------------------------------------------------------------------------------
  function lvs_transp_reset(in_sid          in isi_sid.sid%type,
                            in_firma_nr     IN isi_firma.firma_nr%TYPE,
                            in_user_id      IN isi_user.login_id%TYPE,
                            in_transport_id IN isi_transport.transp_id%TYPE,
                            in_res_id       in isi_resource.res_id%type)
    RETURN INTEGER IS

    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(2550);

    v_found     boolean;
    v_ret_value INTEGER; -- return value
    v_transport isi_transport%ROWTYPE;
    v_res       isi_resource%ROWTYPE;

    CURSOR c_transport IS
      select t.*
        from isi_transport t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.transp_id = in_transport_id;

    CURSOR c_res is
      select *
        from isi_resource res
       where res.sid = in_sid
         and res.res_id = in_res_id;

  begin
    v_ret_value := 0; -- Erst mal OK

    OPEN c_transport;
    FETCH c_transport
      into v_transport; -- Lesen des Transportauftrags
    v_found := c_transport%FOUND;
    CLOSE c_transport;

    if v_found 
    then
      if in_res_id is not NULL
      then
        OPEN c_res;
        FETCH c_res
          into v_res; -- Resource lesen
        v_found := c_res%FOUND;
        CLOSE c_res;
      else
        v_found := true;
      end if;
      if v_found then
        update isi_transport tra
           set tra.res_id = in_res_id, 
               tra.status = c.TRANS_FREI
         where tra.sid = in_sid
           and tra.firma_nr = in_firma_nr
           and tra.transp_id = in_transport_id;
      else
        v_ret_value := C.LGR_RES_FEHLT;
      end if;
    else
      v_ret_value := c.TRANSPORT_FEHLT;
    end if;
    if v_ret_value = 0 then
      commit;
    else
      rollback;
    end if;
    return(v_ret_value);
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
  end lvs_transp_reset;


  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Fehlerabhandlung für eien leeren Lagerplatz wenn dieser Buchungstechnisch
  -- gefüllt seien sollte
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_transport_abbr(in_sid                  in isi_sid.sid%type,
                               in_firma                in isi_firma.firma_nr%type,
                               in_res_id               in isi_resource.res_id%type
                              ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(2550);

  begin
    update isi_transport t
       set t.res_id = NULL,
           t.status = c.TRANS_FREI
     where t.sid = in_sid
       and t.firma_nr = in_firma
       and t.res_id = in_res_id
       and (t.status = c.TRANS_BEGIN
        or  t.status = C.TRANS_ZUGEW);
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
  end lvs_transport_abbr;

  FUNCTION lvs_transp_loeschen(in_sid             in isi_sid.sid%type,
                               in_firma_nr        in isi_firma.firma_nr%type,
                               in_user_id         in isi_user.login_id%type,
                               in_transport_id    in isi_transport.transp_id%type,
                               in_immer_loeschen  in varchar2)
                               RETURN INTEGER IS
    v_error          EXCEPTION;
    v_err_nr         number;
    v_err_text       varchar2(2550);
    v_transp_grp     isi_transport_grp%rowtype;
    v_transp_grp_id  isi_transport_grp.lte_grp_id%type;
    v_transp         isi_transport%rowtype;
    
    v_ret_value      INTEGER; -- return value
    
    CURSOR c_transp_grp is
      select *
        from isi_transport_grp t
       where t.lte_grp_id = v_transp_grp_id
      order by t.lte_pos_grp;
  begin
    if not lvs_p_base.get_transport(in_sid, in_transport_id, v_transp)
    then
      return(C.TRANSPORT_FEHLT);      
    end if;
    if not lvs_p_base.get_transp_grp_by_lte_id(in_sid,
                                               v_transp.lte_id,
                                               v_transp_grp)
    then
      v_ret_value := lvs_transp_loeschen_buchen (in_sid,             -- in isi_sid.sid%type,
                                                 in_firma_nr,        -- IN isi_firma.firma_nr%TYPE,
                                                 in_user_id,         -- IN isi_user.login_id%TYPE,
                                                 in_transport_id,    -- IN isi_transport.transp_id%TYPE,
                                                 in_immer_loeschen); -- in lvs_lte.lte_id%type,
    else
      v_transp_grp_id := v_transp_grp.lte_grp_id;
      OPEN c_transp_grp;
      LOOP
        FETCH c_transp_grp into v_transp_grp;
        EXIT when c_transp_grp%NOTFOUND;
        v_ret_value := lvs_transp_loeschen_buchen (in_sid,                 -- in isi_sid.sid%type,
                                                   in_firma_nr,            -- IN isi_firma.firma_nr%TYPE,
                                                   in_user_id,             -- IN isi_user.login_id%TYPE,
                                                   v_transp_grp.transp_id, -- IN isi_transport.transp_id%TYPE,
                                                   in_immer_loeschen); -- in lvs_lte.lte_id%type,
      end LOOP;
      CLOSE c_transp_grp;
      delete isi_transport_grp t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_grp_id = v_transp_grp_id;
    end if;

    return(v_ret_value);

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_transp_grp%ISOPEN
      then
        CLOSE c_transp_grp;
      end if;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_transp_grp%ISOPEN
      then
        CLOSE c_transp_grp;
      end if;
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

  FUNCTION lvs_transp_loeschen_buchen(in_sid             in isi_sid.sid%type,
                                      in_firma_nr        in isi_firma.firma_nr%type,
                                      in_user_id         in isi_user.login_id%type,
                                      in_transport_id    in isi_transport.transp_id%type,
                                      in_immer_loeschen  in varchar2)
    RETURN INTEGER IS

    v_found_parent     boolean;
    v_found            boolean;
    v_ret_value        INTEGER; -- return value
    v_result           INTEGER; -- return value

    v_transport         isi_transport%ROWTYPE;
    v_transport_parent  isi_transport%ROWTYPE;
    v_transp_grp     isi_transport_grp%rowtype;
    v_lte               lvs_lte%ROWTYPE; -- Daten der transporteinheit (Für den Lagerplatz)
    v_lgr_ziel          lvs_lgr%ROWTYPE; -- Lagerplatz ziel
    v_lgr_quelle        lvs_lgr%ROWTYPE; -- Lagerplatz auf den die lte soll

    v_ziel_lgr_ort_n_freif   lvs_lte.ziel_lgr_ort_n_freif%type;
    v_ziel_lgr_platz_n_freif lvs_lte.ziel_lgr_platz_n_freif%type;
    v_ziel_lgr_ort           lvs_lte.ziel_lgr_ort%type;
    v_ziel_lgr_platz         lvs_lte.ziel_lgr_platz%type;
    v_lgr_platz              lvs_lte.lgr_platz%type;

    v_ist_lagerplatz  lvs_lgr.lgr_platz%TYPE;
    v_soll_lagerplatz lvs_lgr.lgr_platz%TYPE;

    v_ist_lagerort lvs_lgr.lgr_ort%TYPE;
    v_neuer_Status lvs_lte.lte_status%TYPE; -- neuer status der LTE

    v_vorg_id   lvs_lam_bh.vorg_id%TYPE; -- Neu VORGang_ID aus Sequenz
    v_lam_bh_id lvs_lam_bh.lam_bh_id%TYPE; -- Neu LAM_BH_ID aus Sequenz
    v_lam       lvs_lam%rowtype; -- Lagerbestand Menge
    v_lam_kg    lvs_lam.lam_kg%type;

    CURSOR c_transport is
      select tra.*
        from isi_transport tra
       where tra.sid = in_sid
         and tra.firma_nr = in_firma_nr
         and tra.transp_id = in_transport_id;

    CURSOR c_transport_parent is
      select tra.*
        from isi_transport tra
       where tra.sid = in_sid
         and tra.firma_nr = in_firma_nr
         and tra.parent_transp_id = v_transport.transp_id;

    CURSOR c_lvs_lte is -- Lesen des Lagerhilfsmittel
      select * from lvs_lte lte where lte.lte_id = v_transport.lte_id;

    CURSOR c_lvs_lgr is -- Lesen des Lagerplatz
      select * from lvs_lgr lgr where lgr.lgr_platz = v_lgr_platz;

    CURSOR c_lam is
      select *
        from lvs_lam lam
       where lam.sid = in_sid
         and lam.firma_nr = v_lte.firma_nr
         and lam.lte_id = v_lte.lte_id;

  begin
    v_err_nr    := NULL;
    v_err_text  := NULL;
    v_ret_value := 0; -- Erst mal OK

    OPEN c_transport;
    FETCH c_transport
      into v_transport; -- Lesen des Transportauftrags
    v_found := c_transport%FOUND;
    CLOSE c_transport;

    OPEN c_transport_parent;
    FETCH c_transport_parent
      into v_transport_parent; -- Lesen des Transportauftrags
    v_found_parent := c_transport_parent%FOUND;
    CLOSE c_transport_parent;

    if v_found_parent
    then
      update isi_transport t
         set t.parent_transp_id = null
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.parent_transp_id = v_transport.transp_id;
      v_ret_value := lvs_transp_loeschen( in_sid,
                                          in_firma_nr,
                                          in_user_id,
                                          v_transport_parent.transp_id,
                                          c.C_TRUE);
      v_ret_value := 0;
    end if;

    if v_transport.status = C.TRANS_GESPERRT
    and v_transport.parent_transp_id is not NULL
    then
      v_ret_value := C.LGR_TRANSP_BEGONNEN;
      return (v_ret_value);
    end if;

    if not v_found then
      v_ret_value := C.TRANSPORT_FEHLT;
    else
      -- LTE Einlesen
      if  v_transport.status = C.TRANS_FREI
      or v_transport.status = C.TRANS_GESPERRT
      or v_transport.status = C.TRANS_SORT_SPERRE
      or in_immer_loeschen = c.C_TRUE then
        OPEN c_lvs_lte;
        FETCH c_lvs_lte
          into v_lte;
        v_found := c_lvs_lte%FOUND;
        CLOSE c_lvs_lte;

        -- Folgetransport wo der Parent bereits transportiert wurde
        if v_transport.parent_transp_id is not NULL
        and v_lte.lgr_platz = v_transport.lgr_platz_quelle
        then
          v_ret_value := C.LGR_TRANSP_BEGONNEN;
          return (v_ret_value);
        end if;

        -- Bei BDE-Aufträgen müssen die Reservierungen storniert werden
        if v_transport.modul_erzeuger = c.LGR_MODUL_BDE
        or v_transport.modul_erzeuger = c.LGR_MODUL_MFR
        then
          v_result := lvs_ausl.lvs_lte_res_rueck (v_lte.sid,
                                                  v_lte.firma_nr,
                                                  v_lte.order_vorgang_id,
                                                  v_lte.order_auf_id,
                                                  v_lte.lte_id,
                                                  v_lte.order_vorgang_id,
                                                  v_lte.lgr_platz,
                                                  c.c_true);
          OPEN c_lvs_lte;
          FETCH c_lvs_lte
            into v_lte;
          v_found := c_lvs_lte%FOUND;
          CLOSE c_lvs_lte;
        end if;
        if not v_found then
          v_ret_value := C.LTE_FEHLT;
        else
          -- lagerplatz aus lvs_lgr lesen
          v_lgr_platz := v_transport.lgr_platz_ziel;
          v_lgr_ziel := NULL;
          OPEN c_lvs_lgr;
          FETCH c_lvs_lgr
            into v_lgr_ziel;
          v_found := c_lvs_lgr%FOUND;
          CLOSE c_lvs_lgr;
          if not v_found then
            v_ret_value := C.LGR_Z_FEHLT;
          else
            if v_transport.lgr_platz_quelle is not null then
              v_lgr_platz := v_transport.lgr_platz_quelle;
              OPEN c_lvs_lgr;
              FETCH c_lvs_lgr
                into v_lgr_quelle;
              v_found := c_lvs_lgr%FOUND;
              CLOSE c_lvs_lgr;
              if not v_found then
                v_ret_value := C.LGR_Q_FEHLT;
              end if;
            end if;
          end if;
        end if;
      else
        v_ret_value := C.LGR_TRANSP_BEGONNEN;

      end if;
      -- lagerplatz aus lvs_lgr lesen
      if v_ret_value = 0 then
        if v_lte.ziel_lgr_ort_n_freif is not null and
           v_transport.lgr_platz_ziel = v_lte.ziel_lgr_platz_n_freif then
          v_ziel_lgr_ort_n_freif       := v_lte.ziel_lgr_ort_n_freif;
          v_ziel_lgr_platz_n_freif     := v_lte.ziel_lgr_platz_n_freif;
          v_ziel_lgr_ort               := NULL;
          v_ziel_lgr_platz             := NULL;
          v_lte.ziel_lgr_ort_n_freif   := NULL;
          v_lte.ziel_lgr_platz_n_freif := NULL;
          v_lte.ziel_lgr_ort           := v_ziel_lgr_ort_n_freif;
          v_lte.ziel_lgr_platz         := v_ziel_lgr_platz_n_freif;
        elsif v_lte.ziel_lgr_ort_n_freif is not null and
              v_transport.lgr_platz_ziel = v_lte.ziel_lgr_platz then
          v_ziel_lgr_ort           := v_lte.ziel_lgr_ort;
          v_ziel_lgr_platz         := v_lte.ziel_lgr_platz;
          v_ziel_lgr_ort_n_freif   := v_lte.ziel_lgr_ort_n_freif;
          v_ziel_lgr_platz_n_freif := v_lte.ziel_lgr_platz_n_freif;
        else
          v_ziel_lgr_ort           := NULL;
          v_ziel_lgr_platz         := NULL;
          v_ziel_lgr_ort_n_freif   := NULL;
          v_ziel_lgr_platz_n_freif := NULL;
        end if;

        -- Ziel der Transports immer um die EINL-Dispo entlasten
        lvs_platz.lvs_platz_einl_disp_ruecks(v_lte, v_lgr_ziel);

        if  v_lte.lgr_platz is not NULL           -- Dispo rueck wenn Palette noch auf der Quelle
        and (v_transport.status = C.TRANS_FREI
         or  v_transport.status != C.TRANS_ZUGEW
         or v_transport.status = C.TRANS_GESPERRT
         or v_transport.status = C.TRANS_SORT_SPERRE)
        then
          lvs_platz.lvs_platz_ausl_disp_ruecks(v_lte, v_lgr_quelle);
        end if;

        v_err_nr   := NULL;
        v_err_text := NULL;

        -- die transporteinheiten und ihre mengen bekommen nun die aktuellen ist und soll positionen!
        if v_lte.lgr_platz is null then
          if v_transport.transp_typ != 'E'
          then
            v_neuer_Status := c.LTE_KF_STAT; -- Korrektur
            v_err_nr   := 10;
            v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
            select seq_vorg_id.nextval into v_vorg_id from dual;
            v_err_nr := NULL;

            OPEN c_lam;
            LOOP
              FETCH c_lam
                into v_lam; -- LagerArtikelMaterial Eintrag lesen
              EXIT when c_lam%NOTFOUND; -- Kein Eintrag mehr da

              begin
                v_lam_kg := v_lam.lam_kg / v_lam.menge;
              exception
                when others then
                  v_lam_kg := 0;
              end;

              -- Palletier Transport mit Ziel-LTE
              if v_lam.res_ziel_lte_id is not NULL
              then
                update lvs_lam l
                   set l.res_ziel_lte_id = NULL
                 where l.lam_id = v_lam.lam_id;
                update lvs_lte t
                   set t.ziel_lgr_platz = NULL
                 where t.lte_id = v_lam.res_ziel_lte_id
                   and not exists (select l.lam_id
                                     from lvs_lam l
                                    where l.res_ziel_lte_id = v_lam.res_ziel_lte_id);

              end if;
              
              --CMe 20210414 Wenn die Palette bereits in Status KF darf 
              --keine weitere INV Buchung durchgeführt werden. Erzeugt sonst doppelte INV Buchungen
              --Ticket: E70397-606
              if v_lte.lte_status != c.LTE_KF_STAT
              then
                v_err_nr   := 20;
                v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
                select seq_lam_bh.nextval into v_lam_bh_id from dual;
                v_err_nr := NULL;
                v_err_text := NULL;

                -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
                insert into lvs_lam_bh -- Inventur Verbuchen, da die Palette jetzt nicht mehr im Bestand ist
                values
                  (v_lte.sid,
                   v_lte.firma_nr,
                   v_vorg_id,
                   c.LAM_BH_INV,
                   v_lam_bh_id,
                   v_lam.lam_id,
                   v_lam.artikel_id,
                   C.LAM_BH_BUS_INV,
                   sysdate,
                   in_user_id,
                   v_lgr_quelle.lgr_platz,
                   v_lte.lte_id,
                   v_lam.lhm_id,
                   v_lam.charge_id,
                   v_lam.serie_id,
                   NULL,
                   v_lam.menge * -1,
                   v_lam.lam_kg * -1,
                   v_lam_kg,
                   v_transport.res_id,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   sysdate,                     -- CREATED_DATE	N	DATE	Y			creation date+time of this dataset
                   in_user_id,                  -- CREATED_LOGIN_ID	N	NUMBER	Y			login id of the user creating this dataset
                   sysdate,                     -- LAST_CHANGE_DATE	N	DATE	Y			change date+time of this dataset
                   in_user_id,                  -- LAST_CHANGE_LOGIN_ID	N	NUMBER	Y			login id of the user changing this dataset
                   null,                        -- CHANGE_MENGE	N	NUMBER	Y			Menge die geändert wurde
                   v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                   null);                      -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
              end if;
            end LOOP;
            CLOSE c_lam;

          else
            OPEN c_lam;
            LOOP
              FETCH c_lam
                into v_lam; -- LagerArtikelMaterial Eintrag lesen
              EXIT when c_lam%NOTFOUND; -- Kein Eintrag mehr da

              begin
                v_lam_kg := v_lam.lam_kg / v_lam.menge;
              exception
                when others then
                  v_lam_kg := 0;
              end;

              -- Palletier Transport mit Ziel-LTE
              if v_lam.res_ziel_lte_id is not NULL
              then
                update lvs_lam l
                   set l.res_ziel_lte_id = NULL
                 where l.lam_id = v_lam.lam_id;
                update lvs_lte t
                   set t.ziel_lgr_platz = NULL
                 where t.lte_id = v_lam.lte_id;
                update lvs_lte t
                   set t.ziel_lgr_platz = NULL
                 where t.lte_id = v_lam.res_ziel_lte_id
                   and not exists (select l.lam_id
                                     from lvs_lam l
                                    where l.res_ziel_lte_id = v_lam.res_ziel_lte_id);

              end if;

            end LOOP;
            CLOSE c_lam;

            --CMe 20210324 Status muss auf KF bleiben
            if v_lte.lte_status != c.LTE_KF_STAT
            then
              v_neuer_Status := c.LTE_PF_STAT; -- Palettiert Fertig
            else
              v_neuer_Status := c.LTE_KF_STAT; -- Korrektur Fertig
            end if;
          end if;
        else
          if v_lgr_quelle.lgr_platz = v_lte.lgr_platz
          then
            if v_lgr_quelle.lgr_verwendung = C.LGR_TYP_WE then
              v_neuer_Status := c.LTE_BF_STAT;
            elsif v_lgr_quelle.lgr_verwendung = C.LGR_TYP_LagerP then
              v_neuer_Status := c.LTE_BF_STAT;
            elsif v_lgr_quelle.lgr_verwendung = C.LGR_TYP_WA then
              v_neuer_Status := c.LTE_AF_STAT;
            elsif v_lgr_quelle.lgr_verwendung = C.LGR_TYP_EP then
              v_neuer_Status := c.LTE_ET_STAT;
            else
              v_neuer_Status := c.LTE_LF_STAT;
            end if;
          else
            v_neuer_Status := v_lte.lte_status;
          end if;
        end if;

        if v_ziel_lgr_ort_n_freif is not null then
          if v_transport.lgr_platz_ziel = v_ziel_lgr_platz_n_freif then
            v_lte.ziel_lgr_ort           := v_ziel_lgr_ort;
            v_lte.ziel_lgr_platz         := v_ziel_lgr_platz;
            v_lte.ziel_lgr_ort_n_freif   := NULL;
            v_lte.ziel_lgr_platz_n_freif := NULL;
          else
            v_lte.ziel_lgr_ort_n_freif   := NULL;
            v_lte.ziel_lgr_platz_n_freif := NULL;
            v_lte.ziel_lgr_ort           := v_ziel_lgr_ort_n_freif;
            v_lte.ziel_lgr_platz         := v_ziel_lgr_platz_n_freif;
          end if;
        end if;

        lvs_p_lte.LVS_TE_LAGERZIEL_UMBUCHEN_353(in_sid,
                                                in_firma_nr,
                                                v_transport.lte_id,
                                                v_lte.lgr_platz,
                                                v_lte.lgr_ort,
                                                v_lte.lgr_platz_gruppe,
                                                v_lte.ziel_lgr_platz_n_freif,
                                                v_lte.ziel_lgr_ort_n_freif,
                                                v_neuer_status,
                                                v_lte.lte_status,
                                                null,
                                                null,
                                                v_transport.lte_letzte_buchung,
                                                v_lte.order_auf_id,
                                                v_lte.order_vorgang_id,
                                                null,
                                                null,
                                                null,
                                                v_lte.lte_offset_x,
                                                v_lte.lte_offset_y,
                                                v_lte.lte_offset_z);
        if v_lte.order_vorgang_id is not NULL
        and v_transport.transp_typ = 'A'
        then
          update lvs_lgr t
             set t.lgr_order_res_te = t.lgr_order_res_te + 1
           where t.lgr_platz = v_lte.lgr_platz;
        end if;
        
        if lvs_p_base.get_transp_grp_by_lte_grp_id(v_transport.sid,
                                                   v_transport.lte_id,
                                                   v_transp_grp) 
        then
          transport_grp_sub(v_transp_grp.sid,
                            v_transp_grp.firma_nr,
                            v_transp_grp.lte_grp_id,
                            v_transp_grp.lte_id,
                            in_user_id);
        end if;
        

        delete isi_transport tra
         where tra.sid = in_sid
           and tra.firma_nr = in_firma_nr
           and tra.transp_id = in_transport_id;
        --CM 20161004 Nach löschen des Transportes User ID im ISI_Transport_Log nachtragen
        if in_user_id is not NULL then
           update isi_transport_log tralog
              set tralog.login_id = in_user_id
            where tralog.sid = in_sid
              and tralog.firma_nr = in_firma_nr
              and tralog.transp_id = in_transport_id
              and tralog.status = 'D';
        end if;
      end if;
    end if;
    return(v_ret_value);
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
  end lvs_transp_loeschen_buchen;

  function lvs_transp_beginnen(in_sid          in isi_sid.sid%type,
                               in_firma_nr     in isi_firma.firma_nr%type,
                               in_user_id      in isi_user.login_id%type,
                               in_transport_id in isi_transport.transp_id%type,
                               in_lte_id       in lvs_lte.lte_id%type,
                               in_res_id       in isi_resource.res_id%type)
    return integer is

    v_found     boolean;
    v_ret_value INTEGER; -- return value

    v_transport isi_transport%ROWTYPE;
    v_res       isi_resource%ROWTYPE;

    CURSOR c_transport IS
      select t.*
        from isi_transport t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.transp_id = in_transport_id;

    CURSOR c_res is
      select *
        from isi_resource res
       where res.sid = in_sid
         and res.res_id = in_res_id;

  begin
    v_ret_value := 0; -- Erst mal OK

    OPEN c_transport;
    FETCH c_transport
      into v_transport; -- Lesen des Transportauftrags
    v_found := c_transport%FOUND;
    CLOSE c_transport;

    if v_found then
      if v_transport.status != C.TRANS_FREI and
         v_transport.status != C.TRANS_ZUGEW then
        v_ret_value := C.LGR_TRANSP_BEGONNEN;
      else
        if in_res_id is not NULL then
          OPEN c_res;
          FETCH c_res
            into v_res; -- Resource lesen
          v_found := c_res%FOUND;
          CLOSE c_res;
        else
          v_found := TRUE;
        end if;
        if v_found then
          update isi_transport tra
             set tra.res_id = nvl(in_res_id, tra.res_id),
                 tra.status = c.TRANS_BEGIN
           where tra.sid = in_sid
             and tra.firma_nr = in_firma_nr
             and tra.transp_id = in_transport_id;
        else
          v_ret_value := C.LGR_RES_FEHLT;
        end if;
      end if;
    else
      v_ret_value := c.TRANSPORT_FEHLT;
    end if;
    return(v_ret_value);
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
  end LVS_TRANSP_BEGINNEN;
  --------------------------------------------------------------------------------
  -- procedure LVS_c.TRANSP_TRANSPORT
  -- Transport mit der ID xx wird begonnen Palette ist aufgenommen und wird
  -- Transportiert
  --------------------------------------------------------------------------------
  function lvs_transp_transport(in_sid             in isi_sid.sid%type,
                                in_firma_nr        in isi_firma.firma_nr%type,
                                in_user_id         in isi_user.login_id%type,
                                in_transport_id    in isi_transport.transp_id%type,
                                in_lte_id          in lvs_lte.lte_id%type,
                                in_res_id          in isi_resource.res_id%type,
                                in_out_lam_bh_vorg in out isi_transport.lam_bh_vorgang_id%type)
    return integer is

    v_found     boolean;
    v_ret_value INTEGER; -- return value

    v_transport    isi_transport%ROWTYPE;
    v_order        isi_order_pos%ROWTYPE;
    v_lte          lvs_lte%ROWTYPE; -- Daten der transporteinheit (Für den Lagerplatz)
    v_neuer_status lvs_lte.lte_status%type;
    v_Quell_lgr    lvs_lgr%ROWTYPE; -- Lagerplatz auf dem die LTE steht
    v_Ziel_lgr     lvs_lgr%ROWTYPE; -- Lagerplatz auf dem die LTE steht
    v_lgr_platz    lvs_lgr.lgr_platz%type; -- Lagerplatz für CURSOR
    v_lam          lvs_lam%rowtype; -- Lagerbestand Menge

    v_lam_bh_id lvs_lam_bh.lam_bh_id%TYPE; -- Neu LAM_BH_ID aus Sequenz
    v_vorg_id   lvs_lam_bh.vorg_id%TYPE; -- Neu VORGang_ID aus Sequenz
    v_vorg_typ  lvs_lam_bh.vorg_typ%type; -- Typ des Vorgangs (UL, LZ ...)
    v_lam_kg    lvs_lam.lam_kg%type;

    CURSOR c_lte IS
      select lte.*
        from lvs_lte lte
       where lte.lte_id = in_lte_id
         and lte.sid = in_sid
         and lte.firma_nr = in_firma_nr;

    CURSOR c_lgr is -- Lesen des Lagerplatz
      select lgr.*
        from lvs_lgr lgr
       where lgr.lgr_platz = v_lgr_platz
         and lgr.sid = in_sid;

    CURSOR c_transport IS
      select tra.*
        from isi_transport tra
       where tra.sid = in_sid
         and tra.firma_nr = in_firma_nr
         and tra.transp_id = in_transport_id;

    CURSOR c_order IS
      select ord.*
        from isi_order_pos ord
       where ord.sid = in_sid
         and ord.firma_nr = in_firma_nr
         and ord.auf_id = v_transport.auf_id;

    CURSOR c_lam is
      select *
        from lvs_lam lam
       where lam.sid = in_sid
         and lam.firma_nr = in_firma_nr
         and lam.lte_id = in_lte_id;

    v_lvs_transp_check_we_waren boolean;
    v_lvs_transp_check_wa_waren boolean;
  begin
    v_err_nr := NULL;
    v_err_text := NULL;
    v_ret_value := 0; -- Erst mal OK

    v_lvs_transp_check_we_waren := (isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', null, 'lvs_transp_check_we_waren', 'LVS', 'CFG', 'F', 'BOOLEAN') = 'T');
    v_lvs_transp_check_wa_waren := (isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', null, 'lvs_transp_check_wa_waren', 'LVS', 'CFG', 'F', 'BOOLEAN') = 'T');

    OPEN c_transport;
    FETCH c_transport
      into v_transport; -- Lesen des Transportauftrags
    v_found := c_transport%FOUND;
    CLOSE c_transport;

    if not v_found then
      v_ret_value := c.TRANSPORT_FEHLT;
      return(v_ret_value);
    end if;

    if v_transport.status = c.TRANS_TRANSPORT
    then
      return(v_ret_value);
    end if;

    if v_transport.modul_bearbeiter != c.LGR_MODUL_MFR
    then
      if ((v_transport.transp_typ = 'E' and v_lvs_transp_check_we_waren)
          or (v_transport.transp_typ = 'A' and v_lvs_transp_check_wa_waren))
         and v_transport.check_ware_login_id is null
      then
        v_err_nr := 10;
        v_err_text :=  LC.ec(LC.O_TXT_QUIT_N_MOEGL_WARE_PRUEF);
        -- v_err_text := 'Quittieren nicht möglich, da noch keine Warenprüfung erfolgt ist.';
        raise v_error;
      end if;
    end if;

    OPEN c_lte;
    FETCH c_lte
      into v_lte; -- Lesen der Transporteinheit
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found then
      v_ret_value := c.LTE_FEHLT;
      return(v_ret_value);
    end if;

    if v_lte.ziel_lgr_platz is not null then
      v_lgr_platz := v_lte.ziel_lgr_platz;
    else
      v_lgr_platz := v_transport.lgr_platz_ziel;
    end if;

    OPEN c_lgr;
    FETCH c_lgr
      into v_ziel_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;

    if not v_found then
      v_ret_value := c.LGR_Z_FEHLT;
      return(v_ret_value);
    end if;

    if v_lte.lgr_platz is not NULL then
      v_lgr_platz := v_lte.lgr_platz;
    else
      v_lgr_platz := v_transport.lgr_platz_quelle;
    end if;

    OPEN c_lgr;
    FETCH c_lgr
      into v_quell_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;
    
    -- CMe 20210423 Anfang:
    -- Wenn die Palette keinen Quellplatz hat, dieser aber insn isi_transport gesetzt ist,
    -- dann auf den Quellplatz im korrekten Status einbuchen.
    -- Ticket: E70397-616
    if (v_found) and
       (v_lte.lgr_platz is null)
    then
      if (v_transport.transp_typ = 'E') or
         (v_transport.transp_typ = 'U')
      then
        if (v_transport.transp_typ = 'U') or
           (v_quell_lgr.lgr_verwendung = c.LGR_TYP_Lager)
        then
          v_neuer_status := c.LTE_UD_STAT;
        else
          v_neuer_status := c.LTE_ED_STAT;
        end if;
      else
        v_neuer_status := c.LTE_AD_STAT;
      end if;
      lvs_p_lte.lvs_korr_te_einbuchen (v_lte.sid,
                                       v_lte.firma_nr,
                                       v_lte.lte_id,
                                       v_neuer_status,
                                       v_quell_lgr.sid,
                                       v_quell_lgr.firma_nr,
                                       v_quell_lgr.lgr_ort,
                                       v_quell_lgr.lgr_platz,
                                       -1,
                                       False);
    end if;
    -- CMe 20210423 Ende
    
    /*
    if not v_found then
      v_ret_value := c.LGR_Q_FEHLT;
      return (v_ret_value);
    end if;
    */

    v_neuer_status := c.LTE_ET_STAT;
    v_vorg_typ     := c.LAM_BH_ZUGAGNG;

    if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_WA
    or (v_Quell_lgr.Lgr_Verwendung = c.LGR_TYP_Lager
    and v_ziel_lgr.lgr_verwendung = c.LGR_TYP_EP) then
      v_neuer_Status := c.LTE_AT_STAT;
      v_vorg_typ     := c.LAM_BH_ABGAGNG;
    end if;

    if  (v_quell_lgr.lgr_verwendung = c.LGR_TYP_Lager
      or v_quell_lgr.lgr_verwendung = c.LGR_TYP_Puffer
      or v_quell_lgr.lgr_verwendung = c.LGR_TYP_LagerP)
    and (v_ziel_lgr.lgr_verwendung = c.Lgr_Typ_Lager
      or v_ziel_lgr.lgr_verwendung = c.LGR_TYP_Puffer
      or v_ziel_lgr.lgr_verwendung = c.LGR_TYP_LagerP)
    then
      v_neuer_Status := c.LTE_UT_STAT;
      v_vorg_typ     := c.LAM_BH_UMLAG;
    end if;

    if v_quell_lgr.lgr_platz is not NULL then
      lvs_platz.lvs_platz_ausl_buchen(v_lte, v_quell_lgr); -- Bucht den Lagerplatz Fehler dann Exception
    end if;

    lvs_p_lte.lvs_te_lagerziel_umbuchen_353(v_lte.sid,
                                            v_lte.firma_nr,
                                            v_lte.lte_id,
                                            null,
                                            null,
                                            null,
                                            v_lte.ziel_lgr_platz,
                                            v_lte.ziel_lgr_ort,
                                            v_neuer_status,
                                            v_lte.lte_status,
                                            v_lte.ziel_lgr_platz_n_freif,
                                            v_lte.ziel_lgr_ort_n_freif,
                                            systimestamp,
                                            v_lte.order_auf_id,
                                            v_lte.order_vorgang_id,
                                            NULL,
                                            v_lte.transport_gruppe,
                                            v_lte.lkw_nr,
                                            v_lte.lte_offset_x,
                                            v_lte.lte_offset_y,
                                            NULL);

    if in_out_lam_bh_vorg is NULL then
      v_err_nr   := 10;
      v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
      select seq_vorg_id.nextval into v_vorg_id from dual;
      v_err_nr := NULL;
      in_out_lam_bh_vorg := v_vorg_id;
    else
      v_vorg_id := in_out_lam_bh_vorg;
    end if;
    v_err_nr := NULL;
    v_err_text := NULL;

    OPEN c_order;
    FETCH c_order
      into v_order; -- Lesen der ISI_ORDER
    CLOSE c_order;

    OPEN c_lam;
    LOOP
      FETCH c_lam
        into v_lam; -- LagerArtikelMaterial Eintrag lesen
      EXIT when c_lam%NOTFOUND; -- Kein Eintrag mehr da

      begin
        v_lam_kg := v_lam.lam_kg / v_lam.menge;
      exception
        when others then
          v_lam_kg := 0;
      end;

      v_err_nr   := 20;
      v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
      select seq_lam_bh.nextval into v_lam_bh_id from dual;
      v_err_nr := NULL;
      v_err_text := NULL;

      -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
      insert into lvs_lam_bh
      values
        (v_lte.sid,
         v_lte.firma_nr,
         v_vorg_id,
         v_vorg_typ,
         v_lam_bh_id,
         v_lam.lam_id,
         v_lam.artikel_id,
         C.LAM_BH_BUS_UML,
         sysdate,
         in_user_id,
         v_quell_lgr.lgr_platz,
         in_lte_id,
         v_lam.lhm_id,
         v_lam.charge_id,
         v_lam.serie_id,
         v_order.auftrag,
         v_lam.menge * -1,
         v_lam.lam_kg * -1,
         v_lam_kg,
         in_res_id,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         sysdate,                     -- CREATED_DATE	N	DATE	Y			creation date+time of this dataset
         in_user_id,                  -- CREATED_LOGIN_ID	N	NUMBER	Y			login id of the user creating this dataset
         sysdate,                     -- LAST_CHANGE_DATE	N	DATE	Y			change date+time of this dataset
         in_user_id,                  -- LAST_CHANGE_LOGIN_ID	N	NUMBER	Y			login id of the user changing this dataset
         null,                        -- CHANGE_MENGE	N	NUMBER	Y			Menge die geändert wurde
         v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
         null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

    end LOOP;
    CLOSE c_lam;

    -- start transaction
    update isi_transport tra
       set tra.res_id            = nvl(in_res_id, tra.res_id),
           tra.status            = c.TRANS_TRANSPORT,
           tra.lam_bh_vorgang_id = v_vorg_id
     where tra.sid = in_sid
       and tra.firma_nr = in_firma_nr
       and tra.transp_id = in_transport_id;

    if v_quell_lgr.lgr_platz is not null then
      lvs_platz.lvs_platz_ausl_disp_ruecks(v_lte, v_quell_lgr);
    end if;

    return(v_ret_value);
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
  end LVS_TRANSP_TRANSPORT;

  --------------------------------------------------------------------------------
  -- procedure LVS_c.TRANSP_FERTIG
  -- Transport mit der ID xx ist fertig Palette Platz und evtl. Order wird gebucht
  --------------------------------------------------------------------------------
  FUNCTION lvs_transp_fertig(in_sid          IN isi_sid.sid%TYPE,
                             in_firma_nr     IN isi_firma.firma_nr%TYPE,
                             in_user_id      IN isi_user.login_id%TYPE,
                             in_transport_id IN isi_transport.transp_id%TYPE,
                             in_lte_id       in lvs_lte.lte_id%type,
                             in_res_id       in isi_resource.res_id%type,
                             in_lgr_platz    in lvs_lgr.lgr_platz%type,
                             in_ausgelagert  in varchar2) RETURN INTEGER IS
    v_ret_value           INTEGER; -- return value
  begin
    v_ret_value := lvs_transport.lvs_transp_fertig_353(in_sid,
                                                       in_firma_nr,
                                                       in_user_id,
                                                       in_transport_id,
                                                       in_lte_id,
                                                       in_res_id,
                                                       in_lgr_platz,
                                                       in_ausgelagert,
                                                       NULL,
                                                       NULL,
                                                       NULL);
    return(v_ret_value);
  end;

  FUNCTION lvs_transp_fertig_buchen(in_sid          in isi_sid.sid%type,
                                    in_firma_nr     IN isi_firma.firma_nr%TYPE,
                                    in_user_id      IN isi_user.login_id%TYPE,
                                    in_transport_id IN isi_transport.transp_id%TYPE,
                                    in_lte_id       in lvs_lte.lte_id%type,
                                    in_res_id       in isi_resource.res_id%type,
                                    in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                    in_ausgelagert  in varchar2,
                                    in_offset_x     in lvs_lte.lte_offset_x%type,
                                    in_offset_y     in lvs_lte.lte_offset_y%type,
                                    in_offset_z     in lvs_lte.lte_offset_z%type) RETURN INTEGER is
    -------------------------------------------------------------------------------------------------------
    v_ret_value           INTEGER; -- return value
    v_result              INTEGER; -- return value

    v_found                BOOLEAN; -- Dummy Var für gefunden im CURSOR
    v_found_parent         boolean;

    v_trans_lte            isi_transport%ROWTYPE;

    v_transport            isi_transport%ROWTYPE;
    v_transport_parent     isi_transport%ROWTYPE;
    v_order_pos            isi_order_pos%ROWTYPE;
    v_lam                  lvs_lam%rowtype; -- Lagerbestand Menge
    v_bde_fa               bde_fa_auftrag%rowtype;
    v_vorg_typ             lvs_lam_bh.vorg_typ%type; -- Typ des Vorgangs (UL, LZ ...)
    v_vorg_id              lvs_lam_bh.vorg_id%TYPE; -- Neu VORGang_ID aus Sequenz
    v_lam_bh_id            lvs_lam_bh.lam_bh_id%TYPE; -- Neu LAM_BH_ID aus Sequenz
    v_lam_order_sum        number; -- Reservierte Menge

    v_buch_date            date; -- Datum und zeit dieser Buchungen

    v_neuer_status         lvs_lte.lte_status%type;
    v_lte_ziel             lvs_lte%rowtype; -- Daten der transporteinheit (Für den Lagerplatz)
    v_lte                  lvs_lte%rowtype; -- Daten einer Transporteinheit
    v_lte_cfg              lvs_lte_cfg%rowtype; -- CFG Daten einer Transporteinheit
    v_komm_q_lte           lvs_lte%rowtype;
    v_komm_order           isi_komm_order%rowtype;

    v_lhm                  lvs_lhm%rowtype; -- Daten des Ladehilfsmittel
    v_lgr_lte              lvs_lgr%rowtype; -- LTE des Transports
    v_quell_lgr            lvs_lgr%rowtype; -- Echtes Ziel des Transports
    v_ziel_lgr             lvs_lgr%rowtype; -- Echtes Ziel des Transports
    v_pruef_lgr            lvs_lgr%rowtype; -- Prüfen Ziel des Transports
    v_ziel_n_frei_lgr      lvs_lgr%rowtype; -- Altes Ziel nach freifahren

    v_lgr_platz            lvs_lgr.lgr_platz%type; -- Lagerplatz für CURSOR
    v_in_lgr_platz         lvs_lgr.lgr_platz%type; -- Lagerplatz für CURSOR aus Uebergabe
    v_liefs                isi_liefs%rowtype; -- Daten des Lieferschein (Bereits erstellt)
    v_order_status         isi_order_pos.status%type; -- Status der Order-Pos.

    v_ausgelagert          varchar2(1);

    v_lhm_id               isi_liefs.v_lhm_id%type; -- LHM-ID des Ersten Krtons auf der Palette

    v_anz_pos              number; -- Anzahl der AUF_ID's diesen Vorgangs

    v_lam_kg               lvs_lam.lam_kg%type;
    v_lte_kg               lvs_lte.lte_akt_kg%type;
    v_trans_anz            number;
    v_trans_grp            isi_transport.transport_gruppe%type;
    v_offset_z             lvs_lte.lte_offset_z%type;

    cursor c_kom_order_tvk is
      select *
        from isi_komm_order t
       where t.transp_id_vor_komm = in_transport_id;

    cursor c_pos_anz is
      select count(auf_id)
        from isi_order_pos pos
       where pos.sid = in_sid
         and pos.vorgang_typ = v_order_pos.vorgang_typ
         and pos.vorgang_id = v_order_pos.vorgang_id
         -- and pos.auf_id != v_order_pos.auf_id
         and pos.status != 'E'
         and pos.status != 'X'               -- Auch X ist fertig
       group by pos.vorgang_typ, pos.vorgang_id;

    CURSOR c_transport IS
      select tr.*
        from isi_transport tr
       where tr.transp_id = in_transport_id
         and tr.sid = in_sid
         and tr.firma_nr = in_firma_nr;

    CURSOR c_trans_order_gesperrt is
      select count(*), min(tr.transport_gruppe)
        from isi_transport tr
       where tr.vorgang_id = v_transport.vorgang_id
         and tr.status = c.TRANS_GESPERRT
         and tr.sid = in_sid
         and tr.firma_nr = in_firma_nr;

    CURSOR c_trans_order_frei is
      select count(*)
        from isi_transport tr
       where tr.vorgang_id = v_transport.vorgang_id
         and tr.status != c.TRANS_GESPERRT
         and tr.sid = in_sid
         and tr.firma_nr = in_firma_nr;

    CURSOR c_transport_order_anz IS
      select count(tr.transp_id)
        from isi_transport tr
       where tr.vorgang_id = v_transport.vorgang_id
         and tr.sid = in_sid
         and tr.firma_nr = in_firma_nr;

    CURSOR c_transport_parent is
      select tra.*
        from isi_transport tra
       where tra.sid = in_sid
         and tra.firma_nr = in_firma_nr
         and tra.parent_transp_id = v_transport.transp_id;

    CURSOR c_transport_ziel IS
      select tr.*
        from isi_transport tr
       where tr.sid = in_sid
         and tr.firma_nr = in_firma_nr
         and tr.lgr_platz_ziel = v_in_lgr_platz
       order by tr.freifahrauftrag desc,
                tr.transport_reihenfolge,
                tr.prio desc,
                tr.transp_id;
    CURSOR c_lte IS
      select lte.*
        from lvs_lte lte
       where lte.lte_id = in_lte_id
         and lte.sid = in_sid
         and lte.firma_nr = in_firma_nr;

    CURSOR c_lte_ausl is
      select *
        from lvs_lte lte
       where lte.sid = in_sid
         and lte.firma_nr = in_firma_nr
         and lte.order_auf_id = v_order_pos.auf_id
         and (lte.lte_status = c.LTE_AD_STAT or
             lte.lte_status = c.LTE_AF_STAT);

    CURSOR c_lte_ziel IS
      select lte.*
        from lvs_lte lte
       where lte.ziel_lgr_platz = v_in_lgr_platz
         and lte.sid = in_sid
         and lte.firma_nr = in_firma_nr;

    CURSOR c_lgr is -- Lesen des Lagerplatz
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = v_lgr_platz
         and lgr.sid = in_sid;

    CURSOR c_lgr_kanal is -- Lesen des 1 freien Platz im Kanal
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz_gruppe = v_ziel_lgr.lgr_platz_gruppe
         and lgr.lgr_ort = v_ziel_lgr.lgr_ort
         and lgr.lgr_dim_g = v_ziel_lgr.lgr_dim_g
         and lgr.lgr_dim_r = v_ziel_lgr.lgr_dim_r
         and lgr.lgr_dim_p = v_ziel_lgr.lgr_dim_p
         and lgr.lgr_dim_e = v_ziel_lgr.lgr_dim_e
         and lgr.lgr_akt_te = 0
         and lgr.sid = in_sid
        order by lgr.lgr_dim_fifo_nr;

      -- -AG- fehler Mischpaletten
      CURSOR c_order_pos IS
      select ord.*
        from isi_order_pos ord
       where ord.sid = in_sid
         and ord.firma_nr = in_firma_nr
         and ord.auf_id = v_lam.order_pos_auf_id;

    CURSOR c_lam is
      select *
        from lvs_lam lam
       where lam.sid = in_sid
         and lam.firma_nr = in_firma_nr
         and lam.lte_id = in_lte_id
       order by lam.order_pos_auf_id;

    CURSOR c_lam_order_sum is
      select decode(v_order_pos.menge_basis, c.BASIS_LTE, count(lam.menge),  sum(lam.menge))
        from lvs_lam lam,
             lvs_lgr lgr
       where lam.sid = in_sid
         and lam.firma_nr = in_firma_nr
         and lam.order_pos_auf_id = v_lam.order_pos_auf_id         
         and lam.lgr_platz = lgr.lgr_platz(+)
         and (exists (select * from isi_transport t where t.lte_id = lam.lte_id and t.auf_id = lam.order_pos_auf_id)
              or nvl(lgr.lgr_verwendung, 'WA') != 'WA');

    CURSOR c_liefers is
      select *
        from isi_liefs l
       where l.sid = v_lam.sid
         and l.firma_nr = v_lam.firma_nr
         and l.li_nr = v_transport.li_nr
         and l.artikel_id = v_lam.artikel_id
         and nvl(l.charge_id, nvl(v_lam.charge_id, -1)) =
             nvl(v_lam.charge_id, -1)
         and nvl(l.serie_id, nvl(v_lam.serie_id, -1)) =
             nvl(v_lam.serie_id, -1);

    v_lvs_transp_check_we_waren boolean;
    v_lvs_transp_check_wa_waren boolean;
    v_lvs_transp_check_einl_lgr boolean;
    v_lvs_transp_check_uml_lgr boolean;
    v_lvs_transp_check_ausl_lgr_z boolean;
    v_lvs_transp_check_ausl_lgr_q boolean;
  begin
    v_ret_value := 0; -- Erst mal OK
    v_buch_date := sysdate;

    v_ausgelagert := in_ausgelagert;

    v_lvs_transp_check_we_waren := (isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', null, 'lvs_transp_check_we_waren', 'LVS', 'CFG', 'F', 'BOOLEAN') = 'T');
    v_lvs_transp_check_wa_waren := (isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', null, 'lvs_transp_check_wa_waren', 'LVS', 'CFG', 'F', 'BOOLEAN') = 'T');
    v_lvs_transp_check_einl_lgr := (isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', null, 'lvs_transp_check_einl_lgr', 'LVS', 'CFG', 'F', 'BOOLEAN') = 'T');
    v_lvs_transp_check_uml_lgr := (isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', null, 'lvs_transp_check_uml_lgr', 'LVS', 'CFG', 'F', 'BOOLEAN') = 'T');
    v_lvs_transp_check_ausl_lgr_z := (isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', null, 'lvs_transp_check_ausl_lgr_z', 'LVS', 'CFG', 'F', 'BOOLEAN') = 'T');
    v_lvs_transp_check_ausl_lgr_q := (isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'CFG', null, 'lvs_transp_check_ausl_lgr_q', 'LVS', 'CFG', 'F', 'BOOLEAN') = 'T');

    OPEN c_transport;
    FETCH c_transport
      into v_transport; -- Lesen des Transportauftrags
    v_found := c_transport%FOUND;
    CLOSE c_transport;

    if not v_found then
      v_ret_value := c.TRANSPORT_FEHLT;
      return(v_ret_value);
    end if;

    if v_transport.modul_bearbeiter != c.LGR_MODUL_MFR
    then
      -- Hier sind die Prüfungen, ob manuelle Prüfungen nötig sind und ob diese
      -- durchgrführt sinf
      if ((v_transport.transp_typ = 'E' and v_lvs_transp_check_we_waren)
          or (v_transport.transp_typ = 'A' and v_lvs_transp_check_wa_waren))
         and v_transport.check_ware_login_id is null
      then
        v_err_nr := 10;
        v_err_text :=  LC.ec(LC.O_TXT_QUIT_N_MOEGL_WARE_PRUEF);
        -- v_err_text := 'Quittieren nicht möglich, da noch keine Warenprüfung erfolgt ist.';
        raise v_error;
      end if;

      if ((v_transport.transp_typ = 'A' and v_lvs_transp_check_ausl_lgr_q))
         and v_transport.check_platz_q_login_id is null
      then
        v_err_nr := 11;
        v_err_text :=  LC.ec(LC.O_TXT_QUIT_N_MOEGL_QUELL_PL);
        -- v_err_text := 'Quittieren nicht möglich, da noch keine Quellplatzprüfung erfolgt ist.';
        raise v_error;
      end if;

      if (    (v_transport.transp_typ = 'E' and v_transport.lgr_verwendung_ziel != 'WA'
               and v_lvs_transp_check_einl_lgr)
           or (v_transport.transp_typ = 'E' and v_transport.lgr_verwendung_ziel = 'WA'
               and v_lvs_transp_check_ausl_lgr_z)
           or (v_transport.transp_typ = 'A' and v_lvs_transp_check_ausl_lgr_z)
           or (v_transport.transp_typ = 'U' and v_lvs_transp_check_uml_lgr))
         and v_transport.check_platz_z_login_id is null
      then
        v_err_nr := 11;
        v_err_text :=  LC.ec(LC.O_TXT_QUIT_N_MOEGL_ZIEL_PL);
        -- v_err_text := 'Quittieren nicht möglich, da noch keine Zielplatzprüfung erfolgt ist.';
        raise v_error;
      end if;
    end if;

    OPEN c_lte;
    FETCH c_lte into v_lte; -- Lesen der Transporteinheit
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    OPEN c_transport_parent;
    FETCH c_transport_parent
      into v_transport_parent; -- Lesen des Transportauftrags
    v_found_parent := c_transport_parent%FOUND;
    CLOSE c_transport_parent;

    if v_found_parent -- Staffeltransport
    then -- Im Staffeltransport steht in der LTE immer das Letzte Ziel
      if in_lgr_platz is not null then
        v_in_lgr_platz := in_lgr_platz;
      else
        v_in_lgr_platz := v_transport.lgr_platz_ziel;
      end if;
      if v_in_lgr_platz != v_transport.lgr_platz_ziel -- Kann beim MFR nicht sein, daher Exception OK
      then
        if v_transport.modul_bearbeiter != c.LGR_MODUL_MFR
        then
          v_err_nr := 15;
          v_err_text := LC.ec_p2(LC.O_TP2_LTE_PLATZ_T_PLATZ_DIFF, v_in_lgr_platz, v_transport.lgr_platz_ziel);
          raise v_error;
        else
          v_ret_value := c.LGR_ZIEL_TYP_FALSCH;
          return(v_ret_value);
        end if;
      end if;
    else
      if in_lgr_platz is not null then
        v_in_lgr_platz := in_lgr_platz;
      elsif v_lte.ziel_lgr_platz is not null then
        v_in_lgr_platz := v_lte.ziel_lgr_platz;
      else
        v_in_lgr_platz := v_transport.lgr_platz_ziel;
      end if;
    end if;

    if not v_found then
      v_ret_value := c.LTE_FEHLT;
      return(v_ret_value);
    end if;
    v_lte_kg := v_lte.lte_akt_kg;

    if v_lte.lgr_platz is not NULL then
      v_lgr_platz := v_lte.lgr_platz;
    else
      v_lgr_platz := v_transport.lgr_platz_quelle;
    end if;

    v_quell_lgr := NULL;
    OPEN c_lgr;
    FETCH c_lgr
      into v_quell_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;

    if  v_transport.modul_bearbeiter = c.LGR_MODUL_MFR
    and v_quell_lgr.lgr_platz is NULL
    then
      if lvs_p_base.get_lam_by_lte_id(v_lte.sid,
                                      v_lte.firma_nr,
                                      v_lte.lte_id,
                                      v_lam)
      and lvs_p_base.get_lgr_platz(v_lam.lam_text, v_quell_lgr) -- Versuche die Palette auf der Quelle einzubuchen
      then
        v_lte.lgr_ort := v_quell_lgr.lgr_ort;
        v_lte.lgr_platz := v_quell_lgr.lgr_platz;
      else
        v_lte.lgr_ort := v_transport.lgr_ort_ziel;
        v_lte.lgr_platz := v_transport.lgr_platz_ziel;
      end if;
      s_schnittstelle.write_host_platz_lte_update(v_lte);
      v_lte.lgr_ort := NULL;
      v_lte.lgr_platz := NULL;
    end if;

    v_lgr_platz := v_in_lgr_platz;

    OPEN c_lgr;
    FETCH c_lgr
      into v_ziel_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;

    if v_transport.modul_bearbeiter != c.LGR_MODUL_MFR
    then
      if  v_ziel_lgr.lgr_typ = c.DURCHL1    -- Hier muss eine feste Reihenfolge beachtet werden
      and v_ziel_lgr.wa_typ like 'BDEPUSH%' -- Da hier BDE-PUSH genau die Reihenfolge eingehaten werden muss
      then
        OPEN c_transport_ziel;
        FETCH c_transport_ziel
          into v_trans_lte; -- Lesen des Transportauftrags
        v_found := c_transport_ziel%FOUND;
        CLOSE c_transport_ziel;
        if v_trans_lte.transp_id != in_transport_id    -- Die ID passt nicht, dann reihenfolge falsch
        then
          v_ret_value := c.LGR_REIHENFOLGE_FALSCH;
          return(v_ret_value);
        end if;
      end if;
      -- Hier Prüfen, ob es eine Überholung gibt (Ziehl hat eine andere Tiefe
      if ((v_ziel_lgr.lgr_typ = c.SAT1)
       or (v_ziel_lgr.lgr_typ = c.KANAL1)
       or (v_ziel_lgr.lgr_typ = c.SEG1)
       or (v_ziel_lgr.lgr_typ = c.SEG_DUEDO1))
      then
        OPEN c_lgr_kanal;
        FETCH c_lgr_kanal into v_pruef_lgr;
        CLOSE c_lgr_kanal;
        -- Pruefung auf Gruppe findet später statt
        if v_pruef_lgr.lgr_platz != v_lgr_platz
        then
          v_in_lgr_platz := v_pruef_lgr.lgr_platz;
          v_lgr_platz := v_pruef_lgr.lgr_platz;
          OPEN c_lgr;
          FETCH c_lgr
            into v_ziel_lgr;
          v_found := c_lgr%FOUND;
          CLOSE c_lgr;
        end if;
      end if;
    end if;

    if not v_found then
      v_ret_value := c.LGR_Z_FEHLT;
      return(v_ret_value);
    end if;

    if not lvs_p_base.get_lte_cfg(v_lte.sid, v_lte.lte_name, v_lte_cfg)
    then
      v_lte_cfg.virtuell := 'F';         -- Nach Transport nicht löschen
    end if;

    if v_transport.status != C.TRANS_TRANSPORT
    and (v_Ziel_lgr.lgr_verwendung != c.LGR_TYP_LagerP -- -AG- In der Palletierung nicht nötig
      or v_lte_cfg.virtuell != 'L')
    then
      -- CMe 20210423 Anfang:
      -- Wenn die Palette keinen Quellplatz hat, dieser aber insn isi_transport gesetzt ist,
      -- dann auf den Quellplatz im korrekten Status einbuchen.
      -- Ticket: E70397-616
      -- CMe 20210527 Ergänzung: Darf nur durchgeführt werden bei Status <> 'E'
      -- Ticket: E70397-632
      if (v_lte.lgr_platz is null) and
         (v_transport.status != 'E')
      then
        if lvs_p_base.get_lgr_platz(v_in_lgr_platz, v_quell_lgr) -- Versuche die Palette auf der Quelle einzubuchen
        then
          if (v_transport.transp_typ = 'E') or
             (v_transport.transp_typ = 'U')
          then
            if (v_transport.transp_typ = 'U') or
               (v_quell_lgr.lgr_verwendung = c.LGR_TYP_Lager)
            then
              v_neuer_status := c.LTE_UD_STAT;
            else
              v_neuer_status := c.LTE_ED_STAT;
            end if;
          else
            v_neuer_status := c.LTE_AD_STAT;
          end if;
          lvs_p_lte.lvs_korr_te_einbuchen (v_lte.sid,
                                           v_lte.firma_nr,
                                           v_lte.lte_id,
                                           v_neuer_status,
                                           v_quell_lgr.sid,
                                           v_quell_lgr.firma_nr,
                                           v_quell_lgr.lgr_ort,
                                           v_quell_lgr.lgr_platz,
                                           in_user_id,
                                           False);
        end if;
      end if;
      -- CMe 20210423 Ende
      v_ret_value := lvs_transp_transport(in_sid,
                                          in_firma_nr,
                                          in_user_id,
                                          in_transport_id,
                                          in_lte_id,
                                          in_res_id,
                                          v_vorg_id);
      if v_ret_value != 0 then
        return(v_ret_value);
      end if;
    end if;

    v_neuer_status := c.LTE_LF_STAT;
    v_vorg_typ     := c.LAM_BH_ZUGAGNG;

    if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_WA then
      v_neuer_status := c.Lte_Af_Stat;
      if v_transport.transp_typ = 'U' then
        v_neuer_status := c.LTE_UF_STAT;
      end if;
      v_vorg_typ := c.LAM_BH_ABGAGNG;
    end if;

    if  (v_quell_lgr.lgr_verwendung = c.LGR_TYP_Lager
      or v_quell_lgr.lgr_verwendung = c.LGR_TYP_Puffer
      or v_quell_lgr.lgr_verwendung = c.LGR_TYP_LagerP)
    and (v_ziel_lgr.lgr_verwendung = c.Lgr_Typ_Lager
      or v_ziel_lgr.lgr_verwendung = c.LGR_TYP_Puffer)
    then
      v_vorg_typ := c.LAM_BH_UMLAG;
    end if;

    if v_Ziel_lgr.lgr_verwendung = c.LGR_TYP_LagerP
    and v_lte_cfg.virtuell = 'L'
    then
      if not lvs_p_base.get_lam_by_lte_id(v_lte.sid,
                                          v_lte.firma_nr,
                                          v_lte.lte_id,
                                          v_lam)
      then
        return (c.LGR_LTE_FEHLT);
      end if;

      if v_lte.lgr_platz is NULL
      then
        if lvs_p_base.get_lgr_platz(v_in_lgr_platz, v_quell_lgr) -- Versuche die Palette auf der Quelle einzubuchen
        then
          lvs_p_lte.lvs_korr_te_einbuchen (v_lte.sid,
                                           v_lte.firma_nr,
                                           v_lte.lte_id,
                                           v_lte.lte_status,
                                           in_sid,
                                           in_firma_nr,
                                           null,
                                           v_lam.lam_text,
                                           -1,
                                           False);
        else -- Falls das nicht geht, dann die Quellpalette auf dem Ziel einbuchen
             -- sonst geht das U,packen nicht
          lvs_p_lte.lvs_korr_te_einbuchen (v_lte.sid,
                                           v_lte.firma_nr,
                                           v_lte.lte_id,
                                           v_lte.lte_status,
                                           in_sid,
                                           in_firma_nr,
                                           null,
                                           v_transport.lgr_platz_ziel,
                                           -1,
                                           False);

        end if;
        if lvs_p_base.get_lte(v_lam.res_ziel_lte_id, v_lte_ziel)
        then
          if v_lte_ziel.lgr_platz is null
          then
            lvs_p_lte.lvs_korr_te_einbuchen (v_lte_ziel.sid,
                                             v_lte_ziel.firma_nr,
                                             v_lte_ziel.lte_id,
                                             v_lte_ziel.lte_status,
                                             in_sid,
                                             in_firma_nr,
                                             null,
                                             v_in_lgr_platz,
                                             -1,
                                             False);
          end if;
          lvs_p_lte_lhm.lvs_lhm_umpacken(v_lam.sid,
                                         v_lam.firma_nr,
                                         -1,
                                         v_transport.res_id,
                                         v_lam.lhm_id,
                                         v_lam.res_ziel_lte_id);
          update lvs_lam t
             set t.res_ziel_lte_id = NULL
           where t.lam_id = v_lam.lam_id;
          if v_lte_ziel.lte_akt_lhm + 1 < lvs_komm.get_packschema_max_lfdn(v_lte_ziel.sid,
                                                                            v_lte_ziel.firma_nr,
                                                                            v_lte_ziel.packschema_kopf_id)
          then
            update lvs_lte t
               set t.lte_status = c.LTE_BS_STAT
             where t.lte_id = v_lte_ziel.lte_id;
          else
            update lvs_lte t
               set t.lte_status = c.LTE_BF_STAT
             where t.lte_id = v_lte_ziel.lte_id;
          end if;

          v_ret_value := lvs_transp_loeschen (v_lam.sid,
                                              v_lam.firma_nr,
                                              -1,
                                              v_transport.transp_id,
                                              c.C_TRUE);

          lvs_p_lte.lvs_korr_te_ausbuchen(v_lte.sid,
                                           v_lte.firma_nr,
                                           v_lte.lte_id,
                                           v_lte.lte_status,
                                           in_sid,
                                           in_firma_nr,
                                           null,
                                           v_lte.lgr_platz,
                                           -1);
          lvs_p_lte.lvs_lte_delete(v_lte.sid,
                                   v_lte.lte_id,
                                   -1,
                                   v_lte.lte_status);

        end if;
      end if;
      return(0);
    end if;

    if v_ziel_lgr.lgr_verwendung = c.Lgr_Typ_EP then
      v_neuer_status := c.LTE_ET_STAT;
    end if;

    if v_ziel_lgr.lgr_verwendung = c.Lgr_Typ_WE then
      v_neuer_status := c.LTE_BF_STAT;
    end if;

    if v_ziel_lgr.lgr_verwendung = c.Lgr_Typ_LagerP then
      v_neuer_status := c.LTE_BF_STAT;
    end if;

    if v_lte.ziel_lgr_platz_n_freif is not NULL then

      v_lgr_platz := v_lte.ziel_lgr_platz_n_freif;

      OPEN c_lgr;
      FETCH c_lgr
        into v_ziel_n_frei_lgr;
      v_found := c_lgr%FOUND;
      CLOSE c_lgr;

      if v_found then

        if v_ziel_n_frei_lgr.lgr_verwendung = c.LGR_TYP_WA then
          v_neuer_Status := c.LTE_AD_STAT;
        end if;

        if (v_ziel_lgr.lgr_verwendung = c.LGR_TYP_Lager
        or  v_ziel_lgr.lgr_verwendung = c.LGR_TYP_Puffer)
        and
          (v_ziel_n_frei_lgr.lgr_verwendung = c.Lgr_Typ_Lager
        or  v_ziel_n_frei_lgr.lgr_verwendung = c.LGR_TYP_Puffer
        or  v_ziel_n_frei_lgr.lgr_verwendung = c.LGR_TYP_LagerP)
        then
          v_neuer_Status := c.LTE_UD_STAT;
        end if;

        if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_LagerP and
           v_ziel_n_frei_lgr.lgr_verwendung = c.Lgr_Typ_Lager then
          v_neuer_Status := c.LTE_ED_STAT;
        end if;

        if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_WE and
           v_ziel_n_frei_lgr.lgr_verwendung = c.Lgr_Typ_Lager then
          v_neuer_Status := c.LTE_ED_STAT;
        end if;

      end if;
    end if;

    if v_lte.ziel_lgr_platz_n_freif is not NULL then
      lvs_platz.lvs_platz_ausl_disp_setzen(v_lte, v_ziel_lgr);
    end if;

    if v_ziel_lgr.lgr_typ = c.STAP_FLAE1
    or v_ziel_lgr.lgr_typ = c.STAP_FLAE2
    and in_offset_z is NULL
    then
      v_offset_z := lvs_platz.lvs_get_lgr_offset_z(v_ziel_lgr.lgr_platz) + v_lte.lte_vol_hoehe;
    else
      v_offset_z := in_offset_z;
    end if;

    -- Produktionsnachschub oder Lagernachschub über ISI-Order
    v_order_pos := NULL;
    v_order_pos.auf_id := NULL;
    v_lam_order_sum := 0;
    v_order_status := NULL;

    v_order_pos.auf_id := NULL;
    v_lam_order_sum := 0;
    v_order_status := NULL;

    OPEN c_lam;
    begin
      FETCH c_lam into v_lam;   -- LagerArtikelMaterial Eintrag lesen
      if not isi_p_order_base.get_order_pos(v_lam.sid, v_lam.order_pos_auf_id, v_order_pos)
      then
        v_order_pos.auf_id := NULL;
        v_order_pos := null;
      end if;
      
      -- -AG- 2025.10.2025 - Behebung der Fehlersituation bei KOMM-Auftragägen mit Status FB und ohne Transport
      -- W24010-99 - Lieferauftragspositionen bleiben auf Status "Vorbereitet"
      -- Der Fehler ist entstanden, da eine LTE fertig kommissioniert wurde, aber für einen weiteren KOMM-Auftrag benötigt wird
      -- In diesem Fall war der Komm-Platz der gleiche, wie der auf dem die LTE schon steht. Ein Transport von nach dem gleichen Platz ist nicht möglich. 
      -- Die Servicelogik hat die KOMM-Order bearbeitet und auf FB gesetzt, jedoch nicht abgefangen das der Transport nicht generiert wurde.
      -- Diese Änderung ist eingebaut worden, damit diese Fehlersituationen grundsätzlich abgefangen werden
      if  v_lam.order_pos_auf_id is not NULL -- LTE hat eine Reservierung
      and v_transport.transp_typ = 'E'       -- Einlagerung
      then                                   -- LTE wurde fälschlicherweise eingelagert, soll aber an einen Komm-Platz
        update isi_komm_order t
           set t.status = 'N'                -- KOMM-Order wieder auf 'N', damit der Transport generiert wird
         where t.lte_id = v_lam.lte_id       -- Für die aktuelle LTE-ID
           and t.status = 'FB'               -- Status FB ist falsch, wenn kein Transport angelegt ist
           and t.auf_id = v_lam.order_pos_auf_id
           and t.transport_vor_komm = 'F'; -- Für die KOMM-Order existiert kein Transport.
      end if;

      if (    v_order_pos.auf_id is not NULL
          and v_order_pos.satzart in ('LNK', 'MAK')      -- Nachschub für Produktion oder Lager, dann muss die Reservierung aus dem Ziel genomme
          and c_lam%FOUND
         )
      then
        v_komm_order.transp_id_vor_komm := NULL;
        OPEN c_kom_order_tvk;
        FETCH c_kom_order_tvk into v_komm_order;
        CLOSE c_kom_order_tvk;
        v_order_pos.auf_id := NULL;
        
        if v_komm_order.transp_id_vor_komm is NULL -- Kein Transport zum KOMM-Platz
        then   
          LOOP
            EXIT when c_lam%NOTFOUND; -- Kein Eintrag mehr da

            if  (v_order_pos.satzart = 'MAK'
              or v_order_pos.satzart = 'LNK')
            then
            -- Dierekter Transport
              if  v_transport.lgr_verwendung_quelle in (c.LGR_TYP_Lager, c.LGR_TYP_LAGERP, c.LGR_TYP_Puffer)
              and v_transport.lgr_verwendung_ziel = c.LGR_TYP_WA
              then  -- Dann Menge buchen fuer Produktionsnachschub
                update isi_order_pos pos
                   set pos.ist_menge = pos.ist_menge + (nvl(v_lam.menge, 0)), 
                       pos.brutto_kg = pos.brutto_kg + (nvl(v_lam.lam_kg, 0)),
                       pos.status = case when (pos.ist_menge + (nvl(v_lam.menge, 0)) >= pos.soll_menge)
                                    then 'X'
                                    else pos.status
                                    end
                 where pos.auf_id = v_lam.order_pos_auf_id
                   and pos.satzart in ('LNK', 'MAK');
                delete isi_transport tra
                 where tra.sid = in_sid
                   and tra.firma_nr = in_firma_nr
                   and tra.transp_id = in_transport_id;
                --CM 20161004 Nach löschen des Transportes User ID im ISI_Transport_Log nachtragen
                if in_user_id is not NULL then
                   update isi_transport_log tralog
                      set tralog.login_id = in_user_id
                    where tralog.sid = in_sid
                      and tralog.firma_nr = in_firma_nr
                      and tralog.transp_id = in_transport_id
                      and tralog.status = 'D';
                end if;
                isi_p_order.c_check_lief_fuer_lief_ende (in_sid,                  -- in_sid        in isi_sid.sid%type,
                                                        in_firma_nr,             -- in_firma_nr    in isi_firma.firma_nr%type,
                                                        v_order_pos.vorgang_typ, -- in isi_order_pos.vorgang_typ%type,
                                                        v_order_pos.li_nr,       -- in_lief_nr     in isi_order_kopf.li_nr%type,
                                                        -1,                      -- in_user_id     in isi_user.login_id%type,
                                                        v_order_pos.vorgang_id); -- in_tour_nr     in isi_order_kopf.vorgang_id%type
              else
                delete isi_transport tra
                 where tra.sid = in_sid
                   and tra.firma_nr = in_firma_nr
                   and tra.transp_id = in_transport_id;
                --CM 20161004 Nach löschen des Transportes User ID im ISI_Transport_Log nachtragen
                if in_user_id is not NULL then
                   update isi_transport_log tralog
                      set tralog.login_id = in_user_id
                    where tralog.sid = in_sid
                      and tralog.firma_nr = in_firma_nr
                      and tralog.transp_id = in_transport_id
                      and tralog.status = 'D';
                end if;
                isi_p_order.c_check_lief_fuer_lief_ende (in_sid,                  -- in_sid        in isi_sid.sid%type,
                                                        in_firma_nr,             -- in_firma_nr    in isi_firma.firma_nr%type,
                                                        v_order_pos.vorgang_typ, -- in isi_order_pos.vorgang_typ%type,
                                                        v_order_pos.li_nr,       -- in_lief_nr     in isi_order_kopf.li_nr%type,
                                                        -1,                      -- in_user_id     in isi_user.login_id%type,
                                                        v_order_pos.vorgang_id); -- in_tour_nr     in isi_order_kopf.vorgang_id%type
              end if;
            end if;

            -- REs-Rueck je LAM und Order lesen wenn noetig
            if v_order_pos.auf_id != v_lam.order_pos_auf_id
            or v_order_pos.auf_id is NULL
            then
              v_result := lvs_ausl.lvs_lte_res_rueck (v_lte.sid,
                                                      v_lte.firma_nr,
                                                      NULL,
                                                      v_lam.order_pos_auf_id,
                                                      v_lte.lte_id,
                                                      v_lte.order_vorgang_id,
                                                      NULL,
                                                      c.c_true);
              v_order_pos.auf_id := v_lam.order_pos_auf_id; -- Merken fertig
            end if;
            FETCH c_lam into v_lam;   -- LagerArtikelMaterial Eintrag lesen
          end LOOP;
          v_lte.order_auf_id := NULL;
          v_lte.order_vorgang_id := NULL;
        end if;
      end if;
    exception
      when others then
        NULL;    -- Sicherheitshalber kapseln, damit Cursor immer geschlossen wird
    end;
    CLOSE c_lam;

    -- Bei BDE-Aufträgen müssen die Reservierungen storniert werden
    if v_transport.modul_erzeuger = c.LGR_MODUL_BDE
    or (v_transport.transp_typ = 'U' and v_lte.order_vorgang_id = -2) -- VorgID -2 = Konstante für Umlagerauftr
    then
      OPEN c_lam;
      begin
        LOOP
          FETCH c_lam into v_lam;   -- LagerArtikelMaterial Eintrag lesen
          EXIT when c_lam%NOTFOUND; -- Kein Eintrag mehr da
          
          -- -AG- 2016.10.11 Neu, Reservierung nur löschen, wenn nicht PUSH
          v_order_pos.auf_id := null;
          
          if bde_p_base.get_fa_by_auf_id(in_sid,
                                         in_firma_nr,
                                         v_lam.order_pos_auf_id,
                                         v_bde_fa)
          then
            if v_bde_fa.ma_reserviert = c.C_TRUE  -- Reserviert für PUSH
            then
              v_order_pos.auf_id := v_lam.order_pos_auf_id;  -- Reservierung nicht loeschen
            end if;
          end if;
          

          -- REs-Rueck je LAM und Order lesen wenn noetig
          if v_order_pos.auf_id != v_lam.order_pos_auf_id
          or v_order_pos.auf_id is NULL
          then
            v_result := lvs_ausl.lvs_lte_res_rueck (v_lte.sid,
                                                    v_lte.firma_nr,
                                                    NULL,
                                                    v_lam.order_pos_auf_id,
                                                    v_lte.lte_id,
                                                    v_lte.order_vorgang_id,
                                                    NULL,
                                                    c.c_true);
            v_order_pos.auf_id := v_lam.order_pos_auf_id; -- Merken fertig
          end if;
        end LOOP;
        v_lte.order_auf_id := NULL;
        v_lte.order_vorgang_id := NULL;
      exception
        when others then
          NULL;    -- Sicherheitshalber kapseln, damit Cursor immer geschlossen wird
      end;
      CLOSE c_lam;
    end if;
       
    if ((     v_lte.ziel_lgr_platz = v_transport.lgr_platz_ziel
         and  v_lte.ziel_lgr_platz = v_in_lgr_platz)
       or (v_transport.lgr_platz_ziel = v_in_lgr_platz)
       )
    then
      lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_ziel_lgr);
      if v_found_parent = true
      then
        v_lte.transport_gruppe := NULL;
        v_lte.lkw_nr := NULL;
      end if;
      lvs_p_lte.lvs_te_lagerziel_umbuchen_353(v_lte.sid,
                                              v_lte.firma_nr,
                                              v_lte.lte_id,
                                              v_ziel_lgr.lgr_platz,
                                              v_ziel_lgr.lgr_ort,
                                              v_ziel_lgr.lgr_platz_gruppe,
                                              v_lte.ziel_lgr_platz_n_freif,
                                              v_lte.ziel_lgr_ort_n_freif,
                                              v_neuer_status,
                                              v_lte.lte_status,
                                              null,
                                              null,
                                              systimestamp,
                                              v_lte.order_auf_id,
                                              v_lte.order_vorgang_id,
                                              NULL,
                                              v_lte.transport_gruppe,
                                              v_lte.lkw_nr,
                                              in_offset_x,
                                              in_offset_y,
                                              in_offset_z);
      lvs_platz.lvs_platz_einl_buchen(v_lte, v_ziel_lgr);
    else
      v_lgr_platz := v_lte.ziel_lgr_platz;
      OPEN c_lgr;
      FETCH c_lgr
        into v_lgr_lte;
      v_found := c_lgr%FOUND;
      CLOSE c_lgr;

      if (   nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.SAT1
          or nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.SEG1
          or nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.SEG_DUEDO1
          or nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.SAT_EPL1
          or nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.SAT_EPL2
          or nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.KANAL1
          or nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.KANAL_BKL1
          or nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.REG_FACH1
          or nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.STAP_FLAE1
          or nvl(v_ziel_lgr.lgr_typ, 'NULL') = c.STAP_FLAE2
         )
         and nvl(v_ziel_lgr.res_string, 'null') != nvl(v_lte.res_string, nvl(v_ziel_lgr.res_string, 'null'))
         and v_ziel_lgr.res_string is not NULL
         and v_lgr_lte.lgr_platz_gruppe != v_ziel_lgr.lgr_platz_gruppe
      then
        v_ret_value := c.LGR_RES_STRING;
      else
        -- ist noch Platz auf diesem Lagerplatz
        if  v_ziel_lgr.lgr_akt_te + 1 <= v_ziel_lgr.lgr_max_te
        and nvl(v_ziel_lgr.lgr_akt_kg + v_lte.lte_akt_kg, 0) <=
            nvl(v_ziel_lgr.lgr_max_kg, 99000)
        or v_ziel_lgr.lgr_max_te = 0 -- Keine Begrenzung
        then
          -- Erst mal gepl. Lagerplatz (ZIEL) der Palette lesen

          if v_ziel_lgr.lgr_akt_te + v_ziel_lgr.lgr_dispo_einl_te < v_ziel_lgr.lgr_max_te
          or v_ziel_lgr.lgr_max_te = 0 -- Keine Begrenzung
          then
            if v_found then
              lvs_platz.lvs_platz_einl_disp_ruecks(v_lte, v_lgr_lte);
            end if;
            v_lte.ziel_lgr_ort   := NULL;
            v_lte.ziel_lgr_platz := NULL;
            lvs_platz.lvs_platz_einl_buchen(v_lte, v_ziel_lgr);
            -- -AG- 24.11.2010 Dispo setzen für kanal-Kontrolle
            lvs_platz.lvs_platz_einl_disp_setzen(v_lte, v_ziel_lgr);
            -- -AG- 24.11.2010 Beim Einbuchen den Res_string korrekt setzen
            lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_ziel_lgr);
            -- -AG- 24.11.2010 Dispo Ruecksetzen nach kanal-Kontrolle
            lvs_platz.lvs_platz_einl_disp_ruecks(v_lte, v_ziel_lgr);
            if v_found_parent = true
            then
              v_lte.transport_gruppe := NULL;
              v_lte.lkw_nr := NULL;
            end if;
            lvs_p_lte.lvs_te_lagerziel_umbuchen_353(v_lte.sid,
                                                    v_lte.firma_nr,
                                                    v_lte.lte_id,
                                                    v_ziel_lgr.lgr_platz,
                                                    v_ziel_lgr.lgr_ort,
                                                    v_ziel_lgr.lgr_platz_gruppe,
                                                    v_lte.ziel_lgr_platz_n_freif,
                                                    v_lte.ziel_lgr_ort_n_freif,
                                                    v_neuer_status,
                                                    v_lte.lte_status,
                                                    null,
                                                    null,
                                                    systimestamp,
                                                    v_lte.order_auf_id,
                                                    v_lte.order_vorgang_id,
                                                    NULL,
                                                    v_lte.transport_gruppe,
                                                    v_lte.lkw_nr,
                                                    in_offset_x,
                                                    in_offset_y,
                                                    in_offset_z);
            -- Lagerplatz tauschen nur bei Kanaelen oder SAT-Lagern
          elsif (v_ziel_lgr.lgr_typ = c.SAT1)
             or (v_ziel_lgr.lgr_typ = c.KANAL1)
             or (v_ziel_lgr.lgr_typ = c.SEG1)
             or (v_ziel_lgr.lgr_typ = c.SEG_DUEDO1)
          then
            -- Tauschen auch nur inerhalb einer Gruppe moeglich
            if v_found and
               v_lgr_lte.lgr_platz_gruppe = v_ziel_lgr.lgr_platz_gruppe then

              -- Update des Transportauftrags der urspruenglich auf diesen Platz sollte
              OPEN c_transport_ziel;
              FETCH c_transport_ziel
                into v_trans_lte; -- Lesen des Transportauftrags
              v_found := c_transport_ziel%FOUND;
              CLOSE c_transport_ziel;

              if v_found then
                update isi_transport tr
                   set tr.lgr_platz_ziel = v_lte.ziel_lgr_platz,
                       tr.lgr_ort_ziel   = v_lte.ziel_lgr_ort
                 where tr.transp_id = v_trans_lte.transp_id
                   and tr.sid = in_sid
                   and tr.firma_nr = in_firma_nr;
              end if;

              -- Update der LTE, die auf diesen Platz sollte
              OPEN c_lte_ziel;
              FETCH c_lte_ziel
                into v_lte_ziel; -- Lesen der Transporteinheit
              v_found := c_lte_ziel%FOUND;
              CLOSE c_lte_ziel;

              -- der Zielplatz ist mit einer anderen (urspuenglichen LTE) disponiert worden
              -- darum die Dispo erst mal ruecksetzen
              lvs_platz.lvs_platz_einl_disp_ruecks(v_lte_ziel, v_ziel_lgr);
              -- Nach dem Buchen in der Tabelle auch die Werte hier korrigieren
              -- AG 28.09.2004
              v_ziel_lgr.lgr_dispo_einl_te := v_ziel_lgr.lgr_dispo_einl_te - 1;
              if v_ziel_lgr.lgr_dispo_einl_te < 0 then
                v_ziel_lgr.lgr_dispo_einl_te := 0;
              end if;

              if v_ziel_lgr.lgr_typ = c.REG_FACH1
              or v_ziel_lgr.lgr_typ = c.STAP_FLAE1
              or v_ziel_lgr.lgr_typ = c.STAP_FLAE2
              then
                v_ziel_lgr.lgr_dispo_einl_frei_hoehe := nvl(v_ziel_lgr.lgr_dispo_einl_frei_hoehe, v_lte_ziel.lte_vol_hoehe) - v_lte_ziel.lte_vol_hoehe;
                if v_ziel_lgr.lgr_dispo_einl_frei_hoehe < 0 then
                  v_ziel_lgr.lgr_dispo_einl_frei_hoehe := 0;
                end if;
              end if;

              v_ziel_lgr.lgr_dispo_einl_kg := v_ziel_lgr.lgr_dispo_einl_kg -
                                              v_lte_ziel.LTE_akt_kg;
              if v_ziel_lgr.lgr_dispo_einl_kg < 0 then
                v_ziel_lgr.lgr_dispo_einl_kg := 0;
              end if;
              -- AG 28.09.2004

              -- den Lagerplatz auf den die zu buchende Palette sollte, muss die  DISPO
              -- zuruecksetzt werden, damit dieser dann mit der Palette die auf diesem
              -- Platz sollte, disponiert werden kann
              lvs_platz.lvs_platz_einl_disp_ruecks(v_lte, v_lgr_lte);
              -- Nach dem Buchen in der Tabelle auch die Werte hier korrigieren
              -- AG 28.09.2004
              v_lgr_lte.lgr_dispo_einl_te := v_lgr_lte.lgr_dispo_einl_te - 1;
              if v_lgr_lte.lgr_dispo_einl_te < 0 then
                v_lgr_lte.lgr_dispo_einl_te := 0;
              end if;

              if v_lgr_lte.lgr_typ = c.REG_FACH1
              or v_ziel_lgr.lgr_typ = c.STAP_FLAE1
              or v_ziel_lgr.lgr_typ = c.STAP_FLAE2
              then
                v_lgr_lte.lgr_dispo_einl_frei_hoehe := nvl(v_lgr_lte.lgr_dispo_einl_frei_hoehe, v_lte.lte_vol_hoehe) - v_lte.lte_vol_hoehe;
                if v_lgr_lte.lgr_dispo_einl_frei_hoehe < 0 then
                  v_lgr_lte.lgr_dispo_einl_frei_hoehe := 0;
                end if;
              end if;

              v_lgr_lte.lgr_dispo_einl_kg := v_lgr_lte.lgr_dispo_einl_kg -
                                             v_lte.LTE_akt_kg;
              if v_lgr_lte.lgr_dispo_einl_kg < 0 then
                v_lgr_lte.lgr_dispo_einl_kg := 0;
              end if;
              -- AG 28.09.2004

              if v_found then
                -- Update dieser LTE auf neuen Platz
                update lvs_lte lte
                   set lte.ziel_lgr_platz = v_lte.ziel_lgr_platz,
                       lte.ziel_lgr_ort   = v_lte.ziel_lgr_ort
                 where lte.lte_id = v_lte_ziel.lte_id
                   and lte.sid = in_sid
                   and lte.firma_nr = in_firma_nr;
                -- Update dieser LTE auf neuen Platz
                lvs_platz.lvs_platz_einl_disp_setzen(v_lte_ziel, v_lgr_lte);
              end if;
              v_lte.ziel_lgr_ort   := NULL;
              v_lte.ziel_lgr_platz := NULL;
              lvs_platz.lvs_platz_einl_buchen(v_lte, v_ziel_lgr);
              lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_ziel_lgr);
              if v_found_parent = true
              then
                v_lte.transport_gruppe := NULL;
                v_lte.lkw_nr := NULL;
              end if;
              lvs_p_lte.lvs_te_lagerziel_umbuchen_353(v_lte.sid,
                                                      v_lte.firma_nr,
                                                      v_lte.lte_id,
                                                      v_ziel_lgr.lgr_platz,
                                                      v_ziel_lgr.lgr_ort,
                                                      v_ziel_lgr.lgr_platz_gruppe,
                                                      v_lte.ziel_lgr_platz_n_freif,
                                                      v_lte.ziel_lgr_ort_n_freif,
                                                      v_neuer_status,
                                                      v_lte.lte_status,
                                                      null,
                                                      null,
                                                      systimestamp,
                                                      v_lte.order_auf_id,
                                                      v_lte.order_vorgang_id,
                                                      NULL,
                                                      v_lte.transport_gruppe,
                                                      v_lte.lkw_nr,
                                                      in_offset_x,
                                                      in_offset_y,
                                                      in_offset_z);
            else
              v_ret_value := c.LGR_Z_FEHLT;
            end if;
          else
            v_ret_value := c.LGR_VOLL;
          end if;
        else
          v_ret_value := c.LGR_VOLL;
        end if;
      end if;
    end if;

    if v_ret_value = 0 
    then
      -- -AG- Hier wird der Transport temp. auf fertig 'E'nde gesetzt. Benötigt für DISPO-Prüfung in lvs_platz.LVS_PLATZ_EINL_BUCHEN
      -- CMe 20210527 Status 'E' darf erst gesetzt werden, wenn das Return Value = 0 ist. Ansonsten liegt ein Fehler vor
      -- Ticket: E70397-632
      update isi_transport t
         set t.status = 'E'
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.transp_id = in_transport_id;
      if v_vorg_id is null then
        if v_transport.lam_bh_vorgang_id is null then
          v_err_nr   := 10;
          v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
          select seq_vorg_id.nextval into v_vorg_id from dual;
          v_err_nr := NULL;
        else
          v_vorg_id := v_transport.lam_bh_vorgang_id;
        end if;
      end if;
      v_err_nr := NULL;
      v_err_text := NULL;

      v_lhm_id := NULL;
      
      -- -AG- fehler Mischpaletten
      -- INIT
      v_order_pos.auf_id := NULL;
      v_lam_order_sum := 0;
      v_order_status := NULL;

      OPEN c_lam;
      LOOP
        FETCH c_lam into v_lam;   -- LagerArtikelMaterial Eintrag lesen
        EXIT when c_lam%NOTFOUND; -- Kein Eintrag mehr da

        -- Order Lesen je LAM wenn nötig
        if v_order_pos.auf_id != v_lam.order_pos_auf_id
        or v_order_pos.auf_id is NULL
        then
          OPEN c_order_pos;
          FETCH c_order_pos into v_order_pos; -- Lesen der ISI_ORDER
          if c_order_pos%NOTFOUND
          then
            v_order_pos.vorgang_id := NULL;
            v_order_pos.li_nr := NULL;
            v_order_pos.li_pos_nr := NULL;
            v_order_pos := NULL;
          end if;
          CLOSE c_order_pos;

          OPEN c_lam_order_sum;
          FETCH c_lam_order_sum into v_lam_order_sum; -- Lesen der Reservierten Menge aus LAM
          CLOSE c_lam_order_sum;
        end if;

        if lvs_p_base.get_lhm(v_lam.lhm_id, v_lhm)
        then
          if v_lhm.komm_quell_lte_id is not null
          then
            if lvs_p_base.get_lte(v_lhm.komm_quell_lte_id, v_komm_q_lte)
            then
              if v_komm_q_lte.lte_status = c.LTE_LF_STAT
                 and v_komm_q_lte.order_auf_id = v_lam.order_pos_auf_id
              then
                v_result := lvs_ausl.lvs_lte_res_rueck(v_komm_q_lte.sid, v_komm_q_lte.firma_nr,
                                                       null, null, v_komm_q_lte.lte_id, v_komm_q_lte.order_vorgang_id,
                                                       v_komm_q_lte.lgr_platz, 'T');
              end if;
            end if;
          end if;
        end if;

        if v_ziel_lgr.lgr_verwendung = c.WA  -- (Jeder WA ist Gut)
        -- -AG- Nur OK, wenn der WA kein WA_TYP 'LDPR'
        and nvl(v_ziel_lgr.wa_typ, 'x') != 'LDPR'
        then
        -- if v_ziel_lgr.lgr_platz = v_order_pos.ziel then
          if v_order_pos.menge_basis = c.BASIS_LTE
          then
            v_order_pos.ist_menge := v_order_pos.ist_menge + 1;
          else
            v_order_pos.ist_menge := v_order_pos.ist_menge + v_lam.menge;
          end if;
          if v_lte.waren_typ = c.MISCHPAL then
            v_order_pos.brutto_kg := nvl(v_order_pos.brutto_kg, 0) + v_lam.lam_kg;
          end if;
        end if;

        v_lam_order_sum := v_lam_order_sum - v_lam.menge;   -- aktuelle Menge von der Reservierten abziehen
        if v_order_pos.ist_menge >= v_order_pos.soll_menge  -- Istmenge hat Sollmende erreicht
        and nvl(v_lam_order_sum, 0) <= 0                    -- Und es ist keine weitere menge reserviert
        then
          v_order_status := 'L';
        end if;

        begin
          v_lam_kg := v_lam.lam_kg / v_lam.menge;
        exception
          when others then
            v_lam_kg := 0;
        end;

        v_err_nr   := 20;
        v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
        select seq_lam_bh.nextval into v_lam_bh_id from dual;
        v_err_nr := NULL;
        v_err_text := NULL;

        -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
        insert into lvs_lam_bh
        values
          (v_lte.sid,
           v_lte.firma_nr,
           v_vorg_id,
           v_vorg_typ,
           v_lam_bh_id,
           v_lam.lam_id,
           v_lam.artikel_id,
           C.LAM_BH_BUS_UML,
           v_buch_date,
           in_user_id,
           v_ziel_lgr.lgr_platz,
           in_lte_id,
           v_lam.lhm_id,
           v_lam.charge_id,
           v_lam.serie_id,
           v_order_pos.auftrag,
           v_lam.menge,
           v_lam.lam_kg,
           v_lam_kg,
           in_res_id,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           sysdate,                     -- CREATED_DATE	N	DATE	Y			creation date+time of this dataset
           in_user_id,                  -- CREATED_LOGIN_ID	N	NUMBER	Y			login id of the user creating this dataset
           sysdate,                     -- LAST_CHANGE_DATE	N	DATE	Y			change date+time of this dataset
           in_user_id,                  -- LAST_CHANGE_LOGIN_ID	N	NUMBER	Y			login id of the user changing this dataset
           null,                        -- CHANGE_MENGE	N	NUMBER	Y			Menge die geändert wurde
           v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
           null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

        s_schnittstelle.write_host_bew(NULL,
                                       v_lam,
                                       v_lam_bh_id,
                                       C.LAM_BH_BUS_UML,
                                       v_vorg_typ,
                                       NULL,
                                       'UE',
                                       v_quell_lgr,
                                       v_ziel_lgr,
                                       in_user_id);
        if v_ziel_lgr.lgr_verwendung = c.WA  -- (Jeder WA ist Gut)
        --if v_ziel_lgr.lgr_platz = v_order_pos.ziel
        or v_order_pos.ziel is NULL 
        then
          v_komm_order.transp_id_vor_komm := NULL;
          OPEN c_kom_order_tvk;
          FETCH c_kom_order_tvk into v_komm_order;
          CLOSE c_kom_order_tvk;
          
          if v_komm_order.transp_id_vor_komm is NULL -- Kein Transport zum KOMM-Platz
          then   
        
            -- Wenn keine Mischpalette kann des Restgewicht auf die Position gebucht werden
            if v_lte.waren_typ != c.MISCHPAL then
              v_order_pos.brutto_kg := nvl(v_order_pos.brutto_kg, 0) + v_lte_kg;
              v_lte_kg := 0;
            end if;
            if v_vorg_typ = c.LAM_BH_ABGAGNG 
            then
              update isi_order_pos pos
                 set pos.ist_menge = v_order_pos.ist_menge,
                     pos.brutto_kg = v_order_pos.brutto_kg
               where pos.sid = in_sid
                 and pos.auf_id = v_lam.order_pos_auf_id;
            end if;
            -- Wenn Auftrag vom HOST dann melden
            if v_order_pos.ist_menge >= v_order_pos.soll_menge  -- Istmenge hat Sollmende erreicht
            then
              v_order_status := 'L';
            end if;
            if v_order_pos.besteller = 'HOST' 
            then
              if v_order_pos.vorgang_typ = 'WAE' 
              and v_vorg_typ = c.LAM_BH_ABGAGNG 
              then
                s_schnittstelle.write_host_bew(v_order_pos,
                                               v_lam,
                                               NULL,
                                               C.LAM_BH_BUS_ABG,
                                               C.LAM_BH_ABGAGNG,
                                               'S_AUF',
                                               NULL,
                                               v_quell_lgr,
                                               v_ziel_lgr,
                                               in_user_id);
              end if;
            end if;
            v_err_nr   := NULL;
            v_err_text := NULL;
            if v_transport.li_pos_nr is null and
               v_transport.lieferschein = c.C_TRUE
            then
              OPEN c_liefers;
              FETCH c_liefers
                into v_liefs;
              v_found := c_liefers%FOUND;
              CLOSE c_liefers;
              if v_found then
                v_transport.li_pos_nr := v_liefs.li_pos_nr;
              end if;
            end if;
            if v_lam.lhm_id is NULL then
              v_lam.lhm_id := v_lam.lam_id;
            end if;
            -- -WK- 20090409: doppelte Einträge in isi_liefs bei staffeltransporten
            -- -AG- Hier darf nur geschrieben werden, wenn der WA kein WA_TYP 'LDPR'
            if nvl(v_ziel_lgr.wa_typ, 'x') = 'LDPO'
            then
              v_ausgelagert := c.C_TRUE;
            end if;

            if v_transport.lieferschein = c.C_TRUE
            and nvl(v_ziel_lgr.wa_typ, 'x') != 'LDPR'
            then
              lvs_ausl.lvs_liefers_erzeuge_daten(v_transport,
                                                 v_lam,
                                                 v_order_pos,
                                                 v_lam_bh_id,
                                                 v_lte,
                                                 v_lhm_id);
              if v_lhm_id is null then
                v_lhm_id := v_lam.lhm_id;
              end if;
            end if;
          end if;
        else
          if v_order_pos.status != 'R'
          and v_order_status is NULL
          then
            v_order_status := 'D';
          end if;
        end if;

      end LOOP;
      CLOSE c_lam;

      update isi_transport t
         set t.status = c.TRANS_FREI
       where t.parent_transp_id = in_transport_id;
      delete isi_transport tra
       where tra.sid = in_sid
         and tra.firma_nr = in_firma_nr
         and tra.transp_id = in_transport_id;

      --CM 20161004 Nach löschen des Transportes User ID im ISI_Transport_Log nachtragen
      if in_user_id is not NULL then
         update isi_transport_log tralog
            set tralog.login_id = in_user_id
          where tralog.sid = in_sid
            and tralog.firma_nr = in_firma_nr
            and tralog.transp_id = in_transport_id
            and tralog.status = 'D';
      end if;
      if v_transport.vorgang_id is not NULL
      then
        OPEN c_trans_order_gesperrt;
        FETCH c_trans_order_gesperrt into v_trans_anz, v_trans_grp;
        CLOSE c_trans_order_gesperrt;

        if v_trans_anz > 0
        and v_trans_grp > 0          -- -AG- 2016.11.29 Nur wenn eine Transportgruppe gesetzt, dann die gesperten der nächsten Gruppe in diesem Vorgang_id freigeben
        then
          OPEN c_trans_order_frei;
          FETCH c_trans_order_frei into v_trans_anz;
          CLOSE c_trans_order_frei;
          if v_trans_anz = 0
          then
            update isi_transport tr
               set tr.status = c.TRANS_FREI
             where tr.vorgang_id = v_transport.vorgang_id
               and tr.status = c.TRANS_GESPERRT
               and tr.transport_gruppe = v_trans_grp
               and tr.sid = in_sid
               and tr.firma_nr = in_firma_nr;

          end if;
        end if;
      end if;

      if v_lte.ziel_lgr_platz_n_freif is not NULL then
        update isi_transport tra
           set tra.lgr_platz_quelle = v_ziel_lgr.lgr_platz,
               tra.lgr_ort_quelle   = v_ziel_lgr.lgr_ort
         where tra.sid = in_sid
           and tra.firma_nr = in_firma_nr
           -- Fehler bei Halbaufträgen LTE dann nicht mehr auf einem Lagerplatz
           -- jedoch müssen ab jetzt alle Transportaufträge dieser palette auf
           -- den neuen Platz als quelle verweisen!!!!
           --and tra.lgr_platz_quelle = v_lte.lgr_platz
           --and tra.lgr_ort_quelle = v_lte.lgr_ort
           and tra.lte_id = v_lte.lte_id;
      end if;

      if v_ziel_lgr.wa_typ = 'LDPO'
      then
        v_ausgelagert := c.C_TRUE;
      end if;
      if (v_ausgelagert = c.C_TRUE
          or (v_transport.modul_bearbeiter = c.LGR_MODUL_MFR
              and c.MFR_AUUL_KOMPL = c.C_TRUE)
         )
      and v_ziel_lgr.lgr_verwendung = c.LGR_TYP_WA
      and nvl(v_ziel_lgr.wa_typ, 'x') != 'LDPR'
      then
        v_lam.artikel_id := null;
        if v_transport.modul_bearbeiter != c.LGR_MODUL_MFR
        and not (v_order_pos.vorgang_typ = 'WAI' and v_order_pos.satzart = 'MA')
        then
          isi_p_order.pruefe_lte_kompl_in_order(v_lte.sid,
                                                v_lte.firma_nr,
                                                v_order_pos.vorgang_id,
                                                v_lte.lte_id);
        end if;

        SAVEPOINT kein_abgang;
        v_lam.lam_id     := lvs_ausl.lvs_lam_abgang(v_lte.sid,
                                                    v_lte.firma_nr,
                                                    v_lam.artikel_id,
                                                    v_lte.lte_id,
                                                    NULL,
                                                    v_order_pos.auftrag,
                                                    in_res_id,
                                                    v_buch_date,
                                                    in_user_id,
                                                    v_vorg_id,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    c.LAM_BH_BUS_ABG,
                                                    v_order_pos.vorgang_id,
                                                    v_order_pos.li_nr,
                                                    v_order_pos.li_pos_nr);
        if v_lam.lam_id < 0           -- Fehler (Gesperrte Ware auf der Palette)
        then
          if (v_transport.modul_bearbeiter != c.LGR_MODUL_MFR
          and v_transport.lgr_verwendung_ziel != c.LGR_TYP_WA
          and c.MFR_AUUL_KOMPL != c.C_TRUE)
          then
            ROLLBACK TO SAVEPOINT kein_abgang;
            if v_transport.modul_bearbeiter != c.LGR_MODUL_MFR
            then
              v_err_nr := 30;
              v_err_text := LC.ec(LC.O_TXT_LTE_M_GESP_WARE);
              raise v_error;
            end if;
          end if;
        end if;

      end if;

      if v_order_status = 'L' then
        if v_order_pos.besteller = 'ISI' then
          update isi_order_pos pos
             set pos.status = 'E',
                 pos.fertig_datum = sysdate
           where pos.sid = in_sid
             and pos.firma_nr = v_order_pos.firma_nr
             and pos.vorgang_id = v_order_pos.vorgang_id
             and pos.vorgang_typ = v_order_pos.vorgang_typ
             and pos.soll_menge <= pos.ist_menge;
          OPEN c_pos_anz; -- Artikeldaten lesen
          FETCH c_pos_anz
            into v_anz_pos;
          v_found := c_pos_anz%FOUND; -- Artikeldaten gefunden ?
          CLOSE c_pos_anz;

          if not v_found
          or v_anz_pos = 0
          then
            update isi_order_kopf kopf
               set kopf.status = 'E',
                   kopf.fertig_datum = sysdate
             where kopf.sid = in_sid
               and kopf.vorgang_typ = v_order_pos.vorgang_typ
               and kopf.vorgang_id = v_order_pos.vorgang_id
               and kopf.status != 'E';
          end if;
        else

          if v_order_status = 'L' then
            OPEN c_lte_ausl;
            FETCH c_lte_ausl
              into v_lte;
            v_found := c_lte_ausl%FOUND;
            CLOSE c_lte_ausl;
            v_order_status := 'X';
            /* -AG- Bei Externen Order pos immer erst durch Bestätigung in der ISI-Order
            if not v_found then
              -- Die Felder für das Schnittstelleschreiben verbiegen
              v_order_pos.status      := 'E';
              if v_order_pos.li_extern = 'B'
              then
                v_order_pos.vorgang_typ := 'BLF';
              else
                v_order_pos.vorgang_typ := 'LIF';
              end if;
              v_lam.lte_id            := NULL;
              v_lam.artikel_id        := NULL;
              v_lam.charge_id         := NULL;
              v_lam.firma_nr          := in_firma_nr;
              v_lam.sid               := in_sid;

              s_schnittstelle.write_host_bew(v_order_pos, -- in_order_pos   in isi_order_pos%rowtype,
                                             v_lam, -- in_lam         in lvs_lam%rowtype,
                                             NULL, -- in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                                             NULL, -- in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                             NULL, -- in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                                             'S_AUF', -- in_tabelle     in varchar2,
                                             'UE', -- in_status      in s_send_bew.status%type,
                                             NULL, -- in_quell_lgr   in lvs_lgr%rowtype,
                                             NULL, -- in_ziel_lgr    in lvs_lgr%rowtype,
                                             NULL,                   -- in_login_id    in isi_user.login_id%type,
                                             v_order_pos.ist_menge); -- in_menge       in number default NULL
            else
              v_order_pos.status := 'X';
            end if;
            */
            update isi_order_pos pos
               set pos.status = v_order_status,
                   pos.fertig_datum = sysdate
             where pos.sid = in_sid
               and pos.firma_nr = v_order_pos.firma_nr
               and pos.vorgang_id = v_order_pos.vorgang_id
               and pos.vorgang_typ = v_order_pos.vorgang_typ
               and pos.soll_menge <= pos.ist_menge;

            isi_p_order.c_check_lief_fuer_lief_ende (in_sid,                  -- in_sid        in isi_sid.sid%type,
                                                    in_firma_nr,             -- in_firma_nr    in isi_firma.firma_nr%type,
                                                    v_order_pos.vorgang_typ, -- in isi_order_pos.vorgang_typ%type,
                                                    v_order_pos.li_nr,       -- in_lief_nr     in isi_order_kopf.li_nr%type,
                                                    -1,                      -- in_user_id     in isi_user.login_id%type,
                                                    v_order_pos.vorgang_id); -- in_tour_nr     in isi_order_kopf.vorgang_id%type
          else
            v_order_status := v_order_pos.status;
            update isi_order_pos pos
               set pos.status = v_order_status
             where pos.sid = in_sid
               and pos.auf_id = v_lam.order_pos_auf_id;
          end if;
        end if;
      elsif v_order_status = 'R'
      then
        OPEN c_transport_order_anz;
        FETCH c_transport_order_anz
          into v_trans_anz; -- Lesen des Transportauftrags
        CLOSE c_transport_order_anz;
        if nvl(v_trans_anz, 0) = 0
        then
          update isi_order_kopf kopf
             set kopf.status = 'V'
           where kopf.sid = in_sid
             and kopf.firma_nr = v_order_pos.firma_nr
             and kopf.vorgang_typ = v_order_pos.vorgang_typ
             and kopf.satzart = v_order_pos.satzart
             and kopf.status != 'E'
             and kopf.vorgang_id = v_order_pos.vorgang_id;
          update isi_order_pos pos
             set pos.status = 'V'
           where pos.sid = in_sid
             and pos.firma_nr = v_order_pos.firma_nr
             and pos.vorgang_typ = v_order_pos.vorgang_typ
             and pos.satzart = v_order_pos.satzart
             and pos.vorgang_id = v_order_pos.vorgang_id;

        end if;
      end if;
      -- AG 07.09.2015 Wenn Transport fertig wird, dann soll dies in der ISI-Komm-Order
      -- als  KE=Komm-Fertig eingetragen werden
      update isi_komm_order t
         set t.ts = sysdate,
             t.transport_nach_komm = c.C_TRUE,
             t.status = 'KE'
       where t.transp_id_nach_komm = in_transport_id
         and t.status in ('TNK')                                      -- TNK = Transport nach KOMM
         and t.komm_typ in ('KE', 'MV', 'UP', 'W', 'D', 'ZE', 'UPA'); -- UP=Umpacken, W=Palettenwechsler, D=reines doppeln, ZE=Zusatzetikett (z.B. Routinglabel), UPA=Artikelreines Umpacken
    else
      update isi_transport t      -- -AG- 2019.01.28 Transport Fertig hat nicht geklapt, dann wieder auf un Transport wegen TEM Status 'E'nde
         set t.status = c.TRANS_TRANSPORT
       where t.parent_transp_id = in_transport_id;
    end if;

    return(v_ret_value);

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
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
  END lvs_transp_fertig_buchen;

  FUNCTION lvs_transp_fertig_353(in_sid          in isi_sid.sid%type,
                                 in_firma_nr     IN isi_firma.firma_nr%TYPE,
                                 in_user_id      IN isi_user.login_id%TYPE,
                                 in_transport_id IN isi_transport.transp_id%TYPE,
                                 in_lte_id       in lvs_lte.lte_id%type,
                                 in_res_id       in isi_resource.res_id%type,
                                 in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                 in_ausgelagert  in varchar2,
                                 in_offset_x     in lvs_lte.lte_offset_x%type,
                                 in_offset_y     in lvs_lte.lte_offset_y%type,
                                 in_offset_z     in lvs_lte.lte_offset_z%type) RETURN INTEGER is
    v_error          EXCEPTION;
    v_err_nr         number;
    v_err_text       varchar2(2550);
    v_transp_grp     isi_transport_grp%rowtype;
    v_transp_grp_id  isi_transport_grp.lte_grp_id%type;
    v_ret_value           INTEGER; -- return value
    
    CURSOR c_transp_grp is
      select *
        from isi_transport_grp t
       where t.lte_grp_id = v_transp_grp_id
      order by t.lte_pos_grp;
  begin
    if not lvs_p_base.get_transp_grp_by_lte_id(in_sid,
                                               in_lte_id,
                                               v_transp_grp)
    then
                                              
      v_ret_value := lvs_transp_fertig_buchen (in_sid,          -- in isi_sid.sid%type,
                                               in_firma_nr,     -- IN isi_firma.firma_nr%TYPE,
                                               in_user_id,      -- IN isi_user.login_id%TYPE,
                                               in_transport_id, -- IN isi_transport.transp_id%TYPE,
                                               in_lte_id,       -- in lvs_lte.lte_id%type,
                                               in_res_id,       -- in isi_resource.res_id%type,
                                               in_lgr_platz,    -- in lvs_lgr.lgr_platz%type,
                                               in_ausgelagert,  -- in varchar2,
                                               in_offset_x,     -- in lvs_lte.lte_offset_x%type,
                                               in_offset_y,     -- in lvs_lte.lte_offset_y%type,
                                               in_offset_z);    -- in lvs_lte.lte_offset_z%type)    
    else
      v_transp_grp_id := v_transp_grp.lte_grp_id;
      OPEN c_transp_grp;
      LOOP
        FETCH c_transp_grp into v_transp_grp;
        EXIT when c_transp_grp%NOTFOUND;
        v_ret_value := lvs_transp_fertig_buchen (in_sid,                 -- in isi_sid.sid%type,
                                                 in_firma_nr,            -- IN isi_firma.firma_nr%TYPE,
                                                 in_user_id,             -- IN isi_user.login_id%TYPE,
                                                 v_transp_grp.transp_id, -- IN isi_transport.transp_id%TYPE,
                                                 v_transp_grp.lte_id,    -- in lvs_lte.lte_id%type,
                                                 in_res_id,              -- in isi_resource.res_id%type,
                                                 in_lgr_platz,           -- in lvs_lgr.lgr_platz%type,
                                                 in_ausgelagert,         -- in varchar2,
                                                 in_offset_x,            -- in lvs_lte.lte_offset_x%type,
                                                 in_offset_y,            -- in lvs_lte.lte_offset_y%type,
                                                 in_offset_z);           -- in lvs_lte.lte_offset_z%type)    
      end LOOP;
      CLOSE c_transp_grp;
      delete isi_transport_grp t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_grp_id = v_transp_grp_id;
    end if;

    return(v_ret_value);

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_transp_grp%ISOPEN
      then
        CLOSE c_transp_grp;
      end if;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_transp_grp%ISOPEN
      then
        CLOSE c_transp_grp;
      end if;
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
  -- function lvs_transp_check_zugriff
  -- return value:
  --  =  1 Freifahrtauftrag wird erzeugten
  --  =  0 Kein Freiauftrag erzeugt auf LTE kann direkt zugegriffen werden
  --  = -1 LTE im Weg freifahren nicht erlaubt
  --------------------------------------------------------------------------------
  function lvs_transp_check_zugriff(in_sid              in isi_sid.sid%type,
                                    in_firma_nr         in isi_firma.firma_nr%type,
                                    in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
                                    in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
                                    in_frei_fahren      in varchar2,
                                    in_user_id          in isi_user.login_id%type,
                                    in_transport_id     in isi_transport.transp_id%type,
                                    in_fahrzeuge_ids  in varchar2)
    return pls_integer is

    v_found              boolean; -- dummy var für gefunden im cursor
    v_bool_found         boolean; -- dummy var für gefunden im cursor
    v_ret_value          pls_integer; -- return value
    v_neuer_status       lvs_lte.lte_status%TYPE; -- neuer status der LTE
    v_lgr_quell_platz    lvs_lgr.lgr_platz%TYPE;
    v_lgr_ziel_platz     lvs_lgr.lgr_platz%TYPE;
    v_transport          isi_transport%ROWTYPE;
    v_transport_ahead    isi_transport%ROWTYPE;
    v_lte                lvs_lte%ROWTYPE; -- Daten der transporteinheit (Für den Lagerplatz)
    v_lvs_lgr_quelle_rec lvs_lgr%ROWTYPE; -- Quelle Lagerplatz auf dem die LTE steht
    v_lgr_new_rec        lvs_lgr%ROWTYPE;
    v_ahead_lte          lvs_lte%ROWTYPE;
    v_einl_dispo         number;
    v_gesperrt           varchar2(1);

    CURSOR c_transport IS
      SELECT tr.*
        FROM isi_transport tr
       WHERE tr.transp_id = in_transport_id
         AND tr.sid = in_sid
         AND tr.firma_nr = in_firma_nr;

    CURSOR c_transport_ahead IS
      SELECT tr.*
        FROM isi_transport tr
       WHERE tr.lte_id = v_ahead_lte.lte_id
         and tr.modul_bearbeiter = v_transport.modul_bearbeiter
         and ((tr.status != c.TRANS_GESPERRT) or (v_gesperrt = 'I'))
         AND tr.sid = in_sid
         AND tr.firma_nr = in_firma_nr;

    CURSOR c_lte IS
      SELECT lte.*
        FROM lvs_lte lte
       WHERE lte.lte_id = v_transport.lte_id
         AND lte.sid = in_sid
         AND lte.firma_nr = in_firma_nr;

    CURSOR c_lgr_gruppe IS
      SELECT sum(nvl(lgr.lgr_dispo_einl_te, 0))
        FROM lvs_lgr lgr
       WHERE lgr.sid = v_lvs_lgr_quelle_rec.sid
         AND lgr.firma_nr = v_lvs_lgr_quelle_rec.firma_nr
         AND lgr.lgr_ort = v_lvs_lgr_quelle_rec.lgr_ort
         AND lgr.lgr_platz = v_lvs_lgr_quelle_rec.lgr_platz
         AND lgr.lgr_platz_gruppe = v_lvs_lgr_quelle_rec.lgr_platz_gruppe;

    CURSOR c_ahead_sat_lte IS
      SELECT lte.*
        FROM lvs_lgr lgr, lvs_lte lte
       WHERE lte.sid = v_lte.sid
         AND lte.firma_nr = v_lte.firma_nr
         AND lgr.lgr_ort = v_lvs_lgr_quelle_rec.lgr_ort
         AND lgr.lgr_platz_gruppe = v_lvs_lgr_quelle_rec.lgr_platz_gruppe
         AND lgr.lgr_dim_fifo_nr > v_lvs_lgr_quelle_rec.lgr_dim_fifo_nr
         AND lgr.sid = lte.sid
         AND lgr.firma_nr = lte.firma_nr
         AND lgr.lgr_platz = lte.lgr_platz
       ORDER BY lgr.lgr_dim_fifo_nr DESC;

    CURSOR c_ahead_stap_flae_lte IS
      SELECT lte.*
        FROM lvs_lgr lgr, lvs_lte lte
       WHERE lte.sid = v_lte.sid
         AND lte.firma_nr = v_lte.firma_nr
         AND lgr.lgr_ort = v_lvs_lgr_quelle_rec.lgr_ort
         AND lgr.lgr_platz = v_lvs_lgr_quelle_rec.lgr_platz
         AND lgr.sid = lte.sid
         AND lgr.firma_nr = lte.firma_nr
         AND lgr.lgr_platz = lte.lgr_platz
         AND lte.lte_offset_z > v_lte.lte_offset_z
       ORDER BY lte.lte_offset_z DESC;

    CURSOR c_ahead_seg_lte IS
      SELECT lte.*
        FROM lvs_lgr lgr, lvs_lte lte
       WHERE lte.sid = v_lte.sid
         AND lte.firma_nr = v_lte.firma_nr
         AND lgr.lgr_ort = v_lvs_lgr_quelle_rec.lgr_ort
         AND lgr.lgr_dim_g = v_lvs_lgr_quelle_rec.lgr_dim_g
         AND lgr.lgr_dim_r = v_lvs_lgr_quelle_rec.lgr_dim_r
         AND lgr.lgr_dim_p = v_lvs_lgr_quelle_rec.lgr_dim_p
         AND lgr.lgr_dim_e = v_lvs_lgr_quelle_rec.lgr_dim_e
         AND lgr.lgr_dim_fifo_nr > v_lvs_lgr_quelle_rec.lgr_dim_fifo_nr
         AND lgr.sid = lte.sid
         AND lgr.firma_nr = lte.firma_nr
         AND lgr.lgr_platz = lte.lgr_platz
       ORDER BY lgr.lgr_dim_fifo_nr DESC;
    v_freif_transp_erzeugt boolean;
  BEGIN
    -- Lesen der Artikeldaten
    v_err_nr   := NULL;
    v_err_text := NULL;
    v_gesperrt := 'C'; -- Check Gesperrt

    -- get isi_transport record
    OPEN c_transport;
    FETCH c_transport
      into v_transport;
    v_found := c_transport%FOUND;
    CLOSE c_transport;

    if not v_found then
      v_err_nr   := c.FMID_LTE_ID_Fehlt;
      v_err_text := LC.ec_p1(LC.O_TP1_TRAM_MIT_ID_FEHLT, in_transport_id);
      RAISE v_error;
    end if;

    -- get lvs_lte record
    OPEN c_lte;
    FETCH c_lte
      into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found then
      v_err_nr   := c.FMID_LTE_ID_Fehlt;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, v_transport.lte_id);
      RAISE v_error;
    end if;

    -- get source lvs_lgr record
    BEGIN
      SELECT lgr.*
        INTO v_lvs_lgr_quelle_rec
        FROM lvs_lgr lgr
       WHERE lgr.lgr_platz = v_transport.lgr_platz_quelle
         AND lgr.sid = in_sid
         AND lgr.firma_nr = in_firma_nr;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_err_nr   := c.FMID_Quelle_Existiert_Nicht;
        v_err_text := LC.ec_p1(LC.O_TP1_Q_LGR_PLATZ_FEHLT, NVL(v_transport.lgr_platz_quelle, 'NULL'));
        RAISE v_error;
    END;

    IF v_lvs_lgr_quelle_rec.gesperrt <> 'F'
    and in_modul_bearbeiter <> c.LGR_MODUL_MFR
    then
      v_err_nr   := c.FMID_Lagerplatz_Gesperrt;
      v_err_text := LC.ec_p2(LC.O_TP2_LAGERPLATZ_GESPERRT, NVL(v_lvs_lgr_quelle_rec.lgr_platz, 'NULL'), v_lvs_lgr_quelle_rec.gesp_grund);
      RAISE v_error;
    end if;
    IF v_lvs_lgr_quelle_rec.akt_inventur_id is not NULL THEN
      v_err_nr   := c.FMID_Lagerplatz_Gesperrt;
      v_err_text := LC.ec_p1(LC.O_TP1_LAGERPLATZ_IN_INVENTUR,  NVL(v_lvs_lgr_quelle_rec.lgr_platz, 'NULL'));
      RAISE v_error;
    END IF;

    if v_lvs_lgr_quelle_rec.lgr_typ != c.SAT1
    and v_lvs_lgr_quelle_rec.lgr_typ != c.KANAL1
    and v_lvs_lgr_quelle_rec.lgr_typ != c.SEG1
    and v_lvs_lgr_quelle_rec.lgr_typ != c.SEG_DUEDO1
    and v_lvs_lgr_quelle_rec.lgr_typ != c.STAP_FLAE1
    and v_lvs_lgr_quelle_rec.lgr_typ != c.STAP_FLAE2
    then
      v_ret_value := 0;    -- Nur in diesen Lagertypen können LTE's versperrt sein
      return(v_ret_value);
    end if;

    -- We check, if we have to generate "freifahrt" auftag for container, which is ahead before the our container.
    -- If we have such container, we can't generate auftrag for our container. We make freifahrt auftrag und
    -- waiting before it will be ready.
    v_bool_found := FALSE;

    OPEN c_lgr_gruppe;
    FETCH c_lgr_gruppe into v_einl_dispo;
    CLOSE c_lgr_gruppe;

    if v_einl_dispo > 0
    then
      v_ret_value := -1;
      return(v_ret_value);
    end if;

    if v_lvs_lgr_quelle_rec.lgr_typ != c.SEG1
    and v_lvs_lgr_quelle_rec.lgr_typ != c.SEG_DUEDO1
    then
      if v_lvs_lgr_quelle_rec.lgr_typ = c.STAP_FLAE1
      or v_lvs_lgr_quelle_rec.lgr_typ = c.STAP_FLAE2
      then
        OPEN c_ahead_stap_flae_lte;
        FETCH c_ahead_stap_flae_lte
          INTO v_ahead_lte;
        v_bool_found := c_ahead_stap_flae_lte%FOUND;
        CLOSE c_ahead_stap_flae_lte;
      else
        OPEN c_ahead_sat_lte;

        FETCH c_ahead_sat_lte
          INTO v_ahead_lte;
        v_bool_found := c_ahead_sat_lte%FOUND;
        CLOSE c_ahead_sat_lte;
      end if;
    else
      OPEN c_ahead_seg_lte;

      FETCH c_ahead_seg_lte
        INTO v_ahead_lte;
      v_bool_found := c_ahead_seg_lte%FOUND;
      CLOSE c_ahead_seg_lte;
    end if;

    if v_lvs_lgr_quelle_rec.anz_uml = 0
    then
      v_lvs_lgr_quelle_rec.anz_uml := NULL;
    end if;

    v_freif_transp_erzeugt := false;

    if  v_bool_found
    and in_frei_fahren = c.C_TRUE
    -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
    and nvl(v_lvs_lgr_quelle_rec.anz_uml, v_ahead_lte.anz_uml + 1) > v_ahead_lte.anz_uml
    then
      if  v_ahead_lte.ziel_lgr_platz is not NULL
      then
        -- Palette hat ein Ziel
        OPEN c_transport_ahead;
        FETCH c_transport_ahead
          into v_transport_ahead;
        v_found := c_transport_ahead%FOUND;
        CLOSE c_transport_ahead;
        if v_found
        -- Immer rausfahren auch wenn noch nicht dran (Prüfung zus. auf dem WA)
        -- and (v_transport_ahead.transport_gruppe <= v_transport.transport_gruppe
        --   or v_transport.lgr_platz_ziel != v_transport_ahead.lgr_platz_ziel)
        then
          if v_transport_ahead.status = c.TRANS_BEGIN -- 20170922 AG Transport schon in der AU-Liste MFR
          then
            return(0);
          end if;
          -- Transport gehört zur gleichen oder kleineren Transportgruppe (Oetker Tour)
          -- oder der Transport hat ein anderes Ziel
          -- dann kann dieser auch vorgezogen werden
          update isi_transport tr
             set tr.freifahrauftrag = 'T'
           where tr.transp_id = v_transport_ahead.transp_id;
          v_ret_value := 1;
          return (v_ret_value);
        end if;
      end if;
      -- LTE-Tausch wenn durch ferie gleiche zugestellt
      if isi_allg.get_firma_cfg_param(v_lte.sid,
                                      v_lte.firma_nr, 
                                      'CFG', 
                                      null, 
                                      'TMS_CHG_TRANSPORT_LTE', 
                                      'LVS', 
                                      'CFG', 
                                      c.C_FALSE, 
                                      'BOOLEAN') = c.c_true
      --CMe 20220310 (P71141-117): Pruefung hier entfällt. Findet ebenfalls in lvs_suche_neue_lte_old_crtl statt
      --and v_ahead_lte.order_auf_id is NULL
      and v_lvs_lgr_quelle_rec.lgr_typ in (c.SAT1, c.KANAL1, c.SEG1, c.SEG_DUEDO1)
      and lvs_p_lte.lvs_suche_neue_lte_old_crtl(v_transport,       -- in_transport       in isi_transport%rowtype,
                                                in_user_id,        -- in_user_id         in isi_user.login_id%type,
                                                'CHANGE',          -- in_lte_crtl        in varchar2,
                                                v_ahead_lte.lte_id --in_lte_id          in lvs_lte.lte_id%type
                                               ) is NULL
      then 
        v_ret_value := 1;
        return (v_ret_value);
      end if;
      
      lvs_lager_opt.lvs_lte_freifahren(v_ahead_lte,
                                       in_modul_erzeuger,
                                       in_modul_bearbeiter,
                                       nvl(v_transport.prio, 0) + 1,
                                       in_fahrzeuge_IDs);
      -- -HJG- 20090216: Bugfix für Return = 1 nur bei erzeugtem transport
      v_freif_transp_erzeugt := true;
    end if;
    
    if v_bool_found
       and not v_freif_transp_erzeugt
    then
      -- Palette ist Blockiert, Lager darf nicht freifahren
      -- Falls die Palette die Blockiert auch ausgelagert werden soll,
      -- dann diese raus. An sonsten bleiben die Transporte stehen
      v_gesperrt := 'I'; -- Ignoriere Gesperrt
      OPEN c_transport_ahead;
      FETCH c_transport_ahead
        into v_transport_ahead;
      v_found := c_transport_ahead%FOUND;
      CLOSE c_transport_ahead;
      if v_found
      then
        -- Palette Blockiert und Freifahren verboten
        -- dann kann dieser auch vorgezogen werden
        update isi_transport tr
           set tr.freifahrauftrag = 'T',
               tr.status = decode(tr.status, 'G', 'F', tr.status) -- Falls Gesperrt, dfann jetzt frei
         where tr.transp_id = v_transport_ahead.transp_id;
        v_ret_value := 1;
        return (v_ret_value);
      end if;
      if  v_bool_found
      and in_frei_fahren = c.C_TRUE
      -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
      and nvl(v_lvs_lgr_quelle_rec.anz_uml, v_ahead_lte.anz_uml + 1) <= v_ahead_lte.anz_uml
      then
        update lvs_lte t
           set t.anz_uml = v_lvs_lgr_quelle_rec.anz_uml - 1
         where t.lte_id = v_ahead_lte.lte_id;
      end if;
      -- freifahrtauftrage muss generiert werden
      v_ret_value := -1;
    elsif v_freif_transp_erzeugt
    then
      -- we have container ahead us.
      v_ret_value := 1;
    else
      -- we have not any container ahead us. we can generate auftrag! :)
      v_ret_value := 0;
    end if;

    return v_ret_value;
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
  END lvs_transp_check_zugriff;

  -- ********************************************************************************************************
  -- ********************************************************************************************************
  -- ********************************************************************************************************
  -- Check ob alle LTE für diese Order frei sind, oder nur von der Order selber belegt sind, bzw. mit einer
  -- Order mit einer kleineren LKW Nummer (Kommt dann früher)
  -- return T = true --> Alles frei
  -- ********************************************************************************************************
  -- ********************************************************************************************************

  function lvs_check_lte_stap_flae_frei(in_lte           in lvs_lte%rowtype)
    return number is

    v_anz                              number;
    v_lgr                              lvs_lgr%rowtype;

    CURSOR c_ahead_stap_flae_lte is
      select count(lte.lte_id) anz
        from lvs_lte lte
       where lte.sid = in_lte.sid
         and lte.firma_nr = in_lte.firma_nr
         and lte.lgr_platz = in_lte.lgr_platz
         and lte.lte_offset_z > in_lte.lte_offset_z
         and nvl(lte.order_vorgang_id, 0) <> in_lte.order_vorgang_id;
  begin
    v_anz := 1;
    if lvs_p_base.get_lgr_platz(in_lte.lgr_platz, v_lgr)
    then
      if v_lgr.lgr_typ = c.STAP_FLAE1
      or v_lgr.lgr_typ = c.STAP_FLAE2
      then
        OPEN c_ahead_stap_flae_lte;
        FETCH c_ahead_stap_flae_lte into v_anz;
        CLOSE c_ahead_stap_flae_lte;
      else
        v_anz := 1;
      end if;
    end if;
    return v_anz;
  end;

  -- ********************************************************************************************************
  -- ********************************************************************************************************
  -- ********************************************************************************************************
  -- Für die Sortierung ist es meiner Meinung nach sinnvoll, die COMMITED Funktionen separat zu schreiben
  -- !! HIER DRUNTER BITTE NUR COMMITED FUNKTIONEN !!
  -- ********************************************************************************************************
  -- ********************************************************************************************************

  function c_transport_freigeben(in_sid             in isi_sid.sid%type,
                                 in_firma_nr        in isi_firma.firma_nr%type,
                                 in_user_id         in isi_user.login_id%type,
                                 in_transport_id    in isi_transport.transp_id%type)
                                 return integer is
    v_ret_value integer;
  begin
    v_ret_value := transport_freigeben(in_sid, in_firma_nr, in_user_id, in_transport_id);

    commit;

    return(v_ret_value);
  end;

  function c_transport_sperren(in_sid             in isi_sid.sid%type,
                               in_firma_nr        in isi_firma.firma_nr%type,
                               in_user_id         in isi_user.login_id%type,
                               in_transport_id    in isi_transport.transp_id%type)
                               return integer is
    v_ret_value integer;
  begin
    v_ret_value := transport_sperren(in_sid, in_firma_nr, in_user_id, in_transport_id);

    commit;

    return(v_ret_value);
  end;

  --------------------------------------------------------------------------------
  -- function lvs_uml_check_crt_lte
  -- Prüft ob die Palette bekannt ist.
  --   Wenn ja (Bekannt) dann Prüfen ob bereits ausgelagert
  --     Wenn Ja (Kein Bestand)  dann Wiederherstellen
  --     Wenn Nein (mit Bestand in den aktiven Daten) Alles OK
  --   Wenn nein (in V3 unbekannt) Dann nach Barcodedaten herstellen
  --------------------------------------------------------------------------------
  -- -AG- BugFix 16-10-2014 Resource für Lagerplatz wurde nicht gelesen
  --      und wenn keine Resource oder Resource ohne Lagerplatz dann letzen Lagerplatz
  --      der LTE benutzen

  procedure lvs_uml_check_crt_lte(in_sid          in isi_sid.sid%type,
                                  in_firma_nr     in isi_firma.firma_nr%type,
                                  in_user_id      in isi_user.login_id%type,
                                  in_lte_id       in lvs_lte.lte_id%type,
                                  in_barcode      in lvs_lte.lte_id%type,
                                  in_res_id       in isi_resource.res_id%type,
                                  in_lgr_platz    in lvs_lgr.lgr_platz%type) is

    v_lte                         lvs_lte%rowtype;
    v_lgr                         lvs_lgr%rowtype;
    v_res                         isi_resource%rowtype;
    v_scanner                     isi_scanner_cfg%rowtype;
    v_firma_cfg                   isi_firma_cfg%rowtype;
    v_lte_lgr                     lvs_lte.lgr_platz%type;

    v_barcode     varchar2(100);
    v_spez_bc     varchar2(100);

    v_lte_best                    number;

    CURSOR c_firma_cfg is
      select *
        from isi_firma_cfg f
       where f.sid = v_scanner.sid
         and f.firma_nr = v_scanner.firma_nr
         and f.kategorie = 'CFG'
         and f.parameter_name = v_spez_bc;
  begin
    v_barcode := in_lte_id;
    -- Init
    v_lte := NULL;
    v_lte_best := 0;
    if not lvs_p_base.get_lgr_platz(in_lgr_platz, v_lgr)
    then
      v_lgr := NULL;
    end if;
    -- Ist die LTE bekannt
    if lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      -- hat die LTE noch Bestand
      v_lte_best := lvs_p_lte_lhm.lvs_lte_lhm_best(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, 'LTE');
      -- Falls kein Bestand, dann ist die Palette ausgelagert und muss wieder eingelagert werden
      if v_lte_best = 0
      then -- LTE nocht im aktuellen Bestand, jedoch ohne menge (Ausgelagert)
        lvs_p_lte_lhm.lvs_c_lte_wieder_einl(in_lte_id, v_lgr.lgr_ort, in_user_id);
      else
        lvs_p_lte_lhm.lvs_c_lte_wieder_einl(in_lte_id, v_lgr.lgr_ort, in_user_id);
      end if;
      v_lte_best := lvs_p_lte_lhm.lvs_lte_lhm_best(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, 'LTE');
    else
      if lvs_p_base.get_lte_hist(in_lte_id, v_lte)
      then
        if v_lte.lte_status != c.LTE_AG_STAT
        then -- war bereitrs Ausgebucht und wird jetz wierder benötigt
          lvs_p_lte_lhm.lvs_c_lte_wieder_einl(in_lte_id, v_lgr.lgr_ort, in_user_id);
        else -- evtl. ohne LGR-Platz aus dem Aktuellen Bestand genommen (28 Tage)
          if lvs_util.c_get_lte_aus_historie(in_lte_id) = 0
          then
            v_err_text := LC.ec_p1(LC.O_TP1_LHM_ID_OHNE_BESTAND, in_lte_id);
            raise v_error;
          end if;
        end if;
        v_lte_best := lvs_p_lte_lhm.lvs_lte_lhm_best(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, 'LTE');
      else -- LTE ist bis jetzt unbekannt -> Dann erstellen wenn möglich
        if isi_p_base.get_scanner_by_res_id(in_sid, in_res_id, v_scanner)
        then
          if nvl(v_scanner.barcode_typ, 'ID') = 'ID'
          then
            v_spez_bc := 'SPEZ_BARCODE_' || v_scanner.akt_aufgabe;
          else
            v_spez_bc := upper(v_scanner.barcode_typ) || '_' || upper(v_scanner.barcode_bez);
          end if;

          v_firma_cfg := NULL;
          OPEN c_firma_cfg;
          FETCH c_firma_cfg into v_firma_cfg;
          CLOSE c_firma_cfg;

          if v_scanner.barcode_typ = 'SPEZ_ID'
          or v_spez_bc like 'SPEZ_BARCODE_%'
          then
            v_barcode := lvs_p_lte_lhm.insert_lhm_aus_barcode(in_sid,
                                                               in_firma_nr,
                                                               in_barcode,
                                                               v_firma_cfg.parameter_wert,
                                                               in_barcode,
                                                               v_lte_best,
                                                               in_lte_id);
          else
            v_err_nr   := c.FMID_LTE_ID_SCHON_VORHANDEN;
            v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
            raise v_error;
          end if;
        end if;
      end if;
    end if;
    
    v_lte_lgr := v_lte.lgr_platz;
    
    if nvl(v_lte_best, 0) = 0
    or not lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      v_err_nr   := c.FMID_LTE_ID_SCHON_VORHANDEN;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
      raise v_error;
    end if;

    if v_lte.lgr_platz is NULL
    then
      if not isi_p_base.get_resource(v_lte.sid, in_res_id, v_res)
      then
        v_res.lager_fertig := NULL;
      end if;
                                      
      lvs_p_lte.lvs_korr_te_einbuchen(v_lte.sid,
                                      v_lte.firma_nr,
                                      v_lte.lte_id,
                                      v_lte.lte_status,
                                      in_sid,
                                      in_firma_nr,
                                      null,
                                      v_res.lager_fertig,
                                      in_user_id);
    end if;
    lvs_p_lte.lvs_c_lte_transport(v_barcode, null, in_lgr_platz, in_user_id);

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
  end lvs_uml_check_crt_lte;

  /*******************************************************************************
   * procedure LVS_LTE_TRANSPORT (...)

   Bucht einen Transport mit und ohne Transportauftrag
   *******************************************************************************/
  procedure lvs_lte_transport(in_lte_id        in lvs_lte.lte_id%type,
                              in_von_lgr_platz in lvs_lgr.lgr_platz%type,
                              in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
                              in_user_id       in isi_user.login_id%type
                             ) is
  begin
    lvs_lte_transport_353(in_lte_id,
                          in_von_lgr_platz,
                          in_zu_lgr_platz,
                          in_user_id,
                          NULL,
                          NULL,
                          NULL);
  end;



  procedure lvs_lte_transport_353(in_lte_id        in lvs_lte.lte_id%type,
                                  in_von_lgr_platz in lvs_lgr.lgr_platz%type,
                                  in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
                                  in_user_id       in isi_user.login_id%type,
                                  in_offset_x      in lvs_lte.lte_offset_x%type,
                                  in_offset_y      in lvs_lte.lte_offset_y%type,
                                  in_offset_z      in lvs_lte.lte_offset_z%type)
                                  is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(2550);


    v_lam                lvs_lam%rowtype;           -- Lagerbestand Menge
    v_vorg_typ           lvs_lam_bh.vorg_typ%type;  -- Typ des Vorgangs (UL, LZ ...)
    v_vorg_id            lvs_lam_bh.vorg_id%TYPE;   -- Neu VORGang_ID aus Sequenz
    v_lam_kg             lvs_lam.lam_kg%type;
    v_buch_date          date;                      -- Datum und zeit dieser Buchungen
    v_lam_bh_id          lvs_lam_bh.lam_bh_id%TYPE; -- Neu LAM_BH_ID aus Sequenz

    v_ziel_n_frei_lgr    lvs_lgr%ROWTYPE;             -- Altes Ziel nach freifahren
    v_quell_lgr          lvs_lgr%rowtype;           -- Echtes Ziel des Transports
    v_ziel_lgr           lvs_lgr%rowtype;           -- Echtes Ziel des Transports
    v_transport          isi_transport%rowtype;

    v_lgr_platz          lvs_lgr.lgr_platz%type; -- Lagerplatz des Materials
    v_lte                lvs_lte%rowtype;       -- Daten der transporteinheit (Für den Lagerplatz)
    v_isi_liefs          isi_liefs%rowtype;

    v_ret_value          INTEGER;                   -- return value

    v_found             boolean;
    v_neuer_Status   lvs_lte.lte_status%TYPE;   -- neuer status der LTE

    v_lte_cfg            lvs_lte_cfg%rowtype;
    v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

    CURSOR c_lte_cfg is
      select t.*
        from lvs_lte_cfg t
       where t.sid = v_lte.sid
         and t.firma_nr = v_lte.firma_nr
         and t.lte_name = v_lte.lte_name;


    CURSOR c_lte is                            -- Lesen der Transporteinheit für den Lagerplatz
      select *
      from lvs_lte lte
      where lte.lte_id = in_lte_id;

    CURSOR c_transport is                            -- Lesen Transport
      select *
      from isi_transport trans
      where trans.lte_id = in_lte_id
        and trans.lgr_platz_ziel = v_lgr_platz;

    CURSOR c_lgr is                            -- Lesen Lagerplatz
      select *
      from lvs_lgr lgr
      where lgr.lgr_platz = v_lgr_platz;

    CURSOR c_lam is
      select *
        from lvs_lam lam
       where lam.sid = v_lte.sid
         and lam.firma_nr = v_lte.firma_nr
         and lam.lte_id = in_lte_id;

    CURSOR c_isi_liefs is
      select *
        from isi_liefs l
       where l.sid = v_lte.sid
         and l.firma_nr = v_lte.firma_nr
         and l.vorgang_id = v_lte.order_vorgang_id;
  begin
    --
    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;         -- LTE noch eingetragen ?
    CLOSE c_lte;
    v_buch_date := sysdate;

    if not v_found
    or v_lte.lte_status = c.LTE_AG_STAT
    then
      v_err_nr := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
      raise v_error;
    end if;

    if v_lte.lgr_platz is NULL
    then
      if v_lte.lte_status = c.LTE_ET_STAT
      or v_lte.lte_status = c.LTE_AT_STAT
      or v_lte.lte_status = c.LTE_UT_STAT
      then
        v_err_nr := 10;
        v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_W_TRANSPORTIERT, nvl(in_lte_id,'NULL'));
        raise v_error;
      end if;
      v_err_nr := null;
      v_err_text := NULL;
      lvs_p_lte.LVS_C_KORR_TE_EINBUCHEN(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, v_lte.lte_status,
                                        v_lte.sid, v_lte.firma_nr, NULL, in_zu_lgr_platz, in_user_id);
      return;
    end if;

    if v_lte.lte_status = c.LTE_BS_STAT
    then
      v_err_nr := 11;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_W_BEFUELLT, nvl(in_lte_id,'NULL'));
      raise v_error;
    end if;

    v_ret_value := 2;
    if v_lte.ziel_lgr_ort is not NULL then
      v_ret_value := 1;
      -- Wenn das Ziel gleich oder in Firma_CFG eingestell, dann immer den Transport mit dem Ziel fertigmelden
      if isi_allg.get_firma_cfg_param (v_lte.sid,
                                          v_lte.firma_nr,
                                          'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                          NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                          'LVS_LTE_TRANSP_I_TR_F',  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                          'LVS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                          'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                          'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                          'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
      or v_lte.ziel_lgr_platz = in_zu_lgr_platz
      then
        v_lgr_platz := v_lte.ziel_lgr_platz;
        OPEN c_transport;
        FETCH c_transport into v_transport;
        v_found := c_transport%FOUND;
        CLOSE c_transport;
        if v_found then
          v_ret_value :=  lvs_transport.lvs_transp_fertig(v_transport.sid, v_transport.firma_nr, in_user_id,
                                                      v_transport.transp_id, in_lte_id, NULL, in_zu_lgr_platz, 'F');
        end if;
      elsif v_lte.ziel_lgr_platz_n_freif = in_zu_lgr_platz then
        v_lgr_platz := v_lte.ziel_lgr_platz;
        OPEN c_transport;
        FETCH c_transport into v_transport;
        v_found := c_transport%FOUND;
        CLOSE c_transport;
        if v_found then
          v_ret_value := lvs_transport.lvs_transp_loeschen(v_transport.sid, v_transport.firma_nr, in_user_id,
                                                       v_transport.transp_id, 'F');
        end if;
        v_lgr_platz := v_lte.ziel_lgr_platz_n_freif;
        OPEN c_transport;
        FETCH c_transport into v_transport;
        v_found := c_transport%FOUND;
        CLOSE c_transport;
        if v_found then
           v_ret_value := lvs_transport.lvs_transp_fertig(v_transport.sid, v_transport.firma_nr, in_user_id,
                                                      v_transport.transp_id, in_lte_id, NULL, in_zu_lgr_platz, 'F');
        end if;
      end if;
    end if;
    if v_ret_value != 0 then
      v_lgr_platz := in_zu_lgr_platz;
      OPEN c_lgr;
      FETCH c_lgr into v_ziel_lgr;
      CLOSE c_lgr;
      v_lgr_platz := v_lte.ziel_lgr_platz_n_freif;
      OPEN c_lgr;
      FETCH c_lgr into v_ziel_n_frei_lgr;
      CLOSE c_lgr;
      v_lgr_platz := v_lte.lgr_platz;
      OPEN c_lgr;
      FETCH c_lgr into v_quell_lgr;
      CLOSE c_lgr;

      if v_quell_lgr.lgr_verwendung = c.LGR_TYP_WE
      and v_lte.order_vorgang_id is not NULL
      and v_lte.ziel_lgr_platz is NULL -- Hat keinen Transport
      then
        v_isi_liefs := NULL;
        OPEN c_isi_liefs;
        FETCH c_isi_liefs into v_isi_liefs;
        CLOSE c_isi_liefs;
        if v_lte.order_vorgang_id = v_isi_liefs.vorgang_id
        and v_isi_liefs.inaktiv_grund is NULL
        then
          v_err_nr := 13;
          v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_AUSGEL_M_RES,  nvl(in_lte_id,'NULL'));
          raise v_error;
        end if;
      end if;

      if v_ret_value != 2
      or v_lte.ziel_lgr_platz is NULL -- Hat keinen Transport
      then
        v_lgr_platz := v_lte.ziel_lgr_platz;

        OPEN c_transport;
        FETCH c_transport into v_transport;
        v_found := c_transport%FOUND;
        CLOSE c_transport;
        if v_found then
          update isi_transport t
             set t.lgr_platz_quelle = in_zu_lgr_platz,
                 t.lgr_ort_quelle = v_ziel_lgr.lgr_ort
           where t.sid = v_transport.sid
             and t.firma_nr = v_transport.firma_nr
             and t.transp_id = v_transport.transp_id;
        end if;
      end if;

      v_neuer_status := c.LTE_LF_STAT;
      v_vorg_typ := c.LAM_BH_ZUGAGNG;
      if  v_ziel_lgr.lgr_verwendung = c.LGR_TYP_WA then
        v_neuer_status := c.Lte_AF_Stat;
        v_vorg_typ := c.LAM_BH_ABGAGNG;
      else
        if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_WE then
          v_neuer_status := c.Lte_BF_Stat;
          v_vorg_typ := c.LAM_BH_UMLAG;
        end if;

        if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_LagerP then
          v_neuer_status := c.Lte_Bs_Stat;              -- Kann weiter befüllt werden
          v_vorg_typ := c.LAM_BH_UMLAG;
        end if;

        if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_EP then
          v_neuer_status := c.Lte_ET_Stat;
        end if;

        if v_quell_lgr.lgr_verwendung = c.LGR_TYP_Lager then
          v_vorg_typ := c.LAM_BH_UMLAG;
        end if;

        if  v_ziel_n_frei_lgr.lgr_verwendung = c.LGR_TYP_WA then
          v_neuer_Status := c.LTE_AD_STAT;
        end if;

        if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_Lager and
          v_ziel_n_frei_lgr.lgr_verwendung  = c.Lgr_Typ_Lager then
          v_neuer_Status := c.LTE_UD_STAT;
        end if;

        if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_WE and
          v_ziel_n_frei_lgr.lgr_verwendung  = c.Lgr_Typ_Lager then
          v_neuer_Status := c.LTE_ED_STAT;
        end if;

        if v_ziel_lgr.lgr_verwendung = c.LGR_TYP_LagerP and
          v_ziel_n_frei_lgr.lgr_verwendung  = c.Lgr_Typ_Lager then
          v_neuer_Status := c.LTE_ED_STAT;
        end if;
        
        -- CMe 20210419 Anfang
        -- Wenn ein Transport noch offen ist und die Palette auf einen Platz umgebucht wurde, muss
        -- der Status richtig gesetzt werden Abhängig von Transport Ziel. Ticket: E70397-603
        if (v_ret_value != 2) and
           (v_transport.lgr_platz_ziel is not null)
        then
          if (v_transport.transp_typ = 'E') and
             (v_ziel_lgr.lgr_verwendung = c.LGR_TYP_Lager) and
             (v_transport.status = c.TRANS_FREI)
          then
            v_neuer_Status := c.LTE_UD_STAT;
          end if;
          
          if (v_transport.transp_typ = 'E') and
             (v_ziel_lgr.lgr_verwendung = c.LGR_TYP_Lager) and
             ((v_transport.status = c.TRANS_TRANSPORT) or (v_transport.status = c.TRANS_BEGIN))
          then
            v_neuer_Status := c.LTE_UT_STAT;
          end if;
          
          if (v_transport.transp_typ = 'E') and
             (v_ziel_lgr.lgr_verwendung <> c.LGR_TYP_Lager) and
             (v_transport.status = c.TRANS_FREI)
          then
            v_neuer_Status := c.LTE_ED_STAT;
          end if;
          
          if (v_transport.transp_typ = 'E') and
             (v_ziel_lgr.lgr_verwendung <> c.LGR_TYP_Lager) and
             ((v_transport.status = c.TRANS_TRANSPORT) or (v_transport.status = c.TRANS_BEGIN))
          then
            v_neuer_Status := c.LTE_ET_STAT;
          end if;
          
          if (v_transport.transp_typ = 'A') and
             (v_transport.status = c.TRANS_FREI)
          then
            v_neuer_Status := c.LTE_AD_STAT;
          end if;
          
          if (v_transport.transp_typ = 'A') and
             (v_ziel_lgr.lgr_verwendung <> c.LGR_TYP_Lager) and
             ((v_transport.status = c.TRANS_TRANSPORT) or (v_transport.status = c.TRANS_BEGIN))
          then
            v_neuer_Status := c.LTE_AT_STAT;
          end if;
          
          if (v_transport.transp_typ = 'U') and
             (v_transport.status = c.TRANS_FREI)
          then
            v_neuer_Status := c.LTE_UD_STAT;
          end if;
          
          if (v_transport.transp_typ = 'U') and
             ((v_transport.status = c.TRANS_TRANSPORT) or (v_transport.status = c.TRANS_BEGIN))
          then
            v_neuer_Status := c.LTE_UT_STAT;
          end if;
        end if;
        -- CMe 20210419 Ende
      end if;
      
      if v_quell_lgr.lgr_platz is not NULL then
        lvs_platz.lvs_platz_ausl_buchen(v_lte, v_quell_lgr); -- Bucht den Lagerplatz Fehler dann Exception
      end if;

      OPEN c_lte_cfg;
      FETCH c_lte_cfg into v_lte_cfg;
      CLOSE c_lte_cfg;

      v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
      lvs_platz.lvs_platz_einl_pruefen_R30(v_lte,
                                           v_basis_lte_name,
                                           v_lte_cfg.flaechen_stellplatz_erf,
                                           v_ziel_lgr,
                                           'K',
                                           NULL);
      lvs_platz.lvs_platz_einl_buchen (v_lte, v_ziel_lgr);
      -- -AG- 2011.01.05 Lagerplatz akt TE + 1 -> für Kanalkontrolle
      v_ziel_lgr.lgr_akt_te := nvl(v_ziel_lgr.lgr_akt_te, 0) + 1;
      lvs_lager_opt.lvs_kanal_kontrolle(v_lte,v_ziel_lgr);
      lvs_p_lte.lvs_te_lagerziel_umbuchen_353(v_lte.sid, v_lte.firma_nr,
                                              v_lte.lte_id,
                                              v_ziel_lgr.lgr_platz, v_ziel_lgr.lgr_ort, v_ziel_lgr.lgr_platz_gruppe,
                                              v_lte.ziel_lgr_platz, v_lte.ziel_lgr_ort,
                                              v_neuer_status, v_lte.lte_status,
                                              v_lte.ziel_lgr_platz_n_freif, v_lte.ziel_lgr_ort_n_freif,
                                              systimestamp, v_lte.order_auf_id, v_lte.order_vorgang_id,
                                              NULL,
                                              v_lte.transport_gruppe,
                                              v_lte.lkw_nr,
                                              in_offset_x,
                                              in_offset_y,
                                              in_offset_z);
      -- Neu -AD- 17.10.2004  -Fehlte noch-
      -- Jetzt alle Lagerbuchungen buchen
      OPEN c_lam;
      v_err_nr := 20;
      v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
      select seq_vorg_id.nextval into v_vorg_id from dual;
      v_err_nr := NULL;
      LOOP
        FETCH c_lam into v_lam;                 -- LagerArtikelMaterial Eintrag lesen
        EXIT when c_lam%NOTFOUND;               -- Kein Eintrag mehr da

        begin
          v_lam_kg :=  v_lam.lam_kg / v_lam.menge;
        exception
          when others then
            v_lam_kg := 0;
        end;

        v_err_nr := 30;
        v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
        select seq_lam_bh.nextval into v_lam_bh_id from dual;
        v_err_nr := NULL;

        -- Lagerplatz Quelle entlasten (Nuch buchung schreiben)
        -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
        insert into lvs_lam_bh
             values(v_lte.sid,
                    v_lte.firma_nr,
                    v_vorg_id,
                    v_vorg_typ,
                    v_lam_bh_id,
                    v_lam.lam_id,
                    v_lam.artikel_id,
                    C.LAM_BH_BUS_UML,
                    v_buch_date,
                    in_user_id,
                    v_quell_lgr.lgr_platz,
                    in_lte_id,
                    v_lam.lhm_id,
                    v_lam.charge_id,
                    v_lam.serie_id,
                    NULL,
                    v_lam.menge * -1,
                    v_lam.lam_kg * -1,
                    v_lam_kg,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    sysdate,                     -- CREATED_DATE	N	DATE	Y			creation date+time of this dataset
                    in_user_id,                  -- CREATED_LOGIN_ID	N	NUMBER	Y			login id of the user creating this dataset
                    sysdate,                     -- LAST_CHANGE_DATE	N	DATE	Y			change date+time of this dataset
                    in_user_id,                  -- LAST_CHANGE_LOGIN_ID	N	NUMBER	Y			login id of the user changing this dataset
                    null,                        -- CHANGE_MENGE	N	NUMBER	Y			Menge die geändert wurde
                    v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                    null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

        v_err_nr := 40;
        v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
        select seq_lam_bh.nextval into v_lam_bh_id from dual;
        v_err_nr := NULL;

        -- Lagerplatz Ziel belasten (Nuch buchung schreiben)
        -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
        insert into lvs_lam_bh
             values(v_lte.sid,
                    v_lte.firma_nr,
                    v_vorg_id,
                    v_vorg_typ,
                    v_lam_bh_id,
                    v_lam.lam_id,
                    v_lam.artikel_id,
                    C.LAM_BH_BUS_UML,
                    v_buch_date,
                    in_user_id,
                    v_ziel_lgr.lgr_platz,
                    in_lte_id,
                    v_lam.lhm_id,
                    v_lam.charge_id,
                    v_lam.serie_id,
                    NULL,
                    v_lam.menge,
                    v_lam.lam_kg,
                    v_lam_kg,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    sysdate,                     -- CREATED_DATE	N	DATE	Y			creation date+time of this dataset
                    in_user_id,                  -- CREATED_LOGIN_ID	N	NUMBER	Y			login id of the user creating this dataset
                    sysdate,                     -- LAST_CHANGE_DATE	N	DATE	Y			change date+time of this dataset
                    in_user_id,                  -- LAST_CHANGE_LOGIN_ID	N	NUMBER	Y			login id of the user changing this dataset
                    null,                        -- CHANGE_MENGE	N	NUMBER	Y			Menge die geändert wurde
                    v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                    null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

        s_schnittstelle.write_host_bew(NULL, v_lam, v_lam_bh_id, C.LAM_BH_BUS_UML, v_vorg_typ,
                                      NULL, 'UE', v_quell_lgr, v_ziel_lgr, in_user_id);
        if v_ziel_lgr.wa_typ = 'LDPO' -- Automatisch den Lagerabgang buchen
        then
          v_lam.lam_id   := lvs_ausl.lvs_lam_abgang(v_lte.sid,
                                                    v_lte.firma_nr,
                                                    v_lam.artikel_id,
                                                    v_lte.lte_id,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    v_buch_date,
                                                    in_user_id,
                                                    v_vorg_id,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    c.LAM_BH_BUS_ABG,
                                                    NULL,
                                                    NULL,
                                                    NULL);

        end if;
      end LOOP;
      CLOSE c_lam;

    end if;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
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
  end lvs_lte_transport_353;

  procedure c_transport_reihenfolge_set(in_sid                   in isi_sid.sid%type,
                                        in_firma_nr              in isi_firma.firma_nr%type,
                                        in_user_id               in isi_user.login_id%type,
                                        in_transport_id          in isi_transport.transp_id%type,
                                        in_transport_reihenfolge in isi_transport.transport_reihenfolge%type)
                                        is
    v_transport                         isi_transport%rowtype;
    v_transp_id                         isi_transport.transp_id%type;

    CURSOR c_transport is
      select *
        from isi_transport t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.parent_transp_id = v_transp_id;
  begin
    update isi_transport t
       set t.transport_reihenfolge = in_transport_reihenfolge,
           t.user_id = nvl(in_user_id, t.user_id)
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.transp_id = in_transport_id;


    v_transp_id := in_transport_id;

    OPEN c_transport;
    FETCH c_transport into v_transport;
    LOOP
      EXIT when c_transport%NOTFOUND;
      CLOSE c_transport;
      -- Cursor zu und Update Kind

      update isi_transport t
         set t.transport_reihenfolge = in_transport_reihenfolge,
             t.user_id = nvl(in_user_id, t.user_id)
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.transp_id = v_transport.transp_id;

      -- Transportid für CURSOR OPEN
      v_transp_id := v_transport.transp_id;
      v_transport := NULL;

      -- Falls es zu diesem TRansport noch ein Kind gibt UPDATE
      OPEN c_transport;
      FETCH c_transport into v_transport;

    end LOOP;

    CLOSE c_transport;
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_transport%ISOPEN
      then
        CLOSE c_transport;
      end if;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_transport%ISOPEN
      then
        CLOSE c_transport;
      end if;
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
  end c_transport_reihenfolge_set;

  procedure c_transport_reihenfolge_fix(in_sid                   in isi_sid.sid%type,
                                        in_firma_nr              in isi_firma.firma_nr%type,
                                        in_user_id               in isi_user.login_id%type,
                                        in_modul_bearbeiter      in isi_transport.Modul_Bearbeiter%TYPE,
                                        in_trans_typ             in varchar2,
                                        in_fixieren              in varchar2)
                                        is
  begin
    if in_fixieren = c.C_TRUE
    then
      update isi_transport t
         set t.transport_reihenfolge = 0,
             t.user_id = in_user_id
       where t.sid               = in_sid
         and t.firma_nr          = in_firma_nr
         and t.modul_bearbeiter  = in_modul_bearbeiter
         and t.transp_typ        = in_trans_typ
         and t.status != 'F'
         and t.status != 'S'
         and t.status != 'G';
    else
      update isi_transport t
         set t.transport_reihenfolge = 9999999999,
             t.user_id = in_user_id
       where t.sid               = in_sid
         and t.firma_nr          = in_firma_nr
         and t.modul_bearbeiter  = in_modul_bearbeiter
         and t.transp_typ        = in_trans_typ
         and t.status != 'F'
         and t.status != 'S'
         and t.status != 'G';
    end if;
  end;

  --------------------------------------------------------------------------------
  -- function lvs_check_transport_ziel
  -- Sucht den Platz im Kanal, der die kleinste fifo-nr hat. Für korrekte Buchung
  -- z.B. aus dem MFR, wenn sich LTEs ueberholen und die SPS keine korrekten
  -- plätze zurück gibt
  -- Return: Lagerplatz LVS_LGR.LGR_PLATZ
  -- Fehler exception
  -- C.FMID_Kein_Platz_fuer_LTE ORA-20976 -> Der Lagerplatz <%1> ist voll. Check für LTE: <%2>
  -- C.FMID_Zuggang_Buchen      ORA-20979 -> Fehler: TransportId <%1> ist unbekannt
  --------------------------------------------------------------------------------
  function lvs_check_transport_ziel(in_sid                   in isi_sid.sid%type,
                                    in_firma_nr              in isi_firma.firma_nr%type,
                                    in_transport_id    in isi_transport.transp_id%type
                                    )
                                    return lvs_lgr.lgr_platz%type is
    v_error     EXCEPTION;                 --
    v_err_nr    number;
    v_err_text  varchar2(2550);

    v_transport                     isi_transport%rowtype;
    v_lgr                           lvs_lgr%rowtype;
    v_lgr_ziel                      lvs_lgr%rowtype;

    v_found                         boolean;

    CURSOR c_lvs_lgr is
      select l.*
        from lvs_lgr l,
             lvs_lgr_ort o
       where l.lgr_platz_gruppe = v_lgr_ziel.lgr_platz_gruppe
         and (    (l.lgr_dim_g = v_lgr_ziel.lgr_dim_g
               and l.lgr_dim_r = v_lgr_ziel.lgr_dim_r
               and l.lgr_dim_p = v_lgr_ziel.lgr_dim_p
               and l.lgr_dim_e = v_lgr_ziel.lgr_dim_e
                  )
             or   (l.lgr_typ != c.SEG1
               and l.lgr_typ != c.SEG_DUEDO1
                  )
             )
         and l.lgr_akt_te < l.lgr_max_te
         and nvl(l.lte_namen, 'x') != 'Keine'
         and l.lgr_ort = o.lgr_ort
         -- and (   not exists (select t.lgr_platz_ziel from isi_transport t where t.lgr_platz_ziel = l.lgr_platz and t.status != c.TRANS_ZUGEW)
         and (       not exists (select t.lgr_platz_ziel 
                                   from isi_transport t 
                                  where t.lgr_platz_ziel_check_new = l.lgr_platz                   
                                    and t.status in (c.TRANS_ZUGEW, c.TRANS_TRANSPORT)  -- Transport ist zugewien und nicht der aktuelle, lagerplatz bereits vergeben 
                                    and t.transp_id != in_transport_id)                 -- Eigener Transport darf nicht zum Fehler führen, dann ist der PLatz OK
              or o.lgr_ort_modul != c.LGR_MODUL_MFR)                                    -- Wenn nicht MFR erstmal immer OK
       order by l.lgr_dim_fifo_nr;
    pragma autonomous_transaction;
  begin
    v_lgr.lgr_platz := NULL;
    if lvs_p_base.get_transport(in_sid, in_transport_id, v_transport)
    then
      if lvs_p_base.get_lgr_platz(v_transport.lgr_platz_ziel, v_lgr_ziel)
      then
        OPEN c_lvs_lgr;
        FETCH c_lvs_lgr into v_lgr;
        v_found := c_lvs_lgr%FOUND;
        CLOSE c_lvs_lgr;
        if v_found
        then
          update isi_transport t
             set t.lgr_platz_ziel_check_new = v_lgr.lgr_platz
           where t.transp_id = in_transport_id;
          commit;
          return(v_lgr.lgr_platz);
        else
          v_err_nr := c.FMID_Kein_Platz_fuer_LTE;
          v_err_text := LC.ec_p2(LC.O_TP2_LGR_PLATZ_VOLL, v_transport.lgr_platz_ziel, v_transport.lte_id);
          raise v_error;
        end if;
      else
        v_err_nr := c.FMID_Zuggang_Buchen;
        v_err_text := LC.ec_p1(LC.O_TP1_TRAM_MIT_ID_FEHLT, to_char(in_transport_id));
        raise v_error;
      end if;
    end if;
    commit;
    return(v_lgr.lgr_platz);
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
  end lvs_check_transport_ziel;


  procedure transport_grp_check(in_sid                   in isi_sid.sid%type,
                                in_firma_nr              in isi_firma.firma_nr%type,
                                in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                                in_lte_id                in isi_transport_grp.lte_grp_id%type,
                                in_user_ID               in isi_user.login_id%TYPE)
                                is
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(2550);
    v_transp_grp  isi_transport_grp%rowtype;
    v_found     boolean;
  begin
    --prüfen ob Parameter übergeben wurden
    if in_lte_grp_id is null or
       in_lte_id is null then
         v_err_nr := C.FMID_Param_fehlen;
         v_err_text := LC.ec(LC.O_TXT_KEIN_PARAMETER);
         raise v_error;
    end if;
    --prüfen ob LTE-ID schon in einem Stapel vorhanden ist
    if lvs_p_base.get_transp_grp_by_lte_grp_id('01',
                                                in_lte_id,
                                                v_transp_grp) then
       v_err_nr := C.FMID_transp_grp_vorhanden;
       v_err_text := LC.ec_p2(LC.O_TP2_TRANSP_GRP_FUER_LTE_VOH, v_transp_grp.lte_grp_id, in_lte_id);
       raise v_error;                               
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

  procedure c_transport_grp_crt(in_sid                   in isi_sid.sid%type,
                                in_firma_nr              in isi_firma.firma_nr%type,
                                in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                                in_lte_id                in isi_transport_grp.lte_grp_id%type,
                                in_user_ID               in isi_user.login_id%TYPE)
                                is
    v_error       EXCEPTION;
    v_err_nr      number;
    v_err_text    varchar2(2550);
    v_transp_grp  isi_transport_grp%rowtype;
    v_transp      isi_transport%rowtype;
    v_found       boolean;
  begin
    transport_grp_check(in_sid,
                        in_firma_nr,
                        in_lte_grp_id,
                        in_lte_id,
                        in_user_ID);

    --prüfen ob GRP-ID schon als Gruppen-ID vorhanden ist
    if lvs_p_base.get_transp_grp_by_lte_grp_id('01',
                                                in_lte_grp_id,
                                                v_transp_grp) then
       v_err_nr := C.FMID_transp_grp_vorhanden;
       v_err_text := LC.ec_p2(LC.O_TP2_TRANSP_GRP_FUER_LTE_VOH, in_lte_grp_id, in_lte_id);
       raise v_error;
    end if;

    v_found := lvs_p_base.get_transport_by_lte_id(in_lte_id,
                                                  v_transp);
    if v_found
    then
      INSERT INTO isi_transport_grp t
      VALUES
        ('01', -- sid
         1, -- firma_nr
         v_transp.transp_id,-- transp_id
         in_lte_grp_id, --LTE Gruppen ID
         in_lte_id, --LTE ID
         1, -- Positionsnummer innerhalb der Gruppe
         v_transp.lgr_platz_ziel,
         sysdate,
         in_user_ID,
         null,
         null
         );
    else
       v_err_nr := C.FMID_transp_id_fehlt;
       v_err_text := LC.ec_p1(LC.O_TP1_TRANSP_ID_FEHLT_FUER_LTE, in_lte_id);
       raise v_error;
    end if;
    commit;
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

  procedure c_transport_grp_add(in_sid                   in isi_sid.sid%type,
                                in_firma_nr              in isi_firma.firma_nr%type,
                                in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                                in_lte_id                in isi_transport_grp.lte_grp_id%type,
                                in_user_ID               in isi_user.login_id%TYPE)
                                is
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(2550);
    v_transp_grp  isi_transport_grp%rowtype;
    v_transp      isi_transport%rowtype;
    v_found     boolean;
  begin
    transport_grp_check(in_sid,
                        in_firma_nr,
                        in_lte_grp_id,
                        in_lte_id,
                        in_user_ID);
    --prüfen ob GRP-ID schon als Gruppen-ID vorhanden ist
    if not lvs_p_base.get_transp_grp_by_lte_grp_id('01',
                                                    in_lte_grp_id,
                                                    v_transp_grp) 
    then
       v_err_nr := C.FMID_transp_grp_fehlt;
       v_err_text := LC.ec_p1(LC.O_TP1_TRANSP_GRP_FEHLT, in_lte_grp_id);
       raise v_error;
    end if;
                        
    v_found := lvs_p_base.get_transport_by_lte_id(in_lte_id,
                                                  v_transp);
    if v_found
    then
      if v_transp.lgr_platz_ziel != v_transp_grp.lte_grp_ziel_lgr_platz
      then
        v_err_nr := C.FMID_Weg_Von_Nach_falsch;
        v_err_text := LC.ec_p1(LC.O_TP1_TRANSP_GRP_LTE_ZIEL_ERR, in_lte_id);
        raise v_error;
      end if;
      update isi_transport_grp t
         set t.lte_pos_grp = t.lte_pos_grp + 1,
             t.last_change_login_id = in_user_ID
       where t.lte_grp_id = in_lte_grp_id;
       
      INSERT INTO isi_transport_grp t
      VALUES
        ('01', -- sid
         1, -- firma_nr
         v_transp.transp_id,-- transp_id
         in_lte_grp_id, --LTE Gruppen ID
         in_lte_id, --LTE ID
         1, -- Positionsnummer innerhalb der Gruppe
         v_transp.lgr_platz_ziel,
         sysdate,
         in_user_ID,
         null,
         null
         );
    else
       v_err_nr := C.FMID_transp_id_fehlt;
       v_err_text := LC.ec_p1(LC.O_TP1_TRANSP_ID_FEHLT_FUER_LTE, in_lte_id);
       raise v_error;
    end if;
    commit;
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
  
  procedure transport_grp_sub(in_sid                   in isi_sid.sid%type,
                              in_firma_nr              in isi_firma.firma_nr%type,
                              in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                              in_lte_id                in isi_transport_grp.lte_grp_id%type,
                              in_user_ID               in isi_user.login_id%TYPE)
                              is
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(2550);
    v_transp_grp  isi_transport_grp%rowtype;
    v_transp_id   isi_transport.transp_id%type;
    v_found     boolean;
  begin
    --prüfen ob LTE-ID schon in einem Stapel vorhanden ist
    if lvs_p_base.get_transp_grp_by_lte_id('01',
                                            in_lte_id,
                                            v_transp_grp) then
       if v_transp_grp.lte_grp_id != in_lte_grp_id
       then
         v_err_nr := C.FMID_transp_grp_falsch;
         v_err_text := LC.ec_p2(LC.C_TP2_TRANSP_GRP_FALSCH, v_transp_grp.lte_grp_id, in_lte_grp_id);
         raise v_error;
       end if;
      update isi_transport_grp t
         set t.lte_pos_grp = t.lte_pos_grp - 1,
             t.last_change_login_id = in_user_ID
       where t.lte_grp_id = in_lte_grp_id
         and t.lte_pos_grp > v_transp_grp.lte_pos_grp;
         
      DELETE isi_transport_grp t
       where t.lte_grp_id = in_lte_grp_id
         and t.lte_id = v_transp_grp.lte_id;
    else
      v_err_nr := C.FMID_transp_grp_fehlt;
      v_err_text := LC.ec_p1(LC.O_TP1_TRANSP_GRP_F_LTE_FEHLT, in_lte_id);
      raise v_error;
    end if;
                        
    commit;
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

  procedure c_transport_grp_sub(in_sid                   in isi_sid.sid%type,
                                in_firma_nr              in isi_firma.firma_nr%type,
                                in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                                in_lte_id                in isi_transport_grp.lte_grp_id%type,
                                in_user_ID               in isi_user.login_id%TYPE)
                                is
  begin
      transport_grp_sub(in_sid,
                        in_firma_nr,
                        in_lte_grp_id,
                        in_lte_id,
                        in_user_ID);
  end;


  procedure c_transport_grp_del(in_sid                   in isi_sid.sid%type,
                                in_firma_nr              in isi_firma.firma_nr%type,
                                in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                                in_user_ID               in isi_user.login_id%TYPE)
                                is
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(2550);
    v_transp_grp  isi_transport_grp%rowtype;
    v_transp_id   isi_transport.transp_id%type;
    v_found     boolean;
  begin
       
    DELETE isi_transport_grp t
     where t.lte_grp_id = in_lte_grp_id;
    commit;
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
 
end lvs_transport;
/



-- sqlcl_snapshot {"hash":"4072764dec75b72888bbcb9cc32366f507fc8089","type":"PACKAGE_BODY","name":"LVS_TRANSPORT","schemaName":"DIRKSPZM32","sxml":""}