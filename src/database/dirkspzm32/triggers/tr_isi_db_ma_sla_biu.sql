create or replace editionable trigger dirkspzm32.tr_isi_db_ma_sla_biu before
    update or insert on dirkspzm32.isi_db_ma_sla
    for each row
declare
	-- local variables here
 begin
    if inserting then
        isi_message_board.send_message(null,                 -- in_sender_name                 in     varchar2,
                                       null,                 -- in_sender_module_name          in     varchar2,
                                       null,                 -- in_sender_application_handle   in     varchar2,
                                       null,                 -- in_recipient_name              in     varchar2,
                                       null,                 -- in_recipient_module_name       in     varchar2,
                                       null,                 -- in_response_required           in     boolean,
                                       c.msg_mt_application, -- in_message_type                in     number,
                                       c.msg_mc_ma_sla,      -- in_message_command             in     number,
                                       0,                    -- in_data_type                   in     number,
                                       :new.db_funktion);    -- in_data                        in     varchar2)
    end if;

    if updating then
        if :new.db_funktion != :old.db_funktion then
            isi_message_board.send_message(null,                 -- in_sender_name                 in     varchar2,
                                           null,                 -- in_sender_module_name          in     varchar2,
                                           null,                 -- in_sender_application_handle   in     varchar2,
                                           null,                 -- in_recipient_name              in     varchar2,
                                           null,                 -- in_recipient_module_name       in     varchar2,
                                           null,                 -- in_response_required           in     boolean,
                                           c.msg_mt_application, -- in_message_type                in     number,
                                           c.msg_mc_ma_sla,      -- in_message_command             in     number,
                                           0,                    -- in_data_type                   in     number,
                                           :new.db_funktion);    -- in_data                        in     varchar2)
        end if;

    end if;

end tr_isi_db_ma_sla_bu;
/

alter trigger dirkspzm32.tr_isi_db_ma_sla_biu enable;


-- sqlcl_snapshot {"hash":"65a0992ee9d5ab140854080cd1c0cf28232327f3","type":"TRIGGER","name":"TR_ISI_DB_MA_SLA_BIU","schemaName":"DIRKSPZM32","sxml":""}