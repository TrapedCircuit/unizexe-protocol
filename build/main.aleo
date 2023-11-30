import credits.aleo;
program unizexe_protocol.aleo;


struct InscribeRecordPreimage:
    program_id_field as field;
    record_name_field as field;
    record_plaintext_scalar as scalar;






function inscribe:
    input r0 as [[[u128; 32u32]; 32u32]; 32u32].private;
    input r1 as credits.aleo/credits.record;
    call credits.aleo/transfer_private r1 self.caller r1.microcredits into r2 r3;
    hash.psd2 r2 into r4 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r4 into r5 as InscribeRecordPreimage;
    hash.bhp1024 r5 into r6 as field;
    output r6 as field.public;
    output self.caller as address.private;


function public_inscribe:
    input r0 as [[[u128; 32u32]; 32u32]; 32u32].private;
    input r1 as credits.aleo/credits.record;
    call credits.aleo/transfer_private r1 self.caller r1.microcredits into r2 r3;
    hash.psd2 r2 into r4 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r4 into r5 as InscribeRecordPreimage;
    hash.bhp1024 r5 into r6 as field;
    output r6 as field.public;
    output self.caller as address.public;


function transfer:
    input r0 as field.public;
    input r1 as field.private;
    input r2 as credits.aleo/credits.record;
    input r3 as address.private;
    hash.psd2 r2 into r4 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r4 into r5 as InscribeRecordPreimage;
    hash.bhp1024 r5 into r6 as field;
    assert.eq r6 r0;
    cast r1r0 into r7 as [field; 2u32];
    hash.psd2 r7 into r8 as field;
    call credits.aleo/transfer_private r2 r3 r2.microcredits into r9 r10;
    hash.psd2 r9 into r11 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r11 into r12 as InscribeRecordPreimage;
    hash.bhp1024 r12 into r13 as field;
    output r8 as field.public;
    output r13 as field.public;
    output self.caller as address.private;


function public_transfer:
    input r0 as field.public;
    input r1 as field.private;
    input r2 as credits.aleo/credits.record;
    input r3 as address.public;
    hash.psd2 r2 into r4 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r4 into r5 as InscribeRecordPreimage;
    hash.bhp1024 r5 into r6 as field;
    assert.eq r6 r0;
    cast r1r0 into r7 as [field; 2u32];
    hash.psd2 r7 into r8 as field;
    call credits.aleo/transfer_private r2 r3 r2.microcredits into r9 r10;
    hash.psd2 r9 into r11 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r11 into r12 as InscribeRecordPreimage;
    hash.bhp1024 r12 into r13 as field;
    output r8 as field.public;
    output r13 as field.public;
    output self.caller as address.public;
