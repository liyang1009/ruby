require 'test/unit'
require 'weakref'
require_relative './ruby/envutil'

module TestWeakRef
  class Delegation < Test::Unit::TestCase
    include TestWeakRef

    NEW_WEAKREF = 'WeakRef.new'
    def new_weakref(obj)
      EnvUtil.suppress_warning do
        WeakRef.new(obj)
      end
    end

    def get(w)
      w
    end

    def assert_no_ref(&block)
      assert_raise(WeakRef::RefError, &block)
    end
  end

  class NonDelegation < Test::Unit::TestCase
    include TestWeakRef

    NEW_WEAKREF = 'WeakRef.[]'
    def new_weakref(obj)
      WeakRef[obj]
    end

    def get(w)
      w.get
    end

    def assert_no_ref(&block)
      assert_nil(yield)
    end
  end

  def make_weakref(level = 10)
    obj = Object.new
    str = obj.to_s
    level.times {obj = new_weakref(obj)}
    return new_weakref(obj), str
  end

  def test_ref
    weak, str = make_weakref
    assert_equal(str, get(weak).to_s)
  end

  def test_recycled
    weak, str = make_weakref
    assert_nothing_raised(WeakRef::RefError) {weak.to_s}
    assert_predicate(weak, :weakref_alive?)
    ObjectSpace.garbage_collect
    ObjectSpace.garbage_collect
    assert_no_ref {o = get(weak) and o.to_s}
    assert_not_predicate(weak, :weakref_alive?)
  end

  def test_not_reference_different_object
    bug7304 = '[ruby-core:49044]'
    weakrefs = []
    3.times do
      obj = Object.new
      def obj.foo; end
      weakrefs << new_weakref(obj)
      ObjectSpace.garbage_collect
    end
    assert_nothing_raised(NoMethodError, bug7304) {
      weakrefs.each do |weak|
        begin
          o = get(weak) and o.foo
        rescue WeakRef::RefError
        end
      end
    }
  end

  def test_weakref_finalize
    bug7304 = '[ruby-core:49044]'
    assert_normal_exit %Q{
      require 'weakref'
      obj = Object.new
      3.times do
        #{self.class::NEW_WEAKREF}(obj)
        ObjectSpace.garbage_collect
      end
    }, bug7304
  end
end
