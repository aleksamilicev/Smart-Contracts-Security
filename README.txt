# OWASP Top 10 Smart Contract Security Vulnerabilities

## **Opis Projekta**

Ovaj projekat ima za cilj implementaciju i demonstraciju sigurnosnih mera za zaštitu pametnih ugovora prema OWASP Smart Contract Top 10 standardu. Svaka ranjivost iz ovog vodiča biće objašnjena, ilustrovana primerom, i za nju će biti predložena odgovarajuća rešenja.

---

## **OWASP Top 10 Ranjivosti i Rešenja**

1. **Reentrancy Attack (SC01)**  
   - **Opis:** Ranjivost omogućava napadaču da izvrši više povratnih poziva pre nego što se stanje ugovora ažurira.  
   - **Rešenja:**  
     - Koristiti "Checks-Effects-Interactions" obrazac.  
     - Koristiti `ReentrancyGuard` ili mutex lock.  
     - Koristiti `transfer` umesto `call` za slanje Ether-a.

2. **Integer Overflow and Underflow (SC02)**  
   - **Opis:** Greške u aritmetici mogu dovesti do neočekivanih rezultata, poput prelivanja vrednosti.  
   - **Rešenja:**  
     - Koristiti `SafeMath` biblioteku.  
     - Koristiti Solidity verziju 0.8 ili noviju koja ima ugrađene zaštite.

3. **Timestamp Dependence (SC03)**  
   - **Opis:** Manipulacija `block.timestamp` može omogućiti napade na vremenski zavisne funkcije.  
   - **Rešenja:**  
     - Koristiti spoljne izvore vremena.  
     - Validirati vreme sa više blokova ili koristiti broj blokova umesto vremena.

4. **Access Control Vulnerabilities (SC04)**  
   - **Opis:** Omogućava neovlašćeni pristup funkcijama ili podacima ugovora.  
   - **Rešenja:**  
     - Implementirati modifiere za kontrolu pristupa.  
     - Koristiti višeslojnu autorizaciju i proveru vidljivosti funkcija.

5. **Front-running Attacks (SC05)**  
   - **Opis:** Napadač presreće transakciju i izvršava svoju pre korisničke transakcije koristeći veći `gas` fee.  
   - **Rešenja:**  
     - Dizajnirati ugovore koji ne zavise od `gas price`.  
     - Koristiti "commit-reveal" obrazac.

6. **Denial of Service (DoS) Attacks (SC06)**  
   - **Opis:** Napadi koji iscrpljuju resurse ugovora, poput `gas` limita ili skladišta.  
   - **Rešenja:**  
     - Ograničiti složenost funkcija i iteracija.  
     - Implementirati timeout mehanizme.  
     - Koristiti fallback funkcije pažljivo.

7. **Logic Errors (SC07)**  
   - **Opis:** Greške u poslovnoj logici ugovora koje omogućavaju eksploataciju.  
   - **Rešenja:**  
     - Rigorozno testiranje i nezavisne provere koda.  
     - Validacija ulaznih vrednosti.

8. **Insecure Randomness (SC08)**  
   - **Opis:** Slaba generacija nasumičnih brojeva omogućava predvidivost rezultata.  
   - **Rešenja:**  
     - Koristiti off-chain generisanje slučajnosti.  
     - Kombinovati različite nepredvidive podatke.

9. **Gas Limit Vulnerabilities (SC09)**  
   - **Opis:** Iscrpljivanje `gas` limita funkcija može dovesti do neuspeha transakcija.  
   - **Rešenja:**  
     - Batch obrada podataka.  
     - Ograničavanje iteracija.  
     - Premestiti obradu u off-chain.

10. **Unchecked External Calls (SC10)**  
    - **Opis:** Neproverene eksterne funkcije mogu uzrokovati neispravno ponašanje ugovora.  
    - **Rešenja:**  
      - Koristiti `try/catch` za proveru povratnih vrednosti.  
      - Koristiti `require` za validaciju rezultata eksternih poziva.

---

## **Cilj Projekta**

- Edukacija o sigurnosnim ranjivostima u pametnim ugovorima.  
- Implementacija proverenih rešenja za zaštitu pametnih ugovora od poznatih napada.

---

## **Contributions**

Dobrodošao je doprinos zajednice! Ako imate predloge za poboljšanje, slobodno otvorite **Issue** ili pošaljite **Pull Request**.

---

## **Izvori**

- [OWASP Smart Contract Top 10](https://owasp.org/www-project-smart-contract-top-10/#)  
- Dokumentacija za Solidity: [Solidity Docs](https://docs.soliditylang.org/)  
- Etherscan Blog: [Blockchain Security](https://etherscan.io/)

---

## **Kontakt**

Za pitanja ili predloge:  
**Email:** [amilicev92@gmail.com]  
**GitHub:** [aleksamilicev](https://github.com/aleksamilicev)
