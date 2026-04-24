create or replace package body dirkspzm32.meld is

    procedure c_alle_meldungen_gehen (
        in_sid       in varchar2,
        in_firma_nr  in number,
        in_bereich   in varchar2,
        in_engine_id in number default null
    ) is
    begin
        alle_meldungen_gehen(in_sid, in_firma_nr, in_bereich, in_engine_id);
        commit;
    end;

    procedure alle_meldungen_gehen (
        in_sid       in varchar2,
        in_firma_nr  in number,
        in_bereich   in varchar2,
        in_engine_id in number default null
    ) is
    begin
        update meldung_daten
        set
            md_geht = sysdate,
            md_status = 'KG'
        where
                sid = in_sid
            and firma_nr = in_firma_nr
            and engine_id = in_engine_id
            and md_status = 'K'
            and md_bereich = in_bereich;

    end;

    procedure c_meldung_buchen (
        in_sid       in varchar2,
        in_firma_nr  in number,
        in_gruppe    in number,
        in_md_ix     in number,
        in_bereich   in varchar2,
        in_status    in varchar2,
        in_hilfstext in varchar2,
        in_engine_id in number default null
    ) is
        v_md_id number;
    begin
        meldung_buchen(in_sid, in_firma_nr, in_gruppe, in_md_ix, in_bereich,
                       in_status, in_hilfstext, in_engine_id, null, v_md_id);

        commit;
    end;

    procedure c_meldung_buchen_47x (
        in_sid       in varchar2,
        in_firma_nr  in number,
        in_gruppe    in number,
        in_md_ix     in number,
        in_bereich   in varchar2,
        in_status    in varchar2,
        in_hilfstext in varchar2,
        in_engine_id in number default null,
        in_param_1   in varchar2,
        in_param_2   in varchar2,
        in_typ       in varchar2
    ) is
        v_md_id number;
    begin
        meldung_buchen_47x(in_sid, in_firma_nr, in_gruppe, in_md_ix, in_bereich,
                           in_status, in_hilfstext, in_engine_id, null, in_param_1,
                           in_param_2, in_typ, v_md_id);

        commit;
    end;

    procedure c_meldung_buchen_ausloes (
        in_sid              in varchar2,
        in_firma_nr         in number,
        in_gruppe           in number,
        in_md_ix            in number,
        in_bereich          in varchar2,
        in_status           in varchar2,
        in_hilfstext        in varchar2,
        in_engine_id        in number default null,
        in_md_ausloes_md_id in number default null,
        out_md_id           out number
    ) is
    begin
        meldung_buchen(in_sid, in_firma_nr, in_gruppe, in_md_ix, in_bereich,
                       in_status, in_hilfstext, in_engine_id, in_md_ausloes_md_id, out_md_id);

        commit;
    end;

    procedure meldung_buchen (
        in_sid              in varchar2,
        in_firma_nr         in number,
        in_gruppe           in number,
        in_md_ix            in number,
        in_bereich          in varchar2,
        in_status           in varchar2,
        in_hilfstext        in varchar2,
        in_engine_id        in number default null,
        in_md_ausloes_md_id in number default null,
        out_md_id           out number
    ) is
    begin
        out_md_id := null;
        if in_status in ( 'K', 'KG' ) then
            insert into meldung_daten values ( in_sid,
                                               in_firma_nr,
                                               in_engine_id,
                                               null, /* md_id */
                                               in_gruppe,
                                               in_md_ix,
                                               in_bereich,
                                               in_status,
                                               sysdate, /* md_kommt */
                                               null, /* md_geht */
                                               in_hilfstext,  /* Hilfstext */
                                               in_md_ausloes_md_id,
                                               null, /* Param_1 */
                                               null,/* Param_2 */
                                               null,/* TYP */
                                               sysdate, -- create Date
                                               1,       -- create User
                                               null,    -- change Date
                                               null,     -- change User
                                               null,     -- md_info_text
                                               in_md_ix,  -- md_initial_index
                                               null ) returning md_id into out_md_id;

        else
            update meldung_daten t
            set
                t.md_geht = sysdate,
                t.md_status = 'KG'
            where
                    sid = in_sid
                and firma_nr = in_firma_nr
                and engine_id = in_engine_id
                and t.md_status = 'K'
                and t.md_index = in_md_ix
                and t.md_gruppe = in_gruppe
                and t.md_bereich = in_bereich;

        end if;

    end;

    procedure meldung_buchen_47x (
        in_sid              in varchar2,
        in_firma_nr         in number,
        in_gruppe           in number,
        in_md_ix            in number,
        in_bereich          in varchar2,
        in_status           in varchar2,
        in_hilfstext        in varchar2,
        in_engine_id        in number default null,
        in_md_ausloes_md_id in number default null,
        in_param_1          varchar2,
        in_param_2          varchar2,
        in_typ              in varchar2,
        out_md_id           out number
    ) is
    begin
        out_md_id := null;
        if in_status in ( 'K', 'KG' ) then
            insert into meldung_daten values ( in_sid,
                                               in_firma_nr,
                                               in_engine_id,
                                               null, /* md_id */
                                               in_gruppe,
                                               in_md_ix,
                                               in_bereich,
                                               in_status,
                                               sysdate, /* md_kommt */
                                               null, /* md_geht */
                                               in_hilfstext,  /* Hilfstext */
                                               in_md_ausloes_md_id,
                                               in_param_1, /* Param_1 */
                                               in_param_2,/* Param_2 */
                                               in_typ, /* TYP */
                                               sysdate, -- create Date
                                               1,       -- create User
                                               null,    -- change Date
                                               null,    -- change User
                                               null,    -- md_info_text
                                               in_md_ix, -- md_initial_index
                                               null ) returning md_id into out_md_id;

        else
            update meldung_daten t
            set
                t.md_geht = sysdate,
                t.md_status = 'KG'
            where
                    sid = in_sid
                and firma_nr = in_firma_nr
                and engine_id = in_engine_id
                and t.md_status = 'K'
                and t.md_index = in_md_ix
                and t.md_gruppe = in_gruppe
                and t.md_bereich = in_bereich;

        end if;

    end;

    procedure meldung_statistik_gen (
        in_von_datum in meldung_daten.md_kommt%type,
        in_bis_datum in meldung_daten.md_kommt%type
    ) is
    begin
        meldung_statistik_gen_31(in_von_datum, in_bis_datum, null);
    end;

    procedure meldung_statistik_gen_31 (
        in_von_datum in meldung_daten.md_kommt%type,
        in_bis_datum in meldung_daten.md_kommt%type,
        in_sprach_id in meldung_texte.mt_sprache%type
    ) is

        v_bereich         meldung_cfg%rowtype;
        v_meldungen       meldung_daten%rowtype;
        v_meldungen_last  meldung_daten%rowtype;
        v_meldungen_texte meldung_texte%rowtype;
        v_stat_daten      meldung_statistik%rowtype;
        v_mt_sprache      meldung_texte.mt_sprache%type;
        v_firma           isi_firma%rowtype;
        cursor c_bereiche is
        select
            *
        from
            meldung_cfg t
        order by
            t.engine_id,
            t.nr;

        cursor c_meldungen is
        select
            *
        from
            meldung_daten t
        where
                t.md_bereich = v_bereich.name
            and t.md_kommt >= trunc(in_von_datum)
            and t.md_kommt <= trunc(in_bis_datum) + 1
            and t.md_geht is not null
        order by
            t.md_id;

        cursor c_meldungen_texte is
        select
            t.*
        from
            meldung_texte t
        where
                t.mt_gruppe = v_meldungen.md_gruppe
            and t.mt_index = v_meldungen.md_index
            and t.mt_sprache = nvl(v_mt_sprache, t.mt_sprache);

    begin
    /*
    isi_p_log.c_isi_system_meldung('01',
                                   1,
                                   'DB_MELD_STAT_JOBS',
                                   'ORA-DB',
                                   'gen_meld_statistik',
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   'gestartet ' || to_char('yyyy.mm.dd hh24:mi:ss', sysdate) || ' für ' ||
                                   to_char('yyyy.mm.dd hh24:mi:ss', in_von_datum) || ' bis '  ||
                                   to_char('yyyy.mm.dd hh24:mi:ss', in_bis_datum),
                                   'I');
    */
        delete meldung_statistik t
        where
                t.ms_begin >= trunc(in_von_datum)
            and t.ms_begin <= trunc(in_bis_datum) + 1;

        if in_sprach_id is not null then
            v_mt_sprache := in_sprach_id;
        else
            if isi_p_base.get_isi_firma('01', 1, v_firma) then
                v_mt_sprache := v_firma.default_lang_id;
            end if;
        end if;

        open c_bereiche;
        loop   -- Über alle Bereiche
            fetch c_bereiche into v_bereich;
            exit when c_bereiche%notfound;
            v_meldungen_last := null;      -- Init
            v_stat_daten := null;
            v_stat_daten.ms_count := 0;
            open c_meldungen;
            loop
                fetch c_meldungen into v_meldungen;
                exit when c_meldungen%notfound;
                if v_stat_daten.gruppe != v_meldungen.md_gruppe
                or nvl(v_stat_daten.ms_ende, sysdate) < v_meldungen.md_kommt - 1 / 1440 -- Mind. 1 Minute lauf
                 then
                    v_stat_daten.ms_minuten := round((v_stat_daten.ms_ende - v_stat_daten.ms_begin) * 1440, 2);

                    begin
                        insert into meldung_statistik values v_stat_daten;

                    exception
                        when others then
                            null;
                    end;
                    v_stat_daten := null;
                    v_stat_daten.ms_count := 0;
                end if;

                v_stat_daten.ms_count := v_stat_daten.ms_count + 1;
                v_stat_daten.sid := v_meldungen.sid;
                v_stat_daten.firma_nr := v_meldungen.firma_nr;
                v_stat_daten.engine_id := v_meldungen.engine_id;
                v_stat_daten.gruppe := v_meldungen.md_gruppe;
                v_stat_daten.bereich := v_meldungen.md_bereich;
                if v_stat_daten.ms_begin is null
                   or v_stat_daten.ms_begin < v_meldungen.md_kommt then
                    v_stat_daten.ms_begin := v_meldungen.md_kommt;
                end if;

                if v_stat_daten.ms_ende is null
                   or v_stat_daten.ms_ende < v_meldungen.md_geht then
                    v_stat_daten.ms_ende := v_meldungen.md_geht;
                end if;

                open c_meldungen_texte;
                fetch c_meldungen_texte into v_meldungen_texte;
                close c_meldungen_texte;
                if v_meldungen_texte.mt_fehlertext not like nvl(v_stat_daten.ms_texte, 'XXXX') then
                    if v_stat_daten.ms_texte is null then
                        v_stat_daten.ms_texte := v_meldungen_texte.mt_fehlertext;
                    else
                        v_stat_daten.ms_texte := substr(v_stat_daten.ms_texte
                                                        || ', '
                                                        || v_meldungen_texte.mt_fehlertext, 1, 4000);
                    end if;
                end if;

            end loop;

            close c_meldungen;
            if v_stat_daten.sid is not null then
                v_stat_daten.ms_minuten := round((v_stat_daten.ms_ende - v_stat_daten.ms_begin) * 1440, 2);

                begin
                    insert into meldung_statistik values v_stat_daten;

                exception
                    when others then
                        null;
                end;
                v_stat_daten := null;
                v_stat_daten.ms_count := 0;
            end if;

        end loop;

        close c_bereiche;
    /*
    isi_p_log.c_isi_system_meldung('01',
                                   1,
                                   'DB_MELD_STAT_JOBS',
                                   'ORA-DB',
                                   'gen_meld_statistik',
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   'beendet ' || to_char('yyyy.mm.dd hh24:mi:ss', sysdate) || ' für ' ||
                                   to_char('yyyy.mm.dd hh24:mi:ss', in_von_datum) || ' bis '  ||
                                   to_char('yyyy.mm.dd hh24:mi:ss', in_bis_datum),
                                   'I');
    */
    end;

    function meldung_anzeige_text (
        in_text      in meldung_texte.mt_fehlertext%type,
        in_help_text in meldung_daten.md_hilfstext%type,
        in_param_1   in meldung_daten.md_param_1%type,
        in_param_2   in meldung_daten.md_param_2%type
    ) return varchar2 is
        v_text varchar2(800);
    begin
        v_text := replace(in_text, '#', in_help_text);
        v_text := replace(v_text, '<%1>', in_param_1);
        v_text := replace(v_text, '<%2>', in_param_2);
        return ( v_text );
    end;

end meld;
/


-- sqlcl_snapshot {"hash":"45b4a34a68d3cf69818f4fbab48b5078686465a7","type":"PACKAGE_BODY","name":"MELD","schemaName":"DIRKSPZM32","sxml":""}