//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "./Base64.sol";
import "./FunPunksDNA.sol";

contract FunPunks is ERC721, ERC721Enumerable, PaymentSplitter, FunPunksDNA {
    using Counters for Counters.Counter;

    Counters.Counter private _idCounter;
    uint256 public maxSuply;
    mapping(uint256 => uint256) public tokenDNA;

    constructor(
        address[] memory _payees,
        uint256[] memory _shares,
        uint256 _maxSuply
    ) payable ERC721("FunPunks", "FNPKS") PaymentSplitter(_payees, _shares) {
        maxSuply = _maxSuply;
    }

    function mint() public {
        // require(
        //     msg.value >= 50000000000000000,
        //     "you neet 0.05 ETH to mint the FunPunks"
        // );
        // _idCounter.increment();
        uint256 current = _idCounter.current();
        require(current < maxSuply, "No FunPunks left to mint");

        tokenDNA[current] = deterministicPseudoRandomDNA(current, msg.sender);
        _safeMint(msg.sender, current);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://avataaars.io/";
    }

    function _paramsURI(uint256 _dna) internal view returns (string memory) {
        string memory params;
        params = string(abi.encodePacked(
            "accessoriesType=",
            getAccessoriesType(_dna),
            "&clotheColor=",
            getClotheColor(_dna),
            "&clotheType=",
            getClotheType(_dna),
            "&eyeType=",
            getEyeType(_dna),
            "&eyebrowType=",
            getEyeBrowType(_dna),
            "&facialHairColor=",
            getFacialHairColor(_dna),
            "&facialHairType=",
            getFacialHairType(_dna),
            "&hairColor=",
            getHairColor(_dna),
            "&hatColor=",
            getHatColor(_dna),
            "&graphicType=",
            getGraphicType(_dna),
            "&mouthType=",
            getMouthType(_dna),
            "&skinColor=",
            getSkinColor(_dna),
            "&topType=",
            getTopType(_dna)
        ));
        return params;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721 Metadata; URI query for nonexistent token"
        );
        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "FunPunks #',
                tokenId,
                '", "description": "An incredible NFT collection", "image": "',
                "// TODO: Calculate image URL",
                '"attributes": [{"Accessories Type": "Blank", "Clothe Color": "Red", "Clothe Type": "Hoodie", "Eye Type": "Default", "Eyebrow Type": "Default"}]',
                '"}'
            )
        );
        return
            string(abi.encodePacked("data:application/json;base64", jsonURI));
    }

    //Override require
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
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
