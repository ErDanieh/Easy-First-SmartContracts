//// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * Interface for the FakeNFTMarketplace
 */
interface IFakeNFTMarketplace {
    function getPrice() external view returns (uint256);

    function available(uint256 _tokenId) external view returns (bool);

    function purchase(uint256 _tokenId) external payable;
}

/**
 * Minimal interface for CryptoDevsNFT containing only two functions
 * that we are interested in
 */
interface ICryptoDevsNFT {
    function balanceOf(address owner) external view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256);
}

contract CryptoDevsDAO is Ownable {
    // We will write contract code here
    //Creamos una estructura que se llame proposal con toda la informacion relevante
    struct Proposal {
        //Id del token que comprariamos si la propuesta se confirma
        uint256 nftTokenId;
        //deadline para que se cumpla la propuesta
        uint256 deadline;
        //Cantidad de votos a favor que lleva la propuesta
        uint256 yayVotes;
        //Cantidad de votos en contra que lleva la propuesta
        uint256 nayVotes;
        //Comprueba si la propuesta se ha ejecutado
        bool executed;
        //mapping de las carteras de todos los votantes
        mapping(uint256 => bool) voters;
    }

    //Creamos un mapping para todas las propuestas
    mapping(uint256 => Proposal) public proposals;
    //Cantidad de propuestas que llevamos
    uint256 public numProposals;

    //Sacamos las instancias de los anteriores contratos
    IFakeNFTMarketplace nftMarketplace;
    ICryptoDevsNFT cryptoDevsNFT;

    //Creamos el constructor  para inicializar las variables de los contratos
    constructor(address _nftMarketplace, address _cryptoDevsNFT) payable {
        nftMarketplace = IFakeNFTMarketplace(_nftMarketplace);
        cryptoDevsNFT = ICryptoDevsNFT(_cryptoDevsNFT);
    }

    //Hacemos una funcion para comprobar si el llamador del contrato es owner de algun nft
    modifier nftHolderOnly() {
        require(cryptoDevsNFT.balanceOf(msg.sender) > 0, "NO eres miembro");
        _;
    }

    //Funcion para crear propuestas, le pasamos el id del token a comprar, ademas hay que
    //llamar al modificador
    function createProposal(uint256 _nftTokenId)
        external
        nftHolderOnly
        returns (uint256)
    {
        require(
            nftMarketplace.available(_nftTokenId),
            "Ese token no esta a la venta"
        );

        Proposal storage proposal = proposals[numProposals];

        //El momento actual + 5 minutos
        proposal.deadline = block.timestamp + 5 minutes;

        numProposals++;

        return numProposals - 1;
    }

    //Modificador para ver si una propuesta sigue activa
    modifier activeProposalOnly(uint256 proposalIndex){
        require(proposals[proposalIndex].deadline > block.timestamp, "DEADLINE_EXCEEDED");
        _;
    }

    enum Vote {
        YAY,
        NAY 
    }


    //Le pasamos el indice de la votacion y el tipo de voto
    function voteOnProposal(uint256 proposalIndex, Vote vote) external nftHolderOnly activeProposalOnly(proposalIndex){
        Proposal storage proposal = proposals[proposalIndex];

        //Miramos cuantos nft tiene el votante
        uint256 voterNFTBalance = cryptoDevsNFT.balanceOf(msg.sender);
        uint256 numVotes = 0;

        //sumamos 1 voto por cada nft que tiene el usuario
        for(uint256 i = 0; i < voterNFTBalance; i++){
            uint256 tokenId = cryptoDevsNFT.tokenOfOwnerByIndex(msg.sender,i);
            if(proposal.voters[tokenId] == false){
                numVotes++;
                proposal.voters[tokenId] = true;
            }
        }
        //Miramos que hayamos votado almenos 1 vez
        require(numVotes > 0, "Already_Voted");
        //Sumamos la cantidad de 
        if(vote == Vote.YAY){
            proposal.yayVotes += numVotes;
        }else{
            proposal.nayVotes += numVotes;
        }
    }

    //Modificador para ver si se puede desactivar la propuesta
    modifier inactiveProposalOnly(uint256 proposalIndex){
        require(proposals[proposalIndex].deadline <= block.timestamp, "DEADLINE not Exceed");
        require(proposals[proposalIndex].executed == false, "La propuesta ya ha sido aceptada");
        _;
    }

    function executeProposal(uint256 proposalIndex) external nftHolderOnly inactiveProposalOnly(proposalIndex){
        Proposal storage proposal = proposals[proposalIndex];

        if(proposal.yayVotes > proposal.nayVotes){
            uint256 nftPrice = nftMarketplace.getPrice();
            require(address(this).balance >= nftPrice, "No tienes suficientes fondos");
            nftMarketplace.purchase{value: nftPrice}(proposal.nftTokenId);
        }
        proposal.executed = true;
        
    }
    /// @dev withdrawEther allows the contract owner (deployer) to withdraw the ETH from the contract
    function withdrawEther() external onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw; contract balance empty");
        payable(owner()).transfer(amount);
    }
    // The following two functions allow the contract to accept ETH deposits
    // directly from a wallet without calling a function
    receive() external payable {}

    fallback() external payable {}
}
