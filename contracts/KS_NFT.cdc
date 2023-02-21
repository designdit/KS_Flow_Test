import NonFungibleToken from 0x01

pub contract KS_NFT: NonFungibleToken {

    pub var totalSupply: UInt64
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)  

    pub resource NFT: NonFungibleToken.INFT {
      pub let id: UInt64

      pub var image: String 

      pub var grFrom: String

      pub var grTo: String

      init(_image: String, _grFrom: String, _grTo: String) {

        self.id = KS_NFT.totalSupply
        KS_NFT.totalSupply = KS_NFT.totalSupply + 1        
  
        self.image = _image
        self.grFrom = _grFrom
        self.grTo = _grTo
      }

    }

    pub resource interface CollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT    
        pub fun borrowKS_NFT(id: UInt64): &NFT?             
    }

    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, CollectionPublic {
       pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        init () {
            self.ownedNFTs <- {}
        }

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("NFT does not exist")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @KS_NFT.NFT

            emit Deposit(id: token.id, to: self.owner?.address)

            self.ownedNFTs[token.id] <-! token
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

pub fun borrowKS_NFT(id: UInt64): &NFT? {
     let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)
     return ref as! &NFT?
}

        destroy() {
            destroy self.ownedNFTs
        }

    }

    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    pub fun mintNFT(image: String, grFrom: String, grTo: String): @NFT {
        return <- create NFT (_image: image, _grFrom: grFrom, _grTo: grTo)
    }

    init() {
      self.totalSupply = 0;
    }
}

