module FriendlyId
  # These methods will be added to the model's {FriendlyId::Base#relation_class relation_class}.
  module FinderMethods

    protected

    # FriendlyId overrides this method to make it possible to use friendly id's
    # identically to numeric ids in finders.
    #
    # @example
    #  person = Person.find(123)
    #  person = Person.find("joe")
    #
    # @see FriendlyId::ObjectUtils
    def find_one(id)
      encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => '',        # Use a blank for those replacements
        :universal_newline => true       # Always break lines with \n
      }
      id = id.encode(Encoding.find('ASCII'), encoding_options)
      return super if id.unfriendly_id?
      where(@klass.friendly_id_config.query_field => id).first or super
    end

    # FriendlyId overrides this method to make it possible to use friendly id's
    # identically to numeric ids in finders.
    #
    # @example
    #  person = Person.exists?(123)
    #  person = Person.exists?("joe")
    #  person = Person.exists?({:name => 'joe'})
    #  person = Person.exists?(['name = ?', 'joe'])
    #
    # @see FriendlyId::ObjectUtils
    def exists?(id = false)
      encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => '',        # Use a blank for those replacements
        :universal_newline => true       # Always break lines with \n
      }
      id = id.encode(Encoding.find('ASCII'), encoding_options) unless id
      return super if id.unfriendly_id?
      super @klass.friendly_id_config.query_field => id
    end
  end
end
