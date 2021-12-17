//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract OnchainNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter public tokenIDs;

    string public baseSVG = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    constructor() ERC721("OnchainNFT", "OCN") {
        console.log("Onchain NFT");
    }

    string[] firstWord = ["doctor strange", "hulk", "iron man", "thor", "quicksilver"];
    string[] secondWord = ["picaso", "vinci", "rembendt", "gogh", "varma"];
    string[] thirdWord = ["harvey", "mike", "berlin", "professor", "john"];

    event NewOnchainNFTMinted(address sender, uint256 tokenId);

    function pickRandomFirstWord(uint _tokenId) public view returns(string memory) {
        uint rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(_tokenId))));
        rand = rand % firstWord.length;
        return firstWord[rand];
    }

    function pickRandomSecondWord(uint _tokenId) public view returns(string memory) {
        uint rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(_tokenId))));
        rand = rand % firstWord.length;
        return firstWord[rand];
    }

    function pickRandomThirdWord(uint _tokenId) public view returns(string memory) {
        uint rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(_tokenId))));
        rand = rand % firstWord.length;
        return firstWord[rand];
    } 

    function random(string memory _input) public pure returns(uint) {
        return uint(keccak256(abi.encodePacked(_input)));
    }

    function makeOnchainNFT() public {
        uint newTokenId = tokenIDs.current();

        string memory first = pickRandomFirstWord(newTokenId);
        string memory second = pickRandomFirstWord(newTokenId);
        string memory third = pickRandomFirstWord(newTokenId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));
        string memory finalSVG = string(abi.encodePacked(baseSVG, combinedWord, "</text></svg>"));

        console.log(finalSVG);

        string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSVG)),
                    '"}'
                )
            )
        )
    );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s", newTokenId, msg.sender);
        tokenIDs.increment();

    emit NewOnchainNFTMinted(msg.sender, newTokenId);

    }

}