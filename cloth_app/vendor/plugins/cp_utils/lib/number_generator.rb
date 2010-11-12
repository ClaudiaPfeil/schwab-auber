class NumberGenerator

  def self.alphanumeric(options = {})
    prefix = options[:prefix].to_s
    length = (options[:length] || 10) - prefix.size
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    ident = 1.upto(length).map { |i| chars[rand(chars.size - 1)] }
    prefix << ident.to_s
  end

  def self.timebased(prefix = nil)
    prefix.to_s + (Time.now.localtime.strftime("%y%m%d%H%M") + rand(99999).to_s.rjust(5, '0'))
  end

  def self.timebased_with_seconds(prefix = nil)
    prefix.to_s + (Time.now.localtime.strftime("%y%m%d%H%M%S") + rand(99999).to_s.rjust(5, '0'))
  end

  def self.password(size = 8)
    chars = (('a'..'z').to_a + ('A'..'Z').to_a + ('2'..'9').to_a) - %w(i I j J o O l L)
    (1..size).map{ |a| chars[rand(chars.size)] }.join
  end

end