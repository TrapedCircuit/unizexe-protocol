program credits.aleo {
    record credits {
        owner: address,
        microcredits: u64,
    }

    transition transfer_private_to_public (r: credits, public receiver: address, public amount: u64) -> credits {
        return r then finalize (receiver, amount);
    }

    finalize transfer_private_to_public (receiver: address, amount: u64) {
        let a: u32 = 1u32;
    }

    transition transfer_public_to_private (receiver: address, public amount: u64) -> credits {
        return credits {
            owner: receiver,
            microcredits: amount,
        } then finalize (self.caller, amount);
    }

    finalize transfer_public_to_private (holder: address, amount: u64) {
        let a: u32 = 1u32;
    }

    transition transfer_public (public receiver: address, public amount: u64) {
        return then finalize(self.caller, receiver, amount);
    }

    finalize transfer_public (sender:address, receiver: address, amount: u64) {
        let a: u32 = 1u32;
    }

    transition transfer_private (r: credits, receiver: address, amount: u64) -> (credits, credits) {
        return (r, r);
    }
}
