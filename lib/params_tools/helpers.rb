module ParamsTools
  module Helpers
  
    # Used for checking a param has the right settings, and initialising it if it's not set.
    #
    # The following will check param[:cars] and if it's not set initialise it to the default,
    # :bugatti_veyron. If it is set but is not in the allowed array it'll also get set to the
    # default and log that it had to update it (info).
    #
    # If you get a request with a parameter in forbidden, it'll also raise a log, but at warn level.
    #
    # You have two choices on syntax - a block style:
    #
    #   check_param(:cars) do |param|
    #     param.default   = :bugatti_veyron
    #     param.allowed   = [:bugatti_veyron, :pagani_zonda, :suzuki_liana, :chevrolet_lacetti]
    #     param.forbidden = [:dacia_sandero, :vampire_jet_car]
    #   end
    #
    # Or a single line options hash style syntax:
    #   check_param(:cars, :default => :bugatti_veyron,
    #                      :allowed => [:bugatti_veyron, :pagani_zonda, :suzuki_liana, :chevrolet_lacetti],
    #                      :forbidden => [:dacia_sandero, :vampire_jet_car])
    #
    def check_param(name, options = {}, &block)
      param = ParamsDetails.new(name.to_sym)
      
      # Apply the settings applied through an options hash
      param.default   = options[:default].to_s if options[:default].present?
      param.allowed   = options[:allowed].collect(&:to_s) if options[:allowed].present?
      param.forbidden = options[:forbidden].collect(&:to_s) if options[:forbidden].present?

      # Or get the settings from the params has if preferred
      yield param if block_given?
    
      params[param.name] = param.default if params[param.name].blank?
      
      if param.forbidden.include?(params[param.name])
        logger.warn("WARNING - request received with forbidden param - param[#{param.name}] was set to #{params[param.name]}")
        params[param.name] = param.default
      elsif !param.allowed.include?(params[param.name])
        logger.info("WARNING - request received with disallowed param - param[#{param.name}] was set to #{params[param.name]}")
        params[param.name] = param.default
      end
    end
    
    class ParamsDetails
    
      attr_accessor :name
    
      attr_accessor :default
    
      attr_accessor :allowed
    
      attr_accessor :forbidden
    
      def initialize(name)
        @name      = name
        @allowed   = []
        @forbidden = []
      end
    
    end

  end
end
