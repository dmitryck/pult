module Pult::Panel::DotAccessible

  def method_missing meth, *args
    self[meth]
  end
end
