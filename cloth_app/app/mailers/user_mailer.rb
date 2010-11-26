class UserMailer < ActionMailer::Base

  def signup_notification(user)
    setup_email(user.reload)
    @subject    += I18n.t('subject_signup')
    @url  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += I18n.t('subject_activation')
    @url  = "http://#{SITE_URL}/"
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
  
  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "KidsKarton.de"
    @subject     = "[#{SITE_URL}] "
    @sent_on     = Time.now
    @user = user
  end

  def setup_admin_email(user)
    @recipients  = "info@claudia-pfeil.com"#"info@kidskarton.de"
    @from        = "#{user.email}"
    @subject     = "[#{SITE_URL}] "
    @sent_on     = Time.now
    @user = user
  end

end
