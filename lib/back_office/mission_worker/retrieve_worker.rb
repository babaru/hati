module BackOffice
  module MissionWorker
    class RetrieveWorker < ::BackOffice::MissionWorker::Base
      @queue = :retrieve_data
    end
  end
end
