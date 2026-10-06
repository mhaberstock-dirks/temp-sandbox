-- trigger_aus.sql
-- Schaltet die aktiven Trigger der Tabellen aus trg_tables (00_config.sql) ab - VOR einer Datenübertragung
-- aus der Produktion, damit die Übertragung keine Nebenwirkungen auslöst (Infor-Schnittstelle, Historie,
-- Folge-Inserts, Audit-Spalten, PowerBI). Gegenstück: trigger_ein.sql NACH der Übertragung (und ggf. nach
-- anonymisieren.sql).
--
-- Aufruf (SQLcl):  @tools/anonymize/trigger_aus.sql
--
-- Zustand: Welche Trigger abgeschaltet wurden, steht in einer Spool-Datei im Arbeitsverzeichnis,
--   trigger_status_<db_name>_<zeitstempel>.sql
-- Jeder Lauf schreibt eine eigene Datei, ein zweiter Lauf überschreibt also nie den Zustand des ersten.
-- Die Datei ist zugleich Protokoll (Zeilen mit "--") und Eingabe für trigger_ein.sql: Am Ende steht ein
-- kleiner PL/SQL-Block, der Datenbank-Kennung und Triggerliste an Bind-Variablen übergibt. Der genaue
-- Aufruf von trigger_ein.sql wird am Ende ausgegeben. Bereits deaktivierte Trigger stehen nicht in der
-- Liste und bleiben deshalb auch nach trigger_ein.sql aus.
--
-- Ablauf (ein PL/SQL-Block - jeder Fehler bricht nur diesen ab, die Session bleibt offen):
--   1. Guard wie in anonymisieren.sql (anon_allowed).
--   2. Vorprüfung, noch ohne Änderung: Abbruch, wenn ein Trigger auf diesen Tabellen nicht VALID ist
--      oder wenn kein Trigger aktiv ist (dann lief trigger_aus.sql vermutlich schon - trigger_ein.sql mit
--      der Datei des früheren Laufs aufrufen).
--   3. Aktive Trigger abschalten. Scheitert das mittendrin, werden die bereits abgeschalteten sofort
--      wieder eingeschaltet, und die Datei enthält keine Triggerliste.
--   4. Erst nach erfolgreichem Abschalten wird die Triggerliste in die Datei geschrieben.
--
-- Nur Trigger auf Tabellen (keine Schema-/Datenbank-Trigger). Scheduler-Jobs werden nicht angefasst.

whenever sqlerror continue none
set serveroutput on size unlimited feedback off verify off define on
set heading off pagesize 0 linesize 4000 trimspool on
@@00_config.sql

column trg_file new_value trg_file noprint
select 'trigger_status_' || lower(sys_context('userenv', 'db_name')) || '_'
       || to_char(sysdate, 'yyyymmdd_hh24miss') || '.sql' as trg_file
  from dual;

spool &trg_file

declare
    l_schema  constant varchar2(128)  := sys_context('userenv', 'current_schema');
    l_allowed constant varchar2(4000) := upper(replace(q'[&anon_allowed]', ' '));
    l_tables  constant varchar2(4000) := upper(replace(q'[&trg_tables]', ' '));
    l_target  varchar2(512);
    l_cloud   varchar2(64);

    l_disabled_owner sys.odcivarchar2list := sys.odcivarchar2list();
    l_disabled_name  sys.odcivarchar2list := sys.odcivarchar2list();
    l_total   pls_integer := 0;
    l_active  pls_integer := 0;
    l_invalid pls_integer := 0;

    -- Protokollzeilen als SQL-Kommentar, damit die Spool-Datei als Skript ausführbar bleibt
    procedure log(p_text varchar2) is
    begin
        sys.dbms_output.put_line('-- ' || to_char(systimestamp, 'hh24:mi:ss') || ' ' || p_text);
    end;

    procedure code(p_text varchar2) is
    begin
        sys.dbms_output.put_line(p_text);
    end;

    function in_list(p_list varchar2, p_name varchar2) return boolean is
    begin
        return instr(',' || p_list || ',', ',' || p_name || ',') > 0;
    end;
begin
    -- ---------------------------------------------------------------------------------------------
    -- Guard (identisch zu anonymisieren.sql)
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
    if l_tables is null then
        raise_application_error(-20040, 'trg_tables in 00_config.sql ist leer.');
    end if;

    -- ---------------------------------------------------------------------------------------------
    -- Vorprüfung (noch keine Änderung)
    -- ---------------------------------------------------------------------------------------------
    log('Tabellen: ' || l_tables);
    for r in (select t.table_name, t.trigger_name, t.status, o.status as obj_status
                from all_triggers t
                join all_objects o on o.owner = t.owner and o.object_name = t.trigger_name and o.object_type = 'TRIGGER'
               where t.table_owner = l_schema
                 and t.base_object_type = 'TABLE'
                 and (l_tables = '*' or instr(',' || l_tables || ',', ',' || t.table_name || ',') > 0)
               order by t.table_name, t.trigger_name)
    loop
        l_total := l_total + 1;
        if r.status = 'ENABLED' then
            l_active := l_active + 1;
        else
            log('  bereits aus, bleibt aus: ' || rpad(r.table_name, 30) || r.trigger_name);
        end if;
        if r.obj_status <> 'VALID' then
            l_invalid := l_invalid + 1;
            log('  NICHT VALID: ' || rpad(r.table_name, 30) || r.trigger_name || ' (' || r.status || ')');
        end if;
    end loop;
    log(l_total || ' Trigger gefunden, davon ' || l_active || ' aktiv.');

    if l_invalid > 0 then
        raise_application_error(-20041, l_invalid || ' Trigger sind nicht VALID - erst kompilieren bzw. Ursache klaeren. '
                                || 'Es wurde nichts geaendert.');
    end if;
    if l_active = 0 then
        raise_application_error(-20044, 'Kein Trigger aktiv - lief trigger_aus.sql schon? Dann trigger_ein.sql mit der '
                                || 'Datei des frueheren Laufs aufrufen. Es wurde nichts geaendert.');
    end if;

    -- ---------------------------------------------------------------------------------------------
    -- Abschalten
    -- ---------------------------------------------------------------------------------------------
    for r in (select t.owner, t.trigger_name
                from all_triggers t
               where t.table_owner = l_schema
                 and t.base_object_type = 'TABLE'
                 and (l_tables = '*' or instr(',' || l_tables || ',', ',' || t.table_name || ',') > 0)
                 and t.status = 'ENABLED'
               order by t.trigger_name)
    loop
        execute immediate 'alter trigger "' || r.owner || '"."' || r.trigger_name || '" disable';
        l_disabled_owner.extend; l_disabled_owner(l_disabled_owner.count) := r.owner;
        l_disabled_name.extend;  l_disabled_name(l_disabled_name.count)   := r.trigger_name;
    end loop;
    log(l_disabled_name.count || ' Trigger abgeschaltet.');

    -- ---------------------------------------------------------------------------------------------
    -- Zustand für trigger_ein.sql (erst nach erfolgreichem Abschalten)
    -- ---------------------------------------------------------------------------------------------
    code('begin');
    code('    :trg_target  := ''' || l_target || ''';');
    code('    :trg_restore := null;');
    for i in 1 .. l_disabled_name.count loop
        code('    :trg_restore := :trg_restore || ''' || l_disabled_owner(i) || '.' || l_disabled_name(i) || ',''; ');
    end loop;
    code('end;');
    code('/');
exception
    when others then
        -- Teilweise abgeschaltet: diese sofort wieder einschalten, damit kein halber Zustand bleibt
        if l_disabled_name.count > 0 then
            log('ABBRUCH beim Abschalten: ' || sqlerrm);
            log('Schalte die ' || l_disabled_name.count || ' bereits abgeschalteten Trigger wieder ein:');
            for i in 1 .. l_disabled_name.count loop
                begin
                    execute immediate 'alter trigger "' || l_disabled_owner(i) || '"."' || l_disabled_name(i) || '" enable';
                    log('  ok: ' || l_disabled_name(i));
                exception
                    when others then
                        log('  FEHLER: ' || l_disabled_name(i) || ': ' || sqlerrm);
                end;
            end loop;
        end if;
        raise;
end;
/

spool off
prompt
prompt Protokoll und Zustand: &trg_file
prompt Wenn oben kein Fehler steht: Daten uebertragen (ggf. danach anonymisieren.sql), dann
prompt   @tools/anonymize/trigger_ein.sql &trg_file
