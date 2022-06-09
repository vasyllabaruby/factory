class Factory
  def self.new(*args, &block)
    Class.new do
      attr_accessor(*args)

      define_method :initialize do |*attr|
        attr.each_with_index do |attr, index|
          instance_variable_set("@#{args[index]}", attr)
        end
      end

      class_eval(&block) if block_given?
    end
  end
end
