package com.sverze.examples.spring.twotier.resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@Controller
@RequestMapping(path = "/database")
public class DatabaseCheckController {
    private static final Logger LOGGER = LogManager.getLogger(DatabaseCheckController.class);
    private Connection connection;

    @Value("${spring.datasource.url}")
    private String datasourceUrl;
    @Value("${spring.datasource.username}")
    private String datasourceUsername;
    @Value("${spring.datasource.password}")
    private String datasourcePassword;

    @GetMapping(path = "/status")
    public ResponseEntity databaseStatus(){
        ResponseEntity response;

        Connection connection = getConnection();
        try {
            if (connection != null && connection.isValid(1000)) {
                LOGGER.debug("Database connection validation successful");
                response = new ResponseEntity(HttpStatus.OK);
            } else {
                LOGGER.warn("SQL Connection invalid");
                response = new ResponseEntity(HttpStatus.SERVICE_UNAVAILABLE);
            }
        } catch (SQLException e) {
            LOGGER.warn("Failed connection validation check", e);
            response = new ResponseEntity(HttpStatus.SERVICE_UNAVAILABLE);
        }
        return response;
    }

    @GetMapping(path = "/url")
    @Produces(MediaType.TEXT_PLAIN)
    public @ResponseBody String databaseUrl() {
        String jdbcUrl = datasourceUrl + "?user=" + datasourceUsername + "&password=" + datasourcePassword;
        LOGGER.debug("JDBC URL [{}]", jdbcUrl);

        return jdbcUrl;
    }

    private Connection getConnection() {
        if (connection == null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                LOGGER.info("Connecting to data base using JDBC URL [{}]", databaseUrl());
                connection = DriverManager.getConnection(datasourceUrl, datasourceUsername, datasourcePassword);
                LOGGER.info("Database connection successfu.");
            } catch (ClassNotFoundException | SQLException e) {
                LOGGER.warn("Failed to create connection", e);
            }
        }
        return connection;
    }
}