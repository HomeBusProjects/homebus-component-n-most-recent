# coding: utf-8
require 'homebus'
require 'homebus_app'
require 'mqtt'
require 'dotenv'
require 'json'

class NMostRecentHomeBusApp < HomeBusApp
  DDC = 'org.homebus.experimental.component.queue'
  STATE_FILENAME = '.saved-state.json'

  def initialize(options)
    @options = options
    super

    Dotenv.load('.env')
    @source_uuid = ENV['SOURCE_UUID']
    @source_ddc = ENV['SOURCE_DDC']
    @n = ENV['N'].to_i
    @subscribed = false

    @msgs = []

    _restore_state
  end

  def setup!
  end

  def work!
    unless @subscribed
      subscribe_to_source_ddc! @source_uuid, @source_ddc
    end

    listen!
  end

  def _prune_msgs
    if @msgs.length > @n
      @msgs.shift
    end
  end

  def receive!(msg)
    if options[:verbose]
      puts 'received', msg
    end

    @msgs.push({ ddc: msg[:ddc], payload: msg[:payload] })
    _prune_msgs

    if options[:verbose]
      puts 'about to save'
    end

    _save_state

    payload = {
     max_length: @n,
     source: @source_uuid,
     ddc: msg[:ddc],
     queue: @msgs
    }

    if options[:verbose]
      pp payload
    end

    publish! DDC, payload

    if options[:verbose]
      puts 'published!'
    end
  end

  def _restore_state
    if File.exists? STATE_FILENAME
      @msgs = JSON.parse File.read(STATE_FILENAME), symbolize_names: true
    end
  end

  def _save_state
    File.open(STATE_FILENAME, 'w') { |f| f.write(JSON.pretty_generate(@msgs)) }
  end

  def manufacturer
    'HomeBus'
  end

  def model
    'Queue Component v1'
  end

  def friendly_name
    'Queue Component'
  end

  def friendly_location
    'Portland, OR'
  end

  def serial_number
    "#{@source_uuid}-#{@n}"
  end

  def pin
    ''
  end

  def devices
    [
      { friendly_name: 'Queue Component',
        friendly_location: '',
        update_frequency: 0,
        index: 0,
        accuracy: 0,
        precision: 0,
        wo_topics: [ '#' ],
        ro_topics: [],
        rw_topics: []
      }
    ]
  end
end
