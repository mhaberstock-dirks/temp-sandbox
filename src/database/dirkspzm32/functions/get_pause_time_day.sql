create or replace 
function DIRKSPZM32.get_pause_time_day(in_sa_kurzname in varchar2,
                                              in_beginn in date,
                                              in_ende in date,
                                              in_anw_std in number,
                                              in_day_pause_std in number,
                                              in_pb_id in pzm_produktionsbereiche.pb_id%type,
                                              out_day_pause_bez_std out number
                                             ) return number is
   time_std      number;
   cursor c_pzm_schichtarten is
       select t.*
         from pzm_schichtarten t
        where t.sa_kurzname = in_sa_kurzname;

   v_pzm_schichtarten pzm_schichtarten%rowtype;
   v_beginn date;
   v_ende date;
   v_found boolean;
   v_pause_unbezahlt boolean;
   v_pause_in_arbeitszeit varchar2(10);
begin
  -- Erst mal keine Pausenzeit fuer diesen Zeitraum
  time_std := 0;
  out_day_pause_bez_std := 0;
  v_pause_unbezahlt := true;

  open c_pzm_schichtarten;
  fetch c_pzm_schichtarten into v_pzm_schichtarten;
  v_found := c_pzm_schichtarten%found;
  close c_pzm_schichtarten;

  -- Wenn Schitdaten gefunden
  if v_found
  then
    if in_day_pause_std = 0
    then
      if v_pzm_schichtarten.calc_basis = 'GLEITZ'
      then
        if in_anw_std = 0
        then
          return (0);
        end if;

        -- die Berechnung erfolgt weiter unten
      else
        -------------------------------------------------------------------------------------------
        --     PAUSE 1
        -------------------------------------------------------------------------------------------
        v_beginn := fraction_of_day(v_pzm_schichtarten.sa_pause1_beginn) + trunc(in_beginn);
        v_ende   := fraction_of_day(v_pzm_schichtarten.sa_pause1_ende) + trunc(in_beginn);
        if v_ende <= in_beginn
        then
          v_beginn := v_beginn + 1;
          v_ende := v_ende + 1;
        end if;
        -- Wenn die Pause1 im Zeitraum ist
        if (in_beginn between v_beginn and v_ende)
           or (in_ende between v_beginn and v_ende)
           or (v_beginn between in_beginn and in_ende)
           or (v_ende between in_beginn and in_ende)
        then
          -- Ueberschneidungen Pause Zeitraum dann Pausenzeit reduzieren
          if v_beginn < in_beginn
          then
            v_beginn := in_beginn;
          end if;

          if v_ende > in_ende
          then
            v_ende := in_ende;
          end if;
          if v_pzm_schichtarten.sa_pause1_unbez = 1
          then
            time_std := time_std + ((v_ende - v_beginn) * 24);
          end if;
        end if;

        -------------------------------------------------------------------------------------------
        --     PAUSE 2
        -------------------------------------------------------------------------------------------
        v_beginn := fraction_of_day(v_pzm_schichtarten.sa_pause2_beginn) + trunc(in_beginn);
        v_ende   := fraction_of_day(v_pzm_schichtarten.sa_pause2_ende) + trunc(in_beginn);
        if v_ende <= in_beginn
        then
          v_beginn := v_beginn + 1;
          v_ende := v_ende + 1;
        end if;

        -- Wenn die Pause2 im Zeitraum ist
        if (in_beginn between v_beginn and v_ende)
           or (in_ende between v_beginn and v_ende)
           or (v_beginn between in_beginn and in_ende)
           or (v_ende between in_beginn and in_ende)
        then
          -- Ueberschneidungen Pause Zeitraum dann Pausenzeit reduzieren
          if v_beginn < in_beginn
          then
            v_beginn := in_beginn;
          end if;

          if v_ende > in_ende
          then
            v_ende := in_ende;
          end if;

          if v_pzm_schichtarten.sa_pause2_unbez = 1
          then
            time_std := time_std + ((v_ende - v_beginn) * 24);
          end if;
        end if;
      end if;
    end if;

    -- die Stufenweise Pausenberechnung gilt seit 01.01.2010
    -- für Gleitzeit und Wechselschicht
    if in_anw_std > 0 and time_std = 0
    then
      v_pause_in_arbeitszeit := nvl(pzm_p_base.get_allg_parameter_mandant(in_pb_id, 'PAUSE_IN_ARBEITSZEIT'), 'T');

      if v_pause_in_arbeitszeit != 'T' -- Berechnung nach Anwesenheit und nicht nach Arbeitszeit (Euscher)
      then
        if nvl(v_pzm_schichtarten.gleitz_pause1_dauer_min, 0) >= 0
           and nvl(v_pzm_schichtarten.gleitz_pause1_arb_std, 0) > 0
           and in_anw_std > v_pzm_schichtarten.gleitz_pause1_arb_std
        then
          -- Stufe 1
          time_std := (nvl(v_pzm_schichtarten.gleitz_pause1_dauer_min, 0) / 60);
          v_pause_unbezahlt := nvl(v_pzm_schichtarten.gleitz_pause1_unbez, 'F') = 'T';

        elsif nvl(v_pzm_schichtarten.gleitz_pause2_dauer_min, 0) >= 0
           and nvl(v_pzm_schichtarten.gleitz_pause2_arb_std, 0) > 0
           and in_anw_std > v_pzm_schichtarten.gleitz_pause2_arb_std
        then
          -- Stufe 2
          time_std := (nvl(v_pzm_schichtarten.gleitz_pause2_dauer_min, 0) / 60);
          v_pause_unbezahlt := nvl(v_pzm_schichtarten.gleitz_pause2_unbez, 'F') = 'T';

        elsif nvl(v_pzm_schichtarten.gleitz_pause3_dauer_min, 0) >= 0
           and nvl(v_pzm_schichtarten.gleitz_pause3_arb_std, 0) > 0
           and in_anw_std > v_pzm_schichtarten.gleitz_pause3_arb_std
        then
          -- Stufe 3
          time_std := (nvl(v_pzm_schichtarten.gleitz_pause3_dauer_min, 0) / 60);
          v_pause_unbezahlt := nvl(v_pzm_schichtarten.gleitz_pause3_unbez, 'F') = 'T';

        else
          -- regulär
          time_std := (nvl(v_pzm_schichtarten.gleitz_pause_dauer_min, 0) / 60);
          v_pause_unbezahlt := nvl(v_pzm_schichtarten.gleitz_pause_unbez, 'F') = 'T';
        end if;
      else
        if in_anw_std > v_pzm_schichtarten.gleitz_pause1_arb_std
        then
          -- Stufe 1
          if in_anw_std < v_pzm_schichtarten.gleitz_pause1_arb_std + (nvl(v_pzm_schichtarten.gleitz_pause1_dauer_min, 0) / 60)
          then
            time_std := nvl(in_anw_std - v_pzm_schichtarten.gleitz_pause1_arb_std, 0);
          else
            time_std := (nvl(v_pzm_schichtarten.gleitz_pause1_dauer_min, 0) / 60);
          end if;
          v_pause_unbezahlt := nvl(v_pzm_schichtarten.gleitz_pause1_unbez, 'F') = 'T';
        end if;

        if in_anw_std > v_pzm_schichtarten.gleitz_pause2_arb_std
        then
          -- Stufe 2
          if in_anw_std < v_pzm_schichtarten.gleitz_pause2_arb_std - time_std + (nvl(v_pzm_schichtarten.gleitz_pause2_dauer_min, 0) / 60)
          then
            time_std := nvl(in_anw_std + time_std - v_pzm_schichtarten.gleitz_pause2_arb_std, 0);
          else
            time_std := (nvl(v_pzm_schichtarten.gleitz_pause2_dauer_min, 0) / 60);
          end if;
          v_pause_unbezahlt := nvl(v_pzm_schichtarten.gleitz_pause2_unbez, 'F') = 'T';
        end if;

        if in_anw_std > v_pzm_schichtarten.gleitz_pause3_arb_std
        then
          -- Stufe 3
          if in_anw_std < v_pzm_schichtarten.gleitz_pause3_arb_std - time_std + (nvl(v_pzm_schichtarten.gleitz_pause3_dauer_min, 0) / 60)
          then
            time_std := nvl(in_anw_std + time_std - v_pzm_schichtarten.gleitz_pause3_arb_std, 0);
          else
            time_std := (nvl(v_pzm_schichtarten.gleitz_pause3_dauer_min, 0) / 60);
          end if;
          v_pause_unbezahlt := nvl(v_pzm_schichtarten.gleitz_pause3_unbez, 'F') = 'T';
        end if;
        
        if time_std = 0
        then
          -- regulär
          time_std := (nvl(v_pzm_schichtarten.gleitz_pause_dauer_min, 0) / 60);
          v_pause_unbezahlt := nvl(v_pzm_schichtarten.gleitz_pause_unbez, 'F') = 'T';
        end if;
      end if;

      if v_pause_unbezahlt
      then
        -- unbazahlte Pause
        if in_day_pause_std > time_std
        then
          time_std := in_day_pause_std; -- gestempelte pause übernehmen, da mehr als reguläre pause
        end if;
      else
        -- bezahlte Pause nur bis zur eingestellten dauer
        out_day_pause_bez_std := time_std;
        if in_day_pause_std > time_std
        then
          -- von der gestempelten Pause nur den "Überschuss" verwenden
          time_std := in_day_pause_std - time_std;
        else
          -- die gestempelte pausenzeit ist innerhalb der bezahlten pause
          time_std := 0;
        end if;
      end if;
    end if;
  end if;

  return(time_std);
end;
/



-- sqlcl_snapshot {"hash":"321589f8d1b54b71070a7234cabc0e0101a2f883","type":"FUNCTION","name":"GET_PAUSE_TIME_DAY","schemaName":"DIRKSPZM32","sxml":""}