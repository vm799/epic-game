
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// Helps with debugging smart contracts
import "hardhat/console.sol";

// Using constructor to print this statement on intialising contract
contract MyEpicGame {

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
        uint defence;
    }
    // arr to hold default data for characters
CharacterAttributes[] defaultCharacters;

//  holds data for intialising game state to pass into run.js
    constructor(
       string[] memory characterNames,
       string[] memory characterImageURIs,
       uint[] memory characterHp,
       uint[] memory characterAttackDmg
    )
}

