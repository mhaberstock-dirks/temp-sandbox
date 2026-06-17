
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_KOPF_BIU" 
  before insert or update on DIRKSPZM32.isi_order_kopf
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_li_nr     isi_order_kopf.li_nr%type;
begin

  if inserting
  then
    if :new.status is null
    then
      :new.status := 'N'; -- ab 3.5.2 Status Neu ist 'N' anstatt Null
    end if;
    if :new.vorgang_typ = 'WAI'
    and :new.satzart = 'MA'
    then
      if :new.vorgang_id is null
      then
        select SEQ_ISI_ORDER_MA_LIEF.nextval into v_li_nr from dual;
        :new.vorgang_id := v_li_nr;
        :new.li_nr := v_li_nr;
      end if;

      if :new.order_datum is null
      then
        :new.order_datum := sysdate;
      end if;
      if :new.liefer_datum is null
      then
        :new.liefer_datum := :new.order_datum;
      end if;
    end if;
  end if;
  if updating
  then
    if  :old.status != 'E'
    and :new.status = 'E'  -- Fertig
    then
      :new.fertig_datum := nvl(:new.fertig_datum, sysdate); -- Wenn Fertigdatum nicht gesetzt, dann jetzt setzen da fertig
    end if;
    if :new.prioritaet != :old.prioritaet
    then
      update isi_order_pos pos
         set pos.prioritaet = :new.prioritaet
       where pos.sid = :new.sid
         and pos.firma_nr = :new.firma_nr
         and pos.vorgang_typ = :new.vorgang_typ
         and pos.vorgang_id = :new.vorgang_id;
    end if;
    if nvl(:new.transport_gruppe, 0) != nvl(:old.transport_gruppe, 0)
    then
      update isi_order_pos pos
         set pos.transport_gruppe = :new.transport_gruppe
       where pos.sid = :new.sid
         and pos.firma_nr = :new.firma_nr
         and pos.vorgang_typ = :new.vorgang_typ
         and pos.vorgang_id = :new.vorgang_id;
    end if;
    if :new.wa_verladepunkt != :old.wa_verladepunkt
    or (    :old.wa_verladepunkt is null
        and :new.wa_verladepunkt is not NULL)
    then
      :new.ziel := :new.wa_verladepunkt;
    end if;
    if :new.ziel != :old.ziel
    or (    :old.ziel is null
        and :new.ziel is not NULL)
    then
      update isi_order_pos pos
         set pos.ziel = :new.ziel
       where pos.sid = :new.sid
         and pos.firma_nr = :new.firma_nr
         and pos.vorgang_typ = :new.vorgang_typ
         and pos.vorgang_id = :new.vorgang_id;
    end if;
    if :new.arbeitsplatz_id != :old.arbeitsplatz_id
    or (    :old.arbeitsplatz_id is null
        and :new.arbeitsplatz_id is not NULL)
    then
      update isi_order_pos pos
         set pos.arbeitsplatz_id = :new.arbeitsplatz_id
       where pos.sid = :new.sid
         and pos.firma_nr = :new.firma_nr
         and pos.vorgang_typ = :new.vorgang_typ
         and pos.vorgang_id = :new.vorgang_id
         and nvl(pos.arbeitsplatz_id, :new.arbeitsplatz_id + 1) != :new.arbeitsplatz_id
         and (pos.arbeitsplatz_id = :old.arbeitsplatz_id
           or pos.arbeitsplatz_id is NULL);
    end if;
    if :new.ziel != :old.ziel
    and :new.satzart not in ('MAK', 'LAK', 'LNK') -- -AG- In diesem fall bestimmt der Kopf nicht das Ziel aller positionen
    then
      update isi_order_pos pos
         set pos.ziel = :new.ziel
       where pos.sid = :new.sid
         and pos.firma_nr = :new.firma_nr
         and pos.vorgang_typ = :new.vorgang_typ
         and pos.vorgang_id = :new.vorgang_id
         and pos.ziel != :new.ziel
         and (pos.ziel = :old.ziel
           or pos.ziel is NULL);
    end if;
    if nvl(:new.lvs_info, 'nix') != nvl(:old.lvs_info, 'nix')
    then
      update isi_order_pos pos
         set pos.lvs_info = :new.lvs_info
       where pos.sid = :new.sid
         and pos.firma_nr = :new.firma_nr
         and pos.vorgang_typ = :new.vorgang_typ
         and pos.vorgang_id = :new.vorgang_id;
    end if;
  end if;
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
end TR_ISI_ORDER_KOPF_BU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_KOPF_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"6fbd9c80c75301c25327c9bc016b41a4babfc702","type":"TRIGGER","name":"TR_ISI_ORDER_KOPF_BIU","schemaName":"DIRKSPZM32","sxml":""}