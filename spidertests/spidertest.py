#!/usr/bin/python3 -B 


TAKAPIURL="http://qa.api.ntjp.se/coop/api/v1"
TKNS="urn:riv:clinicalprocess:healthcond:description:GetCareDocumentationResponder:2"


import requests
from zeep import Client
from zeep.transports import Transport
from zeep.cache import SqliteCache
from junit_xml import TestSuite, TestCase
import time
import os

class MissingSettingException(Exception):
    def __init__(self, list_of_missing):
        self.list = list_of_missing
    def __str__(self):
        return "Missing following settings: " + ', '.join(self.list)
    def __repr__(self):
        return "MissingSettingException(" + ",".join(self.list)

class Settings(object):
    def __init__(self, list_of_settings):
        self.list_of_settings = list_of_settings
        missing = [m for m in list_of_settings if m not in os.environ]
        if missing:
            raise MissingSettingException(missing)
    def __getattr__(self,name):
        if name in self.list_of_settings:
            return os.environ.get(name)
        raise Exception("Unknown setting " + name)

IGNORE_LA_LIST = [
  '5565594230',
  'PRODUCER-NOT-AVAILABLE',
  ] + ["SKLTP-MOCK{:02}".format(i) for i in range(1,21)] 
  

def execute_api_call(func, **params):
    url = "{api}/{func}".format(api=TAKAPIURL, func=func)
    response = requests.get(url, params=params, headers={'Accept': 'application/json'})
    return response.json()
    
def get_connection_point_id(platform,environment):
    response =  execute_api_call('connectionPoints', platform=platform, environment=environment)
    return response[0]['id']
    
def get_tak_consumer_id(connectionPointId, hsaid):
    data = execute_api_call('serviceConsumers', connectionPointId=connectionPointId)
    for i in data:
        if i['hsaId'] == hsaid:
            return i['id']

def get_tak_tk_id():
    data = execute_api_call('serviceContracts', namespace=TKNS)
    url = "{}/serviceContracts?namespace={}".format(TAKAPIURL,TKNS)
    r = requests.get(url=url, params={"Accept": "application/json"})
    data = r.json()
    return data[0]["id"]

def get_tak_la_for_tk(connectionPointId, consumerhsaid):
    consid = get_tak_consumer_id(connectionPointId, consumerhsaid)
    tkid = get_tak_tk_id()

    url = "{}/logicalAddresss?connectionPointId={}&serviceConsumerId={}&serviceContractId={}".format(TAKAPIURL,connectionPointId,consid,tkid)
    r = requests.get(url=url, params={"Accept": "application/json"})
    data = r.json()
    
    return data
    
def test_availible_endpoints(output):

    s = Settings(['PLATFORM', 'ENVIRONMENT', 'SERVICEURL', 'WSDLURL', "CONSUMERHSAID", "CERTFILE"])
    test_cases = []
        
    cache = SqliteCache(path='/tmp/_gcdrunner_sqlite.db', timeout=60*24*7)

    session = requests.Session()
    #session.verify = False
    #session.cert=s.CERTFILE

    transport = Transport(session=session,cache=cache)
    client = Client(s.WSDLURL, transport=transport)
    service = client.create_service(client.service._binding.name.text, s.SERVICEURL)

    session.verify = False
    session.cert=s.CERTFILE

    pid_fact = client.type_factory('ns2')
    adr_fact = client.type_factory('ns5')
    pid_t = pid_fact.PersonIdType('191212121212', '1.2.752.129.2.1.3.1')
    connectionPointId = get_connection_point_id(s.PLATFORM, s.ENVIRONMENT)

    requests.packages.urllib3.disable_warnings()
    endpoints = get_tak_la_for_tk(connectionPointId, s.CONSUMERHSAID)
    endpoints = list(filter(lambda e: e["logicalAddress"] not in IGNORE_LA_LIST, endpoints))
    endpoints.sort(key=lambda e: e["description"])
    for endpoint in endpoints:
        testname = "{} ({})".format(endpoint["description"], endpoint["logicalAddress"])
        
        print ("Running test: {}".format(testname))
        logicalAddress_t = adr_fact.LogicalAddressType(endpoint['logicalAddress'])
        
        tc =  TestCase(name=testname)
        tc.stdout =  "Testing Logical address: {},  with id: {},  description: {}".format(endpoint['logicalAddress'], endpoint['id'], endpoint['description'])
        
        try:
            start = time.time()
            response = service.GetCareDocumentation(patientId=pid_t,_soapheaders={'LogicalAddress': logicalAddress_t})
            tc.elapsed_sec = time.time() - start
            tc.stdout = repr(response['result'])
        except Exception as e:
            tc.stderr = str(e)
            failtype = None
            if tc.stderr.startswith("VP"):
               failtype = tc.stderr.split()[0] 
            tc.add_failure_info(output=str(e), failure_type=failtype)
        test_cases.append(tc)

    ts = TestSuite("Spider TK tests for TK: " + TKNS, test_cases)
    with open(output, 'w') as f:
        TestSuite.to_file(f, [ts])

if __name__ == '__main__':
    test_availible_endpoints("output.xml")
