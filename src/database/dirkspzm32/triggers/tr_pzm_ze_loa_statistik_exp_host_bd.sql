create or replace editionable trigger dirkspzm32.tr_pzm_ze_loa_statistik_exp_host_bd before
    insert or update on dirkspzm32.pzm_ze_loa_statistik_exp_host
    for each row
declare
    v_found       boolean;
    v_vertragsart pzm_vertragsarten%rowtype;
    cursor c_vertragsart is
    select
        va.*
    from
        pzm_vertragsarten va,
        pzm_personal      p
    where
            p.pers_nr = :old.pers_nr
        and p.pers_vertragsart = va.va_id;

begin
    open c_vertragsart;
    fetch c_vertragsart into v_vertragsart;
    v_found := c_vertragsart%found;
    close c_vertragsart;
end;
/

alter trigger dirkspzm32.tr_pzm_ze_loa_statistik_exp_host_bd enable;


-- sqlcl_snapshot {"hash":"c9e3715fa73d47d9a76e6778e34e4da2108cebca","type":"TRIGGER","name":"TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BD","schemaName":"DIRKSPZM32","sxml":""}