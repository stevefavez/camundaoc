package org.camunda.demo.loanapprovalspringboot;

import org.camunda.bpm.spring.boot.starter.annotation.EnableProcessApplication;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableProcessApplication
public class LoanApprovalSpringbootApplication {

    public static void main(String[] args) {
        SpringApplication.run(LoanApprovalSpringbootApplication.class, args);
    }

}

