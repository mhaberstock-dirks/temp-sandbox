create or replace 
package body DIRKSPZM32.ISI_Migration is


  /*******************************************************************************
  * function get_version (...)
  *******************************************************************************/
  function get_version return varchar2 is
  begin
    return(v_version_str);
  end;

	/*******************************************************************************
  * function c_update_action_info (...)
  *******************************************************************************/

	function c_update_action_info(in_action_old_name        in varchar2,
	                               in_action_new_name       in varchar2) return varchar2 is
		v_return_str varchar2(100);
		v_action_id number;
  	v_action_info_old sec_action_info%rowtype;
  	v_action_info_new sec_action_info%rowtype;
		v_found_new       boolean;
		v_found_old       boolean;

		cursor c_action_info_new is
			select *
				from sec_action_info
			 where name = in_action_new_name;
		cursor c_action_info_old is
			select *
				from sec_action_info
			 where name = in_action_old_name;
  begin
 		open c_action_info_new;

		fetch c_action_info_new
			into v_action_info_new;
		v_found_new := c_action_info_new%found;
 		open c_action_info_old;

		fetch c_action_info_old
			into v_action_info_old;
		v_found_old := c_action_info_old%found;

    if (v_found_old) and (v_found_new) then

		  v_action_id := v_Action_info_new.Action_Id;
			delete sec_action_info t
         where t.Action_id  = v_action_id;
			commit;
		end if;
		if (v_found_old) then
		  v_action_id := v_Action_info_old.Action_Id;
			update sec_action_info t
			   set t.name = in_action_new_name
         where t.Action_id  = v_action_id;
			commit;
		end if;
		close c_action_info_old;
		close c_action_info_new;

   return(v_return_str);
end;

	/*******************************************************************************
  * function c_migration_to_3_5_1 (...)
  *******************************************************************************/
	-- !!!! Das muss von Hand gemacht werden. !!!!
	-- Ansicht transporte arbeiten jetzt mit Benutzerberechtigung
  function c_migration_to_3_5_1 return varchar2 is
		v_return_str varchar2(100);
  begin

	  v_return_str := '';
		-- Update ISI_Firma_CFG
		update isi_firma t
		  set t.lte_barcode_type = 'STD'
		  where t.lte_barcode_type = 'Standard';
		update isi_firma t
		  set t.lhm_barcode_type = 'STD'
		  where t.lhm_barcode_type = 'Standard';
		commit;
    -- Anpassung  LTE_SEC_ACTION_INFO     old           new
	  v_return_str := c_update_action_info('act_RB01',  'act_ISRL01');
	  v_return_str := c_update_action_info('act_LWA01', 'act_LWA02');
	  v_return_str := c_update_action_info('act_RA01',  'act_ISRD01');
    return(v_return_str);
		-- Anpassung ISI_LANGUAGE
		update isi_language  l
		  set l.lang_key   = 'DE'
		  where l.lang_key = 'lang_name_german';
		update isi_language  l
		  set l.lang_key   = 'EN'
		  where l.lang_key = 'lang_name_english';
		update isi_language  l
		  set l.lang_key   = 'NL'
		  where l.lang_key = 'lang_name_dutch';

  end;





end ISI_Migration;
/



-- sqlcl_snapshot {"hash":"35f2c9b623dac6b00078dc884ddb130fff3f97fc","type":"PACKAGE_BODY","name":"ISI_MIGRATION","schemaName":"DIRKSPZM32","sxml":""}