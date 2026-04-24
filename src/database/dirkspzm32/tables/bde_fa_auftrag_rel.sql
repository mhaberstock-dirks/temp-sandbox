create table dirkspzm32.bde_fa_auftrag_rel (
    sid               varchar2(2 char) not null enable,
    firma_nr          number not null enable,
    leitzahl          number not null enable,
    fa_ag             number(*, 0) not null enable,
    fa_upos           number(*, 0) default 0 not null enable,
    nfa_ag            number(*, 0) not null enable,
    nfa_upos          number(*, 0) default 0 not null enable,
    ueberlappungstyp  number default 1,
    wert              number default 0,
    minpuffer         number default 0,
    maxpufferbeachten number default 0,
    maxpuffer         number default 0
);

alter table dirkspzm32.bde_fa_auftrag_rel
    add constraint pk_bde_fa_auftrag_rel
        primary key ( leitzahl,
                      fa_ag,
                      fa_upos,
                      nfa_ag,
                      nfa_upos,
                      firma_nr,
                      sid )
            using index enable;


-- sqlcl_snapshot {"hash":"a05871ee635d5db01d9dbd7d99fd970fef9c54c7","type":"TABLE","name":"BDE_FA_AUFTRAG_REL","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>BDE_FA_AUFTRAG_REL</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_UPOS</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>0</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NFA_AG</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NFA_UPOS</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>0</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UEBERLAPPUNGSTYP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>1</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>WERT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MINPUFFER</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MAXPUFFERBEACHTEN</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MAXPUFFER</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>0</DEFAULT>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_BDE_FA_AUFTRAG_REL</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>LEITZAHL</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FA_AG</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FA_UPOS</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>NFA_AG</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>NFA_UPOS</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}