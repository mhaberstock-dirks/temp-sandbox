
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_RCV_KUNDEN_AUFTR_POS_BIU" 
  before insert or update on DIRKSPZM32.s_rcv_kunden_auftr_pos
  for each row
declare
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  -- local variables here
  v_found         boolean;
  v_sid              isi_sid%rowtype;
  v_adr_liefer       isi_adressen.adr_liefer%type;
  v_adress_id        isi_adressen.adress_id%type;
  v_adress_id_li     isi_adressen.adress_id%type;
  v_artikel_id       isi_artikel.artikel_id%type;
  v_mengeneinheit    isi_artikel.mengeneinheit%type;
  v_menge_basis      isi_artikel.menge_basis%type;
  v_kunden_auftr_pos tms_kunden_auftr_pos%rowtype;
  v_charge_id        lvs_charge.charge_id%type;

  v_std_anbruch_lte  s_rcv_auftr.anbruch%type;
  v_neu_std_strateg  s_rcv_auftr.strategie%type;

  CURSOR c_sid is
   select *
     from isi_sid s
    where s.sid_my_sid = 1;

  CURSOR c_adressen is
   select adr.adress_id
     from isi_adressen adr
    where adr.sid        = v_sid.sid
      and adr.firma_nr   = :new.firma_nr
      and adr.adr_art    = :new.adr_art
      and adr.adr_nr     = :new.adr_nr
      and adr.adr_liefer = v_adr_liefer;

  CURSOR c_artikel is
   select art.artikel_id, art.mengeneinheit, art.menge_basis
     from isi_artikel art
    where art.sid     = v_sid.sid
      and art.artikel = :new.artikel;

  cursor c_kunden_auftr_pos is
   select *
     from tms_kunden_auftr_pos t
    where t.sid      = nvl(:new.sid, v_sid.sid)
      and t.firma_nr = :new.firma_nr
      and t.auftrag_nr = :new.auftrag
      and t.pos_nr = :new.pos_nr
      and t.upos_nr = :new.upos_nr;

begin
  -- sid
  OPEN c_sid;
  FETCH c_sid into v_sid;
  v_found := c_sid%FOUND;
  CLOSE c_sid;


  if :new.status = 'D'
  then
    OPEN c_kunden_auftr_pos;
    FETCH c_kunden_auftr_pos into v_kunden_auftr_pos;
    v_found := c_kunden_auftr_pos%FOUND;
    CLOSE c_kunden_auftr_pos;

    -- 20200727 - LHa - Nur löschen wenn der Auftrag noch Neu ist
    if v_found and v_kunden_auftr_pos.status = 'N'
    then
      delete tms_kunden_auftr_pos t
       where t.kunden_auftr_pos_id = :old.kunden_auftr_pos_id
         and t.sid = :new.sid;
    end if;

    return; -- Nach dem Löschen fertig Den Satz in der S_Tabelle muss der DIS löschen
  end if;

  if :new.status = 'DF'
  then
    return;
  end if;

  if not v_found then
    v_sid.sid := '01';
  end if;

  v_std_anbruch_lte := nvl(:new.anbruch, isi_allg.get_firma_cfg_param(v_sid.sid, :new.firma_nr,
                                                        'ORDER_NEU_STD', 'LI',
                                                        'ANBRUCH_LTE', 'order', 'CFG',
                                                        'I', 'STRING'));
  v_neu_std_strateg := nvl(:new.strategie, isi_allg.get_firma_cfg_param(v_sid.sid, :new.firma_nr,
                                                        'ORDER_NEU_STD', 'LI',
                                                        'STRATEGIE', 'order', 'CFG',
                                                        'FIFO', 'STRING'));
    -- c_adressen
    v_adr_liefer := 0;
    OPEN c_adressen;
    FETCH c_adressen into v_adress_id;
    v_found := c_adressen%FOUND;
    CLOSE c_adressen;
    if not v_found
    then
      v_err_nr := 15;
      v_err_text := lc.ec_p1(LC.O_TP1_TXT_ADRESSE_NF, nvl(:new.adr_nr, 'NULL')); -- 'Fehler: Adressdaten fehlen für Nummer <' || nvl(:new.adr_nr, 'NULL') || '>';
      raise v_error;
    end if;

    v_adr_liefer := :new.adr_liefer;
    OPEN c_adressen;
    FETCH c_adressen into v_adress_id_li;
    v_found := c_adressen%FOUND;
    CLOSE c_adressen;
    if not v_found
    then
      v_adress_id_li := NULL;
    end if;

    -- c_artikel
    OPEN c_artikel;
    FETCH c_artikel into v_artikel_id, v_mengeneinheit, v_menge_basis;
    v_found := c_artikel%FOUND;
    CLOSE c_artikel;

    if not v_found then
       v_err_nr := 20;
       v_err_text := lc.ec_p1(LC.O_TP1_ARTIKEL_FEHLT, nvl(:new.artikel, 'NULL')); -- 'Fehler: Artikeldaten fehlen für Artikel <' || nvl(:new.artikel, 'NULL') || '>';
       raise v_error;
    end if;

    OPEN c_kunden_auftr_pos;
    FETCH c_kunden_auftr_pos into v_kunden_auftr_pos;
    v_found := c_kunden_auftr_pos%FOUND;
    CLOSE c_kunden_auftr_pos;

    if :new.kunden_auftr_pos_id is NULL
    then
      :new.kunden_auftr_pos_id := v_kunden_auftr_pos.kunden_auftr_pos_id;
    end if;

    if not v_found then
      if :new.kunden_auftr_pos_id is NULL
      then
        select SEQ_S_RCV_kunden_auftr_pos.NEXTVAL into v_kunden_auftr_pos.kunden_auftr_pos_id from dual;
        :new.kunden_auftr_pos_id := v_kunden_auftr_pos.kunden_auftr_pos_id;
      else
        v_kunden_auftr_pos.kunden_auftr_pos_id := :new.kunden_auftr_pos_id;
      end if;

      insert into tms_kunden_auftr_pos t (
                  t.sid,                       -- SID      VARCHAR2(2) not null,
                  t.firma_nr,                  -- FIRMA_NR NUMBER(2) not null,
                  t.kunden_auftr_pos_id,        -- kunden_auftr_pos_ID        NUMBER,
                  t.besteller,
                  t.auftrag_nr,
                  t.pos_nr,
                  t.upos_nr,
                  t.artikel_id,                -- ARTIKEL_ID        NUMBER,
                  t.soll_menge,                -- IST_MENGE         NUMBER(12,3),
                  t.anbruch,
                  t.adress_id_rechn,
                  t.adress_id_liefer,
                  t.erz_datum,
                  t.erz_login_id,
                  t.strategie,
                  t.ziel,
                  t.wae_ziel,
                  t.auftr_datum
                  )
           values (
                  v_sid.sid,                      -- SID      VARCHAR2(2) not null,
                  :new.firma_nr,                  -- FIRMA_NR NUMBER(2) not null,
                  :new.kunden_auftr_pos_id,        -- VORGANG_ID        NUMBER,
                  nvl(:new.besteller, 'HOST'),
                  :new.auftrag,
                  :new.pos_nr,
                  :new.upos_nr,
                  v_artikel_id,                   -- ARTIKEL_ID        NUMBER,
                  :new.soll_menge,                -- IST_MENGE         NUMBER(12,3),
                  v_std_anbruch_lte,
                  v_adress_id,
                  v_adress_id_li,
                  sysdate,
                  -1, -- bei Schnittstellen immer -1 (NOUSER)
                  v_neu_std_strateg,
                  :new.ziel,
                  :new.wae_ziel,
                  :new.order_datum
                  );
    else
      if updating and v_kunden_auftr_pos.status != 'N'
      then
        if (:new.soll_menge != :old.soll_menge)
        then
          -- nur wenn die Soll-Menge geändert wird, ist das ein Problem
          v_err_nr := 30;
          v_err_text := lc.ec('O_TXT_KD_AUFTR_POS_NO_UPDATE');
          raise v_error;
        end if;
      end if;
    end if;

    if :new.charge is not NULL then
      v_charge_id := get_charge_id(v_sid.sid, :new.firma_nr, NULL, :new.charge, v_artikel_id);
    else
      v_charge_id := NULL;
    end if;

    update tms_kunden_auftr_pos t
       set t.adress_id_liefer = v_adress_id_li,
           t.adress_id_rechn = v_adress_id,
           t.artikel_id      = v_artikel_id,           -- ARTIKEL_ID        NUMBER,
           t.arbeitsplatz_id = :new.arbeitsplatz_id,   -- ARBEITSPLATZ_ID   NUMBER,
           t.fa_nr           = :new.fa_nr,             -- LEITZAHL          NUMBER,
           t.fa_ag           = :new.fa_ag,             -- FA_AG             NUMBER,
           t.fa_upos         = :new.fa_upos,           -- FA_Ut           NUMBER,
           t.charge_id       = v_charge_id,            -- CHARGE_ID         NUMBER,
           t.strategie       = nvl(:new.strategie, v_neu_std_strateg), -- STRATEGIE         VARCHAR2(10),
           t.mhd             = :new.mhd,               -- MHD               DATE,
           t.order_info      = :new.kom_info,          -- ORDER_INFO        VARCHAR2(40),
           t.soll_menge      = :new.soll_menge,        -- SOLL_MENGE        NUMBER,
           t.menge_basis     = v_menge_basis,          -- MENGE_BASIS       VARCHAR2(3),
           t.mengeneinheit   = v_mengeneinheit,        -- MENGENEINHEIT     VARCHAR2(10),
           t.ziel            = :new.ziel,              -- ZIEL              VARCHAR2(30),
           t.wae_ziel        = :new.wae_ziel,          -- WAE_ZIEL          VARCHAR2(6),
           t.besteller       = nvl(:new.besteller, t.besteller),                 -- BESTELLER         VARCHAR2(10),
           t.freigabe        = nvl(:new.freigabe, 'M'),-- FREIGABE          CHAR(1),
           t.freigabe_datum  = :new.freigabe_datum,
           t.prioritaet      = :new.prioritaet,        -- PRIORITAET        NUMBER,
           t.anbruch         = :new.anbruch,           -- ANBRUCH           CHAR(1)
           t.best_nr_kunde   = :new.best_nr_kunde,     -- BEST_NR_KUNDE     VARCHAR2(30)
           t.auftr_datum     = :new.order_datum,
           t.liefer_datum    = :new.liefer_datum,
           t.li_nr           = :new.li_nr,
           t.li_pos_nr       = :new.li_pos_nr,
           t.zeichnung_index = :new.zeichnung_index,
           t.lam_sel1        = :new.lam_sel1,
           t.lam_sel2        = :new.lam_sel2,
           t.lam_sel3        = :new.lam_sel3,
           t.lam_sel4        = :new.lam_sel4,
           t.lam_sel5        = :new.lam_sel5,
           t.lam_sel6        = :new.lam_sel6,
           t.lam_sel7        = :new.lam_sel7,
           t.lam_sel8        = :new.lam_sel8,
           t.lam_sel9        = :new.lam_sel9,
           t.lam_sel10       = :new.lam_sel10

     where t.kunden_auftr_pos_id = v_kunden_auftr_pos.kunden_auftr_pos_id
       and t.sid = v_sid.sid;
exception
  when v_error then
    raise_application_error(-20000 - v_err_nr, v_err_text);
  when others then
    if v_err_nr is not NULL then
      raise_application_error(-20000 - v_err_nr, v_err_text, true);
    else
      raise;
    end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_RCV_KUNDEN_AUFTR_POS_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"089a5597d7b5eed0ebe2096ea73618d1c0a77db9","type":"TRIGGER","name":"TR_S_RCV_KUNDEN_AUFTR_POS_BIU","schemaName":"DIRKSPZM32","sxml":""}