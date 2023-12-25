# UniZexe Protocol

## Introduce

UniZexe是一种协议，允许用户以极低的成本在Aleo上进行状态存储和可信计算。通过将状态binding到Aleo的原生代币Record中，以及使用Zexe-like的加密原语。让普通用户以更具扩展性的方式参与进Aleo的生态，并且不失去隐私性。

如今，我们将主要使用UniZexe协议探索组合性更强并且更便宜的XRC-20代币以及NFT。未来，我们也会探索使用这套协议作为一种实施新型L2的方式。

## Definition

UniZexe的基础行为只有两个, 分别是 `inscribe` 和 `transfer`, 主要提供的功能也就是将数据铭刻在`Record` 上，以及转移`Inscribed Record`. 但是与其他铭文协议不同的是，基础行为都会有两个版本，分别是**Private**和**Public**，这个不仅在合约中体现，也会在索引器的实现上有差别。

1. **Inscribe**

   ```rust
   transition inscribe (data: [[u128; 16]; 32], coin: credits.leo/credits) -> (public field, public address)
   ```

   `inscribe`函数有两个**input**，分别是铭刻的内容`data`， 以及要铭刻的`Record`。

   `data`是一个由`u128`组成的二维数组，每个`u128`都是由16个`u8`组成，所以每个`data`都是由`Vec<u8>`转化过来的。

   ```rust
    pub fn to_vec(&self) -> Vec<u8> {
        let mut vec = Vec::new();
        for i in 0..32 {
            for j in 0..16 {
                vec.extend_from_slice(&self.0[i][j].to_le_bytes());
            }
        }
        vec
    }

    pub fn from_slice(vec: &[u8]) -> anyhow::Result<Self> {
        if vec.len() != 32 * 16 * 16 {
            bail!("Invalid slice length")
        }
        let mut arr = [[0u128; 16]; 32];
        for i in 0..32 {
            for j in 0..16 {
                let mut bytes = [0u8; 16];
                bytes.copy_from_slice(&vec[(i * 16 + j) * 16..(i * 16 + j + 1) * 16]);
                arr[i][j] = u128::from_le_bytes(bytes);
            }
        }
        Ok(Self(arr))
    }
   ```

   `Record`是Aleo原生合约的货币单位，遵循的是**UTXO**的模型。所以当使用`Inscribe`后会消耗掉当前的`Record`，然后产生两个新的`Record`，输出的第一个`Record`就是拥有铭文的`Inscribed Record`。

   <img src="https://files.catbox.moe/7envx1.png" alt="7envx1.png" style="zoom:50%;" />

   完成`inscribe`后的同时会生成两个**Output**，分别是对应**Inscription**的**Commitment**，以及持有人根据执行模式（Private or Public)分别对应的明文和密文地址。

2. **Transfer**

   ```rust
   transition transfer (public commitment: field, coin: credits.leo/credits, public receiver: address) -> public field
   ```

   `transfer`函数有3个**input**，分别是上述所说的**Inscription**的**Commitment**，以及对应的`Inscribed Record`，还有接受人的地址，这个同样分别有隐私和非隐私两种版本。

   完成操作后同样会有1个**Output**，是新生成的**Inscription**的**Commitment**，所以这就是为什么这个协议叫做**UniZexe**，它一样属于**UTXO**模型。

## Details(i.e. Why does it work)

要解释Why it works，我们要回到原生协议**ZEXE**上。

我们知道在**ZEXE**中定义了`Record`为**UTXO**模型，并且使用了大量加密原语使得`Record`的流转能保证隐私性。所以为了实现**Colored Coin**这一目标，我们直接在`Record`上实现是最简单也最稳定安全的，所以我们需要构建一个索引`Record`的方式。

![m8g8ip.png](https://files.catbox.moe/m8g8ip.png)

当产生一笔带有`Record`的transaction的时候，因为其隐私性，在链上我们只能观测到`(tag, serial_number) =transition=> (cipher_record, commitment, checksum)`这样一个transition。

- `tag = hash_psd2([sk_tag, commitment])` sk_tag是由用户view_key派生的。
- `serial_number = some_op(private_key, commitment)`
- `cipher_record = encrypt(view_key, plain_record)`
- `commitment = hash_bhp1024(to_bits_le![program_id, record_name, record_plaintext])`
- `checksum = hash_bhp1024(to_bit_le!(ciper_record))`

很明显的，当我们说我们持有一个未消耗的`Record`的时候，我们实际上持有的就是链上存在该`Record`的`Commitment`并且没有对应的`tag`和`serial_number`的**inclusion proof**。

所以很自然的我们最应该使用的是commitment作为我们inscription的索引方式。但是由于leo语言的限制，我们暂时没法对输入的`Record`进行`commitment`的计算，也就没法校验输入的`commitment`是否属于这个`Record`。所以我们构建了自己的`Commitment`，并且作为每次UTXO转换的输出。

```rust
  // handle commitment
  let record_scalar: scalar = Poseidon2::hash_to_scalar(coin);

  let commitment_preimage: InscribedRecordPreimage = InscribedRecordPreimage {
      program_id_field: program_id_field(),
      record_name_field: record_name_field(),
      record_plaintext_scalar: record_scalar,
  };

  let commitment: field = BHP1024::hash_to_field(commitment_preimage);
```

这样，我们即实现了对原生货币`Record`的绑定。

## Further(a way to implement off-chain and off-record ZEXE)

*TODO*
