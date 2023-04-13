// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct Campaign {
    address author;
    string title;
    string description;
    string videoUrl;
    string imageUrl;
    uint256 balance;
    bool active;
}

contract DonationCrypto {
    uint256 public nextId = 0;
    uint256 public fee = 100;

    mapping(uint256 => Campaign) public campaigns;

    function addCampaign(
        string calldata _title,
        string calldata _description,
        string calldata _videoUrl,
        string calldata _imageUrl
    ) public {
        Campaign memory newCampaign;
    
        newCampaign.title = _title;
        newCampaign.description = _description;
        newCampaign.videoUrl = _videoUrl;
        newCampaign.imageUrl = _imageUrl;
        newCampaign.active = true;
        newCampaign.author = msg.sender;

        nextId++;
        campaigns[nextId] = newCampaign;
    }

    function donate(uint256 _id) public payable {
        require(msg.value > 0, "You must send a donation value > 0");
        require(campaigns[_id].active == true, "Cannot donate to this campaign");

        campaigns[_id].balance += msg.value;
    }

    function withdraw(uint256 _id) public {
        Campaign memory campaign = campaigns[_id];
        require(campaign.author == msg.sender, "You do not have permission");
        require(campaign.active == true, "This campaign is closed");
        require(campaign.balance > fee, "This campaign does not have enough balance");

        address payable recipient = payable(campaign.author);
        recipient.call{value: campaign.balance - fee}("");

        campaigns[_id].active = false;
    }
}