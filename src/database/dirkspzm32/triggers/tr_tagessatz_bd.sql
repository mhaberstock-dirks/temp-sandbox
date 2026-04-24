create or replace editionable trigger dirkspzm32.tr_tagessatz_bd before
    delete on dirkspzm32.pzm_ze_tagessatz
    for each row
declare
  -- local variables here
 begin
    update pzm_ze_loa_ausw t
    set
        t.aa_id = null
    where
            t.zeaw_pers_nr = :old.ts_pers_nr
        and t.zeaw_datum = :old.ts_datum;

    delete pzm_ze_loa_ausw t
    where
            t.zeaw_pers_nr = :old.ts_pers_nr
        and t.zeaw_datum = :old.ts_datum;

end;
/

alter trigger dirkspzm32.tr_tagessatz_bd enable;


-- sqlcl_snapshot {"hash":"10a3a25609f2aa820441e5ab7701cc7160403917","type":"TRIGGER","name":"TR_TAGESSATZ_BD","schemaName":"DIRKSPZM32","sxml":""}