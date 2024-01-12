import credits.aleo;
program unizexe_protocol.aleo;


struct InscribedRecordPreimage:
    program_id_field as field;
    record_name_field as field;
    record_plaintext_scalar as scalar;


mapping store:
	key as field.public;
	value as address.public;









function inscribe_private:
    input r0 as [[u128; 16u32]; 32u32].public;
    input r1 as credits.aleo/credits.record;
    gt r1.microcredits 0u64 into r2;
    assert.eq r2 true;
    call credits.aleo/transfer_private r1 self.caller 0u64 into r3 r4;
    hash.psd2 r3 into r5 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r5 into r6 as InscribedRecordPreimage;
    hash.bhp1024 r6 into r7 as field;
    output r7 as field.public;
    output self.caller as address.private;


function inscribe:
    input r0 as [[u128; 16u32]; 32u32].public;
    input r1 as credits.aleo/credits.record;
    gt r1.microcredits 0u64 into r2;
    assert.eq r2 true;
    call credits.aleo/transfer_private r1 self.caller 0u64 into r3 r4;
    hash.psd2 r3 into r5 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r5 into r6 as InscribedRecordPreimage;
    hash.bhp1024 r6 into r7 as field;
    output r7 as field.public;
    output self.caller as address.public;


function private_transfer:
    input r0 as field.public;
    input r1 as credits.aleo/credits.record;
    input r2 as address.private;
    hash.psd2 r1 into r3 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r3 into r4 as InscribedRecordPreimage;
    hash.bhp1024 r4 into r5 as field;
    is.eq r5 r0 into r6;
    assert.eq r6 true;
    call credits.aleo/transfer_private r1 r2 r1.microcredits into r7 r8;
    hash.psd2 r7 into r9 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r9 into r10 as InscribedRecordPreimage;
    hash.bhp1024 r10 into r11 as field;
    output r11 as field.public;


function transfer:
    input r0 as field.public;
    input r1 as credits.aleo/credits.record;
    input r2 as address.public;
    hash.psd2 r1 into r3 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r3 into r4 as InscribedRecordPreimage;
    hash.bhp1024 r4 into r5 as field;
    is.eq r5 r0 into r6;
    assert.eq r6 true;
    call credits.aleo/transfer_private r1 r2 r1.microcredits into r7 r8;
    hash.psd2 r7 into r9 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r9 into r10 as InscribedRecordPreimage;
    hash.bhp1024 r10 into r11 as field;
    output r11 as field.public;


function lock:
    input r0 as field.public;
    input r1 as credits.aleo/credits.record;
    input r2 as address.public;
    hash.psd2 r1 into r3 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r3 into r4 as InscribedRecordPreimage;
    hash.bhp1024 r4 into r5 as field;
    is.eq r5 r0 into r6;
    assert.eq r6 true;
    call credits.aleo/transfer_private_to_public r1 r2 0u64 into r7 r8;
    async lock r8 r0 r2 into r9;
    output r9 as unizexe_protocol.aleo/lock.future;

finalize lock:
    input r0 as credits.aleo/transfer_private_to_public.future;
    input r1 as field.public;
    input r2 as address.public;
    await r0;
    set r2 into store[r1];


function withdraw:
    input r0 as field.public;
    input r1 as address.public;
    call credits.aleo/transfer_public_to_private r1 0u64 into r2 r3;
    hash.psd2 r2 into r4 as scalar;
    cast 2592153563941481818299150355295976261590486546629126588116998228059827156447field 5364367152170003308090674155064976139835263083583673604434541896507872122573field r4 into r5 as InscribedRecordPreimage;
    hash.bhp1024 r5 into r6 as field;
    async withdraw r3 self.caller r0 into r7;
    output r6 as field.public;
    output r7 as unizexe_protocol.aleo/withdraw.future;

finalize withdraw:
    input r0 as credits.aleo/transfer_public_to_private.future;
    input r1 as address.public;
    input r2 as field.public;
    await r0;
    get store[r2] into r3;
    is.eq r3 r1 into r4;
    assert.eq r4 true;
    remove store[r2];
