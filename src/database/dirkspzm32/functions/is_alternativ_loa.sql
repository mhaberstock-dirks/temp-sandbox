create or replace function dirkspzm32.is_alternativ_loa (
    in_loa in pzm_lohnarten.lz_id%type
) return boolean is

    result    boolean;
    v_lohnart pzm_lohnarten.lz_id%type;
    v_altloa  pzm_lohnarten.lz_alternativ_loa_id%type;
    cursor c_lohnarten is
    select
        lz_lohnart,
        lz_alternativ_loa_id
    from
        pzm_lohnarten t
    where
        lz_alternativ_loa_id = in_loa;

begin
    result := false;
    open c_lohnarten;
    fetch c_lohnarten into
        v_lohnart,
        v_altloa;
    result := c_lohnarten%found;
    close c_lohnarten;
    return ( result );
end is_alternativ_loa;
/


-- sqlcl_snapshot {"hash":"28d58d46c0417c32d4ed54dce16c43712dfb4700","type":"FUNCTION","name":"IS_ALTERNATIV_LOA","schemaName":"DIRKSPZM32","sxml":""}