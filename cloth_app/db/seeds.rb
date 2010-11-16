# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
if Category.count > 0
  Category.delete_all
  Category.connection.execute("ALTER TABLE categories AUTO_INCREMENT = 1")
end
categories = Category.create([
                              { :name => 'Contact',       :description => 'Kontakt aufnehmen über Kontaktformular'},
                              { :name => 'Help',          :description => 'Hilfe für die Nutzer'},
                              { :name => 'Impressum',     :description => 'notwendig nach §5 Teledienstgesetz zur Angabe der Herkunft der Publikation'},
                              { :name => 'Logout',        :description => 'Abmelden vom System'},
                              { :name => 'Login',         :description => 'Anmelden am System'},
                              { :name => 'LandingPage',   :description => 'Offline Optimierung der SEO, dh. Werbung durch Verlinkung von anderen Websites erhöht die Wahrscheinlichkeit der erfolgreichen Suche.'},
                              { :name => 'Order',         :description => 'Bestellungen von Kleiderpaketen'},
                              { :name => 'Package',       :description => 'Zusammenstellen und Bestellen von Kleiderpaketen'},
                              { :name => 'Profile',       :description => 'Verwalten des eigenen Nutzerprofiles'},
                              { :name => 'Search',        :description => 'Suche nach den Kleiderpaketen'},
                              { :name => 'Signup',        :description => 'Registrieren'},
                              { :name => 'User',          :description => 'Nutzer für Nutzerverwaltung'},
                              { :name => 'Welcome',       :description => 'Startseite des Tauschportals, hier sollte eine kurze Erklärung des Portals und eine Anleitung der Bedienung zu finden sein.'}
                             ])
