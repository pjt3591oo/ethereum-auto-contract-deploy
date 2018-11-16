interface token {
    function transfer(address receiver, uint amount);
    function balanceOf(address addr) returns (uint);
}

contract Crowdsale {
    address public beneficiary;
    address public tokenAddress;
    address public owner;

    token public tokenReward;

    uint public fundingGoal;
    uint public price ;
    uint public decimals = 0; // token decimals
    
    function Crowdsale(
        address ifSuccessfulSendTo,           // 이더 환급할 때 이더 돌려받을 계정
        uint fundingGoalInEthers,             // 목표 이더량
        uint etherCostOfEachToken,            // 1이더당 몇개의 토큰을 줄지
        address addressOfTokenUsedAsReward    // 토큰 컨트랙트 주소
    ) {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = fundingGoalInEthers * 1 * 10 ** uint256(decimals);
        price = (1 ether / etherCostOfEachToken)  ;
        tokenReward = token(addressOfTokenUsedAsReward);
        tokenAddress = addressOfTokenUsedAsReward;
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    function () payable {
        tokenReward.transfer(msg.sender, msg.value / price * 10 ** uint256(decimals));
    }
    
    function returnEther() onlyOwner{
        beneficiary.send(address(this).balance);
    }
}