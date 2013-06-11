require "observer"

module BackOffice
  module MissionWorker
    class Base
      include Observable

      def initialize
        add_observer MissionObserver.new
      end

      def self.perform(id)
        obj = eval(self.name).new
        obj.perform id
      end

      def perform(id)
        mission = ::Mission.find id
        context = mission.context
        begin
          mission.perform!

          # do some real stuff
          do_perform mission

          mission.complete!
        rescue => e
          context = context.merge error: e.to_s
          mission.fail! context
          raise e
        end
      end

      def do_perform(mission)
      end

      def notify(id, context)
        changed
        notify_observers id, context
      end
    end
  end
end
