create or replace force editionable view dirkspzm32.z_pzm_pbi_bde (
    ze_bde_pers_nr,
    ze_bde_datum,
    ze_bde_day_ist_start,
    ze_bde_day_ist_ende,
    ze_bde_sa_kurzname,
    ze_bde_leitzahl,
    ze_bde_fa_ag,
    ze_bde_fa_upos,
    ze_bde_zeit_min,
    ze_bde_verbucht_datum,
    ze_bde_verbucht_status,
    ze_bde_ret_code,
    ze_bde_status_text,
    created_date,
    created_login_id,
    last_change_date,
    last_change_login_id,
    ze_bde_basis,
    ze_bde_personalteilber
) as
    select
        t.ze_bde_pers_nr,
        t.ze_bde_datum,
        t.ze_bde_day_ist_start,
        t.ze_bde_day_ist_ende,
        t.ze_bde_sa_kurzname,
        t.ze_bde_leitzahl,
        t.ze_bde_fa_ag,
        t.ze_bde_fa_upos,
        t.ze_bde_zeit_min,
        t.ze_bde_verbucht_datum,
        t.ze_bde_verbucht_status,
        t.ze_bde_ret_code,
        t.ze_bde_status_text,
        t.created_date,
        t.created_login_id,
        t.last_change_date,
        t.last_change_login_id,
        t.ze_bde_basis,
        t.ze_bde_personalteilber
    from
        pzm_ze_bde_zeiten t
    where
            t.ze_bde_basis = 'BDE'
        and t.ze_bde_verbucht_status = 'UE'
    order by
        t.last_change_date,
        t.ze_bde_pers_nr,
        t.ze_bde_day_ist_start desc,
        t.ze_bde_basis,
        t.ze_bde_datum;


-- sqlcl_snapshot {"hash":"1f59e7779d715728a478ba1daffee431a52e2e67","type":"VIEW","name":"Z_PZM_PBI_BDE","schemaName":"DIRKSPZM32","sxml":""}