create or replace editionable trigger dirkspzm32.tr_lvs_lgr_bd before
    delete on dirkspzm32.lvs_lgr
    for each row
declare
  -- local variables here
    v_lgr_grp lvs_lgr_grp%rowtype;
    v_found   boolean;
    v_max_lte lvs_lgr.lgr_max_te%type;
    cursor c_lgr_grp is
    select
        t.*
    from
        lvs_lgr_grp t
    where
            t.lgr_gruppe_id = :old.lgr_gruppe_id
        and t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.lgr_ort = :old.lgr_ort;

begin
    v_max_lte := 0;
    if :old.lgr_gruppe_id is not null then
        open c_lgr_grp;
        fetch c_lgr_grp into v_lgr_grp;
        v_found := c_lgr_grp%found;
        close c_lgr_grp;
        if :old.lgr_typ != c.seg1
        or :old.lte_namen_cfg like ( '%'
                                     || c.euro
                                     || c.te_trenner || '%' ) then
            v_max_lte := nvl(:old.lgr_max_te,
                             0);
        end if;

        if v_found then
            if nvl(v_max_lte, 0) != 0 then
                v_lgr_grp.lgr_gruppe_max_lte := nvl(v_lgr_grp.lgr_gruppe_max_lte, 0) - v_max_lte;
                update lvs_lgr_grp grp
                set
                    grp.lgr_gruppe_max_lte = v_lgr_grp.lgr_gruppe_max_lte
                where
                    grp.lgr_gruppe_id = :old.lgr_gruppe_id;

            end if;
        end if;

    end if;

end tr_lvs_lgr_bd;
/

alter trigger dirkspzm32.tr_lvs_lgr_bd enable;


-- sqlcl_snapshot {"hash":"c906093e6f52b5b726c41cdc2db5959e7af73269","type":"TRIGGER","name":"TR_LVS_LGR_BD","schemaName":"DIRKSPZM32","sxml":""}