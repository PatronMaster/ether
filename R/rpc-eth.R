#' Returns the current ethereum protocol version.
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_protocolVersion()
#' }
eth_protocolVersion <- function() {
  get_post_response("eth_protocolVersion") %>% hex_to_dec()
}

#' Returns an object with data about the sync status.
#'
#' @return Boolean.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_syncing()
#' }
eth_syncing <- function() {
  get_post_response("eth_syncing")
}

#' Returns the client coinbase address.
#'
#' @return A 20 byte (hexadecimal) Ethereum address.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_coinbase()
#' }
eth_coinbase <- function() {
  get_post_response("eth_coinbase")
}

#' Returns true if client is actively mining new blocks.
#'
#' @return Boolean.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_mining()
#' }
eth_mining <- function() {
  get_post_response("eth_mining")
}

#' Returns the number of hashes per second that the node is mining with.
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_hashrate()
#' }
eth_hashrate <- function() {
  get_post_response("eth_hashrate") %>% hex_to_dec()
}

#' Returns the current gas price in wei.
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_gasPrice()
#' }
eth_gasPrice <- function() {
  get_post_response("eth_gasPrice") %>% mpfr(base = 16)
}

#' Returns addresses owned by client.
#'
#' @return A vector of 20 byte (hexadecimal) Ethereum addresses.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_accounts()
#' }
eth_accounts <- function() {
  get_post_response("eth_accounts") %>% unlist()
}

#' Returns the number of most recent block.
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_blockNumber()
#' }
eth_blockNumber <- function() {
  get_post_response("eth_blockNumber") %>% hex_to_dec()
}

#' Returns the balance (in Wei) of the account at specified address.
#'
#' @param address A 20 byte (hexadecimal) Ethereum address.
#' @param number An integer block number (as a hexidecimal string) or one of "earliest", "latest" or "pending".
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getBalance()
#' eth_getBalance("0xD34DA389374CAAD1A048FBDC4569AAE33fD5a375")
#' }
eth_getBalance <- function(address = NULL, number = "latest") {
  if (is.null(address)) {
    address = eth_coinbase()
    #
    # If there is no coinbase available.
    #
    if (is.null(address)) stop("Must specify address.")
  }
  get_post_response("eth_getBalance", list(address, number)) %>% mpfr(base = 16)
}



#' Executes a new message call immediately without creating a transaction on the block chain.
#'
#' Not completed just to_address and data
#' https://eth.wiki/json-rpc/API#eth_accounts
#'
#'
#'
#' @examples
#' \dontrun{
#' #eth_call(to_address =token_address,data = data)
#' #eth_call(to_address ="0x0D8775F648430679A709E98d2b0Cb6250d2887EF",
#' #data = "0x70a08231000000000000000000000000D79D326318aa8aBd5B84984dd5F258f7B5ecD356")
#' }
eth_call <- function(from_address = NULL,to_address, gas = NULL ,gasPrice = NULL ,value = NULL, data = NULL ,number = "latest") {
  if (is.null(to_address)) {
     stop("Must specify address.")
  }
  to_data<-list(to = to_address, data = data)

  if (!is.null(data)) {
    get_post_response("eth_call", list(to_data, number))%>% mpfr(base = 16)
  }

 #get_post_response("eth_call", list(address, number)) %>% mpfr(base = 16)
}

#' Returns the tokens balance of the account at specified address.
#'
#' @param token_address A 20 byte (hexadecimal) Token address.
#' @param address A 20 byte (hexadecimal) Ethereum address.
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' #' eth_getTokenBalance(token_address = "0x2b591e99afe9f32eaa6214f7b7629768c40eeb39",
#' # address = "0xb96376d80a16af6700dcbaba2a459dd7856f103a")
#' }
eth_getTokenBalance <- function(token_address,address) {
  if (is.null(address)|| is.null(token_address)) {
    stop("Must specify address.")
  }
  balanceOf<- "0x70a08231"
  decimals<-"0x313ce567"
  pathing <- "000000000000000000000000"
  address<-gsub("0x","",address)
  data<-paste0(decimals,pathing,address)
  Tokendecimals<-eth_call(to_address =token_address,data = data )
  data<-paste0(balanceOf,pathing,address)
  eth_call(to_address =token_address,data = data)/(10^Tokendecimals)
}

#' Returns the value from a storage position at a given address.
#'
#' @param address A 20 byte (hexadecimal) Ethereum address.
#' @param position Position in the storage.
#' @param number An integer block number (as a hexidecimal string) or one of "earliest", "latest" or "pending".
#'
#' @return Hex string.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getStorageAt("0x3589d05a1ec4Af9f65b0E5554e645707775Ee43C", "0x0")
#' }
eth_getStorageAt <- function(address, position, number = "latest") {
  get_post_response("eth_getStorageAt", list(address, position, number))
}

#' Returns the number of transactions sent from an address.
#'
#' @param address A 20 byte (hexadecimal) Ethereum address.
#' @param number An integer block number (as a hexidecimal string) or one of "earliest", "latest" or "pending".
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getTransactionCount("0xD34DA389374CAAD1A048FBDC4569AAE33fD5a375")
#' }
eth_getTransactionCount <- function(address = NULL, number = "latest") {
  if (is.null(address)) address = eth_coinbase()
  get_post_response("eth_getTransactionCount", list(address, number)) %>% hex_to_dec()
}

#' Returns the number of transactions in a block matching the given block hash.
#'
#' @param hash Hash of a block.
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getBlockTransactionCountByHash(
#'   "0xb6d656ead4c3d4b1aa24d6b4d3d4cde8c090794e597258993512d650f088fcba"
#' )
#' }
eth_getBlockTransactionCountByHash <- function(hash) {
  get_post_response("eth_getBlockTransactionCountByHash", list(hash)) %>% hex_to_dec()
}

#' Returns the number of transactions in a specified block.
#'
#' @param number An integer block number (as a hexidecimal string) or one of "earliest", "latest" or "pending".
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getBlockTransactionCountByNumber("0x4720FF")
#' eth_getBlockTransactionCountByNumber()
#' }
eth_getBlockTransactionCountByNumber <- function(number = "latest") {
  get_post_response("eth_getBlockTransactionCountByNumber", list(number)) %>% hex_to_dec()
}

#' Returns the number of uncles in a block from a block matching the given block hash.
#'
#' @param hash Hash of a block.
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getUncleCountByBlockHash("0x8575df1eb3df61f3880628ca8e495038ee0b278c0aa48fe41f80b8d0d4e83e79")
#' }
eth_getUncleCountByBlockHash <- function(hash) {
  get_post_response("eth_getUncleCountByBlockHash", list(hash)) %>% hex_to_dec()
}

#' Returns the number of uncles in a block from a block matching the given block number.
#'
#' @param number An integer block number (as a hexidecimal string) or one of "earliest", "latest" or "pending".
#'
#' @return Integer.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getUncleCountByBlockNumber("0x4720fe")
#' }
eth_getUncleCountByBlockNumber <- function(number) {
  get_post_response("eth_getUncleCountByBlockNumber", list(number)) %>% hex_to_dec()
}

#' Returns information about a specified block.
#'
#' Combines functionality from eth_getBlockByHash() and eth_getBlockByNumber().
#'
#' @param hash Hash of a block.
#' @param number An integer block number (as a hexidecimal string) or one of "earliest", "latest" or "pending".
#' @param full Whether or not to return full transaction objects.
#'
#' @return List.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getBlock()
#' eth_getBlock("0xb6d656ead4c3d4b1aa24d6b4d3d4cde8c090794e597258993512d650f088fcba")
#' eth_getBlock(number = "0x4720FF")
#' eth_getBlock(number = "0x49a8ea") # A block with two uncles.
#' }
eth_getBlock <- function(hash = NULL, number = "latest", full = TRUE) {
  if (!is.null(hash))
    block <- get_post_response("eth_getBlockByHash", list(hash, full))
  else
    block <- get_post_response("eth_getBlockByNumber", list(number, full))

  block$timestamp <- hex_to_dec(block$timestamp)
  #
  if (!block$timestamp) {
    block$timestamp <- NA
  } else {
    block$timestamp <- as.POSIXct(block$timestamp, origin = "1970-01-01", tz = "UTC")
  }

  if (length(block$transactions)) {
    block$transactions <- lapply(block$transactions, function(transaction) {
      # The presence of NULL breaks bind_rows().
      if (is.null(transaction$to)) transaction$to <- NA
      transaction
    }) %>%
      bind_rows() %>%
      rename_(index = "transactionIndex")
  } else {
    block$transactions = NA
  }

  block
}

#' Returns the information about a transaction.
#'
#' @param hash A transaction hash.
#'
#' @return List.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getTransactionByHash("0x4b0f317c326299a4d063ccccff2daf7452c35dc7ec5b4279f001d6e2f745cc6f")
#' eth_getTransactionByHash("0x8fd9e04958cc4fb602b9d9fa5a9b6da512779ccd22477ccc5ce73721296cf151")
#' }
eth_getTransactionByHash <- function(hash) {
  get_post_response("eth_getTransactionByHash", list(hash))
}

#' Returns information about a transaction by block hash and transaction index position.
#'
#' @param hash A block hash.
#' @param index Index of transaction in block.
#'
#' @return List.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getTransactionByBlockHashAndIndex(
#'   "0xb6d656ead4c3d4b1aa24d6b4d3d4cde8c090794e597258993512d650f088fcba", "0x0"
#' )
#' eth_getTransactionByBlockHashAndIndex(
#'   "0xb6d656ead4c3d4b1aa24d6b4d3d4cde8c090794e597258993512d650f088fcba", "0x5"
#' )
#' }
eth_getTransactionByBlockHashAndIndex <- function(hash, index) {
  get_post_response("eth_getTransactionByBlockHashAndIndex", list(hash, index))
}

#' Returns information about a transaction by block number and transaction index position.
#'
#' @param number An integer block number (as a hexidecimal string) or one of "earliest", "latest" or "pending".
#' @param index Index of transaction in block.
#'
#' @return List.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getTransactionByBlockNumberAndIndex("0x4720FF", "0x0")
#' eth_getTransactionByBlockNumberAndIndex("0x4720FF", "0x5")
#' }
eth_getTransactionByBlockNumberAndIndex <- function(number, index) {
  get_post_response("eth_getTransactionByBlockNumberAndIndex", list(number, index))
}

#' Returns the receipt of a transaction by transaction hash.
#'
#' @param hash A transaction hash.
#'
#' @return List.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getTransactionReceipt("0x8fd9e04958cc4fb602b9d9fa5a9b6da512779ccd22477ccc5ce73721296cf151")
#' }
eth_getTransactionReceipt <- function(hash) {
  get_post_response("eth_getTransactionReceipt", list(hash))
}

#' Returns information about an uncle of a block by hash and uncle index position.
#'
#' @param hash Hash of a block.
#' @param index Index of transaction in block.
#'
#' @return List.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getUncleByBlockHashAndIndex(
#'   "0x8575df1eb3df61f3880628ca8e495038ee0b278c0aa48fe41f80b8d0d4e83e79", "0x0"
#' )
#' }
eth_getUncleByBlockHashAndIndex <- function(hash, index) {
  get_post_response("eth_getUncleByBlockHashAndIndex", list(hash, index))
}

#' Returns information about a uncle of a block by number and uncle index position.
#'
#' @param number An integer block number (as a hexidecimal string) or one of "earliest", "latest" or "pending".
#' @param index Index of transaction in block.
#'
#' @return List.
#' @export
#'
#' @examples
#' \dontrun{
#' eth_getUncleByBlockNumberAndIndex("0x4720fe", "0x0")
#' }
eth_getUncleByBlockNumberAndIndex <- function(number, index) {
  get_post_response("eth_getUncleByBlockNumberAndIndex", list(number, index))
}

