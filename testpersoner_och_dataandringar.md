# Testpersoner och dataändringar

## Kort svar

Ja. SoapUI-projektet för Engagemangsindex (EI) använder testpersoners identifierare när det skapar, uppdaterar och tar bort engagemang. Det är EI:s engagemangsposter kopplade till identifieraren som ändras; testfallen ändrar inte personens personnummer.

## Överblick: testfall som skriver till EI

Följande inventering omfattar de SoapUI-teststeg i repot som skickar EI `Update`- eller `ProcessNotification`-anrop med personidentitet. `deleteFlag=false` skickar ett add-/uppdateringsanrop; `deleteFlag=true` begär borttagning. Även ett delete-steg kan påverka delad testdata. En FindContent-förfrågan är däremot läsande. Testfallen körs inte nödvändigtvis allihop vid varje jobb; tabellen beskriver vad konfigurationen försöker göra när respektive fall körs.

| Projekt och testfall | Vad skickas till EI | Städning och möjlig påverkan |
| --- | --- | --- |
| `SKLTP-EI`: `5.0.1`, `5.0.2` | Delete via Update respektive ProcessNotification för `patientId11`/`patientId12`. | Förberedande rensning; kan ta bort matchande engagemang som redan finns. |
| `SKLTP-EI`: `5.1.1`, `5.1.2` | Skapar ett engagemang för `patientId11`; separat fall tar bort ett engagemang. | Add och delete är separata testfall. |
| `SKLTP-EI`: `5.2.1`-`5.2.6` | Skapar och uppdaterar engagemang för `patientId11`, tar bort engagemang, testar borttagning av okänt engagemang och skapar/tar bort ett fall utan `mostRecentContent`. | Add/update-fall kan lämna data kvar om ett senare delete-fall inte körs. |
| `SKLTP-EI`: `5.3.1`, `5.3.2` | Add respektive delete för samma 2 003 personnummer, i batchar om 1 000, 1 000 och 3. | Två separata fall; delete är inte automatisk återställning om det inte körs efter add. |
| `SKLTP-EI`: `5.4.1`-`5.4.8` | Negativa/valideringsanrop: dubbletter, 1 001 poster, reserverad adress och felaktigt format/schema via Update eller ProcessNotification. | Avsedda att pröva avvisning. Om ett sådant anrop oväntat accepteras kan data ändras; granska resultatet. |
| `SKLTP-EI`: `5.4.9` | Innehåller ProcessNotification- och delete-anrop i testflödet med felaktig FindContent. | Har både skrivande anrop och borttagning; behandla som potentiellt ändrande, även om testets huvudsyfte är felhantering. |
| `SKLTP-EI`: `5.4.10` | Skickar en giltig Update och därefter en Update med äldre `mostRecentContent`. | Uppdaterar testdata; ingen separat efterföljande delete framgår av fallet. |
| `SKLTP-EI`: `5.5.1`-`5.5.3`, `5.5.6` | Add eller Update via Update/ProcessNotification för `patientId11`, följt av notifieringskontroll. | Vissa fall rensar före testet, men har ingen motsvarande delete efteråt; data kan bli kvar eller skrivas över. |
| `SKLTP-EI`: `5.5.4`, `5.5.7` | Delete via Update respektive ProcessNotification. | Tar bort engagemang; kan påverka data från tidigare körningar eller andra tester som delar identitet/ägare. |
| `SKLTP-EI`: `5.5.5` | Skapar och tar sedan bort engagemang utan `mostRecentContent`. | Har uttrycklig delete i sekvensen; avbrott före delete kan lämna data kvar. |
| `SKLTP-EI`: `5.6.1` | Förberedande rensning följd av create/update via ProcessNotification. | Ingen motsvarande efterföljande delete framgår; data kan bli kvar. |
| `SKLTP-EI`: `5.6.2` | Delete via ProcessNotification. | Tar bort matchande engagemang. |
| `SKLTP-EI`: `5.6.3` | Skapar engagemang, ändrar ägare och skickar delete-anrop. | Innehåller städsteg i sekvensen; ett avbrott kan förhindra att de körs. |
| `SKLTP-EI`: `5.6.7` | Skapar och tar bort engagemang utan `mostRecentContent`. | Har uttrycklig delete i sekvensen; avbrott före delete kan lämna data kvar. |
| `SKLTP-EI`: `5.7.1` | ProcessNotification följt av ProcessNotification-delete för `patientId12`. | Har uttrycklig delete i sekvensen; avbrott kan lämna data kvar. |
| `SKLTP-EI`: `5.7.2`, `5.7.3` | Först delete/rensning, därefter add/update och slutligen delete för `patientId12`. | Städar före och efter i normal sekvens; konkurrerande tester eller avbrott kan ändå påverka delad data. |
| `SKLTP-AgP-Hogkostnadsskydd`: `4.19.0 PRE - Sätt engagemang till känd ålder` | EI-Update med `deleteFlag=false` för nio identiteter: `patientId1`-`patientId4`, `patientId7`-`patientId10` och `patientId17`. | Ingen motsvarande delete finns i testfallet; engagemang kan ligga kvar. |
| `SKLTP-AgP-Tillstandsbeskrivning`: `4.3.13`, `4.3.14` | Add för `patientId1`, kör scenariot och skickar därefter delete. | Har uttrycklig städning efter scenariot; avbrott före delete kan lämna data kvar. |
| Inaktiva EI-fall: `5.5.8`, `5.5.9`, `5.6.4`-`5.6.6` | Testar ägarbyten via ProcessNotification och/eller Update för `patientId11`. | Alla är markerade `disabled="true"`; de körs inte i nuvarande konfiguration, men skulle skriva till EI om de aktiveras. |
| `SKLTP-Core-Functionality`: `Link producer with mock gemenlogiskadress` | Add och delete för `patientId16`. | Testfallet har `disabled="true"` och körs inte som aktivt fall i nuvarande projektkonfiguration. |

Detta är en inventering av konfigurerade anrop, inte bevis på att de har körts eller lyckats. EI-poster kan påverka andra projekt när de delar EI-miljö och samma personidentitet, producent/ägare och logiska adress. En förberedande rensning är inte en generell återställning: den kan ta bort poster som andra tester lagt in. FindContent-kontrollerna läser data och ändrar den inte. Se [testfallsinventeringen](test_cases.md) för projektens övriga, icke-skrivande testfall.

## Vilka testpersoner används?

Den bifogade listan innehåller **2 013 unika personnummer som förekommer i aktiva EI-skrivande requestars personidentitetsfält** i repot. Den är en sammanslagen lista, inte en uppgift om hur många personer ett visst testfall ändrar. Exempelvis använder 2 003 av numren grundladdningsfallen, medan andra testfall använder mindre delmängder. Listan omfattar inte inaktiverade skrivande fall och är baserad på request-konfiguration, inte körresultat.

Listan är framtagen från EI-skrivande requestar och testvärdena i `soaptest/data-sed.xml`; den innehåller inte dubbletter. `soaptest/test-personnummer.txt` är inte en fullständig källa till dessa värden; ändra därför inte enbart den filen och anta att det ändrar vilka personer testerna använder.

## Förslag: begränsa den bokade testmängden till 30

Om ni inte får boka 2 003 personer ska det nuvarande grundladdningstestet inte köras som det är. Det gäller specifikt testfallen **`5.3.1 Grundladdning (add) 2003 poster`** och **`5.3.2 Grundladdning (delete) 2003 poster`** i `soaptest/SKLTP-EI-soapui-project.xml`. Det första skickar add-anrop för 2 003 unika personnummer; det andra skickar delete-anrop för samma uppsättning. Anropen är uppdelade i grupper om 1 000, 1 000 och 3 poster.

Det bör vara möjligt att göra en variant som använder 30 bokade personer, men den testar inte längre samma datavolym. Det går inte att ersätta de 2 003 numren med 30 utan att även ändra payloads, stickprov och förväntningar.

### Rekommenderat upplägg

1. **Gör 30 bokade nummer till den enda tillåtna personmängden för normal EI-körning.** Inventera alla aktiva EI-anrop, inklusive förberedande rensning, notifieringar och mockrelaterade anrop, och säkerställ att de bara använder dessa nummer.
2. **Behåll funktionsfallen, men gör en 30-personers variant av `5.3.1`/`5.3.2` för normal körning.** Uppdatera både add- och delete-anropen samt FindContent-stickproven så de använder samma 30 personer. Ändra testnamn och assertioner så de tydligt anger 30, inte 2 003.
3. **Behåll 2 003-personersfallen endast om de fortfarande behövs och kan godkännas.** Kör dem separat, avsiktligt och först efter att miljöansvarig bekräftat att samtliga personer är bokade och att körningen inte stör andra projekt. Om bokningsgränsen är absolut ska `5.3.1` och `5.3.2` tas ur standardkörningen eller tas bort.
4. **Samordna återställning och körordning.** Kör add, verifiering och delete i följd, helst i en isolerad miljö. Kontrollera efter delete att testposterna inte längre finns. Kör inte samtidigt andra projekt som använder samma personer och EI-producent/ägare. Räkna inte med att efterföljande delete körs om körningen avbryts.

### Varför finns 2 003 nummer?

I `SKLTP-EI-soapui-project.xml` har `5.3.1` tre Update-anrop för 1 000, 1 000 respektive 3 poster. `5.3.2` skickar motsvarande delete-anrop. De unika personnumren ligger direkt i request-payloads; de skapas inte genom att läsa hela `test-personnummer.txt`. Det förklarar varför listan är så stor och varför en ändring behöver omfatta båda fallen och stickproven. Repo-konfigurationen visar inte varför det ursprungligen valdes just 2 003 eller vilket krav som motiverar volymen, så det bör bekräftas med testernas ägare innan volymtestet tas bort.

### Kontroller innan ändringen godkänns

- Kontrollera automatiskt att alla aktiva EI request-payloads använder högst de 30 bokade personnumren; leta särskilt efter fasta nummer i XML.
- Kontrollera att grundladdningsvarianten har exakt 30 unika personer, att add och delete använder samma personer och producent/ägare, och att stickproven bara avser dessa.
- Kör i en isolerad testmiljö: add → FindContent-verifiering → delete → FindContent-verifiering av frånvaro.
- Bekräfta med ansvariga för load-mocks, NTJP-MOCKS och EI om testdata och rensning delas med andra projekt. Samma personnummer kan förekomma i flera tjänster; bokning av ett nummer innebär inte automatiskt att dess EI-poster är isolerade.

## Avgränsning och försiktighet

Detta är en statisk genomgång av projektkonfigurationen, inte en logg från en faktisk körning. Den visar att testfallen är konfigurerade att skicka ändrande anrop, men inte om en viss körning lyckas eller exakt vilket tillstånd testmiljön har efteråt. Kör endast ändrande testfall mot avsedd NTjP-testmiljö och räkna med att testdata för de använda identifierarna kan påverkas.

Se även [README.md](README.md) för krav på miljö och testdata samt [test_cases.md](test_cases.md) för den fullständiga testfallsinventeringen.
