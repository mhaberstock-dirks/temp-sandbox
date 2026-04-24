create or replace force editionable view dirkspzm32.isi_v_auto_messaging (
    kategorie_ix,
    description,
    type_2,
    save_2,
    mail_2,
    print_2,
    mail_body,
    data_criteria,
    mail_from_display_name,
    mail_from_user_login_id,
    mail_host,
    report_layout_name,
    report_layout_path,
    mail_port,
    file_name,
    action_timing,
    mail_title,
    mail_to_display_name,
    action_type
) as
    select
        x.kategorie_ix,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_DESCRIPTION', x.parameter_wert))       as description,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_TARGET_TYPE', x.parameter_wert))       as type_2,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_SAVE_TO_PATH', x.parameter_wert))      as save_2,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_TO_ADDRESS', x.parameter_wert))        as mail_2,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_PRINTER', x.parameter_wert))           as print_2,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_BODY', x.parameter_wert))              as mail_body,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_CRITERIA', x.parameter_wert))          as data_criteria,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_FROM_DISPLAY_NAME', x.parameter_wert)) as mail_from_display_name,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_FROM_LOGIN_ID', x.parameter_wert))     as mail_from_user_login_id,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_HOST', x.parameter_wert))              as mail_host,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_LAYOUT_NAME', x.parameter_wert))       as report_layout_name,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_LAYOUT_PATH', x.parameter_wert))       as report_layout_path,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_PORT', x.parameter_wert))              as mail_port,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_TARGET_NAME', x.parameter_wert))       as file_name,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_TIMING', x.parameter_wert))            as action_timing,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_TITLE', x.parameter_wert))             as mail_title,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_TO_DISPLAY_NAME', x.parameter_wert))   as mail_to_display_name,
        max(decode(x.parameter_name, 'ALLG_MESSSAGBOARD_TYPE', x.parameter_wert))              as action_type
    from
        (
            select
                t.*,
                t.rowid
            from
                isi_firma_cfg t
            where
                    1 = 1
                and t.kategorie = 'AUTO_MESSSAGING'
                and ( t.parameter_name = 'ALLG_MESSSAGBOARD_DESCRIPTION'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_TARGET_TYPE'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_TO_ADDRESS'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_SAVE_TO_PATH'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_PRINTER'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_BODY'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_CRITERIA'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_FROM_DISPLAY_NAME'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_FROM_LOGIN_ID'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_HOST'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_LAYOUT_NAME'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_LAYOUT_PATH'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_PORT'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_TARGET_NAME'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_TIMING'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_TITLE'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_TO_DISPLAY_NAME'
                      or t.parameter_name = 'ALLG_MESSSAGBOARD_TYPE' )
            order by
                t.kategorie_ix,
                t.parameter_name
        ) x
    group by
        x.kategorie_ix;


-- sqlcl_snapshot {"hash":"b8f667ef14ba893b2299c8ed48d536e45789d6bc","type":"VIEW","name":"ISI_V_AUTO_MESSAGING","schemaName":"DIRKSPZM32","sxml":""}