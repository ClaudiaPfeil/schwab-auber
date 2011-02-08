class UserMailer < ActionMailer::Base
  include Cms
  include ActionView::Helpers::UrlHelper

  def signup_notification(user)
    setup_email(user.reload)
    @url  = link_to 'Jetzt Registrierung bestätigen!', "http://#{::SITE_URL}/activate/#{user.activation_code}"
    @content_type = 'text/html'
  end
  
  def activation(user)
    setup_email(user)
    @subject    += I18n.t('subject_activation')
    @url  = link_to 'unserer Seite', "http://#{::SITE_URL}/"
    @content_type = 'text/html'
  end

  def order_cartons(user)
    setup_admin_email(user)
    @subject    += user.first_name + " " + user.last_name + I18n.t('user_order_cartons')
  end

  def cancel_info(user)
    setup_admin_email(user)
    @subject  =  "KidsKarton.de - Kunde hat gekündigt"
    @user = user
  end

  def send_invitation(friend, user)
    setup_friend_email(friend, user)
    @subject    += I18n.t('subject_invitation')
    @url  = link_to 'Registieren Sie sich hier kostenlos', "http://#{::LANDING_URL}?id=#{user.id}"
    @friend =  friend
    @content_type = 'text/html'
  end

  def remember_prepayment(payment, user)
    setup_remember_prepayment(user, payment)
    @subject  += I18n.t('subject_remember_prepayment')
    @message  = payment[:message]
    @bank = get_content("BankDetails")
  end

  def forgot_password(user)
    setup_email(user)
    @subject = "KidsKarton.de – Passwort neu vergeben."
    @user = user
    @link = link_to 'Klicken Sie bitte hier um sich ein neues Passwort zu vergeben', "http://#{::SITE_URL}/" + "reset_password/" + user.id.to_s
    @content_type = 'text/html'
  end

  def send_contact(user)
    setup_contact_email(user)
    @subject += I18n.t('get_in_contact')
    @user = user
    @content_type = 'text/html'
  end

  def send_package_ordered_email(user, receiver, package, coupon)
    setup_info_order_email(user)
    @user = user
    @receiver = receiver
    @package = package
    @coupon  = coupon
  end
  
  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "info@kidskarton.de"
    @subject     = "KidsKarton Konto Aktivierung"
    @sent_on     = Time.now
    @user = user
  end

  def setup_admin_email(user)
    @recipients  = "info@kidskarton.de"
    @from        = "#{user.email}"
    @subject     = "[#{::SITE_URL}] "
    @sent_on     = Time.now
    @user = user
  end

  def setup_friend_email(friend, user)
    @recipients  = friend[:friends_email]
    @from        = "info@kidskarton.de"
    @subject     = "Einladung: KidsKarton.de – die Online Tauschbörse für Kinderbekleidung!"
    @sent_on     = Time.now
    @user = user
  end

  def setup_remember_prepayment(user, payment)
    @recipients  = user.email || payment[:email]
    @from        = "KidsKarton.de"
    @subject     = "[#{::SITE_URL}] "
    @sent_on     = Time.now
    @user        = user
  end

  def setup_contact_email(user)
    @recipients  = "info@kidskarton.de"
    @from        =  user[:email]
    @subject     = "[#{::SITE_URL}] "
    @sent_on     = Time.now
    @user = user
  end

  def setup_info_order_email(user)
    @recipients  =  user.email
    @from        = "info@kidskarton.de"
    @subject     = "Ihr Kleiderpaket wurde bestellt - bitte jetzt versenden!"
    @sent_on     = Time.now
    @user = user
  end

end
