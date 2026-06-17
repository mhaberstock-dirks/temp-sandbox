create or replace 
function DIRKSPZM32.get_pause_time(p_sa_kurzname in varchar2,
                                          p_beginn in date,
                                          p_ende in date,
                                          p_pb_id in pzm_produktionsbereiche.pb_id%type
                                         ) return number is
   time_std      number;
   cursor c_pzm_schichtarten is
       select t.*
         from pzm_schichtarten t
        where t.sa_kurzname = p_sa_kurzname;

   v_pzm_schichtarten pzm_schichtarten%rowtype;
   v_beginn date;
   v_ende date;
   v_anw_dauer number;
   v_arb_dauer number;
   v_arb_dauer1 number;
   v_arb_dauer2 number;
   v_arb_dauer3 number;
   v_found boolean;
   v_pause_unbezahlt number;
begin
  -- Erst mal keine Pausenzeit fuer diesen Zeitraum
  time_std := 0;
  v_anw_dauer := (p_ende - p_beginn) * 24;
  
  if pzm_lohnauswertung.v_pzm_sim_on -- In der Simulation berechen, wieviel Pausenzeit für die Schicht gerechnet werden muss
  then
    time_std := get_pause_time_day (p_sa_kurzname,
                                    p_beginn,
                                    p_ende,
                                    v_anw_dauer,
                                    0,
                                    p_pb_id,
                                    v_pause_unbezahlt);
    
    return time_std;
  end if;
  
  open c_pzm_schichtarten;
  fetch c_pzm_schichtarten into v_pzm_schichtarten;
  v_found := c_pzm_schichtarten%found;
  close c_pzm_schichtarten;

  -- Wenn Schitdaten gefunden
  if v_found
  then
    -- gilt nur für schichten mit festen pausenzeiten, die auch bei abwesenheiten abgezogen werden müssen
    -------------------------------------------------------------------------------------------
    --     PAUSE 1
    -------------------------------------------------------------------------------------------
    v_beginn := fraction_of_day(v_pzm_schichtarten.sa_pause1_beginn) + trunc(p_beginn);
    v_ende   := fraction_of_day(v_pzm_schichtarten.sa_pause1_ende) + trunc(p_beginn);
    if v_ende <= p_beginn
    then
      v_beginn := v_beginn + 1;
      v_ende := v_ende + 1;
    end if;
    -- Wenn die Pause1 im Zeitraum ist
    if (p_beginn between v_beginn and v_ende)
       or (p_ende between v_beginn and v_ende)
       or (v_beginn between p_beginn and p_ende)
       or (v_ende between p_beginn and p_ende)
    then
      -- Ueberschneidungen Pause Zeitraum dann Pausenzeit reduzieren
      if v_beginn < p_beginn
      then
        v_beginn := p_beginn;
      end if;
      if v_ende > p_ende
      then
        v_ende := p_ende;
      end if;
      if v_pzm_schichtarten.sa_pause1_unbez = 1
      then
        time_std := time_std + ((v_ende - v_beginn) * 24);
      end if;
    end if;

    -------------------------------------------------------------------------------------------
    --     PAUSE 2
    -------------------------------------------------------------------------------------------
    v_beginn := fraction_of_day(v_pzm_schichtarten.sa_pause2_beginn) + trunc(p_beginn);
    v_ende   := fraction_of_day(v_pzm_schichtarten.sa_pause2_ende) + trunc(p_beginn);
    if v_ende <= p_beginn
    then
      v_beginn := v_beginn + 1;
      v_ende := v_ende + 1;
    end if;
    -- Wenn die Pause2 im Zeitraum ist
    if (p_beginn between v_beginn and v_ende)
       or (p_ende between v_beginn and v_ende)
       or (v_beginn between p_beginn and p_ende)
       or (v_ende between p_beginn and p_ende)
    then
      -- Ueberschneidungen Pause Zeitraum dann Pausenzeit reduzieren
      if v_beginn < p_beginn
      then
        v_beginn := p_beginn;
      end if;

      if v_ende > p_ende
      then
        v_ende := p_ende;
      end if;

      if v_pzm_schichtarten.sa_pause2_unbez = 1
      then
        time_std := time_std + ((v_ende - v_beginn) * 24);
      end if;
    end if;
  end if;

  return(time_std);
end;
/



-- sqlcl_snapshot {"hash":"4b2cd1339c297f3cfef6e6538f1e5eaffb7043f3","type":"FUNCTION","name":"GET_PAUSE_TIME","schemaName":"DIRKSPZM32","sxml":""}