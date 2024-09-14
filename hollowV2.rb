require 'ethereum'

# Estrutura para representar um plano de investimento
class InvestmentPlan
  attr_accessor :initial_investment, :monthly_return, :annual_return, :net_annual_return, :slots

  def initialize(initial_investment, monthly_return, annual_return, net_annual_return, slots)
    @initial_investment = initial_investment
    @monthly_return = monthly_return
    @annual_return = annual_return
    @net_annual_return = net_annual_return
    @slots = slots
  end
end

# Contrato InvestmentContract
class InvestmentContract
  def initialize(web3, contract_address, owner)
    @web3 = web3
    @contract_address = contract_address
    @owner = owner
    @balances = {}
    @invested_amount = {}
    @authorized_investors = {}
  end

  def invest(amount)
    raise 'Investor is not authorized' unless @authorized_investors[web3.eth.coinbase]
    raise 'Investment amount must be greater than zero' unless amount > 0
    raise 'Insufficient balance' unless amount <= @balances[web3.eth.coinbase]

    @balances[web3.eth.coinbase] -= amount
    @invested_amount[web3.eth.coinbase] ||= 0
    @invested_amount[web3.eth.coinbase] += amount

    emit_investment(web3.eth.coinbase, amount)
  end

  def authorize_investor(investor, authorized)
    raise 'Only owner can perform this action' unless web3.eth.coinbase == @owner
    @authorized_investors[investor] = authorized
    emit_authorization_changed(investor, authorized)
  end

  def balance_of(investor)
    @balances[investor] || 0
  end

  def invested_amount_of(investor)
    @invested_amount[investor] || 0
  end

  private

  def emit_investment(investor, amount)
    puts "Investment event: Investor #{investor} invested #{amount}"
  end

  def emit_authorization_changed(investor, authorized)
    puts "Authorization changed: Investor #{investor} is #{authorized ? 'authorized' : 'not authorized'}"
  end
end

# Contrato AuthenticationContract
class AuthenticationContract
  def initialize(web3, contract_address, owner)
    @web3 = web3
    @contract_address = contract_address
    @owner = owner
    @message_authenticity = {}
  end

  def authenticate_message(message_hash)
    raise 'Only owner can perform this action' unless @web3.eth.coinbase == @owner
    raise 'Message already authenticated' if @message_authenticity[@web3.eth.coinbase] && @message_authenticity[@web3.eth.coinbase][message_hash]

    @message_authenticity[@web3.eth.coinbase] ||= {}
    @message_authenticity[@web3.eth.coinbase][message_hash] = true
    emit_message_authenticated(@web3.eth.coinbase, message_hash, true)
  end

  def is_message_authenticated(investor, message_hash)
    @message_authenticity[investor] && @message_authenticity[investor][message_hash] || false
  end

  private

  def emit_message_authenticated(investor, message_hash, authenticated)
    puts "Message authentication event: Investor #{investor} - Message Hash #{message_hash} - Authenticated: #{authenticated}"
  end
end

# Contrato InvestmentPlanManager
class InvestmentPlanManager
  def initialize(investment_contract, authentication_contract)
    @investment_contract = investment_contract
    @authentication_contract = authentication_contract
    @investment_plans = {}
  end

  def add_plan(plan_name, initial_investment, monthly_return, annual_return, net_annual_return, slots)
    raise 'Only InvestmentContract can add plans' unless @investment_contract

    @investment_plans[plan_name] = InvestmentPlan.new(initial_investment, monthly_return, annual_return, net_annual_return, slots)
    emit_plan_added(plan_name, initial_investment, monthly_return, annual_return, net_annual_return, slots)
  end

  def invest(plan_name, amount)
    raise 'Investment amount must be greater than zero' unless amount > 0
    # Logic for investing, to be implemented
  end

  def get_investment_contract_balance(investor)
    @investment_contract.balance_of(investor)
  end

  def authenticate_message(message_hash)
    @authentication_contract.authenticate_message(message_hash)
  end

  def is_message_authenticated(investor, message_hash)
    @authentication_contract.is_message_authenticated(investor, message_hash)
  end

  private

  def emit_plan_added(plan_name, initial_investment, monthly_return, annual_return, net_annual_return, slots)
    puts "Plan added event: #{plan_name} with Initial Investment: #{initial_investment}, Monthly Return: #{monthly_return}, Annual Return: #{annual_return}, Net Annual Return: #{net_annual_return}, Slots: #{slots}"
  end
end

# Exemplo de uso
web3 = Ethereum::HttpClient.new('http://localhost:8545')
owner = web3.eth.coinbase
investment_contract = InvestmentContract.new(web3, '0xInvestmentContractAddress', owner)
authentication_contract = AuthenticationContract.new(web3, '0xAuthenticationContractAddress', owner)
manager = InvestmentPlanManager.new(investment_contract, authentication_contract)

# Adiciona um plano de investimento
manager.add_plan('PlanA', 1000, 100, 1200, 1300, 10)

# Autentica uma mensagem
manager.authenticate_message('0xMessageHash')

# Verifica se a mensagem está autenticada
puts manager.is_message_authenticated(owner, '0xMessageHash')

# Investir em um plano
# manager.invest('PlanA', 500)

# Verifica o saldo de um investidor
puts investment_contract.balance_of(owner)
