package com.sverze.examples.spring.twotier;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import static java.lang.String.format;

@SpringBootApplication
public class Application {
    private static final Logger LOGGER = LogManager.getLogger(Application.class);

    public static void main(String[] args) {
        LOGGER.info("Application starting");
        SpringApplication.run(Application.class, args);
        LOGGER.info("Application started");
    }
}

//public class Application {
//
//    private static final Logger LOGGER = LogManager.getLogger(Application.class);
//    private static final String BASE_URI;
//    private static final String protocol;
//    private static final Optional<String> host;
//    private static final Optional<String> port;
//    private static HttpServer httpServer;
//
//    static {
//        protocol = "http://";
//        host = Optional.ofNullable(System.getenv("HOSTNAME"));
//        port = Optional.ofNullable(System.getenv("PORT"));
//        BASE_URI = protocol + host.orElse("localhost") + ":" + port.orElse("8080") + "/";
//    }
//
//    // TODO: Terraform plugin for IntelliJ
//    private Application() {
//        try {
//            LOGGER.info("Jersey app starting ...");
//            // create a resource config that scans for JAX-RS resources and providers in com.example.rest package
//            final ResourceConfig rc = new ResourceConfig().packages(CustomerService.class.getPackage().getName());
//
//            // create and start a new instance of grizzly http server exposing the Jersey application at BASE_URI
//            httpServer = GrizzlyHttpServerFactory.createHttpServer(URI.create(BASE_URI), rc);
//            LOGGER.info("Jersey app started with WADL available at {}", BASE_URI);
//            httpServer.start();
//            Thread.currentThread().join();
//        } catch (Exception e) {
//            LOGGER.error("Failed to start jersey app: {}", e.getMessage());
//        }
//    }
//
//
//    private void shutdown() {
//        if (httpServer != null && httpServer.isStarted()) {
//            LOGGER.info("Jersey app shutting down now");
//            httpServer.shutdownNow();
//        }
//    }
//
//    public static void main(String[] args) throws IOException {
//        Application main = new Application();
//        Runtime.getRuntime().addShutdownHook(new Thread(main::shutdown));
//    }
//}
