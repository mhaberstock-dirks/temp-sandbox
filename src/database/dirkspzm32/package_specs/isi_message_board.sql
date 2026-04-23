create or replace package dirkspzm32.isi_message_board is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  05.10.2004 16:51:29
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
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
    );

    procedure c_send_raw_message (
        in_raw_data in varchar2
    );

    procedure c_send_raw_message (
        in_signal   in varchar2,
        in_raw_data in varchar2
    );

end isi_message_board;
/


-- sqlcl_snapshot {"hash":"3f7d99439ce99c3479e7fdaecca46ce8f44840f5","type":"PACKAGE_SPEC","name":"ISI_MESSAGE_BOARD","schemaName":"DIRKSPZM32","sxml":""}