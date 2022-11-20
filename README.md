kódování README.md UTF-8
1.část, informace k SQL dotazům
2.část, vyhodnocení 

====================================================================================
1.část
====================================================================================

Primární a sekundární tabulka

Spojení tabulek czechia_payroll a czechia_price pomocí JOIN - zde mě zajímají jen záznamy, u nichž je v obou tabulkách známý rok (a čtvrtletí). Plyne to ze zadání projektu. V základní tabulce není použito GROUP BY a agregační funkce, lepší mít data v původním rozlišení. Agregace může proběhnout při řešení zadaných otázek. JOIN czechia_payroll a czechia_price uděláno přes year a quarter kvůli velikosti konečné tabulky a smysluplnosti cen/mezd, které leží proti sobě v tabulce. Např. aby proti sobě neležely ceny z června se mzdami v prvním čtvrtletí, pokud by se někdo chtěl probírat tabulkou.

Připojení informací z číselníků pomocí LEFT JOIN - hodnota IS NULL v hlavních tabulkách může mít zvláštní význam a není žádoucí ji ztratit. Např. info z data.gov.cz
Tabulka czechia_payroll
odvetvi_kod
kód položky číselníku pro odvětví	
pokud není vyplněn, jedná se o úhrn za všechna odvětví

Z tabulky czechia_payroll by se měly brát buď jen záznamy s calculation_code = 100, nebo s calculation_code = 200. V agregačních funkcích by nebylo dobré míchat dohromady mzdy spočítané různými způsoby, navíc výsledná tabulka bude mít poloviční velikost. V tomto projektu byly vybrané záznamy s calculation_code = 100, v reálu by bylo nutné upřesnit calculation_code u zadavatele.

Chybějící data
czechia_payroll: 
industry_branch_code IS NULL - úhrn za všechna odvětví

czechia_price: 
region_code IS NULL - úhrn za celou ČR

countries:
continent: Timor-Leste (Asie); Guernsey, Jersey, Man (Normanské ostrovy, Evropa)
nemá významný vliv na výsledky, Normanské ostrovy vypadávají z tabulky secondary_table 

economies:
population:Kuvajt (Asie), Palestina (Asie), Eritrea (Afrika); a položky, kde country Not classified, kromě sloupce year všechny ostatni sloupce IS NULL
Kuvajt, Palestina, Eritrea jsou neevropské země, nemá vliv na řešení projektu. Bylo by užitečné dodatečně zjistit, co a proč jsou v tabulce economies záznamy, které mají vyplněný jen sloupec year.

secondary_table: 
GDP: Faroe Islands(2006-2009,2011-2018), Gibraltar(2006-2018), Liechtenstein(2006-2009,2011-2018)
gini: Albania(2006-2007,2009-2011,2013,2018), Andorra(2006-2018), Bosnia and Herzegovina(2006, 2008-2010, 2012-2018), Croatia(2006-2008), Faroe Islands(2006-2018), Germany(2017_2018), Gibraltar(2006-2018), Icelad(2018), Ireland(2018), Italy(2018), Liechtenstein(2006-2018), Monaco(2006-2018), Montenegro(2006-2011, 2017-2018), North Macedonia(2006-2008), San Marino(2006-2018), Serbia(2006-2011,2018), Slovakia(2017), United Kingdom(2018)
nemá vliv na řešení projektu, ze secondary_table jsou potřeba jen data pro ČR

úkol 1
Vytvoření pomocné tabulky, kde jsou spočítané meziroční změny mezd v jednotlivých odvětvích. V dalším kroku se hledají negativní meziroční přírůstky (= pokles) mezd. 

úkol 2
bez doplňujícího komentáře

úkol 3
Vytvoření pomocné tabulky s meziroční změnou cen potravin. Pro kontrolu tabulka obsahuje dílčí výsledky - posunutí položek o rok, rozdíl cen v Kč a konečně požadovaný rozdíl cen v %. Při výpočtu se jako 100 % bere cena v prvním roce porovnávané dvojice. Následují dotazy na změny cen.

úkol 4
Vytvoření dvou pomocných tabulek. V jedné meziroční změna mezd, ve druhé meziroční změna ceny potravin. Cena potravin zde použitá je spočítaná jako průměrná cena přes všechny kategorie potravin bez ohledu na jednotky (1 kg, 150 g, 1 l, 10 ks). V následujícím dotaze porovnání meziroční změny cen potravin a meziroční změny mezd.

úkol 5
Vytvoření pomocné tabulky sledující růst HDP v ČR. Ve sledovaném období došlo ve třech letech k meziročnímu nárůstu HDP o 5 %. Tyto roky jsou v dalším považované za roky s vysokých růstem HDP. V těch rokách a v rokách po nich následujících je zjišťovaná meziroční změna cen a mezd. Jako referenční hodnoty jsou použité zbývající roky. V úkolu se využívají tabulky _task_4_price a _task_4_pay z úkolu 4. 


===================================================================================
2.část
===================================================================================

1. Mzdy mezi roky 2006-2018 přechodně klesly ve 14 odvětvích z 19. Nejčastěji k poklesu mezd došlo mezi roky 2012 a 2013.
	Činnosti v oblasti nemovitostí			 		2012-2013
	Informační a komunikační činnosti 				2012-2013
	Kulturní, zábavní a rekreační činnosti 				2010-2011, 2012-2013
	Ostatní činnosti 						2009-2010
	Peněžnictví a pojišťovnictví 					2012-2013
	Profesní, vědecké a technické činnosti 				2009-2010, 2012-2013
	Stavebnictví 							2012-2013
	Těžba a dobývání 						2008-2009, 2012-2013, 2013-2014, 2015-2016
	Ubytování, stravování a pohostinství 				2008-2009, 2010-2011
	Velkoobchod a maloobchod; opravy a údržba motorových vozidel	2012-2013
	Veřejná správa a obrana; povinné sociální zabezpečení 		2009-2010, 2010-2011
	Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu 	2012-2013, 2014-2015
	Vzdělávání 							2009-2010
	Zásobování vodou; činnosti související s odpady a sanacemi 	2012-2013


2. V roce 2006 bylo možné za průměrnou mzdu koupit 1171.01 kg chleba a 1307.25 l mléka.
V roce 2018 bylo možné za průměrnou mzdu koupit 1279.05 kg chleba a 1564.29 l mléka.

3. Meziroční změny cen u všech potravin ve sledovaném období kolísají - jsou kladné, meziroční zdražení, i záporné, meziroční zlevnění. 
Při srovnání cen v roce 2006 a 2018 nejvíc zlevnil (měl největší negativní nárůst ceny) cukr, o 27.52 %. Pokud by se bral v úvahu jen kladný nárůst cen, nejméně v roce 2018 oproti roku 2006 zdražily banány, o 7.36 %
Nejvyšší meziroční pokles (negativní nárůst) byl u ceny rajčat v letech 2006-2007, a to 30.28 %.
Nejmenší kladný nárůst byl u ceny rostlinného tuku - 0.01 % mezi roky 2008 a 2009.
Potřebovala bych si blíže upřesnit se zadavatelem, co se chce dozvědět.

4. Rok, kdy by meziroční nárůst cen potravin byl výrazně vyšší než růst mezd ve sledovaném období 2006-2018 neexistuje. V letech 2008-2009 se sice objevil rozdíl přes 10 % mezi změnou cen potravin a změnou výše mzdy, ovšem ceny meziročně klesly o 6.81 % a mzdy vyrostly o 4.16 %. 

5. V letech 2007, 2015 a 2017 byl meziroční růst HDP o 5 %. Tyto roky jsou považované za roky s velkým nárůstem HDP. Meziroční změna cen a mezd je hodnocena pro roky 2007 a 2008, 2015 a 2016, 2017 a 2018. Jako referenční hodnoty slouží údaje o mzdách a cenách v letech 2009-2014. 
V refrenčních letech rostly ceny meziročně v rozmezí -6.81 % (pokles) až 6.94 %. K výraznějšímu meziročnímu růstu ceny došlo v roce 2017, a to o 9.98 %. Ostatní sledované roky (2007-2008, 2015-2016 a 2018) se od referenčních let nelišily.
Mzdy v referenčních letech rostly o -0.14 % (pokles) až 4.16 %. Výraznější růst mezd se objevil v letech 2007-2008 a v letech 2017-2018. V období 2015-2016 se růst mezd od referenčních období nelišil.
Závěr nelze potvrdit, že by růst HDP měl vliv na ceny ve stejném roce  roce následujícím. Je možné, že rostoucí HDP vede ke zvýšení mezd. 
 