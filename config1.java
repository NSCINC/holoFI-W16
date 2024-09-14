import java.io.Serializable;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.IOException;
import java.net.Socket;

// Classe ConfigurationInfo que implementa Serializable para transmissão pela rede
public class ConfigurationInfo implements Serializable {
    private static final long serialVersionUID = 1L;

    // Função para mostrar informações de configuração
    public static String show() {
        // Simulação de informações de configuração (exemplo simples)
        String version = "1.0";
        String platform = "Java";
        String author = "Java Dev Team";

        // Retornar uma string formatada com informações de configuração
        return String.format("Configuração Java:\nVersão: %s\nPlataforma: %s\nAutor: %s",
                             version, platform, author);
    }

    // Função para retornar informações de flags de compilação (simulação)
    public static String cxxFlags() {
        // Simulação de flags de compilação (exemplo simples)
        String flags = "-O2 -std=c++11";

        return "Flags de Compilação: " + flags;
    }

    // Função para retornar informações de paralelização (simulação)
    public static String parallelInfo() {
        // Simulação de informações de paralelização (exemplo simples)
        int threads = 4;
        String method = "OpenMP";

        return String.format("Informações de Paralelização:\nThreads: %d\nMétodo: %s",
                             threads, method);
    }

    // Método para enviar informações de configuração pela rede
    public static void sendConfig(String host, int port) throws IOException {
        try (Socket socket = new Socket(host, port);
             ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream())) {
            out.writeObject(new ConfigurationInfo());
            System.out.println("Configuração enviada para " + host + ":" + port);
        }
    }

    // Método para receber informações de configuração pela rede
    public static ConfigurationInfo receiveConfig(int port) throws IOException, ClassNotFoundException {
        try (Socket socket = new Socket("localhost", port);
             ObjectInputStream in = new ObjectInputStream(socket.getInputStream())) {
            return (ConfigurationInfo) in.readObject();
        }
    }

    // Método principal para testar as funções
    public static void main(String[] args) {
        try {
            // Mostrar informações locais
            System.out.println(show());
            System.out.println(cxxFlags());
            System.out.println(parallelInfo());

            // Enviar informações para um servidor fictício
            sendConfig("localhost", 12345);

            // Receber informações de um servidor fictício
            ConfigurationInfo receivedConfig = receiveConfig(12345);
            System.out.println("Configuração recebida: " + receivedConfig);

        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
