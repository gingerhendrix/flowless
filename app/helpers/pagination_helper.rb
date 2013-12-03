module PaginationHelper

  def render_pagination(objects)
    render partial: "layouts/pagination", locals: { objects: objects }
  end

  def page_entries_info(collection, options = {})
    i18n_scope = [ :views, :page_entries_info ]
    count      = get_count(collection, options)
    entry_name = get_entry_name(collection, options)

    if count < 2
      case count
      when 0; t('no_objects_found', :objects => entry_name, :scope => i18n_scope)
      when 1; t('showing_1_object', :objects => entry_name.capitalize, :scope => i18n_scope)
      else;   t('showing_all_count_objects', :count => count,
                                            :objects => entry_name.pluralize.capitalize,
                                            :scope => i18n_scope)
      end
    else
      to_end = collection.options[:skip] + collection.options[:limit]
      to_end = count if to_end > count
      I18n.t('showing_from_to_of_total_objects', :objects => entry_name.pluralize.capitalize,
                                                :from => collection.options[:skip] + 1,
                                                :to => to_end,
                                                :total => count,
                                                :scope => i18n_scope)
    end
  end

  private

    def get_entry_name(collection, options)
      if collection.is_a? Kaminari::PaginatableArray
        get_array_entry_name(collection, options)
      elsif collection.is_a? Array
        get_array_entry_name(collection, options)
      else
        options[:entry_name] || collection.model_name.human
      end
    end

    def get_count(collection, options)
      if collection.is_a? Kaminari::PaginatableArray
        collection.instance_variable_get(:@_total_count).to_i
      elsif collection.is_a? Array
        collection.options[:count]
      else
        collection.embedded? ? get_embed_collection_count(collection) : collection.count
      end
    end

    def get_array_entry_name(collection, options = {})
      options[:entry_name] || (collection.empty? ? t('object', scope: i18n_scope) : collection.first.class.name.underscore.sub('_', ' '))
    end

    def get_embed_collection_count(collection)
      crit = collection.dup
      crit.options.delete :limit
      crit.options.delete :skip
      crit.count
    end

end
