package com.sverze.examples.spring.twotier.resource;

import com.sverze.examples.spring.twotier.model.Customer;
import com.sverze.examples.spring.twotier.respository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Controller
@RequestMapping(path="/customer")
public class CustomerController {
	@Autowired
	private CustomerRepository customerRepository;
	
	@PostMapping(path = "/add")
	public ResponseEntity addCustomer(@RequestBody Customer customer) {
		customerRepository.save(customer);
		return new ResponseEntity(HttpStatus.OK);
	}

    @GetMapping(path = "/{id}")
	@Produces(value = MediaType.APPLICATION_JSON)
	public ResponseEntity<Customer> getCustomer(@PathVariable("id") long id) {
		Customer match = customerRepository.findOne(id);
		if (match != null) {
			return new ResponseEntity<>(match, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	}

	@PutMapping(path = "/update")
	public ResponseEntity updateCustomer(@RequestBody Customer customer){
		Customer match = customerRepository.findOne(customer.getId());
		ResponseEntity response;
		if (match != null) {
			customerRepository.save(customer);
			response = new ResponseEntity(HttpStatus.OK);
		} else {
			response = new ResponseEntity(HttpStatus.NOT_FOUND);
		}
		return response;
	}

    @DeleteMapping(path = "/remove/{id}")
    public ResponseEntity deleteCustomer(@PathVariable("id") long id){
        Customer match = customerRepository.findOne(id);
        ResponseEntity response;
        if (match != null) {
            customerRepository.delete(match);
            response = new ResponseEntity(HttpStatus.OK);
        } else {
            response = new ResponseEntity(HttpStatus.NOT_FOUND);
        }
        return response;
    }

	@GetMapping(path = "/all")
	@Produces(value = MediaType.APPLICATION_JSON)
	public @ResponseBody Iterable<Customer> getAllCustomers() {
		return customerRepository.findAll();
	}
}
