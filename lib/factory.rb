class Factory

  def self.new(class_name, *args, &block)
    if class_name.is_a? String
      const_set(class_name, Struct.new(*args) { class_eval(&block) if block_given? })
    else
      Struct.new(*args.unshift(class_name)) { class_eval(&block) if block_given? }
    end
  end
end