pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract NFT_Token {
    struct Token{
        string name;
        string specification;
        int strength;
        int agility;
        int intelligence;
    }

    Token[] tokensArr;
    
    mapping (uint => uint) tokenToOwner;
    mapping (uint => uint) tokenToPrice;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
        tvm.accept();
		_;
	}

    function createToken(string name, string specification, int strength, int agility, int intelligence) public checkOwnerAndAccept {
        for (uint256 i = 0; i < tokensArr.length; i++) {
            require(tokensArr[i].name == name, 101);
        }
        tokensArr.push(Token(name, specification, strength, agility, intelligence)); 
        uint keyAsLastNum = tokensArr.length - 1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();
    }

    function saleToken(uint256 id, uint256 price) public checkOwnerAndAccept {
        require(msg.pubkey() == tokenToOwner[id], 101);
        tokenToPrice[id] = price; 
    }
}