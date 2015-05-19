module Formatter
  module Error
    def self.call message, backtrace, options, env
      if message.is_a?(Hash)
  	    { :status => "NG", :result => { :code => message[:code],
                                        :type => message[:message],
                                        :detail => message[:detail] } }.to_json
      else
        { :status => "NG", :result => { :code => 4,
                                        :type => message,
                                        :detail => {} } }.to_json
      end
    end
  end
end
