create or replace editionable trigger dirkspzm32.tr_lvs_lte_bi before
    insert on dirkspzm32.lvs_lte
    for each row
declare
  -- local variables here
 begin
    delete lvs_lte_hist t
    where
        t.lte_id = :new.lte_id;

    if
        :new.order_auf_id is null
        and :old.order_auf_id = -1
    then
        update lvs_lam lam
        set
            lam.order_pos_auf_id = null
        where
                lam.lte_id = :new.lte_id
            and lam.order_pos_auf_id = - 1;

    end if;

    if
        :new.res_string is null
        and :new.lte_akt_lhm = 0         -- c.LEERPAL
    then
        :new.res_string := :new.lte_name;    -- -AG- Fuer Leerbehältereinlagerung und Gleichverteilung
    end if;

end tr_lvs_lte_bi;
/

alter trigger dirkspzm32.tr_lvs_lte_bi enable;


-- sqlcl_snapshot {"hash":"ab29c95c2d2e37637576a4d8e9c516864f37fa4b","type":"TRIGGER","name":"TR_LVS_LTE_BI","schemaName":"DIRKSPZM32","sxml":""}