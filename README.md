# soapui-skltp

Test destined to be ran from Jenkins toward different SKLTP deployments.

## Soap test (FT)

There is support to run tests from Jenkins (see Jenkinsfile which is read by Jenkins project).

There is support to run tests locally (CLI) using testrunner (see soaptest/soaptest_local.sh).

```
  Input parameters:
    - Hostname 
        (for SIT, use test.esb.njtp.se)
        (for QA, use qa.esb.ntjp.se)
    - Certificate (path to a pkcs12 file)
    - Certificate password
    - Source system (HSA, normally LOAD-MOCKS i SIT, JOL-MOCK i QA) 
```

There is support to run tests from SoapUI. This requires the SoapUI installation to be configured 
with the soapui-support library and a client certificate. Also run soaptest/soaptest_sed_data.sh 
to prepare(sed) the needed data.xml file for the target NTjP environment.

```
  Usage:
  ./soaptest_sed_data.sh {dev|test|qa}
```

