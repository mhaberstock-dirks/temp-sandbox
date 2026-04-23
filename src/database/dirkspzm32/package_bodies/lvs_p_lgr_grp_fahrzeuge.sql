create or replace package body dirkspzm32.lvs_p_lgr_grp_fahrzeuge is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
    v_found    boolean;


  -- Function and procedure implementations
    function check_fahrzeug (
        in_fahrzeug         in lvs_fahrzeuge%rowtype,
        in_lgr              in lvs_lgr%rowtype,
        in_check_endgueltig in boolean,
        in_fah_text         in varchar2
    ) return varchar2 is
        v_fahrzeug_max_trans_lte lvs_fahrzeuge.max_trans_lte%type;
        v_fah_text               varchar2(255);
    begin
        v_fah_text := in_fah_text;
      -- Wenn max_trans_fahrzeuge = 0 dann unbegrenzt erlaubt
        if in_fahrzeug.max_trans_lte = 0 then
            v_fahrzeug_max_trans_lte := in_fahrzeug.akt_trans_lte + 1;
        else
            v_fahrzeug_max_trans_lte := in_fahrzeug.max_trans_lte;
        end if;

        if in_fahrzeug.fahrzeug_ok <> c.c_true -- Fahrzeug ist OK

         then
            if
                in_fahrzeug.fahrzeug_ok = '?'
                and in_fahrzeug.anz_test_lte > 0
            then
                v_fah_text := null;
            else
        -- Jetzt kommt nur nocht 'F'alse und 'M'anuell ausgeschaltet
                if in_fahrzeug.fahrzeug_ok = 'M' -- 'M'anuell auf defekt gestellt (Keine Paletten da hin schicken
                or in_fahrzeug.fahrzeug_ok = 'F'
                or in_fahrzeug.fahrzeug_ok = '?'
                or v_fahrzeug_max_trans_lte < in_fahrzeug.akt_trans_lte + 1 then
                    v_fah_text := lc.ec_p2(lc.o_tp2_lgr_platz_kein_fahrzeug, in_lgr.lgr_platz, in_fahrzeug.fahrzeug_ok);
          -- v_fah_text := 'Lagerplatz: <' || in_lgr.lgr_platz || '> ist nicht zu erreichen. Fahrzeug ist gestört mit status <'  || in_fahrzeug.fahrzeug_ok || '>.';
                else
                    v_fah_text := null;
                end if;
            end if;
        else
      -- Maximale Anzahl der Paletten prüfen wenn schon Fahrzeuge genannt sind,
      -- Falls noch keine Fahrzeuge genannt sind, dann können in der Zwischenzeit
      -- die Transporte verringert werden (Abgearbeitet)
            if
                v_fahrzeug_max_trans_lte < in_fahrzeug.akt_trans_lte + 1
                and in_check_endgueltig is not null
            then
                v_fah_text := lc.ec_p1(lc.o_tp1_lgr_platz_fahrzeug_max, in_lgr.lgr_platz);
        -- v_fah_text := 'Lagerplatz: <' || in_lgr.lgr_platz || '> ist nicht zu erreichen. Maximale anzahl Einlagertransporte überschritten.';
            else
                v_fah_text := null;
            end if;
        end if;

        return ( v_fah_text );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
      -- rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
      -- rollback;
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
    end;

  /*-------------------------------------------------------------------------
  -- Function ermittelt, dieser Platz mit einem Fahrzeug aud der Liste
  -- in_fahrzeuge_IDs erreichbar ist. Die ID's sint RES_ID's aus der ISI_Resource
  -- !!!!!!Achtung: Die Liste der Fahrzeuge muss mit einem ';' beginnen!!!!!!!
  -- Wenn der Übergabeparameter NULL ist, dann dürfen alle Fahrzeuge fahren
  -- Rückgabe:
  --    v_fah_text        NULL -> Alles OK, kein Fehler
  --                  NOT NULL -> Fehlertext als Klartext
  -------------------------------------------------------------------------*/
    function chk_lgr_leit_zugriff_ok (
        in_lgr              in lvs_lgr%rowtype,
        in_check_endgueltig in boolean,
        in_fah_text         in varchar2
    ) return varchar2 is

        v_ort            lvs_lgr_ort%rowtype;
        v_fah_text       varchar2(255);
        v_fahrzeug       lvs_fahrzeuge%rowtype;
        v_fahrzeug_ls_id lvs_fahrzeuge_ls_id.stapler_ls_id%type;
        cursor c_fahrzeug is
        select
            *
        from
            lvs_fahrzeuge fah
        where
            nvl(fah.stapler_ls_id,
                nvl(v_ort.stapler_ls_id, -1)) = nvl(v_ort.stapler_ls_id, -1)
            or exists (
                select
                    *
                from
                    lvs_fahrzeuge_ls_id x
                where
                        x.res_id = fah.res_id
                    and x.stapler_ls_id = nvl(v_ort.stapler_ls_id, -1)
            );

        cursor c_ort is
        select
            *
        from
            lvs_lgr_ort ort
        where
                ort.sid = in_lgr.sid
            and ort.lgr_ort_modul != 'MFR'        -- Beim MFR kann keine Stapler genutzt werden
            and ort.firma_nr = in_lgr.firma_nr
            and ort.lgr_ort = in_lgr.lgr_ort;

        cursor c_fahrzeug_ls_id is
        select
            ls.stapler_ls_id
        from
            lvs_fahrzeuge_ls_id ls
        where
                ls.res_id = v_fahrzeug.res_id
            and ls.stapler_ls_id = nvl(v_ort.stapler_ls_id, -1);

    begin
        v_fah_text := in_fah_text;
        open c_ort;
        fetch c_ort into v_ort;
        v_found := c_ort%found;
        close c_ort;
        if
            in_lgr.lgr_gruppe_id is null
            and v_ort.stapler_ls_id is null
        then
            v_fah_text := null;
        end if;

        if v_found then
            open c_fahrzeug;
            fetch c_fahrzeug into v_fahrzeug;
            v_found := c_fahrzeug%found;
            loop
                exit when not v_found;
                open c_fahrzeug_ls_id;
                fetch c_fahrzeug_ls_id into v_fahrzeug_ls_id;
                close c_fahrzeug_ls_id;
                v_fahrzeug.stapler_ls_id := nvl(v_fahrzeug.stapler_ls_id, v_fahrzeug_ls_id);
                if v_fahrzeug.stapler_ls_id is not null then
                    v_fah_text := check_fahrzeug(v_fahrzeug, in_lgr, in_check_endgueltig, v_fah_text);
                    exit when v_fah_text is null;
                end if;

                fetch c_fahrzeug into v_fahrzeug;
                v_found := c_fahrzeug%found;
            end loop;

            close c_fahrzeug;
        end if;

        return ( v_fah_text );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
      -- rollback;
            if c_ort%isopen then
                close c_ort;
            end if;
            if c_fahrzeug%isopen then
                close c_fahrzeug;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
      -- rollback;
            if c_ort%isopen then
                close c_ort;
            end if;
            if c_fahrzeug%isopen then
                close c_fahrzeug;
            end if;
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

    end;

  /*-------------------------------------------------------------------------
  -- Function ermittelt, dieser Platz mit einem Fahrzeug erreichbar ist.
  -- Rückgabe:
  --    OK            True  -> Alles OK, kein Fehler
  --                  False -> Fehlertext als Klartext
  -------------------------------------------------------------------------*/
    function chk_lgr_platz_zugriff_ok (
        in_lgr_platz in lvs_lgr.lgr_platz%type
    ) return varchar2 is

        v_fah_text      varchar2(255);
        v_lgr           lvs_lgr%rowtype;
        v_lte           lvs_lte%rowtype;
        v_fahrzeuge_ids varchar2(255);
    begin
  -- Call the function
        v_lte := null;
        v_fah_text := null;
        if lvs_p_base.get_lgr_platz(in_lgr_platz, v_lgr) then
            v_fah_text := lvs_p_lgr_grp_fahrzeuge.chk_lgr_grp_zugriff_ok(v_lgr, v_lte, v_fahrzeuge_ids);
        end if;

        if v_fah_text is null then
            return ( c.c_true );
        else
            return ( c.c_false );
        end if;

    end;

  /*-------------------------------------------------------------------------
  -- Function ermittelt, dieser Platz mit einem Fahrzeug aud der Liste
  -- in_fahrzeuge_IDs erreichbar ist. Die ID's sint RES_ID's aus der ISI_Resource
  -- !!!!!!Achtung: Die Liste der Fahrzeuge muss mit einem ';' beginnen!!!!!!!
  -- Wenn der Übergabeparameter NULL ist, dann dürfen alle Fahrzeuge fahren
  -- Rückgabe:
  --    v_fah_text        NULL -> Alles OK, kein Fehler
  --                  NOT NULL -> Fehlertext als Klartext
  -------------------------------------------------------------------------*/

    function chk_lgr_grp_zugriff_ok (
        in_lgr           in lvs_lgr%rowtype,
        in_lte           in lvs_lte%rowtype,
        in_fahrzeuge_ids in varchar2
    ) return varchar2 is

        v_lgr_grp_fahrzeug lvs_lgr_grp_fahrzeug%rowtype;
        v_fahrzeug         lvs_fahrzeuge%rowtype;
        v_check_endgueltig boolean;
        v_fah_text         varchar2(255);
        cursor c_fahrzeug is
        select
            *
        from
            lvs_fahrzeuge fah
        where
            fah.res_id = v_lgr_grp_fahrzeug.res_id;

        cursor c_lgr_grp_fahrzeug is
        select
            *
        from
            lvs_lgr_grp_fahrzeug grf
        where
                grf.lgr_gruppe_id = in_lgr.lgr_gruppe_id
            and grf.lgr_ort = in_lgr.lgr_ort
            and nvl(in_fahrzeuge_ids, ';'
                                      || grf.res_id
                                      || ';') like ( '%;'
                                                     || grf.res_id || ';%' );

    begin
    -- Erst mal kein Fehler
        v_fah_text := nvl(v_g_fah_text,
                          lc.ec_p1(lc.o_tp1_lgr_platz_kein_fahrz_erf, in_lgr.lgr_platz));
    -- v_fah_text := nvl (v_g_fah_text, 'Kein Fahrzeug für Lagerplatz <' || in_lgr.lgr_platz || '> gefunden.');
        v_err_nr := null;
        if in_fahrzeuge_ids is null then
            v_fah_text := null;
        end if;
        if in_lte.ziel_lgr_platz = in_lgr.lgr_platz -- LTE-Ziel gleich diesem Lagerplatz dann kann das nur noch die Pruefung sein ob der Platz erreichbar ist
        or (
            in_fahrzeuge_ids is not null           -- Liste der Fahrzeuge ist mitgegeben
            and in_lte.lgr_platz is not null
        )          -- und Transport für diese Palette existiert schon, dann endgültig Prüfen
         then
            v_check_endgueltig := true;
        else
            v_check_endgueltig := false;
        end if;

    -- Erster Versuch geht über die Lager-Gruppen -> Fahrzeug
        open c_lgr_grp_fahrzeug;
        fetch c_lgr_grp_fahrzeug into v_lgr_grp_fahrzeug;
        loop
            exit when c_lgr_grp_fahrzeug%notfound;
            v_fah_text := nvl(v_g_fah_text,
                              lc.ec_p1(lc.o_tp1_lgr_platz_kein_fahrz_erf, in_lgr.lgr_platz));

            open c_fahrzeug;
            fetch c_fahrzeug into v_fahrzeug;
            v_found := c_fahrzeug%found;
            close c_fahrzeug;
            if v_found then
                v_fah_text := check_fahrzeug(v_fahrzeug, in_lgr, v_check_endgueltig, v_fah_text);
            end if;

            exit when v_fah_text is null;
            fetch c_lgr_grp_fahrzeug into v_lgr_grp_fahrzeug;
        end loop;

        close c_lgr_grp_fahrzeug;

    -- Über die Lagergruppen wurde kein funktionierendes Fahrzeug gefunden
    -- Jetzt noch schauen ob für diesen Lagerort Fahrzeuge über die LeitID zu finden sind
        if v_fah_text is not null then
            v_fah_text := chk_lgr_leit_zugriff_ok(in_lgr,              -- in_lgr              in   lvs_lgr%rowtype,
             v_check_endgueltig,  -- in_check_endgueltig in   boolean
             v_fah_text);
        end if;
    --if v_fah_text is NULL
    --then
    --  v_fahrzeuge_tab(v_fahrzeug.res_id) := TRUE;
    --end if;

        v_g_fah_text := v_fah_text;
        return ( v_fah_text );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
      -- rollback;
            if c_fahrzeug%isopen then
                close c_fahrzeug;
            end if;
            if c_lgr_grp_fahrzeug%isopen then
                close c_lgr_grp_fahrzeug;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
      -- rollback;
            if c_fahrzeug%isopen then
                close c_fahrzeug;
            end if;
            if c_lgr_grp_fahrzeug%isopen then
                close c_lgr_grp_fahrzeug;
            end if;
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

    end;

    function lgr_grp_fuellgrad (
        in_sid               in isi_sid.sid%type,
        in_firma_nr          in isi_firma.firma_nr%type,
        in_lgr_ort           in lvs_lgr_ort.lgr_ort%type,
        in_lgr_gruppe_id     in lvs_lgr.lgr_gruppe_id%type,
        in_ref_lgr_ort       in lvs_lgr_ort.lgr_ort%type,
        in_ref_lgr_gruppe_id in lvs_lgr.lgr_gruppe_id%type,
        in_res_string        in lvs_lte.res_string%type
    ) return number is

        v_gruppe_haupt_grp     lvs_lgr_grp.lgr_gruppe_haupt_grp%type;
        v_ref_gruppe_haupt_grp lvs_lgr_grp.lgr_gruppe_haupt_grp%type;
        v_anz_res_lte          number;
        v_max_grp_lte          number;
        v_fuellgrad            number;
        v_lgr_ort              lvs_lgr_ort.lgr_ort%type;
        v_lgr_gruppe_id        lvs_lgr_grp.lgr_gruppe_id%type;
        cursor c_lgr_gruppe_haupt_grp is
        select
            grp.lgr_gruppe_haupt_grp
        from
            lvs_lgr_grp grp
        where
                grp.lgr_ort = v_lgr_ort
            and grp.lgr_gruppe_id = v_lgr_gruppe_id;

        cursor c_lgr_haupt_grp_lte_res is
        select
            nvl(
                sum(lgr.lgr_akt_te),
                0
            ) + nvl(
                sum(lgr.lgr_dispo_einl_te),
                0
            ) lgr_res
        from
            lvs_lgr lgr
        where
                lgr.sid = in_sid
            and lgr.firma_nr = in_firma_nr
            and lgr.lgr_ort = in_lgr_ort
            and lgr.res_string = in_res_string
            and lgr.lgr_gruppe_id in (
                select
                    grp.lgr_gruppe_id
                from
                    lvs_lgr_grp grp
                where
                        grp.lgr_ort = in_lgr_ort
                    and grp.lgr_gruppe_haupt_grp = v_gruppe_haupt_grp
            );

        cursor c_lgr_grp_lte_res is
        select
            nvl(
                sum(lgr.lgr_akt_te),
                0
            ) + nvl(
                sum(lgr.lgr_dispo_einl_te),
                0
            ) lgr_res
        from
            lvs_lgr lgr
        where
                lgr.sid = in_sid
            and lgr.firma_nr = in_firma_nr
            and lgr.lgr_ort = in_lgr_ort
            and lgr.lgr_gruppe_id = in_lgr_gruppe_id
            and lgr.res_string = in_res_string;

        cursor c_lvs_lgr_haupt_grp is
        select
            sum(grp.lgr_gruppe_max_lte)
        from
            lvs_lgr_grp grp
        where
                grp.lgr_ort = in_lgr_ort
            and grp.lgr_gruppe_haupt_grp = v_gruppe_haupt_grp
        group by
            grp.lgr_gruppe_haupt_grp;

        cursor c_lvs_lgr_grp is
        select
            sum(grp.lgr_gruppe_max_lte)
        from
            lvs_lgr_grp grp
        where
                grp.lgr_ort = in_lgr_ort
            and grp.lgr_gruppe_id = in_lgr_gruppe_id
        group by
            grp.lgr_gruppe_haupt_grp;

    begin
    -- Holen der Hauptgruppe des Lagers
        v_lgr_gruppe_id := in_lgr_gruppe_id;
        v_lgr_ort := in_lgr_ort;
        open c_lgr_gruppe_haupt_grp;
        fetch c_lgr_gruppe_haupt_grp into v_gruppe_haupt_grp;
        close c_lgr_gruppe_haupt_grp;
        v_lgr_gruppe_id := in_ref_lgr_gruppe_id;
        v_lgr_ort := in_ref_lgr_ort;
        open c_lgr_gruppe_haupt_grp;
        fetch c_lgr_gruppe_haupt_grp into v_ref_gruppe_haupt_grp;
        close c_lgr_gruppe_haupt_grp;

    -- in der REF_Gruppe befindet sich immer die Gruppe, in die zu letzt eingelagert wurde
    -- falls diese Gruppe gleich mit der neuen ist, dann wird der Fuellgrad auf 100% gesetzt
    -- und ist damit immer der Maxwert. Somit sind alle anderen Gruppen besser und würden
    -- als besser erkannt. Diese Gruppe würde nur im Notfall genommen (Alle anderen Gruppen
    -- gehen nicht)
        if v_gruppe_haupt_grp = v_ref_gruppe_haupt_grp
        or nvl(in_lgr_gruppe_id, -1) = nvl(in_ref_lgr_gruppe_id, -1) then
            v_fuellgrad := 100;
        else
      -- In der aktuellen gruppe ist eine Hauptgruppe eingetragen
      -- dann die Lagerplätze dieser Hauptgruppe benutzen
            if v_gruppe_haupt_grp is not null then
        -- Lesen Anzahl der Lagerplätze mit diesem Reservierungsstring
                open c_lgr_haupt_grp_lte_res;
                fetch c_lgr_haupt_grp_lte_res into v_anz_res_lte;
                close c_lgr_haupt_grp_lte_res;
                open c_lvs_lgr_haupt_grp;
                fetch c_lvs_lgr_haupt_grp into v_max_grp_lte;
                close c_lvs_lgr_haupt_grp;
            else
                open c_lgr_grp_lte_res;
                fetch c_lgr_grp_lte_res into v_anz_res_lte;
                close c_lgr_grp_lte_res;
                open c_lvs_lgr_grp;
                fetch c_lvs_lgr_grp into v_max_grp_lte;
                close c_lvs_lgr_grp;
            end if;

            if nvl(v_max_grp_lte, 0) = 0 then
                v_fuellgrad := 0;
            else
                v_fuellgrad := nvl(v_anz_res_lte, 0) / v_max_grp_lte * 100;
            end if;

        end if;

        return ( v_fuellgrad );
    end;

  /*-------------------------------------------------------------------------
  -- Function ermittelt, dieser Platz mit genau einem Fahrzeug erreichbar ist,
  -- und Auslagerungen möglich sind.
  -- Rückgabe:
  --    'T'           -> Alles OK, kein Fehler
  --    'F'           -> Nur ein Fahrzeug, jedoch defekt
  -------------------------------------------------------------------------*/

    function chk_lte_lgr_zugriff_ok (
        in_lte_id in lvs_lte.lte_id%type
    ) return varchar2 is

        v_result        varchar2(1);
        v_res_id        isi_resource.res_id%type;
        v_lte           lvs_lte%rowtype;
        v_lgr           lvs_lgr%rowtype;
        v_found         boolean;
        v_lvs_fahrzeuge lvs_fahrzeuge%rowtype;
        cursor c_lte is -- Lesen des Lagerhilfsmittel
        select
            *
        from
            lvs_lte lte
        where
            lte.lte_id = in_lte_id;

        cursor c_lvs_lgr_grp_fahrzeug is
        select
            decode(
                min(f.res_id),
                max(f.res_id),
                min(f.res_id),
                null
            ) res_id
        from
            lvs_lgr_grp_fahrzeug f
        where
                f.lgr_gruppe_id = v_lgr.lgr_gruppe_id
            and f.lgr_ort = v_lte.lgr_ort;

        cursor c_lvs_fahrzeuge is
        select
            *
        from
            lvs_fahrzeuge t
        where
                t.sid = v_lgr.sid
            and t.res_id = v_res_id
            and t.fahrzeug_ok != 'M';

        cursor c_lgr is -- Lesen des Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz = v_lte.lgr_platz;

    begin
        v_result := 'T';
        open c_lte;
        fetch c_lte into v_lte;
        v_found := c_lte%found;
        close c_lte;
        if v_found then
            open c_lgr;
            fetch c_lgr into v_lgr;
            v_found := c_lgr%found;
            close c_lgr;
            if
                v_found
                and v_lgr.lgr_gruppe_id is not null
            then
                v_res_id := null;
                open c_lvs_lgr_grp_fahrzeug;
                fetch c_lvs_lgr_grp_fahrzeug into v_res_id;
                close c_lvs_lgr_grp_fahrzeug;
                if v_res_id is not null then
                    open c_lvs_fahrzeuge;
                    fetch c_lvs_fahrzeuge into v_lvs_fahrzeuge;
                    v_found := c_lvs_fahrzeuge%found;
                    close c_lvs_fahrzeuge;
                    if not v_found -- Alle manuell auf defekt gesetzt
                     then
                        v_result := c.c_false;
                    end if;
                end if;

            end if;

        end if;

        return ( v_result );
    end chk_lte_lgr_zugriff_ok;

  /*-------------------------------------------------------------------------
  -- Procedure setzt den Gesamtstatus eines Fahrzeugs
  -- Uebergabegabe in_status_OK:
  --    'T'           -> Alles OK
  --    'F'           -> Fahrzeug ist gesperrt
  --    'M'           -> Fahrzeug manuell auf Defekt gesetzt
  --    '?'           -> Fahrzeug ist im Testmodus und soll nur in_anz_test_lte transportieren
  --    Testanzahl    -> Im Status '?' soll diese Anzahl an LTEs getestet werden
  -- Uebergabegabe in_ausl_status_OK:
  --    'T'           -> Alles OK
  --    'F'           -> Fahrzeug ist gesperrt
  --    'M'           -> Fahrzeug manuell auf Defekt gesetzt
  -------------------------------------------------------------------------*/
    procedure c_set_fahrzeug_status (
        in_res_id         in isi_resource.res_id%type,
        in_status_ok      in lvs_fahrzeuge.fahrzeug_ok%type,
        in_anz_test_lte   in lvs_fahrzeuge.anz_test_lte%type,
        in_ausl_status_ok in lvs_fahrzeuge.fahrzeug_ok%type
    ) is
    begin
        update lvs_fahrzeuge f
        set
            f.fahrzeug_ok = in_status_ok,
            f.anz_test_lte = nvl(in_anz_test_lte, 0),
            f.fahrzeug_ausl_ok = in_ausl_status_ok
        where
            f.res_id = in_res_id;

        commit;
    end c_set_fahrzeug_status;

    procedure lgr_grp_kanal_kontrolle (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_lgr_ort    in lvs_lgr_ort.lgr_ort%type,
        in_lgr_gruppe in lvs_lgr.gruppe%type
    ) is
    -- Non-scalar parameters require additional processing
        v_lte lvs_lte%rowtype;
        v_lgr lvs_lgr%rowtype;
        cursor c_lgr is
        select
            *
        from
            lvs_lgr t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort = in_lgr_ort
            and t.gruppe = in_lgr_gruppe
            and t.lgr_dim_fifo_nr = 1;

        cursor c_lte is
        select
            *
        from
            lvs_lte t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_platz = v_lgr.lgr_platz
            or t.ziel_lgr_platz = v_lgr.lgr_platz;

    begin
        open c_lgr;
        fetch c_lgr into v_lgr;
        loop
            v_lte := null;
            exit when c_lgr%notfound;
            open c_lte;
            fetch c_lte into v_lte;
            close c_lte;
      -- Call the procedure
            lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_lgr);
      -- dbms_output.put_line('Platz:' || v_lgr.lgr_platz);
            commit;
            fetch c_lgr into v_lgr;
        end loop;

        close c_lgr;
    end;

    procedure c_set_lgr_grp_to_platz_grp (
        in_sid                in isi_sid.sid%type,
        in_firma_nr           in isi_firma.firma_nr%type,
        in_lgr_ort            in lvs_lgr_ort.lgr_ort%type,
        in_lgr_gruppe_set     in lvs_lgr.lgr_gruppe_id%type,
        in_lgr_gruppe_rest    in lvs_lgr.lgr_gruppe_id%type,
        in_lgr_dim_g          in lvs_lgr.lgr_dim_g%type,
        in_lgr_dim_r          in lvs_lgr.lgr_dim_r%type,
        in_gruppe             in lvs_lgr.gruppe%type,
        in_anz_plaetze        in number,
        in_anz_plaetze_gruppe in number
    ) is

        v_lgr               lvs_lgr%rowtype;
        v_lte               lvs_lte%rowtype;
        v_platz_belegt      boolean;
        v_lgr_platz_grp_set lvs_lgr.lgr_platz%type;
        v_dim_t             number;
        v_anz_i_max         number;
        v_anz_i             number;
        v_anz_i_geteilt     number;
        v_anz_i_first       number;
        cursor c_lgr_gruppe is
        select
            *
        from
            lvs_lgr t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort = in_lgr_ort
            and t.lgr_dim_g = in_lgr_dim_g
            and t.lgr_dim_r = in_lgr_dim_r
            and t.gruppe = in_gruppe
        order by
            t.lgr_dim_t desc;

        cursor c_lgr_gruppe_rest is
        select
            *
        from
            lvs_lgr t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort = in_lgr_ort
            and t.lgr_dim_g = in_lgr_dim_g
            and t.lgr_dim_r = in_lgr_dim_r
            and t.gruppe = in_gruppe
            and t.lgr_gruppe_id = in_lgr_gruppe_rest
        order by
            t.lgr_dim_t;

        cursor c_lte is
        select
            *
        from
            lvs_lte t
        where
            t.lgr_platz = v_lgr.lgr_platz;

    begin
        v_platz_belegt := false;
        v_dim_t := 0;
        v_lgr_platz_grp_set := null;
        v_anz_i := round((in_anz_plaetze * 8 / 10) - 0.5, 0); -- Umrechnung Euro 800 zu Indu 1000

        v_anz_i_geteilt := round((in_anz_plaetze_gruppe / 2 * 8 / 10) - 0.5, 0) * 2;

        v_anz_i_max := round((in_anz_plaetze_gruppe * 8 / 10) - 0.5, 0);

        v_anz_i_first := round((in_anz_plaetze_gruppe / 2) - 0.5, 0) - round((v_anz_i_geteilt / 2) - 0.5, 0);

        if v_anz_i < 0 then
            v_anz_i := 0;
        end if;
        if
            v_anz_i_first + v_anz_i > in_anz_plaetze
            and v_anz_i_geteilt < v_anz_i_max
            and v_anz_i > 0
        then
            v_anz_i := v_anz_i - 1;
        end if;

        if
            v_anz_i_first + in_anz_plaetze > in_anz_plaetze_gruppe - v_anz_i_first
            and v_anz_i > 0
        then
            v_anz_i := v_anz_i + 1;
        end if;

        if v_anz_i > v_anz_i_geteilt then
            v_anz_i := v_anz_i_geteilt;
        end if;
        if
            ( v_anz_i_first >= in_anz_plaetze
            or in_anz_plaetze >= in_anz_plaetze_gruppe - v_anz_i_first )
            and in_anz_plaetze != 0
            and in_anz_plaetze != in_anz_plaetze_gruppe
            and v_anz_i_geteilt != 0
        then
            v_err_nr := 2;
            v_err_text := lc.ec_p1(lc.o_tp1_res_error,
                                   'set > '
                                   || to_char(v_anz_i_first)
                                   || ' or set < '
                                   || to_char(in_anz_plaetze_gruppe - v_anz_i_first)
                                   || ' or set = '
                                   || to_char(0)
                                   || ' or set = '
                                   || to_char(in_anz_plaetze_gruppe));

            raise v_error;
        end if;

        update lvs_lgr t
        set
            t.lgr_gruppe_id = in_lgr_gruppe_rest
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort = in_lgr_ort
            and t.lgr_dim_g = in_lgr_dim_g
            and t.lgr_dim_r = in_lgr_dim_r
            and t.gruppe = in_gruppe
            and t.lgr_gruppe_id != in_lgr_gruppe_rest;

        update lvs_lgr t
        set
            t.lte_namen = 'Euro;',
            t.lte_namen_cfg = 'Euro;'
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort = in_lgr_ort
            and t.lgr_dim_g = in_lgr_dim_g
            and t.lgr_dim_r = in_lgr_dim_r
            and t.gruppe = in_gruppe
            and ( t.lte_namen_cfg like '%Euro;%' )
            and ( t.lgr_dim_t <= v_anz_i_first
                  or t.lgr_dim_t > in_anz_plaetze_gruppe - v_anz_i_first );

        update lvs_lgr t
        set
            t.lte_namen = 'Euro;Indu;',
            t.lte_namen_cfg = 'Euro;Indu;'
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort = in_lgr_ort
            and t.lgr_dim_g = in_lgr_dim_g
            and t.lgr_dim_r = in_lgr_dim_r
            and t.gruppe = in_gruppe
            and ( t.lte_namen_cfg like '%Euro;%' )
            and ( t.lgr_dim_t > v_anz_i_first
                  or t.lgr_dim_t <= in_anz_plaetze_gruppe - v_anz_i_first );

        open c_lgr_gruppe;
        loop
            fetch c_lgr_gruppe into v_lgr;
            exit when c_lgr_gruppe%notfound
            or v_dim_t >= in_anz_plaetze;
            if v_lgr_platz_grp_set is null then
                v_lgr_platz_grp_set := v_lgr.lgr_platz;
            end if;
            if
                isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'LVS_CHG_PLATZ_CFG',      -- in_kategorie             in isi_firma_cfg.kategorie%type,
                 null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                 'LVS_PLATZ_CHG_TO_GRP_SHOW_DISPO_ERR',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                               'LVS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                'BOOLEAN') = c.c_true     -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                and ( v_lgr.lgr_dispo_einl_te > 0
                or v_lgr.lgr_dispo_ausl_te > 0 )
            then
                v_err_nr := 1;
                v_err_text := lc.ec(lc.o_txt_lgr_m_dispo);
                raise v_error;
            end if;

            update lvs_lgr t
            set
                t.lgr_gruppe_id = in_lgr_gruppe_set,
                t.lgr_platz_gruppe = v_lgr_platz_grp_set,
                t.hrl_lag_max_pal_a = in_anz_plaetze,
                t.hrl_lag_max_pal_i = v_anz_i,
                t.lgr_dim_fifo_nr = in_anz_plaetze - v_dim_t
            where
                    t.sid = in_sid
                and t.firma_nr = in_firma_nr
                and t.lgr_platz = v_lgr.lgr_platz;

            v_dim_t := v_dim_t + 1;
        end loop;

        close c_lgr_gruppe;
        v_platz_belegt := false;
        v_dim_t := 0;
        open c_lgr_gruppe;
        loop
            fetch c_lgr_gruppe into v_lgr;
            exit when c_lgr_gruppe%notfound
            or v_dim_t >= in_anz_plaetze;
            if v_lgr.lgr_akt_te > 0 then
                if not v_platz_belegt then
                    v_lte := null;
                    open c_lte;
                    fetch c_lte into v_lte;
                    close c_lte;
                    lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_lgr);
                end if;

                v_platz_belegt := true;
            end if;

            v_lgr.lte_namen := null;
            if v_lgr.lgr_akt_te = 0 then
                if v_platz_belegt                 -- dann ist der Platz blockiert
                 then
                    v_lgr.lte_namen := 'keine';       -- Dann auch keine Möglichkeit für die Einlagerung
                    update lvs_lgr t
                    set
                        t.lte_namen = v_lgr.lte_namen
                    where
                            t.sid = in_sid
                        and t.firma_nr = in_firma_nr
                        and t.lgr_platz = v_lgr.lgr_platz;

                else
                    lvs_lager_opt.lvs_kanal_kontrolle(null, v_lgr);
                end if;
            end if;

            v_dim_t := v_dim_t + 1;
        end loop;

        close c_lgr_gruppe;
        v_dim_t := 0;
        v_platz_belegt := false;
        v_lgr_platz_grp_set := null;
        v_anz_i := v_anz_i_geteilt - v_anz_i;
    --v_anz_i := round(((in_anz_plaetze_gruppe - in_anz_plaetze) * 8 / 10) - 0.5, 0); -- Umrechnung Euro 800 zu Indu 1000
        open c_lgr_gruppe_rest;
        loop
            fetch c_lgr_gruppe_rest into v_lgr;
            exit when c_lgr_gruppe_rest%notfound;
            if v_lgr_platz_grp_set is null then
                v_lgr_platz_grp_set := v_lgr.lgr_platz;
            end if;
            if
                isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'LVS_CHG_PLATZ_CFG',      -- in_kategorie             in isi_firma_cfg.kategorie%type,
                 null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                 'LVS_PLATZ_CHG_TO_GRP_SHOW_DISPO_ERR',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                               'LVS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                'BOOLEAN') = c.c_true     -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                and ( v_lgr.lgr_dispo_einl_te > 0
                or v_lgr.lgr_dispo_ausl_te > 0 )
            then
                v_err_nr := 1;
                v_err_text := lc.ec(lc.o_txt_lgr_m_dispo);
                raise v_error;
            end if;

            update lvs_lgr t
            set
                t.lgr_platz_gruppe = v_lgr_platz_grp_set,
                t.hrl_lag_max_pal_a = in_anz_plaetze_gruppe - in_anz_plaetze,
                t.hrl_lag_max_pal_i = v_anz_i,
                t.lgr_dim_fifo_nr = in_anz_plaetze_gruppe - in_anz_plaetze - v_dim_t
            where
                    t.sid = in_sid
                and t.firma_nr = in_firma_nr
                and t.lgr_platz = v_lgr.lgr_platz;

            v_dim_t := v_dim_t + 1;
        end loop;

        close c_lgr_gruppe_rest;
        open c_lgr_gruppe_rest;
        loop
            fetch c_lgr_gruppe_rest into v_lgr;
            exit when c_lgr_gruppe_rest%notfound;
            if v_lgr.lgr_akt_te > 0 then
                if not v_platz_belegt then
                    v_lte := null;
                    open c_lte;
                    fetch c_lte into v_lte;
                    close c_lte;
                    lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_lgr);
                end if;

                v_platz_belegt := true;
            end if;

            v_lgr.lte_namen := null;
            if v_lgr.lgr_akt_te = 0 then
                if v_platz_belegt                 -- dann ist der Platz blockiert
                 then
                    v_lgr.lte_namen := 'keine';       -- Dann auch keine Möglichkeit für die Einlagerung
                    update lvs_lgr t
                    set
                        t.lte_namen = v_lgr.lte_namen
                    where
                            t.sid = in_sid
                        and t.firma_nr = in_firma_nr
                        and t.lgr_platz = v_lgr.lgr_platz;

                else
                    lvs_lager_opt.lvs_kanal_kontrolle(null, v_lgr);
                end if;
            end if;

            v_dim_t := v_dim_t + 1;
        end loop;

        close c_lgr_gruppe_rest;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
      -- rollback;
            if c_lgr_gruppe%isopen then
                close c_lgr_gruppe;
            end if;
            if c_lgr_gruppe_rest%isopen then
                close c_lgr_gruppe_rest;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
      -- rollback;
            if c_lgr_gruppe%isopen then
                close c_lgr_gruppe;
            end if;
            if c_lgr_gruppe_rest%isopen then
                close c_lgr_gruppe_rest;
            end if;
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

    end;
  /*-------------------------------------------------------------------------
  -- Procedure setzt die LGR_PLATZ_GRP neu und ordnet diese einem Fahrzeug zu
  -- Berechnet damit auch die Anzahl der plätze einer Gruppe neu
  -- Setzt die DIM-FIFO nummer des Lagerplatz
  -- Sperrt Pläze, die dann nicht zu erreichen sind
  -------------------------------------------------------------------------*/
    procedure c_set_lgr_grp_to_fahrzeug (
        in_sid             in isi_sid.sid%type,
        in_firma_nr        in isi_firma.firma_nr%type,
        in_lgr_ort         in lvs_lgr_ort.lgr_ort%type,
        in_lgr_gruppe_set  in lvs_lgr.lgr_gruppe_id%type,
        in_lgr_gruppe_rest in lvs_lgr.lgr_gruppe_id%type,
        in_lgr_dim_g       in lvs_lgr.lgr_dim_g%type,
        in_lgr_dim_r       in lvs_lgr.lgr_dim_r%type,
        in_lgr_dim_p_von   in lvs_lgr.lgr_dim_p%type,
        in_lgr_dim_p_bis   in lvs_lgr.lgr_dim_p%type,
        in_lgr_dim_e_von   in lvs_lgr.lgr_dim_e%type,
        in_lgr_dim_e_bis   in lvs_lgr.lgr_dim_e%type,
        in_anz_plaetze     in number
    ) is

        v_lgr_gruppe         lvs_lgr.gruppe%type;
        v_lgr_platz_min      lvs_lgr.lgr_platz%type;   -- Name der Lagerplatzgruppe für in_lgr_gruppe_set
        v_lgr_platz_max      lvs_lgr.lgr_platz%type;   -- Name der Lagerplatzgruppe für in_lgr_gruppe_rest
        v_anz_plaetze_gruppe number;
        cursor c_lgr_gruppe is
        select
            t.gruppe,
            min(t.lgr_platz),
            max(t.lgr_platz),
            count(t.lgr_platz)
        from
            lvs_lgr t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_ort = in_lgr_ort
            and t.lgr_typ = c.kanal1
            and t.lgr_dim_g = in_lgr_dim_g
            and t.lgr_dim_r = in_lgr_dim_r
            and t.lgr_dim_p >= in_lgr_dim_p_von
            and t.lgr_dim_p <= in_lgr_dim_p_bis
            and t.lgr_dim_e >= in_lgr_dim_e_von
            and t.lgr_dim_e <= in_lgr_dim_e_bis
        group by
            t.gruppe
        order by
            t.gruppe;

    begin
        open c_lgr_gruppe;
        loop
            fetch c_lgr_gruppe into
                v_lgr_gruppe,
                v_lgr_platz_min,
                v_lgr_platz_max,
                v_anz_plaetze_gruppe;
            exit when c_lgr_gruppe%notfound;

      -- dbms_output.put_line(v_lgr_gruppe || ' ' || v_lgr_platz_min || ' ' || v_lgr_platz_max);
            c_set_lgr_grp_to_platz_grp(in_sid, in_firma_nr, in_lgr_ort, in_lgr_gruppe_set, in_lgr_gruppe_rest,
                                       in_lgr_dim_g, in_lgr_dim_r, v_lgr_gruppe, in_anz_plaetze, v_anz_plaetze_gruppe);

            lgr_grp_kanal_kontrolle(in_sid, in_firma_nr, in_lgr_ort, v_lgr_gruppe);
        end loop;

        close c_lgr_gruppe;
        commit;
    end c_set_lgr_grp_to_fahrzeug;

    procedure c_chk_fahrzeug_defekt_st (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type
    ) is
  -- local variables here
        v_transport                 isi_transport%rowtype;
        v_found                     boolean;
        v_ret                       varchar2(500);
        v_lte_id                    lvs_lte.lte_id%type;
        v_status                    lvs_fahrz_defekt_dispo_st.status%type;
        v_lvs_fahrz_defekt_dispo_st lvs_fahrz_defekt_dispo_st%rowtype;
        cursor c_fahrz_def_status is
        select
            *
        from
            lvs_fahrz_defekt_dispo_st t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.status in ( 'N', 'B', 'TF', 'R' )
            and t.defekt_date < sysdate - 1 / 1440; -- Um Fehleingaben ohen Konsequez inerhalb von 1 Minute zu korrigieren
        cursor c_transport is
        select
            t.*
        from
            isi_transport t
        where
                t.res_id = v_lvs_fahrz_defekt_dispo_st.res_id
            and t.transp_typ = 'A'
            and t.status in ( 'F', 'G', 'B' );

        cursor c_dispos is
        select
            lam.lte_id
        from
            lvs_lam              lam,
            lvs_lgr              lgr,
            lvs_lgr_grp_fahrzeug fg,
            lvs_fahrzeuge        f
        where
                lam.order_pos_auf_id > 0
            and lam.lgr_platz = lgr.lgr_platz
            and fg.lgr_gruppe_id = lgr.lgr_gruppe_id
            and fg.lgr_ort = lgr.lgr_ort
            and fg.res_id = f.res_id
            and f.res_id = v_lvs_fahrz_defekt_dispo_st.res_id;

    begin

    -- Hier zuerst die Transporte, die noch nicht im Status Transport sind
        open c_fahrz_def_status;
        fetch c_fahrz_def_status into v_lvs_fahrz_defekt_dispo_st;
        loop
            v_status := 'TF';
            exit when c_fahrz_def_status%notfound;
            begin
                update lvs_fahrz_defekt_dispo_st t
                set
                    t.status = 'B'
                where
                        t.sid = v_lvs_fahrz_defekt_dispo_st.sid
                    and t.firma_nr = v_lvs_fahrz_defekt_dispo_st.firma_nr
                    and t.res_id = v_lvs_fahrz_defekt_dispo_st.res_id
                    and t.defekt_date = v_lvs_fahrz_defekt_dispo_st.defekt_date;
        -- Hier zuerst die Transporte, die noch nicht im Status Transport sind
                open c_transport;
                loop
                    fetch c_transport into v_transport;
                    exit when c_transport%notfound;
                    begin
                        v_ret := lvs_p_lte.lvs_neue_lte_res_nio_transp(v_transport.transp_id, -1, v_transport.lte_id);

                        if v_ret is not null then
                            if v_ret != lc.ec('O_TP1_NO_ACTION_TAKEN') then
                                v_status := 'R'; -- Die LTE nicht getauscht werden EGAL mit der nächsten weiter
                                 -- Und merken, das eine Rest da ist, der nicht verteilte werden komnnte
                            end if;

                        end if;

                    exception
                        when others then
                            v_status := 'R'; -- Im Fehler konnte die LTE nicht getauscht werden EGAL mit der nächsten weiter
                                              -- Und merken, das eine Rest da ist, der nicht verteilte werden komnnte
                    end;

                end loop;

                close c_transport;
                update lvs_fahrz_defekt_dispo_st t
                set
                    t.status = v_status
                where
                        t.sid = v_lvs_fahrz_defekt_dispo_st.sid
                    and t.firma_nr = v_lvs_fahrz_defekt_dispo_st.firma_nr
                    and t.res_id = v_lvs_fahrz_defekt_dispo_st.res_id
                    and t.defekt_date = v_lvs_fahrz_defekt_dispo_st.defekt_date;

            exception
                when others then -- Umswitchen so nicht möglich
                    rollback;
                    if c_transport%isopen then
                        close c_transport;
                    end if;
                    if c_dispos%isopen then
                        close c_dispos;
                    end if;
                    if c_fahrz_def_status%isopen then
                        close c_fahrz_def_status;
                    end if;
            end;

            fetch c_fahrz_def_status into v_lvs_fahrz_defekt_dispo_st;
        end loop;

        close c_fahrz_def_status;

    -- Jetzt die DISPOS
        open c_fahrz_def_status;
        fetch c_fahrz_def_status into v_lvs_fahrz_defekt_dispo_st;
        loop
            exit when c_fahrz_def_status%notfound;
            begin
                v_status := v_lvs_fahrz_defekt_dispo_st.status;
                update lvs_fahrz_defekt_dispo_st t
                set
                    t.status = 'F'
                where
                        t.sid = v_lvs_fahrz_defekt_dispo_st.sid
                    and t.firma_nr = v_lvs_fahrz_defekt_dispo_st.firma_nr
                    and t.res_id = v_lvs_fahrz_defekt_dispo_st.res_id
                    and t.status != 'R'
                    and t.defekt_date = v_lvs_fahrz_defekt_dispo_st.defekt_date;

        -- Jetzt alle DISPOS wenn möglich umsetzten
                open c_dispos;
                loop
                    fetch c_dispos into v_lte_id;
                    exit when c_dispos%notfound;
                    begin
                        v_ret := lvs_p_lte.lvs_neue_lte_res_nio_dispo(-1, v_lte_id);
                        if v_ret is not null then
                            if v_ret != lc.ec('O_TP1_NO_ACTION_TAKEN') then
                                v_status := 'R'; -- Die LTE nicht getauscht werden EGAL mit der nächsten weiter
                                 -- Und merken, das eine Rest da ist, der nicht verteilte werden komnnte
                            end if;

                        end if;

                    exception
                        when others then
                            v_status := 'B'; -- Im Fehler konnte die LTE nicht getauscht werden EGAL mit der nächsten weiter
                                              -- Und merken, das eine Rest da ist, der nicht verteilte werden komnnte
                                              -- Mit B gern ganzen Ablauf wiederholen
                    end;

                    if v_status = 'TF' then
                        v_status := 'F';         -- Dieser Resource ist fertig
                    else
                        v_status := 'B';         -- Dieser Resource ist fertig
                    end if;

                    update lvs_fahrz_defekt_dispo_st t
                    set
                        t.status = v_status
                    where
                            t.sid = v_lvs_fahrz_defekt_dispo_st.sid
                        and t.firma_nr = v_lvs_fahrz_defekt_dispo_st.firma_nr
                        and t.res_id = v_lvs_fahrz_defekt_dispo_st.res_id
                        and t.defekt_date = v_lvs_fahrz_defekt_dispo_st.defekt_date
                        and t.status != v_status;

                    commit;
                end loop;

                close c_dispos;
                fetch c_fahrz_def_status into v_lvs_fahrz_defekt_dispo_st;
            exception
                when others then -- Umswitchen so nicht möglich
                    rollback;
                    if c_transport%isopen then
                        close c_transport;
                    end if;
                    if c_dispos%isopen then
                        close c_dispos;
                    end if;
                    exit;
            end;

            update lvs_fahrz_defekt_dispo_st t
            set
                t.status = 'B'
            where
                    t.sid = v_lvs_fahrz_defekt_dispo_st.sid
                and t.firma_nr = v_lvs_fahrz_defekt_dispo_st.firma_nr
                and t.res_id = v_lvs_fahrz_defekt_dispo_st.res_id
                and t.defekt_date = v_lvs_fahrz_defekt_dispo_st.defekt_date
                and t.status = 'R';

            commit;
        end loop;

        close c_fahrz_def_status;
    end;

begin
  -- Initialization
    v_g_fah_text := null;
end lvs_p_lgr_grp_fahrzeuge;
/


-- sqlcl_snapshot {"hash":"5f5f8a35a126241cb9465aef8eeae25f888ee535","type":"PACKAGE_BODY","name":"LVS_P_LGR_GRP_FAHRZEUGE","schemaName":"DIRKSPZM32","sxml":""}