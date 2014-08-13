class IOS < Oxidized::Model

  prompt /^([\w.@()-]+[#>]\s?)$/
  comment  '! '

  # example how to handle pager
  #expect /^\s--More--\s+.*$/ do |data, re|
  #  send ' '
  #  data.sub re, ''
  #end

  # non-preferred way to handle additional PW prompt
  #expect /^[\w.]+>$/ do |data|
  #  send "enable\n"
  #  send vars(:enable) + "\n"
  #  data
  #end

  cmd :all do |cfg|
    #cfg.gsub! /\cH+\s{8}/, ''         # example how to handle pager
    #cfg.gsub! /\cH+/, ''              # example how to handle pager
    cfg.each_line.to_a[1..-2].join
  end

  cmd :secret do |cfg|
    cfg.gsub! /^(snmp-server community).*/, '\\1 <configuration removed>'
    cfg.gsub! /username (\S+) privilege (\d+) (\S+).*/, '<secret hidden>'
    cfg
  end

  cmd 'show running-config' do |cfg|
    cfg.type = 'diff'
    cfg
  end

  cmd 'show version' do |state|
    state.type = 'nodiff'
    state
  end

  cmd 'show inventory' do |state|
    state.type = 'nodiff'
    state
  end

  cmd 'show running-config' do |state|
    state = state.each_line.to_a[3..-1].join
    state.gsub! /^Current configuration : [^\n]*\n/, ''
    state.sub! /^(ntp clock-period).*/, '! \1'
    state.gsub! /^\ tunnel\ mpls\ traffic-eng\ bandwidth[^\n]*\n*(
                  (?:\ [^\n]*\n*)*
                  tunnel\ mpls\ traffic-eng\ auto-bw)/mx, '\1'
    state = Oxidized::String.new state
    state.type = 'nodiff'
    state
  end

  cmd 'show ip bgp sum' do |state|
    state.type = 'nodiff'
    state
  end

  cmd 'show cdp neigh' do |state|
    state.type = 'nodiff'
    state
  end

  cfg :telnet do
    username /^Username:/
    password /^Password:/
  end

  cfg :telnet, :ssh do
    post_login 'terminal length 0'
    post_login 'terminal width 0'
    # preferred way to handle additional passwords
    if vars :enable
      post_login do
        send "enable\n"
        send vars(:enable) + "\n"
      end
    end
    pre_logout 'exit'
  end

end
