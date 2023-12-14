import credits.leo;
// The 'unizexe_protocol' program.
program unizexe_protocol.aleo {
    /*
        The original record defination is:
        commitment = hash_bhp1024(to_bits_le![program_id, record_name, record_plaintext]);
        tag = hash_psd2([sk_tag, commitment]);

        The inscribed record defination is:
        commitment = hash_bhp1024(plaintext {program_id_field, record_name_field, record_plaintext_scalar});
        tag = hash_psd2(plaintext [sk_tag, commitment]);
    */

    mapping storage: field => address;

    struct InscribedRecordPreimage {
        program_id_field: field,
        record_name_field: field,
        record_plaintext_scalar: scalar,
    }

    inline program_id_field() -> field {
        // hash_bhp1024(program_id)
        return 2592153563941481818299150355295976261590486546629126588116998228059827156447field;
    }

    inline record_name_field() -> field {
        // hash_bhp1024(record_name)
        return 5364367152170003308090674155064976139835263083583673604434541896507872122573field;
    }

    inline validate_coin(coin: credits, commitment: field) -> bool {
        // check commitment from this record
        let record_scalar: scalar = Poseidon2::hash_to_scalar(coin);
        let commitment_preimage: InscribedRecordPreimage = InscribedRecordPreimage {
            program_id_field: program_id_field(),
            record_name_field: record_name_field(),
            record_plaintext_scalar: record_scalar,
        };
        let old_commitment: field = BHP1024::hash_to_field(commitment_preimage);
        return old_commitment == commitment;
    }

    inline incription_commitment(coin: credits) -> field {
        // handle commitment
        let record_scalar: scalar = Poseidon2::hash_to_scalar(coin);

        let commitment_preimage: InscribedRecordPreimage = InscribedRecordPreimage {
            program_id_field: program_id_field(),
            record_name_field: record_name_field(),
            record_plaintext_scalar: record_scalar,
        };

        let commitment: field = BHP1024::hash_to_field(commitment_preimage);
        return commitment;
    }

    // outputs first is inscribed coin's commitment
    transition inscribe_private (data: [[[u128; 32]; 32]; 32], coin: credits) -> (public field, private address) {
        let (c1, c2): (credits, credits) = credits.leo/transfer_private(coin, self.caller, 1u64);// use minimum amount

        // handle commitment
        let commitment: field = incription_commitment(c1);
        return (commitment, self.caller);
    }

    // outputs first is inscribed coin's commitment
    transition inscribe (data: [[[u128; 32]; 32]; 32], coin: credits) -> (public field, public address) {
        let (c1, c2): (credits, credits) = credits.leo/transfer_private(coin, self.caller, 1u64); // use minimum amount

        // handle commitment
        let commitment: field = incription_commitment(c1);
        return (commitment, self.caller);
    }

    // outputs first is consumed coin's tag, second is new transfered coin's commitment
    transition private_transfer (public commitment: field, coin: credits, receiver: address) -> public field {
        // check commitment from this record
        assert(validate_coin(coin, commitment));

        let (c1, c2): (credits, credits) = credits.leo/transfer_private(coin, receiver, coin.microcredits);

        // handle commitment
        let new_commitment: field = incription_commitment(c1);
        return new_commitment;
    }

    // outputs first is consumed coin's tag, second is new transfered coin's commitment
    transition transfer (public commitment: field, coin: credits, public receiver: address) -> public field {
        // check commitment from this record
        assert(validate_coin(coin, commitment));

        let (c1, c2): (credits, credits) = credits.leo/transfer_private(coin, receiver, coin.microcredits);

        // handle commitment
        let new_commitment: field = incription_commitment(c1);
        return new_commitment;
    }

    transition lock (public commitment: field, coin: credits, public receiver: address) {
        // check commitment from this record
        assert(validate_coin(coin, commitment));

        credits.leo/transfer_private_to_public(coin, receiver, 1u64);

        return finalize (commitment, receiver);
    }

    finalize lock (commitment: field, receiver: address) {
        Mapping::set(storage, commitment, receiver);
    }

    transition withdraw (public commitment: field) -> public field {
        let coin: credits = credits.leo/transfer_public_to_private(self, 1u64);

        // handle commitment
        let new_commitment: field = incription_commitment(coin);

        return new_commitment then finalize (self.caller, commitment);
    }

    finalize withdraw (caller: address, commitment: field) {
        let holder: address = Mapping::get(storage, commitment);
        assert(holder == caller);

        Mapping::remove(storage, commitment);
    }
}
