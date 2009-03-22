class Object
  # Like Object#try, but lets you do stuff like:
  #
  # user.email.or_if_blank("no email")
  #
  def or_if_blank(val)
    if self.respond_to? :blank?
      self.blank? ? val : self
    else
      self
    end
  end
end
