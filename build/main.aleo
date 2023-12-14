import credits.aleo;
program unizexe_protocol.aleo;


struct InscribedRecordPreimage:
    program_id_field as field;
    record_name_field as field;
    record_plaintext_scalar as scalar;






function inscribe_private:
    input r0 as [[[u128; 32u32]; 32u32]; 32u32].private;
    input r1 as credits.record;
    call credits.aleo/transfer_private r1 self.caller 1u64 into r2 r3;
    hash.psd2 r2 into r4 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r4 into r5 as InscribedRecordPreimage;
    hash.bhp1024 r5 into r6 as field;
    output r6 as field.public;
    output self.caller as address.private;


function inscribe:
    input r0 as [[[u128; 32u32]; 32u32]; 32u32].private;
    input r1 as credits.record;
    call credits.aleo/transfer_private r1 self.caller 1u64 into r2 r3;
    hash.psd2 r2 into r4 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r4 into r5 as InscribedRecordPreimage;
    hash.bhp1024 r5 into r6 as field;
    output r6 as field.public;
    output self.caller as address.public;


function private_transfer:
    input r0 as field.public;
    input r1 as credits.record;
    input r2 as address.private;
    hash.psd2 r1 into r3 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r3 into r4 as InscribedRecordPreimage;
    hash.bhp1024 r4 into r5 as field;
    assert.eq r5 r0;
    call credits.aleo/transfer_private r1 r2 r1.microcredits into r6 r7;
    hash.psd2 r6 into r8 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r8 into r9 as InscribedRecordPreimage;
    hash.bhp1024 r9 into r10 as field;
    output r10 as field.public;


function transfer:
    input r0 as field.public;
    input r1 as credits.record;
    input r2 as address.public;
    hash.psd2 r1 into r3 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r3 into r4 as InscribedRecordPreimage;
    hash.bhp1024 r4 into r5 as field;
    assert.eq r5 r0;
    call credits.aleo/transfer_private r1 r2 r1.microcredits into r6 r7;
    hash.psd2 r6 into r8 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r8 into r9 as InscribedRecordPreimage;
    hash.bhp1024 r9 into r10 as field;
    output r10 as field.public;
