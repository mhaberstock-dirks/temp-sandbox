create or replace 
package DIRKSPZM32.lc is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  22.02.2007 11:15:16
  __________________________________________________
  Description
  Language Constants
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
	             3.4.0.0     (-WK-)   Package erstellt
  */


  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

  -- Language constants
  --C_TXT_P1_LVS_PLATZ_BELEGT constant varchar2(255) := 'C_TXT_P1_LVS_PLATZ_BELEGT'; -- 'Der Lagerplatz %1 ist belegt'
  --C_TXT_P1_LVS_PLATZ_GESPERRT constant varchar2(255) := 'C_TXT_P1_LVS_PLATZ_GESPERRT'; -- 'Der Lagerplatz %1 ist gesperrt'
  O_TXT_DB_ERROR                 constant varchar2(30) := 'O_TXT_DB_ERROR';                -- 'Es ist ein Datenbankfehler aufgetreten. Weitere Informationen unter Details.'
  O_TXT_CRITICAL_DB_ERROR        constant varchar2(30) := 'O_TXT_CRITICAL_DB_ERROR';       -- 'Es ist ein kritischer Datenbankfehler aufgetreten. Bitte benachrichtigen Sie den Administrator.'
  O_TXT_ID_LEANGENUEBERLAUF      constant varchar2(30) := 'O_TXT_ID_LEANGENUEBERLAUF';     -- 'Fehler: ID kann nicht gebildet werden. Längengenüberlauf';
  O_TP1_DEFAULT_U_ARTIKEL_FEHLT  constant varchar2(30) := 'O_TP1_DEFAULT_U_ARTIKEL_FEHLT'; -- 'Fehler: INIT-Artikel 0 und gesuchter <%1> fehlt.'
  O_TXT_FEHLER_WARE_ANLEGEN_LTE  constant varchar2(30) := 'O_TXT_FEHLER_WARE_ANLEGEN_LTE'; -- 'Fehler: Beim anlegen der Ware für die LTE.';
  O_TXT_LTE_ID_SCHON_VORHANDEN   constant varchar2(30) := 'O_TXT_LTE_ID_SCHON_VORHANDEN';  -- 'Fehler: LTE schon im Bestand.'
  O_TXT_DEFAULT_ARTIKEL_FEHLT    constant varchar2(30) := 'O_TXT_DEFAULT_ARTIKEL_FEHLT';   -- 'Fehler: INIT-Artikel mit Artikelid 0 fehlt.'

  O_TP1_LVS_PROD_LINIE_FEHLT     constant varchar2(30) := 'O_TP1_LVS_PROD_LINIE_FEHLT';    -- 'Produktionslinie ID: <%1> nicht vorhanden.'
  O_TXT_LVS_PROD_L_WARE_UNGUELT  constant varchar2(30) := 'O_TXT_LVS_PROD_L_WARE_UNGUELT'; -- 'Fehler: Keine gültigen Daten (Ware) für Linie gefunden'
  O_TP1_LVS_PROD_L_WARE_LEER     constant varchar2(30) := 'O_TP1_LVS_PROD_L_WARE_LEER';    -- 'Produktionslinie ID: <%1> hat keine Waren angelegt.'
  O_TP1_PALETTEN_TYP_FEHLT       constant varchar2(30) := 'O_TP1_PALETTEN_TYP_FEHLT';      -- 'Fehler: Transporteinheit TYP <%1> nicht vorhanden'
  O_TP2_PLATZ_EXISTIERT_NICHT    constant varchar2(30) := 'O_TP2_PLATZ_EXISTIERT_NICHT';   -- 'Fehler: Lagerplatz <%1> nicht vorhanden. Paltzprüfung für LTE: <%2>';

  O_TP1_LAGERPLATZ_IN_INVENTUR   constant varchar2(30) := 'O_TXT_LAGERPLATZ_IN_INVENTUR';  -- 'Fehler: Lagerplatz <%1> ist in Inventur.'
  O_TP2_LAGERPLATZ_GESPERRT      constant varchar2(30) := 'O_TP1_LAGERPLATZ_GESPERRT';     -- 'Fehler: Lagerplatz <%1> ist Gesperrt. Sperrgrund: <%2'>;
  O_TP1_PLATZ_KEIN_WE            constant varchar2(30) := 'O_TP1_PLATZ_KEIN_WE';           -- 'Fehler: Lagerplatz <%1> ist kein Wareneingangsplatz';
  O_TP1_SEQ_VORGANG              constant varchar2(30) := 'O_TP1_SEQ_VORGANG';             -- 'SEQ VORG_ID Fehler beim holen der Seq_Nummer <%1>!!!';
  O_TXT_SEQ_ERR                  constant varchar2(30) := 'O_TXT_SEQ_ERR';                 -- 'Fehler beim holen der Seq_Nummer!!!'

  O_TP1_LTE_ID_NICHT_BUCHBAR     constant varchar2(30) := 'O_TP1_LTE_ID_NICHT_BUCHBAR';    -- 'Neue LTE ist nicht buchbar (INSERT lvs_lte) <%1>'
  O_TP1_LTE_ID_UPDATE_ERR        constant varchar2(30) := 'O_TP1_LTE_ID_UPDATE_ERR';       -- 'Update der LTE <%1> nicht möglich';
  O_TP2_LTE_BUCH_PLATZ_ERR       constant varchar2(30) := 'O_TP2_LTE_BUCH_PLATZ_ERR';      -- 'Fehler beim Buchen der LTE <%1> auf den Lagerplatz <%2> nicht möglich'
  O_TP1_LTE_ID_FEHLT             constant varchar2(30) := 'O_TP1_LTE_ID_FEHLT';            -- 'Fehler: LTE ID <%1> existiert nicht'
  O_TP2_LTE_ID_ST_N_LOESCHBAR    constant varchar2(30) := 'O_TP1_LTE_ID_ST_N_LOESCHBAR';   -- 'Fehler: LTE <%1> hat Status <%2> und kann nicht gelöscht werden';

  O_TP2_LTE_ID_TRANS_N_LOESCHBAR constant varchar2(30) := 'O_TP2_LTE_ID_TRANS_N_LOESCHBAR';-- 'Fehler: LTE <%1> wird zum Lagerplatz <%2> transportiert und kann nicht gelöscht werden';
  O_TP1_FIRMENSTAMM_FEHLT        constant varchar2(30) := 'O_TP1_FIRMENSTAMM_FEHLT';       -- 'Firmenstammdaten nicht gefunden für Firma Nr.: <%1>';
  O_TP1_LHM_ID_OHNE_BESTAND      constant varchar2(30) := 'O_TP1_LHM_ID_OHNE_BESTAND';     -- 'Fehler: Kein Lagerbestand für LHM-ID <%1>';
  O_TP1_ARTIKEL_ID_FEHLT         constant varchar2(30) := 'O_TP1_ARTIKEL_ID_FEHLT';        -- 'Artikelstammdaten nicht gefunden für Artikel-ID: <%1>';
  O_TP1_ETIKETTEN_LAYOUT_FEHLT   constant varchar2(30) := 'O_TP1_ETIKETTEN_LAYOUT_FEHLT';  -- 'Etikettenlayout <%1> fehlt';

  O_TP1_ETI_DATEI_UNTERSTUETZT   constant varchar2(30) := 'O_TP1_ETI_DATEI_UNTERSTUETZT';  -- 'Etikettenlayoutdatei <%1> wird nicht unterstützt'
  O_TP1_LTE_ID_W_TRANSPORTIERT   constant varchar2(30) := 'O_TP1_LTE_ID_W_TRANSPORTIERT';  -- 'Fehler: LTE <%1> wird grade Transportiert.';
  O_TP1_LTE_ID_W_BEFUELLT        constant varchar2(30) := 'O_TP1_LTE_ID_W_BEFUELLT';       -- 'Fehler: LTE <%1> wird noch befüllt.';
  O_TP1_LTE_ID_AUSGEL_M_RES      constant varchar2(30) := 'O_TP1_LTE_ID_AUSGEL_M_RES';     -- 'Fehler: LTE <%1> bereits ausgelagert mit Reservierung.';
  O_TP1_LTE_ID_IST_LEER          constant varchar2(30) := 'O_TP1_LTE_ID_IST_LEER';         -- 'Fehler: Transporteinheit <%1> ist eine Leerpalette.';

  O_TP3_LTE_M_LIEFERS_VORHADEN   constant varchar2(30) := 'O_TP3_LTE_M_LIEFERS_VORHADEN';  -- 'Fehler: LTE <%1> Lieferscheineintrag <%2/%3> bereits vorhanden.'
  O_TP1_LTE_LIEFERS_DIFF         constant varchar2(30) := 'O_TP1_LTE_LIEFERS_DIFF';        -- 'Fehler: LTE-Daten der LTE: <%1> stimmen nicht mehr mit dem Lieferschein überein'
  O_TP1_LTE_ID_AUSGEL            constant varchar2(30) := 'O_TP1_LTE_ID_AUSGEL';           -- 'Fehler: LTE: <%1> bereits ausgelagert.'
  O_TP2_LTE_ID_RES_ERR           constant varchar2(30) := 'O_TP2_LTE_ID_RES_ERR';          -- 'Fehler: LTE <%1> ist nicht für die Tour <%2> reserviert.'
  O_TP1_LAGERPLATZ_FEHLT         constant varchar2(30) := 'O_TP1_LAGERPLATZ_FEHLT';        -- 'Fehler: Lagerplatz <%1> fehlt.'

  O_TP1_LTE_ID_GESP_WARE_AUSL    constant varchar2(30) := 'O_TP1_LTE_ID_GESP_WARE_AUSL';   -- 'Fehler: Gesperrte Ware auf der LTE <%1>. Auslagern nicht möglich. '
  O_TP2_LTE_ID_ST_N_AUSL_BAR     constant varchar2(30) := 'O_TP2_LTE_ID_ST_N_AUSL_BAR';    -- 'LTE <%1> mit Status <%2> kann nicht ausgelagert werden.'
  O_TP1_Q_LGR_PLATZ_FEHLT        constant varchar2(30) := 'O_TP1_Q_LGR_PLATZ_FEHLT';       -- 'Fehler: Quellenlagerplatz: <%1> fehlt.'
  O_TP1_FEHERABHANDLUNG_FEHLT    constant varchar2(30) := 'O_TP1_FEHERABHANDLUNG_FEHLT';   -- 'Fehler: Fehlerabhandlung Prog.Nr.:<%1> fehlt'
  O_TP1_BUCH_ERR                 constant varchar2(30) := 'O_TP1_BUCH_ERR';                -- 'Fehler beim Schreiben der Buchung %1';

  O_TP2_PRUEFZIFFER_ERR          constant varchar2(30) := 'O_TP2_PRUEFZIFFER_ERR';         -- 'Pruefziffer ist falsch!! Gefunden <%1>, Berechnet <%2>'
  O_TXT_BUCH_ERR_VERBRAUCH       constant varchar2(30) := 'O_TXT_BUCH_ERR_VERBRAUCH';      -- 'Fehler: Lagerbuchung Verbrauch konnte nicht gelesen werden';
  O_TXT_LAGERBEST_N_LESBAR       constant varchar2(30) := 'O_TXT_LAGERBEST_N_LESBAR';      -- 'Fehler: Lagerbbestand konnte nicht gelesen werden'
  O_TP1_Q_LTE_ID_FEHLT           constant varchar2(30) := 'O_TP1_Q_LTE_ID_FEHLT';          -- 'Fehler: Quelle LTE <%1> Fehlt'
  O_TP2_BUC_LAM_BH_ERR           constant varchar2(30) := 'O_TP2_BUC_LAM_BH_ERR';          -- 'Buchung für Buch_id, LAM_ID: <%1>/<%2> nicht möglich'

  O_TP1_LHM_ID_FEHLT             constant varchar2(30) := 'O_TP1_LHM_ID_FEHLT';            -- 'LHM: <%1> Fehlt!!!'
  O_TP1_LHM_ID_N_IM_LAGER        constant varchar2(30) := 'O_TP1_LHM_ID_N_IM_LAGER';       -- 'LHM: <%1> ist noch nicht eingelagert!!!'
  O_TP1_LTE_OHNE_LGR_PLATZ       constant varchar2(30) := 'O_TP1_LTE_OHNE_LGR_PLATZ';      -- 'Fehler: LTE ID: <%1> hat keinen Lagerplatz'
  O_TP1_LTE_WIEDER_EINL_UNMOEGL  constant varchar2(30) := 'O_TP1_LTE_WIEDER_EINL_UNMOEGL'; -- 'Fehler: Für LTE mit ID <%1> ist die Wiedereinlagerung nicht möglich.
  O_TP2_LTE_ERR_HAT_STATUS       constant varchar2(30) := 'O_TP2_LTE_ERR_HAT_STATUS';      -- 'Fehler: LTE mit ID <%1> hat Status <%2>.'

  O_TP1_ARTIKEL_FEHLT            constant varchar2(30) := 'O_TP1_ARTIKEL_FEHLT';           -- 'Fehler: Artikel <%1> fehlt'
  O_TP2_ARTIKEL_MENGE_LEER       constant varchar2(30) := 'O_TP2_ARTIKEL_MENGE_LEER';      -- 'Fehler: Artikel <%1> auf LTE <%2> darf nicht auf Menge 0 gesetzt werden';
  O_TP1_LAM_FEHLT                constant varchar2(30) := 'O_TP1_LAM_FEHLT';               -- 'Fehler: LAM <%1> ist nicht vorhanden'
  O_TP1_LAM_BH_FEHLT             constant varchar2(30) := 'O_TP1_LAM_BH_FEHLT';            -- 'Fehler: Lam_bh <%1> ist nicht vorhanden'
  O_TP1_LTE_HAT_MEHR_EINE_LHM    constant varchar2(30) := 'O_TP1_LTE_HAT_MEHR_EINE_LHM';   -- 'Fehler: Auf LTE: <%1> ist mehr als eine LHM vorhanden.'

  O_TP1_LHM_CFG_FEHLT            constant varchar2(30) := 'O_TP1_LHM_CFG_FEHLT';           -- 'Fehler: LHM_CFG: <%1> ist nicht vorhanden.'
  O_TXT_LTE_HAT_RES_AUFT_ERR     constant varchar2(30) := 'O_TXT_LTE_HAT_RES_AUFT_ERR';    -- 'Fehler: Auf der Lagermenge ist eine Reservierung. Aufteilung der Lagermengen in LHM nicht möglich.';
  O_TP2_LTE_PLATZ_T_PLATZ_DIFF   constant varchar2(30) := 'O_TP2_LTE_PLATZ_T_PLATZ_DIFF';  -- 'Fehler: LTE Lagerplatz <%1> Transportlagerplatz <%2> stimmen nicht überein.';
  O_TP1_Z_LGR_PLATZ_FEHLT        constant varchar2(30) := 'O_TP1_Z_LGR_PLATZ_FEHLT';       -- 'Fehler: Ziel  Lagerplatz <%1> nicht vorhanden';
  O_TP1_LGR_PLATZ_LEER           constant varchar2(30) := 'O_TP1_LGR_PLATZ_LEER';          -- 'Fehler: Lagerplatz  <%1> ist leer.'

  O_TP2_WEG_VON_NACH_FALSCH      constant varchar2(30) := 'O_TP2_WEG_VON_NACH_FALSCH';     -- 'Fehler: Transport von <%1> Nach <%2> nicht möglich';
  O_TXT_NUR_FREI_TRANS_SPERREN   constant varchar2(30) := 'O_TXT_NUR_FREI_TRANS_SPERREN';  -- 'Nur ein freier Transport kann gesperrt werden.'
  O_TXT_LTE_M_GESP_WARE          constant varchar2(30) := 'O_TXT_LTE_M_GESP_WARE';         -- 'Es ist noch gesperrte Ware auf der LTE. Vor der Verladung erst abpacken. ';
  O_TP1_TRAM_MIT_ID_FEHLT        constant varchar2(30) := 'O_TP1_TRAM_MIT_ID_FEHLT';       -- 'Fehler: TransportId <%1> ist unbekannt';
  O_TP1_TRANSP_ID_NF             constant varchar2(30) := 'O_TP1_TRANSP_ID_NF';            -- 'Transport ID <%1> not found';
  O_TXT_LGR_PLATZ_GLEICH_BEREICH constant varchar2(30) := 'O_TXT_LGR_PLATZ_GLEICH_BEREICH';-- 'Fehler: Die Lagerplaetze müßen zum gleichen Bereich gehören'

  O_TXT_LGR_PLATZ_VON_KLEIN_BIS  constant varchar2(30) := 'O_TXT_LGR_PLATZ_VON_KLEIN_BIS'; -- 'Fehler: Der von Lagerplatz muß kleiner als der bis Lagerplatze sein';
  O_TP2_LGR_ORT_IN_INVENTUR      constant varchar2(30) := 'O_TP2_LGR_ORT_IN_INVENTUR';     -- 'Lagerort <%1> <%2> ist in Inventur!';
  O_TP3_LGR_KEINE_FLAECH         constant varchar2(30) := 'O_TP3_LGR_KEINE_FLAECH';        -- 'Die LTE <%1> Type <%2> darf am Lagerplatz <%3> nicht eingelagert werden, da der Palettentyp einen Flächenstellplatz benötigt';
  O_TP3_LGR_FUER_LTE_ERR         constant varchar2(30) := 'O_TP3_LGR_FUER_LTE_ERR';        -- 'Die LTE <%1> Type <%2> darf am Lagerplatz <%3> nicht eingelagert werden';
  O_TP2_LGR_ZU_KALT              constant varchar2(30) := 'O_TP2_LGR_ZU_KALT';             -- 'Der Lagerplatz ist zu kalt für die LTE <%1> Type <%2>';

  O_TP2_LGR_ZU_WARM              constant varchar2(30) := 'O_TP2_LGR_ZU_WARM';             -- 'Der Lagerplatz ist zu warm für die LTE <%1> Type <%2>';
  O_TP2_LGR_WERT_K_ZU_GROSS      constant varchar2(30) := 'O_TP2_LGR_WERT_K_ZU_KLEIN';     -- 'Die Wert Klasse der Ware ist zu gross für den Lagerplatz <%1> Check für LTE: <%2>';
  O_TP2_LGR_G_KLASSE_ZU_GROSS    constant varchar2(30) := 'O_TP2_LGR_G_KLASSE_ZU_GROSS';   -- 'Die Gefahren Klasse der Ware ist zu gross für den Lagerplatz <%1> Check für LTE: <%2>';
  O_TP2_LGR_WERT_K_ZU_KLEIN      constant varchar2(30) := 'O_TP2_LGR_WERT_K_ZU_KLEIN';     -- 'Die Wert Klasse der Ware ist zu klein für den Lagerplatz <%1> Check für LTE: <%2>';
  O_TP2_LGR_G_KLASSE_ZU_KLEIN    constant varchar2(30) := 'O_TP2_LGR_G_KLASSE_ZU_KLEIN';   -- 'Die Gefahren Klasse der Ware ist zu klein für den Lagerplatz <%1> Check für LTE: <%2>';
  O_TP2_LGR_PLATZ_VOLL           constant varchar2(30) := 'O_TP2_LGR_PLATZ_VOLL';          -- 'Der Lagerplatz <%1> ist voll. Check für LTE: <%2>';

  O_TP2_LGR_PLATZ_KOMPL_RES      constant varchar2(30) := 'O_TP2_LGR_PLATZ_KOMPL_RES';     -- 'Der Lagerplatz <%1> ist komplett reserviert. Check für LTE: <%2>';
  O_TP2_LGR_LTE_Z_SCHWER         constant varchar2(30) := 'O_TP2_LGR_LTE_Z_SCHWER';        -- 'Die LTE ist zu schwer für den Lagerplatz <%1>. Check für LTE: <%2>';
  O_TP2_LGR_LTE_Z_HOCH           constant varchar2(30) := 'O_TP2_LGR_LTE_Z_HOCH';          -- 'Die freihe Höhe für den Lagerplatz <%1> reicht nicht aus. Check für LTE: <%2>';
  O_TP2_LGR_LTE_Z_BREIT          constant varchar2(30) := 'O_TP2_LGR_LTE_Z_BREIT';         -- 'Die freihe Breite für den Lagerplatz <%1> reicht nicht aus. Check für LTE: <%2>';
  O_TP2_LGR_LTE_Z_TIEF           constant varchar2(30) := 'O_TP2_LGR_LTE_Z_TIEF';          -- 'Die freihe Tiefe für den Lagerplatz <%1> reicht nicht aus. Check für LTE: <%2>';

  O_TP2_LGR_LTE_TYP_FALSCH       constant varchar2(30) := 'O_TP2_LGR_LTE_TYP_FALSCH';      -- 'Die LTE <%1> Type <%2> passt nicht auf diesen Lagerplatz';
  O_TP2_LGR_TYP_FEHLT            constant varchar2(30) := 'O_TP2_LGR_TYP_FEHLT';           -- 'Unbekannter Lagertyp <%1> in Konfiguration prüfen. Lagerplatz <%2>;
  O_TXT_LGR_STAT_RES_ART_ERR     constant varchar2(30) := 'O_TXT_LGR_STAT_RES_ART_ERR';    -- 'Fehler: Ein Lagerplatz kann kann entweder für einen Artikel oder auf eine ReservirungsCode resewrviert werden!';
  O_TP1_LGR_PLATZ_GRP_FEHLT      constant varchar2(30) := 'O_TP1_LGR_PLATZ_GRP_FEHLT';     -- 'Fehler: Lagerplatzgruppe <%1> fehlt!'
  O_TXT_LGR_TYP_STAT_RES_ERR     constant varchar2(30) := 'O_TXT_LGR_TYP_STAT_RES_ERR';    -- 'Fehler: Nur Lagerplätze vom Typ (SAT, KANAL, KANAL BLOCK, FACH, SAT EPL) können auf einen ReservirungsCode resewrviert werden!';

  O_TP2_LGR_LTE_TPY_ART_ERR      constant varchar2(30) := 'O_TP2_LGR_LTE_TPY_ART_ERR';     -- 'Fehler: Lagerplätze können grundsätzlich nur LTE''s vom Typ <%1> aufnehmen. Der Artikel hat den LTE-Typ <%2> als Standard eingetragen.';
  O_TXT_LGR_M_DISPO_O_LTE        constant varchar2(30) := 'O_TXT_LGR_M_DISPO_O_LTE';       -- 'Fehler: Lagerplätze müssen leer und ohne Disponierungen sein!'
  O_TXT_LGR_M_DISPO              constant varchar2(30) := 'O_TXT_LGR_M_DISPO';             -- 'Fehler: Lagerplätze müssen ohne Disponierungen sein! Disponierungen liegen vor!';
  O_TP1_LGR_KEIN_FAHRZEUG        constant varchar2(30) := 'O_TP1_LGR_KEIN_FAHRZEUG';       -- 'Fehler: Kein Lagerplatz für LTE: <%1> möglich. Keine Fahrzeuge gefunden oder defekt.';
  O_TXT_LGR_ORT_N_ERFASST        constant varchar2(30) := 'O_TP1_LGR_ORT_N_ERFASST';       -- 'Fehler: Kein Lagerort für die Platzsuche angegeben.';

  O_TP4_LGR_PLATZ_MAX_FAKT_ERR   constant varchar2(30) := 'O_TP4_LGR_PLATZ_MAX_FAKT_ERR';  -- 'Fehler: Kein Lagerplatz für LTE: <%1> gefunden mit Faktor <%2> und Maximalfaktor <%3>. Lagerplatz: <%4> Grund : Maximalfaktor für Einlagerung überschritten';
  O_TP3_LGR_PLATZ_RES_ANBR_ERR   constant varchar2(30) := 'O_TP3_LGR_PLATZ_RES_ANBR_ERR';  -- 'Fehler: Kein Lagerplatz für LTE:<%1> gefunden. Lagerplatz: <%2> Grund : LTE benötigt einen Lagerplatz mit Reservierung <%3>';
  O_TP3_LGR_F_LTE_N_GEFUNDEN_TC  constant varchar2(30) := 'O_TP3_LGR_F_LTE_N_GEFUNDEN_TC'; -- 'Fehler: Kein Lagerplatz für LTE: <%1> gefunden. Lagerplatz: <%2> Grund : <%3TC>;
  O_TP1_LGR_F_LTE_N_GEFUNDEN     constant varchar2(30) := 'O_TP1_LGR_F_LTE_N_GEFUNDEN';    -- 'Fehler: Kein Lagerplatz für LTE: <%1> gefunden.';
  O_TP1_LTE_CFG_FEHLT            constant varchar2(30) := 'O_TP1_LTE_CFG_FEHLT';           -- 'Fehler: LTE_CFG: <%1> ist nicht vorhanden.'

  O_TP2_LTE_ID_ST_N_EINL_BAR     constant varchar2(30) := 'O_TP2_LTE_ID_ST_N_EINL_BAR';    -- 'LTE <%1> mit Status <%2> kann nicht eingelagert werden.'
  O_TP4_LGR_ORT_FALSCHES_MODUL   constant varchar2(30) := 'O_TP4_LGR_ORT_FALSCHES_MODUL';  -- 'Fehler: Lagerort <%1> für PLatz <%2> von Modul <%3> kann nicht vom Modul <%4> bearbeitet werden.';
  O_TP1_BEWEGUNGSART_FALSCH      constant varchar2(30) := 'O_TP1_BEWEGUNGSART_FALSCH';     -- Fehler: Bewegungsart <%1>  wird nicht untersützt!'
  O_TP2_LGR_ORT_FUER_PLATZ_FEHLT constant varchar2(30) := 'O_TP2_LGR_ORT_FUER_PLATZ_FEHLT';-- 'Fehler: Lagerort <%1> für PLatz <%2> nicht vorhanden';
  O_TP1_LGR_PLATZ_N_LEER         constant varchar2(30) := 'O_TP1_LGR_PLATZ_N_LEER';        -- 'Fehler: Lagerplatz  <%1> ist nicht leer.'

  O_TP1_INV_ARTIKEL_STATUS_ERST  constant varchar2(30) := 'O_TP1_INV_ARTIKEL_STATUS_ERST'; -- 'Es konnten keine Daten für Artikelstatus gefunden bzw. erstellt werden. (Artikel: <%1>)';
  O_TP2_INV_ARTIKEL_IST_INVERTUR constant varchar2(30) := 'O_TP2_INV_ARTIKEL_IST_INVERTUR';-- 'Auf dem Artikel <%1> wird bereits eine Inventur durchgeführt (Inventur ID: <%2>)';
  O_TP1_LHM_AUF_LTE_N_UNINQUE    constant varchar2(30) := 'O_TP1_LHM_AUF_LTE_N_UNINQUE';   -- 'Eine einzelne LHM kann nicht eindeutig ermittelt werden, da auf der LTE (ID: <%1> mehr als eine LHM vorhanden ist.');
  O_TP1_ARTIKEL_ID_STATUS_ERST   constant varchar2(30) := 'O_TP1_ARTIKEL_ID_STATUS_ERST';  -- 'Es konnten keine Daten für Artikelstatus gefunden bzw. erstellt werden. (Artikel ID: <%1>)';
  O_TXT_OPTI_FREI_PLAETZE_N_AUSR constant varchar2(30) := 'O_TXT_OPTI_FREI_PLAETZE_N_AUSR';-- 'Fehler: Nicht genügend freie Lagerplätze um die Optimierung durchzuführen.';

  O_TP1_Z_PLATZ_IN_GRP_N_LESBAR  constant varchar2(30) := 'O_TP1_Z_PLATZ_IN_GRP_N_LESBAR'; -- 'Fehler: Ziellagerplatz in Gruppe <%1> nicht zu lesen.';
  O_TP1_LGR_F_LTE_N_GRUND_AUSL   constant varchar2(30) := 'O_TP1_LGR_F_LTE_N_GRUND_AUSL';  -- 'Fehler: Kein Lagerplatz für LTE: <%1> Lagerplatz: <%2> Grund : Lagerplatz hat auslagerungen';
  O_TP2_LTE_ZLTE_GLIECH_QLTE     constant varchar2(30) := 'O_TP2_LTE_ZLTE_GLIECH_QLTE';    -- 'Fehler: Quell LTE <%1> darf nicht Ziel LTE <%2> sein';
  O_TP2_LTE_M_STATUS_LOESCHEN    constant varchar2(30) := 'O_TP2_LTE_M_STATUS_LOESCHEN';   -- 'Fehler: LTE <%1> mit Status <%2> kann nicht vom Lagerplatz gelöscht werden';
  O_TXT_LTE_FUER_MATERIAL_N_GEBU constant varchar2(30) := 'O_TXT_LTE_FUER_MATERIAL_N_GEBU';-- 'Fehler: Keine LTE für Material gebucht.';

  O_TP1_LAM_ZUG_BUCHUNG_ERR      constant varchar2(30) := 'O_TP1_LAM_ZUG_BUCHUNG_ERR';     -- 'Zugangsbuchung für LAM ID: <%1> nicht möglich';
  O_TP3_LAM_BH_BUCH_F_LAM_N_MOEG constant varchar2(30) := 'O_TP3_LAM_BH_BUCH_F_LAM_N_MOEG';-- 'LAM_BH Buchunge: Buchunge für Vorg, Buch_id, LAM_ID: ' || v_vorg_id || '/' || v_lam_bh_id || '/' || v_lam_id || ' nicht möglich';
  O_TP2_LGR_PLATZ_FEHLT_C_LTE    constant varchar2(30) := 'O_TP2_LGR_PLATZ_FEHLT_C_LTE';   -- 'Fehler: Lagerplatz <%1> nicht vorhanden. Paltzprüfung für LTE: <%2>';
  O_TXT_LTE_N_POS_OHNE_LTE_ERR   constant varchar2(30) := 'O_TXT_LTE_N_POS_OHNE_LTE_ERR';  -- 'Mehrere Positionen in den Linienwaren nicht möglich, wenn LTE Typ = "-Ohne LTE".';
  O_TXT_LTE_ANLEG_ERR            constant varchar2(30) := 'O_TXT_LTE_ANLEG_ERR';           -- 'LTE konnte nicht angelegt werden.';

  O_TP1_ORDER_AUF_ID_FEHLT       constant varchar2(30) := 'O_TP1_ORDER_AUF_ID_FEHLT';      -- 'Die Order mit der Nummer (auf_id) <%1> fehlt.';
  O_TXT_BUCHEN_O_ID_N_MOEGLICH   constant varchar2(30) := 'O_TXT_BUCHEN_O_ID_N_MOEGLICH';  -- 'Buchen ohne ID (kein Barcode) nicht möglich'
  O_TP3_ORDER_FREIDATUM_ERR      constant varchar2(30) := 'O_TP3_ORDER_FREIDATUM_ERR';     -- 'Fehler: Die Aktivierung der Tour <%1> für Lieferschein <%2> ist erst am <%3> möglich!';
  O_TP2_ORDER_AKTIV_OHNE_ARBPLZ  constant varchar2(30) := 'O_TP2_ORDER_AKTIV_OHNE_ARBPLZ'; -- 'Fehler: Die Aktivierung der Tour <%1> für Lieferschein <%2> nicht möglich, da die Arbeitsplatz_ID fehlt.';
  O_TP1_ORDER_POS_WA_FEHLT       constant varchar2(30) := 'O_TP1_ORDER_POS_WA_FEHLT';      -- 'Fehler: Nicht in allen Positionen ist ein WA für die Auslagerung eingetragen. Aktivierung der Tour <%1> nicht möglich!';

  O_TP1_ORDER_RES_OHNE_ARBPLZ    constant varchar2(30) := 'O_TP1_ORDER_RES_OHNE_ARBPLZ';   -- 'Fehler: Die Reservirung von Ware für Lieferschein <%1> nicht möglich, da die Arbeitsplatz_ID fehlt.';
  O_TP2_ORDER_LIEF_KOPF_FEHLT    constant varchar2(30) := 'O_TP2_ORDER_LIEF_KOPF_FEHLT';   -- 'Fehler: Kopfdaten für Lieferschein <%1> Pos. <%2> fehlt.';
  O_TXT_DISOP_L_ERR_FIFO         constant varchar2(30) := 'O_TXT_DISOP_L_ERR_FIFO';        -- 'Das Löschen dieser Disponierung ist nicht möglich, da FIFO eingehalten werden muss.'
  O_TP2_LTE_LGR_ORT_FEHLT        constant varchar2(30) := 'O_TP2_LTE_LGR_ORT_FEHLT';       -- 'Fehler: Der in der LTE <%1> eingetragene Lagerort <%2> fehlt!';
  O_TXT_BESTAND_KLEINER_NULL     constant varchar2(30) := 'O_TXT_BESTAND_KLEINER_NULL';    -- 'Fehler: Bestand dann unter Null.';

  O_TP4_LTE_STATUS_FALSCH        constant varchar2(30) := 'O_TP4_LTE_STATUS_FALSCH';       -- 'LTE Status <%1> ist falsch. Status muss <%2> oder <%3> sein! Check bei LTE_ID: <%4>';
  O_TP1_LTE_IST_RES              constant varchar2(30) := 'O_TP1_LTE_IST_RES';             -- 'Fehler: Diese LTE <%1> ist bereits für einen Auftrag reserviert.'
  O_TP2_LGR_ORT_KEINE_SCHNELLVER constant varchar2(30) := 'O_TP2_LGR_ORT_KEINE_SCHNELLVER';-- 'Lagerort <%1> ist für Lager-Modul  <%2> und kann nicht für die Schnellverladung genutzt werden';
  O_TXT_ORDER_FEHLT              constant varchar2(30) := 'O_TXT_ORDER_FEHLT';             -- 'ISI-Order ist nicht gefunden'
  O_TXT_ORDER_AUFT_ZU            constant varchar2(30) := 'O_TXT_ORDER_AUFT_ZU';           -- 'ISI-Order Auftrag ist schon geschlossen';

  O_TXT_ORDER_AUFT_DIR_VERL      constant varchar2(30) := 'O_TXT_ORDER_AUFT_DIR_VERL';     -- 'ISI-Order Auftrag hat nicht das Kennzeichen >>Direkt Verladung<<'
  O_TXT_ORDER_AUFT_NO_UPDATE     constant varchar2(30) := 'O_TXT_ORDER_AUFT_NO_UPDATE';    -- 'ISI-Order Auftrag ist nicht aktualisiert worden';
  O_TXT_ORDER_M_TRANS_N_CLOSE    constant varchar2(30) := 'O_TXT_ORDER_M_TRANS_N_CLOSE';   -- 'Es gibt Transport Auftraege. ISI-Order Auftrag kann nicht geschlossen werden';
  O_TP2_ORDER_UML_FREIDATUM_ERR  constant varchar2(30) := 'O_TP2_ORDER_UML_FREIDATUM_ERR'; -- 'Fehler: Die Aktivirung der Umlagerung <%1> ist erst am <%2> möglich!';
  O_TP1_ORDER_UML_POS_WA_FEHLT   constant varchar2(30) := 'O_TP1_ORDER_UML_POS_WA_FEHLT';  -- 'Fehler: Nicht in allen Positionen ist ein WA für die Auslagerung eingetragen. Aktivierung der Umlagerung <%1> nicht möglich!';


  O_TP1_CHARGE_ZU_KURZ           constant varchar2(30) := 'O_TP1_CHARGE_ZU_KURZ';          -- 'Fehler: Charge ist zu kurz! MIN Länge = <%1> zugeordnet!'';
  O_TP1_CHARGE_ZU_LANG           constant varchar2(30) := 'O_TP1_CHARGE_ZU_LANG';          -- 'Fehler: Charge ist zu lang! MAX Länge = <%1> zugeordnet!'';
  O_TP2_CHARGE_IST_ZUGEORDNED    constant varchar2(30) := 'O_TP2_CHARGE_IST_ZUGEORDNED';   -- 'Fehler: Charge <%1> ist <%2> zugeordnet!'';
  O_TP2_ORDER_VORG_KOPF_FEHLT    constant varchar2(30) := 'O_TP2_ORDER_VORG_KOPF_FEHLT';   -- 'Fehler: Kopfdaten für Tour <%1> Lieferschein <%2> fehlt.';
  O_TP1_LAGERO_F_ARBEITSPL_FEHLT constant varchar2(30) := 'O_TP1_LAGERO_F_ARBEITSPL_FEHLT';-- 'Fehler: Lagerorte für Arbeitsplatz <%1> fehlen!'

  O_TP3_BESTANDS_MG_FEHLT_BDE    constant varchar2(30) := 'O_TP5_BESTANDS_MG_FEHLT_L1';    -- 'Warnung: Bestandsmengen nicht Ausreichend!'
                                                                                           -- 'Fehler bei FA_AUFTR/AG/UPOS <%1>/<%2>/<%2> ' ||
  O_TP5_BESTANDS_MG_FEHLT_L1     constant varchar2(30) := 'O_TP5_BESTANDS_MG_FEHLT_L1';    -- 'Warnung: Bestandsmengen nicht Ausreichend!'
                                                                                           -- 'Lieferschein <%1>/<%2> benötigt ' ||
                                                                                           -- '<%3> <%4>, <%5> reserviert!'

  O_TP5_BESTANDS_MG_Z_VIEL_L1    constant varchar2(30) := 'O_TP5_BESTANDS_MG_Z_VIEL_L1';    -- 'Warnung: Zu viel reserviert!'
  --O_TP5_BESTANDS_MG_Z_VIEL_L1    constant varchar2(30) := 'O_TP3_BESTANDS_MG_FEHLT_BDE';    -- 'Warnung: Zu viel reserviert!'
                                                                                            -- 'Lieferschein <%1>/<%2> benötigt ' ||
                                                                                            -- '<%3> <%4>, <%5> reserviert!'
  O_TP2_ORDER_VORG_AUFID_FEHLT   constant varchar2(30) := 'O_TP2_ORDER_VORG_AUFID_FEHLT';   -- 'Fehler: Tour <%1> AUF_ID <%2> fehlt.';
  O_TP1_ORDER_LIEF_UMLA_FEHLT    constant varchar2(30) := 'O_TP1_ORDER_LIEF_UMLA_FEHLT';    -- 'Fehler: Kopfdaten für Umlagerung: <%1> nicht vorhanden!';

  O_TP5_BESTANDS_UL_FEHLT_L1     constant varchar2(30) := 'O_TP5_BESTANDS_MG_FEHLT_L1';    -- 'Warnung: Bestandsmengen nicht Ausreichend!'
                                                                                           -- 'Umlagerung <%1>/<%2> benötigt ' ||
                                                                                           -- '<%3> <%4>, <%5> reserviert!'
  O_TP5_BESTANDS_UL_Z_VIEL_L1    constant varchar2(30) := 'O_TP5_BESTANDS_UL_Z_VIEL_L1';   -- 'Warnung: Zu viel reserviert!'
                                                                                           -- 'Umlagerung <%1>/<%2> benötigt ' ||
                                                                                           -- '<%3> <%4>, <%5> reserviert!'

  O_TXT_ORDER_TOUR_HAT_TRANSP    constant varchar2(30) := 'O_TXT_ORDER_TOUR_HAT_TRANSP';   -- 'Fehler: Es sind bereits Transporte für diese Tour eingetragen.';
  O_TXT_VORB_FREI_PLAETZE_N_AUSR constant varchar2(30) := 'O_TXT_VORB_FREI_PLAETZE_N_AUSR';-- 'Fehler: Nicht genügend Lagerplätze die die Bedingungen für die Paletten in dieser Tour erfüllen. ';
  O_TXT_FREI_PLAETZE_N_AUSR      constant varchar2(30) := 'O_TXT_FREI_PLAETZE_N_AUSR';     -- 'Fehler: Nicht genügend freie Lagerplätze.';
  O_TXT_TOUR_HAT_NOCH_RES        constant varchar2(30) := 'O_TXT_TOUR_HAT_NOCH_RES';       -- 'Fehler: Es sind noch Transporteinheiten für diese Tour reserviert, Fertigmeldung nicht möglich.';
  O_TP1_LAM_ID_FEHLT             constant varchar2(30) := 'O_TP1_LAM_ID_FEHLT';            -- 'Fehler: LAM_ID <%1> existiert nicht'

  O_TXT_LTE_HAT_NOCH_LHM_O_RES   constant varchar2(30) := 'O_TXT_LTE_HAT_NOCH_LHM_O_RES';  -- 'Fehler: Es ist Ware auf der LTE, die für keien Auftrag Reserviert wurde. Diese Ware muss erst abpackt werden.';
  O_TXT_LTE_HAT_NOCH_LHM_F_RES   constant varchar2(30) := 'O_TXT_LTE_HAT_NOCH_LHM_F_RES';  -- 'Fehler: Es befindet sich Ware auf der LTE, die nicht zu diesem Auftrag gehört. Diese muss vor der Verladung erst abpackt werden.';
  O_TP1_LTE_WIRD_SCHON_TRANSP    constant varchar2(30) := 'O_TP1_LTE_WIRD_SCHON_TRANSP';   -- 'Die LTE ID <%1> ist bereits im Transport '
  O_TP1_ORDER_VORG_FEHLT         constant varchar2(30) := 'O_TP1_ORDER_VORG_FEHLT';        -- 'Fehler: Order-Kopf für Vorgang ID <%1> fehlt.';
  O_TP1_RES_ERROR                constant varchar2(30) := 'O_TP1_RES_ERROR';               -- 'Fehler: Beim Reservieren ist ein Fehler Aufgetreten. Fehlernr. : <%1>.';

  O_TXT_KEIN_LAGERBESTAND        constant varchar2(30) := 'O_TXT_KEIN_LAGERBESTAND';       -- 'Fehler: Es konnte keine Ware gefunden werden.';
  O_TP1_LTE_IN_KOMMISSION        constant varchar2(30) := 'O_TP1_LTE_IN_KOMMISSION';       -- 'Fehler: Die Ziel-LTE für die Kommissionierung ist bereits für Ziel <%1> reserviert. Bitte eine neue LTE anlegen.
------------------------------------------------------- (AG Neu)
  O_TP2_LGR_PLATZ_KEIN_FAHRZEUG  constant varchar2(30) := 'O_TP2_LGR_PLATZ_KEIN_FAHRZEUG'; -- 'Fehler: Lagerplatz: <%1> ist nicht zu erreichen. Fahrzeug ist gestört mit status <%2'>.';
  O_TP1_LGR_PLATZ_FAHRZEUG_MAX   constant varchar2(30) := 'O_TP1_LGR_PLATZ_FAHRZEUG_MAX';  -- 'Fehler: Lagerplatz: <%1> ist nicht zu erreichen. Maximale anzahl Einlagertransporte überschritten.';
  O_TP1_LGR_PLATZ_KEIN_FAHRZ_ERF constant varchar2(30) := 'O_TP1_LGR_PLATZ_KEIN_FAHRZ_ERF';-- 'Fehler: Kein Fahrzeug für Lagerplatz <%1> erfasst.';

  O_TXT_LTE_AM_ZIEL_TR_GELOESCHT constant varchar2(30) := 'O_TXT_LTE_AM_ZIEL_TR_GELOESCHT';-- 'LTE bereits am Ziel. Transport gelöscht.';
  O_TP1_NEUEN_PLATZ_ANFAHERN     constant varchar2(30) := 'O_TP1_NEUEN_PLATZ_ANFAHERN';    -- 'Bitte neuen Lagerplatz anfahren. <%1>'
  O_TXT_LTE_NICHT_AM_WE_F_ORDER  constant varchar2(30) := 'O_TXT_LTE_NICHT_AM_WE_F_ORDER'; -- 'LTE fehlt am WE für ISIOrder (Prüfen und neu Reservieren). Transport gelöscht.';
  O_TXT_LTE_NICHT_AM_WE_N_BUCH   constant varchar2(30) := 'O_TXT_LTE_NICHT_AM_WE_N_BUCH';  -- 'LTE fehlt am Wareneingang (Prüfen und neu Buchen). Transport gelöscht.';
  O_TXT_LTE_KEIN_ERSATZ_GEFUNDEN constant varchar2(30) := 'O_TXT_LTE_KEIN_ERSATZ_GEFUNDEN';-- 'Keinen Ersatz mit gleicher Menge. In ISIOrder neu reservieren. Transport gelöscht.';

  O_TP1_LTE_GEWECHSELT_N_PLATZ  constant varchar2(30) := 'O_TP1_LTE_GEWECHSELT_N_PLATZ';   -- 'LTE gewechselt. Bitte neuen Lagerplatz anfahren. <%1>';
  O_TXT_LTE_KEIN_ERSATZ_N_RES   constant varchar2(30) := 'O_TXT_LTE_KEIN_ERSATZ_N_RES';    -- 'Kein Ersatz automatisch zu finden. Bitte um Ersatz kümmern. Transport gelöscht.';
  O_TXT_MENGE_FEHLT             constant varchar2(30) := 'O_TXT_MENGE_FEHLT';              -- 'Menge Fehlt'
  O_TXT_PROD_DATUM_FEHLT        constant varchar2(30) := 'O_TXT_PROD_DATUM_FEHLT';         -- 'Prod. Datum Fehlt'
  O_TXT_MENGE_FEHLER            constant varchar2(30) := 'O_TXT_MENGE_FEHLER';             -- 'Fehler in der Menge'

  O_TXT_DATUM_FEHLER            constant varchar2(30) := 'O_TXT_DATUM_FEHLER';             -- 'Fehler im Datum'
  O_TXT_QUIT_N_MOEGL_WARE_PRUEF constant varchar2(30) := 'O_TXT_QUIT_N_MOEGL_WARE_PRUEF';  -- 'Quittieren nicht möglich, da noch keine Warenprüfung erfolgt ist.'
  O_TXT_QUIT_N_MOEGL_QUELL_PL   constant varchar2(30) := 'O_TXT_QUIT_N_MOEGL_QUELL_PL';    -- 'Quittieren nicht möglich, da noch keine Quellplatzprüfung erfolgt ist.'
  O_TXT_QUIT_N_MOEGL_ZIEL_PL    constant varchar2(30) := 'O_TXT_QUIT_N_MOEGL_ZIEL_PL';     -- 'Quittieren nicht möglich, da noch keine Zielplatzprüfung erfolgt ist.'
  O_TP1_LGR_PLATZ_O_KOMM        constant varchar2(30) := 'O_TP1_LGR_PLATZ_O_KOMM';         -- 'Für den Lagerplatz <%1> konnten keine Kommissionierdaten gefunden werden.'

  O_TP1_LGR_ORT_O_KOMM          constant varchar2(30) := 'O_TP1_LGR_ORT_O_KOMM';           -- 'Für den Lagerort <%1> ist kein Kommissionierlagerplatz eingerichtet.'
  O_TP1_LGR_ORT_O_K_AUSW_PL     constant varchar2(30) := 'O_TP1_LGR_ORT_O_K_AUSW_PL';      -- 'Für den Lagerort <%1> ist kein Ausweichlagerplatz definiert, obwohl keine Kommissionierung möglich ist.'
  O_TP1_CHARGE_ID_FEHLT         constant varchar2(30) := 'O_TP1_CHARGE_ID_FEHLT';          -- 'Die Charge mit ID <%1> fehlt.''
  O_TP1_LTE_ID_O_RESERVIERUNG   constant varchar2(30) := 'O_TP1_LTE_ID_O_RESERVIERUNG';    -- 'Für LTE ID <%1> konnte keine reservierte LHM gefunden werden.'
  O_TP1_LHM_TYP_FEHLT           constant varchar2(30) := 'O_TP1_LHM_TYP_FEHLT';            -- 'Fehler: LHM TYP <%1> nicht vorhanden'

  O_TP1_KEINE_HIST_DATEN        constant varchar2(30) := 'O_TP1_KEINE_HIST_DATEN';         -- 'Keine Daten in der Histotie gefunden'
  O_TP1_LHM_UNIQUE_ERROR        constant varchar2(30) := 'O_TP1_LHM_UNIQUE_ERROR';         -- LHM-ID <1%> ist bereits verbraucht

  O_TXT_KEIN_PARAMETER          constant varchar2(30) := 'O_TXT_KEIN_PARAMETER';           -- 'Null Parameter übergeben'
------------------------------------------------------- (Neu Ende)

  -- PPS / BDE / FLS
  O_TP1_RESOURCE_FEHLT           constant varchar2(30) := 'O_TP1_RESOURCE_FEHLT';          -- 'Fehler: Resource ID <%1> fehlt';
  O_TP1_RESOURCENZUSTAND_FEHLT   constant varchar2(30) := 'O_TP1_RESOURCENZUSTAND_FEHLT';  -- 'Fehler: Aktuelle zustand von Resource <%1> fehlt';
  O_TP3_FA_AUFTRG_FEHLT          constant varchar2(30) := 'O_TP3_FA_AUFTRG_FEHLT';         -- 'Fehler: FA-Auftrag <%1>/<%2>-<%3> fehlt';
  O_TXT_LTE_ERR_OHNE_LGR_PLATZ   constant varchar2(30) := 'O_TXT_LTE_ERR_OHNE_LGR_PLATZ';  -- 'Fehler: Anlegen eine Produktionspalette ohne LGR_Platz nicht möglich';
  O_TP1_ARTIKEL_ARB_PLAN_FEHLT   constant varchar2(30) := 'O_TP1_ARTIKEL_ARB_PLAN_FEHLT';  -- 'Fehler: Arbeitsplan für Artikel: <%1> fehlt';
  O_TP1_ARB_PLAN_POS_FEHLT       constant varchar2(30) := 'O_TP1_ARB_PLAN_POS_FEHLT';      -- 'Fehler: Arbeitsplanpositionen für Arbeitsplan: <%1> fehlen';

  O_TP1_ARB_PPS_AUF_FEHLT        constant varchar2(30) := 'O_TP1_ARB_PPS_AUF_FEHLT';       -- 'Fehler: PPS Fertigungsauftrag: <%1> fehlt';
  O_TP1_ARB_PPS_AG_FEHLT         constant varchar2(30) := 'O_TP1_ARB_PPS_AG_FEHLT';        -- 'Fehler: PPS AGs für Fertigungsauftrag: <%1> fehlen';
  O_TP2_ARB_PPS_AG_BDE_BEG       constant varchar2(30) := 'O_TP2_ARB_PPS_AG_BDE_BEG';      -- 'Fehler: Im Fertigungsauftrag: <%1> sind im BDE minimal: <%2> AGs begonnen.';
  O_TP2_BDE_FA_AG_ZU_GROSS       constant varchar2(30) := 'O_TP2_BDE_FA_AG_ZU_GROSS';      -- 'Fehler: AG für Fertigungsauftrag: <%1> im BDE mit <%2> zu gross (MAX-WERT überschritten).';
  O_TP2_ART_PROD_PARAM_NIO       constant varchar2(30) := 'O_TP2_ART_PROD_PARAM_NIO';      -- 'Die Produktionsparameter wurden im Artikelstamm für FA <%1>/<%2> nicht vollständig gepflegt).';
  O_TP3_ART_PROD_PARAM_NIO       constant varchar2(30) := 'O_TP3_ART_PROD_PARAM_NIO';      -- 'Die Produktionsparameter wurden für Bauteil <%3> im  FA <%1>/<%2> nicht vollständig gepflegt).';

  O_TP4_ART_CHARGE_IM_FA_FALSCH  constant varchar2(30) := 'O_TP4_ART_CHARGE_IM_FA_FALSCH'; -- 'Die Artikelnummer oder die Charge im FA <%1>/<%2>/<%3> passen nicht zum Barcode <%4>).';
  O_TXT_EP_WE_WA_VOLL_N_MOEGLICH constant varchar2(30) := 'O_TXT_EP_WE_WA_VOLL_N_MOEGLICH';-- 'Ein EP, WE oder WA kann nicht voll sein.';
  O_TXT_KD_AUFTR_POS_NO_UPDATE   constant varchar2(30) := 'O_TXT_KD_AUFTR_POS_NO_UPDATE';  -- 'Auftrag konnte nicht aktualisiert werden';
  O_TP1_TXT_ADRESSE_NF           constant varchar2(30) := 'O_TP1_TXT_ADRESSE_NF';          -- 'Fehler: Adressdaten fehlen für Nummer %1;

  -- Transports
  O_TP1_TRANSP_DATA_NF           constant varchar2(30) := 'O_TP1_TRANSP_DATA_NF';          -- transport data not found for transp_id <%1>
  O_TP1_TRANSP_DATA_BY_TU_NF     constant varchar2(30) := 'O_TP1_TRANSP_DATA_BY_TU_NF';    -- transport data not found for transport unit <%1>
  C_TP2_TRANSP_RES_ASSIGN_FAIL   constant varchar2(30) := 'C_TP2_TRANSP_RES_ASSIGN_FAIL';  -- assignment of transport <%1> to ressource <%2> failed
  C_TP2_TRANSP_GRP_FALSCH        constant varchar2(30) := 'C_TP2_TRANSP_GRP_FALSCH';       -- Transport-Gruppe falsch GRP1 <%1> != GRP2 <%2>
  O_TP1_TRANSP_GRP_VORHANDEN     constant varchar2(30) := 'O_TP1_TRANSP_GRP_VORHANDEN';    -- Transport-Gruppe <%1> bereits vorhanden
  O_TP1_TRANSP_ID_FEHLT          constant varchar2(30) := 'O_TP1_TRANSP_ID_FEHLT';         -- Transport-ID <%1> fehlt
  O_TP1_TRANSP_ID_FEHLT_FUER_LTE constant varchar2(30) := 'O_TP1_TRANSP_ID_FEHLT_FUER_LTE';-- Transport-ID für LTE-ID <%1> fehlt
  O_TP1_TRANSP_GRP_FEHLT         constant varchar2(30) := 'O_TP1_TRANSP_GRP_FEHLT';        -- Transport-Gruppe <%1> fehlt
  O_TP2_TRANSP_GRP_FUER_LTE_VOH  constant varchar2(30) := 'O_TP2_TRANSP_GRP_FUER_LTE_VOH'; -- Transport-Gruppe <%1> für LTE-ID <%2> bereits vorhanden
  O_TP1_TRANSP_GRP_F_LTE_FEHLT   constant varchar2(30) := 'O_TP1_TRANSP_GRP_F_LTE_FEHLT';  -- Transport-Gruppe für LTE-ID <%1> fehlt
  O_TP1_TRANSP_GRP_LTE_ZIEL_ERR  constant varchar2(30) := 'O_TP1_TRANSP_GRP_LTE_ZIEL_ERR'; -- Transport-Gruppe für LTE-ID <%1> hat falsches Ziel

  O_TP3_LGR_CFG_ERR              constant varchar2(30) := 'O_TP3_LGR_CFG_ERR';             -- 'Die LTE <%1> Type <%2> darf am Lagerplatz <%3> nicht eingelagert werden (CFG passt nicht)';
  
  O_TXT_TRANSP_LTE_CHANGED       constant varchar2(30) := 'O_TXT_TRANSP_LTE_CHANGED';      -- 'Die Transport LTE wurde ersetzt. Bitte Auftrag erneut starten'
  
  -- Public function and procedure declarations
  function ec(in_const_name in varchar2) return varchar2;
  function ec_p1(in_const_name in varchar2,
                 in_p1 in varchar2) return varchar2;
  function ec_p2(in_const_name in varchar2,
                 in_p1 in varchar2,
                 in_p2 in varchar2) return varchar2;
  function ec_p3(in_const_name in varchar2,
                 in_p1 in varchar2,
                 in_p2 in varchar2,
                 in_p3 in varchar2) return varchar2;
  function ec_p4(in_const_name in varchar2,
                 in_p1 in varchar2,
                 in_p2 in varchar2,
                 in_p3 in varchar2,
                 in_p4 in varchar2) return varchar2;
  function ec_p5(in_const_name in varchar2,
                 in_p1 in varchar2,
                 in_p2 in varchar2,
                 in_p3 in varchar2,
                 in_p4 in varchar2,
                 in_p5 in varchar2) return varchar2;

end lc;
/



-- sqlcl_snapshot {"hash":"73d2aef4e5c2fb08cd4da251083a0afa7cc97f37","type":"PACKAGE_SPEC","name":"LC","schemaName":"DIRKSPZM32","sxml":""}