// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EducationInvestmentFund {
    address public owner;
    uint256 public totalFunds;
    mapping(address => uint256) public contributions;
    mapping(address => bool) public approvedBeneficiaries;

    event FundContributed(address indexed contributor, uint256 amount);
    event FundWithdrawn(address indexed beneficiary, uint256 amount);
    event BeneficiaryApproved(address indexed beneficiary);
    event BeneficiaryRemoved(address indexed beneficiary);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier onlyApprovedBeneficiary() {
        require(approvedBeneficiaries[msg.sender], "Not an approved beneficiary");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
        emit FundContributed(msg.sender, msg.value);
    }

    function approveBeneficiary(address _beneficiary) external onlyOwner {
        approvedBeneficiaries[_beneficiary] = true;
        emit BeneficiaryApproved(_beneficiary);
    }

    function removeBeneficiary(address _beneficiary) external onlyOwner {
        approvedBeneficiaries[_beneficiary] = false;
        emit BeneficiaryRemoved(_beneficiary);
    }

    function withdrawFunds(uint256 _amount) external onlyApprovedBeneficiary {
        require(_amount <= totalFunds, "Insufficient funds");
        payable(msg.sender).transfer(_amount);
        totalFunds -= _amount;
        emit FundWithdrawn(msg.sender, _amount);
    }

    function getContribution(address _contributor) external view returns (uint256) {
        return contributions[_contributor];
    }

    function getTotalFunds() external view returns (uint256) {
        return totalFunds;
    }
}
