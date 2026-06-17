create or replace 
package DIRKSPZM32.ISI_ALLG is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  22.09.2004 10:18:15
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  21.11.2013   3.5.7       (-WK-)   Vereinfachte Form für das Laden von Konfigurationsparametern
  27.11.2009   3.5.0.4     (-BW-)   Minor Release
  05.04.2008   3.4.4.3     (-WK-)   Einbinden der ClientInfo-Funktionen in ISIPlus
  10.10.2006   3.3.4.2     (-WK-)   Erweiterung für Basisfunktionen z.B. "get_firma"
  00.00.2006   3.3.4.1     (-AG-)   Versioneirung erstellt
	22.09.2004   3.3.4.0     (-AG-)   Erstellt
  */

  -------------------------------------------------------------------------------------------------------
  -- Release handling
  -------------------------------------------------------------------------------------------------------
  v_release_major  constant number := 3;
  v_release_minor  constant number := 5;
  v_revision       constant number := 7;
  -- the build number is counted in the package body
  v_rev_date       constant varchar2(20) := '21.11.2013';
  v_release_str    constant  varchar2(20) := to_char(v_release_major) || '.' ||
                                             to_char(v_release_minor) || '.' ||
                                             to_char(v_revision) || ' / ' ||
                                             v_rev_date;

  -- v_version_str    constant  varchar2(20) := '3.5.7.5 / 21.11.2013';
  function get_release return varchar2;
  function get_version return varchar2;
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2);

	-------------------------------------------------------------------------------------------------------
	-- Public declarations
	-------------------------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- function Legt einen Parameter in der Arbeitsplatz CFG an
  -- mit COMMIT
  --------------------------------------------------------------------------------
  procedure c_set_arbeitsplatz_cfg (in_tcpip               in       varchar2,
                                    in_modul_name          in       isi_arbeitsplatz_param.modul_name%type,
                                    in_modul_funktion      in       isi_arbeitsplatz_param.modul_funktion%type,
                                    in_modul_parameter     in       isi_arbeitsplatz_param.modul_parameter%type
                                   );

  --------------------------------------------------------------------------------
  -- function gibt einen Parameter aus der Firma CFG zurück, und legt ihn ggf. an
  -- mit COMMIT
  --------------------------------------------------------------------------------
  function c_get_firma_cfg_param (in_sid                   in isi_firma_cfg.sid%type,
                                  in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                  in_kategorie             in isi_firma_cfg.kategorie%type,
                                  in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                  in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                  in_modul_name            in isi_firma_cfg.modul_name%type,
                                  in_typ                   in isi_firma_cfg.typ%type,
                                  in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                  in_default_param_typ     in isi_firma_cfg.parameter_typ%type
                                 ) return varchar;

  --------------------------------------------------------------------------------
  -- function gibt einen Parameter aus der Firma CFG zurück, und legt ihn ggf. an
  --
  --------------------------------------------------------------------------------
  function get_firma_cfg_param(in_sid                   in isi_firma_cfg.sid%type,
                              in_firma_nr              in isi_firma_cfg.firma_nr%type,
                              in_kategorie             in isi_firma_cfg.kategorie%type,
                              in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                              in_parameter_name        in isi_firma_cfg.parameter_name%type,
                              in_modul_name            in isi_firma_cfg.modul_name%type,
                              in_typ                   in isi_firma_cfg.typ%type,
                              in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                              in_default_param_typ     in isi_firma_cfg.parameter_typ%type
                             ) return varchar;
                             
  /* function c_get_global_param
     Gibt einen Parameter aus der Firma CFG zurück, und legt ihn ggf. an.
     Bei dieser Variante wird für Kategorie und Typ standardmäßig 'CFG' verwendet
     und der Kategorie IX ist NULL. Da der Parametertyp 'BOOLEAN' am häufigsten 
     verwendet wird, ist dieser als 'default' vorbelegt.
     Die Transaktion wird mit commit abgeschlossen.

     ---- HISTORY ---
     21.11.2013 -WK- Erstellt

     @param in_modul_name          Konstanter Name des Moduls dem der Parameter untergeordnet wird
     @param in_parameter_name      Name des Parameter in der globalen Konfiguration (isi_firma_cfg)
     @param in_default_param_wert  Standardwert für den Parameter, falls er in der Konfiguration 
                                   noch nicht vorhanden ist
     @param in_default_param_typ   Erwarteter Datentyp des Parameters. Standart ist 'BOOLEAN'.
                                   Ein Boolean wird mit 'T' und 'F' gespeichert.
   */
  function c_get_global_param(
    in_modul_name            in isi_firma_cfg.modul_name%type,
    in_parameter_name        in isi_firma_cfg.parameter_name%type,
    in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
    in_default_param_typ     in isi_firma_cfg.parameter_typ%type default 'BOOLEAN'
  ) return varchar2;

  /* function get_global_param
     Gibt einen Parameter aus der Firma CFG zurück, und legt ihn ggf. an.
     Bei dieser Variante wird für Kategorie und Typ standardmäßig 'CFG' verwendet
     und der Kategorie IX ist NULL. Da der Parametertyp 'BOOLEAN' am häufigsten 
     verwendet wird, ist dieser als 'default' vorbelegt.

     ---- HISTORY ---
     21.11.2013 -WK- Erstellt

     @param in_modul_name          Konstanter Name des Moduls dem der Parameter untergeordnet wird
     @param in_parameter_name      Name des Parameter in der globalen Konfiguration (isi_firma_cfg)
     @param in_default_param_wert  Standardwert für den Parameter, falls er in der Konfiguration 
                                   noch nicht vorhanden ist
     @param in_default_param_typ   Erwarteter Datentyp des Parameters. Standart ist 'BOOLEAN'.
                                   Ein Boolean wird mit 'T' und 'F' gespeichert.
   */
  function get_global_param(
    in_modul_name            in isi_firma_cfg.modul_name%type,
    in_parameter_name        in isi_firma_cfg.parameter_name%type,
    in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
    in_default_param_typ     in isi_firma_cfg.parameter_typ%type default 'BOOLEAN'
  ) return varchar2;

  --------------------------------------------------------------------------------
  -- Function gibt Artikel_CFG zurueck
  --
  --------------------------------------------------------------------------------
  function get_artikel_cfg(in_sid          in isi_artikel_cfg.sid%type,
                           io_artikel_cfg  in out isi_artikel_cfg%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- Function gibt einen Artikeldatensatz anhand der artikel_id zurück
  --
  --------------------------------------------------------------------------------
  function get_artikel_by_artikel_id(in_sid          in isi_artikel.sid%type,
                                     in_artikel_id   in isi_artikel.artikel_id%type,
                                     io_artikel_satz in out isi_artikel%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- Function gibt einen Artikeldatensatz anhand der Artikelnummer zurück
  --
  --------------------------------------------------------------------------------
  function get_artikel_by_artikel_nr(in_artikel      in isi_artikel.artikel%type,
                                     io_artikel_satz in out isi_artikel%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- Function gibt einen Kunden-Artikeldatensatz anhand der artikel_id und Kundennummer
  -- zurück
  --
  --------------------------------------------------------------------------------
  function get_kd_artikel_by_artikel_id(in_sid               in isi_artikel.sid%type,
                                        in_artikel_id        in isi_artikel.artikel_id%type,
                                        in_kunden_nr         in isi_adressen.adr_nr%type,
                                        io_kd_artikel_satz   in out isi_artikel_kunde%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- Function gibt einen Firmadatensatz zurück
  --
  --------------------------------------------------------------------------------
  function get_firma(in_sid      in isi_firma.sid%type,
                     in_firma_nr in isi_firma.firma_nr%type,
                     io_firma    in out isi_firma%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- Function gibt einen SID-Datensatz zurück
  --
  --------------------------------------------------------------------------------
  function get_sid(in_sid in isi_sid.sid%type,
                   io_sid in out isi_sid%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- Function gibt einen SID-Status zurück
  --
  --------------------------------------------------------------------------------
  function get_sid_status(in_sid in isi_sid.sid%type) return varchar2;

  --------------------------------------------------------------------------------
  -- Function gibt einen Userdatensatz anhand der login_id zurück
  --
  --------------------------------------------------------------------------------
  function get_user_by_login_id(in_sid      in isi_user.sid%type,
                                in_login_id in isi_user.login_id%type,
                                io_user    in out isi_user%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- Function gibt einen Userdatensatz anhand des Benutzernamens zurück
  --
  --------------------------------------------------------------------------------
  function get_user_by_username(in_username in isi_user.username%type,
                                io_user     in out isi_user%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- Function gibt einen Userdatensatz anhand der personalnummer zurück
  --
  --------------------------------------------------------------------------------
  function get_user_by_pers_nr(in_pers_nr  in isi_user.pers_nr%type,
                               io_user     in out isi_user%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- Function gibt einen Userdatensatz anhand der TransponderID zurück
  --
  --------------------------------------------------------------------------------
  function get_user_by_transpoder(in_transponder in isi_user.transponder%type,
                                  io_user        in out isi_user%rowtype) return boolean;

  --------------------------------------------------------------------------------
  -- 03.04.08 (-AM-)
  -- Function liest das Feld CLIENT_INFO aus dem 'USERENV'
  --
  --------------------------------------------------------------------------------
  function get_client_info return varchar2;-- v$session.client_info%type

  --------------------------------------------------------------------------------
  -- 03.04.08 (-AM-)
  -- Procedure setzt das Feld CLIENT_INFO im 'USERENV'
  -- mit commit
  --------------------------------------------------------------------------------
  procedure c_set_client_info(v_cli in varchar2); -- v$session.client_info%type
end ISI_ALLG;
/



-- sqlcl_snapshot {"hash":"c8503c7adc76e9aff7715666dff1b40fdd0941aa","type":"PACKAGE_SPEC","name":"ISI_ALLG","schemaName":"DIRKSPZM32","sxml":""}