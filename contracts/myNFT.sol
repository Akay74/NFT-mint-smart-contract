// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyNFT is ERC721URIStorage {

    using Counters for Counters.Counter; // openzeppelin library for updating our token Id
    Counters.Counter private _tokenIds; // assign the value of the counter struct to the token Id

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // create 3 arrays for the random words used in the NFTs
    string[] firstWords = ["Captain", "Private", "Lieutenant", "Cadet", "Corporal", "Major", "General", "Comrade", "Rebel", "Marshall", "Officer", "Brigadier", "Commander", "Admiral", "Colonel"];
    string[] secondWords = ["Akay", "Obiwe", "Francis", "Ryan", "Jindu", "Victor", "Nnamdi", "Kamsi", "Chris", "David", "Athena", "Roach", "Soap", "Kalashnikov", "Ghost"];
    string[] thirdWords = ["Eagles", "Lion", "Wolf", "Cougar", "Tiger", "Hawk", "Price", "Rover", "Falcon", "Shark", "Whale", "Bear", "Hunter", "Dog", "Fox"];

    event NewAkayNFTMinted(address sender, uint256 tokenId);
    
    constructor() ERC721("AkayNFT", "AKAY") {
        console.log('lets get it!');
    }

    function getFirstRandomWord(uint tokenId) public view returns(string memory) {
        uint rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function getSecondRandomWord(uint tokenId) public view returns(string memory) {
        uint rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function getThirdRandomWord(uint tokenId) public view returns(string memory) {
        uint rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) public pure returns (uint) {
        return uint(keccak256(abi.encodePacked(input)));
    }

    function mintAkayNFT() public {
        // increment the counter for the next NFT minting
        _tokenIds.increment();

        // get current Id 
        uint newItemId = _tokenIds.current();

        string memory first = getFirstRandomWord(newItemId);
        string memory second = getSecondRandomWord(newItemId);
        string memory third = getThirdRandomWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        // concantenate the three words and the baseSvg to get the final SVG
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A limited edition Akay collection.", "image": "data:image/svg+xml;base64,',
                        // add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // set the final token uri from the generated json 
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(    string(
            abi.encodePacked(
            "https://nftpreview.0xdev.codes/?code=",
            finalTokenUri
        )
        ));
        console.log("--------------------\n");

        // mint NFT to the address msg.sender
        _safeMint(msg.sender, newItemId);
        // set NFT data
        _setTokenURI(newItemId, finalTokenUri);

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        emit NewAkayNFTMinted(msg.sender, newItemId);
    }

}

// data:image/svg+xml;base64,ICAgICJuYW1lIjogIkFrYXlBbHBoYUdvZGhhbmQiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBzcGVjaWFsIGVkaXRpb24gQWtheSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStRV3RoZVVGc2NHaGhSMjlrYUdGdVpEd3ZkR1Y0ZEQ0S1BDOXpkbWMrIg==

/*{
    "name": "AkayAlphaGodhand",
    "description": "An NFT from the special edition Akay collection",
    "image": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaW5ZTWluIG1lZXQiIHZpZXdCb3g9IjAgMCAzNTAgMzUwIj4KICAgIDxzdHlsZT4uYmFzZSB7IGZpbGw6IHdoaXRlOyBmb250LWZhbWlseTogc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgfTwvc3R5bGU+CiAgICA8cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJibGFjayIgLz4KICAgIDx0ZXh0IHg9IjUwJSIgeT0iNTAlIiBjbGFzcz0iYmFzZSIgZG9taW5hbnQtYmFzZWxpbmU9Im1pZGRsZSIgdGV4dC1hbmNob3I9Im1pZGRsZSI+QWtheUFscGhhR29kaGFuZDwvdGV4dD4KPC9zdmc+"
}*/