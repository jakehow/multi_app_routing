class Hash
  def prepare_for_eval
    "{#{map {|k,v| ":#{k} => '#{v}'"}.join(', ')}}"
  end
end