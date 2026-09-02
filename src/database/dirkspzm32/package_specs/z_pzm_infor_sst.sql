create or replace 
PACKAGE z_pzm_infor_sst
-----------------------------------------------------------------------------------------------
-- Package: z_pzm_infor_sst
-- Zweck:   Prozeduren für die Kommunikation mit INFO.
-- Autor:   M.Haberstock
-- Datum:   2026-07-17
--
-- Dieses Package buendelt alle Tabellen-Operationen, die für die Kommunikation mit INFOR
-- benötigt werden.
--

IS
  /**
   * Liste der unterstützten Tabellen; Wird validiert
  **/
  TYPE t_table_list IS TABLE OF VARCHAR2(128);

  c_supported_tables CONSTANT t_table_list :=
    t_table_list(
      'PZM_SCHICHT_MODELLE'
    , 'PZM_TARIFMODELLE'
    , 'PZM_PERSONAL'
    , 'PZM_PRODUKTIONSBEREICHE'
    , 'PZM_ABTEILUNGEN'
    , 'PZM_VERTRAGSARTEN'
    , 'ISI_USER'
    );

   /**
   * Exception-Definitionen für Fehler-Handling in Anwendung
   * (können in Exception-Handler-Blöcken z.B. wie folgt behandelt werden:
   *   EXCEPTION
   *     WHEN z_pzm_infor_sst.unknown_action_type THEN
   *       ...
   */
  err_unknown_action_type   NUMBER := -20001;
  unknown_action_type       EXCEPTION;
  PRAGMA EXCEPTION_INIT (unknown_action_type, -20001);

  err_unsupported_table     NUMBER := -20002;
  unsupported_table         EXCEPTION;
  PRAGMA EXCEPTION_INIT (unsupported_table, -20002);

-----------------------------------------------------------------------------------------------
-- OEFFENTLICHE API:
-----------------------------------------------------------------------------------------------

  /**
   * Prozedur zur Erzeugung von Schnittstellen-Daten
   * Aufruf aus -BIUD-Triggern von Stammdaten-Tabellen, die an INFOR gesendet werden
   *
   * @param i_tabelle           Name der Stammdatentabelle
   * @param i_pk_felder         Name der PK-Felder
   * @param i_value             Wert des PK zur Stammdatentabelle
   * @param i_action_type       Operation auf Stammdatentabelle: I=Insert, U=Update oder D=Delete
   */
  PROCEDURE ins_pzm_stammdaten_to_infor (i_tabelle IN z_pzm_stammdaten_to_infor.tabelle%TYPE
                                       , i_pk_felder IN z_pzm_stammdaten_to_infor.pk_felder%TYPE
                                       , i_value IN z_pzm_stammdaten_to_infor.pk_value%TYPE
                                       , i_action_type IN z_pzm_stammdaten_to_infor.action_type%TYPE);
END z_pzm_infor_sst;
/



-- sqlcl_snapshot {"hash":"938d4071513837b1365a22d89dc70677e6a914cd","type":"PACKAGE_SPEC","name":"Z_PZM_INFOR_SST","schemaName":"DIRKSPZM32","sxml":""}