# UniZexe Protocol

## Introduce

UniZexe是一种协议，允许用户以极低的成本在Aleo上进行状态存储和可信计算。通过将状态binding到Aleo的原生代币Record中，以及使用Zexe-like的加密原语。让普通用户以更具扩展性的方式参与进Aleo的生态，并且不失去隐私性。

如今，我们将主要使用UniZexe协议探索组合性更强并且更便宜的XRC-20代币以及NFT。未来，我们也会探索使用这套协议作为一种实施新型L2的方式。

## Definition

UniZexe的基础行为只有两个, 分别是 `inscribe` 和 `transfer`, 主要提供的功能也就是将数据铭刻在`Record` 上，以及转移`Inscribed Record`. 但是与其他铭文协议不同的是，基础行为都会有两个版本，分别是**Private**和**Public**，这个不仅在合约中体现，也会在索引器的实现上有差别。

1. **Inscribe**

   ```rust
   transition inscribe (data: [[[u128; 32]; 32]; 32], coin: credits.leo/credits) -> (public field, public address)
   ```

   `inscribe`函数有两个**input**，分别是铭刻的内容`data`， 以及要铭刻的`Record`。

   `data`是一个由`u128`组成的三维数组，每个`u128`都是由16个`u8`组成，所以每个`data`都是由`Vec<u8>`转化过来的。

   ```rust
   fn example_data_transform() {
       // from Vec<u8> to [[[u128; 32]; 32]; 32]
       let mut raw_data = vec![5u8, 6u8, 7u8, 8u8];
       raw_data.resize(32 * 32 * 32, 0);
       let raw_data = raw_data.chunks(16).map(|c| u128::from_le_bytes(c.try_into().unwrap())).collect::<Vec<u128>>();
       let mut data = [[[0u128; 32]; 32]; 32];
       for (i, num) in raw_data.iter().enumerate() {
           let x = i / 32 / 32;
           let y = i / 32 % 32;
           let z = i % 32;
           data[x][y][z] = *num;
       }

       // from [[[u128; 32]; 32]; 32] to Vec<u8>
       let mut raw_data = Vec::new();
       for x in 0..32 {
           for y in 0..32 {
               for z in 0..32 {
                   raw_data.push(data[x][y][z]);
               }
           }
       }
       let mut data = Vec::new();
       for num in raw_data {
           let bytes = num.to_le_bytes();
           data.extend_from_slice(&bytes);
       }
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

So, why does it work?

我们必须从原始的ZEXE模型开始说起。

在原生的
