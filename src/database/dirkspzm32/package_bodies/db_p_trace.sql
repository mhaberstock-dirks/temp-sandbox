create or replace package body dirkspzm32.db_p_trace is

  /**************************************************************************************************************************
  Funktion ermittelt und gibt die Job-Nr. zurück
  Rückgabewert: v_job = die Jobnummer
  ***************************************************************************************************************************/
    function get_job_nr return integer is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_job integer;
    -------------------------------------------------------------------------------------------------------
    begin
        select
            job
        into v_job
        from
            user_jobs
        where
            what like '%c_tabelle_db_trace_verklein_in%';

        return v_job;

  -- Fehlerbehandlung
    exception
        when others then
            return null;
    end get_job_nr;

  /**************************************************************************************************************************
  Funktion ermittelt den "DB_*"-Trigger einer angegebenen Tabelle
  Parameter:
     in_tabellenname = Name der Tabelle für die der Trigger gelöscht werden soll
  Rückgabewert:
     v_trigger_name = Name des Triggers einer explizit angegebenen Tabelle
  ***************************************************************************************************************************/
    function get_trigger_name (
        in_tabellenname in varchar2
    ) return varchar2 is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_tabellenname varchar2(255);
    -------------------------------------------------------------------------------------------------------
    begin
        select
            trigger_name
        into v_tabellenname
        from
            user_triggers
        where
            upper(trigger_name) like 'DB_%'
            and upper(table_name) = upper(in_tabellenname);

        return v_tabellenname;
  -- Fehlerbehandlung
    exception
        when others then
            return null;
    end get_trigger_name;

  /**************************************************************************************************************************
  Funktion ermittelt aus der Tabelle "ISI_DB_CT_CFG", den Wert aus Spalte "TRIGGERAKTIV"
  Parameter:
     in_tabellenname = Name der Tabelle für die der Trigger gelöscht werden soll
  Rückgabewert:
     gibt den Wert der Spalte "TRIGGERAKTIV" aus "ISI_DB_CT_CFG" zurück
  ***************************************************************************************************************************/
    function get_trigger_aktiv (
        in_tabellenname in varchar2
    ) return integer is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_triggeraktiv integer;
    -------------------------------------------------------------------------------------------------------
    begin
        select
            triggeraktiv
        into v_triggeraktiv
        from
            db_trace_cfg
        where
            tabellenname = in_tabellenname;

        return v_triggeraktiv;

  -- Fehlerbehandlung
    exception
        when others then
            return 0;
    end get_trigger_aktiv;

  /**************************************************************************************************************************
  Funktion ermittelt aus einer Tabelle alle PK Keys der Tabelle
  Parameter:
     in_tabellenname = Name der Tabelle für die die Primärschlüssel ermittelt werden sollen
  Rückgabewert:
     gibt ein String welche die PK-Felder mit ";" getrennt zurück
  ***************************************************************************************************************************/
    function get_pk_schluessel (
        in_tabellenname in varchar2
    ) return varchar2 is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_pk_felder db_trace.act_pk_cols%type;
    -------------------------------------------------------------------------------------------------------
    begin
        select
            listagg(cols.column_name, ';') within group(
            order by
                cols.column_name
            )
        into v_pk_felder
        from
            all_constraints  cons,
            all_cons_columns cols
        where
                1 = 1
            and cols.table_name = upper(in_tabellenname)
            and cons.constraint_type = 'P'
            and cons.constraint_name = cols.constraint_name
            and cons.owner = cols.owner
            and cons.owner = (
                select
                    sys_context('USERENV', 'CURRENT_SCHEMA')
                from
                    dual
            )
        order by
            cols.table_name,
            cols.position;

        return v_pk_felder;

  -- Fehlerbehandlung
    exception
        when others then
            return null;
    end get_pk_schluessel;

    /**************************************************************************************************************************
  Funktion ermittelt aus einer Tabelle alle Spallten der Tabelle
  Parameter:
     in_tabellenname = Name der Tabelle für die die Spalten ermittelt werden sollen
  Rückgabewert:
     gibt ein String welche die Columns mit ";" getrennt zurück
  ***************************************************************************************************************************/
    function get_spalten_namen (
        in_sid          in isi_firma.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_login_id     in isi_user.login_id%type,
        in_tabellenname in varchar2
    ) return varchar2 is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_columns db_trace_cfg.spalten%type;
    -------------------------------------------------------------------------------------------------------
    begin
        select
            listagg(cols.column_name, ';') within group(
            order by
                cols.column_name
            )
        into v_columns
        from
            all_constraints  cons,
            all_cons_columns cols
        where
                1 = 1
            and cols.table_name = upper(in_tabellenname)
            and cons.constraint_type <> 'P'
            and cons.constraint_name = cols.constraint_name
            and cons.owner = cols.owner
            and cons.owner = (
                select
                    sys_context('USERENV', 'CURRENT_SCHEMA')
                from
                    dual
            )
        order by
            cols.table_name,
            cols.position;

        return v_columns;

  -- Fehlerbehandlung
    exception
        when others then
            isi_p_log.c_isi_system_meldung(in_sid,
                                           in_firma_nr,
                                           'Gibt die Spalten einer Tabelle wieder außer PK',
                                           'ORA-DB',
                                           'db_p_trace.get_spalten_namen',
                                           null,
                                           null,
                                           in_login_id,
                                           null,
                                           null,
                                           'Fehler '
                                           || sqlerrm(sqlcode)
                                           || '. ',
                                           'EL');

            return null;
    end get_spalten_namen;

  /**************************************************************************************************************************
  Funktion setzt eine Zeichenkette für die PK-Felder zusammen
  Parameter:
     in_pk_liste = Liste mit den PK-Feldern mit ";" getrennt
     in_art      = ob der neue oder der alte Wert benutzt wird
                   'new' = Stringaufbau mit :new.[Feldnamen]
                   'old' = Stringaufbau mit :old.[Feldnamen]
                   ''    = Stringaufbau mit :[Feldnamen]
  Rückgabewert:
     gibt ein String welche die PK-Felder formatiert zurück gibt
  ***************************************************************************************************************************/
    function ersetze_zeichen (
        in_pk_liste in varchar2,
        in_art      in varchar2
    ) return varchar2 is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_pk_felder varchar2(1024);
    -------------------------------------------------------------------------------------------------------
    begin
        v_pk_felder := lower(trim(in_pk_liste));
        if length(trim(in_art)) > 0 then
            v_pk_felder := ':'
                           || trim(in_art)
                           || '.'
                           || v_pk_felder;
            if instr(in_pk_liste, ';') > 0 then
                v_pk_felder := replace(v_pk_felder,
                                       ';',
                                       '|| '';'' || :'
                                       || trim(in_art)
                                       || '.');

            end if;

        end if;

        return v_pk_felder;

  -- Fehlerbehandlung
    exception
        when others then
            return null;
    end ersetze_zeichen;

  /*************************************************************************************************************************
  Prozedur ruft die Tabelle "c_tabelle_db_trace_verkleinern" auf.
  Parameter:
     in_ab_tage = alle Einträge die älter sind als x Tagen (ab aktuellem Datum) werden gelöscht.
                  Z.B. wenn in_ab_tage=5 und das aktuelle Datum 10.01.2019 ist dann werden alle Einträge die älter
                  als 05.01.2019 sind gelöscht.
                  Default Wert = 30 Tage
  Rückgabewert:
     -
  **************************************************************************************************************************/
    procedure c_tabelle_db_trace_verklein_in (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        in_ab_tage  in integer
    ) is
  -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_meldung varchar2(4048);
  -------------------------------------------------------------------------------------------------------
    begin
        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'Tabelle DB_TRACE verkleinern', 'ORA-DB', 'db_p_trace.c_tabelle_db_trace_verklein_in'
        ,
                                       null, null, in_login_id, null, null,
                                       'Start Tabelle DB_TRACE verkleinern', 'IL');

        c_tabelle_db_trace_verkleinern(in_sid, in_firma_nr, in_login_id, in_ab_tage, v_meldung);
        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'Tabelle DB_TRACE verkleinern', 'ORA-DB', 'db_p_trace.c_tabelle_db_trace_verklein_in'
        ,
                                       null, null, in_login_id, null, null,
                                       'Ende Tabelle DB_TRACE verkleinern', 'IL');

        commit;
    end c_tabelle_db_trace_verklein_in;

  /*************************************************************************************************************************
  Prozedur verkleinert die Tabelle: DB_TRACE
  Parameter:
    in_ab_tage = alle Einträge die älter sind als x Tagen (ab aktuellem Datum) werden gelöscht.
                 Z.B. wenn in_ab_tage=5 und das aktuelle Datum 10.01.2019 ist dann werden alle Einträge die älter
                 als 05.01.2019 sind gelöscht.
                 Default Wert = 30 Tage
  Rückgabewert:
     out_meldung = Eine Meldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure c_tabelle_db_trace_verkleinern (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        in_ab_tage  in integer,
        out_meldung out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_ab_tage             integer;
        v_ab_datum            date;
        v_liste_tabellennamen varchar2(4096);
    -- Cursor auf der Tabelle: db_trace_cfg setzen
        cursor curs_tabelle_act_cfg is
        select
            tabellenname,
            triggeraktiv
        from
            db_trace_cfg;

        rec_act_cfg           curs_tabelle_act_cfg%rowtype;
    -------------------------------------------------------------------------------------------------------
    begin
        if in_ab_tage < 0
        or in_ab_tage is null then
            v_ab_tage := 30;
        else
            v_ab_tage := in_ab_tage;
        end if;

        open curs_tabelle_act_cfg;
        fetch curs_tabelle_act_cfg into rec_act_cfg;
        while curs_tabelle_act_cfg%found loop
            if ( v_ab_tage <= rec_act_cfg.triggeraktiv ) then
                v_ab_tage := v_ab_tage;
            else
                v_ab_tage := rec_act_cfg.triggeraktiv;
            end if;

            v_ab_datum := sysdate - v_ab_tage;

      -- Einträge in der db_trace werden gelöscht
            delete from db_trace
            where
                    act_table = rec_act_cfg.tabellenname
                and log_date < v_ab_datum;

            commit;
            v_liste_tabellennamen := v_liste_tabellennamen
                                     || rec_act_cfg.tabellenname
                                     || ',';
            fetch curs_tabelle_act_cfg into rec_act_cfg;
        end loop;

    -- Cursor auf der Tabelle: db_trace_cfg wird geschlossen
        close curs_tabelle_act_cfg;
        if ( length(trim(v_liste_tabellennamen)) > 0 ) then
            out_meldung := 'Die Einträge der Tabellen '
                           || v_liste_tabellennamen
                           || ' wurden erfolgreich gelöscht';
        else
            out_meldung := 'Keine Einträge wurden gelöscht';
        end if;

        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE Tabelle DB_TRACE verkleinern', 'ORA-DB', 'db_p_trace.c_tabelle_db_trace_verkleinern'
        ,
                                       null, null, in_login_id, null, null,
                                       out_meldung, 'IL');
    /*
    Es werden alle Tabellen aus der Tabelle: DB_TRACE gelöscht
    welche nicht in der Tabelle: db_trace_cfg vorkommen
    und Datum ...
    */
        if in_ab_tage < 0
        or in_ab_tage is null then
            v_ab_datum := sysdate - 30;
        else
            v_ab_datum := sysdate - in_ab_tage;
        end if;

        v_liste_tabellennamen := rtrim(v_liste_tabellennamen, ',');
        delete from db_trace
        where
            act_table not in v_liste_tabellennamen
            and log_date < v_ab_datum;

        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE Tabelle DB_TRACE verkleinern', 'ORA-DB', 'db_p_trace.c_tabelle_db_trace_verkleinern'
        ,
                                       null, null, in_login_id, null, null,
                                       'Es wurden '
                                       || sql%rowcount
                                       || ' Datensätze gelöscht von Tabellen die nicht in der Tabelle db_trace_cfg vorhanden sind.', 'IL'
                                       );

        commit;

  -- Fehlerbehandlung
    exception
        when others then
            if curs_tabelle_act_cfg%isopen then
                close curs_tabelle_act_cfg;
                out_meldung := 'Cursor wurde geschlossen.';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE Tabelle DB_TRACE verkleinern', 'ORA-DB', 'db_p_trace.c_tabelle_db_trace_verkleinern'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

                if sqlcode is not null then
                    out_meldung := 'Fehler '
                                   || sqlerrm(sqlcode)
                                   || '. '
                                   || out_meldung;
                    isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE Tabelle DB_TRACE verkleinern', 'ORA-DB', 'db_p_trace.c_tabelle_db_trace_verkleinern'
                    ,
                                                   null, null, in_login_id, null, null,
                                                   out_meldung, 'IL');

                end if;

            end if;
    end c_tabelle_db_trace_verkleinern;

  /*************************************************************************************************************************
  Prozedur setzt in der Tabelle: db_trace_cfg die Werte der Spalte: TRIGGERAKTIV = 0
  Parameter: -
  Rückgabewert:
     out_meldung = Eine Meldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure c_trigger_deaktivieren (
        in_sid         in isi_firma.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_login_id    in isi_user.login_id%type,
        in_tabellename in varchar2,
        out_meldung    out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
    -------------------------------------------------------------------------------------------------------
    begin
        if in_tabellename is not null
           or length(trim(in_tabellename)) > 0 then
            update db_trace_cfg t
            set
                t.triggeraktiv = 0
            where
                t.tabellenname = in_tabellename;

        else
            update db_trace_cfg t
            set
                t.triggeraktiv = 0;

        end if;

        commit;
        out_meldung := 'Trigger erfolgreich deaktiviert.';
        isi_p_log.c_isi_system_meldung(in_sid,
                                       in_firma_nr,
                                       'TRACE Trigger Deaktivieren',
                                       'ORA-DB',
                                       'db_p_trace.c_trigger_deaktivieren',
                                       null,
                                       null,
                                       in_login_id,
                                       null,
                                       null,
                                       'gestartet '
                                       || to_char(sysdate, 'yyyy-mm-dd hh24')
                                       || ' für Tabelle '
                                       || nvl(in_tabellename, 'ALL'),
                                       'IL');

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Update abgebrochen.';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE  Trigger Deaktivieren', 'ORA-DB', 'db_p_trace.c_trigger_deaktivieren'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

            end if;
    end c_trigger_deaktivieren;

  /*************************************************************************************************************************
  Prozedur setzt in der Tabelle: db_trace_cfg in der Spalte: TRIGGERAKTIV den übergebenen Wert
  Ist der übergebene Wert <= 0 wird der Defaultwert = 30 genommen.
  Parameter:
      in_tabellename = Name der Tabelle
         Werte: kein Tabellenname           => es wird Triggeraktiv für alle Tabellen gesetzt
                Tabellenname wird angegeben => es wird nur für diese Tabelle die Spalte Triggeraktiv gesetzt
      in_wert        = Anzahl der Tage ab wann die Einträge gelöscht werden
  Rückgabewert:
      out_meldung    = Fehlermeldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure c_trigger_aktivieren (
        in_sid         in isi_firma.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_login_id    in isi_user.login_id%type,
        in_tabellename in varchar2,
        in_wert        in integer,
        out_meldung    out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_wert integer;
    -------------------------------------------------------------------------------------------------------
    begin
        if in_wert <= 0
        or in_wert is null then
            v_wert := 30;
        else
            v_wert := in_wert;
        end if;

        if in_tabellename is not null
           or length(trim(in_tabellename)) > 0 then
            update db_trace_cfg t
            set
                t.triggeraktiv = v_wert
            where
                t.tabellenname = in_tabellename;

        else
            update db_trace_cfg t
            set
                t.triggeraktiv = v_wert;

        end if;

        commit;

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Update abgebrochen.';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE  Trigger Aktivieren', 'ORA-DB', 'db_p_trace.c_trigger_aktivieren'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

            end if;
    end c_trigger_aktivieren;

  /*************************************************************************************************************************
  Prozedur löscht alle Trigger aus de Tabelle: USER_TRIGGERS des DB Schemas die mit DB_* anfangen
  Parameter: -
  Rückgabewert:
     out_meldung = Info- oder Fehlermeldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure c_trigger_loeschen_alle (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        out_meldung out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_anzahl          integer;
    -- Cursor auf der Tabelle: USER_TRIGGERS setzen
        cursor curs_user_triggers is
        select
            trigger_name
        from
            user_triggers
        where
            trigger_name like 'DB_%'
            or trigger_name like 'TRAL_%'; -- alte Log Trigger
        rec_user_triggers curs_user_triggers%rowtype;
    -------------------------------------------------------------------------------------------------------
    begin
        v_anzahl := 0;
        open curs_user_triggers;
        fetch curs_user_triggers into rec_user_triggers;
        while curs_user_triggers%found loop
            execute immediate 'DROP TRIGGER ' || rec_user_triggers.trigger_name;
            commit;
            v_anzahl := v_anzahl + 1;
            fetch curs_user_triggers into rec_user_triggers;
        end loop;
    -- Cursor auf der Tabelle: USER_TRIGGERS wird geschlossen
        close curs_user_triggers;
        if v_anzahl = 0 then
            out_meldung := 'Es wurden keine Trigger gelöscht';
        else
            out_meldung := v_anzahl || ' Trigger(s) wurde(n) gelöscht';
        end if;

        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE  Alle Trigger löschen', 'ORA-DB', 'db_p_trace.c_trigger_loeschen_alle'
        ,
                                       null, null, in_login_id, null, null,
                                       out_meldung, 'IL');
  -- Fehlerbehandlung
    exception
        when others then
            if curs_user_triggers%isopen then
                close curs_user_triggers;
                out_meldung := 'Cursor wurde geschlossen.';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE  Alle Trigger löschen', 'ORA-DB', 'db_p_trace.c_trigger_loeschen_alle'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

                if sqlcode is not null then
                    out_meldung := 'Fehler '
                                   || sqlerrm(sqlcode)
                                   || '. '
                                   || out_meldung;
                    isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE  Alle Trigger löschen', 'ORA-DB', 'db_p_trace.c_trigger_loeschen_alle'
                    ,
                                                   null, null, in_login_id, null, null,
                                                   out_meldung, 'IL');

                end if;

            end if;
    end c_trigger_loeschen_alle;

  /*************************************************************************************************************************
  Prozedur löscht einen Trigger einer gegebenen Tabelle
  Parameter:
     in_tabellename = Tabelle deren Trigger gelöscht werden soll. Ist Tabellenname = NULL werden alle Trigger gelöscht
  Rückgabewert:
     out_meldung = Info- oder Fehlermeldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure c_trigger_loeschen (
        in_sid         in isi_firma.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_login_id    in isi_user.login_id%type,
        in_tabellename in varchar2,
        out_meldung    out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Autonome Transaktion
        pragma autonomous_transaction;

    -- Deklarationen
        v_trigger_name varchar2(255);
    -------------------------------------------------------------------------------------------------------
    begin
        if in_tabellename is not null
           or length(trim(in_tabellename)) > 0 then
            v_trigger_name := get_trigger_name(in_tabellename);
            if v_trigger_name is not null then
                execute immediate 'DROP TRIGGER ' || v_trigger_name;
                commit;
                out_meldung := 'Trigger '
                               || v_trigger_name
                               || ' gelöscht.';
            else
                out_meldung := 'Trigger '
                               || v_trigger_name
                               || ' existiert nicht.';
            end if;

        else
            out_meldung := 'Bitte Tabellenname eingeben.';
        end if;

        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE Trigger löschen', 'ORA-DB', 'db_p_trace.c_trigger_loeschen',
                                       null, null, in_login_id, null, null,
                                       out_meldung, 'IL');

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Vorgang abgebrochen.';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'TRACE Trigger löschen', 'ORA-DB', 'db_p_trace.c_trigger_loeschen'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

            end if;
    end c_trigger_loeschen;

  /*************************************************************************************************************************
  Prozedur erzeugt einen Trigger für eine angegebene Tabelle. Die Funktionalität des Triggers ist durch ein Template gegeben
  Jira-Ticket: P70540-134
  Parameter:
     p_tabellename = die Tabelle für die der Trigger erzeugt werden soll

  Rückgabewert:
     out_meldung = Info- oder Fehlermeldung wird zurück gegeben

     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     !!!!! Die Prozedur kann den Trigger nicht erzeugen da die Permissions fehlen !!!!!
     !!!!! Lössung: grant create trigger to yyyy;                                 !!!!!
     !!!!! Die Rolle DBA ist anscheinend nicht ausreichend                        !!!!!
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     !!!!! Achtung !!!!!                            !!!!! Achtung !!!!!
     Das Erzeugen des Triggers kann eventuell nicht funktionieren da die Spalten
     in der angegebenen Tabelle eventuell nicht vorkommen!!!
     !!!!! Achtung !!!!!                            !!!!! Achtung !!!!!
  **************************************************************************************************************************/
    procedure c_trigger_von_tmpl_erstellen (
        in_sid         in isi_firma.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_login_id    in isi_user.login_id%type,
        in_tabellename in varchar2,
        out_meldung    out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Autonome Transaktion
        pragma autonomous_transaction;

    -- Deklarationen
        v_text         varchar2(4096);
        v_trigger_name varchar(64);
        v_anzahl       integer;
        v_pk_liste     varchar(1024);
        v_pk_new       varchar(1024);
        v_pk_old       varchar(1024);
    -------------------------------------------------------------------------------------------------------
    begin
        out_meldung := '';
        v_trigger_name := 'db_' || lower(in_tabellename);
    -- Existiert der zu erzeugende Trigger?
        select
            count(*)
        into v_anzahl
        from
            user_triggers
        where
            trigger_name = upper(v_trigger_name);

        v_pk_liste := get_pk_schluessel(in_tabellename);
        v_pk_new := ersetze_zeichen(v_pk_liste, 'new');
        v_pk_old := ersetze_zeichen(v_pk_liste, 'old');
        v_text := '
          create or replace trigger '
                  || v_trigger_name
                  || '
            after insert or update or delete on '
                  || in_tabellename
                  || '
            for each row
          declare
            -- local variables here
            v_pk_values  db_trace.act_pk_values%type;
            v_command    db_trace.act_command%type;
            v_info       db_trace.act_info%type;
          begin
            -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
            if db_p_trace.get_trigger_aktiv('''
                  || in_tabellename
                  || ''') = 0
            then
              return;
            end if;

            v_pk_values := null;
            if inserting
            then
              v_pk_values := '
                  || v_pk_new
                  || ';
              v_command := ''INSERT'';
              -- v_info := ''vorgang_id='' || :new.vorgang_id || '';'';
              -- v_info := v_info || ''pos_nr='' || :new.pos_nr || '';'';
            elsif updating
            then
              v_pk_values := '
                  || v_pk_new
                  || ';
              v_command := ''UPDATE'';
              -- v_info := ''vorgang_id='' || :old.vorgang_id || '';'';
              -- v_info := v_info || ''pos_nr='' || :old.pos_nr || '';'';
            elsif deleting
            then
              v_pk_values := '
                  || v_pk_old
                  || ';
              v_command := ''DELETE'';
              -- v_info := ''vorgang_id='' || :old.vorgang_id || '';'';
            end if;

            -- Autonome Transaktion
            db_p_trace.c_db_act_log('''
                  || in_tabellename
                  || ''','''
                  || v_pk_liste
                  || ''',v_pk_values,v_command,v_info);

            exception
              -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
              when others then
                null;

          end '
                  || v_trigger_name
                  || ';
     ';

        if v_anzahl = 0 then
      -- für die Codeformattierung des Triggers
            v_text := replace(v_text, '          ', '');
            v_text := replace(v_text,
                              ',',
                              ','
                              || chr(13)
                              || chr(10)
                              || '                        ');
      -- Trigger erzeugen wenn dieser nicht existiert
            execute immediate v_text;
            out_meldung := 'Trigger '
                           || v_trigger_name
                           || ' erfolgreich angelegt';
        else
            out_meldung := 'Trigger '
                           || v_trigger_name
                           || ' existiert bereits';
        end if;

        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'Trigger von Tempalte erstellen', 'ORA-DB', 'db_p_trace.c_trigger_von_tmpl_erstellen'
        ,
                                       null, null, in_login_id, null, null,
                                       out_meldung, 'IL');

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Vorgang abgebrochen.';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'Trigger von Tempalte erstellen', 'ORA-DB', 'db_p_trace.c_trigger_von_tmpl_erstellen'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

            end if;
    end c_trigger_von_tmpl_erstellen;

  /*************************************************************************************************************************
  Prozedur geht die Tabelle: "db_trace_cfg" durch, ließt den Namen aller Tabellen
  gibt diese der Prozedur "c_trigger_vom_tmpl_erstellen" und ruft auch diese.
  Parameter: -

  Rückgabewert:
     out_meldung : Info- oder Fehlermeldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure c_trigger_von_tmpl_alle_tbl (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        out_meldung out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_anzahl         integer;
    -- Cursor auf der Tabelle: db_trace_cfg  setzen
        cursor curs_db_trace_cfg is
        select
            tabellenname
        from
            db_trace_cfg;

        rec_db_trace_cfg curs_db_trace_cfg%rowtype;
    ---------------------------------------------------------------------
    begin
        v_anzahl := 0;
        open curs_db_trace_cfg;
        fetch curs_db_trace_cfg into rec_db_trace_cfg;
        while curs_db_trace_cfg%found loop
            c_trigger_von_tmpl_erstellen(in_sid, in_firma_nr, in_login_id, rec_db_trace_cfg.tabellenname, out_meldung);
            v_anzahl := v_anzahl + 1;
            fetch curs_db_trace_cfg into rec_db_trace_cfg;
        end loop;
    -- Cursor auf der Tabelle: db_trace_cfg wird geschlossen
        close curs_db_trace_cfg;
        if v_anzahl = 0 then
            out_meldung := 'Tabelle: db_trace_cfg ist leer.';
        else
            out_meldung := v_anzahl || ' Trigger wurden erfolgreich erstellt.';
        end if;

        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'Alle Trigger von Tempalte erstellen', 'ORA-DB', 'db_p_trace.c_trigger_von_tmpl_alle_tbl'
        ,
                                       null, null, in_login_id, null, null,
                                       out_meldung, 'IL');

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Vorgang abgebrochen.';
                close curs_db_trace_cfg;
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'Alle Trigger von Tempalte erstellen', 'ORA-DB', 'db_p_trace.c_trigger_von_tmpl_alle_tbl'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

            end if;
    end c_trigger_von_tmpl_alle_tbl;

  /*************************************************************************************************************************
  Prozedur loggt Aktivitäten in Tabellen und speichert die Umgebungsinformationen [05.04.2008 (-WK-)]
  Parameter:
     in_act_table
     in_act_pk_cols
     in_act_pk_values
     in_act_command
     in_act_info

  Rückgabewert:
     out_meldung : Info- oder Fehlermeldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure db_act_log_out_meld (
        in_act_table     in db_trace.act_table%type,
        in_act_pk_cols   in db_trace.act_pk_cols%type,
        in_act_pk_values in db_trace.act_pk_values%type,
        in_act_command   in db_trace.act_command%type,
        in_act_info      in db_trace.act_info%type,
        out_meldung      out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_act_log_id         db_trace.db_act_log_id%type;
        v_found_act_log_id   db_trace.db_act_log_id%type;
        v_bg_job_id          db_trace.bg_job_id%type;
        v_audsid             db_trace.audsid%type;
        v_client_info        db_trace.client_info%type;
        v_client_ident       db_trace.client_identifier%type;
        v_client_host        db_trace.client_host%type;
        v_client_module_info db_trace.client_module_info%type;
        v_client_action_info db_trace.client_action_info%type;
        v_client_os_user     db_trace.client_os_user%type;
        v_client_programm    db_trace.program%type;
        v_terminal           db_trace.terminal%type;
        v_isiusr             db_trace.isiusr%type;
        cursor c_db_act_log is
        select
            t.db_act_log_id
        from
            db_trace t
        where
            t.db_act_log_id = v_act_log_id;

        v_found              boolean;
    -------------------------------------------------------------------------------------------------------
    begin
    -- BG_JOB_ID: Job ID of the current session if it was established by an Oracle Database background
    -- process. Null if the session was not established by a background process.
        v_bg_job_id := sys_context('USERENV', 'BG_JOB_ID');

    -- SESSIONID: The auditing session identifier.
        v_audsid := sys_context('USERENV', 'SESSIONID');

    -- CLIENT_INFO: Returns up to 64 bytes of user session information that can be stored by an application
    -- using the DBMS_APPLICATION_INFO package.
        v_client_info := sys_context('USERENV', 'CLIENT_INFO');

    -- CLIENT_IDENTIFIER: Returns an identifier that is set by the application through the DBMS_SESSION.SET_IDENTIFIER
    -- procedure, the OCI attribute OCI_ATTR_CLIENT_IDENTIFIER, or the Java class
    -- Oracle.jdbc.OracleConnection.setClientIdentifier. This attribute is used by various database
    -- components to identify lightweight application users who authenticate as the same database user.
        v_client_ident := sys_context('USERENV', 'CLIENT_IDENTIFIER');

    -- HOST: Name of the host machine from which the client has connected.
        v_client_host := sys_context('USERENV', 'HOST');

    -- MODULE: The application name (module) set through the DBMS_APPLICATION_INFO package or OCI.
        v_client_module_info := sys_context('USERENV', 'MODULE');

    -- ACTION: Identifies the position in the module (application name) and is set through the
    -- DBMS_APPLICATION_INFO package or OCI.
        v_client_action_info := sys_context('USERENV', 'ACTION');

    -- OS_USER: Operating system user name of the client process that initiated the database session.
        v_client_os_user := sys_context('USERENV', 'OS_USER');

    -- TERMINAL: The operating system identifier for the client of the current session.
        v_terminal := sys_context('USERENV', 'TERMINAL');
        v_isiusr := isi_utils.get_csv_value(v_client_ident, 'isiusr');

    -- PROGRAM: Name of program
    -- >>> INFO <<<
    -- Folgende ORA-Rechte sind notwendig
    -- => Als SYS folgende Befehle ausführen:
    -- grant create trigger to SchemaName;        -- Trigger vom Template erstellen
    -- grant select on v_$session to SchemaName;  -- zum Auslesen weitere Informationen beim Loggen
        select
            program
        into v_client_programm
        from
            v$session
        where
            audsid = (
                select
                    userenv('SESSIONID')
                from
                    dual
            );

        select
            seq_db_act_log_id.nextval
        into v_act_log_id
        from
            dual;

        open c_db_act_log;
        fetch c_db_act_log into v_found_act_log_id;
        v_found := c_db_act_log%found;
        close c_db_act_log;
        if v_found then
      -- falls wir in die Runde loggen
            delete db_trace t
            where
                t.db_act_log_id = v_found_act_log_id;

        end if;
        insert into db_trace t (
            db_act_log_id,
            log_date,
            audsid,
            bg_job_id,
            client_os_user,
            client_host,
            terminal,
            program,
            client_module_info,
            client_action_info,
            client_info,
            client_identifier,
            isiusr,
            act_table,
            act_pk_cols,
            act_pk_values,
            act_command,
            act_info,
            transactionid
        ) values ( v_act_log_id,
                   sysdate,
                   v_audsid,
                   v_bg_job_id,
                   v_client_os_user,
                   v_client_host,
                   v_terminal,
                   v_client_programm,
                   v_client_module_info,
                   v_client_action_info,
                   v_client_info,
                   v_client_ident,
                   v_isiusr,
                   in_act_table,
                   in_act_pk_cols,
                   in_act_pk_values,
                   in_act_command,
                   in_act_info,
                   dbms_transaction.local_transaction_id );

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Vorgang abgebrochen.';
            end if;
    end db_act_log_out_meld;

  /*************************************************************************************************************************
  Prozedur ruft die "db_act_log_out_meld" auf
  Parameter:
     in_act_table
     in_act_pk_cols
     in_act_pk_values
     in_act_command
     in_act_info
  Rückgabewert:
     -
  **************************************************************************************************************************/
    procedure db_act_log (
        in_act_table     in db_trace.act_table%type,
        in_act_pk_cols   in db_trace.act_pk_cols%type,
        in_act_pk_values in db_trace.act_pk_values%type,
        in_act_command   in db_trace.act_command%type,
        in_act_info      in db_trace.act_info%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
        v_meldung varchar2(4048);
    -------------------------------------------------------------------------------------------------------
    begin
        db_act_log_out_meld(in_act_table, in_act_pk_cols, in_act_pk_values, in_act_command, in_act_info,
                            v_meldung);
    end db_act_log;

  /*************************************************************************************************************************
  Prozedur ruft "db_act_log_out_meld" auf welche eine Meldung zurück gibt
  Parameter:
     in_act_table
     in_act_pk_cols
     in_act_pk_values
     in_act_command
     in_act_info
  Rückgabewert:
     out_meldung : Fehlermeldung
  **************************************************************************************************************************/
    procedure c_db_act_log_out_meld (
        in_act_table     in db_trace.act_table%type,
        in_act_pk_cols   in db_trace.act_pk_cols%type,
        in_act_pk_values in db_trace.act_pk_values%type,
        in_act_command   in db_trace.act_command%type,
        in_act_info      in db_trace.act_info%type,
        out_meldung      out varchar2
    ) is

    -- Autonome Transaktion
        pragma autonomous_transaction;
    begin
        db_act_log_out_meld(in_act_table, in_act_pk_cols, in_act_pk_values, in_act_command, in_act_info,
                            out_meldung);
        commit;

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Vorgang abgebrochen.';
            end if;
    end c_db_act_log_out_meld;

  /*************************************************************************************************************************
  Prozedur ruft "db_act_log_out_meld" auf
  Parameter:
     in_act_table
     in_act_pk_cols
     in_act_pk_values
     in_act_command
     in_act_info
  Rückgabewert:
     -
  **************************************************************************************************************************/
    procedure c_db_act_log (
        in_act_table     in db_trace.act_table%type,
        in_act_pk_cols   in db_trace.act_pk_cols%type,
        in_act_pk_values in db_trace.act_pk_values%type,
        in_act_command   in db_trace.act_command%type,
        in_act_info      in db_trace.act_info%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Autonome Transaktion
        pragma autonomous_transaction;

    -- Deklarationen
        v_meldung varchar2(4048);
    -------------------------------------------------------------------------------------------------------
    begin
        db_act_log_out_meld(in_act_table, in_act_pk_cols, in_act_pk_values, in_act_command, in_act_info,
                            v_meldung);
        commit;
    end c_db_act_log;

  /*************************************************************************************************************************
  Prozedur erstellt einen Job der die Prozedur "c_tabelle_act_log_verkleinern" aufruft.
  Jira-Ticket: P70540-136
  Parameter:
       in_startzeit = Angabe der Startzeit. Format "hh24:mm"
  Rückgabewert
       out_meldung = Info- oder Fehlermeldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure c_job_erstellen (
        in_sid       in isi_firma.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_login_id  in isi_user.login_id%type,
        in_startzeit in varchar2,
        out_meldung  out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Autonome Transaktion
        pragma autonomous_transaction;

    -- Deklarationen
        v_job        integer;
        v_startzeit  varchar2(8);
        v_startdatum varchar2(18);
        v_datum      date;
        v_what       varchar(512);
    -------------------------------------------------------------------------------------------------------
    begin
        v_job := get_job_nr();
        if v_job is null then
            if in_startzeit is null
               or length(trim(in_startzeit)) = 0
            or length(trim(in_startzeit)) <> 5 then
                out_meldung := 'Falsche Zeitangabe. Zeit wird auf 23:59 gesetzt';
                v_startzeit := '23:59:59';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'DB Job erstellen zum verkleinern', 'ORA-DB', 'db_p_trace.c_job_erstellen'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'IL');

            else
                v_startzeit := in_startzeit || ':00';
            end if;

      -- Job existiert nicht
            v_startdatum := sysdate
                            || ' '
                            || v_startzeit;
            v_datum := to_date ( v_startdatum,
            'dd.mm.yy hh24:mi:ss' );
            v_what := 'begin
                         -- Prozedur: c_tabelle_db_trace_verklein_in wird aufgerufen
                         db_p_trace.c_tabelle_db_trace_verklein_in(in_sid => '''
                      || in_sid
                      || ''',
                                            in_firma_nr => '
                      || in_firma_nr
                      || ',
                                            in_login_id => -1,
                                            in_ab_tage => null);
                       end;';
      -- Codestyle bei der Joberstellung entsprechend aussehen zu lassen
            v_what := replace(v_what, '                       ', '');
      -- Job wird erstellt
            sys.dbms_job.submit(v_job,
                                what      => v_what,
                                next_date => v_datum,
                                interval  => 'sysdate + 1'); -- Ausführung jeden Tag
            commit;
            out_meldung := 'Job mit der Nr.: '
                           || v_job
                           || ' wurde erstellt.';
        else
            out_meldung := 'Job mit der Nr.: '
                           || v_job
                           || ' existiert bereits.';
        end if;

        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'DB Job erstellen zum verkleinern', 'ORA-DB', 'db_p_trace.c_job_erstellen'
        ,
                                       null, null, in_login_id, null, null,
                                       out_meldung, 'IL');

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Vorgang abgebrochen.';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'DB Job erstellen zum verkleinern', 'ORA-DB', 'db_p_trace.c_job_erstellen'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

            end if;
    end c_job_erstellen;

  /*************************************************************************************************************************
  Prozedur löscht den Job der die Prozedur "c_tabelle_act_log_verkleinern" aufruft.
  Jira-Ticket: P70540-137
  Parameter: keine
  Rückgabewert:
    out_meldung : Eine Meldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure c_job_loeschen (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        out_meldung out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Autonome Transaktion
        pragma autonomous_transaction;

    -- Deklarationen
        v_job integer;
    -------------------------------------------------------------------------------------------------------
    begin
    -- Job wird ermittelt
        v_job := get_job_nr();
        if v_job is null then
      -- Job existiert nicht
            out_meldung := 'Job '
                           || v_job
                           || ' existiert nicht.';
        else
      --user_jobs.drop_job(v_job);
            dbms_job.remove(v_job);
            commit;
            out_meldung := 'Job '
                           || v_job
                           || ' wurde erfolgreich gelöscht.';
        end if;

        isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'DB Job löschen zum verkleinern', 'ORA-DB', 'db_p_trace.c_job_loeschen',
                                       null, null, in_login_id, null, null,
                                       out_meldung, 'IL');

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Vorgang abgebrochen.';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'DB Job löschen zum verkleinern', 'ORA-DB', 'db_p_trace.c_job_loeschen'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

            end if;
    end c_job_loeschen;

  /*************************************************************************************************************************
  Prozedur Monitoring wird deaktiviert
  Parameter:
     keine
  Rückgabewert:
    out_meldung : Meldung wird zurück gegeben
  **************************************************************************************************************************/
    procedure c_db_trace_deaktivieren (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        out_meldung out varchar2
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Deklarationen
    -------------------------------------------------------------------------------------------------------
    begin
        c_trigger_deaktivieren(in_sid, in_firma_nr, in_login_id, null, out_meldung);
        c_tabelle_db_trace_verkleinern(in_sid, in_firma_nr, in_login_id, 0, out_meldung);
        c_job_loeschen(in_sid, in_firma_nr, in_login_id, out_meldung);

  -- Fehlerbehandlung
    exception
        when others then
            if sqlcode is not null then
                out_meldung := 'Fehler '
                               || sqlerrm(sqlcode)
                               || '. Vorgang abgebrochen.';
                isi_p_log.c_isi_system_meldung(in_sid, in_firma_nr, 'DB Job löschen zum verkleinern', 'ORA-DB', 'db_p_trace.c_job_loeschen'
                ,
                                               null, null, in_login_id, null, null,
                                               out_meldung, 'EL');

            end if;
    end c_db_trace_deaktivieren;

end db_p_trace;
/


-- sqlcl_snapshot {"hash":"49a86c3e0496af44099ec8f1fd8e7820d58b86e1","type":"PACKAGE_BODY","name":"DB_P_TRACE","schemaName":"DIRKSPZM32","sxml":""}