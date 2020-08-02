
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ether

[![Travis-CI Build
Status](https://travis-ci.org/datawookie/ether.svg?branch=master)](https://travis-ci.org/datawookie/ether)

The `ether` package provides functions for interacting with the Ethereum
network.

The details of the RPC interface along with `curl` examples of
interacting with it are documented in the [JSON RPC
page](https://github.com/ethereum/wiki/wiki/JSON-RPC) on the Ethereum
Wiki.

## Differences in relation to the main package (datawookie/ether)

New function eth_getTokenBalance(get balance of one ETH address)
Example:

``` r
eth_getTokenBalance(token_address = "0x2b591e99afe9f32eaa6214f7b7629768c40eeb39",address ="0xb96376d80a16af6700dcbaba2a459dd7856f103a")

Result: 1 'mpfr' number of precision  256   bits 
[1] 100
```

eth_call first step made. 
"Accepts to" and "data"
``` 
Object - The transaction call object
from: DATA, 20 Bytes - (optional) The address the transaction is sent from.
to: DATA, 20 Bytes - The address the transaction is directed to.
gas: QUANTITY - (optional) Integer of the gas provided for the transaction execution. eth_call consumes zero gas, but this parameter may be needed by some executions.
gasPrice: QUANTITY - (optional) Integer of the gasPrice used for each paid gas
value: QUANTITY - (optional) Integer of the value sent with this transaction
data: DATA - (optional) Hash of the method signature and encoded parameters. For details see Ethereum Contract ABI in the Solidity documentation
QUANTITY|TAG - integer block number, or the string "latest", "earliest" or "pending", see the default block parameter
```
https://eth.wiki/json-rpc/API#eth_call


## Installation

Install from GitHub using

``` r
# install.packages("devtools")
devtools::install_github("PatronMaster/ether")
```

Alternatively there is a stable version listed on CRAN.

## Example

Load the package.

``` r
library(ether)
```

You’ll need to connect to an Ethereum node exposing a RPC interface. By
default the package will attempt to connect to a node on `localhost`
using port 8545. However, you can also make use of the public RPC nodes
hosted by [infura.io](https://infura.io/). Assuming that you have
created an infura.io API key and stored it in the `INFURA_MAINNET_KEY`
environment
variable.

``` r
set_rpc_address("https://mainnet.infura.io/", key = Sys.getenv("INFURA_MAINNET_KEY"))
```

Once you’ve configured the connection to RPC you are ready to interact
with the Ethereum blockchain.

``` r
eth_blockNumber()
#> [1] 9350538
```

``` r
eth_gasPrice()
#> 1 'mpfr' number of precision  32   bits 
#> [1] 1000000000
```

``` r
eth_getBalance("0xD34DA389374CAAD1A048FBDC4569AAE33fD5a375")
#> 1 'mpfr' number of precision  60   bits 
#> [1] 247878498530503149
```

``` r
eth_getTransactionCount("0xD34DA389374CAAD1A048FBDC4569AAE33fD5a375")
#> [1] 1150417
```
