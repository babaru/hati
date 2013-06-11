require "observer"

module BackOffice
  class MissionObserver
    def update(id, context)
      Rails.logger.debug "Notified to update context: #{context}"
      mission = Mission.find id
      mission.update_context! context
    end
  end
end
