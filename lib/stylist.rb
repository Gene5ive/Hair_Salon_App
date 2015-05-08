class Stylist

  attr_reader(:name, :id, :client_id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    resturned_stylists = DB.exec("SELECT * FROM stylists;")
    stylists = []
    resturned_stylists.each do |stylist|
      name = stylist.fetch("name")
      id = stylist.fetch("id").to_i
      stylists.push(Stylist.new({:name => name, :id => id}))
    end
    stylists
  end

  define_singleton_method(:find) do |id|
    @id = id
    result = DB.exec("SELECT * FROM stylists WHERE id = #{@id}")
    @name = result.first.fetch("name")
    Stylist.new({:name => @name, :id => @id})
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO stylists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  define_method(:==) do |another_stylist|
    self.name == another_stylist.name && self.id == another_stylist.id
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    @id = self.id
    DB.exec("UPDATE stylists SET name = '#{@name}' WHERE id = #{@id};")

    # attributes.fetch(:client_ids, []).each do |client_id|
    #   DB.exec("INSERT INTO stylists (client_id) VALUES (#{{client_id}});")
    # end
  end

  define_method(:delete) do
    DB.exec("DELETE FROM stylists WHERE id = #{self.id};")
  end
end
