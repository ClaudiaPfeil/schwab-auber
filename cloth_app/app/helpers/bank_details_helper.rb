# To change this template, choose Tools | Templates
# and open the template in the editor.

module BankDetailsHelper
    # Einfügen einer neuen Zeile zwischen der Kontoverbindung
    def format_article(article)
      tmp = article.split("\r\n")
      bank = tmp.first
      bank_conto  = tmp.second
      account_number = tmp.third

      @content = content_tag(:br, bank)
      @content << content_tag(:br, bank_conto)
      @content << content_tag(:br, account_number)

      @content
    end

    def check_role(role)
      current_user.is? role.to_sym
    end
end
