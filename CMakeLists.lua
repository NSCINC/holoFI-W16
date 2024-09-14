-- Define a tabela ClassNamespace
ClassNamespace = {}
ClassNamespace.__index = ClassNamespace

function ClassNamespace.new(name)
    local self = setmetatable({}, ClassNamespace)
    self.name = name
    self.proxies = {}
    return self
end

-- Define a tabela ClassNamespaceManager
ClassNamespaceManager = {}
ClassNamespaceManager.__index = ClassNamespaceManager

function ClassNamespaceManager.new()
    local self = setmetatable({}, ClassNamespaceManager)
    self.namespaces = {}
    return self
end

-- Emite um evento ao carregar uma nova biblioteca
function ClassNamespaceManager:library_loaded(path)
    print("LibraryLoaded event emitted: " .. path)
end

-- Obtém um proxy (endereço) de uma classe em um namespace
function ClassNamespaceManager:get_class_proxy(namespace, class_name)
    local ns = self.namespaces[namespace]
    if ns then
        return ns.proxies[class_name]
    end
    return nil
end

-- Carrega uma biblioteca compartilhada
function ClassNamespaceManager:load_library(path)
    -- Lógica de carregamento da biblioteca compartilhada
    -- Aqui apenas emite um evento
    self:library_loaded(path)
    -- Em um cenário real, você pode usar ffi para carregar uma biblioteca nativa
end

-- Cria um novo namespace de classes
function ClassNamespaceManager:create_class_namespace(namespace_name)
    self.namespaces[namespace_name] = ClassNamespace.new(namespace_name)
end

-- Exemplo de uso das funções
function main()
    local manager = ClassNamespaceManager.new()

    -- Criar um namespace
    manager:create_class_namespace("NamespaceA")
    print("Namespace 'NamespaceA' criado")

    -- Adicionar um proxy para uma classe no NamespaceA
    local ns = manager.namespaces["NamespaceA"]
    if ns then
        ns.proxies["ClassNameA"] = "0xAddress"
    end

    -- Obter o proxy para a classe ClassNameA no NamespaceA
    local proxy = manager:get_class_proxy("NamespaceA", "ClassNameA")
    print("Proxy para 'ClassNameA' no 'NamespaceA': " .. (proxy or "nil"))

    -- Carregar uma biblioteca compartilhada
    manager:load_library("path/to/library.so")
end

-- Executa o exemplo
main()
