# soapui-skltp

#--------------------------------------------------------
# Soap test (FT)
#--------------------------------------------------------
# Support to be run from Jenkins (see Jenkinsfile which is read by Jenkins project)

# Support to be run locally (CLI) using testrunner (see soaptest/soaptest_local.sh)
  Input parameters:
    - Hostname 
        (for SIT, use test.esb.njtp.se)
        (for QA, use qa.esb.ntjp.se)
    - Certificate (path to a pkcs12 file)
    - Certificate password
    - Source system (HSA, normally LOAD-MOCKS i SIT, JOL-MOCK i QA) 

# Support to be run from SoapUI 
  (recommended is to run soaptest/soaptest_local.sh first. 
   The script will prepare(sed) the neccessary files)


#--------------------------------------------------------
# Load test (Gatling)
#--------------------------------------------------------
# Support to be run from Jenkins (see Jenkinsfile which is read by Jenkins project)

# TBD - Look over loadtest so it can more easily be ran also locally
