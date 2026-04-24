create or replace editionable trigger dirkspzm32.tr_bde_fa_auftrag_stl_bi before
    insert on dirkspzm32.bde_fa_auftrag_stl
    for each row
declare
  -- local variables here
 begin
    if :new.fa_ag_stl_id is null then
        select
            seq_fa_ag_stl_id.nextval
        into :new.fa_ag_stl_id
        from
            dual;

    end if;
end tr_bde_fa_auftrag_stl_bi;
/

alter trigger dirkspzm32.tr_bde_fa_auftrag_stl_bi enable;


-- sqlcl_snapshot {"hash":"96bc0e444c782ef65140fb9fb89a8962118f7c31","type":"TRIGGER","name":"TR_BDE_FA_AUFTRAG_STL_BI","schemaName":"DIRKSPZM32","sxml":""}