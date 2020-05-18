pragma solidity >=0.4.24;
import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";


contract StarNotary is ERC721 {
    struct Star {
        string name;}
    string public constant name = "flickStar token";
    string public constant symbol = "FST";
    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    function createStar(string memory _name, uint256 _tokenId) public { 
        Star memory newStar = Star(_name);
        tokenIdToStarInfo[_tokenId] = newStar; 
        _mint(msg.sender, _tokenId);
    }
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sale the Star you don't owned");
        starsForSale[_tokenId] = _price;
    }
    function _make_payable(address x) internal pure returns (address payable) {
        return address(uint160(x));
    }

    function buyStar(uint256 _tokenId) public  payable {
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value > starCost, "You need to have enough Ether");
        _transferFrom(ownerAddress, msg.sender, _tokenId); 
        address payable ownerAddressPayable = _make_payable(ownerAddress); 
        ownerAddressPayable.transfer(starCost);
        if(msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }
    }
    function lookUptokenIdToStarInfo (uint _tokenId) public view returns (string memory) {
        return tokenIdToStarInfo[_tokenId].name;
    }
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        address tokenExchanger;
        address tokenReceiver;
        uint256 token1;
        uint256 token2;
        if (ownerOf(_tokenId1) == msg.sender) {
            tokenExchanger = ownerOf(_tokenId1);
            tokenReceiver = ownerOf(_tokenId2);
            token1 = _tokenId1;
            token2 = _tokenId2;
        }
        else if (ownerOf(_tokenId2) == msg.sender) {
            tokenExchanger = ownerOf(_tokenId2);
            tokenReceiver = ownerOf(_tokenId1);
            token1 = _tokenId2;
            token2 = _tokenId1;
        }
        else {
            revert("You can't exchange a star you don't own.");
        }
        _transferFrom(tokenExchanger, tokenReceiver, token1);
        _transferFrom(tokenReceiver, tokenExchanger, token2);
    }

    function transferStar(address _to1, uint256 _tokenId) public {
        //1. Check if the sender is the ownerOf(_tokenId)
        require(ownerOf(_tokenId) == msg.sender, "You can't transfer a star you don't own.");
        //2. Use the transferFrom(from, to, tokenId); function to transfer the Star
        _transferFrom(msg.sender, _to1, _tokenId);
    }

}
