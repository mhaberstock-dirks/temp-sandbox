create or replace 
PACKAGE BODY DIRKSPZM32.sqlcl_lb_capture AS

    FUNCTION getboolean (
        val IN VARCHAR2
    ) RETURN BOOLEAN IS
    BEGIN
        IF ( lower(val) = 'on' ) THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END;

    PROCEDURE set_parm (
        p_handle IN NUMBER,
        p_parm IN VARCHAR2,
        p_state IN VARCHAR2
    ) IS
    BEGIN
        IF ( p_state = 'on' ) THEN
            dbms_metadata.set_transform_param(p_handle, p_parm, TRUE);
        ELSE
            dbms_metadata.set_transform_param(p_handle, p_parm, FALSE);
        END IF;
    END;

    FUNCTION getsequence RETURN NUMBER IS
        seq NUMBER;
    BEGIN
        SELECT
            nvl(
                max(object_sequence),
                1
            ) + 100
        INTO seq
        FROM
            databasechangelog_export;

        RETURN seq;
    END;

    FUNCTION sxmltoddl11 (
        sxml IN CLOB,
        otype IN VARCHAR2
    ) RETURN CLOB AS
        l_obj sys.xmltype;
        l_trn NUMBER;
        l_ddl CLOB;
        l_hdl NUMBER;
        th1 NUMBER;
    BEGIN
        l_obj := sys.xmltype.createxml(sxml);
        dbms_lob.createtemporary(l_ddl, TRUE);
        l_hdl := dbms_metadata.openw(otype);
        l_trn := dbms_metadata.add_transform(l_hdl, 'SXMLDDL');
        dbms_metadata.set_transform_param(l_trn, 'SQLTERMINATOR', TRUE);
        dbms_metadata.convert(l_hdl, l_obj, l_ddl);
        dbms_metadata.close(l_hdl);
        RETURN l_ddl;
    END;

    FUNCTION get_deps (
        oname IN VARCHAR2,
        otype IN VARCHAR2
    ) RETURN VARCHAR2 AS
        deps VARCHAR2(32767);
        cnt NUMBER;
        l_type VARCHAR2(2000);
    BEGIN
        cnt := 0;
        IF otype = 'TABLE' THEN
            RETURN NULL;
        ELSE
            IF otype = 'TYPE_SPEC' THEN
                l_type := 'TYPE';
            ELSIF otype = 'TYPE_BODY' THEN
                l_type := 'TYPE BODY';
            ELSIF otype = 'PACKAGE_SPEC' THEN
                l_type := 'PACKAGE';
            ELSIF otype = 'PACKAGE_BODY' THEN
                l_type := 'PACKAGE BODY';
            END IF;

            FOR r_dep IN (
                SELECT
                    referenced_name
                FROM
                    user_dependencies
                WHERE
                        type = l_type
                    AND name = oname
                    AND referenced_owner = user
            ) LOOP
                IF r_dep.referenced_name != oname THEN
                    IF cnt = 0 THEN
                        deps := r_dep.referenced_name;
                        cnt  := 1;
                    ELSE
                        deps := r_dep.referenced_name
                                || ','
                                || deps;
                    END IF;

                END IF;
            END LOOP;

        END IF;

        RETURN deps;
    END;

    FUNCTION get_grants (
        p_rank IN NUMBER,
        p_otype VARCHAR2
    ) RETURN VARCHAR2 IS
        --METADATA HOLDERS
        l_handle NUMBER; -- handle returned by OPEN
        l_transform_handle NUMBER; -- handle returned by ADD_TRANSFORM
        l_map_handle NUMBER; -- handle for the schema mapping
        l_tableddls sys.ku$_ddls;
        l_tableddl sys.ku$_ddl;
        l_obj_type VARCHAR2(20000);
        l_count NUMBER := 0;
    BEGIN
        l_obj_type         := trim(upper(p_otype));
        l_handle           := dbms_metadata.open(upper(l_obj_type));
        IF ( l_obj_type NOT IN ( 'SYSTEM_GRANT', 'ROLE_GRANT' ) ) THEN
            dbms_metadata.set_filter(l_handle, 'GRANTOR', user);
        ELSE
            dbms_metadata.set_filter(l_handle, 'GRANTEE', user);
        END IF;

        l_map_handle       := dbms_metadata.add_transform(l_handle, 'MODIFY');
        dbms_metadata.set_remap_param(l_map_handle, 'REMAP_SCHEMA', user, '%USER_NAME%');
        l_transform_handle := dbms_metadata.add_transform(l_handle, 'DDL');
        dbms_metadata.set_transform_param(l_transform_handle, 'PRETTY', TRUE);
        dbms_metadata.set_transform_param(l_transform_handle, 'SQLTERMINATOR', TRUE);
        LOOP
            l_count     := l_count + 1;
            l_tableddls := dbms_metadata.fetch_ddl(l_handle);
            EXIT WHEN l_tableddls IS NULL
                      OR l_tableddls(1) IS NULL;
            BEGIN
                l_tableddl := l_tableddls(1);
            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK;
                    EXIT;
            END;

            INSERT INTO databasechangelog_export (
                object_rank,
                object_sequence,
                object_name,
                object_type,
                object_doc,
                object_deps,
                file_name
            ) VALUES ( p_rank,
                       getsequence(),
                       l_count,
                       l_obj_type,
                       l_tableddl.ddltext,
                       NULL,
                       l_count || '.xml' );

            IF ( l_count = 500 ) THEN
                COMMIT;
            END IF;
        END LOOP;

        dbms_metadata.close(l_handle);
        COMMIT;
        RETURN NULL;
    END;

    FUNCTION capture_object_type (
        p_rank IN NUMBER,
        p_otype VARCHAR2,
        p_body VARCHAR2 DEFAULT 'on',
        p_constraints VARCHAR2 DEFAULT 'on',
        p_constraints_as_alter VARCHAR2 DEFAULT 'on',
        p_force VARCHAR2 DEFAULT 'on',
        p_inherit VARCHAR2 DEFAULT 'on',
        p_inserts VARCHAR2 DEFAULT 'on',
        p_partitioning VARCHAR2 DEFAULT 'on',
        p_pretty VARCHAR2 DEFAULT 'on',
        p_ref_constraints VARCHAR2 DEFAULT 'on',
        p_segments VARCHAR2 DEFAULT 'on',
        p_size_byte_keyword VARCHAR2 DEFAULT 'on',
        p_specification VARCHAR2 DEFAULT 'on',
        p_sqlterminator VARCHAR2 DEFAULT 'on',
        p_storage VARCHAR2 DEFAULT 'on',
        p_tablespace VARCHAR2 DEFAULT 'on',
        p_lb_table_name VARCHAR2 DEFAULT 'DATABASECHANGELOG',
        p_filter VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 IS
    --METADATA HOLDERS
        l_handle NUMBER; -- handle returned by OPEN
        l_transform_handle NUMBER; -- handle returned by ADD_TRANSFORM
        l_map_handle NUMBER; -- handle for the schema mapping
        l_oname VARCHAR2(32767);
        l_clob_doc CLOB;
        l_parsed sys.ku$_parsed_items;
        l_path VARCHAR2(32767);
        l_tableddls sys.ku$_ddls;
        l_tableddl sys.ku$_ddl;
        l_mv_rows NUMBER;
        l_deps VARCHAR2(32767);
        l_obj_type VARCHAR2(20000);
        l_action VARCHAR2(20);
        l_count NUMBER := 0;
        l_seq NUMBER;
        l_ddl CLOB;
        l_err_num NUMBER;
        l_err_msg VARCHAR2(100);
        cur1 SYS_REFCURSOR;
        query_string VARCHAR2(2000);
        l_obj_count NUMBER;
        TYPE myrec IS RECORD (
            synonym_name VARCHAR(128)
        );
        myrecord myrec;
    BEGIN
        l_obj_type := trim(upper(p_otype));
        -- SHORT CIRCUITS

        IF ( l_obj_type IN ( 'SYSTEM_GRANT', 'ROLE_GRANT', 'OBJECT_GRANT' ) ) THEN
            RETURN get_grants(p_rank, p_otype);
        END IF;

        IF ( l_obj_type = 'MATERIALIZED_VIEW' ) THEN
            SELECT
                COUNT(*)
            INTO l_mv_rows
            FROM
                user_objects
            WHERE
                object_type = 'MATERIALIZED VIEW';

            IF ( l_mv_rows = 0 ) THEN
                RETURN NULL;
            END IF;
        ELSIF ( l_obj_type = 'PUBLIC_SYNONYM' ) THEN
            query_string := ' SELECT
                    synonym_name
                FROM
                    all_synonyms
                WHERE
                        owner = ''PUBLIC''
                    AND table_owner = user ';
            IF ( length(p_filter) > 0 ) THEN
                query_string := ' SELECT
                    synonym_name
                FROM
                    all_synonyms
                WHERE
                        owner = ''PUBLIC''
                    AND table_owner = user  and table_name ' || p_filter;
            END IF;

            OPEN cur1 FOR query_string;

            LOOP
                FETCH cur1 INTO myrecord;
                EXIT WHEN cur1%notfound;
                l_count := l_count + 1;
                l_deps  := get_deps(
                    upper(l_oname),
                    upper(l_obj_type)
                );
                INSERT INTO databasechangelog_export (
                    object_rank,
                    object_sequence,
                    object_name,
                    object_deps,
                    object_type,
                    object_doc,
                    file_name
                ) VALUES ( 1000,
                           getsequence(),
                           myrecord.synonym_name,
                           l_deps,
                           'SYNONYM',
                           dbms_metadata.get_ddl('SYNONYM', myrecord.synonym_name, 'PUBLIC'),
                           myrecord.synonym_name || '_public_synonym.xml' );

                IF l_count = 500 THEN
                    COMMIT;
                END IF;
            END LOOP;

            COMMIT;
            RETURN NULL;
        END IF;

         -- GET HANDLE
        IF ( l_obj_type IN ( 'JOB' ) ) THEN
            l_handle := dbms_metadata.open(upper('PROCOBJ'));
            dbms_metadata.set_filter(l_handle, 'SCHEMA', user);
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT IN (select credential_name from user_credentials)');
        ELSIF ( l_obj_type IN ( 'DIRECTORY' ) ) THEN
            l_handle := dbms_metadata.open(upper(l_obj_type));
        ELSE
            l_handle := dbms_metadata.open(upper(l_obj_type));
            dbms_metadata.set_filter(l_handle, 'SCHEMA', user);
        END IF;

        dbms_metadata.set_parse_item(l_handle, 'NAME');

         -- FILTERS- FILTERS
        IF ( l_obj_type = 'INDEX' ) THEN
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT in (select constraint_name from user_constraints where constraint_type=''P'')');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''I_SNAP%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''C_SNAP%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''I_MLOG%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''SYS_%$$''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''SYS_FDA%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''SYS_FBA%''');
            dbms_metadata.set_filter(l_handle, 'SYSTEM_GENERATED', FALSE);
        ELSIF ( l_obj_type = 'TABLE'
        OR l_obj_type = 'VIEW'
        OR l_obj_type = 'TRIGGER' ) THEN
            IF (
                p_lb_table_name IS NOT NULL
                AND p_lb_table_name != ''
            ) THEN
                dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE '''
                                                                || p_lb_table_name
                                                                || '%''');
            ELSE
                dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''DATABASECHANGELOG%''');
            END IF;

            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'not in (select mview_name from user_mviews)');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''MLOG$_%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''SYS_FBA%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT IN (''EXP_LOAD'',''EXP_SORT'',''EXP_PROCESS'',''EXP_CLEANUP'')');
        ELSIF ( l_obj_type IN ( 'PACKAGE_SPEC', 'PACKAGE_BODY' ) ) THEN
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', '!=''SQLCL_LB_CAPTURE''');
        END IF;

        IF ( length(p_filter) > 0 ) THEN
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', p_filter);
        END IF;
        -- GLOBAL FILTERS
        dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''DR$%''');
        dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''AQ$_%''');
        --TRANSFORMS
        IF ( l_obj_type IN ( 'REF_CONSTRAINT', 'DIMENSION', 'FUNCTION', 'PROCEDURE', 'PACKAGE_SPEC',
                             'PACKAGE_BODY', 'TYPE_SPEC', 'TYPE_BODY', 'PUBLIC_SYNONYM', 'SYNONYM',
                             'DB_LINK', 'TRIGGER', 'JOB', 'DIRECTORY' ) ) THEN
            l_action           := 'DDL';
            IF l_obj_type NOT IN ( 'DIRECTORY', 'JOB' ) THEN
                l_map_handle := dbms_metadata.add_transform(l_handle, 'MODIFY');
                dbms_metadata.set_remap_param(l_map_handle, 'REMAP_SCHEMA', user, '%USER_NAME%');
            END IF;

            l_transform_handle := dbms_metadata.add_transform(l_handle, 'DDL');
            dbms_metadata.set_transform_param(l_transform_handle,
                                              'PRETTY',
                                              getboolean(p_pretty));
            dbms_metadata.set_transform_param(l_transform_handle,
                                              'SQLTERMINATOR',
                                              getboolean(p_sqlterminator));
        ELSE
            l_action           := 'SXML';
            sys.dbms_lob.createtemporary(l_clob_doc,
                                         FALSE,
                                         sys.dbms_lob.session);
            l_map_handle       := dbms_metadata.add_transform(l_handle, 'MODIFY');
            dbms_metadata.set_remap_param(l_map_handle, 'REMAP_SCHEMA', user, '%USER_NAME%');
            l_transform_handle := dbms_metadata.add_transform(l_handle, 'SXML');
            IF l_obj_type = 'CLUSTER' THEN
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'STORAGE',
                                                  getboolean(p_storage));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'TABLESPACE',
                                                  getboolean(p_tablespace));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'SEGMENT_ATTRIBUTES',
                                                  getboolean(p_segments));
            ELSIF l_obj_type = 'INDEX' THEN
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'STORAGE',
                                                  getboolean(p_storage));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'TABLESPACE',
                                                  getboolean(p_tablespace));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'SEGMENT_ATTRIBUTES',
                                                  getboolean(p_segments));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'PARTITIONING',
                                                  getboolean(p_partitioning));
            ELSIF l_obj_type = 'MATERIALIZED_VIEW' THEN
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'STORAGE',
                                                  getboolean(p_storage));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'TABLESPACE',
                                                  getboolean(p_tablespace));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'SEGMENT_ATTRIBUTES',
                                                  getboolean(p_segments));
            ELSIF l_obj_type = 'MATERIALIZED_VIEW_LOG' THEN
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'STORAGE',
                                                  getboolean(p_storage));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'TABLESPACE',
                                                  getboolean(p_tablespace));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'SEGMENT_ATTRIBUTES',
                                                  getboolean(p_segments));
            ELSIF l_obj_type = 'TABLE' THEN
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'STORAGE',
                                                  getboolean(p_storage));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'TABLESPACE',
                                                  getboolean(p_tablespace));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'SEGMENT_ATTRIBUTES',
                                                  getboolean(p_segments));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'CONSTRAINTS',
                                                  getboolean(p_constraints));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'PARTITIONING',
                                                  getboolean(p_partitioning));
                dbms_metadata.set_transform_param(l_transform_handle, 'REF_CONSTRAINTS', FALSE);
            END IF;

        END IF;
  -- supported by all objects
        IF ( l_action = 'SXML' ) THEN
            LOOP
                l_count := l_count + 1;
                dbms_metadata.fetch_xml_clob(l_handle, l_clob_doc, l_parsed, l_path);
                EXIT WHEN l_clob_doc IS NULL;
                BEGIN
                    l_oname := l_parsed(1).value;
                EXCEPTION
                    WHEN OTHERS THEN
                        l_oname := NULL;
                END;

                l_deps  := get_deps(
                    upper(l_oname),
                    upper(l_obj_type)
                );
                IF ( length(l_deps) > 2000 ) THEN
                    l_deps := substr(l_deps,
                                     instr(l_deps, ',', -1),
                                     1);
                END IF;

                l_seq   := getsequence();
                INSERT INTO databasechangelog_export (
                    object_rank,
                    object_sequence,
                    object_name,
                    object_type,
                    object_doc,
                    object_deps,
                    file_name
                ) VALUES ( p_rank,
                           l_seq,
                           l_oname,
                           l_obj_type,
                           l_clob_doc,
                           l_deps,
                           lower(l_oname
                                 || '_'
                                 || l_obj_type
                                 || '.xml') );

                IF l_obj_type = 'TABLE'
                OR l_obj_type = 'VIEW' THEN
                    BEGIN
                        dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'EMIT_SCHEMA', FALSE);
                        dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'SQLTERMINATOR', TRUE);
                        dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'PRETTY', TRUE);
                        SELECT
                            dbms_metadata.get_dependent_ddl('COMMENT', l_oname, user)
                        INTO l_ddl
                        FROM
                            dual;

                    EXCEPTION
                        WHEN OTHERS THEN
                            l_ddl := NULL;
                    END;

                    IF ( l_ddl IS NOT NULL ) THEN
                        INSERT INTO databasechangelog_export (
                            object_rank,
                            object_sequence,
                            object_name,
                            object_type,
                            object_doc,
                            file_name
                        ) VALUES ( 65,
                                   getsequence(),
                                   l_oname,
                                   'COMMENT',
                                   l_ddl,
                                   lower(l_oname || '_COMMENTS.xml') );

                    END IF;

                END IF;

                IF l_count = 100 THEN
                    COMMIT;
                    l_count := 0;
                END IF;
            END LOOP;
            COMMIT;
            dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'DEFAULT', TRUE);
        ELSIF ( l_action = 'DDL' ) THEN
            LOOP
                l_count     := l_count + 1;
                l_tableddls := dbms_metadata.fetch_ddl(l_handle);
                EXIT WHEN l_tableddls IS NULL
                          OR l_tableddls(1) IS NULL;
                BEGIN
                    l_tableddl := l_tableddls(1);
                    l_oname    := l_tableddl.parseditems(1).value;
                EXCEPTION
                    WHEN OTHERS THEN
                        ROLLBACK;
                        EXIT;
                END;

                l_deps      := get_deps(
                    upper(l_oname),
                    upper(l_obj_type)
                );
                IF ( length(l_deps) > 2000 ) THEN
                    l_deps := substr(l_deps,
                                     instr(l_deps, ',', -1),
                                     1);
                END IF;

                INSERT INTO databasechangelog_export (
                    object_rank,
                    object_sequence,
                    object_name,
                    object_type,
                    object_doc,
                    object_deps,
                    file_name
                ) VALUES ( p_rank,
                           getsequence(),
                           l_oname,
                           l_obj_type,
                           l_tableddl.ddltext,
                           l_deps,
                           lower(l_oname
                                 || '_'
                                 || l_obj_type
                                 || '.xml') );

                IF l_count = 100 THEN
                    COMMIT;
                    l_count := 0;
                END IF;
            END LOOP;
            commit;
        END IF;

        dbms_metadata.close(l_handle);
        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            l_err_num := sqlcode;
            l_err_msg := substr(sqlerrm, 1, 100);
            ROLLBACK;
            RETURN l_err_msg
                   || '\n '
                   || l_action;
    END;

    PROCEDURE sortcapturedobjects IS
        l_seq NUMBER;
    BEGIN
        -- set all objects wihtout deps to 0 sequence
        UPDATE databasechangelog_export
        SET
            object_sequence = 0
        WHERE
            object_deps IS NULL;

        COMMIT;
        --set all objects that only depend on zeros to 100
        UPDATE databasechangelog_export
        SET
            object_sequence = 100
        WHERE
                object_rank = object_rank
            AND object_deps IN (
                SELECT
                    object_name
                FROM
                    databasechangelog_export
                WHERE
                    object_sequence = 0
            );

        COMMIT;
-- sort the rest
        FOR r1 IN (
            SELECT
                *
            FROM
                databasechangelog_export
            WHERE
                object_sequence > 100
        ) LOOP
            SELECT
                MAX(dep_seq)
            INTO l_seq
            FROM
                (
                    WITH deps AS (
                        SELECT
                            t.object_rank,
                            t.object_sequence,
                            t.object_name,
                            TRIM(regexp_substr(t.object_deps, '[^,]+', 1, lines.column_value)) object_deps
                        FROM
                            databasechangelog_export t,
                            TABLE ( CAST(MULTISET(
                                SELECT
                                    level
                                FROM
                                    dual
                                CONNECT BY
                                    instr(t.object_deps, ',', 1, level - 1) > 0
                            ) AS sys.odcinumberlist) ) lines
                        ORDER BY
                            t.object_rank,
                            t.object_sequence,
                            t.object_name,
                            lines.column_value
                    )
                    SELECT
                        d.object_rank rank,
                        d.object_sequence seq,
                        d.object_name name,
                        l.object_sequence dep_seq,
                        d.object_deps dep_name
                    FROM
                        deps d,
                        databasechangelog_export l
                    WHERE
                            l.object_rank = d.object_rank
                        AND d.object_deps = l.object_name
                ) data
            WHERE
                    name = r1.object_name
                AND rank = r1.object_rank;

            UPDATE databasechangelog_export
            SET
                object_sequence = l_seq + 5
            WHERE
                    object_rank = r1.object_rank
                AND object_name = r1.object_name;

        END LOOP;

        COMMIT;
    END;

END;
/



-- sqlcl_snapshot {"hash":"01647e8961cbca2e359a90eced4287d4011cca30","type":"PACKAGE_BODY","name":"SQLCL_LB_CAPTURE","schemaName":"DIRKSPZM32","sxml":""}