create or replace editionable trigger dirkspzm32.tr_abwesenheitsmeld_biu before
    insert or update on dirkspzm32.pzm_abwesenheitsmeldungen
    for each row
declare
  -- local variables here
 begin
    if inserting then
        select
            seq_km_id.nextval
        into :new.km_id
        from
            dual;

        :new.erz_datum := sysdate;
    end if;

    if updating then
        :new.aend_datum := sysdate;
    end if;
    :new.anz_tage := ( trunc(:new.ende) - trunc(:new.beginn) ) + 1;

end tr_krankmeld_bi;
/

alter trigger dirkspzm32.tr_abwesenheitsmeld_biu enable;


-- sqlcl_snapshot {"hash":"30eef55c660e529ccd3ccd42dafd23d9a81d6fef","type":"TRIGGER","name":"TR_ABWESENHEITSMELD_BIU","schemaName":"DIRKSPZM32","sxml":""}