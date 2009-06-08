#
# written by Jakob Holderbaum
#
require 'bin/config'


# helpers
def createhtml(update,pagename,pagetitle,blocks) # {{{
    htmfile = File.open(File.join($PAGE_PATH,pagename+$HTM_POSTFIX),File::WRONLY|File::TRUNC|File::CREAT)
    blockfile = File.open(File.join($PAGE_PATH,pagename+$PAGE_BLOCK_POSTFIX),File::WRONLY|File::TRUNC|File::CREAT)
        
    titlefile = File.open(File.join($PAGE_PATH,pagename+$PAGE_TITLE_POSTFIX),File::WRONLY|File::TRUNC|File::CREAT)
    titlefile.puts pagetitle


    pages = IO.readlines $PAGE_ORDER_PATH
    if !update
        pages += [pagename]
    end
    nav = '<ul id="'+$NAV_ID+'">'
    pages.each { |p| 
        p.strip!
        title = IO.readlines File.join($PAGE_PATH,p+$PAGE_TITLE_POSTFIX)
        p += $HTM_POSTFIX
        if p==pagename+$HTM_POSTFIX
            nav += '<li class="'+$NAV_ELEM_SELECTED+'">'+pagetitle+'</li>'
        else 
            nav += '<li class="'+$NAV_ELEM_UNSELECTED+'"><a href="'+p+'">'+title[0]+'</a></li>'
        end
    }
    nav += '</ul>'

    head = IO.readlines(File.join($TPL_PATH,'head.html'))

    head.each do |line|
        htmfile.puts line.gsub($PHOLDER_NAV,nav)
    end

    blocks.each do |block|
        htmfile.puts "<!-- #{block} -- begin -->"
        FileUtils.copy_stream(File.open(File.join($BLOCK_PATH,block+$HTM_POSTFIX)),htmfile)
        htmfile.puts "<!-- #{block} -- end -->"
        blockfile.puts block
    end
#    FileUtils.copy_stream(File.open(File.join($TPL_PATH,'foot.html')),htmfile)
    foot = IO.readlines(File.join($TPL_PATH,'foot.html'))

    foot.each do |line|
        htmfile.puts line
    end 
end # }}}



def mkpage(pagename,pagetitle,blocks) # {{{
    if !pagename || !pagetitle || !blocks   # this arith works, but it's bloated -- too lazy to think about :)
        puts 'usage: mkpage pagename pagetitle [list of blocks]'
        puts '  at least one block'
    elsif !(pagename =~ /^\w+$/)
        puts ':::: pagename must be alphanumeric'
    elsif File.exist? File.join($PAGE_PATH,pagename+$HTM_POSTFIX)
        puts ':::: another page was named the same'
    elsif blocks.length == 0
        puts ':::: page must contain at least one block'
    else
        blocks.each do |b|
            if !File.exist? File.join($BLOCK_PATH,b+$HTM_POSTFIX)
                puts ':::: there is no block named '+b
                return
            end
        end

        orderfile = File.open($PAGE_ORDER_PATH,File::WRONLY|File::APPEND|File::CREAT)
        orderfile.puts pagename

        createhtml(false,pagename,pagetitle,blocks)

    end
end # }}}

def rmpage(pagename) # {{{
    if !pagename
        puts 'usage: rmpage pagename'
    elsif !(pagename =~ /^\w+$/)
        puts ':::: pagename must be alphanumeric'
    elsif !File.exist? File.join($PAGE_PATH,pagename+$HTM_POSTFIX)
        puts ':::: there is no page named this way'
    else
        File.delete File.join($PAGE_PATH,pagename+$HTM_POSTFIX)
        File.delete File.join($PAGE_PATH,pagename+$PAGE_BLOCK_POSTFIX)
        File.delete File.join($PAGE_PATH,pagename+$PAGE_TITLE_POSTFIX)
        if File.symlink? File.join($WEB_PATH,pagename+$HTM_POSTFIX)
            File.delete File.join($WEB_PATH,pagename+$HTM_POSTFIX)
        end

        pages = IO.readlines $PAGE_ORDER_PATH
        pages.each {|p| p.strip!}

        pages -= [pagename]

        orderfile = File.open(File.join($PAGE_ORDER_PATH),File::WRONLY|File::TRUNC|File::CREAT)
        pages.each{|p| orderfile.puts p }
    end
end # }}}

def uppage(pagename) # {{{
    if !pagename
        puts 'usage: uppage pagename'
    elsif !(pagename =~ /^\w+$/)
        puts ':::: pagename must be alphanumeric'
    elsif !File.exist? File.join($PAGE_PATH,pagename+$HTM_POSTFIX)
        puts ':::: there is no page named this way'
    else
        blocks = IO.readlines File.join($PAGE_PATH,pagename+$PAGE_BLOCK_POSTFIX)
        blocks.each {|b| b.strip!}

        title = IO.readlines File.join($PAGE_PATH,pagename+$PAGE_TITLE_POSTFIX)


        createhtml(true,pagename,title[0],blocks)
        
    end
end # }}}

def lspage(pagename) # {{{
    if !pagename
        pages = IO.readlines $PAGE_ORDER_PATH
        pages.each {|p| puts p }
    elsif !(pagename =~ /^\w+$/)
        puts ':::: pagename must be alphanumeric'
    elsif !File.exist? File.join($PAGE_PATH,pagename+$HTM_POSTFIX)
        puts ':::: there is no page named this way'
    else
        title = IO.readlines File.join($PAGE_PATH,pagename+$PAGE_TITLE_POSTFIX)

        puts [pagename,', title: "',title.join.strip,'", blocks: '].join
        lsblock pagename
    end

    
end # }}}

def mvpage(pagename,pos) # {{{
    pages = IO.readlines $PAGE_ORDER_PATH
    i=-1
    pages.each_index do |x|
        if pages[x].strip==pagename
            i=x
        end
    end

    if i>-1
        if pos == 'up'
            if i != 0
                puts ':: moving up'
                pages[i],pages[i-1] = pages[i-1],pages[i]
            end
        elsif pos == 'down'
            if i < pages.length-1
                puts ':: moving down'
                pages[i],pages[i+1] = pages[i+1],pages[i]
            end
        elsif pos.to_i >= 0 && pos.to_i < pages.length
            puts ':: swap page '+i.to_s+' with page '+pos 
            pages[i.to_i],pages[pos.to_i] = pages[pos.to_i],pages[i.to_i]
        else
            puts ':::: position is invalid'
            return
        end
        orderfile = File.open($PAGE_ORDER_PATH,File::WRONLY|File::TRUNC|File::CREAT)
        pages.each {|p| orderfile.puts p }
    else
        puts ':: pagename not found'
    end
    
end # }}}

