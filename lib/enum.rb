class Enum
 
  attr_reader :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end

  def self.get_hash
    @hash
  end

  def self.add_item(key,value)
    @hash ||= {}
    @hash[key]=value
  end

  def self.const_missing(key)
    self.new(key,@hash[key]) unless @hash[key].nil?
  end

  def self.each
    @hash.each {|key,value| yield(key,value)}
  end

  def self.keys
    @hash.map {|n,v| n}
  end
  
  def self.values
    @hash.map {|n,v| v}
  end  

  def self.for_select
    @hash.map { |n,v| [v,n] }
  end

  def ==(other)
    return false if other.nil? || other.class != self.class
    other.name == self.name
  end

  def to_s
    "#{name}"
  end

  def to_sym
    name.to_sym
  end

  def self.[](key)
    return Enum.new("","") if key.blank?
    key = key.upcase.to_sym unless key.is_a?(Symbol)
    self.new(key,@hash[key]) unless @hash[key].nil?
  end

end