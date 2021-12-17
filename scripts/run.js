const main = async() => {
    const nftContractFactory = await hre.ethers.getContractFactory("OnchainNFT");
    const nftContract = await nftContractFactory.deploy();
    nftContract.deployed();
    console.log("Contract deployed to: ", nftContract.address);

    let txn = await nftContract.makeOnchainNFT();
    await txn.wait();
}

const runMain = async() => {
    try {
        await main();
        process.exit(0);
    }
    catch(error) {
        console.log(error);
        process.exit(1);
    }
}

runMain();