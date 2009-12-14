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

class Array
  def odd
    new_guy = self.class.new
    self.each_with_index {|item,n| new_guy << item if n % 2 == 1 }

    new_guy
  end

  def even
    new_guy = self.class.new
    self.each_with_index {|item,n| new_guy << item if n % 2 == 0 }

    new_guy
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

class ActiveRecord::Base
  class << self
    def scoped_methods #:nodoc:
      Thread.current[:"#{self}_scoped_methods"] ||= (self.default_scoping || []).dup
    end
  end
end

class ActiveRecord::Errors
  def remove(k)
    @errors.delete(k)
  end
end

class ActiveRecord::Errors
  def full_messages
    full_messages = []

    @errors.each_key do |attr|
      @errors[attr].each do |msg|
        next if msg.nil?

        msg_text = case msg
                   when ActiveRecord::Error
                     msg.message
                   else
                     msg.to_s
                  end

        if attr == "base" || msg_text =~ /^[[:upper:]]/
          full_messages << msg_text
        else
          full_messages << @base.class.human_attribute_name(attr) + " " + msg_text
        end
      end
    end
    full_messages
  end
end


