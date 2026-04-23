create or replace editionable trigger dirkspzm32.tr_pzm_konten_bh_bu before
    update on dirkspzm32.pzm_konten_bh
    for each row
declare
  -- Lokale Variablen
 begin
    if :new.wert != :new.wert then
        raise_application_error(-20000, 'Anpassen eines Buchungswertes ist nicht möglich. Bitte Stornierung oder Korrekturbuchung benutzen.'
        );
    end if;
end tr_pzm_konten_bh_bu;
/

alter trigger dirkspzm32.tr_pzm_konten_bh_bu enable;


-- sqlcl_snapshot {"hash":"fbdcd58623ddb240598789029be1233e20c16d02","type":"TRIGGER","name":"TR_PZM_KONTEN_BH_BU","schemaName":"DIRKSPZM32","sxml":""}