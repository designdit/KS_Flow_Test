import KS_NFT from 0x02

transaction(image: String, grFrom: String, grTo: String) {
    prepare(acct: AuthAccount) {
        if acct.borrow<&KS_NFT.Collection>(from: /storage/KS_NFT_TestCollection) == nil {
            acct.save(<- KS_NFT.createEmptyCollection(), to: /storage/KS_NFT_TestCollection)
            acct.link<&KS_NFT.Collection{KS_NFT.CollectionPublic}>(/public/KS_NFTCollection, target: /storage/KS_NFT_TestCollection)
        }

        let nftCollection = acct.borrow<&KS_NFT.Collection>(from: /storage/KS_NFT_TestCollection)!
        nftCollection.deposit(token: <-KS_NFT.mintNFT(image: image, grFrom: grFrom, grTo: grTo))

    }

    execute {
      log("Minted an NFT")
    }
}
