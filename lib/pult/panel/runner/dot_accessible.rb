module Pult::Panel::Runner::DotAccessible

  def method_missing meth, *args
    self[meth]
  end
end
