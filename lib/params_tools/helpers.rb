module ParamsTools
  module Helpers
  
    # Used for checking a param has the right settings, and initialising it if it's not set.
    #
    # The following will check param[:cars] and if it's not set initialise it to the default,
    # :bugatti_veyron. If it is set but is not in the allowed array it'll also get set to the
    # default log that it had to update it (info).
    #
    # If you get a request with a parameter in forbidden, it'll also raise a log, at warn level.
    #
    #   check_param(:cars) do |param|
    #     param.default   = :bugatti_veyron
    #     param.allowed   = [:bugatti_veyron, :pagani_zonda, :suzuki_liana, :chevrolet_lacetti]
    #     param.forbidden = [:dacia_sandero, :vampire_jet_car]
    #   end
    #
    def check_param(name, &block)
      param = ParamsDetails.new(name.to_sym)
      yield param
    
      params[param.name] = param.default if params[param.name].blank?
      
      if param.forbidden.collect(&:to_s).include?(params[param.name].to_s)
        logger.warn("WARNING - request received with forbidden param - param[#{param.name}] was set to #{params[param.name]}")
        params[param.name] = param.default
      elsif !param.allowed.collect(&:to_s).include?(params[param.name].to_s)
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
