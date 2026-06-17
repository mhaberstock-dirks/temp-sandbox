create or replace 
package DIRKSPZM32.security is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  02.04.2004 17:42:28
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  20.04.2007   3.4.1.2     (-AG-)   Abwaertskompatiblitaet zu Version 3.3 wieder hergestellt
  19.03.2007   3.4.1.1     (-WK-)   Versioneirung erstellt
  *                                 c_check_module_existense jetzt ohne out parameter
  *                                 ModuleCaption und -Description sind jetzt Sprachgesteuert
  *                                 ModuleID ist jetzt eine feste Konstante, die hier mitgegeben wird
  02.04.2004   3.2.0.0     (-WK-)   Package erstellt
  */


  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

  -- Nachbildung der Fuktionalitaet für Applikationen V3.3
	const_reset_captions constant boolean := false;

	function get_const_reset_captions return boolean;

	procedure c_check_module_existense(in_module_name        in varchar2,
																		 io_module_description in out varchar2,
																		 out_module_caption    out varchar2,
																		 out_module_help_file  out varchar2,
																		 out_module_id         out number);

	-- Schreibfehler!! Existiert nur wegen alten Programmen
	procedure c_check_section_exeistence(in_module_id           in number,
																			 in_section_name        in varchar2,
																			 io_section_description in out varchar2,
																			 out_section_caption    out varchar2,
																			 out_section_help_file  out varchar2,
																			 out_section_id         out number);

	procedure c_check_section_existence(in_module_id           in number,
																			in_section_name        in varchar2,
																			io_section_description in out varchar2,
																			out_section_caption    out varchar2,
																			out_section_help_file  out varchar2,
																			out_section_id         out number);

	procedure c_check_action_existence(in_section_id         in number,
																		 in_action_name        in varchar2,
																		 io_action_description in out varchar2,
																		 io_action_caption     in out varchar2,
																		 out_action_help_file  out varchar2,
																		 out_action_id         out number);

  procedure get_firma_daten(in_sid                    in  isi_sid.sid%type,
                            in_firma_nr               in  isi_firma.firma_nr%type,
                            out_firma_daten           out isi_firma%rowtype);
  -- Ende Nachbildung der Fuktionalitaet für Applikationen V3.3

  -- Ab hier die Checkfunktionen ab Version 3.4
	procedure c_check_module_existense_34 (in_module_name         in varchar2,
    																		 in_module_description  in varchar2,
    																		 in_module_caption      in varchar2,
    																		 out_module_help_file   out varchar2,
    																		 in_module_id           in number,
                                         in_lang_cn_caption     in sec_module_info.lang_cn_caption%type,
                                         in_lang_cn_description in sec_module_info.lang_cn_description%type);

	procedure c_check_section_existence_34 (in_mod_id              in number,
    																			in_section_name        in varchar2,
    																			in_section_description in varchar2,
    																			in_section_caption     in varchar2,
    																			out_section_help_file  out varchar2,
    																			out_section_id         out number,
                                          in_lang_cn_caption     in sec_section_info.lang_cn_caption%type,
                                          in_lang_cn_description in sec_section_info.lang_cn_description%type);

	procedure c_check_action_existence_34 (in_mod_id              in number,
    																		 in_action_name         in varchar2,
    																		 in_action_description  in varchar2,
    																		 in_action_caption      in varchar2,
                                         in_category            in varchar2,
    																		 out_action_help_file   out varchar2,
    																		 out_action_id          out number,
                                         in_lang_cn_caption     in sec_action_info.lang_cn_caption%type,
                                         in_lang_cn_description in sec_action_info.lang_cn_description%type);

	procedure get_enabled_modules(in_sid                in varchar2,
																in_login_id           in number,
																out_cs_module_id_list out varchar2,
																in_separator          in varchar2 default ',');

	procedure get_enabled_sections(in_sid                 in varchar2,
																 in_login_id            in number,
																 in_module_id           in number,
																 out_cs_section_id_list out varchar2,
																 in_separator           in varchar2 default ',');

	procedure get_enabled_actions(in_sid                in varchar2,
																in_login_id           in number,
																in_section_id         in number,
																out_cs_action_id_list out varchar2,
																in_separator          in varchar2 default ',');

	function is_user_valid(in_username    in varchar2,
												 in_password    in varchar2,
												 out_user_daten out isi_user%rowtype) return boolean;

	function is_user_valid(in_username  in varchar2,
												 in_password  in varchar2,
												 out_sid      out varchar2,
												 out_login_id out number,
												 out_firma_nr out number,
												 out_pers_nr  out number) return boolean;

	function is_transponder_valid(in_transponder_key in varchar2,
																out_user_daten     out isi_user%rowtype)
		return boolean;

	function is_transponder_valid(in_transponder_key in varchar2,
																out_sid            out varchar2,
																out_login_id       out number,
																out_firma_nr       out number,
																out_username       out varchar2,
																out_pers_nr        out number) return boolean;

	procedure alles_freigeben_fuer_gruppe(in_sid      in varchar2,
																				in_firma_nr in number,
																				in_group_id in sec_groups.group_id%type);

	procedure c_delete_action_info(in_action_id in sec_action_info.action_id%type);

end security;
/



-- sqlcl_snapshot {"hash":"ee69272287a440d260f7b0cd6994cbc47d829d41","type":"PACKAGE_SPEC","name":"SECURITY","schemaName":"DIRKSPZM32","sxml":""}