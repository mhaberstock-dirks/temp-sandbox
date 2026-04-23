create or replace editionable trigger dirkspzm32.tr_isi_script_cfg_biu before
    insert or update on dirkspzm32.isi_script_cfg
    for each row
declare
	-- local variables here
 begin
    if inserting then
        :new.build := 1;
        if :new.script_id is null then
            select
                seq_script_cfg_id.nextval
            into :new.script_id
            from
                dual;

        end if;

    elsif updating then
        :new.build := :new.build + 1;
        insert into isi_script_cfg_hist values ( :old.sid,
                                                 :old.firma_nr,
                                                 :old.script_id,
                                                 :old.script_name,
                                                 :old.script_info,
                                                 :old.script_internal,
                                                 :old.edit_security_level,
                                                 :old.erz_login_id,
                                                 :old.erz_datum,
                                                 :old.aend_login_id,
                                                 :old.aend_datum,
                                                 :old.script_source_type,
                                                 :old.script_source,
                                                 :old.script_pre_comp_b64,
                                                 :old.debug_input_data,
                                                 :old.debug_output_data,
                                                 :old.script_context,
                                                 :old.enabled,
                                                 :old.last_debug,
                                                 :old.last_execution,
                                                 :old.last_exec_duration_ms,
                                                 :old.last_var_result_list,
                                                 :old.exec_order,
                                                 :old.build );

    end if;
end tr_isi_script_cfg_biu;
/

alter trigger dirkspzm32.tr_isi_script_cfg_biu enable;


-- sqlcl_snapshot {"hash":"404f53986aabdc6232fd0821e9dfda3a8c044e5b","type":"TRIGGER","name":"TR_ISI_SCRIPT_CFG_BIU","schemaName":"DIRKSPZM32","sxml":""}