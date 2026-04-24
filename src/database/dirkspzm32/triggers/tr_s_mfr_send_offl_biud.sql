create or replace editionable trigger dirkspzm32.tr_s_mfr_send_offl_biud before
    insert or update or delete on dirkspzm32.s_mfr_send_offline
    for each row
declare
  -- local variables here
 begin
    if inserting then
        select
            seq_s_send_bew_id.nextval
        into :new.offline_id
        from
            dual;

    elsif updating then
        null;
    elsif deleting then
        null;
    end if;

    if deleting then
        begin
            insert into s_mfr_send_offline_hist values ( :old.firma_nr,
                                                         :old.offline_id,
                                                         :old.auf_id,
                                                         :old.satzart,
                                                         :old.funktion,
                                                         :old.auftrag,
                                                         :old.lte_id,
                                                         :old.gen_datum,
                                                         :old.quelle,
                                                         :old.ziel,
                                                         :old.telegramm,
                                                         :old.gruppe );

        end;

    end if;

end tr_s_mfr_send_offl_biud;
/

alter trigger dirkspzm32.tr_s_mfr_send_offl_biud enable;


-- sqlcl_snapshot {"hash":"fd507a96378531695cfb179f997037a31e38ebdb","type":"TRIGGER","name":"TR_S_MFR_SEND_OFFL_BIUD","schemaName":"DIRKSPZM32","sxml":""}