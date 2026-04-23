create or replace editionable trigger dirkspzm32.tr_isi_transport_aiud after
    insert or update or delete on dirkspzm32.isi_transport
    for each row
declare
  -- local variables here
 begin
  -- dbms_alert.signal('Transport_aenderung', 0);
    if updating
    or inserting then
        if :new.modul_bearbeiter != 'MFR' then
            isi_message_board.c_send_raw_message('Transport_aenderung', 0);
        end if;
    else
    -- deleting
        if :old.modul_bearbeiter != 'MFR' then
            isi_message_board.c_send_raw_message('Transport_aenderung', 0);
        end if;
    end if;

    if updating then
        if :new.res_id is not null then
            if
                :new.modul_bearbeiter = 'MFR'
                and (
                    :new.status != 'G'
                    and :old.status = 'G'
                )
            or (
                :new.status = 'F' -- WK 2015-09-21 keine gesperrten Transporte an den MFR Server melden
                and ( nvl(:old.res_id,
                          -1) != :new.res_id
                or nvl(:new.lgr_platz_quelle,
                       'PLATZ_FEHLT') != nvl(:old.lgr_platz_quelle,
                                             'PLATZ_FEHLT')
                or nvl(:new.lgr_platz_ziel,
                       'PLATZ_FEHLT') != nvl(:old.lgr_platz_ziel,
                                             'PLATZ_FEHLT') )
            ) then
                isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,
                                               null,                              -- in_sender_module_name          in     varchar2,
                                               null,                              -- in_sender_application_handle   in     varchar2,
                                               null,                              -- in_recipient_name              in     varchar2,
                                               'mfr_server',                      -- in_recipient_module_name       in     varchar2,
                                               false,                             -- in_response_required           in     boolean,
                                               c.msg_mt_mfr_server,               -- in_message_type                in     number,
                                               c.msg_mc_mfr_neuer_transport,      -- in_message_command             in     number,
                                               0,                                 -- in_data_type                   in     number,
                                               :new.res_id);                      -- in_data                        in     varchar2)
            end if;

            if
                :new.modul_bearbeiter = 'MFR' -- AG 2018.07.17 - Transport wird jetzt durch eine anderes RBG gefahren
                and :new.res_id != :old.res_id
                and :old.res_id is not null
                and :new.status = 'F'
            then
                isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,
                                               null,                              -- in_sender_module_name          in     varchar2,
                                               null,                              -- in_sender_application_handle   in     varchar2,
                                               null,                              -- in_recipient_name              in     varchar2,
                                               'mfr_server',                      -- in_recipient_module_name       in     varchar2,
                                               false,                             -- in_response_required           in     boolean,
                                               c.msg_mt_mfr_server,               -- in_message_type                in     number,
                                               c.msg_mc_mfr_n_resid_transport,    -- in_message_command             in     number,
                                               0,                                 -- in_data_type                   in     number,
                                               'OLD_RES_ID='
                                               || to_char(:old.res_id)
                                               || ';'
                                               || 'NEW_RES_ID='
                                               || to_char(:new.res_id)
                                               || ';'
                                               || 'TRANSP_ID='
                                               || to_char(:new.transp_id));          -- in_data                        in     varchar2)
            end if;

        end if;

    elsif inserting then
        if :new.res_id is not null then
            if
                :new.modul_bearbeiter = 'MFR'
                and :new.status != 'G' -- WK 2015-09-21 keine gesperrten Transporte an den MFR Server melden
            then
                isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,
                                               null,                              -- in_sender_module_name          in     varchar2,
                                               null,                              -- in_sender_application_handle   in     varchar2,
                                               null,                              -- in_recipient_name              in     varchar2,
                                               'mfr_server',                      -- in_recipient_module_name       in     varchar2,
                                               false,                             -- in_response_required           in     boolean,
                                               c.msg_mt_mfr_server,               -- in_message_type                in     number,
                                               c.msg_mc_mfr_neuer_transport,      -- in_message_command             in     number,
                                               0,                                 -- in_data_type                   in     number,
                                               :new.res_id);                      -- in_data                        in     varchar2)
            end if;

        else
      -- no resource assigned now
            if
                :old.res_id is not null
                and :new.status != 'G'                                              -- Nurt wenn Frei, dann fuer MFR wichtig
            then
                if :old.modul_bearbeiter = 'MFR' then
                    isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,
                                                   null,                              -- in_sender_module_name          in     varchar2,
                                                   null,                              -- in_sender_application_handle   in     varchar2,
                                                   null,                              -- in_recipient_name              in     varchar2,
                                                   'mfr_server',                      -- in_recipient_module_name       in     varchar2,
                                                   false,                             -- in_response_required           in     boolean,
                                                   c.msg_mt_mfr_server,               -- in_message_type                in     number,
                                                   c.msg_mc_mfr_del_transport,        -- in_message_command             in     number,
                                                   0,                                 -- in_data_type                   in     number,
                                                   :old.res_id);                      -- in_data                        in     varchar2)
                end if;

            end if;
        end if;
    else
    -- deleting
        if :old.res_id is not null then
            if
                :old.modul_bearbeiter = 'MFR'
                and ( :old.status = c.trans_frei
                or :old.status = c.trans_zugew
                or :old.status = c.trans_begin )
            then
                isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,
                                               null,                              -- in_sender_module_name          in     varchar2,
                                               null,                              -- in_sender_application_handle   in     varchar2,
                                               null,                              -- in_recipient_name              in     varchar2,
                                               'mfr_server',                      -- in_recipient_module_name       in     varchar2,
                                               false,                             -- in_response_required           in     boolean,
                                               c.msg_mt_mfr_server,               -- in_message_type                in     number,
                                               c.msg_mc_mfr_del_transport,        -- in_message_command             in     number,
                                               0,                                 -- in_data_type                   in     number,
                                               :old.res_id);                      -- in_data                        in     varchar2)
            end if;

        end if;
    end if;

end;
/

alter trigger dirkspzm32.tr_isi_transport_aiud enable;


-- sqlcl_snapshot {"hash":"f4f764b22b3e3ed76d46a736a8df285e5ce79f56","type":"TRIGGER","name":"TR_ISI_TRANSPORT_AIUD","schemaName":"DIRKSPZM32","sxml":""}