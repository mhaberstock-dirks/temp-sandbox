create or replace 
procedure DIRKSPZM32.a1_init_database_data is
  v_count number; -- Count of records of any table
begin
  --~~~~~~~~~~~~~~~~ General ISI_* tables ~~~~~~~~~~~~~~~~--
  
  -- ISI_SID --
  select count(*) into v_count from isi_sid;
  if v_count = 0
  then
    insert into isi_sid (sid, sid_name, sid_my_sid, sid_status)
    values ('01', 'auto_created', 1, 'T');
  end if;
  
  -- ISI_FIRMA --
  select count(*) into v_count from isi_firma;
  if v_count = 0
  then
    insert into isi_firma (sid, firma_nr, bezeichnung, info, adress_id)
    select 01, 1, 'Meine_Firma', 'Standardfirma automatisch angelegt', 0 from dual;
  end if;
  
  -- ISI_ADRESSEN (eigene Adressen) --
 select count(*) into v_count from isi_adressen;
  if v_count = 0
  then
    insert into isi_adressen (sid, adress_id, firma_nr, adr_art, adr_nr, adr_liefer, name_1)
                      select '01', 1, 1, 'E', 1, 0, 'Meine Firma' from dual;
  end if;
  
  -- ISI_LANGUAGE --
  select count(*) into v_count from isi_language;
  if v_count = 0
  then
    insert into isi_language (lang_id, lang_name, lang_key, charset, font_name, lang_code)
                      select  1,       'German',  'DE',     0,       'Tahoma',  'de'      from dual
                      union
                      select  2,       'English', 'EN',     0,       'Tahoma',  'en'      from dual
                      union
                      select  5,       'Dutch',   'NL',     0,       'Tahoma',  'nl'      from dual
                      union
                      select  4,       'Polish',  'PL',     0,       'Tahoma',  'pl'      from dual
                      union
                      select  3,       'Czech',   'CS',     0,       'Tahoma',  'cs'      from dual;
  end if;
  
  -- ISI_RES_STATUS_CFG --
  select count(*) into v_count from isi_res_status_cfg;
  if v_count = 0
  then
    insert into isi_res_status_cfg (sid, firma_nr, res_st_id, res_typ, st_gruppe, st_text,                st_fg_color, st_bg_color)
      select                        '01',1,        -1,        'MS',    'P',       'Unbegründete Störung', 65535,       255         from dual
      union
      select                        '01',1,        0,         'MS',    'P',       'Maschine läuft',       0,           12639424    from dual
      union
      select                        '01',1,        1,         'MS',    'R',       'Rüsten',               8388608,     128         from dual;
  end if;
  --~~~~~~~~~~~~~~~~ BDE_* tables ~~~~~~~~~~~~~~~~--

  --~~~~~~~~~~~~~~~~ LVS_* tables ~~~~~~~~~~~~~~~~--
  -- LVS_LTE_CFG --
  -- LVS_LHM_CFG --

  --~~~~~~~~~~~~~~~~ PZM_* tables ~~~~~~~~~~~~~~~~--
end;
/



-- sqlcl_snapshot {"hash":"fcc672fb0723b9d1aec3554c7fc633d419bab16d","type":"PROCEDURE","name":"A1_INIT_DATABASE_DATA","schemaName":"DIRKSPZM32","sxml":""}