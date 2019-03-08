# Camunda on Openshift
The goal of this repository is to show a way to integrate camunda cockpit springboot  on Openshift (formely openshift origin - okd.io - https://docs.okd.io/latest/welcome/index.html) and to create a small process project.

In this demo, we'll be using the following components :

*  minishift : used to install okd.io easily on your desktop
* okd.io 3.11 : the opensource version of openshift. (by the way, the demo works as well on onpenshift 3.11)
* Postgres sql container running on openshift.
* camunda-bpm-spring-boot-starter-webapp and rest - opensource version 3.2.0 
* https://maven.fabric8.io/ : a great maven plugin allowing to deploy any springboot app on an openshift cluster. (no pipeline to create)

## Installing minishift
Installing a full openshift cluster could required a lot of resources. That's the reason, of the minishift projectm, allowing to run openshift on a single node workstation.
In theory, on windows, you just need a virtualization system (Hypberv or virtualbox) and to install minishift, - https://docs.huihoo.com/openshift/origin-latest/minishift/getting-started/installing.html.

In reality, after restarting openshift on virtualbox, you can face the "Ip reassigned" issue (https://github.com/minishift/minishift/issues/1508), so, no other choice than to delete and create the openshift vm again.
To get rid of that, you can use the following image : https://github.com/minishift/minishift-centos-iso/releases

please, see in "minishift" folder the "start-minishift.sh" script that can be run on windows using gitbash

By the way, if you need to install minishift somewhere else than on your default C drive, you can do it, but you'll need to change the "HOMEPATH" and the "USERPROFILE"

## Openshift setup for camunda cockpit
1. start your openshift cluster - in our case, minishift. (if you're using my script - . start-minishift.sh)
2. login to the console ( the url displayed after successfull startup ), or by typing in your git bash : minishift console.
3. choose a user and password (don't use admin user) and log in.
4. Create a new Project (for kubernetes users, it's a namespace) - let's name it "camunda".
5. Open your new project and open the "Catalog". We'll create a postgre SQL server for our camunda deployment
6. Choose Postgre SQL and fill in the proper values ( Connection Username, Password the Database Name )
7. After a while, you'll have a new service in your project : postgresql. 
8. In your projects go to Application -> Services and click on your postresql service. We'll need the following values to connect to this db from camunda cockpit 
   - Hostname (something like postgresql.camunda.svc)
   - Port ( by default, must be 5432 )

Here we're, we're ready to run our camunda cockpit in this namespace.

## Generate database tables and testing our cockpit-oc locally
Tables can be generated easily by using the property "camunda.bpm.database.schema-update" to "create".
Openshift (OC) allow us to access openshift pods localy using "port-forward". Thanks to this great functionality, we can test the execution of our CockpitOcApplication locally but using openshift postgresql database.

So, run your git bash and execute the following commands :

    $ eval $(minishift oc-env)
    $ oc project camunda
    Already on project "camunda" on server "https://192.168.99.101:8443".
    $ oc get pods
    NAME                 READY     STATUS    RESTARTS   AGE
    postgresql-1-t69r5   1/1       Running   0          32m
    $ oc port-forward postgresql-1-t69r5 5432:5432
    Forwarding from 127.0.0.1:5432 -> 5432
    Forwarding from [::1]:5432 -> 5432

Now, dig into cockpit-oc and modify "application.yml" as is : 
1. uncomment "schema-update : create"
2. uncomment "datasource.url" - localhost and comment the other one
3. Start the springboot "CockpitOcApplication"
4. Open your browser on "localhost:8080"... and login using "master" - "changeit".

## Deploy on your openshift cluster
Now, we'll deploy our OC application on our openshift cluster, but without having to use a jenkins pipeline  or any s2i based on git.
This can be done thanks to the use of fabric8, a maven plugin using OC to create an s2i binary image from a local artefact.
So, let's start by commenting the "application.yml"
1. comment "schema-update : create"
2. comment the localhost postgre url and use the "openshift" one.
3. stop the "oc port-forward" on gitbash (CTRL + C)
4. move to project "cockpit-oc" and type the following maven command :

       mvn clean fabric8:deploy
       
5. open openshift web console (type minishift console) - dig into your project "camuna"
and see applications -> routes - You should see a new route to access your new cockpit-oc pod.

###Important Notice
As you can see, using fabric8 help you to test your code easily in openshift, without having
to "push" code in git in order to run some .s2i images. But this was just for "demo" purpose, 
in the real life, I'd rather have some jenkins pipeline or a source to image build to ensure that what's pushed in git
is  what you get on your openshift cluster

##Testing with a process
Now, we'll deploy a process - as a "Pod" in our openshift project. The process is under loan-approval-oc and contains
only one human task and on java action.
It's really important that you set the System Task as "Asynchronous Before and After", to ensure that the task is only
executed by the process engine on which the process is deployed. (Otherwise, juste after a human task, if not asynchronous, it will run on the process engine of the human task...)

Now, to deploy it, you'll have to execute the following maven command into the loan-approval-oc projet :

    mvn clean fabric8:deploy

This will not only deploy the pod, but also deploy in Camunda, so, if you dig into the cockpit, you must be able to
see the new process, run it and see some messages in the console of the pod of the loan-approval-oc.

## Next  step - We'll see how to integrate SSO using Redhat SSO / Keycloak... 




    

