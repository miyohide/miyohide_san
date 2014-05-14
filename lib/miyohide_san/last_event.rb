class MiyohideSan::LastEvent
  include Comparable
  CACHE_DIR = File.expand_path('../../../tmp', __FILE__)

  def <=>(new_event)
    result = nil

    cache.fetch('event') { new_event }.tap do |event|
      result = (event.id <=> new_event.id)
    end

    if result.try(:<, 0)
      cache.write('event', new_event)
    end

    result
  end

  private
  def cache
    ActiveSupport::Cache::FileStore.new(CACHE_DIR)
  end
end
