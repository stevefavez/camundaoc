package org.camunda.demo.loanapprovalspringboot.tasks;

import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;

public class DemoTask implements JavaDelegate {
    @Override
    public void execute(DelegateExecution delegateExecution) throws Exception {
        System.out.println( "Invoking java task from process on the correct server, for process definition id : " + delegateExecution.getProcessDefinitionId() ) ;
    }
}
