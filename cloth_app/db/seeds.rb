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
categories = Category.create([{ :name => 'Landing_Page', :description => 'Offline Optimierung der SEO, dh. Werbung durch Verlinkung von anderen Websites erhöht die Wahrscheinlichkeit der erfolgreichen Suche.'},
                              { :name => 'Welcome',     :description => 'Startseite des Tauschportals, hier sollte eine kurze Erklärung des Portals und eine Anleitung der Bedienung zu finden sein.'},
                              { :name => 'Packages',    :description => 'Zusammenstellen und Bestellen von Kleiderpacketen'},
                              { :name => 'Search',      :description => 'Suche nach den Kleiderpacketen'},
                              { :name => 'Impressums',  :description => 'notwendig nach §5 Teledienstgesetz zur Angabe der Herkunft der Publikation'},
                              { :name => 'Banks',       :description => 'Verwalten des Kontos'},
                              { :name => 'Profiles',    :description => 'Verwalten des eigenen Nutzerprofiles'},
                              { :name => 'Helps',       :description => 'Hilfe für die Nutzer'},
                              { :name => 'Contacts',    :description => 'Kontakt aufnehmen über Kontaktformular'},
                              { :name => 'Signup',      :description => 'Registrieren'},
                              { :name => 'Logout',      :description => 'Abmelden vom System'},
                              { :name => 'Login',       :description => 'Anmelden am System'},
                              { :name => 'Users',       :description => 'Nutzer für Nutzerverwaltung'}
                             ])
