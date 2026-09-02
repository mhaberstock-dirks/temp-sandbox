create or replace 
TYPE "PZM_SCHICHTPERIODE_T" as object(
  schichtmodellname varchar2(30),
  wochenr   integer,
  name      varchar2(30),
  wochentag integer,
  gesamtstundenWoche integer

);
/


-- sqlcl_snapshot {"hash":"ad36335a9662d6ec165c8a367fc4dbc927437dd0","type":"TYPE_SPEC","name":"PZM_SCHICHTPERIODE_T","schemaName":"DIRKSPZM32","sxml":""}