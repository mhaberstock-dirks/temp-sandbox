-- anonymisieren.sql
-- Ersetzt personenbezogene Stammdaten und Organisationsbezeichnungen durch Fantasiewerte.
--
-- Aufruf (Arbeitsverzeichnis = Repo-Root):
--   @tools/anonymize/anonymisieren.sql PROBE    -- alles ausführen und prüfen, dann ROLLBACK
--   @tools/anonymize/anonymisieren.sql COMMIT   -- alles ausführen und prüfen, dann COMMIT
-- Ausgabe zusätzlich in anon.log.
--
-- Das Skript besteht aus genau einem PL/SQL-Block. Jede Prüfung und jeder Fehler bricht diesen Block ab,
-- danach folgt nur noch "spool off". Deshalb ist kein "whenever sqlerror exit" nötig: Die SQLcl-Session
-- bleibt nach einem Fehler offen und die Meldung sichtbar.
--
-- Ablauf:
--   1. Guard: nur für die Kennungen aus anon_allowed (00_config.sql) - SCHEMA@DB_NAME auf einer
--      Autonomous Database, sonst SCHEMA@DB_NAME@SERVER_HOST.
--   2. Trigger-Vorprüfung auf den betroffenen Tabellen: Ist einer davon INVALID, bricht das Skript ab,
--      BEVOR irgendetwas geändert wird. Die Liste der Trigger samt Status wird ausgegeben.
--   3. Nur die aktiven Trigger der betroffenen Tabellen werden abgeschaltet (sonst würden u. a. die
--      Infor-Schnittstelle über tr_z_*_to_infor_biud und die Historie über tr_pzm_personal_hist_track
--      ausgelöst). Bereits deaktivierte Trigger bleiben unberührt.
--   4. Anonymisieren und prüfen, ob noch Klarnamen übrig sind.
--   5. COMMIT bzw. ROLLBACK (PROBE) - bei jedem Fehler ROLLBACK.
--   6. Genau die in Schritt 3 abgeschalteten Trigger wieder einschalten - auch im Fehlerfall, und zwar
--      erst NACH Commit/Rollback (ALTER TRIGGER ist DDL und würde sonst offene Änderungen committen).
--      Danach wird geprüft, dass jeder davon wieder ENABLED und VALID ist, und die Zahl ungültiger
--      Objekte im Schema mit dem Stand vorher verglichen. Abweichungen führen zu einem Fehler.
--
-- Während des Laufs (Schritte 3-6) laufen DML-Anweisungen ANDERER Sessions auf diesen Tabellen ohne
-- Trigger. Deshalb nur auf einer Datenbank ausführen, die sonst niemand gleichzeitig nutzt.
--
-- Eigenschaften:
--   - Deterministisch: Dieselbe PERS_NR bekommt bei jedem Lauf denselben Fantasienamen - unabhängig
--     davon, welche anderen Personen es gibt.
--   - Eindeutig: Die PERS_NR wird umkehrbar auf eine Kombination aus Vorname und Nachname abgebildet
--     (Namensraum = Anzahl Vornamen x Anzahl Nachnamen, derzeit 100 x 250 = 25.000). Zwei Personen
--     bekommen nur dann denselben Namen, wenn sich ihre PERS_NR um ein Vielfaches davon unterscheiden;
--     die Prüfung am Ende meldet das.
--   - Konsistent: Alle Kopien eines Namens (siehe c_targets) bekommen denselben Wert.
--   - Wiederholbar: Ein zweiter Lauf auf bereits anonymisierten Daten ändert nichts mehr.
--
-- Bewusst NICHT verändert (pseudonymisiert, nicht anonymisiert - mit dem Datenschutz abstimmen):
--   - PERS_NR (Schlüssel in rund 50 Tabellen) und damit alle daran hängenden Zeit-, Abwesenheits-
--     und Lohndaten
--   - Anrede/Geschlecht, Tätigkeit, Vertrags- und Schichtdaten, Ein-/Austrittsdaten, Staatsangehörigkeit,
--     Familienstand, Schwerbehinderung (S_PZM_PERS.BEHIND_STATUS)
--   - Audit-Spalten CREATED_USER / LAST_CHANGE_USER, ISI_USER, ISI_CONTACT, ISI_ADRESSEN, ISI_KOSTENSTELLEN

whenever sqlerror continue none
set serveroutput on feedback off verify off define on
define anon_mode = '&1'
spool anon.log
@@00_config.sql

declare
    l_schema  constant varchar2(128)  := sys_context('userenv', 'current_schema');
    l_mode    constant varchar2(10)   := upper(trim('&anon_mode'));
    l_target  varchar2(512);    -- Kennung der aktuellen Verbindung, siehe Guard
    l_cloud   varchar2(64);     -- Workload-Typ einer Autonomous Database, sonst null
    l_allowed constant varchar2(4000) := upper(replace(q'[&anon_allowed]', ' '));

    -- Namenslisten: nur ASCII (keine Umlaute), damit das Skript unabhängig vom Client-Encoding läuft.
    -- Keine Dubletten, Vornamen-Listen gleich lang (beides wird unten geprüft).
    c_vn_w constant varchar2(4000) :=
        'Anna,Barbara,Christina,Daniela,Elena,Franziska,Gabriele,Hannah,Ines,Julia,'
     || 'Katharina,Laura,Maria,Nina,Olga,Petra,Renate,Sabine,Tanja,Ursula,'
     || 'Vanessa,Waltraud,Yvonne,Zoe,Andrea,Birgit,Carina,Doris,Eva,Frieda,'
     || 'Greta,Heike,Ingrid,Jana,Karin,Lena,Monika,Nadine,Paula,Silke,'
     || 'Alexandra,Angelika,Antonia,Beate,Bettina,Brigitte,Carla,Charlotte,Claudia,Corinna,'
     || 'Denise,Diana,Edith,Elisabeth,Emma,Erika,Esther,Fabienne,Felicitas,Gisela,'
     || 'Helga,Helene,Hildegard,Irene,Isabel,Jasmin,Johanna,Josefine,Judith,Jutta,'
     || 'Kerstin,Klara,Lara,Lea,Lisa,Luise,Magdalena,Maren,Marion,Martina,'
     || 'Melanie,Miriam,Nicole,Nora,Patricia,Regina,Rita,Ronja,Rosa,Sandra,'
     || 'Sarah,Sofia,Stefanie,Susanne,Svenja,Theresa,Ulrike,Vera,Viktoria,Wiebke';
    c_vn_m constant varchar2(4000) :=
        'Andreas,Bernd,Christian,Daniel,Erik,Frank,Georg,Hans,Ingo,Jan,'
     || 'Klaus,Lukas,Markus,Norbert,Oliver,Peter,Ralf,Stefan,Thomas,Uwe,'
     || 'Volker,Werner,Xaver,Yannick,Achim,Boris,Carsten,Dieter,Egon,Felix,'
     || 'Gerd,Heinz,Jens,Karl,Lars,Martin,Nils,Otto,Paul,Sven,'
     || 'Adrian,Albert,Alexander,Anton,Armin,Benjamin,Bernhard,Bruno,Clemens,Dennis,'
     || 'Dominik,Edgar,Elias,Emil,Fabian,Florian,Friedrich,Gregor,Gustav,Harald,'
     || 'Helmut,Henrik,Herbert,Holger,Hubert,Jakob,Joachim,Johannes,Jonas,Josef,'
     || 'Julian,Kai,Konrad,Leon,Lorenz,Ludwig,Manfred,Matthias,Max,Michael,'
     || 'Moritz,Niklas,Oskar,Patrick,Philipp,Rainer,Reinhard,Robert,Rudolf,Sebastian,'
     || 'Simon,Timo,Tobias,Torsten,Ulrich,Valentin,Viktor,Walter,Wolfgang,Zacharias';
    -- Nachnamen = jeder Wortanfang mit jeder Endung (25 x 10 = 250), z. B. Birkenfeld, Lindenhof.
    -- Wortanfänge und Endungen dürfen sich nicht überschneiden (sonst z. B. Bergberg).
    c_nn_anfang constant varchar2(4000) :=
        'Ahorn,Birken,Buchen,Eichen,Erlen,Eschen,Fichten,Linden,Tannen,Weiden,'
     || 'Rosen,Wiesen,Falken,Finken,Lerchen,Hasel,Kirsch,Apfel,Sonnen,Mond,'
     || 'Nuss,Holler,Kranich,Rabens,Adler';
    c_nn_endung constant varchar2(4000) := 'berg,feld,bach,hof,tal,brunn,au,hain,stein,wald';
    l_nn     varchar2(4000);

    -- Dieselben Listen mit fester Breite (jeder Name auf l_w Zeichen aufgefüllt): Der n-te Name ist
    -- dann substr(liste, (n-1) * l_w + 1, l_w) - ohne Suche. regexp_substr(liste, '[^,]+', 1, n) war
    -- bei 250 Nachnamen pro Zeile messbar teuer (16 s für 2.950 Zeilen, reine CPU).
    l_w       pls_integer;
    -- Zerlegte Listen (siehe split_list)
    l_vn_w_t  sys.odcivarchar2list;
    l_vn_m_t  sys.odcivarchar2list;
    l_nn_t    sys.odcivarchar2list := sys.odcivarchar2list();
    l_vn_w_fw varchar2(4000);
    l_vn_m_fw varchar2(4000);
    l_nn_fw   varchar2(4000);

    l_cnt_vn pls_integer;
    l_cnt_nn pls_integer;
    l_m      pls_integer;   -- Namensraum = l_cnt_vn * l_cnt_nn
    l_a      pls_integer;   -- Multiplikator, teilerfremd zu l_m -> PERS_NR * l_a mod l_m ist umkehrbar

    type t_target is record (tab varchar2(128), pk varchar2(128), vcol varchar2(128), ncol varchar2(128));
    type t_targets is table of t_target;
    -- Alle Tabellen mit Vor-/Nachname einer Person, Schlüssel ist jeweils die Personalnummer.
    -- PZM_PERSONAL ist die Quelle der Anrede (für passende Vornamen), alle anderen folgen derselben Zuordnung.
    c_targets constant t_targets := t_targets(
        t_target('PZM_PERSONAL',              'PERS_NR', 'PERS_VNAME', 'PERS_NNAME'),
        t_target('S_PZM_PERS',                'PERS_NR', 'VNAME',      'NNAME'),
        t_target('PZM_ZE_AZK_URLAUB',         'PERS_NR', 'VNAME',      'NNAME'),
        t_target('PZM_ZE_LOA_EXP_EXT_GUTSCH', 'PERS_NR', 'PERS_VNAME', 'PERS_NNAME'),
        t_target('Z_PZM_PERSONAL_IMPORT',     'PERS_NR', 'PERS_VNAME', 'PERS_NNAME'));

    -- Alle Tabellen, die das Skript ändert - deren Trigger werden geprüft und während des Laufs abgeschaltet
    c_changed_tabs constant sys.odcivarchar2list := sys.odcivarchar2list(
        'PZM_PERSONAL', 'S_PZM_PERS', 'PZM_ZE_AZK_URLAUB', 'PZM_ZE_LOA_EXP_EXT_GUTSCH', 'Z_PZM_PERSONAL_IMPORT',
        'PZM_ABWESENHEITS_ANTR', 'PZM_ABTEILUNGEN', 'PZM_PRODUKTIONSBEREICHE');

    -- Von diesem Skript abgeschaltete Trigger (Owner und Name), nur diese werden wieder eingeschaltet
    l_disabled_owner sys.odcivarchar2list := sys.odcivarchar2list();
    l_disabled_name  sys.odcivarchar2list := sys.odcivarchar2list();
    l_restored       boolean := false;
    l_restore_errors pls_integer := 0;
    l_invalid_before pls_integer;

    l_sql    varchar2(4000);
    l_count  pls_integer;
    l_min_nr number;
    l_max_nr number;
    l_errors pls_integer := 0;

    -- SQLcl zeigt dbms_output erst nach dem Ende des Blocks. Während des Laufs ist der aktuelle
    -- Schritt deshalb zusätzlich in v$session.action zu sehen (module = 'anonymisieren').
    procedure log(p_text varchar2) is
    begin
        sys.dbms_output.put_line(to_char(systimestamp, 'hh24:mi:ss') || ' ' || p_text);
        sys.dbms_application_info.set_action(substr(trim(p_text), 1, 64));
    end;

    function table_exists(p_tab varchar2) return boolean is
        l_n pls_integer;
    begin
        select count(*) into l_n from all_tables where owner = l_schema and table_name = p_tab;
        return l_n > 0;
    end;

    function col_len(p_tab varchar2, p_col varchar2) return pls_integer is
        l_len pls_integer;
    begin
        select char_length into l_len from all_tab_columns
         where owner = l_schema and table_name = p_tab and column_name = p_col;
        return l_len;
    end;

    function gcd(p_x pls_integer, p_y pls_integer) return pls_integer is
        l_x pls_integer := p_x;
        l_y pls_integer := p_y;
        l_r pls_integer;
    begin
        while l_y <> 0 loop
            l_r := mod(l_x, l_y);
            l_x := l_y;
            l_y := l_r;
        end loop;
        return l_x;
    end;

    -- Zerlegt eine kommagetrennte Liste mit STRSPLIT (in allen PZM-Datenbanken vorhanden).
    -- Dynamisch aufgerufen, damit der Block auch bei falschem Schema kompiliert und der Guard greift.
    -- Zieltyp sys.odcivarchar2list statt split_tbl aus demselben Grund.
    -- Nicht regexp_substr(liste, '[^,]+', 1, i) in einer Schleife: Das sucht für jedes i wieder vom
    -- Anfang - bei 250 Nachnamen rund 31.000 Treffer pro Liste, das kostete rund 4 Sekunden.
    function split_list(p_list varchar2) return sys.odcivarchar2list is
        l_result sys.odcivarchar2list;
    begin
        execute immediate q'~select column_value from table(strsplit(:list, ','))~'
            bulk collect into l_result
            using p_list;
        return l_result;
    end;

    function max_len(p_list sys.odcivarchar2list) return pls_integer is
        l_max pls_integer := 0;
    begin
        for i in 1 .. p_list.count loop
            l_max := greatest(l_max, length(p_list(i)));
        end loop;
        return l_max;
    end;

    function fixed_width(p_list sys.odcivarchar2list) return varchar2 is
        l_result varchar2(32767);
    begin
        for i in 1 .. p_list.count loop
            l_result := l_result || rpad(p_list(i), l_w);
        end loop;
        if length(l_result) > 4000 then
            raise_application_error(-20036, 'Namensliste mit fester Breite ist laenger als 4000 Zeichen - Liste kuerzen.');
        end if;
        return l_result;
    end;

    function duplicates(p_list sys.odcivarchar2list) return pls_integer is
        type t_seen is table of boolean index by varchar2(4000);
        l_seen t_seen;
        l_n    pls_integer := 0;
    begin
        for i in 1 .. p_list.count loop
            if l_seen.exists(p_list(i)) then
                l_n := l_n + 1;
            else
                l_seen(p_list(i)) := true;
            end if;
        end loop;
        return l_n;
    end;

    function invalid_objects return pls_integer is
        l_n pls_integer;
    begin
        select count(*) into l_n from all_objects where owner = l_schema and status <> 'VALID';
        return l_n;
    end;

    -- p_sql liefert die Anzahl nicht anonymisierter Zeilen; mit p_names => true erhaelt es die
    -- Fantasie-Listen als Binds :vn (alle Vornamen) und :nn (Nachnamen)
    procedure check_zero(p_what varchar2, p_sql varchar2, p_names boolean default false) is
        l_n pls_integer;
    begin
        if p_names then
            execute immediate p_sql into l_n using c_vn_w || ',' || c_vn_m, l_nn;
        else
            execute immediate p_sql into l_n;
        end if;
        if l_n > 0 then
            log('  FEHLER: ' || p_what || ': ' || l_n || ' Zeile(n) nicht anonymisiert');
            l_errors := l_errors + 1;
        else
            log('  ok: ' || p_what);
        end if;
    end;

    -- Schaltet genau die vom Skript abgeschalteten Trigger wieder ein und prüft deren Zustand.
    -- Darf nur nach COMMIT/ROLLBACK aufgerufen werden (DDL). Fehler werden gesammelt, nicht geworfen,
    -- damit auch bei einem Problem mit einem Trigger alle übrigen wieder eingeschaltet werden.
    procedure restore_triggers is
        l_status     all_triggers.status%type;
        l_obj_status all_objects.status%type;
    begin
        -- Schon erledigt, oder Abbruch vor dem Abschalten (Guard, Vorprüfung) - dann gibt es nichts zurückzustellen
        if l_restored or l_disabled_name.count = 0 then
            return;
        end if;
        l_restored := true;

        -- Drei Durchgänge: erst alle einschalten, dann ungültige kompilieren, dann alle prüfen. Ein Trigger mit
        -- FOLLOWS/PRECEDES hängt vom referenzierten Trigger ab; dessen ALTER TRIGGER (DDL) macht ihn ungültig,
        -- auch wenn er selbst schon wieder eingeschaltet war. Der Code ist unverändert, neu kompilieren genügt.
        log('Trigger wieder einschalten:');
        for i in 1 .. l_disabled_name.count loop
            begin
                execute immediate 'alter trigger "' || l_disabled_owner(i) || '"."' || l_disabled_name(i) || '" enable';
            exception
                when others then
                    log('  FEHLER beim Einschalten von ' || l_disabled_name(i) || ': ' || sqlerrm);
                    l_restore_errors := l_restore_errors + 1;
            end;
        end loop;

        for i in 1 .. l_disabled_name.count loop
            select max(o.status) into l_obj_status
              from all_objects o
             where o.owner = l_disabled_owner(i) and o.object_name = l_disabled_name(i) and o.object_type = 'TRIGGER';
            if l_obj_status <> 'VALID' then
                begin
                    execute immediate 'alter trigger "' || l_disabled_owner(i) || '"."' || l_disabled_name(i) || '" compile';
                    log('  neu kompiliert: ' || l_disabled_name(i));
                exception
                    when others then
                        -- Die Prüfung unten meldet ihn dann als ungültig
                        log('  FEHLER beim Kompilieren von ' || l_disabled_name(i) || ': ' || sqlerrm);
                end;
            end if;
        end loop;

        for i in 1 .. l_disabled_name.count loop
            begin
                select t.status, o.status
                  into l_status, l_obj_status
                  from all_triggers t
                  join all_objects o on o.owner = t.owner and o.object_name = t.trigger_name and o.object_type = 'TRIGGER'
                 where t.owner = l_disabled_owner(i) and t.trigger_name = l_disabled_name(i);
            exception
                when no_data_found then
                    l_status := 'NICHT GEFUNDEN';
                    l_obj_status := '-';
            end;

            if l_status = 'ENABLED' and l_obj_status = 'VALID' then
                log('  ok: ' || l_disabled_name(i));
            else
                log('  FEHLER: ' || l_disabled_name(i) || ' ist ' || l_status || '/' || l_obj_status
                    || ' (erwartet ENABLED/VALID)');
                l_restore_errors := l_restore_errors + 1;
            end if;
        end loop;

        if invalid_objects > l_invalid_before then
            log('  FEHLER: Ungueltige Objekte im Schema vorher ' || l_invalid_before || ', jetzt ' || invalid_objects);
            l_restore_errors := l_restore_errors + 1;
        else
            log('  ok: Ungueltige Objekte im Schema unveraendert (' || l_invalid_before || ')');
        end if;
    end;
begin
    sys.dbms_application_info.set_module('anonymisieren', 'Start');

    -- ---------------------------------------------------------------------------------------------
    -- Guard (noch keine Änderung)
    -- ---------------------------------------------------------------------------------------------
    -- Ein Fehler hier bricht nur diesen Block ab (vor jeder Änderung), die SQLcl-Session bleibt offen.
    --
    -- Autonomous Database: DB_NAME ist eindeutig, der Server-Host wechselt -> Kennung ohne Host.
    -- Sonst: DB_NAME ist nicht unbedingt eindeutig (z. B. Klone der Produktion), der Host ist dauerhaft
    -- -> Kennung mit Host. Erkennung über CLOUD_SERVICE (nur auf einer ADB gesetzt). Kennt eine ältere
    -- Version den Parameter nicht, gilt die Datenbank als nicht-ADB - schlägt die Erkennung auf einer ADB
    -- fehl, enthält die Kennung den Host, passt zu keinem Eintrag, und das Skript bricht ab.
    begin
        l_cloud := sys_context('userenv', 'cloud_service');
    exception
        when others then
            l_cloud := null;
    end;
    l_target := upper(sys_context('userenv', 'current_schema') || '@' || sys_context('userenv', 'db_name'));
    if l_cloud is null then
        l_target := l_target || '@' || upper(sys_context('userenv', 'server_host'));
        log('Verbunden mit ' || l_target || ' (SCHEMA@DB_NAME@SERVER_HOST)');
    else
        log('Verbunden mit ' || l_target || ' (SCHEMA@DB_NAME, Autonomous Database ' || l_cloud || ')');
    end if;
    if l_allowed is null then
        raise_application_error(-20001, 'anon_allowed in 00_config.sql ist leer - nichts freigegeben.');
    end if;
    if instr(',' || l_allowed || ',', ',' || l_target || ',') = 0 then
        raise_application_error(-20002, l_target || ' ist nicht in anon_allowed (00_config.sql) freigegeben.');
    end if;

    -- ---------------------------------------------------------------------------------------------
    -- Vorbedingungen (noch keine Änderung)
    -- ---------------------------------------------------------------------------------------------
    if l_mode not in ('PROBE', 'COMMIT') then
        raise_application_error(-20030, 'Aufruf mit PROBE oder COMMIT, nicht "' || l_mode || '".');
    end if;
    log('Modus: ' || l_mode);

    l_vn_w_t := split_list(c_vn_w);
    l_vn_m_t := split_list(c_vn_m);
    declare
        l_anfang sys.odcivarchar2list := split_list(c_nn_anfang);
        l_endung sys.odcivarchar2list := split_list(c_nn_endung);
    begin
        for a in 1 .. l_anfang.count loop
            for e in 1 .. l_endung.count loop
                l_nn_t.extend;
                l_nn_t(l_nn_t.count) := l_anfang(a) || l_endung(e);
                -- Kommagetrennt zusätzlich für die Prüfung am Ende (check_zero)
                l_nn := l_nn || case when l_nn is not null then ',' end || l_nn_t(l_nn_t.count);
            end loop;
        end loop;
    end;

    l_cnt_vn := l_vn_w_t.count;
    l_cnt_nn := l_nn_t.count;
    if l_cnt_vn <> l_vn_m_t.count then
        raise_application_error(-20031, 'Vornamen-Listen c_vn_w und c_vn_m muessen gleich lang sein.');
    end if;
    if duplicates(l_vn_w_t) + duplicates(l_vn_m_t) + duplicates(l_nn_t) > 0 then
        raise_application_error(-20035, 'Namenslisten enthalten Dubletten.');
    end if;

    l_w       := greatest(max_len(l_vn_w_t), max_len(l_vn_m_t), max_len(l_nn_t));
    l_vn_w_fw := fixed_width(l_vn_w_t);
    l_vn_m_fw := fixed_width(l_vn_m_t);
    l_nn_fw   := fixed_width(l_nn_t);

    l_m := l_cnt_vn * l_cnt_nn;
    l_a := round(l_m * 0.618);
    while gcd(l_a, l_m) <> 1 loop
        l_a := l_a + 1;
    end loop;
    log('Namensraum: ' || l_cnt_vn || ' Vornamen x ' || l_cnt_nn || ' Nachnamen = ' || l_m || ' Kombinationen');

    log('Trigger auf den betroffenen Tabellen (Tabelle / Trigger / Aktivierung / Gueltigkeit):');
    l_count := 0;
    for r in (select t.table_name, t.owner, t.trigger_name, t.status, o.status as obj_status
                from all_triggers t
                join all_objects o on o.owner = t.owner and o.object_name = t.trigger_name and o.object_type = 'TRIGGER'
               where t.table_owner = l_schema
                 and t.table_name in (select column_value from table(c_changed_tabs))
               order by t.table_name, t.trigger_name)
    loop
        log('  ' || rpad(r.table_name, 27) || rpad(r.trigger_name, 45) || rpad(r.status, 10) || r.obj_status);
        if r.obj_status <> 'VALID' then
            l_count := l_count + 1;
        end if;
    end loop;
    if l_count > 0 then
        raise_application_error(-20032, l_count || ' Trigger auf den betroffenen Tabellen sind nicht VALID. '
                                || 'Erst kompilieren bzw. Ursache klaeren - es wurde nichts geaendert.');
    end if;

    l_invalid_before := invalid_objects;
    log('Ungueltige Objekte im Schema vor dem Lauf: ' || l_invalid_before);

    -- ---------------------------------------------------------------------------------------------
    -- Aktive Trigger der betroffenen Tabellen abschalten (ab hier stellt der Exception-Handler zurück)
    -- ---------------------------------------------------------------------------------------------
    for r in (select t.owner, t.trigger_name
                from all_triggers t
               where t.table_owner = l_schema
                 and t.table_name in (select column_value from table(c_changed_tabs))
                 and t.status = 'ENABLED'
               order by t.trigger_name)
    loop
        execute immediate 'alter trigger "' || r.owner || '"."' || r.trigger_name || '" disable';
        l_disabled_owner.extend; l_disabled_owner(l_disabled_owner.count) := r.owner;
        l_disabled_name.extend;  l_disabled_name(l_disabled_name.count)   := r.trigger_name;
    end loop;
    log(l_disabled_name.count || ' Trigger abgeschaltet.');

    -- ---------------------------------------------------------------------------------------------
    -- Personennamen
    -- ---------------------------------------------------------------------------------------------
    log('Personennamen:');
    for i in 1 .. c_targets.count loop
        if not table_exists(c_targets(i).tab) then
            log('  ' || c_targets(i).tab || ': Tabelle nicht vorhanden, uebersprungen');
            continue;
        end if;

        -- Die Namen hängen nur von der PERS_NR ab: #IDX# bildet sie umkehrbar auf 0 .. l_m-1 ab,
        -- daraus Vorname = #IDX# mod Anzahl Vornamen, Nachname = #IDX# div Anzahl Vornamen.
        -- Die Anrede kommt aus PZM_PERSONAL (Unterabfrage über den Primärschlüssel).
        -- Tabellen-/Spaltennamen und Zahlen werden per replace eingesetzt, die Namenslisten gebunden.
        l_sql := q'~
            update #TAB# t
               set t.#VCOL# = substr(rtrim(substr(
                                  case (select case when upper(trim(p.pers_anrede)) like 'FRAU%' then 'W'
                                                    when upper(trim(p.pers_anrede)) like 'HERR%' then 'M'
                                               end
                                          from pzm_personal p
                                         where p.pers_nr = t.#PK#)
                                      when 'W' then :vn_w
                                      when 'M' then :vn_m
                                      -- Anrede unbekannt oder Person nicht in PZM_PERSONAL
                                      else case when mod(ora_hash(t.#PK#, 4294967295, 3), 2) = 0 then :vn_w else :vn_m end
                                  end,
                                  mod(#IDX#, #CNT_VN#) * #W# + 1, #W#)), 1, #VLEN#),
                   t.#NCOL# = substr(rtrim(substr(:nn, trunc(#IDX# / #CNT_VN#) * #W# + 1, #W#)), 1, #NLEN#)
             where t.#PK# is not null~';
        l_sql := replace(l_sql, '#IDX#', 'mod(mod(t.#PK# * ' || l_a || ', ' || l_m || ') + ' || l_m || ', ' || l_m || ')');
        l_sql := replace(l_sql, '#TAB#',    c_targets(i).tab);
        l_sql := replace(l_sql, '#PK#',     c_targets(i).pk);
        l_sql := replace(l_sql, '#VCOL#',   c_targets(i).vcol);
        l_sql := replace(l_sql, '#NCOL#',   c_targets(i).ncol);
        l_sql := replace(l_sql, '#VLEN#',   col_len(c_targets(i).tab, c_targets(i).vcol));
        l_sql := replace(l_sql, '#NLEN#',   col_len(c_targets(i).tab, c_targets(i).ncol));
        l_sql := replace(l_sql, '#CNT_VN#', l_cnt_vn);
        l_sql := replace(l_sql, '#W#',      l_w);

        execute immediate l_sql using l_vn_w_fw, l_vn_m_fw, l_vn_w_fw, l_vn_m_fw, l_nn_fw;
        log('  ' || c_targets(i).tab || ': ' || sql%rowcount || ' Zeilen');
    end loop;

    -- ---------------------------------------------------------------------------------------------
    -- S_PZM_PERS: weitere Personendaten
    -- ---------------------------------------------------------------------------------------------
    -- Alle Anweisungen auf Tabellen des Schemas laufen als dynamisches SQL: Statisches SQL würde beim
    -- Kompilieren des Blocks aufgelöst - bei falschem Schema scheitert dann der ganze Block, noch bevor
    -- der Guard laufen kann (ORA-00942).

    -- Zeilen ohne Personalnummer: Name aus der ROWID ableiten (werden vom UPDATE oben nicht erfasst)
    execute immediate q'~
        update s_pzm_pers
           set vname = rtrim(substr(:vn, mod(ora_hash(rowidtochar(rowid), 4294967295, 1), :cnt_vn) * :w + 1, :w)),
               nname = rtrim(substr(:nn, mod(ora_hash(rowidtochar(rowid), 4294967295, 2), :cnt_nn) * :w + 1, :w))
         where pers_nr is null~'
        using l_vn_m_fw, l_cnt_vn, l_w, l_w, l_nn_fw, l_cnt_nn, l_w, l_w;

    execute immediate q'~
        update s_pzm_pers
           set username    = nvl2(username,    'u' || nvl(to_char(pers_nr), rowidtochar(rowid)), null),
               passwort    = null,
               anschrift   = nvl2(anschrift,   'Musterstrasse ' || (mod(ora_hash(nvl(pers_nr, 0), 4294967295, 4), 200) + 1), null),
               plz         = nvl2(plz,         12345, null),
               wohnort     = nvl2(wohnort,     'Musterstadt', null),
               telefon_nr  = null,
               kuerzel     = nvl2(kuerzel,     upper(substr(vname, 1, 1) || substr(nname, 1, 2)), null),
               -- Geburtsjahr bleibt (Alter ist fachlich relevant), Tag/Monat auf den 1. Juli
               geb_datum   = trunc(geb_datum, 'YYYY') + 181~';
    log('  S_PZM_PERS weitere Personendaten: ' || sql%rowcount || ' Zeilen');

    -- ---------------------------------------------------------------------------------------------
    -- Freitexte, die Personenbezug oder Gesundheitsangaben enthalten können
    -- ---------------------------------------------------------------------------------------------
    execute immediate 'update pzm_abwesenheits_antr set au_bemerkung = null where au_bemerkung is not null';
    log('  PZM_ABWESENHEITS_ANTR.AU_BEMERKUNG geleert: ' || sql%rowcount || ' Zeilen');

    -- ---------------------------------------------------------------------------------------------
    -- Organisation
    -- ---------------------------------------------------------------------------------------------
    log('Organisation:');
    execute immediate q'~
        update pzm_abteilungen
           set abt_name      = 'Abteilung ' || abt_id,
               abt_kurz_name = nvl2(abt_kurz_name, 'A' || abt_id, null),
               abt_info      = null~';
    log('  PZM_ABTEILUNGEN: ' || sql%rowcount || ' Zeilen');

    execute immediate q'~
        update pzm_produktionsbereiche
           set pb_name        = 'Bereich ' || pb_id,
               pb_bemerkungen = null~';
    log('  PZM_PRODUKTIONSBEREICHE: ' || sql%rowcount || ' Zeilen');

    -- ---------------------------------------------------------------------------------------------
    -- Prüfung: keine Klarnamen mehr übrig (jeder Name muss aus den Fantasie-Listen stammen)
    -- ---------------------------------------------------------------------------------------------
    log('Pruefung:');
    for i in 1 .. c_targets.count loop
        if table_exists(c_targets(i).tab) then
            check_zero(c_targets(i).tab,
                'select count(*) from ' || c_targets(i).tab
                || ' where instr('','' || :vn || '','', '','' || ' || c_targets(i).vcol || ' || '','') = 0'
                || '    or instr('','' || :nn || '','', '','' || ' || c_targets(i).ncol || ' || '','') = 0',
                p_names => true);
        end if;
    end loop;
    check_zero('S_PZM_PERS Passwort/Telefon',
        'select count(*) from s_pzm_pers where passwort is not null or telefon_nr is not null');
    check_zero('PZM_ABTEILUNGEN',
        'select count(*) from pzm_abteilungen where abt_name <> ''Abteilung '' || abt_id');
    check_zero('PZM_PRODUKTIONSBEREICHE',
        'select count(*) from pzm_produktionsbereiche where pb_name <> ''Bereich '' || pb_id');

    -- Eindeutigkeit ist erwünscht, aber kein Grund, die Anonymisierung zu verwerfen -> nur Hinweis
    execute immediate q'~
        select nvl(sum(anzahl), 0), min(min_nr), max(max_nr)
          from (select count(*) as anzahl, min(pers_nr) as min_nr, max(pers_nr) as max_nr
                  from pzm_personal
                 group by pers_vname, pers_nname
                having count(*) > 1)~'
       into l_count, l_min_nr, l_max_nr;
    if l_count = 0 then
        log('  ok: PZM_PERSONAL Namen eindeutig');
    else
        log('  HINWEIS: PZM_PERSONAL ' || l_count || ' Personen mit mehrfach vergebenem Namen (PERS_NR '
            || l_min_nr || ' .. ' || l_max_nr || ') - PERS_NR-Spanne groesser als der Namensraum ('
            || l_m || '), Namenslisten erweitern');
    end if;

    if l_errors > 0 then
        raise_application_error(-20033, l_errors || ' Pruefung(en) fehlgeschlagen - alle Aenderungen werden zurueckgerollt.');
    end if;

    -- ---------------------------------------------------------------------------------------------
    -- Abschluss: erst Commit/Rollback, dann Trigger zurück
    -- ---------------------------------------------------------------------------------------------
    if l_mode = 'COMMIT' then
        commit;
        log('Anonymisierung committet.');
    else
        rollback;
        log('PROBE: alle Pruefungen erfolgreich, Aenderungen zurueckgerollt.');
    end if;

    restore_triggers;
    sys.dbms_application_info.set_module(null, null);
    if l_restore_errors > 0 then
        raise_application_error(-20034, l_restore_errors || ' Problem(e) beim Wiederherstellen der Trigger - siehe Ausgabe oben.');
    end if;
exception
    when others then
        rollback;
        log('ABBRUCH: ' || sqlerrm || ' - Aenderungen zurueckgerollt.');
        restore_triggers;
        sys.dbms_application_info.set_module(null, null);
        raise;
end;
/

spool off
