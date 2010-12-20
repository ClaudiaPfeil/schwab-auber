# To change this template, choose Tools | Templates
# and open the template in the editor.

# Löschen der gekündigten Premium Mitgliedschaften
every 24.hours do runner
  User.destroy_premiums
end
