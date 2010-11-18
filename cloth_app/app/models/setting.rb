# 3.3.1 Persönliche Einstellungen
# Registrierte Nutzer sollen über ein Nutzer-Profil die Möglichkeit für folgende Einstellungen besitzen:
#* Vor- und Nachname
#* Anschrift bzw. Adresse
#* Anzeige-Option des eigenen Namens (wahlweise Vor- und Nachname, Vorname und erster Buchstabe des Nachnamens, nur Vorname, erster Buchstabe des
#   Vornamens und kompletter Nachname
#* Auswahl des Geschlechts (weiblich, männlich)
#* Angabe des Geburtsdatums
#* Angabe einer Telefon-Nummer

class Setting < ActiveRecord::Base
  
  belongs_to :profile
  
end
