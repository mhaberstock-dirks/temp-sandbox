create or replace editionable trigger dirkspzm32.tr_s_rcv_fa_auf_rel_biu before
    insert or update or delete on dirkspzm32.s_rcv_fa_auf_rel
    for each row
declare
    v_fa_rel s_rcv_fa_auf_rel%rowtype;
    v_found  boolean;
    cursor c_fa_rel is
    select
        *
    from
        bde_fa_auftrag_rel t
    where
            t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.leitzahl = :new.leitzahl
        and t.fa_ag = :new.fa_ag
        and t.fa_upos = :new.fa_upos
        and t.nfa_ag = :new.nfa_ag
        and t.nfa_upos = :new.nfa_upos;

begin
    if updating
    or inserting then
        open c_fa_rel;
        fetch c_fa_rel into v_fa_rel;
        v_found := c_fa_rel%found;
        close c_fa_rel;
        if v_found then
            update bde_fa_auftrag_rel t
            set
                t.ueberlappungstyp = :new.ueberlappungstyp,
                t.wert = :new.wert,
                t.minpuffer = :new.minpuffer,
                t.maxpufferbeachten = :new.maxpufferbeachten,
                t.maxpuffer = :new.maxpuffer
            where
                    t.sid = :new.sid
                and t.firma_nr = :new.firma_nr
                and t.leitzahl = :new.leitzahl
                and t.fa_ag = :new.fa_ag
                and t.fa_upos = :new.fa_upos
                and t.nfa_ag = :new.nfa_ag
                and t.nfa_upos = :new.nfa_upos;

        else
            insert into bde_fa_auftrag_rel values ( :new.sid,
                                                    :new.firma_nr,
                                                    :new.leitzahl,
                                                    :new.fa_ag,
                                                    :new.fa_upos,
                                                    :new.nfa_ag,
                                                    :new.nfa_upos,
                                                    :new.ueberlappungstyp,
                                                    :new.wert,
                                                    :new.minpuffer,
                                                    :new.maxpufferbeachten,
                                                    :new.maxpuffer );

        end if;

    elsif deleting then
        delete bde_fa_auftrag_rel t
        where
                t.sid = :old.sid
            and t.firma_nr = :old.firma_nr
            and t.leitzahl = :old.leitzahl
            and t.fa_ag = :old.fa_ag
            and t.fa_upos = :old.fa_upos
            and t.nfa_ag = :old.nfa_ag
            and t.nfa_upos = :old.nfa_upos;

    end if;
end tr_s_rcv_fa_auf_rel;
/

alter trigger dirkspzm32.tr_s_rcv_fa_auf_rel_biu enable;


-- sqlcl_snapshot {"hash":"9e716b7a0af694c39a2082585aa3ae7c6ef63a40","type":"TRIGGER","name":"TR_S_RCV_FA_AUF_REL_BIU","schemaName":"DIRKSPZM32","sxml":""}