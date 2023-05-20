// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title IPaperlx
 * @author Techan
 */
interface IPaperlx {
    struct Credential {
        address creator;
        address owner;
        string uri;
        uint64 id;
        uint64 timeCreated;
    }

    struct Creator {
        uint64 id;
        uint64 docsCount;
        struct[] Credential;
    }

    /**
     * @notice Emits when a document is created 
     * @param id the id of the document created
     * @param uri the URI of the document created
     */
    event docCreated(uint128 id, string uri);

    /**
     * @notice Emits when a document is deleted
     * @param id the id of the document deleted
     */
    event docDeleted(uint128 id);

    /**
     * @notice Emits when a document is updated
     * @param id the id of the document updated
     * @param oldUri the URI of the document to be updated
     * @param newUri the new URI of the document
     */
    event docUpdated(uint128 id, string oldUri, string newUri);

    /**
     * @dev adds a new user to the contract
     * @param user is the address of the user to register
     */
    function registerUser(address user) external;

    /**
     * @dev updates the user address linked to documents
     * @param newUser new user address 
     */
    function updateUser(address newUser) external;

    /**
     * @dev receives the doc uri which has been generated on the frontend
     * using ipfs/filecoin and creates a copy on the blockchain 
     * @param docUri uri of doc containing the json metadata
     */
    function createDoc(string docUri) external;

    /**
     * @dev updates the doc uri linked to the doc id
     * @param docId id of the document to be updated
     * @param newDocUri new uri that will be linked to document id
     */
    function updateDoc(uint128 docId, string newDocUri) external;

    /**
     * @dev deletes the doc entry on the smart contract
     * @param docId the id of the document to be deleted
     */
    function deleteDoc(uint128 docId) external;

    /**
     * @dev returns the details of the Credential struct
     * @param id the id of the doc to fetch details from
     */
    function getDoc(uint128 id) external view returns(Credential memory);

    /**
     * @dev returns the details of the Creator struct
     * @param id the id of the user
     */
    function getUser(uint128 id) external view returns(Creator memory);

    /**
     * @dev verifies that an address is part of the Paperlx registry
     * @param userQuery address of user to be verified
     */
    function isValidUser(address userQuery) external view returns (bool);
}