
    // creating an async fx to compile the contract/generate files/
    // on a local ethereum network
    // once deployed, can be tested with fake miners and constructor will run
    // contract address will be generated.
    // https://rinkeby.rarible.com/token/0xED6193B84153E9f2FA6E361209b813d0D1FE2aa9:1

    const main = async () =>{
        const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
        const gameContract = await gameContractFactory.deploy(
            ["Sarah", "Bruce", "She-Ra"],
            ["https://imgur.com/AEKcEOl.png",
            "https://i.imgur.com/aDIUIUd.jpeg",
            "https://i.imgur.com/3ByvYV2.jpeg"],
            [100,200,300],  //HP values
             [100,50,25],     //Attack damage values
        "The Terminator",
        "https://i.imgur.com/xTF778g.png",
        10000,
        50
        );
        await gameContract.deployed();
        console.log("Contract deployed to:", gameContract.address);
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
    