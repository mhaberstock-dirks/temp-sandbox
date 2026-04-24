create or replace package body dirkspzm32.lvs_serie is

  /*
  __________________________________________________
  Author    : CMe
  Created   : 04.11.2019 15:27:55
  __________________________________________________
  Description
  Funktionen und Prozeduren für die Verwaltung von Serien
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  04.11.2019   DB31_1      (-CMe-)  Package erstellt mit folgenden Logiken:
                                    - LVS_SERIE_ID_KOPF_ERZEUGEN
                                    - LVS_SERIE_ID_POS_ERZEUGEN
                                    - LVS_C_SERIE_ERZEUGEN

                                    Ticket: E20DB-37
  */

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
    procedure raise_isi_error (
        in_err_nr   in number,
        in_err_text in varchar2
    ) is
    begin
        v_err_nr := in_err_nr;
        v_err_text := in_err_text;
        raise v_error;
    end;

  -------------------------------------------------------------------------------------------------------
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
    procedure reset_isi_error is
    begin
        v_err_nr := null;
        v_err_text := null;
    end;

  /*******************************************************************************
  procedure LVS_SERIE_ID_KOPF_ERZEUGEN(...)
    Erzeugt die Kopf Daten einer Serie basierend auf den übergebenen Parametern. Wird keine
    in_id_maske übergeben wird die Default Maske (DEFAULT_SERIE_MASKE) aus der Firma CFG
    verwendet. Für das generiern der Kopfdaten muss ein Fertigungsauftrag vorhanden sein.
    Der Fertigungsauftrag kann sowohl über die Leitzahl, als auch über die ABNR (in_leitzahl_extern)
    ermittelt werden.
  *******************************************************************************/
    procedure lvs_serie_id_kopf_erzeugen (
        in_sid                in lvs_serie_id_kopf.sid%type,
        in_firma_nr           in lvs_serie_id_kopf.firma_nr%type,
        in_leitzahl           in lvs_serie_id_kopf.leitzahl%type,
        in_leitzahl_extern    in lvs_serie_id_kopf.abnr%type,
        in_id_maske           in lvs_serie_id_kopf.serie_maske%type,
        in_externe_id_maske   in lvs_serie_id_kopf.serie_extern_maske%type,
        in_start_id           in lvs_serie_id_kopf.serie_start_id%type,
        in_start_externe_id   in lvs_serie_id_kopf.serie_extern_start_id%type,
        in_serie_gen_richtung in lvs_serie_id_kopf.serie_gen_richtung%type,
        out_serie_id          out lvs_serie_id_kopf.serie_id%type
    ) is

        v_serie_maske    lvs_serie_id_kopf.serie_maske%type;
        v_bde_fa_auftrag bde_fa_auftrag%rowtype;
        v_found          boolean;
        cursor c_get_bde_fa is
        select
            bde.*
        from
            bde_fa_auftrag bde
        where
            ( bde.leitzahl = in_leitzahl
              or bde.abnr = in_leitzahl_extern )
            and bde.kenz_letzt_ag = 1;

    begin
        reset_isi_error;
        open c_get_bde_fa;
        fetch c_get_bde_fa into v_bde_fa_auftrag;
        v_found := c_get_bde_fa%found;
        close c_get_bde_fa;
        if not v_found then
            raise_isi_error(10,
                            lc.ec_p3(lc.o_tp3_fa_auftrg_fehlt,
                                     in_leitzahl_extern,
                                     to_char(in_leitzahl),
                                     ''));
        end if;

        if in_id_maske is null then
            v_serie_maske := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'CFG',                 -- in_kategorie          in isi_firma_cfg.kategorie%type
             null,                  -- in_kategorie_ix       in isi_firma_cfg.kategorie_ix%type
             'DEFAULT_SERIE_MASKE', -- in_parameter_name     in isi_firma_cfg.parameter_name%type
                                                            'LVS',                 -- in_modul_name         in isi_firma_cfg.modul_name%type
                                                             'CFG', '@@@@@@@@@@@@@@@@@@',  -- in_default_param_wert in isi_firma_cfg.parameter_wert%type
                                                             'STRING');             -- in_default_param_typ  in isi_firma_cfg.parameter_typ%type
        else
            v_serie_maske := in_id_maske;
        end if;

        select
            seq_serie_id.nextval
        into out_serie_id
        from
            dual;

        insert into lvs_serie_id_kopf values ( in_sid,                       --SID                   VARCHAR2(2)
                                               in_firma_nr,                  --FIRMA_NR              NUMBER(2)
                                               out_serie_id,                 --SERIE_ID              INTEGER
                                               v_bde_fa_auftrag.abnr,        --ABNR                  VARCHAR2(20)
                                               v_bde_fa_auftrag.leitzahl,    --LEITZAHL              INTEGER
                                               v_bde_fa_auftrag.ab_soll_mg,  --SERIE_MENGE           INTEGER
                                               in_start_id,                  --SERIE_START_ID        VARCHAR2(50)
                                               v_serie_maske,                --SERIE_MASKE           VARCHAR2(50)
                                               in_externe_id_maske,          --SERIE_EXTERN_MASKE    VARCHAR2(50)
                                               in_start_externe_id,          --SERIE_EXTERN_START_ID VARCHAR2(50)
                                               sysdate,                      --CREATED_DATE          DATE
                                               - 1,                           --CREATED_LOGIN_ID      INTEGER
                                               null,                         --LAST_CHANGE_DATE      DATE
                                               null,
                                               in_serie_gen_richtung );                        --LAST_CHANGE_LOGIN_ID  INTEGER
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end lvs_serie_id_kopf_erzeugen;

  /*******************************************************************************
  procedure LVS_SERIE_ID_POS_ERZEUGEN(...)
    Generiert sowohl die Serien Nr als auch die externe Serien Nummer über die
    die Kopfdaten. Die Zeichen die in den jeweiligen Masken ersetzt werden sind
    in der Firma CFG hinterlegt (SERIE_NR_MASKE_REPLACE_CHAR und SERIE_NR_EXT_MASKE_REPLACE_CHAR).
    Default Character ist '@'.
  *******************************************************************************/
    procedure lvs_serie_id_pos_erzeugen (
        in_sid      in lvs_serie_id_pos.sid%type,
        in_firma_nr in lvs_serie_id_pos.firma_nr%type,
        in_serie_id in lvs_serie_id_pos.serie_id%type
    ) is

        v_lvs_serie_id_kopf         lvs_serie_id_kopf%rowtype;
        v_serie_nr                  lvs_serie_id_pos.serie_nr%type;
        v_serie_nr_extern           lvs_serie_id_pos.serie_nr_extern%type;
        v_replace_char_serie_nr     varchar2(1);
        v_replace_char_serie_ext_nr varchar2(1);
        v_found                     boolean;
        v_max_anzahl                integer;
        v_first_id                  integer;
        v_first_id_ext              integer;
        v_position                  integer;
        v_laenge                    integer;
        v_serie_lfdn_id             integer;
        v_prefix                    v_lvs_serie_id_kopf.serie_maske%type;
        v_suffix                    v_lvs_serie_id_kopf.serie_maske%type;
        cursor c_get_serie_id_kopf is
        select
            sik.*
        from
            lvs_serie_id_kopf sik
        where
            sik.serie_id = in_serie_id;

    begin
        reset_isi_error;
        open c_get_serie_id_kopf;
        fetch c_get_serie_id_kopf into v_lvs_serie_id_kopf;
        v_found := c_get_serie_id_kopf%found;
        close c_get_serie_id_kopf;
        if not v_found then
            raise_isi_error(10, 'Serie Kopf nicht gefunden');
        end if;
        v_replace_char_serie_nr := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'CFG',                         -- in_kategorie          in isi_firma_cfg.kategorie%type
         null,                          -- in_kategorie_ix       in isi_firma_cfg.kategorie_ix%type
         'SERIE_NR_MASKE_REPLACE_CHAR', -- in_parameter_name     in isi_firma_cfg.parameter_name%type
                                                                  'LVS',                         -- in_modul_name         in isi_firma_cfg.modul_name%type
                                                                   'CFG', '@',                           -- in_default_param_wert in isi_firma_cfg.parameter_wert%type
                                                                   'STRING');                     -- in_default_param_typ  in isi_firma_cfg.parameter_typ%type
        v_replace_char_serie_ext_nr := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'CFG',                              -- in_kategorie          in isi_firma_cfg.kategorie%type
         null,                               -- in_kategorie_ix       in isi_firma_cfg.kategorie_ix%type
         'SERIE_NR_EXT_MASKE_REPLACE_CHAR',  -- in_parameter_name     in isi_firma_cfg.parameter_name%type
                                                                      'LVS',                              -- in_modul_name         in isi_firma_cfg.modul_name%type
                                                                       'CFG', '@',                                -- in_default_param_wert in isi_firma_cfg.parameter_wert%type
                                                                       'STRING');                          -- in_default_param_typ  in isi_firma_cfg.parameter_typ%type
        v_max_anzahl := ( v_lvs_serie_id_kopf.serie_menge );
        for i in 1..v_max_anzahl loop
            if v_lvs_serie_id_kopf.serie_gen_richtung = 'AU' then
                v_serie_lfdn_id := i;     -- Aufsteigend
            else
                v_serie_lfdn_id := v_max_anzahl - i + 1;     -- Absteigend
            end if;

            if i = 1 then
                v_serie_nr := v_lvs_serie_id_kopf.serie_start_id;
                v_serie_nr_extern := v_lvs_serie_id_kopf.serie_extern_start_id;
            else
        --Berechnet die Anzahl an Zeichen die ersetzt werden sollen
                select
                    length(v_lvs_serie_id_kopf.serie_maske) - nvl(
                        length(replace(v_lvs_serie_id_kopf.serie_maske, v_replace_char_serie_nr)),
                        0
                    )
                into v_laenge
                from
                    dual;
        -- Hole die erste Position des vorkommens
                v_position := instr(v_lvs_serie_id_kopf.serie_maske, v_replace_char_serie_nr);
        -- Hole die Startnummer
                v_first_id := to_number ( substr(v_lvs_serie_id_kopf.serie_start_id, v_position, v_laenge) );
        -- Hole Prefix
                v_prefix := substr(v_lvs_serie_id_kopf.serie_maske, 1, v_position - 1);
        -- Hole Suffix
                v_suffix := substr(v_lvs_serie_id_kopf.serie_maske,(v_position + v_laenge) + 1);
                v_serie_nr := v_prefix
                              || lpad(
                    to_char(v_first_id +(i - 1)),
                    v_laenge,
                    '0'
                )
                              || v_suffix;

                if v_lvs_serie_id_kopf.serie_extern_maske is not null then
                    if v_lvs_serie_id_kopf.serie_extern_maske = v_lvs_serie_id_kopf.serie_maske then
                        v_serie_nr_extern := v_serie_nr;
                    else
            --Berechnet die Anzahl an Zeichen die ersetzt werden sollen
                        select
                            length(v_lvs_serie_id_kopf.serie_extern_maske) - nvl(
                                length(replace(v_lvs_serie_id_kopf.serie_extern_maske, v_replace_char_serie_ext_nr)),
                                0
                            )
                        into v_laenge
                        from
                            dual;
            -- Hole die erste Position des vorkommens
                        v_position := instr(v_lvs_serie_id_kopf.serie_extern_maske, v_replace_char_serie_ext_nr);
            -- Hole die Startnummer
                        v_first_id_ext := to_number ( substr(v_lvs_serie_id_kopf.serie_extern_start_id, v_position, v_laenge) );
            -- Hole Prefix
                        v_prefix := substr(v_lvs_serie_id_kopf.serie_extern_maske, 1, v_position - 1);
            -- Hole Suffix
                        v_suffix := substr(v_lvs_serie_id_kopf.serie_extern_maske,(v_position + v_laenge) + 1);
                        v_serie_nr_extern := v_prefix
                                             || lpad(
                            to_char(v_first_id_ext +(i - 1)),
                            v_laenge,
                            '0'
                        )
                                             || v_suffix;

                    end if;
                end if;

            end if;

            insert into lvs_serie_id_pos values ( in_sid,                       --SID                   VARCHAR2(2)
                                                  in_firma_nr,                  --FIRMA_NR              NUMBER(2)
                                                  v_lvs_serie_id_kopf.serie_id, --SERIE_ID              INTEGER
                                                  v_serie_lfdn_id,              --SERIE_POS_LFDN        INTEGER
                                                  null,                         --SERIE_ID_LFDN         INTEGER
                                                  v_serie_nr,                   --SERIE_NR              VARCHAR2(50)
                                                  null,                         --LAM_ID                INTEGER
                                                  v_serie_nr_extern,            --SERIE_NR_EXTERN       VARCHAR2(50)
                                                  sysdate,                      --CREATED_DATE          DATE
                                                  - 1,                           --CREATED_LOGIN_ID      INTEGER
                                                  null,                         --LAST_CHANGE_DATE      DATE
                                                  null );                        --LAST_CHANGE_LOGIN_ID  INTEGER
        end loop;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end lvs_serie_id_pos_erzeugen;

  /*******************************************************************************
  procedure LVS_C_SERIE_ERZEUGEN(...)
    Erzeugt für einen Fertigungsauftrag sowohl die Kopf als auch die Positionsdaten
    für eine Serie
  *******************************************************************************/
    procedure lvs_c_serie_erzeugen (
        in_sid                in lvs_serie_id_kopf.sid%type,
        in_firma_nr           in lvs_serie_id_kopf.firma_nr%type,
        in_leitzahl           in lvs_serie_id_kopf.leitzahl%type,
        in_leitzahl_extern    in lvs_serie_id_kopf.abnr%type,
        in_id_maske           in lvs_serie_id_kopf.serie_maske%type,
        in_externe_id_maske   in lvs_serie_id_kopf.serie_extern_maske%type,
        in_start_id           in lvs_serie_id_kopf.serie_start_id%type,
        in_start_externe_id   in lvs_serie_id_kopf.serie_extern_start_id%type,
        in_serie_gen_richtung in lvs_serie_id_kopf.serie_gen_richtung%type
    ) is

        v_serie_id     lvs_serie_id_kopf.serie_id%type;
        v_chk_serie_id lvs_serie_id_kopf.serie_id%type;
        v_found        boolean;
        cursor c_chk_serie is
        select
            sidk.serie_id
        from
                 lvs_serie_id_kopf sidk
            join lvs_serie_id_pos sidp on sidp.serie_id = sidk.serie_id
        where
            sidk.leitzahl = in_leitzahl
            or sidk.abnr = in_leitzahl_extern
        group by
            sidk.serie_id;

    begin
        reset_isi_error;
        open c_chk_serie;
        fetch c_chk_serie into v_chk_serie_id;
        v_found := c_chk_serie%found;
        close c_chk_serie;
        if not v_found then
            lvs_serie_id_kopf_erzeugen(in_sid, in_firma_nr, in_leitzahl, in_leitzahl_extern, in_id_maske,
                                       in_externe_id_maske, in_start_id, in_start_externe_id, in_serie_gen_richtung, v_serie_id);

            lvs_serie_id_pos_erzeugen(in_sid, in_firma_nr, v_serie_id);
            commit;
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end lvs_c_serie_erzeugen;

  /*******************************************************************************
  function GET_NEXT_SERIE_NR_BY_FA (...)
    Holte die nächste freie Serien Nummer für einen Fertigungsauftrag. Eine Seriennummer
    ist dann Verfügbar, wenn keine LAM_ID eingetragen. Die Funktion setzt gleichzeitig die
    übergeben LAM ID in die Serie. Als Ergebnis wird die Seriennummer zurück gegeben.
  *******************************************************************************/
    function get_next_serie_nr_by_fa (
        in_sid      in lvs_serie_id_kopf.sid%type,
        in_firma_nr in lvs_serie_id_kopf.firma_nr%type,
        in_leitzahl in lvs_serie_id_kopf.leitzahl%type,
        in_lam_id   in lvs_lam.lam_id%type,
        in_login_id in lvs_serie_id_pos.last_change_login_id%type
    ) return varchar2 is

        v_serie_id lvs_serie_id_kopf.serie_id%type;
        v_result   lvs_serie_id_pos.serie_nr%type;
        v_found    boolean;
        cursor chk_lam_on_serie is
        select
            sidp.serie_nr
        from
            lvs_serie_id_pos sidp
        where
                sidp.sid = in_sid
            and sidp.firma_nr = in_firma_nr
            and sidp.lam_id = in_lam_id;

        cursor get_serie_id is
        select
            sidk.serie_id
        from
            lvs_serie_id_kopf sidk
        where
                sidk.sid = in_sid
            and sidk.firma_nr = in_firma_nr
            and sidk.leitzahl = in_leitzahl;

        cursor get_next_serien_nr is
        select
            sidp.serie_nr
        from
            lvs_serie_id_pos sidp
        where
                sidp.sid = in_sid
            and sidp.firma_nr = in_firma_nr
            and sidp.serie_id = v_serie_id
            and sidp.serie_pos_lfdn = (
                select
                    min(x.serie_pos_lfdn)
                from
                    lvs_serie_id_pos x
                where
                        x.sid = in_sid
                    and x.firma_nr = in_firma_nr
                    and x.serie_id = v_serie_id
                    and x.lam_id is null
            );

    begin
        reset_isi_error;
        if in_lam_id is null then
            raise_isi_error(10, 'Keine LAM ID gesetzt');
        end if;
        open chk_lam_on_serie;
        fetch chk_lam_on_serie into v_result;
        v_found := chk_lam_on_serie%found;
        close chk_lam_on_serie;
        if v_found then
            raise_isi_error(20, 'LAM Id'
                                || in_lam_id
                                || ' wird bereits fuer Serie '
                                || v_result
                                || ' verwendet');
        end if;

        open get_serie_id;
        fetch get_serie_id into v_serie_id;
        v_found := get_serie_id%found;
        close get_serie_id;
        if not v_found then
            raise_isi_error(20, 'Serie Kopf fuer Leitzahl '
                                || in_leitzahl
                                || ' nicht gefunden');
        end if;

        open get_next_serien_nr;
        fetch get_next_serien_nr into v_result;
        v_found := get_next_serien_nr%found;
        close get_next_serien_nr;
        if not v_found then
            raise_isi_error(30, 'Keine freie Serie fuer Leitzahl '
                                || in_leitzahl
                                || '['
                                || v_serie_id
                                || '] nicht gefunden');
        end if;

        update lvs_serie_id_pos sidp
        set
            sidp.lam_id = in_lam_id,
            sidp.last_change_login_id = in_login_id
        where
                sidp.serie_id = v_serie_id
            and sidp.serie_nr = v_result;

        return ( v_result );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end get_next_serie_nr_by_fa;

  /*******************************************************************************
  function GET_SERIE_NR_EXT_BY_SERIE_NR (...)
    Holt basierend auf der Seriennummer die externe Seriennummer.
  *******************************************************************************/
    function get_serie_nr_ext_by_serie_nr (
        in_sid      in lvs_serie_id_kopf.sid%type,
        in_firma_nr in lvs_serie_id_kopf.firma_nr%type,
        in_serie_nr in lvs_serie_id_pos.serie_nr%type
    ) return varchar2 is

        v_result lvs_serie_id_pos.serie_nr%type;
        v_found  boolean;
        cursor c_get_serie_nr_ext is
        select
            sidp.serie_nr_extern
        from
            lvs_serie_id_pos sidp
        where
                sidp.sid = in_sid
            and sidp.firma_nr = in_firma_nr
            and sidp.serie_nr = in_serie_nr;

    begin
        reset_isi_error;
        open c_get_serie_nr_ext;
        fetch c_get_serie_nr_ext into v_result;
        v_found := c_get_serie_nr_ext%found;
        close c_get_serie_nr_ext;
        if not v_found then
            raise_isi_error(10, 'Serien Nr '
                                || in_serie_nr
                                || ' nicht gefunden');
        end if;

        return ( v_result );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end get_serie_nr_ext_by_serie_nr;

  /*******************************************************************************
  function GET_SERIE_NR_EXT_BY_SERIE_NR (...)
    Setzt die LAM Id der übergeben Seriennummer auf null. Damit ist sie wieder frei
    verfügbar
  *******************************************************************************/
    procedure reset_serie_nr (
        in_sid      in lvs_serie_id_kopf.sid%type,
        in_firma_nr in lvs_serie_id_kopf.firma_nr%type,
        in_serie_nr in lvs_serie_id_pos.serie_nr%type,
        in_login_id in lvs_serie_id_pos.last_change_login_id%type
    ) is
    begin
        reset_isi_error;
        update lvs_serie_id_pos sidp
        set
            sidp.lam_id = null,
            sidp.last_change_login_id = in_login_id
        where
                sidp.sid = in_sid
            and sidp.firma_nr = in_firma_nr
            and sidp.serie_nr = in_serie_nr;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end reset_serie_nr;

end lvs_serie;
/


-- sqlcl_snapshot {"hash":"d2f852d96c311d8e1d0037290375242ec300a3ba","type":"PACKAGE_BODY","name":"LVS_SERIE","schemaName":"DIRKSPZM32","sxml":""}