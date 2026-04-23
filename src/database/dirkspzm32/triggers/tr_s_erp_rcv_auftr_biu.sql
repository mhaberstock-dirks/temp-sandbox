
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_AUFTR_BIU" 
  before insert or update or delete on S_ERP_RCV_AUFTR
  for each row
declare
  v_adr                   isi_adressen%rowtype;
  v_rcv_auftr             s_rcv_auftr%rowtype;
  v_art                   isi_artikel%rowtype;
  v_found                 boolean;

  CURSOR c_rcv_auftr is
    select *
      from s_rcv_auftr t
     where t.auf_id = :new.auf_id;

  CURSOR c_adr is
    select *
      from isi_adressen t
     where t.adr_art = :new.adr_art
       and t.adr_nr = :new.adr_nr
       and t.adr_liefer = :new.adr_liefer;

  CURSOR c_art is
    select *
      from isi_artikel t
     where t.artikel = :new.artikel;
begin

  if inserting
  or updating
  then

    If :new.satzart not in ('BE', 'BK', 'RK')
    then
      :new.tour := nvl(:new.tour, to_char(:new.vorgang));
    else
      :new.tour := nvl(:new.tour, to_char(:new.auftrag));
    end if;


    if nvl(:new.vorgang, 0) = 0
    then
      :new.vorgang := :new.li_nr;
    end if;

    OPEN c_adr;
    FETCH c_adr into v_adr;
    v_found := c_adr%FOUND;
    CLOSE c_adr;

    if NOT v_found
    then
      insert into s_rcv_adr
        (firma_nr,
         adr_art,
         adr_nr,
         adr_liefer,
         name_1,
         aktiv)
      values
        (1,
        :new.adr_art,
        :new.adr_nr,
        :new.adr_liefer,
        'ISI-AUTO-Bestellung Nummer: ' ||  :new.adr_nr,
        'T');
    end if;

    OPEN c_art;
    FETCH c_art into v_art;
    v_found := c_art%FOUND;
    CLOSE c_art;

    if NOT v_found
    then
      insert into s_rcv_artikel
        (firma_nr,
        artikel,
        bezeichnung1,
        bezeichnung2,
        CREATED_DATE,
        aktiv)
      values
        (1,
        :new.artikel,
        'ISI-AUTO-Artikel',
        :new.artikel,
        sysdate,
        'T');

    end if;

    OPEN c_rcv_auftr;
    FETCH c_rcv_auftr into v_rcv_auftr;
    v_found := c_rcv_auftr%FOUND;
    CLOSE c_rcv_auftr;
  end if;

  if inserting
  or not v_found
  then
    if :new.satzart = 'BE'
    or :new.satzart = 'BK'             -- KONSI Bestellung
    or :new.satzart = 'RK'
    then
      update s_rcv_auftr t
         set t.status = 'L'
       where t.vorgang = :new.auftrag
         and t.satzart = :new.SATZART
         and t.pos_nr = :new.pos_nr;
    end if;
    :new.IST_MENGE := nvl(:new.IST_MENGE, 0);
    begin
      if :new.auf_id is NULL
      then
        select SEQ_S_AUFTR.NEXTVAL into :new.auf_id from dual;
      end if;
      insert into s_rcv_auftr
           values (
                    :new.FIRMA_NR,
                    :new.auf_id,
                    decode(:new.satzart, 'LI',
                           :new.vorgang,    -- VORGANG_ID        NUMBER,
                           :new.auftrag),
                    :new.SATZART,
                    :new.AUFTRAG,
                    :new.POS_NR,
                    :new.UPOS_NR,
                    :new.ARTIKEL,
                    :new.ADR_ART,
                    :new.ADR_NR,
                    :new.ADR_LIEFER,
                    :new.LEITZAHL,
                    :new.CHARGE,
                    :new.SERIENNR,
                    nvl(:new.STRATEGIE, 'FIFO'),
                    :new.MHD,
                    :new.li_nr,
                    :new.li_pos_nr,
                    decode (:new.arbeitsplatz_id, 'VS1', 101,
                            decode (:new.arbeitsplatz_id, 'VS2', 201, NULL)),
                    :new.KOM_INFO,
                    :new.SOLL_MG,
                    :new.IST_MENGE,
                    :new.STATUS,
                    nvl(:new.WA_ZIEL, 'SPED'),
                    :new.created_date,
                    :new.LVS_INFO,
                    decode(nvl(:new.PRIORITAET, 0), 0, 3, :new.PRIORITAET),
                    :new.best_nr_kunde,
                    NULL,
                    NULL,
                    null,
                    :new.best_term,
                    'HOST',
                    :new.lam_sel1,       -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.lam_sel2,       -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.lam_sel3,       -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.lam_sel4,       -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.lam_sel5,       -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.lam_sel6,       -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.lam_sel7,       -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.lam_sel8,       -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.lam_sel9,       -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.lam_sel10,      -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                    :new.tour,           -- Tour
                    NULL                 --  UEBER_UNTER_LIEFERN  N VARCHAR2(4) Y

                    )
          returning status into :new.status;
          return;
    exception
      when dup_val_on_index then NULL;
    end;
  end if;

  if updating
  then
    update s_rcv_auftr a
         set
              a.firma_nr = :new.FIRMA_NR,
              a.vorgang = decode(:new.satzart, 'LI',
                                 :new.vorgang,    -- VORGANG_ID        NUMBER,
                                  :new.auftrag),
              a.satzart = :new.SATZART,
              a.auftrag = :new.AUFTRAG,
              a.pos_nr = :new.POS_NR,
              a.upos_nr = :new.UPOS_NR,
              a.artikel = :new.ARTIKEL,
              a.adr_art = :new.ADR_ART,
              a.adr_nr = :new.ADR_NR,
              a.adr_liefer = :new.ADR_LIEFER,
              a.leitzahl = :new.LEITZAHL,
              a.charge = :new.CHARGE,
              a.seriennr = :new.SERIENNR,
              --a.strategie = nvl(:new.STRATEGIE, 'FIFO'),
              a.mhd = :new.MHD,
              a.li_nr = :new.li_nr,
              a.li_pos_nr = :new.li_pos_nr,
              a.arbeitsplatz_id = decode (:new.arbeitsplatz_id, 'VS1', 101,
                                    decode (:new.arbeitsplatz_id, 'VS2', 201, NULL)),
              a.kom_info = :new.KOM_INFO,
              a.soll_mg = :new.SOLL_MG,
              --a.ist_menge = :new.IST_MENGE,
              --a.wa_ziel = nvl(:new.WA_ZIEL, 'SPED'),
              a.gen_datum = :new.created_date,
              --a.prioritaet = :new.PRIORITAET,
              a.status = :new.status,
              a.best_nr_kunde = :new.best_nr_kunde,
              a.liefer_datum =  :new.best_term,
              a.lam_sel1 =      :new.lam_sel1,       -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.lam_sel2 =      :new.lam_sel2,       -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.lam_sel3 =      :new.lam_sel3,       -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.lam_sel4 =      :new.lam_sel4,       -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.lam_sel5 =      :new.lam_sel5,       -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.lam_sel6 =      :new.lam_sel6,       -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.lam_sel7 =      :new.lam_sel7,       -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.lam_sel8 =      :new.lam_sel8,       -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.lam_sel9 =      :new.lam_sel9,       -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.lam_sel10 =     :new.lam_sel10,      -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              a.tour =          :new.tour            -- Tour
     where a.firma_nr = :new.FIRMA_NR
       and a.auf_id = :new.auf_id;
  elsif deleting then
    delete s_rcv_auftr a
     where a.firma_nr = :old.FIRMA_NR
       and a.auf_id = :old.auf_id;
  end if;

end TR_S_ERP_RCV_AUFTR;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_AUFTR_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"e40ffe03940423811f42acf619db19a20aa319da","type":"TRIGGER","name":"TR_S_ERP_RCV_AUFTR_BIU","schemaName":"DIRKSPZM32","sxml":""}