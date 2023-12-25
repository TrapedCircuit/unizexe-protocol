program credits.aleo;

record credits:
    owner as address.private;
    microcredits as u64.private;


function transfer_private_to_public:
    input r0 as credits.record;
    input r1 as address.public;
    input r2 as u64.public;
    async transfer_private_to_public r1 r2 into r3;
    output r0 as credits.record;
    output r3 as credits.aleo/transfer_private_to_public.future;

finalize transfer_private_to_public:
    input r0 as address.public;
    input r1 as u64.public;


function transfer_public_to_private:
    input r0 as address.private;
    input r1 as u64.public;
    cast r0 r1 into r2 as credits.record;
    async transfer_public_to_private self.caller r1 into r3;
    output r2 as credits.record;
    output r3 as credits.aleo/transfer_public_to_private.future;

finalize transfer_public_to_private:
    input r0 as address.public;
    input r1 as u64.public;


function transfer_public:
    input r0 as address.public;
    input r1 as u64.public;
    async transfer_public self.caller r0 r1 into r2;
    output r2 as credits.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;


function transfer_private:
    input r0 as credits.record;
    input r1 as address.private;
    input r2 as u64.private;
    output r0 as credits.record;
    output r0 as credits.record;
