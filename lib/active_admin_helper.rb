class ActiveAdminHelper
  class << self
    # YES_NO_COLLECTION = [[true.humanize, true], [false.humanize, false]].freeze

    # def yes_no_collection
    #   YES_NO_COLLECTION
    # end

    # def hash_to_collection(hash)
    #   hash.map { |k,v| [v,k] }
    # end

    def folder_collection(id: nil)
      model_collection(Folder, :id => id)
    end

    # This function offers two ways to custom displayed text:
    # - a block can be provided to format the value shown. Param will be the item name to transform
    # - the `formatter` param: function on the given field (e.g: `:titleize`, `:humanize`)
    def model_collection(model, field: :name, extra_option: false, formatter: nil, id: nil)
      query = generate_id_union_query(model, id, field)
      query = query.select([:id, field]).order(field)
      query_collection(query, :extra_option => extra_option) do |o|
        if block_given?
          yield(o)
        elsif formatter.present?
          o.read_attribute(field).try(formatter)
        else
          o.read_attribute(field)
        end
      end
    end

    # A block is expected to format the value to display.
    # That block will receive the resource as a parameter and will return the text to display
    def query_collection(query, extra_option: false)
      process_extra_option(query.map { |o| [yield(o), o.id] }, :option => extra_option)
    end

    # Allow to return a collection based on a single field on a model
    # A block can be provided to form the value to display
    def unique_field_collection(model, field)
      # values = Rails.cache.fetch("#{model.to_s}/#{field.to_s}/unique_field_collection", :expires_in => 10.minutes) do
      values = model.order(field).pluck(field).uniq
      # end

      values.map { |value| [block_given? ? yield(value) : value, value] }
    end

    # prepend an option in the dropdown collection
    # NOTE, when using this trick, two other steps need to be taken:
    # - create/edit a scope following the naming ActiveAdmin naming convention that will handle the value of the extra option
    # - add the `search_methods` directive to register the filter
    def process_extra_option(collection, option: false)
      return collection unless option.present?

      [generate_option(option)] + collection
    end

    # `option` can either:
    # - be a hash with the keys `:text` and/or `:value`
    # - any other value. It will be converted to an empty hash to use default values
    def generate_option(option)
      text, value = (option.is_a?(Hash) ? option : {}).values_at(:text, :value)
      [text.presence || 'Not Set', value.presence || 0]
    end

    def generate_id_union_query(query, id, field)
      # in case `id` is the actual object instead of its ID
      id = id.id if id.respond_to?(:id) && id.class != NilClass
      # if no ID is/are given, no need to build a UNION query
      return query unless id.present?

      # UNION query
      fields = [:id, field]
      model = query.respond_to?(:klass) ? query.klass : query
      model.from("(#{query.select(fields).to_sql} UNION #{model.select(fields).where(:id => id).to_sql}) AS u")
    end
  end
end
