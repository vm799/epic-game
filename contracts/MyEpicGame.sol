
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

//  constructor RUNS ONCE holds data for intialising game state to pass into run.js
constructor(
       string[] memory characterNames,
       string[] memory characterImageURIs,
       uint[] memory characterHp,
       uint[] memory characterAttackDmg,
       uint[] memory characterDefence
    )
    {
        for (uint i = 0; i < characterNames.length; i += 1){
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i;
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                attackDamage: characterAttackDmg[i],
                defence: characterDefence
            }));
            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done intiliasing %s w/HP %s, img %s", c.name, c.hp, c.imageURI);
        }
    }
}




