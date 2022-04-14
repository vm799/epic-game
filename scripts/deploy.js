
    // creating an async fx to compile the contract/generate files/
    // on a local ethereum network
    // once deployed, can be tested with fake miners and constructor will run
    // contract address will be generated.


    const main = async () =>{
        const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
        const gameContract = await gameContractFactory.deploy(
            ["Sarah", "Bruce", "She-Ra"],
            ["https://imgur.com/AEKcEOl.png",
            "https://i.imgur.com/aDIUIUd.jpeg",
            "https://i.imgur.com/3ByvYV2.jpeg"],
            [100,200,300],  //HP values
            [100,50,25]      //Attack damage values
        );
        await gameContract.deployed();
        console.log("Contract deployed to:", gameContract.address);
    
let txn;
  
txn = await gameContract.mintCharacterNFT(0);
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #2");

  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait();
  console.log("Minted NFT #3");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #4");

  console.log("Done deploying and minting!");
    };
    
    const runMain = async ()=>{
        try{
            await main();
            process.exit(0);
        } catch (error){
            console.log(error);
            process.exit(1);
        }
    };
    
    runMain();
    