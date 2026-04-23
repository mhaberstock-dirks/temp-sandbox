create or replace package body dirkspzm32.isi_alert is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler-Variablen für eine Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);

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

    procedure c_insert_mail (
        in_mail_address in isi_mail_queue.mail_address%type,
        in_betreff      in isi_mail_queue.betreff_text%type,
        in_inhalt       in isi_mail_queue.inhalt_text%type,
        in_send_modul   in isi_mail_queue.send_modul%type
    ) is
    begin
  -- Eine mail in die Tabelle isi_mail_queue schreiben !
        insert into isi_mail_queue (
            mail_address,
            betreff_text,
            inhalt_text,
            send_modul
        ) values ( in_mail_address,
                   in_betreff,
                   in_inhalt,
                   in_send_modul );

        commit;
        v_err_nr := 0;
    end;

    procedure min_date_from_resource_status (
        in_res_id             in isi_resource.res_id%type,
        in_filter             in isi_alert_cfg.alert_filter%type,
        out_seconds           out number,
        out_min_date          out date,
        out_min_res_status_id out isi_resource_zust_akt.status_id%type,
        out_min_resource_name out isi_resource.res_name%type,
        out_min_status_text   out isi_resource_zust_akt.status_text%type,
        out_min_res_id        out isi_resource_zust_akt.res_id%type
    ) is

        cursor c_get_min_status_date is
        select
            ( ( sysdate - min(r_akt.status_seit) ) * 24 * 60 * 60 ) diff_sek,
            min(r_akt.status_seit)                                  min_date,
            min(r_akt.status_id)                                    min_res_status_id,
            min(r.res_name)                                         min_resource_name,
            min(r_akt.status_text)                                  min_status_text,
            min(r_akt.res_id)                                       min_res_id
        from
            isi_resource          r,
            isi_resource_zust_akt r_akt
        where
            ( ( r.res_id = in_res_id )
              or ( r.parent_res_id = in_res_id )
              or ( r.linie_res_id = in_res_id ) )
            and r.res_id = r_akt.res_id
            and r_akt.status_id <> 0;

    begin
        out_min_date := null;
        out_seconds := null;
        open c_get_min_status_date;
        fetch c_get_min_status_date into
            out_seconds,
            out_min_date,
            out_min_res_status_id,
            out_min_resource_name,
            out_min_status_text,
            out_min_res_id;
        close c_get_min_status_date;
    end;

    procedure min_date_from_meldung_status (
        in_res_id             in isi_resource.res_id%type,
        in_filter             in isi_alert_cfg.alert_filter%type,
        out_seconds           out number,
        out_min_date          out date,
        out_min_res_status_id out isi_resource_zust_akt.status_id%type,
        out_min_resource_name out isi_resource.res_name%type,
        out_min_status_text   out isi_resource_zust_akt.status_text%type,
        out_min_res_id        out isi_resource_zust_akt.res_id%type
    ) is

        cursor c_get_min_meldung_date is
        select
            x.*
        from
            (
                select
                    ( ( sysdate - ( md.md_kommt ) ) * 24 * 60 * 60 ) diff_sek, -- differenz in Sekunden seit Meldung begonnen
                    ( md.md_kommt )                                  min_date,
                    ( mt.mt_fehlertext ),
                    ( r.res_name )                                   min_resource_name
                from
                    isi_resource  r,
                    meldung_cfg   mc,
                    meldung_daten md,
                    meldung_texte mt
                where
                    ( ( r.res_id = in_res_id )
                      or                   -- konfigurierte Resource Direkt
                       ( r.parent_res_id = in_res_id )
                      or             -- konfigurierte Resource is parent
                       ( r.linie_res_id = in_res_id ) )
                    and            -- konfigurierte Resource gehört zu Linie
                     ( mc.res_id = r.res_id )
                    and                    -- Meldung_cfg benötigt die Resource sonst funktioniert es nicht.
                     ( md.md_status = 'K' )
                    and ( md.md_bereich = mc.name )
                    and ( md.md_index = mt.mt_index )
                    and ( mc.fehler_text_gruppe = mt.mt_gruppe )
                    and ( ( mt.filter_mask like '%'
                                                || in_filter
                                                || '%' )
                          or ( in_filter is null ) ) -- wenn Filter gesetzt filtern
                order by
                    md.md_kommt,
                    md.md_id
            ) x
        where
            rownum = 1;                                  -- wir brauchen nur den ältesten Datensatz
    begin
        out_min_date := null;
        out_seconds := null;
        open c_get_min_meldung_date;
        fetch c_get_min_meldung_date into
            out_seconds,
            out_min_date,
            out_min_status_text,
            out_min_resource_name;
        close c_get_min_meldung_date;
    end;


  -------------------------------------------------------------------------------------------------------
  -- procedure  c_service_resource_alert(...)
  -------------------------------------------------------------------------------------------------------
  -- Diese Procedure prüft, welche Meldungen Alerts und Resourcen Alerts in der Tabelle ISI_ALERT_CFG konfiguriert sind
  -- und händelt das Versenden der dort konfigurierten Alerts in die Tabelle ISI_ALERT_QUEUE

    procedure c_service_res_meld_alert is

        v_res_id                    isi_resource.res_id%type;
        v_alert_filter              isi_alert_cfg.alert_filter%type;
        v_alert_name                isi_alert_cfg.alert_cfg_name%type;
        v_alert_typ                 isi_alert_cfg.alert_typ%type;
        v_alert_status              isi_alert_cfg.alert_status%type;
        v_alert_datum               isi_alert_cfg.alert_datum%type;
        v_alert_aktiv               isi_alert_cfg.alert_aktiv%type;
        v_alert_intervall           isi_alert_cfg.alert_intervall%type;
        v_alert_template_kopf       isi_alert_cfg.template_kopf%type;
        v_alert_template_meld_kommt isi_alert_cfg.template_meld_kommt%type;
        v_alert_template_meld_geht  isi_alert_cfg.template_meld_geht%type;
        v_alert_mail_address        isi_alert_cfg.mail_address%type;
        v_res_min_date              date;
        v_res_min_res_id            isi_resource.res_id%type;
        v_res_min_source_name       isi_resource.res_name%type;
        v_res_min_status_text       isi_resource_zust_akt.status_text%type;
        v_seconds                   number;
        v_min_date                  date;
        v_min_res_status_id         isi_resource_zust_akt.status_id%type;
        v_min_resource_name         isi_resource.res_name%type;
        v_min_status_text           isi_resource_zust_akt.status_text%type;
        v_min_res_id                isi_resource.res_id%type;
        v_betreff                   isi_mail_queue.betreff_text%type;
        v_inhalt                    isi_mail_queue.inhalt_text%type;
        v_send_modul                isi_mail_queue.send_modul%type;
        cursor c_isi_alert_cfg_res is
        select
            t.alert_typ,
            t.alert_cfg_name,
            t.res_id,
            t.alert_status,
            t.alert_datum,
            t.alert_aktiv,
            t.alert_intervall,
            t.template_kopf,
            t.template_meld_kommt,
            t.template_meld_geht,
            t.mail_address,
            t.alert_filter
        from
            isi_alert_cfg t
        where
            t.alert_typ = 'R'
            or t.alert_typ = 'M'; -- Resourcen Alert
    begin
        v_send_modul := 'c_service_resource_alert';
        open c_isi_alert_cfg_res;
        loop
            fetch c_isi_alert_cfg_res into
                v_alert_typ,
                v_alert_name,
                v_res_id,
                v_alert_status,
                v_alert_datum,
                v_alert_aktiv,
                v_alert_intervall,
                v_alert_template_kopf,
                v_alert_template_meld_kommt,
                v_alert_template_meld_geht,
                v_alert_mail_address,
                v_alert_filter;

            exit when c_isi_alert_cfg_res%notfound;
     --  prüfen ob alerts behandelt werden sollen
            if v_alert_aktiv = 'T' then
                if v_alert_typ = 'R' then --Resourcen Alert
                    min_date_from_resource_status(v_res_id, v_alert_filter, v_seconds, v_min_date, v_min_res_status_id,
                                                  v_min_resource_name, v_min_status_text, v_min_res_id);

                    if
                        ( v_min_date is not null )
                        and ( v_seconds > v_alert_intervall )
                        and ( v_alert_status <> 'T' )
                    then
          -- Alert Start Eintragen Meldung gekommen !!!
                        v_betreff := v_alert_template_meld_kommt;
                        v_inhalt := v_min_resource_name
                                    || ' '
                                    || v_min_status_text;
                        c_insert_mail(v_alert_mail_address, v_betreff, v_inhalt, v_send_modul);
                        update isi_alert_cfg t
                        set
                            t.alert_status = 'T',
                            t.last_alert_date = v_min_date
                        where
                            t.alert_cfg_name = v_alert_name;

                        commit;
                    end if;

                    if
                        ( v_alert_status = 'T' )
                        and ( v_min_date is null )
                    then
          -- Alert Start Eintragen Meldung gegangen !!!
                        v_betreff := v_alert_template_meld_geht;
                        v_inhalt := '';
                        c_insert_mail(v_alert_mail_address, v_betreff, v_inhalt, v_send_modul);
                        update isi_alert_cfg t
                        set
                            t.alert_status = 'F',
                            t.alert_datum = v_min_date
                        where
                            t.alert_cfg_name = v_alert_name;

                        commit;
                    end if;

                end if; -- Resourcen Alert
                if v_alert_typ = 'M' then --Meldungen Alert
                    min_date_from_meldung_status(v_res_id, v_alert_filter, v_seconds, v_min_date, v_min_res_status_id,
                                                 v_min_resource_name, v_min_status_text, v_min_res_id);

                    if
                        ( v_min_date is not null )
                        and ( v_seconds > v_alert_intervall )
                        and ( v_alert_status <> 'T' )
                    then
          -- Alert Start Eintragen Meldung gekommen !!!
                        v_betreff := v_alert_template_meld_kommt;
                        v_inhalt := v_min_resource_name
                                    || ' '
                                    || v_min_status_text;
                        c_insert_mail(v_alert_mail_address, v_betreff, v_inhalt, v_send_modul);
                        update isi_alert_cfg t
                        set
                            t.alert_status = 'T',
                            t.alert_datum = v_min_date
                        where
                            t.alert_cfg_name = v_alert_name;

                        commit;
                    end if;

                    if
                        ( v_alert_status = 'T' )
                        and ( v_min_date is null )
                    then
          -- Alert Start Eintragen Meldung gegangen !!!
                        v_betreff := v_alert_template_meld_geht;
                        v_inhalt := '';
                        c_insert_mail(v_alert_mail_address, v_betreff, v_inhalt, v_send_modul);
                        update isi_alert_cfg t
                        set
                            t.alert_status = 'F',
                            t.alert_datum = v_min_date
                        where
                            t.alert_cfg_name = v_alert_name;

                        commit;
                    end if;

                end if; -- Resourcen Alert
            end if;  -- aktiv
        end loop;

        close c_isi_alert_cfg_res;
        commit;
    end;

begin
  -- globale Initialisierung
  -- Erst mal kein Fehler
    v_err_nr := null;
    v_err_text := null;
end isi_alert;
/


-- sqlcl_snapshot {"hash":"c9a2d623e2832efa7a704836de643552aa0f9e40","type":"PACKAGE_BODY","name":"ISI_ALERT","schemaName":"DIRKSPZM32","sxml":""}