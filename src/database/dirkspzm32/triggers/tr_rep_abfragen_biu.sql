create or replace editionable trigger dirkspzm32.tr_rep_abfragen_biu before
    insert or update on dirkspzm32.rep_abfragen
    for each row
declare
  -- local variables here
 begin
    if inserting then
        select
            seq_rep_id.nextval
        into :new.rep_id
        from
            dual;

    end if;
end tr_rep_abfragen_biu;
/

alter trigger dirkspzm32.tr_rep_abfragen_biu enable;


-- sqlcl_snapshot {"hash":"18ef74a68b832e0d31c480e0d317b643e0083d02","type":"TRIGGER","name":"TR_REP_ABFRAGEN_BIU","schemaName":"DIRKSPZM32","sxml":""}