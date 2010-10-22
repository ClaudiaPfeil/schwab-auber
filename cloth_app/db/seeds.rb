# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

categories = Category.create([{ :name => 'LandingPage', :description => 'Offline Optimierung der SEO, dh. Werbung durch Verlinkung von anderen Websites erhöht die Wahrscheinlichkeit der erfolgreichen Suche.'},
                              { :name => 'Welcome',     :description => 'Startseite des Tauschportals, hier sollte eine kurze Erklärung des Portals und eine Anleitung der Bedienung zu finden sein.'},
                              { :name => 'Packages',    :description => 'Zusammenstellen und Bestellen von Kleiderpacketen'},
                              { :name => 'Search',      :description => 'Suche nach den Kleiderpacketen'},
                              { :name => 'Impressum',   :description => 'notwendig nach §5 Teledienstgesetz zur Angabe der Herkunft der Publikation'},
                              { :name => 'Bank',        :description => 'Verwalten des Kontos'},
                              { :name => 'Profiles',    :description => 'Verwalten des eigenen Nutzerprofiles'}
                             ])
