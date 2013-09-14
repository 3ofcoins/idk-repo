zone 'i.3ofcoins.net'

entry('@') do
  # R53 doesn't allow us to set CNAME, so we'll get an IP ourselves
  # instead of hardcoding it.
  require 'socket'
  [ :a, '144.76.136.145' ]      # falcor
end

entry 'ronja', 'ronja.3ofcoins.net.'
entry 'birk',  'birk.3ofcoins.net.'
entry 'hamish', '80.74.134.120'
entry 'adhoc', 'ronja'

entry 'chef', 'falcor'
entry 'headquarters', 'falcor'
entry 'hq', 'falcor'
entry 'jenkins', 'falcor'
