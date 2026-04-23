create or replace editionable trigger dirkspzm32.tr_lvs_prod_linie_waren_bi before
    insert on dirkspzm32.lvs_prod_linie_waren
    for each row
declare
  -- local variables here
 begin
    if :new.waren_nr is null then
        select
            nvl(
                max(waren_nr),
                0
            ) + 1
        into :new.waren_nr
        from
            lvs_prod_linie_waren
        where
                sid = :new.sid
            and firma_nr = :new.firma_nr
            and linie_nr = :new.linie_nr;

    end if;
end tr_lvs_prod_linie_waren_bi;
/

alter trigger dirkspzm32.tr_lvs_prod_linie_waren_bi enable;


-- sqlcl_snapshot {"hash":"9c7bad59bcda1d17c0f4b73c62f1316faf821c68","type":"TRIGGER","name":"TR_LVS_PROD_LINIE_WAREN_BI","schemaName":"DIRKSPZM32","sxml":""}