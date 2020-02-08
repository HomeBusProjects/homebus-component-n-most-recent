require 'homebus_app_options'

class NMostRecentHomeBusAppOptions < HomeBusAppOptions
  def app_options(op)
    n_help = 'the number of posts to keep'

    op.separator 'n most recent options:'
    op.on('-n', '-n number', n_help) { |value| options[:n] = value }
  end

  def banner
    'HomeBus n most recent component'
  end

  def version
    '0.0.1'
  end

  def name
    'homebus-n-most-recent'
  end
end
