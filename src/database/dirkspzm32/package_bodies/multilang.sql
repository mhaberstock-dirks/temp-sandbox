create or replace package body dirkspzm32.multilang is

    function get_lang_name (
        in_lang_id in isi_language.lang_id%type
    ) return isi_language.lang_name%type is
        v_result isi_language.lang_name%type;
    begin
        select
            t.lang_name
        into v_result
        from
            isi_language t
        where
            t.lang_id = in_lang_id;

        return v_result;
    end;

    function get_lang_id (
        in_lang_name in isi_language.lang_name%type
    ) return isi_language.lang_id%type is
        v_result isi_language.lang_id%type;
    begin
        select
            t.lang_id
        into v_result
        from
            isi_language t
        where
            lower(t.lang_name) = lower(in_lang_name);

        return v_result;
    end;

    function get_default_firma_lang_name (
        in_firma_nr in isi_firma.firma_nr%type
    ) return isi_language.lang_name%type is

        v_result isi_language.lang_name%type;
        v_my_sid isi_sid.sid%type;
        cursor c_firma is
        select
            isi_language.lang_name
        from
            isi_firma t,
            isi_language
        where
                t.sid = v_my_sid
            and t.firma_nr = in_firma_nr
            and t.default_lang_id = isi_language.lang_id;

    begin
        v_result := null;
        select
            t.sid
        into v_my_sid
        from
            isi_sid t
        where
            t.sid_my_sid = 1;

        open c_firma;
        fetch c_firma into v_result;
        close c_firma;
        return v_result;
    end;

    procedure get_module_lang_data (
        in_module_id           in sec_module_info.mod_id%type,
        out_module_caption     out sec_module_info.caption%type,
        out_module_description out sec_module_info.description%type
    ) is

        cursor c_module_info is
        select
            t.caption,
            t.description
        from
            sec_module_info t
        where
            t.mod_id = in_module_id;

        v_found boolean;
    begin
        open c_module_info;
        fetch c_module_info into
            out_module_caption,
            out_module_description;
        v_found := c_module_info%found;
        close c_module_info;
        if not v_found then
            raise_application_error(-20900,
                                    'No data found for Module ID ' || to_char(in_module_id));
        end if;

    end;

    procedure get_section_lang_data (
        in_section_id           in sec_section_info.section_id%type,
        out_section_caption     out sec_section_info.caption%type,
        out_section_description out sec_section_info.description%type
    ) is

        cursor c_section_info is
        select
            t.caption,
            t.description
        from
            sec_section_info t
        where
            t.section_id = in_section_id;

        v_found boolean;
    begin
        open c_section_info;
        fetch c_section_info into
            out_section_caption,
            out_section_description;
        v_found := c_section_info%found;
        close c_section_info;
        if not v_found then
            raise_application_error(-20900,
                                    'No data found for Section ID ' || to_char(in_section_id));
        end if;

    end;

    procedure get_lang_info (
        in_lang_name  in isi_language.lang_name%type,
        out_lang_info out isi_language%rowtype
    ) is

        cursor c_isi_language is
        select
            *
        from
            isi_language t
        where
            lower(t.lang_name) = lower(in_lang_name);

        v_found boolean;
    begin
        open c_isi_language;
        fetch c_isi_language into out_lang_info;
        v_found := c_isi_language%found;
        close c_isi_language;
        if not v_found then
            raise_application_error(-20010,
                                    'Language '
                                    || to_char(in_lang_name)
                                    || ' not found!');
        end if;

    end;

    function get_all_lang_names_cs return varchar2 is

        v_result    varchar2(1000);
        v_lang_name isi_language.lang_name%type;
        cursor c_isi_language is
        select
            lang_name
        from
            isi_language t
        order by
            lang_id;

    begin
        v_result := null;
        open c_isi_language;
        loop
            fetch c_isi_language into v_lang_name;
            exit when c_isi_language%notfound;
            if v_result is null then
                v_result := v_lang_name;
            else
                v_result := v_result
                            || ','
                            || v_lang_name;
            end if;

        end loop;

        close c_isi_language;
        if v_result is null then
            v_result := '';
        end if;
        return v_result;
    end;

    function get_firma_lang_names_cs (
        in_firma_nr in isi_firma.firma_nr%type
    ) return varchar2 is
    begin
    -- TODO:
        return to_char(in_firma_nr);
    end;

    function get_arbeitsplatz_lang_names_cs (
        ip_adresse in isi_arbeitsplatz.ip_adresse%type
    ) return varchar2 is
    begin
    -- TODO:
        return ip_adresse;
    end;

end;
/


-- sqlcl_snapshot {"hash":"9309e734b317e626adaa2cb526a1a6967852c245","type":"PACKAGE_BODY","name":"MULTILANG","schemaName":"DIRKSPZM32","sxml":""}