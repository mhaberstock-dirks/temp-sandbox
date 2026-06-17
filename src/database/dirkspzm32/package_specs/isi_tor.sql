create or replace 
package DIRKSPZM32.isi_TOR is

  /*
  __________________________________________________
  Author
  A.Gödeke (-AG-)  07.08.2007 21:30:06
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
	             3.4.1.1:    (-AG-)   Neu erstellt
  */

  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;


  -- Public Funktions und Prozedur-Deklaration

  function c_tor_open_time(in_tor_id            in isi_tor_cfg.tor_id_lesegeraet%type,
                           in_tor_rs485_adresse in isi_tor_cfg.tor_rs485_adresse%type,
                           in_transponder       in isi_user.transponder%type
                          ) return number;


  function tor_check_dauer_open(in_tor_id            in isi_tor_cfg.tor_id_lesegeraet%type,
                                in_tor_rs485_adresse in isi_tor_cfg.tor_rs485_adresse%type
                                ) return number;

end isi_tor;
/



-- sqlcl_snapshot {"hash":"e00d1bfad57a49c704dd429ebc06f7dd10954f53","type":"PACKAGE_SPEC","name":"ISI_TOR","schemaName":"DIRKSPZM32","sxml":""}