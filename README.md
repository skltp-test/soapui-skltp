# soapui-skltp

System tests for SKLTP. Requires mocking setup only available in NTjP test environments.

## Local execution

The tests can be run from a local SoapUI installation. This requires SoapUI to be configured 
with the [soapui-support library](https://rivta-tools.bitbucket.io/soapui-support/) and a client certificate.

Also run `soaptest/soaptest_sed_data.sh` to prepare(sed) the needed data.xml file for the target NTjP environment. Usage:

```
  ./soaptest_sed_data.sh {dev|test|qa}
```

When the above is prepared, open `soaptest/soapui-skltp-workspace.xml` in SoapUI to access all the testsuites.

## Jenkins execution

This repository also includes the needed files to support execution in Jenkins. These are:
* `Jenkinsfile` - the main script used by Jenkins.
* `soaptest/Dockerfile` - defines a containerized SoapUI execution environment.
* `soaptest/testrunner_all.sh` - a script that uses SoapUI testrunner to execute testsuites according to input parameters from Jenkins.
