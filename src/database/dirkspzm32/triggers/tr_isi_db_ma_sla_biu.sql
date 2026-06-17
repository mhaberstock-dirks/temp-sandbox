
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_DB_MA_SLA_BIU" 
  before update or insert on DIRKSPZM32.isi_db_ma_sla
  for each row
declare
	-- local variables here
begin
	if inserting
	then
      isi_message_board.send_message(NULL,                 -- in_sender_name                 in     varchar2,
                                     NULL,                 -- in_sender_module_name          in     varchar2,
                                     NULL,                 -- in_sender_application_handle   in     varchar2,
                                     NULL,                 -- in_recipient_name              in     varchar2,
                                     NULL,                 -- in_recipient_module_name       in     varchar2,
                                     NULL,                 -- in_response_required           in     boolean,
                                     c.MSG_MT_APPLICATION, -- in_message_type                in     number,
                                     c.MSG_MC_MA_SLA,      -- in_message_command             in     number,
                                     0,                    -- in_data_type                   in     number,
                                     :new.db_funktion);    -- in_data                        in     varchar2)
	end if;
	if updating
	then
		if :new.db_funktion != :old.db_funktion
		then
      isi_message_board.send_message(NULL,                 -- in_sender_name                 in     varchar2,
                                     NULL,                 -- in_sender_module_name          in     varchar2,
                                     NULL,                 -- in_sender_application_handle   in     varchar2,
                                     NULL,                 -- in_recipient_name              in     varchar2,
                                     NULL,                 -- in_recipient_module_name       in     varchar2,
                                     NULL,                 -- in_response_required           in     boolean,
                                     c.MSG_MT_APPLICATION, -- in_message_type                in     number,
                                     c.MSG_MC_MA_SLA,      -- in_message_command             in     number,
                                     0,                    -- in_data_type                   in     number,
                                     :new.db_funktion);    -- in_data                        in     varchar2)
		end if;
	end if;
end tr_isi_db_ma_sla_bu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_DB_MA_SLA_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"a454f62be2aee0fe9237c359f4b994b914e2919e","type":"TRIGGER","name":"TR_ISI_DB_MA_SLA_BIU","schemaName":"DIRKSPZM32","sxml":""}