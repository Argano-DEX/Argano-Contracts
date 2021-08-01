# Argano-Contracts
Argano’s core smart contracts

### 0001	no	awaiting onchain deployment
### 0002	yes	executeTransaction function was removed
### 0003	yes	dev fund allocation was completely removed from contracts
### 0004	yes	dev fund allocation was completely removed from contracts
### 0005	no	awaiting onchain deployment
### 0006	yes	oracle updates is implemented
### 0007	no	tx.origin check is desired. Possible manipulations is allowed.* || UPDATED now checks msg.send and ( msg.sender == tx.origin )
### 0008	yes	ability to swap "using ECR orTCR" is removed
### 0009	yes	add check that block removing active rebalance pool
### 0010	yes	modifier notMigrated added
### 0011	yes	ERC20Custom changed to openzeppelin implementation
### 0012	no	awaiting onchain deployment
### 0013	yes	dev fund allocation was completely removed from contracts
### 0014	yes	swap function reworked
### 0015	yes	local copies was removed
### 0016	yes	local copies was removed
### 0017	no	local copies desired
### 0018	yes	<add events> 
### 0019	added some events and zero addresses cheks
### 0020	yes	Multiple Deployable Contract was separated into different files
### 0021	no	awaiting onchain deployment/ we awaiting token sale requirenments
### 0022	yes	ABIv2Encoder removed. Safe math removed
### 0023	yes	dev fund allocation was completely removed from contracts
### 0024	yes	optimised according to recomendation
### 0025	no	current implementation is ok for us. Will be changed in next version of protocol
### 0026	yes	dev fund allocation was completely removed from contracts
### 0027	yes	10 min twap is desired
### 0028	yes	local copies was removed
### 0029	yes	uq112x112 removed
### 0030	yes	18 decimals cap for collaterall tokens is desired
### 0031	yes	receive() added
### 0032	no	current implementation is ok for us. Will be changed in next version of protocol
### 0033	yes	unused interfaces removed (full, according to audit)
### 0034	yes	initialized logic moved to constructors and named functions
### 0035	no	added in important places (partial)**
### 0036	yes	Incorrect safemath conversion is fixed
### 0037	yes	setted added
### 0038	yes	unchecked blocks integrated into code
### 0039  yes Now Effective Collateral Ratio starts with pause and could be onllt turning on
### 0040  yes now Buyback and Recollateralize Restricted by Strategist (without timelock)


tx.origin check is desired. Possible manipulations is allowed.* - This mean that tx.origin authorisation is best use-case for our vision of discount requirement. We want give discount only for transaction initiators that hold our governance token, not for contracts. If we will use msg.sender insted this is could open opportunities for scammers to create contracts with out token in balance to give users discount and manage their funds. We noticed about patterns when attacker could use tx.origin to call transaction as another user (fallback attack), but this scenario is not dangerous for our protocol economic or users funds. This manipulation could be totally ignored. But, in next versions of protocol we will change this logic to acheive best-case patterns and avoid to use tx.origin totally.

UPDATED now checks msg.send and ( msg.sender == tx.origin )

** - || UPDATED added some events and zero addresses cheks
