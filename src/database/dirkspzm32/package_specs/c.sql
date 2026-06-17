create or replace 
package DIRKSPZM32.c is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  03.02.2006 15:08:06
  __________________________________________________
  Description
  Konstanten für DB
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */


  v_isi_product_release constant varchar2(10) := '3.5';
  function get_isi_product_release return varchar2;

  --************************************************************************************************
  -- message_definitions;

  -- Message types
  MSG_MT_APPLICATION       constant number      := 1;
  MSG_MT_NOTIFICATION       constant number      := 2;
  MSG_MT_BETRIEBSART       constant number      := 3;             -- Betriebsart Host Umschalten
  MSG_MT_MESSAGEBOARD      constant number      := 4;             -- Zur internen Verwendung für das MessageBoard
  MSG_MT_SCANNER           constant number      := 5;             -- Zur internen Verwendung für die ScannerEngine
  MSG_MT_PRINT_ENGINE      constant number      := 6;             -- Zur internen Verwendung für die PrintEngine
  MSG_MT_MFR_SERVER        constant number      := 7;             -- Zur internen Verwendung für den MFR
   MSG_MT_MFR_BASE_BEFEHL   constant number      := 8;             -- Standard befehle zwischen MFR und MFR Visu
  MSG_MT_MELD_ENGINE       constant number      := 9;             -- Zur internen Verwendung für die Meldung-Engine

   MSG_MT_HOST_IMP_EXP      constant number      := 10;            -- Zur internen Verwendung für Host DatenÜbernahme, Daten Abgabe
  MSG_MT_TRANSPONDER       constant number      := 11;
  MSG_MT_MDE_SERVER        constant number      := 12;            -- MDE OPC Server zum mmeldern von Auftragswechsel etc.
   MSG_MT_SYSTEM_MELD       constant number      := 13;            -- ISIPlus System Meldungen
  MSG_MT_WATCHDOG          constant number      := 14;
  MSG_MT_FLS_SERVER        constant number      := 15;
  MSG_MT_FLS_BEFEHLE       constant number      := 16;
  MSG_MT_RES_ZUST_CHG      constant number      := 17;

  MSG_MT_USER          constant number      := 1000;
  MSG_MT_CEREALIA     constant number      := 1001;

  -- Message commands
  MSG_MC_ERROR        constant number      := 1;
  MSG_MC_WARNING      constant number      := 2;
  MSG_MC_INFO          constant number      := 3;
  MSG_MC_MA_SLA        constant number      := 4;



  -- Alle nummern > $1000 sind modulspezifisch (keine Sonderlösungen)
  MSG_MC_PRINT_JOB_READY  constant number      := 1001;
  MSG_MC_PRINT_JOB_ERROR  constant number      := 1002;

  MSG_MC_MFR_NEUER_TRANSPORT       constant number   := 4416;
  MSG_MC_MFR_DEL_TRANSPORT         constant number   := 4417;
  MSG_MC_MFR_NEUE_LHM              constant number   := 4418;
  MSG_MC_MFR_EVENT                 constant number   := 4419;
  MSG_MC_MFR_N_RESID_TRANSPORT     constant number   := 4420;


  -- Ab der nummer $1000 0000 können freie Messages definiert werden
  -- Die lokale definition kann dann so aussehen:
  --MSG_MC_MY_COMMAND = MSG_MC_USER + $0001; // daraus entsteht $1000 0001
  MSG_MC_USER              constant number      := 10000000;

  -- ********************* fuer MSG_MT_MDE_SERVER ********************************
  C_MSG_MDE_RES_ID             constant varchar2(25) := 'MDE_RES_ID';                 -- Maschine ISI_RESOURCE.RES_ID
  C_MSG_MDE_MASCH_NAME         constant varchar2(25) := 'MDE_MASCH_NAME';             -- Name der Maschine ISI_RESOURCE.RES_NAME
  C_MSG_MDE_LEITZAHL           constant varchar2(25) := 'MDE_LEITZAHL';               -- Fertigungsauftragsnummer
  C_MSG_MDE_FA_AG              constant varchar2(25) := 'MDE_FA_AG';                  -- Fertigungsauftrag Arbeitsgang
  C_MSG_MDE_FA_UPOS            constant varchar2(25) := 'MDE_FA_UPOS';                -- Fertigungsauftrag Unterposition fuer Gruppenarbeit
  C_MSG_MDE_FA_SOLL_MG         constant varchar2(25) := 'MDE_FA_SOLL_MG';             -- Fertigungsauftrag Sollmenge des gesamten Auftrags
  C_MSG_MDE_FA_SOLL_LHM_MG     constant varchar2(25) := 'MDE_FA_SOLL_LHM_MG';         -- Fertigungsauftrag Sollmenge Stk je LHM
  C_MSG_MDE_FA_IST_MG          constant varchar2(25) := 'MDE_FA_IST_MG';              -- Fertigungsauftrag Istmenge des gesamten Auftrags als Initialwert Auftragswechsel
  C_MSG_MDE_FA_IST_MG_B        constant varchar2(25) := 'MDE_FA_IST_MG_B';            -- Fertigungsauftrag Istmenge B des gesamten Auftrags als Initialwert Auftragswechsel
  C_MSG_MDE_FA_IST_MG_S        constant varchar2(25) := 'MDE_FA_IST_MG_S';            -- Fertigungsauftrag Istmenge Schrott des gesamten Auftrags als Initialwert Auftragswechsel
  C_MSG_MDE_RES_STATUS_ID      constant varchar2(25) := 'MSG_MDE_RES_STATUS_ID';      -- Bei Statusänderung der Resource (Maschine)

  C_MSG_RES_ID                 constant varchar2(25) := 'MSG_RES_ID';                 -- Resource (Maschine)
  C_MSG_LTE_ID                 constant varchar2(25) := 'MSG_LTE_ID';                 -- LTE_ID
  C_MSG_LHM_ID                 constant varchar2(25) := 'MSG_LHM_ID';                 -- LHM_ID
  C_MSG_ZIEL_LTE_ID            constant varchar2(25) := 'MSG_ZIEL_LTE_ID';            -- LTE_ID der Ziel LTE (Packen)
  C_MSG_TRANSPORT_ID           constant varchar2(25) := 'MSG_TRANSPORT_ID';           -- ID des Transports
  C_MSG_LGR_PLATZ              constant varchar2(25) := 'MSG_MSG_LGR_PLATZ';          -- Ziel Lagerplatz
  C_MSG_ARTIKEL_ID             constant varchar2(25) := 'MSG_ARTIKEL_ID';             -- Artikel ID
  C_MSG_ARTIKEL                constant varchar2(25) := 'MSG_ARTIKEL';                -- Artikel Nr
  C_MSG_ARTIKEL_BEZ            constant varchar2(25) := 'MSG_ARTIKEL_BEZ';            -- Artikel Bezeichnung
  C_MSG_ZIEL                   constant varchar2(25) := 'MSG_ZIEL';                   -- Nächstes Ziel
  C_MSG_COMMAND                constant varchar2(25) := 'MSG_COMMAND';                -- Kommando
  C_MSG_QUELLE                 constant varchar2(25) := 'MSG_QUELLE';                 -- Quellplatz Quellelement
  C_MSG_ELEMENT                constant varchar2(25) := 'MSG_ELEMENT';                -- Ziel Lagerplatz
  C_MSG_ID                     constant varchar2(25) := 'MSG_ID';
  MSG_MC_MDE_AUF_STAT_RUESTEN    constant number := 1; -- Auftrags- Statuswechsel DB -> OPC
  MSG_MC_MDE_AUF_STAT_R_ENDE     constant number := 2; -- Auftrags- Statuswechsel DB -> OPC
  MSG_MC_MDE_AUF_STAT_PRODUKTION constant number := 3; -- Auftrags- Statuswechsel DB -> OPC
  MSG_MC_MDE_AUF_STAT_P_ENDE     constant number := 4; -- Auftrags- Statuswechsel DB -> OPC
  MSG_MC_MDE_RES_STATUS_WECHSEL  constant number := 5; -- ResStatus- Statuswechsel DB -> OPC (Ausloesende Stoerung)
  MSG_MC_MDE_SCHICHT_ANFANG      constant number := 6; -- ResStatus- Statuswechsel DB -> OPC
  MSG_MC_MDE_SCHICHT_ENDE        constant number := 7; -- ResStatus- Statuswechsel DB -> OPC
  MSG_MC_MDE_SCHICHT_WECHSEL     constant number := 8; -- ResStatus- Statuswechsel DB -> OPC

  C_MSG_RES_RES_ID             constant varchar2(25) := 'RES_RES_ID';                 -- Maschine ISI_RESOURCE.RES_ID
  C_MSG_RES_MASCH_NAME         constant varchar2(25) := 'RES_MASCH_NAME';             -- Name der Maschine ISI_RESOURCE.RES_NAME
  C_MSG_RES_LEITZAHL           constant varchar2(25) := 'RES_LEITZAHL';               -- Fertigungsauftragsnummer
  C_MSG_RES_FA_AG              constant varchar2(25) := 'RES_FA_AG';                  -- Fertigungsauftrag Arbeitsgang
  C_MSG_RES_FA_UPOS            constant varchar2(25) := 'RES_FA_UPOS';                -- Fertigungsauftrag Unterposition fuer Gruppenarbeit
  C_MSG_RES_FA_SOLL_MG         constant varchar2(25) := 'RES_FA_SOLL_MG';             -- Fertigungsauftrag Sollmenge des gesamten Auftrags
  C_MSG_RES_FA_SOLL_LHM_MG     constant varchar2(25) := 'RES_FA_SOLL_LHM_MG';         -- Fertigungsauftrag Sollmenge Stk je LHM
  C_MSG_RES_FA_IST_MG          constant varchar2(25) := 'RES_FA_IST_MG';              -- Fertigungsauftrag Istmenge des gesamten Auftrags als Initialwert Auftragswechsel
  C_MSG_RES_FA_IST_MG_B        constant varchar2(25) := 'RES_FA_IST_MG_B';            -- Fertigungsauftrag Istmenge B des gesamten Auftrags als Initialwert Auftragswechsel
  C_MSG_RES_FA_IST_MG_S        constant varchar2(25) := 'RES_FA_IST_MG_S';            -- Fertigungsauftrag Istmenge Schrott des gesamten Auftrags als Initialwert Auftragswechsel
  C_MSG_RES_RES_STATUS_ID      constant varchar2(25) := 'MSG_RES_RES_STATUS_ID';      -- Bei Statusänderung der Resource (Maschine)

  MSG_MC_RES_AUF_STAT_RUESTEN    constant number := 1; -- Auftrags- Statuswechsel
  MSG_MC_RES_AUF_STAT_R_ENDE     constant number := 2; -- Auftrags- Statuswechsel
  MSG_MC_RES_AUF_STAT_PRODUKTION constant number := 3; -- Auftrags- Statuswechsel
  MSG_MC_RES_AUF_STAT_P_ENDE     constant number := 4; -- Auftrags- Statuswechsel
  MSG_MC_RES_STATUS_WECHSEL      constant number := 5; -- ResStatus- Statuswechsel
  MSG_MC_RES_SCHICHT_ANFANG      constant number := 6; -- ResStatus- Statuswechsel
  MSG_MC_RES_SCHICHT_ENDE        constant number := 7; -- ResStatus- Statuswechsel
  MSG_MC_RES_SCHICHT_WECHSEL     constant number := 8; -- ResStatus- Statuswechsel
  MSG_MC_RES_RESET               constant number := 9; -- Res Reset
  MSG_MC_RES_AUF_STAT_STOP       constant number :=10; -- Auftrags- Statuswechsel Stop
  MSG_MC_RES_INIT                constant number :=11; -- Init Resource

  MSC_MC_CEREALIA_OG_EINLAGERN constant number := MSG_MC_USER + 1;
  MSC_MC_CEREALIA_OG_AUSLAGERN constant number := MSG_MC_USER + 2;

  -- Ende message_definitions;
  --************************************************************************************************

  ETI_STATUS_SOLL_DRUCKEN  constant varchar2(3)  := 'SD';
  ETI_STATUS_GEDRUCKT      constant varchar2(3)  := 'D';
  ETI_STATUS_NEU_DRUCKEN   constant varchar2(3)  := 'ND';

  LTE_KOMM_GLEICH_LTE      constant varchar2(30) := 'GleicheLteBenutzen';
  LTE_BARCODE_CCG          constant varchar2(3)  := 'CCG';
  LTE_BARCODE_NVE          constant varchar2(3)  := 'NVE';
  LTE_BARCODE_VDA          constant varchar2(3)  := 'VDA';
  LTE_BARCODE_STD          constant varchar2(3)  := 'STD';
  LTE_BARCODE_SPEZ         constant varchar2(4)  := 'SPEZ';

  LGR_MODUL_DLG            constant varchar2(10) := 'DLG';
  LGR_MODUL_BDE            constant varchar2(10) := 'BDE';
  LGR_MODUL_MFR            constant varchar2(10) := 'MFR';
  LGR_MODUL_LVS            constant varchar2(10) := 'LVS';
  LGR_MODUL_SLS            constant varchar2(10) := 'SLS';
  LGR_MODUL_ORDER          constant varchar2(10) := 'ORD';
  LGR_MODUL_PAPIER         constant varchar2(10) := 'PAP';
  LGR_MODUL_HOST           constant varchar2(10) := 'HST';  -- HST über ISI-Order
  LGR_MODUL_ISIPlus        constant varchar2(10) := 'ISI';  -- z.B. durch Automatisches Optimieren

  LTE_ID_GUELTIG_TAGE      constant number       := 7;  -- Wie lange bleibt einen LTE_ID gültig wenn sie LEER oder den Status KF oder PF hat.
  LHM_ID_GUELTIG_TAGE      constant number       := 7;  -- Wie lange bleibt einen LHM_ID gültig wenn sie LEER ist.
  LAM_ID_GUELTIG_TAGE      constant number       := 30; -- Wie lange bleibt einen LAM_ID gültig wenn sie LEER ist.
  LTE_KF_PF_GUELTIG        constant number       := 30;

  LTE_VOLL_A               constant varchar2(1)  := 'A'; -- Anbruch
  LTE_VOLL_V               constant varchar2(1)  := 'V'; -- Std. Menge auf der Palette

  LTE_VOLL_TXT_A           constant varchar2(20) := 'Anbruch'; -- Anbruch
  LTE_VOLL_TXT_V           constant varchar2(20) := 'Vollpal.'; -- Std. Menge auf der Palette

  LGR_STRATEGIE_FIFO       constant varchar2(10) := 'FIFO';
  LGR_STRATEGIE_LIFO       constant varchar2(10) := 'LIFO';

  MHD_BERECHNEN_TAG        constant varchar2(2) := 'TA';
  MHD_BERECHNEN_WOCHE_A    constant varchar2(2) := 'WA';
  MHD_BERECHNEN_WOCHE_E    constant varchar2(2) := 'WE';
  MHD_BERECHNEN_MONAT_A    constant varchar2(2) := 'MA';
  MHD_BERECHNEN_MONAT_E    constant varchar2(2) := 'ME';
  MHD_BERECHNEN_JAHR_A     constant varchar2(2) := 'YA';
  MHD_BERECHNEN_JAHR_E     constant varchar2(2) := 'YE';
  MHD_BERECHNEN_TAG_       constant varchar2(2) := 'AT';
  MHD_BERECHNEN_WOCHE_A_   constant varchar2(2) := 'AW';
  MHD_BERECHNEN_WOCHE_E_   constant varchar2(2) := 'EW';
  MHD_BERECHNEN_MONAT_A_   constant varchar2(2) := 'AM';
  MHD_BERECHNEN_MONAT_E_   constant varchar2(2) := 'EM';
  MHD_BERECHNEN_JAHR_A_    constant varchar2(2) := 'AY';
  MHD_BERECHNEN_JAHR_E_    constant varchar2(2) := 'EY';

  --FM_SUCHE_PLATZ_TE_KO     constant number :=   1; -- Ora -20001
  --FM_SUCHE_PLATZ_TE_EINLAG constant number :=   2;
  --FM_SUCHE_PLATZ_TE_SATUS  constant number :=   3;

  BASIS_LHM                constant varchar2(3) := 'LHM';
  BASIS_LTE                constant varchar2(3) := 'LTE';
  BASIS_LTE_VL             constant varchar2(6) := 'LTE_VL';

  TE_TRENNER               constant varchar2(1):=';'; --Euro;Indu;

  -- LGR_VERWENDUNG
  LGR_TYP_Lager           constant varchar2(8)   :='Lager';
  LGR_TYP_WE              constant varchar2(8)   :='WE';
  LGR_TYP_WA              constant varchar2(8)   :='WA';
  LGR_TYP_Puffer          constant varchar2(8)   :='Puffer';
  LGR_TYP_EP              constant varchar2(8)   :='EP';
  LGR_TYP_WEP             constant varchar2(8)   :='WEP';
  LGR_TYP_LAGERP          constant varchar2(8)   :='LagerP';

  C_TRUE                  constant varchar2(1)   := 'T';
  C_FALSE                 constant varchar2(1)   := 'F';
  LEER                    constant varchar2(1)   := '_';
  C_ANBRUCH_VORZUG        constant varchar2(1)   := 'V';
  C_ANBRUCH_AUSNAHME      constant varchar2(1)   := 'A';
  C_ANBRUCH_IGNORE        constant varchar2(1)   := 'I';
  C_VOLLE_BEHAELTER       constant varchar2(1)   := 'B';
  -- Decode True / False in Ja / Nein
  C_TXT_TRUE              constant varchar2(10)  := 'Ja';
  C_TXT_FALSE             constant varchar2(10)  := 'Nein';

  HILFS_CHARGE            constant varchar2(1)   := 'H';
  LEERPAL                 constant varchar2(2)   := 'LP';
  MISCHPAL                constant varchar2(2)   := 'MP';
  MISCHKANAL              constant varchar2(2)   := 'MK';
  FERTIGWARE              constant varchar2(2)   := 'FW';
  HALBWARE                constant varchar2(2)   := 'HW';
  ROHWARE                 constant varchar2(2)   := 'RW';

  -- welche Transporteinheiten  werden von der Software unterstützt
  LteTypenMischen         constant integer      := 1;              -- 0 = Nein, 1 Nur Grundtypen
  Euro                    constant varchar2(10) :='Euro';
  DueDo                   constant varchar2(10) := 'DueDo';
  EuroK                   constant varchar2(10) :='Euro-K';
  EuroKH1                 constant varchar2(10) :='Euro-KH1';
  ChepEuro                constant varchar2(10) :='ChepEuro';
  Indu                    constant varchar2(10) :='Indu';
  ChepIndu                constant varchar2(10) :='ChepIndu';
  GiBo                    constant varchar2(10) :='GiBo';
  EWegK                   constant varchar2(10) :='EWegK';
  EWegG                   constant varchar2(10) :='EWegG';
  EWegI                   constant varchar2(10) :='EWegI';
  KeineLTE                constant varchar2(10) := '-Keine LTE';
  VirtualLTE              constant varchar2(10) := '-Virtual'; -- WK ? mit "-" ok? -> wegen Sortierung (werden immer oben angezeigt)

  -- LVS Lagerort max. 3 stellen Trenner Lagerorte ist ..
  LORT_FORMAT             constant varchar2(1)  :='0';
  LORT_TRENNER            constant varchar2(1)  :=';';
  LORT_LAENGE             constant number       := 4;

  -- Welche lagertypen werden IN der Software unterstützt
  SAT1                    constant varchar2(10) := 'SAT1';
  SAT_EPL1                constant varchar2(10) := 'SAT_EPL1'; -- Sateliten Einzelplatzlager opti auf Leistung
  SAT_EPL2                constant varchar2(10) := 'SAT_EPL2'; -- Segmentlager opti auf Kompremierung
  EPL1                    constant varchar2(10) := 'EPL1';
  KANAL1                  constant varchar2(10) := 'KANAL1';
  KANAL_BKL1              constant varchar2(10) := 'KANBKL1'; -- Kanal als Blocklager mit Reservierung
  BKL1                    constant varchar2(10) := 'BKL1';
  REG_FACH1               constant varchar2(10) := 'REG_FACH1'; -- Regalfach mit freiher höhe (Wie HUF)
  SEG1                    constant varchar2(10) := 'SEG1';      -- Segmentlager
  SEG_DUEDO1              constant varchar2(10) := 'SEG_DUEDO1';-- Segmentlager, in dem in der Tiefe zu Plätze freigeschaltet werden können
  PP_EPL1                 constant varchar2(10) := 'PP_EPL1';   -- Einzelplatzlager fürd Palettierer
  DURCHL1                 constant varchar2(10) := 'DURCHL1';   -- Durchlauflager
  STAP_FLAE1              constant varchar2(10) := 'STAP_FLAE1'; -- Dynamische Fläche zum Stapeln von Platten
  STAP_FLAE2              constant varchar2(10) := 'STAP_FLAE2'; -- Dynamische Fläche zum Stapeln von Platten mit festen MIN und Max Werten

  WE                      constant varchar2(10) := 'WE';
  WA                      constant varchar2(10) := 'WA';
  MFR_AUUL_KOMPL          constant varchar2(1)  := 'F';

  -- Verwendung der Kanaele und Sat_lager
  LGR_M_K                 constant varchar2(11) :=  'MischKANAL;';     -- Mischkanal
  LGR_M_P                 constant varchar2(11) :=  'MischPal;';       -- Kanal für Mischpalletten

  -- Statustypen für LTS's
  LTE_FF_STAT             constant varchar2(3)  := 'FF'; -- Palette ist im Status Freifahren
  LTE_PF_STAT             constant varchar2(3)  := 'PF'; -- Palettiert frei
  LTE_KF_STAT             constant varchar2(3)  := 'KF'; -- Korrekturstatus
  LTE_BS_STAT             constant varchar2(3)  := 'B';  -- Wird befüllt
  LTE_BF_STAT             constant varchar2(3)  := 'BF'; -- Wird fertig
  LTE_ED_STAT             constant varchar2(3)  := 'ED'; -- TE soll eingelagert werden
  LTE_ET_STAT             constant varchar2(3)  := 'ET'; -- TE wird eingelagert und ist aufgenommen
  LTE_LF_STAT             constant varchar2(3)  := 'LF'; -- TE ist eingelagert am Ziel
  LTE_AD_STAT             constant varchar2(3)  := 'AD'; -- TE soll ausgelagert werden
  LTE_AT_STAT             constant varchar2(3)  := 'AT'; -- TE wird ausgelagert Und TE ist aufgenommen
  LTE_AF_STAT             constant varchar2(3)  := 'AF'; -- TE ist ausgelagert im Lager
  LTE_AG_STAT             constant varchar2(3)  := 'AG'; -- TE ist ausgelagert und weg
  LTE_AR_STAT             constant varchar2(3)  := 'AR'; -- TE ist ausgelagert und Rueckgelagert
  LTE_UD_STAT             constant varchar2(3)  := 'UD'; -- TE soll umgelagert werden
  LTE_UT_STAT             constant varchar2(3)  := 'UT'; -- TE wird umgelagertund  TE ist aufgenommen
  LTE_UF_STAT             constant varchar2(3)  := 'UF'; -- TE Umlagerung Fertig (Steht zum weitertransport auf einem WA)

  -- Vorgangstypen für Lagerbewegungen (LAM_BH)

  LAM_BH_ZUGAGNG          constant varchar2(2)  := 'LZ';  -- Lagerzugang
  LAM_BH_ABGAGNG          constant varchar2(2)  := 'LA';  -- Lagerabgang
  LAM_BH_UMLAG            constant varchar2(2)  := 'LU';  -- Umlagerung
  LAM_BH_SPRERE           constant varchar2(2)  := 'SP';  -- Sperren
  LAM_BH_UMPACKEN         constant varchar2(2)  := 'UP';  -- Umpacken (Aufpacken auf eine Palette)
  LAM_BH_INV              constant varchar2(2)  := 'IV';  -- Inventur
  LAM_BH_WKE              constant varchar2(2)  := 'KE';  -- Konsi-Entnahme

  LAM_BH_BUS_INV          constant number       := 1;     -- Inventur
  LAM_BH_BUS_ZUG          constant number       := 2;     -- Lagerzugang
  LAM_BH_BUS_ABG          constant number       := 3;     -- Lagerabgang
  LAM_BH_BUS_UML          constant number       := 4;     -- Umlagerung
  LAM_BH_BUS_SP           constant number       := 5;     -- Warenbestand sperren
  LAM_BH_BUS_UP           constant number       := 6;     -- Pick und Put Umpacken
  LAM_BH_BUS_Q            constant number       := 7;     -- Quarantäne mit abbuchung
  LAM_BH_BUS_ZUG_KOMM     constant number       := 12;    -- Lagerzugang KommDirekt
  LAM_BH_BUS_ABG_KOMM     constant number       := 13;    -- Lagerabgang KommDirekt
  LAM_BH_BUS_IVZ          constant number       := 14;    -- geZaehlte InVentur (wo auch ein Zaehl-Datum geschrieben wird)
  LAM_BH_BUS_ZUG_KONSI    constant number       := 22;    -- Lagerzugang KONSI-LAGER (KWE aus ISI-Order BK)
  LAM_BH_BUS_ABG_KONSI    constant number       := 23;    -- Lagerabgang KONSI-LAGER (KWA aus ISI-Order LK)
  LAM_BH_BUS_WKE_KONSI    constant number       := 24;    -- Warenentnahme KONSI-LAGER (WKE aus KONSI wird freier Bestand)

  LTE_EINL                constant varchar2(10) := 'EINL';-- Einlagern
  LTE_AUSL                constant varchar2(10) := 'AUSL';-- Auslagern

  -- Status für Transporte
  TRANS_FREI              constant varchar2(1)  := 'F';  -- Auftrag ist frei, kann vergeben werden
  TRANS_GESPERRT          constant varchar2(1)  := 'G';  -- Auftrag ist gesperrt, darf keinem Zugewiesen und von keinem begonnen werden
  TRANS_ZUGEW             constant varchar2(1)  := 'Z';  -- Auftrag ist einem Fahrzeug zugewiesen
  TRANS_BEGIN             constant varchar2(1)  := 'B';  -- Fahrzeug ist auf dem Weg zur LTE
  TRANS_TRANSPORT         constant varchar2(1)  := 'T';  -- Palette wird Transportiert
  TRANS_SORT_SPERRE       constant varchar2(1)  := 'S';  -- Auftrag ist gesperrt, soll sortiert werden

  -- 20081211: Anpassung für Smithuis
  MHD_MS_MIN_TAGE         constant integer      := -1;   -- Cer 60 -- Min MHD für Ware die an einer Maschine weiterverarbeitet wird
  MHD_RW_MIN_TAGE         constant integer      := -1;   -- Cer 30 -- Min MHD für Rohware zum Ausliefern
  MHD_HW_MIN_TAGE         constant integer      := -1;   -- Cer 30 -- Min MHD für Halbfertigware zum Ausliefern
  MHD_FW_MIN_TAGE         constant integer      := -1;   -- Cer 30 -- Min MHD für Fertigware zum Ausliefern

  FMID_Bestand_reicht_nicht    constant integer     := 800;
  FMID_Resource_Fehlt          constant integer     := 801;
  FMID_LTE_ID_RES              constant integer     := 802;
  FMID_SEQ_FEHLER              constant integer     := 803;
  FMID_BUCH_FEHLER             constant integer     := 804;

  FMID_Quelle_Existiert_Nicht  constant integer     := 950;
  FMID_Ziel_Existiert_Nicht    constant integer     := 951;
  FMID_LTE_ID_Null             constant integer     := 952;
  FMID_LTE_ID_SCHON_VORHANDEN  constant integer     := 953;
  FMID_QuellKanal_Leer         constant integer     := 954;
  FMID_Quelle_Nicht_BELEGT     constant integer     := 955;
  FMID_Ziel_Voll               constant integer     := 956;
  FMID_Artikelnummer_Fehlt     constant integer     := 957;
  FMID_PaletteTyp_Fehlt        constant integer     := 958;
  FMID_Lagerplatz_Gesperrt     constant integer     := 959;
  FMID_Platz_kein_WE           constant integer     := 960;
  FMID_LTE_ID_Fehlt            constant integer     := 961;
  FMID_Lager_Platz_fehlt       constant integer     := 962;
  FMID_Falscher_LTE_Status     constant integer     := 963;
  FMID_Platz_Nicht_IO          constant integer     := 964;
  FMID_LTE_hat_Transport       constant integer     := 965;
  FMID_Lte_falscher_Platz      constant integer     := 966;
  FMID_Weg_Von_Nach_falsch     constant integer     := 967;
  FMID_Falscher_LTE_Type       constant integer     := 968;
  FMID_Falsche_Temperatur      constant integer     := 969;
  FMID_Falsche_Wertklasse      constant integer     := 970;
  FMID_Falsche_Gefahrenklasse  constant integer     := 971;
  FMID_LTE_ist_zu_schwer       constant integer     := 972;
  FMID_LTE_zu_gross            constant integer     := 973;
  FMID_LGR_Type_unbekannt      constant integer     := 974;
  FMID_Keine_Lagerorte         constant integer     := 975;
  FMID_Kein_Platz_fuer_LTE     constant integer     := 976;
  FMID_Falscher_BearbModul     constant integer     := 977;
  FMID_Falsche_Buchungsart     constant integer     := 978;
  FMID_Zuggang_Buchen          constant integer     := 979;
  FMID_Alle_Fahrz_Ausgelastet  constant integer     := 980;
  FMID_Kein_Fahrz_bereit_orte  constant integer     := 981;
  FMID_Inventur_Artikel        constant integer     := 982;
  FMID_Inventur_Platz          constant integer     := 983;
  FMID_Inventur_Ort            constant integer     := 984;
  FMID_Inventur                constant integer     := 985;
  FMID_transp_grp_falsch       constant integer     := 986;
  FMID_Param_fehlen            constant integer     := 987;
  FMID_transp_grp_vorhanden    constant integer     := 988;
  FMID_transp_id_fehlt         constant integer     := 989;
  FMID_transp_grp_fehlt        constant integer     := 990;
  FMID_lager_cfg_nio           constant integer     := 991;



  -- Status für Transporte
  MAX_ANZ_LIEFS_TAGE      constant integer      := 31;   -- Maximal angezeigte Tage für Lieferscheindruck

  -- Status Decoder !!!
  LAB_STAT_Q              constant varchar2(1)   := 'Q';  -- Quarantäne
  LAB_STAT_U              constant varchar2(1)   := 'U';  -- Unfrei
  LAB_STAT_B              constant varchar2(1)   := 'B';  -- Bedingt Frei
  LAB_STAT_G              constant varchar2(1)   := 'G';  -- Gesperrt
  LAB_STAT_F              constant varchar2(1)   := 'F';  -- Frei
  LAB_STAT_M              constant varchar2(1)   := 'M';  -- Muster
  LAB_STAT_W              constant varchar2(1)   := 'W';  -- Warenausgangsprüfung
  LAB_STAT_S              constant varchar2(1)   := 'S';  -- Sonderprüfung


  LAB_STAT_TXT_Q          constant varchar2(10) := 'Quarantäne';
  LAB_STAT_TXT_U          constant varchar2(10) := 'Unfrei';
  LAB_STAT_TXT_B          constant varchar2(10) := 'Bed. Frei';
  LAB_STAT_TXT_G          constant varchar2(10) := 'Gesperrt';
  LAB_STAT_TXT_F          constant varchar2(10) := 'Frei';
  LAB_STAT_TXT_M          constant varchar2(10) := 'Muster';

  LAB_STAT_COL_Q          constant varchar2(10) := '@@00E100E1';
  LAB_STAT_COL_U          constant varchar2(10) := '@@008D8D8D';
  LAB_STAT_COL_B          constant varchar2(10) := '';
  LAB_STAT_COL_G          constant varchar2(10) := '@@000000D7';
  LAB_STAT_COL_F          constant varchar2(10) := '@@00007D00';

  LGR_GESPERRT_G          constant varchar2(1)   := 'G';
  LGR_GESPERRT_F          constant varchar2(1)   := 'F';

  LGR_GESPERRT_TXT_F      constant varchar2(10) := 'Frei';
  LGR_GESPERRT_TXT_G      constant varchar2(10) := 'Gesperrt';

  LGR_GESPERRT_COL_G      constant varchar2(10) := '@@000000D7';
  LGR_GESPERRT_COL_F      constant varchar2(10) := '@@00007D00';

  -- Returns fuer Transport Quittung
  TRANSPORT_FEHLT         constant integer      := -1;
  LTE_FEHLT               constant integer      := -2;
  LGR_FEHLT               constant integer      := -3;
  LGR_LTE_FEHLT           constant integer      := -4;
  LGR_Q_FEHLT             constant integer      := -5;
  LGR_Z_FEHLT             constant integer      := -6;
  LGR_TRANSP_BEGONNEN     constant integer      := -7;
  LGR_RES_FEHLT           constant integer      := -8;
  LGR_REIHENFOLGE_FALSCH  constant integer      := -9;

  LGR_VOLL                constant integer      := -10;
  LGR_DISPO_VOLL          constant integer      := -11;

  LGR_RES_STRING          constant integer      := -20;

  LGR_ZIEL_TYP_FALSCH     constant integer      := -50;

  TRANSPORT_TXT_FEHLT     constant varchar2(30) := 'Transportauftrag fehlt';
  LTE_TXT_FEHLT           constant varchar2(30) := 'LTE fehlt';
  LGR_TXT_FEHLT           constant varchar2(30) := 'Lagerplatz fehlt';
  LGR_LTE_TXT_FEHLT       constant varchar2(30) := '???';
  LGR_Q_TXT_FEHLT         constant varchar2(30) := 'Quellelagerplatz fehlt';
  LGR_Z_TXT_FEHLT         constant varchar2(30) := 'Ziellagerplatz fehlt';
  LGR_TRANSP_TXT_BEGONNEN constant varchar2(30) := 'Transport bereits begonnen';
  LGR_RES_TXT_FEHLT       constant varchar2(30) := 'Resource fehlt';
  LGR_REIHENF_TXT_FALSCH  constant varchar2(30) := 'Transport Reihenfolge Falsch';

  LGR_TXT_VOLL            constant varchar2(30) := 'Lager ist voll';
  LGR_DISPO_TXT_VOLL      constant varchar2(30) := 'Lagergruppe ist voll';

  LGR_RES_TXT_STRING      constant varchar2(30) := 'Res-string ist falsch';

  -- LGR_RES_TXT_STRING      constant varchar2(30) := 'Lagergruppe ist voll';

  LGR_ZIEL_TYP_TXT_FALSCH constant varchar2(30) := 'Transportstatus ist falsch';

  LGR_TRANSP_STD_PRIO_MS  constant number       := 5;            -- Std Prio für Transporte an eine Maschine
  LGR_TRANSP_STD_PRIO_WA  constant number       := 3;            -- Std Prio für Transporte Auslagerung
  LGR_TRANSP_STD_PRIO_WE  constant number       := 4;            -- Std Prio für Transporte Einlagerung
  LGR_TRANSP_STD_PRIO_UL  constant number       := 1;            -- Std Prio für Transporte Umlagerung
  LGR_TRANSP_STD_PRIO_FF  constant number       := 10;           -- Std Prio für Transporte Freifahren

  -- Werte für Lagerplatzfindung
  -- Gilt für alle Typen (Achtung, im Blocklager ist der Res.String nicht gesetzt. Der Wert ist dann immer LGR_PLATZ_LEER)
  LGR_PLATZ_RES_STRING     constant number       := 1;           -- Multiplikator für gleichen Reservirungsstring
  LGR_PLATZ_LEER           constant number       := 1.1;         -- Multiplikator für leeren Platz
  LGR_PLATZ_MISCH_KANAL    constant number       := 1.3;         -- Multiplikator für Mischkanäle
  LGR_PLATZ_MISCH_PAL      constant number       := 1.4;         -- Multiplikator für Kanäle mit Mischpaletten
  LGR_PLATZ_FALSCH         constant number       := 99;          -- Multiplikator für Kanäle die mit anderen Artikeln gefüllt sind
  -- 20081211: Anpassung für Smithuis
  LGR_PLATZ_FACTOR_MAX     constant number       := 99999999;    -- Schlechter darf der Platz in der Bewertung nicht sein (Nur Belegung)

  -- Nur Regallager (Einzelplatz, Kanal oder Sat-Lager)
                                                                 -- Diese Einstellung sagt RW unten FW u. HW oben, MP egal
  LGR_HOEHE_FW_WERT        constant integer      := 0;           -- Welchen Einfluss soll (FW) auf die hoehe im Regal haben
  LGR_HOEHE_RW_WERT        constant integer      := 0;           -- Welchen Einfluss soll (RW) auf die hoehe im Regal haben
  LGR_HOEHE_HW_WERT        constant integer      := 0;           -- Welchen Einfluss soll (HW) auf die hoehe im Regal haben
  LGR_HOEHE_MP_WERT        constant integer      := 0;           -- Welchen Einfluss soll (MP) auf die hoehe im Regal haben

  LGR_ABC_WERT             constant integer      := 1;           -- Faktor besser, schlechter für ABC-Abgleich
  LGR_ART_RES              constant integer      := 20;          -- Faktor besser, schlechter wenn für einen Kanal eine Artikelreservierung vorgenommen wurde

  LGR_ORT_ABSTAND_FAKTOR   constant integer      := -1;          -- Abstand der Lagerorte nach LGR_ORT
  -- 20081211: Anpassung für Smithuis
  LGR_ABSTAND_FAKTOR       constant integer      :=  -1;         -- Abstand der Lagerplaetze nach LGR_DIM_PLATZ
                                                                 -- 0 = Abstand egal 1 = Gorsser Abstand gut -1 kleiner Abstand gut
  LGR_PLATZ_R_FAKTOR       constant integer      :=  1;          -- 0 = Egal, -1 = Große Platznummer gut, 1 = kleine gut

  -- Hier sind die Faktoren, mit dem man freihe Hoehen Gewicht etc fuer die Lagerplatzfindung genutzt werden kann
  -- (Faktor Abstand wird mit diesem Produkt multiliziert)
  LGR_GEWICHT_RELEVANZ     constant integer      := NULL;        -- Faktor mit dem das Differenzgewicht multpliziert wird um der Lagerplatz zu bewerten
  LGR_HOEHE_RELEVANZ       constant integer      := NULL;        -- Faktor mit dem die freihe Hoehe multpliziert wird um der Lagerplatz zu bewerten
  -- Tiefe und Breite wird z.Zt. nicht beruecksichtigt.
  LGR_BREITE_RELEVANZ      constant integer      := NULL;        -- Faktor mit dem die freihe Tiefe multpliziert wird um der Lagerplatz zu bewerten
  LGR_TIEFE_RELEVANZ       constant integer      := NULL;        -- Faktor mit dem die freihe breite multpliziert wird um der Lagerplatz zu bewerten

  -- (Faktor Abstand wird mit diesem Produkt multiliziert bei Gleichverteilung in Lagergruppen)
  LGR_FUELLGRAD_RELEVANZ  constant integer      := 1000000000;   -- Faktor mit dem der Füllgrad in Prozent multipliziert wird, wenn im Lager gleichverteilung gewünscht ist

  -- Keine Relevanz bei Kanal-Blocklager
  LGR_PLATZ_AUSL_DISPO     constant integer      := 100;         -- Um wieviel schlechter wird der PLatz bei je Auslagerung
  LGR_ORDER_RESERVIERUNG   constant integer      := 0.5;         -- Um wieviel schlechter wird der PLatz bei je Auslagerreservirung
  -- Nur Blocklager
  LGR_PLATZ_VERFUEG        constant integer      := 1;           -- Um wieviel besser wird der PLatz bei je Verfügbaren Platz
  LGR_PLATZ_AKT_LTE        constant integer      := 1;           -- Um wieviel besser wird der PLatz bei je power(LTE, 2)
  -- LGR_PLATZ_VERFUEG        constant integer      := 1;           -- Um wieviel schlechter wird der PLatz bei je Auslagerung


  v_nr              integer;
  v_ts              timestamp;
  v_gleich          varchar2(4096);

  function DECODE_FUNCTION_FEHLER (
    return_value in integer) return varchar2;

  function DECODE_LTE_VOLL (
  return_value in varchar2) return varchar2;

  function DECODE_TRUE_FALSE (
  return_value in varchar2) return varchar2;

  function R_SAT1 return varchar2;
  function R_SAT_EPL1 return varchar2;
  function R_SAT_EPL2 return varchar2;
  function R_EPL1 return varchar2;
  function R_KANAL1 return varchar2;
  function R_KANAL_BKL1 return varchar2;
  function R_BKL1 return varchar2;
  function R_REG_FACH1 return varchar2;
  function R_SEG1 return varchar2;
  function R_SEG_DUEDO1 return varchar2;
  function R_PP_EPL1 return varchar2;
  function R_DURCHL1 return varchar2;
  function R_STAP_FLAE1 return varchar2;
  function R_STAP_FLAE2 return varchar2;

  function R_C_FALSE return varchar2;
  function R_C_TRUE return varchar2;

  function R_LTE_VOLL_V return varchar2;
  function R_LTE_VOLL_A return varchar2;
  function R_C_ANBRUCH_AUSNAHME return varchar2;
  function R_C_ANBRUCH_VORZUG return varchar2;
  function R_C_ANBRUCH_IGNORE return varchar2;
  function R_LGR_GESPERRT_F return varchar2;
  function R_LGR_ABSTAND_FAKTOR return integer;
  function R_LGR_PLATZ_R_FAKTOR return integer;

  function R_MHD_MS_MIN_TAGE return integer;
  function R_MHD_RW_MIN_TAGE return integer;
  function R_MHD_HW_MIN_TAGE return integer;
  function R_MHD_FW_MIN_TAGE return integer;

  function R_Lgr_Typ_We return varchar2;
  function R_Lgr_Typ_Wa return varchar2;
  function R_Lgr_Typ_Lager return varchar2;
  function R_Lgr_Typ_Puffer return varchar2;
  function R_Lgr_Typ_LagerP return varchar2;

  function R_LAM_BH_BUS_INV return integer;
  function R_LAM_BH_BUS_ZUG return integer;
  function R_LAM_BH_BUS_ABG return integer;
  function R_LAM_BH_BUS_UML return integer;
  function R_LAM_BH_BUS_SP  return integer;
  function R_LAM_BH_BUS_UP  return integer;
  function R_LAM_BH_BUS_Q   return integer;
  function R_LAM_BH_BUS_ZUG_KOMM return integer;
  function R_LAM_BH_BUS_ABG_KOMM return integer;
  function R_LAM_BH_BUS_GEZAE_INV return integer;
  function R_LAM_BH_BUS_ZUG_KONSI return integer;
  function R_LAM_BH_BUS_ABG_KONSI return integer;
  function R_LAM_BH_BUS_UML_KONSI return integer;

  function R_LTE_FF_STAT return varchar2;
  function R_LTE_PF_STAT return varchar2;
  function R_LTE_KF_STAT return varchar2;
  function R_LTE_BS_STAT return varchar2;
  function R_LTE_BF_STAT return varchar2;
  function R_LTE_ED_STAT return varchar2;
  function R_LTE_ET_STAT return varchar2;
  function R_LTE_LF_STAT return varchar2;
  function R_LTE_AD_STAT return varchar2;
  function R_LTE_AF_STAT return varchar2;
  function R_LTE_AG_STAT return varchar2;
  function R_LTE_UD_STAT return varchar2;
  function R_LTE_UT_STAT return varchar2;

  function R_LAB_STAT_Q  return varchar2;
  function R_LAB_STAT_U  return varchar2;
  function R_LAB_STAT_B  return varchar2;
  function R_LAB_STAT_G  return varchar2;
  function R_LAB_STAT_F  return varchar2;


  function R_LORT_LAENGE return number;

  function R_LGR_PLATZ_RES_STRING return number;
  function R_LGR_PLATZ_LEER return number;
  function R_LGR_PLATZ_MISCH_KANAL return number;
  function R_LGR_PLATZ_MISCH_PAL return number;
  function R_LGR_PLATZ_FALSCH return number;
  function R_MAX_ANZ_LIEFS_TAGE return number;

  function R_FMID_Quelle_Existiert_Nicht return integer;
  function R_FMID_Ziel_Existiert_Nicht   return integer;
  function R_FMID_LTE_ID_Null            return integer;
  function R_FMID_LTE_ID_SCHON_VORHANDEN return integer;
  function R_FMID_QuellKanal_Leer        return integer;
  function R_FMID_Quelle_Nicht_BELEGT    return integer;
  function R_FMID_Ziel_Voll              return integer;
  function R_FMID_Artikelnummer_Fehlt    return integer;
  function R_FMID_PaletteTyp_Fehlt       return integer;
  function R_FMID_Lagerplatz_Gesperrt    return integer;
  function R_FMID_Platz_kein_WE          return integer;
  function R_FMID_LTE_ID_Fehlt           return integer;
  function R_FMID_Lager_Platz_fehlt      return integer;
  function R_FMID_Falscher_LTE_Status    return integer;
  function R_FMID_Platz_Nicht_IO         return integer;
  function R_FMID_LTE_hat_Transport      return integer;
  function R_FMID_Lte_falscher_Platz     return integer;
  function R_FMID_Weg_von_nach_falsch    return integer;
  function R_FMID_Falscher_LTE_Type      return integer;
  function R_FMID_Falsche_Temperatur     return integer;
  function R_FMID_Falsche_Wertklasse     return integer;
  function R_FMID_Falsche_Gefahrenklasse return integer;
  function R_FMID_LTE_ist_zu_schwer      return integer;
  function R_FMID_LTE_zu_gross           return integer;
  function R_FMID_LGR_Type_unbekannt     return integer;
  function R_FMID_Keine_Lagerorte        return integer;
  function R_FMID_Kein_Platz_fuer_LTE    return integer;
  function R_FMID_Falscher_BearbModul    return integer;
  function R_FMID_Falsche_Buchungsart    return integer;
  function R_FMID_Zuggang_Buchen         return integer;
  function R_FMID_Alle_Fahrz_Ausgelastet return integer;
  function R_FMID_Kein_Fahrz_bereit_orte return integer;

  function sql_count (in_nr      in integer,
                      in_gleich  in varchar2,
                      in_ts      in timestamp)
                      return integer;

  FUNCTION DECODE_LABOR_STATUS(labor_status IN LVS_LAM.labor_status%TYPE)
    RETURN VARCHAR2;

  FUNCTION DECODE_LABOR_STATUS_FARBE(labor_status IN LVS_LAM.labor_status%TYPE)
    RETURN VARCHAR2;

  FUNCTION DECODE_LGR_SPERRE(Gesperrt IN LVS_LGR.Gesperrt%TYPE)
    RETURN VARCHAR2;

  FUNCTION DECODE_LGR_SPERRE_FARBE(Gesperrt IN LVS_LGR.Gesperrt%TYPE)
    RETURN VARCHAR2;


end c;
/



-- sqlcl_snapshot {"hash":"5c283aca263e4ecdf679a287189291a8b6d7d380","type":"PACKAGE_SPEC","name":"C","schemaName":"DIRKSPZM32","sxml":""}