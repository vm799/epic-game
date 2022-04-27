
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// NFT contract to inherit from.
// OpenZeppelin implements the NFT standard with own logic
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./libraries/Base64.sol";

// Helps with debugging smart contracts
import "hardhat/console.sol";

// Using constructor to print this statement on intialising contract
contract MyEpicGame is ERC721 {

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    struct BigBoss {
    string name;
    string imageURI;
    uint hp;
    uint maxHp;
    uint attackDamage;
}  

// console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);


// unique NFT identifier
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

// arr to hold default data for characters
CharacterAttributes[] defaultCharacters;
BigBoss public bigBoss;

// map the nft's tokenId : nft attributes
mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

//map the nft to an address: nft tokenID, can track and manage owner of nft
mapping(address => uint256) public nftHolders;

event CharacterNFTMinted(address sender, uint256 tokenId, uint256 characterIndex);
event AttackComplete(uint newBossHp, uint newPlayerHp);



//  constructor RUNS ONCE holds data for intialising game state to pass into run.js
constructor(
       string[] memory characterNames,
       string[] memory characterImageURIs,
       uint[] memory characterHp,
       uint[] memory characterAttackDmg,
     string memory bossName, // These new variables would be passed in via run.js or deploy.js.
  string memory bossImageURI,
  uint bossHp,
  uint bossAttackDamage
    )

    ERC721("Badasses", "Badass")
    {

    bigBoss = BigBoss({
    name: bossName,
    imageURI: bossImageURI,
    hp: bossHp,
    maxHp: bossHp,
    attackDamage: bossAttackDamage
        });
console.log("Done initializing boss %s w/ HP %s, img %s", bigBoss.name, bigBoss.hp, bigBoss.imageURI);

        for (uint i = 0; i < characterNames.length; i += 1){
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDmg[i]
            }));
            CharacterAttributes memory c = defaultCharacters[i];
            
            // Hardhat allows 4 params to be used on console.log: uint, string, bool, address
            console.log("Done intiliasing %s w/HP %s, img %s", c.name, c.hp, c.imageURI);
        }
        // incrementing the nfts
        _tokenIds.increment();
    }
    

function mintCharacterNFT(uint _characterIndex) external {
        uint256 newItemId = _tokenIds.current();

        // assigns the tokenId to callers wallet using solidity variable that gives access 
        // to person calling the contract
        _safeMint(msg.sender, newItemId);

nftHolderAttributes[newItemId] = CharacterAttributes({
    characterIndex: _characterIndex,
      name: defaultCharacters[_characterIndex].name,
      imageURI: defaultCharacters[_characterIndex].imageURI,
      hp: defaultCharacters[_characterIndex].hp,
      maxHp: defaultCharacters[_characterIndex].maxHp,
      attackDamage: defaultCharacters[_characterIndex].attackDamage
});
console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);
// keep track of who owns the nft
nftHolders[msg.sender] = newItemId;
//fx from OpenZeppelin
 _tokenIds.increment();

 emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    
}

function attackBoss() public {

  // Get the state of the player's NFT.
  uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
  CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
  console.log("\nPlayer w/ character %s about to attack. Has %s HP and %s AD", player.name, player.hp, player.attackDamage);
  console.log("Boss %s has %s HP and %s AD", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);
  // Make sure the player has more than 0 HP.
  require (
      player.hp > 0,
      "Error: character must have HP to attack boss."
  );
  // Make sure the boss has more than 0 HP.
  require (
      bigBoss.hp > 0,
      "Error: boss must have HP to be attacked."
  );
  // Allow player to attack boss.
  if (bigBoss.hp < player.attackDamage) {
      bigBoss.hp = 0;
  } else {
      bigBoss.hp = bigBoss.hp - player.attackDamage;
  }
  // Allow boss to attack player.
  if (player.hp < bigBoss.attackDamage){
      player.hp = 0;
  } else {
      player.hp = player.hp - bigBoss.attackDamage;
  }

    emit AttackComplete(bigBoss.hp, player.hp);
    console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
    console.log("Boss attacked player. New player hp: %s\n", player.hp);
}


function tokenURI(uint256 _tokenId) public view override returns (string memory) {
  CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

  string memory strHp = Strings.toString(charAttributes.hp);
  string memory strMaxHp = Strings.toString(charAttributes.maxHp);
  string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);

  string memory json = Base64.encode(
    abi.encodePacked(
      '{"name": "',
      charAttributes.name,
      ' -- NFT #: ',
      Strings.toString(_tokenId),
      '", "description": "This is an NFT that lets people play in the game BadAss Slayer!", "image": "',
      charAttributes.imageURI,
      '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
      strAttackDamage,'} ]}'
    )
  );

  string memory output = string(
    abi.encodePacked("data:application/json;base64,", json)
  );
  
  return output;
}

function checkIfUserHasNFT() public view returns (CharacterAttributes memory) {
 // Get the tokenId of the user's character NFT
uint256 userNftTokenId = nftHolders[msg.sender];
  // If the user has a tokenId in the map, return their character.
if (userNftTokenId > 0) {
    return nftHolderAttributes[userNftTokenId];
}
  // Else, return an empty character.
  else {
        CharacterAttributes memory emptyStruct;
        return emptyStruct;
  }
}


function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory){
return defaultCharacters;
}

function getBigBoss() public view returns (BigBoss memory){
return bigBoss;
}
}



