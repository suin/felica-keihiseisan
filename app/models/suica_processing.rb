class SuicaProcessing < ActiveRecord::Base
  class << self
    def issue_new?(code)
      code == 7
    end

    def charge?(code)
      [2, 20, 21].include?(code)
    end
  end
end
