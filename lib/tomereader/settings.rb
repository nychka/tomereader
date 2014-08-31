 module Tomereader
   module Settings
     def create_logger(name=nil)
      name ||= 'output'
      logger = Logging.logger[self]
      logger.add_appenders(Logging.appenders.file("log/#{name}.log"))
      return logger
    end
  end
end