create or replace package body dirkspzm32.sqlcl_lb_capture as

    function getboolean (
        val in varchar2
    ) return boolean is
    begin
        if ( lower(val) = 'on' ) then
            return true;
        else
            return false;
        end if;
    end;

    procedure set_parm (
        p_handle in number,
        p_parm   in varchar2,
        p_state  in varchar2
    ) is
    begin
        if ( p_state = 'on' ) then
            dbms_metadata.set_transform_param(p_handle, p_parm, true);
        else
            dbms_metadata.set_transform_param(p_handle, p_parm, false);
        end if;
    end;

    function getsequence return number is
        seq number;
    begin
        select
            nvl(
                max(object_sequence),
                1
            ) + 100
        into seq
        from
            databasechangelog_export;

        return seq;
    end;

    function sxmltoddl11 (
        sxml  in clob,
        otype in varchar2
    ) return clob as
        l_obj sys.xmltype;
        l_trn number;
        l_ddl clob;
        l_hdl number;
        th1   number;
    begin
        l_obj := sys.xmltype.createxml(sxml);
        dbms_lob.createtemporary(l_ddl, true);
        l_hdl := dbms_metadata.openw(otype);
        l_trn := dbms_metadata.add_transform(l_hdl, 'SXMLDDL');
        dbms_metadata.set_transform_param(l_trn, 'SQLTERMINATOR', true);
        dbms_metadata.convert(l_hdl, l_obj, l_ddl);
        dbms_metadata.close(l_hdl);
        return l_ddl;
    end;

    function get_deps (
        oname in varchar2,
        otype in varchar2
    ) return varchar2 as
        deps   varchar2(32767);
        cnt    number;
        l_type varchar2(2000);
    begin
        cnt := 0;
        if otype = 'TABLE' then
            return null;
        else
            if otype = 'TYPE_SPEC' then
                l_type := 'TYPE';
            elsif otype = 'TYPE_BODY' then
                l_type := 'TYPE BODY';
            elsif otype = 'PACKAGE_SPEC' then
                l_type := 'PACKAGE';
            elsif otype = 'PACKAGE_BODY' then
                l_type := 'PACKAGE BODY';
            end if;

            for r_dep in (
                select
                    referenced_name
                from
                    user_dependencies
                where
                        type = l_type
                    and name = oname
                    and referenced_owner = user
            ) loop
                if r_dep.referenced_name != oname then
                    if cnt = 0 then
                        deps := r_dep.referenced_name;
                        cnt := 1;
                    else
                        deps := r_dep.referenced_name
                                || ','
                                || deps;
                    end if;

                end if;
            end loop;

        end if;

        return deps;
    end;

    function get_grants (
        p_rank  in number,
        p_otype varchar2
    ) return varchar2 is
        --METADATA HOLDERS
        l_handle           number; -- handle returned by OPEN
        l_transform_handle number; -- handle returned by ADD_TRANSFORM
        l_map_handle       number; -- handle for the schema mapping
        l_tableddls        sys.ku$_ddls;
        l_tableddl         sys.ku$_ddl;
        l_obj_type         varchar2(20000);
        l_count            number := 0;
    begin
        l_obj_type := trim(upper(p_otype));
        l_handle := dbms_metadata.open(upper(l_obj_type));
        if ( l_obj_type not in ( 'SYSTEM_GRANT', 'ROLE_GRANT' ) ) then
            dbms_metadata.set_filter(l_handle, 'GRANTOR', user);
        else
            dbms_metadata.set_filter(l_handle, 'GRANTEE', user);
        end if;

        l_map_handle := dbms_metadata.add_transform(l_handle, 'MODIFY');
        dbms_metadata.set_remap_param(l_map_handle, 'REMAP_SCHEMA', user, '%USER_NAME%');
        l_transform_handle := dbms_metadata.add_transform(l_handle, 'DDL');
        dbms_metadata.set_transform_param(l_transform_handle, 'PRETTY', true);
        dbms_metadata.set_transform_param(l_transform_handle, 'SQLTERMINATOR', true);
        loop
            l_count := l_count + 1;
            l_tableddls := dbms_metadata.fetch_ddl(l_handle);
            exit when l_tableddls is null
                      or l_tableddls(1) is null;
            begin
                l_tableddl := l_tableddls(1);
            exception
                when others then
                    rollback;
                    exit;
            end;

            insert into databasechangelog_export (
                object_rank,
                object_sequence,
                object_name,
                object_type,
                object_doc,
                object_deps,
                file_name
            ) values ( p_rank,
                       getsequence(),
                       l_count,
                       l_obj_type,
                       l_tableddl.ddltext,
                       null,
                       l_count || '.xml' );

            if ( l_count = 500 ) then
                commit;
            end if;
        end loop;

        dbms_metadata.close(l_handle);
        commit;
        return null;
    end;

    function capture_object_type (
        p_rank                 in number,
        p_otype                varchar2,
        p_body                 varchar2 default 'on',
        p_constraints          varchar2 default 'on',
        p_constraints_as_alter varchar2 default 'on',
        p_force                varchar2 default 'on',
        p_inherit              varchar2 default 'on',
        p_inserts              varchar2 default 'on',
        p_partitioning         varchar2 default 'on',
        p_pretty               varchar2 default 'on',
        p_ref_constraints      varchar2 default 'on',
        p_segments             varchar2 default 'on',
        p_size_byte_keyword    varchar2 default 'on',
        p_specification        varchar2 default 'on',
        p_sqlterminator        varchar2 default 'on',
        p_storage              varchar2 default 'on',
        p_tablespace           varchar2 default 'on',
        p_lb_table_name        varchar2 default 'DATABASECHANGELOG',
        p_filter               varchar2 default null
    ) return varchar2 is
    --METADATA HOLDERS
        l_handle           number; -- handle returned by OPEN
        l_transform_handle number; -- handle returned by ADD_TRANSFORM
        l_map_handle       number; -- handle for the schema mapping
        l_oname            varchar2(32767);
        l_clob_doc         clob;
        l_parsed           sys.ku$_parsed_items;
        l_path             varchar2(32767);
        l_tableddls        sys.ku$_ddls;
        l_tableddl         sys.ku$_ddl;
        l_mv_rows          number;
        l_deps             varchar2(32767);
        l_obj_type         varchar2(20000);
        l_action           varchar2(20);
        l_count            number := 0;
        l_seq              number;
        l_ddl              clob;
        l_err_num          number;
        l_err_msg          varchar2(100);
        cur1               sys_refcursor;
        query_string       varchar2(2000);
        l_obj_count        number;
        type myrec is record (
            synonym_name varchar(128)
        );
        myrecord           myrec;
    begin
        l_obj_type := trim(upper(p_otype));
        -- SHORT CIRCUITS

        if ( l_obj_type in ( 'SYSTEM_GRANT', 'ROLE_GRANT', 'OBJECT_GRANT' ) ) then
            return get_grants(p_rank, p_otype);
        end if;

        if ( l_obj_type = 'MATERIALIZED_VIEW' ) then
            select
                count(*)
            into l_mv_rows
            from
                user_objects
            where
                object_type = 'MATERIALIZED VIEW';

            if ( l_mv_rows = 0 ) then
                return null;
            end if;
        elsif ( l_obj_type = 'PUBLIC_SYNONYM' ) then
            query_string := ' SELECT
                    synonym_name
                FROM
                    all_synonyms
                WHERE
                        owner = ''PUBLIC''
                    AND table_owner = user ';
            if ( length(p_filter) > 0 ) then
                query_string := ' SELECT
                    synonym_name
                FROM
                    all_synonyms
                WHERE
                        owner = ''PUBLIC''
                    AND table_owner = user  and table_name ' || p_filter;
            end if;

            open cur1 for query_string;

            loop
                fetch cur1 into myrecord;
                exit when cur1%notfound;
                l_count := l_count + 1;
                l_deps := get_deps(
                    upper(l_oname),
                    upper(l_obj_type)
                );
                insert into databasechangelog_export (
                    object_rank,
                    object_sequence,
                    object_name,
                    object_deps,
                    object_type,
                    object_doc,
                    file_name
                ) values ( 1000,
                           getsequence(),
                           myrecord.synonym_name,
                           l_deps,
                           'SYNONYM',
                           dbms_metadata.get_ddl('SYNONYM', myrecord.synonym_name, 'PUBLIC'),
                           myrecord.synonym_name || '_public_synonym.xml' );

                if l_count = 500 then
                    commit;
                end if;
            end loop;

            commit;
            return null;
        end if;

         -- GET HANDLE
        if ( l_obj_type in ( 'JOB' ) ) then
            l_handle := dbms_metadata.open(upper('PROCOBJ'));
            dbms_metadata.set_filter(l_handle, 'SCHEMA', user);
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT IN (select credential_name from user_credentials)');
        elsif ( l_obj_type in ( 'DIRECTORY' ) ) then
            l_handle := dbms_metadata.open(upper(l_obj_type));
        else
            l_handle := dbms_metadata.open(upper(l_obj_type));
            dbms_metadata.set_filter(l_handle, 'SCHEMA', user);
        end if;

        dbms_metadata.set_parse_item(l_handle, 'NAME');

         -- FILTERS- FILTERS
        if ( l_obj_type = 'INDEX' ) then
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT in (select constraint_name from user_constraints where constraint_type=''P'')'
            );
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''I_SNAP%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''C_SNAP%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''I_MLOG%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''SYS_%$$''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''SYS_FDA%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''SYS_FBA%''');
            dbms_metadata.set_filter(l_handle, 'SYSTEM_GENERATED', false);
        elsif ( l_obj_type = 'TABLE'
        or l_obj_type = 'VIEW'
        or l_obj_type = 'TRIGGER' ) then
            if (
                p_lb_table_name is not null
                and p_lb_table_name != ''
            ) then
                dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE '''
                                                                || p_lb_table_name
                                                                || '%''');
            else
                dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''DATABASECHANGELOG%''');
            end if;

            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'not in (select mview_name from user_mviews)');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''MLOG$_%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''SYS_FBA%''');
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT IN (''EXP_LOAD'',''EXP_SORT'',''EXP_PROCESS'',''EXP_CLEANUP'')');
        elsif ( l_obj_type in ( 'PACKAGE_SPEC', 'PACKAGE_BODY' ) ) then
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', '!=''SQLCL_LB_CAPTURE''');
        end if;

        if ( length(p_filter) > 0 ) then
            dbms_metadata.set_filter(l_handle, 'NAME_EXPR', p_filter);
        end if;
        -- GLOBAL FILTERS
        dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''DR$%''');
        dbms_metadata.set_filter(l_handle, 'NAME_EXPR', 'NOT LIKE ''AQ$_%''');
        --TRANSFORMS
        if ( l_obj_type in ( 'REF_CONSTRAINT', 'DIMENSION', 'FUNCTION', 'PROCEDURE', 'PACKAGE_SPEC',
                             'PACKAGE_BODY', 'TYPE_SPEC', 'TYPE_BODY', 'PUBLIC_SYNONYM', 'SYNONYM',
                             'DB_LINK', 'TRIGGER', 'JOB', 'DIRECTORY' ) ) then
            l_action := 'DDL';
            if l_obj_type not in ( 'DIRECTORY', 'JOB' ) then
                l_map_handle := dbms_metadata.add_transform(l_handle, 'MODIFY');
                dbms_metadata.set_remap_param(l_map_handle, 'REMAP_SCHEMA', user, '%USER_NAME%');
            end if;

            l_transform_handle := dbms_metadata.add_transform(l_handle, 'DDL');
            dbms_metadata.set_transform_param(l_transform_handle,
                                              'PRETTY',
                                              getboolean(p_pretty));
            dbms_metadata.set_transform_param(l_transform_handle,
                                              'SQLTERMINATOR',
                                              getboolean(p_sqlterminator));
        else
            l_action := 'SXML';
            sys.dbms_lob.createtemporary(l_clob_doc,
                                         false,
                                         sys.dbms_lob.session);
            l_map_handle := dbms_metadata.add_transform(l_handle, 'MODIFY');
            dbms_metadata.set_remap_param(l_map_handle, 'REMAP_SCHEMA', user, '%USER_NAME%');
            l_transform_handle := dbms_metadata.add_transform(l_handle, 'SXML');
            if l_obj_type = 'CLUSTER' then
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'STORAGE',
                                                  getboolean(p_storage));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'TABLESPACE',
                                                  getboolean(p_tablespace));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'SEGMENT_ATTRIBUTES',
                                                  getboolean(p_segments));
            elsif l_obj_type = 'INDEX' then
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
            elsif l_obj_type = 'MATERIALIZED_VIEW' then
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'STORAGE',
                                                  getboolean(p_storage));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'TABLESPACE',
                                                  getboolean(p_tablespace));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'SEGMENT_ATTRIBUTES',
                                                  getboolean(p_segments));
            elsif l_obj_type = 'MATERIALIZED_VIEW_LOG' then
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'STORAGE',
                                                  getboolean(p_storage));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'TABLESPACE',
                                                  getboolean(p_tablespace));
                dbms_metadata.set_transform_param(l_transform_handle,
                                                  'SEGMENT_ATTRIBUTES',
                                                  getboolean(p_segments));
            elsif l_obj_type = 'TABLE' then
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
                dbms_metadata.set_transform_param(l_transform_handle, 'REF_CONSTRAINTS', false);
            end if;

        end if;
  -- supported by all objects
        if ( l_action = 'SXML' ) then
            loop
                l_count := l_count + 1;
                dbms_metadata.fetch_xml_clob(l_handle, l_clob_doc, l_parsed, l_path);
                exit when l_clob_doc is null;
                begin
                    l_oname := l_parsed(1).value;
                exception
                    when others then
                        l_oname := null;
                end;

                l_deps := get_deps(
                    upper(l_oname),
                    upper(l_obj_type)
                );
                if ( length(l_deps) > 2000 ) then
                    l_deps := substr(l_deps,
                                     instr(l_deps, ',', -1),
                                     1);
                end if;

                l_seq := getsequence();
                insert into databasechangelog_export (
                    object_rank,
                    object_sequence,
                    object_name,
                    object_type,
                    object_doc,
                    object_deps,
                    file_name
                ) values ( p_rank,
                           l_seq,
                           l_oname,
                           l_obj_type,
                           l_clob_doc,
                           l_deps,
                           lower(l_oname
                                 || '_'
                                 || l_obj_type || '.xml') );

                if l_obj_type = 'TABLE'
                or l_obj_type = 'VIEW' then
                    begin
                        dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'EMIT_SCHEMA', false);
                        dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'SQLTERMINATOR', true);
                        dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'PRETTY', true);
                        select
                            dbms_metadata.get_dependent_ddl('COMMENT', l_oname, user)
                        into l_ddl
                        from
                            dual;

                    exception
                        when others then
                            l_ddl := null;
                    end;

                    if ( l_ddl is not null ) then
                        insert into databasechangelog_export (
                            object_rank,
                            object_sequence,
                            object_name,
                            object_type,
                            object_doc,
                            file_name
                        ) values ( 65,
                                   getsequence(),
                                   l_oname,
                                   'COMMENT',
                                   l_ddl,
                                   lower(l_oname || '_COMMENTS.xml') );

                    end if;

                end if;

                if l_count = 100 then
                    commit;
                    l_count := 0;
                end if;
            end loop;

            commit;
            dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'DEFAULT', true);
        elsif ( l_action = 'DDL' ) then
            loop
                l_count := l_count + 1;
                l_tableddls := dbms_metadata.fetch_ddl(l_handle);
                exit when l_tableddls is null
                          or l_tableddls(1) is null;
                begin
                    l_tableddl := l_tableddls(1);
                    l_oname := l_tableddl.parseditems(1).value;
                exception
                    when others then
                        rollback;
                        exit;
                end;

                l_deps := get_deps(
                    upper(l_oname),
                    upper(l_obj_type)
                );
                if ( length(l_deps) > 2000 ) then
                    l_deps := substr(l_deps,
                                     instr(l_deps, ',', -1),
                                     1);
                end if;

                insert into databasechangelog_export (
                    object_rank,
                    object_sequence,
                    object_name,
                    object_type,
                    object_doc,
                    object_deps,
                    file_name
                ) values ( p_rank,
                           getsequence(),
                           l_oname,
                           l_obj_type,
                           l_tableddl.ddltext,
                           l_deps,
                           lower(l_oname
                                 || '_'
                                 || l_obj_type || '.xml') );

                if l_count = 100 then
                    commit;
                    l_count := 0;
                end if;
            end loop;

            commit;
        end if;

        dbms_metadata.close(l_handle);
        return null;
    exception
        when others then
            l_err_num := sqlcode;
            l_err_msg := substr(sqlerrm, 1, 100);
            rollback;
            return l_err_msg
                   || '\n '
                   || l_action;
    end;

    procedure sortcapturedobjects is
        l_seq number;
    begin
        -- set all objects wihtout deps to 0 sequence
        update databasechangelog_export
        set
            object_sequence = 0
        where
            object_deps is null;

        commit;
        --set all objects that only depend on zeros to 100
        update databasechangelog_export
        set
            object_sequence = 100
        where
                object_rank = object_rank
            and object_deps in (
                select
                    object_name
                from
                    databasechangelog_export
                where
                    object_sequence = 0
            );

        commit;
-- sort the rest
        for r1 in (
            select
                *
            from
                databasechangelog_export
            where
                object_sequence > 100
        ) loop
            select
                max(dep_seq)
            into l_seq
            from
                (
                    with deps as (
                        select
                            t.object_rank,
                            t.object_sequence,
                            t.object_name,
                            trim(regexp_substr(t.object_deps, '[^,]+', 1, lines.column_value)) object_deps
                        from
                            databasechangelog_export   t,
                            table ( cast(multiset(
                                select
                                    level
                                from
                                    dual
                                connect by
                                    instr(t.object_deps, ',', 1, level - 1) > 0
                            ) as sys.odcinumberlist) ) lines
                        order by
                            t.object_rank,
                            t.object_sequence,
                            t.object_name,
                            lines.column_value
                    )
                    select
                        d.object_rank     rank,
                        d.object_sequence seq,
                        d.object_name     name,
                        l.object_sequence dep_seq,
                        d.object_deps     dep_name
                    from
                        deps                     d,
                        databasechangelog_export l
                    where
                            l.object_rank = d.object_rank
                        and d.object_deps = l.object_name
                ) data
            where
                    name = r1.object_name
                and rank = r1.object_rank;

            update databasechangelog_export
            set
                object_sequence = l_seq + 5
            where
                    object_rank = r1.object_rank
                and object_name = r1.object_name;

        end loop;

        commit;
    end;

end;
/


-- sqlcl_snapshot {"hash":"03095c16dcf60ff603c3ffcce141e58a8050869d","type":"PACKAGE_BODY","name":"SQLCL_LB_CAPTURE","schemaName":"DIRKSPZM32","sxml":""}