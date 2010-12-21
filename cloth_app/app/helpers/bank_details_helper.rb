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

    def get_price
      price = 0.0
      user = current_user
      membership = user.membership
      prices = Price.find_by_kind(membership)
      
      if user.is_premium?
        period = user.period
        case period
          when 3  :   price += prices.shipping
          when 6  :   price += prices.shipping
          when 12 :   price += prices.shipping - 1.0
        end
      else
        price += prices.shipping.to_f + prices.handling.to_f
      end
    end
end
