create or replace editionable trigger dirkspzm32.tr_pzm_ze_loa_exp_host_bd before
    delete on dirkspzm32.pzm_ze_loa_exp_host
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

alter trigger dirkspzm32.tr_pzm_ze_loa_exp_host_bd enable;


-- sqlcl_snapshot {"hash":"2c6bb7d3b26bd798d116e04f0e4baa1527952fb2","type":"TRIGGER","name":"TR_PZM_ZE_LOA_EXP_HOST_BD","schemaName":"DIRKSPZM32","sxml":""}