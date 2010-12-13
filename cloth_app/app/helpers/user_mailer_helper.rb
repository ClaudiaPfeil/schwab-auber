# To change this template, choose Tools | Templates
# and open the template in the editor.

module UserMailerHelper
  def format_article(article)
    tmp = article.split("\r\n")
    
    bank = tmp.first.split(":").second
    bank_conto  = tmp.second.split(":").second
    account_number = tmp.third.split(":").second

    return bank, bank_conto, account_number
  end
end
