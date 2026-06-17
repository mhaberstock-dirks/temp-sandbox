
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_QS_BABTEC_FAUF_BU" 
  before update on DIRKSPZM32.bde_fa_auftrag
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_res                                              isi_resource%rowtype;
  v_art                                              isi_artikel%rowtype;

  cursor c_res is
    select *
      from isi_resource t
     where t.res_id = :new.res_id;

  cursor c_art is
    select *
      from isi_artikel t
     where t.artikel_id = :new.ag_artikel_id;


begin
  if  ( :new.freig_status != 'N'
    and nvl(:old.freig_status, 'NULL') = 'N'
      )
  then
    v_res := NULL;
    v_art := NULL;

    OPEN c_res;
    FETCH c_res into v_res;
    CLOSE c_res;

    OPEN c_art;
    FETCH c_art into v_art;
    CLOSE c_art;

    begin
      if :new.satzart = 'V'
      or :new.satzart = 'VR'
      then
        insert into s_qs_babtec_fauf t
           values (lpad(to_char(:new.leitzahl), 7, '0')
                  -- || '/' || lpad(to_char(:new.fa_ag), 3, '0') Jetzt nur eine Meldung je FA
                  , -- Nur die erste Meldung je FA von der ersten Maschine die den FA anmeldet
                  -- || '-' || nvl(v_res.res_ext_name, 'Fehlt')
                  -- || '-' || to_char(trunc(sysdate), 'yyyy-mm-dd'), -- AUFTRAGNR   VARCHAR2(30) not null,
                  nvl(v_art.artikel, 'Fehlt'),
                  -- 2019.07.02 - Anpassung der Kundennummer an Stammdaten (7 stellig Kundennummer + 6 stellig Lieferadresse)
                  lpad(nvl(:new.kunden_nr, '0'), 7, '0')
                       || '-'
                       || lpad(decode(to_char(nvl(:new.kunden_nr_adr_liefer, '1')), '1', '0', to_char(:new.kunden_nr_adr_liefer)), 6, '0'),
                  --:new.kunden_nr || '-' || :new.kunden_nr_adr_liefer,
                                                                   -- KUNDENNR    VARCHAR2(30),
                  :new.ag_soll_mg,                                 -- LIEFERMENGE NUMBER,
                  :new.BEST_NR_KUNDE,                              -- BESTELLNR   VARCHAR2(30),
                  :new.ab_text2,                                   -- BENUTZER1   VARCHAR2(60), Hier die Charge
                  v_res.res_ext_name,                              -- BENUTZER2   VARCHAR2(60)
                  v_art.mengeneinheit,                             -- Mengeneinhei
                  'N',                                             -- :new.status := 'N';
                  sysdate,                                         -- :new.erstell_datum := nvl(:new.erstell_datum, sysdate);
                  NULL,                                            -- :new.bearb_datum := sysdate;
                  NULL,                                            -- FEHLER_CODE N NUMBER  Y     Host-Übertragung Fehlernummer
                  NULL);                                           -- FEHLER_TEXT N VARCHAR2(255) Y     Host-Übertragung Fehlertext
      end if;
    exception
      when others then NULL;
    end;
  end if;

exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
  when v_error then
    RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text);
    raise;
  when others then
    if v_err_nr is not NULL then
        RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text, true);
    else
        raise;
    end if;
end TR_S_QS_BABTEC_AUF_BU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_QS_BABTEC_FAUF_BU" ENABLE;


-- sqlcl_snapshot {"hash":"78666fbf5697bfc123632bbb2c3b277ad42d77c2","type":"TRIGGER","name":"TR_S_QS_BABTEC_FAUF_BU","schemaName":"DIRKSPZM32","sxml":""}