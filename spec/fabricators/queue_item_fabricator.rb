Fabricator(:queue_item) do
  order {rand(1..10)} 
end
