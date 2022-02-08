# so I can log requests during dev without fkin with a db
class JsonLogs
  def self.write(data)
    
    existing_data = JSON.parse File.read('db/log.json')

    File.open("db/log.json","w") do |f|
      f.puts JSON.pretty_generate(existing_data << data)
    end 
  end
end
