pragma solidity ^0.8.0;

// Define metodos e eventos da ERC-20 que devem ser implementados no Contract DIOToken
interface IERC20{

    //getters: retornam valores
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    //functions: logica do token DIOToken dentro do padrao ERC-20
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    //events: notificacoes de transferencia e aprovacao respectivamente
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256);

}
// Define a logica do DIOToken e a implementacao da interface IERC20
contract DIOToken is IERC20{

    // Nome do token
    string public constant name = "DIO Token";

    // Simbolo do token
    string public constant symbol = "DIO";

    // Numero de casas decimais. Padrao do ERC-20: 18 casas decimais
    uint8 public constant decimals = 18;

    // Mapeamento que armazena saldo de cada endereco
    mapping (address => uint256) balances;

    // Mapeamento para controle de permissoes de gastos entre enderecos
    mapping(address => mapping(address=>uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

    constructor(){
        balances[msg.sender] = totalSupply_;
    }

    // Retorna a oferta total de tokens
    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    // Retorna o saldo de um endereco
    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }

    // Permite que um endereco transfira tokens para outra conta
    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    // Permite que um endereco aprove outro a gastar uma certa quantia de tokens
    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    // Retorna quantidade de tokens que uma conta autorizada possa gastar em nome do proprietario 
    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    // Permite transferencias de tokens entre os endereços dentro do limite de aprovacao
    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

}
