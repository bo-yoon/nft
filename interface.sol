// Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.5.6;
//pragma solidity ^0.4.20;


interface ERC721 /* is ERC165 */ {

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    function balanceOf(address _owner) public  view returns (uint256);
    function ownerOf(uint256 _tokenId) public view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public ;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public ;
    function transferFrom(address _from, address _to, uint256 _tokenId) public ;
    function approve(address _approved, uint256 _tokenId) public ;
    function setApprovalForAll(address _operator, bool _approved) public;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) public view returns (bool);
}


