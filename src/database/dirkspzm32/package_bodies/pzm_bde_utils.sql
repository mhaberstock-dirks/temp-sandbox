create or replace package body dirkspzm32.pzm_bde_utils is

    v_build_number constant number := 1;
  /*
   *  Build history
   *  date       | version    | info
   *  ---------------------------------------------------------------------------------
   *  13.11.2024 | 5.5.11.1   | (-AG-) package created
   */
    v_error exception;
    v_err_nr       number;
    v_err_text     varchar2(255);

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

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
    function get_release return varchar2 is
    begin
        return ( v_release_str );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_version return varchar2 is
    begin
        return ( to_char(v_release_major)
                 || '.'
                 || to_char(v_release_minor)
                 || '.'
                 || to_char(v_revision)
                 || '.'
                 || to_char(v_build_number)
                 || ' / ' || v_rev_date );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    procedure get_version_ex (
        out_rel_major   out number,
        out_rel_minor   out number,
        out_revision    out number,
        out_buid_number out number,
        out_rev_date    out varchar2
    ) is
    begin
        out_rel_major := v_release_major;
        out_rel_minor := v_release_minor;
        out_revision := v_revision;
        out_buid_number := v_build_number;
        out_rev_date := v_rev_date;
    end;

  /******************************************************************************************************
   * private functions
   ******************************************************************************************************/

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_bde_zeiten_by_pers_nr (
        in_pers_nr     in pzm_ze_bde_zeiten.ze_bde_pers_nr%type,
        in_ts_datum    in pzm_ze_bde_zeiten.ze_bde_datum%type,
        in_leitzahl    in bde_fa_auftrag.leitzahl%type,
        in_fa_ag       in bde_fa_auftrag.fa_ag%type,
        in_fa_upos     in bde_fa_auftrag.fa_upos%type,
        out_bde_zeiten out pzm_ze_bde_zeiten%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_pzm_ze_bde_zeiten is
        select
            *
        from
            pzm_ze_bde_zeiten t
        where
                t.ze_bde_pers_nr = in_pers_nr
            and t.ze_bde_basis = 'BDE'
            and t.ze_bde_datum = nvl(in_ts_datum, t.ze_bde_datum)
            and t.ze_bde_leitzahl = nvl(in_leitzahl, t.ze_bde_leitzahl)
            and t.ze_bde_fa_ag = nvl(in_fa_ag, t.ze_bde_fa_ag)
            and t.ze_bde_fa_upos = nvl(in_fa_upos, t.ze_bde_fa_upos)
            and t.ze_bde_day_ist_ende is null
        order by
            t.ze_bde_datum desc;

    begin
        open c_pzm_ze_bde_zeiten;
        fetch c_pzm_ze_bde_zeiten into out_bde_zeiten;
        v_found := c_pzm_ze_bde_zeiten%found;
        close c_pzm_ze_bde_zeiten;
        return v_found;
    end;

    function close_bde_zeiten_by_pers_nr (
        in_pers_nr in pzm_ze_bde_zeiten.ze_bde_pers_nr%type,
        in_datum   in pzm_ze_bde_zeiten.ze_bde_day_ist_ende%type
    ) return boolean is
        v_return boolean;
    
    --v_bde_zeiten     pzm_ze_bde_zeiten%rowtype;
    begin
        update pzm_ze_bde_zeiten t
        set
            t.ze_bde_day_ist_ende = in_datum
        where
                t.ze_bde_pers_nr = in_pers_nr
            and t.ze_bde_basis = 'BDE'
            and t.ze_bde_day_ist_ende is null
            and t.ze_bde_day_ist_start < in_datum;

        v_return := true;
        return v_return;
    end;

    function start_zeit_fa_pers_nr (
        in_pers_nr  in isi_user.pers_nr%type,
        in_ts_datum in pzm_ze_bde_zeiten.ze_bde_datum%type,
        in_leitzahl in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_fa_upos  in bde_fa_auftrag.fa_upos%type,
        in_datum    in bde_fa_auftrag.termin_start_ist%type
    ) return number is
        v_result         number;
        v_found          boolean;
        v_bde_fa_auftrag bde_fa_auftrag%rowtype;
    --v_bde_zeiten                  pzm_ze_bde_zeiten%rowtype;
        v_personal       pzm_personal%rowtype;
    begin
        v_result := -1;               -- Fehler unbegründet

        if
            isi_allg.get_user_by_pers_nr(in_pers_nr, v_isi_user)
            and v_isi_user.login_id is not null
        then
            if isi_allg.c_get_firma_cfg_param(v_sid.sid,             -- in_sid,
             v_firma,               --  in_firma_nr,
             'PZM_BDE',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
             null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
             'CHECK_FA',            -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                              'PZM',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                               'T',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'BOOLEAN') = c.c_false -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
            or bde_p_base.get_fa_ag(v_isi_user.sid,      -- in_sid,
             v_isi_user.firma_nr, -- Firma immer 1
             in_leitzahl,         -- in bde_fa_auftrag.leitzahl%type,
             in_fa_ag,            -- in bde_fa_auftrag.fa_ag%type,
             in_fa_upos,          -- in bde_fa_auftrag.fa_upos%type,
                                    v_bde_fa_auftrag) then
                v_result := 0;
                if isi_allg.c_get_firma_cfg_param(v_isi_user.sid,      -- in_sid,
                 v_isi_user.firma_nr, -- Firma immer 1
                 'PZM_BDE',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
                 null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                 'BUCH_FA_IN_BDE',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                  'PZM',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                   'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                   'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                   'BOOLEAN') = c.c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                                   then
                    begin
                        bde_pd_prod_p_ag_b(v_isi_user.sid,      -- in_sid,
                         v_isi_user.firma_nr, -- Firma immer 1
                         in_leitzahl,         -- in bde_fa_auftrag.leitzahl%type,
                         in_fa_ag,            -- in bde_fa_auftrag.fa_ag%type,
                         in_fa_upos,          -- in bde_fa_auftrag.fa_upos%type,
                                           v_bde_fa_auftrag.res_id, null,                -- Akt Terminal
                                            v_isi_user.login_id);

                    exception
                        when others then
                            v_result := 3;     -- FA im BDE nicht zu buchen
                    end;

                else
                    v_found := close_bde_zeiten_by_pers_nr(v_isi_user.pers_nr, --in pzm_ze_bde_zeiten.ze_bde_pers_nr%type,
                     in_datum);          --in pzm_ze_bde_zeiten.ze_bde_day_ist_ende%type);
                    if not pzm_p_base.get_personal(in_pers_nr, v_personal) then
                        v_personal := null;
                        v_personal.pers_personalteilber := null;
                    end if;

                    begin
                        update bde_fa_auftrag t
                        set
                            t.freig_status = 'AP',
                            t.status_begin = in_datum,
                            t.termin_start_ist = nvl(t.termin_start_ist, in_datum)
                        where
                                t.leitzahl = in_leitzahl
                            and t.fa_ag = in_fa_ag
                            and t.fa_upos = in_fa_upos;

                    exception
                        when others then
                            v_result := 0;     -- FA im BDE nicht zu buchen, hier egal
                    end;

                    insert into pzm_ze_bde_zeiten (
                        ze_bde_pers_nr,
                        ze_bde_datum,
                        ze_bde_basis,
                        ze_bde_day_ist_start,
                        ze_bde_leitzahl,
                        ze_bde_fa_ag,
                        ze_bde_fa_upos,
                        ze_bde_zeit_min,
                        ze_bde_verbucht_status,
                        ze_bde_personalteilber,
                        created_login_id
                    ) values ( v_isi_user.pers_nr,
                               trunc(in_ts_datum),
                               'BDE',
                               in_datum,
                               in_leitzahl,
                               in_fa_ag,
                               in_fa_upos,
                               0,
                               'N',
                               v_personal.pers_personalteilber,
                               v_isi_user.login_id );

                end if;

            else
                v_result := 2;     -- FA-Fehlt
            end if;

        else
            v_result := 1; -- Transponder fehlt  in isi_user
        end if;

        return ( v_result );
    end;
  ---------------------------------------------------------------------------------------------------
    function c_start_zeit_fa_pers_nr (
        in_pers_nr  in isi_user.pers_nr%type,
        in_ts_datum in pzm_ze_bde_zeiten.ze_bde_datum%type,
        in_leitzahl in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_fa_upos  in bde_fa_auftrag.fa_upos%type,
        in_datum    in bde_fa_auftrag.termin_start_ist%type
    ) return number is
        v_result number;
    begin
        v_result := start_zeit_fa_pers_nr(in_pers_nr, in_ts_datum, in_leitzahl, in_fa_ag, in_fa_upos,
                                          in_datum);
        commit;
        return v_result;
    end;

  
  ---------------------------------------------------------------------------------------------------
  --
  ---------------------------------------------------------------------------------------------------
    function c_pzm_pers_nr_zeit_fa_buchen (
        in_pers_nr      in pzm_personal.pers_nr%type,
        in_sa_kurz_name in bde_pd_kopf.sa_kurzname%type,
        in_datum_beg    in bde_pd_kopf.pd_kopf_beginn%type,
        in_datum_ende   in bde_pd_kopf.pd_kopf_ende%type,
        in_zeit_std     in number,
        in_datum        in pzm_ze_tagessatz.ts_datum%type
    ) return number is
        v_result number;
    begin
        v_result := pzm_bde_utils.pzm_pers_nr_zeit_fa_buchen(in_pers_nr, in_sa_kurz_name, in_datum_beg, in_datum_ende, in_zeit_std,
                                                             in_datum);

        commit;
        return v_result;
    end;
  
  ---------------------------------------------------------------------------------------------------
  --
  ---------------------------------------------------------------------------------------------------
    function pzm_pers_nr_zeit_fa_buchen (
        in_pers_nr      in pzm_personal.pers_nr%type,
        in_sa_kurz_name in bde_pd_kopf.sa_kurzname%type,
        in_datum_beg    in bde_pd_kopf.pd_kopf_beginn%type,
        in_datum_ende   in bde_pd_kopf.pd_kopf_ende%type,
        in_zeit_std     in number,
        in_datum        in pzm_ze_tagessatz.ts_datum%type
    ) return number is

        v_result            number;
        v_found             boolean;
        v_found_bde         boolean;                            
    --v_bde_ok boolean;                            
        v_ts_minuten_faktor number;
        v_ts_stunden        number;
        v_bde_minuten_ges   number;
        v_personal          pzm_personal%rowtype;
        v_pzm_abt           pzm_abteilungen%rowtype;
    --v_bde_minuten_ts              number;

    --v_bde_fa_auftrag              bde_fa_auftrag%rowtype;
        v_bde_zeiten        pzm_ze_bde_zeiten%rowtype;
        v_bde_zeiten_open   pzm_ze_bde_zeiten%rowtype;
        v_start_str         varchar2(20);
        v_ende_str          varchar2(20);
        cursor c_pzm_ze_zeiten is     -- Zeiten die auf PZM in PZM_BDE gebucht sind ohne FA-Auftrag
        select
            *
        from
            pzm_ze_bde_zeiten t
        where
                t.ze_bde_pers_nr = in_pers_nr
            and t.ze_bde_datum = in_datum
            and ( ( t.ze_bde_day_ist_start >= in_datum_beg
                    and t.ze_bde_day_ist_start < in_datum_ende )
                  or ( t.ze_bde_day_ist_ende > in_datum_beg
                       and t.ze_bde_day_ist_ende <= in_datum_ende ) )
            and t.ze_bde_basis = 'PZM';

        cursor c_pzm_bde_ze_zeiten is
        select
            *
        from
            pzm_ze_bde_zeiten t
        where
                t.ze_bde_pers_nr = in_pers_nr
            and t.ze_bde_datum = in_datum
            and ( ( t.ze_bde_day_ist_start >= in_datum_beg
                    and t.ze_bde_day_ist_start < in_datum_ende )
                  or ( t.ze_bde_day_ist_ende > in_datum_beg
                       and t.ze_bde_day_ist_ende <= in_datum_ende )
                  or ( t.ze_bde_day_ist_start < in_datum_beg
                       and t.ze_bde_day_ist_ende > in_datum_ende ) )
            and t.ze_bde_basis = 'BDE';

        cursor c_abteilung is
        select
            *
        from
            pzm_abteilungen a
        where
            a.abt_id = v_personal.pers_abt_id;

    begin
        if isi_allg.get_user_by_pers_nr(in_pers_nr, v_isi_user) then
            if isi_allg.c_get_firma_cfg_param(v_isi_user.sid,      -- in_sid,
             v_isi_user.firma_nr, -- Firma immer 1
             'PZM_BDE',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
             null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
             'BUCH_FA_IN_BDE',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                              'PZM',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                               'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'BOOLEAN') = c.c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                               then
                begin
           -- Nicht implementiert
           /*
          if bde_p_base.get_fa_ag(v_isi_user.sid,      -- in_sid,
                                  v_isi_user.firma_nr, -- Firma immer 1
                                  in_leitzahl,         -- in bde_fa_auftrag.leitzahl%type,
                                  in_fa_ag,            -- in bde_fa_auftrag.fa_ag%type,
                                  in_fa_upos,          -- in bde_fa_auftrag.fa_upos%type,
                                  v_bde_fa_auftrag)
          then
            NULL;
          else
          */
                    v_result := 3;     -- FA im BDE nicht zu buchen -- Nicht implementiert
          --end if;
                exception
                    when others then
                        v_result := 3;     -- FA im BDE nicht zu buchen
                end;
            else
                v_found_bde := get_bde_zeiten_by_pers_nr(in_pers_nr, in_datum, null, null, null,
                                                         v_bde_zeiten_open);

        -- Durchlauf gebuchte Daten für den Tagessatz löschen und aus dem BDE-Satz die Minuten reduzieren
                open c_pzm_ze_zeiten;
                fetch c_pzm_ze_zeiten into v_bde_zeiten;
                v_found := c_pzm_ze_zeiten%found;
                if v_found then
                    update bde_fa_auftrag t
                    set
                        t.prod_zeit_ist = t.prod_zeit_ist - nvl(v_bde_zeiten.ze_bde_zeit_min, 0)
                    where
                            t.leitzahl = v_bde_zeiten.ze_bde_leitzahl
                        and t.fa_ag = v_bde_zeiten.ze_bde_fa_ag
                        and t.fa_upos = v_bde_zeiten.ze_bde_fa_upos;

                    update pzm_ze_bde_zeiten t -- Gebuchte Zeiten aus dem Satz nehmen
                    set
                        t.ze_bde_zeit_min = 0, -- round(t.ze_bde_zeit_min - v_bde_zeiten.ze_bde_zeit_min, 0)
                        t.ze_bde_status_text =
                            case
                                when t.ze_bde_verbucht_status = 'UE' then
                                    substr('OldMin.='
                                           || to_char(t.ze_bde_zeit_min)
                                           || ' '
                                           || t.ze_bde_status_text,
                                           1,
                                           255)
                                else
                                    t.ze_bde_status_text
                            end
                    where
                            t.ze_bde_pers_nr = v_bde_zeiten.ze_bde_pers_nr
                        and t.ze_bde_datum = v_bde_zeiten.ze_bde_datum
                        and t.ze_bde_basis = 'BDE';

                    delete pzm_ze_bde_zeiten t
                    where
                            t.ze_bde_pers_nr = v_bde_zeiten.ze_bde_pers_nr
                        and t.ze_bde_datum = v_bde_zeiten.ze_bde_datum
                        and t.ze_bde_basis = 'PZM';

                end if;

                close c_pzm_ze_zeiten;
        -- Ende - Durchlauf gebuchte Daten für den Tagessatz löschen
                update pzm_ze_bde_zeiten t
                set
                    t.ze_bde_day_ist_ende = in_datum_ende
                where
                        t.ze_bde_pers_nr = in_pers_nr
                    and t.ze_bde_basis = 'BDE'
                    and t.ze_bde_datum = in_datum
                    and t.ze_bde_day_ist_start < in_datum_ende
                    and t.ze_bde_day_ist_ende is null;
        
        -- Durchlauf buche Zeiten für den Tagessatz im BDE-Satz
                v_ts_stunden := ( in_datum_ende - in_datum_beg ) * 24; -- In Stunden
                if nvl(v_ts_stunden, 0) = 0 then
                    v_ts_stunden := in_zeit_std;            -- Start_ende falsch
                end if;
                if v_ts_stunden > 0 then
                    v_ts_minuten_faktor := ( in_zeit_std    -- TS Zeit in Stunden
                     / v_ts_stunden );-- gesamtzeit des TS-Satz
                else
                    v_ts_minuten_faktor := 1;
                end if;

                open c_pzm_bde_ze_zeiten;
                loop
                    fetch c_pzm_bde_ze_zeiten into v_bde_zeiten;
                    v_found := c_pzm_bde_ze_zeiten%found;
                    exit when not v_found;
                    if v_bde_zeiten.ze_bde_day_ist_ende <= v_bde_zeiten.ze_bde_day_ist_start
                    or v_bde_zeiten.ze_bde_day_ist_ende = null then
                        v_bde_zeiten.ze_bde_day_ist_ende := in_datum_ende;
                    end if;

                    v_bde_minuten_ges := ( (
                        case
                            when nvl(v_bde_zeiten.ze_bde_day_ist_ende, in_datum_ende) >= in_datum_ende then
                                in_datum_ende
                            else
                                nvl(v_bde_zeiten.ze_bde_day_ist_ende, in_datum_ende)
                        end
                        -
                        case
                            when v_bde_zeiten.ze_bde_day_ist_start >= in_datum_beg then
                                v_bde_zeiten.ze_bde_day_ist_start
                            else
                                in_datum_beg
                        end                                               -- korrekten Startzeitpunkt ermitteln          
                    ) * 1440                                                    -- In Minuten
                     ) * v_ts_minuten_faktor;                                   -- In Anteil der TS-Minuten der gesamten Zeit

                    v_start_str := to_char(v_bde_zeiten.ze_bde_day_ist_start, 'dd.mm.yyyy hh24:mi_ss');
                    v_ende_str := to_char(v_bde_zeiten.ze_bde_day_ist_ende, 'dd.mm.yyyy hh24:mi_ss');
                    update bde_fa_auftrag t
                    set
                        t.prod_zeit_ist = t.prod_zeit_ist + v_bde_minuten_ges,
                        t.status_begin = in_datum,
                        t.termin_ende_ist = v_bde_zeiten.ze_bde_day_ist_ende,
                        t.freig_status = 'F'
                    where
                            t.leitzahl = v_bde_zeiten.ze_bde_leitzahl
                        and t.fa_ag = v_bde_zeiten.ze_bde_fa_ag
                        and t.fa_upos = v_bde_zeiten.ze_bde_fa_upos;

                    update pzm_ze_bde_zeiten t -- Gebuchte Zeiten aus dem Satz nehmen
                    set
                        t.ze_bde_zeit_min = nvl(v_bde_minuten_ges, 0),
                        t.ze_bde_day_ist_ende = v_bde_zeiten.ze_bde_day_ist_ende,
                        t.ze_bde_sa_kurzname = in_sa_kurz_name--,
                 --t.ze_bde_verbucht_status = 'N' -- 'U' AG Erst mal auf N lassen, damit im Nachgang freigegeben werden kann
                    where
                            t.ze_bde_pers_nr = v_bde_zeiten.ze_bde_pers_nr
                        and t.ze_bde_leitzahl = v_bde_zeiten.ze_bde_leitzahl
                        and t.ze_bde_fa_ag = v_bde_zeiten.ze_bde_fa_ag
                        and t.ze_bde_fa_upos = v_bde_zeiten.ze_bde_fa_upos
                        and t.ze_bde_day_ist_start < v_bde_zeiten.ze_bde_day_ist_ende
                        and ( ( t.ze_bde_day_ist_start = v_bde_zeiten.ze_bde_day_ist_start
                                or nvl(t.ze_bde_day_ist_ende, in_datum_ende) = v_bde_zeiten.ze_bde_day_ist_ende )
--               or (t.ze_bde_day_ist_ende > in_datum_beg 
--                   and t.ze_bde_day_ist_ende <= in_datum_ende)
--               or (t.ze_bde_day_ist_start < in_datum_beg 
--                   and t.ze_bde_day_ist_ende > in_datum_ende)
                                 )
                        and t.ze_bde_basis = 'BDE';

                    if not pzm_p_base.get_personal(in_pers_nr, v_personal) then
                        v_personal := null;
                        v_personal.pers_personalteilber := null;
                    end if;

                    if v_bde_zeiten.ze_bde_day_ist_start < v_bde_zeiten.ze_bde_day_ist_ende then
                        insert into pzm_ze_bde_zeiten (
                            ze_bde_pers_nr,
                            ze_bde_datum,
                            ze_bde_basis,
                            ze_bde_day_ist_start,
                            ze_bde_day_ist_ende,
                            ze_bde_sa_kurzname,
                            ze_bde_leitzahl,
                            ze_bde_fa_ag,
                            ze_bde_fa_upos,
                            ze_bde_zeit_min,
                            ze_bde_verbucht_status,
                            ze_bde_verbucht_datum,
                            ze_bde_ret_code,
                            ze_bde_status_text,
                            ze_bde_personalteilber,
                            created_login_id
                        ) values ( v_bde_zeiten.ze_bde_pers_nr,
                                   in_datum,
                                   'PZM',
                                   case
                                       when v_bde_zeiten.ze_bde_day_ist_start >= in_datum_beg then
                                           v_bde_zeiten.ze_bde_day_ist_start
                                       else
                                           in_datum_beg
                                   end,                                -- korrekten Startzeitpunkt ermitteln
                                   nvl(v_bde_zeiten.ze_bde_day_ist_ende, in_datum_ende),
                                   in_sa_kurz_name,
                                   v_bde_zeiten.ze_bde_leitzahl,
                                   v_bde_zeiten.ze_bde_fa_ag,
                                   v_bde_zeiten.ze_bde_fa_upos,
                                   round(v_bde_minuten_ges, 0),
                                   'UE',
                                   sysdate,
                                   0,
                                   'PZM INTERN PZM -> BDE Transfer - success',
                                   v_personal.pers_personalteilber,
                                   v_isi_user.login_id );

                    end if;

                end loop;

                close c_pzm_bde_ze_zeiten;
        -- Ende - Durchlauf gebuchte Daten für den Tagessatz löschen
                v_result := 0;
                if v_found_bde then
                    open c_abteilung;
                    fetch c_abteilung into v_pzm_abt;
                    v_found := c_abteilung%found;
                    close c_abteilung;
                    if
                        v_found
                        and v_pzm_abt.abt_pzm_bde_typ_continue = c.c_true
                    then
                        v_result := start_zeit_fa_pers_nr(v_bde_zeiten_open.ze_bde_pers_nr, sysdate, v_bde_zeiten_open.ze_bde_leitzahl
                        , v_bde_zeiten_open.ze_bde_fa_ag, v_bde_zeiten_open.ze_bde_fa_upos,
                                                          sysdate);
                    end if;

                end if;

            end if;
        else
            v_result := 1; -- Personalnummer fehlt in isi_user
        end if;

        return v_result;
    end;
  
  ----------------------------------------------------------------------------------------
  -- Verbuchen der Tagessätze für diesen Schinchtag im BDE
  ----------------------------------------------------------------------------------------
    function c_pzm_ze_tagessatz_buchen (
        in_datum in pzm_ze_tagessatz.ts_datum%type
    ) return number is

        v_result       number;
        v_ts_result    number;
        v_found        boolean;
        v_ze_tagessatz pzm_ze_tagessatz%rowtype;
        cursor c_ze_tagessatz is
        select
            *
        from
            pzm_ze_tagessatz t
        where
            t.ts_datum = trunc(in_datum);

    begin
        if isi_allg.c_get_firma_cfg_param(v_isi_user.sid,      -- in_sid,
         v_isi_user.firma_nr, -- Firma immer 1
         'PZM_BDE',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'BUCH_FA_IN_BDE',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                          'PZM',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                           'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                           'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                           'BOOLEAN') = c.c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                           then -- Das ist in diesem Modus nicht möglich
            v_result := 3;     -- FA im BDE nicht zu buchen
        else
            v_result := 0;     -- Erst mal OK
            open c_ze_tagessatz;
            loop
                fetch c_ze_tagessatz into v_ze_tagessatz;
                v_found := c_ze_tagessatz%found;
                exit when not v_found;
                if v_ze_tagessatz.ts_pers_nr = 9100000700 then
                    v_ze_tagessatz.ts_pers_nr := v_ze_tagessatz.ts_pers_nr;
                end if;

                if v_ze_tagessatz.ts_day_arb_std + v_ze_tagessatz.ts_day_ueb_std + v_ze_tagessatz.ts_day_flex_std > 0 then
                    v_ts_result := pzm_bde_utils.c_pzm_pers_nr_zeit_fa_buchen(v_ze_tagessatz.ts_pers_nr,         -- => :in_pers_nr,
                     v_ze_tagessatz.ts_sa_kurzname,     -- => :in_sa_kurz_name,
                     v_ze_tagessatz.ts_day_wert_start,  -- => :in_datum_beg,
                     v_ze_tagessatz.ts_day_wert_ende - v_ze_tagessatz.ts_day_abw_std / 24,   -- => :in_datum_ende,
                     v_ze_tagessatz.ts_day_arb_std + v_ze_tagessatz.ts_day_ueb_std + v_ze_tagessatz.ts_day_flex_std,     -- => in_zeit_min => :in_zeit_min,
                                                                              v_ze_tagessatz.ts_datum);          -- => :in_datum);
                else
                    update pzm_ze_bde_zeiten t                                -- Wenn keine Anmeldung, dann wird der Satz geschlossen (Urlaub, Krank, ...)
                    set
                        t.ze_bde_day_ist_ende = t.ze_bde_day_ist_start,
                        t.ze_bde_verbucht_status = 'N' -- 'U' Erst mal auf U damit im Nachgang Freigegeben werden kann
                    where
                            t.ze_bde_pers_nr = v_ze_tagessatz.ts_pers_nr
                        and t.ze_bde_basis = 'BDE'
                        and t.ze_bde_datum = in_datum
                        and t.ze_bde_day_ist_ende is null;

                end if;

                if v_ts_result != 0 then
                    v_result := v_ts_result;                                -- Wenn nicht OK, dann result merken
                end if;
            end loop;

            close c_ze_tagessatz;
        end if;

        commit;
        return v_result;
    end;

begin
    open c_sid;
    fetch c_sid into v_sid;
    v_sid_found := c_sid%found;
    close c_sid;
    v_firma := 1;
    if not v_sid_found then
        v_sid.sid := '01';
    end if;
end;
/


-- sqlcl_snapshot {"hash":"d909a303de4f8205aa8eefd07873dc99fa775b48","type":"PACKAGE_BODY","name":"PZM_BDE_UTILS","schemaName":"DIRKSPZM32","sxml":""}