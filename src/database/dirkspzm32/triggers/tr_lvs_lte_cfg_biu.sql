create or replace editionable trigger dirkspzm32.tr_lvs_lte_cfg_biu before
    insert or update on dirkspzm32.lvs_lte_cfg
    for each row
declare
    v_ems_artikel ems_artikel%rowtype;
    lte           lvs_lte_cfg%rowtype;
    v_found       boolean;

  -- local variables here
    cursor c_ems_artikel is
    select
        *
    from
        ems_artikel t
    where
            t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.ems_art_name = :new.lte_name;

begin
    open c_ems_artikel;
    fetch c_ems_artikel into v_ems_artikel;
    v_found := c_ems_artikel%found;
    close c_ems_artikel;
    if not v_found then
        insert into ems_artikel (
            sid,
            firma_nr,
            ems_art_name,
            erz_login_id,
            erz_datum,
            aend_login_id,
            aend_datum,
            ems_art_text,
            ems_art_gruppe_id,
            aktiv,
            beschreibung,
            mengen_einheit,
            gewicht_kg,
            foto_datei_k,
            foto_datei_n,
            artikel_id,
            lte_name,
            lhm_name
        ) values ( :new.sid,
                   :new.firma_nr,
                   :new.lte_name,
                   - 1,
                   sysdate,
                   null,
                   null,
                   substr(:new.lte_text,
                          1,
                          50),
                   null,
                   'T',
                   :new.lte_text,
                   'STK',
                   nvl(lte.lte_gew_kg, 0),
                   null,
                   null,
                   null,
                   :new.lte_name,
                   null );

    else
        update ems_artikel
        set
            aend_login_id = - 1,
            aend_datum = sysdate,
            ems_art_text = substr(:new.lte_text,
                                  1,
                                  50),
            ems_art_gruppe_id = null,
            aktiv = 'T',
            beschreibung = :new.lte_text,
            gewicht_kg = nvl(lte.lte_gew_kg, 0),
            lte_name = :new.lte_name
        where
                sid = :new.sid
            and firma_nr = :new.firma_nr
            and ems_art_name = :new.lte_name;

    end if;

end tr_lvs_lte_cfg_biu;
/

alter trigger dirkspzm32.tr_lvs_lte_cfg_biu enable;


-- sqlcl_snapshot {"hash":"509f15168732e6a7fabd8a43dd3ab121f377a345","type":"TRIGGER","name":"TR_LVS_LTE_CFG_BIU","schemaName":"DIRKSPZM32","sxml":""}