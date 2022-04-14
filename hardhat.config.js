require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.1",
  networks:{
    rinkeby: {
      url: 'kGHTE7D_rMYCFeb5p1wJgPwYpZyBodjr',
      accounts: ['a1d9e37bbf1bb27a28a029c172388c944f84bf4129cf5c803c8d09d82d6c0ddb'],
    },
  },
};
