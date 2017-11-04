package com.sverze.examples.spring.twotier.resource;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Controller
@RequestMapping(path = "/health")
public class HealthCheckController {

    @GetMapping
    public ResponseEntity getHealthStatus() {
        return new ResponseEntity(HttpStatus.OK);
    }
}