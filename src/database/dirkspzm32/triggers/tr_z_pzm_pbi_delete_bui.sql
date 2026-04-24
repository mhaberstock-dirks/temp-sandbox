create or replace editionable trigger dirkspzm32.tr_z_pzm_pbi_delete_bui before
    insert or update on dirkspzm32.z_pzm_pbi_delete
    for each row
declare begin
    if inserting then
        if
            :new.pers_nr >= 80000
            and :new.pers_nr <= 89999
        then
            :new.status := 'I';
        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_z_pzm_pbi_delete_bui enable;


-- sqlcl_snapshot {"hash":"f043aa239c5e1392b161f428182f45961e891af4","type":"TRIGGER","name":"TR_Z_PZM_PBI_DELETE_BUI","schemaName":"DIRKSPZM32","sxml":""}