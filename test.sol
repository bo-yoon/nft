// Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.5.6;
//pragma solidity ^0.4.20;


interface ERC721 /* is ERC165 */ {

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    
    
    function balanceOf(address _owner) public  view returns (uint256); // 어떤 계정에 몇개의 토큰 이 있는지
    function ownerOf(uint256 _tokenId) public view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
    function transferFrom(address _from, address _to, uint256 _tokenId) public ;
    function approve(address _approved, uint256 _tokenId) public;
    function setApprovalForAll(address _operator, bool _approved) public; // 모든 토큰 권한 줌
    function getApproved(uint256 _tokenId) public view returns (address);
    function isApprovedForAll(address _owner, address _operator) public view returns (bool);
}


/// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
}


contract  ERC721Implementation is  ERC721 {
    
    // 발행한다. 누가 소유하게 될 것인지
    mapping (uint256 => address) tokenOwner;
    mapping (address => uint256) ownedTokensCount;
    mapping (uint256 => address) tokenApprovals; // 계정 주소
    mapping (address => mapping (address => bool)) operatorApprovals; // 여러명에게 권한 부여 가능
    
    function mint(address _to, uint _tokenId) public {
        tokenOwner[_tokenId]  = _to;  
        ownedTokensCount[_to] += 1;
    }
    
    function balanceOf(address _owner) public view returns (uint256) {
        return ownedTokensCount[_owner];
        // 오너가 가진 코큰의 개수 리턴
    }
    
    function ownerOf(uint256 _tokenId) public view returns (address) {
        return tokenOwner[_tokenId];
    }
    
    
    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        // 토큰을 한 계정에서 다른 계정으로
        address owner = ownerOf(_tokenId);
        require(msg.sender == owner || getApproved(_tokenId) == msg.sender || isApprovedForAll(owner, msg.sender)); // 함수를 호출한계정이 오너랑 같은지
        require(_from != address(0));
        require(_to != address(0));
        
        ownedTokensCount[_from] -= 1;
        tokenOwner[_tokenId] = address(0);
        
        ownedTokensCount[_to] += 1;
        tokenOwner[_tokenId] = _to;
    }
     
     
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
        transferFrom(_from, _to, _tokenId);
           
        if (isContract(_to)) {
           bytes4 returnValue = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, '');
           require(returnValue == 0x150b7a02);
        }
           
    }
    
        function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public {
        transferFrom(_from, _to, _tokenId);
           
        if (isContract(_to)) {
           bytes4 returnValue = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, data);
           require(returnValue == 0x150b7a02);
        }
           
    }
    function approve(address _approved, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_approved != owner);
        require(msg.sender == owner);
        tokenApprovals[_tokenId] = _approved;
        
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        
        return tokenApprovals[_tokenId];
        
        
    }   
    function isContract(address _addr) private view returns (bool) {
           uint256 size;
           assembly { size:= extcodesize(_addr) }
           return size > 0;
    }
    
    function setApprovalForAll(address _operator, bool _approved) public {
        require(_operator != msg.sender); 
        operatorApprovals[msg.sender][_operator] = _approved;
    }
        
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return operatorApprovals[_owner][_operator];
    }
    
}
 
contract Auction is ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns(bytes4) { 
         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}

