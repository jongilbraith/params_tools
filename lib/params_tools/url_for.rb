class ActionController::Base

  # For overriding url_for with an extra parameter of :preserve, which points to an
  # array of parameters which will be automatically passed on to the new url.
  def url_for_with_preserve(options = {})
    if options[:preserve].present? && options[:preserve].is_a?(Array)
      preserved_params = options.delete(:preserve)
      preserved_params.each do |param|
        options.merge!(param => params[param]) unless params[param].blank?
      end
    end

    url_for_without_preserve(options)
  end
  alias_method_chain :url_for, :preserve

end
