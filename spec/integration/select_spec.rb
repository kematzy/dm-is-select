require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

if HAS_SQLITE3 || HAS_MYSQL || HAS_POSTGRES
  describe 'DataMapper::Is::Select' do
    
    class Category
      include DataMapper::Resource
      property :id, Serial
      property :name, String
      
      is :select, :name
      
      auto_migrate!
    end #/ Category
    
    class TreeCategory
      include DataMapper::Resource
      property :id, Serial
      property :name, String
      
      is :tree, :order => :name
      is :select, :name, :is_tree => true 
      
      auto_migrate!
    end #/ TreeCategory
    
    
    5.times do |n| 
      Category.create(:name => "Category #{n+1}")
    end
    
    2.times do |parent_id|
      parent_id += 1
      parent = TreeCategory.create(:name => "TreeCategory-#{parent_id}" , :parent_id => 0 )
      child = TreeCategory.create(:name => "TreeCategory-#{parent_id}-Child" , :parent_id => parent.id )
      grandchild = TreeCategory.create(:name => "TreeCategory-#{parent_id}-Child-GrandChild" , :parent_id => child.id )
    end
    
    
    describe "Class Methods" do 
      
      describe "is :select" do 
        
        it "should work with both strings & symbols as the fieldname provided" do 
          lambda { 
            class Dummy
            include DataMapper::Resource
            property :id, Serial
            property :name, String
            
            is :select, 'name'
            auto_migrate!
          end 
          
          }.should_not raise_error(ArgumentError)
        end
        
        it "should raise an ArgumentError if non-existant field is provided" do 
          lambda { 
            class Dummy
            include DataMapper::Resource
            property :id, Serial
            property :name, String
            
            is :select, :does_not_exist
            auto_migrate!
          end 
          
          }.should raise_error(ArgumentError)
        end
        
      end #/ is :select
      
      describe "#items_for_select_menu" do 
        
        describe "Normal Model" do 
          
          it "should return the default select options when given no params" do 
            Category.items_for_select_menu.should == [ 
              ["Select Category", nil], 
              ["  ------  ", "nil"], 
              ["Category 1", 1], 
              ["Category 2", 2], 
              ["Category 3", 3], 
              ["Category 4", 4], 
              ["Category 5", 5]
            ]
          end
          
          it "should return the select options with custom prompt when given the  :prompt => ? " do 
            Category.items_for_select_menu(:prompt => "Custom Prompt " ).should == [ 
              ["Custom Prompt ", nil], 
              ["  ------  ", "nil"], 
              ["Category 1", 1], 
              ["Category 2", 2], 
              ["Category 3", 3], 
              ["Category 4", 4], 
              ["Category 5", 5]
            ]
          end
          
          it "should return the select options without a prompt & divider when given :prompt => false" do 
            Category.items_for_select_menu(:prompt => false ).should == [ 
              ["Category 1", 1], 
              ["Category 2", 2], 
              ["Category 3", 3], 
              ["Category 4", 4], 
              ["Category 5", 5]
            ]
          end
          
          it "should return the select options without a prompt & divider when given :prompt => true" do 
            #  TODO:: this should be reworked, but right now it's good enough 
            Category.items_for_select_menu(:prompt => true ).should == [ 
              [true, nil],
              ["  ------  ", "nil"],
              ["Category 1", 1], 
              ["Category 2", 2], 
              ["Category 3", 3], 
              ["Category 4", 4], 
              ["Category 5", 5]
            ]
          end
          
          it "should return the select options without the divider when given :divider => false" do 
            Category.items_for_select_menu(:divider => false ).should == [ 
              ["Select Category", nil], 
              ["Category 1", 1], 
              ["Category 2", 2], 
              ["Category 3", 3], 
              ["Category 4", 4], 
              ["Category 5", 5]
            ]
          end
          
          it "should return the select options with reversed order when given :order => DESC" do 
            Category.items_for_select_menu(:order => [ :id.desc ] ).should == [ 
              ["Select Category", nil], 
              ["  ------  ", "nil"], 
              ["Category 5", 5],
              ["Category 4", 4], 
              ["Category 3", 3], 
              ["Category 2", 2], 
              ["Category 1", 1] 
            ]
          end
          
        end #/ Normal Model
        
        describe "Tree Model" do 
          
          it "should return the default select options when given no params" do 
            TreeCategory.items_for_select_menu.should == [
              ["Select Treecategory", nil], 
              ["  ------  ", "nil"], 
              ["TreeCategory-1", 1], 
              ["-- TreeCategory-1-Child", 2], 
              ["-- -- TreeCategory-1-Child-GrandChild", 3],
              ["TreeCategory-2", 4], 
              ["-- TreeCategory-2-Child", 5], 
              ["-- -- TreeCategory-2-Child-GrandChild", 6]
            ]
          end
          
          it "should return the select options with reversed order when given :order => DESC" do 
            TreeCategory.items_for_select_menu(:order => [ :id.desc ] ).should == [
              ["Select Treecategory", nil], 
              ["  ------  ", "nil"], 
              ["TreeCategory-2", 4], 
              ["-- TreeCategory-2-Child", 5], 
              ["-- -- TreeCategory-2-Child-GrandChild", 6], 
              ["TreeCategory-1", 1], 
              ["-- TreeCategory-1-Child", 2], 
              ["-- -- TreeCategory-1-Child-GrandChild", 3]
            ]
          end
          
        end #/ Tree Model
        
      end #/ #item_for_select_menu
      
    end #/ Class Methods
    
    # describe "Instance Methods" do 
    #   
    # end #/ Instance Methods
    
  end #/ DataMapper::Is::Select
  
end #/ if
