
    // creating an async fx to compile the contract/generate files/
    // on a local ethereum network
    // once deployed, can be tested with fake miners and constructor will run
    // contract address will be generated.


const main = async () =>{
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy();
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
