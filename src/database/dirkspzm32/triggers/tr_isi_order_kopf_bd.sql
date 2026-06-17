
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_KOPF_BD" 
  before delete on DIRKSPZM32.isi_order_kopf
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_order_pos isi_order_pos%rowtype;

  cursor c_order_pos is
    select t.*
      from isi_order_pos t
     where t.sid = :old.sid
       and t.vorgang_typ = :old.vorgang_typ
       and t.vorgang_id = :old.vorgang_id
       and (nvl(t.li_nr, -1) = nvl(:old.li_nr, -1)
         or (t.satzart != 'LI' and :old.li_nr is NULL));

  v_found boolean;

  v_result    number;

  v_lte_id       lvs_lte.lte_id%type;
  v_auf_id       lvs_lte.order_auf_id%type;

   CURSOR c_lte is
     select t.lte_id, t.order_auf_id from lvs_lte t
      where t.order_vorgang_id = :old.vorgang_id;

begin
  delete isi_komm_order t
    where t.vorgang_id = :old.vorgang_id;

  OPEN c_lte;
  FETCH c_lte into v_lte_id, v_auf_id;
  LOOP
    EXIT when c_lte%NOTFOUND;
    v_result := lvs_ausl.lvs_lte_res_rueck (:old.sid,
                                            :old.firma_nr,
                                            :old.vorgang_id,
                                            v_auf_id,
                                            v_lte_id,
                                            :old.vorgang_id,
                                            NULL,
                                            c.c_true);


    FETCH c_lte into v_lte_id, v_auf_id;
  end LOOP;
  CLOSE c_lte;

  open c_order_pos;
  fetch c_order_pos into v_order_pos;
  v_found := c_order_pos%found;
  close c_order_pos;

  if v_found
  then
    v_err_nr := 10;
    v_err_text := 'Der Datensatz mit der VorgangID ' || :old.vorgang_id || ' kann nicht gelöscht werden, ' ||
                  'da noch Positionen vorhanden sind! Es müssen erst alle Positionen gelöscht werden.';
    raise v_error;
  end if;

  update lvs_lte lte
     set lte.order_vorgang_id = NULL,
         lte.order_auf_id = NULL
   where lte.order_vorgang_id = :old.vorgang_id;
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
end tr_isi_order_kopf_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_KOPF_BD" ENABLE;


-- sqlcl_snapshot {"hash":"a6651294bbfd585e3c420499997f0773afabe3eb","type":"TRIGGER","name":"TR_ISI_ORDER_KOPF_BD","schemaName":"DIRKSPZM32","sxml":""}