package com.sverze.examples.spring.twotier.respository;

import com.sverze.examples.spring.twotier.model.Customer;
import org.springframework.data.repository.CrudRepository;

public interface CustomerRepository extends CrudRepository<Customer, Long> {

}
