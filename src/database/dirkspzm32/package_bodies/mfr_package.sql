create or replace 
package body DIRKSPZM32.MFR_Package is

  procedure Change_Lte_Properties(in_lte                  in lvs_lte%rowtype,
                                  in_lte_name             in lvs_lte.lte_name%type,
                                  in_lte_hoehe            in lvs_lte.lte_vol_hoehe%type,
                                  in_lte_breite           in lvs_lte.lte_vol_breite%type,
                                  in_lte_tiefe            in lvs_lte.lte_vol_tiefe%type,
                                  in_lte_gewicht          in lvs_lte.lte_akt_kg%type,
                                  in_wickelprogramm       in lvs_lte.wickelprogramm%type,
                                  in_auto_depal           in lvs_lte.auto_depal%type
                                  );

  -- Function and procedure implementations
  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

-------------------------------------------------------------------------
function MFR_SIM_get_einlager_lte_id   (in_sid         in isi_sid.sid%TYPE,
                                        in_firma_nr    in isi_firma.firma_nr%TYPE)
                                        Return varchar2 is
-------------------------------------------------------------------------
-- Holt fuer die MFR Simulation eien Paletten ID von eien Einlagerfaehigen Palette


  v_error      EXCEPTION;
  v_err_nr     number;
  v_err_text   varchar2(255);
  v_found      boolean;

  v_lte_id     lvs_lte.lte_id%type;

  CURSOR c_lte_id is
    select t.lte_id
      from lvs_lte t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.lte_status = c.LTE_PF_STAT
     order by t.lte_id;
BEGIN
  v_err_nr := NULL;
  v_err_text := NULL;

  OPEN c_lte_id;
  FETCH c_lte_id into v_lte_id;
  v_found := c_lte_id%FOUND;
  CLOSE c_lte_id;

  if not v_found
  then
    v_lte_id := NULL;
  end if;

  return (v_lte_id);
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
END MFR_SIM_get_einlager_lte_id;


-------------------------------------------------------------------------
procedure c_sc_ean_create_lte_print (in_scanner_name      in      isi_scanner_cfg.scanner_name%type,
                                     in_barcode           in      isi_scanner_cfg.scanner_daten%type,
                                     in_login_id          in      isi_user.login_id%type)
                                     is

-------------------------------------------------------------------------
-- Dient als Deckel für den MFR, damit aus dem MFR-Server vernüftig
-- zugegriffen werden kann. Druckfunktion so spaeter auch für auto.
-- Etikettierung ohne MFR möglich

begin
  bde_scanner.bde_c_sc_ean_create_lte_print(in_scanner_name,        -- in_scanner_name      in      isi_scanner_cfg.scanner_name%type,
                                            in_barcode,             -- in_barcode           in      isi_scanner_cfg.scanner_daten%type,
                                            in_login_id);           -- in_login_id          in      isi_user.login_id%type)
end;

/*******************************************************************************
 * procedure LVS_C_LTE_ARTIKEL_ERZ_LGR_ORT(...)   mit COMMIT
 * Artikelnummer, Ziellagerort und Charge werden übergeben
 *******************************************************************************/
  procedure C_LTE_ARTIKEL_ERZ_LGR_ORT_TEXT(in_sid                 in isi_sid.sid%type,
                                          in_firma_nr            in isi_firma.firma_nr%type,
                                          in_lte_id              in lvs_lte.lte_id%type,
                                          in_artikel             in isi_artikel.artikel%type,
                                          in_menge_basis         in lvs_lam.menge_basis%type,
                                          in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                          in_charge              in lvs_charge.charge_bez%type,
                                          in_menge               in lvs_lam.menge%type,
                                          in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                          in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                          in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                          in_lte_name            in lvs_lte.lte_name%type,
                                          in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                          in_prod_datum          in lvs_lam.prod_datum%type,
                                          in_zug_datum           in lvs_lam.zug_datum%type,
                                          in_mhd                 in lvs_lam.lam_mhd%type,
                                          in_sep_nve             in lvs_lte.nve_nr%type,
                                          in_prod_nr             in lvs_lam.leitzahl%type,
                                          in_fa_ag               in lvs_lam.fa_ag%type,
                                          in_fa_upos             in lvs_lam.fa_upos%type,
                                          in_wa_status           in lvs_lam.labor_status%type,
                                          in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                          in_login_id            in isi_user.login_id%type,
                                          in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                                          in_lam_text            in lvs_lam.lam_text%type)
                                          is
  begin
    lvs_p_lte.LVS_C_LTE_ARTIKEL_ERZ_LGR_ORT(in_sid,                 -- in isi_sid.sid%type,
                                            in_firma_nr,            -- in isi_firma.firma_nr%type,
                                            in_lte_id,              -- in lvs_lte.lte_id%type,
                                            in_artikel,             -- in isi_artikel.artikel%type,
                                            in_menge_basis,         -- in lvs_lam.menge_basis%type,
                                            in_mengeneinheit_basis, -- in lvs_lam.mengeneinheit_basis%type,
                                            in_charge,              -- in lvs_charge.charge_bez%type,
                                            in_menge,               -- in lvs_lam.menge%type,
                                            in_lte_hoehe,           -- in lvs_lte.lte_vol_hoehe%type,
                                            in_lte_breite,          -- in lvs_lte.lte_vol_breite%type,
                                            in_lte_tiefe,           -- in lvs_lte.lte_vol_tiefe%type,
                                            in_lte_name,            -- in lvs_lte.lte_name%type,
                                            in_lte_gew_kg,          -- in lvs_lte.lte_akt_kg%type,
                                            in_prod_datum,          -- in lvs_lam.prod_datum%type,
                                            in_zug_datum,           -- in lvs_lam.zug_datum%type,
                                            in_mhd,                 -- in lvs_lam.lam_mhd%type,
                                            in_sep_nve,             -- in lvs_lte.nve_nr%type,
                                            in_prod_nr,             -- in lvs_lam.leitzahl%type,
                                            in_fa_ag,               -- in lvs_lam.fa_ag%type,
                                            in_fa_upos,             -- in lvs_lam.fa_upos%type,
                                            in_wa_status,           -- in lvs_lam.labor_status%type,
                                            in_lief_auftragnr,      -- in lvs_lte.res_string_statisch%type,
                                            in_login_id,            -- in isi_user.login_id%type,
                                            in_lgr_ort);            -- in lvs_lgr_ort.lgr_ort%type)
    update lvs_lam lam
       set lam.lam_text = in_lam_text
     where lam.lte_id = in_lte_id;

  end;

  procedure c_erzeuge_lte_lgr_ort(in_sid                  in isi_sid.sid%type,
                                  in_firma_nr             in isi_firma.firma_nr%type,
                                  in_artikel              in isi_artikel.artikel%type,
                                  in_charge               in lvs_charge.charge_bez%type,
                                  in_menge                in lvs_lam.menge%type,
                                  in_login_id             in isi_user.login_id%type,

                                  in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
                                  in_progr_nr             in isi_transport.progr_nr%TYPE,
                                  in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                  in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                  in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                  in_aktuelle_position    in lvs_lam.lam_text%type,
                                  out_lte_id              out lvs_lte.lte_id%type)
                                  is
  begin
    lvs_p_lte.LVS_C_LTE_ARTIKEL_ERZ_LGR_ORT(in_sid,                 -- in isi_sid.sid%type,
                                            in_firma_nr,            -- in isi_firma.firma_nr%type,
                                            NULL,                   -- in lvs_lte.lte_id%type,
                                            in_artikel,             -- in isi_artikel.artikel%type,
                                            NULL,                   -- in lvs_lam.menge_basis%type,
                                            NULL,                   -- in lvs_lam.mengeneinheit_basis%type,
                                            in_charge,              -- in lvs_charge.charge_bez%type,
                                            in_menge,               -- in lvs_lam.menge%type,
                                            NULL,                   -- in lvs_lte.lte_vol_hoehe%type,
                                            NULL,                   -- in lvs_lte.lte_vol_breite%type,
                                            NULL,                   -- in lvs_lte.lte_vol_tiefe%type,
                                            NULL,                   -- in lvs_lte.lte_name%type,
                                            NULL,                   -- in lvs_lte.lte_akt_kg%type,
                                            NULL,                   -- in lvs_lam.prod_datum%type,
                                            NULL,                   -- in lvs_lam.zug_datum%type,
                                            NULL,                   -- in lvs_lam.lam_mhd%type,
                                            NULL,                   -- in lvs_lte.nve_nr%type,
                                            NULL,                   -- in lvs_lam.leitzahl%type,
                                            NULL,                   -- in lvs_lam.fa_ag%type,
                                            NULL,                   -- in lvs_lam.fa_upos%type,
                                            NULL,                   -- in lvs_lam.labor_status%type,
                                            NULL,                   -- in lvs_lte.res_string_statisch%type,
                                            in_login_id,            -- in isi_user.login_id%type,
                                            in_lgr_ort);            -- in lvs_lgr_ort.lgr_ort%type)
    out_lte_id := lvs_p_lte.v_lvs_lte_id;
    update lvs_lam lam
       set lam.lam_text = in_aktuelle_position
     where lam.lte_id = lvs_p_lte.v_lvs_lte_id;
  end;

  procedure c_erzeuge_lte_einl_lgr_ort(in_sid                  in isi_sid.sid%type,
                                       in_firma_nr             in isi_firma.firma_nr%type,
                                       in_artikel              in isi_artikel.artikel%type,
                                       in_charge               in lvs_charge.charge_bez%type,
                                       in_menge                in lvs_lam.menge%type,
                                       in_login_id             in isi_user.login_id%type,
                                       in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
                                       in_fahrzeuge_IDs        in varchar2,
                                       in_prio                 in isi_transport.Prio%TYPE,
                                       in_progr_nr             in isi_transport.progr_nr%TYPE,
                                       in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                       in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                       in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                       in_aktuelle_position    in lvs_lam.lam_text%type,
                                       out_lte_id              out lvs_lte.lte_id%type,
                                       out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                       out_transport_id        out number,
                                       out_res_id              out isi_resource.res_id%type)
                                       is
    v_err                                 varchar2(100);
  begin
    v_err                                 := 'Raise';
    c_erzeuge_lte_einl_lgr_ort_v (in_sid,                  -- in isi_sid.sid%type,
                                  in_firma_nr,             -- in isi_firma.firma_nr%type,
                                  in_artikel,              -- in isi_artikel.artikel%type,
                                  in_charge,               -- in lvs_charge.charge_bez%type,
                                  in_menge,                -- in lvs_lam.menge%type,
                                  in_login_id,             -- in isi_user.login_id%type,
                                  in_lgr_ort,              -- in lvs_lgr_ort.lgr_ort%type,
                                  in_fahrzeuge_IDs,        -- in varchar2,
                                  in_prio,                 -- in isi_transport.Prio%TYPE,
                                  in_progr_nr,             -- in isi_transport.progr_nr%TYPE,
                                  in_quelle_Leer_progr_nr, -- in isi_transport.quelle_leer_progr_nr%TYPE,
                                  in_ziel_voll_Progr_nr,   -- in isi_transport.ziel_voll_progr_nr%TYPE,
                                  in_lgr_platz_quelle,     -- in lvs_lgr.lgr_platz%type,
                                  in_aktuelle_position,    -- in lvs_lam.lam_text%type,
                                  NULL,                    -- in lvs_lte.lte_vol_hoehe%type,
                                  NULL,                    -- in lvs_lte.lte_vol_breite%type,
                                  NULL,                    -- in lvs_lte.lte_vol_tiefe%type,
                                  out_lte_id,              -- out lvs_lte.lte_id%type,
                                  out_lgr_platz,           -- out lvs_lgr.lgr_platz%TYPE,
                                  out_transport_id,        -- out number,
                                  out_res_id,              -- out isi_resource.res_id%type);
                                  v_err);
  end;
  procedure c_erzeuge_lte_einl_lgr_ort_v (in_sid                  in isi_sid.sid%type,
                                          in_firma_nr             in isi_firma.firma_nr%type,
                                          in_artikel              in isi_artikel.artikel%type,
                                          in_charge               in lvs_charge.charge_bez%type,
                                          in_menge                in lvs_lam.menge%type,
                                          in_login_id             in isi_user.login_id%type,
                                          in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
                                          in_fahrzeuge_IDs        in varchar2,
                                          in_prio                 in isi_transport.Prio%TYPE,
                                          in_progr_nr             in isi_transport.progr_nr%TYPE,
                                          in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                          in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                          in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                          in_aktuelle_position    in lvs_lam.lam_text%type,
                                          in_lte_hoehe            in lvs_lte.lte_vol_hoehe%type,
                                          in_lte_breite           in lvs_lte.lte_vol_breite%type,
                                          in_lte_tiefe            in lvs_lte.lte_vol_tiefe%type,
                                          out_lte_id              out lvs_lte.lte_id%type,
                                          out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                          out_transport_id        out number,
                                          out_res_id              out isi_resource.res_id%type,
                                          io_error                in out varchar2)
                                          is

    v_art                                 isi_artikel%rowtype;
  begin
    if not isi_p_base.get_isi_artikel_by_nr(in_artikel, v_art)
    then
       RAISE_APPLICATION_ERROR(-20000-1, LC.ec_p1(LC.O_TP1_ARTIKEL_FEHLT, in_artikel));
    end if;

    lvs_p_lte.LVS_C_LTE_ARTIKEL_ERZ_LGR_ORT(in_sid,                 -- in isi_sid.sid%type,
                                            in_firma_nr,            -- in isi_firma.firma_nr%type,
                                            NULL,                   -- in lvs_lte.lte_id%type,
                                            in_artikel,             -- in isi_artikel.artikel%type,
                                            NULL,                   -- in lvs_lam.menge_basis%type,
                                            NULL,                   -- in lvs_lam.mengeneinheit_basis%type,
                                            in_charge,              -- in lvs_charge.charge_bez%type,
                                            in_menge,               -- in lvs_lam.menge%type,
                                            in_lte_hoehe,           -- in lvs_lte.lte_vol_hoehe%type,
                                            in_lte_breite,          -- in lvs_lte.lte_vol_breite%type,
                                            in_lte_tiefe,           -- in lvs_lte.lte_vol_tiefe%type,
                                            v_art.lte_name,         -- in lvs_lte.lte_name%type,
                                            NULL,                   -- in lvs_lte.lte_akt_kg%type,
                                            NULL,                   -- in lvs_lam.prod_datum%type,
                                            NULL,                   -- in lvs_lam.zug_datum%type,
                                            NULL,                   -- in lvs_lam.lam_mhd%type,
                                            NULL,                   -- in lvs_lte.nve_nr%type,
                                            NULL,                   -- in lvs_lam.leitzahl%type,
                                            NULL,                   -- in lvs_lam.fa_ag%type,
                                            NULL,                   -- in lvs_lam.fa_upos%type,
                                            NULL,                   -- in lvs_lam.labor_status%type,
                                            NULL,                   -- in lvs_lte.res_string_statisch%type,
                                            in_login_id,            -- in isi_user.login_id%type,
                                            in_lgr_ort);            -- in lvs_lgr_ort.lgr_ort%type)
    out_lte_id := lvs_p_lte.v_lvs_lte_id;
    update lvs_lam lam
       set lam.lam_text = in_aktuelle_position
     where lam.lte_id = lvs_p_lte.v_lvs_lte_id;
    commit;

    lvs_platz.lvs_c_transp_suche_einl_p_rid(lvs_p_lte.v_lvs_lte_id,          -- in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                            in_lgr_ort || ';',               -- in_lgr_orte             in varchar2,
                                            in_fahrzeuge_IDs,                -- in_fahrzeuge_IDs        in varchar2,
                                            'MFR',                           -- in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                            'MFR',                           -- in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                            in_login_ID,                     -- in_user_ID              in isi_user.login_id%TYPE,
                                            in_prio,                         -- in_prio                 in isi_transport.Prio%TYPE,
                                            in_progr_nr,                     -- in_progr_nr             in isi_transport.progr_nr%TYPE,
                                            in_quelle_Leer_progr_nr,         -- in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                            in_ziel_voll_Progr_nr,           -- in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                            in_lgr_platz_quelle,             -- in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                            in_aktuelle_position,            -- in_aktuelle_position    in lvs_lam.lam_text%type,
                                            out_lgr_platz,                   -- out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                            out_transport_id,                -- out_transport_id        out number,
                                            out_res_id);                     -- out_res_id              out isi_resource.res_id%type

    io_error := NULL;
  exception
    when others then
      out_lte_id := lvs_p_lte.v_lvs_lte_id;
      if upper(io_error) = 'RAISE'
      then
        raise;
      else
        io_error := SUBSTR(SQLERRM, 1, 4000);
      end if;

  end;

  ------------------------------------------------------------------------------------------------------------------------------------
  -- Procedure erzeugt Palette mit Artikel und Auslagerauftrag
  ------------------------------------------------------------------------------------------------------------------------------------
  procedure c_erzeuge_artikel_ausl_auf(in_sid                  in isi_sid.sid%type,
                                       in_firma_nr             in isi_firma.firma_nr%type,
                                       in_artikel              in isi_artikel.artikel%type,
                                       in_charge               in lvs_charge.charge_bez%type,
                                       in_menge                in lvs_lam.menge%type,
                                       in_login_id             in isi_user.login_id%type,
                                       in_lgr_orte             in varchar2,
                                       in_ziel                 in lvs_lgr.lgr_platz%type)
                                       is

    v_artikel                          isi_artikel%rowtype;
    v_charge_id                        lvs_charge.charge_id%type;
    v_order_auf_id                     lvs_lam.order_pos_auf_id%type;
    v_lte                              lvs_lte%rowtype;

    v_transp_id          isi_transport.transp_id%type;
    v_transp_gruppe      isi_transport.transport_gruppe%type;
    v_result                           number;

    CURSOR c_lte is
      select *
        from lvs_lte t
       where t.lte_id in (select distinct l.lte_id
                            from lvs_lam l
                           where l.sid = in_sid
                             and l.order_pos_auf_id = v_order_auf_id);
  begin

    if isi_p_base.get_isi_artikel_by_nr(in_artikel, v_artikel)
    then

      if in_charge is not NULL
      then
        v_charge_id := get_charge_id(in_sid,
                                     in_firma_nr,
                                     NULL,
                                     in_charge,
                                     v_artikel.artikel_id);
      else
        v_charge_id := NULL;
      end if;

      lvs_ausl.c_lam_suche_res_ausl(in_sid,                      --in_sid                  in lvs_lam.sid%type,
                                    in_firma_nr,                 -- in_firma_nr             in lvs_lam.firma_nr%type,
                                    v_artikel.artikel_id,        -- in_artikel_id           in lvs_lam.artikel_id%type,
                                    NULL,                        -- in_leitzahl             in lvs_lam.leitzahl%type,
                                    NULL,                        -- in_fa_ag                in lvs_lam.fa_ag%type,
                                    v_charge_id,                 -- in_charge_id            in lvs_lam.charge_id%type,
                                    NULL,                        -- in_seriennr_id          in lvs_lam.serie_id%type,
                                    NULL,                        -- in_mhd                  in lvs_lam.lam_mhd%type,
                                    NULL,                        -- in_zeichnung_index      in lvs_lam.zeichnung_index%type,
                                    in_lgr_orte,                 -- in_lgr_orte             in varchar2,
                                    nvl(in_menge, 1),            -- in_menge                in number,
                                    in_ziel,                     -- in_ziel_lgr_platz       in lvs_lgr.lgr_platz%type,
                                    NULL,                        -- in_komm_ziel_lte_name   in lvs_lte_cfg.lte_name%type,
                                    NULL,                        -- in_komm_ziel_lte_id     in lvs_lte.lte_id%type,
                                    NULL,                        -- in_komm_anz_lhm_pro_lte in number,
                                    v_order_auf_id,              -- io_order_auf_id         in out lvs_lam.order_pos_auf_id%type,
                                    in_login_id);                -- in_login_id             in isi_user.login_id%type) is

      OPEN c_lte;
      FETCH c_lte into v_lte;

      loop
        exit when c_lte%NOTFOUND;
        v_result := lvs_transport.lvs_transp_lte(in_sid, in_firma_nr, 'MFR', null, c.c_false, 'A',
                                                 in_login_id, v_order_auf_id, null, 3, 0, 0, 0,
                                                 v_lte.lgr_platz, in_ziel, v_lte.lte_id,
                                                 null, c.c_false, null, null, v_lte.order_vorgang_id, null, null,
                                                 v_transp_gruppe, v_transp_id);

        FETCH c_lte into v_lte;
      end loop;
      CLOSE c_lte;

    end if;
    commit;
  end;

  function pruefe_transport_f_ziel(in_ziel                 in varchar2)
                                   return varchar2 is
    v_anz_transporte               number;
  begin
    select count(*) into v_anz_transporte
      from isi_transport t
     where t.lgr_platz_ziel = in_ziel;
    if v_anz_transporte = 0
    then
      return(c.C_FALSE);
    else
      return (c.C_TRUE);
    end if;
  end;

  procedure c_we_lte_transp_einl_platz(in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                          in_lgr_orte             in varchar2,
                                          in_fahrzeuge_IDs        in varchar2,
                                          in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                          in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                          in_user_ID              in isi_user.login_id%TYPE,
                                          in_prio                 in isi_transport.Prio%TYPE,
                                          in_progr_nr             in isi_transport.progr_nr%TYPE,
                                          in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                          in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                          in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                          out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                          out_transport_id        out number) is
  begin
    lvs_platz.LVS_C_TRANSP_SUCHE_EINL_PLATZ(in_lte_id,
                                            in_lgr_orte,
                                            in_fahrzeuge_IDs,
                                            in_modul_erzeuger,
                                            in_modul_bearbeiter,
                                            in_user_ID,
                                            in_prio,
                                            in_progr_nr,
                                            in_quelle_Leer_progr_nr,
                                            in_ziel_voll_Progr_nr,
                                            in_lgr_platz_quelle,
                                            out_lgr_platz,
                                            out_transport_id);
  end;

  -------------------------------------------------------------------------------------------------------------
  -- Funktion dient zur Ermittlung, ob eine Palette bereits eingelagert wurde
  -- Falls nicht, dann wird der LTE-Name zurueckgegeben
  -- Dient bei Palletierern, dass leere Paletten zum Palettieren geholt werden koennen
  -------------------------------------------------------------------------------------------------------------
  function lte_anfordern_name (in_lte_sid             in lvs_lte.sid%TYPE,
                               in_lte_firma_nr        in lvs_lte.firma_nr%TYPE,
                               in_lte_id              in lvs_lte.lte_id%type)
                               return lvs_lte.lte_name%type is

    v_lte                      lvs_lte%rowtype;
  begin
    v_lte := NULL;
    if lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      if v_lte.lgr_platz is NULL     -- Palette noch nicht eingelagert
      then
        return v_lte.lte_name;
      end if;
    end if;
    return NULL;
  end;

  procedure c_art_id_suche_ausl(in_sid                  in lvs_lam.sid%type,
                                in_firma_nr             in lvs_lam.firma_nr%type,
                                in_artikel_id           in lvs_lam.artikel_id%type,
                                in_lager_orte           in varchar2,
                                in_ziel_lgr_platz       in lvs_lgr.lgr_platz%type,
                                in_login_id             in isi_user.login_id%type)
                                is

    v_order_auf_id              isi_order_pos.auf_id%type;

  begin
    lvs_ausl.c_lam_suche_res_ausl(in_sid,
                                  in_firma_nr,
                                  in_artikel_id,
                                  NULL,              -- in_leitzahl => :in_leitzahl,
                                  NULL,              -- in_fa_ag => :in_fa_ag,
                                  NULL,              -- in_charge_id => :in_charge_id,
                                  NULL,              -- in_seriennr_id => :in_seriennr_id,
                                  NULL,              -- in_mhd => :in_mhd,
                                  NULL,              -- in_zeichnung_index => :in_zeichnung_index,
                                  in_lager_orte,     -- in_lgr_orte => :in_lgr_orte,
                                  0,                 -- in_menge,
                                  in_ziel_lgr_platz,
                                  NULL,              -- in_komm_ziel_lte_name => :in_komm_ziel_lte_name,
                                  NULL,              -- in_komm_ziel_lte_id => :in_komm_ziel_lte_id,
                                  NULL,              -- in_komm_anz_lhm_pro_lte => :in_komm_anz_lhm_pro_lte,
                                  v_order_auf_id,    -- io_order_auf_id => :io_order_auf_id,
                                  in_login_id,
                                  c.C_TRUE);

  end;

  procedure c_art_nr_suche_ausl(in_sid                  in lvs_lam.sid%type,
                                in_firma_nr             in lvs_lam.firma_nr%type,
                                in_artikel              in isi_artikel.artikel%type,
                                in_lager_orte           in varchar2,
                                in_ziel_lgr_platz       in lvs_lgr.lgr_platz%type,
                                in_login_id             in isi_user.login_id%type)
                                is
    v_art                       isi_artikel%rowtype;
  begin
    if not isi_p_base.get_isi_artikel_by_nr(in_artikel, v_art)
    then
       RAISE_APPLICATION_ERROR(-20000-1, LC.ec_p1(LC.O_TP1_ARTIKEL_FEHLT, in_artikel));
    else
      c_art_id_suche_ausl(in_sid,
                          in_firma_nr,
                          v_art.artikel_id,
                          in_lager_orte,
                          in_ziel_lgr_platz,
                          in_login_id);
    end if;
  end;

  /*
  --------------------------------------------------------------------------------
  function c_transp_log
  Trägt einen Eintrag in die MFR_TRANP_LOG Tabelle ein und schließt die Transaktion ab.
  ---- HISTORY ---
  2013-11-12: (-WK-) in_sid und in_firma_nr (nach Absprache mit -BW-) aus
  der Tabelle entfernt, aber in der Funktion aus Abwärtskompatibilität
  noch beibehalten.
  2016-01-21: (-CM-) Anpassung: weitere Felder sind hinzugekommen.

  @param in_type                 Bewegungs Typ,
  @param in_element              Name des Elementes,
  @param in_source               Transport Quell Element,
  @param in_target               Transport Quell Element,
  @param in_origin_source        Aufsetzpunkt der Palette,
  @param in_final_dest           Endziel der Palette,
  @param in_lte_id               LTE ID%,
  @param in_mfr_unique_id        Unique Id,
  @param in_is_nio               Gibt an ob NIO Anliegt
  @param in_duration_sec         Gibt die gesamt LAufzeit des Auftrages in Sekunden an
  @param out_GUID                Gibt die generierte GUID zurück
  @commit
  --------------------------------------------------------------------------------
  */
  procedure c_transp_log(in_type                 in mfr_transp_log.type%type,
                         in_element              in mfr_transp_log.element%type,
                         in_source               in mfr_transp_log.source%type,
                         in_target               in mfr_transp_log.target%type,
                         in_origin_source        in mfr_transp_log.origin_source%type,
                         in_final_dest           in mfr_transp_log.final_dest%type,
                         in_lte_id               in mfr_transp_log.lte_id%type,
                         in_mfr_unique_id        in mfr_transp_log.mfr_unique_id%type,
                         in_is_nio               in mfr_transp_log.is_nio%type,
                         out_GUID                out mfr_transp_log.guid%type,
                         in_duration_sec         in mfr_transp_log.duration_sec%type) is
  begin
    insert into mfr_transp_log(
                element,
                source,
                target,
                type,
                lte_id,
                mfr_unique_id,
                origin_source,
                final_dest,
                is_nio,
                duration_sec
              ) values (
                in_element,
                in_source,
                in_target,
                in_type,
                in_lte_id,
                in_mfr_unique_id,
                in_origin_source,
                in_final_dest,
                in_is_nio,
                in_duration_sec
              ) returning GUID into out_GUID;
    commit;
  end;

    /*
  --------------------------------------------------------------------------------
  function c_transp_log_nio
  Trägt einen Eintrag in die mfr_transp_log_nio Tabelle ein und schließt die Transaktion ab.
  @param in_guid             GUID zum korrenspondieren Eintrag in mfr_transp_log
  @param in_nio_Bit_Index    NIO Bit Index
  @commit
  --------------------------------------------------------------------------------
  */
  procedure c_transp_log_nio (in_guid                 mfr_transp_log_nio.mfr_transp_log_id%type,
                              in_nio_Bit_Index       number) is

  v_nio_text_index mfr_transp_log_nio.nio_mt_index%type;

  begin

  v_nio_text_index := ((in_nio_Bit_Index + 1) / 100) + 1;

  insert into mfr_transp_log_nio(
          mfr_transp_log_id,
          nio_mt_index
         )values (
          in_guid,
          v_nio_text_index
         );
  commit;
  end;


  /*
  --------------------------------------------------------------------------------
  function c_transp_log_with_nio
  Fasst die Funktion C_transp_log und cc_transp_log_nio zusammen.
  ---- HISTORY ---
  2013-11-12: (-WK-) in_sid und in_firma_nr (nach Absprache mit -BW-) aus
  der Tabelle entfernt, aber in der Funktion aus Abwärtskompatibilität
  noch beibehalten.
  2016-01-21: (-CM-) Anpassung: weitere Felder sind hinzugekommen.

  @param in_type                 Bewegungs Typ,
  @param in_element              Name des Elementes,
  @param in_source               Transport Quell Element,
  @param in_target               Transport Quell Element,
  @param in_origin_source        Aufsetzpunkt der Palette,
  @param in_final_dest           Endziel der Palette,
  @param in_lte_id               LTE ID%,
  @param in_mfr_unique_id        Unique Id,
  @param in_is_nio               Gibt an ob NIO Anliegt
  @param in_nio_bits             Gibt an ob NIO Anliegt
  @param in_duration_sec         Gibt die gesamt LAufzeit des Auftrages in Sekunden an
  @param out_GUID                Gibt die generierte GUID zurück
  @commit
  --------------------------------------------------------------------------------
  */
  procedure c_transp_log_with_nio(in_type        in mfr_transp_log.type%type,
                         in_element              in mfr_transp_log.element%type,
                         in_source               in mfr_transp_log.source%type,
                         in_target               in mfr_transp_log.target%type,
                         in_origin_source        in mfr_transp_log.origin_source%type,
                         in_final_dest           in mfr_transp_log.final_dest%type,
                         in_lte_id               in mfr_transp_log.lte_id%type,
                         in_mfr_unique_id        in mfr_transp_log.mfr_unique_id%type,
                         in_is_nio               in mfr_transp_log.is_nio%type,
                         in_nio_bits             number,
                         out_GUID                out mfr_transp_log.guid%type,
                         in_duration_sec         in mfr_transp_log.duration_sec%type) is

    niobitindex Number;
    niobitmask Number;
  begin
    c_transp_log(in_type,
                 in_element,
                 in_source,
                 in_target,
                 in_origin_source,
                 in_final_dest,
                 in_lte_id,
                 in_mfr_unique_id,
                 in_is_nio,
                 out_GUID,
                 in_duration_sec);
    if in_nio_bits <> 0 then
      for niobitindex in  0 .. 15
      loop
        niobitmask := 1 * power(2,niobitindex);
        if  BitAnd(in_nio_bits, niobitmask )  = niobitmask then
          c_transp_log_nio (out_guid, niobitindex);
        end if;
      end loop;
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
  begin
    return(lvs_transport.lvs_check_transport_ziel(in_sid, in_firma_nr, in_transport_id));
  end lvs_check_transport_ziel;

  --------------------------------------------------------------------------------
  -- function c_erzeuge_artikel_id_ausl_auf_tms
  -- Sucht im Lager nach dem Artikel mit der Artikel_id und generiert einen
  -- Auslagertransport ohne Order !!!!!!
  -- Return: -0  = ok sonst <> 0
  --------------------------------------------------------------------------------

  function c_erzeuge_art_id_ausl_auf_tms(in_sid                  in lvs_lam.sid%type,
                                             in_firma_nr             in lvs_lam.firma_nr%type,
                                             in_artikel_id           in isi_artikel.artikel_id%type,
                                             in_lager_orte           in varchar2,
                                             in_ziel_lgr_platz       in lvs_lgr.lgr_platz%type,
                                             in_login_id             in isi_user.login_id%type,
                                             in_prio                 in isi_transport.prio%type
                                             )
                                             return NUMBER is

   v_transport_gruppe float;
   v_lte_id lvs_lte.lte_id%type;
   v_quell_lagerplatz lvs_lgr.lgr_platz%type;
   v_lgr_modul_bearbeiter lvs_lgr_ort.lgr_ort_modul%type;
   v_ausl_sort  number;
   v_ausl_sort2 number;
   p_result NUMBER;

   CURSOR c_Lte_Liste is
      select lte.lte_id,
             lte.lgr_platz,
             o.lgr_ort_modul,
             trunc(lvs_ausl.lvs_lte_platz_bewerten(m.sid,
                                             m.firma_nr,
                                             'FIFO',
                                             'I',
                                             lte.lte_voll,
                                             nvl(min(m.lam_mhd), lte.res_mhd),
                                             trunc(min(m.prod_datum)),
                                             lte.lte_id,
                                             lte.lgr_platz,
                                             lte.res_string,
                                             l.lgr_platz_gruppe,
                                             l.lgr_typ,
                                             m.artikel_id)) ausl_sort,
             lvs_ausl.lvs_lte_platz_bewerten(m.sid,
                                       m.firma_nr,
                                       'FIFO',
                                       'I',
                                       lte.lte_voll,
                                       nvl(min(m.lam_mhd),
                                           lte.res_mhd),
                                       trunc(min(m.prod_datum)),
                                       lte.lte_id,
                                       lte.lgr_platz,
                                       lte.res_string,
                                       l.lgr_platz_gruppe,
                                       l.lgr_typ,
                                       m.artikel_id) ausl_sort2
        from isi_artikel a,
             lvs_lam     m,
             lvs_charge  c,
             lvs_lgr     l,
             lvs_lgr_ort o,
             lvs_lte     lte
       where a.artikel_id = in_artikel_id
             and a.sid = in_sid
             and m.sid = a.sid
             and m.artikel_id = a.artikel_id(+)
             and c.charge_id(+) = m.charge_id
             and l.lgr_platz = m.lgr_platz
             and (
                   (l.lgr_verwendung = 'Lager' and lte.lte_status = 'LF')
                    or (l.lgr_verwendung = 'WE' and lte.lte_status = 'BF')
                    or (l.lgr_verwendung = 'LagerP' and l.lgr_dispo_einl_te = 0)
                  )
             and l.gesperrt = 'F'
             and o.sid = l.sid
             and o.firma_nr = l.firma_nr
             and o.lgr_ort = l.lgr_ort
             and lte.order_vorgang_id is null
             and lte.lte_id = m.lte_id
             and (instr(lvs_lager_opt.lvs_lort_format(in_lager_orte ), lpad(to_char(l.lgr_ort),  3                 - 1, '0') || ';') > 0)
       group by
             m.abnr,
             a.artikel_id,
             a.Bezeichnung2,
             a.artikel,
             m.mengeneinheit_basis,
             m.lgr_platz,
             a.reife_zeit_tage,
             m.labor_status,
             m.lam_p9,
             l.gesperrt,
             lte.res_mhd,
             l.lgr_platz_gruppe,
             l.lgr_dim_fifo_nr,
             l.gesperrt,
             l.uml_erlaubt,
             o.lgr_ort_modul,
             m.lte_id,
             c.charge_bez,
             lte.lte_id,
             lte.waren_typ,
             m.sid,
             m.firma_nr,
             lte.lte_voll,
       -- m.lam_mhd,
             lte.res_mhd,
       -- m.prod_datum,
             lte.lgr_platz,
             lte.res_string,
             l.lgr_platz_gruppe,
             l.lgr_typ,
             l.lgr_dim_p,
             m.artikel_id,
             lte.lte_letzte_buchung,
             lte.rowid
   order by  ausl_sort,
             ausl_sort2,
             lte.lte_letzte_buchung; -- FIFO

  begin
    p_result := -1;
    open c_lte_Liste;
    loop
      fetch c_Lte_Liste into v_lte_id,
                           v_quell_lagerplatz,
                           v_lgr_modul_bearbeiter,
                           v_ausl_sort,
                           v_ausl_sort2;


      exit when c_Lte_Liste%notfound;
      v_transport_gruppe := 0.0;
      p_result := lvs_platz.lvs_c_transp_lte(in_sid,      -- in sid
                                             in_firma_nr, -- firma_nr
                                             'MFR',        -- in_modul_erzeuger,
                                             v_lgr_modul_bearbeiter,       -- :modul_bearbeiter,
                                             'T',         --in_frei_fahren,
                                             'A',         --in_trans_typ,   // Typ OK??? Evtl U wen Ziel ein Lagerplatz oder LagerP
                                             in_login_id,
                                             null,        --in_auftrag_id, ' + CRLF +
                                             null,        --in_auftrag_id_extern, ' + CRLF +
                                             in_prio,
                                             1,           --in_progr_nr, ' + CRLF +
                                             1,           --in_quelle_leer_progr_nr, ' + CRLF +
                                             1,           --in_ziel_voll_progr_nr, ' + CRLF +
                                             v_quell_lagerplatz,
                                             in_ziel_lgr_platz,
                                             v_lte_id,     --:lte_id, ' + CRLF +
                                             null,         -- kunde_nr
                                             'F',         -- lieferschein, ' + CRLF + // Kein Lieferschein
                                             null,         -- :li_nr, ' + CRLF +
                                             null,         --in_li_pos_nr, ' + CRLF +
                                             null,         -- :tour_nr, --in_vorgang_id, ' + CRLF +
                                             null,         -- :lkw_nr, ' + CRLF +
                                             null,          --  :res_id, --in_fahrzeuge_ids, ' + CRLF +
                                             v_transport_gruppe);


      if p_result = 0                        -- Transport ist erzeugt
      then
        exit;
      end if;
    end loop;
    close c_lte_Liste;
  return(0);

  end c_erzeuge_art_id_ausl_auf_tms;

  --------------------------------------------------------------------------------
  -- function c_erzeuge_artikel_nr_ausl_auf_tms
  -- Sucht im Lager nach dem Artikel mit der Artikelnr und generiert einen
  -- Auslagertransport ohne Order !!!!!!
  -- Return: -0  = ok sonst <> 0
  --------------------------------------------------------------------------------

  function c_erzeuge_art_nr_ausl_auf_tms(in_sid                  in lvs_lam.sid%type,
                                          in_firma_nr             in lvs_lam.firma_nr%type,
                                          in_artikel              in isi_artikel.artikel%type,
                                          in_lager_orte           in varchar2,
                                          in_ziel_lgr_platz       in lvs_lgr.lgr_platz%type,
                                          in_login_id             in isi_user.login_id%type,
                                          in_prio                 in isi_transport.prio%type
                                )


                                return Number  is
  v_result  Number;
  v_art     isi_artikel%rowtype;


  begin
    v_result := -1;
    if not isi_p_base.get_isi_artikel_by_nr(in_artikel, v_art)
    then
       RAISE_APPLICATION_ERROR(-20000-1, LC.ec_p1(LC.O_TP1_ARTIKEL_FEHLT, in_artikel));
    else
      v_result := c_erzeuge_art_id_ausl_auf_tms(in_sid,
                                                 in_firma_nr,
                                                 v_art.artikel_id,
                                                 in_lager_orte,
                                                 in_ziel_lgr_platz,
                                                 in_login_id,
                                                 in_prio);
    end if;
    return(v_result);

  end c_erzeuge_art_nr_ausl_auf_tms;

  function lte_lhm_info(in_lte_id      in  lvs_lte.lte_id%type,
                                            out_akt_lhm    out number,
                                            out_max_lhm    out number
                                            )
                                            return varchar2 is


    -- local variables here
    v_lte              lvs_lte%rowtype;
    v_max              number;
    v_result           varchar2(1);

    CURSOR c_max_lhm is
          select max(pp.packschema_pos_nr)
            from lvs_packschema_pos pp
           where pp.packschema_kopf_id = v_lte.packschema_kopf_id;
  begin
    v_lte := null;
    if lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      out_akt_lhm := v_lte.lte_akt_lhm;
      out_max_lhm := NULL;
      OPEN c_max_lhm;
      FETCH c_max_lhm into out_max_lhm;
      CLOSE c_max_lhm;
      if out_max_lhm is NULL
      then
        out_max_lhm := v_lte.lte_akt_lhm + 1;
        v_result := c.C_FALSE;
      else
        v_result := c.C_FALSE;
        if out_max_lhm <= v_lte.lte_akt_lhm
        then
          v_result := c.C_TRUE;
        end if;
      end if;
    end if;
    return(v_result);
  end;

  -------------------------------------------------------------------------
  -- Traegt den transport eien Palette ein. Setzt alle DISPOS etc.
  -------------------------------------------------------------------------
  function c_lvs_transp_lte(in_sid                  in isi_sid.sid%TYPE,
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

    v_result              number;

  begin
    v_result := lvs_transport.lvs_transp_lte (in_sid,                                 -- '01'
                                              in_firma_nr,                            -- 1
                                              in_modul_erzeuger,                      -- MFR
                                              in_modul_bearbeiter,                    -- MFR
                                              in_frei_fahren,                          -- T
                                              in_trans_typ,                            -- 'A'
                                              in_user_id,                              -- -1
                                              in_auftrag_id,                           -- NULL
                                              in_auftrag_id_extern,                    -- NULL
                                              in_prio,                                 -- 5
                                              in_progr_nr,                             -- NULL
                                              in_quelle_leer_progr_nr,                 -- NULL
                                              in_ziel_voll_progr_nr,                   -- NULL
                                              in_lgr_quell_lgr_platz,                  -- Quellplatz z.B. PF2_11
                                              in_lgr_ziel_lgr_platz,                   -- 'Z_VS01'
                                              in_lte_id,                               -- LTE_ID z.B. 07300001
                                              in_kunde_nr,                             -- NULL
                                              in_lieferschein,                         -- 'F'
                                              in_li_nr,                                -- NULL
                                              in_li_pos_nr,                            -- NULL
                                              in_vorgang_id,                           -- NULL
                                              in_fahrzeuge_ids,                        -- NULL (Damit der MFR diesen Transport nicht in die A/U-Liste für RBG2 schreibt
                                              in_lkw_nr,                               -- NULL
                                              in_out_transport_gruppe,                 -- NULL
                                              out_transp_id,                           -- out_transport_id
                                              in_parent_transp_id,                     -- NULL
                                              in_fetig_bis);                           -- NULL
    if in_fahrzeuge_IDs is NULL
    then
      update isi_transport t
         set t.res_id = NULL                  -- Damit der Auftrag nich in die AU Liste kommt
       where t.transp_id = out_transp_id;
    end if;
    commit;
    return(v_result);
  end;
  -------------------------------------------------------------------------
  -- Traegt den transport eien Palette ein. Setzt alle DISPOS etc.
  -- Erweiterung PAZ mit KOMM Feldern
  -------------------------------------------------------------------------
  function lvs_c_transp_lte_353(in_sid                     in isi_sid.sid%type,
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
                                in_kunde_nr                in lvs_lam.kunden_nr%TYPE,
                                in_lieferschein            in isi_transport.lieferschein%type,
                                in_li_nr                   in isi_transport.li_nr%type,
                                in_li_pos_nr               in isi_transport.li_pos_nr%type,
                                in_vorgang_id              in isi_transport.vorgang_id%type,
                                in_lkw_nr                  in isi_transport.lkw_nr%type,
                                in_fahrzeuge_IDs           in varchar2,
                                in_komm_id                 in isi_transport.p_komm_id%type,
                                in_komm_lte_lhm_lagen      in isi_transport.p_komm_lte_lhm_lagen%type,
                                in_komm_lte_lhm_pro_lage   in isi_transport.p_komm_lte_lhm_pro_lage%type,
                                in_komm_lhm_hoehe_lage     in isi_transport.p_komm_lhm_hoehe_lage%type,
                                in_komm_packscheme_kopf_id in isi_transport.p_komm_packschema_kopf_id%type,
                                in_out_transport_gruppe    in out isi_transport.transport_gruppe%type)
                                return number is

    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    v_transp_id isi_transport.transp_id%type;
    v_result    number;
  begin
    -- Lesen der Artikeldaten
    v_err_nr   := NULL;
    v_err_text := NULL;
    v_result   := lvs_transport.lvs_transp_lte_353(in_sid,
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
                                                   in_fahrzeuge_IDs,
                                                   in_lkw_nr,
                                                   in_komm_id,
                                                   in_komm_lte_lhm_lagen,
                                                   in_komm_lte_lhm_pro_lage,
                                                   in_komm_lhm_hoehe_lage,
                                                   in_komm_packscheme_kopf_id,
                                                   in_out_transport_gruppe,
                                                   v_transp_id);

    commit;
    return(v_result);
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


  procedure c_import_mfr_element is

    v_fahrzeug         mfr_import.mfr_element_name%TYPE;
    v_fahrzeug_test    mfr_import.mfr_element_name%TYPE;
    v_pos_nr           mfr_import.pos_nr%TYPE;
    v_last_index       number;
    v_found            boolean;
    v_mfr_import       mfr_import%ROWTYPE;

   CURSOR c_max_element_id is
   select max(element_id)
     from mfr_element_cfg;

   CURSOR c_import_mfr_element is
   select t.mfr_element_name,
          t.pos_nr
     from mfr_import t;

   CURSOR c_check_element_available is
   select elem.fahrzeug
     from mfr_element_cfg elem
    where elem.fahrzeug = v_fahrzeug;
  begin

    v_last_index := 0;

    OPEN c_max_element_id;
    FETCH c_max_element_id into v_last_index;
    v_found := c_max_element_id%FOUND;
    CLOSE c_max_element_id;

    if not v_found or
       v_last_index is null
    then
       v_last_index := 0;
    end if;

    OPEN c_import_mfr_element;
    FETCH c_import_mfr_element into v_mfr_import;

      loop
        exit when c_import_mfr_element%NOTFOUND;

        v_fahrzeug := v_mfr_import.mfr_element_name;
        v_pos_nr := v_mfr_import.pos_nr;

        if v_pos_nr is null
        then
          v_pos_nr := 0;
        end if;

        OPEN c_check_element_available;
        FETCH c_check_element_available into v_fahrzeug_test;
        v_found := c_check_element_available%FOUND;
        CLOSE c_check_element_available;

        if not v_found
        then
           insert into mfr_element_cfg
                  (sid,
                   firma_nr,
                   engine_id,
                   reset_gruppen_id,
                   Element_id,
                   enabled,
                   editor_sperre,
                   element_typ,
                   fahrzeug_ix,
                   Fahrzeug,
                   gewerke_nr,
                   pos_nr)
           values
                  ('01',
                   1,
                   1,  -- engine_id
                   1, --Reset_gruppen_id
                   v_last_index,
                   'T',
                   'F',
                   0,   --element_typ
                   v_last_index,
                   v_fahrzeug,
                   1, -- gewerke_nr,
                   v_pos_nr); -- pos_nr);
            v_last_index := v_last_index + 1;
        end if;

        FETCH c_import_mfr_element into v_mfr_import;
      end loop;

      CLOSE c_import_mfr_element;
  end;
  -------------------------------------------------------------------------
  -- Trägt neue leere Elemente in MFR_ELEMENT_CFG ein für Verwendung MFR Konfigurator !!!
  -------------------------------------------------------------------------
  function c_add_empty_mfr_element_cfg(
                            in_count                in number,
                            in_element_name         in mfr_element_cfg.fahrzeug%TYPE, --'RB11_'  'RB11_401'
                            in_start_elem_pos_nr    in number,                        -- 401
                            in_start_pos_nr         in number)                        -- 11401
                            return boolean is

    v_result              number;
    v_element_id          number;
    c                     number;
    Fahrzeug_name         mfr_element_cfg.fahrzeug%TYPE;
    v_elem_pos_nr         number;
    v_pos_nr              number;
    v_found               boolean;

    CURSOR c_max_element_id is
      select max(element_id)
        from mfr_element_cfg;

  begin
    v_element_id := -1;
    v_elem_pos_nr := in_start_elem_pos_nr;
    v_pos_nr := in_start_pos_nr;
    OPEN c_max_element_id;
    FETCH c_max_element_id into v_element_id;
    v_found := c_max_element_id%FOUND;
    CLOSE c_max_element_id;

    if not v_found or
       v_element_id is null then
      v_element_id := -1;
    end if;

    FOR c IN 0..in_count -1
    LOOP
       v_element_id := v_element_id +1;
       if in_element_name is null then
         Fahrzeug_name := 'ix_' || To_char(v_element_id);
         v_elem_pos_nr := 0;
       else
         Fahrzeug_name := in_element_name || To_char(v_elem_pos_nr);
       end if;
       insert into mfr_element_cfg
              (sid,
               firma_nr,
               engine_id,
               reset_gruppen_id,
               Element_id,
               enabled,
               editor_sperre,
               element_typ,
               fahrzeug_ix,
               Fahrzeug,
               gewerke_nr,
               pos_nr,
               telegr_fc,
               telegr_fe_id_anfang,
               telegr_fe_id_ende)
       values
              ('01',
               1,
               1,  -- engine_id
               1, --Reset_gruppen_id
               v_element_id,
               'T',
               'F',
               0,   --element_typ
               v_element_id,
               Fahrzeug_name,
               1, -- gewerke_nr,
               v_pos_nr,
               v_pos_nr,
               v_pos_nr,
               v_pos_nr); -- pos_nr);
        v_elem_pos_nr := v_elem_pos_nr + 1;
        v_pos_nr := v_pos_nr + 1;
    END LOOP;
    commit;
    return(true);
  end;


  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- jedoch ohne Berücksichtigung von Fahrzeugen
  -------------------------------------------------------------------------
  procedure C_TRANSP_SUCHE_EINL_P_RID_LTE(in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                          in_lgr_orte             in varchar2,
                                          in_fahrzeuge_IDs        in varchar2,
                                          in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                          in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                          in_user_ID              in isi_user.login_id%TYPE,
                                          in_prio                 in isi_transport.Prio%TYPE,
                                          in_progr_nr             in isi_transport.progr_nr%TYPE,
                                          in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                          in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                          in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                          in_aktuelle_position    in lvs_lam.lam_text%type,
                                          in_lte_hoehe            in lvs_lte.lte_vol_hoehe%type,
                                          in_lte_breite           in lvs_lte.lte_vol_breite%type,
                                          in_lte_tiefe            in lvs_lte.lte_vol_tiefe%type,
                                          in_lte_name             in lvs_lte.lte_name%type,
                                          in_lte_gew_kg           in lvs_lte.lte_akt_kg%type,
                                          out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                          out_transport_id        out number,
                                          out_res_id              out isi_resource.res_id%type
                                          ) is
    --
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    v_lte                                 lvs_lte%rowtype;
    v_lgr                                 lvs_lgr%rowtype;
  begin
    lvs_platz.v_fahrz_res_id := NULL;

    if  lvs_p_base.get_lte(in_lte_id, v_lte) -- Lesen der LTE
    and v_lte.lte_status in (c.LTE_BF_STAT, c.LTE_BS_STAT, c.LTE_PF_STAT, c.LTE_KF_STAT, c.LTE_AF_STAT, c.LTE_AG_STAT)
    then
      Change_Lte_Properties(
                        v_lte,                  -- in lvs_lte%rowtype,
                        in_lte_name,            -- in lvs_lte.lte_name%type,
                        in_lte_hoehe,           -- in lvs_lte.lte_vol_hoehe%type,
                        in_lte_breite,          -- in lvs_lte.lte_vol_breite%type,
                        in_lte_tiefe,           -- in lvs_lte.lte_vol_tiefe%type,
                        in_lte_gew_kg,          -- in lvs_lte.lte_akt_kg%type,
                        NULL,                   -- in lvs_lte.wickelprogramm%type,
                        NULL                    -- in lvs_lte.auto_depal%type
                        );
      begin
        if (   v_lte.lte_status = c.LTE_BF_STAT -- Palette stheht auf enem WE oder WA mit bestand und wurde vom MFR mit ID Gelesen
            or v_lte.lte_status = c.LTE_AF_STAT
            or v_lte.lte_status = c.LTE_AF_STAT
           )
        and v_lte.lgr_platz != in_aktuelle_position        -- Palette sthet nicht auf übergebenen Platz (Wenn PLatz in LTE NULL dann unwahr
        then
          if lvs_p_base.get_lgr_platz(in_aktuelle_position, v_lgr) -- Ist der Platz im LVS vorhanden
          then                                                     -- Dann umbuchen auf den Platz
            lvs_transport.lvs_lte_transport(in_lte_id, v_lte.lgr_platz, in_aktuelle_position, -1);
          end if;
        end if;
      exception
        -- Fehlerfall immer ignorieren, Palette bleibt wo sie ist und wird dann vesucht einzulagern
        when others then NULL;
      end;
    end if;

    lvs_platz.lvs_c_transp_suche_einl_p_oq(in_lte_id, -- in LVS_LTE.LTE_ID%TYPE,
                                           in_lgr_orte, -- in varchar2,
                                           in_fahrzeuge_IDs, --        in varchar2,
                                           in_modul_erzeuger, -- in isi_transport.Modul_Erzeuger%TYPE,
                                           in_modul_bearbeiter, -- in isi_transport.Modul_Bearbeiter%TYPE,
                                           in_user_ID, -- in isi_user.login_id%TYPE,
                                           in_prio, -- in isi_transport.Prio%TYPE,
                                           in_progr_nr, -- in isi_transport.progr_nr%TYPE,
                                           in_quelle_Leer_progr_nr, -- in isi_transport.quelle_leer_progr_nr%TYPE,
                                           in_ziel_voll_Progr_nr, -- in isi_transport.ziel_voll_progr_nr%TYPE,
                                           in_lgr_platz_quelle, -- in lvs_lgr.lgr_platz%type,
                                           in_aktuelle_position, -- in_aktuelle_position    in lvs_lam.lam_text%type,
                                           out_lgr_platz, -- out lvs_lgr.lgr_platz%TYPE,
                                           out_transport_id); -- out number;
    out_res_id := lvs_platz.v_fahrz_res_id;
    -- Achtung das Commit uebernimmt die gerufene Procedure
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
  end C_TRANSP_SUCHE_EINL_P_RID_LTE;


   function get_doc_elem_text(in_mfr_element_id in mfr_element_cfg.element_id%type)
     return varchar2 is
  v_text  varchar2(5000);
  c_header varchar2(150) := 'Name;       Typ;       FC; FE_ID;        Quell-Bahn;   Ziel-Bahn; B-Info; Beschreibung' || cr_lf;
  begin
    v_text := '';

    select stradd_cr( ma.fahrzeug || '; ' ||  'AT;' || ma.telegr_fc || '; '|| ma.telegr_fe_id_anfang || '; ' || ma.telegr_fe_id_anfang || '; ' || '; '
         || mq.telegr_fe_id_ende
     || '; ' || mq.telegr_fe_id_ende ||';' || decode(w.Ziel_Element_id - ma.element_id, 0, ' Aufnahme', ' Abgabe'))

    into v_text

-- Nur Test Ausgabe
--     , ma.pos_nr, mq.pos_nr quell_pos_nr, mz.pos_nr ziel_pos_nr,
 --     w.Quell_element_id Quell_Weg_Quelle, w.Ziel_element_id Quell_Weg_Ziel , w.Quell_element_Id Ziel_Weg_Quelle, w.Ziel_element_Id Ziel_Weg_Ziel
     from
        mfr_element_cfg ma ,
        mfr_element_cfg mq ,
        mfr_element_cfg mz ,

        mfr_wege w
     where
        ma.Element_ID = in_mfr_element_id and
        --m.Element_id = wq.Ziel_Element_Id (+)  and
        (ma.Element_id = w.Ziel_Element_Id   or
        ma.Element_id = w.Quell_element_ID)  and
        w.Quell_Element_ID = mq.Element_Id(+)  and
        w.Ziel_Element_id = mz.Element_Id(+)
        order by ma.pos_nr, mq.pos_nr, mz.pos_nr;


     return(c_header || v_text);
  end;

-------------------------------------------------------------------------
-- Mit dieser Funktion können Änderungen an einer Lte vorgenommen werden.
-- diese dürfen auch während einer Einlagerung vorgenommen werden.
  procedure C_Change_Lte_Properties(
                            in_lte_id               in lvs_lte.lte_id%type,
                            in_lte_name             in lvs_lte.lte_name%type,
                            in_lte_hoehe            in lvs_lte.lte_vol_hoehe%type,
                            in_lte_breite           in lvs_lte.lte_vol_breite%type,
                            in_lte_tiefe            in lvs_lte.lte_vol_tiefe%type,
                            in_lte_gewicht          in lvs_lte.lte_akt_kg%type,
                            in_wickelprogramm       in lvs_lte.wickelprogramm%type,
                            in_auto_depal           in lvs_lte.auto_depal%type
                            ) is
  v_error EXCEPTION;
  v_err_nr   number;
  v_err_text varchar2(255);
  v_lte lvs_lte%Rowtype;
  begin
    if lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      Change_Lte_Properties(
                            v_lte,                  -- in lvs_lte%rowtype,
                            in_lte_name,            -- in lvs_lte.lte_name%type,
                            in_lte_hoehe,           -- in lvs_lte.lte_vol_hoehe%type,
                            in_lte_breite,          -- in lvs_lte.lte_vol_breite%type,
                            in_lte_tiefe,           -- in lvs_lte.lte_vol_tiefe%type,
                            in_lte_gewicht,         -- in lvs_lte.lte_akt_kg%type,
                            in_wickelprogramm,      -- in lvs_lte.wickelprogramm%type,
                            in_auto_depal           -- in lvs_lte.auto_depal%type
                            );
    end if;
    commit;
  end C_Change_Lte_Properties;

  procedure Change_Lte_Properties(
                            in_lte                  in lvs_lte%rowtype,
                            in_lte_name             in lvs_lte.lte_name%type,
                            in_lte_hoehe            in lvs_lte.lte_vol_hoehe%type,
                            in_lte_breite           in lvs_lte.lte_vol_breite%type,
                            in_lte_tiefe            in lvs_lte.lte_vol_tiefe%type,
                            in_lte_gewicht          in lvs_lte.lte_akt_kg%type,
                            in_wickelprogramm       in lvs_lte.wickelprogramm%type,
                            in_auto_depal           in lvs_lte.auto_depal%type
                            ) is
  v_error EXCEPTION;
  v_err_nr   number;
  v_err_text varchar2(255);
  begin
    -- Update der LTE-Daten
    update lvs_lte lte
       set lte.lte_name = nvl(in_lte_name, lte.lte_name),
           lte.lte_vol_hoehe = nvl(in_lte_hoehe, lte.lte_vol_hoehe),
           lte.lte_vol_breite = nvl(in_lte_breite, lte.lte_vol_breite),
           lte.lte_vol_tiefe = nvl(in_lte_tiefe, lte.lte_vol_tiefe),
           lte.lte_vol = nvl(in_lte_tiefe, lte.lte_vol_tiefe) * nvl(in_lte_hoehe, lte.lte_vol_hoehe) * nvl(in_lte_breite, lte.lte_vol_breite) / 1000000000,
           lte.lte_akt_kg = nvl(in_lte_gewicht, lte.lte_akt_kg),
           lte.wickelprogramm = nvl(in_wickelprogramm, lte.wickelprogramm),
           lte.auto_depal = nvl(in_auto_depal, lte.auto_depal)
     where lte.lte_id = in_lte.Lte_id;

    -- LTE steht auf einem Lagerpltz, dann Gewicht und Höhen prüfen
    if in_lte.lgr_platz is not NULL
    then
      if in_lte_gewicht != in_lte.lte_akt_kg
      then
        update lvs_lgr lgr
           set lgr.lgr_akt_kg = lgr.lgr_akt_kg + in_lte.lte_akt_kg - in_lte_gewicht
         where lgr.lgr_platz = in_lte.lgr_platz;
      end if;
      if in_lte_hoehe != in_lte.lte_vol_hoehe
      then
        update lvs_lgr lgr
           set lgr.lgr_frei_hoehe = lgr.lgr_frei_hoehe + in_lte.lte_vol_hoehe - in_lte_hoehe
         where lgr.lgr_platz = in_lte.lgr_platz
           and lgr.lgr_typ in (c.REG_FACH1, c.STAP_FLAE1, c.STAP_FLAE2);
      end if;
    end if;
    -- LTE hat ein Ziel, dann Gewicht und Höhen prüfen in Quelle und Ziel anpasse (DISPO)
    if in_lte.ziel_lgr_platz is not NULL
    then
      if in_lte_gewicht != in_lte.lte_akt_kg
      then
        update lvs_lgr lgr
           set lgr.lgr_dispo_ausl_kg = lgr.lgr_dispo_ausl_kg + in_lte.lte_akt_kg - in_lte_gewicht
         where lgr.lgr_platz = in_lte.lgr_platz;
        update lvs_lgr lgr
           set lgr.lgr_dispo_einl_kg = lgr_dispo_einl_kg + in_lte.lte_akt_kg - in_lte_gewicht
         where lgr.lgr_platz = in_lte.ziel_lgr_platz;
      end if;
      if in_lte_hoehe != in_lte.lte_vol_hoehe
      then
        update lvs_lgr lgr
           set lgr.lgr_dispo_einl_frei_hoehe = lgr.lgr_dispo_einl_frei_hoehe + in_lte.lte_vol_hoehe - in_lte_hoehe
         where lgr.lgr_platz = in_lte.lgr_platz
           and lgr.lgr_typ in (c.REG_FACH1, c.STAP_FLAE1, c.STAP_FLAE2);
      end if;
    end if;
  end Change_Lte_Properties;


-------------------------------------------------------------------------
-- Mit dieser Funktion wird der Zielplatz mit den LTE-Daten geprüft. Wenn dies einen Fehler ergibt,
-- dann muss der Transport gelöscht werden, weil z.B. keine Einlagerung mit den geänderten Daten möglich ist.
-- Der Transport wird gelöscht gelöscht, der Grund wird zurückgegeben.
  function c_pruef_einl_err_text_del_t(in_lte_id            in lvs_lte.lte_id%type,
                                       in_lgr_platz         in lvs_lgr.lgr_platz%type,
                                       in_fahrzeuge_IDs     in varchar2,
                                       in_transport_id      in isi_transport.transp_id%type)
                                       return varchar2 is
  v_lte                                   lvs_lte%rowtype;
  v_lgr                                   lvs_lgr%rowtype;

  v_lte_cfg            lvs_lte_cfg%rowtype;
  v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

  v_res_number         number;
  v_result             varchar2(2000);

  CURSOR c_lte_cfg is
    select t.*
      from lvs_lte_cfg t
     where t.sid = v_lte.sid
       and t.firma_nr = v_lte.firma_nr
       and t.lte_name = v_lte.lte_name;

  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.lte_id = in_lte_id;

  CURSOR c_lgr is
    select *
      from lvs_lgr lgr
     where lgr.lgr_platz = in_lgr_platz;

  begin
    OPEN c_lte;
    FETCH c_lte into v_lte;
    CLOSE c_lte;

    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    CLOSE c_lgr;

    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;
    CLOSE c_lte_cfg;

    v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
    v_result := lvs_platz.lvs_platz_einl_pruef_err_text(v_lte, v_basis_lte_name, v_lte_cfg.flaechen_stellplatz_erf, v_lgr, in_fahrzeuge_IDs);

    if v_result is not NULL
    then
      v_res_number := lvs_transport.lvs_transp_loeschen(v_lte.sid, v_lte.firma_nr, -1, in_transport_id, c.c_true);
    end if;

    commit;
    return(v_result);

  end;

  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- jedoch ohne Berücksichtigung von Fahrzeugen
  -------------------------------------------------------------------------
  procedure C_TRANSP_DEPAL_LTE(in_lte_id                   in LVS_LTE.LTE_ID%TYPE,
                               in_lgr_ort                  in lvs_lgr_ort.lgr_ort%type,
                               in_modul_erzeuger           in isi_transport.Modul_Erzeuger%TYPE,
                               in_modul_bearbeiter         in isi_transport.Modul_Bearbeiter%TYPE,
                               in_user_ID                  in isi_user.login_id%TYPE,
                               in_prio                     in isi_transport.Prio%TYPE,
                               in_aktuelle_position        in lvs_lam.lam_text%type,
                               in_lte_hoehe                in lvs_lte.lte_vol_hoehe%type,
                               in_lte_breite               in lvs_lte.lte_vol_breite%type,
                               in_lte_tiefe                in lvs_lte.lte_vol_tiefe%type,
                               in_lte_name                 in lvs_lte.lte_name%type,
                               in_lte_gew_kg               in lvs_lte.lte_akt_kg%type,
                               in_komm_lgr_platz           in lvs_lgr.lgr_platz%TYPE,
                               in_ziel_packschema_kopf_id  in lvs_packschema_kopf.packschema_kopf_id%type,
                               out_transport_id            out number,
                               out_p_komm_id               out number
                               ) is
    --
    v_error EXCEPTION;
    v_err_nr   number;
    v_err_text varchar2(255);

    v_artikel_id               lvs_lam.artikel_id%type;
    v_charge_id                lvs_lam.charge_id%type;
    v_prod_datum               lvs_lam.prod_datum%type;
    v_zug_datum                lvs_lam.zug_datum%type;
    v_menge                    lvs_lam.menge%type;
    v_lam_kg                   lvs_lam.lam_kg%type;
    v_labor_status             lvs_lam.labor_status%type;
    v_lam_sel1                 lvs_lam.lam_sel1%type;
    v_lam_sel2                 lvs_lam.lam_sel2%type;
    v_lam_sel3                 lvs_lam.lam_sel3%type;
    v_lam_sel4                 lvs_lam.lam_sel4%type;
    v_lam_sel5                 lvs_lam.lam_sel5%type;
    v_lam_sel6                 lvs_lam.lam_sel6%type;
    v_lam_sel7                 lvs_lam.lam_sel7%type;
    v_lam_sel8                 lvs_lam.lam_sel8%type;
    v_lam_sel9                 lvs_lam.lam_sel9%type;
    v_lam_sel10                lvs_lam.lam_sel10%type;
    v_lhm_hoehe                lvs_lhm.lhm_vol_hoehe%type;
    v_lhm_menge                lvs_lam.menge%type;


    v_lte                                 lvs_lte%rowtype;
    v_lgr                                 lvs_lgr%rowtype;
    v_artikel                             isi_artikel%rowtype;

    v_auf_id_extern                       isi_order_pos.auf_id_extern%type;
    v_auf_id                              isi_order_pos.auf_id%type;
    v_li_nr                               number;
    v_lhm_je_lage                         number;
    v_lte_lagen                           number;
    v_quell_lte_lagen                     number;
    v_lte_anz                             number;
    v_abnr                                lvs_lam.abnr%type;
    v_abnr_num                            number;
    v_komm_id                             isi_komm_order.komm_id%type;

    v_transport_gruppe       isi_transport.transport_gruppe%type;
    v_komm_lgr_platz         lvs_lgr.lgr_platz%type;

    CURSOR c_lam is
      select t.artikel_id,
             t.charge_id,
             min(t.prod_datum),
             t.zug_datum,
             sum(t.menge),
             sum(t.lam_kg),
             min(t.abnr),
             t.labor_status,
             t.lam_sel1,
             t.lam_sel2,
             t.lam_sel3,
             t.lam_sel4,
             t.lam_sel5,
             t.lam_sel6,
             t.lam_sel7,
             t.lam_sel8,
             t.lam_sel9,
             t.lam_sel10,
             max(lhm.lhm_vol_hoehe),
             min(t.menge)
        from lvs_lam t,
             lvs_lhm lhm
       where t.lte_id = in_lte_id
         and t.lhm_id = lhm.lhm_id
       group by  t.artikel_id,
                 t.charge_id,
                 t.zug_datum,
                 t.labor_status,
                 t.lam_sel1,
                 t.lam_sel2,
                 t.lam_sel3,
                 t.lam_sel4,
                 t.lam_sel5,
                 t.lam_sel6,
                 t.lam_sel7,
                 t.lam_sel8,
                 t.lam_sel9,
                 t.lam_sel10;

    CURSOR c_order_pos is
     select pos.auf_id
       from isi_order_pos pos
      where pos.auf_id_extern = v_auf_id_extern;

    CURSOR c_komm_lgr_platz is
      select l.lgr_platz
        from isi_resource r,
             lvs_lgr l
       where r.parent_res_id = (select x.parent_res_id from isi_resource x
                                 where x.res_name = in_komm_lgr_platz)
         and (r.kategorie_typ = 'LTE_LHM'
           or r.kategorie_typ = 'LHM')
         and r.res_name = l.lgr_platz
         and l.lgr_verwendung = 'WE';


  begin
    open c_lam;
    fetch c_lam into v_artikel_id,
                     v_charge_id,
                     v_prod_datum,
                     v_zug_datum,
                     v_menge,
                     v_lam_kg,
                     v_abnr,
                     v_labor_status,
                     v_lam_sel1,
                     v_lam_sel2,
                     v_lam_sel3,
                     v_lam_sel4,
                     v_lam_sel5,
                     v_lam_sel6,
                     v_lam_sel7,
                     v_lam_sel8,
                     v_lam_sel9,
                     v_lam_sel10,
                     v_lhm_hoehe,
                     v_lhm_menge;
    if c_lam%rowcount > 1 -- Es gibt mehr als einen Eintrag
    then
      close c_lam;
      RAISE_APPLICATION_ERROR(-20000-c.FMID_Falscher_LTE_Status, LC.ec_p1(LC.O_TP1_LTE_HAT_MEHR_EINE_LHM, in_lte_id));
    end if;
    close c_lam;
    begin
      v_abnr_num := v_abnr;
    exception
      when others then v_abnr_num := null;
    end;

    if  lvs_p_base.get_lte(in_lte_id, v_lte) -- Lesen der LTE
    then
      if not isi_p_base.get_isi_artikel(v_lte.sid, v_artikel_id, v_artikel)
      then
        RAISE_APPLICATION_ERROR(-20000-c.FMID_Artikelnummer_Fehlt, LC.ec_p1(LC.O_TP1_ARTIKEL_FEHLT, v_artikel.artikel));
      end if;
      if (   v_lte.lte_status = c.LTE_KF_STAT -- Palette stheht nicht der aktuellen Position mit Bestand
          or v_lte.lte_status = c.LTE_PF_STAT
          or v_lte.lte_status = c.LTE_AF_STAT
         )
      then
        if v_lte.lgr_platz != in_aktuelle_position        -- Palette sthet nicht auf übergebenen Platz (Wenn PLatz in LTE NULL dann unwahr
        or v_lte.lgr_platz is NULL
        then
          if lvs_p_base.get_lgr_platz(in_aktuelle_position, v_lgr) -- Ist der Platz im LVS vorhanden
          then                                                     -- Dann umbuchen auf den Platz
            lvs_transport.lvs_lte_transport(in_lte_id, v_lte.lgr_platz, in_aktuelle_position, in_user_ID);
          else
            RAISE_APPLICATION_ERROR(-20000-c.FMID_Lte_falscher_Platz, LC.ec_p2(LC.O_TP2_LTE_BUCH_PLATZ_ERR, in_lte_id, in_aktuelle_position));
          end if;
        end if;
      end if;
    else
      RAISE_APPLICATION_ERROR(-20000-c.FMID_LTE_ID_Fehlt, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
    end if;

    if  lvs_p_base.get_lte(in_lte_id, v_lte) -- Lesen der LTE
    and v_lte.lte_status in (c.LTE_BF_STAT, c.LTE_BS_STAT, c.LTE_PF_STAT, c.LTE_KF_STAT, c.LTE_AF_STAT, c.LTE_AG_STAT)
    then
      Change_Lte_Properties(
                        v_lte,                  -- in lvs_lte%rowtype,
                        in_lte_name,            -- in lvs_lte.lte_name%type,
                        in_lte_hoehe,           -- in lvs_lte.lte_vol_hoehe%type,
                        in_lte_breite,          -- in lvs_lte.lte_vol_breite%type,
                        in_lte_tiefe,           -- in lvs_lte.lte_vol_tiefe%type,
                        in_lte_gew_kg,          -- in lvs_lte.lte_akt_kg%type,
                        NULL,                   -- in lvs_lte.wickelprogramm%type,
                        NULL                    -- in lvs_lte.auto_depal%type
                        );
    end if;


    select SEQ_S_AUFTR.NEXTVAL into v_auf_id_extern from dual;
    select SEQ_TMS_ORDER_VORGANG_ID.nextval into v_li_nr from dual;

    -- Jetzt die ISI_ORDER bauen
    insert into s_rcv_auftr
         values (v_lte.firma_nr,           -- FIRMA_NR
                 v_auf_id_extern,          -- AUF_ID
                 v_li_nr,                  -- VORGANG_ID
                 'LNK',                    -- VORGANG,
                 nvl(v_abnr_num, v_li_nr), -- AUFTRAG
                 1,                        -- POS_NR
                 0,                        -- UPOS_NR
                 v_artikel.artikel,        -- ARTIKEL,
                 'E',                      -- ADR_ART, Wir selber
                 1,                        -- ADR_NR,
                 0,                        -- ADR_LIEFER,
                 null,                     -- LEITZAHL,
                 null,                     -- Charge
                 null,                     -- SERIENNR,
                 'FIFO',                   -- Strategie
                 NULL,                     -- MHD
                 nvl(v_abnr_num, v_li_nr), -- LI_NR,
                 1,                        -- li_pos_nr,
                 null,                     -- arbeitsplatz_id
                 null,                     -- KOM_INFO,
                 v_menge,                  -- SOLL_MENGE,
                 0,                        -- IST_MENGE,
                 'N',                      -- STATUS,
                 'LAGER',                  -- WA_ZIEL
                 sysdate,                  -- GEN_DATUM,
                 null,                     -- LVS_INFO,
                 in_prio,                  -- PRIORITAET),
                 null,                     -- BEST_NR_KUNDE,
                 null,                     -- FA_AG
                 in_lgr_ort,               -- ZIEL
                 null,                     -- ANBRUCH
                 null,                     -- LIEFER_DATUM
                 'ISI',                    -- BESTELLER
                 v_lam_sel1,               -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam_sel2,               -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam_sel3,               -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam_sel4,               -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam_sel5,               -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam_sel6,               -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam_sel7,               -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam_sel8,               -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam_sel9,               -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 v_lam_sel10,              -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                 NULL,                     -- Tour
                 NULL                      --  UEBER_UNTER_LIEFERN  N VARCHAR2(4) Y

                 );
    OPEN c_order_pos;
    FETCH c_order_pos into v_auf_id;
    CLOSE c_order_pos;

    -- Lesen Quell-Packschema
    select count(pp.packschema_pos_nr) into v_lhm_je_lage
      from lvs_packschema_pos pp
     where pp.sid = v_lte.sid
       and pp.firma_nr = v_lte.firma_nr
       and pp.packschema_kopf_id = v_lte.packschema_kopf_id
     group by pp.packschema_kopf_id;

   begin
     v_quell_lte_lagen := trunc(v_lte.lte_akt_lhm / v_lhm_je_lage);
     if mod (v_lte.lte_akt_lhm, v_lhm_je_lage) > 0
     then
       v_quell_lte_lagen := v_quell_lte_lagen + 1;
     end if;
   exception
     when others then v_quell_lte_lagen := 1;
   end;

    -- Lesen Ziel-Packschema
   select pk.anz_lagen,
          count(pp.packschema_pos_nr) into v_lte_lagen, v_lhm_je_lage
     from lvs_packschema_pos pp,
          lvs_packschema_kopf pk
    where pp.sid = v_lte.sid
      and pp.firma_nr = v_lte.firma_nr
      and pp.packschema_kopf_id = in_ziel_packschema_kopf_id
      and pk.packschema_kopf_id = in_ziel_packschema_kopf_id
    group by pk.packschema_kopf_id, pk.anz_lagen;

   begin
     v_lte_anz := trunc(v_lte.lte_akt_lhm / (v_lhm_je_lage * v_lte_lagen));
     if mod (v_lte.lte_akt_lhm, (v_lhm_je_lage * v_lte_lagen)) > 0
     then
       v_lte_anz := v_lte_anz + 1;
     end if;
   exception
     when others then v_lte_lagen := v_lte.lte_akt_lhm;
   end;

    -- Ziel-Packschema hat mehr als eine LAM je lage
    if v_lhm_je_lage > 1
    then
      v_lhm_menge := v_lhm_menge * v_lhm_je_lage;
    end if;

    -- LAM reservieren
    update lvs_lam lam
       set lam.order_pos_auf_id = v_auf_id,
           lam.res_menge = lam.menge,
           lam.res_login_id = in_user_ID
     where lam.lte_id = in_lte_id
       and lam.artikel_id = v_artikel_id
       and lam.order_pos_auf_id is null;

    -- LTE reservieren
    update lvs_lte lte
       set lte.order_vorgang_id = v_li_nr,
           lte.order_auf_id = v_auf_id,
           lte.res_login_id = in_user_ID,
           lte.res_ziel_lgr_platz = in_komm_lgr_platz
     where lte.sid = v_lte.sid
       and lte.lte_id = in_lte_id;

    update isi_order_pos pos
       set pos.ware_disponiert = 'T',
           pos.status = 'T',
           pos.freigegeben_datum = sysdate,
           pos.ziel_lhm_menge = v_lhm_menge
       where pos.sid = v_lte.sid
         and pos.firma_nr = v_lte.firma_nr
         and pos.auf_id = v_auf_id;

    update isi_order_kopf kopf
       set kopf.status = 'T',
           kopf.freigegeben_datum = sysdate
     where kopf.sid = v_lte.sid
       and kopf.firma_nr = v_lte.firma_nr
       and kopf.vorgang_id = v_li_nr;

   select seq_transport_gruppe.nextval into v_transport_gruppe from dual;
   if lvs_transport.lvs_transp_lte(v_lte.sid,                 -- in_sid                  IN isi_sid.sid%TYPE,
                                   v_lte.firma_nr,            -- in_firma_nr             IN isi_firma.firma_nr%TYPE,
                                   in_modul_erzeuger,         -- in_modul_erzeuger       IN isi_transport.modul_erzeuger%TYPE,
                                   in_modul_bearbeiter,       -- in_modul_bearbeiter     IN isi_transport.modul_bearbeiter%TYPE,
                                   C.C_FALSE,                 -- in_frei_fahren          IN varchar2,
                                   'A',                       -- in_trans_typ            in varchar2,
                                   in_user_ID,                -- in_user_id              IN isi_user.login_id%TYPE,
                                   v_auf_id,                  -- in_auftrag_id           IN isi_transport.auf_id%TYPE,
                                   NULL,                      -- in_auftrag_id_extern    IN isi_transport.auf_id_extern%TYPE,
                                   in_prio,                   -- in_prio                 IN isi_transport.prio%TYPE,
                                   0,                         -- in_progr_nr             IN isi_transport.progr_nr%TYPE,
                                   0,                         -- in_quelle_leer_progr_nr IN isi_transport.quelle_leer_progr_nr%TYPE,
                                   0,                         -- in_ziel_voll_progr_nr   IN isi_transport.ziel_voll_progr_nr%TYPE,
                                   in_aktuelle_position,      -- in_lgr_quell_lgr_platz  IN lvs_lte.lgr_platz%TYPE,
                                   in_komm_lgr_platz,         -- in_lgr_ziel_lgr_platz   IN lvs_lte.lgr_platz%TYPE,
                                   in_lte_id,                 -- in_lte_id               IN lvs_lte.lte_id%TYPE,
                                   NULL,                      -- in_kunde_nr             IN lvs_lam.kunden_nr%TYPE
                                   c.C_FALSE,                 -- in_lieferschein
                                   nvl(v_abnr_num, v_li_nr),  -- Lieferschein Nummer
                                   1,                         -- Lieferscheinposition -Nummer
                                   v_li_nr,                   -- Tournummer
                                   NULL,                      -- in_fahrzeuge_IDs Hier nicht mehr Prüfen da die Paletten schon im Vorfeld Reserviert wurden
                                   0,
                                   v_transport_gruppe,
                                   out_transport_id) != 0
   then
     RAISE_APPLICATION_ERROR(-20000-c.FMID_Falsche_Buchungsart, LC.ec_p2(LC.O_TP2_WEG_VON_NACH_FALSCH, in_aktuelle_position, in_komm_lgr_platz));
   end if;

   if lvs_transport.lvs_transp_beginnen (v_lte.sid,                  -- in_sid                  IN isi_sid.sid%TYPE,
                                         v_lte.firma_nr,            -- in_firma_nr             IN isi_firma.firma_nr%TYPE,
                                         in_user_id,                -- in_user_id              IN isi_user.login_id%TYPE,
                                         out_transport_id,          -- in_transport_id         IN isi_transport.transport_id%TYPE,
                                         in_lte_id,                 -- in_lte_id               IN lvs_lte.lte_id%TYPE,
                                         NULL)                      -- in_res_id              in isi_resource.res_id%type)
                                         != 0
   then
     RAISE_APPLICATION_ERROR(-20000-c.FMID_Falsche_Buchungsart, LC.ec_p1(LC.O_TP1_TRAM_MIT_ID_FEHLT, to_char(out_transport_id)));
   end if;

   v_komm_lgr_platz := NULL;
   OPEN c_komm_lgr_platz;
   FETCH c_komm_lgr_platz into v_komm_lgr_platz;
   if c_komm_lgr_platz%NOTFOUND
   or v_komm_lgr_platz is NULL
   then
     v_komm_lgr_platz := in_komm_lgr_platz;
   end if;
   CLOSE c_komm_lgr_platz;

   insert into isi_komm_order
   values
      (v_lte.sid,
       v_lte.firma_nr,
       NULL,    -- v_komm_id,
       v_li_nr, -- v_p_komm_id,
       NULL, -- v_s_ext_rcv_komm_id,
       NULL, -- v_s_ext_rcv_info_text,
       NULL, -- v_s_send_ref_id,
       NULL, -- v_s_send_tab_name,
       'UP', -- v_komm_typ,
       'N',  -- v_status,
       NULL, -- v_ts,
       in_prio,-- v_prio,
       'MFR',-- v_modul_erzeuger,
       'MFR',-- v_modul_bearbeiter,
       NULL, -- v_login_id,
       NULL, -- v_bearb_login_id,
       NULL, -- v_bearb_arbeitsplatz_id,
       NULL, -- v_bearb_res_id,
       NULL, -- v_bearb_start_datum,
       NULL, -- v_info_text,
       'M',  -- v_freigabe,
       NULL, -- v_freigabe_datum,
       NULL, -- v_freigegeben_login_id,
       NULL, -- v_freigegeben_datum,
       NULL, -- v_soll_datum,
       NULL, -- v_fertig_datum,
       NULL,             -- v_fertig_login_id,
       v_li_nr,          -- v_vorgang_id,
       v_auf_id,         -- v_auf_id,
       'T',              -- v_transport_vor_komm,
       'F',              -- v_transport_nach_komm,
       out_transport_id, -- v_transp_id_vor_komm,
       NULL,             -- v_transp_id_nach_komm,
       v_komm_lgr_platz, -- v_komm_lgr_platz,
       NULL,             -- v_komm_ziel_lte_id,
       NULL,             -- v_lgr_ort_quelle,
       in_lte_id,        -- v_lte_id,
       NULL,             -- v_lam_id,
       v_artikel_id,     -- v_artikel_id,
       NULL,             -- v_leitzahl,
       NULL,             -- v_fa_ag,
       NULL,             -- v_fa_upos,
       NULL,             -- v_charge_id,
       NULL,             -- v_seriennr_id,
       NULL,             -- v_mhd,
       v_menge,          -- v_menge,
       v_artikel.mengeneinheit_basis, -- v_menge_basis,
       v_artikel.mengeneinheit, -- v_mengeneinheit,
       v_menge,          -- v_komm_soll_menge,
       0,                -- v_komm_ist_menge,
       '1',              -- v_komm_ziel_lgr_platz,
       NULL,             -- v_komm_neu_artikel,
       NULL,             -- v_komm_neu_leitzahl,
       NULL,             -- v_komm_neu_fa_ag,
       NULL,             -- v_komm_neu_fa_upos,
       NULL,             -- v_komm_neu_charge,
       NULL,             -- v_komm_neu_seriennr,
       NULL,             -- v_komm_neu_lhm_name,
       NULL,             -- v_komm_neu_lte_name,
       NULL,             -- v_komm_neu_lte_hoehe,
       NULL,             -- v_komm_scan_daten_q,
       NULL,             -- v_komm_scan_daten_z,
       v_lte_anz,        -- v_anz_lte,
       v_lte_lagen,      -- v_lte_lhm_lagen,
       v_lhm_je_lage,    -- v_lte_lhm_pro_lage,
       v_lhm_hoehe,      -- v_lhm_hoehe_lage,
       in_ziel_packschema_kopf_id, -- v_packschema_kopf_id,
       nvl(v_abnr_num, v_li_nr), -- v_lieferschein_nr,
       NULL,             -- v_packschema_traeger_id,
       NULL,             -- v_zusatz_etiketten_name,
       v_quell_lte_lagen,-- v_lte_lhm_lagen_quelle,
       null,             -- status_info_text
       v_lhm_menge)      -- LHM_MENGE N NUMBER  Y     Menge im Ziel (LHM) für das Zielgebinde
     returning komm_id into v_komm_id;
    update isi_transport t
       set t.p_komm_id = v_komm_id
      where t.transp_id = out_transport_id;


    out_p_komm_id := v_li_nr;

    commit;
  end C_TRANSP_DEPAL_LTE;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure Legt eine LHM von einer Palette auf eine andere
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure lvs_c_lte_lhm_umpacken(in_sid        in isi_sid.sid%type,
                                   in_firma_nr   in isi_firma.firma_nr%type,
                                   in_user_id    in isi_user.login_id%type,
                                   in_res_id     in isi_resource.res_id%type,
                                   in_q_lte_id   in lvs_lhm.Lhm_Id%type,
                                   in_z_lte_id   in lvs_lte.lte_id%type,
                                   in_auf_id     in isi_order_pos.auf_id%type,
                                   in_lhm_uanz   in number) is

    ----------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    ----------------------------------------------------------------------------

  begin

    lvs_komm.lvs_c_lte_lhm_umpacken (in_sid,        --in isi_sid.sid%type,
                                     in_firma_nr,   --in isi_firma.firma_nr%type,
                                     in_user_id,    --in isi_user.login_id%type,
                                     in_res_id,     --in isi_resource.res_id%type,
                                     in_q_lte_id,   --in lvs_lhm.Lhm_Id%type,
                                     in_z_lte_id,   --in lvs_lte.lte_id%type,
                                     in_auf_id,     --in isi_order_pos.auf_id%type,
                                     in_lhm_uanz);  --in number) is);
  end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure löscht alle Einträge die mit dieser DEPLAL angelegt wurden
  -- und kann nach Fehler sowie nach erfolgreichem Ende aufgerufen werden
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************

  procedure c_del_transp_depal_lte (in_sid                      in isi_sid.sid%type,
                                    in_firma_nr                 in isi_firma.firma_nr%type,
                                    in_user_id                  in isi_user.login_id%type,
                                    in_lte_id                   in lvs_lte.lte_id%type,
                                    in_transport_id             in isi_transport.transp_id%type,
                                    in_immer_loeschen           in varchar2
                                    ) is

    v_found      boolean;
    v_result_n                         number;

    v_lte                              lvs_lte%rowtype;
    v_transport                        isi_transport%rowtype;
    v_komm_order                       isi_komm_order%rowtype;

    CURSOR c_transport  is             -- Lesen transport ueber LTE_ID und Transport_ID
      select *
        from isi_transport tra
       where tra.sid = in_sid
         and tra.firma_nr = in_firma_nr
         and tra.lte_id = in_lte_id
         and tra.transp_id = nvl(in_transport_id, tra.transp_id);

    CURSOR c_komm_order is
      select *
        from isi_komm_order t
       where t.lte_id = in_lte_id;

  begin

    if lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      -- Lesen der KOMM_Order
      v_komm_order := NULL;
      OPEN c_komm_order;
      FETCH c_komm_order into v_komm_order;
      v_found := c_komm_order%FOUND;
      CLOSE c_komm_order;

      -- MFR hat ggf. diesen Order mit Komm Order für die eingene Vewrwaltung ROBOTER angelegt und kann muss nach Beendigung geloescht werden
      if v_found -- KOMM_Order gefunden
      and (    v_komm_order.modul_erzeuger != 'MFR' -- Nur wenn Erzeuger der MFR ist, dann alle wieder löschen
            or (    v_komm_order.menge < v_komm_order.komm_ist_menge  -- Noch nicht fertig
                and in_immer_loeschen = 'T'                           -- Auch loeschen wenn noch nicht fertig
                                                                      -- Z.B. nach Konturenfehler
               )
           )
      then
        return;
      end if;

      -- Lesen des Transports
      v_transport := NULL;
      OPEN c_transport;
      FETCH c_transport into v_transport;
      v_found := c_transport%FOUND;
      CLOSE c_transport;

      if v_found -- Transport gefunden
      then
        v_result_n := lvs_transport.lvs_transp_loeschen(in_sid,   -- Dann löschen
                                                        in_firma_nr,
                                                        in_user_id,
                                                        v_transport.transp_id,
                                                        'T');
      end if;

      delete isi_komm_order t
       where t.modul_erzeuger = 'MFR'
         and t.lte_id = in_lte_id;                              -- Schonmal die KOMM_ORDER löschen

      isi_p_order.c_abbr_trans_lief(in_sid,                     -- Reservierungenzurücksetzen
                                    in_firma_nr,
                                    v_komm_order.p_komm_id,
                                    in_user_id,
                                    'T');                       -- Mit diesem Commit ist der Eintrag in der ISI_KOMM_Order gelöscht und alle Reservierungen  entfernt.

      isi_p_order.c_del_lief(in_sid,                            -- Order komplett löschen
                             in_firma_nr,
                             v_komm_order.p_komm_id,            -- in_lief_nr
                             in_user_id,
                             v_komm_order.p_komm_id);           -- in_tour_nr
      delete isi_order_tour t
        where t.vorgang_id =  v_komm_order.p_komm_id;           -- tour_nr
      if v_lte.lgr_platz is not NULL                            -- LTE steht auf einem Lagerplatz
      then
        lvs_p_lte.LVS_KORR_TE_AUSBUCHEN(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, v_lte.lte_status,
                                        v_lte.sid, v_lte.firma_nr, v_lte.lgr_ort, v_lte.lgr_platz, in_user_id);
        if v_lte.lte_akt_lhm = 0        -- Palette ist leer
        then
          lvs_p_lte.lvs_lte_delete(v_lte.sid, v_lte.lte_id, in_user_id, v_lte.lte_status); -- dann löschen
        end if;
      end if;
    end if;
    commit;
  end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- procedure aendert das Ziel in der ISI_ORDER, Transporten und ISI_ORDER_TOUR
  -- nachdem der MFR für eine LTE das Ziel geändert hat.
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************

  procedure c_change_order_ziel (in_sid                      in isi_sid.sid%type,
                                 in_firma_nr                 in isi_firma.firma_nr%type,
                                 in_vorgang_id               in isi_order_pos.vorgang_id%type,
                                 in_von_ziel                 in isi_order_pos.ziel%type,
                                 in_neues_ziel               in isi_order_pos.ziel%type)
                                 is
    v_lgr                        lvs_lgr%rowtype;
    v_lte                        lvs_lte%rowtype;
    v_transport                  isi_transport%rowtype;
    v_res_id                     isi_resource.res_id%type;
    v_result                     number;

    CURSOR c_transport IS
      select t.*
        from isi_transport t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.vorgang_id = in_vorgang_id
         and t.lgr_platz_ziel = in_von_ziel;

  begin
    if lvs_p_base.get_lgr_platz(in_neues_ziel, v_lgr)
    then
      update isi_order_pos t
         set t.ziel = in_neues_ziel
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.vorgang_id = in_vorgang_id
         and t.ziel = in_von_ziel;
      update isi_order_tour t
         set t.pack_lgr_platz = in_neues_ziel
       where t.vorgang_id = in_vorgang_id;
     update isi_komm_order t
         set t.komm_ziel_lgr_platz = in_neues_ziel
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.p_komm_id = in_vorgang_id
         and t.vorgang_id = in_vorgang_id
         and t.komm_ziel_lgr_platz = in_von_ziel;

      OPEN c_transport;
      LOOP
        FETCH c_transport
          into v_transport; -- Lesen des Transportauftrags
        Exit when c_transport%NOTFOUND;
        v_result := lvs_platz.lvs_c_transp_neues_ziel(in_sid,
                                                      in_firma_nr,
                                                      -1,
                                                      v_transport.transp_id,
                                                      in_neues_ziel,
                                                      v_res_id);
      END LOOP;
      CLOSE c_transport;

    else
      RAISE_APPLICATION_ERROR(-20000-1, LC.ec_p2(LC.O_TP2_PLATZ_EXISTIERT_NICHT, in_neues_ziel, 'ALL'));
    end if;
  end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Diese Procedure wird von Start_MFR_Server aufgerufen und legt in der Tabelle
  -- Meldung_daten die NIO Texte an
  --------------------------------------------------------------------------------
  --******************************************************************************

  function C_Check_Create_NIO_Meldungen  return varchar2 is
    v_result varchar2(2000);
    v_count number;
  begin
    v_result := '';
    -- Deutsch Sprache = 1
    select count(*) into v_count from Meldung_texte mt
      where mt.mt_gruppe = -1 and mt.mt_sprache = 1;
    if v_count = 0  then   -- SID, Firma_nr, Engine_id, MT_Sprache, MT_Gruppe, mt_index , FehlerNr, Fehlertext, Typ, Quittieren, create Date,create User,change Date,change User
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.01 , 1, 'Überstand vorn', 'M',      'M','', '1',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.02 , 2, 'Überstand hinten', 'M',    'M','', '2',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.03 , 3, 'Überstand links', 'M',     'M','', '3',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.04 , 4, 'Überstand rechts', 'M',    'M','', '4',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.05 , 5, 'Kufe links', 'M',          'M','', '5',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.06 , 6, 'Kufe mitte', 'M',          'M','', '6',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.07 , 7, 'Kufe rechts', 'M',         'M','', '7',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.08 , 8, 'Kufe Freiraum', 'M',       'M','', '8',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.09 , 9, 'Gewicht', 'M',             'M','', '9',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.10 ,10, 'Kontur: Palettentyp','M',  'M','','10',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.11 ,11, 'Kontur: Höhe', 'M',        'M','','11',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.12 ,12, 'Scanner: NOREAD', 'M',     'M','','12',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.13 ,13, 'Scanner: TIMEOUT', 'M',    'M','','13',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.14 ,14, 'MFR Ausschleusen', 'M',    'M','','14',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.15 ,15, 'ID unbekannt / falsch','M','M','','15',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 1,  -1, 1.16 ,16, 'Vorgabe Werker', 'M',      'M','','16',sysdate,-1,null,null,null,null,null);
      COMMIT;
    end if;

    -- Holländisch Sprache = 5
    select count(*) into v_count from Meldung_texte mt
      where mt.mt_gruppe = -1 and mt.mt_sprache = 5;
    if v_count = 0  then
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.01 , 1, 'Overhang front', 'M',        'M','', '1',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.02 , 2, 'Overhang rear', 'M',         'M','', '2',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.03 , 3, 'Overhang left', 'M',         'M','', '3',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.04 , 4, 'Overhang right', 'M',        'M','', '4',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.05 , 5, 'Kufe links',  'M',           'M','', '5',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.06 , 6, 'Kufe mitte', 'M',            'M','', '6',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.07 , 7, 'Kufe rechts', 'M',           'M','', '7',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.08 , 8, 'Kufe Freiraum', 'M',         'M','', '8',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.09 , 9, 'Gewicht', 'M',               'M','', '9',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.10 ,10, 'Kontur: Palettentyp', 'M',   'M','','10',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.11 ,11, 'Hoogte', 'M',                'M','','11',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.12 ,12, 'Scanner: NOREAD', 'M',       'M','','12',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.13 ,13, 'Scanner: TIMEOUT', 'M',      'M','','13',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.14 ,14, 'MFR Ausschleusen', 'M',      'M','','14',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.15 ,15, 'ID unbekannt / falsch', 'M', 'M','','15',sysdate,-1,null,null,null,null,null);
      insert into meldung_texte values('01', 1, 1, 5, -1, 1.16 ,16, 'Vorgabe Werker', 'M',        'M','','16',sysdate,-1,null,null,null,null,null);
      COMMIT;
    end if;
    return(v_result);
  end;


  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Diese Procedure wird vom MFR Server R3 R4 ? beim Start aufgerufen.
  -- Hier können benötigte Daten validiert werden,
  -- oder Daten automatisiert angelegt werden die der MFR Server benötigt.
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************

  function C_MFR_Server_Start return varchar2 is
  v_result             varchar2(2000);

  begin
    v_result := C_Check_Create_NIO_Meldungen();
    return(v_result);
  end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Diese Procedure wird vom Meld_server aufgerufen um Meldungen auch in ISI_RES_STATUS
  -- einzutragen. Eine Meldung wird nur eingetragen, wenn die Maschine keinen Fehler
  -- eingetragen hat.
  -- in_res_st_id =  0  Meldungen gegangen
  -- in_res_st_id <> 0  meldung gekommmen
  --******************************************************************************


  function c_res_stat(in_sid         in isi_sid.sid%TYPE,
                      in_firma_nr    in isi_firma.firma_nr%TYPE,
                      in_res_id      in isi_resource.res_id%TYPE,
                      in_ls_login_id   in isi_user.login_id%type,
                      in_res_st_id     in isi_res_status_cfg.res_st_id%type,
                      in_res_typ       in isi_res_status_cfg.res_typ%type)
     return number is


    v_result number;
    v_res_action char;
    v_res_run_stop char;
    v_res_st_id isi_res_status_cfg.res_st_id%type;

    CURSOR c_res_status IS
      select
        decode(t.akt_aufgabe, 'R', 'R',                 -- R= Ruesten
        decode (t.status_id, 0, '0', '1')) ms_run_stop  -- 0= Run 1 = Stop
      from
        ISI_RESOURCE_ZUST_AKT t
      where t.res_id = in_res_id;

    CURSOR c_exist_meldung is
      select
        irs.res_st_id
      from
        isi_resource r,
        isi_res_status_cfg irs
      where
        r.res_id = in_res_id and
        r.sid = irs.sid and
        r.firma_nr = irs.firma_nr  and
        irs.res_st_id = in_res_st_id and
        r.typ = irs.res_typ  and
        r.fehler_schluessel = irs.fehler_schluessel;

begin
    v_result := 0; -- Keine Störung an Maschine
    v_res_st_id := in_res_st_id;
    OPEN c_res_status;
    FETCH c_res_status into v_res_action; -- Lese res_status
    CLOSE c_res_Status;
    if v_res_st_id <> 0
    THEN
      OPEN c_exist_meldung;
      FETCH c_exist_meldung into v_res_st_id; -- Lese res_status
      IF not c_exist_meldung%found
      THEN
        v_res_st_id := -1;   -- wenn die Meldung nicht existiert, wird default -1 unbegründete Störung gesetzt.
      END IF;
      CLOSE c_exist_meldung;
    END IF;
    if ((v_res_action = '0') and (v_res_st_id <> 0)) or -- Maschine hatte keine Störung, nicht im Rüsten Störung kommt.
      ((v_res_action = '1') and (v_res_st_id = 0))then  -- Maschine hatte Störung nicht im Rüsten Fehler geht!
      res_status.res_status_beg(in_sid,
                                 in_firma_nr,
                                 in_res_id,
                                 in_ls_login_id,
                                 v_res_st_id,
                                 in_res_typ,
                                 null,  -- in_res_st_ug_id,
                                 null, --in_fehler_res_id,
                                 null); -- in_date
      COMMIT;
      v_result := in_res_st_id; -- Neuer Status Maschine zurück
    end if;
    return(v_result);

  end;


  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Diese Procedure kann zur Anlagenkonfiguration benutzt werden, wenn Elemente vorher für zwei SPS Schnittstellen
  -- geplant waren, und diese jetzt mit einer Schnittstelle angesteuert werden sollen.
  -- in_new_PLC_connector =  New PLC Connector   neue Schnittstellen  Nr (Telegr_Koppl_Nr)
  -- in_old_PLC_connector =  Old PLC Connector   alte Schnittstellen  Nr (Telegr_Koppl_Nr)

   --******************************************************************************

  procedure c_mfr_elem_cfg_change_plc_Nr(in_new_plc_connector         in MFR_Element_cfg.Telegr_Koppl_Nr%TYPE,
                                         in_old_plc_connector         in MFR_Element_cfg.Telegr_Koppl_Nr%TYPE) is
  begin
    update MFR_Element_CFG set
      MFR_Element_CFG.Telegr_Koppl_Nr = in_new_PLC_connector
    where MFR_Element_CFG.Telegr_Koppl_Nr = in_old_PLC_connector;
    commit;
  end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Diese Procedure kann zur Anlagenkonfiguration benutzt werden, wenn eine SPS Schnittstelle komplett entfernt werden soll.
  -- Dabei werden ab dieser Schnittstelle  alle Schnittstellen um 1 aufgerückt, sodaß keine (Freien Schnittstellen im MFR Server vorhanden bleiben müssen);
  -- start_move_up_at_PLC_connector =  Moving up At PLC Connector   (Aufrücken er SPS Schnittstellen um 1 ab Nr (Telegr_Koppl_Nr)

  --******************************************************************************

  procedure c_mfr_elem_cfg_move_up_plc_Nr(start_move_up_at_PLC_connector in MFR_Element_cfg.Telegr_Koppl_Nr%TYPE) is
  begin
    update MFR_Element_CFG set
      MFR_Element_CFG.Telegr_Koppl_Nr = MFR_Element_CFG.Telegr_Koppl_Nr -1
    where MFR_Element_CFG.Telegr_Koppl_Nr >= start_move_up_at_PLC_connector;
    commit;
  end;

end mfr_package;
/



-- sqlcl_snapshot {"hash":"b73c04cc78caa5f79b98c51209c718d4e8f5de83","type":"PACKAGE_BODY","name":"MFR_PACKAGE","schemaName":"DIRKSPZM32","sxml":""}