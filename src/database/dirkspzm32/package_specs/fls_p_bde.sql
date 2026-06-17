create or replace 
package DIRKSPZM32.fls_p_bde is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  10.12.2007
  __________________________________________________
  Description
  Basisfunktionalitäten zur Buchung von FLS-Aktivitäten
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  01.07.2008   3.4.5.3     (-WK-)   neue Funktion "c_fe_ag_stl_lam_ist_menge" für die
  *                                 Buchung von verbrauchten Bauteilmengen
  30.06.2008   3.4.5.2     (-WK-)   "get_next_new_fa" eliminiert und naue Funktion
  *                                 "c_start_next_new_fa" erstellt
  22.04.2008   3.4.5.1     (-AG-)   Package erweitert um c_res_status_beg
  10.12.2007   3.4.4.1     (-WK-)   Package erstellt
  */



	v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';

	-------------------------------------------------------------------------------------------------------
	--# Liefert die aktuelle Version dieses Packages
	-------------------------------------------------------------------------------------------------------
  function get_version
    return varchar2; --# Aktuelle Version mit Datum (siehe #Konstanten )

	-------------------------------------------------------------------------------------------------------
	--# Nächsten FA holen, der Verarbeitet werden kann und als Begonnen kennzeichnen
	-------------------------------------------------------------------------------------------------------
  function c_start_next_new_fa(
    in_sid        in bde_fa_kopf.sid%type,      --# System ID
    in_firma_nr   in bde_fa_kopf.firma_nr%type, --# Mandantennummer
    out_fa_nr     out bde_fa_kopf.fa_nr%type    --# Fertigunsauftragsnummer des nächsten Fertigungsauftrags
  ) return varchar2;                            --# Return: T = FA vorhanden, F = kein FA vorhanden

	-------------------------------------------------------------------------------------------------------
	--# Fertigungsbeginn des FA_AG anmelden. Buchung in "[bde_pd_prod]".
	-------------------------------------------------------------------------------------------------------
	procedure c_fa_ag_anmelden(
    in_sid      in bde_fa_auftrag.sid%type,       --# System ID
		in_firma_nr in bde_fa_auftrag.firma_nr%type,  --# Mandantennummer
		in_fa_nr    in bde_fa_auftrag.leitzahl%type,
    in_fa_ag    in bde_fa_auftrag.fa_ag%type,
    in_fa_upos  in bde_fa_auftrag.fa_upos%type,
    in_res_id   in isi_resource.res_id%type,
    in_ip_name  in isi_arbeitsplatz.ip_name%type,
    in_login_id in isi_user.login_id%type,
    out_vorg_id out bde_pd_prod.vorg_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--# Fertigung des FA_AG abmelden. Buchung in "[bde_pd_prod]".
	--# Ob der AG komplett fertig ist, kann mit "soll_menge = ist_menge" geprüft werden.
	--# D.h. "Abmelden" ist nicht zwangläufig "Fertigmelden"
	-------------------------------------------------------------------------------------------------------
	procedure c_fa_ag_abmelden(
    in_sid           in bde_fa_auftrag.sid%type,       --# System ID
    in_firma_nr      in bde_fa_auftrag.firma_nr%type,  --# Mandantennummer
    in_fa_nr         in bde_fa_auftrag.leitzahl%type,  --# Fertigungsauftragsnummer
    in_fa_ag         in bde_fa_auftrag.fa_ag%type,     --# Arbeitsgang des Fertigungsauftrags
    in_fa_upos       in bde_fa_auftrag.fa_upos%type,   --# Unterposition zum Arbeitsgang
    in_res_id        in isi_resource.res_id%type,      --# Ressourcen ID von der Maschine/Station an der der AG abgemeldet werden soll
    in_login_id      in isi_user.login_id%type,        --# Login ID des Benutzers, der die Abmeldung ausführt
    in_menge_a       in bde_pd_prod.menge_a%type,      --# Restmenge von A-Ware die in der Ressource noch vorhanden ist.
    in_menge_b       in bde_pd_prod.menge_b%type,      --# Restmenge von B-Ware die in der Ressource noch vorhanden ist.
    in_menge_schrott in bde_pd_prod.schrott%type       --# Restmenge von Schrott-Ware die in der Ressource noch vorhanden ist.
  );

	-------------------------------------------------------------------------------------------------------
	--# TODO: -AG- bitte nachdokumentieren!
	-------------------------------------------------------------------------------------------------------
  procedure c_fa_ag_menge_buchen(
    in_sid           in bde_fa_auftrag.sid%type,          --# System ID
    in_firma_nr      in bde_fa_auftrag.firma_nr%type,     --# Mandantennummer
    in_vorg_typ      in bde_pd_prod.vorg_typ%type,
    in_fa_nr         in bde_fa_auftrag.leitzahl%type,
    in_fa_ag         in bde_fa_auftrag.fa_ag%type,
    in_fa_upos       in bde_fa_auftrag.fa_upos%type,
    in_res_id        in isi_resource.res_id%type,
    in_login_id      in isi_user.login_id%type,
    in_menge_a       in bde_pd_prod.menge_a%type,
    in_menge_b       in bde_pd_prod.menge_b%type,
    in_menge_schrott in bde_pd_prod.schrott%type,
    in_fae_id        in bde_pd_prod.fae_id%type,
    in_fae_id_pos    in bde_pd_prod.fae_id_position%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
	procedure c_fa_ag_bereit(
    in_sid      in bde_fa_auftrag.sid%type,       --# System ID
		in_firma_nr in bde_fa_auftrag.firma_nr%type,  --# Mandantennummer
		in_fa_nr    in bde_fa_auftrag.leitzahl%type,
		in_fa_ag    in bde_fa_auftrag.fa_ag%type,
		in_fa_upos  in bde_fa_auftrag.fa_upos%type,
		in_login_id in isi_user.login_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--# Neue Fertigungseinheit für den angemeldeten Fertigungsauftrag in der Ressource (Maschine/Station)
  --# erzeugen. Eine Fertigungseinheit wird durch eine LAM_ID repräsentiert und ist in der Tabelle
  --# LVS_LAM ohne Zuordnung zu einer LHM oder LTE gespeichert. Dabei wird ggf. die Seriennummer
  --# automatisch inkrementiert und der neuen Fertigungseinheit zugeordnet. Der Artikel wird über den
  --# Fertigungsauftrag der Fertigungseinheit zugeordnet. Des weiteren wird der letzte abgeschlossene
  --# Arbeitsgang an dieser Fertigungseinheit, der aktuelle verantworliche Benutzer und die aktuelle
  --# Ressource gespeichert.
  --# Zusätzlich werden ggf. alle Stücklisten-Daten (Anbauteile, etc.) die von Fertigungsauftrag
  --# für die Fertigungseinheit vorgesehen sind angelegt und mit der Fertigungeinheit verknüpft.
  --# Durch den Status in den Stücklistenpositionen und den letzten abgeschlossenen Arbeitsgang
  --# (in der Tabelle LVS_LAM Spalte FA_AG) kann der Fertigungsprozess verfolgt werden.
  --# In der Rssource wird eine Verknüfung zu der hier erstellten Fertigungseinheit erstellt. Damit kann
  --# gesteuert bzw. ermittelt werden, an welcher Fertigungseinheit eine Ressource gerade arbeitet.
  --# An der Fertigungseinheit wird dann der aktuell angemeldete Arbeitsgang in/von der Ressource
  --# bearbeitet.
	-------------------------------------------------------------------------------------------------------
	procedure c_fa_ag_fe_erzeugen(
    in_sid      in bde_fa_auftrag.sid%type,       --# System ID
		in_firma_nr in bde_fa_auftrag.firma_nr%type,  --# Mandantennummer
		in_fa_nr    in bde_fa_auftrag.leitzahl%type,  --# Fertigungsauftragsnummer
		in_fa_ag    in bde_fa_auftrag.fa_ag%type,     --# Arbeitsgang des Fertigungsauftrags
		in_fa_upos  in bde_fa_auftrag.fa_upos%type,   --# Unterposition zum Arbeitsgang
		in_res_id   in isi_resource.res_id%type,      --# Ressourcen ID von der Maschine/Station an der eine FE angelegt werden soll
		in_login_id in isi_user.login_id%type,        --# Login ID des Benutzers, der aktuell für die Ressource verantworlich ist (Schichtanmeldung).
		out_lam_id  out lvs_lam.lam_id%type           --# Eindeutige Identifikation der neuen Fertigungseinheit (LAM_ID in der Tabelle LVS_LAM)
  );

	-------------------------------------------------------------------------------------------------------
	--# Alle Verknüpfungen auf Rohwaren (Anbauteile, etc.) aus der Ressource entfernen.
  --# Typischerweise wird diese Funktion von Magazin-Ressourcen verwendet.
	-------------------------------------------------------------------------------------------------------
  procedure c_ma_remove_all_res_lam_akt(
    in_sid    in isi_resource_lam_akt.sid%type,    --# System ID
    in_res_id in isi_resource_lam_akt.res_id%type  --# Ressourcen ID des Magazins oder Maschine aus der alle Rohwaren enfert werden sollen.
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_ma_add_new_res_lam_akt(
    in_sid        in isi_resource_lam_akt.sid%type,         --# System ID
    in_firma_nr   in lvs_lam.firma_nr%type,                 --# Mandantennummer
    in_res_id     in isi_resource_lam_akt.res_id%type,
    in_artikel_id in isi_resource_lam_akt.artikel_id%type,
    in_charge_id  in lvs_lam.charge_id%type,
    in_zeichnung  in lvs_lam.zeichnung%type,
    in_zindex     in lvs_lam.zeichnung_index%type,
    in_menge      in lvs_lam.menge%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_ma_add_res_lam_akt_menge(
    in_sid        in isi_resource_lam_akt.sid%type,         --# System ID
    in_firma_nr   in lvs_lam.firma_nr%type,                 --# Mandantennummer
    in_res_id     in isi_resource_lam_akt.res_id%type,
    in_artikel_id in isi_resource_lam_akt.artikel_id%type,
    in_lam_id     in isi_resource_lam_akt.lam_id%type,
    in_menge      in lvs_lam.menge%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_ma_reduce_res_lam_akt_menge(
    in_sid        in isi_resource_lam_akt.sid%type,         --# System ID
    in_firma_nr   in lvs_lam.firma_nr%type,                 --# Mandantennummer
    in_res_id     in isi_resource_lam_akt.res_id%type,
    in_artikel_id in isi_resource_lam_akt.artikel_id%type,
    in_lam_id     in isi_resource_lam_akt.lam_id%type,
    in_menge      in lvs_lam.menge%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_ma_set_res_lam_akt_params(
    in_sid        in isi_resource_lam_akt.sid%type,            --# System ID
    in_res_id     in isi_resource_lam_akt.res_id%type,
    in_artikel_id in isi_resource_lam_akt.artikel_id%type,
    in_params_csv in isi_resource_lam_akt.res_lam_params%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_bereit(
    in_sid         in bde_pd_lam_stl_daten.sid%type,          --# System ID
		in_firma_nr    in bde_pd_lam_stl_daten.firma_nr%type,     --# Mandantennummer
		in_fert_lam_id in bde_pd_lam_stl_daten.fert_lam_id%type,
    in_fa_nr       in bde_pd_lam_stl_daten.fa_nr%type,
		in_fa_ag       in bde_pd_lam_stl_daten.fa_ag%type,
		in_fa_upos     in bde_pd_lam_stl_daten.fa_upos%type,
		in_res_id      in bde_pd_lam_stl_daten.res_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_reset(
    in_sid         in bde_pd_lam_stl_daten.sid%type,          --# System ID
		in_firma_nr    in bde_pd_lam_stl_daten.firma_nr%type,     --# Mandantennummer
		in_fert_lam_id in bde_pd_lam_stl_daten.fert_lam_id%type,
    in_fa_nr       in bde_pd_lam_stl_daten.fa_nr%type,
		in_fa_ag       in bde_pd_lam_stl_daten.fa_ag%type,
		in_fa_upos     in bde_pd_lam_stl_daten.fa_upos%type,
		in_res_id      in bde_pd_lam_stl_daten.res_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_fertig(
    in_sid           in bde_pd_lam_stl_daten.sid%type,          --# System ID
		in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,     --# Mandantennummer
		in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
    in_fa_nr         in bde_pd_lam_stl_daten.fa_nr%type,
		in_fa_ag         in bde_pd_lam_stl_daten.fa_ag%type,
		in_fa_upos       in bde_pd_lam_stl_daten.fa_upos%type,
		in_res_id        in bde_pd_lam_stl_daten.res_id%type,
    in_menge_io      in bde_pd_prod.menge_a%type,
    in_menge_nio     in bde_pd_prod.menge_b%type,
    in_menge_schrott in bde_pd_prod.schrott%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_stl_lam_status(
    in_sid                 in bde_pd_lam_stl_daten.sid%type,                  --# System ID
		in_firma_nr            in bde_pd_lam_stl_daten.firma_nr%type,             --# Mandantennummer
		in_fe_lam_stl_daten_id in bde_pd_lam_stl_daten.pd_lam_stl_daten_id%type,
    in_status              in bde_pd_lam_stl_daten.status%type,
    in_res_id              in bde_pd_lam_stl_daten.res_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_stl_lam_fertig(
    in_sid           in bde_pd_lam_stl_daten.sid%type,           --# System ID
		in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,      --# Mandantennummer
		in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
    in_fa_nr         in bde_pd_lam_stl_daten.fa_nr%type,
		in_fa_ag         in bde_pd_lam_stl_daten.fa_ag%type,
		in_fa_upos       in bde_pd_lam_stl_daten.fa_upos%type,
    in_fa_ag_stl_id  in bde_pd_lam_stl_daten.fa_ag_stl_id%type,
		in_res_id        in bde_pd_lam_stl_daten.res_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--# Setzt die IST-Menge der verbrauchten, bzw. eingesetzten Bauteile auf den übergebenen Wert.
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_stl_lam_ist_menge(
    in_sid           in bde_pd_lam_stl_daten.sid%type,                --# System ID
		in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,           --# Mandantennummer
		in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
    in_fa_nr         in bde_pd_lam_stl_daten.fa_nr%type,
		in_fa_ag         in bde_pd_lam_stl_daten.fa_ag%type,
		in_fa_upos       in bde_pd_lam_stl_daten.fa_upos%type,
    in_fa_ag_stl_id  in bde_pd_lam_stl_daten.fa_ag_stl_id%type,
    in_ist_menge     in bde_pd_lam_stl_daten.stl_lam_ist_menge%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_upd_result_params(
    in_sid           in bde_pd_lam_stl_daten.sid%type,           --# System ID
    in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,      --# Mandantennummer
    in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
    in_fa_nr         in bde_pd_lam_stl_daten.fa_nr%type,
    in_fa_ag         in bde_pd_lam_stl_daten.fa_ag%type,
    in_fa_upos       in bde_pd_lam_stl_daten.fa_upos%type,
    in_fa_ag_stl_id  in bde_pd_lam_stl_daten.fa_ag_stl_id%type,
    in_result_params in bde_pd_lam_stl_daten.result_params%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_stl_lam_res_status(
    in_sid           in bde_pd_lam_stl_daten.sid%type,           --# System ID
		in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,      --# Mandantennummer
    in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
    in_fa_nr         in bde_pd_lam_stl_daten.fa_nr%type,
    in_fa_ag         in bde_pd_lam_stl_daten.fa_ag%type,
    in_fa_upos       in bde_pd_lam_stl_daten.fa_upos%type,
    in_fa_ag_stl_id  in bde_pd_lam_stl_daten.fa_ag_stl_id%type,
    in_res_id        in bde_pd_lam_stl_daten.res_id%type,
    in_res_status_id in bde_pd_lam_stl_daten.res_status_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_res_anmelden(
    in_sid           in bde_pd_lam_stl_daten.sid%type,          --# System ID
		in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,     --# Mandantennummer
		in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
    in_fa_nr         in bde_pd_lam_stl_daten.fa_nr%type,
		in_fa_ag         in bde_pd_lam_stl_daten.fa_ag%type,
		in_fa_upos       in bde_pd_lam_stl_daten.fa_upos%type,
	  in_res_id        in bde_pd_lam_stl_daten.res_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_ag_res_abmelden(
    in_sid           in bde_pd_lam_stl_daten.sid%type,          --# System ID
		in_firma_nr      in bde_pd_lam_stl_daten.firma_nr%type,     --# Mandantennummer
		in_fert_lam_id   in bde_pd_lam_stl_daten.fert_lam_id%type,
		in_res_id        in bde_pd_lam_stl_daten.res_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_update_qs_status(
    in_sid           in lvs_lam.sid%type,        --# System ID
		in_firma_nr      in lvs_lam.firma_nr%type,   --# Mandantennummer
		in_fert_lam_id   in lvs_lam.lam_id%type,
    in_qs_status     in lvs_lam.qs_status%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_entnahme_buchen(
    in_sid           in lvs_lam.sid%type,       --# System ID
		in_firma_nr      in lvs_lam.firma_nr%type,  --# Mandantennummer
		in_fert_lam_id   in lvs_lam.lam_id%type,
		in_res_id        in lvs_lam.res_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_update_last_fa_ag(
    in_sid           in lvs_lam.sid%type,       --# System ID
		in_firma_nr      in lvs_lam.firma_nr%type,  --# Mandantennummer
		in_fert_lam_id   in lvs_lam.lam_id%type,
    in_fa_ag         in lvs_lam.fa_ag%type,
    in_fa_upos       in lvs_lam.fa_upos%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_nio_insert(
    in_sid                 in  bde_pd_nio_daten.sid%type,                  --# System ID
		in_firma_nr            in  bde_pd_nio_daten.firma_nr%type,             --# Mandantennummer
		in_fert_lam_id         in  bde_pd_nio_daten.fert_lam_id%type,
    in_fe_lam_stl_daten_id in  bde_pd_nio_daten.pd_lam_stl_daten_id%type,
		in_res_id              in  bde_pd_nio_daten.res_id%type,
    in_nio_nr              in  bde_pd_nio_daten.nio_nr%type,
    in_nio_status          in  bde_pd_nio_daten.nio_status%type,
    in_nio_params          in  bde_pd_nio_daten.nio_params%type,
    out_nio_daten_id       out bde_pd_nio_daten.nio_daten_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_nio_update_status(
    in_sid          in bde_pd_nio_daten.sid%type,           --# System ID
		in_firma_nr     in bde_pd_nio_daten.firma_nr%type,      --# Mandantennummer
    in_nio_daten_id in bde_pd_nio_daten.nio_daten_id%type,
    in_nio_status   in bde_pd_nio_daten.nio_status%type,
    in_res_id       in bde_pd_nio_daten.res_id%type
  );

	-------------------------------------------------------------------------------------------------------
	--#
	-------------------------------------------------------------------------------------------------------
  procedure c_fe_nio_update_params(
    in_sid          in bde_pd_nio_daten.sid%type,           --# System ID
		in_firma_nr     in bde_pd_nio_daten.firma_nr%type,      --# Mandantennummer
    in_nio_daten_id in bde_pd_nio_daten.nio_daten_id%type,
    in_nio_params   in bde_pd_nio_daten.nio_params%type
  );

	-------------------------------------------------------------------------------------------------------
	--# TODO: -AG- Bitte nachdokumentieren!
	-------------------------------------------------------------------------------------------------------
  procedure c_res_status_beg(
    in_sid          in bde_pd_nio_daten.sid%type,          --# System ID
    in_firma_nr     in bde_pd_nio_daten.firma_nr%type,     --# Mandantennummer
    in_res_id       in isi_resource.res_id%type,
    in_st_id        in isi_res_status_cfg.res_st_id%type,
    in_st_ug_id     in isi_res_status.res_st_ug_id%type,
    v_login_id      in isi_user.login_id%type
  );
end;
/



-- sqlcl_snapshot {"hash":"a70644eb1461867a3933bb5461234ca7e7573513","type":"PACKAGE_SPEC","name":"FLS_P_BDE","schemaName":"DIRKSPZM32","sxml":""}