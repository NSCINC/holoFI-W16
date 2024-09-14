// Definição de classe para armazenar detalhes do plano de investimento
class InvestmentPlan {
    int initialInvestment
    int monthlyReturn
    int annualReturn
    int netAnnualReturn
    int slots

    // Construtor
    InvestmentPlan(int initialInvestment, int monthlyReturn, int annualReturn, int netAnnualReturn, int slots) {
        this.initialInvestment = initialInvestment
        this.monthlyReturn = monthlyReturn
        this.annualReturn = annualReturn
        this.netAnnualReturn = netAnnualReturn
        this.slots = slots
    }
}

// Mapeamento para armazenar dados em cache
map<string, InvestmentPlan> cache = new map<string, InvestmentPlan>()

// Função para adicionar um plano de investimento ao cache
function addInvestmentPlan(planName: string, initialInvestment: int, monthlyReturn: int, annualReturn: int, netAnnualReturn: int, slots: int) {
    print("Adding plan: " + planName)
    if (cache.containsKey(planName)) {
        throw new Exception("Plan already exists")
    }
    cache.put(planName, new InvestmentPlan(initialInvestment, monthlyReturn, annualReturn, netAnnualReturn, slots))
    print("Plan added: " + planName)
}

// Função para atualizar um plano de investimento no cache
function updateInvestmentPlan(planName: string, initialInvestment: int?, monthlyReturn: int?, annualReturn: int?, netAnnualReturn: int?, slots: int?) {
    print("Updating plan: " + planName)
    InvestmentPlan plan = cache.get(planName)
    if (plan == null) {
        throw new Exception("Plan does not exist")
    }
    if (initialInvestment != null) plan.initialInvestment = initialInvestment
    if (monthlyReturn != null) plan.monthlyReturn = monthlyReturn
    if (annualReturn != null) plan.annualReturn = annualReturn
    if (netAnnualReturn != null) plan.netAnnualReturn = netAnnualReturn
    if (slots != null) plan.slots = slots
    print("Plan updated: " + planName)
}

// Função para remover um plano de investimento do cache
function removeInvestmentPlan(planName: string) {
    print("Removing plan: " + planName)
    if (!cache.containsKey(planName)) {
        throw new Exception("Plan does not exist")
    }
    cache.remove(planName)
    print("Plan removed: " + planName)
}

// Função para consultar os detalhes de um plano de investimento no cache
function getInvestmentPlanDetails(planName: string) -> InvestmentPlan {
    print("Fetching details for plan: " + planName)
    InvestmentPlan plan = cache.get(planName)
    if (plan == null) {
        throw new Exception("Plan does not exist")
    }
    return plan
}

// Função para listar todos os planos de investimento
function listInvestmentPlans() {
    print("Listing all investment plans:")
    for (entry in cache.entries()) {
        string planName = entry.key
        InvestmentPlan plan = entry.value
        print("Plan Name: " + planName)
        print("  Initial Investment: " + plan.initialInvestment)
        print("  Monthly Return: " + plan.monthlyReturn)
        print("  Annual Return: " + plan.annualReturn)
        print("  Net Annual Return: " + plan.netAnnualReturn)
        print("  Slots: " + plan.slots)
        print("")
    }
}

// Exemplo de uso das funções definidas
function main() {
    // Etapa 1: Adicionar um plano de investimento
    print("\nStep 1: Adding an Investment Plan")
    addInvestmentPlan("economicPlan", 500, 5, 60, 300, 500)

    // Etapa 2: Consultar detalhes de um plano de investimento
    print("\nStep 2: Fetching Investment Plan Details")
    InvestmentPlan plan = getInvestmentPlanDetails("economicPlan")
    print("Initial Investment: " + plan.initialInvestment)
    print("Monthly Return: " + plan.monthlyReturn)
    print("Annual Return: " + plan.annualReturn)
    print("Net Annual Return: " + plan.netAnnualReturn)
    print("Slots: " + plan.slots)

    // Etapa 3: Atualizar um plano de investimento
    print("\nStep 3: Updating an Investment Plan")
    updateInvestmentPlan("economicPlan", null, 10, null, 400, null)

    // Etapa 4: Consultar detalhes do plano de investimento após atualização
    print("\nStep 4: Fetching Updated Investment Plan Details")
    plan = getInvestmentPlanDetails("economicPlan")
    print("Initial Investment: " + plan.initialInvestment)
    print("Monthly Return: " + plan.monthlyReturn)
    print("Annual Return: " + plan.annualReturn)
    print("Net Annual Return: " + plan.netAnnualReturn)
    print("Slots: " + plan.slots)

    // Etapa 5: Listar todos os planos de investimento
    print("\nStep 5: Listing All Investment Plans")
    listInvestmentPlans()

    // Etapa 6: Remover um plano de investimento
    print("\nStep 6: Removing an Investment Plan")
    removeInvestmentPlan("economicPlan")

    // Etapa 7: Listar todos os planos de investimento após remoção
    print("\nStep 7: Listing All Investment Plans After Removal")
    listInvestmentPlans()

    // Fim dos exemplos
    print("\nRunby code execution completed.")
}

main()
