# Class that keeps track of the collection of tests to be run. Contains methods to browse test files and load test class files, 

require_relative 'Testbase.rb'

class Collector

    #collect executable files
    def collect_file_list(path_list)
        file_list=[]
        for path in path_list
            file_list = file_list + Dir[path].select { |f| File.extname(f)=='.rb'}
        end
        return file_list   
    end

    #collect executable classes
    def load_file(file)
        existing_classes = ObjectSpace.each_object(Class).to_a
        begin
            require_relative file
            known_objects=[Testbase::Test, Testbase]
            new_classes = ObjectSpace.each_object(Class).to_a - existing_classes
        rescue Exception => e
            puts "Error: #{e}, while collecting test classes for file #{file}, hence skipping."
            return []
        end
        classes_found=new_classes-known_objects
        return classes_found
    end

    #collect_executable_test_classes
    def collect_tests(class_collection)
        test_collection=Hash.new
        test_classes=[]
        for i in class_collection
            if i.ancestors.include?Testbase and i != Testbase
                test_classes.push(i)
                #Find test classes in each test class
                test_cases=[]
                for j in class_collection
                    if j.ancestors.include?Testbase::Test and j.to_s.include?i.to_s and i != Testbase::Test
                        test_cases.push(j)
                    end
                end
            test_collection[i]=test_cases
            end
        end
        return test_collection
    end

    #collect all tests
    def collect(path_list)
        files_list=collect_file_list(path_list)
        if files_list.empty?
            raise "No ruby files found for execution, please re-check the file path specified"
            return
        end

        class_collection=[]
        for file in files_list
            classes_found = load_file(file)
            next if classes_found.empty?
            class_collection = class_collection + classes_found
        end

        test_collection=collect_tests(class_collection)
        if test_collection.empty?
            raise "No executable test classes found, please check the test classes in path specified "
        end

        return test_collection
    end

end

