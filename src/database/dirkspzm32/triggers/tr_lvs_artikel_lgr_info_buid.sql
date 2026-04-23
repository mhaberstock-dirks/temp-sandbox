create or replace editionable trigger dirkspzm32.tr_lvs_artikel_lgr_info_buid before
    insert or update or delete on dirkspzm32.lvs_artikel_lgr_info
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if :new.lvs_art_lgr_info_id is null then
            select
                seq_lvs_artikel_lgr_info.nextval
            into :new.lvs_art_lgr_info_id
            from
                dual;

        end if;

    end if;
end tr_lvs_artikel_lgr_info_buid;
/

alter trigger dirkspzm32.tr_lvs_artikel_lgr_info_buid enable;


-- sqlcl_snapshot {"hash":"470a5cdd4707ed98f0658d9197c9b52a163951a3","type":"TRIGGER","name":"TR_LVS_ARTIKEL_LGR_INFO_BUID","schemaName":"DIRKSPZM32","sxml":""}