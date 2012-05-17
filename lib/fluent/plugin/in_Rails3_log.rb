class Rails3LogInput < Fluent::TailInput
  Fluent::Plugin.register_input('Rails3_log', self)
  IP_ADDRESS_REGEX = %r!\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}!
  def configure_parser(conf)
    @_time = Time.now.to_i
    @_record = {}
  end
  
  def parse_line(line)
    if line.start_with?("Started")
      reg =  %r!^Started (?<method>[A-Z]+) "(?<path>.+)" for (?<ip_address>#{IP_ADDRESS_REGEX}) at (?<access_time>.+)$!
      data = line.match reg
      %w(method path ip_address access_time).each {|item| @_record[item] = data[item] }
      @_time = Time.parse(@_record['access_time']).to_i
    elsif line.start_with?("Processing")
      reg = %r!^Processing by (?<controller>.+)#(?<action>.+) as (?<mime>.+)$!
      data = line.match reg
      %w(controller action mime).each {|item| @_record[item] = data[item] }
    elsif line.start_with?("Completed")
      reg = %r!^Completed (?<status_code>\d+) (?<status_msg>.+) in (?<proc_time>\d+)ms \(Views: (?<views_time>\d+\.\d+)ms \| ActiveRecord: (?<ar_time>\d+\.\d+)ms \| Sphinx: (?<sphinx_time>\d+\.\d+)ms\)$!
      data = line.match reg
      %w(status_code status_msg proc_time views_time ar_time sphinx_time).each {|item| @_record[item] = data[item] }
      n_record = @_record.clone
      @_record = {}
      return @_time, n_record
    end
    return nil, nil
  end
end
