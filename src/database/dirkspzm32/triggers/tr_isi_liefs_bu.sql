
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_LIEFS_BU" 
  before update on DIRKSPZM32.isi_liefs
  for each row
declare
  -- local variables here
  v_lam_id             lvs_lam.lam_id%type;
  v_menge              lvs_lam.menge%type;
  v_found              boolean;

  v_lte                lvs_lte%rowtype;

  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.sid = :new.sid
       and lte.lte_id = :new.lte_id
       and (lte.lte_status = c.lte_af_stat
         or lte.lte_status = c.lte_ag_stat);

  CURSOR c_lam_lte IS
  SELECT sum(lam.menge)
    FROM lvs_lam lam
    WHERE lam.sid = :new.sid AND
          lam.lte_id = :new.lte_id
    group by lam.lte_id;

begin
  OPEN c_lam_lte; -- Ersten Eintrag lesen
  FETCH c_lam_lte into v_menge;
  v_found := c_lam_lte%FOUND; -- Eintrag mit Menge vorhanden, das ist ein Fehler (Abbruch)
  CLOSE c_lam_lte;

  if  v_found
  and v_menge > 0
  and :new.login_id_verantwortung is not NULL
  then
    OPEN c_lte; -- Eintrag lesen (Nur Status AF (Auslagern Fertig)
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND; -- Eintrag mit Menge vorhanden, das ist ein Fehler (Abbruch)
    CLOSE c_lte;
    if  v_found
    and v_lte.lte_status = c.LTE_AF_STAT
    then
      -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
      v_lam_id := lvs_ausl.lvs_lam_abgang (:new.sid, :new.firma_nr, :new.artikel_id, :new.lte_id,
                                           NULL, :new.auftrag,
                                           NULL, sysdate, :new.login_id_verantwortung, NULL, NULL, NULL, NULL, NULL, NULL,
                                           c.LAM_BH_BUS_ABG, :new.vorgang_id, :new.li_nr, :new.li_pos_nr);
      update lvs_lte lte
         set lte.lgr_platz = NULL,
             lte.lgr_platz_gruppe = NULL,
             lte.lgr_ort = NULL,
             lte.ziel_lgr_ort = NULL,
             lte.ziel_lgr_platz = NULL,
             lte.ziel_lgr_ort_n_freif = NULL,
             lte.ziel_lgr_platz_n_freif = NULL
       where lte.sid = :new.sid
         and lte.lte_id = :new.lte_id;
    end if;
  end if;
end TR_ISI_LIEFS_BU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_LIEFS_BU" ENABLE;


-- sqlcl_snapshot {"hash":"aee14ba3eabb92119f933bc96621c2e3cda85d2a","type":"TRIGGER","name":"TR_ISI_LIEFS_BU","schemaName":"DIRKSPZM32","sxml":""}