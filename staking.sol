// SPDX-License-Identifier: UNLICENSED


pragma solidity ^0.6.12;

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}
library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
library Address {
   
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

   
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

   
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

   
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

   
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

  
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

   
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}
contract ReentrancyGuard {
    bool private _notEntered;

    constructor () internal {

        _notEntered = true;
    }

    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}
contract StakingTokenWrapper is ReentrancyGuard {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public stakingToken;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    constructor(address _stakingToken) internal {
        stakingToken = IERC20(_stakingToken);
    }

    function totalSupply()
        public
        view
        returns (uint256)
    {
        return _totalSupply;
    }

    function balanceOf(address _account)
        public
        view
        returns (uint256)
    {
        return _balances[_account];
    }

    function _stake(address _beneficiary, uint256 _amount)
        internal
        nonReentrant
    {
        _totalSupply = _totalSupply.add(_amount);
        _balances[_beneficiary] = _balances[_beneficiary].add(_amount);
        stakingToken.transferFrom(msg.sender, address(this), _amount);
    }

    function _withdraw(uint256 _amount)
        internal
        nonReentrant
    {
        _totalSupply = _totalSupply.sub(_amount);
        _balances[msg.sender] = _balances[msg.sender].sub(_amount);
        stakingToken.safeTransfer(msg.sender, _amount);
    }
}
interface IRewardsDistributionRecipient {
    // function notifyRewardAmount(uint256 reward) external;
    function getRewardToken() external view returns (IERC20);
}
abstract contract RewardsDistributionRecipient is IRewardsDistributionRecipient {

    // @abstract
    // function notifyRewardAmount(uint256 reward) external;
    function getRewardToken() external virtual override view returns (IERC20);

    // This address has the ability to distribute the rewards
    address public rewardsDistributor;

    /** @dev Recipient is a module, governed by mStable governance */
    constructor(address _rewardsDistributor) 
        internal
    {
        rewardsDistributor = _rewardsDistributor;
    }

    /**
     * @dev Only the rewards distributor can notify about rewards
     */
    modifier onlyRewardsDistributor() {
        require(msg.sender == rewardsDistributor, "Caller is not reward distributor");
        _;
    }
}
library StableMath {

    using SafeMath for uint256;

    uint256 private constant FULL_SCALE = 1e18;

    uint256 private constant RATIO_SCALE = 1e8;

    function getFullScale() internal pure returns (uint256) {
        return FULL_SCALE;
    }

    function getRatioScale() internal pure returns (uint256) {
        return RATIO_SCALE;
    }

    function scaleInteger(uint256 x)
        internal
        pure
        returns (uint256)
    {
        return x.mul(FULL_SCALE);
    }

    function mulTruncate(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return mulTruncateScale(x, y, FULL_SCALE);
    }

    function mulTruncateScale(uint256 x, uint256 y, uint256 scale)
        internal
        pure
        returns (uint256)
    {
        // e.g. assume scale = fullScale
        // z = 10e18 * 9e17 = 9e36
        uint256 z = x.mul(y);
        // return 9e38 / 1e18 = 9e18
        return z.div(scale);
    }

    function mulTruncateCeil(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e17 * 17268172638 = 138145381104e17
        uint256 scaled = x.mul(y);
        // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
        uint256 ceil = scaled.add(FULL_SCALE.sub(1));
        // e.g. 13814538111.399...e18 / 1e18 = 13814538111
        return ceil.div(FULL_SCALE);
    }

    function divPrecisely(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e18 * 1e18 = 8e36
        uint256 z = x.mul(FULL_SCALE);
        // e.g. 8e36 / 10e18 = 8e17
        return z.div(y);
    }

    function mulRatioTruncate(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256 c)
    {
        return mulTruncateScale(x, ratio, RATIO_SCALE);
    }

    function mulRatioTruncateCeil(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256)
    {
        // e.g. How much mAsset should I burn for this bAsset (x)?
        // 1e18 * 1e8 = 1e26
        uint256 scaled = x.mul(ratio);
        // 1e26 + 9.99e7 = 100..00.999e8
        uint256 ceil = scaled.add(RATIO_SCALE.sub(1));
        // return 100..00.999e8 / 1e8 = 1e18
        return ceil.div(RATIO_SCALE);
    }

    function divRatioPrecisely(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256 c)
    {
        // e.g. 1e14 * 1e8 = 1e22
        uint256 y = x.mul(RATIO_SCALE);
        // return 1e22 / 1e12 = 1e10
        return y.div(ratio);
    }

    function min(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return x > y ? y : x;
    }

    function max(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return x > y ? x : y;
    }

    function clamp(uint256 x, uint256 upperBound)
        internal
        pure
        returns (uint256)
    {
        return x > upperBound ? upperBound : x;
    }
}
contract Staking is StakingTokenWrapper, RewardsDistributionRecipient {

    using StableMath for uint256;
    using Address for address;

    IERC20 public rewardsToken;

    // uint256 public constant ONE_DAY = 86400; // in seconds
    uint256 internal constant ONE_DAY = 60; // 1 mins in seconds
    
    uint256 public minStakingAmount = 1 * 1e18;
    
    uint256 internal FlaxableRewardPercent  = 3 * 1e18;  // 3%
    uint256 internal threeMonthRewardPercent  = 6 * 1e18;  // 6%
    uint256 internal sixMonthRewardPercent    = 7 * 1e18;  // 7%
    uint256 internal nineMonthRewardPercent    = 8 * 1e18;  // 8%
    uint256 internal twelveMonthRewardPercent = 9 * 1e18;   // 9%
    uint256 internal twentyFourMonthRewardPercent = 12 * 1e18;   // 12%
    uint256 internal thirtySixMonthRewardPercent = 15 * 1e18;   // 15%
    uint256 internal FeePercent = 1 * 1e18; // 1%
    
    
    // percentage calculation
    string public FlaxableReward  = "3%";
    string public threeMonthReward  = "6%";
    string public sixMonthReward    =  "7%";
    string public nineMonthReward    = "8%";
    string public twelveMonthReward =  "9%";
    string public twentyFourMonthReward = "12%";
    string public thirtySixMonthReward = "15%";
    string public FeeDeduction =  "1%";


    uint256 internal rewardPercent = 1; // 1%
    
    // Timestamps of staking duration
    
    uint256 public constant FLEXABLE_MONTHS_DURATION   = 5 days;
    uint256 public constant THREE_MONTHS_DURATION   = 90 days;
    uint256 public constant SIX_MONTHS_DURATION     = 180 days;
    uint256 public constant NINE_MONTHS_DURATION     = 270 days;
    uint256 public constant TWELVE_MONTHS_DURATION  = 360 days;
    uint256 public constant TWENTYfOUR_MONTHS_DURATION  = 720 days;
    uint256 public constant THIRTYsIX_MONTHS_DURATION  = 1080 days;
    
    uint256 internal stakingDuration = 0;
    
    //owner 
    address owner ;
    
    // Amount the user has staked
    mapping(address => uint256) public userStakedTokens;
    // Reward the user will get after staking period ends
    mapping(address => uint256) public rewards;
    // Rewards paid to user
    mapping(address => uint256) public userRewardsPaid;
    // Stake starting timestamp
    mapping(address => uint256) public stakeStarted;
    // Stake ending timestamp
    mapping(address => uint256) public stakeEnded;
    
    
    

    event Staked(address indexed user, uint256 amount, uint256 reward);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    /***************************************
                    CONSTRUCTOR
    ****************************************/

    constructor (
        address _stakingToken,
        address _rewardsToken,
        address _rewardsDistributor
    )
        public
        StakingTokenWrapper(_stakingToken)
        RewardsDistributionRecipient(_rewardsDistributor)
       
    {
        rewardsToken = IERC20(_rewardsToken);
         owner = _rewardsDistributor;
    }
    
    /***************************************
                    MODIFIERS
    ****************************************/

    modifier isAccount(address _account) {
        require(!Address.isContract(_account), "Only external owned accounts allowed");
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    /***************************************
                    ACTIONS
    ****************************************/
    
    function stake3m(uint256 _amount)
        external
    {
        __stake(msg.sender, _amount, THREE_MONTHS_DURATION);
    }
    
    function stake6m(uint256 _amount)
        external
    {
        __stake(msg.sender, _amount, SIX_MONTHS_DURATION);
    }
    
    function stake9m(uint256 _amount)
        external
    {
        __stake(msg.sender, _amount, NINE_MONTHS_DURATION );
    }
    
    function stake12m(uint256 _amount)
        external
    {
        __stake(msg.sender, _amount, TWELVE_MONTHS_DURATION);
    }
    
    function stake24m(uint256 _amount)
        external
    {
        __stake(msg.sender, _amount, TWENTYfOUR_MONTHS_DURATION);
    }
    
    function stake36m(uint256 _amount)
        external
    {
        __stake(msg.sender, _amount, THIRTYsIX_MONTHS_DURATION);
    }
    
    
    function unstake() 
        external 
    {
        require(block.timestamp >= stakeEnded[msg.sender], "Reward cannot be claimed before time");
        
        withdraw(balanceOf(msg.sender));
        claimReward();
        
       
        stakeStarted[msg.sender] = 0;
        stakeEnded[msg.sender] = 0;
    }
    

    function __stake(address _beneficiary, uint256 _addAmount, uint256 _period)
        internal
        isAccount(_beneficiary)
    {
        require(
            _addAmount >= minStakingAmount, 
            "Invalid staking amount"
        );
        require(
            _period == FLEXABLE_MONTHS_DURATION ||
            _period == THREE_MONTHS_DURATION || 
            _period == SIX_MONTHS_DURATION  ||
            _period == NINE_MONTHS_DURATION ||
            _period == TWELVE_MONTHS_DURATION||
            _period == TWENTYfOUR_MONTHS_DURATION||
            _period == THIRTYsIX_MONTHS_DURATION,
            "Invalid staking period"
        );
        
        uint256 _amount1 = _addAmount * FeePercent;
        //      1e36     =    1e18    * 1e18 
        uint256 _feeAmount = _amount1 / 1e20;
        uint256 _amount = _addAmount.sub( _feeAmount);
        
        // Transfer fee to owner
        stakingToken.transferFrom(_beneficiary, owner, _feeAmount);
        
        
        super._stake(_beneficiary, _amount);
        stakeStarted[_beneficiary] = block.timestamp;
        
        userStakedTokens[_beneficiary] = userStakedTokens[_beneficiary].add(_amount);
        uint256 __userAmount = userStakedTokens[_beneficiary];
        
        // calculation is on the basis:
        // reward = (monthPercentageInWei * stakedAmountInWei) / 1e20
        // e.g: (2.5% * 1e18  *  100 * 1e18) / 1e20 = 2.5 * 1e18
        uint256 _rewardAmount;
       
       if (_period == FLEXABLE_MONTHS_DURATION) {
            _rewardAmount = (FlaxableRewardPercent * __userAmount) / 1e20;
            rewards[_beneficiary] = _rewardAmount;
            stakeEnded[_beneficiary] = (block.timestamp).add(FLEXABLE_MONTHS_DURATION);
        } 
        else if (_period == THREE_MONTHS_DURATION) {
            _rewardAmount = (threeMonthRewardPercent * __userAmount) / 1e20;
            rewards[_beneficiary] = _rewardAmount;
            stakeEnded[_beneficiary] = (block.timestamp).add(THREE_MONTHS_DURATION);
        }
       
        else if (_period == THREE_MONTHS_DURATION) {
            _rewardAmount = (threeMonthRewardPercent * __userAmount) / 1e20;
            rewards[_beneficiary] = _rewardAmount;
            stakeEnded[_beneficiary] = (block.timestamp).add(THREE_MONTHS_DURATION);
        } 
        else if (_period == SIX_MONTHS_DURATION) {
            _rewardAmount = (sixMonthRewardPercent * __userAmount) / 1e20;
            rewards[_beneficiary] = _rewardAmount;
            stakeEnded[_beneficiary] = (block.timestamp).add(SIX_MONTHS_DURATION);
        } 
        else if (_period == NINE_MONTHS_DURATION) {
            _rewardAmount = (nineMonthRewardPercent * __userAmount) / 1e20;
            rewards[_beneficiary] = _rewardAmount;
            stakeEnded[_beneficiary] = (block.timestamp).add(NINE_MONTHS_DURATION);    
        } 
        else if (_period == TWELVE_MONTHS_DURATION) {
            _rewardAmount = (twelveMonthRewardPercent * __userAmount) / 1e20;
            rewards[_beneficiary] = _rewardAmount;
            stakeEnded[_beneficiary] = (block.timestamp).add(TWELVE_MONTHS_DURATION);
            
        } 
        else if (_period == THIRTYsIX_MONTHS_DURATION) {
            _rewardAmount = (thirtySixMonthRewardPercent * __userAmount) / 1e20;
            rewards[_beneficiary] = _rewardAmount;
            stakeEnded[_beneficiary] = (block.timestamp).add(THIRTYsIX_MONTHS_DURATION);
            
        } 
        else {
            revert("Error: duration not allowed!");
        }

        emit Staked(_beneficiary, _amount, _rewardAmount);
    }

    function withdraw(uint256 _amount)
        internal
        isAccount(msg.sender)
    {
        require(_amount > 0, "Cannot withdraw 0");
        require(block.timestamp >= stakeEnded[msg.sender], "Reward cannot be claimed before staking ends");
        userStakedTokens[msg.sender] = userStakedTokens[msg.sender].sub(_amount);
        _withdraw(_amount);
        emit Withdrawn(msg.sender, _amount);
    }

    function claimReward()
        internal
        isAccount(msg.sender)
    {
        require(block.timestamp >= stakeEnded[msg.sender], "Reward cannot be claimed before staking ends");
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardsToken.transfer(msg.sender, reward);
            userRewardsPaid[msg.sender] = userRewardsPaid[msg.sender].add(reward);
            emit RewardPaid(msg.sender, reward);
        }
    }


    /***************************************
                    GETTERS
    ****************************************/
   


    function getRewardToken()
        external
        override
        view
        returns (IERC20)
    {
        return rewardsToken;
    }

    function earned(address _account)
        public
        view
        returns (uint256)
    {
        return rewards[_account];
    }

    function tokensStaked(address _account)
        public
        view
        returns (uint256)
    {
        return userStakedTokens[_account];
    }


    /***************************************
                    ADMIN
    ****************************************/

    function sendRewardTokens(uint256 _amount) 
        public 
        onlyRewardsDistributor 
    {
        require(rewardsToken.transferFrom(msg.sender, address(this), _amount), "Transfering not approved!");
    }
    
    function withdrawRewardTokens(address receiver, uint256 _amount) 
        public onlyRewardsDistributor
    {
        require(rewardsToken.transfer(receiver, _amount), "Not enough tokens on contract!");
    }
    
    function withdrawStakeTokens(address receiver, uint256 _amount) 
        public onlyRewardsDistributor
        
    {
        require(stakingToken.transfer(receiver, _amount), "Not enough tokens on contract!");
    }
}



