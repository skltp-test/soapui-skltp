# Testfallsbeskrivning

Detta dokument beskriver SoapUI-testfallen som finns i `soaptest/`-projektfilerna. Inventeringen omfattar 398 `testCase`-element i 17 SoapUI-projektfiler, inklusive inaktiverade fall. Beskrivningarna bygger på testfallens namn, suite, request-steg och assertions i XML-filerna; de anger avsikten, inte ett resultat från en körning.

Testerna riktar sig mot SKLTP/NTjP:s testmiljöer och förutsätter enligt [README.md](README.md) SoapUI, `soapui-support`, klientcertifikat och förberedda testdata. Suite- och testfallsnamn nedan är de identifierare som visas i SoapUI. `Inaktiv` betyder att testfallet har `disabled="true"` i projektet. `BLOCK` i filnamnet är en projektmarkering; Axel-filen omfattas inte av Jenkins mönster `SKLTP-Adapter-*soapui-project.xml`.

## Testtäckning

Översikten visar testfall som är aktiverade i SoapUI-projektfilerna, inte faktisk kodtäckning eller körresultat. Ett aktivt fall kan fortfarande hoppas över eller misslyckas beroende på miljö och testdata. Av 398 testfall är 345 aktiva och 53 inaktiva (cirka 86,7 % aktiva).

| Projekt | Täckningsområde | Totalt | Aktiva | Inaktiva |
| --- | --- | ---: | ---: | ---: |
| `SKLTP-Adapter-Axel-soapui-project.BLOCK.xml` | Axel-adaptern, SKV register/revoke certificate | 2 | 2 | 0 |
| `SKLTP-Adapter-FkCertProxy-soapui-project.xml` | FK CertProxy, RegisterCertificate | 1 | 1 | 0 |
| `SKLTP-AgP-Aktivitetshantering-soapui-project.xml` | AgP, activity actions | 10 | 10 | 0 |
| `SKLTP-AgP-Basuppgifter-tillstand-soapui-project.xml` | AgP, health-condition basic | 10 | 10 | 0 |
| `SKLTP-AgP-Hogkostnadsskydd-soapui-project.xml` | AgP, patient fee exemption och åldersgränser | 11 | 11 | 0 |
| `SKLTP-AgP-Ordinationsutfall-soapui-project.xml` | AgP, activity prescription outcome | 24 | 24 | 0 |
| `SKLTP-AgP-Remisstatus-soapui-project.xml` | AgP, request status och GRA-version | 11 | 11 | 0 |
| `SKLTP-AgP-Resurssamordning-soapui-project.xml` | AgP, logistics för GCC/GCP/GCS | 36 | 24 | 12 |
| `SKLTP-AgP-Tidbokning-soapui-project.xml` | AgP, scheduling | 10 | 10 | 0 |
| `SKLTP-AgP-Tillstandsbeskrivning-soapui-project.xml` | AgP, health-condition description | 50 | 50 | 0 |
| `SKLTP-AgP-Utfall-av-aktiviteter-soapui-project.xml` | AgP, health-condition activity outcome | 60 | 60 | 0 |
| `SKLTP-Core-Functionality-soapui-project.xml` | Routing, headers, correlation-id, standardfel, versioner, trädklättring, WSDL och TLS | 61 | 59 | 2 |
| `SKLTP-Core-Tjansteadressering-soapui-project.xml` | Registry-sökningar GSSC och GLABSC | 4 | 4 | 0 |
| `SKLTP-EI-soapui-project.xml` | Engagemang, grundladdning, validering, notifieringar och FindContent | 41 | 36 | 5 |
| `SKLTP-REST-DomDB-soapui-project.xml` | DomDB API v1/v2 och Domain AdminWeb | 8 | 5 | 3 |
| `SKLTP-REST-Takapi-soapui-project.xml` | TAK API v1/v2-resurser | 38 | 19 | 19 |
| `SKLTP-REST-Web-Accessibility-soapui-project.xml` | URL-nåbarhet för API, webbgränssnitt och adaptrar över olika transportvägar | 21 | 9 | 12 |
| **Totalt** |  | **398** | **345** | **53** |

### Täckning och begränsningar

- **AgP (222 fall):** funktionella frågeflöden med olika mängd engagemang och poster, aggregering från flera producenter, tomma svar, timeout, logiska fel och tekniska undantag. Tolv GCS-fall i Resurssamordning är inaktiva.
- **EI (41 fall):** skapa, uppdatera och ta bort engagemang, grundladdningar, felaktiga meddelanden, notifieringar och FindContent. Fem ägarskaps-/notifieringsfall är inaktiva.
- **Kärnfunktioner och adressering (65 fall):** konsument-/producentroller, routing, behörighet, standardiserade fel, protokollversioner, registry-filtrering, WSDL och hostname-verifiering. Två Core-fall är inaktiva.
- **REST och nåbarhet (67 fall):** DomDB och TAK API samt URL-kontroller via Apache/BKS. Alla 19 TAK API v1-fall är inaktiva; även tre DomDB-fall och tolv URL-kontroller är inaktiva.
- **Adaptrar (3 fall):** Axel register/revoke certificate och FK CertProxy RegisterCertificate. Axel-projektet har filnamnet `BLOCK` och körs inte av Jenkins wildcard enligt noteringen ovan.

Detta är en statisk inventering av SoapUI-konfigurationen. Den visar inte vilka fall som faktiskt körs i en viss Jenkins-körning, assertionernas utfall, täckning i applikationskod eller krav som saknar testfall. Inaktiva fall behöver aktiveras och köras i rätt NTjP-testmiljö innan de kan räknas som verifierad täckning.

## AgP-tjänster

AgP-projekten innehåller samma återkommande scenarier för olika RIV-tjänster. Tabellen förklarar vad varje suffix i testfalls-ID:t prövar. Prefixet före suffixet pekar ut tjänst/testsvit; den exakta täckningen per projekt anges efter tabellen.

| Suffix | Vad testfallet prövar |
| --- | --- |
| `.1` | Patienten saknar engagemang. Tjänsten ska hantera att ingen producent behöver lämna uppgifter. |
| `.2` | Engagemang och minst en post finns hos en producent. Verifierar normalt svar med en träff. |
| `.3` | En post finns hos var och en av tre producenter. Verifierar aggregering från flera producenter. |
| `.4` | En producent returnerar en stor mängd poster (normalt 1 000). Prövar hantering av större svar. |
| `.5` | Engagemang finns hos 20 producenter, normalt fem poster hos var och en. Prövar bred aggregering. |
| `.6` | En av tre producenter lämnar tomt svar. Prövar partiellt tomt svar tillsammans med fungerande producenter. |
| `.7` | En av tre producenter timeoutar. Prövar partiellt bortfall. |
| `.8` | Samtliga producenter timeoutar. Prövar totalt timeout-bortfall. |
| `.9` | En av tre producenter ger ett logiskt fel. Prövar partiellt fel i producenternas svar. |
| `.10` | Samtliga producenter ger logiskt fel. Prövar fel från alla producenter. |
| `.11` | En av tre producenter ger ett tekniskt undantag/exception. Prövar partiellt tekniskt fel. |
| `.12` | Samtliga producenter ger exception. Prövar tekniskt fel från alla producenter. |

I nedanstående inventering betyder exempelvis `4.1.1–4.1.12` att respektive uppräknat suffix finns som ett eget testfall och beskrivs av motsvarande rad i scenariotabellen. Utelämnade suffix finns inte i den aktuella projektfilen. Där namn anger annan mängd poster, annan ålder eller annan routing gäller det projektspecifika tillägget.

### `SKLTP-AgP-Tillstandsbeskrivning-soapui-project.xml`

Suite `clinicalprocess_healthcond_description`, tjänsten för health-condition description:

- `4.1.1–4.1.12 (GAI)`: scenarierna 1–12 enligt scenariotabellen.
- `4.2.1–4.2.12 (GCD)`: scenarierna 1–12; `.4` innehåller dessutom GCD3/`hasMore`-fallet för stort svar.
- `4.3.1–4.3.12 (GD)`: scenarierna 1–12.
- `4.3.13 (GD)`: engagemang pekar på en okänd logisk adress; prövar hantering av olöst adress vid aggregering.
- `4.3.14 (GD)`: engagemang finns för en adress där samverkansbehörighet saknas; prövar behörighetsfel vid aggregering.
- `4.4.1–4.4.12 (GFS)`: scenarierna 1–12.

### `SKLTP-AgP-Utfall-av-aktiviteter-soapui-project.xml`

Suite `clinicalprocess_healthcond_actoutcome`, tjänsten för health-condition activity outcome:

- `4.10.1–4.10.12 (GECGO)`: scenarierna 1–12, med `.4` anpassat till 200 poster och `.5` till 20 producenter med två poster var.
- `4.10.13 (GECGO)`: 200 poster hämtas via direktadresserat anrop; prövar routing utan vanlig aggregerande tjänstväg.
- `4.10.14 (GECGO)`: 200 poster hämtas via direktadresserat anrop som inte går via RTjP; prövar alternativ direktväg.
- `4.11.1–4.11.12 (GIO)`: scenarierna 1–12.
- `4.12.1–4.12.12 (GLOO)`: scenarierna 1–12.
- `4.13.1–4.13.8 (GMMH)`: inget engagemang, engagemang hos en/tre/många producenter, tomt svar från en producent samt timeout från en/alla producenter.
- `4.13.11–4.13.12 (GMMH)`: exception från en respektive samtliga producenter. Suffix `.9` och `.10` finns inte i projektet.
- `4.14.1–4.14.12 (GRO)`: scenarierna 1–12.

### `SKLTP-AgP-Ordinationsutfall-soapui-project.xml`

Suite `clinicalprocess_activityprescription_actoutcome`, tjänsten för activity prescription outcome:

- `4.5.1–4.5.12 (GVH)`: scenarierna 1–12.
- `4.6.1–4.6.12 (GMH)`: scenarierna 1–12.

### `SKLTP-AgP-Resurssamordning-soapui-project.xml`

Suite `clinicalprocess_logistics_logistics`, tjänsten för logistics:

- `4.7.1–4.7.12 (GCC)`: scenarierna 1–12.
- `4.8.1–4.8.12 (GCP)`: scenarierna 1–12.
- `4.9.1–4.9.12 (GCS)`: samma scenarier 1–12, men samtliga dessa tolv testfall är inaktiverade i projektet.

### `SKLTP-AgP-Basuppgifter-tillstand-soapui-project.xml`

Suite `clinicalprocess_healthcond_basic`, tjänsten för health-condition basic:

- `4.15.1–4.15.8 (GO)`: scenarierna 1–8.
- `4.15.11–4.15.12 (GO)`: exception från en respektive samtliga producenter. `.9` och `.10` finns inte.

### `SKLTP-AgP-Aktivitetshantering-soapui-project.xml`

Suite `clinicalprocess_activity_actions`, tjänsten för activity actions:

- `4.16.1–4.16.8 (GA)`: scenarierna 1–8.
- `4.16.11–4.16.12 (GA)`: exception från en respektive samtliga producenter. `.9` och `.10` finns inte.

### `SKLTP-AgP-Remisstatus-soapui-project.xml`

Suite `crm_requeststatus`, tjänsten för request status:

- `check gra version support`: hämtar tjänstens stödda service contracts och kontrollerar att GRA version 2 finns bland dem.
- `4.17.1–4.17.8 (GRA)`: scenarierna 1–8.
- `4.17.11–4.17.12 (GRA)`: exception från en respektive samtliga producenter. `.9` och `.10` finns inte.

### `SKLTP-AgP-Tidbokning-soapui-project.xml`

Suite `crm_scheduling`, tjänsten för scheduling:

- `4.18.1–4.18.8 (GSOCS)`: scenarierna 1–8.
- `4.18.11–4.18.12 (GSOCS)`: exception från en respektive samtliga producenter. `.9` och `.10` finns inte.

### `SKLTP-AgP-Hogkostnadsskydd-soapui-project.xml`

Projektet innehåller en förberedande suite och `financial_patientfees_exemption`:

- `4.19.0 PRE - Sätt engagemang till känd ålder`: förbereder testdata så att åldern på engagemangsposterna är känd.
- `4.19.1 (RES)`: patient utan engagemang.
- `4.19.2 (RES)`: en producent med engagemang uppdaterat under de senaste 12 månaderna.
- `4.19.3 (RES)`: tre producenter med engagemang uppdaterat under de senaste 12 månaderna.
- `4.19.4 (RES)`: engagemang hos en producent är äldre än 12 månader.
- `4.19.5 (RES)`: 20 producenter med engagemang uppdaterat under de senaste 12 månaderna.
- `4.19.6 (RES)`: en av tre producenter har en äldre engagemangspost.
- `4.19.7 (RES)`: timeout mot en av tre producenter.
- `4.19.8 (RES)`: timeout mot samtliga producenter.
- `4.19.11 (RES)`: exception från en av tre producenter.
- `4.19.12 (RES)`: exception från samtliga producenter.

## SKLTP-kärnfunktioner

### `SKLTP-Core-Functionality-soapui-project.xml`

- `1.1.1`: angränsande konsument anropar via aggregerande tjänst.
- `1.1.2`: samma anropsväg, med `x-rivta-original-serviceconsumer-hsaid` angivet.
- `1.1.3`: avlägsen konsument anropar via aggregerande tjänst.
- `1.1.4`: angränsande konsument anropar via aggregerande tjänst med `x-vp-sender-id` angivet.
- `1.2.1`: angränsande konsument skickar direktadresserad fråga.
- `1.2.2`: avlägsen konsument skickar direktadresserad fråga.
- `1.3.1`: anrop via aggregerande tjänst med angivet SKLTP correlation-id.
- `1.3.2`: prövar hantering av identiska correlation-id.
- `1.3.3`: direktadresserat anrop med angivet SKLTP correlation-id. **Inaktiv.**
- `1.4.1`: ursprunglig konsument skickar en fråga utan tidigare anropskedja.
- `1.4.2`: vidarebefordrar en fråga som redan har en anropskedja.
- `Get and set environment properties` (förekommer i två suites): läser testmiljöns endpoint-/miljödata och sätter SoapUI-miljövariabler.
- `Link producer with mock gemenlogiskadress`: administrativt teststeg som kopplar producent till mock med gemen logisk adress. **Inaktiv.**
- `Verifiera att anrop via Agp ar skiftlägesokansligt`: kontrollerar att HSA-id-kontroll för anrop via AgP inte är skiftlägeskänslig.
- `Verifiera att direktanrop ar skiftlagesokansligt`: motsvarande skiftlägeskontroll för direktanrop.
- `2.1.1`: anrop till okänd tjänst; verifierar standardiserat fel enligt den beskrivning som anges i testfallet.
- `2.1.2`: anrop till hostname i stället för en känd tjänst.
- `2.3.1`: anrop utan logisk adress; förväntat fel VP003.
- `2.3.2`: samma felväg för GD utan logisk adress; förväntat VP003.
- `2.4.1`: anrop till okänd tjänsteproducent; förväntat VP004.
- `2.7.1`: producent saknar samverkansbehörighet; förväntat VP007.
- `2.9.1`: producent är inte kontaktbar; förväntat VP009.
- `2.10.1`: producenten svarar med SoapFault; prövar vidarebefordran/hantering av SOAP-felet.
- `2.11.1`: rundgång mellan RTjP och NTjP; förväntat VP014.
- `2.12.1`: felaktigt formaterat SOAP-envelope; förväntat VP015.
- `2.12.2`: felaktigt formaterad SOAP-body; förväntat VP015.
- `3.1.1`: RIVTABP 2.0-konsument mot 2.0-producent.
- `3.1.2`: RIVTABP 2.1-konsument mot 2.0-producent; prövar versionsöversättning.
- `3.1.3`: RIVTABP 2.0-konsument mot 2.1-producent; prövar versionsöversättning.
- `3.1.4`: RIVTABP 2.1-konsument mot 2.1-producent.
- `TK - Ej tillatet pa: anropsbehorighet (pos - hittar vagval)`: positivt trädklättringsfall där behörighet inte är tillåten på anropsnivå men en giltig väg hittas.
- `Baseline - verifiera att anrop fungerar mot takat vagval per kontrakt`: grundfall som verifierar anrop mot TAK-vägval per kontrakt.
- `TK - Ej tillatet pa: vagval (pos hittar beh)`: positivt trädklättringsfall där vägvalet saknas på den aktuella nivån men behörighet hittas.
- `TK - Ej tillatet pa: vagval (neg VP004)`: negativt vägval vid trädklättring; verifierar VP004.
- `TK - Ej tillatet pa: anropsbehorighet (neg VP007)`: negativ behörighetskontroll vid trädklättring; verifierar VP007.
- `TK - Ej tillatet pa: kontrakt (neg)`: negativt fall där kontraktet inte är tillåtet.
- `NTP-775.1`: direktadresserad GRO; endast standardbehörighet (SB) och standardvägval (SV) finns.
- `NTP-775.2`: direktadresserad GCC; vägval baseras på TAK.
- `NTP-775.3`: direktadresserad GCC; vägval baseras på HSA.
- `NTP-775.4`: direktadresserad GCC; vägval baseras på SB och SV.
- `NTP-775.5`: direktadresserad GO; vägval baseras på SB och TAK.
- `NTP-775.6`: direktadresserad GIO; SB finns men vägval saknas.
- `NTP-775.7`: direktadresserad GA; vägval baseras på TAK-anropsbehörighet och SV.
- `NTP-775.8`: direktadresserad FAQ; SV finns men anropsbehörighet saknas.
- `NTP-775.9`: direktadresserad GO; vägval baseras på SB och HSA-klättring.
- `NTP-775.21`: GRO till AGP; endast SB och SV finns.
- `NTP-772.22`: GCC till AGP; vägval baseras på TAK.
- `NTP-775.23`: GCC till AGP; vägval baseras på HSA.
- `NTP-775.24`: GCC till AGP; vägval baseras på SB och SV.
- `NTP-775.25`: GO till AGP; vägval baseras på SB och TAK.
- `NTP-775.26`: GIO till AGP; SB finns men vägval saknas.
- `NTP-775.27`: GA till AGP; vägval baseras på TAK-anropsbehörighet och SV.
- `NTP-775.28`: GD till AGP; SV finns men anropsbehörighet saknas.
- `NTP-775.41`: RMCQ med standardrouting; vägval baseras på VG.
- `NTP-775.42`: RMCA med standardrouting; VG används även när SB och SV finns.
- `NTP-775.43`: RMCQ med standardrouting utan logisk adress.
- `SKLTP-1239.1`: RMCQ med standardrouting och samma HSA-id vid VG#VE-adressering.
- `Hämta wsdl - deltest`: delmoment som hämtar WSDL.
- `Hämta wsdl`: hämtar WSDL via den fullständiga testsekvensen.
- `Hostname verification`: prövar att TLS-certifikatets hostname verifieras.

### `SKLTP-Core-Tjansteadressering-soapui-project.xml`

Suite `infrastructure_itintegration_registry` testar registry-sökningar:

- `NTP-805.1 GSSC all`: hämtar GSSC utan filter.
- `NTP-805.2 GSSC filter on serviceConsumerHsaId`: hämtar GSSC filtrerat på konsumentens HSA-id.
- `NTP-805.3 GLABSC (inget filter)`: hämtar GLABSC utan filter.
- `NTP-805.4 GLABSC (filter)`: hämtar GLABSC med filter.

## Engagemangsindex (EI)

### `SKLTP-EI-soapui-project.xml`

- `5.0.1 PRE - Rensa engagemang`: förberedande test som rensar engagemangsdata.
- `5.0.2 PRE - Rensa engagemang med ProcessNotifications`: rensar data via ProcessNotification och prövar den vägen för datarensning.
- `5.1.1 Lägg till ett engagemang till en producent`: skapar ett engagemang hos en producent.
- `5.1.2 Ta bort ett engagemang till en producent`: tar bort ett befintligt engagemang hos en producent.
- `5.2.1 Lägg till engagemang till tre olika producenter`: skapar engagemang hos tre producenter.
- `5.2.2 Uppdatera engagemang till tre olika producenter`: uppdaterar de tre producenternas engagemang.
- `5.2.3 Uppdatera engagemang ytterligare en gång till två av tre producenter`: gör en upprepad uppdatering för två producenter.
- `5.2.4 Ta bort engagemang till tre olika producenter`: tar bort engagemang från tre producenter.
- `5.2.5 Ta bort engagemang (som inte existerar)`: prövar borttagning av ett okänt engagemang.
- `5.2.6 Hantera engagemang där mostRecentContent saknas`: prövar uppdatering när posten saknar `mostRecentContent`.
- `5.3.1 Grundladdning (add) 2003 poster`: lägger in 2 003 poster i en grundladdning.
- `5.3.2 Grundladdning (delete) 2003 poster`: tar bort 2 003 poster genom grundladdning.
- `5.4.1 Skicka Update med två identiska poster (R1)`: prövar validering av dubbletter i Update.
- `5.4.2 Skicka Update med för många poster`: prövar gränsen för antal poster i Update.
- `5.4.3 Skicka Update med EI's reserverade logiska adress (R7)`: prövar avvisning av EI:s reserverade logiska adress.
- `5.4.4 Skicka Update med tre engagemang, ett engagemang bryter mot schemat`: prövar om ett felaktigt engagemang gör att Update avvisas.
- `5.4.5 Skicka ProcessNotification med tre engagemang, ett engagemang bryter mot schemat`: motsvarande schemafel vid ProcessNotification.
- `5.4.6 Skicka ProcessNotification med två identiska poster`: prövar dubblettvalidering för ProcessNotification.
- `5.4.7 Skicka ProcessNotification med för många poster`: prövar antalgräns för ProcessNotification.
- `5.4.8 Skicka ProcessNotification felaktigt med EI's reserverade logiska adress`: prövar reserverad adress i felaktigt ProcessNotification-anrop.
- `5.4.9 Skicka FindContent som är felaktig`: prövar validering av felaktigt FindContent-anrop.
- `5.4.10 Skicka en andra Update med äldre mostRecentContent`: prövar att en äldre version av innehållet inte skriver över nyare data.
- `5.5.1 Lägga till ett engagemang (Update), kontrollera notifieringar`: lägger till ett engagemang och kontrollerar att notifieringar skickas.
- `5.5.2 Lägga till flera engagemang (Update), kontrollera notifieringar`: samma notifieringskontroll för flera engagemang.
- `5.5.3 Uppdatera engagemang till tre olika producenter, kontrollera notifieringar`: kontrollerar notifieringar efter uppdatering för tre producenter.
- `5.5.4 Ta bort engagemang till tre olika producenter, kontrollera notifieringar`: kontrollerar notifieringar efter borttagning.
- `5.5.5 Hantera engagemang där mostRecentContent saknas, kontrollera notifieringar`: kontrollerar notifieringar när fältet saknas.
- `5.5.6 Uppdatera engagemang med ProcessNotification, kontrollera notifieringar`: verifierar notifiering efter uppdatering med ProcessNotification.
- `5.5.7 Ta bort engagemang med ProcessNotification, kontrollera notifieringar`: verifierar notifiering efter borttagning med ProcessNotification.
- `5.5.8 Förändra ägarskap för en post, namnbyte av regional owner, kontrollera notifieringar`: prövar notifieringar vid ägarbyte och namnbyte. **Inaktiv.**
- `5.5.9 Förändra ägarskap för poster från regionalt HSA till Ineras HSA, kontrollera notifieringar`: prövar notifieringar vid överföring av ägarskap. **Inaktiv.**
- `5.6.1 Uppdatera engagemang med ProcessNotification till tre olika producenter`: tar emot uppdatering riktad till tre producenter.
- `5.6.2 Ta bort engagemang med ProcessNotification till tre olika producenter`: tar emot borttagning riktad till tre producenter.
- `5.6.3 Förändra ägarskap för poster från Ineras HSA till regionalt HSA`: tar emot ändring av ägarskap från Inera till region.
- `5.6.4 Förändra ägarskap för en post, namnbyte av regional owner`: prövar ägarbyte med namnändring. **Inaktiv.**
- `5.6.5 Förändra ägarskap för poster från regionalt HSA till Ineras HSA`: tar emot ägarskapsändring till Inera. **Inaktiv.**
- `5.6.6 Förändra ägarskapet till tre olika producenter`: prövar ägarskapsändring för tre producenter. **Inaktiv.**
- `5.6.7 Hantera engagemang med ProcessNotification där mostRecentContent saknas`: tar emot ProcessNotification utan `mostRecentContent`.
- `5.7.1 Skicka FindContent utan optionella element`: prövar FindContent med endast nödvändiga element.
- `5.7.2 Skicka Update använd FindContent för samtliga optionella element`: prövar FindContent-villkor med samtliga optionella element.
- `5.7.3 Skicka FindContent med samtliga optionella element`: prövar FindContent med alla optionella element satta.

## Adaptertester

- `SKLTP-Adapter-Axel-soapui-project.BLOCK.xml`, suite `SKLTP-Axel`:
  - `SKLTP-Axel-SKV-register_certificate`: skickar SKV:s register-certificate-anrop via Axel-adaptern.
  - `SKLTP-Axel-SKV-revoke_certificate`: skickar SKV:s revoke-certificate-anrop via Axel-adaptern.
- `SKLTP-Adapter-FkCertProxy-soapui-project.xml`, suite `fk_cert_proxy`:
  - `FK CertProxy RegisterCertificate`: skickar RegisterCertificate via FK CertProxy-adaptern.

## REST- och endpointtester

### `SKLTP-REST-DomDB-soapui-project.xml`

- `DomDB API v1 - Read and Set Testrun Properties`: läser testmiljödata och sätter egenskaper för API v1-testkörningen.
- `DomDB API v1 - Liveness Swaggerfile`: gör liveness-/tillgänglighetskontroll mot API v1:s Swagger-fil.
- `DomDB API v1 - Read ServiceDomains`: läser service domains från API v1. **Inaktiv.**
- `DomDB API v2 - Read and Set Testrun Properties`: läser testmiljödata och sätter egenskaper för API v2-testkörningen.
- `DomDB API v2 - Liveness Swaggerfile`: gör liveness-/tillgänglighetskontroll mot API v2:s Swagger-fil.
- `DomDB API v2 - Read ServiceDomains`: läser service domains från API v2.
- `DomDB Domain Adminweb - Read and Set Testrun Properties`: läser inställningar för DomDB Domain AdminWeb. **Inaktiv.**
- `DomDB Domain Adminweb - Liveness Front Page`: kontrollerar att AdminWeb:s startsida går att nå. **Inaktiv.**

### `SKLTP-REST-Takapi-soapui-project.xml`

Testsviten innehåller genererade GET-/REST-testfall för TAK API v1 och v2. `readData` laddar testdata och miljöegenskaper; varje endpointfall skickar en GET mot den angivna resursen och kontrollerar det konfigurerade HTTP-svaret.

- `readData` i `SKLTP-takapi`: laddar data för v1. **Inaktiv.**
- Följande v1-resurstestfall finns men är **inaktiva**: `/connectionPoints TestCase`, `/connectionPoints/{id} TestCase`, `/cooperations TestCase`, `/cooperations/{id} TestCase`, `/installedContracts TestCase`, `/serviceConsumers TestCase`, `/installedContracts/{id} TestCase`, `/logicalAddresss TestCase`, `/logicalAddresss/{id} TestCase`, `/serviceConsumers/{id} TestCase`, `/serviceContracts TestCase`, `/serviceContracts/{id} TestCase`, `/serviceDomains TestCase`, `/serviceDomains/{id} TestCase`, `/serviceProducers/{id} TestCase`, `/serviceProductions TestCase`, `/serviceProductions/{id} TestCase`, `anropsadress_mm`.
- `readData` i `SKLTP-takapi-v2`: laddar data för v2.
- Följande v2-resurstestfall är **aktiva**: `/v2/connectionPoints TestCase`, `/v2/connectionPoints/{id} TestCase`, `/v2/cooperations TestCase`, `/v2/cooperations/{id} TestCase`, `/v2/installedContracts TestCase`, `/v2/serviceConsumers TestCase`, `/v2/installedContracts/{id} TestCase`, `/v2/logicalAddresses TestCase`, `/v2/logicalAddresses/{id} TestCase`, `/v2/serviceConsumers/{id} TestCase`, `/v2/serviceContracts TestCase`, `/v2/serviceContracts/{id} TestCase`, `/v2/serviceDomains TestCase`, `/v2/serviceDomains/{id} TestCase`, `/v2/serviceProducers/{id} TestCase`, `/v2/serviceProductions TestCase`, `/v2/serviceProductions/{id} TestCase`, `v2-anropsadress_mm`.

### `SKLTP-REST-Web-Accessibility-soapui-project.xml`

Suite `testURLar`: `readData` läser mål-URL:er; varje namngivet fall gör en nåbarhetskontroll mot tjänsten och transportvägen i namnet.

- `TAK-API v1 - Via apache https`: TAK API v1 via Apache över HTTPS. **Inaktiv.**
- `TAK-API v1 - Direct BKS https`: TAK API v1 direkt mot BKS över HTTPS. **Inaktiv.**
- `Tak-API v2 - Via apache https`: TAK API v2 via Apache över HTTPS.
- `Tak-API v2 - Direct BKS https`: TAK API v2 direkt mot BKS över HTTPS.
- `DomDB-API v1 - Via apache https`: DomDB API v1 via Apache över HTTPS. **Inaktiv.**
- `DomDB-API v1 - Direct BKS http`: DomDB API v1 direkt mot BKS över HTTP. **Inaktiv.**
- `DomDB-API v1 - Direct BKS https`: DomDB API v1 direkt mot BKS över HTTPS. **Inaktiv.**
- `DomDB-API v2 - Via apache https`: DomDB API v2 via Apache över HTTPS.
- `DomDB-API v2 - Direct BKS http`: DomDB API v2 direkt mot BKS över HTTP. **Inaktiv.**
- `DomDB-API v2 - Direct BKS https`: DomDB API v2 direkt mot BKS över HTTPS.
- `DomDB AdminWeb - Via apache http`: DomDB AdminWeb via Apache över HTTP. **Inaktiv.**
- `DomDB AdminWeb - Via apache https`: DomDB AdminWeb via Apache över HTTPS.
- `DomDB AdminWeb - Direct BKS https`: DomDB AdminWeb direkt mot BKS över HTTPS.
- `DomDB AdminWeb - Direct BKS http`: DomDB AdminWeb direkt mot BKS över HTTP. **Inaktiv.**
- `TAK-Web - Direct BKS http`: TAK Web direkt mot BKS över HTTP. **Inaktiv.**
- `TAK-Web - Direct BKS https`: TAK Web direkt mot BKS över HTTPS.
- `AAA - Direct BKS http`: AAA direkt mot BKS över HTTP. **Inaktiv.**
- `AAA - Direct BKS https`: AAA direkt mot BKS över HTTPS.
- `Axel - Direct BKS http`: Axel direkt mot BKS över HTTP. **Inaktiv.**
- `Axel - Direct BKS https`: Axel direkt mot BKS över HTTPS. **Inaktiv.**

## Körning

Öppna `soaptest/soapui-skltp-workspace.xml` i SoapUI för att navigera bland suites. Jenkins kör projektfamiljer via `soaptest/testrunner_all.sh`; enskilda fall kan köras från SoapUI. Testresultat beror på aktuell NTjP-testmiljö, miljödata, mockar och klientcertifikat.
