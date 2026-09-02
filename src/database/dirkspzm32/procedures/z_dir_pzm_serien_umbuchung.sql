create or replace 
procedure z_dir_pzm_serien_umbuchung is
  v_k_umb                   pzm_konten_umbuchen%rowtype;
  v_date                    date;
  v_Wochentag               integer;
  v_true                    boolean;

  v_buch_wert               pzm_konten_umbuchen.buch_wert%type;

  cursor c_k_umb is
    select * from pzm_konten_umbuchen t
     where t.typ_status in ('D', 'N')
       and t.aktiv = c.R_C_TRUE;

begin

  open c_k_umb;
  loop
    fetch c_k_umb
      into v_k_umb;
    exit when c_k_umb%notfound;
    v_true := false;
    v_buch_wert := NULL;
    v_Wochentag := isi_utils.Iso_WeekDay(sysdate);

    case when v_Wochentag = 1 and v_k_umb.buch_wot_mo_wert is not NULL
              then v_buch_wert := v_k_umb.buch_wot_mo_wert;
         when v_Wochentag = 2 and v_k_umb.buch_wot_di_wert is not NULL
              then v_buch_wert := v_k_umb.buch_wot_di_wert;
         when v_Wochentag = 3 and v_k_umb.buch_wot_mi_wert is not NULL
              then v_buch_wert := v_k_umb.buch_wot_mi_wert;
         when v_Wochentag = 4 and v_k_umb.buch_wot_do_wert is not NULL
              then v_buch_wert := v_k_umb.buch_wot_do_wert;
         when v_Wochentag = 5 and v_k_umb.buch_wot_fr_wert is not NULL
              then v_buch_wert := v_k_umb.buch_wot_fr_wert;
         when v_Wochentag = 6 and v_k_umb.buch_wot_sa_wert is not NULL
              then v_buch_wert := v_k_umb.buch_wot_sa_wert;
         when v_Wochentag = 7 and v_k_umb.buch_wot_so_wert is not NULL
              then v_buch_wert := v_k_umb.buch_wot_so_wert;
         else v_buch_wert := NULL;
    end case;

    if v_buch_wert is NULL
    and v_k_umb.buch_wert > 0
    then
      v_buch_wert := v_k_umb.buch_wert;
    end if;
    if v_buch_wert is not NULL
    then
      if v_k_umb.typ_status = 'D'
      and fraction_of_day(v_k_umb.buch_datum) <= fraction_of_day(sysdate)
      and trunc(nvl(v_k_umb.last_event_date, sysdate-1)) < trunc(sysdate)
      then
        v_true := true;
        if v_buch_wert = 0
        then
          v_buch_wert := NULL;
        end if;
        v_k_umb.buch_datum := (trunc(sysdate) + fraction_of_day(v_k_umb.buch_datum)) -1; -- Immer erst am nächsten Tag buchen - Anwesenheit prüfen         
      elsif v_k_umb.typ_status = 'N'
      and v_k_umb.buch_datum <= sysdate
      then
        v_true := true;
      end if;
    end if;

    if v_true
    then
      pzm_kontoverwaltung.zk_serien_umbuchen(in_pb_id => v_k_umb.pb_id,
                                             in_abt_id => v_k_umb.abt_id,
                                             in_wert => v_buch_wert,
                                             in_einheit => v_k_umb.buch_einheit,
                                             in_info => nvl(v_k_umb.info, v_k_umb.name),
                                             in_zk_start => v_k_umb.buch_datum,
                                             in_zk_aa_id => NULL,
                                             in_zk_v_name_kurz => v_k_umb.von_konto_name_kurz,
                                             in_zk_n_name_kurz => v_k_umb.nach_konto_name_kurz);
      if v_k_umb.typ_status = 'N'
      then
        v_k_umb.typ_status := 'F';
      end if;

      update pzm_konten_umbuchen t
         set t.typ_status = v_k_umb.typ_status,
             t.last_event_date = sysdate
       where t.name = v_k_umb.name;

    end if;      

  end loop;
  close c_k_umb;

end z_dir_pzm_serien_umbuchung;
/



-- sqlcl_snapshot {"hash":"a520a4b59229fc6789bd15024e86659f407b0d55","type":"PROCEDURE","name":"Z_DIR_PZM_SERIEN_UMBUCHUNG","schemaName":"DIRKSPZM32","sxml":""}