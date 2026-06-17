
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."V_ISI_CHECK_SEQUENCES" ("TABLE_NAME_", "SEQ_NAME_", "FIELD_NAME_", "Kommentar_", "SEQ_TAB_WERTE") AS 
  select check_table_name(upper(s."table_name_") ) Table_Name_,
       upper(s."sequence_name_") SEQ_Name_,
       check_field_name(upper(s."table_name_"),upper(s."field_name_") ) Field_Name_,
       s."Kommentar_",
       isi_check_sequence(upper(s."sequence_name_"), get_max_index(upper(s."table_name_"), upper(s."field_name_"))) SEQ_TAB_Werte
  from v_isi_tab_field_seq s
 order by s."table_name_" asc
;


-- sqlcl_snapshot {"hash":"cbc2ec852a1db056763770c1fcfab1c05af9b038","type":"VIEW","name":"V_ISI_CHECK_SEQUENCES","schemaName":"DIRKSPZM32","sxml":""}