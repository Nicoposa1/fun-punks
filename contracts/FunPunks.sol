//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract FunPunks is ERC721, ERC721Enumerable {
  using Counters for Counters.Counter;

  Counters.Counter private _idCounter;
  uint256 public maxSuply;

  constructor(uint256 _maxSuply) ERC721("FunPunks", "FNPKS") {
    maxSuply = _maxSuply;
  }

  function mint() public {
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
