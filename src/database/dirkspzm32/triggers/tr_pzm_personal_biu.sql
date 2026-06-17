
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_PERSONAL_BIU" 
  before insert OR update on DIRKSPZM32.pzm_personal
  for each row
declare
  -- local variables here
  v_user isi_user%rowtype;
  v_found boolean;

  cursor c_isi_user is
    select *
      from isi_user
     where pers_nr = :new.pers_nr
    for update of anrede,
                  nachname,
                  vorname,
                  anschrift,
                  plz,
                  wohnort,
                  telefon_nr;
  v_pers_nr pzm_personal.pers_nr%type;
  v_uk_konto pzm_konten%rowtype;
  v_uk_konto_old pzm_konten%rowtype;
  v_schichtmodell pzm_schicht_modelle%rowtype;
  v_schichtmodell_abt pzm_schicht_modelle%rowtype;

  v_d_arb_std_pro_tag pzm_schicht_modelle.d_arb_std_pro_tag%type;
  v_urlaub_anspr_aa_id pzm_personal.pers_urlaub_anspr_aa_id%type;
 

  cursor c_pzm_konten_uk is
    select t.*
      from pzm_konten t,
           pzm_abwesenheitsarten aa,
           pzm_lohnarten lz
     where t.sid = '01'
       and t.firma_nr = 1
       and t.pers_nr = v_pers_nr
       and t.name_kurz = lz.lz_konto_name_kurz
       and lz.lz_id = aa.lz_id
       and aa.aa_id = v_urlaub_anspr_aa_id;

  cursor c_schichtmodell is
    select t.*
      from pzm_schicht_modelle t
     where t.sm_name = :new.pers_sm_name;

  cursor c_schichtmodell_abt is
    select t.*
      from pzm_abteilungen a,
           pzm_schicht_modelle t
     where a.abt_id = :new.pers_abt_id
       and t.sm_name = a.abt_standard_sm_name;

begin
  open c_isi_user;
  v_pers_nr := :new.pers_nr;
  fetch c_isi_user into v_user;
  v_found := c_isi_user%found;
  close c_isi_user;
  
  begin
    if v_found then
      update isi_user set
             anrede = :new.pers_anrede,
             nachname = :new.pers_nname,
             vorname = :new.pers_vname
       where pers_nr = :new.pers_nr;
    else
      insert into isi_user (
        login_id,
        pers_nr,
        anrede,
        vorname,
        nachname
      ) values (
        seq_login_id.nextval,
        :new.pers_nr,
        :new.pers_anrede,
        :new.pers_vname,
        :new.pers_nname
      );
    end if;
  exception when others then NULL;
  end;
  if updating
  then
    v_urlaub_anspr_aa_id := :new.pers_urlaub_anspr_aa_id;
    open c_pzm_konten_uk;
    fetch c_pzm_konten_uk into v_uk_konto;
    v_found := c_pzm_konten_uk%found;
    close c_pzm_konten_uk;
    
    if not v_found
    then
      insert into pzm_konten
      select '01',
             1,
             v_pers_nr,
             null,
             k.name,
             k.name_kurz,
             k.typ,
             k.buch_einheit,
             0, -- saldo
             null, -- letzte_buchung
             null, -- letzter_abschluss_am
             null, -- abschluss_saldo
             k.info,
             k.def_max_saldo,
             k.def_min_saldo,
             k.aktiv,
             0
        from pzm_konten_cfg k
       where k.aktiv = 'T'
         and k.name_kurz = (select lz.lz_konto_name_kurz
                              from pzm_abwesenheitsarten aa,
                                   pzm_lohnarten lz
                             where lz.lz_id = aa.lz_id
                               and aa.aa_id = v_urlaub_anspr_aa_id);
      open c_pzm_konten_uk;
      fetch c_pzm_konten_uk into v_uk_konto;
      v_found := c_pzm_konten_uk%found;
      close c_pzm_konten_uk;
    end if;

    v_urlaub_anspr_aa_id := :old.pers_urlaub_anspr_aa_id;
    open c_pzm_konten_uk;
    fetch c_pzm_konten_uk into v_uk_konto_old;
    close c_pzm_konten_uk;

    -- -WK- 20110805: Bugfix: Fehlende Gutschrift, wenn Urlaubskonto-Art erst im nachhinein gesetzt wurde
    if nvl(:new.pers_urlaub_anspr_aa_id, -1) <> :old.pers_urlaub_anspr_aa_id
    then
      update pzm_konten t set t.aktiv = 'F' where t.konto_nr = v_uk_konto_old.konto_nr and t.firma_nr = 1 and t.sid = '01';
      update pzm_konten t set t.aktiv = 'T' where t.konto_nr = v_uk_konto.konto_nr and t.firma_nr = 1 and t.sid = '01';

      if nvl(:new.pers_urlaub_anspr_wert, 0) > 0
      then
        -- Einheitwechsel, Umrechnung!
        open c_schichtmodell;
        fetch c_schichtmodell into v_schichtmodell;
        v_found := c_schichtmodell%found;
        close c_schichtmodell;

        if v_found and nvl(pzm_utils.pzm_get_sm_durch_std_tag(v_schichtmodell.sm_name), 0) > 0
        then
           v_d_arb_std_pro_tag := pzm_utils.pzm_get_sm_durch_std_tag(v_schichtmodell.sm_name);
        else
          open c_schichtmodell_abt;
          fetch c_schichtmodell_abt into v_schichtmodell_abt;
          v_found := c_schichtmodell_abt%found;
          close c_schichtmodell_abt;
          v_d_arb_std_pro_tag := pzm_utils.pzm_get_sm_durch_std_tag(v_schichtmodell_abt.sm_name);
        end if;
        
        if not v_found
        then
          v_d_arb_std_pro_tag := 8;
        end if;

        if v_d_arb_std_pro_tag is not null
        then

          if :old.pers_urlaub_anspr_aa_id = :new.pers_urlaub_anspr_aa_id
          then
            if upper(v_uk_konto.buch_einheit) = 'HH24' and upper(v_uk_konto_old.buch_einheit) = 'DD'
            then
              :new.pers_urlaub_anspr_wert := :old.pers_urlaub_anspr_wert * v_d_arb_std_pro_tag;
            elsif upper(v_uk_konto.buch_einheit) = 'DD' and upper(v_uk_konto_old.buch_einheit) = 'HH24'
            then
              :new.pers_urlaub_anspr_wert := round(:old.pers_urlaub_anspr_wert / v_d_arb_std_pro_tag);
            end if;
          end if;
        elsif :old.pers_urlaub_anspr_aa_id is not null
        then
          raise_application_error(-20000, 'In dem zugeordneten Schichtmodell <' ||
                                          nvl(nvl(v_schichtmodell.sm_name, v_schichtmodell_abt.sm_name), 'Nicht eingetragen bei ' || :new.pers_nr) ||
                                          '> sind keine Durchschnitt-Arbeitsstunden hinterlegt!');
        end if;
      end if;
    end if;
  end if;
  
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_PERSONAL_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"52c81f161ea0cd2779c428a05e4b37236df15b0d","type":"TRIGGER","name":"TR_PZM_PERSONAL_BIU","schemaName":"DIRKSPZM32","sxml":""}