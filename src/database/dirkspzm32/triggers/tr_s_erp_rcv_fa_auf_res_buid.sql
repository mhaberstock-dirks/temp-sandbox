
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_FA_AUF_RES_BUID" 
  before insert or update  or delete on DIRKSPZM32.S_ERP_RCV_FA_AUF_RES
  for each row
declare
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);

  v_res         isi_resource%rowtype;
  v_fa_res      s_rcv_fa_auf_res%rowtype;

  v_found       boolean;

  CURSOR c_fa_res is
    select *
      from s_rcv_fa_auf_res t
     where t.sid = '01'
       and t.firma_nr = :new.firma_nr
       and t.leitzahl = :new.leitzahl
       and t.fa_ag = :new.fa_ag
       and t.fa_upos = :new.fa_upos
       and t.satzart = :new.satzart
       and t.res_id = v_res.res_id;

begin

  if inserting
  or updating
  then
    if not isi_p_base.get_resource_by_ext_name(:new.maschine, v_res)
    then
      v_err_nr := 10;
      v_err_text := 'Maschine ' || :new.maschine || ' nicht konfiguriert';
      raise v_error;
    end if;

    OPEN c_fa_res;
    FETCH c_fa_res into v_fa_res;
    v_found := c_fa_res%FOUND;
    CLOSE c_fa_res;

    if not v_found
    then
      begin
        insert into s_rcv_fa_auf_res
             values ( '01',
                      :new.FIRMA_NR,
                      :new.auf_id,
                      :new.AUFTRAG,
                      :new.LEITZAHL,
                      :new.FA_AG,
                      :new.FA_UPOS,
                      :new.SATZART,
                      v_res.res_id,
                      :new.minuten,
                      :new.minuten_ruesten
                      );
         return;
      exception
        when dup_val_on_index then NULL;
      end;
    end if;

    update s_rcv_fa_auf_res t
         set t.minuten = :new.Minuten,
             t.minuten_ruesten = :new.minuten_ruesten
     where t.sid = '01'
       and t.firma_nr = :new.firma_nr
       and t.leitzahl = :new.leitzahl
       and t.fa_ag = :new.fa_ag
       and t.fa_upos = :new.fa_upos
       and t.satzart = :new.satzart
       and t.res_id = v_res.res_id;
  end if;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
  when v_error then  -- Update 2011 show Exception Source Line
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end TR_S_ERP_RCV_FA_AUF_RES_BUID;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_FA_AUF_RES_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"905ad065bbac5cfe553cde138a3aac14675fe098","type":"TRIGGER","name":"TR_S_ERP_RCV_FA_AUF_RES_BUID","schemaName":"DIRKSPZM32","sxml":""}