create or replace 
package DIRKSPZM32.PRINT_ALLG is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG)  30.07.2008 10:54:05
  __________________________________________________
  Description
  Funktionen für Printengine.
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
	30.07.2008   3.3.4.1     (-AG-)   Erstellt
  */



  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

  PE_TYP_ETI          constant varchar2(3)  := 'ETI';
  PE_TYP_WIN          constant varchar2(3)  := 'WIN';

  --------------------------------------------------------------------------------
  -- Function gibt einen Druckerdatensatz zurück
  --
  --------------------------------------------------------------------------------
  function get_drucker(in_sid             in pe_drucker_cfg.sid%type,
                       in_firma_nr        in pe_drucker_cfg.firma_nr%type,
                       in_drucker_name    in pe_drucker_cfg.drucker_name%type,
                       io_drucker         in out pe_drucker_cfg%rowtype) return boolean;

  function get_eti_drucker_typ(in_drucker_typ     in pe_eti_drucker_typen.lp_type%type,
                               io_drucker_typ     in out pe_eti_drucker_typen%rowtype) return boolean;

  function get_drucker_layout_cfg(in_sid                in pe_drucker_layout_cfg.sid%type,
                                  in_firma_nr           in pe_drucker_layout_cfg.firma_nr%type,
                                  in_drucker_name       in pe_drucker_layout_cfg.drucker_name%type,
                                  in_layout_name        in pe_drucker_layout_cfg.src_layout_name%type,
                                  in_layout_datei       in pe_drucker_layout_cfg.src_layout_datei%type,
                                  io_drucker_layout_cfg in out pe_drucker_layout_cfg%rowtype
                                 ) return boolean;

end PRINT_ALLG;
/



-- sqlcl_snapshot {"hash":"16c1d9e8007d26d0058bd850f03da0146e4db965","type":"PACKAGE_SPEC","name":"PRINT_ALLG","schemaName":"DIRKSPZM32","sxml":""}