pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Misfit is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address owner;
    uint fee;

    event Minted(address to, uint id, string uri);

    event PriceUpdated(uint newPrice);
    event OwnerUpdated(address newOwner);

    constructor(uint _fee) ERC721("Misfit", "MFU") {
      owner = msg.sender;
      fee = _fee;
    }

    function mint(address player, string memory tokenURI)
        public payable
        returns (uint256)
    {
        require(_tokenIds.current() < 10000); //10000 item cap
        require(msg.value >= fee);  //User must pay set fee.

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        Minted(player, newItemId, tokenURI);

        return newItemId;
    }

    function updateOwner(address newOwner) public{
      require(msg.sender == owner);
      owner = newOwner;

      OwnerUpdated(newOwner);
    }

    function updateFee(uint newFee) public{
      require(msg.sender == owner);
      fee = newFee;

      PriceUpdated(newFee);
    }

    function getFee() public view returns (uint) {
      return fee;
    }

    function getOwner() public view returns (address) {
      return owner;
    }
}
