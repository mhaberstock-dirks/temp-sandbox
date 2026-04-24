create or replace editionable trigger dirkspzm32.tr_dw_lvs_bestand_bi before
    insert or update on dirkspzm32.dw_lvs_bestand
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if :new.dw_stat_id is null
           or :new.dw_stat_id = 0 then
            select
                seq_dw_lvs_bestand.nextval
            into :new.dw_stat_id
            from
                dual;

        end if;

        if :new.erfasst_am is null then
            select
                sysdate
            into :new.erfasst_am
            from
                dual;

        end if;

    end if;
end tr_dw_lvs_bestand_bi;
/

alter trigger dirkspzm32.tr_dw_lvs_bestand_bi enable;


-- sqlcl_snapshot {"hash":"7d480144f03bcfa4f54fb986103b3624507915d5","type":"TRIGGER","name":"TR_DW_LVS_BESTAND_BI","schemaName":"DIRKSPZM32","sxml":""}