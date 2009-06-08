#
# written by Jakob Holderbaum
#
require 'bin/page'


def build
    Dir.new($PAGE_PATH).each do |file|
        unless ['.', '..'].include? file
            if file =~ /.*\.html$/
                if File.symlink? File.join($WEB_PATH,file)
                    File.delete File.join($WEB_PATH,file)
                end
                File.symlink(File.join('..',$PAGE_PATH,file),File.join($WEB_PATH,file))
            end
        end
    end
end

