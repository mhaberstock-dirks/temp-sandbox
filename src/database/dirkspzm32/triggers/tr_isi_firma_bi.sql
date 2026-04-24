create or replace editionable trigger dirkspzm32.tr_isi_firma_bi before
    insert on dirkspzm32.isi_firma
    for each row
declare
  -- local variables here

  -- Gibt es bereits eine Adresse für diese Firma ?
    cursor c_adr is
    select
        a.adress_id
    from
        isi_adressen a
    where
            a.sid = :new.sid
        and a.firma_nr = :new.firma_nr
        and a.adr_art = 'E'
        and a.adr_nr = :new.firma_nr
        and a.adr_liefer = '0';

    v_adresse_id isi_adressen.adress_id%type;   -- Adress_ID der Adresse
    v_found      boolean;                       -- Adresse gefunden ?
begin
    if :new.adress_id is null then
        open c_adr;
        fetch c_adr into v_adresse_id;                      -- Lesen der Adersse
        v_found := c_adr%found;
        close c_adr;
        if v_found then
            :new.adress_id := v_adresse_id;                   -- Gelese Adresse eintragen
        else
            :new.adress_id := isi_adresse_insert(:new.sid,
                                                 :new.firma_nr,
                                                 'E',
                                                 :new.firma_nr,
                                                 0);
        end if;

    end if;
end tr_isi_firma_bi;
/

alter trigger dirkspzm32.tr_isi_firma_bi enable;


-- sqlcl_snapshot {"hash":"cbe54f7736fab9740d92c6265f89d06f9fa56e55","type":"TRIGGER","name":"TR_ISI_FIRMA_BI","schemaName":"DIRKSPZM32","sxml":""}