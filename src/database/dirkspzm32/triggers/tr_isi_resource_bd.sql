create or replace editionable trigger dirkspzm32.tr_isi_resource_bd before
    delete on dirkspzm32.isi_resource
    for each row
declare
  -- local variables here
 begin
    delete from isi_resource_zust_akt
    where
            sid = :old.sid
        and res_id = :old.res_id;

    delete from isi_resource_var
    where
            sid = :old.sid
        and res_id = :old.res_id;

end tr_isi_resource_bd;
/

alter trigger dirkspzm32.tr_isi_resource_bd enable;


-- sqlcl_snapshot {"hash":"2a31c28d47f7915da021bbe034d96cf3cf6a121c","type":"TRIGGER","name":"TR_ISI_RESOURCE_BD","schemaName":"DIRKSPZM32","sxml":""}