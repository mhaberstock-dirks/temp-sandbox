create or replace editionable trigger dirkspzm32.tr_lvs_lgr_aiud after
    insert or update on dirkspzm32.lvs_lgr
    for each row
declare begin
--  if INSERTING then
--    dbms_alert.SIGNAL('LVS_LGR_INSERT', to_char(:new.lgr_Platz));
--  elsif UPDATING then
--    dbms_alert.SIGNAL('LVS_LGR_UPDATE', to_char(:new.lgr_Platz));
--  end if;
    null;
end tr_lvs_lgr_aiud;
/

alter trigger dirkspzm32.tr_lvs_lgr_aiud enable;


-- sqlcl_snapshot {"hash":"be959df11a1d6501a7936cabc80904ea8cbfb0da","type":"TRIGGER","name":"TR_LVS_LGR_AIUD","schemaName":"DIRKSPZM32","sxml":""}