#
# written by Jakob Holderbaum
#
require 'rubygems'
require 'RedCloth'

require 'bin/config'
def chblock(blockname) # {{{
    if !blockname
        puts "usage: chblock blockname"
    elsif !(blockname =~ /^\w+$/)
        puts ':::: blockname must be alphanumeric'
    elsif !File.exist? File.join($BLOCK_PATH,blockname+$BLOCK_POSTFIX)
        puts ':::: you cannot edit an nonexistent block! D\'oh'
    else
        puts ":: opening editor"
        blkfile = File.join($BLOCK_PATH,blockname+$BLOCK_POSTFIX)
        syscall = $EDITOR+' '+blkfile
        puts syscall
        if system syscall
            if File.exists? blkfile # TODO: check with MOAR safety - cheksum eg
                puts ':: converting file'
                htmfile = File.open(File.join($BLOCK_PATH,blockname+$HTM_POSTFIX),'w')
                htmfile.puts RedCloth.new(IO.readlines(blkfile).join).to_html
            else
                puts ':::: file must be created'
            end
        else
            puts ':::: syscall failed! Giveup'
        end

    end
end # }}}

def mkblock(blockname) # {{{
    if !blockname
        puts "usage: mkblock name"
    elsif !(blockname =~ /^\w+$/)
        puts ':::: blockname must be alphanumeric'
    elsif File.exist? File.join($BLOCK_PATH,blockname+$BLOCK_POSTFIX)
        puts ':::: this block allready exists. You can edit it via \'bin/cms chblock '+blockname+'\''
    else
        FileUtils.touch File.join($BLOCK_PATH,blockname+$BLOCK_POSTFIX)

        chblock blockname
    end
end # }}}

def rmblock(blockname) # {{{
    if !blockname
        puts "usage: rmblock blockname"
    elsif !(blockname =~ /^\w+$/)
        puts ':::: blockname must be alphanumeric'
    elsif !(File.exist? File.join($BLOCK_PATH,blockname+$BLOCK_POSTFIX)) || !(File.exist? File.join($BLOCK_PATH,blockname+$HTM_POSTFIX))
        puts ':::: such a block doesnt exist'
    else
            File.delete File.join($BLOCK_PATH,blockname+$BLOCK_POSTFIX)
            File.delete File.join($BLOCK_PATH,blockname+$HTM_POSTFIX)
    end
end # }}}

def lsblock(pagename) # {{{
    if !pagename
        blocks = Dir.new($BLOCK_PATH).entries.select{|d| d =~ /.*\.html$/ }
        blocks.each do |b|
            puts b[0..-6]
        end
    elsif !(pagename =~ /^\w+$/)
        puts ':::: pagename must be alphanumeric'
    elsif !File.exist? File.join($PAGE_PATH,pagename+$HTM_POSTFIX)
        puts ':::: no man, there is no page with such a name'
    else
        blocks = IO.readlines File.join($PAGE_PATH,pagename+$PAGE_BLOCK_POSTFIX)
        blocks.each do |b|
            puts b
        end
    end
end # }}}

