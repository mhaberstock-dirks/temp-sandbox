create or replace editionable trigger dirkspzm32.tr_pzm_abwesenheitsarten before
    insert on dirkspzm32.pzm_abwesenheitsarten
    for each row
declare
  -- local variables here
 begin
    if :new.aa_id is null then
        select
            seq_aa_id.nextval
        into :new.aa_id
        from
            dual;

    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_abwesenheitsarten enable;


-- sqlcl_snapshot {"hash":"b27958e7e3e6e4fc7a387cc6139d10e7950c96c2","type":"TRIGGER","name":"TR_PZM_ABWESENHEITSARTEN","schemaName":"DIRKSPZM32","sxml":""}