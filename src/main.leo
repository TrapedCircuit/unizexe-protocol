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

    // outputs first is inscribed coin's commitment
    transition inscribe_private (data: [[[u128; 32]; 32]; 32], coin: credits) -> (public field, private address) {
        let (c1, c2): (credits, credits) = credits.leo/transfer_private(coin, self.caller, 1u64);// use minimum amount

        // handle commitment
        let record_scalar: scalar = Poseidon2::hash_to_scalar(c1);

        let commitment_preimage: InscribedRecordPreimage = InscribedRecordPreimage {
            program_id_field: program_id_field(),
            record_name_field: record_name_field(),
            record_plaintext_scalar: record_scalar,
        };

        let commitment: field = BHP1024::hash_to_field(commitment_preimage);
        return (commitment, self.caller);
    }

    // outputs first is inscribed coin's commitment
    transition inscribe (data: [[[u128; 32]; 32]; 32], coin: credits) -> (public field, public address) {
        let (c1, c2): (credits, credits) = credits.leo/transfer_private(coin, self.caller, 1u64); // use minimum amount

        // handle commitment
        let record_scalar: scalar = Poseidon2::hash_to_scalar(c1);

        let commitment_preimage: InscribedRecordPreimage = InscribedRecordPreimage {
            program_id_field: program_id_field(),
            record_name_field: record_name_field(),
            record_plaintext_scalar: record_scalar,
        };

        let commitment: field = BHP1024::hash_to_field(commitment_preimage);
        return (commitment, self.caller);
    }

    // outputs first is consumed coin's tag, second is new transfered coin's commitment
    transition private_transfer (public commitment: field, coin: credits, receiver: address) -> public field {
        // check commitment from this record
        let old_record_scalar: scalar = Poseidon2::hash_to_scalar(coin);
        let old_commitment_preimage: InscribedRecordPreimage = InscribedRecordPreimage {
            program_id_field: program_id_field(),
            record_name_field: record_name_field(),
            record_plaintext_scalar: old_record_scalar,
        };
        let old_commitment: field = BHP1024::hash_to_field(old_commitment_preimage);
        assert_eq(old_commitment, commitment);

        let (c1, c2): (credits, credits) = credits.leo/transfer_private(coin, receiver, coin.microcredits);

        // handle commitment
        let record_scalar: scalar = Poseidon2::hash_to_scalar(c1);

        let commitment_preimage: InscribedRecordPreimage = InscribedRecordPreimage {
            program_id_field: program_id_field(),
            record_name_field: record_name_field(),
            record_plaintext_scalar: record_scalar,
        };

        let new_commitment: field = BHP1024::hash_to_field(commitment_preimage);
        return new_commitment;
    }

    // outputs first is consumed coin's tag, second is new transfered coin's commitment
    transition transfer (public commitment: field, coin: credits, public receiver: address) -> public field {
        // check commitment from this record
        let old_record_scalar: scalar = Poseidon2::hash_to_scalar(coin);
        let old_commitment_preimage: InscribedRecordPreimage = InscribedRecordPreimage {
            program_id_field: program_id_field(),
            record_name_field: record_name_field(),
            record_plaintext_scalar: old_record_scalar,
        };
        let old_commitment: field = BHP1024::hash_to_field(old_commitment_preimage);
        assert_eq(old_commitment, commitment);

        let (c1, c2): (credits, credits) = credits.leo/transfer_private(coin, receiver, coin.microcredits);

        // handle commitment
        let record_scalar: scalar = Poseidon2::hash_to_scalar(c1);

        let commitment_preimage: InscribedRecordPreimage = InscribedRecordPreimage {
            program_id_field: program_id_field(),
            record_name_field: record_name_field(),
            record_plaintext_scalar: record_scalar,
        };

        let new_commitment: field = BHP1024::hash_to_field(commitment_preimage);
        return new_commitment;
    }
}
