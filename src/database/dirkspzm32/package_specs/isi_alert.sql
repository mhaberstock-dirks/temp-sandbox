create or replace package dirkspzm32.isi_alert is

  /*
  __________________________________________________
  Author
  B.Welling  (-BWe-)  04.05.2020
  __________________________________________________
  Description
  Funktionen für das Alerting in ISI_PLus
  Die Alerts werden über die Tabelle ISI_ALERT_QUEUE
  verteilt.
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  05.05.2020   R.31       (-BWe-)   Minor Release
  */

    procedure c_insert_mail (
        in_mail_address in isi_mail_queue.mail_address%type,
        in_betreff      in isi_mail_queue.betreff_text%type,
        in_inhalt       in isi_mail_queue.inhalt_text%type,
        in_send_modul   in isi_mail_queue.send_modul%type
    );

    procedure c_service_res_meld_alert;

end isi_alert;
/


-- sqlcl_snapshot {"hash":"e3dcdc8f252ceac59b2acc7e3a1f4049327bd229","type":"PACKAGE_SPEC","name":"ISI_ALERT","schemaName":"DIRKSPZM32","sxml":""}