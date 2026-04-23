create or replace editionable trigger dirkspzm32.tr_meldung_daten_biu before
    insert or update on dirkspzm32.meldung_daten
    for each row
declare
  -- local variables here
 begin
    if inserting then
        select
            seq_md_id.nextval
        into :new.md_id
        from
            dual;

    end if;
end tr_meldung_daten_biu;
/

alter trigger dirkspzm32.tr_meldung_daten_biu enable;


-- sqlcl_snapshot {"hash":"32c677b893fd18ab45d0484ee5588c51af8a774f","type":"TRIGGER","name":"TR_MELDUNG_DATEN_BIU","schemaName":"DIRKSPZM32","sxml":""}