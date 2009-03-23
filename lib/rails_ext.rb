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

module ActiveRecord
  module RailsExt

    module ClassMethods
      def blank?
        count == 0
      end

      alias empty? blank?
    end

  end
end

ActiveRecord::Base.extend ActiveRecord::RailsExt::ClassMethods

module ActiveRecord
  class Base
   protected
    def scoped_methods #:nodoc:
      Thread.current[:"#{self}_scoped_methods"] ||= (self.default_scoping || []).dup
    end
  end
end
