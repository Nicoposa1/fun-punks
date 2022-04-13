//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";


contract FunPunks is ERC721, ERC721Enumerable, PaymentSplitter {
  using Counters for Counters.Counter;

  Counters.Counter private _idCounter;
  uint256 public maxSuply;

  constructor(address[] memory _payees, uint256[] memory _shares, uint256 _maxSuply) ERC721("FunPunks", "FNPKS") PaymentSplitter(_payees, _shares) payable{
    maxSuply = _maxSuply;
  }

  function mint() public payable {
    require(msg.value >= 50000000000000000, "you neet 0.05 ETH to mint the PinaPunks");
    _idCounter.increment();
    uint256 current = _idCounter.current(); 
    require(current < maxSuply, "No FunPunks left to mint");
    _safeMint(msg.sender, current);
  }

  //Override require
  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}
