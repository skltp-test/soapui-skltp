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

There is support to run tests from SoapUI.

```
  Run soaptest/soaptest_local.sh first.
  The script will prepare(sed) the neccessary files
```

## Load test (Gatling)

There is support to run tests from Jenkins (see Jenkinsfile which is read by Jenkins project)

```
TBD - Look over loadtest so it can more easily be ran also locally
```
