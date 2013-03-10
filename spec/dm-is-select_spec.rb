require_relative './spec_helper'

if HAS_SQLITE3 || HAS_MYSQL || HAS_POSTGRES
  
  describe 'DataMapper::Is::Select' do
    
    before(:each) do 
      
      class Category
        include DataMapper::Resource
        property :id, Serial
        property :name, String
        property :publish_status, String, :default => "on"
        
        is :select, :name
      end 
      
      class TreeCategory
        include DataMapper::Resource
        property :id, Serial
        property :name, String
        property :publish_status, String, :default => "on"
        # property :parent_id, Integer
        
        is :tree, :order => :name
        is :select, :name, :is_tree => true 
      end
      
      class Country
        include DataMapper::Resource
        property :code,     String, :key => true
        property :name,    String
        is :select, :name, :value_field => :code
      end #/ Country
      
      DataMapper.finalize
      
      DataMapper.auto_migrate!
      
    end
    
    describe "VERSION" do 
      
      it "should have a VERSION constant" do 
        DataMapper::Is::Select::VERSION.should match(/\d\.\d+\.\d+/)
      end
      
    end #/ VERSION
    
    describe "Class Methods" do 
      
      describe "is :select" do 
        
        it "should work with both strings & symbols as the fieldname provided" do 
          lambda { 
            class Dummy
            include DataMapper::Resource
            property :id, Serial
            property :name, String
            
            is :select, 'name'
          end 
          
          DataMapper.auto_migrate!
          
          }.should_not raise_error(ArgumentError)
        end
        
        it "should raise an ArgumentError if non-existant field is provided" do 
          lambda { 
            class Dummy
              include DataMapper::Resource
              property :id, Serial
              property :name, String
              
              is :select, :does_not_exist
            end 
            
            DataMapper.auto_migrate!
          }.should raise_error(ArgumentError)
        end
        
      end #/ is :select
      
      describe "#items_for_select_menu" do 
        
        describe "A Normal Model" do 
          
          before(:each) do 
            5.times do |n| 
              Category.create(:name => "Category #{n+1}")
            end
          end
          
          it "should return the default select options when given no params" do 
            Category.items_for_select_menu.should == [ 
              [nil, "Select Category"], 
              ["nil", "  ------  "], 
              [1, "Category 1"], 
              [2, "Category 2"], 
              [3, "Category 3"], 
              [4, "Category 4"], 
              [5, "Category 5"]
            ]
          end
          
          it "should return the select options with custom prompt when given the  :prompt => ? " do 
            Category.items_for_select_menu(:prompt => "Custom Prompt " ).should == [ 
              [nil, "Custom Prompt "], 
              ["nil", "  ------  "], 
              [1, "Category 1"], 
              [2, "Category 2"], 
              [3, "Category 3"], 
              [4, "Category 4"], 
              [5, "Category 5"]
            ]
          end
          
          it "should return the select options without a prompt & divider when given :prompt => false" do 
            Category.items_for_select_menu(:prompt => false ).should == [ 
              [1, "Category 1"], 
              [2, "Category 2"], 
              [3, "Category 3"], 
              [4, "Category 4"], 
              [5, "Category 5"]
            ]
          end
          
          it "should return the select options without a prompt & divider when given :prompt => true" do 
            #  TODO:: this should be reworked, but right now it's good enough 
            Category.items_for_select_menu(:prompt => true ).should == [ 
              [nil, true],
              ["nil", "  ------  "],
              [1, "Category 1"], 
              [2, "Category 2"], 
              [3, "Category 3"], 
              [4, "Category 4"], 
              [5, "Category 5"]
            ]
          end
          
          it "should return the select options without the divider when given :divider => false" do 
            Category.items_for_select_menu(:divider => false ).should == [ 
              [nil, "Select Category"], 
              [1, "Category 1"], 
              [2, "Category 2"], 
              [3, "Category 3"], 
              [4, "Category 4"], 
              [5, "Category 5"]
            ]
          end
          
          it "should return the select options with reversed order when given :order => DESC" do 
            Category.items_for_select_menu(:order => [ :id.desc ] ).should == [ 
              [nil, "Select Category"], 
              ["nil", "  ------  "], 
              [5, "Category 5"],
              [4, "Category 4"], 
              [3, "Category 3"], 
              [2, "Category 2"], 
              [1, "Category 1"] 
            ]
          end
          
          it "should respect the SQL select options" do 
            c = Category.get(1)
            c.publish_status = 'off'
            c.save
            
            Category.items_for_select_menu(:publish_status => "on", :order => [ :id.desc ] ).should == [ 
              [nil, "Select Category"], 
              ["nil", "  ------  "], 
              [5, "Category 5"],
              [4, "Category 4"], 
              [3, "Category 3"], 
              [2, "Category 2"], 
              # [1, "Category 1"] 
            ]
          end
          
          it "should handle invalid SQL select options" do 
            Category.items_for_select_menu(:publish_status => "invalid", :order => [ :id.desc ] ).should == [ 
              [nil, "Select Category"], 
              ["nil", "  ------  "], 
              # [5, "Category 5"],
              # [4, "Category 4"], 
              # [3, "Category 3"], 
              # [2, "Category 2"], 
              # [1, "Category 1"] 
            ]
          end
          
        end #/ Normal Model
        
        describe "Tree Model" do 
          
          before(:each) do 
            2.times do |parent_id|
              parent_id += 1
              theparent = TreeCategory.create(:name => "TreeCategory-#{parent_id}") # sets parent_id => nil
              child = TreeCategory.create(:name => "TreeCategory-#{parent_id}-Child" , :parent => theparent )
              grandchild = TreeCategory.create(:name => "TreeCategory-#{parent_id}-Child-GrandChild" , :parent_id => child.id )
            end
            
          end
          
          it "should return the default select options when given no params" do 
            TreeCategory.items_for_select_menu.should == [
              [nil, "Select TreeCategory"], 
              ["nil", "  ------  "], 
              [0, "Top Level TreeCategory"],
              ["nil", "  ------  "], 
              [1, "TreeCategory-1"], 
              [2, "-- TreeCategory-1-Child"], 
              [3, "-- -- TreeCategory-1-Child-GrandChild"],
              [4, "TreeCategory-2"], 
              [5, "-- TreeCategory-2-Child"], 
              [6, "-- -- TreeCategory-2-Child-GrandChild"]
            ]
          end
          
          it "should return the select options with reversed order when given :order => DESC" do 
            TreeCategory.items_for_select_menu(:order => [ :id.desc ] ).should == [
              [nil, "Select TreeCategory"], 
              ["nil", "  ------  "], 
              [0, "Top Level TreeCategory"],
              ["nil", "  ------  "], 
              [4, "TreeCategory-2"], 
              [5, "-- TreeCategory-2-Child"], 
              [6, "-- -- TreeCategory-2-Child-GrandChild"], 
              [1, "TreeCategory-1"], 
              [2, "-- TreeCategory-1-Child"], 
              [3, "-- -- TreeCategory-1-Child-GrandChild"]
            ]
          end
          
          it "should return the select options without the Top Level Parent when given :show_root => false" do 
            TreeCategory.items_for_select_menu(:show_root => false).should == [
              [nil, "Select TreeCategory"], 
              ["nil", "  ------  "], 
              [1, "TreeCategory-1"], 
              [2, "-- TreeCategory-1-Child"], 
              [3, "-- -- TreeCategory-1-Child-GrandChild"],
              [4, "TreeCategory-2"], 
              [5, "-- TreeCategory-2-Child"], 
              [6, "-- -- TreeCategory-2-Child-GrandChild"]
            ]
          end
          
          it "should return the select options with custom text for the Top Level Parent when given :root_text => ?" do 
            TreeCategory.items_for_select_menu(:root_text => "Custom Top Level Text").should == [
              [nil, "Select TreeCategory"], 
              ["nil", "  ------  "], 
              [0, "Custom Top Level Text"],
              ["nil", "  ------  "], 
              [1, "TreeCategory-1"], 
              [2, "-- TreeCategory-1-Child"], 
              [3, "-- -- TreeCategory-1-Child-GrandChild"],
              [4, "TreeCategory-2"], 
              [5, "-- TreeCategory-2-Child"], 
              [6, "-- -- TreeCategory-2-Child-GrandChild"]
            ]
          end
          
          it "should respect the SQL select options" do 
            c = TreeCategory.get(1)
            c.publish_status = 'off'
            c.save
            
            TreeCategory.items_for_select_menu( :publish_status => "on", :order => [ :id.desc ] ).should == [
              [nil, "Select TreeCategory"], 
              ["nil", "  ------  "], 
              [0, "Top Level TreeCategory"],
              ["nil", "  ------  "], 
              [4, "TreeCategory-2"], 
              [5, "-- TreeCategory-2-Child"], 
              [6, "-- -- TreeCategory-2-Child-GrandChild"], 
              # [1, "TreeCategory-1"], 
              # [2, "-- TreeCategory-1-Child"], 
              # [3, "-- -- TreeCategory-1-Child-GrandChild"]
            ]
          end
          
          it "should handle invalid SQL select options" do 
            TreeCategory.items_for_select_menu( :publish_status => "invalid", :order => [ :id.desc ] ).should == [
              [nil, "Select TreeCategory"], 
              ["nil", "  ------  "], 
              [0, "Top Level TreeCategory"],
              ["nil", "  ------  "], 
              # [4, "TreeCategory-2"], 
              # [5, "-- TreeCategory-2-Child"], 
              # [6, "-- -- TreeCategory-2-Child-GrandChild"], 
              # [1, "TreeCategory-1"], 
              # [2, "-- TreeCategory-1-Child"], 
              # [3, "-- -- TreeCategory-1-Child-GrandChild"]
            ]
          end
          
        end #/ Tree Model
        
        describe "A value_field model" do 
          
          before(:each) do 
            3.times do |i|
              Country.create(:code => "A#{i}", :name => "Country#{i}")
            end
          end
          
          it "should return the default select options when given no params" do 
            Country.items_for_select_menu.should == [
              [nil, "Select Country"], 
              ["nil", "  ------  "], 
              ['A0', "Country0"], 
              ['A1', "Country1"], 
              ['A2', "Country2"], 
              # [4, "Country3"], 
              # [5, "Country4"]
            ]
          end
          
        end #/ A value_field model
        
      end #/ #item_for_select_menu
      
    end #/ Class Methods
    
    describe "Instance Methods" do 
      
      it "are not defined with this DataMapper plugin" do 
        1.should == 1
      end
      
      
    end #/ Instance Methods
    
  end #/ DataMapper::Is::Select
  
end #/ if