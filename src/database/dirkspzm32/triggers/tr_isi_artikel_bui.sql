create or replace editionable trigger dirkspzm32.tr_isi_artikel_bui before
    insert or update on dirkspzm32.isi_artikel
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if nvl(:new.artikel_id,
               0) = 0 then
            select
                seq_artikel_id.nextval
            into :new.artikel_id
            from
                dual;

        end if;

        if :new.artikel_id = -1 then
            :new.artikel_id := 0;
        end if;

--  elsif UPDATING
--    Hier kommt die Abhandlung, wenn Äderungen von Artikel gespeichert werden sollen
--    if then
--
--    end if;
    end if;

    if :new.menge_basis = c.basis_lhm then
        :new.mengeneinheit_basis := :new.lhm_name;
    elsif :new.menge_basis = c.basis_lte then
        :new.mengeneinheit_basis := :new.lte_name;
    else
        :new.mengeneinheit_basis := :new.mengeneinheit;
    end if;

end;
/

alter trigger dirkspzm32.tr_isi_artikel_bui enable;


-- sqlcl_snapshot {"hash":"0236e9754f16c74152bf6ceb84b3616930c29c83","type":"TRIGGER","name":"TR_ISI_ARTIKEL_BUI","schemaName":"DIRKSPZM32","sxml":""}