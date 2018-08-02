package computerdatabase

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class RequestsNTjP extends Simulation {

        // Traffic will be routed toward LOAD-MOCKS based choosen personId
	val feeder1 = csv("../user-files/data/NTJPduration.csv").circular
	
	val httpConf = http
		//.baseURL("https://test.esb.ntjp.se/vp/") // Here is the root for all relative URLs
		.acceptEncodingHeader("gzip, deflate")
		.userAgentHeader("NTjP load tests")

	   val GetDiagnosis_2 = exec(http("GetDiagnosis_2")
		.post("https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/description/GetDiagnosis/2/rivtabp21")
		.body(ElFileBody("user-files/data/GetDiagnosis2.xml")).asXML
		.check(status.is(200), responseTimeInMillis.lessThan(15000)))

	   val GetMedicationHistory_2 = exec(http("GetMedicationHistory_2")
		.post("https://test.esb.ntjp.se/vp/clinicalprocess/activityprescription/actoutcome/GetMedicationHistory/2/rivtabp21")
		.body(ElFileBody("user-files/data/GetMedicationHistory2.xml")).asXML
		.check(status.is(200), responseTimeInMillis.lessThan(15000)))  

	   val GetImagingOutcome_1 = exec(http("GetImagingOutcome_1")
                .post("https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/actoutcome/GetImagingOutcome/1/rivtabp21")
                .body(ElFileBody("user-files/data/GetImagingOutcome1.xml")).asXML
			.check(status.is(200), responseTimeInMillis.lessThan(15000)))

	   val GetLaboratoryOrderOutcome_3 = exec(http("GetLaboratoryOrderOutcome_3")
                .post("https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/actoutcome/GetLaboratoryOrderOutcome/3/rivtabp21")
                .body(ElFileBody("user-files/data/GetLaboratoryOrderOutcome3.xml")).asXML
			.check(status.is(200), responseTimeInMillis.lessThan(15000)))

	   val GetReferralOutcome_3 = exec(http("GetReferralOutcome_3")
                .post("https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/actoutcome/GetReferralOutcome/3/rivtabp21")
                .body(ElFileBody("user-files/data/GetReferralOutcome3.xml")).asXML
			.check(status.is(200), responseTimeInMillis.lessThan(15000)))

	   val GetAlertInformation_2 = exec(http("GetAlertInformation_2")
                .post("https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/description/GetAlertInformation/2/rivtabp21")
                .body(ElFileBody("user-files/data/GetAlertInformation2.xml")).asXML
			.check(status.is(200), responseTimeInMillis.lessThan(15000)))

	   val GetCareContacts_2 = exec(http("GetCareContacts_2")
                .post("https://test.esb.ntjp.se/vp/clinicalprocess/logistics/logistics/GetCareContacts/2/rivtabp21")
                .body(ElFileBody("user-files/data/GetCareContacts2.xml")).asXML
			.check(status.is(200), responseTimeInMillis.lessThan(15000)))

	   val GetCareDocumentation_2 = exec(http("GetCareDocumentation_2")
                .post("https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/description/GetCareDocumentation/2/rivtabp21")
                .body(ElFileBody("user-files/data/GetCareDocumentation2.xml")).asXML
			.check(status.is(200), responseTimeInMillis.lessThan(15000)))

	   val GetVaccinationHistory_2 = exec(http("GetVaccinationHistory_2")
                .post("https://test.esb.ntjp.se/vp/clinicalprocess/activityprescription/actoutcome/GetVaccinationHistory/2/rivtabp21")
                .body(ElFileBody("user-files/data/GetVaccinationHistory2.xml")).asXML
			.check(status.is(200), responseTimeInMillis.lessThan(15000)))

	   val GetFunctionalStatus_2 = exec(http("GetFunctionalStatus_2")
                .post("https://test.esb.ntjp.se/vp/clinicalprocess/healthcond/description/GetFunctionalStatus/2/rivtabp21")
                .body(ElFileBody("user-files/data/GetFunctionalStatus2.xml")).asXML
			.check(status.is(200), responseTimeInMillis.lessThan(15000)))

	   val GetCarePlans_2 = exec(http("GetCarePlans_2")
                .post("https://test.esb.ntjp.se/vp/clinicalprocess/logistics/logistics/GetCarePlans/2/rivtabp21")
                .body(ElFileBody("user-files/data/GetCarePlans2.xml")).asXML
			.check(status.is(200), responseTimeInMillis.lessThan(15000)))

		
	// Available scenarios for different types of setups
	val requestGetDiagnosis_2 = scenario("GetDiagnosis_2").feed(feeder1).exec(GetDiagnosis_2) 
	val requestGetMedicationHistory_2 = scenario("GetMedicationHistory_2").feed(feeder1).exec(GetMedicationHistory_2)
	val requestGetImagingOutcome_1 = scenario("GetImagingOutcome_1").feed(feeder1).exec(GetImagingOutcome_1)
	val requestGetLaboratoryOrderOutcome_3 = scenario("GetLaboratoryOrderOutcome_3").feed(feeder1).exec(GetLaboratoryOrderOutcome_3)
	val requestGetReferralOutcome_3 = scenario("GetReferralOutcome_3").feed(feeder1).exec(GetReferralOutcome_3)
	val requestGetAlertInformation_2 = scenario("GetAlertInformation_2").feed(feeder1).exec(GetAlertInformation_2)
	val requestGetCareContacts_2 = scenario("GetCareContacts_2").feed(feeder1).exec(GetCareContacts_2)
	val requestGetCareDocumentation_2 = scenario("GetCareDocumentation_2").feed(feeder1).exec(GetCareDocumentation_2)
	val requestGetVaccinationHistory_2 = scenario("GetVaccinationHistory_2").feed(feeder1).exec(GetVaccinationHistory_2)
	val requestGetFunctionalStatus_2 = scenario("GetFunctionalStatus_2").feed(feeder1).exec(GetFunctionalStatus_2)
	val requestGetCarePlans_2 = scenario("GetCarePlans_2").feed(feeder1).exec(GetCarePlans_2)


  // Simulate NPÖ that requests patient data once per second
  // NOTE: Injections are run in parallell, stepts within an injection are sequencial
  setUp(
    requestGetDiagnosis_2.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetMedicationHistory_2.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetImagingOutcome_1.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetLaboratoryOrderOutcome_3.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetReferralOutcome_3.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetAlertInformation_2.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetCareContacts_2.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetCareDocumentation_2.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetVaccinationHistory_2.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetFunctionalStatus_2.inject(constantUsersPerSec(1) during(300 seconds)),
    requestGetCarePlans_2.inject(constantUsersPerSec(1) during(300 seconds))
  ).protocols(httpConf)  
  
  
}

