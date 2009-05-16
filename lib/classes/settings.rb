class Settings
  def self.load
    xml = File.read('settings.xml')
    file = REXML::Document.new(xml)
    posts = []
    file.elements.each('settings/setting') do |p|
      name = p.elements.entries.values_at(0)[0].text # <name> ... </name>
      value = p.elements.entries.values_at(1)[0].text # <value> ... </value>
      self.class.send(:define_method, name) { puts value }
    end
    self.CONSTANT7 
  end
  def self.reload
    initialize
  end
end
