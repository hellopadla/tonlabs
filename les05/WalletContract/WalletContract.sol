pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract WalletContract {
    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    function sendTransaction(address dest, uint128 value, bool bounce) 
    public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 0);
    }
    
    function sendWithoutFee(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 0);
    }

    function sendWithFee(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 1);
    }

    function sendAllMoneyDestroyWallet(address dest) public pure checkOwnerAndAccept {
        dest.transfer(123, true, 128 + 32);
    }
}