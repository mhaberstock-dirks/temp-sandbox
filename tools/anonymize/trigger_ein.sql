-- trigger_ein.sql
-- Schaltet genau die Trigger wieder ein, die trigger_aus.sql abgeschaltet hat - NACH der Datenübertragung
-- (und ggf. nach anonymisieren.sql).
--
-- Aufruf (SQLcl):  @tools/anonymize/trigger_ein.sql <datei>
--   <datei> = die von trigger_aus.sql geschriebene trigger_status_<db_name>_<zeitstempel>.sql
--   (trigger_aus.sql gibt den vollständigen Aufruf am Ende aus)
--
-- Ablauf (ein PL/SQL-Block - jeder Fehler bricht nur diesen ab, die Session bleibt offen):
--   1. Die Datei wird ausgeführt: Ihre Protokollzeilen sind Kommentare, der Block am Ende übergibt
--      Datenbank-Kennung und Triggerliste an die Bind-Variablen :trg_target und :trg_restore.
--   2. Guard wie in anonymisieren.sql, zusätzlich: Die Datei muss zur aktuellen Verbindung gehören.
--   3. Jeden Trigger aus der Liste einschalten. Scheitert einer, werden die übrigen trotzdem eingeschaltet.
--   4. Prüfung: Jeder Trigger aus der Liste ist ENABLED und VALID; ungültige Objekte im Schema werden
--      aufgelistet.
-- Mehrfacher Aufruf mit derselben Datei ist unkritisch. Die Datei kann nach Erfolg gelöscht werden.

whenever sqlerror continue none
set serveroutput on size unlimited feedback off verify off define on
define trg_file = '&1'
@@00_config.sql

variable trg_target  varchar2(512)
variable trg_restore clob
begin
    -- Zurücksetzen, damit kein Wert aus einem früheren Aufruf in derselben Session übrig bleibt
    :trg_target  := null;
    :trg_restore := null;
end;
/

prompt Lese &trg_file ...
@&trg_file

declare
    l_allowed constant varchar2(4000) := upper(replace(q'[&anon_allowed]', ' '));
    l_target  varchar2(512);
    l_cloud   varchar2(64);

    l_restore clob := :trg_restore;
    l_owner   sys.odcivarchar2list := sys.odcivarchar2list();
    l_name    sys.odcivarchar2list := sys.odcivarchar2list();
    l_entries sys.odcivarchar2list := sys.odcivarchar2list();   -- "OWNER.TRIGGER", für die Prüfabfrage
    l_entry   varchar2(300);
    l_start   pls_integer := 1;
    l_pos     pls_integer;
    l_count   pls_integer;
    l_enabled pls_integer := 0;
    l_errors  pls_integer := 0;
    l_invalid pls_integer := 0;

    procedure log(p_text varchar2) is
    begin
        sys.dbms_output.put_line(to_char(systimestamp, 'hh24:mi:ss') || ' ' || p_text);
    end;

    function in_list(p_list varchar2, p_name varchar2) return boolean is
    begin
        return instr(',' || p_list || ',', ',' || p_name || ',') > 0;
    end;
begin
    -- ---------------------------------------------------------------------------------------------
    -- Guard (identisch zu anonymisieren.sql) und Zugehörigkeit der Datei
    -- ---------------------------------------------------------------------------------------------
    begin
        l_cloud := sys_context('userenv', 'cloud_service');
    exception
        when others then
            l_cloud := null;
    end;
    l_target := upper(sys_context('userenv', 'current_schema') || '@' || sys_context('userenv', 'db_name'));
    if l_cloud is null then
        l_target := l_target || '@' || upper(sys_context('userenv', 'server_host'));
    end if;
    log('Verbunden mit ' || l_target);
    if l_allowed is null then
        raise_application_error(-20001, 'anon_allowed in 00_config.sql ist leer - nichts freigegeben.');
    end if;
    if not in_list(l_allowed, l_target) then
        raise_application_error(-20002, l_target || ' ist nicht in anon_allowed (00_config.sql) freigegeben.');
    end if;
    if :trg_target is null then
        raise_application_error(-20045, 'Die Datei &trg_file enthaelt keinen Trigger-Zustand - trigger_aus.sql ist dort '
                                || 'vermutlich abgebrochen (siehe Kommentare in der Datei).');
    end if;
    if :trg_target <> l_target then
        raise_application_error(-20046, 'Die Datei gehoert zu ' || :trg_target || ', verbunden ist ' || l_target || '.');
    end if;

    -- ---------------------------------------------------------------------------------------------
    -- Triggerliste aus der Datei ("OWNER.TRIGGER,OWNER.TRIGGER,...")
    -- ---------------------------------------------------------------------------------------------
    loop
        l_pos := instr(l_restore, ',', l_start);
        exit when l_pos = 0 or l_pos is null;
        l_entry := substr(l_restore, l_start, l_pos - l_start);
        l_entries.extend; l_entries(l_entries.count) := l_entry;
        l_owner.extend; l_owner(l_owner.count) := substr(l_entry, 1, instr(l_entry, '.') - 1);
        l_name.extend;  l_name(l_name.count)   := substr(l_entry, instr(l_entry, '.') + 1);
        l_start := l_pos + 1;
    end loop;
    log(l_name.count || ' Trigger laut Datei wieder einzuschalten.');

    -- ---------------------------------------------------------------------------------------------
    -- Einschalten und prüfen
    -- ---------------------------------------------------------------------------------------------
    for i in 1 .. l_name.count loop
        begin
            execute immediate 'alter trigger "' || l_owner(i) || '"."' || l_name(i) || '" enable';
            l_enabled := l_enabled + 1;
        exception
            when others then
                log('  FEHLER beim Einschalten von ' || l_name(i) || ': ' || sqlerrm);
                l_errors := l_errors + 1;
        end;
    end loop;
    log(l_enabled || ' Trigger eingeschaltet.');

    -- Ein Trigger mit FOLLOWS/PRECEDES hängt vom referenzierten Trigger ab. ALTER TRIGGER (disable/enable)
    -- auf diesem ist DDL und macht den abhängigen ungültig - der Code ist unverändert, neu kompilieren genügt.
    for r in (select t.owner, t.trigger_name
                from all_triggers t
                join all_objects o on o.owner = t.owner and o.object_name = t.trigger_name and o.object_type = 'TRIGGER'
               where t.owner || '.' || t.trigger_name in (select column_value from table(l_entries))
                 and o.status <> 'VALID')
    loop
        begin
            execute immediate 'alter trigger "' || r.owner || '"."' || r.trigger_name || '" compile';
            log('  neu kompiliert: ' || r.trigger_name);
        exception
            when others then
                -- Die Prüfung unten meldet ihn dann als ungültig
                log('  FEHLER beim Kompilieren von ' || r.trigger_name || ': ' || sqlerrm);
        end;
    end loop;

    -- Eine Abfrage für alle Trigger der Liste statt einer je Trigger (Data Dictionary ist auf der ADB träge)
    log('Pruefung:');
    l_count := 0;
    for r in (select t.owner || '.' || t.trigger_name as entry, t.status, o.status as obj_status
                from all_triggers t
                join all_objects o on o.owner = t.owner and o.object_name = t.trigger_name and o.object_type = 'TRIGGER'
               where t.owner || '.' || t.trigger_name in (select column_value from table(l_entries)))
    loop
        l_count := l_count + 1;
        if r.status <> 'ENABLED' or r.obj_status <> 'VALID' then
            log('  FEHLER: ' || rpad(r.entry, 60) || r.status || '/' || r.obj_status || ' (erwartet ENABLED/VALID)');
            l_errors := l_errors + 1;
        end if;
    end loop;
    if l_count < l_entries.count then
        log('  FEHLER: ' || (l_entries.count - l_count) || ' Trigger aus der Datei gibt es nicht mehr');
        l_errors := l_errors + 1;
    end if;
    if l_errors = 0 then
        log('  ok: alle ' || l_name.count || ' Trigger ENABLED/VALID');
    end if;

    for r in (select object_type, object_name
                from all_objects
               where owner = sys_context('userenv', 'current_schema') and status <> 'VALID'
               order by object_type, object_name)
    loop
        l_invalid := l_invalid + 1;
        if l_invalid <= 20 then
            log('  ungueltig: ' || rpad(r.object_type, 20) || r.object_name);
        end if;
    end loop;
    if l_invalid = 0 then
        log('  ok: keine ungueltigen Objekte im Schema');
    else
        log('  HINWEIS: ' || l_invalid || ' ungueltige Objekte im Schema' || case when l_invalid > 20 then ' (die ersten 20 oben)' end);
    end if;

    if l_errors > 0 then
        raise_application_error(-20043, l_errors || ' Problem(e) mit Triggern - siehe Ausgabe oben.');
    end if;
    log('Fertig. &trg_file kann geloescht werden.');
end;
/
