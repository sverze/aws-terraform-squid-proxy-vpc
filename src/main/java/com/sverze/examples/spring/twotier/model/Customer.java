package com.sverze.examples.spring.twotier.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.concurrent.atomic.AtomicLong;

@Entity
public class Customer {
    @Id @GeneratedValue(strategy= GenerationType.AUTO)
    private Long id;
    private final String firstName;
    private final String lastName;
    private final String email;
    private final String city;
    private final String state;
    private final String birthday;
    private static final AtomicLong counter = new AtomicLong(100);

    private Customer(CustomerBuilder builder){
        this.id = counter.getAndIncrement();
        this.firstName = builder.firstName;
        this.lastName = builder.lastName;
        this.email = builder.email;
        this.city = builder.city;
        this.state = builder.state;
        this.birthday = builder.birthday;
    }

    public Customer(){
        Customer cust = new Customer.CustomerBuilder().build();
        this.firstName = cust.getFirstName();
        this.lastName = cust.getLastName();
        this.email = cust.getEmail();
        this.city = cust.getCity();
        this.state = cust.getState();
        this.birthday = cust.getBirthday();
    }

    public Customer(Long id, String firstName, String lastName,
                    String email, String city, String state, String birthday){
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.city = city;
        this.state = state;
        this.birthday = birthday;
    }

    public Long getId(){
        return this.id;
    }

    public String getFirstName() {
        return this.firstName;
    }

    public String getLastName() {
        return this.lastName;
    }

    public String getEmail(){
        return this.email;
    }

    public String getCity() {
        return this.city;
    }

    public String getState() {
        return this.state;
    }

    public String getBirthday(){
        return this.birthday;
    }

    @Override
    public String toString(){
        return "ID: " + id
                + " First: " + firstName
                + " Last: " + lastName + "\n"
                + " EMail: " + email + "\n"
                + " City: " + city
                + " State: " + state
                + " Birthday " + birthday;
    }

    static class CustomerBuilder{
        private String firstName = "";
        private String lastName = "";
        private String email = "";
        private String city = "";
        private String state = "";
        private String birthday = "";

        CustomerBuilder firstName(String firstName){
            this.firstName = firstName;
            return this;
        }

        CustomerBuilder lastName(String lastName){
            this.lastName = lastName;
            return this;
        }

        CustomerBuilder email(String email){
            this.email = email;
            return this;
        }

        CustomerBuilder city(String city){
            this.city = city;
            return this;
        }

        CustomerBuilder state(String state){
            this.state = state;
            return this;
        }

        CustomerBuilder birthday(String birthday){
            this.birthday = birthday;
            return this;
        }

        Customer build(){
            return new Customer(this);
        }

    }
}