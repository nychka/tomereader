 module Tomereader
   module Settings
     def create_logger
      logger = Logging.logger[self]
      logger.add_appenders(Logging.appenders.file('log/output.log'))
      return logger
    end
  end
end