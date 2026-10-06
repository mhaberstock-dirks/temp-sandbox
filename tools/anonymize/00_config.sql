-- 00_config.sql
-- Einstellungen für anonymisieren.sql, trigger_aus.sql und trigger_ein.sql (dort per @@ eingebunden).
--
-- anon_allowed: kommagetrennte Liste der Verbindungen, auf denen die Skripte laufen dürfen. Ein Eintrag ist
--   - SCHEMA@DB_NAME              für eine Autonomous Database (DB_NAME ist eindeutig, der Host wechselt)
--   - SCHEMA@DB_NAME@SERVER_HOST  für alle anderen Datenbanken (DB_NAME ist nicht unbedingt eindeutig,
--                                 z. B. bei Klonen der Produktion; der Host ist dauerhaft)
-- Die Skripte erkennen selbst, ob sie auf einer Autonomous Database laufen, bilden die passende Kennung und
-- vergleichen sie exakt mit den Einträgen. Groß-/Kleinschreibung und Leerzeichen spielen keine Rolle.
-- Die Kennung steht in der ersten Ausgabezeile ("Verbunden mit ..."), oder per Abfrage:
--
--   select sys_context('userenv','current_schema') || '@' || sys_context('userenv','db_name')
--          || nvl2(sys_context('userenv','cloud_service'), null, '@' || sys_context('userenv','server_host'))
--     from dual;
--
-- NIE eine Produktiv-Datenbank oder die gemeinsame Haupt-Entwicklungsdatenbank eintragen.
-- Leer = die Skripte brechen immer ab.

define anon_allowed = 'DIRKSPZM32@GBA35C3573202B6_ADBDEVMH'

-- trg_tables: Tabellen, deren Trigger trigger_aus.sql / trigger_ein.sql vor bzw. nach einer
-- Datenübertragung ab- und wieder einschalten. Kommagetrennt, oder * für alle Tabellen des Schemas.
-- Voreinstellung: dieselben Tabellen, die anonymisieren.sql ändert (dort fest im Skript, c_changed_tabs).

define trg_tables = 'PZM_PERSONAL, S_PZM_PERS, PZM_ZE_AZK_URLAUB, PZM_ZE_LOA_EXP_EXT_GUTSCH, Z_PZM_PERSONAL_IMPORT, PZM_ABWESENHEITS_ANTR, PZM_ABTEILUNGEN, PZM_PRODUKTIONSBEREICHE'
