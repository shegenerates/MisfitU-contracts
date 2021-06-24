pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/access/Ownable.sol";

contract Misfit_University is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint public fee;

    uint public reserved;

    string public baseUri;

    event Minted(address to, uint id, string uri);

    event PriceUpdated(uint newPrice);

    constructor() ERC721("Misfit University", "MFU") {
      fee = 80000000000000000 wei; //0.08 ETH
      baseUri = "ipfs://QmbumZq4f81hc2KsVWMMH2AmRpw7nSwX3KBsjABewabNnj/";
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /*
    * Mint Misfits
    */
    function mint(address player, uint numberOfMints)
        public payable
        returns (uint256)
    {
        require(_tokenIds.current() + numberOfMints < 9900, "Maximum amount of Misfits already minted."); //10000 item cap (9900 public + 100 team mints)
        require(msg.value >= fee * numberOfMints, "Fee is not correct.");  //User must pay set fee.`
        require(numberOfMints <= 20, "You cant mint more than 20 at a time.");

        for(uint i = 0; i < numberOfMints; i++) {

            _tokenIds.increment();
            uint256 newItemId = _tokenIds.current();
            string memory tokenURI = string(abi.encodePacked(baseUri, toString(newItemId),  ".json"));
            _mint(player, newItemId);
            _setTokenURI(newItemId, tokenURI);

            //removed Mint event here bc of gas intensity.
        }

        return _tokenIds.current();
    }

    function getOwnerResrveMinted() public view returns(uint){
        return reserved;
    }

    function mintOwner(address player, string memory tokenURI)
        public onlyOwner
        returns (uint256)
    {
        require(msg.sender == owner);
        require(reserved < 100); //owner can mint up to 100 for free. this can be handed over to a DAO too.

        require(_tokenIds.current() < 10000); //10000 item cap

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        emit Minted(player, newItemId, tokenURI);

        reserved = reserved + 1;

        return newItemId;
    }

    function updateFee(uint newFee) public onlyOwner{
      fee = newFee;

      emit PriceUpdated(newFee);
    }

    function getFee() public view returns (uint) {
      return fee;
    }

    function cashOut() public onlyOwner{
        require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
    }
}
