pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Mifit is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address owner;
    uint fee;

    constructor(uint _fee) ERC721("Misfit", "MFU") {
      owner = msg.sender;
      fee = _fee;
    }

    function mint(address player, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();
        require(_tokenIds <= 10000); //10000 item cap

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function updateOwner() {

    }

    function updateFee() {

    }
}
