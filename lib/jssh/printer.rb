class Printer
    attr_accessor :instant
    def initialize(executor)
        self.instant=true
        @executor=executor
    end
    def submit_jobs(hosts)
        @memo={}
        hosts.each{|j| @memo[j]=nil }
    end
    def print(host,content,is_end)
        if self.instant
            lambda{ @executor.puts ("="*20+host+"="*20).to_yellow; @memo[host]='' }.call unless @memo[host]
            @executor.puts content if content
            @memo.delete host if is_end
        else
            @memo[host]=("="*20+host+"="*20).to_yellow+"\n"  unless @memo[host]
            @memo[host] << content if content
            lambda{ @executor.puts @memo[host]; @memo.delete host }.call if is_end
        end
    end
    def finished?
        @memo.empty?
    end
end

class StdoutExecutor
    def puts(str)
        $stdout.puts str
    end
end
class FileExecutor
    def initialize(filename)
        @file=File.open(filename,'a')
    end
    def puts(str)
        @file.puts str
    end
end
class NullExecutor
    def puts(str)
        #Do nothing
    end
end

