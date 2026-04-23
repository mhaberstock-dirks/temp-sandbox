create or replace package body dirkspzm32.isi_message_board is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error exception;
    --v_err_nr    number;
    --v_err_text  varchar2(255);

  -- Function and procedure implementations
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function Verpackt eine Message in den für ISIPlus benoetigten Rahmen
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure send_message (
        in_sender_name               in varchar2,
        in_sender_module_name        in varchar2,
        in_sender_application_handle in varchar2,
        in_recipient_name            in varchar2,
        in_recipient_module_name     in varchar2,
        in_response_required         in boolean,
        in_message_type              in number,
        in_message_command           in number,
        in_data_type                 in number,
        in_data                      in varchar2,
        in_db_user_name              in varchar2 default null
    ) is

        pragma autonomous_transaction;
        v_tf_txt            varchar2(10);
        v_protokoll         varchar2(4000);
        v_database_username varchar2(100);
    begin
        if in_response_required then
            v_tf_txt := 'True';
        else
            v_tf_txt := 'False';
        end if;
        if in_db_user_name is null then
            v_database_username := dbms_standard.login_user;
        else
            v_database_username := in_db_user_name;
        end if;

        v_protokoll := '<isi_message> ';
        v_protokoll := v_protokoll
                       || '<sender name="'
                       || nvl(in_sender_name, '')
                       || '" module_name="'
                       || nvl(in_sender_module_name, '')
                       || '" application_handle="'
                       || nvl(in_sender_application_handle, 0)
                       || '" database_username="'
                       || nvl(v_database_username, '')
                       || '"/> ';

        v_protokoll := v_protokoll
                       || '<recipient name="'
                       || nvl(in_recipient_name, '')
                       || '" module_name="'
                       || nvl(in_recipient_module_name, '')
                       || '"/>';

        v_protokoll := v_protokoll
                       || '<response_required>'
                       || nvl(v_tf_txt, '')
                       || '</response_required> ';

        v_protokoll := v_protokoll
                       || '<message_type>'
                       || nvl(
            to_char(in_message_type),
            '0'
        )
                       || '</message_type> ';

        v_protokoll := v_protokoll
                       || ' <message_command>'
                       || nvl(
            to_char(in_message_command),
            '0'
        )
                       || '</message_command> ';

        v_protokoll := v_protokoll
                       || ' <data_type>'
                       || nvl(
            to_char(in_data_type),
            '0'
        )
                       || '</data_type> ';

        v_protokoll := v_protokoll
                       || ' <data>'
                       || nvl(in_data, '')
                       || '</data> ';

        v_protokoll := v_protokoll || ' </isi_message> ';
        dbms_alert.signal('isi_message', v_protokoll);
        commit;
    end;

    procedure c_send_raw_message (
        in_raw_data in varchar2
    ) is
        pragma autonomous_transaction;
    begin
        dbms_alert.signal('isi_message', in_raw_data);
        commit;
    end;

    procedure c_send_raw_message (
        in_signal   in varchar2,
        in_raw_data in varchar2
    ) is
        pragma autonomous_transaction;
    begin
        dbms_alert.signal(in_signal, in_raw_data);
        commit;
    end;
--begin
  -- Initialization
  --<Statement>;
end isi_message_board;
/


-- sqlcl_snapshot {"hash":"1e93193e667e79c7169defa25058dce329bfe29f","type":"PACKAGE_BODY","name":"ISI_MESSAGE_BOARD","schemaName":"DIRKSPZM32","sxml":""}