# subiektGtEanAutogenerator
Rozwiązanie umożliwiające generowanie oraz zapis kodów EAN do produktów w InsERT SubiekGT, można z łatwością użyć w innym systemie, np. Subiekt Nexo, lub Comarch Optima, Comarch XL itd.

## Instalacja przy użyciu [Microsoft SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
### Dodaj funkcję obliczającą cyfrę kontrolną
* Zrób kopię zapasową bazy danych programu (Subiekt GT)
* Uruchom SSMS
* Połącz się do bazy Subiekta
* Otwórz plik [./subiektGtEanAutogenerator/src/fnCyfraKontrolnaEan.sql]
* Alternatywnie otwórz nowe zapytanie SQL (CTRL+N) i wklej zawartość pow. pliku
* Wybierz bazę danych z Twoim subiektem
* Uruchom Query

### Dodaj trigger generujący kod EAN do wybranego produktu
* Otwórz plik [./subiektGtEanAutogenerator/src/trigger_tw__Towary_AutoEan]
* Alternatywnie otwórz nowe zapytanie SQL (CTRL+N) i wklej zawartość pow. pliku
* Wybierz bazę danych z Twoim subiektem
* Uruchom Query

## Działanie rozwiązania

Dodaj nowy towar testowy, w zakładce `Urządzenia` zaznacz `Otwarta cena w kasie fiskalnej`, zapisz nowo dodany towar.
Po ponownym otworzeniu karty towaru, w zakładce `Urządzenia` znajdziesz kod EAN. Subiek GT daje możliwość wydrukowania kodu na etykietach cenowych (i nie tylko).
Rozwiązanie doda również kod EAN do indeksu Subiekta, więc od razu po zapisaniu Towaru możesz wyszukać produkt w Subiekt Instynkt.

## Modyfikacje działania.
1. Zmiana serii kodów kreskowych.

W triggerze zmień
* `SET @seria='2000000'+'%';` na `SET @seria='[Przydzielony zakres kodów]'+'%';` 
* `IF @sEAN is null SET @sEAN='200000000001';` na `IF @sEAN is null SET @sEAN='[Pierwszy wolny kod z zakresu]';`
3. Zmiana flagi wyzwalającej autogenerowanie kodu EAN

W trigerze (linia 14):

`IF (UPDATE(tw_CenaOtwarta) and (SELECT tw_CenaOtwarta FROM inserted)>0)` zmień tw_CenaOtwarta na inne pole reprezentujące funkconalność, której nie używasz. Np. `[tw_WagaEtykiet]`, `[tw_SklepInternet]`, `[tw_SprzedazMobilna]`

