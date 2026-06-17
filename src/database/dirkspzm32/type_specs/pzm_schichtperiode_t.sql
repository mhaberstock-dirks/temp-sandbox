create or replace 
TYPE DIRKSPZM32."PZM_SCHICHTPERIODE_T" as object(
  schichtmodellname varchar2(30),
  wochenr   integer,
  name      varchar2(30),
  wochentag integer,
  gesamtstundenWoche integer

);
/


-- sqlcl_snapshot {"hash":"f102c1800ecf9932281937fc56da0ddfb3b7651d","type":"TYPE_SPEC","name":"PZM_SCHICHTPERIODE_T","schemaName":"DIRKSPZM32","sxml":""}