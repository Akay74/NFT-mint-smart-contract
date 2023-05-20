// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./interface/IPaperlx.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title Techan-Paperlx
 * @author akay@techan.io
 */
contract Paperlx {

    using SafeMath for uint256;
    using Counters for Counters.Counter; // openzeppelin library for updating our token Id

    Counters.Counter private _tokenIds; // assign the value of the counter struct to the token Id

    mapping(address => Creator) public creators;
    mapping(uint128 => Credential) public credentials;
    mapping(address => bool) public validUser;

    constructor() ERC721("Techan", "TCHN") {}

    /**
     * @dev adds a new user to the contract
     * @param user is the address of the user to register
     */
    function registerUser(address user) external {
        creators[user] = Creator({
            id: uint64(block.timestamp),
            docsCount: 0,
            credentials: new Credential[](0)
        });
    }

    /**
     * @dev updates the user address linked to documents
     * @param newUser new user address 
     */
    function updateUser(address newUser) external {
        Creator storage creator = creators[msg.sender];
        creators[newUser] = creator;
        delete creators[msg.sender];
    }

    /**
     * @dev receives the doc uri which has been generated on the frontend
     * using ipfs/filecoin and creates a copy on the blockchain 
     * @param docUri uri of doc containing the json metadata
     */
    function createDoc(string memory docUri) external {
        Creator storage creator = creators[msg.sender];
        uint128 docId = uint128(block.timestamp);
        Credential memory credential = Credential({
            creator: msg.sender,
            owner: msg.sender,
            uri: docUri,
            id: docId,
            timeCreated: uint64(block.timestamp)
        });
        creator.credentials.push(credential);
        creator.docsCount++;
        credentials[docId] = credential;
        emit docCreated(docId, docUri);
    }

    /**
     * @dev updates the doc uri linked to the doc id
     * @param docId id of the document to be updated
     * @param newDocUri new uri that will be linked to document id
     */
    function updateDoc(uint128 docId, string memory newDocUri) external {
        Credential storage credential = credentials[docId];
        require(msg.sender == credential.owner, "Only document owner can update the document");
        emit docUpdated(docId, credential.uri, newDocUri);
        credential.uri = newDocUri;
    }

    /**
     * @dev deletes the doc entry on the smart contract
     * @param docId the id of the document to be deleted
     */
    function deleteDoc(uint128 docId) external {
        Credential storage credential = credentials[docId];
        Creator storage creator = creators[credential.creator];
        require(msg.sender == credential.owner, "Only document owner can delete the document");
        emit docDeleted(doc)Id;
    };
}