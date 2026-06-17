
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_PURCH_KOPF_BU" 
  before update on DIRKSPZM32.isi_purch_kopf
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);
  v_id        isi_purch_kopf.id%Type;
  v_kunden    isi_adressen%RowType;
  v_found     boolean;

  CURSOR c_kunden is
    select *
      from isi_adressen t
     where t.adress_id = :new.kunde_id;

begin
  if updating
  then
     --if :new.vorg_typ ='BE' or v_header.vorg_typ ='AN' then
        -- nichts zu tun
     --end if;
     if :new.vorg_typ ='AUFTR'
     then
        OPEN c_kunden;
        FETCH c_kunden into v_kunden;
        v_found := c_kunden%FOUND;
        CLOSE c_kunden;

        if v_found = false then
           v_err_nr := 20;
           v_err_text := lc.ec_p1(lc.O_TP1_TXT_ADRESSE_NF  , to_char( :new.kunde_id));
        end if;
        if :old.status != 'E'
        then
          :new.aend_datum := Sysdate;
        end if;
        if :new.status = 'F'
        then
          return;
        end if;
        if (:new.liefer_datum <> :old.liefer_datum) or
           (:new.Lieferschein_nr <> :old.lieferschein_nr) or
           (:new.kunde_id <> :old.kunde_id) then
           update
             s_rcv_kunden_auftr_pos a
              set
               a.liefer_datum = :new.liefer_datum,
               a.fertig_datum = :new.liefer_datum,
               a.adr_nr       = v_kunden.adr_nr,
               a.adr_liefer   = v_kunden.adr_liefer,
               a.li_nr        = :new.Lieferschein_Nr
           where
             a.auftrag  = :new.id;
        end if;

     end if;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_PURCH_KOPF_BU" ENABLE;


-- sqlcl_snapshot {"hash":"c00af3cddaff49bce726ec8ea189193f5ebf9ebf","type":"TRIGGER","name":"TR_ISI_PURCH_KOPF_BU","schemaName":"DIRKSPZM32","sxml":""}