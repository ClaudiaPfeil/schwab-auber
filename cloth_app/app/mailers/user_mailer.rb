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
    @subject    += I18n.t(:order_more_cartons)
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
    @recipients  = "info@kidskarton.de"
    @from        = "#{user.email}"
    @subject     = "[#{SITE_URL}] "
    @sent_on     = Time.now
    @user = user
  end

end
