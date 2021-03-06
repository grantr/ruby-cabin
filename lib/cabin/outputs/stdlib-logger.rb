require "cabin"
require "json"

# Wrap Ruby stdlib's logger. This allows you to output to a normal ruby logger
# with Cabin. Since Ruby's Logger has a love for strings alone, this 
# wrapper will convert the data/event to json before sending it to Logger.
class Cabin::Outputs::StdlibLogger
  public
  def initialize(logger)
    @logger = logger
    @logger.level = logger.class::DEBUG
  end # def initialize

  # Receive an event
  public
  def <<(event)
    if !event.include?(:level)
      event[:level] = :info
    end
    method = event[:level].downcase.to_sym || :info
    event.delete(:level)

    data = event.clone
    # delete things from the 'data' portion that's not really data.
    data.delete(:message)
    data.delete(:timestamp)
    message = "#{event[:message]} #{data.to_json}"

    #p [@logger.level, logger.class::DEBUG]
    # This will call @logger.info(data) or something similar.
    @logger.send(method, message)
  end # def <<
end # class Cabin::Outputs::StdlibLogger
