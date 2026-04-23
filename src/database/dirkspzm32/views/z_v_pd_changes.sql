create or replace force editionable view dirkspzm32.z_v_pd_changes (
    res_pruef_plan_data_bez,
    res_teilgewerk,
    res_name,
    text,
    res_pruef_plan_data_value,
    daten_faktor,
    einheit,
    user_full_name,
    last_change_date
) as
    select
        ppdc.res_pruef_plan_data_bez,
        ppdc.res_teilgewerk,
        res.res_name,
        res.text,/* art.artikel,*/
/*art.bezeichnung1, */
        ppd.res_pruef_plan_data_value,
        ppdc.daten_faktor,
        ppdc.einheit,
        case
            when ppd.last_change_login_id is not null then
                usr.nachname
                || ', '
                || usr.vorname
            else
                ''
        end as user_full_name,
        ppd.last_change_date
    from
             isi_res_pruef_plan_data ppd
        inner join isi_res_pruef_plan_data_cfg ppdc on ppd.sid = ppdc.sid
                                                       and ppd.firma_nr = ppdc.firma_nr
                                                       and ppd.res_id = ppdc.res_id
                                                       and ppd.res_teilgewerk = ppdc.res_teilgewerk
                                                       and ppd.res_pruef_plan_data_nr = ppdc.res_pruef_plan_data_nr
--left join isi_artikel art on ppd.artikel_id = art.artikel_id
        inner join isi_resource                res on ppd.res_id = res.res_id
        left join isi_user                    usr on ppd.last_change_login_id = usr.login_id;


-- sqlcl_snapshot {"hash":"17c82fd83c41022dff5a087094c553601f3f1a91","type":"VIEW","name":"Z_V_PD_CHANGES","schemaName":"DIRKSPZM32","sxml":""}