create or replace 
PACKAGE DIRKSPZM32.z_pzm_infor_sst
-----------------------------------------------------------------------------------------------
-- Package: z_pzm_infor_sst
-- Zweck:   Prozeduren für die Kommunikation mit INFO.
-- Autor:   M.Haberstock
-- Datum:   2026-07
--
-- Dieses Package buendelt alle Tabellen-Operationen, die für die Kommunikation mit INFOR
-- benötigt werden-
--

-----------------------------------------------------------------------------------------------
-- OEFFENTLICHE API:
-----------------------------------------------------------------------------------------------
IS
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



-- sqlcl_snapshot {"hash":"fea2b6fc62db09deba573b36b81946bf4d058cda","type":"PACKAGE_SPEC","name":"Z_PZM_INFOR_SST","schemaName":"DIRKSPZM32","sxml":""}