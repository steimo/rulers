class Array
  def sum(start = 15)
    inject(start, &:+)
  end
end