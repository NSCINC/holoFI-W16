-- SPDX-License-Identifier: MIT
-- Copyright 2024 NSC INCS, Lucas Januário

-- InvestmentContract
InvestmentContract = {}
InvestmentContract.__index = InvestmentContract

-- Cria uma nova instância do contrato de investimento
-- @param owner O endereço do proprietário do contrato
-- @return Uma nova instância do InvestmentContract
function InvestmentContract.new(owner)
    local self = setmetatable({}, InvestmentContract)
    self.owner = owner
    self.balances = {}
    self.investedAmount = {}
    self.authorizedInvestors = {}
    return self
end

-- Permite que um investidor faça um investimento
-- @param amount O valor a ser investido
function InvestmentContract:invest(amount)
    assert(self.authorizedInvestors[msg.sender], "Investor is not authorized")
    assert(amount > 0, "Investment amount must be greater than zero")
    assert(amount <= (self.balances[msg.sender] or 0), "Insufficient balance")

    self.balances[msg.sender] = (self.balances[msg.sender] or 0) - amount
    self.investedAmount[msg.sender] = (self.investedAmount[msg.sender] or 0) + amount

    self:emit("Investment", msg.sender, amount)
end

-- Autoriza ou desautoriza um investidor
-- @param investor O endereço do investidor
-- @param authorized Se o investidor deve ser autorizado ou não
function InvestmentContract:authorizeInvestor(investor, authorized)
    assert(msg.sender == self.owner, "Only owner can perform this action")
    self.authorizedInvestors[investor] = authorized
    self:emit("AuthorizationChanged", investor, authorized)
end

-- Obtém o saldo de um investidor
-- @param investor O endereço do investidor
-- @return O saldo do investidor
function InvestmentContract:balanceOf(investor)
    return self.balances[investor] or 0
end

-- Obtém o valor investido por um investidor
-- @param investor O endereço do investidor
-- @return O valor investido pelo investidor
function InvestmentContract:investedAmountOf(investor)
    return self.investedAmount[investor] or 0
end

-- Simula a emissão de eventos
-- @param event O nome do evento
-- @param ... Argumentos adicionais para o evento
function InvestmentContract:emit(event, ...)
    local args = {...}
    print(string.format("Event %s emitted with args: %s", event, table.concat(args, ", ")))
end

-- AuthenticationContract
AuthenticationContract = {}
AuthenticationContract.__index = AuthenticationContract

-- Cria uma nova instância do contrato de autenticação
-- @param owner O endereço do proprietário do contrato
-- @return Uma nova instância do AuthenticationContract
function AuthenticationContract.new(owner)
    local self = setmetatable({}, AuthenticationContract)
    self.owner = owner
    self.messageAuthenticity = {}
    return self
end

-- Autentica uma mensagem
-- @param messageHash O hash da mensagem a ser autenticada
function AuthenticationContract:authenticateMessage(messageHash)
    if not self.messageAuthenticity[msg.sender] then
        self.messageAuthenticity[msg.sender] = {}
    end
    assert(not self.messageAuthenticity[msg.sender][messageHash], "Message already authenticated")
    self.messageAuthenticity[msg.sender][messageHash] = true
    self:emit("MessageAuthenticated", msg.sender, messageHash, true)
end

-- Verifica se uma mensagem foi autenticada
-- @param investor O endereço do investidor
-- @param messageHash O hash da mensagem a ser verificado
-- @return Verdadeiro se a mensagem foi autenticada, falso caso contrário
function AuthenticationContract:isMessageAuthenticated(investor, messageHash)
    return self.messageAuthenticity[investor] and self.messageAuthenticity[investor][messageHash] or false
end

-- Simula a emissão de eventos
-- @param event O nome do evento
-- @param ... Argumentos adicionais para o evento
function AuthenticationContract:emit(event, ...)
    local args = {...}
    print(string.format("Event %s emitted with args: %s", event, table.concat(args, ", ")))
end

-- Exemplo de uso das funções definidas

-- Criar instâncias dos contratos
local owner = "owner_address"
local investor1 = "investor1_address"
local investor2 = "investor2_address"

local investment_contract = InvestmentContract.new(owner)
local authentication_contract = AuthenticationContract.new(owner)

-- Adicionar saldo ao investidor
investment_contract.balances[investor1] = 1000
investment_contract.balances[investor2] = 1000

-- Autorizar investidores
investment_contract:authorizeInvestor(investor1, true)
investment_contract:authorizeInvestor(investor2, true)

-- Investir e autenticar mensagens
print("\nStep 1: Investment and Authentication")
investment_contract:invest(500)
authentication_contract:authenticateMessage("message_hash_1")

-- Consultar detalhes
print("\nStep 2: Fetching Details")
print("Investor1 Balance:", investment_contract:balanceOf(investor1))
print("Investor1 Invested Amount:", investment_contract:investedAmountOf(investor1))
print("Message Authenticated:", authentication_contract:isMessageAuthenticated(investor1, "message_hash_1"))

-- Fim dos exemplos
print("\nLua code execution completed.")
