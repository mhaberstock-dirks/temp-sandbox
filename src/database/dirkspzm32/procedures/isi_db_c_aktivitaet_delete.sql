create or replace 
procedure DIRKSPZM32.isi_db_c_aktivitaet_delete(in_tabelle in varchar2,
																											 in_pk_feld in varchar2,
																											 in_row_id  in varchar2,
																											 in_ts      in timestamp) is
begin

  if in_tabelle is not NULL
  then
    delete isi_db_aktivitaet t
     where t.quell_row_id = in_row_id
       and t.tab_name = in_tabelle
       and t.tab_pk_feldwert = in_pk_feld
       and t.time <= in_ts
       and t.aktion != 'I'
       and t.aktion != 'D';
  else
    delete isi_db_aktivitaet t
     where t.id = in_pk_feld;
  end if;
  commit;
end isi_db_c_aktivitaet_delete;
/



-- sqlcl_snapshot {"hash":"bd559940549c8e3b3a5ff9bcbcb1fec7e2c800bd","type":"PROCEDURE","name":"ISI_DB_C_AKTIVITAET_DELETE","schemaName":"DIRKSPZM32","sxml":""}