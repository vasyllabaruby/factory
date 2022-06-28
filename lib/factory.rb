# * Here you must define your `Factory` class.
# * Each instance of Factory could be stored into variable. The name of this variable is the name of created Class
# * Arguments of creatable Factory instance are fields/attributes of created class
# * The ability to add some methods to this class must be provided while creating a Factory
# * We must have an ability to get/set the value of attribute like [0], ['attribute_name'], [:attribute_name]
#
# * Instance of creatable Factory class should correctly respond to main methods of Struct
# - each
# - each_pair
# - dig
# - size/length
# - members
# - select
# - to_a
# - values_at
# - ==, eql?

class Factory
  def self.new(class_name, *args, &block)
    if class_name.is_a? String
      my_class = create_new_class(*args, &block)
      const_set(class_name, my_class)
    else
      create_new_class(class_name, *args, &block)
    end
  end

  def self.create_new_class(*args, &block)
    Class.new do
      attr_accessor(*args)

      define_method :initialize do |*attr|
        raise ArgumentError if args.size < attr.size

        attr.length.times do |index|
          instance_variable_set("@#{args[index]}", attr[index])
        end
      end

      define_method :vars do
        args
      end

      def ==(other)
        vars.each { |arg| return false if public_send(arg) != other.public_send(arg) }
        true
      end

      def [](var)
        if var.is_a?(Integer)
          instance_variable_get(instance_variables[var])
        else
          instance_variable_get("@#{var}")
        end
      end

      def []=(key, value)
        instance_variable_set("@#{key}", value)
      end

      def dig(*args)
        to_h.dig(*args)
      end

      def to_h
        members.map { |member| [member, self[member]] }.to_h
      end

      def each(&block)
        to_a.each(&block)
      end

      def each_pair(&block)
        hash = Hash.new { |h, k| h[k] = '' }
        arr = to_a
        arr.length.times do |index|
          hash[vars[index]] << arr[index].to_s
        end
        hash.each_pair(&block)
      end

      def length
        members.length
      end

      def size
        members.size
      end

      def members
        vars
      end

      def select(&block)
        to_a.select(&block)
      end

      def to_a
        members.map { |member| instance_variable_get("@#{member}") }
      end

      def values_at(*arg)
        result = []
        arr = to_a
        arr.length.times { |index| result.push(arr[index]) if arg.include?(index) }
        result
      end

      class_eval(&block) if block_given?
    end
  end
end
