# coding: utf-8
require 'homebus'
require 'homebus_app'
require 'mqtt'
require 'dotenv'
require 'json'

class NMostRecentHomeBusApp < HomeBusApp
  def initialize(options)
    @options = options
    super

    Dotenv.load('.env')
    @source_uuid = ENV['SOURCE_UUID']
    @n = ENV['N'].to_i
    @subscribed = false

    @msgs = []
  end

  def setup!
  end

  def work!
    unless @subscribed
      subscribe_to_devices! @source_uuid
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
      puts msg
    end

    @msgs.push msg
    _prune_msgs

    if options[:verbose]
      pp @msgs
    end

    publish! JSON.generate @msgs
  end

  def manufacturer
    'HomeBus'
  end

  def model
    'Aggregate Component v1'
  end

  def friendly_name
    'Aggregate Component'
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
      { friendly_name: 'Aggregate Component',
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
