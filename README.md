# Kolide Fleet k8s Helm Chart
This chart is  a combination of tools, including Kolide's Fleet OSQuery orchestrator that allows us to query all of our hosts on demand for APT (Advanced Persistent Threat) IOC’s (Indicators Of Comprimise).

Scheduled queries feed all of these results into a search Index. Osquery is even platform agnostic so we can deploy it across all endpoints, regardless of host OS.

-   **Osquery** – Is a tool that allows us to query devices as if they are databases. It was built by Facebook and is built with performance in mind.
-   **Kolide Fleet** – 
[Kolide Fleet](https://kolide.com/fleet)    
A flexible control server for osquery fleets. Fleet allows us query multiple hosts on demand as well as create query packs, build schedules and manage the hosts in our environment.

-    **Elastic Stack** – Elasticsearch, Logstash and Kibana are tools that allow for the collection, normalizing and visualization of logs.    

**This solution implies Kubernetes Operator Framework based ELK Stack** Fleet Output is fed into ELK via container native EFK FluentD sends the JSON formatted stdout and stderr to the k8s embedded elk stack. Therefore we do not include the ELK solution with this chart.     


#### TL;DR; How to install    
Follow the README.md for each sub-chart, install in this order:    
1. Install Redis chart        
1. Install MySQL chart
1. Install Fleet chart          

---    

We can automate endpoint security monitoring with a combination of OSQuery Packs targeting IOCs:

And a set of query packs:

-   **Palantir OSQuery** : https://github.com/palantir/osquery-configuration
-   **GSA Laptop Management** : https://github.com/GSA/laptop-management
-   **FaceBook OSQuery** : https://osquery.io/chart    

![EUC Intelligence](./docs/fleet-intel-platform.png)

Some use-cases for the Kolide Fleet solution include:    
Systematically monitor EUC (End User Compute)    
-   IOC's (Indicators of Comprimise)    
-   Configuration Compliance   
-   Operations issues & support    
-   General fleet management & capacity management    

#### Kolide Fleet implements an OSQuery TLS Service    

Kolide Fleet is an Open Source Osquery Manager  

Kolide Fleet is an application that allows you to take advantage of the power of osquery
in order to maintain constant insight into the state of your infrastructure (security, health, stability, performance, compliance, etc).

https://kolide.com/fleet
https://github.com/kolide/fleet/blob/master/docs/application/README.md     

![Kolide Diagram](./docs/kolide.png)

#### Utilities

-   **Build agent installer packages**    [package-build.sh](./docs/package-build.sh)
-   **Import OSQuery Pack files**   [import.go](./docs/import.go)
    Pack import tool examples: [Import examples](https://gist.github.com/marpaia/9e061f81fa60b2825f4b6bb8e0cd2c77)
-   **Files to run stuff on Minikube** [minikube-files](./docs/minikube/)
    **To run Elastic Stack on Minikube you must run the systcl pod to
    increase shmmax m.max_map_count=262166**

```
2018 ACME InfoSec
```
