create or replace editionable trigger dirkspzm32.tr_ems_konten_biu before
    insert on dirkspzm32.ems_konten
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if :new.ems_konto_nr is null then
            select
                seq_ems_konto_nr.nextval
            into :new.ems_konto_nr
            from
                dual;

        end if;

    end if;
end tr_ems_konten_biu;
/

alter trigger dirkspzm32.tr_ems_konten_biu enable;


-- sqlcl_snapshot {"hash":"a2e2f549e034a22fc8434f109373063f1bb24868","type":"TRIGGER","name":"TR_EMS_KONTEN_BIU","schemaName":"DIRKSPZM32","sxml":""}