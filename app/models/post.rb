class Post < ApplicationRecord
	extend ActsAsTreeDiagram::ViewDiagram
	acts_as_tree order: 'title'
end
