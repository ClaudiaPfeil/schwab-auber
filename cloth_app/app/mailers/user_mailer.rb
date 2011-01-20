class UserMailer < ActionMailer::Base
  include Cms

  def signup_notification(user)
    setup_email(user.reload)
    @subject    += I18n.t('subject_signup')
    @url  = "http://#{::SITE_URL}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += I18n.t('subject_activation')
    @url  = "http://#{::SITE_URL}/"
  end

  def order_cartons(user)
    setup_admin_email(user)
    @subject    += user.first_name + " " + user.last_name + I18n.t('user_order_cartons')
  end

  def cancel_info(user)
    setup_admin_email(user)
    @subject  +=  user.first_name + " " + user.last_name
    @subject  +=  user.is_premium? ? I18n.t('user_canceled_membership')  : I18n.t('user_canceled_membership_to') + formatted_date(user.membership_ends) + I18n.t('user_canceled')
  end

  def send_invitation(friend, user)
    setup_friend_email(friend, user)
    @subject    += I18n.t('subject_invitation')
    @url  = "http://#{::LANDING_URL}?id=#{user.id}"
    @friend =  friend
  end

  def remember_prepayment(payment, user)
    setup_remember_prepayment(user, payment)
    @subject  += I18n.t('subject_remember_prepayment')
    @message  = payment[:message]
    @bank = get_content("BankDetails")
  end

  def forgot_password(user)
    setup_email(user)
    @subject += I18n.t('reset_password')
    @user = user
    @link = "http://#{::SITE_URL}/" + "reset_password/" + user.id.to_s
  end

  def send_contact(user)
    setup_contact_email(user)
    @subject += I18n.t('get_in_contact')
    @user = user
  end
  
  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "KidsKarton.de"
    @subject     = "[#{::SITE_URL}] "
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
    @from        = "#{user.first_name} #{user.last_name}"
    @subject     = "[#{::SITE_URL}] "
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

end
