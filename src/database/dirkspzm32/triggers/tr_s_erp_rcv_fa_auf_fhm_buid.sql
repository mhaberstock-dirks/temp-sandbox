
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_FA_AUF_FHM_BUID" 
  before insert or update  or delete on DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM
  for each row
declare
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);

  v_fa_fhm           s_rcv_fa_auf_fhm%rowtype;
  v_fa_res_list      bde_fa_auftrag_res_liste%rowtype;
  v_fa_res_fhm       isi_res_fhm%rowtype;
  v_fa_res_fhm_list  isi_res_fhm_list%rowtype;

  v_found       boolean;

  CURSOR c_fa_res_list is
    select *
      from bde_fa_auftrag_res_liste rl
     where rl.sid = '01'
       and rl.firma_nr = :new.firma_nr
       and rl.leitzahl = :new.leitzahl
       and rl.fa_ag = :new.fa_ag;

  CURSOR c_fa_res_fhm is
    select *
      from isi_res_fhm rf
     where rf.firma_nr = :new.firma_nr
       and rf.fhm = :new.prod_fhm;

  CURSOR c_fa_res_fhm_list is
    select *
      from isi_res_fhm_list rf
     where rf.res_id = v_fa_res_list.res_id
       and rf.fhm = :new.prod_fhm;

  CURSOR c_fa_FHM is
    select *
      from s_rcv_fa_auf_FHM t
     where t.sid = '01'
       and t.firma_nr = :new.firma_nr
       and t.leitzahl = :new.leitzahl
       and t.FA_AG    = :new.FA_AG
       and t.FA_UPOS  = :new.FA_UPOS
       and t.prod_fhm = :new.prod_fhm;

begin

  if inserting
  or updating
  then

    OPEN c_fa_FHM;
    FETCH c_fa_FHM into v_fa_FHM;
    v_found := c_fa_FHM%FOUND;
    CLOSE c_fa_FHM;
    v_fa_fhm.fhm_grp := :new.fhm_grp;

    if nvl(:new.fhm_grp, 0) = 0
    and not v_found
    then
      select nvl(max(t.fhm_grp), 0) + 1 into v_fa_fhm.fhm_grp
        from bde_fa_auftrag_fhm t
       where t.sid = '01'
         and t.firma_nr = :new.firma_nr
         and t.leitzahl = :new.leitzahl
         and t.FA_AG    = :new.FA_AG
         and t.FA_UPOS  = :new.FA_UPOS;
    end if;

    if not v_found
    then
      begin
        insert into s_rcv_fa_auf_FHM
             values ( '01',
                      :new.FIRMA_NR,
                      :new.auf_id,
                      :new.AUFTRAG,
                      :new.LEITZAHL,
                      :new.FA_AG,
                      :new.FA_UPOS,
                      :new.prod_fhm,
                      v_fa_fhm.fhm_grp,
                      1                      --Aktuell nicht in der Schnittstellentabelle, dann immer 1
                      );
      exception
        when dup_val_on_index then NULL;
      end;
    else
      update s_rcv_fa_auf_fhm t
         set t.auf_id = :new.auf_id,
             t.auftrag = :new.auftrag,
             t.fhm_grp = nvl(nvl(:new.fhm_grp, t.fhm_grp), v_fa_fhm.fhm_grp)
       where t.sid = '01'
         and t.firma_nr = :new.firma_nr
         and t.leitzahl = :new.leitzahl
         and t.FA_AG    = :new.FA_AG
         and t.FA_UPOS  = :new.FA_UPOS
         and t.prod_fhm = :new.prod_fhm;
    end if;

    if :new.ruest_zeit > 0
    then
      OPEN c_fa_res_fhm;
      FETCH c_fa_res_fhm into v_fa_res_fhm;
      v_found := c_fa_res_fhm%FOUND;
      CLOSE c_fa_res_fhm;
      if not v_found
      then
        insert into isi_res_fhm
          values('01',
                 :new.FIRMA_NR,
                 :new.prod_fhm,
                 'DYN_GEN_' || :new.prod_fhm,
                 NULL,
                 NULL,
                 NULL,
                 2,
                 100000,
                 100,
                 0,
                 0,
                 NULL,
                 nvl(:new.ruest_zeit, 0),
                 0,
                 'T',
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL);
      end if;
      OPEN c_fa_res_list;
      FETCH c_fa_res_list into v_fa_res_list;
      LOOP
        exit when c_fa_res_list%NOTFOUND;
        OPEN c_fa_res_fhm_list;
        FETCH c_fa_res_fhm_list into v_fa_res_fhm_list;
        v_found := c_fa_res_fhm_list%FOUND;
        CLOSE c_fa_res_fhm_list;
        if not v_found
        then
          insert into isi_res_fhm_list
            values(:new.prod_fhm,
                   v_fa_res_list.res_id,
                   to_date('01.01.2000','dd.mm.yyyy'),
                   to_date('01.01.2999 00:00:00','dd.mm.yyyy hh24:mi:ss'),
                   0,
                   100
                   );
        end if;
        FETCH c_fa_res_list into v_fa_res_list;

      end LOOP;
      CLOSE c_fa_res_list;
    end if;
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
end TR_S_ERP_RCV_FA_AUF_FHM_BUID;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_FA_AUF_FHM_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"70701acb2ccc908827ed774cabe2cc87ec2ae1d1","type":"TRIGGER","name":"TR_S_ERP_RCV_FA_AUF_FHM_BUID","schemaName":"DIRKSPZM32","sxml":""}