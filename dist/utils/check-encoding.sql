-- check-encoding.sql
-- -----------------------------------------------------------------------------------------------
-- Prueft, ob deutsche Sonderzeichen (ae oe ue Ae Oe Ue ss) im Schema durch fehlerhafte
-- Client-/Tool-Encoding-Konfiguration verstuemmelt wurden (z.B. sqlcl, sqlplus, PL/SQL Developer,
-- dbForge Studio mit falscher NLS_LANG-Einstellung oder falschem lokalem Datei-Encoding beim
-- Objekt-Austausch zwischen Datenbanken mit unterschiedlichem NLS_CHARACTERSET).
--
-- Alle sieben deutschen Sonderzeichen beginnen in UTF-8 mit demselben Leadbyte 0xC3 (ae=C3A4,
-- oe=C3B6, ue=C3BC, Ae=C384, Oe=C396, Ue=C39C, ss=C39F). Welches kaputte Zeichen bei falscher
-- Codepage-Interpretation entsteht, haengt deshalb nur von der Codepage ab, nicht vom Buchstaben:
--   - CP850/CP437 interpretieren 0xC3 als "├" (U+251C)
--   - CP1252/Latin-1 interpretieren 0xC3 als "Ã" (U+00C3)
--   - Fehlt NLS_LANG beim Client komplett (z.B. sqlplus/OCI ohne gesetzte Umgebungsvariable),
--     faellt der Client historisch auf AMERICAN_AMERICA.US7ASCII zurueck - einen reinen 7-Bit-
--     Zeichensatz. Beide Bytes einer UTF-8-Umlaut-Sequenz liegen >= 0x80 und sind darin nicht
--     abbildbar; Oracle ersetzt beim Zeichensatz-Uebergang jedes der zwei ungueltigen Bytes durch
--     sein Standard-Ersatzzeichen "¿" (U+00BF) - deshalb erscheint "¿¿" (zweimal) pro Umlaut,
--     empirisch bestaetigt (sqlplus ohne NLS_LANG, CP850-Konsole, UTF-8-Quelldatei).
--
-- WICHTIG: "├" ist in Einzelbyte-Zielzeichensaetzen wie WE8MSWIN1252 nicht abbildbar. Wird der
-- Suchbegriff UNISTR('\251C') in einer solchen Session geparst, ersetzt Oracle ihn beim
-- Zeichensatz-Uebergang durch ein Ersatzzeichen (beobachtet: '+') - eine reine SQL-WHERE-Bedingung
-- wuerde dadurch effektiv nach '+' statt nach "├" suchen und massenhaft falsche Treffer liefern.
-- Deshalb wird hier zur Laufzeit per PL/SQL zuerst NLS_CHARACTERSET geprueft und die "├"/
-- Replacement-Zeichen-Pruefung fuer nicht-Unicode-Zielzeichensaetze komplett uebersprungen -
-- nicht nur das Ergebnis nachtraeglich gefiltert, sondern der Vergleich gar nicht erst geparst.
-- "Ã" ist dagegen in jedem Zeichensatz ein gueltiges, unproblematisches Zeichen und wird immer
-- geprueft (klassisches "Doppel-Encoding": Client sendet UTF-8-Bytes, meldet der DB aber ein
-- falsches NLS_LANG, wodurch die Rohbytes byteweise als Zielzeichen gespeichert werden).
--
-- Aufruf: @check-encoding.sql <schema>
-- -----------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
DEFINE chk_schema = &1

DECLARE
  v_schema     VARCHAR2(128) := UPPER('&chk_schema');
  v_charset    VARCHAR2(64);
  v_is_unicode BOOLEAN;
  v_text       VARCHAR2(32767);
  v_hits       PLS_INTEGER := 0;

  FUNCTION is_corrupted(p_text IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_text IS NULL THEN
      RETURN FALSE;
    END IF;
    IF INSTR(p_text, UNISTR('\00C3')) > 0 THEN   -- "Ã" - in jedem Characterset unproblematisch
      RETURN TRUE;
    END IF;
    IF INSTR(p_text, UNISTR('\00BF\00BF')) > 0 THEN -- "¿¿" - fehlendes NLS_LANG (US7ASCII-Fallback)
      RETURN TRUE;
    END IF;
    IF v_is_unicode THEN                          -- "├" / Replacement nur pruefen, wenn ueberhaupt
      IF INSTR(p_text, UNISTR('\251C')) > 0        -- moeglich - sonst Fehlalarm durch Ersatzzeichen
      OR INSTR(p_text, UNISTR('\FFFD')) > 0 THEN
        RETURN TRUE;
      END IF;
    END IF;
    RETURN FALSE;
  END;

BEGIN
  SELECT value INTO v_charset FROM nls_database_parameters WHERE parameter = 'NLS_CHARACTERSET';
  v_is_unicode := (INSTR(UPPER(v_charset), 'UTF8') > 0);

  DBMS_OUTPUT.PUT_LINE('NLS_CHARACTERSET: ' || v_charset || ' - Box-Zeichen-Pruefung ("├") ist ' ||
    CASE WHEN v_is_unicode THEN 'AKTIV' ELSE 'DEAKTIVIERT (in diesem Characterset nicht abbildbar)' END);
  DBMS_OUTPUT.PUT_LINE('Schema: ' || v_schema);

  DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== Source (Packages/Bodies/Procedures/Functions/Types) ===');
  FOR r IN (SELECT owner, name, type, line, text FROM dba_source WHERE owner = v_schema) LOOP
    IF is_corrupted(r.text) THEN
      DBMS_OUTPUT.PUT_LINE(r.owner || '.' || r.name || ' (' || r.type || ') Zeile ' || r.line || ': ' || r.text);
      v_hits := v_hits + 1;
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== Tabellen-Kommentare ===');
  FOR r IN (SELECT owner, table_name, comments FROM dba_tab_comments WHERE owner = v_schema) LOOP
    IF is_corrupted(r.comments) THEN
      DBMS_OUTPUT.PUT_LINE(r.owner || '.' || r.table_name || ': ' || r.comments);
      v_hits := v_hits + 1;
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== Spalten-Kommentare ===');
  FOR r IN (SELECT owner, table_name, column_name, comments FROM dba_col_comments WHERE owner = v_schema) LOOP
    IF is_corrupted(r.comments) THEN
      DBMS_OUTPUT.PUT_LINE(r.owner || '.' || r.table_name || '.' || r.column_name || ': ' || r.comments);
      v_hits := v_hits + 1;
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== Views ===');
  FOR r IN (SELECT owner, view_name FROM dba_views WHERE owner = v_schema) LOOP
    BEGIN
      SELECT text INTO v_text FROM dba_views WHERE owner = r.owner AND view_name = r.view_name;
      IF is_corrupted(v_text) THEN
        DBMS_OUTPUT.PUT_LINE(r.owner || '.' || r.view_name);
        v_hits := v_hits + 1;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN NULL; -- TEXT > 32767 Zeichen (selten) - wird uebersprungen statt Abbruch
    END;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== Trigger ===');
  FOR r IN (SELECT owner, trigger_name FROM dba_triggers WHERE owner = v_schema) LOOP
    BEGIN
      SELECT trigger_body INTO v_text FROM dba_triggers WHERE owner = r.owner AND trigger_name = r.trigger_name;
      IF is_corrupted(v_text) THEN
        DBMS_OUTPUT.PUT_LINE(r.owner || '.' || r.trigger_name);
        v_hits := v_hits + 1;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== Fertig: ' || v_hits || ' Treffer insgesamt ===');
END;
/

UNDEFINE chk_schema
